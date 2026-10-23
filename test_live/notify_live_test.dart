// Live-Test: Findet die Hintergrund-Prüfung eine neue Nachricht des Partners auf den Relays?
// Aufruf: flutter test test_live/notify_live_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/message_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  test('Neue Nachricht des Partners wird gefunden, danach nicht noch einmal', () async {
    final keyApi = KeyApi();
    final myPriv = keyApi.generatePrivateKey();
    final partnerPriv = keyApi.generatePrivateKey();
    final me = keyApi.getPublicKey(myPriv);
    final partner = keyApi.getPublicKey(partnerPriv);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    SharedPreferences.setMockInitialValues({
      MessageNotifier.keyEnabled: true,
      'velvet_nostr_pubkey': me,
      'velvet_partner_pubkey': partner,
      MessageNotifier.keyNotifiedUntil: now - 5,
    });

    // Partner schreibt über ein einziges Relay.
    final ws = await WebSocket.connect('wss://nos.lol').timeout(const Duration(seconds: 10));
    final event = EventApi().finishEvent(
      Event(
        kind: 4,
        tags: [
          ['p', me]
        ],
        content: Nip04().encrypt(partnerPriv, me, jsonEncode({'type': 'chat', 'text': 'Test'})),
        created_at: now,
        verify: false,
      ),
      partnerPriv,
    );
    ws.add(jsonEncode(['EVENT', event.toJson()]));
    await Future.delayed(const Duration(seconds: 3));
    await ws.close();

    expect(await MessageNotifier.checkRelays(), greaterThanOrEqualTo(1));
    expect(await MessageNotifier.checkRelays(), 0); // schon gemeldet
  }, timeout: const Timeout(Duration(seconds: 90)));
}
