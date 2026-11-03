import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/theme/vp_tokens.dart';
import 'package:velvetpulse/widgets/design/vp_komponenten.dart';

void main() {
  testWidgets(
      'Alle Rahmenvarianten werden fehlerfrei gezeichnet und bleiben bedienbar',
      (tester) async {
    for (final rahmen in VpRahmen.values) {
      var tipps = 0;
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: SizedBox(
                  width: 240,
                  child: VpKarte(
                      rahmen: rahmen,
                      onTap: () => tipps++,
                      child: const Text('Inhalt'))))));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: rahmen.name);
      await tester.tap(find.text('Inhalt'));
      await tester.pumpAndSettle();
      expect(tipps, 1, reason: rahmen.name);
      expect(tester.takeException(), isNull, reason: rahmen.name);
    }
  });
}
