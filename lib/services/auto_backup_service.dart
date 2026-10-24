import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'backup_codec.dart';
import 'storage_service.dart';

class AutoBackupService {
  static const String backupFileName = 'velvetpulse_backup.json';

  /// Einziger Ort, an dem Sicherungen automatisch geschrieben und gelesen werden:
  /// der private App-Speicher. Andere Apps können ihn nicht lesen. Die Sicherung
  /// enthält keine Geheimnisse (siehe BackupCodec, SecretStore).
  /// Dateien aus Download oder Documents werden nie automatisch eingelesen, nur
  /// über den Import im Onboarding, nach Prüfung und auf ausdrücklichen Wunsch.
  ///
  /// Den Ordner liefert Android (Context.getFilesDir), damit es auch in einem
  /// Arbeitsprofil oder bei einem zweiten Nutzer klappt. Für den Hauptnutzer ist es
  /// derselbe Ort wie früher (/data/user/0/<Paket>/files), alte Sicherungen bleiben also gültig.
  static Future<String?> _privateBackupPath() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    try {
      final dir = await getApplicationSupportDirectory();
      return '${dir.path}/$backupFileName';
    } catch (_) {
      return null;
    }
  }

  /// Beim App-Start: Ist die App eingerichtet, wird nur gesichert. Sonst wird
  /// eine vorhandene private Sicherung geprüft und eingespielt.
  static Future<bool> checkAndAutoRestore() async {
    if (StorageService.hasCompletedOnboarding() &&
        StorageService.getUserProfile() != null) {
      saveAutoBackup();
      return true;
    }

    final text = await readBackupText();
    if (text == null) return false;
    try {
      final backup = BackupCodec.validate(text);
      await StorageService.importBackup(backup, secrets: backup.plaintextSecrets);
      debugPrint('AutoBackupService: private Sicherung eingespielt.');
      return true;
    } catch (e) {
      debugPrint('AutoBackupService: private Sicherung nicht verwendet: ${e is BackupException ? e.message : e.runtimeType}');
      return false;
    }
  }

  /// Schreibt den aktuellen Stand still in den privaten Speicher.
  static Future<bool> saveAutoBackup() async {
    try {
      final data = StorageService.exportAllUserData();

      final profile = data['userProfile'];
      final lessons = data['completedLessons'] as List?;
      if (profile == null && (lessons == null || lessons.isEmpty)) {
        return false;
      }

      final path = await _privateBackupPath();
      if (path == null) return false;

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final file = File(path);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      file.writeAsStringSync(jsonString, flush: true);
      return true;
    } catch (e) {
      debugPrint('AutoBackupService saveAutoBackup error: ${e.runtimeType}');
      return false;
    }
  }

  /// Inhalt der privaten Sicherung, falls vorhanden und nicht übergroß.
  static Future<String?> readBackupText() async {
    final path = await _privateBackupPath();
    if (path == null) return null;
    try {
      final file = File(path);
      if (file.existsSync() && file.lengthSync() <= BackupCodec.maxBackupChars) {
        final text = file.readAsStringSync();
        return text.trim().isEmpty ? null : text;
      }
    } catch (_) {}
    return null;
  }
}
