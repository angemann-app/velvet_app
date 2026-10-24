import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../l10n/t.dart';

/// Beenden · Pause/Fortsetzen · Überspringen für die geführten Audios (Gemeinsamer Abend,
/// Selbsterkundung). Jeder Knopf ist beschriftet, damit sofort klar ist, wie man anhält oder
/// aufhört, und für Screenreader benannt.
class PlayerSteuerung extends StatelessWidget {
  final bool pausiert;
  final Color farbe;
  final Color symbolFarbe;
  final VoidCallback onBeenden;
  final VoidCallback onPause;
  final VoidCallback onUeberspringen;

  const PlayerSteuerung({
    super.key,
    required this.pausiert,
    required this.farbe,
    required this.symbolFarbe,
    required this.onBeenden,
    required this.onPause,
    required this.onUeberspringen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _knopf(Icons.stop_rounded, t.playerSteuerungStop, onBeenden),
        const SizedBox(width: 20),
        Column(children: [
          Semantics(
            button: true,
            label: pausiert ? t.playerSteuerungResume : t.playerSteuerungPause,
            excludeSemantics: true,
            child: InkWell(
              onTap: onPause,
              customBorder: const CircleBorder(),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(shape: BoxShape.circle, color: farbe),
                child: Icon(pausiert ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 38, color: symbolFarbe),
              ),
            ),
          ),
          const SizedBox(height: 6),
          ExcludeSemantics(child: _beschriftung(pausiert ? t.playerSteuerungResume : t.playerSteuerungPause2)),
        ]),
        const SizedBox(width: 20),
        _knopf(Icons.skip_next_rounded, t.playerSteuerungSkip, onUeberspringen),
      ],
    );
  }

  Widget _knopf(IconData icon, String text, VoidCallback onPressed) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            iconSize: 30,
            color: AppTheme.textSecondary,
            tooltip: text,
          ),
          ExcludeSemantics(child: _beschriftung(text)),
        ]),
      );

  Widget _beschriftung(String text) =>
      Text(text, style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted));
}
