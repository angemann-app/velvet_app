import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Nur synchronisierte Schlafsitzungen; keine Live-Sensorik oder Bewertung.
class SchlafAufzeichnung {
  final String id, quelle, tag;
  final DateTime beginn, ende, quelleGeaendert, importiert;
  final int? beginnOffsetMinuten, endeOffsetMinuten;
  final Map<int, int> phasenMs;
  final bool phasenVollstaendig;

  const SchlafAufzeichnung(
      {required this.id,
      required this.quelle,
      required this.tag,
      required this.beginn,
      required this.ende,
      required this.quelleGeaendert,
      required this.importiert,
      this.beginnOffsetMinuten,
      this.endeOffsetMinuten,
      this.phasenMs = const {},
      this.phasenVollstaendig = false});

  Duration get zeitfenster => ende.difference(beginn);
  Duration? get schlafzeit => !phasenVollstaendig || (phasenMs[0] ?? 0) > 0
      ? null
      : Duration(
          milliseconds: [2, 4, 5, 6].fold(0, (n, k) => n + (phasenMs[k] ?? 0)));

  static String datum(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  factory SchlafAufzeichnung.ausHealth(Map<String, dynamic> j, DateTime jetzt) {
    final quelle = j['quelle'];
    final record = j['id'];
    if (quelle is! String ||
        quelle.isEmpty ||
        quelle.length > 300 ||
        record is! String ||
        record.isEmpty ||
        record.length > 300) {
      throw const FormatException('Ungültige Schlafquelle');
    }
    final start = _zeit(j['startMs']);
    final end = _zeit(j['endeMs']);
    if (!end.isAfter(start) ||
        end.difference(start) > const Duration(hours: 36) ||
        end.isAfter(jetzt.toUtc())) {
      throw const FormatException('Keine abgeschlossene Schlafsitzung');
    }
    final offset = j['offsetEndeMin'];
    final startOffset = j['offsetStartMin'];
    if (startOffset != null &&
        (startOffset is! int || startOffset.abs() > 1080))
      throw const FormatException('Ungültige Startzeitzone');
    if (offset != null && (offset is! int || offset.abs() > 1080))
      throw const FormatException('Ungültige Zeitzone');
    final raw = j['phasen'];
    if (raw is! List || raw.length > 10000)
      throw const FormatException('Ungültige Schlafphasen');
    final parts = <({DateTime start, DateTime end, int typ})>[];
    for (final value in raw) {
      final p = Map<String, dynamic>.from(value as Map);
      final a = _zeit(p['startMs']), b = _zeit(p['endeMs']);
      final typ = p['typ'];
      if (typ is! int ||
          typ < 0 ||
          typ > 7 ||
          !b.isAfter(a) ||
          a.isBefore(start) ||
          b.isAfter(end)) {
        throw const FormatException('Ungültige Schlafphase');
      }
      parts.add((start: a, end: b, typ: typ));
    }
    parts.sort((a, b) => a.start.compareTo(b.start));
    final totals = <int, int>{};
    var cursor = start, complete = parts.isNotEmpty;
    for (final p in parts) {
      if (p.start.isBefore(cursor))
        throw const FormatException('Überlappende Schlafphasen');
      if (p.start != cursor) complete = false;
      totals[p.typ] =
          (totals[p.typ] ?? 0) + p.end.difference(p.start).inMilliseconds;
      cursor = p.end;
    }
    complete &= cursor == end;
    final wake = offset == null
        ? end.toLocal()
        : end.add(Duration(minutes: offset as int));
    return SchlafAufzeichnung(
        id: sha256.convert(utf8.encode('$quelle/$record')).toString(),
        quelle: quelle,
        tag: datum(wake),
        beginn: start,
        ende: end,
        quelleGeaendert: _zeit(j['geaendertMs']),
        importiert: jetzt.toUtc(),
        beginnOffsetMinuten: startOffset as int?,
        endeOffsetMinuten: offset as int?,
        phasenMs: Map.unmodifiable(totals),
        phasenVollstaendig: complete);
  }

  factory SchlafAufzeichnung.fromJson(Map<String, dynamic> j) {
    final id = j['id'], quelle = j['quelle'], tag = j['tag'];
    if (id is! String ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(id) ||
        quelle is! String ||
        quelle.isEmpty ||
        quelle.length > 300 ||
        tag is! String ||
        DateTime.tryParse(tag) == null ||
        datum(DateTime.parse(tag)) != tag) {
      throw const FormatException('Ungültige Schlafaufzeichnung');
    }
    final start = _zeit(j['startMs']), end = _zeit(j['endeMs']);
    if (!end.isAfter(start) ||
        end.difference(start) > const Duration(hours: 36))
      throw const FormatException('Ungültiges Schlaffenster');
    final offset = j['offsetEndeMin'];
    final startOffset = j['offsetStartMin'];
    if (startOffset != null &&
        (startOffset is! int || startOffset.abs() > 1080))
      throw const FormatException('Ungültiger Startoffset');
    if (offset != null && (offset is! int || offset.abs() > 1080))
      throw const FormatException('Ungültiger Offset');
    if (offset is int && datum(end.add(Duration(minutes: offset))) != tag)
      throw const FormatException('Widersprüchlicher Schlaftag');
    final raw = j['phasenMs'];
    if (raw is! Map || raw.length > 8 || j['vollstaendig'] is! bool)
      throw const FormatException('Ungültige Phasensummen');
    final totals = <int, int>{};
    for (final e in raw.entries) {
      final typ = int.tryParse(e.key.toString());
      if (typ == null ||
          typ < 0 ||
          typ > 7 ||
          e.value is! int ||
          (e.value as int) < 0) throw const FormatException('Ungültige Phase');
      totals[typ] = e.value as int;
    }
    final sum = totals.values.fold(0, (a, b) => a + b),
        duration = end.difference(start).inMilliseconds;
    if (sum > duration || (j['vollstaendig'] == true && sum != duration))
      throw const FormatException('Ungültige Phasendauer');
    return SchlafAufzeichnung(
        id: id,
        quelle: quelle,
        tag: tag,
        beginn: start,
        ende: end,
        quelleGeaendert: _zeit(j['quelleGeaendertMs']),
        importiert: _zeit(j['importiertMs']),
        beginnOffsetMinuten: startOffset as int?,
        endeOffsetMinuten: offset as int?,
        phasenMs: Map.unmodifiable(totals),
        phasenVollstaendig: j['vollstaendig'] as bool);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quelle': quelle,
        'tag': tag,
        'startMs': beginn.millisecondsSinceEpoch,
        'endeMs': ende.millisecondsSinceEpoch,
        'quelleGeaendertMs': quelleGeaendert.millisecondsSinceEpoch,
        'importiertMs': importiert.millisecondsSinceEpoch,
        'offsetStartMin': beginnOffsetMinuten,
        'offsetEndeMin': endeOffsetMinuten,
        'vollstaendig': phasenVollstaendig,
        'phasenMs': {
          for (final k in (phasenMs.keys.toList()..sort())) '$k': phasenMs[k]
        }
      };
}

DateTime _zeit(dynamic value) {
  if (value is! int || value < 0 || value > 4133980800000)
    throw const FormatException('Ungültiger Zeitpunkt');
  return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
}

/// Verbunden ist gerätespezifisch und wird beim Backup-Merge nicht aktiviert.
class SchlafDaten {
  final List<SchlafAufzeichnung> aufzeichnungen;
  final DateTime? geloeschtAm, letzterAbgleich;
  final bool verbunden;
  const SchlafDaten(
      {this.aufzeichnungen = const [],
      this.geloeschtAm,
      this.letzterAbgleich,
      this.verbunden = false});

