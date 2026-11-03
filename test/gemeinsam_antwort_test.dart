import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/gemeinsam_antwort.dart';

void main() {
  test(
      'Nicht versandte Antwort bleibt verdeckt; Gefühl und Freigabe werden erhalten',
      () {
    final lokal = GemeinsamAntwort.lesen(
        const GemeinsamAntwort('Angenehm', gefuehl: 'ruhig').speichern());
    expect(lokal.geteilt, isFalse);
    expect(lokal.gefuehl, 'ruhig');
    final geteilt = GemeinsamAntwort.lesen(
        const GemeinsamAntwort('Angenehm', gefuehl: 'nah', geteilt: true)
            .speichern());
    expect(geteilt.geteilt, isTrue);
    expect(geteilt.text, 'Angenehm');
  });
  test('Alter Klartext bleibt lesbar, ohne eine Übertragung zu behaupten', () {
    final alt = GemeinsamAntwort.lesen('Ein früherer Rückblick');
    expect(alt.text, 'Ein früherer Rückblick');
    expect(alt.geteilt, isFalse);
  });
  test('Drahtformat bleibt auch bei vielen Steuerzeichen unter Nostr-Grenze',
      () {
    expect(() => GemeinsamAntwort('${'a\n' * 1999}a').speichern(),
        throwsFormatException);
    expect(
        () => const GemeinsamAntwort('Text', gefuehl: 'unbekannt').speichern(),
        throwsFormatException);
    expect(
        () => const GemeinsamAntwort('  ').speichern(), throwsFormatException);
  });
}
