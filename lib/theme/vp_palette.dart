import 'package:flutter/material.dart';

/// Welche Atmosphäre gerade gilt. Spicy hat Vorrang, sonst gilt die gewählte Darstellung des Normalmodus.
enum VpPaletteId {
  /// Helles Magazin: Elfenbein, Graphit, gedecktes Altrosa (Standard).
  papier,

  /// Dunkle Lesart derselben Gestaltung.
  nacht,

  /// Die Farben bis Build 55 (Übergangsphase, siehe docs/konzepte/designsystem-magazin.md).
  klassisch,

  /// Bordeaux und Pflaume, wärmeres Papierweiß, kräftigeres Altrosa.
  spicy;

  static VpPaletteId? ausName(String? name) {
    for (final p in values) {
      if (p.name == name) return p;
    }
    return null;
  }
}

/// Alle Farben einer Atmosphäre, benannt nach ihrer Aufgabe und nicht nach ihrem Farbton.
/// Die Werte gehören hierher und nirgends sonst hin; Bildschirme lesen sie über `AppTheme` oder `context.vp`.
@immutable
class VpPalette {
  final VpPaletteId id;
  final Brightness helligkeit;

  /// Grundfläche der Seite.
  final Color papier;

  /// Karten und Flächen, die sich von der Seite abheben.
  final Color papierErhoben;

  /// Eingelassene oder hervorgehobene Elemente (Felder, gewählte Chips).
  final Color papierVertieft;

  /// Haupttext und Symbole.
  final Color tinte;
  final Color tinteLeise;
  final Color tinteStumm;

  /// Haarlinien und Rahmen; `linieStark` für Trennungen, die tragen müssen.
  final Color linie;
  final Color linieStark;

  /// Markenakzent für Flächen, Linien und große Elemente. Als Text nur `akzentTief`.
  final Color akzent;
  final Color akzentHell;
  final Color akzentLeise;

  /// Kräftigere Akzentstufe für kleinen Text und Symbole auf `papier` und `papierErhoben`.
  final Color akzentTief;
  final Color akzentTiefHell;
  final Color akzentTiefLeise;

  /// Text und Symbole auf Akzentflächen.
  final Color aufAkzent;

  /// Text und Symbole auf Flächen in kzentTief.
  final Color aufAkzentTief;

  /// Text und Symbole auf Flächen in signal.
  final Color aufSignal;

  /// SOS und Fehler. Sonst nirgends.
  final Color signal;
  final Color signalLeise;

  /// Zustandsfarben (Ja, Vielleicht, Nein), gedämpft und mit der Marke verwandt.
  final Color statusJa;
  final Color statusVielleicht;
  final Color statusNein;

  /// Tiefenton für Vignetten und Bildränder.
  final Color tiefe;

  const VpPalette({
    required this.id,
    required this.helligkeit,
    required this.papier,
    required this.papierErhoben,
    required this.papierVertieft,
    required this.tinte,
    required this.tinteLeise,
    required this.tinteStumm,
    required this.linie,
    required this.linieStark,
    required this.akzent,
    required this.akzentHell,
    required this.akzentLeise,
    required this.akzentTief,
    required this.akzentTiefHell,
    required this.akzentTiefLeise,
    required this.aufAkzent,
    required this.aufAkzentTief,
    required this.aufSignal,
    required this.signal,
    required this.signalLeise,
    required this.statusJa,
    required this.statusVielleicht,
    required this.statusNein,
    required this.tiefe,
  });

  bool get istDunkel => helligkeit == Brightness.dark;

  /// Papier: Ausgangswerte aus dem Auftrag (Hintergrund F6F0E6, Karten FBF7F0, Text 2A2A2C / 5A5750, Akzent C98A93; der Akzent ist auf B47C84 vertieft, damit er als Linie und große Fläche 3 : 1 auf Papier erreicht).
  static const papierPalette = VpPalette(
    id: VpPaletteId.papier,
    helligkeit: Brightness.light,
    papier: Color(0xFFF6F0E6),
    papierErhoben: Color(0xFFFBF7F0),
    papierVertieft: Color(0xFFEDE5D6),
    tinte: Color(0xFF2A2A2C),
    tinteLeise: Color(0xFF5A5750),
    tinteStumm: Color(0xFF66625A),
    linie: Color(0xFFD8CFBF),
    linieStark: Color(0xFFB3A996),
    akzent: Color(0xFFB47C84),
    akzentHell: Color(0xFFDDAAB1),
    akzentLeise: Color(0x33B47C84),
    akzentTief: Color(0xFF8E4A57),
    akzentTiefHell: Color(0xFFA85E6B),
    akzentTiefLeise: Color(0x338E4A57),
    aufAkzent: Color(0xFF2A1518),
    aufAkzentTief: Color(0xFFFBF7F0),
    aufSignal: Color(0xFFFFFFFF),
    signal: Color(0xFFB8283F),
    signalLeise: Color(0x33B8283F),
    statusJa: Color(0xFF5F8A6B),
    statusVielleicht: Color(0xFFA9843F),
    statusNein: Color(0xFF9A6770),
    tiefe: Color(0xFFE6D9C6),
  );

