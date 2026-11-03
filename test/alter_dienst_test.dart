// Altersnachweis für Spicy (docs/konzepte/altersnachweis.md): Selbstauskunft plus Gerätesperre, nur lokal.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/alter_dienst.dart';
import 'package:velvetpulse/services/privacy_service.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/spicy_modus_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('de');
    await initializeDateFormatting('en');
  });

  Future<void> starten([Map<String, Object> werte = const {}]) async {
    SharedPreferences.setMockInitialValues(werte);
    StorageService.resetForTest();
    AlterDienst.zuruecksetzen();
    PrivacyService.authenticateFuerTest = () async => true;
    PrivacyService.unterstuetztFuerTest = true;
    await StorageService.init();
    await AlterDienst.init();
  }

  tearDown(() {
    AlterDienst.zuruecksetzen();
    PrivacyService.authenticateFuerTest = null;
    PrivacyService.unterstuetztFuerTest = null;
  });

  group('Altersrechnung', () {
    test('18 gilt erst, wenn der Geburtsmonat des 18. Jahres vorbei ist', () {
      final jetzt = DateTime(2026, 11, 3);
      expect(AlterDienst.volljaehrig(2008, 10, jetzt), isTrue); // Oktober 2008: Monat vorbei
      expect(AlterDienst.volljaehrig(2008, 11, jetzt), isFalse); // November 2008: Monat läuft noch
      expect(AlterDienst.volljaehrig(2008, 12, jetzt), isFalse);
      expect(AlterDienst.volljaehrig(2000, 12, jetzt), isTrue);
      expect(AlterDienst.volljaehrig(2009, 1, jetzt), isFalse);
    });

    test('Dezember-Geburtsmonat rechnet über den Jahreswechsel', () {
      expect(AlterDienst.volljaehrig(2007, 12, DateTime(2026, 1, 1)), isTrue);
      expect(AlterDienst.volljaehrig(2008, 12, DateTime(2026, 12, 31)), isFalse);
      expect(AlterDienst.volljaehrig(2008, 12, DateTime(2027, 1, 1)), isTrue);
    });
  });

  group('Zustand', () {
    test('Ohne scharfe Prüfung (Tests) bleibt alles wie bisher', () async {
      SharedPreferences.setMockInitialValues({});
      StorageService.resetForTest();
      AlterDienst.zuruecksetzen();
      await StorageService.init();
      await StorageService.setSpicyMode(true);
      expect(StorageService.spicyMode(), isTrue);
    });

    test('Altbestand: Spicy an, aber nie bestätigt → bleibt aus, Wahl bleibt erhalten', () async {
      await starten({'spicy_mode': true});
      expect(StorageService.spicyGewaehlt(), isTrue);
      expect(StorageService.spicyMode(), isFalse);
    });

    test('Angabe unter 18 sperrt, speichert aber nichts Bestätigtes', () async {
      await starten();
      final jetzt = DateTime(2026, 11, 3);
      expect(await AlterDienst.angabePruefen(2010, 5, jetzt), isFalse);
      expect(AlterDienst.bestaetigt, isFalse);
      expect(AlterDienst.gesperrtBis(jetzt), jetzt.add(AlterDienst.sperrfrist));
      expect(AlterDienst.gesperrtBis(jetzt.add(const Duration(days: 31))), isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().any((k) => k.contains('geburt')), isFalse);
    });

    test('Bestätigung und Sperre überleben den Neustart, das Geburtsdatum nie', () async {
      await starten();
      expect(await AlterDienst.angabePruefen(1990, 3), isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().where((k) => k.startsWith('spicy_alter')), ['spicy_alter_bestaetigt']);
      expect(prefs.getInt('spicy_alter_bestaetigt'), isNotNull);
      for (final k in prefs.getKeys()) {
        expect(prefs.get(k).toString().contains('1990'), isFalse, reason: k);
      }
      AlterDienst.zuruecksetzen();
      await AlterDienst.init();
      expect(AlterDienst.bestaetigt, isTrue);
    });

    test('Bestätigt, aber ohne Entsperren: aus; nach Entsperren: an', () async {
      await starten();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      expect(StorageService.spicyMode(), isFalse);
      expect(await AlterDienst.entsperren(), isTrue);
      expect(StorageService.spicyMode(), isTrue);
    });

    test('Misslingt die Gerätesperre, bleibt Spicy zu', () async {
      await starten();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      PrivacyService.authenticateFuerTest = () async => false;
      expect(await AlterDienst.entsperren(), isFalse);
      expect(StorageService.spicyMode(), isFalse);
    });

    test('Nach langem Hintergrund verfällt die Entsperrung, nach kurzem nicht', () async {
      await starten();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      await AlterDienst.entsperren();

      AlterDienst.erneutNach = const Duration(minutes: 30);
      // Hintergrund simulieren
      final seit = DateTime.now().subtract(const Duration(minutes: 5));
      AlterDienst.hintergrundStartFuerTest(seit);
      AlterDienst.hintergrundEnde();
      expect(StorageService.spicyMode(), isTrue);

      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(minutes: 31)));
      AlterDienst.hintergrundEnde();
      expect(StorageService.spicyMode(), isFalse);
    });

    test('„Immer erneut absichern“ aus: kein erneutes Fragen', () async {
      await starten();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      await AlterDienst.setAbsichern(false);
      expect(StorageService.spicyMode(), isTrue);
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 3)));
      AlterDienst.hintergrundEnde();
      expect(StorageService.spicyMode(), isTrue);
    });

    test('Fällt die Gerätesperre weg, geht Spicy aus', () async {
      await starten();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      await AlterDienst.entsperren();
      expect(StorageService.spicyMode(), isTrue);
      PrivacyService.unterstuetztFuerTest = false;
      await AlterDienst.geraetesperreKontrollieren();
      expect(StorageService.spicyMode(), isFalse);
      expect(StorageService.spicyGewaehlt(), isFalse);
    });
  });

  test('Nachweis und Entsperrung stehen nicht in Sicherung oder Backup', () {
    for (final f in ['lib/services/storage_service.dart', 'lib/services/backup_codec.dart']) {
      final q = File(f).readAsStringSync();
      expect(q.contains('spicy_alter'), isFalse, reason: f);
      expect(q.contains('spicy_immer_absichern'), isFalse, reason: f);
    }
  });

  group('Dialog', () {
    Future<void> oeffnen(WidgetTester tester, void Function(bool) ergebnis) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => ergebnis(await spicyModusEinschalten(context)),
              child: const Text('los'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('los'));
      await tester.pumpAndSettle();
    }

    Future<void> waehle(WidgetTester tester, String key, int wert) async {
      tester.widget<DropdownButtonFormField<int>>(find.byKey(ValueKey(key))).onChanged!(wert);
      await tester.pumpAndSettle();
    }

    testWidgets('Ohne Gerätesperre gibt es einen Hinweis und kein Spicy', (tester) async {
      await tester.runAsync(starten);
      PrivacyService.unterstuetztFuerTest = false;
      bool? erg;
      await oeffnen(tester, (b) => erg = b);
      expect(find.text('Gerätesperre nötig'), findsOneWidget);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      expect(erg, isFalse);
      expect(StorageService.spicyMode(), isFalse);
    });

    testWidgets('Erwachsen: Angabe, Hinweis, Gerätesperre → Spicy an', (tester) async {
      await tester.runAsync(starten);
      bool? erg;
      await oeffnen(tester, (b) => erg = b);
      expect(find.text('Bist du volljährig?'), findsOneWidget);
      await waehle(tester, 'alter_monat', 1);
      await waehle(tester, 'alter_jahr', DateTime.now().year - 30);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      expect(find.text('Spicy-Modus einschalten?'), findsOneWidget);
      await tester.tap(find.text('Ich bin 18+, einschalten'));
      await tester.pumpAndSettle();
      expect(erg, isTrue);
      expect(StorageService.spicyMode(), isTrue);
    });

    testWidgets('Unter 18: Sperre, danach lässt der Dialog keine neue Angabe zu', (tester) async {
      await tester.runAsync(starten);
      bool? erg;
      await oeffnen(tester, (b) => erg = b);
      await waehle(tester, 'alter_monat', 1);
      await waehle(tester, 'alter_jahr', DateTime.now().year - 10);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      expect(find.text('Gerade nicht möglich'), findsOneWidget);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      expect(erg, isFalse);
      expect(StorageService.spicyMode(), isFalse);

      erg = null;
      await tester.tap(find.text('los'));
      await tester.pumpAndSettle();
      expect(find.text('Gerade nicht möglich'), findsOneWidget);
      expect(find.text('Bist du volljährig?'), findsNothing);
    });
  });
}
