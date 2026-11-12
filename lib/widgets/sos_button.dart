import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/t.dart';
import '../screens/sos/sos_modal.dart';
import '../theme/app_theme.dart';

/// Hilfe in der Kopfzeile: Kapsel mit Rettungsring und dem Wort „Hilfe“ (docs/konzepte/sos-neu.md, Vorschlag A).
/// Bleibt auf allen Hauptseiten erreichbar; Antippen öffnet das Hilfe-Blatt. Das Wort ist neutral genug für den Diskretions-Modus.
/// Sichtbar [size] hoch, die Tippfläche ist mindestens 48 hoch.
class SosButton extends StatelessWidget {
  final double size;

  const SosButton({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final farbe = AppTheme.signal;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: t.sosTitel,
        excludeSemantics: true,
        onTap: () => SosModal.show(context),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => SosModal.show(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Center(
              child: Container(
                constraints: BoxConstraints(minHeight: size),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: ShapeDecoration(
                  color: farbe.withValues(alpha: 0.10),
                  shape: StadiumBorder(side: BorderSide(color: farbe.withValues(alpha: 0.7))),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/rettungsring.svg',
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(farbe, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 6),
                    Text(t.sosTitel, style: TextStyle(color: farbe, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
