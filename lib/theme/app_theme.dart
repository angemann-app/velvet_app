import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import 'vp_palette.dart';
import 'vp_tokens.dart';

/// Zugang zu den Entwurfswerten der aktuellen Atmosphäre (docs/konzepte/designsystem-magazin.md).
///
/// Die Farben sind bewusst keine Konstanten: Sie hängen am Spicy-Modus und an der gewählten Darstellung
/// (Papier, Nachtpapier, Klassisch). Nach einem Wechsel baut `main.dart` die Oberfläche neu auf.
/// Neuer Code nutzt die Rollennamen (`papier`, `tinte`, `akzent` …) oder `context.vp`.
class AppTheme {
  /// Gilt gerade: Spicy vor der gewählten Darstellung des Normalmodus.
  static VpPaletteId get paletteId =>
      StorageService.spicyMode() ? VpPaletteId.spicy : (VpPaletteId.ausName(StorageService.designPalette()) ?? VpPaletteId.papier);

  static VpPalette get palette => VpPalette.von(paletteId);
  static VpTokens get tokens => VpTokens.von(palette);

  // Rollen
  static Color get papier => palette.papier;
  static Color get papierErhoben => palette.papierErhoben;
  static Color get papierVertieft => palette.papierVertieft;
  static Color get tinte => palette.tinte;
  static Color get tinteLeise => palette.tinteLeise;
  static Color get tinteStumm => palette.tinteStumm;
  static Color get linie => palette.linie;
  static Color get linieStark => palette.linieStark;
  static Color get akzent => palette.akzent;
  static Color get akzentHell => palette.akzentHell;
  static Color get akzentLeise => palette.akzentLeise;
  static Color get akzentTief => palette.akzentTief;
  static Color get akzentTiefLeise => palette.akzentTiefLeise;
  static Color get signalLeise => palette.signalLeise;
  static Color get aufAkzent => palette.aufAkzent;
  static Color get aufAkzentTief => palette.aufAkzentTief;
  static Color get aufSignal => palette.aufSignal;

  /// Text auf Bildern mit dunkler Abdunklung (Titelbild-Kacheln): in allen Atmosphären hell, weil die Abdunklung es ist.
  static const Color aufBild = Color(0xFFF6F0E6);

  /// Text und Symbole auf gefüllten Statusflächen (Ja, Vielleicht): hell auf Papier, dunkel auf den dunklen Atmosphären.
  static Color get aufStatus => palette.istDunkel ? palette.aufAkzent : palette.papierErhoben;
  static Color get akzentTiefHell => palette.akzentTiefHell;
  static Color get tiefe => palette.tiefe;
  static Color get signal => palette.signal;
  static Color get statusJa => palette.statusJa;
  static Color get statusVielleicht => palette.statusVielleicht;
  static Color get statusNein => palette.statusNein;

  /// Das Theme der aktuellen Atmosphäre.
  static ThemeData get darkTheme => themeData(palette);

