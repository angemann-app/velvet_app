import 'dart:convert';

/// Lokale persönliche Zeichen und Tagesbeobachtungen. Löschungen werden beim
/// Backup-Merge wie Änderungen behandelt, damit alte Sicherungen sie nicht zurückholen.
class PraxisEintrag {
  final String id;
  final String art;
  final DateTime geaendert;
  final bool geloescht;
  final String text;
  final int? schlaf;
  final int? lust;
  final bool? sinnlich;
  final bool? klar;
  final bool? hoehepunkt;

  const PraxisEintrag(
      {required this.id,
      required this.art,
      required this.geaendert,
      this.geloescht = false,
      this.text = '',
      this.schlaf,
      this.lust,
      this.sinnlich,
      this.klar,
      this.hoehepunkt});

  factory PraxisEintrag.fromJson(Map<String, dynamic> j) {
    final id = j['id'];
    final art = j['art'];
    final text = j['text'] ?? '';
    if (id is! String ||
        id.isEmpty ||
        id.length > 100 ||
        !['zeichen', 'tag'].contains(art) ||
        text is! String ||
        text.length > (art == 'zeichen' ? 120 : 2000) ||
        (art == 'zeichen' && j['geloescht'] != true && text.trim().isEmpty) ||
        (j['geloescht'] != null && j['geloescht'] is! bool)) {
      throw const FormatException('Ungültiger Praxiseintrag');
    }
    if (art == 'tag') {
      final date = DateTime.tryParse(id);
      if (date == null || datum(date) != id)
        throw const FormatException('Ungültiger Tag');
    }
    for (final key in ['schlaf', 'lust']) {
      final v = j[key];
      if (v != null && (v is! int || v < 0 || v > 4))
        throw const FormatException('Ungültige Stufe');
    }
    for (final key in ['sinnlich', 'klar', 'hoehepunkt']) {
      if (j[key] != null && j[key] is! bool)
        throw const FormatException('Ungültige Beobachtung');
    }
    return PraxisEintrag(
        id: id,
        art: art as String,
        geaendert: DateTime.parse(j['geaendert'] as String),
        geloescht: j['geloescht'] == true,
        text: text,
        schlaf: j['schlaf'] as int?,
        lust: j['lust'] as int?,
        sinnlich: j['sinnlich'] as bool?,
        klar: j['klar'] as bool?,
        hoehepunkt: j['hoehepunkt'] as bool?);
  }

  static String datum(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  PraxisEintrag mitZeit(DateTime zeit) => PraxisEintrag(
      id: id,
      art: art,
      geaendert: zeit,
      geloescht: geloescht,
      text: text,
      schlaf: schlaf,
      lust: lust,
      sinnlich: sinnlich,
      klar: klar,
      hoehepunkt: hoehepunkt);

  Map<String, dynamic> toJson() => {
        'id': id, 'art': art, 'geaendert': geaendert.toUtc().toIso8601String(),
        'geloescht': geloescht,
        // Löschmarkierung behält keinen privaten Inhalt zurück.
        if (!geloescht) ...{
          'text': text,
          if (schlaf != null) 'schlaf': schlaf,
          if (lust != null) 'lust': lust,
          if (sinnlich != null) 'sinnlich': sinnlich,
          if (klar != null) 'klar': klar,
          if (hoehepunkt != null) 'hoehepunkt': hoehepunkt,
        },
      };
}

class TraumpraxisDaten {
  final List<PraxisEintrag> eintraege;
  const TraumpraxisDaten([this.eintraege = const []]);

  factory TraumpraxisDaten.fromJson(Map<String, dynamic> j) {
    if (j['version'] != 1 || j['eintraege'] is! List)
      throw const FormatException('Unbekanntes Praxisformat');
    return const TraumpraxisDaten().zusammen(TraumpraxisDaten((j['eintraege']
            as List)
        .map((e) => PraxisEintrag.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()));
  }

  List<PraxisEintrag> get zeichen =>
      eintraege.where((e) => e.art == 'zeichen' && !e.geloescht).toList()
        ..sort((a, b) => b.geaendert.compareTo(a.geaendert));
  List<PraxisEintrag> get tage =>
      eintraege.where((e) => e.art == 'tag' && !e.geloescht).toList()
        ..sort((a, b) => b.id.compareTo(a.id));

  TraumpraxisDaten zusammen(TraumpraxisDaten andere) {
    final result = <String, PraxisEintrag>{};
    for (final e in [...eintraege, ...andere.eintraege]) {
      final key = '${e.art}/${e.id}';
      final old = result[key];
      if (old == null ||
          e.geaendert.isAfter(old.geaendert) ||
          (e.geaendert.isAtSameMomentAs(old.geaendert) &&
              (e.geloescht && !old.geloescht ||
                  e.geloescht == old.geloescht &&
                      jsonEncode(e.toJson())
                              .compareTo(jsonEncode(old.toJson())) >
                          0))) {
        result[key] = e;
      }
    }
    return TraumpraxisDaten(result.values.toList()
      ..sort((a, b) => '${a.art}/${a.id}'.compareTo('${b.art}/${b.id}')));
  }

  Map<String, dynamic> toJson() =>
      {'version': 1, 'eintraege': eintraege.map((e) => e.toJson()).toList()};
}
