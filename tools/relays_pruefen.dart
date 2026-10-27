// Prüft jeden Server des Paar-Kanals: Nimmt er eine verschlüsselte Direktnachricht (kind 4) und ein
// flüchtiges Signal (kind 21555, Foto-Übertragung) an und reicht beides live an ein Gegenüber weiter?
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/relays_pruefen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nostr_tools/nostr_tools.dart';

const relays = [
  'wss://relay.primal.net',
  'wss://nos.lol',
  'wss://nostr.mom',
  'wss://relay.snort.social',
  'wss://relay.damus.io',
];

Future<void> main() async {
  final keys = KeyApi();
  final events = EventApi();
  final nip04 = Nip04();
  final a = keys.generatePrivateKey(), b = keys.generatePrivateKey();
  final aPub = keys.getPublicKey(a), bPub = keys.getPublicKey(b);

  // kind 4: Direktnachrichten (Kopplung, Chat); kind 21555: flüchtige Signale (Foto-Übertragung).
  for (final kind in [4, 21555])
  for (final url in relays) {
    final ergebnis = StringBuffer('kind $kind  $url: ');
    try {
      final empfaenger = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
      final sender = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
      final angekommen = Completer<bool>();
      String? okMeldung;
      empfaenger.listen((raw) {
        final m = jsonDecode(raw as String) as List;
        if (m[0] == 'EVENT' && !angekommen.isCompleted) angekommen.complete(true);
        if (m[0] == 'CLOSED' || m[0] == 'NOTICE') ergebnis.write('[Empfänger ${m[0]}: ${m.last}] ');
      });
      sender.listen((raw) {
        final m = jsonDecode(raw as String) as List;
        if (m[0] == 'OK') okMeldung = '${m[2]}${(m.length > 3 && '${m[3]}'.isNotEmpty) ? ' (${m[3]})' : ''}';
        if (m[0] == 'NOTICE') ergebnis.write('[Sender NOTICE: ${m.last}] ');
      });
      empfaenger.add(jsonEncode([
        'REQ', 'test', {'kinds': [kind], if (kind != 4) 'authors': [aPub], '#p': [bPub], 'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60}
      ]));
      await Future.delayed(const Duration(seconds: 1));
      final ev = events.finishEvent(
          Event(
            kind: kind,
            tags: [['p', bPub]],
            content: nip04.encrypt(a, bPub, 'Test'),
            created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            pubkey: aPub,
          ),
          a);
      sender.add(jsonEncode(['EVENT', {
        'id': ev.id, 'pubkey': ev.pubkey, 'created_at': ev.created_at, 'kind': ev.kind,
        'tags': ev.tags, 'content': ev.content, 'sig': ev.sig,
      }]));
      final ok = await angekommen.future.timeout(const Duration(seconds: 8), onTimeout: () => false);
      ergebnis.write('angenommen: ${okMeldung ?? 'keine Antwort'}, weitergereicht: ${ok ? 'ja' : 'NEIN'}');
      await empfaenger.close();
      await sender.close();
    } catch (e) {
      ergebnis.write('nicht erreichbar (${e.runtimeType})');
    }
    stdout.writeln(ergebnis);
  }
  exit(0);
}
