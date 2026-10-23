import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

/// Ein gesprochener Baustein aus assets/data/paar_abend.json.
class PaarBaustein {
  final String id;
  final String phase;
  final String text;
  final String? zone;
  final int stufe;
  final String? tiefe;

  const PaarBaustein({
    required this.id,
    required this.phase,
    required this.text,
    this.zone,
    this.stufe = 0,
    this.tiefe,
  });

  factory PaarBaustein.fromJson(Map<String, dynamic> json) => PaarBaustein(
        id: json['id'],
        phase: json['phase'],
        text: json['text'],
        zone: json['zone'],
        stufe: json['stufe'] ?? 0,
        tiefe: json['tiefe'],
      );
}

/// Wie weit der Abend gehen darf. Jede Stufe schließt die vorherigen ein.
enum PaarTiefe { bekleidet, haut, intim }

/// Ein Schritt im Ablauf: Ansage, Stille oder Klangschale.
class PaarSchritt {
  final PaarBaustein? baustein;
  final Duration dauer;
  final bool klang;

  /// 1 oder 2 während einer Runde, sonst 0. Daraus zeigt die App, wer gerade gibt.
  final int runde;

  const PaarSchritt.ansage(PaarBaustein this.baustein, this.dauer, this.runde) : klang = false;
  const PaarSchritt.stille(this.dauer, this.runde)
      : baustein = null,
        klang = false;
  const PaarSchritt.klangschale(this.runde)
      : baustein = null,
        dauer = const Duration(seconds: 5),
        klang = true;
}

class PaarAbendDaten {
  final List<PaarBaustein> bausteine;

  /// Echte Länge jeder Aufnahme in ms, Schlüssel "<stimme>_<id>" (von tools/generate_audio.py --paar).
  final Map<String, int> dauerMs;

  const PaarAbendDaten(this.bausteine, this.dauerMs);

  static Future<PaarAbendDaten> laden() async {
    final data = jsonDecode(await rootBundle.loadString('assets/data/paar_abend.json'));
    Map<String, int> dauer = {};
    try {
      final raw = jsonDecode(await rootBundle.loadString('assets/audio/paar/dauer.json')) as Map;
      dauer = raw.map((k, v) => MapEntry(k as String, v as int));
    } catch (_) {
      // Ohne Längenliste wird aus der Textlänge geschätzt.
    }
    return PaarAbendDaten(
      (data['bausteine'] as List).map((b) => PaarBaustein.fromJson(b)).toList(),
      dauer,
    );
  }

  Duration dauerVon(PaarBaustein b, String stimme) {
    final ms = dauerMs['${stimme}_${b.id}'];
    // Kokoro spricht bei Tempo 0,9 etwa 13 Zeichen pro Sekunde.
    return Duration(milliseconds: ms ?? (b.text.length / 13 * 1000).round());
  }

