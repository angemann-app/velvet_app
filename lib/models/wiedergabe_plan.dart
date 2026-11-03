/// Ein reproduzierbarer Hörablauf. Persistiert werden nur IDs, Zeiten und
/// Einstellungen; Titel und Sprechtexte bleiben flüchtig im Arbeitsspeicher.
enum WiedergabeArt {
  lektion,
  paar,
  selbst,
  einschlaf,
  traum,
  lust,
  wecken,
  reihe,
  praxis
}

enum AbschnittArt { sprache, stille, klang }

class WiedergabeAbschnitt {
  final String id;
  final AbschnittArt art;
  final Duration dauer;
  final String? pfad;
  final String text;
  final String phase;
  final int runde;
  final bool aufnahmeEnde;
  final String? bild;

  const WiedergabeAbschnitt(
      {required this.id,
      required this.art,
      required this.dauer,
      this.pfad,
      this.text = '',
      this.phase = '',
      this.runde = 0,
      this.aufnahmeEnde = false,
      this.bild});

  Map<String, dynamic> toJson() => {
        'id': id,
        'art': art.name,
        'dauerMs': dauer.inMilliseconds,
        if (pfad != null) 'pfad': pfad,
        'phase': phase,
        'runde': runde,
        'aufnahmeEnde': aufnahmeEnde,
        if (bild != null) 'bild': bild,
      };

  factory WiedergabeAbschnitt.fromJson(Map<String, dynamic> j) {
    final id = _id(j['id']);
    final art = AbschnittArt.values.asNameMap()[j['art']];
    if (art == null) throw const FormatException('Unbekannte Abschnittsart');
    final dauer = _zahl(j['dauerMs'], 1, 43200000);
    final phase = j['phase'] == '' ? '' : _id(j['phase'] ?? '');
    final runde = _zahl(j['runde'] ?? 0, 0, 2);
    final pfad = j['pfad'] as String?;
    final bild = j['bild'] as String?;
    if (pfad != null) _pfad(pfad, 'audio', 'opus');
    if (bild != null) _pfad(bild, 'bilder', 'webp');
    if (art != AbschnittArt.stille && pfad == null)
      throw const FormatException('Aufnahmepfad fehlt');
    if (j['aufnahmeEnde'] != null && j['aufnahmeEnde'] is! bool)
      throw const FormatException('Ungültige Abschnittsgrenze');
    return WiedergabeAbschnitt(
        id: id,
        art: art,
        dauer: Duration(milliseconds: dauer),
        pfad: pfad,
        phase: phase,
        runde: runde,
        aufnahmeEnde: j['aufnahmeEnde'] == true,
        bild: bild);
  }
}

class WiedergabePlan {
  final WiedergabeArt art;
  final String id;
  final String sprache;
  final bool spicy;
  final String titel;
  final List<WiedergabeAbschnitt> abschnitte;
  final Map<String, Object> parameter;

  WiedergabePlan(
      {required this.art,
      required this.id,
      required this.sprache,
      required this.spicy,
      this.titel = '',
      required List<WiedergabeAbschnitt> abschnitte,
      Map<String, Object> parameter = const {}})
      : abschnitte = List.unmodifiable(abschnitte),
        parameter = Map.unmodifiable(parameter);

  Duration get dauer => abschnitte.fold(Duration.zero, (v, s) => v + s.dauer);
  Duration bisAbschnitt(int index) =>
      abschnitte.take(index).fold(Duration.zero, (v, s) => v + s.dauer);

  Map<String, dynamic> toJson() => {
        'art': art.name,
        'id': id,
        'sprache': sprache,
        'spicy': spicy,
        'abschnitte': abschnitte.map((s) => s.toJson()).toList(),
        'parameter': parameter,
      };

  factory WiedergabePlan.fromJson(Map<String, dynamic> j) {
    final art = WiedergabeArt.values.asNameMap()[j['art']];
    if (art == null ||
        !const ['de', 'en'].contains(j['sprache']) ||
        j['spicy'] is! bool) {
      throw const FormatException('Ungültiger Hörablauf');
    }
    final raw = j['abschnitte'];
    if (raw is! List || raw.isEmpty || raw.length > 1024)
      throw const FormatException('Ungültige Abschnittsliste');
    final steps = [
      for (final s in raw)
        WiedergabeAbschnitt.fromJson(Map<String, dynamic>.from(s as Map))
    ];
    final p = j['parameter'];
    if (p is! Map || p.length > 24)
      throw const FormatException('Ungültige Einstellungen');
    const keys = {
      'stimme',
      'minuten',
      'tiefe',
      'koerper',
      'teppich',
      'ichZuerst',
      'folge',
      'variante',
      'perspektive',
      'thema',
      'bettKoerper',
      'traumKoerper',
      'gegenueber',
      'lustFolge',
      'lustZaehlen',
      'abend',
      'teppichLaut',
      'blendeMs',
      'stimmeVon',
      'stimmeBis',
      'sprachfamilie'
    };
    final params = <String, Object>{};
    for (final e in p.entries) {
      if (!keys.contains(e.key))
        throw const FormatException('Unbekannte Einstellung');
      final v = e.value;
      const schalter = {'teppich', 'ichZuerst', 'lustZaehlen'};
      const lautstaerken = {'teppichLaut', 'stimmeVon', 'stimmeBis'};
      const zahlen = {'minuten', 'lustFolge', 'blendeMs'};
      if (schalter.contains(e.key)
          ? v is! bool
          : lautstaerken.contains(e.key)
              ? v is! num || !v.isFinite || v < 0 || v > 1
              : zahlen.contains(e.key)
                  ? v is! int || v < 0 || v > 43200000
                  : v is! String) {
        throw const FormatException(
            'Einstellung hat falschen Typ oder Bereich');
      }
      if (v is String) {
        if (v.length > 100 || !RegExp(r'^[a-zA-Z0-9_:.-]*$').hasMatch(v))
          throw const FormatException('Ungültige Auswahl');
      } else if (v is num) {
        if (!v.isFinite || v < 0 || v > 43200000)
          throw const FormatException('Ungültiger Zahlenwert');
      } else if (v is! bool) {
        throw const FormatException('Ungültiger Einstellungswert');
      }
      params[e.key as String] = v as Object;
    }
    final plan = WiedergabePlan(
        art: art,
        id: _id(j['id']),
        sprache: j['sprache'] as String,
        spicy: j['spicy'] as bool,
        abschnitte: steps,
        parameter: params);
    if (plan.dauer.inMilliseconds > 43200000)
      throw const FormatException('Hörablauf zu lang');
    return plan;
  }
}

String _id(Object? value) {
  if (value is! String || !RegExp(r'^[a-zA-Z0-9_:-]{1,160}$').hasMatch(value))
    throw const FormatException('Ungültige Inhalts-ID');
  return value;
}

int _zahl(Object? value, int min, int max) {
  if (value is! int || value < min || value > max)
    throw const FormatException('Ungültige Zeit/Position');
  return value;
}

void _pfad(String p, String root, String extension) {
  if (p.length > 240 ||
      !RegExp('^$root/[a-zA-Z0-9_/-]+\\.$extension\$').hasMatch(p) ||
      p.contains('..')) {
    throw const FormatException('Ungültiger relativer Medienpfad');
  }
}
