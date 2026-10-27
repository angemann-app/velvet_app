import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/nip44.dart';

/// Prüft lib/services/nip44.dart gegen die offiziellen Testvektoren von NIP-44 v2.
/// Quelle: https://github.com/paulmillr/nip44 (Datei nip44.vectors.json, MIT-Lizenz),
/// abgelegt unter test/daten/nip44.vectors.json.
void main() {
  final vektoren = (jsonDecode(File('test/daten/nip44.vectors.json').readAsStringSync()) as Map)['v2'] as Map;
  final gueltig = vektoren['valid'] as Map;
  final ungueltig = vektoren['invalid'] as Map;
  final keys = KeyApi();

  test('get_conversation_key', () {
    for (final v in gueltig['get_conversation_key'] as List) {
      expect(Nip44.bytesHex(Nip44.conversationKey(v['sec1'], v['pub2'])), v['conversation_key'], reason: '${v['note']}');
    }
  });

  test('get_message_keys', () {
    final mk = gueltig['get_message_keys'] as Map;
    final conv = Nip44.hexBytes(mk['conversation_key']);
    for (final v in mk['keys'] as List) {
      final k = Nip44.messageKeys(conv, Nip44.hexBytes(v['nonce']));
      expect(Nip44.bytesHex(k.chachaKey), v['chacha_key']);
      expect(Nip44.bytesHex(k.chachaNonce), v['chacha_nonce']);
      expect(Nip44.bytesHex(k.hmacKey), v['hmac_key']);
    }
  });

  test('calc_padded_len', () {
    for (final v in gueltig['calc_padded_len'] as List) {
      expect(Nip44.calcPaddedLen(v[0] as int), v[1]);
    }
  });

  test('encrypt_decrypt', () {
    for (final v in gueltig['encrypt_decrypt'] as List) {
      final pub2 = keys.getPublicKey(v['sec2']);
      final conv = Nip44.conversationKey(v['sec1'], pub2);
      expect(Nip44.bytesHex(conv), v['conversation_key']);
      // In beide Richtungen derselbe Schlüssel.
      expect(Nip44.bytesHex(Nip44.conversationKey(v['sec2'], keys.getPublicKey(v['sec1']))), v['conversation_key']);
      final payload = Nip44.encrypt(v['plaintext'], conv, nonce: Nip44.hexBytes(v['nonce']));
      expect(payload, v['payload']);
      expect(Nip44.decrypt(payload, conv), v['plaintext']);
    }
  });

  test('encrypt_decrypt_long_msg', () {
    for (final v in gueltig['encrypt_decrypt_long_msg'] as List) {
      final klartext = (v['pattern'] as String) * (v['repeat'] as int);
      expect(sha256.convert(utf8.encode(klartext)).toString(), v['plaintext_sha256']);
      final conv = Nip44.hexBytes(v['conversation_key']);
      final payload = Nip44.encrypt(klartext, conv, nonce: Nip44.hexBytes(v['nonce']));
      expect(sha256.convert(utf8.encode(payload)).toString(), v['payload_sha256']);
      expect(Nip44.decrypt(payload, conv), klartext);
    }
  });

  test('ungültige Längen werden nicht verschlüsselt', () {
    final conv = Nip44.zufallsBytes(32);
    for (final laenge in ungueltig['encrypt_msg_lengths'] as List) {
      expect(() => Nip44.encrypt('a' * (laenge as int), conv), throwsArgumentError, reason: '$laenge');
    }
  });

  test('ungültige Schlüssel werden abgelehnt', () {
    for (final v in ungueltig['get_conversation_key'] as List) {
      expect(() => Nip44.conversationKey(v['sec1'], v['pub2']), throwsArgumentError, reason: '${v['note']}');
    }
  });

  test('verfälschte Payloads werden abgelehnt', () {
    for (final v in ungueltig['decrypt'] as List) {
      expect(() => Nip44.decrypt(v['payload'], Nip44.hexBytes(v['conversation_key'])), throwsFormatException,
          reason: '${v['note']}');
    }
  });

  test('Zufalls-Nonce: gleicher Text, verschiedene Payloads', () {
    final a = keys.generatePrivateKey(), b = keys.generatePrivateKey();
    final conv = Nip44.conversationKey(a, keys.getPublicKey(b));
    final p1 = Nip44.encrypt('Hallo ✨', conv), p2 = Nip44.encrypt('Hallo ✨', conv);
    expect(p1, isNot(p2));
    expect(Nip44.decrypt(p2, Nip44.conversationKey(b, keys.getPublicKey(a))), 'Hallo ✨');
  });
}
