import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../services/pakete.dart';
import 'einschlaf_reise.dart';
import 'paar_abend.dart';
import 'traum_reise.dart';

/// Ein Baustein der Serie „Lust im Traum“ (docs/konzepte/lust-im-traum.md). Texte und Aufnahmen kommen nur
/// aus dem Paket `<sprache>-lust` (lust/lust.json, audio/lust/), nie aus der App.
class LustBaustein {
  final String id;
  final String phase; // 'folge' | 'uebergang'
  final String text;
  final int? folge;
  final String? koerper; // 'vulva' | 'penis'
  final String? teil; // v1 | v2 | v3 | f | tag
  final String? gegenueber; // niemand | frau | mann | offen (ab Folge 3)

  const LustBaustein({
    required this.id,
    required this.phase,
    required this.text,
    this.folge,
    this.koerper,
    this.teil,
    this.gegenueber,
  });

  factory LustBaustein.fromJson(Map<String, dynamic> json) => LustBaustein(
        id: json['id'],
        phase: json['phase'],
        text: json['text'],
        folge: json['folge'],
        koerper: json['koerper'],
        teil: json['teil'],
        gegenueber: json['gegenueber'],
      );

  PaarBaustein get alsPaar => PaarBaustein(id: id, phase: phase, text: text, koerper: koerper);
}

class LustDaten {
  static const folgen = 8;
  static const laengen = [30, 45, 60];
  static const gegenuebers = ['niemand', 'frau', 'mann', 'offen'];

  /// Ab dieser Folge sind Traumkörper und Gegenüber wählbar.
  static const abFolgeTraumkoerper = 3;

  /// So viele gehörte Abende schalten die nächste Folge frei.
  static const abendeFuerNaechste = 2;

  final List<LustBaustein> bausteine;
  final Map<String, int> dauerMs;
  final Map<String, LustBaustein> _nachId;

  LustDaten(this.bausteine, this.dauerMs) : _nachId = {for (final b in bausteine) b.id: b};

  /// Null, solange das Paket fehlt.
  static Future<LustDaten?> laden() async {
    final texte = Pakete.datei('lust/lust.json');
    if (texte == null) return null;
    try {
      final data = jsonDecode(await File(texte).readAsString()) as Map;
      Map<String, int> dauer = {};
      final d = Pakete.datei('audio/lust/dauer.json');
      if (d != null) {
        dauer = (jsonDecode(await File(d).readAsString()) as Map).map((k, v) => MapEntry(k as String, v as int));
      }
      return LustDaten([for (final b in data['bausteine'] as List) LustBaustein.fromJson(b)], dauer);
    } catch (_) {
      return null;
    }
  }

  bool istLust(String id) => _nachId.containsKey(id);

  /// Die Übung für den Tag zu einer Folge.
  String? tag(int folge, String koerper) => _nachId['f${folge}_${koerper}_tag']?.text;

  /// Ist die Folge frei? Folge 1 immer; sonst nach [abendeFuerNaechste] Abenden der vorigen, oder wenn eine
  /// spätere schon gehört wurde.
  static bool frei(int folge, Map<int, int> fortschritt) {
    if (folge <= 1) return true;
    if ((fortschritt[folge - 1] ?? 0) >= abendeFuerNaechste) return true;
    return fortschritt.entries.any((e) => e.key >= folge && e.value > 0);
  }

  Duration dauerVon(LustBaustein b, String stimme) {
    final ms = dauerMs['${stimme}_${b.id}'];
    if (ms != null) return Duration(milliseconds: ms);
    final absaetze = b.text.split('\n').where((a) => a.trim().isNotEmpty).length;
    return Duration(milliseconds: (b.text.length / 10 * 1000).round() + (absaetze - 1).clamp(0, 99).toInt() * 1500);
  }

  /// Ein Abend: Ankommen und Atem aus der Einschlaf-Reise, Sinken aus der Traum-Reise, ab Folge 3 bei
  /// anderem Traumkörper ein Übergang, dann die Folge (lang, mittel, kurz, Absicht) und ein Nachklang aus der
  /// Absicht mit immer längeren Pausen, am Ende Stille.
  List<PaarSchritt> planen({
    required EinschlafDaten einschlaf,
    TraumDaten? traum,
    required int minuten,
    required int folge,
    required String bettKoerper,
    String? traumKoerper,
    String gegenueber = 'niemand',
    required String stimme,
    Set<String> zuletzt = const {},
    Random? zufall,
  }) {
    final rnd = zufall ?? Random();
    final gesamt = Duration(minutes: minuten);
    final traumteil = folge >= abFolgeTraumkoerper;
    final koerper = traumteil ? (traumKoerper ?? bettKoerper) : bettKoerper;
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

    void lustBaustein(LustBaustein b, Duration pause) {
      sprich(b.alsPaar, dauerVon(b, stimme));
      stille(pause);
    }

    einschlafPhase('ankommen', 0.08);
    final sinken = (traum?.bausteine.where((b) => b.phase == 'sinken').toList() ?? [])..shuffle(rnd);
    if (sinken.isNotEmpty) {
      final s = sinken.first;
      sprich(s.alsPaar, traum!.dauerVon(s, stimme));
      stille(begrenzt(anteil(0.12) - traum.dauerVon(s, stimme), 20, 600));
    }
    einschlafPhase('atem', 0.06);

    if (traumteil && koerper != bettKoerper) {
      final uebergaenge = bausteine.where((b) => b.phase == 'uebergang' && b.koerper == koerper).toList()
        ..shuffle(rnd);
      if (uebergaenge.isNotEmpty) lustBaustein(uebergaenge.first, const Duration(seconds: 30));
    }

    final mitGegenueber = traumteil && gegenueber != 'niemand';
    final teile = [
      (mitGegenueber ? _nachId['f${folge}_${koerper}_${gegenueber}_v1'] : null) ?? _nachId['f${folge}_${koerper}_v1'],
      _nachId['f${folge}_${koerper}_v2'],
      _nachId['f${folge}_${koerper}_v3'],
    ].whereType<LustBaustein>().toList();
    final absicht = _nachId['f${folge}_${koerper}_f'];
    var sprechen = Duration.zero;
    for (final b in teile) {
      sprechen += dauerVon(b, stimme);
    }
    final pause = begrenzt((anteil(0.40) - sprechen) ~/ (teile.length + 1), 30, 420);
    for (final b in teile) {
      lustBaustein(b, pause);
    }
    if (absicht != null) {
      lustBaustein(absicht, pause);
      // Nachklang: nur noch die Absicht, mit immer längeren Pausen.
      final ende = vergangen + anteil(0.26);
      for (var i = 0;; i++) {
        final p = begrenzt(Duration(seconds: (60 * pow(1.2, i)).round()), 60, 360);
        if (i >= 2 && vergangen + dauerVon(absicht, stimme) + p > ende) break;
        lustBaustein(absicht, p);
      }
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
