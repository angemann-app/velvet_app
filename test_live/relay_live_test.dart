// Läuft als Test (eigener Ordner, damit er nicht bei jedem flutter test mitläuft).
// ignore_for_file: invalid_use_of_visible_for_testing_member
// Live-Test gegen echte Nostr-Relays (braucht Internet, nicht Teil von `flutter test`).
// Aufruf: flutter test test_live/relay_live_test.dart
//
// Simuliert die stabile 4.2.0, die nur mit EINEM Relay spricht, gegen die neue
// Version, die mit allen spricht – in beide Richtungen.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null; // echte Netzwerkverbindungen erlauben

  test('Neue Version und Ein-Relay-Gerät erreichen sich gegenseitig', () async {
    final keyApi = KeyApi();
    final oldPriv = keyApi.generatePrivateKey();
    final oldPub = keyApi.getPublicKey(oldPriv);

    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    final nostr = NostrService();
    await nostr.reloadKeysFromPrefs();
    await nostr.setPartner(oldPub, name: 'Alt');
    final newPub = nostr.myPublicKey;

    // Das „alte“ Gerät: nur nostr.mom, wie eine 4.2.0, die dort gelandet ist.
    const oldRelay = 'wss://nostr.mom';
    final ws = await WebSocket.connect(oldRelay).timeout(const Duration(seconds: 10));
    final received = Completer<String>();
    ws.listen((data) {
      final msg = jsonDecode(data as String);
      if (msg is List && msg[0] == 'EVENT' && msg[2]['pubkey'] == newPub && !received.isCompleted) {
        received.complete(Nip04().decrypt(oldPriv, newPub, msg[2]['content'] as String));
      }
    });
    ws.add(jsonEncode([
      'REQ',
      'alt',
      {
        'kinds': [4],
        '#p': [oldPub],
        'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60,
      }
    ]));

    // Warten, bis die neue Version mit Relays verbunden ist.
    for (var i = 0; i < 40 && nostr.connectedRelays.isEmpty; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    await Future.delayed(const Duration(seconds: 3));
    // ignore: avoid_print
    print('Neue Version verbunden mit: ${nostr.connectedRelays}');

    // Neu → Alt
    expect(await nostr.sendChatMessage('Hallo vom neuen Gerät'), isTrue);
    expect(await received.future.timeout(const Duration(seconds: 15)), contains('Hallo vom neuen Gerät'));

    // Alt → Neu, nur über das eine Relay
    final event = EventApi().finishEvent(
      Event(
        kind: 4,
        tags: [
          ['p', newPub]
        ],
        content: Nip04().encrypt(oldPriv, newPub, jsonEncode({'type': 'chat', 'text': 'Antwort vom alten Gerät'})),
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        verify: false,
      ),
      oldPriv,
    );
    ws.add(jsonEncode(['EVENT', event.toJson()]));
    for (var i = 0; i < 60; i++) {
      if (nostr.messagesNotifier.value.any((m) => m.text == 'Antwort vom alten Gerät')) break;
      await Future.delayed(const Duration(milliseconds: 250));
    }
    expect(nostr.messagesNotifier.value.where((m) => m.text == 'Antwort vom alten Gerät').length, 1);

    await ws.close();
    nostr.dispose();
  }, timeout: const Timeout(Duration(seconds: 60)));
}
