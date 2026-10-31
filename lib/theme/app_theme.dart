import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AppTheme {
  // Zwei Paletten: Skizzenbuch (normal) und Spicy (tiefes Weinrot, wärmer). Die Farben sind bewusst keine
  // Konstanten, sondern hängen am Spicy-Modus (docs/konzepte/redesign-bleistift.md); nach dem Umschalten baut
  // SpicyModus.neuAufbauen die Oberfläche neu auf.
  static bool get _sp => StorageService.spicyMode();
  static Color _w(Color normal, Color spicy) => _sp ? spicy : normal;

  // Brand Colors
  static Color get background => _w(const Color(0xFF1D1F22), const Color(0xFF1A0F14)); // Nachtpapier (Graphit)
  static Color get surface => _w(const Color(0xFF26282C), const Color(0xFF2A1820));    // Karte auf Nachtpapier
  static Color get surfaceLight => _w(const Color(0xFF34373C), const Color(0xFF3B2330)); // Erhöhtes Element
  static Color get border => _w(const Color(0xFF4A4C50), const Color(0xFF5E3744));       // Skizzenlinie
  static Color get sageGreen => _w(const Color(0xFFD9A3AB), const Color(0xFFEE8497));   // Gedämpftes Rosé (Hauptakzent, früher Salbeigrün)
  static Color get sageLight => _w(const Color(0xFFE8C2C8), const Color(0xFFF7B8C4));   // Helles Rosé
  static Color get sageGlow => _w(const Color(0x33D9A3AB), const Color(0x44EE8497));    // Sanfter Schimmer
  static Color get amber => _w(const Color(0xFFCFA163), const Color(0xFFE0956A));       // Gedämpftes Sand
  static Color get amberLight => _w(const Color(0xFFE6C48B), const Color(0xFFF0B48C));
  static Color get amberGlow => _w(const Color(0x33CFA163), const Color(0x44E0956A));
  static Color get rose => _w(const Color(0xFFF43F5E), const Color(0xFFFF4D6D));        // SOS / Accent
  static Color get roseGlow => _w(const Color(0x33F43F5E), const Color(0x44FF4D6D));

  // Typography Colors
  static Color get textPrimary => _w(const Color(0xFFE9E4D8), const Color(0xFFF4E8E4));
  static Color get textSecondary => _w(const Color(0xFFB9B3A6), const Color(0xFFCDB5B3));
  static Color get textMuted => _w(const Color(0xFF9B968B), const Color(0xFFAA8F8E));

  /// Überschriften in Serif (Android: Noto Serif, ohne mitgelieferte Schriftdatei), alles andere bleibt Systemschrift.
  static const TextTheme _ueberschriften = TextTheme(
    headlineLarge: TextStyle(fontFamily: 'serif'),
    headlineMedium: TextStyle(fontFamily: 'serif'),
    headlineSmall: TextStyle(fontFamily: 'serif'),
    titleLarge: TextStyle(fontFamily: 'serif'),
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: sageGreen,
        secondary: amber,
        surface: surface,
        surfaceContainerHighest: surfaceLight,
        error: rose,
        onPrimary: Color(0xFF2A1518),
        onSecondary: Color(0xFF451A03),
        onSurface: textPrimary,
      ),
      fontFamily: null, // Fließtext: Systemschrift; Überschriften serif (Skizzenbuch, siehe docs/konzepte/redesign-bleistift.md)
      textTheme: _ueberschriften,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sageGreen,
          foregroundColor: const Color(0xFF2A1518),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: sageGreen, width: 1.5),
        ),
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: sageGreen,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
