import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

import '../services/pakete.dart';
import '../services/sprache.dart';
import 'einschlaf_reise.dart';
import 'paar_abend.dart';

/// Ein gesprochener Baustein aus assets/data/traum_reise.json.
class TraumBaustein {
  final String id;
  final String phase;
  final String text;

  /// Traumbild und Teil ('v1' lang, 'v2' mittel, 'v3' kurz, 'f' Absicht) der Traumbild-Bausteine.
  final String? bild;
  final String? teil;

  /// 'spicy' mit [koerper] 'vulva' oder 'penis' für die deutlicheren Fassungen.
  final String? stufe;
  final String? koerper;

  const TraumBaustein({
    required this.id,
    required this.phase,
    required this.text,
    this.bild,
    this.teil,
    this.stufe,
    this.koerper,
  });

  factory TraumBaustein.fromJson(Map<String, dynamic> json) => TraumBaustein(
        id: json['id'],
        phase: json['phase'],
        text: json['text'],
        bild: json['bild'],
        teil: json['teil'],
        stufe: json['stufe'],
        koerper: json['koerper'],
      );

  PaarBaustein get alsPaar => PaarBaustein(id: id, phase: phase, text: text, koerper: koerper);
}

/// Traum-Abend (erster Teil der Traum-Reise, docs/konzepte/traum-reise.md): Ankommen und Atem aus der
/// Einschlaf-Reise, dann Sinken in den Traum, ein gewähltes Traumbild in drei Fassungen, die Traum-Absicht und ein
/// Nachklang aus Absichten mit immer längeren Pausen, am Ende Stille. Die Aufnahmen liegen in audio/traum/
/// (Traum-Bausteine) bzw. audio/einschlaf/ (übernommene Bausteine); welche wohin gehört, sagt [istTraum].
class TraumDaten {
  /// Die Traumbilder in der Reihenfolge der Anzeige.
  static const bilder = ['warmes_wasser', 'ort_fuer_mich', 'koerper_im_licht', 'begegnung', 'klarheit'];
  static const laengen = [30, 45, 60];

  final List<TraumBaustein> bausteine;
  final Map<String, int> dauerMs;
  final Map<String, TraumBaustein> _nachId;

  TraumDaten(this.bausteine, this.dauerMs) : _nachId = {for (final b in bausteine) b.id: b};

  static Future<TraumDaten> laden() async {
    final data = jsonDecode(await rootBundle.loadString(Sprache.inhalt('traum_reise.json')));
    Map<String, int> dauer = {};
    try {
      final raw = jsonDecode(await _dauerText('audio/traum/dauer.json')) as Map;
      dauer = raw.map((k, v) => MapEntry(k as String, v as int));
    } catch (_) {}
    return TraumDaten((data['bausteine'] as List).map((b) => TraumBaustein.fromJson(b)).toList(), dauer);
  }

  /// Gehört die Aufnahme zu audio/traum/ (sonst audio/einschlaf/)?
  bool istTraum(String id) => _nachId.containsKey(id);

  /// Text eines Hinweises (phase 'hinweis'), z. B. 'hinweis_einstieg', oder null.
  String? hinweis(String id) => _nachId[id]?.text;

  Duration dauerVon(TraumBaustein b, String stimme) {
    final ms = dauerMs['${stimme}_${b.id}'];
    if (ms != null) return Duration(milliseconds: ms);
    final absaetze = b.text.split('\n').where((a) => a.trim().isNotEmpty).length;
    return Duration(milliseconds: (b.text.length / 10 * 1000).round() + (absaetze - 1).clamp(0, 99).toInt() * 1500);
  }

