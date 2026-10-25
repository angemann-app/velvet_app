// Spicy-Modus: standardmäßig aus, und ohne ihn nirgends wählbar.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/content_models.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';
import 'package:velvetpulse/services/listen_uebersetzung.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  Future<void> starten(Map<String, Object> werte) async {
    SharedPreferences.setMockInitialValues(werte);
    StorageService.resetForTest();
    await StorageService.init();
  }

  test('Standardmäßig aus, Ein- und Ausschalten wird gespeichert', () async {
    await starten({});
    expect(StorageService.spicyMode(), isFalse);
    await StorageService.setSpicyMode(true);
    expect(StorageService.spicyMode(), isTrue);
    await StorageService.setSpicyMode(false);
    expect(StorageService.spicyMode(), isFalse);
  });

  test('Die Einrichtung bietet Spicy nur bei eingeschaltetem Modus an', () {
    expect(waehlbareTiefen(spicyErlaubt: false), [PaarTiefe.bekleidet, PaarTiefe.haut, PaarTiefe.intim]);
    expect(waehlbareTiefen(spicyErlaubt: true), PaarTiefe.values);
  });

  test('Gespeichertes Spicy wird zu Intim, solange der Modus aus ist', () {
    expect(tiefeAusName('spicy', spicyErlaubt: false), PaarTiefe.intim);
    expect(tiefeAusName('sehrSpicy', spicyErlaubt: false), PaarTiefe.intim);
    expect(tiefeAusName('spicy', spicyErlaubt: true), PaarTiefe.spicy);
    expect(tiefeAusName('sehrSpicy', spicyErlaubt: true), PaarTiefe.sehrSpicy);
    expect(tiefeAusName('haut', spicyErlaubt: false), PaarTiefe.haut);
    expect(tiefeAusName('unbekannt', spicyErlaubt: true), PaarTiefe.bekleidet);
    expect(tiefeAusName(null, spicyErlaubt: true), PaarTiefe.bekleidet);
  });

  test('Spicy-Bausteine kommen nur bei Spicy vor und ersetzen dort die Varianten ihrer Phase', () {
    final bausteine = [
      for (final f in ['assets/data/selbst_reise.json', 'assets/data/paar_abend.json'])
        ...(jsonDecode(File(f).readAsStringSync())['bausteine'] as List).map((b) => PaarBaustein.fromJson(b)),
    ];
    for (final phase in bausteine.map((b) => b.phase).toSet()) {
      for (final tiefe in PaarTiefe.values) {
        final fremd = {'spicy', 'sehrSpicy'}..remove(tiefe.name);
        expect(bausteineDerPhase(bausteine, phase, tiefe).any((b) => fremd.contains(b.tiefe)), isFalse,
            reason: '$phase bei $tiefe');
      }
    }
    for (final tiefe in [PaarTiefe.spicy, PaarTiefe.sehrSpicy]) {
      final ankommen = bausteineDerPhase(bausteine, 'ankommen', tiefe);
      expect(ankommen, isNotEmpty);
      expect(ankommen.every((b) => b.tiefe == tiefe.name), isTrue);
      // Erinnerungen und Berührungen mischen.
      final erinnerung = bausteineDerPhase(bausteine, 'erinnerung', tiefe);
      expect(erinnerung.any((b) => b.tiefe == tiefe.name), isTrue);
      expect(erinnerung.any((b) => b.tiefe == null), isTrue);
    }
    // Jeder Spicy-Baustein hat sein Gegenstück in Sehr spicy (…_s1 ↔ …_x1).
    final ids = bausteine.map((b) => b.id).toSet();
    for (final b in bausteine.where((b) => b.tiefe == 'spicy')) {
      final basis = b.id.substring(0, b.id.lastIndexOf('_'));
      final nr = b.id.substring(b.id.lastIndexOf('_') + 1).replaceFirst('s', '');
      expect(ids, contains('${basis}_x$nr'), reason: b.id);
    }
    // Phasen ohne Spicy-Variante (Atem) bleiben wie sie sind.
    expect(bausteineDerPhase(bausteine, 'atem', PaarTiefe.spicy), isNotEmpty);
  });

  test('Spicy-Kurse und Spicy-Fragen nur bei eingeschaltetem Modus', () async {
    final db = VelvetDatabase.fromJson(jsonDecode(File('assets/data/velvet_content.json').readAsStringSync()));
    final spicyKurse = db.alleKurse.where((c) => c.spicy).map((c) => c.id).toSet();
    expect(spicyKurse, containsAll(['course_spicy_solo', 'course_spicy_duo']));

    await starten({});
    expect(db.courses.map((c) => c.id).toSet().intersection(spicyKurse), isEmpty);
    expect(ListenUebersetzung.kategorien.any((k) => k.spicy), isFalse);
    expect(ListenUebersetzung.eintraege.any((i) => i.categoryId == 'spicy'), isFalse);

    await StorageService.setSpicyMode(true);
    expect(db.courses.map((c) => c.id), containsAll(spicyKurse));
    expect(ListenUebersetzung.kategorien.any((k) => k.id == 'spicy'), isTrue);
  });

  test('Spicy-Lektionen in normalen Kursen nur bei eingeschaltetem Modus', () async {
    final db = VelvetDatabase.fromJson(jsonDecode(File('assets/data/velvet_content.json').readAsStringSync()));
    Course alltag() => db.courses.firstWhere((c) => c.id == 'course_everyday_eros');
    await starten({});
    expect(alltag().lessons.map((l) => l.id), isNot(contains('alltag_6')));
    expect(alltag().lessons, hasLength(7));
    await StorageService.setSpicyMode(true);
    expect(alltag().lessons, hasLength(11));
    expect(alltag().lessons.where((l) => l.spicy).map((l) => l.id), ['alltag_6', 'alltag_7', 'alltag_8', 'alltag_10']);
  });

  test('Spicy-Fragen verweisen nur auf Lektionen, die es gibt', () {
    final db = VelvetDatabase.fromJson(jsonDecode(File('assets/data/velvet_content.json').readAsStringSync()));
    final lektionen = {for (final c in db.alleKurse) ...c.lessons.map((l) => l.id)};
    for (final k in velvetYesNoMaybeCategories) {
      for (final i in k.items) {
        if (i.lessonId != null) expect(lektionen, contains(i.lessonId), reason: i.id);
      }
    }
  });

  test('Der Modus wird nicht in die Sicherung geschrieben', () {
    final quelle = File('lib/services/storage_service.dart').readAsStringSync();
    final start = quelle.indexOf('exportAllUserData()');
    expect(start, isNot(-1));
    final export = quelle.substring(start, quelle.indexOf('exportWithSecrets'));
    expect(export.toLowerCase().contains('spicy'), isFalse);
  });
}
