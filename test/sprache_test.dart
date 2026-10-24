import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/listen_uebersetzung.dart';
import 'package:velvetpulse/services/sprache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Sprache.laden();
  });

  tearDown(() => Sprache.geraetFuerTest = 'de');

  test('Deutsches Gerät: Deutsch, alle anderen: Englisch', () {
    Sprache.geraetFuerTest = 'de';
    expect(Sprache.code, 'de');
    for (final geraet in ['en', 'fr', 'tr']) {
      Sprache.geraetFuerTest = geraet;
      expect(Sprache.code, 'en', reason: geraet);
    }
  });

  test('Die Wahl im Profil schlägt die Gerätesprache und bleibt gespeichert', () async {
    Sprache.geraetFuerTest = 'en';
    await Sprache.setzen('de');
    expect(Sprache.code, 'de');
    await Sprache.laden();
    expect(Sprache.wahl.value, 'de');
    await Sprache.setzen('auto');
    expect(Sprache.code, 'en');
  });

  test('Inhalte, Listen und Bausteine kommen in der gewählten Sprache', () async {
    Sprache.geraetFuerTest = 'en';
    var db = await DataService.neuLaden();
    expect(db.courses.first.title, '1. Understanding Mind and Body');
    expect(ListenUebersetzung.kategorien.first.title, isNot(contains('ä')));
    expect(ListenUebersetzung.fantasien.length, greaterThan(0));
    final paar = await PaarAbendDaten.laden();
    expect(paar.dauerMs, isEmpty, reason: 'Längen der deutschen Aufnahmen gelten nicht für Englisch');

    Sprache.geraetFuerTest = 'de';
    db = await DataService.neuLaden();
    expect(db.courses.first.title, '1. Kopf und Körper verstehen');
    expect(ListenUebersetzung.kategorien, same(ListenUebersetzung.kategorien));
  });
}