  factory SchlafDaten.fromJson(Map<String, dynamic> j) {
    if (j['version'] != 1 ||
        j['aufzeichnungen'] is! List ||
        (j['aufzeichnungen'] as List).length > 500 ||
        j['verbunden'] is! bool) {
      throw const FormatException('Ungültiger Schlafdatenstand');
    }
    final data = SchlafDaten(
        aufzeichnungen: (j['aufzeichnungen'] as List)
            .map((e) => SchlafAufzeichnung.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
        geloeschtAm: j['geloeschtMs'] == null ? null : _zeit(j['geloeschtMs']),
        letzterAbgleich:
            j['abgleichMs'] == null ? null : _zeit(j['abgleichMs']),
        verbunden: j['verbunden'] as bool);
    return data.zusammen(const SchlafDaten());
  }

  SchlafDaten zusammen(SchlafDaten other) {
    final clear =
        [geloeschtAm, other.geloeschtAm].whereType<DateTime>().toList()..sort();
    final mark = clear.isEmpty ? null : clear.last;
    final merged = <String, SchlafAufzeichnung>{};
    for (final r in [...aufzeichnungen, ...other.aufzeichnungen]) {
      if (mark != null && !r.importiert.isAfter(mark)) continue;
      final old = merged[r.id];
      final order =
          old == null ? 1 : r.quelleGeaendert.compareTo(old.quelleGeaendert);
      if (old == null ||
          order > 0 ||
          (order == 0 &&
              (r.importiert.isAfter(old.importiert) ||
                  (r.importiert == old.importiert &&
                      jsonEncode(r.toJson())
                              .compareTo(jsonEncode(old.toJson())) >
                          0)))) merged[r.id] = r;
    }
    if (merged.length > 500) throw const FormatException('Schlafdatenlimit');
    final list = merged.values.toList()
      ..sort((a, b) => b.ende.compareTo(a.ende) != 0
          ? b.ende.compareTo(a.ende)
          : a.id.compareTo(b.id));
    final sync = [letzterAbgleich, other.letzterAbgleich]
        .whereType<DateTime>()
        .where((zeit) => mark == null || zeit.isAfter(mark))
        .toList()
      ..sort();
    return SchlafDaten(
        aufzeichnungen: List.unmodifiable(list),
        geloeschtAm: mark,
        letzterAbgleich: sync.isEmpty ? null : sync.last,
        verbunden: verbunden);
  }

  SchlafDaten verbindung(bool aktiv) => SchlafDaten(
      aufzeichnungen: aufzeichnungen,
      geloeschtAm: geloeschtAm,
      letzterAbgleich: letzterAbgleich,
      verbunden: aktiv);

  SchlafDaten loeschen(DateTime jetzt) {
    final last = [
      jetzt.toUtc(),
      if (geloeschtAm != null) geloeschtAm!,
      ...aufzeichnungen.map((r) => r.importiert)
    ]..sort();
    return SchlafDaten(
        geloeschtAm: last.last.add(const Duration(milliseconds: 1)),
        verbunden: verbunden);
  }

  Map<String, dynamic> toJson() => {
        'version': 1,
        'verbunden': verbunden,
        'geloeschtMs': geloeschtAm?.millisecondsSinceEpoch,
        'abgleichMs': letzterAbgleich?.millisecondsSinceEpoch,
        'aufzeichnungen': aufzeichnungen.map((r) => r.toJson()).toList()
      };
}
