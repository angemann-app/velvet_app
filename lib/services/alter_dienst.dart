import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/t.dart';
import 'privacy_service.dart';
import 'storage_service.dart';

/// Altersnachweis für den Spicy-Modus (docs/konzepte/altersnachweis.md). Alles nur auf dem Gerät:
/// Selbstauskunft mit Geburtsmonat und -jahr, dazu die Gerätesperre. Das Geburtsdatum wird nie gespeichert,
/// nur der Zeitpunkt der Bestätigung. Nichts davon gehört in Sicherung oder Backup-Merge.
class AlterDienst with WidgetsBindingObserver {
  AlterDienst._();

  static const String _keyBestaetigt = 'spicy_alter_bestaetigt';
  static const String _keyGesperrtBis = 'spicy_alter_gesperrt_bis';
  static const String _keyAbsichern = 'spicy_immer_absichern';

  static const int mindestalter = 18;
  static const Duration sperrfrist = Duration(days: 30);

  /// Nach so langer Zeit im Hintergrund fragt Spicy wieder nach der Gerätesperre
  /// (docs/konzepte/privatsphaere-schutz.md, Entscheidung 12.11.2026: fest 5 Stunden).
  static const Duration standardErneutNach = Duration(hours: 5);
  static Duration erneutNach = standardErneutNach;

  /// Zählt hoch, wenn die Entsperrung wegen langer Zeit im Hintergrund verfallen ist und Spicy gewählt war.
  /// main.dart zeigt dann einmal den Hinweis „Spicy-Modus ist aus“ (abholen mit [ablaufHinweisAbholen]).
  static final ValueNotifier<int> ablauf = ValueNotifier<int>(0);
  static bool _ablaufHinweisOffen = false;

  /// True genau einmal je Ablauf: Wer den Hinweis zeigt, holt ihn damit ab.
  static bool ablaufHinweisAbholen() {
    final offen = _ablaufHinweisOffen;
    _ablaufHinweisOffen = false;
    return offen;
  }

  /// Erst [init] schaltet die Prüfung scharf. Ohne [init] (Tests) verhält sich `spicyMode()` wie bisher.
  static bool _pruefen = false;
  static DateTime? _bestaetigt;
  static DateTime? _gesperrtBis;
  static bool _absichern = true;
  static DateTime? _entsperrt;
  static DateTime? _imHintergrundSeit;
  static final AlterDienst _beobachter = AlterDienst._();

