import 'dart:convert';
import 'dart:io';

import '../services/pakete.dart';

/// Eine Szene des gemeinsamen Szenenbuchs einer Folge. Die ID bleibt in allen korrespondierenden Fassungen
/// gleich (docs/konzepte/lust-audioreihe.md, „Gemeinsame Szenen-IDs“).
class ReiheSzene {
  final String id;
  final String beschreibung;

  /// Produktionsziel in Sekunden seit Beginn (Synchronisationsmarke), keine Pause im Audio.
  final int start;
  final int ende;

  const ReiheSzene({required this.id, required this.beschreibung, required this.start, required this.ende});

  factory ReiheSzene.fromJson(Map<String, dynamic> j) => ReiheSzene(
        id: j['id'] as String,
        beschreibung: (j['beschreibung'] as String?) ?? '',
        start: j['start'] as int,
        ende: j['ende'] as int,
      );
}

/// Der Text einer Szene aus einer Perspektive. Eine Aufnahme je Segment, ohne künstliche Stille dazwischen.
class ReiheSegment {
  final String szene;
  final String text;

  const ReiheSegment({required this.szene, required this.text});

  factory ReiheSegment.fromJson(Map<String, dynamic> j) =>
      ReiheSegment(szene: j['szene'] as String, text: j['text'] as String);
}

/// Eine Fassung: Variante (soft | spicy) und Perspektive (z. B. frau | mann) einer Folge.
class ReiheFassung {
  final String id;
  final String variante;
  final String perspektive;
  final String stimme;
  final List<ReiheSegment> segmente;

  const ReiheFassung({
    required this.id,
    required this.variante,
    required this.perspektive,
    required this.stimme,
    required this.segmente,
  });

  bool get spicy => variante == 'spicy';

  factory ReiheFassung.fromJson(Map<String, dynamic> j) => ReiheFassung(
        id: j['id'] as String,
        variante: j['variante'] as String,
        perspektive: j['perspektive'] as String,
        stimme: j['stimme'] as String,
        segmente: [for (final s in j['segmente'] as List) ReiheSegment.fromJson(s as Map<String, dynamic>)],
      );
}

/// Eine Folge der Reihe, z. B. „Zwischen Frau und Mann“, mit Szenenbuch und allen Fassungen.
class ReiheFolge {
  final String id;
  final String typ;
  final String titel;
  final String beschreibung;
  final List<ReiheSzene> szenen;
  final List<ReiheFassung> fassungen;

  const ReiheFolge({
    required this.id,
    required this.typ,
    required this.titel,
    required this.beschreibung,
    required this.szenen,
    required this.fassungen,
  });

  factory ReiheFolge.fromJson(Map<String, dynamic> j) => ReiheFolge(
        id: j['id'] as String,
        typ: j['typ'] as String,
        titel: j['titel'] as String,
        beschreibung: (j['beschreibung'] as String?) ?? '',
        szenen: [for (final s in j['szenen'] as List) ReiheSzene.fromJson(s as Map<String, dynamic>)],
        fassungen: [for (final f in j['fassungen'] as List) ReiheFassung.fromJson(f as Map<String, dynamic>)],
      );

  /// Varianten dieser Folge; Spicy nur, wenn [spicyErlaubt].
  List<String> varianten({required bool spicyErlaubt}) {
    final alle = <String>{for (final f in fassungen) f.variante};
    return [
      for (final v in const ['soft', 'spicy'])
        if (alle.contains(v) && (v != 'spicy' || spicyErlaubt)) v
    ];
  }

  List<ReiheFassung> fassungenVon(String variante) => [for (final f in fassungen) if (f.variante == variante) f];

  /// Die zusammengehörende Fassung derselben Begegnung (gleiche Variante, andere Perspektive).
  List<ReiheFassung> partnerVon(ReiheFassung f) =>
      [for (final g in fassungen) if (g.variante == f.variante && g.id != f.id) g];

