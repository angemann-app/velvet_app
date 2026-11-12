import 'dart:convert';
import 'wiedergabe_plan.dart';

/// Letzte Wiedergabe einschließlich Löschmarkierung gegen alte Sicherungen.
class WiedergabeMerker {
  final WiedergabePlan? plan;
  final int index;
  final Duration position;
  final DateTime geaendert;
  bool get geloescht => plan == null;

  const WiedergabeMerker(
      {required this.plan,
      required this.index,
      required this.position,
      required this.geaendert});

  Map<String, dynamic> toJson() => {
        'geaendert': geaendert.toUtc().toIso8601String(),
        if (plan != null) 'plan': plan!.toJson(),
        'index': index,
        'positionMs': position.inMilliseconds
      };

  factory WiedergabeMerker.fromJson(Map<String, dynamic> j) {
    final zeit = _zeit(j['geaendert']);
    final plan = j['plan'] == null
        ? null
        : WiedergabePlan.fromJson(Map<String, dynamic>.from(j['plan'] as Map));
    final index = j['index'];
    final pos = j['positionMs'];
    if (index is! int ||
        pos is! int ||
        index < 0 ||
        pos < 0 ||
        (plan == null
            ? index != 0 || pos != 0
            : index >= plan.abschnitte.length || pos > 43200000)) {
      throw const FormatException('Ungültiger Wiedergabemerker');
    }
    return WiedergabeMerker(
        plan: plan,
        index: index,
        position: Duration(milliseconds: pos),
        geaendert: zeit);
  }
}

/// Drei freiwillige Schritte zu einer bestehenden Lektion, keine neuen Texte.
class WegStand {
  final String lektion;
  final int schritt;
  final DateTime geaendert;
  const WegStand(
      {required this.lektion, required this.schritt, required this.geaendert});
  bool get fertig => schritt == 3;
  Map<String, dynamic> toJson() => {
        'lektion': lektion,
        'schritt': schritt,
        'geaendert': geaendert.toUtc().toIso8601String()
      };
  factory WegStand.fromJson(Map<String, dynamic> j) {
    if (j['lektion'] is! String ||
        !RegExp(r'^[a-zA-Z0-9_-]{1,160}$').hasMatch(j['lektion'] as String) ||
        j['schritt'] is! int ||
        (j['schritt'] as int) < 0 ||
        (j['schritt'] as int) > 3) {
      throw const FormatException('Ungültiger persönlicher Weg');
    }
    return WegStand(
        lektion: j['lektion'] as String,
        schritt: j['schritt'] as int,
        geaendert: _zeit(j['geaendert']));
  }
}

/// Stand von „Eure erste Woche“: sieben freiwillige Schritte, nur lokal. Kein Zähler, keine Erinnerung.
/// Schritt-Nummern 1 bis 7; Wert „getan“ oder „uebersprungen“. „Heute nicht“ wird nicht gespeichert.
class ErsteWocheStand {
  static const anzahl = 7;
  static const getan = 'getan';
  static const uebersprungen = 'uebersprungen';

  final DateTime? beginn;
  final Map<int, String> schritte;
  final bool ausgeblendet;
  final DateTime geaendert;

  const ErsteWocheStand(
      {this.beginn,
      this.schritte = const {},
      this.ausgeblendet = false,
      required this.geaendert});

  /// Erster Schritt, der weder getan noch übersprungen ist; null, wenn alle sieben erledigt sind.
  int? get aktuellerSchritt {
    for (var n = 1; n <= anzahl; n++) {
      if (!schritte.containsKey(n)) return n;
    }
    return null;
  }

  bool get abgeschlossen => aktuellerSchritt == null;

  ErsteWocheStand kopie(
          {DateTime? beginn,
          Map<int, String>? schritte,
          bool? ausgeblendet,
          required DateTime geaendert}) =>
      ErsteWocheStand(
          beginn: beginn ?? this.beginn,
          schritte: schritte ?? this.schritte,
          ausgeblendet: ausgeblendet ?? this.ausgeblendet,
          geaendert: geaendert);

