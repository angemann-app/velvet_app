import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/sprachausgabe.dart';
import '../theme/app_theme.dart';

/// Englische Aufnahmen nachladen oder löschen (Profil, nur wenn die App englisch ist).
class AudioPaketKarte extends StatelessWidget {
  const AudioPaketKarte({super.key});

  Future<void> _laden(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AudioPaket.laden();
      messenger.showSnackBar(SnackBar(content: Text(t.audioPaketFertig)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t.audioPaketFehler), backgroundColor: AppTheme.rose));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AudioPaket.stand,
      builder: (context, _, __) => ValueListenableBuilder<double?>(
        valueListenable: AudioPaket.fortschritt,
        builder: (context, fortschritt, _) {
          final installiert = AudioPaket.vorhanden;
          return Container(
            margin: const EdgeInsets.only(top: 6, right: 8, bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.record_voice_over_rounded, color: AppTheme.sageGreen, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(t.audioPaketTitel,
                        style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(
                  installiert ? t.audioPaketInstalliert(AudioPaket.belegtMb) : t.audioPaketText(AudioPaket.ungefaehrMb),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4),
                ),
                const SizedBox(height: 10),
                if (fortschritt != null)
                  LinearProgressIndicator(
                    value: fortschritt == 0 ? null : fortschritt,
                    color: AppTheme.sageGreen,
                    backgroundColor: AppTheme.surfaceLight,
                  )
                else if (installiert)
                  TextButton.icon(
                    onPressed: AudioPaket.loeschen,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(t.audioPaketLoeschen),
                    style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => _laden(context),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(t.audioPaketLaden),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
