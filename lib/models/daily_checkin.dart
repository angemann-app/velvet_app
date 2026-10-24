import '../l10n/t.dart';

class DailyCheckIn {
  final String date; // YYYY-MM-DD
  final int stressLevel; // 1 to 5
  final int performancePressure; // 1 to 5
  final List<String> positiveActions;
  final DateTime timestamp;

  DailyCheckIn({
    required this.date,
    required this.stressLevel,
    required this.performancePressure,
    required this.positiveActions,
    required this.timestamp,
  });

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) {
    return DailyCheckIn(
      date: json['date'] as String? ?? '',
      stressLevel: (json['stress_level'] as num?)?.toInt() ?? 3,
      performancePressure: (json['performance_pressure'] as num?)?.toInt() ?? 3,
      positiveActions: (json['positive_actions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'stress_level': stressLevel,
        'performance_pressure': performancePressure,
        'positive_actions': positiveActions,
        'timestamp': timestamp.toIso8601String(),
      };

  /// Die deutschen Texte sind zugleich die gespeicherte Kennung (in Check-ins und Sicherungen) –
  /// nie ändern. Angezeigt wird die Übersetzung über [anzeige].
  static const List<String> availableActions = [
    'Bewusst tief geatmet (Physiol. Seufzer)',
    'Beckenboden entspannt (Reverse Kegel)',
    'Das Handy abends weggelegt',
    'Spaziergang an frischer Luft gemacht',
    'Fokus auf Hautkontakt gelenkt',
    'Offenes Wort mit Partner/in gewagt',
  ];

  static String anzeige(String gespeichert) => switch (gespeichert) {
        'Bewusst tief geatmet (Physiol. Seufzer)' => t.checkinActionBreathed,
        'Beckenboden entspannt (Reverse Kegel)' => t.checkinActionPelvicFloor,
        'Das Handy abends weggelegt' => t.checkinActionPhoneAway,
        'Spaziergang an frischer Luft gemacht' => t.checkinActionWalk,
        'Fokus auf Hautkontakt gelenkt' => t.checkinActionSkinContact,
        'Offenes Wort mit Partner/in gewagt' => t.checkinActionOpenWord,
        _ => gespeichert,
      };
}
