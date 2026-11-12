import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/t.dart';

/// Ergebnis der Standard-Einrichtung der App-Sperre am Ende des Onboardings.
enum SperrEinrichtung {
  /// Sperre ist jetzt an (Gerätesperre wurde bestätigt).
  eingeschaltet,

  /// War schon an, nichts zu tun.
  schonAn,

  /// Das Gerät hat keine Bildschirmsperre; die Sperre bleibt aus.
  nichtMoeglich,

  /// Die Bestätigung wurde abgebrochen oder ist misslungen; die Sperre bleibt aus.
  abgebrochen,
}

/// Diskretions-Modus: App-Sperre per Fingerabdruck und unauffälliges App-Symbol.
class PrivacyService {
  static String _keyLockEnabled = 'privacy_lock_enabled';
  static String _keyDiscreetIcon = 'privacy_discreet_icon';

  /// Nach so langer Zeit im Hintergrund wird wieder entsperrt.
  static Duration relockAfter = Duration(minutes: 1);

  static MethodChannel _channel = MethodChannel('velvetpulse/privacy');
  static final LocalAuthentication _auth = LocalAuthentication();

  static bool _authenticating = false;

  /// True, solange der Fingerabdruck-Dialog offen ist (er schickt die App kurz in den Hintergrund).
  static bool get isAuthenticating => _authenticating;

  static Future<bool> isLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLockEnabled) ?? false;
  }

  /// Merker, dass die App-Sperre einmal angeboten bzw. eingerichtet wurde (docs/konzepte/privatsphaere-schutz.md, a).
  /// Gerätegebunden und bewusst **nicht** in Sicherung oder Backup-Merge: Eine Sicherung auf einem anderen Gerät
  /// darf dort keine Sperrentscheidung übertragen.
  static const String keyFrageGestellt = 'app_sperre_frage_gestellt';

  static Future<void> _frageMerken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyFrageGestellt, true);
  }

  /// Neue Einrichtung (Ende des Onboardings): Die Sperre wird Standard, wenn das Gerät eine Bildschirmsperre hat.
  /// Dafür einmal die Gerätesperre bestätigen (wie beim Einschalten im Profil), sonst könnte man sich aussperren.
  /// Wird die Bestätigung abgebrochen, bleibt der Merker ungesetzt: Dann fragt die App später einmal (Bestandsfrage).
  static Future<SperrEinrichtung> standardEinrichten() async {
    final ergebnis = await isLockEnabled()
        ? SperrEinrichtung.schonAn
        : !await isSupported()
            ? SperrEinrichtung.nichtMoeglich
            : await setLockEnabled(true)
                ? SperrEinrichtung.eingeschaltet
                : SperrEinrichtung.abgebrochen;
    if (ergebnis != SperrEinrichtung.abgebrochen) await _frageMerken();
    return ergebnis;
  }

  /// Bestand: Soll beim Start einmal gefragt werden, ob die App gesperrt werden soll?
  /// Wer schon eine Sperre hat, wird nie gefragt (Merker wird gesetzt). Ohne Bildschirmsperre wird nichts gezeigt
  /// und nichts gemerkt; der Schalter im Profil bleibt der Weg.
  static Future<bool> frageNoetig() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(keyFrageGestellt) ?? false) return false;
    if (await isLockEnabled()) {
      await _frageMerken();
      return false;
    }
    return isSupported();
  }

  /// Antwort auf die Bestandsfrage: Bei „Ja“ wird gesperrt (mit Bestätigung), in jedem Fall fragt die App
  /// danach nie wieder von selbst. Gibt zurück, ob die Sperre jetzt an ist.
  static Future<bool> frageBeantworten(bool sperren) async {
    await _frageMerken();
    if (!sperren) return false;
    return setLockEnabled(true);
  }

  static Future<bool> isDiscreetIcon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDiscreetIcon) ?? false;
  }

  /// Ersatz für die Geräteprüfung in Tests.
  @visibleForTesting
  static bool? unterstuetztFuerTest;

  static Future<bool> isSupported() async {
    if (unterstuetztFuerTest != null) return unterstuetztFuerTest!;
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Ersatz für den Fingerabdruck-Dialog in Tests.
  @visibleForTesting
  static Future<bool> Function()? authenticateFuerTest;

  /// Uhr, in Tests ersetzbar.
  @visibleForTesting
  static DateTime Function() uhr = DateTime.now;

  /// Zeitpunkt der letzten erfolgreichen Bestätigung der Gerätesperre. Nur im Speicher, nie gespeichert.
  static DateTime? _letzteBestaetigung;

  @visibleForTesting
  static void bestaetigungVergessenFuerTest() => _letzteBestaetigung = null;

  /// Wurde die Gerätesperre in den letzten [dauer] erfolgreich bestätigt (z. B. hat die App-Sperre gerade entsperrt)?
  static bool kuerzlichBestaetigt(Duration dauer) {
    final zuletzt = _letzteBestaetigung;
    if (zuletzt == null) return false;
    final her = uhr().difference(zuletzt);
    return !her.isNegative && her <= dauer;
  }

  /// Fragt Fingerabdruck oder Geräte-PIN ab. Gibt true bei Erfolg zurück.
  static Future<bool> authenticate({String? reason}) async {
    if (authenticateFuerTest != null) return _merken(await authenticateFuerTest!());
    reason ??= t.privacyServiceUnlockTheApp;
    if (_authenticating) return false;
    _authenticating = true;
    try {
      return _merken(await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true));
    } catch (e) {
      debugPrint('PrivacyService authenticate error: $e');
      return false;
    } finally {
      _authenticating = false;
    }
  }

  static bool _merken(bool ok) {
    if (ok) _letzteBestaetigung = uhr();
    return ok;
  }

  /// Schaltet die Sperre um. Beim Einschalten wird zuerst einmal entsperrt,
  /// damit sich niemand versehentlich aussperrt.
  static Future<bool> setLockEnabled(bool enabled) async {
    if (enabled && !await authenticate(reason: t.privacyServiceConfirmToTurnOnThe)) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLockEnabled, enabled);
    await applySecureFlag(enabled);
    return true;
  }

  /// Verbirgt Inhalte in der App-Übersicht und blockiert Screenshots.
  static Future<void> applySecureFlag(bool secure) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('setSecure', secure);
    } catch (e) {
      debugPrint('PrivacyService setSecure error: $e');
    }
  }

  static Future<void> setDiscreetIcon(bool discreet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDiscreetIcon, discreet);
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('setDiscreetIcon', discreet);
    } catch (e) {
      debugPrint('PrivacyService setDiscreetIcon error: $e');
    }
  }
}
