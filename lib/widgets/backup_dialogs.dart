import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auto_backup_service.dart';
import '../services/backup_codec.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// „Backup exportieren“: Nutzerdaten immer, Verbindungsschlüssel und API-Key nur mit Passwort.
Future<void> showExportBackupDialog(BuildContext context) async {
  final withSecrets = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('Was soll in die Sicherung?'),
      content: const Text(
        'Nur deine Daten: Profil, Fortschritt, Reflexionen, Tagebuch, Wünsche. Reicht für dieses Handy.\n\n'
        'Mit Passwort: zusätzlich die Verbindung im Paar-Kanal und dein API-Key, verschlüsselt. '
        'Das brauchst du für einen Umzug auf ein anderes Handy.',
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Nur Daten')),
        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Mit Passwort')),
      ],
    ),
  );
  if (withSecrets == null || !context.mounted) return;

  Map<String, dynamic> data;
  if (withSecrets) {
    final password = await _askNewPassword(context);
    if (password == null || !context.mounted) return;
    data = await _withProgress(context, StorageService.exportWithSecrets(password));
  } else {
    data = StorageService.exportAllUserData();
  }
  await Clipboard.setData(ClipboardData(text: jsonEncode(data)));
  await AutoBackupService.saveAutoBackup();
  HapticFeedback.lightImpact();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('Sicherung kopiert'),
      content: Text(
        'Die Sicherung liegt in der Zwischenablage. Füge sie in eine Notiz oder ein privates Dokument ein.'
        '${withSecrets ? '\n\nOhne dein Passwort lassen sich Verbindung und API-Key nicht wiederherstellen. Auch wir können es nicht zurücksetzen.' : ''}',
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
    ),
  );
}

/// Fragt beim Einspielen alles Nötige ab und gibt die Geheimnisse zurück, die mit
/// eingespielt werden sollen, oder null, wenn der Nutzer abbricht.
Future<Map<String, String>?> resolveBackupSecrets(BuildContext context, ValidatedBackup backup) async {
  if (backup.hasPlaintextSecrets) {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Ältere Sicherung'),
        content: const Text(
          'Diese Sicherung stammt aus einer älteren Version und enthält deinen API-Key und deinen '
          'Verbindungsschlüssel unverschlüsselt. Sie wird trotzdem eingespielt.\n\n'
          'Lösche die alte Sicherung danach dort, wo du sie aufbewahrt hast, und erstelle bei Bedarf '
          'eine neue mit Passwort.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Einspielen')),
        ],
      ),
    );
    return ok == true ? backup.plaintextSecrets : null;
  }
  if (!backup.needsPassword) return const {};

  String? error;
  while (context.mounted) {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Passwort der Sicherung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Damit kommen auch die Verbindung im Paar-Kanal und dein API-Key zurück.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Passwort', errorText: error),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, ''), child: const Text('Ohne Schlüssel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Entsperren')),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return null;
    if (result.isEmpty) return const {};
    try {
      if (!context.mounted) return null;
      return await _withProgress(context, BackupCodec.decryptSecrets(backup.encryptedSecrets!, result));
    } on BackupException catch (e) {
      error = e.message;
    }
  }
  return null;
}

Future<String?> _askNewPassword(BuildContext context) async {
  final first = TextEditingController();
  final second = TextEditingController();
  String? error;
  final password = await showDialog<String>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Passwort für die Sicherung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: first, obscureText: true, autofocus: true,
                decoration: const InputDecoration(hintText: 'Passwort (mindestens 8 Zeichen)')),
            const SizedBox(height: 8),
            TextField(controller: second, obscureText: true,
                decoration: InputDecoration(hintText: 'Passwort wiederholen', errorText: error)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              if (first.text.length < 8) {
                setState(() => error = 'Bitte mindestens 8 Zeichen.');
              } else if (first.text != second.text) {
                setState(() => error = 'Die Passwörter sind verschieden.');
              } else {
                Navigator.pop(ctx, first.text);
              }
            },
            child: const Text('Verschlüsseln'),
          ),
        ],
      ),
    ),
  );
  first.dispose();
  second.dispose();
  return password;
}

/// Zeigt einen Hinweis, solange die (absichtlich langsame) Verschlüsselung läuft.
Future<T> _withProgress<T>(BuildContext context, Future<T> work) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      backgroundColor: AppTheme.surface,
      content: Row(
        children: [
          SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
          SizedBox(width: 16),
          Expanded(child: Text('Einen Moment …')),
        ],
      ),
    ),
  );
  try {
    return await work;
  } finally {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}
