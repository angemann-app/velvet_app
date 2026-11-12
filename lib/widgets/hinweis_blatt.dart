import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme/vp_palette.dart';
import '../theme/vp_tokens.dart';

/// Ruhiges Blatt im Magazin-Look für einmalige Hinweise (App-Sperre, Fantasie-Hinweis, abgelaufener Spicy-Modus).
/// Immer in der Darstellung des Normalmodus (Papier, Nachtpapier oder Klassisch), nie in Spicy-Farben, damit es
/// neutral bleibt, auch wenn es über einer Spicy-Seite liegt (docs/konzepte/privatsphaere-schutz.md).
class VpHinweisBlatt extends StatelessWidget {
  final IconData icon;
  final String titel;
  final String text;

  /// Optionaler zweiter Absatz, leiser gesetzt.
  final String? zusatz;
  final String ok;
  final VoidCallback onOk;

  /// Optionaler zweiter Knopf (z. B. „Nicht jetzt“), als Textknopf unter dem Hauptknopf.
  final String? zweitens;
  final VoidCallback? onZweitens;

  const VpHinweisBlatt({
    super.key,
    required this.icon,
    required this.titel,
    required this.text,
    this.zusatz,
    required this.ok,
    required this.onOk,
    this.zweitens,
    this.onZweitens,
  });

  /// Die Palette des Normalmodus, unabhängig davon, ob Spicy gerade an ist.
  static VpPalette get neutralePalette {
    final id = VpPaletteId.ausName(StorageService.designPalette());
    return VpPalette.von(id == null || id == VpPaletteId.spicy ? VpPaletteId.papier : id);
  }

  @override
  Widget build(BuildContext context) {
    final p = neutralePalette;
    final typo = VpTypo.fuer(p);
    return Container(
      decoration: BoxDecoration(
        color: p.papierErhoben,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(VpRadius.blatt)),
        border: Border(top: BorderSide(color: p.linie, width: VpLinie.haar)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(VpAbstand.xl, VpAbstand.m, VpAbstand.xl, VpAbstand.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: p.linieStark, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: VpAbstand.xl),
              Align(alignment: Alignment.centerLeft, child: Icon(icon, color: p.akzentTief, size: 26)),
              const SizedBox(height: VpAbstand.m),
              Text(titel, style: typo.ueberschrift.copyWith(fontSize: 22)),
              const SizedBox(height: VpAbstand.m),
              Text(text, style: typo.fliesstext),
              if (zusatz != null) ...[
                const SizedBox(height: VpAbstand.m),
                Text(zusatz!, style: typo.fliesstext.copyWith(color: p.tinteLeise)),
              ],
              const SizedBox(height: VpAbstand.xl),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onOk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.akzent,
                    foregroundColor: p.aufAkzent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                  ),
                  child: Text(ok, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                ),
              ),
              if (zweitens != null) ...[
                const SizedBox(height: VpAbstand.xs),
                TextButton(
                  onPressed: onZweitens,
                  style: TextButton.styleFrom(foregroundColor: p.tinteLeise, minimumSize: const Size.fromHeight(44)),
                  child: Text(zweitens!, style: const TextStyle(fontSize: 14.5)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Zeigt ein [VpHinweisBlatt] als Blatt von unten.
Future<T?> zeigeHinweisBlatt<T>(BuildContext context, WidgetBuilder builder) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
