import '../l10n/t.dart';

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

  /// Die deutschen Bezeichnungen sind zugleich die gespeicherte Kennung (in Einträgen und
  /// Sicherungen) – nie ändern. Angezeigt wird die Übersetzung über [anzeige].
  static const List<String> availableDistortions = [
    'Spectatoring / Selbstbeobachtung',
    'Katastrophisieren',
    'Alles-oder-Nichts-Denken',
    'Gedankenlesen',
    'Leistungsdruck',
    'Tunnelblick auf Körpersignale',
  ];

  static String anzeige(String gespeichert) => switch (gespeichert) {
        'Spectatoring / Selbstbeobachtung' => t.distortionSpectatoring,
        'Katastrophisieren' => t.distortionCatastrophizing,
        'Alles-oder-Nichts-Denken' => t.distortionAllOrNothing,
        'Gedankenlesen' => t.distortionMindReading,
        'Leistungsdruck' => t.distortionPerformancePressure,
        'Tunnelblick auf Körpersignale' => t.distortionTunnelVision,
        _ => gespeichert,
      };

  /// Passende Denkfalle zu einem Glaubenssatz aus der Bibliothek (nach dessen fester id).
  static String fuerGlaubenssatz(String beliefId) => switch (beliefId) {
        'belief_spectatoring' || 'belief_female_body' => 'Spectatoring / Selbstbeobachtung',
        'belief_comparison' => 'Katastrophisieren',
        'belief_responsibility' || 'belief_masculinity' || 'belief_female_orgasm' || 'belief_duty_sex' =>
          'Leistungsdruck',
        'belief_non_concordance' => 'Tunnelblick auf Körpersignale',
        _ => 'Alles-oder-Nichts-Denken',
      };
}
