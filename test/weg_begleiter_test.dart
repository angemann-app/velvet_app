import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/content_models.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/widgets/weg_begleiter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
    Sprache.geraetFuerTest = 'de';
  });
  tearDown(() => Sprache.geraetFuerTest = null);

  testWidgets(
      'Schritte nur ausdrücklich bestätigen; Öffnen verändert keine Antworten',
      (tester) async {
    final geoeffnet = <int>[];
    final lektion = Lesson(
        id: 'neutral',
        title: 'Beispiel',
        type: 'article',
        durationMin: 2,
        linkedTool: 'breath_pacer',
        summary: '',
        content: '',
        reflectionQuestion: 'Wie war es?');
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: WegBegleiter(lektion: lektion, oeffnen: geoeffnet.add))));
    expect(StorageService.getBedienDaten().weg, isNull);
    await tester.tap(find.text(t.wegBeginnen));
    await tester.pumpAndSettle();
    expect(StorageService.getBedienDaten().weg!.schritt, 0);
    for (var schritt = 0; schritt < 3; schritt++) {
      await tester.tap(find.text(t.wegOeffnen));
      await tester.pumpAndSettle();
      expect(StorageService.getBedienDaten().weg!.schritt, schritt);
      await tester
          .tap(find.text(schritt == 2 ? t.wegAbschliessen : t.wegWeiter));
      await tester.pumpAndSettle();
    }
    expect(geoeffnet, [0, 1, 2]);
    expect(StorageService.getBedienDaten().weg!.fertig, isTrue);
    expect(StorageService.getReflectionAnswer('neutral'), isNull);
    expect(StorageService.isLessonCompleted('neutral'), isFalse);
    expect(find.text(t.wegNochEinmal), findsOneWidget);
  });
}
