import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/bild_register.dart';
import '../../services/pakete.dart';
import '../../services/sprache.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_palette.dart';
import '../../theme/vp_tokens.dart';
import 'vp_grafik.dart';

/// Ein Bildfeld nach dem Bildregister (docs/konzepte/designsystem-magazin.md, Abschnitt 3.3).
///
/// Löst in dieser Reihenfolge auf: Spicy-Fassung (Modus an, Datei da) → reguläres Bild → gezeichneter Platzhalter.
/// Es gibt nie eine leere oder schwarze Fläche: Fehlt die Datei oder lädt sie nicht, steht der Platzhalter da.
/// Spätere Illustrationen kommen nur ins Register oder Paket, ein Bildschirm ändert sich dafür nicht.
class VpBildFeld extends StatelessWidget {
  final BildEintrag? _eintrag;
  final String? _id;
  final String? _datei;
  final VpBildFormat? _format;
  final BoxFit? fit;
  final bool alsSeitenverhaeltnis;
  final int? cacheBreite;

  /// Zugänglichkeitstext; ohne Angabe der Alt-Text aus dem Register.
  final String? beschreibung;

  /// Nach ID aus dem Register (`kurs.01.titel`).
  const VpBildFeld(String id,
      {super.key,
      this.fit,
      this.alsSeitenverhaeltnis = false,
      this.beschreibung})
      : cacheBreite = null,
        _id = id,
        _eintrag = null,
        _datei = null,
        _format = null;

  /// Für Bestandsinhalte: der Pfad aus den Inhaltsdateien (`assets/images/cover_01.svg`). Ist er im Register, gelten dessen
  /// Fassungen (Spicy, Englisch); sonst wird das Asset unverändert gezeigt.
  VpBildFeld.pfad(String pfad,
      {super.key,
      VpBildFormat? format,
      this.fit,
      this.alsSeitenverhaeltnis = false,
      this.beschreibung})
      : cacheBreite = null,
        _id = null,
        _eintrag = BildRegister.nachPfad(pfad) ??
            BildEintrag(
              id: pfad,
              format: format ?? VpBildFormat.kopf,
              normal: pfad,
              altDe: '',
              altEn: '',
            ),
        _datei = null,
        _format = format;

  /// Eine Datei auf dem Gerät (Paketbild, Foto der Lektion). Fehlt sie, steht der Platzhalter da.
  /// [cacheBreite] begrenzt die Auflösung im Speicher (große Studien).
  const VpBildFeld.datei(String pfad,
      {super.key,
      required VpBildFormat format,
      this.fit,
      this.alsSeitenverhaeltnis = false,
      this.beschreibung,
      this.cacheBreite})
      : _id = null,
        _eintrag = null,
        _datei = pfad,
        _format = format;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: Pakete.stand,
        builder: (context, _, __) => _baueBild(context),
      );

  Widget _baueBild(BuildContext context) {
    final id = _id;
    final eintrag = _eintrag ?? (id != null ? BildRegister.eintrag(id) : null);
    final format = _format ?? eintrag?.format ?? VpBildFormat.kopf;
    final datei = _datei;
    final saatgut = _id ?? eintrag?.id ?? datei ?? 'bild';
    final platzhalter = VpPlatzhalter(saatgut: saatgut, format: format);

    Widget inhalt;
    final quelle = datei != null
        ? BildQuelle.datei(datei)
        : (eintrag == null ? null : BildRegister.loese(eintrag));
    if (quelle == null) {
      inhalt = platzhalter;
    } else if (quelle.istDatei) {
      final f = File(quelle.pfad);
      inhalt = f.existsSync()
          ? Image.file(f,
              fit: fit ?? _fuer(format),
              cacheWidth: cacheBreite,
              errorBuilder: (_, __, ___) => platzhalter)
          : platzhalter;
    } else if (quelle.istSvg) {
      final pfad =
          (format == VpBildFormat.diagramm || format == VpBildFormat.studie) &&
                  eintrag?.englisch == null
              ? Sprache.bild(quelle.pfad)
              : quelle.pfad;
      inhalt = SvgPicture.asset(pfad,
          fit: fit ?? _fuer(format),
          placeholderBuilder: (_) => platzhalter,
          errorBuilder: (_, __, ___) => platzhalter);
    } else {
      inhalt = Image.asset(quelle.pfad,
          fit: fit ?? _fuer(format), errorBuilder: (_, __, ___) => platzhalter);
    }

    final alt = beschreibung ?? eintrag?.alt(Sprache.englisch);
    Widget feld = inhalt;
    if (alsSeitenverhaeltnis)
      feld = AspectRatio(aspectRatio: format.verhaeltnis, child: feld);
    if (alt != null && alt.isNotEmpty)
      feld = Semantics(
          image: true, label: alt, child: ExcludeSemantics(child: feld));
    return feld;
  }

  static BoxFit _fuer(VpBildFormat f) =>
      f == VpBildFormat.diagramm ? BoxFit.contain : BoxFit.cover;
}

