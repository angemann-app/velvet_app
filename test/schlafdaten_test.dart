import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/schlafdaten.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/schlafdaten_dienst.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

final now = DateTime.utc(2026, 11, 3, 10);
final start = DateTime.utc(2026, 11, 2, 22);
final end = DateTime.utc(2026, 11, 3, 6);

Map<String, dynamic> session(
        {String id = 'nacht',
        String quelle = 'test.provider',
        List<Map<String, dynamic>> phasen = const []}) =>
    {
      'id': id,
      'quelle': quelle,
      'startMs': start.millisecondsSinceEpoch,
      'endeMs': end.millisecondsSinceEpoch,
      'geaendertMs': end.millisecondsSinceEpoch,
      'offsetStartMin': 60,
      'offsetEndeMin': 60,
      'phasen': phasen,
    };
Map<String, dynamic> phase(DateTime a, DateTime b, int typ) => {
      'startMs': a.millisecondsSinceEpoch,
      'endeMs': b.millisecondsSinceEpoch,
      'typ': typ
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({'spicy_mode': true});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
  });

  test('Fehlende Phasen werden nicht als acht Stunden Schlaf erfunden', () {
    final r = SchlafAufzeichnung.ausHealth(session(), now);
    expect(r.zeitfenster, const Duration(hours: 8));
    expect(r.schlafzeit, isNull);
    expect(r.tag, '2026-11-03');
    expect(SchlafAufzeichnung.fromJson(r.toJson()).toJson(), r.toJson());
  });
  test(
      'Vollständige Phasen ziehen Wachzeit ab; Lücken und unbekannte Phasen bleiben unbekannt',
      () {
    final split = start.add(const Duration(hours: 1));
    final r = SchlafAufzeichnung.ausHealth(
        session(phasen: [phase(start, split, 1), phase(split, end, 4)]), now);
    expect(r.schlafzeit, const Duration(hours: 7));
    expect(
        SchlafAufzeichnung.ausHealth(
                session(phasen: [phase(split, end, 6)]), now)
            .schlafzeit,
        isNull);
    expect(
        SchlafAufzeichnung.ausHealth(
                session(phasen: [phase(start, end, 0)]), now)
            .schlafzeit,
        isNull);
  });
  test(
      'Überlappende Phasen, laufende Sitzungen und ungültige Zeitzonen ablehnen',
      () {
    expect(
        () => SchlafAufzeichnung.ausHealth(
            session(phasen: [phase(start, end, 4), phase(start, end, 6)]), now),
        throwsFormatException);
    expect(
        () => SchlafAufzeichnung.ausHealth({
              ...session(),
              'endeMs': now.add(const Duration(hours: 1)).millisecondsSinceEpoch
            }, now),
        throwsFormatException);
    expect(
        () => SchlafAufzeichnung.ausHealth(
            {...session(), 'offsetEndeMin': 1081}, now),
        throwsFormatException);
  });
  test(
      'Aufwachdatum folgt Quellzeitzone, UTC-Dauer bleibt bei Sommerzeitwechsel erhalten',
      () {
    final a = DateTime.utc(2026, 10, 24, 22), b = DateTime.utc(2026, 10, 25, 6);
    final r = SchlafAufzeichnung.ausHealth({
      ...session(),
      'startMs': a.millisecondsSinceEpoch,
      'endeMs': b.millisecondsSinceEpoch,
      'offsetStartMin': 120,
      'offsetEndeMin': 60
    }, now);
    expect(r.tag, '2026-10-25');
    expect(r.zeitfenster.inHours, 8);
    expect(r.beginnOffsetMinuten, 120);
    final other = SchlafAufzeichnung.ausHealth({
      ...session(),
      'endeMs': DateTime.utc(2026, 11, 3, 0, 30).millisecondsSinceEpoch,
      'offsetEndeMin': -120
    }, now);
    expect(other.tag, '2026-11-02');
  });
  test(
      'Gleiche Provider-ID anderer Quellen bleibt getrennt, Wiederholung dedupliziert',
      () {
    final a = SchlafAufzeichnung.ausHealth(session(), now);
    final b =
        SchlafAufzeichnung.ausHealth(session(quelle: 'anderer.provider'), now);
    final d = SchlafDaten(aufzeichnungen: [a])
        .zusammen(SchlafDaten(aufzeichnungen: [a, b]));
    expect(d.aufzeichnungen.length, 2);
    expect(a.id, isNot(b.id));
  });
  test(
      'Backup-Merge konvergiert bei gleicher Zeit und übernimmt keine Geräteverbindung',
      () {
    final a = SchlafAufzeichnung.ausHealth(session(), now);
    final b = SchlafAufzeichnung.ausHealth(
        {...session(), 'offsetStartMin': 120}, now);
    final left = SchlafDaten(aufzeichnungen: [a]);
    final right = SchlafDaten(aufzeichnungen: [b]);
    expect(left.zusammen(right).toJson(), right.zusammen(left).toJson());
    expect(
        left
            .zusammen(SchlafDaten(aufzeichnungen: [a], verbunden: true))
            .verbunden,
        isFalse);
  });
  test(
      'Trennen behält Daten, getrenntes Löschen entfernt sie auch gegen altes Backup',
      () async {
    final a = SchlafAufzeichnung.ausHealth(session(), now);
    await StorageService.saveSchlafdaten(
        (_) => SchlafDaten(aufzeichnungen: [a], verbunden: true),
        backup: false);
    final old = StorageService.exportAllUserData();
    await StorageService.savePraxisEintrag(
        PraxisEintrag(id: '2026-11-03', art: 'tag', geaendert: now, lust: 3));
    final dienst = SchlafdatenDienst();
    await dienst.trennen();
    expect(StorageService.getSchlafdaten().aufzeichnungen, hasLength(1));
    expect(StorageService.getSchlafdaten().verbunden, isFalse);
    await dienst.loeschen();
    await StorageService.importBackup(BackupCodec.validate(old));
    expect(StorageService.getSchlafdaten().aufzeichnungen, isEmpty);
    expect(StorageService.getSchlafdaten().verbunden, isFalse);
    expect(StorageService.getTraumpraxis().tage.single.lust, 3);
  });
  test(
      'Importierte Daten und Löschmarkierung überleben Wiederherstellung, Verbindung bleibt aus',
      () async {
    final a = SchlafAufzeichnung.ausHealth(session(), now);
    final data = SchlafDaten(aufzeichnungen: [a], verbunden: true);
    await StorageService.importBackup(BackupCodec.validate(
        {'app': 'VelvetPulse', 'schlafdaten': data.toJson()}));
    expect(StorageService.getSchlafdaten().aufzeichnungen.single.toJson(),
        a.toJson());
    expect(StorageService.getSchlafdaten().verbunden, isFalse);
    final deleted = data.loeschen(now.subtract(const Duration(days: 1)));
    expect(deleted.zusammen(data).aufzeichnungen, isEmpty);
    expect(SchlafDaten.fromJson(deleted.toJson()).geloeschtAm, isNotNull);
  });
  test('Beschädigter Schlafblock importiert kein anderes Feld teilweise',
      () async {
    final before = StorageService.exportAllUserData();
    await expectLater(
        StorageService.importBackup(BackupCodec.validate({
          'app': 'VelvetPulse',
          'schlafdaten': {'version': 99},
          'completedLessons': ['unbeabsichtigt']
        })),
        throwsA(isA<BackupException>()));
    expect(StorageService.getCompletedLessons(), isEmpty);
    expect(StorageService.exportAllUserData()['schlafdaten'],
        before['schlafdaten']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schlafdaten', '{defekt');
    await expectLater(
        StorageService.saveSchlafdaten((_) => const SchlafDaten()),
        throwsFormatException);
    expect(prefs.getString('schlafdaten'), '{defekt');
  });
  test('Importlimit überschreibt keinen vorhandenen Stand', () async {
    final entries = [
      for (var i = 0; i <= 500; i++)
        SchlafAufzeichnung.ausHealth(session(id: '$i'), now)
    ];
    await expectLater(
        StorageService.saveSchlafdaten(
            (_) => SchlafDaten(aufzeichnungen: entries),
            backup: false),
        throwsFormatException);
    expect(StorageService.getSchlafdaten().aufzeichnungen, isEmpty);
  });

  const channel = MethodChannel('test/schlafdaten');
  tearDown(() => TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null));
  test(
      'Nur READ_SLEEP-Daten, manueller Zeitraum und Quellwahl; keine gespeicherte Berechtigung ersetzt Systemzugriff',
      () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'status')
        return {'verfuegbar': true, 'berechtigt': true};
      if (call.method == 'lesen') {
        final args = Map<String, dynamic>.from(call.arguments as Map);
        expect(args['endeMs'] - args['startMs'],
            const Duration(days: 30).inMilliseconds);
        return [session(), session(id: 'anders', quelle: 'zweiter.provider')];
      }
      return null;
    });
    final dienst = SchlafdatenDienst(kanal: channel);
    expect(calls, isEmpty);
    await dienst.verbinden();
    final rows = await dienst.lesen(zeit: now);
    await dienst.uebernehmen(rows, 'test.provider');
    expect(StorageService.getSchlafdaten().aufzeichnungen.single.quelle,
        'test.provider');
    expect(calls.where((c) => c == 'lesen'), hasLength(1));
  });
  test('Spätes Leseergebnis nach Trennen kann keinen Import mehr schreiben',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'status')
        return {'verfuegbar': true, 'berechtigt': true};
      return null;
    });
    final dienst = SchlafdatenDienst(kanal: channel);
    await dienst.verbinden();
    final rows = [SchlafAufzeichnung.ausHealth(session(), now)];
    await dienst.trennen();
    await expectLater(
        dienst.uebernehmen(rows, 'test.provider'), throwsStateError);
    expect(StorageService.getSchlafdaten().aufzeichnungen, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('spicy_mode', false);
    await expectLater(
        dienst.uebernehmen(rows, 'test.provider'), throwsStateError);
  });
  test('Trennen verwirft eine noch laufende native Abfrage', () async {
    final antwort = Completer<List<dynamic>>();
    final gestartet = Completer<void>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'status') {
        return {'verfuegbar': true, 'berechtigt': true};
      }
      if (call.method == 'lesen') {
        gestartet.complete();
        return antwort.future;
      }
      return null;
    });
    final dienst = SchlafdatenDienst(kanal: channel);
    await dienst.verbinden();
    final lesen = dienst.lesen(zeit: now);
    final pruefung = expectLater(lesen, throwsStateError);
    await gestartet.future;
    await dienst.trennen();
    antwort.complete([session()]);
    await pruefung;
    expect(StorageService.getSchlafdaten().aufzeichnungen, isEmpty);
  });
  test('Entzogene Systemberechtigung verhindert Speichern', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            channel, (call) async => {'verfuegbar': true, 'berechtigt': false});
    final dienst = SchlafdatenDienst(kanal: channel);
    await dienst.verbinden();
    await expectLater(
        dienst.uebernehmen(
            [SchlafAufzeichnung.ausHealth(session(), now)], 'test.provider'),
        throwsStateError);
    expect(StorageService.getSchlafdaten().aufzeichnungen, isEmpty);
  });
}
