import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

import 'nostr_keys.dart';
import '../l10n/t.dart';

/// Format und Prüfung von Sicherungen.
///
/// Schema 2 (ab 4.3.0): keine Geheimnisse im Klartext. API-Key und privater
/// Nostr-Schlüssel stehen nur, wenn der Nutzer es beim Export wählt, im Block
/// `secrets`, verschlüsselt mit einem Passwort (PBKDF2-HMAC-SHA256 + AES-256-GCM).
/// Das Passwort steht nicht in der Datei. Ältere Versionen ignorieren `secrets`.
///
/// Schema 1 (bis 4.3.0-beta.1, Feld `version: "4.0.0"`) enthielt die Geheimnisse
/// im Klartext; solche Sicherungen werden weiter angenommen, aber als unsicher gemeldet.
class BackupCodec {
  static const int schema = 2;
  static const int maxBackupChars = 2 * 1024 * 1024;
  static const int _maxListLength = 5000;
  static const int _maxStringLength = 200000;
  static const int pbkdf2Iterations = 210000;

  /// Felder, die eine Sicherung haben darf, mit ihrem erlaubten Typ.
  static const Map<String, Type> _fields = {
    'userProfile': Map,
    'completedLessons': List,
    'reflectionAnswers': String,
    'cbtEntries': List,
    'dailyCheckIns': List,
    'yesNoMaybe': String,
    'streakCount': int,
    'lastActiveDate': String,
    'nostrPubKey': String,
    'nostrPartnerPubKey': String,
    'nostrPartnerName': String,
    'myFantasyVotes': String,
    'partnerFantasyVotes': String,
    'partnerReflections': String,
    'nostrPartnerGender': String,
    // Für welches Gegenüber NIP-17 angekündigt wurde (öffentlicher Schlüssel, siehe NostrService).
    'nostrPartnerNip17': String,
    // Traumtagebuch (Liste von TraumEintrag) und Fortschritt der Serie „Lust im Traum“ (JSON {Folge: Abende}).
    'traumTagebuch': List,
    'lustFortschritt': String,
    // Realitätschecks (Einstellungen als Map).
    'realitaetschecks': Map,
    // Zeitpunkte des nächtlichen Weckens (Liste von ISO-8601-Strings für die 2x/Woche-Regel).
    'naechtlichesWecken': List,
    // Lautsprecher-Abfrage und Pause beim Trennen der Kopfhörer.
    'frageVorLautsprecher': bool,
    'pausiereBeiKopfhoererGetrennt': bool,
  };

  /// Prüft eine Sicherung vollständig, bevor irgendetwas gespeichert wird.
  /// Gibt nur bekannte, typgeprüfte Felder zurück; wirft [BackupException] mit
  /// einer verständlichen Meldung.
  static ValidatedBackup validate(Object? raw) {
    if (raw is String) {
      if (raw.length > maxBackupChars) throw BackupException(t.backupCodecTheBackupIsTooLarge);
      try {
        raw = jsonDecode(raw);
      } catch (_) {
        throw BackupException(t.backupCodecThisIsNotAValid);
      }
    }
    if (raw is! Map) throw BackupException(t.backupCodecThisIsNotAValid2);
    final data = Map<String, dynamic>.from(raw);
    if (data['app'] != 'VelvetPulse') throw BackupException(t.backupCodecThisIsNotAVelvetpulse);

    final schemaValue = data['schema'];
    final int foundSchema = schemaValue == null ? 1 : (schemaValue is int ? schemaValue : -1);
    if (foundSchema < 1 || foundSchema > schema) {
      throw BackupException(t.backupCodecThisBackupComesFromA);
    }

    final clean = <String, dynamic>{};
    for (final entry in _fields.entries) {
      final value = data[entry.key];
      if (value == null) continue;
      if (!_hasType(value, entry.value)) {
        throw BackupException(t.backupCodecTheBackupIsDamagedField(entry.key));
      }
      _checkSize(value, entry.key);
      clean[entry.key] = value;
    }
    for (final field in ['nostrPubKey', 'nostrPartnerPubKey', 'nostrPartnerNip17']) {
      final key = clean[field] as String?;
      if (key != null && key.isNotEmpty && !isValidPublicKeyHex(key)) {
        throw BackupException(t.backupCodecTheBackupContainsAnInvalid);
      }
    }

    // Schema 1: Geheimnisse im Klartext.
    final legacySecrets = <String, String>{};
    if (foundSchema == 1) {
      final apiKey = data['apiKey'];
      if (apiKey is String && apiKey.trim().isNotEmpty) {
        _checkSize(apiKey, 'apiKey');
        legacySecrets['apiKey'] = apiKey.trim();
      }
      final priv = data['nostrPrivKey'];
      if (priv != null) {
        if (priv is! String || !isValidPrivateKeyHex(priv)) {
          throw BackupException(t.backupCodecTheBackupContainsAnInvalid);
        }
        legacySecrets['nostrPrivKey'] = priv;
      }
    }

    final secrets = data['secrets'];
    if (secrets != null && secrets is! Map) throw BackupException(t.backupCodecTheBackupIsDamagedField2);

    return ValidatedBackup(
      data: clean,
      plaintextSecrets: legacySecrets,
      encryptedSecrets: secrets == null ? null : Map<String, dynamic>.from(secrets as Map),
    );
  }

