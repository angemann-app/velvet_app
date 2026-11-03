import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/content_models.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/services/wiedergabe_plaene.dart';

WiedergabePlan lektion(Lesson l, {String sprache = 'de', String? pfad}) =>
    WiedergabePlan(
        art: WiedergabeArt.lektion,
        id: l.id,
        sprache: sprache,
        spicy: false,
        abschnitte: [
          WiedergabeAbschnitt(
              id: l.id,
              art: AbschnittArt.sprache,
              dauer: const Duration(minutes: 1),
              pfad: pfad ?? 'audio/${l.id}.opus',
              aufnahmeEnde: true)
        ]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VelvetDatabase de;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
    de = VelvetDatabase.fromJson(jsonDecode(
        await rootBundle.loadString('assets/data/velvet_content.json')));
  });
  test(
      'Merker ergänzt kanonische Texte und Titel, ohne die gespeicherte Sprache zu wechseln',
      () async {
    final l = de.courses.first.lessons.first;
    final p = await WiedergabePlaene.ergaenzen(lektion(l, sprache: 'en'));
    expect(p.sprache, 'en');
    expect(p.abschnitte.single.text, isNotEmpty);
    final en = VelvetDatabase.fromJson(jsonDecode(
        await rootBundle.loadString('translations/en/velvet_content.json')));
    expect(p.titel, en.alleKurse.first.lessons.first.title);
    expect(p.abschnitte.single.text, isNot(l.content));
  });
  test('Falsche Spicy-Markierung umgeht weder Kurs- noch Lektionsschutz',
      () async {
    final c = de.alleKurse.firstWhere((c) => c.spicy);
    await expectLater(
        WiedergabePlaene.ergaenzen(lektion(c.lessons.first)), throwsStateError);
    await StorageService.setSpicyMode(true);
    final p = await WiedergabePlaene.ergaenzen(lektion(c.lessons.first));
    expect(p.spicy, isTrue);
  });
  test(
      'Fremder Aufnahmepfad wird auch bei gültiger Lektions-ID nicht abgespielt',
      () async {
    final l = de.courses.first.lessons.first;
    await expectLater(
        WiedergabePlaene.ergaenzen(lektion(l, pfad: 'audio/fremd.opus')),
        throwsStateError);
  });
  test(
      'Zufälliger Ablauf bleibt nach Serialisierung in derselben Reihenfolge erhalten',
      () async {
    final daten = await PaarAbendDaten.laden();
    final schritte =
        daten.planen(minuten: 20, tiefe: PaarTiefe.bekleidet, stimme: 'martin');
    final p = WiedergabePlaene.schritte(
        art: WiedergabeArt.paar,
        titel: 'Vorschau',
        schritte: schritte,
        stimme: 'martin',
        familie: (_) => 'paar',
        spicy: false);
    final zurueck =
        await WiedergabePlaene.ergaenzen(WiedergabePlan.fromJson(p.toJson()));
    expect(zurueck.abschnitte.map((s) => s.id), p.abschnitte.map((s) => s.id));
    expect(zurueck.abschnitte.map((s) => s.dauer),
        p.abschnitte.map((s) => s.dauer));
    expect(
        zurueck.abschnitte
            .where((s) => s.art == AbschnittArt.sprache)
            .every((s) => s.text.isNotEmpty),
        isTrue);
  });
}
