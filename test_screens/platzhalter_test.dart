// ignore_for_file: invalid_use_of_visible_for_testing_member
// Rendert die Platzhalter des Bildsystems (alle Formate, mehrere IDs) nach build/platzhalter_<palette>.png.
//   flutter test test_screens/platzhalter_test.dart --dart-define=PALETTE=nacht   (papier | nacht | klassisch)
//   flutter test test_screens/platzhalter_test.dart --dart-define=SPICY=true
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';
import 'package:velvetpulse/theme/vp_tokens.dart';
import 'package:velvetpulse/widgets/design/vp_bild_feld.dart';

const _palette = String.fromEnvironment('PALETTE', defaultValue: 'papier');
const _spicy = bool.fromEnvironment('SPICY');

void main() {
  testWidgets('Platzhalter rendern', (tester) async {
    tester.view.physicalSize = const Size(900, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({if (_spicy) 'spicy_mode': true, 'design_palette': _palette});
    StorageService.resetForTest();
    await tester.runAsync(() => StorageService.init());

    final key = GlobalKey();
    const ids = ['kurs.01.titel', 'kurs.07.titel', 'audio.einschlaf.cover', 'bereich.spicy'];
    Widget zelle(VpBildFormat f, String id) => Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: f == VpBildFormat.marke ? 90 : 190,
            height: 190 / f.verhaeltnis > 150 ? 150 : 190 / f.verhaeltnis,
            child: VpPlatzhalter(saatgut: id, format: f),
          ),
        );
    await tester.pumpWidget(RepaintBoundary(
      key: key,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              for (final f in VpBildFormat.values) Row(children: [for (final id in ids) zelle(f, id)]),
            ]),
          ),
        ),
      ),
    ));
    await tester.pump();
    await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      final name = _spicy ? 'spicy' : _palette;
      Directory('build').createSync(recursive: true);
      File('build/platzhalter_$name.png').writeAsBytesSync(bytes);
    });
  });
}
