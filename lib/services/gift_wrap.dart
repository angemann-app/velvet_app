import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:nostr_tools/nostr_tools.dart';

import 'nip44.dart';
import 'nostr_event_check.dart';

/// Private Direktnachrichten nach NIP-17 mit Gift Wrap (NIP-59):
///
///   Rumor (kind 14, unsigniert, echter Absender und echter Zeitpunkt)
///   → Siegel (kind 13, signiert vom echten Absender, Inhalt: Rumor per NIP-44 an den Empfänger)
///   → Hülle (kind 1059, signiert von einem Wegwerf-Schlüssel, `p`-Tag Empfänger, Inhalt: Siegel per NIP-44)
///
/// Die Server sehen nur „irgendwer schreibt an diesen Empfänger“. Der Zeitstempel von Siegel und Hülle
/// wird zufällig bis zu zwei Tage zurückgesetzt; der echte steht nur in der Rumor.
/// Keine Kopie an sich selbst (Konzept docs/konzepte/nip17.md, Entscheidung 5).
class GiftWrap {
  /// So weit dürfen die sichtbaren Zeitstempel zurückliegen (NIP-59). Beim Abholen entsprechend früher anfragen.
  static const Duration maxZurueck = Duration(days: 2);

  static final Random _zufall = Random.secure();
  static final KeyApi _keys = KeyApi();
  static final EventApi _events = EventApi();

  /// Gemeinsame Schlüssel je Paar zwischenspeichern: ECDH ist in reinem Dart nicht billig.
  static final Map<String, Uint8List> _convCache = {};

  static Uint8List conversationKey(String privat, String oeffentlich) {
    final schluessel = '$privat:$oeffentlich';
    final vorhanden = _convCache[schluessel];
    if (vorhanden != null) return vorhanden;
    if (_convCache.length > 16) _convCache.clear();
    return _convCache[schluessel] = Nip44.conversationKey(privat, oeffentlich);
  }

  static String verschluesseln(String klartext, String privat, String oeffentlich) =>
      Nip44.encrypt(klartext, conversationKey(privat, oeffentlich));

  static String entschluesseln(String payload, String privat, String oeffentlich) =>
      Nip44.decrypt(payload, conversationKey(privat, oeffentlich));

  /// Unsignierte Rumor mit berechneter id.
  static Map<String, dynamic> rumor({
    required String absenderPub,
    required String empfaengerPub,
    required String inhalt,
    int? zeit,
    int kind = NostrEventCheck.rumorKind,
  }) {
    final ev = Event(
      kind: kind,
      tags: [
        ['p', empfaengerPub]
      ],
      content: inhalt,
      created_at: zeit ?? _jetzt(),
      pubkey: absenderPub,
      verify: false,
    );
    ev.id = _events.getEventHash(ev);
    return {
      'id': ev.id,
      'pubkey': ev.pubkey,
      'created_at': ev.created_at,
      'kind': ev.kind,
      'tags': ev.tags,
      'content': ev.content,
    };
  }

  /// Packt [rumor] in Siegel und Hülle. [huellenTags] landen zusätzlich auf der Hülle (z. B. `expiration`,
  /// damit die Server sie löschen). [wegwerfSchluessel] nur für Tests.
  static Map<String, dynamic> einpacken({
    required Map<String, dynamic> rumor,
    required String absenderPrivat,
    required String empfaengerPub,
    List<List<String>> huellenTags = const [],
    String? wegwerfSchluessel,
  }) {
    final siegel = _events.finishEvent(
      Event(
        kind: NostrEventCheck.sealKind,
        tags: [],
        content: verschluesseln(jsonEncode(rumor), absenderPrivat, empfaengerPub),
        created_at: zufallsZeit(),
      ),
      absenderPrivat,
    );
    final wegwerf = wegwerfSchluessel ?? _keys.generatePrivateKey();
    // Der Wegwerf-Schlüssel wird nur einmal gebraucht; nicht im Zwischenspeicher behalten.
    final huelle = _events.finishEvent(
      Event(
        kind: NostrEventCheck.giftWrapKind,
        tags: [
          ['p', empfaengerPub],
          ...huellenTags,
        ],
        content: Nip44.encrypt(jsonEncode(siegel.toJson()), Nip44.conversationKey(wegwerf, empfaengerPub)),
        created_at: zufallsZeit(),
      ),
      wegwerf,
    );
    return huelle.toJson();
  }

  /// Öffnet eine Hülle und prüft alle drei Stufen (NostrEventCheck). Ist [erwarteterAbsender] gesetzt,
  /// zählt nur ein Siegel von diesem Schlüssel. null, wenn irgendetwas nicht passt.
  static ({Map<String, dynamic> rumor, String absender})? auspacken(
    Map<String, dynamic> huelle, {
    required String meinPrivat,
    required String meinPub,
    String? erwarteterAbsender,
    DateTime? now,
  }) {
    if (!NostrEventCheck.isValidGiftWrap(huelle, recipient: meinPub, now: now)) return null;
    try {
      // Der Wegwerf-Schlüssel kommt nie wieder: nicht zwischenspeichern.
      final siegelText = Nip44.decrypt(
          huelle['content'] as String, Nip44.conversationKey(meinPrivat, huelle['pubkey'] as String));
      final siegel = jsonDecode(siegelText);
      if (siegel is! Map<String, dynamic>) return null;
      if (!NostrEventCheck.isValidSeal(siegel, sender: erwarteterAbsender, now: now)) return null;
      final absender = siegel['pubkey'] as String;
      final rumorText = entschluesseln(siegel['content'] as String, meinPrivat, absender);
      final rumor = jsonDecode(rumorText);
      if (rumor is! Map<String, dynamic>) return null;
      if (!NostrEventCheck.isValidRumor(rumor, sealPubkey: absender, recipient: meinPub, now: now)) return null;
      return (rumor: rumor, absender: absender);
    } catch (_) {
      return null;
    }
  }

  /// Jetzt minus zufällig bis zu zwei Tage.
  static int zufallsZeit() => _jetzt() - _zufall.nextInt(maxZurueck.inSeconds);

  static int _jetzt() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
