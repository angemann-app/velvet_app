import 'schlafdaten.dart';
import 'traum_eintrag.dart';
import 'traumpraxis_daten.dart';

/// Tagesbezug, keine medizinische oder kausale Auswertung.
class SchlafTraumTag {
  final String datum;
  final List<SchlafAufzeichnung> messungen;
  final List<TraumEintrag> traeume;
  final PraxisEintrag? beobachtung;
  const SchlafTraumTag(
      this.datum, this.messungen, this.traeume, this.beobachtung);

  bool get klar =>
      beobachtung?.klar == true ||
      traeume.any((t) => t.marken.contains('luzide'));
  bool get sinnlich =>
      beobachtung?.sinnlich == true ||
      traeume.any((t) => t.marken.contains('sinnlich'));
  bool get hoehepunkt =>
      beobachtung?.hoehepunkt == true ||
      traeume.any((t) => t.marken.contains('hoehepunkt'));
  bool get erinnert => traeume.any((t) =>
      !t.marken.contains(TraumEintrag.nichts) &&
      (t.text.trim().isNotEmpty ||
          t.marken
              .any({'erinnert', 'luzide', 'sinnlich', 'hoehepunkt'}.contains)));
  bool get nichtsErinnert =>
      !erinnert && traeume.any((t) => t.marken.contains(TraumEintrag.nichts));
  bool get hatAngaben => beobachtung != null || traeume.isNotEmpty;

  static List<SchlafTraumTag> woche(
      {required DateTime heute,
      required SchlafDaten schlaf,
      required List<TraumEintrag> traeume,
      required TraumpraxisDaten praxis}) {
    // Kalenderarithmetik statt 24-Stunden-Schritten über Zeitumstellungen.
    return [
      for (var i = 0; i < 7; i++)
        _tag(
            SchlafAufzeichnung.datum(
                DateTime(heute.year, heute.month, heute.day - i)),
            schlaf,
            traeume,
            praxis)
    ];
  }

  static SchlafTraumTag _tag(String datum, SchlafDaten schlaf,
          List<TraumEintrag> traeume, TraumpraxisDaten praxis) =>
      SchlafTraumTag(
        datum,
        schlaf.aufzeichnungen.where((r) => r.tag == datum).toList(),
        traeume
            .where((t) => SchlafAufzeichnung.datum(t.zeit.toLocal()) == datum)
            .toList(),
        praxis.tage.where((t) => t.id == datum).firstOrNull,
      );
}
