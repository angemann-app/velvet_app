import 'dart:io';

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

  test('Ein Sprachwechsel ändert keine gespeicherten Daten außer der Sprachwahl', () async {
    SharedPreferences.setMockInitialValues({
      'completed_lessons': ['neuro_1'],
      'velvet_yes_no_maybe_answers': '{"item_64":"yes"}',
      'cbt_journal_entries': ['{"id":"1","cognitive_distortions":["Leistungsdruck"]}'],
    });
    final prefs = await SharedPreferences.getInstance();
    final vorher = {for (final k in prefs.getKeys()) k: prefs.get(k)};
    await Sprache.setzen('en');
    await DataService.neuLaden();
    await Sprache.setzen('de');
    await DataService.neuLaden();
    final nachher = {for (final k in prefs.getKeys()) if (k != 'app_language') k: prefs.get(k)};
    expect(nachher, vorher);
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

  test('Jede beschriftete Grafik hat eine englische Fassung', () {
    final grafiken = Directory('assets/images')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .where((n) => n.startsWith('diagram_') && !n.endsWith('_en.svg'));
    for (final name in grafiken) {
      expect(File('assets/images/${name.replaceFirst('.svg', '_en.svg')}').existsSync(), isTrue, reason: name);
    }
    Sprache.geraetFuerTest = 'en';
    expect(Sprache.bild('assets/images/diagram_wellen.svg'), 'assets/images/diagram_wellen_en.svg');
    expect(Sprache.bild('assets/images/cover_01.svg'), 'assets/images/cover_01.svg');
    Sprache.geraetFuerTest = 'de';
    expect(Sprache.bild('assets/images/diagram_wellen.svg'), 'assets/images/diagram_wellen.svg');
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
