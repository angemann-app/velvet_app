// Holt die Rückmeldungen aus dem Rückmelde-Postfach (lib/services/rueckmeldung.dart) und entschlüsselt sie.
// Der private Schlüssel liegt nur hier: C:\TOOLS\velvet-feedback\feedback_key.json (tools/feedback_schluessel.dart).
// Neue Rückmeldungen werden ausgegeben und an C:\TOOLS\velvet-feedback\rueckmeldungen.md angehängt,
// danach öffentliche Antworten und Erwähnungen des Projekt-Profils (nur lesen).
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart             (nur neue)
//   C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart --alle      (alle, die die Server noch haben)
//   C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart --leser ag  (eigener Lesestand)
//
// Jeder Leser hat seinen eigenen Lesestand (gesehen_<leser>.json), damit Antigravity und Claude sich
// die Meldungen nicht gegenseitig „wegholen“. Ohne --leser gilt gesehen.json (Claude). Nur dieser
// Standard-Leser hängt an rueckmeldungen.md an, damit dort nichts doppelt steht.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/gift_wrap.dart';
import 'package:velvetpulse/services/nostr_event_check.dart';

const relays = [
  'wss://relay.primal.net',
  'wss://nos.lol',
  'wss://nostr.mom',
  'wss://relay.snort.social',
  'wss://relay.damus.io',
];
const ordner = r'C:\TOOLS\velvet-feedback';

/// Öffentliches Nostr-Profil des Projekts (für Antworten und Erwähnungen).
const projektNpub = 'npub1lpcmrtc50qshs8q7l3v34wfq47z5l9fvyruxlt0pzhga3643jxlqsnrkr2';

Future<void> main(List<String> args) async {
  final alle = args.contains('--alle');
  final schluessel = jsonDecode(File('$ordner\\feedback_key.json').readAsStringSync()) as Map<String, dynamic>;
  final privat = Nip19().decode(schluessel['nsec'] as String)['data'] as String;
  final oeffentlich = schluessel['hex_public'] as String;
  final lesePos = args.indexOf('--leser');
  final leser = lesePos >= 0 && lesePos + 1 < args.length ? args[lesePos + 1] : null;
  final gesehenDatei = File(leser == null ? '$ordner\\gesehen.json' : '$ordner\\gesehen_$leser.json');
  // Neuer Leser: beginnt beim gemeinsamen Stand von bisher, statt alles Alte noch einmal zu melden.
  final gemeinsam = File('$ordner\\gesehen.json');
  if (leser != null && !gesehenDatei.existsSync() && gemeinsam.existsSync()) gemeinsam.copySync(gesehenDatei.path);
  final gesehen = <String>{
    if (gesehenDatei.existsSync() && !alle) ...(jsonDecode(gesehenDatei.readAsStringSync()) as List).cast<String>(),
  };

  // kind 4: NIP-04 (Versionen vor der Umstellung), kind 1059: NIP-17 (Gift Wrap, echter Zeitpunkt in der Rumor).
  final events = await holen({
    'kinds': [4, NostrEventCheck.giftWrapKind],
    '#p': [oeffentlich],
    'limit': 500
  });

  final neu = <({String id, int zeit, String text})>[];
  for (final ev in events.values) {
    final id = ev['id'] as String;
    if (gesehen.contains(id)) continue;
    if (ev['kind'] == 4 && NostrEventCheck.isValidDirectMessage(ev, recipient: oeffentlich)) {
      String text;
      try {
        text = Nip04().decrypt(privat, ev['pubkey'] as String, ev['content'] as String);
      } catch (_) {
        text = '(nicht entschlüsselbar)';
      }
      neu.add((id: id, zeit: ev['created_at'] as int, text: text));
    } else if (ev['kind'] == NostrEventCheck.giftWrapKind) {
      final offen = GiftWrap.auspacken(ev, meinPrivat: privat, meinPub: oeffentlich);
      if (offen == null) continue; // gefälscht oder nicht lesbar
      neu.add((id: id, zeit: offen.rumor['created_at'] as int, text: offen.rumor['content'] as String));
    }
  }
  neu.sort((a, b) => a.zeit.compareTo(b.zeit));

  final protokoll = StringBuffer();
  for (final ev in neu) {
    final text = ev.text;
    final zeit = DateTime.fromMillisecondsSinceEpoch(ev.zeit * 1000).toLocal();
    protokoll
      ..writeln('## ${zeit.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}  (${ev.id.substring(0, 8)})')
      ..writeln()
      ..writeln(text)
      ..writeln();
    gesehen.add(ev.id);
  }
  stdout.writeln(neu.isEmpty ? 'Keine neuen Rückmeldungen.' : '${neu.length} neue Rückmeldung(en):\n\n$protokoll');
  if (neu.isNotEmpty && !alle && leser == null) {
    File('$ordner\\rueckmeldungen.md').writeAsStringSync(protokoll.toString(), mode: FileMode.append);
  }
  // Öffentliche Antworten und Erwähnungen am Projekt-Profil (kind 1, ohne eigene Beiträge).
  final projekt = Nip19().decode(projektNpub)['data'] as String;
  final erwaehnungen = [
    for (final ev in (await holen({
      'kinds': [1],
      '#p': [projekt],
      'limit': 200
    })).values)
      if (!gesehen.contains(ev['id']) && ev['pubkey'] != projekt) ev
  ]..sort((a, b) => (a['created_at'] as int).compareTo(b['created_at'] as int));
  if (erwaehnungen.isEmpty) {
    stdout.writeln('Keine neuen öffentlichen Antworten oder Erwähnungen.');
  } else {
    stdout.writeln('${erwaehnungen.length} neue öffentliche Antwort(en)/Erwähnung(en):\n');
    for (final ev in erwaehnungen) {
      final zeit = DateTime.fromMillisecondsSinceEpoch((ev['created_at'] as int) * 1000).toLocal();
      final von = Nip19().npubEncode(ev['pubkey'] as String);
      stdout
        ..writeln('## ${zeit.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}  von ${von.substring(0, 16)}…  (nevent: ${ev['id']})')
        ..writeln()
        ..writeln(ev['content'])
        ..writeln();
      gesehen.add(ev['id'] as String);
    }
  }

  gesehenDatei.writeAsStringSync(jsonEncode(gesehen.toList()));
  exit(0);
}

/// Fragt alle Server mit einem Filter ab und sammelt die Events (doppelte zählen einmal).
Future<Map<String, Map<String, dynamic>>> holen(Map<String, Object> filter) async {
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
          ws.add(jsonEncode(['REQ', 'abholen', filter]));
          await fertig.future.timeout(const Duration(seconds: 10), onTimeout: () {});
          await ws.close();
        } catch (e) {
          stderr.writeln('$url: nicht erreichbar (${e.runtimeType})');
        }
      }(),
  ]);
  return events;
}
