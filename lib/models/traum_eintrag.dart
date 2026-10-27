/// Ein Eintrag im Traumtagebuch (docs/konzepte/traum-reise.md, „Traumtagebuch“). Privat: geht nie
/// automatisch an Partner:in oder KI-Coach, ist aber Teil der verschlüsselten Sicherung.
class TraumEintrag {
  /// Markierungen in der Reihenfolge der Anzeige. „nichts“ steht für „Nichts erinnert“.
  static const markierungen = ['erinnert', 'luzide', 'sinnlich', 'hoehepunkt', 'unangenehm', 'schlecht_geschlafen'];
  static const nichts = 'nichts';

  /// Markierungen, die bei Häufung eine Pause nahelegen.
  static const belastend = {'unangenehm', 'schlecht_geschlafen'};

  final String id;
  final DateTime zeit;
  final String text;
  final Set<String> marken;

  /// Was am Abend davor lief, z. B. 'traum:warmes_wasser' oder 'lust:3'; null ohne Abend-Audio.
  final String? abend;

  const TraumEintrag({required this.id, required this.zeit, this.text = '', this.marken = const {}, this.abend});

  factory TraumEintrag.fromJson(Map<String, dynamic> json) => TraumEintrag(
        id: json['id'] as String,
        zeit: DateTime.parse(json['zeit'] as String),
        text: json['text'] as String? ?? '',
        marken: {...((json['marken'] as List?) ?? const []).map((e) => e.toString())},
        abend: json['abend'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'zeit': zeit.toIso8601String(),
        'text': text,
        'marken': marken.toList(),
        if (abend != null) 'abend': abend,
      };

  TraumEintrag mit({String? text, Set<String>? marken}) =>
      TraumEintrag(id: id, zeit: zeit, text: text ?? this.text, marken: marken ?? this.marken, abend: abend);

  /// Pause-Regel: mindestens drei der letzten sieben Einträge belastend markiert.
  static bool pauseRaten(List<TraumEintrag> neuesteZuerst) =>
      neuesteZuerst.take(7).where((e) => e.marken.any(belastend.contains)).length >= 3;
}