  static ThemeData themeData(VpPalette p) {
    final tokens = VpTokens.von(p);
    final typo = tokens.typo;
    final dunkel = p.istDunkel;

    final scheme = (dunkel ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
      primary: p.akzent,
      onPrimary: p.aufAkzent,
      secondary: p.akzentTief,
      onSecondary: dunkel ? p.aufAkzent : p.papierErhoben,
      surface: p.papierErhoben,
      onSurface: p.tinte,
      surfaceContainerHighest: p.papierVertieft,
      surfaceContainerHigh: p.papierVertieft,
      surfaceContainer: p.papierErhoben,
      surfaceContainerLow: p.papier,
      outline: p.linieStark,
      outlineVariant: p.linie,
      error: p.signal,
      onError: Colors.white,
    );

    // Anzeige, Überschriften und Titel in Serif; Fließtext und Beschriftungen bleiben Systemschrift.
    final textTheme = TextTheme(
      displayLarge: typo.anzeige.copyWith(fontSize: 40),
      displayMedium: typo.anzeige,
      displaySmall: typo.anzeige.copyWith(fontSize: 30),
      headlineLarge: typo.ueberschrift.copyWith(fontSize: 28),
      headlineMedium: typo.ueberschrift,
      headlineSmall: typo.ueberschrift.copyWith(fontSize: 21),
      titleLarge: typo.titel.copyWith(fontSize: 20),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3, color: p.tinte),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3, color: p.tinte),
      bodyLarge: typo.fliesstext.copyWith(fontSize: 16),
      bodyMedium: typo.fliesstext,
      bodySmall: typo.beschriftung,
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.tinte),
      labelMedium: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: p.tinteLeise),
      labelSmall: typo.eyebrow,
    );

    final haar = BorderSide(color: p.linie, width: VpLinie.haar);
    final rahmen = BorderSide(color: p.linie, width: VpLinie.rahmen);

    return ThemeData(
      useMaterial3: true,
      brightness: p.helligkeit,
      scaffoldBackgroundColor: p.papier,
      canvasColor: p.papier,
      colorScheme: scheme,
      fontFamily: null,
      textTheme: textTheme,
      extensions: [tokens],
      splashFactory: InkRipple.splashFactory,
      dividerTheme: DividerThemeData(color: p.linie, thickness: VpLinie.haar, space: 1),
      iconTheme: IconThemeData(color: p.tinte),
      appBarTheme: AppBarTheme(
        backgroundColor: p.papier,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: typo.titel.copyWith(fontSize: 22),
        iconTheme: IconThemeData(color: p.tinte),
      ),
      cardTheme: CardThemeData(
        color: p.papierErhoben,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte), side: haar),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.akzent,
          foregroundColor: p.aufAkzent,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.akzent,
          foregroundColor: p.aufAkzent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.tinte,
          side: BorderSide(color: p.linieStark, width: VpLinie.rahmen),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.akzentTief,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: p.tinte)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.papierVertieft.withValues(alpha: dunkel ? 0.4 : 0.55),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(VpRadius.feld), borderSide: rahmen),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(VpRadius.feld), borderSide: rahmen),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VpRadius.feld),
          borderSide: BorderSide(color: p.akzentTief, width: 1.5),
        ),
        labelStyle: TextStyle(color: p.tinteLeise),
        hintStyle: TextStyle(color: p.tinteStumm),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.papier,
        selectedItemColor: p.akzentTief,
        unselectedItemColor: p.tinteStumm,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.papierErhoben,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte), side: rahmen),
        titleTextStyle: typo.titel.copyWith(fontSize: 20),
        contentTextStyle: typo.fliesstext,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.papierErhoben,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: p.papierErhoben,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(VpRadius.blatt)),
          side: haar,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.papier,
        selectedColor: p.akzentLeise,
        disabledColor: p.papierVertieft,
        side: haar,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.tinte),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.chip)),
        showCheckmark: false,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: p.akzentTief,
        inactiveTrackColor: p.linie,
        thumbColor: p.akzentTief,
        overlayColor: p.akzentLeise,
        trackHeight: 2,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.papierErhoben : p.tinteStumm),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.akzentTief : p.papierVertieft),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.akzentTief : p.linieStark),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.akzentTief : Colors.transparent),
        checkColor: WidgetStatePropertyAll(p.papierErhoben),
        side: BorderSide(color: p.linieStark, width: VpLinie.rahmen),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.akzentTief : p.linieStark),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.akzentTief,
        linearTrackColor: p.linie,
        circularTrackColor: p.linie,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.tinte,
        contentTextStyle: TextStyle(color: p.papier, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.akzentTief,
        unselectedLabelColor: p.tinteStumm,
        indicatorColor: p.akzentTief,
        dividerColor: p.linie,
      ),
      listTileTheme: ListTileThemeData(iconColor: p.tinteLeise, textColor: p.tinte),
      popupMenuTheme: PopupMenuThemeData(
        color: p.papierErhoben,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld), side: haar),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: p.tinte, borderRadius: BorderRadius.circular(VpRadius.chip)),
        textStyle: TextStyle(color: p.papier, fontSize: 12),
      ),
    );
  }
}
