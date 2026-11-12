// Schutz der Privatsphäre (docs/konzepte/privatsphaere-schutz.md): App-Sperre als Standard, Spicy-Frist 5 Stunden
// mit Hinweis beim Ablauf, Fantasie-Hinweis einmal je Gerät.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/alter_dienst.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/privacy_service.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/app_sperre_frage.dart';
import 'package:velvetpulse/widgets/fantasie_hinweis.dart';
import 'package:velvetpulse/widgets/spicy_abgelaufen_hinweis.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var abfragen = 0;

  Future<void> starten({Map<String, Object> werte = const {}, bool unterstuetzt = true, bool bestaetigt = true}) async {
    SharedPreferences.setMockInitialValues(werte);
    StorageService.resetForTest();
    AlterDienst.zuruecksetzen();
    abfragen = 0;
    PrivacyService.unterstuetztFuerTest = unterstuetzt;
    PrivacyService.authenticateFuerTest = () async {
      abfragen++;
      return bestaetigt;
    };
    await StorageService.init();
  }

  Future<bool> sperreAn() => PrivacyService.isLockEnabled();
  Future<bool?> merker() async => (await SharedPreferences.getInstance()).getBool(PrivacyService.keyFrageGestellt);

  tearDown(() {
    AlterDienst.zuruecksetzen();
    PrivacyService.authenticateFuerTest = null;
    PrivacyService.unterstuetztFuerTest = null;
  });

  /// Seite mit einem Knopf, der [aktion] startet; so laufen die Blätter wie in der App.
  Future<void> seite(WidgetTester tester, Future<void> Function(BuildContext) aktion) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(onPressed: () => aktion(context), child: const Text('los')),
        ),
      ),
    ));
  }

  Future<void> los(WidgetTester tester) async {
    await tester.tap(find.text('los'));
    await tester.pumpAndSettle();
    // Die Gerätesperre ruft einen (im Test fehlenden) Plattformkanal; dessen Antwort kommt erst außerhalb der Testzeit.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  group('App-Sperre bei der neuen Einrichtung', () {
    test('Mit Bildschirmsperre: an, einmal bestätigt, Merker gesetzt', () async {
      await starten();
      expect(await PrivacyService.standardEinrichten(), SperrEinrichtung.eingeschaltet);
      expect(await sperreAn(), isTrue);
      expect(abfragen, 1);
      expect(await merker(), isTrue);
      // Danach keine Bestandsfrage mehr.
      expect(await PrivacyService.frageNoetig(), isFalse);
    });

    test('Ohne Bildschirmsperre: bleibt aus, keine Abfrage', () async {
      await starten(unterstuetzt: false);
      expect(await PrivacyService.standardEinrichten(), SperrEinrichtung.nichtMoeglich);
      expect(await sperreAn(), isFalse);
      expect(abfragen, 0);
      expect(await merker(), isTrue);
      // Auch wenn später eine Bildschirmsperre dazukommt, fragt die App nicht aufdringlich nach.
      PrivacyService.unterstuetztFuerTest = true;
      expect(await PrivacyService.frageNoetig(), isFalse);
    });

    test('Bestätigung abgebrochen: Sperre bleibt aus, niemand sperrt sich aus', () async {
      await starten(bestaetigt: false);
      expect(await PrivacyService.standardEinrichten(), SperrEinrichtung.abgebrochen);
      expect(await sperreAn(), isFalse);
    });

    testWidgets('Blatt „Nur für dich“ nach dem Einschalten', (tester) async {
      await tester.runAsync(() => starten());
      await seite(tester, appSperreEinrichten);
      await los(tester);
      expect(find.text(t.appSperreNeuTitel), findsOneWidget);
      expect(find.text(t.appSperreNeuText), findsOneWidget);
      await tester.tap(find.text(t.appSperreNeuOk));
      await tester.pumpAndSettle();
      expect(find.text(t.appSperreNeuTitel), findsNothing);
      expect(await tester.runAsync(sperreAn), isTrue);
    });

    testWidgets('Ohne Bildschirmsperre: Blatt mit Anleitung, Sperre bleibt aus', (tester) async {
      await tester.runAsync(() => starten(unterstuetzt: false));
      await seite(tester, appSperreEinrichten);
      await los(tester);
      expect(find.text(t.appSperreKeineTitel), findsOneWidget);
      await tester.tap(find.text(t.appSperreKeineOk));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(sperreAn), isFalse);
    });
  });

  group('App-Sperre beim Bestand', () {
    test('Hat schon eine Sperre: keine Frage, Merker gesetzt', () async {
      await starten(werte: {'privacy_lock_enabled': true});
      expect(await PrivacyService.frageNoetig(), isFalse);
      expect(await merker(), isTrue);
    });

    test('Ohne Bildschirmsperre: nichts zeigen, nichts merken', () async {
      await starten(unterstuetzt: false);
      expect(await PrivacyService.frageNoetig(), isFalse);
      expect(await merker(), isNull);
    });

    testWidgets('„Ja, sperren“: Sperre an, danach nie wieder gefragt', (tester) async {
      await tester.runAsync(() => starten());
      await seite(tester, appSperreFrageWennNoetig);
      await los(tester);
      expect(find.text(t.appSperreFrageTitel), findsOneWidget);
      await tester.tap(find.text(t.appSperreFrageJa));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(sperreAn), isTrue);
      expect(abfragen, 1);

      await los(tester);
      expect(find.text(t.appSperreFrageTitel), findsNothing);
    });

    testWidgets('„Nicht jetzt“: Sperre bleibt aus, die App fragt nie wieder von selbst', (tester) async {
      await tester.runAsync(() => starten());
      await seite(tester, appSperreFrageWennNoetig);
      await los(tester);
      await tester.tap(find.text(t.appSperreFrageNein));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(sperreAn), isFalse);
      expect(abfragen, 0);
      expect(await tester.runAsync(merker), isTrue);

      await los(tester);
      expect(find.text(t.appSperreFrageTitel), findsNothing);
    });
  });

  test('Sperr-Schlüssel stehen nicht in Sicherung oder Backup-Merge', () async {
    await starten(werte: {'privacy_lock_enabled': true, PrivacyService.keyFrageGestellt: true});
    final export = StorageService.exportAllUserData();
    final text = export.toString();
    expect(text.contains('app_sperre'), isFalse);
    expect(text.contains('privacy_lock'), isFalse);
    for (final f in ['lib/services/storage_service.dart', 'lib/services/backup_codec.dart']) {
      final q = File(f).readAsStringSync();
      expect(q.contains('app_sperre_frage_gestellt'), isFalse, reason: f);
      expect(q.contains('privacy_lock_enabled'), isFalse, reason: f);
    }
    // Eine Sicherung mit diesen Feldern überträgt sie nicht.
    export['app_sperre_frage_gestellt'] = false;
    export['privacy_lock_enabled'] = false;
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(await sperreAn(), isTrue);
    expect(await merker(), isTrue);
  });

  group('Spicy-Frist', () {
    Future<void> spicyEntsperrt() async {
      await starten();
      await AlterDienst.init();
      await AlterDienst.angabePruefen(1990, 3);
      await StorageService.setSpicyMode(true);
      await AlterDienst.entsperren();
      expect(StorageService.spicyMode(), isTrue);
    }

    test('Standard sind fest 5 Stunden', () {
      AlterDienst.zuruecksetzen();
      expect(AlterDienst.erneutNach, const Duration(hours: 5));
    });

    test('Knapp unter 5 Stunden bleibt Spicy offen, knapp darüber nicht', () async {
      await spicyEntsperrt();
      final jetzt = DateTime.now();
      AlterDienst.hintergrundStartFuerTest(jetzt.subtract(const Duration(hours: 4, minutes: 59)));
      AlterDienst.hintergrundEnde(jetzt);
      expect(StorageService.spicyMode(), isTrue);
      expect(AlterDienst.ablaufHinweisAbholen(), isFalse);

      AlterDienst.hintergrundStartFuerTest(jetzt.subtract(const Duration(hours: 5, minutes: 1)));
      AlterDienst.hintergrundEnde(jetzt);
      expect(StorageService.spicyMode(), isFalse);
      expect(StorageService.spicyGewaehlt(), isTrue, reason: 'die Wahl bleibt');
    });

    test('Ablauf-Hinweis genau einmal je Ablauf', () async {
      await spicyEntsperrt();
      final vorher = AlterDienst.ablauf.value;
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 6)));
      AlterDienst.hintergrundEnde();
      expect(AlterDienst.ablauf.value, vorher + 1);
      expect(AlterDienst.ablaufHinweisAbholen(), isTrue);
      expect(AlterDienst.ablaufHinweisAbholen(), isFalse);
      // Ein zweites Zurückkehren ohne neue Entsperrung meldet nichts mehr.
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 6)));
      AlterDienst.hintergrundEnde();
      expect(AlterDienst.ablaufHinweisAbholen(), isFalse);
    });

    test('Ohne gewähltes Spicy kein Hinweis', () async {
      await spicyEntsperrt();
      await StorageService.setSpicyMode(false);
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 6)));
      AlterDienst.hintergrundEnde();
      expect(AlterDienst.ablaufHinweisAbholen(), isFalse);
    });

    testWidgets('Hinweis „Spicy-Modus ist aus“: einmal, „Wieder entsperren“ schaltet Spicy wieder frei', (tester) async {
      await tester.runAsync(spicyEntsperrt);
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 6)));
      AlterDienst.hintergrundEnde();
      await seite(tester, spicyAbgelaufenZeigenWennNoetig);
      await los(tester);
      expect(find.text(t.spicyAbgelaufenTitel), findsOneWidget);
      await tester.tap(find.text(t.spicyAbgelaufenEntsperren));
      await tester.pumpAndSettle();
      expect(StorageService.spicyMode(), isTrue);

      await los(tester);
      expect(find.text(t.spicyAbgelaufenTitel), findsNothing);
    });

    testWidgets('„Später“ schließt nur, Spicy bleibt aus', (tester) async {
      await tester.runAsync(spicyEntsperrt);
      AlterDienst.hintergrundStartFuerTest(DateTime.now().subtract(const Duration(hours: 6)));
      AlterDienst.hintergrundEnde();
      await seite(tester, spicyAbgelaufenZeigenWennNoetig);
      await los(tester);
      await tester.tap(find.text(t.spicyAbgelaufenSpaeter));
      await tester.pumpAndSettle();
      expect(find.text(t.spicyAbgelaufenTitel), findsNothing);
      expect(StorageService.spicyMode(), isFalse);
    });
  });

  group('Fantasie-Hinweis', () {
    testWidgets('Erscheint einmal je Gerät, auch über beide Stellen hinweg', (tester) async {
      await tester.runAsync(() => starten());
      await seite(tester, (c) => fantasieHinweisEinmal(c, drei: true));
      await los(tester);
      expect(find.text(t.fantasieHinweisTitel), findsOneWidget);
      expect(find.text(t.fantasieHinweisDrei), findsOneWidget);
      await tester.tap(find.text(t.fantasieHinweisOk));
      await tester.pumpAndSettle();
      expect(StorageService.fantasieHinweisGesehen(), isTrue);

      await los(tester);
      expect(find.text(t.fantasieHinweisTitel), findsNothing);
    });

    testWidgets('Ohne Szenen zu dritt kein Zusatzsatz', (tester) async {
      await tester.runAsync(() => starten());
      await seite(tester, fantasieHinweisEinmal);
      await los(tester);
      expect(find.text(t.fantasieHinweisTitel), findsOneWidget);
      expect(find.text(t.fantasieHinweisDrei), findsNothing);
    });
  });
}