  /// Prüft das gemeinsame Szenenbuch: gleiche Szenen-IDs in gleicher Reihenfolge in jeder Fassung, jede Szene
  /// einmal, Zeitmarken aufsteigend. Gibt die Verstöße zurück, leer = in Ordnung.
  List<String> pruefeSynchronitaet() {
    final probleme = <String>[];
    final soll = [for (final s in szenen) s.id];
    if (soll.toSet().length != soll.length) probleme.add('$id: Szenen-IDs doppelt');
    var vorher = -1;
    for (final s in szenen) {
      if (s.start < vorher || s.ende <= s.start) probleme.add('$id: Zeitmarke von ${s.id} unstimmig');
      vorher = s.ende;
    }
    for (final f in fassungen) {
      final ist = [for (final s in f.segmente) s.szene];
      if (ist.length != soll.length || !_gleich(ist, soll)) {
        probleme.add('$id/${f.id}: Szenenfolge weicht vom Szenenbuch ab');
      }
      if (f.segmente.any((s) => s.text.trim().isEmpty)) probleme.add('$id/${f.id}: leeres Segment');
    }
    return probleme;
  }

  static bool _gleich(List<String> a, List<String> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class ReiheDaten {
  final List<ReiheFolge> folgen;

  /// Echte Länge jeder Aufnahme in ms, Schlüssel `<stimme>_<folge>_<fassung>_<szene>`.
  final Map<String, int> dauerMs;

  const ReiheDaten(this.folgen, this.dauerMs);

  static const _textDatei = 'reihe/reihe.json';
  static const _dauerDatei = 'audio/reihe/dauer.json';

  /// Null, solange das Paket fehlt oder unlesbar ist.
  static Future<ReiheDaten?> laden() async {
    final texte = Pakete.datei(_textDatei);
    if (texte == null) return null;
    try {
      final daten = fromJson(jsonDecode(await File(texte).readAsString()) as Map<String, dynamic>);
      final d = Pakete.datei(_dauerDatei);
      if (d == null) return daten;
      final dauer = (jsonDecode(await File(d).readAsString()) as Map).map((k, v) => MapEntry(k as String, v as int));
      return ReiheDaten(daten.folgen, dauer);
    } catch (_) {
      return null;
    }
  }

  static ReiheDaten fromJson(Map<String, dynamic> j) => ReiheDaten([
        for (final f in j['folgen'] as List) ReiheFolge.fromJson(f as Map<String, dynamic>),
      ], const {});

  /// Pfad der Aufnahme eines Segments im Paket.
  static String audioPfad(ReiheFolge folge, ReiheFassung fassung, ReiheSegment s) =>
      'audio/reihe/${fassung.stimme}_${folge.id}_${fassung.id}_${s.szene}.opus';

  /// Dauer eines Segments: gemessen, sonst aus der Textlänge geschätzt (rund zehn Zeichen je Sekunde).
  Duration dauerVon(ReiheFolge folge, ReiheFassung fassung, ReiheSegment s) {
    final ms = dauerMs['${fassung.stimme}_${folge.id}_${fassung.id}_${s.szene}'];
    if (ms != null) return Duration(milliseconds: ms);
    return Duration(milliseconds: (s.text.length / 10 * 1000).round());
  }

  Duration gesamt(ReiheFolge folge, ReiheFassung fassung) =>
      fassung.segmente.fold(Duration.zero, (sum, s) => sum + dauerVon(folge, fassung, s));

  /// Wie weit eine Szene in der Fassung vom Produktionsziel des Szenenbuchs abweicht (Sekunden, positiv =
  /// später). Für die Synchronisationsprüfung bei Probeaufnahmen.
  Map<String, int> abweichungen(ReiheFolge folge, ReiheFassung fassung) {
    final ergebnis = <String, int>{};
    var t = Duration.zero;
    for (final s in fassung.segmente) {
      final szene = folge.szenen.where((x) => x.id == s.szene).firstOrNull;
      if (szene != null) ergebnis[s.szene] = t.inSeconds - szene.start;
      t += dauerVon(folge, fassung, s);
    }
    return ergebnis;
  }
}
