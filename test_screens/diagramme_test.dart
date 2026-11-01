// Rendert alle DE/EN-Diagramme mit dem tatsächlichen SVG-Renderer der App.
// Aufruf: flutter test test_screens/diagramme_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('100 Diagramme sind in Flutter renderbar, auch in Handygröße',
      (tester) async {
    await (FontLoader('SourceSerif4')
          ..addFont(rootBundle.load('assets/fonts/SourceSerif4-Regular.ttf')))
        .load();
    // Widgettests haben keine Android-Systemschrift. Den SVG-Familiennamen
    // explizit mit Roboto belegen, damit die Vorschau echte Zeichen zeigt.
    final sans = File(
      'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
    );
    await (FontLoader('sans-serif')
          ..addFont(Future.value(ByteData.sublistView(sans.readAsBytesSync()))))
        .load();
    final files = Directory('assets/images')
        .listSync()
        .whereType<File>()
        .where((f) => RegExp(r'diagram_.*\.svg$').hasMatch(f.path))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    expect(files, hasLength(100));
    final out = Directory('build/redaktion/diagramm-review/flutter')
      ..createSync(recursive: true);
    final key = GlobalKey();
    for (final file in files) {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: 360,
              height: 270,
              child: SvgPicture.string(file.readAsStringSync()),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: file.path);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final name = file.uri.pathSegments.last.replaceAll('.svg', '.png');
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        expect(bytes, isNotNull, reason: file.path);
        await File('${out.path}/$name')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
