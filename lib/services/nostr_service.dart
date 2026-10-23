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
      await sendChatMessage('💛 Wir sind verbunden!');
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
    return '$count von ${fallbackRelays.length} Servern';
  }

  List<String> get connectedRelays =>
      [for (final r in _relays.values) if (r.socket != null) r.url.replaceFirst('wss://', '')];

  void _subscribeToInbox([_RelayConnection? only]) {
    if (_myPublicKey == null) return;
    final reqMessage = jsonEncode([
      'REQ',
      'velvet_sub',
      {
        'kinds': [4],
        '#p': [_myPublicKey!],
        'limit': 20,
      }
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

    // Ist ein Partner gesetzt, zählen nur seine Nachrichten.
    if (_partnerPublicKey != null && _partnerPublicKey!.isNotEmpty) {
      if (senderPubkey != _partnerPublicKey) {
        return;
      }
    }
    _processedEventIds.add(id);

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
        final t = data['type'] as String?;
        if (t == 'ping') {
          type = CoupleMessageType.ping;
          emoji = data['emoji'] as String?;
          text = data['text'] as String?;
        } else if (t == 'fantasy_vote') {
          type = CoupleMessageType.fantasyVote;
          fantasyId = data['fantasyId'] as String?;
          fantasyVote = data['vote'] as String?;
          text = 'Fantasie-Auswahl abgestimmt';
        } else if (t == 'chat') {
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
        } else {
          final updated = Map<String, String>.from(partnerFantasyVotesNotifier.value);
          updated[fantasyId] = fantasyVote;
          partnerFantasyVotesNotifier.value = updated;
          _savePartnerFantasyVotes();
        }
        _calculateMatches();
      }
    }

    // Add to message list if chat or ping
    final currentList = List<CoupleMessage>.from(messagesNotifier.value);
    // Insert sorted by time
    currentList.add(newMsg);
    currentList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    messagesNotifier.value = currentList;

    _saveMessagesToCache();
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

  Future<bool> setPartner(String inputKey, {String? name}) async {
    String cleanKey = inputKey.trim();
    if (cleanKey.isEmpty) return false;
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
        return false;
      }
    }

    // Hex must be valid 64-char key
    if (cleanKey.length != 64) {
      return false;
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

    final prefs = await SharedPreferences.getInstance();
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

  Future<void> unpairPartner() async {
    _partnerPublicKey = null;
    _partnerNpub = null;
    _partnerName = 'Partner';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPartnerPubKey);
    await prefs.remove(_keyPartnerName);

    partnerPubKeyNotifier.value = null;
    partnerNameNotifier.value = 'Partner';
    partnerReflectionsNotifier.value = {};
    await prefs.remove(_keyPartnerReflections);
  }

  /// Lektion empfehlen. Ältere Versionen zeigen nur den Text.
  Future<bool> sendLessonShare(String lessonId, String lessonTitle, String courseTitle) =>
      _sendLearning({'text': '📖 Lies mal: „$lessonTitle“ ($courseTitle)', 'lesson': lessonId});

  /// Eigene Reflexion teilen. Der lesbare Text verrät die Antwort nicht.
  Future<bool> sendReflection(String lessonId, String lessonTitle, String answer) => _sendLearning({
        'text': '💭 Ich habe meine Gedanken zu „$lessonTitle“ geteilt. Du siehst sie, sobald du selbst geantwortet hast.',
        'lesson': lessonId,
        'reflection': answer.trim(),
      });

  Future<bool> _sendLearning(Map<String, String> fields) async {
    if (!isPaired) return false;
    final payload = jsonEncode({'type': 'chat', ...fields, 'timestamp': DateTime.now().millisecondsSinceEpoch});
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

  Future<int> syncAllYesNoMaybeVotes(Map<String, String> answers) async {
    int count = 0;
    for (var entry in answers.entries) {
      final success = await sendFantasyVote(entry.key, entry.value);
      if (success) count++;
    }
    return count;
  }

  Future<bool> _sendKind4(String plaintext, void Function(String eventId) onSuccess) async {
    if (_myPrivateKey == null || _partnerPublicKey == null) return false;
    final sockets = [for (final r in _relays.values) if (r.socket != null) r.socket!];
    if (sockets.isEmpty) {
      debugPrint('Nostr: kein Server verbunden, Nachricht nicht gesendet');
      return false;
    }

    try {
      final encrypted = _nip04.encrypt(_myPrivateKey!, _partnerPublicKey!, plaintext);
      final event = Event(
        kind: 4,
        tags: [
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
