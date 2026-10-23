import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AutoBackupService {
  static const String backupFileName = 'velvetpulse_backup.json';

  static String get _packageName {
    try {
      final cmdline = File('/proc/self/cmdline')
          .readAsStringSync()
          .split('\u0000')
          .first
          .trim();
      if (cmdline.isNotEmpty) return cmdline;
    } catch (_) {}
    return 'org.velvetpulse.app';
  }

  /// Einziger Schreibort: der private App-Speicher. Andere Apps können ihn
  /// nicht lesen, und Androids Cloud-Backup (backup_rules.xml) sichert ihn mit.
  /// Das Backup enthält API-Key und privaten Nostr-Schlüssel, darum nie öffentlich.
  static String? get _privateBackupPath {
    if (!Platform.isAndroid) return null;
    return '/data/user/0/$_packageName/files/$backupFileName';
  }

  /// Leseorte für die Wiederherstellung: privater Speicher zuerst, danach
  /// Altdateien früherer Versionen und manuell abgelegte Sicherungen.
  static List<String> get _restorePaths {
    if (!Platform.isAndroid) return [];
    final pkg = _packageName;
    final paths = <String>[
      _privateBackupPath!,
      '/storage/emulated/0/Android/data/$pkg/files/$backupFileName',
      '/storage/emulated/0/Documents/VelvetPulse/$backupFileName',
      '/storage/emulated/0/Documents/$backupFileName',
      '/storage/emulated/0/Download/$backupFileName',
    ];
    return paths.toSet().toList();
  }

  /// Automatically called on app launch to detect and restore any existing backup file
  static Future<bool> checkAndAutoRestore() async {
    if (StorageService.hasCompletedOnboarding() &&
        StorageService.getUserProfile() != null) {
      debugPrint('AutoBackupService: User already initialized, keeping local storage active.');
      saveAutoBackup();
      return true;
    }

    debugPrint('AutoBackupService: Checking for autarkic backup file...');

    for (final path in _restorePaths) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          final content = file.readAsStringSync();
          if (content.trim().isNotEmpty) {
            final dynamic parsed = jsonDecode(content);
            if (parsed is Map<String, dynamic> &&
                parsed['app'] == 'VelvetPulse') {
              final success = await StorageService.importUserData(parsed);
              if (success) {
                debugPrint('AutoBackupService: Successfully auto-restored backup from: $path');
                return true;
              }
            }
          }
        }
      } catch (e) {
        debugPrint('AutoBackupService: Could not read backup at $path: $e');
      }
    }

    return false;
  }

  /// Silently writes the current state to the persistent device backup files
  static Future<bool> saveAutoBackup() async {
    try {
      final data = StorageService.exportAllUserData();

      final profile = data['userProfile'];
      final lessons = data['completedLessons'] as List?;
      final apiKey = data['apiKey'] as String?;

      if (profile == null &&
          (lessons == null || lessons.isEmpty) &&
          (apiKey == null || apiKey.isEmpty)) {
        return false;
      }

      final path = _privateBackupPath;
      if (path == null) return false;

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final file = File(path);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      file.writeAsStringSync(jsonString, flush: true);
      return true;
    } catch (e) {
      debugPrint('AutoBackupService saveAutoBackup global error: $e');
      return false;
    }
  }

  static Future<String?> findExistingBackupPath() async {
    for (final path in _restorePaths) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          final content = file.readAsStringSync();
          if (content.trim().isNotEmpty) {
            final dynamic parsed = jsonDecode(content);
            if (parsed is Map<String, dynamic> &&
                parsed['app'] == 'VelvetPulse') {
              return path;
            }
          }
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<Map<String, dynamic>?> readBackupFromFile(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        return jsonDecode(content) as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('Error reading backup from file: $e');
    }
    return null;
  }
}
