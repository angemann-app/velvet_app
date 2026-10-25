// Erzeugt einmalig das Schlüsselpaar des Rückmelde-Postfachs (Funktionswünsche, Fehler, Aussprache).
// Der private Schlüssel kommt nach C:\TOOLS\velvet-feedback\feedback_key.json – nie ins Repository.
// Den öffentlichen Schlüssel (npub) trägt man in lib/services/rueckmeldung.dart ein.
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/feedback_schluessel.dart
import 'dart:convert';
import 'dart:io';

import 'package:nostr_tools/nostr_tools.dart';

void main() {
  final datei = File(r'C:\TOOLS\velvet-feedback\feedback_key.json');
  if (datei.existsSync()) {
    stderr.writeln('Gibt es schon: ${datei.path} – nicht überschrieben.');
    exit(1);
  }
  final keys = KeyApi();
  final privat = keys.generatePrivateKey();
  final oeffentlich = keys.getPublicKey(privat);
  final nip19 = Nip19();
  datei
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert({
      'hinweis': 'Privater Schlüssel des VelvetPulse-Rückmelde-Postfachs. Geheim halten, nicht ins Repository.',
      'nsec': nip19.nsecEncode(privat),
      'npub': nip19.npubEncode(oeffentlich),
      'hex_public': oeffentlich,
    }));
  stdout.writeln('Angelegt: ${datei.path}');
  stdout.writeln('npub: ${nip19.npubEncode(oeffentlich)}');
  stdout.writeln('hex:  $oeffentlich');
}
