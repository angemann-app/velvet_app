// Prüft jeden Server des Paar-Kanals: Nimmt er eine verschlüsselte Direktnachricht (kind 4) an,
// und reicht er sie an ein zweites, frisches Gegenüber weiter? Genau das passiert bei der Kopplung.
// Danach dasselbe für NIP-17 (Gift Wrap, kind 1059, Zeitstempel bis zu zwei Tage zurück): angenommen,
// live weitergereicht und später noch abrufbar?
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/relays_pruefen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/gift_wrap.dart';

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

  for (final url in relays) {
    final ergebnis = StringBuffer('$url: ');
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
        'REQ', 'test', {'kinds': [4], '#p': [bPub], 'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 30}
      ]));
      await Future.delayed(const Duration(seconds: 1));
      final ev = events.finishEvent(
          Event(
            kind: 4,
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

  stdout.writeln('\nNIP-17 (kind 1059):');
  for (final url in relays) {
    stdout.writeln(await giftWrapPruefen(url, a, bPub));
  }
  exit(0);
}

/// Hülle von [absender] an [empfaenger]: Nimmt der Server sie trotz zurückgesetztem Zeitstempel an,
/// reicht er sie live weiter, und liefert er sie bei einer späteren Abfrage noch aus?
Future<String> giftWrapPruefen(String url, String absender, String empfaenger) async {
  final ergebnis = StringBuffer('$url: ');
  try {
    final huelle = GiftWrap.einpacken(
      rumor: GiftWrap.rumor(absenderPub: KeyApi().getPublicKey(absender), empfaengerPub: empfaenger, inhalt: 'Test'),
      absenderPrivat: absender,
      empfaengerPub: empfaenger,
    );
    final filter = {
      'kinds': [1059],
      '#p': [empfaenger],
      'since': DateTime.now().millisecondsSinceEpoch ~/ 1000 - GiftWrap.maxZurueck.inSeconds - 60,
    };
    final empfaengerWs = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
    final sender = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
    final live = Completer<bool>();
    String? okMeldung;
    empfaengerWs.listen((raw) {
      final m = jsonDecode(raw as String) as List;
      if (m[0] == 'EVENT' && (m[2] as Map)['id'] == huelle['id'] && !live.isCompleted) live.complete(true);
      if (m[0] == 'CLOSED' || m[0] == 'NOTICE') ergebnis.write('[Empfänger ${m[0]}: ${m.last}] ');
    });
    sender.listen((raw) {
      final m = jsonDecode(raw as String) as List;
      if (m[0] == 'OK') okMeldung = '${m[2]}${(m.length > 3 && '${m[3]}'.isNotEmpty) ? ' (${m[3]})' : ''}';
      if (m[0] == 'NOTICE') ergebnis.write('[Sender NOTICE: ${m.last}] ');
    });
    empfaengerWs.add(jsonEncode(['REQ', 'live', filter]));
    await Future.delayed(const Duration(seconds: 1));
    sender.add(jsonEncode(['EVENT', huelle]));
    final weiter = await live.future.timeout(const Duration(seconds: 8), onTimeout: () => false);
    await empfaengerWs.close();
    await sender.close();

    // Neue Verbindung, wie ein Handy, das später online kommt.
    final spaeter = await WebSocket.connect(url).timeout(const Duration(seconds: 8));
    final gespeichert = Completer<bool>();
    spaeter.listen((raw) {
      final m = jsonDecode(raw as String) as List;
      if (m[0] == 'EVENT' && (m[2] as Map)['id'] == huelle['id'] && !gespeichert.isCompleted) gespeichert.complete(true);
      if ((m[0] == 'EOSE' || m[0] == 'CLOSED') && !gespeichert.isCompleted) gespeichert.complete(false);
    });
    spaeter.add(jsonEncode(['REQ', 'spaeter', filter]));
    final abrufbar = await gespeichert.future.timeout(const Duration(seconds: 8), onTimeout: () => false);
    await spaeter.close();
    ergebnis.write('angenommen: ${okMeldung ?? 'keine Antwort'}, weitergereicht: ${weiter ? 'ja' : 'NEIN'}, '
        'später abrufbar: ${abrufbar ? 'ja' : 'NEIN'}');
  } catch (e) {
    ergebnis.write('nicht erreichbar (${e.runtimeType})');
  }
  return ergebnis.toString();
}
