import 'traum_eintrag.dart';

/// Vorlagen nur aus dem lokalen Tagebuch; keine Auswertung sexueller Vorlieben.
class Traumpraxis {
  static List<TraumEintrag> vorlagen(List<TraumEintrag> eintraege) => eintraege
      .where((e) =>
          e.text.trim().isNotEmpty &&
          !e.marken.contains(TraumEintrag.nichts) &&
          !e.marken.any(TraumEintrag.belastend.contains))
      .toList()
    ..sort((a, b) => b.zeit.compareTo(a.zeit));

  static bool pauseRaten(List<TraumEintrag> eintraege) {
    final sortiert = [...eintraege]..sort((a, b) => b.zeit.compareTo(a.zeit));
    return TraumEintrag.pauseRaten(sortiert);
  }
}
