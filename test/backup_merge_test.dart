import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

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

  test('Die Ja/Nein-Liste ist in der Sicherung enthalten', () {
    final export = StorageService.exportAllUserData();
    expect(jsonDecode(export['yesNoMaybe'] as String), {'a': 'yes', 'c': 'no'});
  });

  test('Einspielen führt Check-ins und Ja/Nein-Antworten zusammen', () async {
    final backup = StorageService.exportAllUserData()
      ..['yesNoMaybe'] = jsonEncode({'a': 'maybe', 'b': 'no'})
      ..['dailyCheckIns'] = [checkIn('2026-10-21', 2), checkIn('2026-10-22', 5)];
    await StorageService.importBackup(BackupCodec.validate(backup));

    final prefs = await SharedPreferences.getInstance();
    expect(jsonDecode(prefs.getString(StorageService.keyYesNoMaybe)!), {'a': 'maybe', 'b': 'no', 'c': 'no'});
    final dates = [
      for (final raw in prefs.getStringList('daily_check_ins')!) (jsonDecode(raw) as Map)['date'],
    ];
    expect(dates, ['2026-10-22', '2026-10-21', '2026-10-20']);
    // Am gleichen Tag gilt die Sicherung.
    expect((jsonDecode(prefs.getStringList('daily_check_ins')!.first) as Map)['mood'], 5);
  });

  test('Beschädigte Felder: verständliche Meldung, und es wird nichts verändert', () async {
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
        throwsA(isA<BackupException>().having((e) => e.message, 'Meldung', contains('beschädigt'))),
        reason: '$feld = $wert',
      );
      expect({for (final k in prefs.getKeys()) k: prefs.get(k)}, vorher, reason: '$feld = $wert');
    }
  });

  test('Abgeschnittene Datei wird abgelehnt, eine Sicherung ohne Daten ändert nichts Wesentliches', () async {
    final voll = jsonEncode(StorageService.exportAllUserData());
    expect(() => BackupCodec.validate(voll.substring(0, voll.length ~/ 2)), throwsA(isA<BackupException>()));

    final prefs = await SharedPreferences.getInstance();
    final yesNoVorher = prefs.getString(StorageService.keyYesNoMaybe);
    await StorageService.importBackup(BackupCodec.validate({'app': 'VelvetPulse', 'schema': 2}));
    expect(prefs.getString(StorageService.keyYesNoMaybe), yesNoVorher);
    expect(prefs.getStringList('daily_check_ins'), hasLength(2));
  });

  test('Beschädigter Passwort-Block: Fehlermeldung statt Absturz', () async {
    for (final block in [
      <String, dynamic>{'v': 1, 'kdf': 'pbkdf2-sha256', 'iter': 210000},
      <String, dynamic>{'v': 1, 'kdf': 'pbkdf2-sha256', 'iter': 210000, 'salt': '!!', 'nonce': 'x', 'ct': 'y'},
      <String, dynamic>{'v': 2},
    ]) {
      await expectLater(BackupCodec.decryptSecrets(block, 'egal'), throwsA(isA<BackupException>()));
    }
  });
}
