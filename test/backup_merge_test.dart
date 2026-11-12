import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/traum_eintrag.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';
import 'package:velvetpulse/models/bedien_daten.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/models/gemeinsam_antwort.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/services/realitaetscheck.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String checkIn(String date, int mood) => jsonEncode({
        'date': date,
        'mood': mood,
        'timestamp': '${date}T08:00:00.000',
      });

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      StorageService.keyYesNoMaybe: jsonEncode({'a': 'yes', 'c': 'no'}),
      'daily_check_ins': [checkIn('2026-10-20', 3), checkIn('2026-10-22', 4)],
    });
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    await NostrService().reloadKeysFromPrefs();
  });

  test(
      'Gemeinsamer Rückblick bleibt mit Gefühl und Freigabe im bestehenden Backup-Feld erhalten',
      () async {
    final id = 'ge_n_${'a' * 32}';
    final antwort = const GemeinsamAntwort('Ein ruhiger Moment',
            gefuehl: 'ruhig', geteilt: true)
        .speichern();
    await StorageService.saveReflectionAnswer(id, antwort);
    final export = StorageService.exportAllUserData();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reflection_answers');
    await StorageService.importBackup(BackupCodec.validate(export));
    final restored =
        GemeinsamAntwort.lesen(StorageService.getReflectionAnswer(id));
    expect(restored.text, 'Ein ruhiger Moment');
    expect(restored.gefuehl, 'ruhig');
    expect(restored.geteilt, isTrue);
  });

  test('Bedienung: parallele lokale Änderungen bleiben getrennt erhalten',
      () async {
    final zeit = DateTime.utc(2026, 11, 2);
    await Future.wait([
      StorageService.saveBedienDaten(
          BedienDaten(
              weg: WegStand(lektion: 'l1', schritt: 1, geaendert: zeit)),
          backup: false),
      StorageService.saveBedienDaten(
          BedienDaten(
              wiedergabe: WiedergabeMerker(
                  plan: null,
                  index: 0,
                  position: Duration.zero,
                  geaendert: zeit)),
          backup: false),
    ]);
    expect(StorageService.getBedienDaten().weg!.schritt, 1);
    expect(StorageService.getBedienDaten().wiedergabe!.geloescht, isTrue);
    expect(StorageService.exportAllUserData()['bedienung'],
        StorageService.getBedienDaten().toJson());
  });

  test('Eure erste Woche: Stand steht in der Sicherung, jüngere Änderung gewinnt, Sicherung ohne Feld bleibt importierbar',
      () async {
    final t1 = DateTime.utc(2026, 11, 12, 9);
    await StorageService.saveBedienDaten(
        BedienDaten(
            ersteWoche: ErsteWocheStand(
                beginn: t1,
                schritte: const {1: ErsteWocheStand.getan},
                geaendert: t1)),
        backup: false);
    final export = StorageService.exportAllUserData();
    expect((export['bedienung'] as Map)['ersteWoche'], isNotNull);
    expect(StorageService.getBedienDaten().ersteWoche!.schritte, {1: 'getan'});

    // Jüngere Änderung auf diesem Gerät gewinnt gegen die ältere Sicherung.
    await StorageService.saveBedienDaten(
        BedienDaten(
            ersteWoche: ErsteWocheStand(
                beginn: t1,
                schritte: const {
                  1: ErsteWocheStand.getan,
                  2: ErsteWocheStand.uebersprungen
                },
                ausgeblendet: true,
                geaendert: t1.add(const Duration(hours: 1)))),
        backup: false);
    await StorageService.importBackup(BackupCodec.validate(export));
    final danach = StorageService.getBedienDaten().ersteWoche!;
    expect(danach.schritte.length, 2);
    expect(danach.ausgeblendet, isTrue);

    // Gleichstand der Zeit: eigene Änderung wird trotzdem nicht verworfen.
    await StorageService.saveBedienDaten(
        BedienDaten(
            ersteWoche: ErsteWocheStand(
                beginn: t1,
                schritte: const {3: ErsteWocheStand.getan},
                geaendert: t1.add(const Duration(hours: 1)))),
        backup: false);
    expect(StorageService.getBedienDaten().ersteWoche!.schritte, {3: 'getan'});
  });

  test('Eure erste Woche: Sicherung ohne das Feld und kaputte Werte', () async {
    final ohne = StorageService.exportAllUserData();
    (ohne['bedienung'] as Map).remove('ersteWoche');
    await StorageService.importBackup(BackupCodec.validate(ohne));
    expect(StorageService.getBedienDaten().ersteWoche, isNull);
    expect(BedienDaten.fromJson({'schema': 1}).ersteWoche, isNull);
    // Unbekannte Schritte werden übersprungen, ein kaputtes Feld bleibt ein Fehler.
    final tolerant = BedienDaten.fromJson({
      'schema': 1,
      'ersteWoche': {
        'schritte': {'9': 'getan', '1': 'getan'},
        'geaendert': '2026-11-12T09:00:00Z'
      }
    });
    expect(tolerant.ersteWoche!.schritte, {1: 'getan'});
    expect(
        () => BedienDaten.fromJson({
              'schema': 1,
              'ersteWoche': {
                'schritte': 'kaputt',
                'geaendert': '2026-11-12T09:00:00Z'
              }
            }),
        throwsFormatException);
  });
  test('Bedienung: zurückgestellte Uhr verliert keine bewusste lokale Änderung',
      () async {
    final zeit = DateTime.utc(2026, 11, 2);
    await StorageService.saveBedienDaten(
        BedienDaten(weg: WegStand(lektion: 'l1', schritt: 1, geaendert: zeit)),
        backup: false);
    await StorageService.saveBedienDaten(
        BedienDaten(
            weg: WegStand(
                lektion: 'l1',
                schritt: 2,
                geaendert: zeit.subtract(const Duration(days: 1)))),
        backup: false);
    expect(StorageService.getBedienDaten().weg!.schritt, 2);
    expect(
        StorageService.getBedienDaten().weg!.geaendert.isAfter(zeit), isTrue);
  });

  test(
      'Bedienung: Export, Wiederherstellung und Löschmarkierung gegen alte Sicherung',
      () async {
    final zeit = DateTime.utc(2026, 11, 2);
    final plan = WiedergabePlan(
        art: WiedergabeArt.lektion,
        id: 'l1',
        sprache: 'de',
        spicy: false,
        titel: 'Nur flüchtig',
        abschnitte: const [
          WiedergabeAbschnitt(
              id: 'l1',
              art: AbschnittArt.sprache,
              dauer: Duration(minutes: 2),
              pfad: 'audio/l1.opus',
              text: 'Nicht sichern')
        ]);
    await StorageService.saveBedienDaten(
        BedienDaten(
            wiedergabe: WiedergabeMerker(
                plan: plan,
                index: 0,
                position: const Duration(seconds: 17),
                geaendert: zeit)),
        backup: false);
    final export = StorageService.exportAllUserData();
    expect(jsonEncode(export['bedienung']), isNot(contains('Nicht sichern')));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bedienung');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getBedienDaten().wiedergabe!.position.inSeconds, 17);
    await StorageService.saveBedienDaten(
        BedienDaten(
            wiedergabe: WiedergabeMerker(
                plan: null,
                index: 0,
                position: Duration.zero,
                geaendert: zeit.add(const Duration(seconds: 1)))),
        backup: false);
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getBedienDaten().wiedergabe!.geloescht, isTrue);
    export.remove('bedienung');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getBedienDaten().wiedergabe!.geloescht, isTrue);
  });

  test(
      'Bedienung: beschädigte Sicherung wird vor anderen Schreibvorgängen abgewiesen',
      () async {
    final vorher = StorageService.exportAllUserData();
    final defekt = {
      ...vorher,
      'completedLessons': ['neu'],
      'bedienung': {'schema': 999}
    };
    await expectLater(StorageService.importBackup(BackupCodec.validate(defekt)),
        throwsA(isA<BackupException>()));
    final nachher = StorageService.exportAllUserData()..remove('exportedAt');
    vorher.remove('exportedAt');
    expect(nachher, vorher);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bedienung', 'kaputter Bestand');
    await expectLater(
        StorageService.saveBedienDaten(
            BedienDaten(
                weg: WegStand(
                    lektion: 'l1',
                    schritt: 0,
                    geaendert: DateTime.utc(2026, 11, 2))),
            backup: false),
        throwsA(isA<FormatException>()));
    expect(prefs.getString('bedienung'), 'kaputter Bestand');
  });

  test(
      'Traumpraxis: beschädigte lokale Daten werden beim Speichern nicht überschrieben',
      () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('traumpraxis', 'kaputter Bestand');
    await expectLater(
        StorageService.savePraxisEintrag(PraxisEintrag(
            id: 'neu',
            art: 'zeichen',
            geaendert: DateTime(2026, 11, 1),
            text: 'Eine Tür')),
        throwsA(isA<FormatException>()));
    expect(prefs.getString('traumpraxis'), 'kaputter Bestand');
  });

  test(
      'Traumpraxis: doppelte IDs werden vor der Anzeige deterministisch zusammengeführt',
      () {
    final first = PraxisEintrag(
        id: 'a', art: 'zeichen', geaendert: DateTime(2026, 10, 1), text: 'Alt');
    final second = PraxisEintrag(
        id: 'a', art: 'zeichen', geaendert: DateTime(2026, 11, 1), text: 'Neu');
    final data = TraumpraxisDaten.fromJson({
      'version': 1,
      'eintraege': [first.toJson(), second.toJson()]
    });
    expect(data.zeichen.single.text, 'Neu');
    expect(() => PraxisEintrag.fromJson({...first.toJson(), 'text': ''}),
        throwsFormatException);
  });

  test(
      'Realitätscheck-Einstellungen sind in der Sicherung und werden wiederhergestellt',
      () async {
    await StorageService.saveRealitaetschecks(
        const RealitaetscheckEinstellungen(
      aktiv: true,
      vonStunde: 10,
      bisStunde: 20,
      anzahlProTag: 4,
    ));
    final export = StorageService.exportAllUserData();
    expect(export['realitaetschecks'], {
      'aktiv': true,
      'vonStunde': 10,
      'bisStunde': 20,
      'anzahlProTag': 4,
    });

    await StorageService.saveRealitaetschecks(
        const RealitaetscheckEinstellungen(aktiv: false));
    expect(StorageService.getRealitaetschecks().aktiv, isFalse);

    await StorageService.importBackup(BackupCodec.validate(export));
    final restored = StorageService.getRealitaetschecks();
    expect(restored.aktiv, isTrue);
    expect(restored.vonStunde, 10);
    expect(restored.bisStunde, 20);
    expect(restored.anzahlProTag, 4);
  });

  test(
      'Traumpraxis: Export, Wiederherstellung und älterer Stand überschreibt nichts',
      () async {
    final a = PraxisEintrag(
        id: 'zeichen-a',
        art: 'zeichen',
        geaendert: DateTime(2026, 11, 1),
        text: 'Eine zweite Tür');
    await StorageService.savePraxisEintrag(a);
    final export = StorageService.exportAllUserData();
    expect((export['traumpraxis'] as Map)['version'], 1);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('traumpraxis');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getTraumpraxis().zeichen.single.text, a.text);
    await StorageService.savePraxisEintrag(a.mitZeit(DateTime(2026, 11, 2)));
    final current = StorageService.getTraumpraxis().toJson();
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getTraumpraxis().toJson(), current);
    export.remove('traumpraxis');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getTraumpraxis().toJson(), current);
  });

  test(
      'Traumpraxis: Löschung überlebt alte Backups; gleiche Zeit bevorzugt Löschung',
      () async {
    final date = DateTime(2026, 11, 1);
    await StorageService.savePraxisEintrag(PraxisEintrag(
        id: 'a', art: 'zeichen', geaendert: date, text: 'Privates Zeichen'));
    final old = StorageService.exportAllUserData();
    await StorageService.savePraxisEintrag(PraxisEintrag(
        id: 'a', art: 'zeichen', geaendert: date, geloescht: true));
    await StorageService.importBackup(BackupCodec.validate(old));
    expect(StorageService.getTraumpraxis().zeichen, isEmpty);
    expect(jsonEncode(StorageService.getTraumpraxis().toJson()),
        isNot(contains('Privates Zeichen')));
    final alive = TraumpraxisDaten(
        [PraxisEintrag(id: 'b', art: 'zeichen', geaendert: date, text: 'Alt')]);
    final deleted = TraumpraxisDaten([
      PraxisEintrag(id: 'b', art: 'zeichen', geaendert: date, geloescht: true)
    ]);
    expect(alive.zusammen(deleted).toJson(), deleted.zusammen(alive).toJson());
    expect(deleted.zusammen(alive).zeichen, isEmpty);
  });

  test(
      'Traumpraxis: offene Fragen und mehrere Tage bleiben beim Merge erhalten',
      () async {
    final day1 = PraxisEintrag(
        id: '2026-10-31',
        art: 'tag',
        geaendert: DateTime(2026, 11, 1),
        lust: 0,
        hoehepunkt: false);
    final day2 = PraxisEintrag(
        id: '2026-11-01',
        art: 'tag',
        geaendert: DateTime(2026, 11, 1),
        schlaf: 4,
        sinnlich: true);
    await StorageService.savePraxisEintrag(day1);
    final export = StorageService.exportAllUserData()
      ..['traumpraxis'] = TraumpraxisDaten([day2]).toJson();
    await StorageService.importBackup(BackupCodec.validate(export));
    final days = StorageService.getTraumpraxis().tage;
    expect(days.map((e) => e.id), ['2026-11-01', '2026-10-31']);
    expect(days.first.lust, isNull);
    expect(days.first.hoehepunkt, isNull);
    expect(days.last.lust, 0);
    expect(days.last.hoehepunkt, isFalse);
  });

  test('Traumpraxis: beschädigtes Backup schreibt auch andere Felder nicht',
      () async {
    final before = StorageService.exportAllUserData();
    final bad = {
      ...before,
      'completedLessons': ['unbeabsichtigt'],
      'traumpraxis': {
        'version': 1,
        'eintraege': [
          {
            'id': '2026-11-01',
            'art': 'tag',
            'geaendert': '2026-11-01',
            'lust': 8
          }
        ]
      }
    };
    await expectLater(StorageService.importBackup(BackupCodec.validate(bad)),
        throwsA(isA<BackupException>()));
    expect(StorageService.getCompletedLessons(),
        isNot(contains('unbeabsichtigt')));
    expect(StorageService.getTraumpraxis().tage, isEmpty);
  });

  test(
      'Lautsprecher-Einstellungen sind in der Sicherung und werden wiederhergestellt',
      () async {
    expect(StorageService.getFrageVorLautsprecher(), isTrue);
    expect(StorageService.getPausiereBeiKopfhoererGetrennt(), isTrue);

    await StorageService.setFrageVorLautsprecher(false);
    await StorageService.setPausiereBeiKopfhoererGetrennt(false);

    final export = StorageService.exportAllUserData();
    expect(export['frageVorLautsprecher'], isFalse);
    expect(export['pausiereBeiKopfhoererGetrennt'], isFalse);

    await StorageService.setFrageVorLautsprecher(true);
    await StorageService.setPausiereBeiKopfhoererGetrennt(true);

    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getFrageVorLautsprecher(), isFalse);
    expect(StorageService.getPausiereBeiKopfhoererGetrennt(), isFalse);
  });

  test(
      'Kursfilter wird gemerkt (auch „Alle Kurse“), steht in der Sicherung und die eigene Wahl gewinnt',
      () async {
    expect(StorageService.getKursFilter(), isNull,
        reason: 'noch nie gewählt: Profil darf vorschlagen');

    await StorageService.setKursFilter('all');
    expect(StorageService.getKursFilter(), 'all',
        reason: '„Alle Kurse“ ist eine Wahl und bleibt');
    await StorageService.setKursFilter('unsinn');
    expect(StorageService.getKursFilter(), 'all');

    final export = StorageService.exportAllUserData();
    expect(export['kursFilter'], 'all');

    await StorageService.setKursFilter('men');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getKursFilter(), 'men',
        reason: 'die Wahl auf diesem Gerät gewinnt');
  });
  test(
      'Körper-Voreinstellung: Standard leer, Wahl steht in der Sicherung, eigene Wahl gewinnt, fehlende wird übernommen',
      () async {
    expect(StorageService.getKoerperVoreinstellung(), isNull);
    expect(StorageService.koerperVorschlag(), 'vulva',
        reason: 'ohne Wahl und ohne Mann: wie bisher vulva');

    await StorageService.setKoerperVoreinstellung('unsinn');
    expect(StorageService.getKoerperVoreinstellung(), isNull,
        reason: 'unbekannte Werte werden nicht gespeichert');

    await StorageService.setKoerperVoreinstellung('penis');
    expect(StorageService.getKoerperVoreinstellung(), 'penis');
    expect(StorageService.koerperVorschlag(), 'penis');

    final export = StorageService.exportAllUserData();
    expect(export['koerperVoreinstellung'], 'penis');

    // Anderer Wert auf diesem Gerät: die eigene Wahl gewinnt.
    await StorageService.setKoerperVoreinstellung('vulva');
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getKoerperVoreinstellung(), 'vulva');

    // Nicht gesetzt: die Sicherung füllt auf.
    await StorageService.setKoerperVoreinstellung(null);
    expect(StorageService.getKoerperVoreinstellung(), isNull);
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getKoerperVoreinstellung(), 'penis');

    // „Beides“ bleibt gespeichert, der Vorschlag für Einzelwahl fällt auf das Geschlecht zurück.
    await StorageService.setKoerperVoreinstellung('beides');
    expect(StorageService.getKoerperVoreinstellung(), 'beides');
    expect(StorageService.koerperVorschlag(), 'vulva');
  });

  test(
      'Audio-Bereich auf der Startseite: standardmäßig offen, Wahl wird gemerkt, steht in der Sicherung, eigene Wahl gewinnt',
      () async {
    expect(StorageService.getAudioBereichOffen(), isTrue,
        reason: 'beim ersten Start offen');
    await StorageService.setAudioBereichOffen(false);
    expect(StorageService.getAudioBereichOffen(), isFalse);

    final export = StorageService.exportAllUserData();
    expect(export['audioBereichOffen'], false);

    await StorageService.setAudioBereichOffen(true);
    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getAudioBereichOffen(), isTrue,
        reason: 'die Wahl auf diesem Gerät gewinnt');
  });

  test('Hallo-Merker ist in der Sicherung und wird wiederhergestellt',
      () async {
    expect(StorageService.getHalloGesendetAm(), isNull);

    await StorageService.setHalloGesendetAm('2026-10-28T09:30:00.000');
    final export = StorageService.exportAllUserData();
    expect(export['halloGesendetAm'], '2026-10-28T09:30:00.000');

    await StorageService.setHalloGesendetAm(null);
    expect(StorageService.getHalloGesendetAm(), isNull);

    await StorageService.importBackup(BackupCodec.validate(export));
    expect(StorageService.getHalloGesendetAm(), '2026-10-28T09:30:00.000');
  });

  test('Die Ja/Nein-Liste ist in der Sicherung enthalten', () {
    final export = StorageService.exportAllUserData();
    expect(jsonDecode(export['yesNoMaybe'] as String), {'a': 'yes', 'c': 'no'});
  });

  test('Einspielen führt Check-ins und Ja/Nein-Antworten zusammen', () async {
    final backup = StorageService.exportAllUserData()
      ..['yesNoMaybe'] = jsonEncode({'a': 'maybe', 'b': 'no'})
      ..['dailyCheckIns'] = [
        checkIn('2026-10-21', 2),
        checkIn('2026-10-22', 5)
      ];
    await StorageService.importBackup(BackupCodec.validate(backup));

    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString(StorageService.keyYesNoMaybe)!),
        {'a': 'maybe', 'b': 'no', 'c': 'no'});
    final dates = [
      for (final raw in prefs.getStringList('daily_check_ins')!)
        (jsonDecode(raw) as Map)['date'],
    ];
    expect(dates, ['2026-10-22', '2026-10-21', '2026-10-20']);
    // Am gleichen Tag gilt die Sicherung.
    expect(
        (jsonDecode(prefs.getStringList('daily_check_ins')!.first)
            as Map)['mood'],
        5);
  });

  test(
      'Beschädigte Felder: verständliche Meldung, und es wird nichts verändert',
      () async {
    final prefs = await SharedPreferences.getInstance();
    final vorher = {for (final k in prefs.getKeys()) k: prefs.get(k)};
    for (final (feld, wert) in [
      ('yesNoMaybe', '{kaputt'),
      ('yesNoMaybe', '["keine", "Zuordnung"]'),
      ('yesNoMaybe', '{"a": 5}'),
      ('reflectionAnswers', 'nicht json'),
    ]) {
      final backup = StorageService.exportAllUserData()..[feld] = wert;
      await expectLater(
        StorageService.importBackup(BackupCodec.validate(backup)),
        throwsA(isA<BackupException>()
            .having((e) => e.message, 'Meldung', contains('beschädigt'))),
        reason: '$feld = $wert',
      );
      expect({for (final k in prefs.getKeys()) k: prefs.get(k)}, vorher,
          reason: '$feld = $wert');
    }
  });

  test(
      'Abgeschnittene Datei wird abgelehnt, eine Sicherung ohne Daten ändert nichts Wesentliches',
      () async {
    final voll = jsonEncode(StorageService.exportAllUserData());
    expect(() => BackupCodec.validate(voll.substring(0, voll.length ~/ 2)),
        throwsA(isA<BackupException>()));

    final prefs = await SharedPreferences.getInstance();
    final yesNoVorher = prefs.getString(StorageService.keyYesNoMaybe);
    await StorageService.importBackup(
        BackupCodec.validate({'app': 'VelvetPulse', 'schema': 2}));
    expect(prefs.getString(StorageService.keyYesNoMaybe), yesNoVorher);
    expect(prefs.getStringList('daily_check_ins'), hasLength(2));
  });

  test('Beschädigter Passwort-Block: Fehlermeldung statt Absturz', () async {
    for (final block in [
      <String, dynamic>{'v': 1, 'kdf': 'pbkdf2-sha256', 'iter': 210000},
      <String, dynamic>{
        'v': 1,
        'kdf': 'pbkdf2-sha256',
        'iter': 210000,
        'salt': '!!',
        'nonce': 'x',
        'ct': 'y'
      },
      <String, dynamic>{'v': 2},
    ]) {
      await expectLater(BackupCodec.decryptSecrets(block, 'egal'),
          throwsA(isA<BackupException>()));
    }
  });

  test('Traumtagebuch und Lust-Fortschritt sind in der Sicherung enthalten',
      () async {
    final eintrag = TraumEintrag(
      id: 'a',
      zeit: DateTime(2026, 10, 27, 7),
      text: 'Wasser',
      marken: {'erinnert'},
    );
    await StorageService.saveTraumEintrag(eintrag);
    await StorageService.lustAbendGehoert(1);
    await StorageService.lustAbendGehoert(1);

    final export = StorageService.exportAllUserData();
    expect(export['traumTagebuch'], [eintrag.toJson()]);
    expect(jsonDecode(export['lustFortschritt'] as String), {'1': 2});
  });

  test('Einspielen führt Traumtagebuch und Lust-Fortschritt zusammen',
      () async {
    final a = TraumEintrag(
        id: 'a',
        zeit: DateTime(2026, 10, 27, 7),
        text: 'lokal',
        marken: {'erinnert'});
    await StorageService.saveTraumEintrag(a);
    await StorageService.saveTraumEintrag(
        TraumEintrag(id: 'b', zeit: DateTime(2026, 10, 26, 7)));
    await StorageService.lustAbendGehoert(1);
    await StorageService.lustAbendGehoert(1);

    final backup = StorageService.exportAllUserData()
      ..['traumTagebuch'] = [
        a.mit(text: 'aus Sicherung').toJson(),
        TraumEintrag(id: 'c', zeit: DateTime(2026, 10, 25, 7)).toJson(),
      ]
      ..['lustFortschritt'] = jsonEncode({'1': 1, '2': 3});
    expect(await StorageService.importUserData(backup), isTrue);

    final eintraege = {
      for (final e in StorageService.getTraumEintraege()) e.id: e
    };
    expect(eintraege.keys, containsAll(['a', 'b', 'c']));
    expect(eintraege['a']!.text, 'aus Sicherung');
    expect(StorageService.getLustFortschritt(), {1: 2, 2: 3});
  });

  test(
      'Nächtliches Wecken ist in der Sicherung enthalten und wird beim Einspielen zusammengeführt',
      () async {
    final z1 = DateTime(2026, 10, 25, 4, 0);
    final z2 = DateTime(2026, 10, 27, 4, 15);
    await StorageService.saveNaechtlichesWecken(z1);

    final export = StorageService.exportAllUserData();
    expect(export['naechtlichesWecken'], [z1.toIso8601String()]);

    final backup = StorageService.exportAllUserData()
      ..['naechtlichesWecken'] = [z2.toIso8601String()];
    expect(await StorageService.importUserData(backup), isTrue);

    final zusammengefuehrt = StorageService.getNaechtlichesWecken();
    expect(zusammengefuehrt, [z2, z1]);
  });
}
