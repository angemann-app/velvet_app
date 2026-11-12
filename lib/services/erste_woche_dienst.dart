import '../models/bedien_daten.dart';
import 'storage_service.dart';

/// Lesen und Schreiben von „Eure erste Woche“ (nur lokal, Teil von [BedienDaten]).
/// Es gibt bewusst keinen Versand, keine Erinnerung und keine Auswertung.
class ErsteWocheDienst {
  ErsteWocheDienst._();

  static ErsteWocheStand? stand() => StorageService.getBedienDaten().ersteWoche;

  /// Markiert einen Schritt als „getan“ oder „uebersprungen“.
  static Future<void> markieren(int nr, String wert, {DateTime? jetzt, bool backup = true}) {
    final j = (jetzt ?? DateTime.now()).toUtc();
    final alt = stand() ?? ErsteWocheStand(geaendert: j);
    return StorageService.saveBedienDaten(
        BedienDaten(ersteWoche: alt.mitSchritt(nr, wert, j)),
        backup: backup);
  }

  /// Blendet die Karte aus oder wieder ein.
  static Future<void> ausgeblendet(bool ja, {DateTime? jetzt, bool backup = true}) {
    final j = (jetzt ?? DateTime.now()).toUtc();
    final alt = stand() ?? ErsteWocheStand(geaendert: j);
    return StorageService.saveBedienDaten(BedienDaten(
        ersteWoche: alt.kopie(ausgeblendet: ja, geaendert: j)),
        backup: backup);
  }
}
