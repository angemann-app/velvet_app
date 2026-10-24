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
  final nostr = NostrService();
  late String myPub;
  late String partnerPriv;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    await nostr.reloadKeysFromPrefs();
    await nostr.unpairPartner();
    myPub = nostr.myPublicKey;
    partnerPriv = keyApi.generatePrivateKey();
    await nostr.setPartner(keyApi.getPublicKey(partnerPriv), name: 'Anna');
  });

  Map<String, dynamic> receipt(String senderPriv, Map<String, dynamic> payload,
          {int kind = NostrService.readReceiptKind, String d = 'velvet-read'}) =>
      EventApi()
          .finishEvent(
            Event(
              kind: kind,
              tags: [
                ['d', d],
                ['p', myPub]
              ],
              content: Nip04().encrypt(senderPriv, myPub, jsonEncode(payload)),
              created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              verify: false,
            ),
            senderPriv,
          )
          .toJson();

  test('Ohne Bestätigung vom Gegenüber ist der Lesestatus unbekannt', () {
    expect(nostr.partnerReadUntil.value, isNull);
  });

  test('Bestätigung des Gegenübers wird übernommen und geht nicht zurück', () async {
    await nostr.handleReadReceipt(receipt(partnerPriv, {'read_until': 1000}));
    expect(nostr.partnerReadUntil.value, 1000);
    await nostr.handleReadReceipt(receipt(partnerPriv, {'read_until': 900}));
    expect(nostr.partnerReadUntil.value, 1000);
    // Bleibt nach einem Neustart erhalten.
    await nostr.reloadKeysFromPrefs();
    expect(nostr.partnerReadUntil.value, 1000);
  });

  test('Schaltet das Gegenüber ab, verschwindet der Lesestatus', () async {
    await nostr.handleReadReceipt(receipt(partnerPriv, {'read_until': 1000}));
    await nostr.handleReadReceipt(receipt(partnerPriv, {'off': true}));
    expect(nostr.partnerReadUntil.value, isNull);
  });

  test('Bestätigungen von Fremden oder mit falschem Kennzeichen zählen nicht', () async {
    await nostr.handleReadReceipt(receipt(keyApi.generatePrivateKey(), {'read_until': 1000}));
    await nostr.handleReadReceipt(receipt(partnerPriv, {'read_until': 1000}, d: 'anderes'));
    expect(nostr.partnerReadUntil.value, isNull);
  });

  test('Manipulierte Lesebestätigungen werden verworfen', () async {
    final echt = receipt(partnerPriv, {'read_until': 1000});
    final andererInhalt = Map<String, dynamic>.from(echt)
      ..['content'] = Nip04().encrypt(partnerPriv, myPub, jsonEncode({'read_until': 9999}));
    final falscheSignatur = Map<String, dynamic>.from(echt)..['sig'] = 'a' * 128;
    final falscheArt = receipt(partnerPriv, {'read_until': 1000}, kind: 4);
    for (final ev in [andererInhalt, falscheSignatur, falscheArt]) {
      await nostr.handleReadReceipt(ev);
    }
    expect(nostr.partnerReadUntil.value, isNull);
  });

  test('Neue Person: alter Lesestatus wird gelöscht', () async {
    await nostr.handleReadReceipt(receipt(partnerPriv, {'read_until': 1000}));
    await nostr.setPartner(keyApi.getPublicKey(keyApi.generatePrivateKey()), name: 'Ben');
    expect(nostr.partnerReadUntil.value, isNull);
  });

  test('Ausgeschaltet bleibt ausgeschaltet, auch nach einem Neustart', () async {
    await nostr.setReadReceiptsEnabled(false);
    await nostr.reloadKeysFromPrefs();
    expect(nostr.readReceiptsEnabled.value, isFalse);
    await nostr.setReadReceiptsEnabled(true);
  });
}
