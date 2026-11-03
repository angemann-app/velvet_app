import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/content_models.dart';
import 'package:velvetpulse/services/inhalt_suche.dart';
import 'package:velvetpulse/services/storage_service.dart';

Lesson lektion(String id, {bool spicy = false}) => Lesson(
    id: id,
    title: id,
    type: 'article',
    durationMin: 2,
    linkedTool: 'none',
    summary: 'Zusammenfassung',
    content: 'Beispielinhalt',
    reflectionQuestion: 'Nicht durchsuchen',
    spicy: spicy);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
  });

  test('Index übernimmt ausschließlich sichtbare Kurse und Lektionen', () {
    final daten = VelvetDatabase(version: '1', sosCards: [], courses: [
      Course(
          id: 'offen',
          title: 'Offener Kurs',
          subtitle: '',
          icon: '',
          lessons: [lektion('normal'), lektion('verborgen', spicy: true)]),
      Course(
          id: 'privat',
          title: 'Verborgener Kurs',
          subtitle: '',
          icon: '',
          spicy: true,
          lessons: [lektion('nicht_sichtbar')]),
    ]);
    final suche = InhaltSuche(kurse: daten.courses);
    expect(suche.index.suche('normal').single.eintrag.id, 'lektion:normal');
    expect(suche.index.suche('verborgen'), isEmpty);
    expect(suche.index.suche('nicht_sichtbar'), isEmpty);
    expect(suche.index.suche('Nicht durchsuchen'), isEmpty);
    expect(suche.index.suche('Beispielinhalt').length, 1);
  });
}
