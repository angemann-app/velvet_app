// Holt die Rückmeldungen aus dem Rückmelde-Postfach (lib/services/rueckmeldung.dart) und entschlüsselt sie.
// Der private Schlüssel liegt nur hier: C:\TOOLS\velvet-feedback\feedback_key.json (tools/feedback_schluessel.dart).
// Neue Rückmeldungen werden ausgegeben und an C:\TOOLS\velvet-feedback\rueckmeldungen.md angehängt.
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart          (nur neue)
//   C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart --alle   (alle, die die Server noch haben)
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/nostr_event_check.dart';

const relays = [
  'wss://relay.primal.net',
  'wss://nos.lol',
  'wss://nostr.mom',
  'wss://relay.snort.social',
  'wss://relay.damus.io',
];
const ordner = r'C:\TOOLS\velvet-feedback';

Future<void> main(List<String> args) async {
  final alle = args.contains('--alle');
  final schluessel = jsonDecode(File('$ordner\\feedback_key.json').readAsStringSync()) as Map<String, dynamic>;
  final privat = Nip19().decode(schluessel['nsec'] as String)['data'] as String;
  final oeffentlich = schluessel['hex_public'] as String;
  final gesehenDatei = File('$ordner\\gesehen.json');
  final gesehen = <String>{
    if (gesehenDatei.existsSync() && !alle) ...(jsonDecode(gesehenDatei.readAsStringSync()) as List).cast<String>(),
  };

  final events = <String, Map<String, dynamic>>{};
  await Future.wait([
    for (final url in relays)
      () async {
        try {
          final ws = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
          final fertig = Completer<void>();
          ws.listen((raw) {
            final m = jsonDecode(raw as String) as List;
            if (m[0] == 'EVENT' && m[2] is Map) {
              final ev = Map<String, dynamic>.from(m[2] as Map);
              events[ev['id'] as String] = ev;
            }
            if ((m[0] == 'EOSE' || m[0] == 'CLOSED') && !fertig.isCompleted) fertig.complete();
          }, onDone: () => fertig.isCompleted ? null : fertig.complete());
          ws.add(jsonEncode([
            'REQ',
            'rueckmeldungen',
            {
              'kinds': [4],
              '#p': [oeffentlich],
              'limit': 500
            }
          ]));
          await fertig.future.timeout(const Duration(seconds: 10), onTimeout: () {});
          await ws.close();
        } catch (e) {
          stderr.writeln('$url: nicht erreichbar (${e.runtimeType})');
        }
      }(),
  ]);

  final neu = [
    for (final ev in events.values)
      if (!gesehen.contains(ev['id']) && NostrEventCheck.isValidDirectMessage(ev, recipient: oeffentlich)) ev
  ]..sort((a, b) => (a['created_at'] as int).compareTo(b['created_at'] as int));

  final protokoll = StringBuffer();
  for (final ev in neu) {
    String text;
    try {
      text = Nip04().decrypt(privat, ev['pubkey'] as String, ev['content'] as String);
    } catch (_) {
      text = '(nicht entschlüsselbar)';
    }
    final zeit = DateTime.fromMillisecondsSinceEpoch((ev['created_at'] as int) * 1000).toLocal();
    protokoll
      ..writeln('## ${zeit.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}  (${(ev['id'] as String).substring(0, 8)})')
      ..writeln()
      ..writeln(text)
      ..writeln();
    gesehen.add(ev['id'] as String);
  }
  stdout.writeln(neu.isEmpty ? 'Keine neuen Rückmeldungen.' : '${neu.length} neue Rückmeldung(en):\n\n$protokoll');
  if (neu.isNotEmpty && !alle) {
    File('$ordner\\rueckmeldungen.md').writeAsStringSync(protokoll.toString(), mode: FileMode.append);
  }
  gesehenDatei.writeAsStringSync(jsonEncode(gesehen.toList()));
  exit(0);
}
