import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

/// NIP-44 Version 2: Verschlüsselung für Nostr (ECDH secp256k1, HKDF-SHA256, ChaCha20, HMAC-SHA256,
/// Längen-Auffüllung). Spezifikation: https://github.com/nostr-protocol/nips/blob/master/44.md
///
/// Selbst umgesetzt, weil `nostr_tools` 1.0.9 nur NIP-04 kann. Alles synchron, ohne neue Abhängigkeit:
/// Kurve und ChaCha20 (RFC 8439) aus `pointycastle`, HMAC-SHA256 aus `crypto`. Geprüft gegen die
/// offiziellen Testvektoren (test/nip44_test.dart, test/daten/nip44.vectors.json).
class Nip44 {
  static const int version = 2;
  static const int minPlaintext = 1;
  static const int maxPlaintext = 65535;

  static final ECDomainParameters _kurve = ECCurve_secp256k1();
  static final BigInt _p =
      BigInt.parse('fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f', radix: 16);
  static final Random _zufall = Random.secure();
  static final Uint8List _salz = Uint8List.fromList(utf8.encode('nip44-v2'));

  /// Gemeinsamer Schlüssel zweier Personen (in beide Richtungen gleich):
  /// HKDF-extract(salt = "nip44-v2", IKM = x-Koordinate von ECDH(privat, öffentlich)).
  /// Wirft [ArgumentError] bei ungültigen Schlüsseln.
  static Uint8List conversationKey(String privatHex, String oeffentlichHex) {
    final d = _hexZahl(privatHex);
    if (d == BigInt.zero || d >= _kurve.n) throw ArgumentError('ungültiger privater Schlüssel');
    final x = _hexZahl(oeffentlichHex);
    if (x == BigInt.zero || x >= _p) throw ArgumentError('ungültiger öffentlicher Schlüssel');
    final ECPoint? punkt;
    try {
      // Öffentliche Nostr-Schlüssel sind nur die x-Koordinate, y ist gerade (BIP-340): Präfix 02.
      punkt = _kurve.curve.decodePoint([2, ..._bytes32(x)]);
    } catch (_) {
      throw ArgumentError('öffentlicher Schlüssel liegt nicht auf der Kurve');
    }
    if (punkt == null || punkt.isInfinity) throw ArgumentError('ungültiger öffentlicher Schlüssel');
    final geteilt = (punkt * d)!;
    if (geteilt.isInfinity) throw ArgumentError('ungültiger gemeinsamer Punkt');
    return _hmac(_salz, _bytes32(geteilt.x!.toBigInteger()!));
  }

  /// Gepolsterte Länge für [laenge] Bytes Klartext (ohne die zwei Längen-Bytes).
  static int calcPaddedLen(int laenge) {
    if (laenge <= 0) throw ArgumentError('zu kurz');
    if (laenge <= 32) return 32;
    final naechste = 1 << ((laenge - 1).bitLength);
    final stueck = naechste <= 256 ? 32 : naechste ~/ 8;
    return stueck * (((laenge - 1) ~/ stueck) + 1);
  }

  /// Schlüssel für eine einzelne Nachricht: HKDF-expand(PRK = conversationKey, info = nonce, L = 76).
  static ({Uint8List chachaKey, Uint8List chachaNonce, Uint8List hmacKey}) messageKeys(
      Uint8List conversationKey, Uint8List nonce) {
    if (conversationKey.length != 32) throw ArgumentError('conversationKey muss 32 Bytes haben');
    if (nonce.length != 32) throw ArgumentError('nonce muss 32 Bytes haben');
    final okm = BytesBuilder();
    var t = Uint8List(0);
    for (var i = 1; okm.length < 76; i++) {
      t = _hmac(conversationKey, Uint8List.fromList([...t, ...nonce, i]));
      okm.add(t);
    }
    final b = okm.toBytes();
    return (
      chachaKey: Uint8List.sublistView(b, 0, 32),
      chachaNonce: Uint8List.sublistView(b, 32, 44),
      hmacKey: Uint8List.sublistView(b, 44, 76),
    );
  }

