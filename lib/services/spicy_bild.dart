import 'storage_service.dart';

/// Titelbilder im Menü (Kursbilder, Ja/Nein/Vielleicht-Bereiche, geführte Audios): Im Spicy-Modus die dezent intimere
/// Fassung `*_spicy.svg` (tools/generate_covers.py --spicy), sonst das normale Bild. Beide sind SVG und liegen in der APK.
/// Konzept: docs/konzepte/kursbilder.md, Entscheidung vom 29.10.2026.
String spicyBild(String pfad) {
  if (!StorageService.spicyMode() || !_menueBild.hasMatch(pfad)) return pfad;
  return pfad.replaceFirst(RegExp(r'\.svg$'), '_spicy.svg');
}

final _menueBild = RegExp(r'^assets/images/(cover_\d+|guided_[a-z]+|ynm_[a-z_]+)\.svg$');
