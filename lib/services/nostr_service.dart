import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/couple_channel_models.dart';
import 'gift_wrap.dart';
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

  // NIP-17 (docs/konzepte/nip17.md, Stufe 1): Empfangen wird immer beides. Gesendet wird per NIP-17
  // (Gift Wrap) erst, wenn das Gegenüber angekündigt hat, dass es das versteht. Gespeichert wird der
  // Schlüssel des Gegenübers, für das die Ankündigung gilt: Wechselt das Gegenüber auf welchem Weg auch
  // immer (Trennen, neue Kopplung, Sicherung), gilt sie automatisch nicht mehr.
  static const String keyPartnerNip17 = 'velvet_partner_nip17';

  /// Zeitpunkt (created_at des Gegenübers) der neuesten Ankündigung. Kommt danach eine NIP-04-Nachricht
  /// ohne Ankündigung, hat das Gegenüber wieder eine ältere Version: zurück auf NIP-04. Ältere, erneut
  /// abgeholte Nachrichten lösen das nicht aus.
  static const String _keyNip17Seit = 'velvet_partner_nip17_seit';

  /// Feld im verschlüsselten JSON jeder per NIP-04 gesendeten Nachricht: „ich verstehe NIP-17“.
  /// Ältere Versionen ignorieren unbekannte Felder.
  static const String nip17Feld = 'nip17';

  /// Flüchtiges Signal beim Start mit derselben Ankündigung (ältere Versionen ignorieren unbekannte Signale).
  static const String faehigSignal = 'faehig';

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

  /// Für welches Gegenüber (öffentlicher Schlüssel) NIP-17 angekündigt wurde.
  String? _nip17Fuer;
  int _nip17Seit = 0;

  /// Hat sich auf eine offene Einladung hin jemand gemeldet, der NIP-17 versteht? Gilt nach dem Annehmen.
  String? _nip17Anfrage;

  bool _faehigGesendet = false;
  Timer? _faehigTimer;
  int _letzteFaehigAntwort = 0;

  /// Versteht das jetzige Gegenüber NIP-17? Dann gehen Nachrichten als Gift Wrap raus.
  bool get partnerNip17 => isPaired && _nip17Fuer == _partnerPublicKey;

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

  /// Der eigene QR-Code wird gezeigt: Das zählt als offene Einladung, damit die Begrüßung des
  /// Handys, das ihn scannt, als Verbindungsanfrage ankommt (ohne Einladung wird sie verworfen).
  Future<void> codeZeigen() async {
    if (isPaired || inviteNameNotifier.value != null) return;
    await startInvite('Partner');
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
    _nip17Fuer = prefs.getString(keyPartnerNip17);
    _nip17Seit = prefs.getInt(_keyNip17Seit) ?? 0;
    _nip17Anfrage = null;
    _faehigGesendet = false;
    // Schon geöffnete Hüllen nicht bei jedem Start erneut entschlüsseln (sie kommen wegen der
    // zurückgesetzten Zeitstempel bis zu zwei Tage lang wieder).
    _processedEventIds.addAll(prefs.getStringList(MessageNotifier.keySeenWraps) ?? const []);
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
    _geloeschteIds
      ..clear()
      ..addAll(prefs.getStringList(_keyGeloeschte) ?? const []);
    _processedEventIds.addAll(_geloeschteIds);
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
    await aufraeumen();

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
      _faehigkeitAnkuendigen();
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
      // NIP-17: Hüllen tragen einen zufällig bis zu zwei Tage zurückgesetzten Zeitstempel und einen
      // Wegwerf-Absender. Darum ohne authors und entsprechend früher; Doppeltes fällt über die id heraus.
      {
        'kinds': [NostrEventCheck.giftWrapKind],
        '#p': [_myPublicKey!],
        if (since != null) 'since': since - GiftWrap.maxZurueck.inSeconds - _inboxOverlapSeconds,
        'limit': since != null ? 500 : 100,
      },
      if (isPaired)
        {
          'kinds': [readReceiptKind],
          'authors': [_partnerPublicKey!],
          '#d': [_readReceiptTag],
          'limit': 1,
        },
      // Flüchtige Signale (Foto-Übertragung): Server speichern sie nicht, sie kommen nur live an.
      if (isPaired)
        {
          'kinds': [signalKind],
          'authors': [_partnerPublicKey!],
          '#p': [_myPublicKey!],
          'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60,
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
          } else if (eventMap['kind'] == NostrEventCheck.giftWrapKind) {
            _handleGiftWrap(eventMap);
          } else if (eventMap['kind'] == readReceiptKind) {
            _handleReadReceipt(eventMap);
          } else if (eventMap['kind'] == signalKind) {
            handleSignal(eventMap);
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

    final String decrypted;
    try {
      decrypted = _nip04.decrypt(_myPrivateKey!, senderPubkey, content);
    } catch (e) {
      debugPrint('Nostr: Nachricht von ${senderPubkey.substring(0, 8)}… nicht entschlüsselbar (${e.runtimeType})');
      return;
    }
    _nip04Ankuendigung(senderPubkey, decrypted, createdAt);
    _eingangVerarbeiten(id: id, senderPubkey: senderPubkey, decrypted: decrypted, createdAt: createdAt);
  }

  /// Gemeinsamer Teil für kind 4 und NIP-17, nach Prüfen und Entschlüsseln.
  void _eingangVerarbeiten({
    required String id,
    required String senderPubkey,
    required String decrypted,
    required int createdAt,
  }) {
    if (isPaired && (_inboxSince == null || createdAt > _inboxSince!)) {
      _inboxSince = createdAt;
      unawaited(SharedPreferences.getInstance().then((p) => p.setInt(_keyInboxSince, createdAt)));
    }
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
  }

  /// NIP-17: Hülle (kind 1059) öffnen. Alle drei Stufen prüft NostrEventCheck (über GiftWrap.auspacken);
  /// als verarbeitet gemerkt wird erst danach, damit eine gefälschte Hülle mit fremder id nichts blockiert.
  /// Die Nachricht trägt die id und den echten Zeitpunkt der Rumor.
  @visibleForTesting
  Future<void> handleGiftWrap(Map<String, dynamic> ev) => _handleGiftWrap(ev);

  Future<void> _handleGiftWrap(Map<String, dynamic> ev) async {
    if (_myPublicKey == null || _myPrivateKey == null) return;
    final Object? huellenId = ev['id'];
    if (huellenId is! String || _processedEventIds.contains(huellenId)) return;
    // Ohne Partner nimmt nur eine offene Einladung Fremde an (wie bei kind 4).
    if (!isPaired && inviteNameNotifier.value == null) return;
    final offen = GiftWrap.auspacken(
      ev,
      meinPrivat: _myPrivateKey!,
      meinPub: _myPublicKey!,
      erwarteterAbsender: isPaired ? _partnerPublicKey : null,
    );
    if (offen == null) {
      // Nur eine echt signierte Hülle als erledigt merken (z. B. nicht von unserem Gegenüber).
      if (NostrEventCheck.isValidGiftWrap(ev, recipient: _myPublicKey!)) _huelleGesehen(huellenId);
      debugPrint('Nostr: Hülle verworfen');
      return;
    }
    _huelleGesehen(huellenId);
    final rumor = offen.rumor;
    final rumorId = rumor['id'] as String;
    if (!_processedEventIds.add(rumorId)) return;
    // Eine NIP-17-Nachricht ist selbst die beste Ankündigung.
    _nip17Merken(offen.absender, zeit: rumor['created_at'] as int);
    _eingangVerarbeiten(
      id: rumorId,
      senderPubkey: offen.absender,
      decrypted: rumor['content'] as String,
      createdAt: rumor['created_at'] as int,
    );
  }

  void _huelleGesehen(String id) {
    _processedEventIds.add(id);
    unawaited(MessageNotifier.markWrapsSeen([id]));
  }

  bool _kuendigtNip17An(String klartext) {
    try {
      final daten = jsonDecode(klartext);
      return daten is Map && daten[nip17Feld] == 1;
    } catch (_) {
      return false;
    }
  }

  /// Eine per NIP-04 empfangene Nachricht, Lesebestätigung oder ein Signal: mit `"nip17": 1` eine
  /// Ankündigung; ohne, und neuer als die letzte Ankündigung, der Rückfall auf NIP-04 (das Gegenüber hat
  /// wieder eine ältere Version, denn neue Versionen schicken das Feld bei NIP-04 immer mit).
  void _nip04Ankuendigung(String absender, String klartext, int zeit) {
    if (_kuendigtNip17An(klartext)) {
      _nip17Merken(absender, zeit: zeit);
    } else if (partnerNip17 && absender == _partnerPublicKey && zeit > _nip17Seit) {
      debugPrint('Nostr: Gegenüber schreibt wieder nur NIP-04, sende ab jetzt wieder so');
      _nip17Fuer = null;
      unawaited(SharedPreferences.getInstance().then((p) => p.remove(keyPartnerNip17)));
    }
  }

  /// Das Gegenüber [absender] versteht NIP-17 (Stand [zeit], created_at des Gegenübers). Während einer
  /// offenen Einladung gilt das erst nach dem Annehmen.
  void _nip17Merken(String absender, {int? zeit}) {
    if (!isPaired) {
      _nip17Anfrage = absender;
      return;
    }
    if (absender != _partnerPublicKey) return;
    if (zeit != null && zeit > _nip17Seit) {
      _nip17Seit = zeit;
      unawaited(SharedPreferences.getInstance().then((p) => p.setInt(_keyNip17Seit, zeit)));
    }
    if (_nip17Fuer == absender) return;
    _nip17Fuer = absender;
    debugPrint('Nostr: Gegenüber versteht NIP-17, sende ab jetzt per Gift Wrap');
    unawaited(SharedPreferences.getInstance().then((p) => p.setString(keyPartnerNip17, absender)));
  }

  /// Einmal je Start (bzw. nach einer neuen Kopplung) das Signal „ich verstehe NIP-17“ senden. Kurz warten,
  /// damit bis dahin mehrere Server verbunden sind; Signale speichern die Server nicht.
  void _faehigkeitAnkuendigen() {
    if (_faehigGesendet || !isPaired || _faehigTimer?.isActive == true) return;
    _faehigTimer = Timer(const Duration(seconds: 3), () async {
      if (_faehigGesendet || !isPaired) return;
      _faehigGesendet = await sendSignal({'t': faehigSignal, nip17Feld: 1});
    });
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
    var spicyEinladung = false;
    var verschwindet = false;
    String? fotoId;
    if (_geloeschteIds.contains(eventId)) return;

    try {
      final data = jsonDecode(decryptedText);
      if (data is Map<String, dynamic>) {
        final typ = data['type'] as String?;
        verschwindet = data['vanish'] == true;
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
          spicyEinladung = data['spicy_invite'] == true;
          final foto = data['foto'];
          if (foto is Map && foto['id'] is String && (foto['id'] as String).length <= 64) {
            fotoId = foto['id'] as String;
            if (!isMe) _fotoMerken(fotoId, Map<String, dynamic>.from(foto));
          }
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
      spicyEinladung: spicyEinladung,
      verschwindet: verschwindet,
      fotoId: fotoId,
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
    // Hat die angenommene Verbindungsanfrage schon NIP-17 angekündigt, gilt das jetzt.
    if (_nip17Anfrage == cleanKey) _nip17Merken(cleanKey);
    _nip17Anfrage = null;

    partnerPubKeyNotifier.value = _partnerPublicKey;
    partnerNameNotifier.value = _partnerName;

    // Gekoppelt: Eine offene Einladung (z. B. vom gezeigten QR-Code) hat sich erledigt.
    if (inviteNameNotifier.value != null) await cancelInvite();

    // Refresh inbox subscription
    _subscribeToInbox();
    _faehigkeitAnkuendigen();

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
    // Die Ankündigung gilt nur für die bisherige Person; die neue kündigt selbst an.
    _nip17Fuer = null;
    await prefs.remove(keyPartnerNip17);
    _nip17Seit = 0;
    await prefs.remove(_keyNip17Seit);
    _faehigGesendet = false;
    _letzteFaehigAntwort = 0;
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

  /// Zum Spicy-Modus einladen. Einschalten muss das Gegenüber selbst (mit Altersabfrage);
  /// ältere Versionen zeigen nur den Text.
  Future<bool> sendSpicyEinladung() => _sendLearning({'text': t.spicyEinladungText}, extra: {'spicy_invite': true});

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
    return _senden(payload, (eventId) {
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

  Future<bool> sendQuickPing(String emoji, String label, {bool verschwindet = false}) async {
    if (!isPaired) return false;

    final payload = jsonEncode({
      'type': 'ping',
      'emoji': emoji,
      'text': label,
      if (verschwindet) 'vanish': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return _senden(payload, extraTags: verschwindet ? _ablaufTag() : const [], (eventId) {
      _parseAndAddMessage(
        eventId: eventId,
        senderPubkey: _myPublicKey!,
        isMe: true,
        decryptedText: payload,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<bool> sendChatMessage(String text, {bool verschwindet = false}) async {
    if (!isPaired || text.trim().isEmpty) return false;

    final payload = jsonEncode({
      'type': 'chat',
      'text': text.trim(),
      if (verschwindet) 'vanish': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return _senden(payload, extraTags: verschwindet ? _ablaufTag() : const [], (eventId) {
      _parseAndAddMessage(
        eventId: eventId,
        senderPubkey: _myPublicKey!,
        isMe: true,
        decryptedText: payload,
        timestamp: DateTime.now(),
      );
    });
  }

  /// Schickt eine Nachricht, sobald ein Server verbunden ist. Für die Begrüßung direkt nach dem
  /// Scannen: Baut die App die Verbindung gerade erst auf, ginge sie sonst still verloren.
  Future<bool> sendeSobaldVerbunden(String text, {Duration warten = const Duration(minutes: 2)}) async {
    if (await sendChatMessage(text)) return true;
    final fertig = Completer<bool>();
    var laeuft = false;
    void pruefen() {
      if (fertig.isCompleted || laeuft || !isConnected) return;
      laeuft = true;
      sendChatMessage(text).then((ok) {
        laeuft = false;
        if (ok && !fertig.isCompleted) fertig.complete(true);
      });
    }

    statusNotifier.addListener(pruefen);
    pruefen();
    final ok = await fertig.future.timeout(warten, onTimeout: () => false);
    statusNotifier.removeListener(pruefen);
    return ok;
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

    return _senden(payload, (eventId) {
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
    // Kann entfallen, wenn 4.4 stabil ist und alle aktualisiert haben. Wer NIP-17 versteht, ist neuer.
    for (final entry in partnerNip17 ? const <MapEntry<String, String>>[] : answers.entries) {
      final payload = jsonEncode({
        'type': 'fantasy_vote',
        'fantasyId': entry.key,
        'vote': entry.value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      await _senden(payload, _processedEventIds.add);
    }

    final ok = await _sendLearning({
      'text': t.nostrServiceIVeSharedMyAnswers,
    }, extra: {'votes': answers});
    return ok ? answers.length : 0;
  }

  /// Nur für Tests: ersetzt das Verschicken an die Server (true = angenommen).
  @visibleForTesting
  bool Function(Map<String, dynamic> event)? senderFuerTest;

  /// Schickt eine Nachricht an das Gegenüber. Versteht es NIP-17 ([partnerNip17]), als Gift Wrap
  /// (Rumor kind 14 → Siegel → Hülle kind 1059), sonst wie bisher als kind 4 mit NIP-04 und der
  /// Ankündigung `"nip17": 1`. [onSuccess] bekommt die id, unter der die Nachricht im Verlauf steht
  /// (bei NIP-17 die der Rumor). [extraTags] (z. B. `expiration`) kommen bei NIP-17 auf die Hülle.
  Future<bool> _senden(String plaintext, void Function(String eventId) onSuccess,
      {List<List<String>> extraTags = const []}) async {
    if (_myPrivateKey == null || _partnerPublicKey == null) return false;
    if (!partnerNip17) {
      return _sendeEvent(kind: 4, plaintext: plaintext, onSuccess: onSuccess, extraTags: extraTags);
    }
    try {
      final rumor = GiftWrap.rumor(absenderPub: _myPublicKey!, empfaengerPub: _partnerPublicKey!, inhalt: plaintext);
      final huelle = GiftWrap.einpacken(
        rumor: rumor,
        absenderPrivat: _myPrivateKey!,
        empfaengerPub: _partnerPublicKey!,
        huellenTags: extraTags,
      );
      final rumorId = rumor['id'] as String;
      _processedEventIds.add(rumorId);
      _processedEventIds.add(huelle['id'] as String);
      if (!_verschicken(huelle)) return false;
      onSuccess(rumorId);
      return true;
    } catch (e) {
      debugPrint('Nostr: Gift Wrap nicht gesendet (${e.runtimeType})');
      return false;
    }
  }

  /// Ein vom eigenen Schlüssel signiertes Event an das Gegenüber (kind 4, Lesebestätigung, Signal).
  /// Inhalt per NIP-44, wenn das Gegenüber NIP-17 angekündigt hat, sonst NIP-04 mit Ankündigung.
  Future<bool> _sendeEvent({
    required int kind,
    required String plaintext,
    required void Function(String eventId) onSuccess,
    List<List<String>> extraTags = const [],
  }) async {
    if (_myPrivateKey == null || _partnerPublicKey == null) return false;
    try {
      final encrypted = partnerNip17 && kind != 4
          ? GiftWrap.verschluesseln(plaintext, _myPrivateKey!, _partnerPublicKey!)
          : _nip04.encrypt(_myPrivateKey!, _partnerPublicKey!, _mitAnkuendigung(plaintext));
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
      if (!_verschicken(signedEvent.toJson())) return false;
      onSuccess(signedEvent.id);
      return true;
    } catch (e) {
      debugPrint('Nostr: Event (kind $kind) nicht gesendet (${e.runtimeType})');
      return false;
    }
  }

  /// An alle verbundenen Server. true, wenn es mindestens einer angenommen hat (bzw. der Test-Sender).
  bool _verschicken(Map<String, dynamic> eventMap) {
    if (senderFuerTest != null) return senderFuerTest!(eventMap);
    final sockets = [for (final r in _relays.values) if (r.socket != null) r.socket!];
    if (sockets.isEmpty) {
      debugPrint('Nostr: kein Server verbunden, Nachricht nicht gesendet');
      return false;
    }
    final message = jsonEncode(['EVENT', eventMap]);
    var sent = 0;
    for (final socket in sockets) {
      try {
        socket.add(message);
        sent++;
      } catch (_) {}
    }
    return sent > 0;
  }

  /// Fügt einem JSON-Objekt die Ankündigung `"nip17": 1` hinzu (nur für NIP-04, siehe [nip17Feld]).
  static String _mitAnkuendigung(String plaintext) {
    try {
      final daten = jsonDecode(plaintext);
      if (daten is Map<String, dynamic>) return jsonEncode({...daten, nip17Feld: 1});
    } catch (_) {}
    return plaintext;
  }

  /// Inhalt einer Lesebestätigung oder eines Signals des Gegenübers: NIP-04 erkennt man an `?iv=`,
  /// alles andere ist NIP-44. Beide kündigen ggf. NIP-17 an.
  String _entschluesselnVomPartner(Map<String, dynamic> ev) {
    final content = ev['content'] as String;
    final zeit = ev['created_at'] as int;
    if (content.contains('?iv=')) {
      final klartext = _nip04.decrypt(_myPrivateKey!, _partnerPublicKey!, content);
      _nip04Ankuendigung(_partnerPublicKey!, klartext, zeit);
      return klartext;
    }
    final klartext = GiftWrap.entschluesseln(content, _myPrivateKey!, _partnerPublicKey!);
    _nip17Merken(_partnerPublicKey!, zeit: zeit);
    return klartext;
  }

  // ---------------------------------------------------------------------------
  // Lesebestätigungen

  /// Meldet dem Gegenüber, bis wohin gelesen wurde – nur wenn der Nachrichten-Bereich
  /// sichtbar ist (entscheidet couples_channel_screen.dart) und die Einstellung an ist.
  Future<void> markMessagesRead() async {
    // Gelesene verschwindende Nachrichten des Gegenübers laufen ab jetzt ab – auch ohne Lesebestätigung.
    _loeschzeitSetzen((m) => !m.isMe);
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

  Future<bool> _sendReadReceipt(Map<String, Object> fields) => _sendeEvent(
        plaintext: jsonEncode(fields),
        onSuccess: _processedEventIds.add,
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
      final data = jsonDecode(_entschluesselnVomPartner(ev));
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
      // Eigene verschwindende Nachrichten, die das Gegenüber gelesen hat, laufen ab jetzt ab.
      _loeschzeitSetzen((m) => m.isMe && m.createdAt.millisecondsSinceEpoch ~/ 1000 <= until);
    } catch (e) {
      debugPrint('Nostr: Lesebestätigung nicht lesbar (${e.runtimeType})');
    }
  }

  // ---------------------------------------------------------------------------
  // Flüchtige Signale (lib/services/foto_kanal.dart)

  /// Flüchtige Art (20000–29999): Server reichen sie nur live weiter und speichern sie nicht.
  static const int signalKind = 21555;
  final StreamController<Map<String, dynamic>> _signale = StreamController<Map<String, dynamic>>.broadcast();

  /// Entschlüsselte Signale des Gegenübers, z. B. „bist du da?“ oder der Verbindungsaufbau für ein Foto.
  Stream<Map<String, dynamic>> get signale => _signale.stream;

  /// Inhalt per NIP-44, sobald das Gegenüber NIP-17 angekündigt hat, sonst NIP-04 (keine Hülle:
  /// Signale sind flüchtig und zeitkritisch, Konzept Entscheidung 3).
  Future<bool> sendSignal(Map<String, Object?> daten) =>
      _sendeEvent(kind: signalKind, plaintext: jsonEncode(daten), onSuccess: _processedEventIds.add);

  @visibleForTesting
  void handleSignal(Map<String, dynamic> ev) {
    if (!isPaired || _myPrivateKey == null || ev['pubkey'] != _partnerPublicKey) return;
    if (!NostrEventCheck.isValidEvent(ev, recipient: _myPublicKey!, kind: signalKind)) return;
    // Alte Signale (vom Server nachgereicht) sind wertlos und könnten verwirren.
    final alter = DateTime.now().millisecondsSinceEpoch ~/ 1000 - (ev['created_at'] as int? ?? 0);
    if (alter > 120) return;
    final id = ev['id'] as String;
    if (!_processedEventIds.add(id)) return;
    try {
      final daten = jsonDecode(_entschluesselnVomPartner(ev));
      if (daten is! Map<String, dynamic>) return;
      if (daten['t'] == faehigSignal) {
        _faehigBeantworten(daten);
        return;
      }
      _signale.add(daten);
    } catch (e) {
      debugPrint('Nostr: Signal nicht lesbar (${e.runtimeType})');
    }
  }

  /// Das Gegenüber hat gerade gestartet und kündigt NIP-17 an (gemerkt hat es schon
  /// [_entschluesselnVomPartner]). Einmal antworten, damit es auch umgekehrt sofort Bescheid weiß;
  /// auf eine Antwort wird nicht geantwortet, und höchstens einmal pro Minute.
  void _faehigBeantworten(Map<String, dynamic> daten) {
    if (daten['antwort'] == 1) return;
    final jetzt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (jetzt - _letzteFaehigAntwort < 60) return;
    _letzteFaehigAntwort = jetzt;
    unawaited(sendSignal({'t': faehigSignal, nip17Feld: 1, 'antwort': 1}));
  }

  // ---------------------------------------------------------------------------
  // Fotos: Schlüssel empfangener Fotos (bis zum Ansehen)

  static const _keyFotoSchluessel = 'velvet_foto_keys';

  /// Angaben zu einem empfangenen Foto (Schlüssel, Größe, Prüfsumme), oder null.
  Future<Map<String, dynamic>?> fotoAngebot(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final alle = jsonDecode(prefs.getString(_keyFotoSchluessel) ?? '{}') as Map<String, dynamic>;
    return alle[id] as Map<String, dynamic>?;
  }

  Future<void> _fotoMerken(String id, Map<String, dynamic> angaben) async {
    final prefs = await SharedPreferences.getInstance();
    final alle = jsonDecode(prefs.getString(_keyFotoSchluessel) ?? '{}') as Map<String, dynamic>;
    alle[id] = angaben;
    await prefs.setString(_keyFotoSchluessel, jsonEncode(alle));
  }

  /// Nach dem Ansehen: Schlüssel vergessen, das Foto ist nicht mehr zu öffnen.
  Future<void> fotoVergessen(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final alle = jsonDecode(prefs.getString(_keyFotoSchluessel) ?? '{}') as Map<String, dynamic>;
    alle.remove(id);
    await prefs.setString(_keyFotoSchluessel, jsonEncode(alle));
  }

  /// Kündigt ein Foto an. Der Schlüssel reist verschlüsselt in der Nachricht, das Foto selbst
  /// später direkt von Handy zu Handy. Ältere Versionen zeigen nur den Text.
  Future<bool> sendFotoAngebot(Map<String, Object> angaben, {bool verschwindet = false}) =>
      _sendLearning({'text': t.fotoNachricht}, extra: {'foto': angaben, if (verschwindet) 'vanish': true});

  // ---------------------------------------------------------------------------
  // Verschwindende Nachrichten

  /// So lange bleibt eine verschwindende Nachricht nach dem Lesen stehen. Gelöscht wird nur nach dem
  /// Lesen: beim Gegenüber, sobald sie auf dem Bildschirm war, beim Absender mit dessen Lesebestätigung.
  static const verschwindenNachLesen = Duration(minutes: 10);

  /// Ablaufdatum für die Server (NIP-40), damit die verschlüsselte Nachricht dort nicht ewig liegt.
  /// Großzügig gewählt, damit sie auch nach längerer Abwesenheit noch ankommt.
  static const serverAblauf = Duration(days: 7);

  static const _keyGeloeschte = 'velvet_vanished_ids';
  final Set<String> _geloeschteIds = {};

  List<List<String>> _ablaufTag() => [
        ['expiration', '${DateTime.now().add(serverAblauf).millisecondsSinceEpoch ~/ 1000}']
      ];

  void _loeschzeitSetzen(bool Function(CoupleMessage) welche) {
    var geaendert = false;
    final liste = [
      for (final m in messagesNotifier.value)
        if (m.verschwindet && m.loeschenAb == null && welche(m))
          (() {
            geaendert = true;
            return m.mitLoeschzeit(DateTime.now().add(verschwindenNachLesen));
          })()
        else
          m,
    ];
    if (!geaendert) return;
    messagesNotifier.value = liste;
    _saveMessagesToCache();
  }

  /// Entfernt abgelaufene verschwindende Nachrichten und merkt sich ihre ids, damit ein Server sie
  /// nicht wieder hereinreicht. Läuft beim Laden und regelmäßig, solange der Paar-Kanal offen ist.
  Future<void> aufraeumen({DateTime? jetzt}) async {
    final now = jetzt ?? DateTime.now();
    bool abgelaufen(CoupleMessage m) => m.verschwindet && m.loeschenAb != null && !now.isBefore(m.loeschenAb!);
    final weg = messagesNotifier.value.where(abgelaufen).toList();
    if (weg.isEmpty) return;
    _geloeschteIds.addAll(weg.map((m) => m.id));
    messagesNotifier.value = messagesNotifier.value.where((m) => !abgelaufen(m)).toList();
    await _saveMessagesToCache();
    final prefs = await SharedPreferences.getInstance();
    final ids = _geloeschteIds.toList();
    await prefs.setStringList(_keyGeloeschte, ids.length > 300 ? ids.sublist(ids.length - 300) : ids);
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
