import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/audio_gruppen.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';
import 'package:velvetpulse/widgets/gefuehrte_audios.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
  });

  Future<void> zeigen(WidgetTester tester, Widget w, {double schrift = 1.0}) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        builder: (c, child) => MediaQuery(
            data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(schrift)), child: child!),
        home: Scaffold(body: SingleChildScrollView(child: w))));
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('Heute: Empfehlung und Gruppen, Geschichten nur im Spicy-Modus', (tester) async {
    await zeigen(tester, const AudioGruppenBereich(mitPaar: true));
    expect(find.text(t.audioFuerHeute), findsOneWidget);
    expect(find.text(t.audioAlleAnzeigen), findsOneWidget);
    expect(find.text(t.audioGruppeFuerUns), findsOneWidget);
    expect(find.text(t.audioGruppeGeschichten), findsNothing);
    await StorageService.setSpicyMode(true);
    await tester.pump();
    expect(find.text(t.audioGruppeGeschichten), findsOneWidget);
  });

  testWidgets('Ohne Paar-Bezug gibt es keine Gruppe „Für uns“', (tester) async {
    await zeigen(tester, const AudioGruppenBereich(mitPaar: false));
    expect(find.text(t.audioGruppeFuerUns), findsNothing);
  });

  testWidgets('Alle anzeigen öffnet die vollständige Liste', (tester) async {
    await zeigen(tester, const AudioGruppenBereich(mitPaar: true));
    await tester.tap(find.text(t.audioAlleAnzeigen));
    await tester.pumpAndSettle();
    expect(find.text(t.gefuehrtSelbstTitel), findsOneWidget);
    expect(find.text(t.couplesChannelSharedEvening), findsOneWidget);
  });

  for (final g in AudioGruppe.values) {
    testWidgets('Gruppenseite ${g.name} rendert ohne Überlauf bei großer Schrift', (tester) async {
      await StorageService.setSpicyMode(true);
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.darkTheme,
          builder: (c, child) => MediaQuery(
              data: MediaQuery.of(c).copyWith(textScaler: const TextScaler.linear(1.6)), child: child!),
          home: AudioGruppeSeite(gruppe: g, mitPaar: true)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });
  }
}
