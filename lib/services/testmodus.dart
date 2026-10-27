import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/paar_abend.dart';

/// Testmodus zum Durchhören (nur für den eigenen Test, nicht in der Sicherung): siebenmal auf die
/// Versionsnummer im Profil tippen schaltet ihn ein oder aus. Kürzt alle Stillen der geführten Audios auf
/// wenige Sekunden, schaltet alle Folgen von „Lust im Traum“ frei, hebt die Wochenregel des nächtlichen
/// Weckens auf und zeigt die Tagebuch-Karte zu jeder Uhrzeit. Schaltet nichts frei, was nicht ohnehin in der
/// App steckt; Spicy-Inhalte bleiben hinter dem Spicy-Modus.
class Testmodus {
  static const _key = 'velvet_testmodus';
  static const _tippenNoetig = 7;
  static const stille = Duration(seconds: 2);

  static final ValueNotifier<bool> aktiv = ValueNotifier(false);
  static SharedPreferences? _prefs;
  static int _tipps = 0;
  static DateTime _letzterTipp = DateTime(0);

  static void init(SharedPreferences prefs) {
    _prefs = prefs;
    aktiv.value = prefs.getBool(_key) ?? false;
  }

  static bool get an => aktiv.value;

  /// Ein Tipp auf die Versionsnummer. Gibt den neuen Zustand zurück, sobald umgeschaltet wurde, sonst null.
  static bool? tippen({DateTime? jetzt}) {
    final t = jetzt ?? DateTime.now();
    _tipps = t.difference(_letzterTipp) > const Duration(seconds: 2) ? 1 : _tipps + 1;
    _letzterTipp = t;
    if (_tipps < _tippenNoetig) return null;
    _tipps = 0;
    aktiv.value = !aktiv.value;
    _prefs?.setBool(_key, aktiv.value);
    return aktiv.value;
  }

  /// Im Testmodus jede Stille auf [stille] kürzen; Ansagen und Klangschale bleiben.
  static List<PaarSchritt> kuerzen(List<PaarSchritt> ablauf) {
    if (!an) return ablauf;
    return [
      for (final s in ablauf)
        if (s.baustein == null && !s.klang && s.dauer > stille) PaarSchritt.stille(stille, s.runde) else s,
    ];
  }

  @visibleForTesting
  static void zuruecksetzen() {
    aktiv.value = false;
    _tipps = 0;
    _letzterTipp = DateTime(0);
  }
}
