import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/couple_channel_models.dart';
import 'message_notifier.dart';
import 'nostr_event_check.dart';
import 'nostr_keys.dart';
import 'secret_store.dart';
import '../l10n/t.dart';

class NostrService {
  static final NostrService _instance = NostrService._internal();
  factory NostrService() => _instance;
  NostrService._internal();

  static const String _keyPubKey = 'velvet_nostr_pubkey';
  static const String _keyPartnerPubKey = 'velvet_partner_pubkey';
  static const String _keyPartnerName = 'velvet_partner_name';
  static const String _keyCachedMessages = 'velvet_couple_messages_cache';
  static const String _keyMyFantasyVotes = 'velvet_my_fantasy_votes';
  static const String _keyPartnerFantasyVotes = 'velvet_partner_fantasy_votes';
  static const String _keyInviteName = 'velvet_invite_name';
  static const String _keyPartnerReflections = 'velvet_partner_reflections';
  static const String _keyPartnerGender = 'velvet_partner_gender';
  static const String _keyProfilePromptDismissed = 'velvet_partner_profile_prompt_dismissed';

  /// Zeitstempel (created_at) der neuesten verarbeiteten Nachricht des Partners. Beim Verbinden
  /// wird alles seitdem abgeholt, nicht nur die letzten paar Nachrichten.
  static const String _keyInboxSince = 'velvet_inbox_since';

  /// Spielraum für abweichende Uhren und Nachzügler beim Abholen.
  static const int _inboxOverlapSeconds = 600;

  // Lesebestätigungen: ein verschlüsselter NIP-78-Eintrag (Art 30078, „ersetzbar“ – die Server
  // behalten je Absender nur den neuesten). Ältere App-Versionen fragen diese Art gar nicht ab,
  // und der Hintergrund-Hinweis (nur Art 4) meldet sie nicht als neue Nachricht.
  static const int readReceiptKind = 30078;
  static const String _readReceiptTag = 'velvet-read';
  static const String _keyReadReceipts = 'velvet_read_receipts';
  static const String _keyPartnerReadUntil = 'velvet_partner_read_until';
  static const String _keyReadSentUntil = 'velvet_read_sent_until';

  static const List<String> fallbackRelays = [
    'wss://relay.primal.net',
    'wss://nos.lol',
    'wss://nostr.mom',
    'wss://relay.snort.social',
    'wss://relay.damus.io',
  ];

  static String get defaultRelayUrl => fallbackRelays[0];

  final KeyApi _keyApi = KeyApi();
  final EventApi _eventApi = EventApi();
  final Nip04 _nip04 = Nip04();
  final Nip19 _nip19 = Nip19();

  final Map<String, _RelayConnection> _relays = {};
  bool _disposed = false;

  String? _myPrivateKey;
  String? _myPublicKey;
  String? _myNpub;

  String? _partnerPublicKey;
  String? _partnerNpub;
  String _partnerName = 'Partner';

  final ValueNotifier<String> myPubKeyNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> myNpubNotifier = ValueNotifier<String>('');

  final ValueNotifier<NostrConnectionStatus> statusNotifier =
      ValueNotifier<NostrConnectionStatus>(NostrConnectionStatus.disconnected);

  final ValueNotifier<String> activeRelayNotifier = ValueNotifier<String>('');

  final ValueNotifier<String?> partnerPubKeyNotifier =
      ValueNotifier<String?>(null);

  final ValueNotifier<String> partnerNameNotifier =
      ValueNotifier<String>('Partner');

  /// Geschlecht des Gegenübers ('female', 'male', 'other'), nur lokal vom Nutzer angegeben.
  /// Dient der Personalisierung der Lektionstexte (lib/services/personalize.dart).
  final ValueNotifier<String?> partnerGenderNotifier = ValueNotifier<String?>(null);

  final ValueNotifier<List<CoupleMessage>> messagesNotifier =
      ValueNotifier<List<CoupleMessage>>([]);

  final ValueNotifier<CoupleMessage?> lastPingNotifier =
      ValueNotifier<CoupleMessage?>(null);

  final ValueNotifier<Map<String, String>> myFantasyVotesNotifier =
      ValueNotifier<Map<String, String>>({});

  final ValueNotifier<Map<String, String>> partnerFantasyVotesNotifier =
      ValueNotifier<Map<String, String>>({});

  /// Reflexionen, die das Gegenüber geteilt hat: Lektion → Antwort.
  /// Angezeigt werden sie erst, wenn man selbst geantwortet hat (lesson_detail_screen.dart).
  final ValueNotifier<Map<String, String>> partnerReflectionsNotifier =
      ValueNotifier<Map<String, String>>({});

  final ValueNotifier<List<String>> matchesNotifier =
      ValueNotifier<List<String>>([]);

  /// Name der eingeladenen Person, solange eine Einladung offen ist.
  final ValueNotifier<String?> inviteNameNotifier = ValueNotifier<String?>(null);

  /// Öffentlicher Schlüssel (hex), der sich auf eine offene Einladung hin gemeldet hat.
  final ValueNotifier<String?> joinRequestNotifier = ValueNotifier<String?>(null);

