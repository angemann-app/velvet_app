// Rückmeldungen gehen verschlüsselt und mit Einmal-Schlüssel ans Rückmelde-Postfach.
import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:velvetpulse/services/nostr_event_check.dart';
import 'package:velvetpulse/services/rueckmeldung.dart';
import 'package:velvetpulse/widgets/aussprache_melden.dart';

void main() {
  final keys = KeyApi();

  test('Der Text enthält nur Eingaben, Version und Sprache', () {
    final text = Rueckmeldung.text(
      art: RueckmeldungArt.aussprache,
      nachricht: 'Wort: Klitoris\nSo sollte es klingen: kurzes i',
      angaben: ausspracheAngaben(wo: 'Lektion anat_1', stimme: 'victoria', position: const Duration(seconds: 75)),
      kontakt: '  ',
      version: '4.7.0+39',
      sprache: 'de',
    );
    expect(text, startsWith('[VelvetPulse] Aussprache'));
    expect(text, contains('Wo: Lektion anat_1'));
    expect(text, contains('Stimme: Victoria'));
    expect(text, contains('Minute: 1:15'));
    expect(text, contains('Version: 4.7.0+39, Sprache: de'));
    expect(text, isNot(contains('Kontakt')), reason: 'leerer Kontakt wird weggelassen');
  });

  test('Nur das Postfach kann die Nachricht lesen, jede hat einen eigenen Absender-Schlüssel', () {
    final postfachPrivat = keys.generatePrivateKey();
    final postfach = keys.getPublicKey(postfachPrivat);
    final a = Rueckmeldung.event('Hallo', empfaenger: postfach);
    final b = Rueckmeldung.event('Hallo', empfaenger: postfach);
    expect(NostrEventCheck.isValidDirectMessage(a, recipient: postfach), isTrue);
    expect(a['pubkey'], isNot(b['pubkey']));
    expect(a['content'], isNot(contains('Hallo')));
    expect(Nip04().decrypt(postfachPrivat, a['pubkey'] as String, a['content'] as String), 'Hallo');
  });

  test('Das eingebaute Postfach ist ein gültiger öffentlicher Schlüssel', () {
    expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(Rueckmeldung.postfachHex), isTrue);
    expect(Nip19().npubEncode(Rueckmeldung.postfachHex),
        'npub1gdea8j6k38zupe75zmqyss6eg4zzprvfynpmky4t8mamkk0wswtsw7n2k5');
  });

  test('Senden gibt weiter, ob ein Server die Nachricht angenommen hat', () async {
    Map<String, dynamic>? gesendet;
    Rueckmeldung.senderFuerTest = (ev) async {
      gesendet = ev;
      return true;
    };
    addTearDown(() => Rueckmeldung.senderFuerTest = null);
    expect(await Rueckmeldung.senden('Test'), isTrue);
    expect(gesendet!['tags'], [
      ['p', Rueckmeldung.postfachHex]
    ]);
  });
}
