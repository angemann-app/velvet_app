// Schickt eine echte Test-Rückmeldung über die Nostr-Server ans Rückmelde-Postfach.
// Abholen danach mit: C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart
//   flutter test test_live/rueckmeldung_live_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/rueckmeldung.dart';

void main() {
  test('Test-Rückmeldung kommt bei mindestens einem Server an', () async {
    final text = Rueckmeldung.text(
      art: RueckmeldungArt.wunsch,
      nachricht: 'Testnachricht: Der Rückmelde-Kanal funktioniert.',
      version: 'Test',
      sprache: 'de',
    );
    expect(await Rueckmeldung.senden(text), isTrue);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