  /// Prüft die entschlüsselten Geheimnisse wie ein Klartext-Backup.
  static Map<String, String> checkSecrets(Map<String, String> secrets) {
    final priv = secrets['nostrPrivKey'];
    if (priv != null && !isValidPrivateKeyHex(priv)) {
      throw BackupException(t.backupCodecTheBackupContainsAnInvalid);
    }
    return secrets;
  }

  static bool _hasType(Object value, Type type) => switch (type) {
        const (Map) => value is Map,
        const (List) => value is List,
        const (String) => value is String,
        const (int) => value is int,
        const (bool) => value is bool,
        _ => false,
      };

  static void _checkSize(Object value, String field) {
    if (value is String && value.length > _maxStringLength) {
      throw BackupException(t.backupCodecTheBackupIsDamagedField3(field));
    }
    if (value is List && value.length > _maxListLength) {
      throw BackupException(t.backupCodecTheBackupIsDamagedField4(field));
    }
  }

  // ---------------------------------------------------------------------------
  // Passwort-Verschlüsselung

  /// Verschlüsselt die Geheimnisse mit dem Passwort. Läuft in einem Isolate,
  /// weil die Schlüsselableitung absichtlich langsam ist.
  static Future<Map<String, dynamic>> encryptSecrets(Map<String, String> secrets, String password) =>
      compute(_encrypt, [jsonEncode(secrets), password]);

  /// Entschlüsselt; wirft [BackupException], wenn das Passwort falsch ist oder die Daten verändert wurden.
  static Future<Map<String, String>> decryptSecrets(Map<String, dynamic> block, String password) async {
    final json = await compute(_decrypt, [jsonEncode(block), password]);
    // GCM kann „falsches Passwort“ und „Datei verändert“ nicht unterscheiden.
    if (json == null) throw BackupException(t.backupCodecThePasswordIsWrongOr);
    final map = jsonDecode(json);
    if (map is! Map) throw BackupException(t.backupCodecTheBackupIsDamaged);
    return checkSecrets(map.map((k, v) => MapEntry(k.toString(), v.toString())));
  }

  static Map<String, dynamic> _encrypt(List<String> args) {
    final rnd = Random.secure();
    final salt = Uint8List.fromList(List.generate(16, (_) => rnd.nextInt(256)));
    final nonce = Uint8List.fromList(List.generate(12, (_) => rnd.nextInt(256)));
    final key = _deriveKey(args[1], salt, pbkdf2Iterations);
    final cipher = GCMBlockCipher(AESEngine())..init(true, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));
    final ct = cipher.process(Uint8List.fromList(utf8.encode(args[0])));
    return {
      'v': 1,
      'kdf': 'pbkdf2-sha256',
      'iter': pbkdf2Iterations,
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
      'ct': base64Encode(ct),
    };
  }

  static String? _decrypt(List<String> args) {
    try {
      final block = jsonDecode(args[0]) as Map<String, dynamic>;
      if (block['v'] != 1 || block['kdf'] != 'pbkdf2-sha256') return null;
      final iter = block['iter'];
      if (iter is! int || iter < 100000 || iter > 5000000) return null;
      final key = _deriveKey(args[1], base64Decode(block['salt'] as String), iter);
      final cipher = GCMBlockCipher(AESEngine())
        ..init(false, AEADParameters(KeyParameter(key), 128, base64Decode(block['nonce'] as String), Uint8List(0)));
      return utf8.decode(cipher.process(base64Decode(block['ct'] as String)));
    } catch (_) {
      return null; // falsches Passwort oder manipulierte Daten: GCM-Prüfung schlägt fehl
    }
  }

  static Uint8List _deriveKey(String password, Uint8List salt, int iterations) {
    final kdf = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))..init(Pbkdf2Parameters(salt, iterations, 32));
    return kdf.process(Uint8List.fromList(utf8.encode(password)));
  }
}

class ValidatedBackup {
  /// Nur bekannte, geprüfte Nutzerdaten.
  final Map<String, dynamic> data;

  /// Geheimnisse aus einer alten Klartext-Sicherung (Schema 1).
  final Map<String, String> plaintextSecrets;

  /// Passwort-verschlüsselter Block, falls vorhanden.
  final Map<String, dynamic>? encryptedSecrets;

  const ValidatedBackup({required this.data, required this.plaintextSecrets, this.encryptedSecrets});

  bool get hasPlaintextSecrets => plaintextSecrets.isNotEmpty;
  bool get needsPassword => encryptedSecrets != null;
  String get profileName => (data['userProfile'] as Map?)?['name']?.toString() ?? t.onboardingUser;
}

class BackupException implements Exception {
  final String message;
  const BackupException(this.message);
  @override
  String toString() => message;
}
