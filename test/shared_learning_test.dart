import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final keyApi = KeyApi();
  late String partnerPriv;
  late String myPub;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    await NostrService().reloadKeysFromPrefs();
    partnerPriv = keyApi.generatePrivateKey();
    myPub = NostrService().myPublicKey;
    await NostrService().setPartner(keyApi.getPublicKey(partnerPriv), name: 'Anna');
    NostrService().messagesNotifier.value = [];
  });

  Map<String, dynamic> fromPartner(Map<String, dynamic> payload) => EventApi()
      .finishEvent(
        Event(
          kind: 4,
          tags: [
            ['p', myPub]
          ],
          content: Nip04().encrypt(partnerPriv, myPub, jsonEncode(payload)),
          created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          verify: false,
        ),
        partnerPriv,
      )
      .toJson();

  test('Geteilte Reflexion landet beim Gegenüber, der Chat-Text verrät sie nicht', () async {
    await NostrService().handleIncomingKind4Map(fromPartner({
      'type': 'chat',
      'text': '💭 Ich habe meine Gedanken zu „Zwei Pedale“ geteilt.',
      'lesson': 'neuro_1',
      'reflection': 'GEHEIME ANTWORT',
    }));
    expect(NostrService().partnerReflectionsNotifier.value['neuro_1'], 'GEHEIME ANTWORT');
    final msg = NostrService().messagesNotifier.value.single;
    expect(msg.lessonId, 'neuro_1');
    expect(msg.text, isNot(contains('GEHEIME ANTWORT')));
  });

  test('Ältere Versionen lesen nur type und text – die Antwort bleibt verborgen', () async {
    // So parst 4.3.0: bekannte Felder, Rest wird ignoriert.
    final payload = {
      'type': 'chat',
      'text': '💭 Ich habe meine Gedanken zu „X“ geteilt.',
      'lesson': 'neuro_1',
      'reflection': 'GEHEIME ANTWORT',
    };
    final data = jsonDecode(jsonEncode(payload)) as Map<String, dynamic>;
    expect(data['type'], 'chat');
    expect(data['text'], isNot(contains('GEHEIME ANTWORT')));
  });

  test('Überlange oder falsche Felder werden ignoriert', () async {
    await NostrService().handleIncomingKind4Map(fromPartner({
      'type': 'chat',
      'text': 'x',
      'lesson': 'l' * 100,
      'reflection': 'y',
    }));
    await NostrService().handleIncomingKind4Map(fromPartner({
      'type': 'chat',
      'text': 'x',
      'lesson': 'neuro_2',
      'reflection': 'z' * 6000,
    }));
    expect(NostrService().partnerReflectionsNotifier.value, isEmpty);
  });

  test('Entkoppeln löscht die Reflexionen des Gegenübers', () async {
    await NostrService().handleIncomingKind4Map(fromPartner(
        {'type': 'chat', 'text': 'x', 'lesson': 'neuro_1', 'reflection': 'Antwort'}));
    await NostrService().unpairPartner();
    expect(NostrService().partnerReflectionsNotifier.value, isEmpty);
  });
}
