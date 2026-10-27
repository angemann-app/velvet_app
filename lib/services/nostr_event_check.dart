import 'package:nostr_tools/nostr_tools.dart';

/// Prüft ein eingehendes Nostr-Event (NIP-01), bevor es irgendetwas verändert.
///
/// Relays sind nicht vertrauenswürdig. Ein Event zählt nur, wenn
/// - alle Pflichtfelder den richtigen Typ und eine vernünftige Größe haben,
/// - die ID wirklich der SHA-256 seiner kanonischen Serialisierung ist,
/// - die Schnorr-Signatur (BIP-340) zu ID und Absender passt,
/// - es an [recipient] adressiert ist (p-Tag).
///
/// Für NIP-17 (Gift Wrap, NIP-59) gibt es drei Stufen: Hülle ([isValidGiftWrap]), Siegel ([isValidSeal])
/// und die unsignierte Rumor ([isValidRumor]). Erst wenn alle drei passen, zählt die Nachricht.
///
/// Hinweis: `nostr_tools` 1.0.9 prüft im `Event`-Konstruktor trotz Parameter
/// `verify` nichts (auskommentiert), darum wird hier ausdrücklich geprüft.
class NostrEventCheck {
  static const int maxContentLength = 64 * 1024;
  static const Duration maxClockSkew = Duration(minutes: 10);

  /// Arten für NIP-17: Hülle, Siegel, private Direktnachricht (Rumor).
  static const int giftWrapKind = 1059;
  static const int sealKind = 13;
  static const int rumorKind = 14;

  /// Größter NIP-44-Payload (Base64 von 65603 Bytes). Die Hülle enthält das verschlüsselte Siegel,
  /// das wiederum die verschlüsselte Rumor enthält, darum darf sie größer sein als eine kind-4-Nachricht.
  static const int maxNip44Length = 87472;

  static final RegExp _hex64 = RegExp(r'^[0-9a-f]{64}$');
  static final RegExp _hex128 = RegExp(r'^[0-9a-f]{128}$');
  static final EventApi _eventApi = EventApi();

  static bool isValidDirectMessage(Map<String, dynamic> ev, {required String recipient, DateTime? now}) =>
      isValidEvent(ev, recipient: recipient, kind: 4, now: now);

  /// Wie [isValidDirectMessage], aber für eine andere Event-Art (z. B. 30078 für Lesebestätigungen).
  static bool isValidEvent(Map<String, dynamic> ev,
      {required String recipient, required int kind, DateTime? now, int maxContent = maxContentLength}) {
    final tags = _gepruefteFelder(ev, kind: kind, now: now, maxContent: maxContent);
    if (tags == null || !_hatEmpfaenger(tags, recipient)) return false;
    return _signaturStimmt(ev, tags);
  }

  /// Hülle (kind 1059): signiert vom Wegwerf-Schlüssel, an [recipient] adressiert.
  static bool isValidGiftWrap(Map<String, dynamic> ev, {required String recipient, DateTime? now}) =>
      isValidEvent(ev, recipient: recipient, kind: giftWrapKind, now: now, maxContent: maxNip44Length);

  /// Siegel (kind 13): signiert vom echten Absender, ohne Tags (NIP-59). Ist [sender] gesetzt,
  /// muss es genau von diesem Schlüssel stammen.
  static bool isValidSeal(Map<String, dynamic> ev, {String? sender, DateTime? now}) {
    final tags = _gepruefteFelder(ev, kind: sealKind, now: now, maxContent: maxNip44Length);
    if (tags == null || tags.isNotEmpty) return false;
    if (sender != null && ev['pubkey'] != sender) return false;
    return _signaturStimmt(ev, tags);
  }

  /// Rumor (kind 14, unsigniert): Die ID muss stimmen, der Absender muss der des Siegels sein
  /// (sonst könnte jemand eine fremde Nachricht in sein eigenes Siegel stecken), und sie muss
  /// an [recipient] gehen.
  static bool isValidRumor(Map<String, dynamic> rumor,
      {required String sealPubkey, required String recipient, DateTime? now}) {
    if (rumor.containsKey('sig') && rumor['sig'] != null && rumor['sig'] != '') return false;
    final tags = _gepruefteFelder(rumor, kind: rumorKind, now: now, maxContent: maxContentLength, signiert: false);
    if (tags == null || rumor['pubkey'] != sealPubkey || !_hatEmpfaenger(tags, recipient)) return false;
    try {
      return _eventApi.getEventHash(_event(rumor, tags)) == rumor['id'];
    } catch (_) {
      return false;
    }
  }

  /// Gemeinsame Formprüfung; gibt die Tags zurück oder null.
  static List<List<String>>? _gepruefteFelder(Map<String, dynamic> ev,
      {required int kind, DateTime? now, required int maxContent, bool signiert = true}) {
    final id = ev['id'];
    final pubkey = ev['pubkey'];
    final sig = ev['sig'];
    final createdAt = ev['created_at'];
    final content = ev['content'];
    final rawTags = ev['tags'];

    if (id is! String || !_hex64.hasMatch(id)) return null;
    if (pubkey is! String || !_hex64.hasMatch(pubkey)) return null;
    if (signiert && (sig is! String || !_hex128.hasMatch(sig))) return null;
    if (ev['kind'] != kind) return null;
    if (content is! String || content.isEmpty || content.length > maxContent) return null;
    if (createdAt is! int || createdAt <= 0) return null;
    final latest = (now ?? DateTime.now()).add(maxClockSkew).millisecondsSinceEpoch ~/ 1000;
    if (createdAt > latest) return null;
    if (rawTags is! List || rawTags.length > 50) return null;

    final tags = <List<String>>[];
    for (final tag in rawTags) {
      if (tag is! List || tag.any((e) => e is! String)) return null;
      tags.add(tag.cast<String>());
    }
    return tags;
  }

  static bool _hatEmpfaenger(List<List<String>> tags, String recipient) =>
      tags.any((t) => t.length >= 2 && t[0] == 'p' && t[1] == recipient);

  static Event _event(Map<String, dynamic> ev, List<List<String>> tags) => Event(
        kind: ev['kind'] as int,
        tags: tags,
        content: ev['content'] as String,
        created_at: ev['created_at'] as int,
        id: ev['id'] as String,
        sig: ev['sig'] is String ? ev['sig'] as String : '',
        pubkey: ev['pubkey'] as String,
        verify: false,
      );

  static bool _signaturStimmt(Map<String, dynamic> ev, List<List<String>> tags) {
    try {
      final event = _event(ev, tags);
      if (_eventApi.getEventHash(event) != ev['id']) return false;
      return _eventApi.verifySignature(event);
    } catch (_) {
      return false;
    }
  }
}
