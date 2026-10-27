import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nostr_tools/nostr_tools.dart';

import 'gift_wrap.dart';
import 'nostr_service.dart';

/// Worum es in einer Rückmeldung geht.
enum RueckmeldungArt { wunsch, fehler, aussprache }

/// Rückmeldungen (Funktionswünsche, Fehler, Aussprache) als verschlüsselte Nostr-Nachricht an das
/// Rückmelde-Postfach von VelvetPulse. Jede Nachricht bekommt einen frischen Einmal-Schlüssel: Sie ist
/// weder mit dem Paar-Kanal noch mit anderen Rückmeldungen verknüpft. Abgeholt werden sie mit
/// tools/rueckmeldungen_abholen.dart (privater Schlüssel nur auf dem Rechner der Entwicklung).
class Rueckmeldung {
  /// Öffentlicher Schlüssel des Postfachs (npub1gdea8j6k38zupe75zmqyss6eg4zzprvfynpmky4t8mamkk0wswtsw7n2k5).
  static const postfachHex = '4373d3cb5689c5c0e7d416c04843594544208d8924c3bb12ab3efbbb59ee8397';

  static const _kennung = {
    RueckmeldungArt.wunsch: 'Funktionswunsch',
    RueckmeldungArt.fehler: 'Fehler',
    RueckmeldungArt.aussprache: 'Aussprache',
  };

  /// Lesbarer Text der Nachricht (so erscheint sie auch in jedem Nostr-Programm).
  /// Nur was hier steht, wird übertragen – keine Profil- oder Nutzungsdaten.
  static String text({
    required RueckmeldungArt art,
    required String nachricht,
    Map<String, String> angaben = const {},
    String? kontakt,
    required String version,
    required String sprache,
  }) {
    final b = StringBuffer('[VelvetPulse] ${_kennung[art]}\n\n${nachricht.trim()}\n');
    final details = {
      for (final e in angaben.entries)
        if (e.value.trim().isNotEmpty) e.key: e.value.trim()
    };
    if (details.isNotEmpty) {
      b.writeln();
      for (final e in details.entries) {
        b.writeln('${e.key}: ${e.value}');
      }
    }
    b
      ..writeln()
      ..writeln('Version: $version, Sprache: $sprache');
    if (kontakt != null && kontakt.trim().isNotEmpty) b.writeln('Kontakt für Rückfragen: ${kontakt.trim()}');
    return b.toString().trim();
  }

  /// NIP-17-Nachricht an das Postfach (Gift Wrap, kind 1059): Die Rumor stammt von einem frischen
  /// Einmal-Schlüssel, die Hülle von einem weiteren frischen Schlüssel. Die Server sehen nur „jemand schreibt
  /// an das Postfach“, nicht wann genau. Abgeholt wird kind 4 (ältere Versionen) und kind 1059.
  static Map<String, dynamic> event(String klartext,
      {String? einmalSchluessel, String? huellenSchluessel, String empfaenger = postfachHex}) {
    final privat = einmalSchluessel ?? KeyApi().generatePrivateKey();
    final rumor = GiftWrap.rumor(absenderPub: KeyApi().getPublicKey(privat), empfaengerPub: empfaenger, inhalt: klartext);
    return GiftWrap.einpacken(
      rumor: rumor,
      absenderPrivat: privat,
      empfaengerPub: empfaenger,
      wegwerfSchluessel: huellenSchluessel,
    );
  }

  /// Nur für Tests: ersetzt das Verschicken an die Server.
  @visibleForTesting
  static Future<bool> Function(Map<String, dynamic> event)? senderFuerTest;

  /// Schickt die Nachricht an alle Server des Paar-Kanals. true, sobald einer sie angenommen hat.
  static Future<bool> senden(String klartext) async {
    final ev = event(klartext);
    if (senderFuerTest != null) return senderFuerTest!(ev);
    final angenommen = Completer<bool>();
    final sockets = <WebSocket>[];
    var offen = NostrService.fallbackRelays.length;
    void fertig() {
      if (--offen == 0 && !angenommen.isCompleted) angenommen.complete(false);
    }

    for (final url in NostrService.fallbackRelays) {
      WebSocket.connect(url).timeout(const Duration(seconds: 6)).then((ws) {
        sockets.add(ws);
        ws.listen((raw) {
          try {
            final m = jsonDecode(raw as String);
            if (m is List && m.length >= 3 && m[0] == 'OK' && m[1] == ev['id']) {
              if (m[2] == true && !angenommen.isCompleted) angenommen.complete(true);
              if (m[2] != true) fertig();
            }
          } catch (_) {}
        }, onError: (_) => fertig(), onDone: () {});
        ws.add(jsonEncode(['EVENT', ev]));
      }).catchError((_) => fertig());
    }
    final ok = await angenommen.future.timeout(const Duration(seconds: 10), onTimeout: () => false);
    for (final ws in sockets) {
      unawaited(ws.close().catchError((_) {}));
    }
    return ok;
  }
}