  /// [bild] null heißt „Überrasch mich“. Spicy-Fassungen nur mit [spicy] und Körper 'vulva' oder 'penis'.
  List<PaarSchritt> planen({
    required EinschlafDaten einschlaf,
    required int minuten,
    String? bild,
    String koerper = 'neutral',
    bool spicy = false,
    required String stimme,
    Set<String> zuletzt = const {},
    Random? zufall,
  }) {
    final rnd = zufall ?? Random();
    final gesamt = Duration(minutes: minuten);
    final gewaehlt = bild ??
        (() {
          final frisch = bilder.where((b) => !zuletzt.contains('${b}_v1')).toList();
          final pool = frisch.isEmpty ? bilder : frisch;
          return pool[rnd.nextInt(pool.length)];
        })();

    final schritte = <PaarSchritt>[];
    var vergangen = Duration.zero;
    Duration anteil(double a) => Duration(seconds: (gesamt.inSeconds * a).round());
    Duration begrenzt(Duration x, int min, int max) => Duration(seconds: x.inSeconds.clamp(min, max).toInt());
    void stille(Duration x) {
      schritte.add(PaarSchritt.stille(x, 0));
      vergangen += x;
    }

    void sprich(PaarBaustein b, Duration d) {
      schritte.add(PaarSchritt.ansage(b, d, 0));
      vergangen += d;
    }

    // Aus der Einschlaf-Reise: Ankommen und Atem.
    EinschlafBaustein? ausEinschlaf(String phase) {
      final alle = einschlaf.bausteine.where((b) => b.phase == phase).toList();
      if (alle.isEmpty) return null;
      final frisch = alle.where((b) => !zuletzt.contains(b.id)).toList();
      final pool = frisch.isEmpty ? alle : frisch;
      return pool[rnd.nextInt(pool.length)];
    }

    void einschlafPhase(String phase, double a) {
      final b = ausEinschlaf(phase);
      if (b == null) return;
      final d = einschlaf.dauerVon(b, stimme);
      sprich(b.alsPaar, d);
      stille(begrenzt(anteil(a) - d, 20, 600));
    }

    void traumBaustein(TraumBaustein b, Duration pause) {
      sprich(b.alsPaar, dauerVon(b, stimme));
      stille(pause);
    }

    einschlafPhase('ankommen', 0.08);
    final sinken = bausteine.where((b) => b.phase == 'sinken').toList()..shuffle(rnd);
    if (sinken.isNotEmpty) traumBaustein(sinken.first, begrenzt(anteil(0.12) - dauerVon(sinken.first, stimme), 20, 600));
    einschlafPhase('atem', 0.06);

    // Traumbild: lang, mittel, kurz; im Spicy-Modus die deutlichere Fassung zwischen lang und mittel.
    final teile = [
      _nachId['${gewaehlt}_v1'],
      if (spicy && koerper != 'neutral') _nachId['${gewaehlt}_s_$koerper'],
      _nachId['${gewaehlt}_v2'],
      _nachId['${gewaehlt}_v3'],
    ].whereType<TraumBaustein>().toList();
    final absicht = _nachId['${gewaehlt}_f'];
    final allgemein = bausteine.where((b) => b.phase == 'absicht').toList();
    final budget = anteil(0.40);
    var sprechen = Duration.zero;
    for (final b in teile) {
      sprechen += dauerVon(b, stimme);
    }
    final pause = begrenzt((budget - sprechen) ~/ (teile.length + 1), 30, 420);
    for (final b in teile) {
      traumBaustein(b, pause);
    }
    if (absicht != null) traumBaustein(absicht, pause);

    // Nachklang: nur noch Absichten, mit immer längeren Pausen.
    final formeln = [if (absicht != null) absicht, ...allgemein];
    final ende = vergangen + anteil(0.26);
    var i = 0;
    while (formeln.isNotEmpty) {
      final b = formeln[i % formeln.length];
      final p = begrenzt(Duration(seconds: (60 * pow(1.2, i)).round()), 60, 360);
      if (i >= 2 && vergangen + dauerVon(b, stimme) + p > ende) break;
      traumBaustein(b, p);
      i++;
    }
    final ausklang = ausEinschlaf('ausklang');
    if (ausklang != null) {
      sprich(ausklang.alsPaar, einschlaf.dauerVon(ausklang, stimme));
      stille(const Duration(seconds: 20));
    }
    final rest = gesamt - vergangen;
    stille(rest < const Duration(minutes: 4) ? const Duration(minutes: 4) : rest);
    return schritte;
  }
}

Future<String> _dauerText(String pfad) async {
  if (!Sprache.englisch) return rootBundle.loadString('assets/$pfad');
  final datei = Pakete.datei(pfad);
  if (datei == null) throw StateError('kein englisches Audiopaket');
  return File(datei).readAsString();
}
