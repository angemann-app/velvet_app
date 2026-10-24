// Der Erotik-Funke auf der Startseite: Aufdecken darf nie zu einem Fehler (grauer Fläche) führen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/app_localizations.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/daily_simmering_card.dart';

void main() {
  for (final status in ['single', 'relationship']) {
    group(status, () {
      // Außerhalb von testWidgets: Plattform-Kanäle brauchen echte Zeit.
      setUp(() async {
        SharedPreferences.setMockInitialValues({
          'user_profile': '{"name":"Test","gender":"male","relationship_status":"$status"}',
        });
        StorageService.resetForTest();
        await StorageService.init();
      });

      testWidgets('Aufdecken zeigt den Impuls ohne Fehler', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('de'),
          home: Scaffold(body: SingleChildScrollView(child: DailySimmeringCard())),
        ));
        await tester.tap(find.byType(DailySimmeringCard));
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        expect(find.byType(ErrorWidget), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
      });
    });
  }
}
