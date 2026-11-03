import 'pakete.dart';

/// Prüft Dateien statt nur die Versionsmarke eines Pakets. Auch ein teilweise
/// installiertes Paket mit fehlenden Dateien gilt nicht als vollständig.
class AufnahmeStand {
  final int benoetigt;
  final int vorhanden;
  const AufnahmeStand({required this.benoetigt, required this.vorhanden});
  bool get vollstaendig => benoetigt > 0 && vorhanden == benoetigt;

  static AufnahmeStand pruefen(Iterable<String> pfade, {String? sprache}) {
    final dateien = pfade.toSet();
    var anzahl = 0;
    for (final pfad in dateien) {
      final eingebaut = pfad == 'audio/paar/klangschale.opus' ||
          pfad == 'audio/paar/klangteppich.opus';
      if (eingebaut || Pakete.datei(pfad, sprache: sprache) != null) anzahl++;
    }
    return AufnahmeStand(benoetigt: dateien.length, vorhanden: anzahl);
  }
}
