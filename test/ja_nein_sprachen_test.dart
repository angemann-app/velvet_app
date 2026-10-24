import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/listen_uebersetzung.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Sprache.laden();
  });
  tearDown(() async {
    Sprache.geraetFuerTest = 'de';
    await DataService.neuLaden();
  });

  Future<void> spicy(bool an) async {
    SharedPreferences.setMockInitialValues({'spicy_mode': an});
    StorageService.resetForTest();
    await StorageService.init();
  }

  test('Englisch: jede Kategorie und jede Frage ist übersetzt, ids und Verknüpfungen bleiben', () async {
    await spicy(true); // damit auch die Spicy-Fragen geprüft werden
    Sprache.geraetFuerTest = 'en';
    await DataService.neuLaden();
    final en = ListenUebersetzung.kategorien;
    expect(en.length, velvetYesNoMaybeCategories.length);
    for (var c = 0; c < en.length; c++) {
      final de = velvetYesNoMaybeCategories[c];
      expect(en[c].id, de.id);
      // „Spicy“ heißt in beiden Sprachen so.
      if (de.id != 'spicy') expect(en[c].title, isNot(de.title), reason: 'Kategorie ${de.id} nicht übersetzt');
      expect(en[c].description, isNot(de.description), reason: 'Beschreibung ${de.id} nicht übersetzt');
      expect(en[c].items.map((i) => i.id), de.items.map((i) => i.id));
      for (var i = 0; i < de.items.length; i++) {
        expect(en[c].items[i].text, isNot(de.items[i].text), reason: '${de.items[i].id} nicht übersetzt');
        expect(en[c].items[i].explanation, isNot(de.items[i].explanation), reason: '${de.items[i].id} Erklärung');
        expect(en[c].items[i].lessonId, de.items[i].lessonId);
        expect(en[c].items[i].image, de.items[i].image);
      }
    }
    final porno = ListenUebersetzung.eintraege.firstWhere((i) => i.id == 'item_64');
    final club = ListenUebersetzung.eintraege.firstWhere((i) => i.id == 'item_65');
    expect(porno.text, 'Watching porn together');
    expect(club.text, contains("swingers' club"));
    expect(club.explanation, contains('nobody joins in'));
    // Verknüpfte Lektionen gibt es auch auf Englisch.
    for (final i in ListenUebersetzung.eintraege.where((i) => i.lessonId != null)) {
      expect(DataService.getLessonById(i.lessonId!), isNotNull, reason: '${i.id} → ${i.lessonId}');
    }
    expect(YesNoMaybeVote.yes.label, 'Yes');
    expect(t.yesNoMaybeNoMatchesYet, 'No matches yet');
  });

  test('Deutsch: Originaltexte, auch die neuen Fragen', () async {
    await spicy(false);
    Sprache.geraetFuerTest = 'de';
    await DataService.neuLaden();
    final porno = ListenUebersetzung.eintraege.firstWhere((i) => i.id == 'item_64');
    expect(porno.text, 'Gemeinsam einen Porno schauen');
    expect(YesNoMaybeVote.yes.label, 'Ja');
    expect(ListenUebersetzung.eintraege.length, 65);
  });
}