  /// Stellt einen Abend zusammen, der möglichst genau [minuten] lang ist.
  /// [zuletzt] sind die zuletzt gehörten Baustein-ids; sie kommen nur dran, wenn es nicht anders geht.
  List<PaarSchritt> planen({
    required int minuten,
    required PaarTiefe tiefe,
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

    final erlaubt = PaarTiefe.values.sublist(0, tiefe.index + 1).map((t) => t.name).toSet();
    final zonen = <String, List<PaarBaustein>>{};
    for (final b in phase('beruehren').where((b) => erlaubt.contains(b.tiefe))) {
      zonen.putIfAbsent(b.zone!, () => []).add(b);
    }
    final proRunde = minuten >= 45 ? 7 : (minuten >= 30 ? 5 : 4);

    // Zonen nach Stufe ordnen (innerhalb einer Stufe zufällig) und gleichmäßig verteilt auswählen,
    // so dass jede Runde sanft beginnt und mit der tiefsten erlaubten Zone endet.
    List<String> zonenFuerRunde() {
      // Zonen, deren Varianten in Runde 1 schon alle dran waren, nur nehmen, wenn sonst zu wenige bleiben.
      var namen = zonen.keys.where((z) => zonen[z]!.any((b) => !benutzt.contains(b.id))).toList();
      if (namen.length < proRunde) namen = zonen.keys.toList();
      namen.shuffle(rnd);
      int stufe(String z) => zonen[z]!.first.stufe;
      namen.sort((a, b) => stufe(a).compareTo(stufe(b)));
      if (namen.length <= proRunde) return namen;
      return [for (var j = 0; j < proRunde; j++) namen[(j * (namen.length - 1) / (proRunde - 1)).round()]];
    }

    // Erst alle Ansagen auswählen, dann die Stillen so verteilen, dass die Gesamtlänge stimmt.
    final ankommen = waehle(phase('ankommen'));
    final runden = <(PaarBaustein, List<PaarBaustein>, PaarBaustein, PaarBaustein)>[];
    for (var r = 0; r < 2; r++) {
      final start = waehle(phase('runde_start'));
      final beruehren = [for (final z in zonenFuerRunde()) waehle(zonen[z]!)];
      runden.add((start, beruehren, waehle(phase('check_in')), waehle(phase('runde_ende'))));
    }
    final wechsel = waehle(phase('wechsel'));
    final ausklang = waehle(phase('ausklang'));

    Duration d(PaarBaustein b) => dauerVon(b, stimme);
    const atem = Duration(seconds: 40);
    const kurz = Duration(seconds: 20);
    var fest = d(ankommen) + atem + d(wechsel) + atem + d(ausklang) + const Duration(seconds: 60) +
        const Duration(seconds: 5) * 5; // Klangschalen
    var zonenAnzahl = 0;
    for (final (start, beruehren, check, ende) in runden) {
      fest += d(start) + kurz + d(check) + kurz + d(ende) + kurz;
      for (final b in beruehren) {
        fest += d(b);
        zonenAnzahl++;
      }
    }
    final rest = Duration(minutes: minuten) - fest;
    final stilleSek = (rest.inSeconds / zonenAnzahl).clamp(40, 300).round();

    final schritte = <PaarSchritt>[
      PaarSchritt.ansage(ankommen, d(ankommen), 0),
      const PaarSchritt.stille(atem, 0),
    ];
    for (var r = 0; r < runden.length; r++) {
      final (start, beruehren, check, ende) = runden[r];
      final runde = r + 1;
      schritte
        ..add(PaarSchritt.klangschale(runde))
        ..add(PaarSchritt.ansage(start, d(start), runde))
        ..add(PaarSchritt.stille(kurz, runde));
      for (var i = 0; i < beruehren.length; i++) {
        final b = beruehren[i];
        schritte.add(PaarSchritt.ansage(b, d(b), runde));
        // Lange Stillen bekommen in der Mitte eine kurze Erinnerung, damit niemand sich verloren fühlt.
        if (stilleSek >= 100) {
          final erinnerung = waehle(phase('erinnerung'));
          final haelfte = Duration(seconds: (stilleSek - d(erinnerung).inSeconds) ~/ 2);
          schritte
            ..add(PaarSchritt.stille(haelfte, runde))
            ..add(PaarSchritt.ansage(erinnerung, d(erinnerung), runde))
            ..add(PaarSchritt.stille(haelfte, runde));
        } else {
          schritte.add(PaarSchritt.stille(Duration(seconds: stilleSek), runde));
        }
        if (i == beruehren.length ~/ 2 - 1) {
          schritte
            ..add(PaarSchritt.ansage(check, d(check), runde))
            ..add(PaarSchritt.stille(kurz, runde));
        }
      }
      schritte
        ..add(PaarSchritt.ansage(ende, d(ende), runde))
        ..add(PaarSchritt.stille(kurz, runde));
      if (r == 0) {
        schritte
          ..add(const PaarSchritt.klangschale(0))
          ..add(PaarSchritt.ansage(wechsel, d(wechsel), 0))
          ..add(const PaarSchritt.stille(atem, 0));
      }
    }
    schritte
      ..add(const PaarSchritt.klangschale(0))
      ..add(PaarSchritt.ansage(ausklang, d(ausklang), 0))
      ..add(const PaarSchritt.stille(Duration(seconds: 60), 0))
      ..add(const PaarSchritt.klangschale(0));
    return schritte;
  }
}