  /// Verschlüsselt [klartext] (1 bis 65535 Bytes UTF-8) zu einem Base64-Payload.
  /// [nonce] nur für Tests; sonst 32 Zufallsbytes.
  static String encrypt(String klartext, Uint8List conversationKey, {Uint8List? nonce}) {
    final n = nonce ?? zufallsBytes(32);
    final keys = messageKeys(conversationKey, n);
    final roh = utf8.encode(klartext);
    if (roh.length < minPlaintext || roh.length > maxPlaintext) {
      throw ArgumentError('Klartext muss 1 bis 65535 Bytes lang sein');
    }
    final gepolstert = Uint8List(2 + calcPaddedLen(roh.length))
      ..[0] = roh.length >> 8
      ..[1] = roh.length & 0xff
      ..setRange(2, 2 + roh.length, roh);
    final geheim = _chacha(keys.chachaKey, keys.chachaNonce, gepolstert);
    final mac = _hmac(keys.hmacKey, Uint8List.fromList([...n, ...geheim]));
    return base64.encode([version, ...n, ...geheim, ...mac]);
  }

  /// Entschlüsselt einen Payload. Wirft [FormatException], wenn er ungültig oder verfälscht ist.
  static String decrypt(String payload, Uint8List conversationKey) {
    if (payload.isEmpty || payload.startsWith('#')) throw const FormatException('unbekannte Version');
    if (payload.length < 132 || payload.length > 87472) throw const FormatException('ungültige Länge');
    final Uint8List daten;
    try {
      daten = base64.decode(payload);
    } catch (_) {
      throw const FormatException('kein Base64');
    }
    if (daten.length < 99 || daten.length > 65603) throw const FormatException('ungültige Länge');
    if (daten[0] != version) throw const FormatException('unbekannte Version');
    final nonce = Uint8List.sublistView(daten, 1, 33);
    final geheim = Uint8List.sublistView(daten, 33, daten.length - 32);
    final mac = Uint8List.sublistView(daten, daten.length - 32);
    final keys = messageKeys(conversationKey, nonce);
    final erwartet = _hmac(keys.hmacKey, Uint8List.fromList([...nonce, ...geheim]));
    if (!_gleich(erwartet, mac)) throw const FormatException('Prüfsumme falsch');
    final gepolstert = _chacha(keys.chachaKey, keys.chachaNonce, geheim);
    if (gepolstert.length < 2) throw const FormatException('ungültige Auffüllung');
    final laenge = (gepolstert[0] << 8) | gepolstert[1];
    if (laenge < minPlaintext || gepolstert.length != 2 + calcPaddedLen(laenge)) {
      throw const FormatException('ungültige Auffüllung');
    }
    try {
      return utf8.decode(Uint8List.sublistView(gepolstert, 2, 2 + laenge));
    } catch (_) {
      throw const FormatException('kein UTF-8');
    }
  }

  static Uint8List zufallsBytes(int anzahl) =>
      Uint8List.fromList(List<int>.generate(anzahl, (_) => _zufall.nextInt(256)));

  static Uint8List _chacha(Uint8List key, Uint8List nonce, Uint8List eingabe) {
    final engine = ChaCha7539Engine()..init(true, ParametersWithIV(KeyParameter(key), nonce));
    return engine.process(eingabe);
  }

  static Uint8List _hmac(List<int> key, List<int> nachricht) =>
      Uint8List.fromList(Hmac(sha256, key).convert(nachricht).bytes);

  /// Vergleich in konstanter Zeit.
  static bool _gleich(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static BigInt _hexZahl(String hex) {
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(hex)) throw ArgumentError('64 Hex-Zeichen erwartet');
    return BigInt.parse(hex, radix: 16);
  }

  static Uint8List _bytes32(BigInt zahl) {
    final b = Uint8List(32);
    var z = zahl;
    for (var i = 31; i >= 0; i--) {
      b[i] = (z & BigInt.from(0xff)).toInt();
      z = z >> 8;
    }
    return b;
  }

  static Uint8List hexBytes(String hex) =>
      Uint8List.fromList([for (var i = 0; i < hex.length; i += 2) int.parse(hex.substring(i, i + 2), radix: 16)]);

  static String bytesHex(List<int> b) => [for (final x in b) x.toRadixString(16).padLeft(2, '0')].join();
}
