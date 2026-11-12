import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/storage_service.dart';
import 'hinweis_blatt.dart';

/// Fantasie-Hinweis (docs/konzepte/privatsphaere-schutz.md, c): einmal je Gerät, an der ersten der beiden Stellen
/// (Lust im Traum, Innenansichten), die geöffnet wird. Der Merker steht in der Sicherung; wer wiederherstellt,
/// sieht ihn nicht erneut. Dauerhaft nachlesbar in der Anleitung („Fantasien sind frei“).
///
/// [drei]: Zusatzsatz für Szenen zu dritt.
Future<void> fantasieHinweisEinmal(BuildContext context, {bool drei = false}) async {
  if (StorageService.fantasieHinweisGesehen()) return;
  // Vor dem Zeigen merken: Auch Wegwischen zählt, und zwei Stellen zugleich zeigen ihn nicht doppelt.
  await StorageService.setFantasieHinweisGesehen(true);
  if (!context.mounted) return;
  await zeigeHinweisBlatt<void>(context, (_) => FantasieHinweisBlatt(drei: drei));
}

class FantasieHinweisBlatt extends StatelessWidget {
  final bool drei;
  const FantasieHinweisBlatt({super.key, this.drei = false});

  @override
  Widget build(BuildContext context) => VpHinweisBlatt(
        icon: Icons.auto_awesome_outlined,
        titel: t.fantasieHinweisTitel,
        text: t.fantasieHinweisText,
        zusatz: drei ? t.fantasieHinweisDrei : null,
        ok: t.fantasieHinweisOk,
        onOk: () => Navigator.of(context).pop(),
      );
}
