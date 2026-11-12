import '../l10n/t.dart';
import 'bedien_daten.dart';

/// Wohin ein Schritt von „Eure erste Woche“ führt.
enum ErsteWocheZiel { lektion, paarAbend, landkarte, rueckblick }

/// Ein Schritt der ersten Woche (docs/konzepte/eine-tonlage.md, Teil 4b).
/// Alle Inhalte sind vorhandene Bausteine; die Texte stehen in den ARB-Dateien (`ersteWocheS<n>…`).
class ErsteWocheSchritt {
  final int nr;
  final ErsteWocheZiel ziel;

  /// Lektion hinter dem Schritt (bei [ErsteWocheZiel.lektion]).
  final String? lektion;

  /// Zweite Lektion, wenn jede Person lieber für sich üben möchte (nur Schritt 2).
  final String? alternative;

  /// Ungefähre Dauer in Minuten (nur zur Orientierung).
  final int minuten;

  const ErsteWocheSchritt(this.nr, this.ziel, this.minuten,
      {this.lektion, this.alternative});

  String get titel => switch (nr) {
        1 => t.ersteWocheS1Titel,
        2 => t.ersteWocheS2Titel,
        3 => t.ersteWocheS3Titel,
        4 => t.ersteWocheS4Titel,
        5 => t.ersteWocheS5Titel,
        6 => t.ersteWocheS6Titel,
        _ => t.ersteWocheS7Titel,
      };

  String get text => switch (nr) {
        1 => t.ersteWocheS1Text,
        2 => t.ersteWocheS2Text,
        3 => t.ersteWocheS3Text,
        4 => t.ersteWocheS4Text,
        5 => t.ersteWocheS5Text,
        6 => t.ersteWocheS6Text,
        _ => t.ersteWocheS7Text,
      };
}

class ErsteWoche {
  ErsteWoche._();

  /// Lektion für „Ein Menü für eure Wünsche“ (Weitermachen nach Schritt 7).
  static const menueLektion = 'desire_3';

  /// Wie lange nichts passiert sein muss, bis die Karte nur noch sanft einlädt.
  static const langePause = Duration(days: 7);

  static const schritte = <ErsteWocheSchritt>[
    ErsteWocheSchritt(1, ErsteWocheZiel.lektion, 10, lektion: 'couples_3'),
    ErsteWocheSchritt(2, ErsteWocheZiel.lektion, 7,
        lektion: 'couples_2', alternative: 'neuro_3'),
    ErsteWocheSchritt(3, ErsteWocheZiel.lektion, 5, lektion: 'neuro_1'),
    ErsteWocheSchritt(4, ErsteWocheZiel.lektion, 15, lektion: 'couples_1'),
    ErsteWocheSchritt(5, ErsteWocheZiel.landkarte, 10),
    ErsteWocheSchritt(6, ErsteWocheZiel.lektion, 10, lektion: 'comm_2'),
    ErsteWocheSchritt(7, ErsteWocheZiel.rueckblick, 8),
  ];

  static ErsteWocheSchritt schritt(int nr) => schritte[nr - 1];

  /// Lange nichts getan? Dann lädt die Karte nur noch sanft ein (kein Zähler, keine Meldung).
  static bool istLangePause(ErsteWocheStand? s, DateTime jetzt) =>
      s != null &&
      s.schritte.isNotEmpty &&
      !s.abgeschlossen &&
      jetzt.difference(s.geaendert) > langePause;
}