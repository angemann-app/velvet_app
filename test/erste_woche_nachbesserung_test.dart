import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/bedien_daten.dart';
import 'package:velvetpulse/models/erste_woche.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';
import 'package:velvetpulse/services/listen_uebersetzung.dart';
import 'package:velvetpulse/screens/couples_channel/erste_woche_screen.dart';
import 'package:velvetpulse/screens/couples_channel/paar_abend_screen.dart';
import 'package:velvetpulse/screens/yes_no_maybe/yes_no_maybe_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/erste_woche_dienst.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Sprache.geraetFuerTest = 'de';

  Future<void> speicher({Map<String, Object> werte = const {}}) async {
    SharedPreferences.setMockInitialValues(werte);
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
  }

  group('Inhalte und Modell', () {
    test('Lektions-IDs der Schritte existieren in den geladenen Inhalten', () async {
      await speicher();
      await DataService.neuLaden();
      for (final s in ErsteWoche.schritte) {
        for (final id in [s.lektion, s.alternative]) {
          if (id == null) continue;
          expect(DataService.getLessonById(id), isNotNull, reason: 'Schritt ${s.nr}: $id');
        }
      }
      expect(DataService.getLessonById(ErsteWoche.menueLektion), isNotNull);
    });

    test('Fantasie-Landkarte: die Kategorie von Schritt 5 gibt es und ist nicht Spicy', () async {
      await speicher();
      await DataService.neuLaden();
      final k = velvetYesNoMaybeCategories.where((c) => c.id == ersteWocheKategorie);
      expect(k.length, 1);
      expect(k.first.spicy, isFalse);
      expect(ListenUebersetzung.kategorien.any((c) => c.id == ersteWocheKategorie), isTrue);
    });

    test('unbekannte Schrittwerte werden übersprungen, nichts wird geworfen', () {
      final s = ErsteWocheStand.fromJson({
        'geaendert': '2026-11-12T09:00:00Z',
        'schritte': {'1': 'getan', '9': 'getan', '2': 'irgendwas', 'x': 'getan'},
      });
      expect(s.schritte, {1: 'getan'});
    });

    test('Stimmen-Vorschlag: Mann Martin, sonst Victoria', () {
      UserProfile p(String g) => UserProfile(
          name: 'A', gender: g, age: 30, relationshipStatus: 'relationship', primaryGoal: 'open');
      expect(StorageService.stimmenVorschlag(p('male')), 'martin');
      expect(StorageService.stimmenVorschlag(p('female')), 'victoria');
      expect(StorageService.stimmenVorschlag(p('other')), 'victoria');
      expect(StorageService.stimmenVorschlag(p('unspecified')), 'victoria');
    });

    test('Paar-Abend: unbekanntes oder diverses Geschlecht ergibt keinen Körper', () {
      expect(paarAbendKoerper('female'), 'vulva');
      expect(paarAbendKoerper('male'), 'penis');
      expect(paarAbendKoerper('other'), isNull);
      expect(paarAbendKoerper('unspecified'), isNull);
      expect(paarAbendKoerper(null), isNull);
    });

    test('„Sagen, wo ich bin“ sendet nichts ohne Bestätigung', () async {
      final gesendet = <String>[];
      Future<bool> senden(String s) async {
        gesendet.add(s);
        return true;
      }

      expect(await ErsteWoche.nachrichtSenden(null, 'Hallo', senden), isNull);
      expect(await ErsteWoche.nachrichtSenden(false, 'Hallo', senden), isNull);
      expect(await ErsteWoche.nachrichtSenden(true, '   ', senden), isNull);
      expect(gesendet, isEmpty);
      expect(await ErsteWoche.nachrichtSenden(true, ' Hallo ', senden), isTrue);
      expect(gesendet, ['Hallo']);
      expect(await ErsteWoche.nachrichtSenden(true, 'x', (_) async => false), isFalse);
    });
  });

  group('Schritt-Seite', () {
    setUp(() async {
      await speicher();
    });

    Future<void> oeffnen(WidgetTester tester, int nr) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Builder(
            builder: (ctx) => Scaffold(
                body: Center(
                    child: TextButton(
                        onPressed: () => Navigator.of(ctx).push(
                            MaterialPageRoute(builder: (_) => ErsteWocheScreen(nr: nr, backup: false))),
                        child: const Text('auf'))))),
      ));
      await tester.tap(find.text('auf'));
      await tester.pumpAndSettle();
    }

    testWidgets('„Haben wir gemacht“ speichert „getan“ und schließt die Seite', (tester) async {
      await oeffnen(tester, 3);
      expect(find.text(t.ersteWocheS3Titel), findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(find.text(t.ersteWocheGemacht));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();
      expect(find.text(t.ersteWocheS3Titel), findsNothing);
      expect(ErsteWocheDienst.stand()?.schritte, {3: ErsteWocheStand.getan});
    });

    testWidgets('„Diesen Schritt überspringen“ speichert „übersprungen“', (tester) async {
      await oeffnen(tester, 2);
      await tester.runAsync(() async {
        await tester.tap(find.text(t.ersteWocheUeberspringen));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();
      expect(find.text(t.ersteWocheS2Titel), findsNothing);
      expect(ErsteWocheDienst.stand()?.schritte, {2: ErsteWocheStand.uebersprungen});
    });

    testWidgets('„Heute nicht“ schließt, speichert nichts und antwortet ruhig', (tester) async {
      await oeffnen(tester, 1);
      await tester.tap(find.text(t.ersteWocheHeuteNicht));
      await tester.pumpAndSettle();
      expect(find.text(t.ersteWocheS1Titel), findsNothing);
      expect(find.text(t.ersteWocheHeuteNichtAntwort), findsOneWidget);
      expect(ErsteWocheDienst.stand(), isNull);
    });

    testWidgets('ohne Paar-Verbindung gibt es „Sagen, wo ich bin“ nicht', (tester) async {
      await oeffnen(tester, 1);
      expect(find.text(t.ersteWocheSagenWo), findsNothing);
    });
  });

  group('Fantasie-Landkarte mit Filter', () {
    testWidgets('nurKategorie zeigt nur diese Kategorie, „Alle Bereiche“ hebt es auf', (tester) async {
      await speicher();
      await tester.runAsync(() => DataService.neuLaden());
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(home: YesNoMaybeScreen(nurKategorie: ersteWocheKategorie)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Sinnlichkeit & Sinne'), findsOneWidget);
      expect(find.text(t.ersteWocheAlleBereiche), findsOneWidget);
      // Andere Kategorien sind nicht zu sehen.
      expect(find.text('Sinnlichkeit & Sinne'), findsOneWidget);
      final anzahlNur = find.byType(Card).evaluate().length + find.byType(Text).evaluate().length;
      await tester.ensureVisible(find.text(t.ersteWocheAlleBereiche));
      await tester.tap(find.text(t.ersteWocheAlleBereiche));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(t.ersteWocheAlleBereiche), findsNothing);
      expect(find.byType(Card).evaluate().length + find.byType(Text).evaluate().length,
          greaterThan(anzahlNur));
    });
  });
}
