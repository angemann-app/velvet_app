import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Hält das Handy bei ausgeschaltetem Bildschirm wach genug, damit lange Wiedergaben (Audioreihe, Reisen) ohne Stocken
/// weiterlaufen. Technisch ein Teil-Wachhaltesperre (`PARTIAL_WAKE_LOCK`) der CPU; der Bildschirm bleibt aus.
/// Die Sperre endet spätestens nach vier Stunden von selbst. Ohne Android (Tests, Vorschau) tut das nichts.
class WachHalten {
  static const _kanal = MethodChannel('velvetpulse/wach');
  static int _zaehler = 0;

  /// Wachhalten anfordern. Mehrere Aufrufe zählen, die Sperre fällt erst, wenn alle wieder [freigeben] gerufen haben.
  static Future<void> halten() async {
    _zaehler++;
    if (_zaehler != 1) return;
    try {
      await _kanal.invokeMethod<void>('halten');
    } catch (e) {
      debugPrint('WachHalten: $e');
    }
  }

  static Future<void> freigeben() async {
    if (_zaehler == 0) return;
    _zaehler--;
    if (_zaehler != 0) return;
    try {
      await _kanal.invokeMethod<void>('freigeben');
    } catch (e) {
      debugPrint('WachHalten: $e');
    }
  }

  @visibleForTesting
  static void zuruecksetzenFuerTest() => _zaehler = 0;
}
