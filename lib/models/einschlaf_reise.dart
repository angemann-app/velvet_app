import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

import '../services/sprachausgabe.dart';
import '../services/sprache.dart';
import 'paar_abend.dart';

/// Ein gesprochener Baustein aus assets/data/einschlaf_reise.json.
class EinschlafBaustein {
  final String id;
  final String phase;
  final String text;

  /// Schwerpunkt, Bogen (1 bis 3) und Teil ('v1' | 'v2' | 'v3' | 'f' | 's1' | 's2') der Lernbausteine.
  final String? thema;
  final int? bogen;
  final String? teil;

  /// 'vulva' oder 'penis' bei den Spicy-Bausteinen.
  final String? koerper;

  const EinschlafBaustein({
    required this.id,
    required this.phase,
    required this.text,
    this.thema,
    this.bogen,
    this.teil,
    this.koerper,
  });

  factory EinschlafBaustein.fromJson(Map<String, dynamic> json) => EinschlafBaustein(
        id: json['id'],
        phase: json['phase'],
        text: json['text'],
        thema: json['thema'],
        bogen: json['bogen'],
        teil: json['teil'],
        koerper: json['koerper'],
      );

  PaarBaustein get alsPaar => PaarBaustein(id: id, phase: phase, text: text, koerper: koerper);
}

/// Einschlaf-Reise: eine lange geführte Meditation zum Einschlafen. Aus den Bausteinen wird jedes Mal eine
/// neue Reise geplant: Ankommen, Sinken, Atem, mehrere Lernrunden zu einem Schwerpunkt, ein Nachklang aus
/// Kurzformeln und am Ende Stille. Die Sprechdichte nimmt stetig ab (Konzept: docs/konzepte/einschlaf-reise.md).
class EinschlafDaten {
  /// Die wählbaren Schwerpunkte in der Reihenfolge der Anzeige.
  static const themen = ['koerper', 'welle', 'gaspedal', 'spueren', 'becken', 'geniessen'];
  static const laengen = [60, 90, 120];

  final List<EinschlafBaustein> bausteine;

  /// Echte Länge jeder Aufnahme in ms, Schlüssel "<stimme>_<id>" (tools/generate_audio.py --einschlaf).
  final Map<String, int> dauerMs;

  final Map<String, EinschlafBaustein> _nachId;

  EinschlafDaten(this.bausteine, this.dauerMs) : _nachId = {for (final b in bausteine) b.id: b};

  static Future<EinschlafDaten> laden() async {
    final data = jsonDecode(await rootBundle.loadString(Sprache.inhalt('einschlaf_reise.json')));
    Map<String, int> dauer = {};
    // Gemessene Längen der Aufnahmen: Deutsch aus der App, Englisch aus dem Audiopaket.
    // Fehlen sie (Englisch ohne Paket), wird aus der Textlänge geschätzt.
    try {
      final raw = jsonDecode(await _dauerText('audio/einschlaf/dauer.json')) as Map;
      dauer = raw.map((k, v) => MapEntry(k as String, v as int));
    } catch (_) {}
    return EinschlafDaten(
      (data['bausteine'] as List).map((b) => EinschlafBaustein.fromJson(b)).toList(),
      dauer,
    );
  }

  Duration dauerVon(EinschlafBaustein b, String stimme) {
    final ms = dauerMs['${stimme}_${b.id}'];
    if (ms != null) return Duration(milliseconds: ms);
    // Grobe Schätzung bei langsamem Sprechtempo: etwa zehn Zeichen pro Sekunde, 1,5 s zwischen Absätzen.
    final absaetze = b.text.split('\n').where((a) => a.trim().isNotEmpty).length;
    return Duration(milliseconds: (b.text.length / 10 * 1000).round() + (absaetze - 1).clamp(0, 99).toInt() * 1500);
  }

  /// Anzahl der Lernrunden je Länge.
  static int runden(int minuten) => minuten >= 120 ? 5 : (minuten >= 90 ? 4 : 3);

  /// Welche Fassung in Runde [runde] (ab 1) gesprochen wird: lang, dann mittel, dann kurz.
  static String fassung(int runde) => const ['v1', 'v2', 'v3', 'v2', 'v3'][(runde - 1).clamp(0, 4)];

