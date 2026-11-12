import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/privacy_service.dart';
import 'hinweis_blatt.dart';

/// App-Sperre als Standard (docs/konzepte/privatsphaere-schutz.md, a).

/// Ende des Onboardings: Sperre einschalten, wenn das Gerät eine Bildschirmsperre hat, und kurz sagen, was passiert ist.
/// Ohne Bildschirmsperre bleibt die Sperre aus, dafür ein Hinweis, wie man eine einrichtet.
Future<void> appSperreEinrichten(BuildContext context) async {
  final ergebnis = await PrivacyService.standardEinrichten();
  if (!context.mounted) return;
  switch (ergebnis) {
    case SperrEinrichtung.eingeschaltet:
      await zeigeHinweisBlatt<void>(context, (_) => const AppSperreNeuBlatt());
    case SperrEinrichtung.nichtMoeglich:
      await zeigeHinweisBlatt<void>(context, (_) => const AppSperreKeineBlatt());
    case SperrEinrichtung.schonAn:
    case SperrEinrichtung.abgebrochen:
      break;
  }
}

/// Bestand: beim Start einmal fragen, ob die App gesperrt werden soll. „Nicht jetzt“ (oder Wegwischen) wird gemerkt;
/// danach fragt die App nie wieder von selbst, der Schalter im Profil bleibt.
Future<void> appSperreFrageWennNoetig(BuildContext context) async {
  if (!await PrivacyService.frageNoetig() || !context.mounted) return;
  final ja = await zeigeHinweisBlatt<bool>(context, (_) => const AppSperreFrageBlatt());
  await PrivacyService.frageBeantworten(ja == true);
}

class AppSperreNeuBlatt extends StatelessWidget {
  const AppSperreNeuBlatt({super.key});

  @override
  Widget build(BuildContext context) => VpHinweisBlatt(
        icon: Icons.lock_outline_rounded,
        titel: t.appSperreNeuTitel,
        text: t.appSperreNeuText,
        ok: t.appSperreNeuOk,
        onOk: () => Navigator.of(context).pop(),
      );
}

class AppSperreKeineBlatt extends StatelessWidget {
  const AppSperreKeineBlatt({super.key});

  @override
  Widget build(BuildContext context) => VpHinweisBlatt(
        icon: Icons.phonelink_lock_rounded,
        titel: t.appSperreKeineTitel,
        text: t.appSperreKeineText,
        ok: t.appSperreKeineOk,
        onOk: () => Navigator.of(context).pop(),
      );
}

class AppSperreFrageBlatt extends StatelessWidget {
  const AppSperreFrageBlatt({super.key});

  @override
  Widget build(BuildContext context) => VpHinweisBlatt(
        icon: Icons.lock_outline_rounded,
        titel: t.appSperreFrageTitel,
        text: t.appSperreFrageText,
        ok: t.appSperreFrageJa,
        onOk: () => Navigator.of(context).pop(true),
        zweitens: t.appSperreFrageNein,
        onZweitens: () => Navigator.of(context).pop(false),
      );
}
