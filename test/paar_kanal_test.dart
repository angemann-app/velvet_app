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

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    await nostr.reloadKeysFromPrefs();
    await nostr.unpairPartner();
    await nostr.cancelInvite();
    myPub = nostr.myPublicKey;
  });

  Map<String, dynamic> dm(String senderPriv, Map<String, dynamic> payload, {int? createdAt}) => EventApi()
      .finishEvent(
        Event(
          kind: 4,
          tags: [
            ['p', myPub]
          ],
          content: Nip04().encrypt(senderPriv, myPub, jsonEncode(payload)),
          created_at: createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
          verify: false,
        ),
        senderPriv,
      )
      .toJson();

  test('Ohne Kopplung und ohne Einladung werden Nachrichten Fremder ignoriert', () async {
    final stranger = keyApi.generatePrivateKey();
    await nostr.handleIncomingKind4Map(dm(stranger, {'type': 'chat', 'text': 'Hallo'}));
    expect(nostr.messagesNotifier.value, isEmpty);
    expect(nostr.joinRequestNotifier.value, isNull);
  });

  test('Bei offener Einladung wird die erste Nachricht zur Verbindungsanfrage', () async {
    final partner = keyApi.generatePrivateKey();
    await nostr.startInvite('Anna');
    await nostr.handleIncomingKind4Map(dm(partner, {'type': 'chat', 'text': 'Hallo'}));
    expect(nostr.joinRequestNotifier.value, keyApi.getPublicKey(partner));
  });

  test('Gebündelte Ja/Nein-Antworten kommen vollständig an, ohne den Verlauf zu füllen', () async {
    final partner = keyApi.generatePrivateKey();
    await nostr.setPartner(keyApi.getPublicKey(partner), name: 'Anna');
    final votes = {for (var i = 0; i < 63; i++) 'item_$i': i.isEven ? 'yes' : 'no'};
    await nostr.handleIncomingKind4Map(dm(partner, {'type': 'chat', 'text': '🗳️ geteilt', 'votes': votes}));
    expect(nostr.partnerFantasyVotesNotifier.value, votes);
    expect(nostr.messagesNotifier.value, hasLength(1));

    // Einzelstimmen (ältere Versionen) landen nicht im Verlauf.
    await nostr.handleIncomingKind4Map(
        dm(partner, {'type': 'fantasy_vote', 'fantasyId': 'item_1', 'vote': 'yes'}));
    expect(nostr.partnerFantasyVotesNotifier.value['item_1'], 'yes');
    expect(nostr.messagesNotifier.value, hasLength(1));
  });

  test('Eine ältere Stimme überschreibt keine neuere', () async {
    final partner = keyApi.generatePrivateKey();
    await nostr.setPartner(keyApi.getPublicKey(partner), name: 'Anna');
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await nostr.handleIncomingKind4Map(
        dm(partner, {'type': 'fantasy_vote', 'fantasyId': 'x', 'vote': 'yes'}, createdAt: now));
    await nostr.handleIncomingKind4Map(
        dm(partner, {'type': 'fantasy_vote', 'fantasyId': 'x', 'vote': 'no'}, createdAt: now - 60));
    expect(nostr.partnerFantasyVotesNotifier.value['x'], 'yes');
  });

  test('Neue Person: Verlauf, Stimmen und Reflexionen der alten werden gelöscht', () async {
    final anna = keyApi.generatePrivateKey();
    await nostr.setPartner(keyApi.getPublicKey(anna), name: 'Anna');
    await nostr.handleIncomingKind4Map(dm(anna, {'type': 'chat', 'text': 'Hi', 'votes': {'a': 'yes'}}));
    await nostr.handleIncomingKind4Map(
        dm(anna, {'type': 'chat', 'text': 'x', 'lesson': 'neuro_1', 'reflection': 'Antwort'}));
    await nostr.sendFantasyVote('a', 'yes');
    expect(nostr.matchesNotifier.value, ['a']);

    // Gleiche Person erneut: nichts geht verloren.
    expect(nostr.wouldReplacePartner(keyApi.getPublicKey(anna)), isFalse);
    await nostr.setPartner(keyApi.getPublicKey(anna), name: 'Anna');
    expect(nostr.messagesNotifier.value, isNotEmpty);

    final ben = keyApi.generatePrivateKey();
    expect(nostr.wouldReplacePartner(Nip19().npubEncode(keyApi.getPublicKey(ben))), isTrue);
    await nostr.setPartner(keyApi.getPublicKey(ben), name: 'Ben');
    expect(nostr.messagesNotifier.value, isEmpty);
    expect(nostr.partnerFantasyVotesNotifier.value, isEmpty);
    expect(nostr.partnerReflectionsNotifier.value, isEmpty);
    expect(nostr.matchesNotifier.value, isEmpty);
    // Die eigenen Antworten bleiben.
    expect(nostr.myFantasyVotesNotifier.value['a'], 'yes');
  });

  test('Trennen löscht alles vom Gegenüber, auch nach einem Neustart', () async {
    final anna = keyApi.generatePrivateKey();
    await nostr.setPartner(keyApi.getPublicKey(anna), name: 'Anna');
    await nostr.handleIncomingKind4Map(dm(anna, {'type': 'chat', 'text': 'Hi', 'votes': {'a': 'yes'}}));
    await nostr.unpairPartner();
    await nostr.reloadKeysFromPrefs();
    expect(nostr.isPaired, isFalse);
    expect(nostr.messagesNotifier.value, isEmpty);
    expect(nostr.partnerFantasyVotesNotifier.value, isEmpty);
  });
}