  /// [thema] null heißt „Überrasch mich“. [koerper]: 'vulva', 'penis' oder 'neutral'; Spicy-Bausteine gibt es
  /// nur für die beiden ersten, und nur wenn [spicy] gesetzt ist (Spicy-Modus der App).
  List<PaarSchritt> planen({
    required int minuten,
    String? thema,
    String koerper = 'neutral',
    bool spicy = false,
    required String stimme,
    Set<String> zuletzt = const {},
    Random? zufall,
  }) {
    final rnd = zufall ?? Random();
    final gesamt = Duration(minutes: minuten);
    final mitSpicy = spicy && koerper != 'neutral';

    EinschlafBaustein? waehle(String phase) {
      final alle = bausteine.where((b) => b.phase == phase).toList();
      if (alle.isEmpty) return null;
      final frisch = alle.where((b) => !zuletzt.contains(b.id)).toList();
      final pool = frisch.isEmpty ? alle : frisch;
      return pool[rnd.nextInt(pool.length)];
    }

    // Die drei Bögen der Reise: bei einem Schwerpunkt dessen drei Bögen der Reihe nach,
    // bei „Überrasch mich“ je ein Bogen aus drei verschiedenen Schwerpunkten.
    final bogenIds = <(String, int)>[];
    if (thema != null) {
      for (var b = 1; b <= 3; b++) {
        bogenIds.add((thema, b));
      }
    } else {
      final mischen = [...themen]..shuffle(rnd);
      for (final t in mischen.take(3)) {
        final frisch = [1, 2, 3].where((b) => !zuletzt.contains('${t}_${b}_f')).toList();
        bogenIds.add((t, (frisch.isEmpty ? [1, 2, 3] : frisch)[rnd.nextInt(frisch.isEmpty ? 3 : frisch.length)]));
      }
    }
    EinschlafBaustein? teil(String t, int b, String v) => _nachId['${t}_${b}_$v'];
    final bogenFormeln = [for (final (t, b) in bogenIds) teil(t, b, 'f')].whereType<EinschlafBaustein>().toList();

    Duration d(EinschlafBaustein b) => dauerVon(b, stimme);
    Duration anteil(double a) => Duration(seconds: (gesamt.inSeconds * a).round());
    Duration begrenzt(Duration x, int min, int max) =>
        Duration(seconds: x.inSeconds.clamp(min, max).toInt());
    final schritte = <PaarSchritt>[];
    var vergangen = Duration.zero;
    void ansage(EinschlafBaustein b) {
      schritte.add(PaarSchritt.ansage(b.alsPaar, d(b), 0));
      vergangen += d(b);
    }

    void stille(Duration x) {
      schritte.add(PaarSchritt.stille(x, 0));
      vergangen += x;
    }

    // Phasen mit einem Baustein und einer Stille, die das Zeitbudget der Phase füllt.
    void phase(String name, double a) {
      final b = waehle(name);
      if (b == null) return;
      final budget = anteil(a);
      ansage(b);
      stille(begrenzt(budget - d(b), 20, 900));
    }

    phase('ankommen', 0.07);
    phase('sinken', 0.13);
    phase('atem', 0.06);

    // Lernrunden: dieselben Bögen in kürzerer Fassung, dazwischen kurz Sinken und Atem.
    final n = runden(minuten);
    final rundeBudget = anteil(0.40) ~/ n;
    for (var r = 1; r <= n; r++) {
      final folge = <(EinschlafBaustein, double)>[]; // Baustein und Gewicht der Stille danach
      var feste = Duration.zero;
      final v = fassung(r);
      if (r > 1) {
        final sk = waehle('sinken_kurz');
        final ak = waehle('atem_kurz');
        if (sk != null) {
          folge.add((sk, 0));
          feste += const Duration(seconds: 45);
        }
        if (ak != null) {
          folge.add((ak, 0));
          feste += const Duration(seconds: 30);
        }
      }
      for (final (t, b) in bogenIds) {
        final text = teil(t, b, v) ?? teil(t, b, 'v1');
        final formel = teil(t, b, 'f');
        if (text != null) folge.add((text, 0.6));
        if (formel != null) folge.add((formel, 1.4));
      }
      if (mitSpicy && bogenIds.isNotEmpty) {
        final t = bogenIds[(r - 1) % bogenIds.length].$1;
        final s = _nachId['${t}_s_${koerper}_${r.isOdd ? 1 : 2}'];
        if (s != null) folge.add((s, 1.0));
      }
      var sprechen = Duration.zero;
      var gewicht = 0.0;
      for (final (b, w) in folge) {
        sprechen += d(b);
        gewicht += w;
      }
      final frei = rundeBudget - sprechen - feste;
      final einheit = gewicht == 0 ? 0.0 : frei.inSeconds / gewicht;
      for (final (b, w) in folge) {
        ansage(b);
        if (w == 0) {
          // Sinken und Atem zwischen den Bögen: feste kurze Pausen
          stille(Duration(seconds: b.phase == 'sinken_kurz' ? 45 : 30));
        } else {
          stille(begrenzt(Duration(seconds: (einheit * w).round()), 20, 420));
        }
      }
    }

    // Nachklang: nur noch die Kurzformeln, ab und zu ein stützender Satz, mit immer längeren Pausen.
    final nachklangBudget = anteil(0.26);
    final ausklang = waehle('ausklang');
    final stuetzen = (bausteine.where((b) => b.phase == 'nachklang_stuetze').toList()..shuffle(rnd));
    final ende = vergangen + nachklangBudget;
    var i = 0;
    var formel = 0;
    var stuetze = 0;
    while (bogenFormeln.isNotEmpty) {
      final istStuetze = stuetzen.isNotEmpty && i % 4 == 3;
      final b = istStuetze ? stuetzen[stuetze++ % stuetzen.length] : bogenFormeln[formel++ % bogenFormeln.length];
      final pause = begrenzt(Duration(seconds: (60 * pow(1.18, i)).round()), 60, 330);
      if (i >= 3 && vergangen + d(b) + pause > ende) break;
      ansage(b);
      stille(pause);
      i++;
    }
    if (ausklang != null) {
      ansage(ausklang);
      stille(const Duration(seconds: 20));
    }

    // Stille bis zum Ende; der Klangteppich blendet währenddessen aus. Mindestens vier Minuten.
    final rest = gesamt - vergangen;
    stille(rest < const Duration(minutes: 4) ? const Duration(minutes: 4) : rest);
    return schritte;
  }
}

/// Inhalt einer dauer.json in der aktuellen Sprache; wirft, wenn es keine gibt.
Future<String> _dauerText(String pfad) async {
  if (!Sprache.englisch) return rootBundle.loadString('assets/$pfad');
  final datei = AudioPaket.datei(pfad);
  if (datei == null) throw StateError('kein englisches Audiopaket');
  return File(datei).readAsString();
}
