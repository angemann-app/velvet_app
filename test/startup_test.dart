import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/screens/main_navigation_screen.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/privacy_service.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

void main() {
  for (final label in ['Überspringen', "Fertig, los geht's"]) {
    testWidgets('Onboarding "$label" -> alle Tabs', (tester) async {
      SharedPreferences.setMockInitialValues({});
      PrivacyService.unterstuetztFuerTest = true;
      PrivacyService.authenticateFuerTest = () async => true;
      addTearDown(() {
        PrivacyService.unterstuetztFuerTest = null;
        PrivacyService.authenticateFuerTest = null;
      });
      await tester.runAsync(() async {
        await StorageService.init();
        await DataService.loadDatabase();
      });

      bool done = false;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: StatefulBuilder(
          builder: (context, setState) => done
              ? const MainNavigationScreen()
              : OnboardingScreen(onComplete: () => setState(() => done = true)),
        ),
      ));
      await tester.pump();

      // Ersteinrichtung in Schritten: Willkommen, dann fünf Fragen. „Später“ steht immer da, „Fertig“ erst am Ende.
      if (label == "Fertig, los geht's") {
        for (final knopf in ['Loslegen', 'Weiter', 'Weiter', 'Weiter', 'Weiter']) {
          final b = find.text(knopf);
          await tester.ensureVisible(b);
          await tester.tap(b);
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      final button = find.text(label);
      await tester.ensureVisible(button);
      await tester.tap(button);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // Seit 12.11.2026 schaltet das Ende der Einrichtung die App-Sperre ein (docs/konzepte/privatsphaere-schutz.md)
      // und zeigt kurz „Nur für dich“. Der Plattformkanal der Gerätesperre antwortet erst außerhalb der Testzeit.
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      // Kein pumpAndSettle: Unter dem Blatt dreht sich beim Personalisieren der Fortschrittskreis.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text(t.appSperreNeuTitel), findsOneWidget);
      await tester.tap(find.text(t.appSperreNeuOk));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(await tester.runAsync(PrivacyService.isLockEnabled), isTrue);
      expect(tester.takeException(), isNull);
      expect(find.byType(MainNavigationScreen), findsOneWidget);

      for (final tab in ['Lernen', 'Üben', 'Wir', 'Heute']) {
        await tester.tap(find.text(tab).last);
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(tester.takeException(), isNull, reason: 'Fehler im Tab $tab');
      }

      await tester.pumpWidget(const SizedBox());
      NostrService().dispose();
      await tester.pump(const Duration(seconds: 6));
    });
  }
}
