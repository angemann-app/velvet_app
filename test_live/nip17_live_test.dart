// Läuft als Test (eigener Ordner, damit er nicht bei jedem flutter test mitläuft).
// ignore_for_file: invalid_use_of_visible_for_testing_member
// Live-Test NIP-17 gegen echte Nostr-Relays (braucht Internet, nicht Teil von `flutter test`).
// Aufruf: flutter test test_live/nip17_live_test.dart
//
// Die App (NostrService) und ein simuliertes Gegenüber, das nur über relay.primal.net spricht:
// Aushandlung über eine NIP-04-Nachricht mit "nip17": 1, danach Gift Wrap in beide Richtungen.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/gift_wrap.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null; // echte Netzwerkverbindungen erlauben

  test('Aushandlung und Gift Wrap in beide Richtungen über echte Server', () async {
    final keyApi = KeyApi();
    final partnerPriv = keyApi.generatePrivateKey();
    final partnerPub = keyApi.getPublicKey(partnerPriv);

    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    final nostr = NostrService();
    await nostr.reloadKeysFromPrefs();
    await nostr.setPartner(partnerPub, name: 'Neu');
    final appPub = nostr.myPublicKey;

    const relay = 'wss://relay.primal.net';
    final ws = await WebSocket.connect(relay).timeout(const Duration(seconds: 10));
    final huelle = Completer<String>();
    ws.listen((data) {
      final msg = jsonDecode(data as String);
      if (msg is List && msg[0] == 'EVENT' && msg[2]['kind'] == 1059 && !huelle.isCompleted) {
        final offen = GiftWrap.auspacken(Map<String, dynamic>.from(msg[2] as Map),
            meinPrivat: partnerPriv, meinPub: partnerPub, erwarteterAbsender: appPub);
        if (offen != null) huelle.complete(offen.rumor['content'] as String);
      }
    });
    ws.add(jsonEncode([
      'REQ',
      'partner',
      {
        'kinds': [1059],
        '#p': [partnerPub],
        'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - GiftWrap.maxZurueck.inSeconds - 60,
      }
    ]));

    for (var i = 0; i < 40 && !nostr.connectedRelays.contains('relay.primal.net'); i++) {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    await Future.delayed(const Duration(seconds: 2));
    // ignore: avoid_print
    print('App verbunden mit: ${nostr.connectedRelays}');

    // 1. Gegenüber kündigt per NIP-04 an.
    final ankuendigung = EventApi().finishEvent(
      Event(
        kind: 4,
        tags: [
          ['p', appPub]
        ],
        content: Nip04().encrypt(partnerPriv, appPub, jsonEncode({'type': 'chat', 'text': 'Hallo', 'nip17': 1})),
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        verify: false,
      ),
      partnerPriv,
    );
    ws.add(jsonEncode(['EVENT', ankuendigung.toJson()]));
    for (var i = 0; i < 60 && !nostr.partnerNip17; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    expect(nostr.partnerNip17, isTrue);

    // 2. App → Gegenüber per Gift Wrap.
    expect(await nostr.sendChatMessage('Versiegelt von der App'), isTrue);
    expect(await huelle.future.timeout(const Duration(seconds: 15)), contains('Versiegelt von der App'));

    // 3. Gegenüber → App per Gift Wrap.
    final rumor = GiftWrap.rumor(
        absenderPub: partnerPub,
        empfaengerPub: appPub,
        inhalt: jsonEncode({'type': 'chat', 'text': 'Versiegelt zurück'}));
    ws.add(jsonEncode([
      'EVENT',
      GiftWrap.einpacken(rumor: rumor, absenderPrivat: partnerPriv, empfaengerPub: appPub),
    ]));
    for (var i = 0; i < 60; i++) {
      if (nostr.messagesNotifier.value.any((m) => m.text == 'Versiegelt zurück')) break;
      await Future.delayed(const Duration(milliseconds: 250));
    }
    final angekommen = nostr.messagesNotifier.value.where((m) => m.text == 'Versiegelt zurück').toList();
    expect(angekommen, hasLength(1));
    expect(angekommen.single.id, rumor['id']);

    await ws.close();
    nostr.dispose();
  }, timeout: const Timeout(Duration(seconds: 90)));
}