/// Der gezeichnete Platzhalter: Raster, Konstruktionsbögen, Eck- und Kreuzmarken in den Farben der aktuellen Atmosphäre.
/// Aus der ID deterministisch abgeleitet, jedes Bild sieht also anders, aber bei jedem Start gleich aus. In Spicy dichter
/// (Schraffur, Vignette) und wärmer. Gedacht als gestaltetes Zwischenstück, nicht als Fehleranzeige.
class VpPlatzhalter extends StatelessWidget {
  final String saatgut;
  final VpBildFormat format;

  const VpPlatzhalter({super.key, required this.saatgut, required this.format});

  @override
  Widget build(BuildContext context) {
    final spicy = AppTheme.paletteId == VpPaletteId.spicy;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _PlatzhalterMaler(
          saat: _fnv(saatgut),
          linie: AppTheme.linieStark,
          akzent: AppTheme.akzent,
          flaeche: AppTheme.papierVertieft,
          tiefe: AppTheme.tiefe,
          spicy: spicy,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Stabiler Hash (Dart-Hashcodes von Strings sind nicht über Läufe garantiert).
int _fnv(String s) {
  var h = 0x811C9DC5;
  for (final u in s.codeUnits) {
    h = ((h ^ u) * 0x01000193) & 0x7FFFFFFF;
  }
  return h;
}

class _PlatzhalterMaler extends CustomPainter {
  final int saat;
  final Color linie, akzent, flaeche, tiefe;
  final bool spicy;

  const _PlatzhalterMaler({
    required this.saat,
    required this.linie,
    required this.akzent,
    required this.flaeche,
    required this.tiefe,
    required this.spicy,
  });

  @override
  void paint(Canvas canvas, Size s) {
    if (s.isEmpty) return;
    final r = math.Random(saat);
    canvas.clipRect(Offset.zero & s);
    canvas.drawRect(Offset.zero & s, Paint()..color = flaeche);

    FeinRaster(linie.withValues(alpha: 0.55)).paint(canvas, s);

    // Zirkelschlag um einen aus der ID abgeleiteten Mittelpunkt.
    final mitte =
        Offset(0.2 + r.nextDouble() * 0.6, 0.3 + r.nextDouble() * 0.5);
    KonstruktionsBogen(akzent.withValues(alpha: 0.7),
            mitte: mitte, ringe: 3 + (saat % 2))
        .paint(canvas, s);

    // Eine Orientierungsachse, leicht geneigt.
    final achse = Paint()
      ..color = linie.withValues(alpha: 0.6)
      ..strokeWidth = 0.8;
    final x0 = s.width * (0.15 + r.nextDouble() * 0.2);
    canvas.drawLine(Offset(x0, s.height * 0.12),
        Offset(x0 + s.width * 0.08, s.height * 0.88), achse);

    // Spicy: dichte Schraffur in einem Streifen und weiche Vignette statt Leere.
    if (spicy) {
      final schraff = Paint()
        ..color = akzent.withValues(alpha: 0.22)
        ..strokeWidth = 0.7;
      final bandBreite = s.width * 0.34;
      final bandX = s.width * (0.45 + r.nextDouble() * 0.2);
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(bandX, 0, bandBreite, s.height));
      for (double d = -s.height; d < bandBreite + s.height; d += 4) {
        canvas.drawLine(Offset(bandX + d, s.height),
            Offset(bandX + d + s.height * 0.6, 0), schraff);
      }
      canvas.restore();
      canvas.drawRect(
        Offset.zero & s,
        Paint()
          ..shader = RadialGradient(
            radius: 1.0,
            colors: [tiefe.withValues(alpha: 0), tiefe.withValues(alpha: 0.5)],
            stops: const [0.5, 1],
          ).createShader(Offset.zero & s),
      );
    }

    EckMarken(linie).paint(canvas, s);
    final kreuz = KreuzMarke(linie.withValues(alpha: 0.9));
    canvas.save();
    canvas.translate(s.width * mitte.dx - 5, s.height * mitte.dy - 5);
    kreuz.paint(canvas, const Size(10, 10));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlatzhalterMaler o) =>
      o.saat != saat ||
      o.linie != linie ||
      o.akzent != akzent ||
      o.flaeche != flaeche ||
      o.spicy != spicy;
}
