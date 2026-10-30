import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color background = Color(0xFF1D1F22); // Nachtpapier (Graphit)
  static const Color surface = Color(0xFF26282C);    // Karte auf Nachtpapier
  static const Color surfaceLight = Color(0xFF34373C); // Erhöhtes Element
  static const Color border = Color(0xFF4A4C50);       // Skizzenlinie
  static const Color sageGreen = Color(0xFFD9A3AB);   // Gedämpftes Rosé (Hauptakzent, früher Salbeigrün)
  static const Color sageLight = Color(0xFFE8C2C8);   // Helles Rosé
  static const Color sageGlow = Color(0x33D9A3AB);    // Sanfter Schimmer
  static const Color amber = Color(0xFFCFA163);       // Gedämpftes Sand
  static const Color amberLight = Color(0xFFE6C48B);
  static const Color amberGlow = Color(0x33CFA163);
  static const Color rose = Color(0xFFF43F5E);        // SOS / Accent
  static const Color roseGlow = Color(0x33F43F5E);

  // Typography Colors
  static const Color textPrimary = Color(0xFFE9E4D8);
  static const Color textSecondary = Color(0xFFB9B3A6);
  static const Color textMuted = Color(0xFF8A857A);

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
      colorScheme: const ColorScheme.dark(
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
      appBarTheme: const AppBarTheme(
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
          side: const BorderSide(color: border, width: 1),
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
          side: const BorderSide(color: border, width: 1.2),
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
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sageGreen, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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
