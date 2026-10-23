/// Prüfungen für Nostr-Schlüssel (secp256k1, BIP-340), unabhängig von der Bibliothek.
final BigInt _curveOrder =
    BigInt.parse('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141', radix: 16);
final RegExp _hex64 = RegExp(r'^[0-9a-f]{64}$');

/// Gültiger privater Schlüssel: 64 Hex-Zeichen und ein Skalar zwischen 1 und n−1.
bool isValidPrivateKeyHex(String? key) {
  if (key == null || !_hex64.hasMatch(key)) return false;
  final value = BigInt.parse(key, radix: 16);
  return value > BigInt.zero && value < _curveOrder;
}

/// Formal gültiger öffentlicher Schlüssel (x-Koordinate, 64 Hex-Zeichen).
bool isValidPublicKeyHex(String? key) => key != null && _hex64.hasMatch(key);
