class CbtJournalEntry {
  final String id;
  final DateTime timestamp;
  final String triggerSituation;
  final String automaticThought;
  final List<String> cognitiveDistortions;
  final String realityCheckReframe;

  CbtJournalEntry({
    required this.id,
    required this.timestamp,
    required this.triggerSituation,
    required this.automaticThought,
    required this.cognitiveDistortions,
    required this.realityCheckReframe,
  });

  factory CbtJournalEntry.fromJson(Map<String, dynamic> json) {
    return CbtJournalEntry(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      triggerSituation: json['trigger_situation'] as String? ?? '',
      automaticThought: json['automatic_thought'] as String? ?? '',
      cognitiveDistortions: (json['cognitive_distortions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      realityCheckReframe: json['reality_check_reframe'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'trigger_situation': triggerSituation,
        'automatic_thought': automaticThought,
        'cognitive_distortions': cognitiveDistortions,
        'reality_check_reframe': realityCheckReframe,
      };

  static const List<String> availableDistortions = [
    'Spectatoring / Selbstbeobachtung',
    'Katastrophisieren',
    'Alles-oder-Nichts-Denken',
    'Gedankenlesen',
    'Leistungsdruck',
    'Tunnelblick auf Körpersignale',
  ];
}
