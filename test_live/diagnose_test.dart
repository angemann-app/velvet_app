// Diagnose: Welche Direktnachrichten zweier Codes liegen auf welchen Relays?
// Liest nur öffentliche Metadaten (Absender, Empfänger, Zeit), entschlüsselt nichts.
// Aufruf: flutter test test_live/diagnose_test.dart --dart-define=A=npub1… --dart-define=B=npub1…
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/nostr_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;

  test('Diagnose', () async {
    final nip19 = Nip19();
    final a = nip19.decode(const String.fromEnvironment('A'))['data'] as String;
    final b = nip19.decode(const String.fromEnvironment('B'))['data'] as String;
    String name(String hex) => hex == a ? 'A' : (hex == b ? 'B' : 'fremd ${hex.substring(0, 8)}');

    for (final relay in NostrService.fallbackRelays) {
      final events = <Map<String, dynamic>>[];
      try {
        final ws = await WebSocket.connect(relay).timeout(const Duration(seconds: 8));
        final done = Completer<void>();
        ws.listen((data) {
          final msg = jsonDecode(data as String);
          if (msg is List && msg[0] == 'EVENT') events.add(msg[2] as Map<String, dynamic>);
          if (msg is List && (msg[0] == 'EOSE' || msg[0] == 'CLOSED') && !done.isCompleted) done.complete();
        });
        final since = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 2 * 86400;
        ws.add(jsonEncode([
          'REQ', 'd1',
          {'kinds': [4], 'authors': [a, b], 'since': since, 'limit': 50},
        ]));
        ws.add(jsonEncode([
          'REQ', 'd2',
          {'kinds': [4], '#p': [a, b], 'since': since, 'limit': 50},
        ]));
        await done.future.timeout(const Duration(seconds: 8), onTimeout: () {});
        await Future.delayed(const Duration(seconds: 2));
        await ws.close();
      } catch (e) {
        // ignore: avoid_print
        print('$relay: nicht erreichbar ($e)');
        continue;
      }
      final seen = <String>{};
      // ignore: avoid_print
      print('$relay: ${events.length} Treffer');
      for (final ev in events) {
        if (!seen.add(ev['id'] as String)) continue;
        final to = (ev['tags'] as List).firstWhere((t) => t[0] == 'p', orElse: () => ['p', '?'])[1] as String;
        final time = DateTime.fromMillisecondsSinceEpoch((ev['created_at'] as int) * 1000);
        // ignore: avoid_print
        print('   $time  ${name(ev['pubkey'] as String)} -> ${name(to)}');
      }
    }
  }, timeout: const Timeout(Duration(seconds: 90)));
}
