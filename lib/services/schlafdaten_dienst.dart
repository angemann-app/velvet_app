import 'package:flutter/services.dart';
import '../models/schlafdaten.dart';
import 'storage_service.dart';

class SchlafZugang {
  final bool verfuegbar, berechtigt;
  const SchlafZugang(this.verfuegbar, this.berechtigt);
}

/// Ausschließlich manuelle, lokale Health-Connect-Abfragen.
class SchlafdatenDienst {
  final MethodChannel kanal;
  int _generation = 0;
  SchlafdatenDienst(
      {this.kanal = const MethodChannel('velvetpulse/schlafdaten')});

  Future<SchlafZugang> status() async {
    try {
      final j = await kanal.invokeMapMethod<String, dynamic>('status');
      return SchlafZugang(j?['verfuegbar'] == true, j?['berechtigt'] == true);
    } on MissingPluginException {
      return const SchlafZugang(false, false);
    }
  }

  Future<bool> berechtigen() async =>
      await kanal.invokeMethod<bool>('berechtigen') == true;
  Future<void> einstellungen() => kanal.invokeMethod<void>('einstellungen');
  void abbrechen() {
    _generation++;
  }

  Future<List<SchlafAufzeichnung>> lesen({DateTime? zeit}) async {
    final gen = ++_generation;
    final now = (zeit ?? DateTime.now()).toUtc();
    if (!(await status()).berechtigt)
      throw PlatformException(code: 'berechtigung_fehlt');
    final raw = await kanal.invokeListMethod<dynamic>('lesen', {
      'startMs': now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      'endeMs': now.millisecondsSinceEpoch,
    }).timeout(const Duration(seconds: 45));
    if (gen != _generation || !StorageService.spicyMode())
      throw StateError('Abgleich abgebrochen');
    if (raw == null || raw.length > 500)
      throw const FormatException('Schlafdatenlimit');
    return raw
        .map((r) => SchlafAufzeichnung.ausHealth(
            Map<String, dynamic>.from(r as Map), now))
        .toList();
  }

  Future<void> verbinden() =>
      StorageService.saveSchlafdaten((d) => d.verbindung(true));

  Future<void> uebernehmen(
      List<SchlafAufzeichnung> daten, String quelle) async {
    final gen = _generation;
    final zugang = await status();
    if (!zugang.berechtigt || !StorageService.spicyMode())
      throw StateError('Abgleich nicht freigegeben');
    final subset = daten.where((r) => r.quelle == quelle).toList();
    if (subset.isEmpty) throw const FormatException('Keine Quelle gewählt');
    await StorageService.saveSchlafdaten((d) {
      if (gen != _generation || !d.verbunden || !StorageService.spicyMode())
        throw StateError('Abgleich abgebrochen');
      return d.zusammen(SchlafDaten(
          aufzeichnungen: subset, letzterAbgleich: DateTime.now().toUtc()));
    });
  }

  Future<void> trennen() async {
    abbrechen();
    await StorageService.saveSchlafdaten((d) => d.verbindung(false));
  }

  Future<void> loeschen() async {
    abbrechen();
    await StorageService.saveSchlafdaten((d) => d.loeschen(DateTime.now()));
  }
}
