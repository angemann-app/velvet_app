// Spicy-Look und geführte Audios: Oberfläche folgt dem Modus, Karten öffnen ohne Fehler.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/app_localizations.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/gefuehrte_audios.dart';
import 'package:velvetpulse/widgets/spicy_atmosphaere.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
  });

  Widget app(Widget kind) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('de'),
        home: Scaffold(body: kind),
      );

  test('Der Schalter meldet jede Änderung', () async {
    expect(StorageService.spicyAenderung.value, isFalse);
    await StorageService.setSpicyMode(true);
    expect(StorageService.spicyAenderung.value, isTrue);
    await StorageService.setSpicyMode(false);
    expect(StorageService.spicyAenderung.value, isFalse);
  });

  testWidgets('Das Glühen liegt nur bei eingeschaltetem Modus über dem Inhalt und fängt keine Berührungen ab',
      (tester) async {
    var getippt = 0;
    Widget mit(bool an) => app(SpicyAtmosphaere(
          an: an,
          child: Center(child: ElevatedButton(onPressed: () => getippt++, child: const Text('Knopf'))),
        ));
    final glut = find.descendant(of: find.byType(SpicyAtmosphaere), matching: find.byType(IgnorePointer));
    await tester.pumpWidget(mit(false));
    expect(glut, findsNothing);
    await tester.pumpWidget(mit(true));
    expect(glut, findsOneWidget);
    await tester.tap(find.text('Knopf'));
    expect(getippt, 1);
  });

  testWidgets('Geführte Audios: Singles sehen nur die Körperreise', (tester) async {
    await tester.pumpWidget(app(const SingleChildScrollView(child: GefuehrteAudios(mitPaar: false))));
    expect(find.text('Körperreise'), findsOneWidget);
    expect(find.text('Gemeinsamer Abend'), findsNothing);
    await tester.pumpWidget(app(const SingleChildScrollView(child: GefuehrteAudios())));
    expect(find.text('Gemeinsamer Abend'), findsOneWidget);
    expect(find.text('Geführte Audios'), findsOneWidget);
  });
}
