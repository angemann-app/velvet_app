import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../services/pakete.dart';
import '../services/sprache.dart';

/// Ein gesprochener Baustein aus assets/data/paar_abend.json.
class PaarBaustein {
  final String id;
  final String phase;
  final String text;
  final String? zone;
  final int stufe;
  final String? tiefe;

  /// 'vulva' oder 'penis' für körperspezifische Bausteine: bei der Selbsterkundung der eigene Körper,
  /// beim Gemeinsamen Abend der Körper der Person, die in der Runde empfängt.
  final String? koerper;

  const PaarBaustein({
    required this.id,
    required this.phase,
    required this.text,
    this.zone,
    this.stufe = 0,
    this.tiefe,
    this.koerper,
  });

  factory PaarBaustein.fromJson(Map<String, dynamic> json) => PaarBaustein(
        id: json['id'],
        phase: json['phase'],
        text: json['text'],
        zone: json['zone'],
        stufe: json['stufe'] ?? 0,
        tiefe: json['tiefe'],
        koerper: json['koerper'],
      );
}

/// Wie weit der Abend gehen darf. Jede Stufe schließt die vorherigen ein.
/// [spicy] und [sehrSpicy] (Dirty Talk) gibt es nur bei eingeschaltetem Spicy-Modus
/// (StorageService.spicyMode). Sie schließen die Stufen bis „intim“ ein, aber nicht einander.
enum PaarTiefe {
  bekleidet,
  haut,
  intim,
  spicy,
  sehrSpicy;

  bool get istSpicy => index >= spicy.index;
}

/// Die Stufen, die die Einrichtung anbietet: die Spicy-Stufen nur bei eingeschaltetem Spicy-Modus.
List<PaarTiefe> waehlbareTiefen({required bool spicyErlaubt}) =>
    [for (final t in PaarTiefe.values) if (!t.istSpicy || spicyErlaubt) t];

/// Gespeicherte Tiefe; eine Spicy-Stufe wird zu Intim, solange der Spicy-Modus aus ist.
PaarTiefe tiefeAusName(String? name, {required bool spicyErlaubt}) {
  final tiefe = PaarTiefe.values.asNameMap()[name] ?? PaarTiefe.bekleidet;
  return tiefe.istSpicy && !spicyErlaubt ? PaarTiefe.intim : tiefe;
}

/// Die Werte von `tiefe`, deren Berührungen bei [tiefe] vorkommen dürfen. Die Spicy-Stufen beginnen
/// gleich auf der Haut, damit genug Zeit für die heißen Teile bleibt.
Set<String> erlaubteTiefen(PaarTiefe tiefe) => {
      for (final t in PaarTiefe.values)
        if (t.istSpicy ? t == tiefe : (t.index <= tiefe.index && !(tiefe.istSpicy && t == PaarTiefe.bekleidet)))
          t.name,
    };

