import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'vp_palette.dart';

/// Abstände (Vielfache von 4). Keine eigenen Zahlen in Bildschirmen, wenn eine Stufe passt.
class VpAbstand {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Seitenrand der Inhalte.
  static const double rand = 20;
}

/// Radien: Magazin, also wenig rund. Voll rund nur für Play-Knöpfe und Avatare.
class VpRadius {
  static const double feld = 8;
  static const double chip = 6;
  static const double karte = 10;
  static const double blatt = 16;
  static const double rund = 999;
}

/// Linienstärken.
class VpLinie {
  static const double haar = 0.8;
  static const double rahmen = 1.2;
  static const double akzent = 2;
}

/// Bildformate (Breite : Höhe) für das Bildregister, siehe docs/konzepte/designsystem-magazin.md.
enum VpBildFormat {
  marke(1 / 1),
  kopf(3 / 2),
  studie(16 / 9),
  hoch(3 / 4),

  /// Erklärdiagramme (800 × 600): werden ganz gezeigt, nie beschnitten.
  diagramm(4 / 3);

  final double verhaeltnis;
  const VpBildFormat(this.verhaeltnis);

  static VpBildFormat? ausName(String? name) {
    for (final f in values) {
      if (f.name == name) return f;
    }
    return null;
  }
}

/// Rahmenvarianten für Karten (`VpKarte`, ab Stufe 4).
enum VpRahmen { keiner, haar, gerahmt, akzent }

/// Typografiestufen. Serif (Source Serif 4) für Anzeige, Überschrift, Titel und Zahlen,
/// Systemschrift für Fließtext und funktionale Beschriftungen.
class VpTypo {
  static const String serif = 'SourceSerif4';

  final TextStyle anzeige;
  final TextStyle ueberschrift;
  final TextStyle titel;
  final TextStyle zahl;
  final TextStyle fliesstext;
  final TextStyle fliesstextKlein;
  final TextStyle eyebrow;
  final TextStyle beschriftung;

  const VpTypo._({
    required this.anzeige,
    required this.ueberschrift,
    required this.titel,
    required this.zahl,
    required this.fliesstext,
    required this.fliesstextKlein,
    required this.eyebrow,
    required this.beschriftung,
  });

  factory VpTypo.fuer(VpPalette p) {
    return VpTypo._(
      anzeige: TextStyle(
        fontFamily: serif,
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: p.tinte,
      ),
      ueberschrift: TextStyle(
        fontFamily: serif,
        fontSize: 24,
        height: 1.22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: p.tinte,
      ),
      titel: TextStyle(
        fontFamily: serif,
        fontSize: 18,
        height: 1.28,
        fontWeight: FontWeight.w600,
        color: p.tinte,
      ),
      zahl: TextStyle(
        fontFamily: serif,
        fontSize: 22,
        height: 1.1,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: p.akzentTief,
      ),
      fliesstext: TextStyle(fontSize: 15, height: 1.5, color: p.tinte),
      fliesstextKlein: TextStyle(fontSize: 13.5, height: 1.45, color: p.tinteLeise),
      // Versalien setzt die Komponente (`VpEyebrow`), hier nur Schnitt und Sperrung.
      eyebrow: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.4, color: p.tinteLeise),
      beschriftung: TextStyle(fontSize: 13, height: 1.35, color: p.tinteLeise),
    );
  }
}

/// Alle Entwurfswerte einer Atmosphäre an einer Stelle. Zugriff: `context.vp` oder `AppTheme.tokens`.
@immutable
class VpTokens extends ThemeExtension<VpTokens> {
  final VpPalette farben;
  final VpTypo typo;

  const VpTokens({required this.farben, required this.typo});

  factory VpTokens.von(VpPalette p) => VpTokens(farben: p, typo: VpTypo.fuer(p));

  @override
  VpTokens copyWith({VpPalette? farben, VpTypo? typo}) =>
      VpTokens(farben: farben ?? this.farben, typo: typo ?? this.typo);

  /// Atmosphären werden nicht überblendet: Der Wechsel baut die Oberfläche neu auf.
  @override
  VpTokens lerp(ThemeExtension<VpTokens>? other, double t) => t < 0.5 || other is! VpTokens ? this : other;
}

extension VpKontext on BuildContext {
  /// Die Entwurfswerte der aktuellen Atmosphäre. Ohne VpTokens im Theme (Tests, fremde Themes) gelten die der App.
  VpTokens get vp => Theme.of(this).extension<VpTokens>() ?? AppTheme.tokens;
}
