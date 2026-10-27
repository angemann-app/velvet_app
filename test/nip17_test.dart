// NIP-17 im Paar-Kanal (docs/konzepte/nip17.md, Stufe 1): Gift Wrap hin und zurück, gefälschte Hüllen und
// Siegel, Aushandlung zwischen neuen und alten Versionen, Rückfall auf NIP-04.
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/backup_codec.dart';
import 'package:velvetpulse/services/gift_wrap.dart';
import 'package:velvetpulse/services/nip44.dart';
import 'package:velvetpulse/services/nostr_event_check.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final keys = KeyApi();
  final events = EventApi();
  int jetzt() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  group('Gift Wrap', () {
    final anna = keys.generatePrivateKey(), ben = keys.generatePrivateKey();
    final annaPub = keys.getPublicKey(anna), benPub = keys.getPublicKey(ben);

    Map<String, dynamic> huelle(String text, {String? von, String an = ''}) {
      final absender = von ?? anna;
      final empfaenger = an.isEmpty ? benPub : an;
      return GiftWrap.einpacken(
        rumor: GiftWrap.rumor(absenderPub: keys.getPublicKey(absender), empfaengerPub: empfaenger, inhalt: text),
        absenderPrivat: absender,
        empfaengerPub: empfaenger,
      );
    }

    test('Hin und zurück: Inhalt, Absender und echter Zeitpunkt kommen an', () {
      final vorher = jetzt();
      final rumor = GiftWrap.rumor(absenderPub: annaPub, empfaengerPub: benPub, inhalt: 'Hallo 💜');
      final h = GiftWrap.einpacken(rumor: rumor, absenderPrivat: anna, empfaengerPub: benPub);
      expect(h['kind'], 1059);
      expect(h['pubkey'], isNot(annaPub), reason: 'Hülle vom Wegwerf-Schlüssel');
      expect(h['tags'], [
        ['p', benPub]
      ]);
      expect(h['created_at'] as int, lessThanOrEqualTo(jetzt()));
      expect(h['created_at'] as int, greaterThanOrEqualTo(vorher - GiftWrap.maxZurueck.inSeconds));
      expect(jsonEncode(h), isNot(contains('Hallo')));
      expect(jsonEncode(h), isNot(contains(annaPub)), reason: 'Absender ist von außen nicht zu sehen');

      final offen = GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub, erwarteterAbsender: annaPub)!;
      expect(offen.absender, annaPub);
      expect(offen.rumor['content'], 'Hallo 💜');
      expect(offen.rumor['id'], rumor['id']);
      expect(offen.rumor['created_at'], greaterThanOrEqualTo(vorher));
      expect(offen.rumor.containsKey('sig'), isFalse);
    });

    test('Jede Hülle hat einen eigenen Wegwerf-Schlüssel', () {
      expect(huelle('a')['pubkey'], isNot(huelle('a')['pubkey']));
    });

    test('Nur der Empfänger kann sie öffnen', () {
      final fremd = keys.generatePrivateKey();
      expect(GiftWrap.auspacken(huelle('x'), meinPrivat: fremd, meinPub: keys.getPublicKey(fremd)), isNull);
      expect(GiftWrap.auspacken(huelle('x'), meinPrivat: anna, meinPub: annaPub), isNull);
    });

    test('Siegel von jemand anderem als dem Partner wird verworfen', () {
      final fremd = keys.generatePrivateKey();
      final h = huelle('Ich bin Anna', von: fremd);
      expect(GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub, erwarteterAbsender: annaPub), isNull);
      // Ohne erwarteten Absender (offene Einladung) zählt der wahre Absender, nicht ein behaupteter.
      expect(GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub)!.absender, keys.getPublicKey(fremd));
    });

    test('Rumor mit fremdem Absender im eigenen Siegel wird verworfen', () {
      final fremd = keys.generatePrivateKey();
      // Der Angreifer steckt eine angeblich von Anna stammende Rumor in sein eigenes Siegel.
      final rumor = GiftWrap.rumor(absenderPub: annaPub, empfaengerPub: benPub, inhalt: 'gefälscht');
      final h = GiftWrap.einpacken(rumor: rumor, absenderPrivat: fremd, empfaengerPub: benPub);
      expect(GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub), isNull);
      expect(GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub, erwarteterAbsender: annaPub), isNull);
    });

    test('Verfälschte Hülle, Siegel oder Rumor werden verworfen', () {
      final echt = huelle('echt');
      expect(GiftWrap.auspacken({...echt, 'content': huelle('anders')['content']}, meinPrivat: ben, meinPub: benPub),
          isNull, reason: 'Inhalt getauscht, Signatur passt nicht mehr');
      expect(GiftWrap.auspacken({...echt, 'sig': 'a' * 128}, meinPrivat: ben, meinPub: benPub), isNull);
      expect(GiftWrap.auspacken({...echt, 'kind': 4}, meinPrivat: ben, meinPub: benPub), isNull);

      // Siegel mit Tags, falscher Art oder geänderter Rumor-id, jeweils in einer korrekt signierten Hülle.
      Map<String, dynamic> umSiegel(Map<String, dynamic> siegel) {
        final wegwerf = keys.generatePrivateKey();
        return events
            .finishEvent(
                Event(
                  kind: 1059,
                  tags: [
                    ['p', benPub]
                  ],
                  content: Nip44.encrypt(jsonEncode(siegel), Nip44.conversationKey(wegwerf, benPub)),
                  created_at: jetzt(),
                ),
                wegwerf)
            .toJson();
      }

      Map<String, dynamic> siegel(Map<String, dynamic> rumor, {int kind = 13, List<List<String>> tags = const []}) =>
          events
              .finishEvent(
                  Event(
                    kind: kind,
                    tags: tags,
                    content: GiftWrap.verschluesseln(jsonEncode(rumor), anna, benPub),
                    created_at: jetzt(),
                  ),
                  anna)
              .toJson();

      final rumor = GiftWrap.rumor(absenderPub: annaPub, empfaengerPub: benPub, inhalt: 'Hallo');
      expect(GiftWrap.auspacken(umSiegel(siegel(rumor)), meinPrivat: ben, meinPub: benPub), isNotNull,
          reason: 'Gegenprobe: so gebaut ist es gültig');
      expect(
          GiftWrap.auspacken(
              umSiegel(siegel(rumor, tags: [
                ['p', benPub]
              ])),
              meinPrivat: ben,
              meinPub: benPub),
          isNull);
      expect(GiftWrap.auspacken(umSiegel(siegel(rumor, kind: 14)), meinPrivat: ben, meinPub: benPub), isNull);
      expect(GiftWrap.auspacken(umSiegel(siegel({...rumor, 'content': 'anders'})), meinPrivat: ben, meinPub: benPub),
          isNull, reason: 'Rumor-id passt nicht zum Inhalt');
      expect(GiftWrap.auspacken(umSiegel(siegel({...rumor, 'kind': 4})), meinPrivat: ben, meinPub: benPub), isNull);
      final anAndere = GiftWrap.rumor(absenderPub: annaPub, empfaengerPub: annaPub, inhalt: 'Hallo');
      expect(GiftWrap.auspacken(umSiegel(siegel(anAndere)), meinPrivat: ben, meinPub: benPub), isNull,
          reason: 'Rumor an jemand anderen');
    });

    test('Hülle an einen anderen Empfänger wird verworfen', () {
      final h = huelle('x', an: annaPub);
      expect(NostrEventCheck.isValidGiftWrap(h, recipient: benPub), isFalse);
      expect(GiftWrap.auspacken(h, meinPrivat: ben, meinPub: benPub), isNull);
    });
  });

  group('Paar-Kanal', () {
    final nostr = NostrService();
    late String myPub;
    late String partnerPriv;
    late String partnerPub;
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

    /// Nachricht des Gegenübers per NIP-04 (alte Version: ohne Ankündigung).
    Map<String, dynamic> dm(Map<String, dynamic> payload,
            {String? von, int kind = 4, List<List<String>> tags = const [], int? zeit}) =>
        events
            .finishEvent(
              Event(
                kind: kind,
                tags: [
                  ...tags,
                  ['p', myPub]
                ],
                content: Nip04().encrypt(von ?? partnerPriv, myPub, jsonEncode(payload)),
                created_at: zeit ?? jetzt(),
                verify: false,
              ),
              von ?? partnerPriv,
            )
            .toJson();

    Map<String, dynamic> wrap(Map<String, dynamic> payload, {String? von, int? zeit}) {
      final absender = von ?? partnerPriv;
      return GiftWrap.einpacken(
        rumor: GiftWrap.rumor(
            absenderPub: keys.getPublicKey(absender), empfaengerPub: myPub, inhalt: jsonEncode(payload), zeit: zeit),
        absenderPrivat: absender,
        empfaengerPub: myPub,
      );
    }

    /// Was das Gegenüber aus einer gesendeten Nachricht liest (kind 4 oder Gift Wrap).
    Map<String, dynamic> lesen(Map<String, dynamic> ev) {
      if (ev['kind'] == 1059) {
        final offen = GiftWrap.auspacken(ev, meinPrivat: partnerPriv, meinPub: partnerPub, erwarteterAbsender: myPub)!;
        return jsonDecode(offen.rumor['content'] as String) as Map<String, dynamic>;
      }
      final content = ev['content'] as String;
      final klar = content.contains('?iv=')
          ? Nip04().decrypt(partnerPriv, myPub, content)
          : GiftWrap.entschluesseln(content, partnerPriv, myPub);
      return jsonDecode(klar) as Map<String, dynamic>;
    }

    test('neu ↔ alt: ohne Ankündigung bleibt es bei NIP-04, mit "nip17": 1 im Inhalt', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hallo von alt'}));
      expect(nostr.partnerNip17, isFalse);
      expect(await nostr.sendChatMessage('Hallo zurück'), isTrue);
      final ev = gesendet.single;
      expect(ev['kind'], 4);
      expect(ev['pubkey'], myPub);
      final inhalt = lesen(ev);
      expect(inhalt['text'], 'Hallo zurück');
      expect(inhalt['nip17'], 1);
      // Die eigene Nachricht steht ohne Zusatzfeld im Verlauf.
      expect(nostr.messagesNotifier.value.last.text, 'Hallo zurück');
    });

    test('neu ↔ neu: nach der Ankündigung geht alles per Gift Wrap', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hallo', 'nip17': 1}));
      expect(nostr.partnerNip17, isTrue);
      expect(await nostr.sendChatMessage('Jetzt privat', verschwindet: true), isTrue);
      final ev = gesendet.single;
      expect(ev['kind'], 1059);
      expect(ev['pubkey'], isNot(myPub));
      expect((ev['tags'] as List).any((t) => t[0] == 'expiration'), isTrue, reason: 'Ablauf auf der Hülle');
      expect(lesen(ev)['text'], 'Jetzt privat');
      expect(lesen(ev).containsKey('nip17'), isFalse);
      // Keine Kopie an sich selbst.
      expect(gesendet.where((e) => (e['tags'] as List).any((t) => t[0] == 'p' && t[1] == myPub)), isEmpty);
      // Bleibt nach einem Neustart erhalten.
      await nostr.reloadKeysFromPrefs();
      expect(nostr.partnerNip17, isTrue);
    });

    test('Eine NIP-17-Nachricht zählt als Ankündigung; echter Zeitpunkt aus der Rumor, keine Doppelten', () async {
      final zeit = jetzt() - 3600;
      final payload = {'type': 'chat', 'text': 'Per Gift Wrap'};
      final rumor =
          GiftWrap.rumor(absenderPub: partnerPub, empfaengerPub: myPub, inhalt: jsonEncode(payload), zeit: zeit);
      final h1 = GiftWrap.einpacken(rumor: rumor, absenderPrivat: partnerPriv, empfaengerPub: myPub);
      final h2 = GiftWrap.einpacken(rumor: rumor, absenderPrivat: partnerPriv, empfaengerPub: myPub);
      await nostr.handleGiftWrap(h1);
      await nostr.handleGiftWrap(h2); // andere Hülle, gleiche Rumor (z. B. von einem zweiten Server)
      await nostr.handleGiftWrap(h1);
      final nachrichten = nostr.messagesNotifier.value.where((m) => m.text == 'Per Gift Wrap').toList();
      expect(nachrichten, hasLength(1));
      expect(nachrichten.single.id, rumor['id']);
      expect(nachrichten.single.createdAt.millisecondsSinceEpoch ~/ 1000, zeit);
      expect(nachrichten.single.isMe, isFalse);
      expect(nostr.partnerNip17, isTrue);
    });

    test('Gift Wrap von Fremden zählt nicht, auch nicht als Ankündigung', () async {
      final fremd = keys.generatePrivateKey();
      await nostr.handleGiftWrap(wrap({'type': 'chat', 'text': 'Spam'}, von: fremd));
      expect(nostr.messagesNotifier.value.where((m) => m.text == 'Spam'), isEmpty);
      expect(nostr.partnerNip17, isFalse);
    });

    test('Gefälschte Hülle mit echter id blockiert die echte Nachricht nicht', () async {
      final echt = wrap({'type': 'chat', 'text': 'Echt'});
      await nostr.handleGiftWrap({...echt, 'sig': 'b' * 128});
      await nostr.handleGiftWrap(echt);
      expect(nostr.messagesNotifier.value.where((m) => m.text == 'Echt'), hasLength(1));
    });

    test('Rückfall: neues Gegenüber oder Trennen setzt die Ankündigung zurück', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hallo', 'nip17': 1}));
      expect(nostr.partnerNip17, isTrue);
      final neuPriv = keys.generatePrivateKey();
      await nostr.setPartner(keys.getPublicKey(neuPriv), name: 'Chris');
      expect(nostr.partnerNip17, isFalse);
      gesendet.clear();
      await nostr.sendChatMessage('Hallo Chris');
      expect(gesendet.where((e) => e['kind'] == 1059), isEmpty);
      expect(gesendet.where((e) => e['kind'] == 4), hasLength(1));

      await nostr.setPartner(partnerPub, name: 'Anna');
      expect(nostr.partnerNip17, isFalse, reason: 'auch beim alten Gegenüber erst nach neuer Ankündigung');
      await nostr.handleGiftWrap(wrap({'type': 'chat', 'text': 'wieder da'}));
      expect(nostr.partnerNip17, isTrue);
      await nostr.unpairPartner();
      expect(nostr.partnerNip17, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(NostrService.keyPartnerNip17), isNull);
    });

    test('Rückfall: das Gegenüber hat wieder eine alte Version', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'neu', 'nip17': 1}, zeit: jetzt() - 100));
      expect(nostr.partnerNip17, isTrue);
      // Eine ältere, erneut abgeholte Nachricht ohne Ankündigung ändert nichts.
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'von früher'}, zeit: jetzt() - 200));
      expect(nostr.partnerNip17, isTrue);
      // Eine neuere ohne Ankündigung: Das Gegenüber kann nur noch NIP-04.
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'wieder alt'}));
      expect(nostr.partnerNip17, isFalse);
      await nostr.sendChatMessage('Kommt an');
      expect(gesendet.single['kind'], 4);
      await nostr.reloadKeysFromPrefs();
      expect(nostr.partnerNip17, isFalse);
    });

    test('Rückfall: eine ältere Sicherung mit anderem Gegenüber schaltet NIP-17 nicht ein', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(NostrService.keyPartnerNip17, keys.getPublicKey(keys.generatePrivateKey()));
      await nostr.reloadKeysFromPrefs();
      expect(nostr.partnerNip17, isFalse);
      await nostr.sendChatMessage('Hallo');
      expect(gesendet.single['kind'], 4);
    });

    test('Verbindungsanfrage mit Ankündigung: nach dem Annehmen gleich NIP-17', () async {
      await nostr.unpairPartner();
      await nostr.startInvite('Anna');
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'Hallo, ich bin jetzt verbunden', 'nip17': 1}));
      expect(nostr.joinRequestNotifier.value, partnerPub);
      expect(nostr.partnerNip17, isFalse);
      expect(await nostr.acceptJoinRequest(), isTrue);
      expect(nostr.partnerNip17, isTrue);
      expect(gesendet.last['kind'], 1059, reason: 'die Bestätigung geht schon per Gift Wrap');
    });

    test('Fähigkeits-Signal: wird gemerkt und einmal beantwortet, per NIP-44', () async {
      nostr.handleSignal(dm({'t': 'faehig', 'nip17': 1}, kind: NostrService.signalKind));
      expect(nostr.partnerNip17, isTrue);
      await Future<void>.delayed(Duration.zero);
      // Nur Antworten zählen (das eigene Start-Signal aus dem Zeitgeber kann dazwischenkommen).
      final antworten =
          gesendet.where((e) => e['kind'] == NostrService.signalKind && lesen(e)['antwort'] == 1).toList();
      expect(antworten, hasLength(1));
      expect(antworten.single['content'], isNot(contains('?iv=')), reason: 'NIP-44');
      expect(lesen(antworten.single), {'t': 'faehig', 'nip17': 1, 'antwort': 1});

      // Auf eine Antwort wird nicht geantwortet.
      gesendet.clear();
      nostr.handleSignal(dm({'t': 'faehig', 'nip17': 1, 'antwort': 1}, kind: NostrService.signalKind));
      await Future<void>.delayed(Duration.zero);
      expect(gesendet.where((e) => e['kind'] == NostrService.signalKind && lesen(e)['antwort'] == 1), isEmpty);
    });

    test('Signale und Lesebestätigungen: NIP-04 vor, NIP-44 nach der Ankündigung, Empfang beider Formate', () async {
      final empfangen = <Map<String, dynamic>>[];
      final sub = nostr.signale.listen(empfangen.add);
      addTearDown(sub.cancel);

      await nostr.sendSignal({'t': 'da?'});
      expect(gesendet.last['content'], contains('?iv='));
      expect(lesen(gesendet.last), {'t': 'da?', 'nip17': 1});

      nostr.handleSignal(dm({'t': 'da'}, kind: NostrService.signalKind));
      expect(nostr.partnerNip17, isFalse);

      // NIP-44-Signal des Gegenübers: zählt als Ankündigung.
      final nip44Signal = events
          .finishEvent(
            Event(
              kind: NostrService.signalKind,
              tags: [
                ['p', myPub]
              ],
              content: GiftWrap.verschluesseln(jsonEncode({'t': 'hallo'}), partnerPriv, myPub),
              created_at: jetzt(),
            ),
            partnerPriv,
          )
          .toJson();
      nostr.handleSignal(nip44Signal);
      await Future<void>.delayed(Duration.zero);
      expect(empfangen.map((s) => s['t']), ['da', 'hallo']);
      expect(nostr.partnerNip17, isTrue);

      gesendet.clear();
      await nostr.sendSignal({'t': 'da?'});
      expect(gesendet.single['kind'], NostrService.signalKind);
      expect(gesendet.single['pubkey'], myPub, reason: 'Signale ohne Hülle');
      expect(gesendet.single['content'], isNot(contains('?iv=')));
      expect(lesen(gesendet.single), {'t': 'da?'});

      // Lesebestätigung des Gegenübers per NIP-44.
      final receipt = events
          .finishEvent(
            Event(
              kind: NostrService.readReceiptKind,
              tags: [
                ['d', 'velvet-read'],
                ['p', myPub]
              ],
              content: GiftWrap.verschluesseln(jsonEncode({'read_until': 1234}), partnerPriv, myPub),
              created_at: jetzt(),
            ),
            partnerPriv,
          )
          .toJson();
      await nostr.handleReadReceipt(receipt);
      expect(nostr.partnerReadUntil.value, 1234);

      gesendet.clear();
      await nostr.setReadReceiptsEnabled(false);
      expect(gesendet.single['kind'], NostrService.readReceiptKind);
      expect(lesen(gesendet.single), {'off': true});
      expect(gesendet.single['content'], isNot(contains('?iv=')));
    });

    test('Ja/Nein-Liste: Einzelstimmen für alte Versionen nur ohne NIP-17', () async {
      await nostr.syncAllYesNoMaybeVotes({'a': 'yes', 'b': 'no'});
      expect(gesendet.where((e) => e['kind'] == 4), hasLength(3));
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'nip17': 1}));
      gesendet.clear();
      await nostr.syncAllYesNoMaybeVotes({'a': 'yes', 'b': 'no'});
      expect(gesendet, hasLength(1));
      expect(lesen(gesendet.single)['votes'], {'a': 'yes', 'b': 'no'});
    });

    test('Die Ankündigung ist Teil der Sicherung', () async {
      await nostr.handleIncomingKind4Map(dm({'type': 'chat', 'text': 'x', 'nip17': 1}));
      await Future<void>.delayed(Duration.zero);
      final export = StorageService.exportAllUserData();
      expect(export['nostrPartnerNip17'], partnerPub);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(NostrService.keyPartnerNip17);
      await StorageService.importBackup(BackupCodec.validate(export));
      expect(nostr.partnerNip17, isTrue);
      expect(() => BackupCodec.validate({...export, 'nostrPartnerNip17': 'kaputt'}), throwsA(isA<BackupException>()));
    });
  });
}
