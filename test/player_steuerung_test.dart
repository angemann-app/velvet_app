import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/widgets/player_steuerung.dart';

void main() {
  testWidgets('Beenden, Pause und Überspringen sind beschriftet, benannt und funktionieren', (tester) async {
    final gedrueckt = <String>[];
    Future<void> zeige(bool pausiert) => tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: PlayerSteuerung(
              pausiert: pausiert,
              farbe: Colors.amber,
              symbolFarbe: Colors.black,
              onBeenden: () => gedrueckt.add('beenden'),
              onPause: () => gedrueckt.add('pause'),
              onUeberspringen: () => gedrueckt.add('weiter'),
            ),
          ),
        ));

    await zeige(false);
    final semantik = tester.ensureSemantics();
    for (final text in ['Beenden', 'Pause', 'Überspringen']) {
      expect(find.text(text), findsOneWidget);
    }
    expect(find.bySemanticsLabel('Pausieren'), findsOneWidget);
    // Die kleinen Knöpfe benennt ihr Tooltip (wird von TalkBack vorgelesen).
    expect(find.byTooltip('Beenden'), findsOneWidget);
    expect(find.byTooltip('Überspringen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.stop_rounded));
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    expect(gedrueckt, ['beenden', 'pause', 'weiter']);

    await zeige(true);
    expect(find.text('Fortsetzen'), findsOneWidget);
    expect(find.bySemanticsLabel('Fortsetzen'), findsOneWidget);
    semantik.dispose();
  });
}
