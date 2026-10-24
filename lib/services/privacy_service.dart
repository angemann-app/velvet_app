import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/t.dart';

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

  static Future<bool> isDiscreetIcon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDiscreetIcon) ?? false;
  }

  static Future<bool> isSupported() async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Fragt Fingerabdruck oder Geräte-PIN ab. Gibt true bei Erfolg zurück.
  static Future<bool> authenticate({String? reason}) async {
    reason ??= t.privacyServiceUnlockTheApp;
    if (_authenticating) return false;
    _authenticating = true;
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } catch (e) {
      debugPrint('PrivacyService authenticate error: $e');
      return false;
    } finally {
      _authenticating = false;
    }
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