  final Set<String> _processedEventIds = {};

  int? _inboxSince;

  /// Ist der Nachrichten-Bereich des Paar-Kanals gerade auf dem Bildschirm? (setzt die Navigation)
  final ValueNotifier<bool> paarKanalSichtbar = ValueNotifier<bool>(false);

  /// Eigene Einstellung „Lesebestätigungen“ (auf Gegenseitigkeit: aus = keine senden, keine anzeigen).
  final ValueNotifier<bool> readReceiptsEnabled = ValueNotifier<bool>(true);

  /// Bis zu welchem Zeitpunkt (created_at, Sekunden) das Gegenüber gelesen hat.
  /// null: Das Gegenüber sendet keine Bestätigungen (ältere Version oder ausgeschaltet).
  final ValueNotifier<int?> partnerReadUntil = ValueNotifier<int?>(null);

  int _readSentUntil = 0;

  /// Wann die gerade gültige Stimme des Partners je Fantasie abgegeben wurde. Beim erneuten
  /// Abholen kommen Nachrichten in beliebiger Reihenfolge; eine ältere darf keine neuere überschreiben.
  final Map<String, int> _partnerVoteTimes = {};

  /// Merkt sich eine verschickte Einladung. Die erste Nachricht, die danach von
  /// einem unbekannten Absender kommt, wird als Verbindungsanfrage angezeigt.
  Future<void> startInvite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyInviteName, name);
    inviteNameNotifier.value = name;
  }

  Future<void> cancelInvite() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyInviteName);
    inviteNameNotifier.value = null;
    joinRequestNotifier.value = null;
  }

  Future<bool> acceptJoinRequest() async {
    final sender = joinRequestNotifier.value;
    if (sender == null) return false;
    final ok = await setPartner(sender, name: inviteNameNotifier.value);
    if (ok) {
      await cancelInvite();
      // Als normale Chat-Nachricht, damit auch ältere Versionen sie anzeigen können.
      await sendChatMessage(t.nostrServiceWeReConnected);
    }
    return ok;
  }

  void declineJoinRequest() => joinRequestNotifier.value = null;

  void _ensureKeysInMemory() {
    if (_myPrivateKey == null || _myPrivateKey!.length != 64) {
      _myPrivateKey = _keyApi.generatePrivateKey();
      _myPublicKey = _keyApi.getPublicKey(_myPrivateKey!);
      try {
        _myNpub = _nip19.npubEncode(_myPublicKey!);
      } catch (_) {
        _myNpub = _myPublicKey;
      }
      myPubKeyNotifier.value = _myPublicKey ?? '';
      myNpubNotifier.value = _myNpub ?? '';
    }
  }

  String get myPublicKey {
    _ensureKeysInMemory();
    return _myPublicKey!;
  }

  String get myPrivateKey {
    _ensureKeysInMemory();
    return _myPrivateKey!;
  }

  String get myNpub {
    _ensureKeysInMemory();
    return _myNpub!;
  }

  String? get partnerPublicKey => _partnerPublicKey;
  String? get partnerNpub => _partnerNpub;
  String get partnerName => _partnerName;
  bool get isConnected => statusNotifier.value == NostrConnectionStatus.connected;
  bool get isPaired => _partnerPublicKey != null && _partnerPublicKey!.isNotEmpty;

  bool _isInitialized = false;

  Future<void> reloadKeysFromPrefs() async {
    _isInitialized = false;
    _myPrivateKey = null;
    _myPublicKey = null;
    _myNpub = null;
    await init();
  }

  Future<void> init() async {
    if (_isInitialized) {
      _disposed = false;
      connectRelay();
      return;
    }
    _isInitialized = true;

    final prefs = await SharedPreferences.getInstance();

    // 1. Schlüssel laden. Der private liegt im SecretStore; der öffentliche wird immer
    // daraus abgeleitet, nie einem gespeicherten Wert geglaubt.
    await SecretStore.init(prefs);
    final storedPriv = SecretStore.read(SecretStore.nostrPrivKey);

    if (isValidPrivateKeyHex(storedPriv)) {
      _myPrivateKey = storedPriv;
      _myPublicKey = _keyApi.getPublicKey(_myPrivateKey!);
    } else {
      _myPrivateKey = null;
      _ensureKeysInMemory();
      await SecretStore.write(SecretStore.nostrPrivKey, _myPrivateKey);
    }
    await prefs.setString(_keyPubKey, _myPublicKey!);

    try {
      _myNpub = _nip19.npubEncode(_myPublicKey!);
    } catch (_) {
      _myNpub = _myPublicKey;
    }

    myPubKeyNotifier.value = _myPublicKey ?? '';
    myNpubNotifier.value = _myNpub ?? '';

    // 2. Load partner info
    _partnerPublicKey = prefs.getString(_keyPartnerPubKey);
    _partnerName = prefs.getString(_keyPartnerName) ?? 'Partner';
    inviteNameNotifier.value = prefs.getString(_keyInviteName);
    _inboxSince = prefs.getInt(_keyInboxSince);
    _partnerVoteTimes.clear();
    readReceiptsEnabled.value = prefs.getBool(_keyReadReceipts) ?? true;
    partnerReadUntil.value = prefs.getInt(_keyPartnerReadUntil);
    _readSentUntil = prefs.getInt(_keyReadSentUntil) ?? 0;
    partnerGenderNotifier.value = prefs.getString(_keyPartnerGender);
    partnerPubKeyNotifier.value = _partnerPublicKey;
    partnerNameNotifier.value = _partnerName;

    if (_partnerPublicKey != null && _partnerPublicKey!.isNotEmpty) {
      try {
        _partnerNpub = _nip19.npubEncode(_partnerPublicKey!);
      } catch (_) {
        _partnerNpub = _partnerPublicKey;
      }
    }

    // 3. Load cached messages
    final cachedMsgJson = prefs.getString(_keyCachedMessages);
    if (cachedMsgJson != null && cachedMsgJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(cachedMsgJson);
        final loaded = list.map((e) => CoupleMessage.fromJson(e as Map<String, dynamic>)).toList();
        messagesNotifier.value = loaded;
        for (var m in loaded) {
          _processedEventIds.add(m.id);
          if (m.type == CoupleMessageType.ping && !m.isMe) {
            lastPingNotifier.value = m;
          }
        }
      } catch (e) {
        debugPrint('Error reading cached couple messages: $e');
      }
    }

    // 4. Load fantasy votes
    final myVotesJson = prefs.getString(_keyMyFantasyVotes);
    if (myVotesJson != null) {
      try {
        myFantasyVotesNotifier.value = Map<String, String>.from(jsonDecode(myVotesJson));
      } catch (_) {}
    }

    try {
      final reflections = prefs.getString(_keyPartnerReflections);
      partnerReflectionsNotifier.value =
          reflections == null ? {} : Map<String, String>.from(jsonDecode(reflections) as Map);
    } catch (_) {
      partnerReflectionsNotifier.value = {};
    }

    final partnerVotesJson = prefs.getString(_keyPartnerFantasyVotes);
    if (partnerVotesJson != null) {
      try {
        partnerFantasyVotesNotifier.value = Map<String, String>.from(jsonDecode(partnerVotesJson));
      } catch (_) {}
    }

    _calculateMatches();

    // 5. Connect to Nostr Relay in background without blocking app startup
    _disposed = false;
    unawaited(connectRelay(force: true));
  }

  /// Verbindet mit ALLEN Relays gleichzeitig. Jede Nachricht geht an alle,
  /// gelesen wird auf allen. So finden zwei Geräte immer zusammen, auch wenn
  /// ein älteres Gerät (bis 4.3.0-beta.2) nur mit einem einzigen Relay spricht.
  /// Doppelte Events fängt die Prüfung per Event-ID ab.
  Future<void> connectRelay({bool force = false}) async {
    for (final url in fallbackRelays) {
      final relay = _relays.putIfAbsent(url, () => _RelayConnection(url));
      if (force || relay.socket == null) {
        unawaited(_connect(relay));
      }
    }
  }

  /// Baut alle Verbindungen neu auf (Menüpunkt „Neu verbinden“).
  void reconnectNextRelay() => connectRelay(force: true);

  Future<void> retryConnection() => connectRelay(force: true);

  Future<void> _connect(_RelayConnection relay) async {
    final int epoch = ++relay.epoch;
    relay.close();
    relay.connecting = true;
    _updateStatus();

    try {
      final ws = await WebSocket.connect(relay.url).timeout(const Duration(seconds: 8));
      if (relay.epoch != epoch || _disposed) {
        ws.close();
        return;
      }
      ws.pingInterval = const Duration(seconds: 30);
      relay.socket = ws;
      relay.connecting = false;
      relay.failures = 0;
      relay.sub = ws.listen(
        (data) => _handleIncomingRawMessage(data, relay),
        onError: (_) => _onConnectionDropped(relay, epoch),
        onDone: () => _onConnectionDropped(relay, epoch),
        cancelOnError: true,
      );
      debugPrint('Nostr: verbunden mit ${relay.url}');
      _subscribeToInbox(relay);
    } catch (e) {
      debugPrint('Nostr: ${relay.url} nicht erreichbar (${e.runtimeType})');
      if (relay.epoch == epoch) _scheduleReconnect(relay);
    }
    _updateStatus();
  }

  void _onConnectionDropped(_RelayConnection relay, int epoch) {
    if (relay.epoch != epoch) return;
    relay.close();
    _scheduleReconnect(relay);
    _updateStatus();
  }

  /// Nur dieses eine Relay später erneut versuchen; die anderen bleiben verbunden.
  void _scheduleReconnect(_RelayConnection relay) {
    if (_disposed) return;
    relay.connecting = false;
    relay.failures++;
    final seconds = (5 * relay.failures).clamp(5, 120);
    relay.timer?.cancel();
    relay.timer = Timer(Duration(seconds: seconds), () => _connect(relay));
  }

  void _updateStatus() {
    final connected = _relays.values.where((r) => r.socket != null).toList();
    statusNotifier.value = connected.isNotEmpty
        ? NostrConnectionStatus.connected
        : (_relays.values.any((r) => r.connecting)
            ? NostrConnectionStatus.connecting
            : NostrConnectionStatus.disconnected);
    activeRelayNotifier.value = connectedRelaysLabel;
  }

  /// Für die Anzeige, z. B. „3 von 5 Servern“.
  String get connectedRelaysLabel {
    final count = _relays.values.where((r) => r.socket != null).length;
    return t.nostrServiceCountOfFallbackrelayslengthServers(count, fallbackRelays.length);
  }

  List<String> get connectedRelays =>
      [for (final r in _relays.values) if (r.socket != null) r.url.replaceFirst('wss://', '')];

  void _subscribeToInbox([_RelayConnection? only]) {
    if (_myPublicKey == null) return;
    // Alles seit der letzten bekannten Nachricht abholen. Früher waren es nur die letzten 20 –
    // wer offline war, verpasste z. B. die meisten Antworten einer geteilten Ja/Nein-Liste.
    final since = _inboxSince;
    final reqMessage = jsonEncode([
      'REQ',
      'velvet_sub',
      {
        'kinds': [4],
        '#p': [_myPublicKey!],
        if (since != null) 'since': since - _inboxOverlapSeconds,
        'limit': since != null ? 500 : 100,
      },
      if (isPaired)
        {
          'kinds': [readReceiptKind],
          'authors': [_partnerPublicKey!],
          '#d': [_readReceiptTag],
          'limit': 1,
        },
    ]);
    for (final relay in only == null ? _relays.values : [only]) {
      try {
        relay.socket?.add(reqMessage);
      } catch (e) {
        debugPrint('Nostr: Abo bei ${relay.url} fehlgeschlagen (${e.runtimeType})');
      }
    }
  }

  void _handleIncomingRawMessage(dynamic raw, _RelayConnection relay) {
    try {
      final String text = raw is List<int> ? utf8.decode(raw) : raw.toString();
      if (text.length > 256 * 1024) return; // übergroße Relay-Nachrichten gar nicht erst parsen
      final dynamic decoded = jsonDecode(text);
      if (decoded is! List || decoded.isEmpty) return;

      final String type = decoded[0].toString();
      if (type == 'EVENT') {
        // Format: ["EVENT", subscription_id, event_map]
        if (decoded.length >= 3 && decoded[2] is Map<String, dynamic>) {
          final eventMap = decoded[2] as Map<String, dynamic>;
          if (eventMap['kind'] == 4) {
            _handleIncomingKind4Map(eventMap);
          } else if (eventMap['kind'] == readReceiptKind) {
            _handleReadReceipt(eventMap);
          }
        }
      } else if (type == 'OK') {
        // ["OK", event_id, accepted, message]
        if (decoded.length >= 3 && decoded[2] == false) {
          debugPrint('Nostr: ${relay.url} hat ein Event abgelehnt: ${decoded.length > 3 ? decoded[3] : ""}');
        }
      } else if (type == 'CLOSED') {
        // Abo beendet (z. B. Anmeldung verlangt): dieses Relay später neu versuchen.
        debugPrint('Nostr: ${relay.url} hat das Abo beendet');
        relay.close();
        _scheduleReconnect(relay);
        _updateStatus();
      }
    } catch (e) {
      debugPrint('Nostr: unlesbare Relay-Nachricht (${e.runtimeType})');
    }
  }

  /// Verarbeitet ein Direktnachrichten-Event. Erst wird geprüft (Format, ID, Signatur,
  /// Empfänger, Absender), erst danach als verarbeitet gemerkt und entschlüsselt.
  /// So kann ein gefälschtes Event mit fremder ID keine echte Nachricht blockieren.
  @visibleForTesting
  Future<void> handleIncomingKind4Map(Map<String, dynamic> ev) => _handleIncomingKind4Map(ev);

  Future<void> _handleIncomingKind4Map(Map<String, dynamic> ev) async {
    if (_myPublicKey == null || _myPrivateKey == null) return;
    final Object? rawId = ev['id'];
    if (rawId is! String || _processedEventIds.contains(rawId)) return;
    if (!NostrEventCheck.isValidDirectMessage(ev, recipient: _myPublicKey!)) {
      debugPrint('Nostr: ungültiges Event verworfen');
      return;
    }
    final String id = rawId;
    final String senderPubkey = ev['pubkey'] as String;
    final String content = ev['content'] as String;
    final int createdAt = ev['created_at'] as int;

    // Ist ein Partner gesetzt, zählen nur seine Nachrichten. Ohne Partner nur, solange eine
    // Einladung offen ist (als Verbindungsanfrage) – sonst könnte jeder Fremde schreiben.
    if (isPaired) {
      if (senderPubkey != _partnerPublicKey) return;
    } else if (inviteNameNotifier.value == null) {
      return;
    }
    _processedEventIds.add(id);
    if (isPaired && (_inboxSince == null || createdAt > _inboxSince!)) {
      _inboxSince = createdAt;
      unawaited(SharedPreferences.getInstance().then((p) => p.setInt(_keyInboxSince, createdAt)));
    }

    try {
      final decrypted = _nip04.decrypt(_myPrivateKey!, senderPubkey, content);
      if (!isPaired && inviteNameNotifier.value != null && senderPubkey.length == 64) {
        joinRequestNotifier.value = senderPubkey;
      }
      _parseAndAddMessage(
        eventId: id,
        senderPubkey: senderPubkey,
        isMe: false,
        decryptedText: decrypted,
        timestamp: DateTime.fromMillisecondsSinceEpoch(createdAt * 1000),
      );
    } catch (e) {
      debugPrint('Nostr: Nachricht von ${senderPubkey.substring(0, 8)}… nicht entschlüsselbar (${e.runtimeType})');
    }
  }

  void _parseAndAddMessage({
    required String eventId,
    required String senderPubkey,
    required bool isMe,
    required String decryptedText,
    required DateTime timestamp,
  }) {
    CoupleMessageType type = CoupleMessageType.chat;
    String? text = decryptedText;
    String? emoji;
    String? fantasyId;
    String? fantasyVote;
    String? lessonId;

    try {
      final data = jsonDecode(decryptedText);
      if (data is Map<String, dynamic>) {
        final typ = data['type'] as String?;
        if (typ == 'ping') {
          type = CoupleMessageType.ping;
          emoji = data['emoji'] as String?;
          text = data['text'] as String?;
        } else if (typ == 'fantasy_vote') {
          type = CoupleMessageType.fantasyVote;
          fantasyId = data['fantasyId'] as String?;
          fantasyVote = data['vote'] as String?;
          text = t.nostrServiceVotedOnTheFantasySelection;
        } else if (typ == 'chat') {
          type = CoupleMessageType.chat;
          text = data['text'] as String?;
          // Gemeinsam lernen: als normale Chat-Nachricht verschickt, damit ältere Versionen
          // den lesbaren Text zeigen. Die Antwort selbst steckt nur im Zusatzfeld.
          final lesson = data['lesson'];
          if (lesson is String && lesson.length <= 64) lessonId = lesson;
          final reflection = data['reflection'];
          if (!isMe && lessonId != null && reflection is String && reflection.length <= 5000) {
            partnerReflectionsNotifier.value = {...partnerReflectionsNotifier.value, lessonId: reflection};
            _savePartnerReflections();
          }
          // Ja/Nein-Liste gebündelt: lesbarer Text für ältere Versionen, alle Stimmen im Zusatzfeld.
          final votes = data['votes'];
          if (!isMe && votes is Map && votes.length <= 500) {
            _applyPartnerVotes({
              for (final e in votes.entries)
                if (e.key is String && e.value is String && (e.key as String).length <= 64)
                  e.key as String: e.value as String,
            }, timestamp);
          }
        }
      }
    } catch (_) {
      // Plain text message
      type = CoupleMessageType.chat;
      text = decryptedText;
    }

    final newMsg = CoupleMessage(
      id: eventId,
      senderPubkey: senderPubkey,
      isMe: isMe,
      type: type,
      text: text,
      emoji: emoji,
      fantasyId: fantasyId,
      fantasyVote: fantasyVote,
      lessonId: lessonId,
      createdAt: timestamp,
    );

    if (type == CoupleMessageType.ping && !isMe) {
      lastPingNotifier.value = newMsg;
    }
    if (!isMe && type != CoupleMessageType.fantasyVote) {
      unawaited(MessageNotifier.notifyIfInBackground(timestamp.millisecondsSinceEpoch ~/ 1000));
    }

    if (type == CoupleMessageType.fantasyVote) {
      if (fantasyId != null && fantasyVote != null) {
        if (isMe) {
          final updated = Map<String, String>.from(myFantasyVotesNotifier.value);
          updated[fantasyId] = fantasyVote;
          myFantasyVotesNotifier.value = updated;
          _saveMyFantasyVotes();
          _calculateMatches();
        } else {
          _applyPartnerVotes({fantasyId: fantasyVote}, timestamp);
        }
      }
      // Stimmen gehören nicht in den Verlauf: Sie würden den Zwischenspeicher (100 Einträge)
      // füllen und echte Nachrichten verdrängen.
      return;
    }

    // Add to message list if chat or ping
    final currentList = List<CoupleMessage>.from(messagesNotifier.value);
    // Insert sorted by time
    currentList.add(newMsg);
    currentList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    messagesNotifier.value = currentList;

    _saveMessagesToCache();
  }

  void _applyPartnerVotes(Map<String, String> votes, DateTime timestamp) {
    final zeit = timestamp.millisecondsSinceEpoch;
    final updated = Map<String, String>.from(partnerFantasyVotesNotifier.value);
    var changed = false;
    for (final e in votes.entries) {
      if ((_partnerVoteTimes[e.key] ?? 0) > zeit) continue;
      _partnerVoteTimes[e.key] = zeit;
      if (updated[e.key] != e.value) {
        updated[e.key] = e.value;
        changed = true;
      }
    }
    if (!changed) return;
    partnerFantasyVotesNotifier.value = updated;
    _savePartnerFantasyVotes();
    _calculateMatches();
  }

  void _calculateMatches() {
    final myVotes = myFantasyVotesNotifier.value;
    final partnerVotes = partnerFantasyVotesNotifier.value;
    final List<String> matches = [];

    for (var entry in myVotes.entries) {
      if (entry.value == 'yes') {
        if (partnerVotes[entry.key] == 'yes') {
          matches.add(entry.key);
        }
      }
    }

    matchesNotifier.value = matches;
  }

  /// true, wenn [inputKey] eine andere Person ist als das jetzige Gegenüber –
  /// dann würde [setPartner] deren Verlauf löschen.
  bool wouldReplacePartner(String inputKey) {
    if (!isPaired) return false;
    final key = _normalizePartnerKey(inputKey);
    return key != null && key != _partnerPublicKey;
  }

  /// Macht aus npub, Hex oder einer ganzen Einladungsnachricht den Hex-Schlüssel, sonst null.
  String? _normalizePartnerKey(String inputKey) {
    String cleanKey = inputKey.trim();
    if (cleanKey.isEmpty) return null;
    // Wer die ganze Einladungsnachricht einfügt, soll trotzdem verbunden werden.
    final npubInText = RegExp(r'npub1[02-9ac-hj-np-z]{20,}').firstMatch(cleanKey);
    if (npubInText != null) cleanKey = npubInText.group(0)!;

    // Handle npub format
    if (cleanKey.startsWith('npub1')) {
      try {
        final decoded = _nip19.decode(cleanKey);
        final hex = decoded['data'] as String?;
        if (hex != null && hex.isNotEmpty) {
          cleanKey = hex;
        }
      } catch (e) {
        debugPrint('Failed to decode npub: $e');
        return null;
      }
    }

    // Hex must be valid 64-char key
    cleanKey = cleanKey.toLowerCase();
    return RegExp(r'^[0-9a-f]{64}$').hasMatch(cleanKey) ? cleanKey : null;
  }

  Future<bool> setPartner(String inputKey, {String? name}) async {
    final cleanKey = _normalizePartnerKey(inputKey);
    if (cleanKey == null) return false;

    final prefs = await SharedPreferences.getInstance();
    // Neue Person: Verlauf, Stimmen und Reflexionen der alten gehören nicht dazu.
    if (isPaired && cleanKey != _partnerPublicKey) {
      await _clearPartnerData(prefs);
    }

    _partnerPublicKey = cleanKey;
    try {
      _partnerNpub = _nip19.npubEncode(_partnerPublicKey!);
    } catch (_) {
      _partnerNpub = _partnerPublicKey;
    }

    if (name != null && name.trim().isNotEmpty) {
      _partnerName = name.trim();
    }

    await prefs.setString(_keyPartnerPubKey, _partnerPublicKey!);
    await prefs.setString(_keyPartnerName, _partnerName);

    partnerPubKeyNotifier.value = _partnerPublicKey;
    partnerNameNotifier.value = _partnerName;

    // Refresh inbox subscription
    _subscribeToInbox();

    return true;
  }

  Future<void> updatePartnerName(String newName) async {
    if (newName.trim().isEmpty) return;
    _partnerName = newName.trim();
    partnerNameNotifier.value = _partnerName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPartnerName, _partnerName);
  }

  /// Trennt die Verbindung und löscht alles, was zu dieser Person gehört.
  /// Die eigenen Antworten (Ja/Nein-Liste, Fantasien) bleiben erhalten.
  Future<void> unpairPartner() async {
    _partnerPublicKey = null;
    _partnerNpub = null;
    _partnerName = 'Partner';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPartnerPubKey);
    await prefs.remove(_keyPartnerName);

    partnerPubKeyNotifier.value = null;
    partnerNameNotifier.value = 'Partner';
    await _clearPartnerData(prefs);
  }

  Future<void> _clearPartnerData(SharedPreferences prefs) async {
    messagesNotifier.value = [];
    lastPingNotifier.value = null;
    await prefs.remove(_keyCachedMessages);
    partnerFantasyVotesNotifier.value = {};
    _partnerVoteTimes.clear();
    await prefs.remove(_keyPartnerFantasyVotes);
    _calculateMatches();
    partnerReflectionsNotifier.value = {};
    await prefs.remove(_keyPartnerReflections);
    partnerGenderNotifier.value = null;
    await prefs.remove(_keyPartnerGender);
    await prefs.remove(_keyProfilePromptDismissed);
    _inboxSince = null;
    await prefs.remove(_keyInboxSince);
    partnerReadUntil.value = null;
    await prefs.remove(_keyPartnerReadUntil);
    _readSentUntil = 0;
    await prefs.remove(_keyReadSentUntil);
  }

  /// Fehlen Name oder Geschlecht des Gegenübers, fragt der Paar-Kanal einmal nach.
  bool get partnerProfileIncomplete =>
      isPaired && (_partnerName.trim().isEmpty || _partnerName == 'Partner' || partnerGenderNotifier.value == null);

  Future<bool> partnerProfilePromptDismissed() async =>
      (await SharedPreferences.getInstance()).getBool(_keyProfilePromptDismissed) ?? false;

  Future<void> dismissPartnerProfilePrompt() async {
    await (await SharedPreferences.getInstance()).setBool(_keyProfilePromptDismissed, true);
    partnerNameNotifier.value = _partnerName; // Anzeige aktualisieren
  }

  Future<void> setPartnerProfile({required String name, String? gender}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name.trim().isNotEmpty) {
      _partnerName = name.trim();
      await prefs.setString(_keyPartnerName, _partnerName);
      partnerNameNotifier.value = _partnerName;
    }
    if (gender == null) {
      await prefs.remove(_keyPartnerGender);
    } else {
      await prefs.setString(_keyPartnerGender, gender);
    }
    partnerGenderNotifier.value = gender;
  }

  /// Lektion empfehlen. Ältere Versionen zeigen nur den Text.
  Future<bool> sendLessonShare(String lessonId, String lessonTitle, String courseTitle) =>
      _sendLearning({'text': t.nostrServiceHaveAReadLessontitleCoursetitle(lessonTitle, courseTitle), 'lesson': lessonId});

  /// Eigene Reflexion teilen. Der lesbare Text verrät die Antwort nicht.
  Future<bool> sendReflection(String lessonId, String lessonTitle, String answer) => _sendLearning({
        'text': t.nostrServiceIVeSharedMyThoughts(lessonTitle),
        'lesson': lessonId,
        'reflection': answer.trim(),
      });

  Future<bool> _sendLearning(Map<String, String> fields, {Map<String, Object> extra = const {}}) async {
    if (!isPaired) return false;
    final payload = jsonEncode(
        {'type': 'chat', ...fields, ...extra, 'timestamp': DateTime.now().millisecondsSinceEpoch});
    return _sendKind4(payload, (eventId) {
      _parseAndAddMessage(
        eventId: eventId,
        senderPubkey: _myPublicKey!,
        isMe: true,
        decryptedText: payload,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<void> _savePartnerReflections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPartnerReflections, jsonEncode(partnerReflectionsNotifier.value));
    } catch (_) {}
  }

  Future<bool> sendQuickPing(String emoji, String label) async {
    if (!isPaired) return false;

    final payload = jsonEncode({
      'type': 'ping',
      'emoji': emoji,
      'text': label,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return _sendKind4(payload, (eventId) {
      _parseAndAddMessage(
        eventId: eventId,
        senderPubkey: _myPublicKey!,
        isMe: true,
        decryptedText: payload,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<bool> sendChatMessage(String text) async {
    if (!isPaired || text.trim().isEmpty) return false;

    final payload = jsonEncode({
      'type': 'chat',
      'text': text.trim(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return _sendKind4(payload, (eventId) {
      _parseAndAddMessage(
        eventId: eventId,
        senderPubkey: _myPublicKey!,
        isMe: true,
        decryptedText: payload,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<bool> sendFantasyVote(String fantasyId, String vote) async {
    // Record vote locally first
    final updated = Map<String, String>.from(myFantasyVotesNotifier.value);
    updated[fantasyId] = vote;
    myFantasyVotesNotifier.value = updated;
    await _saveMyFantasyVotes();
    _calculateMatches();

    if (!isPaired) return true;

    final payload = jsonEncode({
      'type': 'fantasy_vote',
      'fantasyId': fantasyId,
      'vote': vote,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return _sendKind4(payload, (eventId) {
      _processedEventIds.add(eventId);
    });
  }

  /// Teilt alle Antworten der Ja/Nein-Liste in EINER Nachricht. Gibt die Zahl der geteilten
  /// Antworten zurück, 0 wenn nichts rausging.
  Future<int> syncAllYesNoMaybeVotes(Map<String, String> answers) async {
    if (answers.isEmpty) return 0;
    myFantasyVotesNotifier.value = {...myFantasyVotesNotifier.value, ...answers};
    await _saveMyFantasyVotes();
    _calculateMatches();
    if (!isPaired) return 0;

    // Übergang: Versionen bis 4.3 kennen nur Einzelstimmen. Solange das Gegenüber noch so eine
    // Version haben kann, gehen sie zusätzlich raus (neue Versionen werten sie gleich aus).
    // Kann entfallen, wenn 4.4 stabil ist und alle aktualisiert haben.
    for (final entry in answers.entries) {
      final payload = jsonEncode({
        'type': 'fantasy_vote',
        'fantasyId': entry.key,
        'vote': entry.value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      await _sendKind4(payload, _processedEventIds.add);
    }

    final ok = await _sendLearning({
      'text': t.nostrServiceIVeSharedMyAnswers,
    }, extra: {'votes': answers});
    return ok ? answers.length : 0;
  }

  Future<bool> _sendKind4(String plaintext, void Function(String eventId) onSuccess,
      {int kind = 4, List<List<String>> extraTags = const []}) async {
    if (_myPrivateKey == null || _partnerPublicKey == null) return false;
    final sockets = [for (final r in _relays.values) if (r.socket != null) r.socket!];
    if (sockets.isEmpty) {
      debugPrint('Nostr: kein Server verbunden, Nachricht nicht gesendet');
      return false;
    }

    try {
      final encrypted = _nip04.encrypt(_myPrivateKey!, _partnerPublicKey!, plaintext);
      final event = Event(
        kind: kind,
        tags: [
          ...extraTags,
          ['p', _partnerPublicKey!]
        ],
        content: encrypted,
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        pubkey: _myPublicKey!,
      );

      final signedEvent = _eventApi.finishEvent(event, _myPrivateKey!);
      _processedEventIds.add(signedEvent.id);

      final eventMap = {
        'id': signedEvent.id,
        'pubkey': signedEvent.pubkey,
        'created_at': signedEvent.created_at,
        'kind': signedEvent.kind,
        'tags': signedEvent.tags,
        'content': signedEvent.content,
        'sig': signedEvent.sig,
      };

      final message = jsonEncode(['EVENT', eventMap]);
      var sent = 0;
      for (final socket in sockets) {
        try {
          socket.add(message);
          sent++;
        } catch (_) {}
      }
      if (sent == 0) return false;
      onSuccess(signedEvent.id);
      return true;
    } catch (e) {
      debugPrint('Error sending Nostr Kind 4 event: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Lesebestätigungen

  /// Meldet dem Gegenüber, bis wohin gelesen wurde – nur wenn der Nachrichten-Bereich
  /// sichtbar ist (entscheidet couples_channel_screen.dart) und die Einstellung an ist.
  Future<void> markMessagesRead() async {
    if (!isPaired || !readReceiptsEnabled.value) return;
    var latest = 0;
    for (final m in messagesNotifier.value) {
      final sek = m.createdAt.millisecondsSinceEpoch ~/ 1000;
      if (!m.isMe && sek > latest) latest = sek;
    }
    if (latest <= _readSentUntil) return;
    if (await _sendReadReceipt({'read_until': latest})) {
      _readSentUntil = latest;
      await (await SharedPreferences.getInstance()).setInt(_keyReadSentUntil, latest);
    }
  }

  /// Ausschalten teilt das dem Gegenüber mit, damit dort kein veraltetes „Gelesen“ stehen bleibt.
  Future<void> setReadReceiptsEnabled(bool enabled) async {
    readReceiptsEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReadReceipts, enabled);
    if (!isPaired) return;
    if (enabled) {
      _readSentUntil = 0;
      await markMessagesRead();
    } else {
      await _sendReadReceipt({'off': true});
    }
  }

  Future<bool> _sendReadReceipt(Map<String, Object> fields) => _sendKind4(
        jsonEncode(fields),
        _processedEventIds.add,
        kind: readReceiptKind,
        extraTags: [
          ['d', _readReceiptTag]
        ],
      );

  @visibleForTesting
  Future<void> handleReadReceipt(Map<String, dynamic> ev) => _handleReadReceipt(ev);

  Future<void> _handleReadReceipt(Map<String, dynamic> ev) async {
    if (!isPaired || _myPrivateKey == null || ev['pubkey'] != _partnerPublicKey) return;
    if (!NostrEventCheck.isValidEvent(ev, recipient: _myPublicKey!, kind: readReceiptKind)) return;
    final tags = ev['tags'] as List;
    if (!tags.any((t) => t is List && t.length >= 2 && t[0] == 'd' && t[1] == _readReceiptTag)) return;
    try {
      final data = jsonDecode(_nip04.decrypt(_myPrivateKey!, _partnerPublicKey!, ev['content'] as String));
      if (data is! Map) return;
      final prefs = await SharedPreferences.getInstance();
      if (data['off'] == true) {
        partnerReadUntil.value = null;
        await prefs.remove(_keyPartnerReadUntil);
        return;
      }
      final until = data['read_until'];
      if (until is! int) return;
      if (until > (partnerReadUntil.value ?? 0)) {
        partnerReadUntil.value = until;
        await prefs.setInt(_keyPartnerReadUntil, until);
      }
    } catch (e) {
      debugPrint('Nostr: Lesebestätigung nicht lesbar (${e.runtimeType})');
    }
  }

  Future<void> _saveMessagesToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = messagesNotifier.value.map((m) => m.toJson()).toList();
      // Keep last 100 messages
      if (list.length > 100) {
        list.removeRange(0, list.length - 100);
      }
      await prefs.setString(_keyCachedMessages, jsonEncode(list));
    } catch (e) {
      debugPrint('Error saving messages to cache: $e');
    }
  }

  Future<void> _saveMyFantasyVotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyMyFantasyVotes, jsonEncode(myFantasyVotesNotifier.value));
    } catch (_) {}
  }

  Future<void> _savePartnerFantasyVotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPartnerFantasyVotes, jsonEncode(partnerFantasyVotesNotifier.value));
    } catch (_) {}
  }

  void dispose() {
    // Laufende Verbindungsversuche verwerfen, damit sie keine neuen mehr planen.
    _disposed = true;
    for (final relay in _relays.values) {
      relay.epoch++;
      relay.timer?.cancel();
      relay.close();
    }
    _updateStatus();
  }
}

class _RelayConnection {
  final String url;
  WebSocket? socket;
  StreamSubscription? sub;
  Timer? timer;
  int epoch = 0;
  int failures = 0;
  bool connecting = false;

  _RelayConnection(this.url);

  void close() {
    sub?.cancel();
    sub = null;
    try {
      socket?.close();
    } catch (_) {}
    socket = null;
  }
}
