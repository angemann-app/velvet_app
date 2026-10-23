import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/screens/main_navigation_screen.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

void main() {
  for (final label in ['Überspringen & Direkt zur App ➔', 'Programm jetzt personalisieren']) {
    testWidgets('Onboarding "$label" -> alle Tabs', (tester) async {
      SharedPreferences.setMockInitialValues({});
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

      final button = find.text(label);
      await tester.ensureVisible(button);
      await tester.tap(button);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(tester.takeException(), isNull);
      expect(find.byType(MainNavigationScreen), findsOneWidget);

      for (final tab in ['Training', 'Reframing', 'Paar-Kanal', 'KI-Coach', 'Kurse']) {
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
