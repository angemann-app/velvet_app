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

class BedienDaten {
  final WiedergabeMerker? wiedergabe;
  final WegStand? weg;
  const BedienDaten({this.wiedergabe, this.weg});
  Map<String, dynamic> toJson() => {
        'schema': 1,
        if (wiedergabe != null) 'wiedergabe': wiedergabe!.toJson(),
        if (weg != null) 'weg': weg!.toJson()
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
            : WegStand.fromJson(Map<String, dynamic>.from(j['weg'] as Map)));
  }

  BedienDaten zusammen(BedienDaten other) => BedienDaten(
      wiedergabe: _neu(
          wiedergabe, other.wiedergabe, (v) => v.geaendert, (v) => v.toJson()),
      weg: _neu(weg, other.weg, (v) => v.geaendert, (v) => v.toJson()));
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
