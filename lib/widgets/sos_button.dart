import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../screens/sos/sos_modal.dart';
import '../theme/app_theme.dart';

/// Soforthilfe in der Kopfzeile: nur ein kleines Schild, ohne Beschriftung und Leuchten (docs/konzepte/heute-und-produktschliff.md,
/// Punkt 4). Bleibt auf allen Hauptseiten erreichbar; Antippen öffnet wie bisher die Akut-Hilfe.
class SosButton extends StatelessWidget {
  final double size;

  const SosButton({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        onPressed: () => SosModal.show(context),
        tooltip: t.sosModalSosQuickHelp,
        icon: Icon(Icons.shield_outlined, color: AppTheme.signal.withValues(alpha: 0.85), size: size * 0.6),
      ),
    );
  }
}
