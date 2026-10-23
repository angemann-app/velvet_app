// Regressionstests zum Sicherheits-Audit v4.2.0+17 (docs/SICHERHEIT_AUDIT_BASELINE.md).
// Nur synthetische Schlüssel und Werte, kein Netz nötig.
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/nostr_event_check.dart';
import 'package:velvetpulse/services/nostr_keys.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

const fakeApiKey = 'TEST-API-KEY-0000000000000000';
final keyApi = KeyApi();

Future<SharedPreferences> freshApp({Map<String, Object> prefs = const {}, Map<String, String> secure = const {}}) async {
  SharedPreferences.setMockInitialValues(prefs);
  FlutterSecureStorage.setMockInitialValues(Map.of(secure));
  SecretStore.resetForTest();
  StorageService.resetForTest();
  await StorageService.init();
  await NostrService().reloadKeysFromPrefs();
  return SharedPreferences.getInstance();
}

Map<String, dynamic> signedDm({
  required String senderPriv,
  required String recipientPub,
  required String text,
  int? createdAt,
}) {
  final event = Event(
    kind: 4,
    tags: [
      ['p', recipientPub]
    ],
    content: Nip04().encrypt(senderPriv, recipientPub, text),
    created_at: createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
    verify: false,
  );
  return EventApi().finishEvent(event, senderPriv).toJson();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('A: keine Geheimnisse im Klartext', () {
    test('Altbestand wandert aus den SharedPreferences in den sicheren Speicher', () async {
      final priv = keyApi.generatePrivateKey();
      final prefs = await freshApp(prefs: {'gemini_api_key': fakeApiKey, 'velvet_nostr_privkey': priv});
      expect(prefs.getString('gemini_api_key'), isNull);
      expect(prefs.getString('velvet_nostr_privkey'), isNull);
      expect(StorageService.getApiKey(), fakeApiKey);
      expect(NostrService().myPublicKey, keyApi.getPublicKey(priv));
    });

    test('Normales Backup und Auto-Backup enthalten weder API-Key noch privaten Schlüssel', () async {
      await freshApp();
      await StorageService.saveApiKey(fakeApiKey, triggerBackup: false);
      final json = jsonEncode(StorageService.exportAllUserData());
      expect(json, isNot(contains(fakeApiKey)));
      expect(json, isNot(contains(NostrService().myPrivateKey)));
      expect(json, isNot(contains('nostrPrivKey')));
      expect(json, isNot(contains('apiKey')));
    });

    test('Export mit Passwort: verschlüsselt, mit richtigem Passwort lesbar, sonst nicht', () async {
      await freshApp();
      await StorageService.saveApiKey(fakeApiKey, triggerBackup: false);
      final data = await StorageService.exportWithSecrets('richtiges-passwort');
      final json = jsonEncode(data);
      expect(json, isNot(contains(fakeApiKey)));
      expect(json, isNot(contains(NostrService().myPrivateKey)));

      final backup = BackupCodec.validate(json);
      expect(backup.needsPassword, isTrue);
      final secrets = await BackupCodec.decryptSecrets(backup.encryptedSecrets!, 'richtiges-passwort');
      expect(secrets['apiKey'], fakeApiKey);
      expect(secrets['nostrPrivKey'], NostrService().myPrivateKey);

      await expectLater(BackupCodec.decryptSecrets(backup.encryptedSecrets!, 'falsch'), throwsA(isA<BackupException>()));
      final tampered = Map<String, dynamic>.from(backup.encryptedSecrets!);
      final ct = base64Decode(tampered['ct'] as String)..[0] ^= 1;
      tampered['ct'] = base64Encode(ct);
      await expectLater(BackupCodec.decryptSecrets(tampered, 'richtiges-passwort'), throwsA(isA<BackupException>()));
    });

    test('Umzug: Sicherung mit Passwort stellt Verbindung und API-Key auf einem neuen Gerät her', () async {
      await freshApp();
      await StorageService.saveApiKey(fakeApiKey, triggerBackup: false);
      final partner = keyApi.getPublicKey(keyApi.generatePrivateKey());
      await NostrService().setPartner(partner, name: 'Anna');
      final oldPub = NostrService().myPublicKey;
      final exported = jsonEncode(await StorageService.exportWithSecrets('pass-1234'));

      await freshApp(); // neues Gerät, neue Identität
      expect(NostrService().myPublicKey, isNot(oldPub));
      final backup = BackupCodec.validate(exported);
      final secrets = await BackupCodec.decryptSecrets(backup.encryptedSecrets!, 'pass-1234');
      await StorageService.importBackup(backup, secrets: secrets);
      expect(NostrService().myPublicKey, oldPub);
      expect(NostrService().partnerPublicKey, partner);
      expect(StorageService.getApiKey(), fakeApiKey);
    });

    test('Ohne Schlüssel auf neuem Gerät wird keine scheinbare Paar-Verbindung übernommen', () async {
      await freshApp();
      await NostrService().setPartner(keyApi.getPublicKey(keyApi.generatePrivateKey()), name: 'Anna');
      final exported = jsonEncode(StorageService.exportAllUserData());
      await freshApp();
      await StorageService.importBackup(BackupCodec.validate(exported));
      expect(NostrService().isPaired, isFalse);
    });
  });

  group('B: Import nur geprüft und ohne Teilschäden', () {
    test('Ungültige Sicherungen werden abgelehnt', () {
      final bad = <Object?>[
        'kein json',
        '[]',
        {'app': 'Fremd'},
        {'app': 'VelvetPulse', 'schema': 99},
        {'app': 'VelvetPulse', 'schema': 'zwei'},
        {'app': 'VelvetPulse', 'completedLessons': 'keine Liste'},
        {'app': 'VelvetPulse', 'streakCount': '5'},
        {'app': 'VelvetPulse', 'reflectionAnswers': 'x' * 300000},
        {'app': 'VelvetPulse', 'completedLessons': List.filled(6000, 'a')},
        {'app': 'VelvetPulse', 'nostrPartnerPubKey': 'nicht-hex'},
        {'app': 'VelvetPulse', 'secrets': 'kaputt'},
        'x' * (BackupCodec.maxBackupChars + 1),
      ];
      for (final raw in bad) {
        expect(() => BackupCodec.validate(raw), throwsA(isA<BackupException>()), reason: '$raw'.length > 40 ? '$raw'.substring(0, 40) : '$raw');
      }
    });

    test('Private Schlüssel werden kryptografisch geprüft', () {
      expect(isValidPrivateKeyHex(keyApi.generatePrivateKey()), isTrue);
      expect(isValidPrivateKeyHex('0' * 64), isFalse); // Skalar 0
      expect(isValidPrivateKeyHex('f' * 64), isFalse); // größer als die Gruppenordnung
      expect(isValidPrivateKeyHex('g' * 64), isFalse); // kein Hex
      expect(isValidPrivateKeyHex('a' * 63), isFalse);
      for (final key in ['0' * 64, 'f' * 64, 'zz']) {
        expect(() => BackupCodec.validate({'app': 'VelvetPulse', 'nostrPrivKey': key}), throwsA(isA<BackupException>()));
      }
    });

    test('Alte Klartext-Sicherung wird erkannt und bleibt einspielbar', () async {
      await freshApp();
      final priv = keyApi.generatePrivateKey();
      final legacy = {
        'app': 'VelvetPulse',
        'version': '4.0.0',
        'apiKey': fakeApiKey,
        'nostrPrivKey': priv,
        'nostrPubKey': keyApi.getPublicKey(priv),
        'completedLessons': ['tease_1'],
      };
      final backup = BackupCodec.validate(legacy);
      expect(backup.hasPlaintextSecrets, isTrue);
      await StorageService.importBackup(backup, secrets: backup.plaintextSecrets);
      expect(StorageService.getApiKey(), fakeApiKey);
      expect(NostrService().myPublicKey, keyApi.getPublicKey(priv));
      expect(StorageService.isLessonCompleted('tease_1'), isTrue);
    });

    test('Nicht zusammenpassende Schlüssel: Abbruch, vorheriger Stand bleibt unverändert', () async {
      final prefs = await freshApp();
      await StorageService.saveUserProfile(
          UserProfile(name: 'Vorher', gender: 'male', age: 40, relationshipStatus: 'relationship', primaryGoal: 'couple_intimacy'),
          triggerBackup: false);
      final pubBefore = NostrService().myPublicKey;
      final snapshot = {for (final k in prefs.getKeys()) k: prefs.get(k)};

      final backup = BackupCodec.validate({
        'app': 'VelvetPulse',
        'version': '4.0.0',
        'userProfile': {'name': 'Fremd', 'gender': 'female', 'age': 30, 'relationshipStatus': 'single', 'primaryGoal': 'x'},
        'nostrPrivKey': keyApi.generatePrivateKey(),
        'nostrPubKey': keyApi.getPublicKey(keyApi.generatePrivateKey()), // passt nicht
      });
      await expectLater(StorageService.importBackup(backup, secrets: backup.plaintextSecrets), throwsA(isA<BackupException>()));
      expect({for (final k in prefs.getKeys()) k: prefs.get(k)}, snapshot);
      expect(StorageService.getUserProfile()!.name, 'Vorher');
      expect(NostrService().myPublicKey, pubBefore);
    });
  });

  group('C: eingehende Nostr-Events', () {
    late String partnerPriv;
    late String myPub;

    setUp(() async {
      await freshApp();
      partnerPriv = keyApi.generatePrivateKey();
      myPub = NostrService().myPublicKey;
      await NostrService().setPartner(keyApi.getPublicKey(partnerPriv), name: 'Anna');
      NostrService().messagesNotifier.value = [];
    });

    int count(String text) => NostrService().messagesNotifier.value.where((m) => m.text == text).length;

    test('Gültiges Event vom Partner wird angenommen, Duplikate nur einmal', () async {
      final ev = signedDm(senderPriv: partnerPriv, recipientPub: myPub, text: 'hallo');
      expect(NostrEventCheck.isValidDirectMessage(ev, recipient: myPub), isTrue);
      await NostrService().handleIncomingKind4Map(ev);
      await NostrService().handleIncomingKind4Map(Map.of(ev));
      expect(count('hallo'), 1);
    });

    test('Manipulierte Events werden verworfen', () async {
      final ev = signedDm(senderPriv: partnerPriv, recipientPub: myPub, text: 'echt');
      final variants = <String, Map<String, dynamic>>{
        'content': {...ev, 'content': Nip04().encrypt(partnerPriv, myPub, 'gefälscht')},
        'created_at': {...ev, 'created_at': (ev['created_at'] as int) - 3600},
        'id': {...ev, 'id': 'a' * 64},
        'sig': {...ev, 'sig': 'b' * 128},
        'ohne sig': {...ev}..remove('sig'),
        'Zeit als Text': {...ev, 'created_at': '${ev['created_at']}'},
        'Zukunft': signedDm(senderPriv: partnerPriv, recipientPub: myPub, text: 'echt',
            createdAt: DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000),
        'falscher Empfänger': signedDm(senderPriv: partnerPriv, recipientPub: keyApi.getPublicKey(keyApi.generatePrivateKey()), text: 'echt'),
        'kein Event': {'kind': 4},
      };
      for (final entry in variants.entries) {
        expect(NostrEventCheck.isValidDirectMessage(entry.value, recipient: myPub), isFalse, reason: entry.key);
        await NostrService().handleIncomingKind4Map(entry.value);
      }
      expect(NostrService().messagesNotifier.value, isEmpty);
    });

    test('Gültig signiertes Event eines Fremden wird nicht angenommen', () async {
      final ev = signedDm(senderPriv: keyApi.generatePrivateKey(), recipientPub: myPub, text: 'fremd');
      expect(NostrEventCheck.isValidDirectMessage(ev, recipient: myPub), isTrue);
      await NostrService().handleIncomingKind4Map(ev);
      expect(count('fremd'), 0);
    });

    test('Ein ungültiges Event mit derselben ID blockiert das echte nicht', () async {
      final ev = signedDm(senderPriv: partnerPriv, recipientPub: myPub, text: 'wichtig');
      await NostrService().handleIncomingKind4Map({...ev, 'sig': 'c' * 128});
      await NostrService().handleIncomingKind4Map(ev);
      expect(count('wichtig'), 1);
    });
  });
}
