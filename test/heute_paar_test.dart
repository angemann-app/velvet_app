import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/screens/courses/courses_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/storage_service.dart';

UserProfile _profil(String status, String ziel) => UserProfile(
    name: 'Alex', gender: 'other', age: 35, relationshipStatus: status, primaryGoal: ziel);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('istPaarModus', () {
    test('Paar-Fokus und nicht Single', () {
      expect(istPaarModus(_profil('relationship', 'couple_intimacy')), isTrue);
      expect(istPaarModus(_profil('dating', 'couple_intimacy')), isTrue);
      expect(istPaarModus(_profil('complicated', 'couple_intimacy')), isTrue);
    });

    test('Single mit Paar-Fokus bleibt die bisherige Seite', () {
      expect(istPaarModus(_profil('single', 'couple_intimacy')), isFalse);
    });

    test('Beziehung mit anderem Fokus bleibt die bisherige Seite', () {
      expect(istPaarModus(_profil('relationship', 'performance_anxiety')), isFalse);
      expect(istPaarModus(_profil('relationship', 'open')), isFalse);
    });

    test('ohne Profil kein Paar-Modus', () {
      expect(istPaarModus(null), isFalse);
    });

    test('vorsichtige Unterzeile nur bei Dating und kompliziert', () {
      expect(istPaarModusVorsichtig(_profil('dating', 'couple_intimacy')), isTrue);
      expect(istPaarModusVorsichtig(_profil('complicated', 'couple_intimacy')), isTrue);
      expect(istPaarModusVorsichtig(_profil('relationship', 'couple_intimacy')), isFalse);
      expect(istPaarModusVorsichtig(_profil('dating', 'open')), isFalse);
      expect(istPaarModusVorsichtig(null), isFalse);
    });
  });

  group('Heute im Paar-Modus', () {
    Future<void> zeigen(WidgetTester tester, UserProfile p) async {
      SharedPreferences.setMockInitialValues({});
      StorageService.resetForTest();
      await tester.runAsync(() async {
        await StorageService.init();
        await StorageService.saveUserProfile(p, triggerBackup: false);
        await DataService.loadDatabase();
      });
      tester.view.physicalSize = const Size(390, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CoursesScreen(onNavigateToTool: (_, {subTab}) {})),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets('Paar-Fokus zeigt Heute zu zweit, Rest ist eingeklappt', (tester) async {
      await zeigen(tester, _profil('relationship', 'couple_intimacy'));
      expect(find.text(t.heutePaarTitel), findsOneWidget);
      expect(find.text(t.heutePaarMehrAllein), findsOneWidget);
      expect(find.text(t.heuteNaechsterSchritt.toUpperCase()), findsNothing);
      expect(find.text(t.heutePaarEinladen), findsOneWidget);
      await tester.tap(find.text(t.heutePaarMehrAllein));
      await tester.pump();
      expect(find.text(t.heuteAlleKurse), findsOneWidget);
      // Zustand nur statisch: wieder schließen, damit andere Tests nicht beeinflusst werden.
      await tester.tap(find.text(t.heutePaarMehrAllein));
      await tester.pump();
      expect(find.text(t.heuteAlleKurse), findsNothing);
    });

    testWidgets('anderer Fokus zeigt die bisherige Seite', (tester) async {
      await zeigen(tester, _profil('relationship', 'performance_anxiety'));
      expect(find.text(t.heutePaarTitel), findsNothing);
      expect(find.text(t.heuteNaechsterSchritt.toUpperCase()), findsOneWidget);
    });
  });
}

