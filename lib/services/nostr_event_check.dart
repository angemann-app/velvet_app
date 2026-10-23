import 'package:nostr_tools/nostr_tools.dart';

/// Prüft ein eingehendes Nostr-Event (NIP-01), bevor es irgendetwas verändert.
///
/// Relays sind nicht vertrauenswürdig. Ein Event zählt nur, wenn
/// - alle Pflichtfelder den richtigen Typ und eine vernünftige Größe haben,
/// - die ID wirklich der SHA-256 seiner kanonischen Serialisierung ist,
/// - die Schnorr-Signatur (BIP-340) zu ID und Absender passt,
/// - es an [recipient] adressiert ist (p-Tag).
///
/// Hinweis: `nostr_tools` 1.0.9 prüft im `Event`-Konstruktor trotz Parameter
/// `verify` nichts (auskommentiert), darum wird hier ausdrücklich geprüft.
class NostrEventCheck {
  static const int maxContentLength = 64 * 1024;
  static const Duration maxClockSkew = Duration(minutes: 10);

  static final RegExp _hex64 = RegExp(r'^[0-9a-f]{64}$');
  static final RegExp _hex128 = RegExp(r'^[0-9a-f]{128}$');
  static final EventApi _eventApi = EventApi();

  static bool isValidDirectMessage(Map<String, dynamic> ev, {required String recipient, DateTime? now}) {
    final id = ev['id'];
    final pubkey = ev['pubkey'];
    final sig = ev['sig'];
    final kind = ev['kind'];
    final createdAt = ev['created_at'];
    final content = ev['content'];
    final rawTags = ev['tags'];

    if (id is! String || !_hex64.hasMatch(id)) return false;
    if (pubkey is! String || !_hex64.hasMatch(pubkey)) return false;
    if (sig is! String || !_hex128.hasMatch(sig)) return false;
    if (kind != 4) return false;
    if (content is! String || content.isEmpty || content.length > maxContentLength) return false;
    if (createdAt is! int || createdAt <= 0) return false;
    final latest = (now ?? DateTime.now()).add(maxClockSkew).millisecondsSinceEpoch ~/ 1000;
    if (createdAt > latest) return false;
    if (rawTags is! List || rawTags.length > 50) return false;

    final tags = <List<String>>[];
    for (final tag in rawTags) {
      if (tag is! List || tag.any((e) => e is! String)) return false;
      tags.add(tag.cast<String>());
    }
    if (!tags.any((t) => t.length >= 2 && t[0] == 'p' && t[1] == recipient)) return false;

    try {
      final event = Event(
        kind: kind,
        tags: tags,
        content: content,
        created_at: createdAt,
        id: id,
        sig: sig,
        pubkey: pubkey,
        verify: false,
      );
      if (_eventApi.getEventHash(event) != id) return false;
      return _eventApi.verifySignature(event);
    } catch (_) {
      return false;
    }
  }
}