  /// Ändert sich beim Sperren und Entsperren, damit Oberflächen folgen.
  static final ValueNotifier<int> aenderung = ValueNotifier<int>(0);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _bestaetigt = _zeit(prefs.getInt(_keyBestaetigt));
    _gesperrtBis = _zeit(prefs.getInt(_keyGesperrtBis));
    _absichern = prefs.getBool(_keyAbsichern) ?? true;
    _entsperrt = null;
    _pruefen = true;
    WidgetsBinding.instance.removeObserver(_beobachter);
    WidgetsBinding.instance.addObserver(_beobachter);
    await geraetesperreKontrollieren();
    _melden();
  }

  @visibleForTesting
  static void zuruecksetzen() {
    _pruefen = false;
    _bestaetigt = _gesperrtBis = _entsperrt = _imHintergrundSeit = null;
    _absichern = true;
    _ablaufHinweisOffen = false;
    erneutNach = standardErneutNach;
  }

  static DateTime? _zeit(int? ms) =>
      ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);

  static void _melden() {
    aenderung.value++;
    StorageService.spicyAenderung.value = StorageService.spicyMode();
  }

  static bool get bestaetigt => _bestaetigt != null;
  static bool get absichern => _absichern;

  /// Spicy ist nutzbar: Alter bestätigt und (falls gewünscht) die Gerätesperre in dieser Sitzung bestätigt.
  /// Ohne scharfe Prüfung (Tests) immer true.
  static bool get frei {
    if (!_pruefen) return true;
    if (_bestaetigt == null) return false;
    return !_absichern || _entsperrt != null;
  }

  /// Bis wann die Angabe „unter 18“ sperrt; null, wenn nicht gesperrt.
  static DateTime? gesperrtBis([DateTime? jetzt]) {
    final bis = _gesperrtBis;
    return bis != null && bis.isAfter(jetzt ?? DateTime.now()) ? bis : null;
  }

  /// Vorsichtig, weil der Tag fehlt: 18 gilt erst, wenn der Geburtsmonat des 18. Jahres vollständig vorbei ist.
  static bool volljaehrig(int jahr, int monat, [DateTime? jetzt]) {
    final j = jetzt ?? DateTime.now();
    final ersterTagNachMonat = DateTime(jahr + mindestalter, monat + 1, 1);
    return !j.isBefore(ersterTagNachMonat);
  }

  static Future<void> _speichern(String key, DateTime? wert) async {
    final prefs = await SharedPreferences.getInstance();
    if (wert == null) {
      await prefs.remove(key);
    } else {
      await prefs.setInt(key, wert.millisecondsSinceEpoch);
    }
  }

  /// Wertet die Angabe aus. Gibt true zurück, wenn volljährig; sonst beginnt die Sperrfrist.
  static Future<bool> angabePruefen(int jahr, int monat, [DateTime? jetzt]) async {
    final j = jetzt ?? DateTime.now();
    if (volljaehrig(jahr, monat, j)) {
      _bestaetigt = j;
      await _speichern(_keyBestaetigt, j);
      return true;
    }
    _gesperrtBis = j.add(sperrfrist);
    await _speichern(_keyGesperrtBis, _gesperrtBis);
    return false;
  }

  /// So kurz zurückliegend darf eine Bestätigung der Gerätesperre sein, damit „Wieder entsperren“ nicht erneut fragt.
  static const Duration kuerzlichBestaetigt = Duration(minutes: 2);

  /// Fragt die Gerätesperre ab und merkt sich bei Erfolg die Entsperrung für diese Sitzung.
  /// [kuerzlichReicht]: Nur für „Wieder entsperren“ nach Ablauf der Frist. Hat die Gerätesperre in den letzten
  /// [kuerzlichBestaetigt] schon bestätigt (z. B. die App-Sperre beim Zurückkehren), wird nicht ein zweites Mal gefragt.
  /// Das Einschalten im Spicy-Dialog fragt immer.
  static Future<bool> entsperren({bool kuerzlichReicht = false}) async {
    final ohneFrage = kuerzlichReicht && PrivacyService.kuerzlichBestaetigt(kuerzlichBestaetigt);
    if (!ohneFrage && !await PrivacyService.authenticate(reason: t.alterSperreGrund)) return false;
    _entsperrt = DateTime.now();
    _ablaufHinweisOffen = false;
    _melden();
    return true;
  }

  static Future<void> setAbsichern(bool wert) async {
    _absichern = wert;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAbsichern, wert);
    if (!wert) _entsperrt = DateTime.now();
    _melden();
  }

  /// Fällt die Gerätesperre weg, geht Spicy wieder aus (Nachweis bleibt, die Wahl nicht).
  static Future<void> geraetesperreKontrollieren() async {
    if (!_pruefen || !StorageService.spicyGewaehlt()) return;
    if (await PrivacyService.isSupported()) return;
    _entsperrt = null;
    await StorageService.setSpicyMode(false);
  }

  @visibleForTesting
  static void hintergrundStartFuerTest(DateTime seit) => _imHintergrundSeit = seit;

  /// Hintergrund länger als [erneutNach]: Entsperrung verfällt.
  @visibleForTesting
  static void hintergrundEnde([DateTime? jetzt]) {
    final seit = _imHintergrundSeit;
    _imHintergrundSeit = null;
    if (!_pruefen || !_absichern || _entsperrt == null || seit == null) return;
    if ((jetzt ?? DateTime.now()).difference(seit) > erneutNach) {
      _entsperrt = null;
      // Nur wer Spicy gewählt hat, merkt den Wechsel; dann einmal klar sagen, warum die Farben umspringen.
      if (StorageService.spicyGewaehlt()) {
        _ablaufHinweisOffen = true;
        ablauf.value++;
      }
      _melden();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Der Gerätesperre-Dialog schickt die App selbst kurz in den Hintergrund.
    if (PrivacyService.isAuthenticating) return;
    if (state == AppLifecycleState.paused) {
      _imHintergrundSeit = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      hintergrundEnde();
      geraetesperreKontrollieren();
    }
  }
}