  /// Nachtpapier: das bisherige Graphit, an die neuen Rollen angepasst.
  static const nachtPalette = VpPalette(
    id: VpPaletteId.nacht,
    helligkeit: Brightness.dark,
    papier: Color(0xFF1D1F22),
    papierErhoben: Color(0xFF26282C),
    papierVertieft: Color(0xFF34373C),
    tinte: Color(0xFFE9E4D8),
    tinteLeise: Color(0xFFB9B3A6),
    tinteStumm: Color(0xFFA8A398),
    linie: Color(0xFF4A4C50),
    linieStark: Color(0xFF686A6E),
    akzent: Color(0xFFD9A3AB),
    akzentHell: Color(0xFFE8C2C8),
    akzentLeise: Color(0x33D9A3AB),
    akzentTief: Color(0xFFE8C2C8),
    akzentTiefHell: Color(0xFFF0D4D8),
    akzentTiefLeise: Color(0x33E8C2C8),
    aufAkzent: Color(0xFF2A1518),
    aufAkzentTief: Color(0xFF2A1518),
    aufSignal: Color(0xFF2A1518),
    signal: Color(0xFFE5576B),
    signalLeise: Color(0x33E5576B),
    statusJa: Color(0xFF8DB59A),
    statusVielleicht: Color(0xFFCFA163),
    statusNein: Color(0xFFC99098),
    tiefe: Color(0xFF15171A),
  );

  /// Klassisch: genau die Farben von Build 55 (Rosé als Hauptakzent, Sand als zweiter).
  static const klassischPalette = VpPalette(
    id: VpPaletteId.klassisch,
    helligkeit: Brightness.dark,
    papier: Color(0xFF1D1F22),
    papierErhoben: Color(0xFF26282C),
    papierVertieft: Color(0xFF34373C),
    tinte: Color(0xFFE9E4D8),
    tinteLeise: Color(0xFFB9B3A6),
    tinteStumm: Color(0xFF9B968B),
    linie: Color(0xFF4A4C50),
    linieStark: Color(0xFF686A6E),
    akzent: Color(0xFFD9A3AB),
    akzentHell: Color(0xFFE8C2C8),
    akzentLeise: Color(0x33D9A3AB),
    akzentTief: Color(0xFFCFA163),
    akzentTiefHell: Color(0xFFE6C48B),
    akzentTiefLeise: Color(0x33CFA163),
    aufAkzent: Color(0xFF2A1518),
    aufAkzentTief: Color(0xFF2A1518),
    aufSignal: Color(0xFFFFFFFF),
    signal: Color(0xFFF43F5E),
    signalLeise: Color(0x33F43F5E),
    statusJa: Color(0xFF10B981),
    statusVielleicht: Color(0xFFCFA163),
    statusNein: Color(0xFFF43F5E),
    tiefe: Color(0xFF15171A),
  );

  /// Spicy: dunkles Bordeaux und Pflaume, warmes Papierweiß, kräftigeres, gedecktes Altrosa. Kein Rot als Feuer.
  static const spicyPalette = VpPalette(
    id: VpPaletteId.spicy,
    helligkeit: Brightness.dark,
    papier: Color(0xFF1F1017),
    papierErhoben: Color(0xFF2C1722),
    papierVertieft: Color(0xFF3B1F2E),
    tinte: Color(0xFFF3E8E2),
    tinteLeise: Color(0xFFD2BCBC),
    tinteStumm: Color(0xFFAA939A),
    linie: Color(0xFF55303F),
    linieStark: Color(0xFF7A4A5E),
    akzent: Color(0xFFD07A8E),
    akzentHell: Color(0xFFE5A1B1),
    akzentLeise: Color(0x33D07A8E),
    akzentTief: Color(0xFFEDB3C0),
    akzentTiefHell: Color(0xFFF5CBD5),
    akzentTiefLeise: Color(0x33EDB3C0),
    aufAkzent: Color(0xFF2A1018),
    aufAkzentTief: Color(0xFF2A1018),
    aufSignal: Color(0xFF2A1018),
    signal: Color(0xFFE05A70),
    signalLeise: Color(0x33E05A70),
    statusJa: Color(0xFF9CBFA6),
    statusVielleicht: Color(0xFFD3A774),
    statusNein: Color(0xFFD08C9A),
    tiefe: Color(0xFF5A2B45),
  );

  static VpPalette von(VpPaletteId id) => switch (id) {
        VpPaletteId.papier => papierPalette,
        VpPaletteId.nacht => nachtPalette,
        VpPaletteId.klassisch => klassischPalette,
        VpPaletteId.spicy => spicyPalette,
      };
}

