// Anleitung: alle Abschnitte da, der Spicy-Abschnitt nur bei eingeschaltetem Modus ausführlich.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/app_localizations.dart';
import 'package:velvetpulse/screens/anleitung_screen.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Alle Abschnitte lassen sich laden und haben Text', () async {
    final abschnitte = await AnleitungAbschnitt.laden();
    expect(abschnitte.length, greaterThanOrEqualTo(10));
    for (final a in abschnitte) {
      expect(a.titel, isNotEmpty);
      expect(a.text.length, greaterThan(80), reason: a.id);
    }
  });

  for (final an in [false, true]) {
    group('Spicy ${an ? 'an' : 'aus'}', () {
      setUp(() async {
        SharedPreferences.setMockInitialValues({'spicy_mode': an});
        StorageService.resetForTest();
        await StorageService.init();
      });

      testWidgets('Spicy-Abschnitt nur ausführlich, wenn der Modus an ist', (tester) async {
        tester.view.physicalSize = const Size(1080, 8000);
        addTearDown(tester.view.reset);
        await tester.runAsync(() async {
          await tester.pumpWidget(const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('de'),
            home: AnleitungScreen(),
          ));
          await Future.delayed(const Duration(milliseconds: 300));
        });
        await tester.pump();
        expect(find.text('Kurse und Lektionen'), findsOneWidget);
        expect(find.text('Spicy-Modus (ab 18)'), an ? findsOneWidget : findsNothing);
      });
    });
  }
}
