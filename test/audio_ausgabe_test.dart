import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/app_localizations.dart';
import 'package:velvetpulse/services/audio_ausgabe.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/lautsprecher_frage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
    AudioAusgabe.instanz.testIstLautsprecher = null;
  });

  tearDown(() {
    AudioAusgabe.instanz.testIstLautsprecher = null;
  });

  group('StorageService Einstellungen', () {
    test('Standardwerte sind true', () {
      expect(StorageService.getFrageVorLautsprecher(), isTrue);
      expect(StorageService.getPausiereBeiKopfhoererGetrennt(), isTrue);
    });

    test('getFrageVorLautsprecher / setFrageVorLautsprecher', () async {
      await StorageService.setFrageVorLautsprecher(false);
      expect(StorageService.getFrageVorLautsprecher(), isFalse);

      await StorageService.setFrageVorLautsprecher(true);
      expect(StorageService.getFrageVorLautsprecher(), isTrue);
    });

    test('getPausiereBeiKopfhoererGetrennt / setPausiereBeiKopfhoererGetrennt', () async {
      await StorageService.setPausiereBeiKopfhoererGetrennt(false);
      expect(StorageService.getPausiereBeiKopfhoererGetrennt(), isFalse);

      await StorageService.setPausiereBeiKopfhoererGetrennt(true);
      expect(StorageService.getPausiereBeiKopfhoererGetrennt(), isTrue);
    });
  });

  group('AudioAusgabe Service', () {
    test('testIstLautsprecher Hook bestimmt Ergebnis', () async {
      AudioAusgabe.instanz.testIstLautsprecher = true;
      expect(await AudioAusgabe.instanz.istLautsprecher(), isTrue);

      AudioAusgabe.instanz.testIstLautsprecher = false;
      expect(await AudioAusgabe.instanz.istLautsprecher(), isFalse);
    });

    test('kopfhoererGetrenntMelden löst onKopfhoererGetrennt aus', () async {
      final events = <void>[];
      final sub = AudioAusgabe.instanz.onKopfhoererGetrennt.listen((event) {
        events.add(event);
      });

      AudioAusgabe.instanz.kopfhoererGetrenntMelden();
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      await sub.cancel();
    });
  });

  group('frageVorLautsprecher Dialog', () {
    Widget testApp({required Future<void> Function(BuildContext) onTrigger}) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('de'),
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => onTrigger(ctx),
              child: const Text('Auslösen'),
            ),
          ),
        ),
      );
    }

    testWidgets('Gibt true zurück ohne Dialog wenn Einstellung deaktiviert ist', (tester) async {
      await StorageService.setFrageVorLautsprecher(false);
      AudioAusgabe.instanz.testIstLautsprecher = true;

      bool? ergebnis;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(ergebnis, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Gibt true zurück ohne Dialog wenn Kopfhörer verbunden sind', (tester) async {
      await StorageService.setFrageVorLautsprecher(true);
      AudioAusgabe.instanz.testIstLautsprecher = false;

      bool? ergebnis;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(ergebnis, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Zeigt Dialog wenn Lautsprecher aktiv und bricht bei Abbrechen ab', (tester) async {
      await StorageService.setFrageVorLautsprecher(true);
      AudioAusgabe.instanz.testIstLautsprecher = true;

      bool? ergebnis;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Lautsprecher'), findsOneWidget);
      expect(find.text('Die Wiedergabe läuft über den Lautsprecher. Trotzdem abspielen?'), findsOneWidget);

      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();

      expect(ergebnis, isFalse);
      expect(StorageService.getFrageVorLautsprecher(), isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Bestätigen spielt ab und lässt Einstellung unverändert', (tester) async {
      await StorageService.setFrageVorLautsprecher(true);
      AudioAusgabe.instanz.testIstLautsprecher = true;

      bool? ergebnis;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Abspielen'));
      await tester.pumpAndSettle();

      expect(ergebnis, isTrue);
      expect(StorageService.getFrageVorLautsprecher(), isTrue);
    });

    testWidgets('Nicht mehr fragen merkt sich die Einstellung', (tester) async {
      await StorageService.setFrageVorLautsprecher(true);
      AudioAusgabe.instanz.testIstLautsprecher = true;

      bool? ergebnis;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Checkbox antippen
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Abspielen antippen
      await tester.tap(find.text('Abspielen'));
      await tester.pumpAndSettle();

      expect(ergebnis, isTrue);
      expect(StorageService.getFrageVorLautsprecher(), isFalse);

      // Zweiter Aufruf fragt nicht mehr nach
      bool? ergebnis2;
      await tester.pumpWidget(testApp(
        onTrigger: (ctx) async {
          ergebnis2 = await frageVorLautsprecher(ctx);
        },
      ));

      await tester.tap(find.text('Auslösen'));
      await tester.pumpAndSettle();

      expect(ergebnis2, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
