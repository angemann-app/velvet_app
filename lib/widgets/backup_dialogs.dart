import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auto_backup_service.dart';
import '../services/backup_codec.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../l10n/t.dart';

/// „Backup exportieren“: Nutzerdaten immer, Verbindungsschlüssel und API-Key nur mit Passwort.
Future<void> showExportBackupDialog(BuildContext context) async {
  final withSecrets = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(t.backupDialogsWhatShouldGoIntoThe),
      content: Text(
        t.backupDialogsOnlyYourDataProfileProgress,
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.backupDialogsDataOnly)),
        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.backupDialogsWithPassword)),
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
      title: Text(t.backupDialogsBackupCopied),
      content: Text(
        t.backupDialogsBackupCopiedText + (withSecrets ? t.backupDialogsPasswordCannotBeReset : ''),
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.backupDialogsOk))],
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
        title: Text(t.backupDialogsOlderBackup),
        content: Text(
          t.backupDialogsThisBackupComesFromAn,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.ausspracheMeldenCancel)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.backupDialogsRestore)),
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
        title: Text(t.backupDialogsBackupPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.backupDialogsThisAlsoBringsBackThe,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(hintText: t.backupDialogsPassword, errorText: error),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, ''), child: Text(t.backupDialogsWithoutKeys)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(t.appLockUnlock)),
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
        title: Text(t.backupDialogsPasswordForTheBackup),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: first, obscureText: true, autofocus: true,
                decoration: InputDecoration(hintText: t.backupDialogsPasswordAtLeastCharacters)),
            const SizedBox(height: 8),
            TextField(controller: second, obscureText: true,
                decoration: InputDecoration(hintText: t.backupDialogsRepeatPassword, errorText: error)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.ausspracheMeldenCancel)),
          ElevatedButton(
            onPressed: () {
              if (first.text.length < 8) {
                setState(() => error = t.backupDialogsPleaseUseAtLeastCharacters);
              } else if (first.text != second.text) {
                setState(() => error = t.backupDialogsThePasswordsDonTMatch);
              } else {
                Navigator.pop(ctx, first.text);
              }
            },
            child: Text(t.backupDialogsEncrypt),
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
    builder: (_) => AlertDialog(
      backgroundColor: AppTheme.surface,
      content: Row(
        children: [
          SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
          SizedBox(width: 16),
          Expanded(child: Text(t.backupDialogsOneMoment)),
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
