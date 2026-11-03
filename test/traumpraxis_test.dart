import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/traum_eintrag.dart';
import 'package:velvetpulse/models/traumpraxis.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';
import 'package:velvetpulse/screens/self_exploration/traumpraxis_verwalten.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:velvetpulse/screens/self_exploration/traumpraxis_screen.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

TraumEintrag eintrag(String id, int tag,
        {String text = 'Warmer Garten', Set<String> marken = const {}}) =>
    TraumEintrag(
        id: id, zeit: DateTime(2026, 10, tag), text: text, marken: marken);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting('de');
    await initializeDateFormatting('en');
  });

  Future<void> vorbereiten(
      {bool spicy = true, List<TraumEintrag> eintraege = const []}) async {
    SharedPreferences.setMockInitialValues({
      'spicy_mode': spicy,
      'traum_tagebuch': eintraege.map((e) => jsonEncode(e.toJson())).toList(),
    });
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    Sprache.wahl.value = 'de';
  }

  Future<void> zeigen(WidgetTester tester) => tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: const TraumpraxisScreen(),
      ));

  test(
      'Vorlagen schließen Belastung, leere Texte und nichts erinnert aus; Original bleibt unverändert',
      () {
    final original = [
      eintrag('alt', 1),
      eintrag('leer', 3, text: '  '),
      eintrag('belastet', 4, marken: {'unangenehm'}),
      eintrag('schlaf', 5, marken: {'schlecht_geschlafen'}),
      eintrag('nichts', 6, marken: {'nichts'}),
      eintrag('neu', 7, marken: {'hoehepunkt'}),
    ];
    expect(Traumpraxis.vorlagen(original).map((e) => e.id), ['neu', 'alt']);
    expect(original.first.id, 'alt');
  });

  test(
      'Pause bewertet chronologisch die neuesten sieben, unabhängig von Eingangsreihenfolge',
      () {
    final entries = [
      for (var i = 1; i <= 10; i++)
        eintrag('$i', i, marken: i <= 3 ? {'unangenehm'} : {})
    ];
    expect(Traumpraxis.pauseRaten(entries), isFalse);
    entries.addAll([
      for (var i = 11; i <= 13; i++)
        eintrag('$i', i, marken: {'schlecht_geschlafen'})
    ]);
    expect(Traumpraxis.pauseRaten(entries.reversed.toList()), isTrue);
  });

  testWidgets(
      'Direktaufruf ohne Spicy zeigt weder Übungen noch private Vorlagen',
      (tester) async {
    await vorbereiten(
        spicy: false,
        eintraege: [eintrag('privat', 1, text: 'Nur auf meinem Gerät')]);
    await zeigen(tester);
    expect(find.text(t.traumpraxisNurSpicy), findsOneWidget);
    expect(find.text(t.traumpraxisErinnern), findsNothing);
    expect(find.text('Nur auf meinem Gerät'), findsNothing);
  });

  testWidgets(
      'Bei belastenden Nächten pausiert MILD; Tagebuch bleibt erreichbar',
      (tester) async {
    await vorbereiten(eintraege: [
      for (var i = 1; i <= 3; i++) eintrag('$i', i, marken: {'unangenehm'})
    ]);
    await zeigen(tester);
    await tester.scrollUntilVisible(find.text(t.traumpraxisRuhe), 200);
    expect(find.text(t.traumpraxisRuhe), findsOneWidget);
    expect(find.text(t.traumpraxisMildSchritte), findsNothing);
    expect(find.text(t.tagebuchTitel), findsOneWidget);
  });

  testWidgets('Ausschalten von Spicy entfernt die aktive Praxis sofort',
      (tester) async {
    await vorbereiten();
    await zeigen(tester);
    expect(find.text(t.traumpraxisHoeren), findsOneWidget);
    await tester.scrollUntilVisible(find.text(t.traumpraxisErinnern), 200);
    expect(find.text(t.traumpraxisErinnern), findsOneWidget);
    await StorageService.setSpicyMode(false);
    await tester.pump();
    expect(find.text(t.traumpraxisHoeren), findsNothing);
    expect(find.text(t.traumpraxisNurSpicy), findsOneWidget);
    expect(find.text(t.traumpraxisErinnern), findsNothing);
  });

  testWidgets('Traumzeichen können angelegt und verändert werden',
      (tester) async {
    await vorbereiten();
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: const PraxisVerwaltung(ansicht: PraxisAnsicht.zeichen)));
    await tester.enterText(find.byType(TextField), 'Ein Fenster im Meer');
    await tester.tap(find.text(t.praxisHinzufuegen));
    await tester.pumpAndSettle();
    expect(StorageService.getTraumpraxis().zeichen.single.text,
        'Ein Fenster im Meer');
    await tester.scrollUntilVisible(find.text(t.praxisBearbeiten), 100,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(t.praxisBearbeiten));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Eine zweite Tür');
    await tester.tap(find.text(t.praxisSpeichern));
    await tester.pumpAndSettle();
    expect(
        StorageService.getTraumpraxis().zeichen.single.text, 'Eine zweite Tür');
  });

  testWidgets(
      'Tagesformular erhält Nullwerte und speichert eine bearbeitete Notiz',
      (tester) async {
    await vorbereiten();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'traumpraxis',
        jsonEncode(TraumpraxisDaten([
          PraxisEintrag(
              id: '2026-11-01',
              art: 'tag',
              geaendert: DateTime(2026, 11, 1),
              lust: 0,
              hoehepunkt: false),
        ]).toJson()));
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(
            builder: (context) => Scaffold(
                  body: TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const PraxisVerwaltung(
                                  ansicht: PraxisAnsicht.beobachtung,
                                  tag: '2026-11-01'))),
                      child: const Text('open')),
                ))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(TextField), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.enterText(find.byType(TextField), 'Heute war Raum für Ruhe.');
    await tester.scrollUntilVisible(find.text(t.praxisSpeichern), 100,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(t.praxisSpeichern));
    await tester.pumpAndSettle();
    final day = StorageService.getTraumpraxis().tage.single;
    expect(day.lust, 0);
    expect(day.schlaf, isNull);
    expect(day.hoehepunkt, false);
    expect(day.klar, isNull);
    expect(day.text, 'Heute war Raum für Ruhe.');
  });

  testWidgets(
      'Alle Verwaltungsansichten DE/EN bei 1,6-facher Schrift ohne Überlauf',
      (tester) async {
    await vorbereiten();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final lang in ['de', 'en']) {
      Sprache.wahl.value = lang;
      for (final view in PraxisAnsicht.values) {
        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.darkTheme,
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.6)),
                child: child!),
            home:
                PraxisVerwaltung(key: ValueKey('$lang/$view'), ansicht: view)));
        await tester.drag(
            find.byType(Scrollable).first, const Offset(0, -1200));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets(
      'Persönliches Traumzeichen wird in die Abendvorbereitung übernommen',
      (tester) async {
    await vorbereiten();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'traumpraxis',
        jsonEncode(TraumpraxisDaten([
          PraxisEintrag(
              id: 'a',
              art: 'zeichen',
              geaendert: DateTime(2026, 11, 1),
              text: 'Eine zweite Tür'),
        ]).toJson()));
    await zeigen(tester);
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('zeichen:null')), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const ValueKey('zeichen:null')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eine zweite Tür').last);
    await tester.pumpAndSettle();
    expect(find.text(t.praxisZeichenAbsicht), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DE/EN und große Schrift auf kleinem Display ohne Überlauf',
      (tester) async {
    await vorbereiten();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final lang in ['de', 'en']) {
      Sprache.wahl.value = lang;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.6)),
          child: child!,
        ),
        home: TraumpraxisScreen(key: ValueKey(lang)),
      ));
      await tester.scrollUntilVisible(find.text(t.traumpraxisErkundung), 250,
          maxScrolls: 60);
      expect(tester.takeException(), isNull);
    }
  });
}
