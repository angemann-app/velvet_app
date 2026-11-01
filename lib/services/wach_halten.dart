import 'package:flutter/widgets.dart';
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

/// Für Bildschirme mit langer Wiedergabe: [wachAn] beim Start und beim Weiterspielen, [wachAus] bei Pause, Ende und
/// Verlassen. Der Bildschirm gibt die Sperre beim Entsorgen selbst frei.
mixin WachHalter<T extends StatefulWidget> on State<T> {
  bool _wachGehalten = false;

  void wachAn() {
    if (_wachGehalten) return;
    _wachGehalten = true;
    WachHalten.halten();
  }

  void wachAus() {
    if (!_wachGehalten) return;
    _wachGehalten = false;
    WachHalten.freigeben();
  }

  @override
  void dispose() {
    wachAus();
    super.dispose();
  }
}
