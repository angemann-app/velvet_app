import 'traum_eintrag.dart';

/// Wochenrückblick im Traumtagebuch (docs/konzepte/traum-reise.md, „Bausteine“ 5).
///
/// Fasst die Traumtagebuch-Einträge der letzten sieben Tage rein deskriptiv zusammen:
/// Einträge gesamt, erinnerte Träume, „Nichts erinnert“, Anzahl je Markierung und
/// Markierungen je Abend.
///
/// Reine Funktion, keine Wertung, kein Punktestand, keine Rangliste oder Serien.
class TraumRueckblick {
  /// Anzahl aller Einträge in den letzten sieben Tagen.
  final int eintraegeGesamt;

  /// Anzahl der Einträge, bei denen sich erinnert wurde (Marke 'erinnert').
  final int erinnert;

  /// Anzahl der Einträge mit 'nichts' (Nichts erinnert).
  final int nichtsErinnert;

  /// Anzahl je Markierung (z. B. 'luzide': 2, 'sinnlich': 3), ohne 'nichts'.
  final Map<String, int> markenZaehlung;

  /// Für jeden Abend (z. B. 'traum:warmes_wasser') die Markierungen auf danach folgenden Einträgen.
  final Map<String, Map<String, int>> abendMarken;

  const TraumRueckblick({
    required this.eintraegeGesamt,
    required this.erinnert,
    required this.nichtsErinnert,
    required this.markenZaehlung,
    required this.abendMarken,
  });

  /// Berechnet den Rückblick für die letzten sieben Tage vor [jetzt] (inklusive).
  /// [jetzt] ist für reproduzierbare Tests optional übergebbar (Standard: DateTime.now()).
  static TraumRueckblick berechnen(List<TraumEintrag> eintraege, {DateTime? jetzt}) {
    final stichtag = jetzt ?? DateTime.now();
    final grenze = stichtag.subtract(const Duration(days: 7));

    final relevant = eintraege.where((e) => !e.zeit.isBefore(grenze) && !e.zeit.isAfter(stichtag)).toList();

    int zaehlerErinnert = 0;
    int zaehlerNichts = 0;
    final Map<String, int> marken = {};
    final Map<String, Map<String, int>> abendMap = {};

    for (final e in relevant) {
      if (e.marken.contains('erinnert')) zaehlerErinnert++;
      if (e.marken.contains(TraumEintrag.nichts)) zaehlerNichts++;

      for (final m in e.marken) {
        if (m == TraumEintrag.nichts) continue;
        marken[m] = (marken[m] ?? 0) + 1;
      }

      if (e.abend != null && e.abend!.trim().isNotEmpty) {
        final a = e.abend!.trim();
        final ziel = abendMap.putIfAbsent(a, () => <String, int>{});
        for (final m in e.marken) {
          ziel[m] = (ziel[m] ?? 0) + 1;
        }
      }
    }

    return TraumRueckblick(
      eintraegeGesamt: relevant.length,
      erinnert: zaehlerErinnert,
      nichtsErinnert: zaehlerNichts,
      markenZaehlung: marken,
      abendMarken: abendMap,
    );
  }
}
