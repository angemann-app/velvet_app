import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/theme/app_theme.dart';
import 'package:velvetpulse/theme/vp_palette.dart';
import 'package:velvetpulse/theme/vp_tokens.dart';

/// Kontrast nach WCAG 2.x (Relative Luminanz). Text braucht 4,5 : 1 (AA), große Elemente und Symbole 3 : 1.
double _luminanz(Color c) {
  double kanal(double v) => v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * kanal(c.r) + 0.7152 * kanal(c.g) + 0.0722 * kanal(c.b);
}

double kontrast(Color a, Color b) {
  final la = _luminanz(a), lb = _luminanz(b);
  final hell = math.max(la, lb), dunkel = math.min(la, lb);
  return (hell + 0.05) / (dunkel + 0.05);
}

void main() {
  // Klassisch sind die alten Farben (Übergang), sie werden nicht nachgebessert und deshalb nicht geprüft.
  final geprueft = [VpPalette.papierPalette, VpPalette.nachtPalette, VpPalette.spicyPalette];

  for (final p in geprueft) {
    group('Kontrast ${p.id.name}', () {
      void text(String name, Color vorn, Color hinten, [double min = 4.5]) {
        test(name, () {
          final k = kontrast(vorn, hinten);
          expect(k, greaterThanOrEqualTo(min), reason: '$name hat nur ${k.toStringAsFixed(2)} : 1');
        });
      }

      text('tinte auf papier', p.tinte, p.papier);
      text('tinte auf papierErhoben', p.tinte, p.papierErhoben);
      text('tinteLeise auf papier', p.tinteLeise, p.papier);
      text('tinteLeise auf papierErhoben', p.tinteLeise, p.papierErhoben);
      text('tinteStumm auf papier', p.tinteStumm, p.papier);
      text('tinteStumm auf papierErhoben', p.tinteStumm, p.papierErhoben);
      text('akzentTief auf papier', p.akzentTief, p.papier);
      text('akzentTief auf papierErhoben', p.akzentTief, p.papierErhoben);
      text('aufAkzent auf akzent (Button)', p.aufAkzent, p.akzent);
      // Eingelassene Flächen (Felder, gewählte Elemente) tragen denselben Text wie die Karte.
      text('tinte auf papierVertieft', p.tinte, p.papierVertieft);
      text('tinteLeise auf papierVertieft', p.tinteLeise, p.papierVertieft);
      text('tinteStumm auf papierVertieft', p.tinteStumm, p.papierVertieft);
      text('akzentTief auf papierVertieft', p.akzentTief, p.papierVertieft);
      text('tinte auf akzentLeise über papierErhoben (gewählte Chips)', p.tinte, Color.alphaBlend(p.akzentLeise, p.papierErhoben));
      text('aufStatus auf statusJa (Ja-Knopf)', p.istDunkel ? p.aufAkzent : p.papierErhoben, p.statusJa, 3);
      text('aufAkzentTief auf akzentTief', p.aufAkzentTief, p.akzentTief);
      text('aufSignal auf signal', p.aufSignal, p.signal);
      text('signal auf papier', p.signal, p.papier, 3);
      text('akzent auf papier (Linie, großes Element)', p.akzent, p.papier, 3);
      text('linieStark auf papier (Rahmen)', p.linieStark, p.papier, 1.8);
      for (final (name, farbe) in [('statusJa', p.statusJa), ('statusVielleicht', p.statusVielleicht), ('statusNein', p.statusNein)]) {
        text('$name auf papier (Symbol)', farbe, p.papier, 3);
      }
    });
  }

  test('Jede Atmosphäre liefert ein vollständiges Theme mit Tokens', () {
    for (final id in VpPaletteId.values) {
      final theme = AppTheme.themeData(VpPalette.von(id));
      expect(theme.extension<VpTokens>(), isNotNull);
      expect(theme.brightness, VpPalette.von(id).helligkeit);
      expect(theme.textTheme.headlineMedium!.fontFamily, 'SourceSerif4');
      expect(VpTypo.fuer(VpPalette.von(id)).fliesstext.fontFamily, isNull, reason: 'Fließtext bleibt Systemschrift');
    }
  });
}
