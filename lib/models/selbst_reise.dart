import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import 'paar_abend.dart';

/// Geführte Selbsterkundung: aus den Bausteinen in assets/data/selbst_reise.json wird jedes Mal
/// eine neue Reise zusammengestellt – Ankommen, Atem, eine Körperreise vom Gesicht bis zur
/// gewählten Tiefe, bei „intim“ mit Wellen, und ein Ausklang. Die meiste Zeit ist Stille.
class SelbstReiseDaten {
  final List<PaarBaustein> bausteine;

  /// Echte Länge jeder Aufnahme in ms, Schlüssel "<stimme>_<id>" (tools/generate_audio.py --selbst).
  final Map<String, int> dauerMs;

  const SelbstReiseDaten(this.bausteine, this.dauerMs);

  static Future<SelbstReiseDaten> laden() async {
    final data = jsonDecode(await rootBundle.loadString('assets/data/selbst_reise.json'));
    Map<String, int> dauer = {};
    try {
      final raw = jsonDecode(await rootBundle.loadString('assets/audio/selbst/dauer.json')) as Map;
      dauer = raw.map((k, v) => MapEntry(k as String, v as int));
    } catch (_) {}
    return SelbstReiseDaten(
      (data['bausteine'] as List).map((b) => PaarBaustein.fromJson(b)).toList(),
      dauer,
    );
  }

  Duration dauerVon(PaarBaustein b, String stimme) {
    final ms = dauerMs['${stimme}_${b.id}'];
    return Duration(milliseconds: ms ?? (b.text.length / 13 * 1000).round());
  }

  /// [koerper]: 'vulva' oder 'penis'; nur für die Tiefe „intim“ von Bedeutung.
  List<PaarSchritt> planen({
    required int minuten,
    required PaarTiefe tiefe,
    required String koerper,
    required String stimme,
    Set<String> zuletzt = const {},
    Random? zufall,
  }) {
    final rnd = zufall ?? Random();
    final benutzt = <String>{};

    PaarBaustein waehle(Iterable<PaarBaustein> kandidaten) {
      final alle = kandidaten.toList();
      var frisch = alle.where((b) => !benutzt.contains(b.id) && !zuletzt.contains(b.id)).toList();
      if (frisch.isEmpty) frisch = alle.where((b) => !benutzt.contains(b.id)).toList();
      if (frisch.isEmpty) frisch = alle;
      final b = frisch[rnd.nextInt(frisch.length)];
      benutzt.add(b.id);
      return b;
    }

    Iterable<PaarBaustein> phase(String p) => bausteine.where((b) => b.phase == p);
    Duration d(PaarBaustein b) => dauerVon(b, stimme);

    final erlaubt = PaarTiefe.values.sublist(0, tiefe.index + 1).map((t) => t.name).toSet();
    final zonen = <String, List<PaarBaustein>>{};
    for (final b in phase('beruehren')) {
      if (!erlaubt.contains(b.tiefe)) continue;
      if (b.koerper != null && b.koerper != koerper) continue;
      if (b.zone == 'genital') continue; // kommt am Ende eigens dran
      zonen.putIfAbsent(b.zone!, () => []).add(b);
    }
    final genital = tiefe == PaarTiefe.intim
        ? phase('beruehren').where((b) => b.zone == 'genital' && b.koerper == koerper).toList()
        : <PaarBaustein>[];

    // Körperreise: Zonen nach Stufe geordnet und gleichmäßig verteilt, damit sie sanft beginnt.
    final anzahl = minuten >= 30 ? 7 : (minuten >= 20 ? 5 : 3);
    final namen = zonen.keys.toList()..shuffle(rnd);
    int stufe(String z) => zonen[z]!.first.stufe;
    namen.sort((a, b) => stufe(a).compareTo(stufe(b)));
    final gewaehlt = namen.length <= anzahl
        ? namen
        : [for (var j = 0; j < anzahl; j++) namen[(j * (namen.length - 1) / (anzahl - 1)).round()]];
    final reise = [for (final z in gewaehlt) waehle(zonen[z]!)];

    // Intim: mehrere Genital-Bausteine, dazwischen eine Wellen-Anleitung.
    final intim = <PaarBaustein>[];
    if (genital.isNotEmpty) {
      final wieviele = minuten >= 30 ? 4 : (minuten >= 20 ? 3 : 2);
      // Der erste ist immer das ruhige Auflegen der Hand.
      final halten = genital.firstWhere((b) => b.id.endsWith('_1'), orElse: () => genital.first);
      benutzt.add(halten.id);
      intim.add(halten);
      for (var i = 1; i < wieviele; i++) {
        intim.add(waehle(genital.where((b) => b != halten)));
        if (i == 1) intim.add(waehle(phase('welle')));
      }
    }

    final ankommen = waehle(phase('ankommen'));
    final atem = waehle(phase('atem'));
    final ausklang = waehle(phase('ausklang'));

    const kurz = Duration(seconds: 20);
    const atemPause = Duration(seconds: 40);
    var fest = d(ankommen) + kurz + d(atem) + atemPause + d(ausklang) + const Duration(seconds: 45) +
        const Duration(seconds: 5) * 2;
    final mitStille = [...reise, ...intim];
    for (final b in mitStille) {
      fest += d(b);
    }
    final rest = Duration(minutes: minuten) - fest;
    final stilleSek = (rest.inSeconds / mitStille.length).clamp(30, 300).round();

    final schritte = <PaarSchritt>[
      const PaarSchritt.klangschale(0),
      PaarSchritt.ansage(ankommen, d(ankommen), 0),
      const PaarSchritt.stille(kurz, 0),
      PaarSchritt.ansage(atem, d(atem), 0),
      const PaarSchritt.stille(atemPause, 0),
    ];
    for (final b in mitStille) {
      schritte.add(PaarSchritt.ansage(b, d(b), 1));
      if (stilleSek >= 100) {
        final erinnerung = waehle(phase('erinnerung'));
        final haelfte = Duration(seconds: (stilleSek - d(erinnerung).inSeconds) ~/ 2);
        schritte
          ..add(PaarSchritt.stille(haelfte, 1))
          ..add(PaarSchritt.ansage(erinnerung, d(erinnerung), 1))
          ..add(PaarSchritt.stille(haelfte, 1));
      } else {
        schritte.add(PaarSchritt.stille(Duration(seconds: stilleSek), 1));
      }
    }
    schritte
      ..add(PaarSchritt.ansage(ausklang, d(ausklang), 0))
      ..add(const PaarSchritt.stille(Duration(seconds: 45), 0))
      ..add(const PaarSchritt.klangschale(0));
    return schritte;
  }
}
