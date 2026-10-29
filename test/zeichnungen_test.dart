// Beschriftete Körperzeichnungen (Feld „zeichnung“): Dateien in beiden Sprachen vorhanden, eingebettetes Bild, Beschriftung nur Zonen.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final inhalt = jsonDecode(File('assets/data/velvet_content.json').readAsStringSync()) as Map<String, dynamic>;
  final pfade = <String>[
    for (final k in inhalt['courses'] as List)
      for (final l in (k as Map)['lessons'] as List)
        if ((l as Map)['zeichnung'] != null) l['zeichnung'] as String,
  ];

  test('Jede Zeichnung gibt es auf Deutsch und Englisch, mit eingebettetem Bild', () {
    expect(pfade.length, greaterThanOrEqualTo(8));
    for (final p in pfade) {
      for (final datei in [p, p.replaceFirst('.svg', '_en.svg')]) {
        final f = File(datei);
        expect(f.existsSync(), isTrue, reason: '$datei fehlt');
        final svg = f.readAsStringSync();
        expect(svg, contains('<image'), reason: '$datei ohne eingebettetes Bild');
        expect(svg, contains('<text'), reason: '$datei ohne Beschriftung');
      }
    }
  });

  testWidgets('Eine Zeichnung mit eingebettetem WebP lässt sich als SVG darstellen', (tester) async {
    final svg = File(pfade.first).readAsStringSync();
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: SvgPicture.string(svg))));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
