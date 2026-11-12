import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Geheimnisse (privater Nostr-Schlüssel) liegen nicht in den
/// SharedPreferences, sondern in einem vom Android-Keystore verschlüsselten Speicher.
/// Dessen Dateien sind vom Cloud-Backup und von der Geräteübertragung ausgenommen
/// (res/xml/backup_rules.xml, data_extraction_rules.xml): Der Keystore-Schlüssel
/// verlässt das Gerät nicht, eine kopierte Datei wäre ohnehin nicht lesbar.
///
/// Damit die übrige App synchron lesen kann, hält [init] die Werte im Speicher.
/// Es gibt keinen Klartext-Fallback: Schlägt der sichere Speicher fehl, bleibt ein
/// neuer Wert nur für diese Sitzung im Arbeitsspeicher. Ein Altbestand bleibt in den
/// SharedPreferences, bis er einmal erfolgreich umgezogen ist.
class SecretStore {
  static const String nostrPrivKey = 'velvet_nostr_privkey';
  static const List<String> _all = [nostrPrivKey];

  /// Altlasten des entfernten KI-Coachs (12.11.2026): Gemini-Schlüssel (Keystore und frühere
  /// SharedPreferences) und Chatverlauf. [init] löscht sie bei jedem Start; Löschen eines
  /// nicht vorhandenen Eintrags ist harmlos, daher braucht es keinen Merker.
  static const String _altGeminiSchluessel = 'gemini_api_key';
  static const String _altChatVerlauf = 'ai_chat_history';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final Map<String, String> _cache = {};
  static bool _ready = false;

  /// Lädt die Geheimnisse und verschiebt Altbestände aus den SharedPreferences
  /// (Versionen bis 4.3.0-beta.1) einmalig in den sicheren Speicher.
  static Future<void> init(SharedPreferences prefs) async {
    if (_ready) return;
    await _altlastenLoeschen(prefs);
    for (final key in _all) {
      String? value;
      try {
        value = await _storage.read(key: key);
      } catch (e) {
        // Typisch nach einer Wiederherstellung auf neuem Gerät: Daten ohne passenden Keystore-Schlüssel.
        debugPrint('SecretStore: $key nicht lesbar, wird verworfen (${e.runtimeType})');
        await _deleteQuietly(key);
      }
      final legacy = prefs.getString(key);
      var migrated = true;
      if ((value == null || value.isEmpty) && legacy != null && legacy.trim().isNotEmpty) {
        value = legacy.trim();
        migrated = await _writeQuietly(key, value);
      }
      // Den Klartext erst löschen, wenn er sicher abgelegt ist, sonst ginge z. B. die Paar-Verbindung verloren.
      if (legacy != null && migrated) await prefs.remove(key);
      if (value != null && value.isNotEmpty) _cache[key] = value;
    }
    _ready = true;
  }

  static Future<void> _altlastenLoeschen(SharedPreferences prefs) async {
    await _deleteQuietly(_altGeminiSchluessel);
    try {
      await prefs.remove(_altGeminiSchluessel);
      await prefs.remove(_altChatVerlauf);
    } catch (e) {
      debugPrint('SecretStore: Altlasten nicht gelöscht (${e.runtimeType})');
    }
  }

  static String? read(String key) => _cache[key];

  static Future<void> write(String key, String? value) async {
    if (value == null || value.isEmpty) {
      _cache.remove(key);
      await _deleteQuietly(key);
    } else {
      _cache[key] = value;
      await _writeQuietly(key, value);
    }
  }

  static Future<bool> _writeQuietly(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true;
    } catch (e) {
      debugPrint('SecretStore: $key konnte nicht sicher gespeichert werden (${e.runtimeType})');
      return false;
    }
  }

  static Future<void> _deleteQuietly(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }

  @visibleForTesting
  static void resetForTest() {
    _cache.clear();
    _ready = false;
  }
}
