import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/bild_register.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';

/// Wiederverwendbare Gestaltungselemente des Magazinstils (Kreuz- und Eckmarken, Maßlinien, Raster, Konstruktionsbögen,
/// Passepartout). Alle sind in Dart gezeichnet und in `assets/data/bilder.json` unter `grafik` geführt; Bildschirme nennen
/// nur die ID. Die Farben kommen aus der aktuellen Atmosphäre.
class VpGrafik extends StatelessWidget {
  final String id;
  final Color? farbe;
  final double? breite;
  final double? hoehe;

  const VpGrafik(this.id, {super.key, this.farbe, this.breite, this.hoehe});

  /// Feine Linie quer über die Breite (Trenner).
  static Widget trenner({String id = 'linie.haar', Color? farbe}) => VpGrafik(id, farbe: farbe, hoehe: id == 'linie.doppel' ? 6 : 14);

  @override
  Widget build(BuildContext context) {
    assert(BildRegister.grafikIds.isEmpty || BildRegister.grafikIds.contains(id), 'Unbekannte Grafik: $id');
    final c = farbe ?? AppTheme.linieStark;
    final maler = malerFuer(id, c);
    return SizedBox(width: breite ?? double.infinity, height: hoehe, child: CustomPaint(painter: maler));
  }

  static CustomPainter malerFuer(String id, Color farbe) => switch (id) {
        'marke.kreuz' => KreuzMarke(farbe),
        'marke.eck' => EckMarken(farbe),
        'linie.mass' => MassLinie(farbe),
        'linie.doppel' => DoppelLinie(farbe),
        'raster.fein' => FeinRaster(farbe),
        'bogen.konstruktion' => KonstruktionsBogen(farbe),
        'rahmen.passepartout' => Passepartout(farbe),
        _ => HaarLinie(farbe),
      };
}

Paint _strich(Color c, [double breite = VpLinie.haar]) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = breite;

class HaarLinie extends CustomPainter {
  final Color farbe;
  const HaarLinie(this.farbe);
  @override
  void paint(Canvas canvas, Size s) => canvas.drawLine(Offset(0, s.height / 2), Offset(s.width, s.height / 2), _strich(farbe));
  @override
  bool shouldRepaint(covariant HaarLinie o) => o.farbe != farbe;
}

class DoppelLinie extends CustomPainter {
  final Color farbe;
  const DoppelLinie(this.farbe);
  @override
  void paint(Canvas canvas, Size s) {
    final y = s.height / 2;
    canvas.drawLine(Offset(0, y - 1.5), Offset(s.width, y - 1.5), _strich(farbe));
    canvas.drawLine(Offset(0, y + 1.5), Offset(s.width, y + 1.5), _strich(farbe, 0.5));
  }

  @override
  bool shouldRepaint(covariant DoppelLinie o) => o.farbe != farbe;
}

/// Maßlinie: Linie mit Endstrichen und einem kleinen Strich in der Mitte.
class MassLinie extends CustomPainter {
  final Color farbe;
  const MassLinie(this.farbe);
  @override
  void paint(Canvas canvas, Size s) {
    final y = s.height / 2;
    final p = _strich(farbe);
    canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    for (final x in [0.0, s.width]) {
      canvas.drawLine(Offset(x, y - 5), Offset(x, y + 5), p);
    }
    canvas.drawLine(Offset(s.width / 2, y - 3), Offset(s.width / 2, y + 3), p);
  }

  @override
  bool shouldRepaint(covariant MassLinie o) => o.farbe != farbe;
}

class KreuzMarke extends CustomPainter {
  final Color farbe;
  final double arm;
  const KreuzMarke(this.farbe, {this.arm = 5});
  @override
  void paint(Canvas canvas, Size s) {
    final m = s.center(Offset.zero);
    final p = _strich(farbe);
    canvas.drawLine(m.translate(-arm, 0), m.translate(arm, 0), p);
    canvas.drawLine(m.translate(0, -arm), m.translate(0, arm), p);
  }

  @override
  bool shouldRepaint(covariant KreuzMarke o) => o.farbe != farbe || o.arm != arm;
}

/// L-förmige Eckmarken in den vier Ecken, wie Schnittmarken im Druck.
class EckMarken extends CustomPainter {
  final Color farbe;
  final double abstand;
  final double laenge;
  const EckMarken(this.farbe, {this.abstand = 8, this.laenge = 12});
  @override
  void paint(Canvas canvas, Size s) {
    final p = _strich(farbe);
    final a = abstand, l = laenge, w = s.width, h = s.height;
    for (final (x, y, dx, dy) in [(a, a, 1.0, 1.0), (w - a, a, -1.0, 1.0), (a, h - a, 1.0, -1.0), (w - a, h - a, -1.0, -1.0)]) {
      canvas.drawLine(Offset(x, y), Offset(x + dx * l, y), p);
      canvas.drawLine(Offset(x, y), Offset(x, y + dy * l), p);
    }
  }

  @override
  bool shouldRepaint(covariant EckMarken o) => o.farbe != farbe || o.abstand != abstand;
}

class FeinRaster extends CustomPainter {
  final Color farbe;
  final double raster;
  const FeinRaster(this.farbe, {this.raster = 24});
  @override
  void paint(Canvas canvas, Size s) {
    final p = _strich(farbe.withValues(alpha: farbe.a * 0.35), 0.5);
    for (double x = raster; x < s.width; x += raster) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = raster; y < s.height; y += raster) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant FeinRaster o) => o.farbe != farbe || o.raster != raster;
}

/// Konstruktionsbögen: gestrichelt wirkende Kreisbögen um einen Mittelpunkt, dazu eine Achse.
class KonstruktionsBogen extends CustomPainter {
  final Color farbe;
  final Offset mitte;
  final int ringe;
  const KonstruktionsBogen(this.farbe, {this.mitte = const Offset(0.7, 0.62), this.ringe = 3});
  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width * mitte.dx, s.height * mitte.dy);
    final p = _strich(farbe);
    final basis = s.shortestSide * 0.28;
    for (var i = 0; i < ringe; i++) {
      final r = basis * (1 + i * 0.55);
      // Jeder Ring nur als Bogen, nie als voller Kreis: wirkt wie ein Zirkelschlag.
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), math.pi * (0.9 + i * 0.12), math.pi * 0.95, false, p);
    }
    canvas.drawLine(Offset(c.dx, 0), Offset(c.dx, s.height), _strich(farbe.withValues(alpha: farbe.a * 0.6), 0.5));
  }

  @override
  bool shouldRepaint(covariant KonstruktionsBogen o) => o.farbe != farbe || o.mitte != mitte || o.ringe != ringe;
}

class Passepartout extends CustomPainter {
  final Color farbe;
  final double rand;
  const Passepartout(this.farbe, {this.rand = 6});
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height).deflate(0.5), _strich(farbe, VpLinie.rahmen));
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height).deflate(rand), _strich(farbe.withValues(alpha: farbe.a * 0.6)));
  }

  @override
  bool shouldRepaint(covariant Passepartout o) => o.farbe != farbe || o.rand != rand;
}
