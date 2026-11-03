// Flutter erkennt Test-Hilfen außerhalb von test/ nicht automatisch.
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/schlafdaten.dart';
import 'package:velvetpulse/screens/self_exploration/schlafdaten_screen.dart';
import 'package:velvetpulse/services/schlafdaten_dienst.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

void main() {
  const kanal = MethodChannel('test/schlafscreen');
  setUpAll(() async {
    for (final entry in {
      'Roboto':
          'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
      'MaterialIcons':
          'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
      'SourceSerif4': 'assets/fonts/SourceSerif4-Regular.ttf',
    }.entries) {
      await (FontLoader(entry.key)
            ..addFont(Future.value(
                ByteData.sublistView(File(entry.value).readAsBytesSync()))))
          .load();
    }
  });
  for (final lang in ['de', 'en']) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('$lang, 360x640, Schrift $scale: Daten und Löschdialog',
          (tester) async {
        SharedPreferences.setMockInitialValues({'spicy_mode': true});
        FlutterSecureStorage.setMockInitialValues({});
        SecretStore.resetForTest();
        StorageService.resetForTest();
        await tester.runAsync(() => StorageService.init());
        Sprache.wahl.value = lang;
        await initializeDateFormatting(lang);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
                kanal, (_) async => {'verfuegbar': true, 'berechtigt': true});
        addTearDown(() => TestDefaultBinaryMessengerBinding
            .instance.defaultBinaryMessenger
            .setMockMethodCallHandler(kanal, null));
        await tester.binding.setSurfaceSize(const Size(360, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final now = DateTime.utc(2026, 11, 3, 10);
        final row = SchlafAufzeichnung.ausHealth({
          'id': 'synthetische-nacht',
          'quelle': 'Beispiel',
          'startMs':
              now.subtract(const Duration(hours: 12)).millisecondsSinceEpoch,
          'endeMs':
              now.subtract(const Duration(hours: 4)).millisecondsSinceEpoch,
          'geaendertMs': now.millisecondsSinceEpoch,
          'offsetStartMin': 60,
          'offsetEndeMin': 60,
          'phasen': [],
        }, now);
        await tester.runAsync(() => StorageService.saveSchlafdaten(
            (_) => SchlafDaten(aufzeichnungen: [row], verbunden: true),
            backup: false));
        final key = GlobalKey();
        await tester.pumpWidget(RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme.copyWith(
                textTheme:
                    AppTheme.darkTheme.textTheme.apply(fontFamily: 'Roboto'),
                textButtonTheme: TextButtonThemeData(
                    style: AppTheme.darkTheme.textButtonTheme.style!.copyWith(
                        textStyle: const WidgetStatePropertyAll(
                            TextStyle(fontFamily: 'Roboto')))),
                filledButtonTheme: FilledButtonThemeData(
                    style: AppTheme.darkTheme.filledButtonTheme.style!.copyWith(
                        textStyle: const WidgetStatePropertyAll(
                            TextStyle(fontFamily: 'Roboto')))),
              ),
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!),
              home: SchlafdatenScreen(dienst: SchlafdatenDienst(kanal: kanal)),
            )));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final img = await boundary.toImage(pixelRatio: 1);
          final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
          final dir = Directory('build/screens/schlafdaten')
            ..createSync(recursive: true);
          File('${dir.path}/$lang-$scale.png')
              .writeAsBytesSync(bytes!.buffer.asUint8List());
          img.dispose();
        });
        final loeschen = find.text(Sprache.texte.schlafLoeschen);
        final details = find.text(Sprache.texte.schlafMesswerte);
        await tester.scrollUntilVisible(details, 350,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await tester.tap(details);
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(loeschen, 350,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await tester.tap(loeschen);
        await tester.pumpAndSettle();
        expect(find.text(Sprache.texte.schlafLoeschenFrage), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text(Sprache.texte.schlafAbbrechen));
        await tester.pumpAndSettle();
        expect(StorageService.getSchlafdaten().aufzeichnungen, hasLength(1));
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
