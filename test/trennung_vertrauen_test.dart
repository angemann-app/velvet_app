// Sicherheit und Vertrauen im Paar-Kanal (docs/konzepte/paar-kanal-vertrauen.md): Trenn-Hinweis,
// Antworten auf Einladung und Funken. Alles läuft als normale Chat-Nachricht mit Zusatzfeld, damit
// ältere Versionen nur einen lesbaren Satz sehen.
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/couple_channel_models.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final keys = KeyApi();
  final events = EventApi();
  final nostr = NostrService();
  int jetzt() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  late String myPub, partnerPriv, partnerPub;
  late List<Map<String, dynamic>> gesendet;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest();
    StorageService.resetForTest();
    await StorageService.init();
    await nostr.reloadKeysFromPrefs();
    await nostr.unpairPartner();
    myPub = nostr.myPublicKey;
    partnerPriv = keys.generatePrivateKey();
    partnerPub = keys.getPublicKey(partnerPriv);
    await nostr.setPartner(partnerPub, name: 'Anna');
    gesendet = [];
    nostr.senderFuerTest = (ev) {
      gesendet.add(ev);
      return true;
    };
  });
  tearDown(() => nostr.senderFuerTest = null);

  Map<String, dynamic> dm(Map<String, dynamic> payload, {String? von, int? zeit}) => events
      .finishEvent(
        Event(
          kind: 4,
          tags: [
            ['p', myPub]
          ],
          content: Nip04().encrypt(von ?? partnerPriv, myPub, jsonEncode(payload)),
          created_at: zeit ?? jetzt(),
          verify: false,
        ),
        von ?? partnerPriv,
      )
      .toJson();

  Map<String, dynamic> lesen(Map<String, dynamic> ev) =>
      jsonDecode(Nip04().decrypt(partnerPriv, myPub, ev['content'] as String)) as Map<String, dynamic>;

  group('Trennen mit Hinweis', () {
    test('Der Hinweis ist eine normale Chat-Nachricht mit neutralem Satz, Zusatzfeld und Ablauf', () async {
      final hinweisGesendet = await nostr.trennenMitHinweis();
      expect(hinweisGesendet, isTrue);
      final ev = gesendet.single;
      expect(ev['kind'], 4);
      expect((ev['tags'] as List).any((t) => t[0] == 'expiration'), isTrue);
      final inhalt = lesen(ev);
      expect(inhalt['type'], 'chat', reason: 'ältere Versionen zeigen den Satz statt rohem JSON');
      expect(inhalt['text'], t.trennungSatzAelter);
      expect(inhalt['trennung'], 1);
      // Auf diesem Handy ist danach aufgeräumt, und nichts steht im eigenen Verlauf.
      expect(nostr.isPaired, isFalse);
      expect(nostr.messagesNotifier.value, isEmpty);
    });

    test('Still trennen: ohne Hinweis wird nichts gesendet, hier ist trotzdem aufgeräumt', () async {
      expect(await nostr.trennenMitHinweis(hinweis: false), isTrue);
      expect(gesendet, isEmpty);
      expect(nostr.isPaired, isFalse);
    });

    test('Kommt der Hinweis nicht raus, wird trotzdem getrennt und das ehrlich gemeldet', () async {
      nostr.senderFuerTest = (_) => false;
      final hinweisGesendet = await nostr.trennenMitHinweis(warten: Duration.zero);
      expect(hinweisGesendet, isFalse);
      expect(nostr.isPaired, isFalse);
    });

    test('Das Gegenüber bekommt eine ruhige Karte statt einer Blase; der Chat bleibt', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hallo'}));
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': t.trennungSatzAelter, 'trennung': 1}));
      expect(nostr.partnerGetrenntNotifier.value, isTrue);
      expect(nostr.messagesNotifier.value.map((m) => m.text), ['Hallo']);
      expect(nostr.isPaired, isTrue, reason: 'gelöscht wird nur, wenn diese Person es selbst bestätigt');
      // Übersteht einen Neustart und ist Teil der Sicherung.
      await nostr.reloadKeysFromPrefs();
      expect(nostr.partnerGetrenntNotifier.value, isTrue);
      final export = StorageService.exportAllUserData();
      expect(export['nostrPartnerGetrennt'], '1');
      expect(export['nostrPartnerSeit'], isNotNull);
      // Wer selbst löscht, setzt den Stand zurück.
      await nostr.unpairPartner();
      expect(nostr.partnerGetrenntNotifier.value, isFalse);
    });

    test('Ein alter Hinweis vom Server zählt nach erneutem Koppeln nicht', () async {
      final alt = dm({'type': 'chat', 'text': 'x', 'trennung': 1}, zeit: jetzt() - 3600);
      await nostr.unpairPartner();
      await nostr.setPartner(partnerPub, name: 'Anna');
      await nostr.handleIncomingKind4Map(alt);
      expect(nostr.partnerGetrenntNotifier.value, isFalse);
      // Ein neuer schon.
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'trennung': 1}, zeit: jetzt() + 2));
      expect(nostr.partnerGetrenntNotifier.value, isTrue);
    });

    test('Hat das Gegenüber getrennt, geht nichts mehr raus; erneutes Koppeln hebt den Stand auf', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'trennung': 1}));
      expect(nostr.partnerGetrenntNotifier.value, isTrue);
      expect(await nostr.sendChatMessage('Hallo?'), isFalse);
      expect(await nostr.sendQuickPing('💗', 'x'), isFalse);
      expect(gesendet, isEmpty);
      await nostr.setPartner(partnerPub, name: 'Anna');
      expect(nostr.partnerGetrenntNotifier.value, isFalse);
      expect(await nostr.sendChatMessage('Wieder da'), isTrue);
    });

    test('Trennen nach dem Hinweis des Gegenübers sendet keinen zweiten Hinweis', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'trennung': 1}));
      expect(await nostr.trennenMitHinweis(), isTrue);
      expect(gesendet, isEmpty);
      expect(nostr.isPaired, isFalse);
    });

    test('Der Hinweis eines Fremden ändert nichts', () async {
      final fremd = keys.generatePrivateKey();
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'trennung': 1}, von: fremd));
      expect(nostr.partnerGetrenntNotifier.value, isFalse);
    });

    test('Trenn-Stand und Beginn der Verbindung prüft die Sicherung', () async {
      final export = StorageService.exportAllUserData();
      expect(() => BackupCodec.validate({...export, 'nostrPartnerGetrennt': 'ja'}), throwsA(isA<BackupException>()));
      expect(() => BackupCodec.validate({...export, 'nostrPartnerSeit': 'gestern'}), throwsA(isA<BackupException>()));
      expect(() => BackupCodec.validate({...export, 'nostrPartnerGetrennt': '1', 'nostrPartnerSeit': '1700000000'}),
          returnsNormally);
    });
  });

  group('Antworten', () {
    test('„Gerade nicht“ geht als lesbare Nachricht mit Zusatzfeld und markiert die Einladung', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Magst du?', 'spicy_invite': true}));
      final einladung = nostr.messagesNotifier.value.single;
      expect(await nostr.sendAntwort('spicy_nein', t.spicyNeinSatz, aufId: einladung.id), isTrue);
      final inhalt = lesen(gesendet.single);
      expect(inhalt['type'], 'chat');
      expect(inhalt['text'], t.spicyNeinSatz);
      expect(inhalt['antwort'], 'spicy_nein');
      expect(nostr.messagesNotifier.value.firstWhere((m) => m.id == einladung.id).beantwortet, isTrue);
    });

    test('Unbekannte Antwort-Arten werden nicht gesendet und beim Empfang verworfen', () async {
      expect(await nostr.sendAntwort('irgendwas', 'x'), isFalse);
      expect(gesendet, isEmpty);
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hi', 'antwort': 'irgendwas'}));
      expect(nostr.messagesNotifier.value.single.antwort, isNull);
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Danke', 'antwort': 'danke'}));
      expect(nostr.messagesNotifier.value.last.antwort, 'danke');
    });

    test('Funken tragen ihre Art nur für „nein“ und „reden“; alles andere fällt weg', () async {
      await nostr.sendQuickPing('🌙', 'Heute lieber nicht', funke: 'nein');
      expect(lesen(gesendet.last)['funke'], 'nein');
      await nostr.sendQuickPing('💗', 'Ich will dich', funke: 'bloed');
      expect(lesen(gesendet.last).containsKey('funke'), isFalse);
      await nostr.handleIncomingKind4Map(dm({'type': 'ping', 'emoji': '💬', 'text': 'Lass uns reden', 'funke': 'reden'}));
      await nostr.handleIncomingKind4Map(dm({'type': 'ping', 'emoji': '💗', 'text': 'x', 'funke': 'bloed'}));
      final pings = nostr.messagesNotifier.value.where((m) => !m.isMe).toList();
      expect(pings.map((m) => m.funke), ['reden', null]);
    });

    test('Antwort-Felder überstehen das Speichern', () async {
      final m = CoupleMessage(
        id: 'a',
        senderPubkey: 'b',
        isMe: false,
        type: CoupleMessageType.ping,
        funke: 'nein',
        antwort: 'danke',
        beantwortet: true,
        createdAt: _zeit,
      );
      final zurueck = CoupleMessage.fromJson(m.toJson());
      expect(zurueck.funke, 'nein');
      expect(zurueck.antwort, 'danke');
      expect(zurueck.beantwortet, isTrue);
      expect(CoupleMessage.fromJson({...m.toJson(), 'antwort': 'boese'}).antwort, isNull);
    });
  });

  group('Foto-Hinweis', () {
    test('Einmal je Verbindung, nach einer Trennung wieder', () async {
      expect(await nostr.fotoHinweisOffen(), isTrue);
      await nostr.fotoHinweisGesehen();
      expect(await nostr.fotoHinweisOffen(), isFalse);
      await nostr.unpairPartner();
      await nostr.setPartner(partnerPub, name: 'Anna');
      expect(await nostr.fotoHinweisOffen(), isTrue);
    });
  });
}

final _zeit = DateTime(2026, 11, 12);
