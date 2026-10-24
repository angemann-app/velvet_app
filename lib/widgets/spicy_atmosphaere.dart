import 'dart:math';

import 'package:flutter/material.dart';

/// Der Spicy-Look: ein warmes, rötliches Glühen an den Rändern und ein paar schwebende Funken,
/// über den Inhalt gelegt, ohne Berührungen abzufangen. Nur bei eingeschaltetem Spicy-Modus.
class SpicyAtmosphaere extends StatelessWidget {
  final bool an;
  final Widget child;

  const SpicyAtmosphaere({super.key, required this.an, required this.child});

  static const glut = Color(0xFFE11D48);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      if (an)
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(child: CustomPaint(painter: _GlutMaler())),
          ),
        ),
    ]);
  }
}

class _GlutMaler extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Glühen oben und unten, sehr dezent, damit Texte gut lesbar bleiben.
    for (final (mitte, hoehe) in [(Offset(size.width * 0.5, 0), size.height * 0.35),
                                   (Offset(size.width * 0.5, size.height), size.height * 0.28)]) {
      final rect = Rect.fromCenter(center: mitte, width: size.width * 1.6, height: hoehe * 2);
      canvas.drawOval(
        rect,
        Paint()
          ..shader = RadialGradient(colors: [
            SpicyAtmosphaere.glut.withValues(alpha: 0.13),
            SpicyAtmosphaere.glut.withValues(alpha: 0),
          ]).createShader(rect),
      );
    }
    // Funken: immer dieselben Positionen, damit nichts flackert.
    final r = Random(24);
    for (var i = 0; i < 18; i++) {
      final p = Offset(r.nextDouble() * size.width, r.nextDouble() * size.height);
      canvas.drawCircle(
        p,
        0.8 + r.nextDouble() * 1.6,
        Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.10 + r.nextDouble() * 0.22),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
