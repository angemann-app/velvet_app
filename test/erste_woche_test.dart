import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/bedien_daten.dart';
import 'package:velvetpulse/models/erste_woche.dart';
import 'package:velvetpulse/services/erste_woche_dienst.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/erste_woche_karte.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Sprache.geraetFuerTest = 'de';

  final z0 = DateTime.utc(2026, 11, 12, 9);

  group('Modell', () {
    test('aktueller Schritt ist der erste nicht erledigte oder übersprungene', () {
      var s = ErsteWocheStand(geaendert: z0);
      expect(s.aktuellerSchritt, 1);
      s = s.mitSchritt(1, ErsteWocheStand.getan, z0);
      expect(s.aktuellerSchritt, 2);
      s = s.mitSchritt(2, ErsteWocheStand.uebersprungen, z0);
      expect(s.aktuellerSchritt, 3);
      expect(s.beginn, z0);
      // Reihenfolge ist frei: Schritt 4 vor 3 ändert den aktuellen nicht.
      s = s.mitSchritt(4, ErsteWocheStand.getan, z0);
      expect(s.aktuellerSchritt, 3);
      for (var n = 3; n <= 7; n++) {
        s = s.mitSchritt(n, ErsteWocheStand.getan, z0);
      }
      expect(s.aktuellerSchritt, isNull);
      expect(s.abgeschlossen, isTrue);
    });

    test('JSON-Runde und tolerante Felder', () {
      final s = ErsteWocheStand(geaendert: z0)
          .mitSchritt(2, ErsteWocheStand.uebersprungen, z0)
          .kopie(ausgeblendet: true, geaendert: z0);
      final j = ErsteWocheStand.fromJson(s.toJson());
      expect(j.schritte, {2: ErsteWocheStand.uebersprungen});
      expect(j.ausgeblendet, isTrue);
      final minimal = ErsteWocheStand.fromJson({'geaendert': '2026-11-12T09:00:00Z'});
      expect(minimal.schritte, isEmpty);
      expect(minimal.ausgeblendet, isFalse);
    });

    test('Zusammenführen: die jüngere Änderung gewinnt', () {
      final alt = ErsteWocheStand(geaendert: z0)
          .mitSchritt(1, ErsteWocheStand.getan, z0);
      final neu = alt.mitSchritt(2, ErsteWocheStand.getan, z0.add(const Duration(hours: 2)));
      final a = BedienDaten(ersteWoche: alt).zusammen(BedienDaten(ersteWoche: neu));
      final b = BedienDaten(ersteWoche: neu).zusammen(BedienDaten(ersteWoche: alt));
      expect(a.ersteWoche!.schritte.length, 2);
      expect(b.ersteWoche!.schritte.length, 2);
      expect(BedienDaten(ersteWoche: alt).zusammen(const BedienDaten()).ersteWoche, isNotNull);
    });

    test('Sieben Schritte, alle mit Titel und Text; lange Pause nur bei offener Woche', () {
      expect(ErsteWoche.schritte.length, 7);
      for (final s in ErsteWoche.schritte) {
        expect(s.titel, isNotEmpty);
        expect(s.text, isNotEmpty);
        expect(s.titel.toLowerCase(), isNot(contains('sex')));
        expect(s.titel.toLowerCase(), isNot(contains('lust')));
        expect(s.titel.toLowerCase(), isNot(contains('traum')));
        expect(s.titel.toLowerCase(), isNot(contains('erotisch')));
      }
      final s = ErsteWocheStand(geaendert: z0).mitSchritt(1, ErsteWocheStand.getan, z0);
      expect(ErsteWoche.istLangePause(s, z0.add(const Duration(days: 3))), isFalse);
      expect(ErsteWoche.istLangePause(s, z0.add(const Duration(days: 9))), isTrue);
      expect(ErsteWoche.istLangePause(null, z0), isFalse);
    });
  });

  group('Karte', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
      SecretStore.resetForTest();
      StorageService.resetForTest();
      await StorageService.init();
    });

    Future<void> zeigen(WidgetTester tester, {DateTime? jetzt}) => tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body: SingleChildScrollView(
                    child: ErsteWocheKarte(imTabWir: true, jetzt: jetzt == null ? null : () => jetzt)))));

    testWidgets('zeigt Schritt, Dauer und Punkte, aber keinen Zähler und keine Prozente', (tester) async {
      await zeigen(tester);
      expect(find.text(t.ersteWocheS1Titel), findsOneWidget);
      expect(find.text(t.ersteWocheSchrittMin(1, 10)), findsOneWidget);
      final texte = tester.widgetList<Text>(find.byType(Text)).map((w) => w.data ?? '').join(' | ');
      expect(texte, isNot(contains('von 7')));
      expect(texte, isNot(contains('%')));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      final semantik = tester.getSemantics(find.byType(ErsteWochePunkte));
      expect(semantik.toString(), isNot(contains('von 7')));
      expect(semantik.toString(), isNot(contains('%')));
    });

    testWidgets('„Heute nicht“ klappt nur zusammen und speichert nichts', (tester) async {
      await zeigen(tester, jetzt: DateTime(2026, 11, 12, 10));
      await tester.tap(find.text(t.ersteWocheHeuteNicht));
      await tester.pump();
      expect(find.text(t.ersteWocheZugeklappt), findsOneWidget);
      expect(find.text(t.ersteWocheAnsehen), findsNothing);
      expect(ErsteWocheDienst.stand(), isNull);
      await tester.tap(find.text(t.ersteWocheZugeklappt));
      await tester.pump();
      expect(find.text(t.ersteWocheAnsehen), findsOneWidget);
    });

    testWidgets('Fortschritt rückt vor, Ausblenden und Wiederzeigen, Schluss mit „Gut so“', (tester) async {
      await zeigen(tester);
      await tester.runAsync(() => ErsteWocheDienst.markieren(1, ErsteWocheStand.getan, backup: false));
      await tester.pump();
      expect(find.text(t.ersteWocheS2Titel), findsOneWidget);

      await tester.runAsync(() => ErsteWocheDienst.ausgeblendet(true, backup: false));
      await tester.pump();
      expect(find.text(t.ersteWocheWiederZeigen), findsOneWidget);
      await tester.runAsync(() => ErsteWocheDienst.ausgeblendet(false, backup: false));
      await tester.pump();
      expect(find.text(t.ersteWocheS2Titel), findsOneWidget);

      for (var n = 2; n <= 7; n++) {
        await tester.runAsync(() => ErsteWocheDienst.markieren(n, ErsteWocheStand.uebersprungen, backup: false));
      }
      await tester.pump();
      expect(find.text(t.ersteWocheGeschafft), findsOneWidget);
      // Tippen auf „Gut so“ ruft dieselbe Dienstfunktion; mit Auto-Backup hängt das im Test.
      await tester.runAsync(() => ErsteWocheDienst.ausgeblendet(true, backup: false));
      await tester.pump();
      expect(find.text(t.ersteWocheGeschafft), findsNothing);
      expect(find.text(t.ersteWocheWiederZeigen), findsOneWidget);
    });

    testWidgets('lange Pause: nur eine sanfte Einladung', (tester) async {
      await tester.runAsync(() => ErsteWocheDienst.markieren(1, ErsteWocheStand.getan, jetzt: DateTime.utc(2026, 11, 1), backup: false));
      await zeigen(tester, jetzt: DateTime(2026, 11, 20));
      expect(find.text(t.ersteWocheLangePause(2)), findsOneWidget);
      expect(find.text(t.ersteWocheSchrittMin(2, 7)), findsNothing);
    });
  });
}
