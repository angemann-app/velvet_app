import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Schaltet den Spicy-Modus nach Bestätigung ein (ab 18). Gibt zurück, ob er danach an ist.
/// Genutzt im Profil und bei einer Einladung des Gegenübers im Paar-Chat.
Future<bool> spicyModusEinschalten(BuildContext context) async {
  if (StorageService.spicyMode()) return true;
  final ja = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(t.spicyEinschaltenTitel),
      content: SingleChildScrollView(child: Text(t.spicyEinschaltenText, style: const TextStyle(height: 1.45))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.ausspracheMeldenCancel)),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(t.spicyEinschalten, style: const TextStyle(color: AppTheme.rose)),
        ),
      ],
    ),
  );
  if (ja != true) return false;
  await StorageService.setSpicyMode(true);
  return true;
}
