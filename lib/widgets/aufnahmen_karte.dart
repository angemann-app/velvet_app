import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/paket_verzeichnis.dart';
import '../services/pakete.dart';
import '../services/sprachausgabe.dart';
import '../theme/app_theme.dart';

/// Aufnahmen der aktuellen Sprache nachladen, aktualisieren oder löschen (Profil und Hinweis auf der Startseite).
class AufnahmenKarte extends StatefulWidget {
  const AufnahmenKarte({super.key});

  @override
  State<AufnahmenKarte> createState() => _AufnahmenKarteState();
}

class _AufnahmenKarteState extends State<AufnahmenKarte> {
  late Future<PaketVerzeichnis?> _verzeichnis = PaketVerzeichnis.laden();

  Future<void> _laden(List<String> namen) async {
    final messenger = ScaffoldMessenger.of(context);
    final v = await _verzeichnis;
    try {
      for (final n in namen) {
        await Pakete.laden(n, verzeichnis: v);
      }
      messenger.showSnackBar(SnackBar(content: Text(t.aufnahmenFertig)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t.aufnahmenFehler), backgroundColor: AppTheme.rose));
    }
  }

  int _mb(PaketVerzeichnis? v, String name) => ((v?.paket(name)?.groesse ?? 0) / 1e6).round();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaketVerzeichnis?>(
      future: _verzeichnis,
      builder: (context, snap) => ValueListenableBuilder<int>(
        valueListenable: Pakete.stand,
        builder: (context, _, __) => ValueListenableBuilder<Map<String, double>>(
          valueListenable: Pakete.fortschritt,
          builder: (context, fortschritt, _) {
            final v = snap.data;
            final fehlend = [for (final a in Pakete.arten) if (!Pakete.vorhanden(a)) Pakete.name(a)];
            final fehlendMb = fehlend.fold(0, (s, n) => s + _mb(v, n));
            return Container(
              margin: const EdgeInsets.only(top: 6, bottom: 8),
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
                      child: Text(t.aufnahmenTitel,
                          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text(t.aufnahmenText,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4)),
                  if (snap.connectionState == ConnectionState.done && v == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(t.aufnahmenNichtErreichbar,
                          style: const TextStyle(color: AppTheme.rose, fontSize: 12.5)),
                    ),
                  const SizedBox(height: 8),
                  for (final art in Pakete.arten) _zeile(art, v, fortschritt),
                  if (fehlend.length > 1 && v != null && fortschritt.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ElevatedButton.icon(
                        onPressed: () => _laden(fehlend),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: Text(t.aufnahmenAlleLaden(fehlendMb)),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _zeile(String art, PaketVerzeichnis? v, Map<String, double> fortschritt) {
    final name = Pakete.name(art);
    final eintrag = v?.paket(name);
    final installiert = Pakete.version(name);
    final altesPaket = installiert == 0 && Pakete.vorhanden(art); // altes englisches Audiopaket
    final aktualisierbar = eintrag != null && installiert > 0 && eintrag.version > installiert;
    final laeuft = fortschritt[name];
    final titel = art == Pakete.lektionen ? t.aufnahmenLektionen : t.aufnahmenGefuehrt;
    final info = installiert > 0 || altesPaket
        ? t.aufnahmenInstalliert(installiert > 0 ? Pakete.belegtMb(name) : AudioPaket.belegtMb)
        : t.aufnahmenGroesse(_mb(v, name));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text('$titel · $info',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5)),
            ),
            if (laeuft == null && eintrag != null && (installiert == 0 && !altesPaket || aktualisierbar))
              TextButton(
                onPressed: fortschritt.isEmpty ? () => _laden([name]) : null,
                child: Text(aktualisierbar ? t.audioPaketAktualisieren : t.aufnahmenLaden),
              ),
            if (laeuft == null && installiert > 0)
              IconButton(
                tooltip: t.audioPaketLoeschen,
                onPressed: () => Pakete.loeschen(name),
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppTheme.textSecondary),
              ),
          ]),
          if (laeuft != null)
            LinearProgressIndicator(
              value: laeuft == 0 ? null : laeuft,
              color: AppTheme.sageGreen,
              backgroundColor: AppTheme.surfaceLight,
            ),
        ],
      ),
    );
  }
}

/// Hinweis auf der Startseite, solange für die aktuelle Sprache Aufnahmen fehlen. „Später“ blendet ihn bis
/// zum nächsten Start aus.
class AufnahmenHinweis extends StatefulWidget {
  const AufnahmenHinweis({super.key});

  @override
  State<AufnahmenHinweis> createState() => _AufnahmenHinweisState();
}

class _AufnahmenHinweisState extends State<AufnahmenHinweis> {
  static bool _spaeter = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Pakete.stand,
      builder: (context, _, __) {
        if (_spaeter || !Pakete.unvollstaendig) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 6),
          decoration: BoxDecoration(
            color: AppTheme.sageGreen.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.aufnahmenHinweisTitel,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 4),
              Text(t.aufnahmenHinweisText,
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.4)),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () => setState(() => _spaeter = true),
                  child: Text(t.aufnahmenSpaeter, style: const TextStyle(color: AppTheme.textSecondary)),
                ),
                TextButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: AppTheme.surface,
                    builder: (_) => const SafeArea(
                      child: Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: AufnahmenKarte()),
                    ),
                  ),
                  child: Text(t.aufnahmenAnsehen, style: const TextStyle(color: AppTheme.sageGreen)),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
