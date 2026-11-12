import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

Future<void> _start(WidgetTester tester, {required void Function() onComplete}) async {
  SharedPreferences.setMockInitialValues({});
  await tester.runAsync(() => StorageService.init());
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.darkTheme,
    home: OnboardingScreen(onComplete: onComplete),
  ));
  await tester.pump();
}

Future<void> _tippe(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('Sanfter Start: drei Bildschirme, Zurück geht zur Willkommensseite', (tester) async {
    await _start(tester, onComplete: () {});

    await _tippe(tester, find.text(t.onboardingEingeladenLink));
    expect(find.text(t.onboardingEingeladenTitel1), findsOneWidget);
    expect(find.text(t.onboardingEingeladenNurSchauen), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);

    await _tippe(tester, find.text(t.onboardingWeiter));
    expect(find.text(t.onboardingEingeladenTitel2), findsOneWidget);
    expect(find.text(t.onboardingEingeladenNurSchauen), findsOneWidget);

    await _tippe(tester, find.text(t.onboardingWeiter));
    expect(find.text(t.onboardingEingeladenTitel3), findsOneWidget);
    expect(find.text(t.onboardingEingeladenEinrichten), findsOneWidget);
    expect(find.text(t.onboardingEingeladenVerbinden), findsOneWidget);
    expect(find.text(t.onboardingEingeladenNurSchauen), findsOneWidget);

    await _tippe(tester, find.text(t.onboardingZurueck));
    expect(find.text(t.onboardingEingeladenTitel2), findsOneWidget);
    await _tippe(tester, find.text(t.onboardingZurueck));
    await _tippe(tester, find.text(t.onboardingZurueck));
    expect(find.text(t.onboardingLosGehts), findsOneWidget);
  });

  testWidgets('Sanfter Start: "Einrichten" führt in die Fragen (Frage 1 von 5)', (tester) async {
    await _start(tester, onComplete: () {});
    await _tippe(tester, find.text(t.onboardingEingeladenLink));
    await _tippe(tester, find.text(t.onboardingWeiter));
    await _tippe(tester, find.text(t.onboardingWeiter));
    await _tippe(tester, find.text(t.onboardingEingeladenEinrichten));
    expect(find.text(t.onboardingSchritt(1, 5)), findsOneWidget);
  });

  testWidgets('Sanfter Start: "Ich schau erst mal nur" speichert Standardprofil und geht in die App', (tester) async {
    var fertig = false;
    await _start(tester, onComplete: () => fertig = true);
    expect(StorageService.getUserProfile(), isNull);

    await _tippe(tester, find.text(t.onboardingEingeladenLink));
    await _tippe(tester, find.text(t.onboardingEingeladenNurSchauen));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();

    final profil = StorageService.getUserProfile();
    expect(profil, isNotNull);
    expect(profil!.gender, 'unspecified');
    expect(profil.primaryGoal, 'open');
    expect(profil.age, 32);
    expect(profil.relationshipStatus, 'relationship');
    expect(fertig, isTrue);
  });
}
