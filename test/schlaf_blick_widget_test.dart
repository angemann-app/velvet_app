import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';
import 'package:velvetpulse/screens/self_exploration/traumpraxis_verwalten.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';
import 'package:velvetpulse/widgets/schlaf_traum_blick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => initializeDateFormatting('de'));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
  });

  Future<void> zeigen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
            body: SingleChildScrollView(child: SchlafTraumBlick(neu: () {})))));
    await tester.pump();
  }

  testWidgets('Alles, was du zur Nacht festgehalten hast, ist sichtbar', (tester) async {
    final heute = PraxisEintrag.datum(DateTime.now());
    await StorageService.savePraxisEintrag(PraxisEintrag(
        id: heute,
        art: 'tag',
        geaendert: DateTime.now(),
        text: 'Ein Fenster im Meer',
        schlaf: 3,
        lust: 2,
        sinnlich: true,
        klar: false));
    await zeigen(tester);
    expect(find.text(praxisSchlafName(3)), findsOneWidget);
    expect(find.text(praxisLustName(2)), findsOneWidget);
    expect(find.text(t.schlafBlickSinnlich), findsOneWidget);
    expect(find.text('Ein Fenster im Meer'), findsOneWidget);
    expect(find.text(t.schlafBlickHeute), findsOneWidget);
    expect(find.text(t.schlafBlickAendern), findsOneWidget);
  });

  testWidgets('Nur Nein-Antworten: der Tag zeigt „Nichts Besonderes notiert“', (tester) async {
    await StorageService.savePraxisEintrag(PraxisEintrag(
        id: PraxisEintrag.datum(DateTime.now()),
        art: 'tag',
        geaendert: DateTime.now(),
        sinnlich: false,
        klar: false,
        hoehepunkt: false));
    await zeigen(tester);
    expect(find.text(t.schlafBlickKeineBesonderheiten), findsOneWidget);
    expect(find.text(t.schlafBlickAendern), findsOneWidget);
  });

  testWidgets('Ohne Angaben lädt ein Knopf zum Festhalten ein', (tester) async {
    await zeigen(tester);
    expect(find.text(t.schlafBlickNochNichts), findsWidgets);
    expect(find.text(t.schlafBlickNacht), findsWidgets);
  });
}
