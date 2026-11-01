import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/vp_palette.dart';

/// Grundfläche einer Seite: die Papierfarbe der aktuellen Atmosphäre, in Spicy zusätzlich eine weiche Randabdunkelung
/// (Vignette) in Pflaume. Kein Glühen, keine Funken; die Vignette fängt keine Berührungen ab und ändert sich nie.
/// Ersetzt `SpicyAtmosphaere` (docs/konzepte/designsystem-magazin.md, Abschnitt 5).
class VpSeite extends StatelessWidget {
  final Widget child;

  const VpSeite({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final spicy = AppTheme.paletteId == VpPaletteId.spicy;
    return Stack(children: [
      Positioned.fill(child: ColoredBox(color: AppTheme.papier)),
      child,
      if (spicy)
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.15,
                    colors: [
                      AppTheme.tiefe.withValues(alpha: 0),
                      AppTheme.tiefe.withValues(alpha: 0.38),
                    ],
                    stops: const [0.55, 1],
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
