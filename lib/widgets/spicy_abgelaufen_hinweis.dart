import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/alter_dienst.dart';
import '../services/storage_service.dart';
import 'hinweis_blatt.dart';

/// Ist die Spicy-Entsperrung nach langer Zeit im Hintergrund verfallen (AlterDienst.erneutNach, 5 Stunden), sagt die
/// App das einmal klar, statt nur die Farben umspringen zu lassen (docs/konzepte/privatsphaere-schutz.md, b).
/// Genau einmal je Ablauf; nach einem App-Neustart reicht die normale Abfrage.
Future<void> spicyAbgelaufenZeigenWennNoetig(BuildContext context) async {
  if (!AlterDienst.ablaufHinweisAbholen()) return;
  if (StorageService.spicyMode() || !StorageService.spicyGewaehlt()) return;
  final entsperren = await zeigeHinweisBlatt<bool>(context, (_) => const SpicyAbgelaufenBlatt());
  // Hat die App-Sperre beim Zurückkehren gerade bestätigt, reicht das: nur eine Abfrage.
  if (entsperren == true) await AlterDienst.entsperren(kuerzlichReicht: true);
}

class SpicyAbgelaufenBlatt extends StatelessWidget {
  const SpicyAbgelaufenBlatt({super.key});

  @override
  Widget build(BuildContext context) => VpHinweisBlatt(
        icon: Icons.lock_clock_outlined,
        titel: t.spicyAbgelaufenTitel,
        text: t.spicyAbgelaufenText,
        ok: t.spicyAbgelaufenEntsperren,
        onOk: () => Navigator.of(context).pop(true),
        zweitens: t.spicyAbgelaufenSpaeter,
        onZweitens: () => Navigator.of(context).pop(false),
      );
}
