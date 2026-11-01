import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import 'vp_grafik.dart';

/// Die redaktionellen Bausteine des Magazinstils (docs/konzepte/designsystem-magazin.md, Abschnitt 3.2).
/// Alle Werte kommen aus `VpTokens`/`AppTheme`; Bildschirme setzen keine eigenen Farben, Radien oder Linienstärken.

/// Kleine Versalienzeile über Titeln („DEIN NÄCHSTER SCHRITT“).
class VpEyebrow extends StatelessWidget {
  final String text;
  final Color? farbe;
  const VpEyebrow(this.text, {super.key, this.farbe});

  @override
  Widget build(BuildContext context) {
    final stil = context.vp.typo.eyebrow;
    return Text(text.toUpperCase(), style: farbe == null ? stil : stil.copyWith(color: farbe));
  }
}

/// Abschnittskopf: Eyebrow, Serif-Titel, optional ein Satz, darunter eine Haarlinie (oder Maßlinie).
class VpAbschnitt extends StatelessWidget {
  final String? eyebrow;
  final String titel;
  final String? text;
  final Widget? trailing;
  final bool linie;
  final bool massLinie;
  final EdgeInsetsGeometry padding;

  const VpAbschnitt({
    super.key,
    this.eyebrow,
    required this.titel,
    this.text,
    this.trailing,
    this.linie = true,
    this.massLinie = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final typo = context.vp.typo;
    return Padding(
      padding: padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (eyebrow != null) ...[VpEyebrow(eyebrow!), const SizedBox(height: VpAbstand.xs)],
              Text(titel, style: typo.ueberschrift),
              if (text != null) ...[
                const SizedBox(height: VpAbstand.xs),
                Text(text!, style: typo.fliesstextKlein),
              ],
            ]),
          ),
          if (trailing != null) trailing!,
        ]),
        if (linie) ...[
          const SizedBox(height: VpAbstand.m),
          massLinie ? VpGrafik.trenner(id: 'linie.mass') : VpGrafik.trenner(),
        ],
      ]),
    );
  }
}

/// Karte mit Rahmenvariante. `haar`: Papier mit Haarlinie; `gerahmt`: zusätzlich Eckmarken; `akzent`: Akzentlinie links;
/// `keiner`: nur Inhalt (Nicht alles braucht einen Rahmen).
class VpKarte extends StatelessWidget {
  final Widget child;
  final VpRahmen rahmen;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const VpKarte({
    super.key,
    required this.child,
    this.rahmen = VpRahmen.haar,
    this.padding = const EdgeInsets.all(VpAbstand.l),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(VpRadius.karte);
    Widget inhalt = Padding(padding: padding, child: child);
    if (rahmen == VpRahmen.gerahmt) {
      inhalt = Stack(children: [
        inhalt,
        Positioned.fill(
          child: IgnorePointer(child: CustomPaint(painter: EckMarken(AppTheme.linieStark, abstand: 5, laenge: 9))),
        ),
      ]);
    }
    if (rahmen == VpRahmen.keiner) {
      return onTap == null ? inhalt : InkWell(onTap: onTap, borderRadius: radius, child: inhalt);
    }
    final deko = BoxDecoration(
      color: AppTheme.papierErhoben,
      borderRadius: radius,
      border: rahmen == VpRahmen.akzent
          ? Border(
              left: BorderSide(color: AppTheme.akzentTief, width: VpLinie.akzent),
              top: BorderSide(color: AppTheme.linie, width: VpLinie.haar),
              right: BorderSide(color: AppTheme.linie, width: VpLinie.haar),
              bottom: BorderSide(color: AppTheme.linie, width: VpLinie.haar),
            )
          : Border.all(color: AppTheme.linie, width: VpLinie.haar),
    );
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: deko,
        child: InkWell(onTap: onTap, borderRadius: radius, child: inhalt),
      ),
    );
  }
}

/// Fortschritt als feine Linie mit Teilstrichen (je Lektion ein Strich) statt eines runden Balkens.
class VpFortschritt extends StatelessWidget {
  /// 0 bis 1.
  final double wert;

  /// Zahl der Teilstriche (0 = keine).
  final int schritte;
  final double hoehe;

