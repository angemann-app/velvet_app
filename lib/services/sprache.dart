import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

/// Sprache der App: Deutsch auf deutschen Geräten, sonst Englisch – oder fest gewählt im Profil.
///
/// Inhalte (Kurse, Listen, Bausteine) liegen auf Deutsch in assets/data/ und auf Englisch in
/// translations/en/; [inhalt] liefert den passenden Pfad. Oberflächentexte kommen aus
/// lib/l10n/app_*.arb ([AppLocalizations]); außerhalb von Widgets über [texte].
class Sprache {
  static const String _key = 'app_language';
  static const List<String> codes = ['de', 'en'];

  /// 'auto', 'de' oder 'en'.
  static final ValueNotifier<String> wahl = ValueNotifier<String>('auto');

  /// Gerätesprache für Tests überschreibbar.
  @visibleForTesting
  static String? geraetFuerTest;

  static String get _geraet {
    final code = geraetFuerTest ?? PlatformDispatcher.instance.locale.languageCode;
    return code == 'de' ? 'de' : 'en';
  }

  /// Die tatsächlich verwendete Sprache: 'de' oder 'en'.
  static String get code => wahl.value == 'auto' ? _geraet : wahl.value;
  static bool get englisch => code == 'en';
  static Locale get locale => Locale(code);

  /// Oberflächentexte ohne BuildContext (Dienste, Benachrichtigungen, Fehlermeldungen).
  static AppLocalizations get texte => (_texte?.localeName == code) ? _texte! : (_texte = lookupAppLocalizations(locale));
  static AppLocalizations? _texte;

  static Future<void> laden() async {
    final prefs = await SharedPreferences.getInstance();
    final w = prefs.getString(_key);
    wahl.value = (w == 'de' || w == 'en') ? w! : 'auto';
  }

  static Future<void> setzen(String neu) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, neu);
    wahl.value = neu;
  }

  /// Pfad einer Inhaltsdatei (z. B. 'velvet_content.json') in der aktuellen Sprache.
  static String inhalt(String datei) => englisch ? 'translations/en/$datei' : 'assets/data/$datei';
}
