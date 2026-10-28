import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/app_localizations.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/rueckmeldung.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'VelvetPulse',
      packageName: 'app.velvetpulse',
      version: '4.13.0',
      buildNumber: '28',
      buildSignature: '',
    );
    StorageService.resetForTest();
    await StorageService.init();
    await StorageService.saveUserProfile(
      UserProfile(
        name: 'Alex',
        gender: 'other',
        age: 30,
        relationshipStatus: 'single',
        primaryGoal: 'pleasure',
      ),
    );
  });

  tearDown(() {
    Rueckmeldung.senderFuerTest = null;
  });

  group('Rueckmeldung.halloText & halloSenden', () {
    test('Inhalt enthält ausschließlich Version und Sprache', () {
      final text = Rueckmeldung.halloText(version: '4.13.0', sprache: 'de');

      expect(text, startsWith('[VelvetPulse] Hallo'));
      expect(text, contains('Version: 4.13.0, Sprache: de'));
      // Keine Profil- oder Gerätedaten
      expect(text, isNot(contains('Alex')));
      expect(text, isNot(contains('single')));
      expect(text, isNot(contains('pleasure')));
      expect(text, isNot(contains('Kontakt')));
    });

    test('halloSenden verschlüsselt als Gift Wrap an das Postfach', () async {
      Map<String, dynamic>? gesendetesEvent;
      Rueckmeldung.senderFuerTest = (ev) async {
        gesendetesEvent = ev;
        return true;
      };

      final ok = await Rueckmeldung.halloSenden(version: '4.13.0', sprache: 'de');
      expect(ok, isTrue);
      expect(gesendetesEvent, isNotNull);
      expect(gesendetesEvent!['kind'], 1059);

      // Event enthält im Klartext weder Klartext-Präfix noch Schlüsselwörter (weil verschlüsselt)
      expect(gesendetesEvent!['content'], isNot(contains('[VelvetPulse]')));
      expect(gesendetesEvent!['content'], isNot(contains('Version:')));
      expect(gesendetesEvent!['content'], isNot(contains('Sprache:')));
    });
  });

  group('Profil-Eintrag Einmal anonym Hallo sagen', () {
    Widget testApp() => const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('de'),
          home: OnboardingScreen(isEditing: true),
        );

    testWidgets('Ohne Tipp wird nichts gesendet und Knopf ist sichtbar', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('ListTile background color')) return;
        oldHandler?.call(d);
      };
      addTearDown(() => FlutterError.onError = oldHandler);

      var gesendet = false;
      Rueckmeldung.senderFuerTest = (_) async {
        gesendet = true;
        return true;
      };

      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      tester.takeException();

      expect(gesendet, isFalse);
      expect(StorageService.getHalloGesendetAm(), isNull);
      expect(find.text('Einmal anonym Hallo sagen'), findsOneWidget);
      expect(find.text('Hallo sagen'), findsOneWidget);
    });

    testWidgets('Tipp sendet Hallo, merkt sich Datum und schließt zweites Senden aus', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('ListTile background color')) return;
        oldHandler?.call(d);
      };
      addTearDown(() => FlutterError.onError = oldHandler);

      var anzahlGesendet = 0;
      Rueckmeldung.senderFuerTest = (_) async {
        anzahlGesendet++;
        return true;
      };

      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      tester.takeException();

      final knopfFinder = find.text('Hallo sagen');
      await tester.ensureVisible(knopfFinder);
      await tester.tap(knopfFinder);
      await tester.pumpAndSettle();

      expect(anzahlGesendet, 1);
      final datum = StorageService.getHalloGesendetAm();
      expect(datum, isNotNull);
      expect(datum, isNotEmpty);

      // Knopf ist weg, stattdessen Danke-Text mit Datum
      expect(find.text('Hallo sagen'), findsNothing);
      expect(find.textContaining('Danke, gesendet am'), findsOneWidget);

      // Neu rendern: nach wie vor kein Knopf
      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      tester.takeException();
      expect(find.text('Hallo sagen'), findsNothing);
      expect(find.textContaining('Danke, gesendet am'), findsOneWidget);
      expect(anzahlGesendet, 1); // Kein erneuter Versand
    });

    testWidgets('Bereits gesendet: zeigt von Beginn an Danke-Text ohne Knopf', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('ListTile background color')) return;
        oldHandler?.call(d);
      };
      addTearDown(() => FlutterError.onError = oldHandler);

      await StorageService.setHalloGesendetAm('28.10.2026');

      var gesendet = false;
      Rueckmeldung.senderFuerTest = (_) async {
        gesendet = true;
        return true;
      };

      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      tester.takeException();

      expect(gesendet, isFalse);
      expect(find.text('Hallo sagen'), findsNothing);
      expect(find.text('Danke, gesendet am 28.10.2026.'), findsOneWidget);
    });
  });

  group('Sicherung & Backup-Merge', () {
    test('halloGesendetAm bleibt in Sicherung und Merge erhalten', () async {
      await StorageService.setHalloGesendetAm('28.10.2026');
      final export = StorageService.exportAllUserData();
      expect(export['halloGesendetAm'], '28.10.2026');

      final validated = BackupCodec.validate(export);
      expect(validated.data['halloGesendetAm'], '28.10.2026');

      // Zurücksetzen und über Merge wiederherstellen
      await StorageService.setHalloGesendetAm(null);
      expect(StorageService.getHalloGesendetAm(), isNull);

      await StorageService.importBackup(validated);
      expect(StorageService.getHalloGesendetAm(), '28.10.2026');
    });
  });
}