  /// Markiert einen Schritt (getan oder übersprungen); setzt beim ersten Mal den Beginn.
  ErsteWocheStand mitSchritt(int nr, String wert, DateTime jetzt) =>
      kopie(
          beginn: beginn ?? jetzt,
          schritte: {...schritte, nr: wert},
          geaendert: jetzt);

  Map<String, dynamic> toJson() => {
        if (beginn != null) 'beginn': beginn!.toUtc().toIso8601String(),
        'schritte': {
          for (final e in (schritte.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key))))
            '${e.key}': e.value
        },
        'ausgeblendet': ausgeblendet,
        'geaendert': geaendert.toUtc().toIso8601String()
      };

  factory ErsteWocheStand.fromJson(Map<String, dynamic> j) {
    final roh = j['schritte'];
    final schritte = <int, String>{};
    if (roh != null) {
      if (roh is! Map) throw const FormatException('Ungültige erste Woche');
      for (final e in roh.entries) {
        final nr = int.tryParse('${e.key}');
        if (nr == null ||
            nr < 1 ||
            nr > anzahl ||
            (e.value != getan && e.value != uebersprungen)) {
          throw const FormatException('Ungültiger Schritt der ersten Woche');
        }
        schritte[nr] = e.value as String;
      }
    }
    if (j['ausgeblendet'] != null && j['ausgeblendet'] is! bool) {
      throw const FormatException('Ungültige erste Woche');
    }
    return ErsteWocheStand(
        beginn: j['beginn'] == null ? null : _zeit(j['beginn']),
        schritte: schritte,
        ausgeblendet: j['ausgeblendet'] == true,
        geaendert: _zeit(j['geaendert']));
  }
}

class BedienDaten {
  final WiedergabeMerker? wiedergabe;
  final WegStand? weg;
  final ErsteWocheStand? ersteWoche;
  const BedienDaten({this.wiedergabe, this.weg, this.ersteWoche});
  Map<String, dynamic> toJson() => {
        'schema': 1,
        if (wiedergabe != null) 'wiedergabe': wiedergabe!.toJson(),
        if (weg != null) 'weg': weg!.toJson(),
        if (ersteWoche != null) 'ersteWoche': ersteWoche!.toJson()
      };
  factory BedienDaten.fromJson(Map<String, dynamic> j) {
    if (j['schema'] != 1)
      throw const FormatException('Unbekannter Bedienungsstand');
    return BedienDaten(
        wiedergabe: j['wiedergabe'] == null
            ? null
            : WiedergabeMerker.fromJson(
                Map<String, dynamic>.from(j['wiedergabe'] as Map)),
        weg: j['weg'] == null
            ? null
            : WegStand.fromJson(Map<String, dynamic>.from(j['weg'] as Map)),
        ersteWoche: j['ersteWoche'] == null
            ? null
            : ErsteWocheStand.fromJson(
                Map<String, dynamic>.from(j['ersteWoche'] as Map)));
  }

  BedienDaten zusammen(BedienDaten other) => BedienDaten(
      wiedergabe: _neu(
          wiedergabe, other.wiedergabe, (v) => v.geaendert, (v) => v.toJson()),
      weg: _neu(weg, other.weg, (v) => v.geaendert, (v) => v.toJson()),
      ersteWoche: _neu(ersteWoche, other.ersteWoche, (v) => v.geaendert,
          (v) => v.toJson()));
}

T? _neu<T>(T? a, T? b, DateTime Function(T) zeit,
    Map<String, dynamic> Function(T) json) {
  if (a == null) return b;
  if (b == null) return a;
  final cmp = zeit(a).compareTo(zeit(b));
  if (cmp != 0) return cmp > 0 ? a : b;
  // Bei Gleichstand gewinnt eine Löschmarkierung; sonst deterministisch.
  if (a is WiedergabeMerker &&
      b is WiedergabeMerker &&
      a.geloescht != b.geloescht) return a.geloescht ? a : b;
  return jsonEncode(json(a)).compareTo(jsonEncode(json(b))) >= 0 ? a : b;
}

DateTime _zeit(Object? value) {
  if (value is! String) throw const FormatException('Änderungszeit fehlt');
  final t = DateTime.tryParse(value);
  if (t == null) throw const FormatException('Ungültige Änderungszeit');
  return t.toUtc();
}
