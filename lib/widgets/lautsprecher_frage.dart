import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/audio_ausgabe.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Prüft, ob vor der Wiedergabe über den eingebauten Lautsprecher nachgefragt werden soll.
///
/// docs/konzepte/lautsprecher.md & AG-8:
/// - Gefragt wird nur, wenn die Einstellung aktiv ist UND die Ausgabe über den eingebauten
///   Lautsprecher läuft (Kabel-, USB- und Bluetooth-Geräte fragen nicht nach).
/// - Dialog: "Die Wiedergabe läuft über den Lautsprecher. Trotzdem abspielen?"
///   Knöpfe "Abspielen" (true) / "Abbrechen" (false), Häkchen "Nicht mehr fragen".
/// - Gibt `true` zurück, wenn die Wiedergabe starten darf, sonst `false`.
Future<bool> frageVorLautsprecher(BuildContext context) async {
  if (!StorageService.getFrageVorLautsprecher()) return true;

  final istLautsprecher = await AudioAusgabe.instanz.istLautsprecher();
  if (!istLautsprecher) return true;

  if (!context.mounted) return false;

  final ergebnis = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _LautsprecherDialog(),
  );

  return ergebnis ?? false;
}

class _LautsprecherDialog extends StatefulWidget {
  const _LautsprecherDialog();

  @override
  State<_LautsprecherDialog> createState() => _LautsprecherDialogState();
}

class _LautsprecherDialogState extends State<_LautsprecherDialog> {
  bool _nichtMehrFragen = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        t.lautsprecherFrageTitel,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.lautsprecherFrageNachricht,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _nichtMehrFragen = !_nichtMehrFragen),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _nichtMehrFragen,
                      activeColor: AppTheme.rose,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (v) =>
                          setState(() => _nichtMehrFragen = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.lautsprecherNichtMehrFragen,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            t.lautsprecherAbbrechen,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_nichtMehrFragen) {
              await StorageService.setFrageVorLautsprecher(false);
            }
            if (context.mounted) Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.rose,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            t.lautsprecherAbspielen,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