  const VpFortschritt({super.key, required this.wert, this.schritte = 0, this.hoehe = 10});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: '${(wert * 100).round()} %',
      child: SizedBox(
        height: hoehe,
        child: CustomPaint(
          painter: _FortschrittMaler(wert.clamp(0, 1).toDouble(), schritte, AppTheme.linieStark, AppTheme.akzentTief),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FortschrittMaler extends CustomPainter {
  final double wert;
  final int schritte;
  final Color spur, fuellung;
  const _FortschrittMaler(this.wert, this.schritte, this.spur, this.fuellung);

  @override
  void paint(Canvas canvas, Size s) {
    final y = s.height / 2;
    final spurStift = Paint()
      ..color = spur
      ..strokeWidth = VpLinie.haar;
    final fuellStift = Paint()
      ..color = fuellung
      ..strokeWidth = VpLinie.akzent
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(Offset(0, y), Offset(s.width, y), spurStift);
    if (wert > 0) canvas.drawLine(Offset(0, y), Offset(s.width * wert, y), fuellStift);
    for (var i = 0; i <= schritte && schritte > 0; i++) {
      final x = s.width * i / schritte;
      final erreicht = x <= s.width * wert + 0.5;
      canvas.drawLine(Offset(x, y - 3), Offset(x, y + 3), erreicht && wert > 0 ? fuellStift : spurStift);
    }
  }

  @override
  bool shouldRepaint(covariant _FortschrittMaler o) =>
      o.wert != wert || o.schritte != schritte || o.spur != spur || o.fuellung != fuellung;
}

/// Auswahl-Chip: eckig, Haarlinie, gewählt mit Akzentton. Linien-Icon statt Emoji.
class VpChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool gewaehlt;
  final VoidCallback? onTap;

  const VpChip({super.key, required this.label, this.icon, this.gewaehlt = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final vordergrund = gewaehlt ? AppTheme.akzentTief : AppTheme.tinteLeise;
    return Semantics(
      button: true,
      selected: gewaehlt,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(VpRadius.chip),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: VpAbstand.m, vertical: VpAbstand.s),
            decoration: BoxDecoration(
              color: gewaehlt ? AppTheme.akzentLeise : Colors.transparent,
              borderRadius: BorderRadius.circular(VpRadius.chip),
              border: Border.all(color: gewaehlt ? AppTheme.akzentTief : AppTheme.linieStark, width: gewaehlt ? VpLinie.rahmen : VpLinie.haar),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[Icon(icon, size: 15, color: vordergrund), const SizedBox(width: 6)],
              Text(label,
                  style: TextStyle(
                      fontSize: 12.5, fontWeight: gewaehlt ? FontWeight.w700 : FontWeight.w500, color: gewaehlt ? AppTheme.tinte : AppTheme.tinteLeise)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Eine Zeile einer redaktionellen Liste: Nummer in Serif, Titel, Teaser, Fortschritt, rechts ein Bild. Darunter eine Haarlinie.
class VpListenzeile extends StatelessWidget {
  final String? nummer;
  final String titel;
  final String? teaser;
  final String? meta;
  final Widget? bild;
  final double bildGroesse;
  final double? fortschritt;
  final int fortschrittSchritte;
  final String? fortschrittText;
  final bool erledigt;
  final bool offen;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool trennlinie;

  const VpListenzeile({
    super.key,
    this.nummer,
    required this.titel,
    this.teaser,
    this.meta,
    this.bild,
    this.bildGroesse = 68,
    this.fortschritt,
    this.fortschrittSchritte = 0,
    this.fortschrittText,
    this.erledigt = false,
    this.offen = false,
    this.onTap,
    this.trailing,
    this.trennlinie = true,
  });

  @override
  Widget build(BuildContext context) {
    final typo = context.vp.typo;
    return Semantics(
      button: onTap != null,
      expanded: onTap != null ? offen : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: VpAbstand.l),
            decoration: BoxDecoration(
              border: trennlinie ? Border(bottom: BorderSide(color: AppTheme.linie, width: VpLinie.haar)) : null,
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (nummer != null)
                SizedBox(
                  width: 34,
                  child: Text(nummer!, style: typo.zahl.copyWith(color: erledigt ? AppTheme.tinteStumm : AppTheme.akzentTief)),
                ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(titel, style: typo.titel),
                  if (teaser != null) ...[
                    const SizedBox(height: VpAbstand.xs),
                    Text(teaser!, maxLines: 3, overflow: TextOverflow.ellipsis, style: typo.fliesstextKlein),
                  ],
                  if (meta != null) ...[
                    const SizedBox(height: VpAbstand.xs),
                    Text(meta!, style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm)),
                  ],
                  if (fortschritt != null) ...[
                    const SizedBox(height: VpAbstand.m),
                    Row(children: [
                      Expanded(child: VpFortschritt(wert: fortschritt!, schritte: fortschrittSchritte)),
                      if (fortschrittText != null) ...[
                        const SizedBox(width: VpAbstand.m),
                        Text(fortschrittText!, style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm)),
                      ],
                    ]),
                  ],
                ]),
              ),
              if (bild != null) ...[
                const SizedBox(width: VpAbstand.l),
                ClipRRect(
                  borderRadius: BorderRadius.circular(VpRadius.chip),
                  child: SizedBox(width: bildGroesse, height: bildGroesse, child: bild),
                ),
              ],
              if (trailing != null) ...[const SizedBox(width: VpAbstand.s), trailing!],
            ]),
          ),
        ),
      ),
    );
  }
}

/// Ruhiger Leer- oder Fehlerzustand: ein gezeichnetes Motiv (Konstruktionsbögen mit Symbol), Serif-Titel und ein Satz.
/// Die Handlungsknöpfe setzt der Aufrufer darunter. Ersetzt die einzelnen Kreise mit großem Symbol.
class VpLeerzustand extends StatelessWidget {
  final IconData icon;
  final String titel;
  final String? text;

  const VpLeerzustand({super.key, required this.icon, required this.titel, this.text});

  @override
  Widget build(BuildContext context) {
    final typo = context.vp.typo;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 150,
        height: 104,
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
            child: CustomPaint(painter: KonstruktionsBogen(AppTheme.linieStark, mitte: const Offset(0.5, 0.62), ringe: 3)),
          ),
          Icon(icon, color: AppTheme.akzentTief, size: 40),
        ]),
      ),
      const SizedBox(height: VpAbstand.l),
      Text(titel, textAlign: TextAlign.center, style: typo.ueberschrift.copyWith(fontSize: 21)),
      if (text != null) ...[
        const SizedBox(height: VpAbstand.s),
        Text(text!, textAlign: TextAlign.center, style: typo.fliesstextKlein.copyWith(height: 1.5)),
      ],
    ]);
  }
}