/// Bausteine einer Phase für die gewählte Tiefe. Bausteine einer Spicy-Stufe kommen nur bei genau dieser
/// Stufe vor; dort ersetzen sie die übrigen Varianten ihrer Phase, nur Berührungen und Erinnerungen mischen.
List<PaarBaustein> bausteineDerPhase(List<PaarBaustein> bausteine, String phase, PaarTiefe tiefe) {
  final spicyNamen = {for (final t in PaarTiefe.values) if (t.istSpicy) t.name};
  final alle = bausteine
      .where((b) => b.phase == phase && (!spicyNamen.contains(b.tiefe) || b.tiefe == tiefe.name))
      .toList();
  if (!tiefe.istSpicy || phase == 'beruehren' || phase == 'erinnerung') return alle;
  final scharf = alle.where((b) => b.tiefe == tiefe.name).toList();
  return scharf.isEmpty ? alle : scharf;
}

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
    final data = jsonDecode(await rootBundle.loadString(Sprache.inhalt('paar_abend.json')));
    Map<String, int> dauer = {};
    // Gemessene Längen der Aufnahmen: Deutsch aus der App, Englisch aus dem Audiopaket.
    // Fehlen sie (Englisch ohne Paket), wird aus der Textlänge geschätzt.
    try {
      final raw = jsonDecode(await _dauerText('audio/paar/dauer.json')) as Map;
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
  /// [empfaenger]: Körper der Person, die in Runde 1 bzw. 2 empfängt ('vulva', 'penis' oder null,
  /// wenn unbekannt). Körperspezifische Bausteine kommen nur in passenden Runden vor.
  List<PaarSchritt> planen({
    required int minuten,
    required PaarTiefe tiefe,
    required String stimme,
    Set<String> zuletzt = const {},
    List<String?> empfaenger = const [null, null],
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

    Iterable<PaarBaustein> phase(String p) => bausteineDerPhase(bausteine, p, tiefe);

    final erlaubt = erlaubteTiefen(tiefe);
    final zonen = <String, List<PaarBaustein>>{};
    for (final b in phase('beruehren').where((b) => erlaubt.contains(b.tiefe))) {
      zonen.putIfAbsent(b.zone!, () => []).add(b);
    }
    final proRunde = minuten >= 45 ? 7 : (minuten >= 30 ? 5 : 4);

    // Zonen nach Stufe ordnen (innerhalb einer Stufe zufällig) und gleichmäßig verteilt auswählen,
    // so dass jede Runde sanft beginnt und mit der tiefsten erlaubten Zone endet.
    Map<String, List<PaarBaustein>> zonenFuer(String? koerper) => {
          for (final e in zonen.entries)
            if (e.value.any((b) => b.koerper == null || b.koerper == koerper))
              e.key: [for (final b in e.value) if (b.koerper == null || b.koerper == koerper) b],
        };

    List<String> zonenFuerRunde(Map<String, List<PaarBaustein>> zonen, String? koerper) {
      // Zonen, deren Varianten in Runde 1 schon alle dran waren, nur nehmen, wenn sonst zu wenige bleiben.
      var namen = zonen.keys.where((z) => zonen[z]!.any((b) => !benutzt.contains(b.id))).toList();
      if (namen.length < proRunde) namen = zonen.keys.toList();
      namen.shuffle(rnd);
      int stufe(String z) => zonen[z]!.first.stufe;
      namen.sort((a, b) => stufe(a).compareTo(stufe(b)));
      var gewaehlt = namen.length <= proRunde
          ? namen
          : [for (var j = 0; j < proRunde; j++) namen[(j * (namen.length - 1) / (proRunde - 1)).round()]];
      // Bei Spicy bekommen die Brüste einer Frau immer ihren eigenen Moment.
      const brueste = 'brueste';
      if (tiefe.istSpicy && koerper == 'vulva' && zonen.containsKey(brueste) && !gewaehlt.contains(brueste)) {
        gewaehlt = [...gewaehlt];
        // Die tiefste Zone bleibt am Ende, ersetzt wird die davor.
        gewaehlt.length >= 2 ? gewaehlt[gewaehlt.length - 2] = brueste : gewaehlt.add(brueste);
        gewaehlt.sort((a, b) => stufe(a).compareTo(stufe(b)));
      }
      return gewaehlt;
    }

    // Erst alle Ansagen auswählen, dann die Stillen so verteilen, dass die Gesamtlänge stimmt.
    final ankommen = waehle(phase('ankommen'));
    final runden = <(PaarBaustein, List<PaarBaustein>, PaarBaustein, PaarBaustein)>[];
    for (var r = 0; r < 2; r++) {
      final start = waehle(phase('runde_start'));
      final koerper = r < empfaenger.length ? empfaenger[r] : null;
      final passend = zonenFuer(koerper);
      final beruehren = [for (final z in zonenFuerRunde(passend, koerper)) waehle(passend[z]!)];
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

/// Inhalt einer dauer.json in der aktuellen Sprache; wirft, wenn es keine gibt.
Future<String> _dauerText(String pfad) async {
  if (!Sprache.englisch) return rootBundle.loadString('assets/$pfad');
  final datei = Pakete.datei(pfad);
  if (datei == null) throw StateError('kein englisches Audiopaket');
  return File(datei).readAsString();
}
