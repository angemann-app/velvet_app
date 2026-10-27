// Erzeugt einmalig den Ed25519-Schlüssel, mit dem das Paket-Verzeichnis (audio-index.json) signiert wird.
// Der private Schlüssel kommt nach C:\TOOLS\velvet-pakete\paket_key.json – nie ins Repository.
// Den öffentlichen Schlüssel trägt man fest in lib/services/paket_verzeichnis.dart ein (PaketVerzeichnis.pruefschluessel).
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/paket_schluessel.dart
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final datei = File(r'C:\TOOLS\velvet-pakete\paket_key.json');
  if (datei.existsSync()) {
    stderr.writeln('Gibt es schon: ${datei.path} – nicht überschrieben.');
    exit(1);
  }
  final paar = await Ed25519().newKeyPair();
  final privat = await paar.extractPrivateKeyBytes();
  final oeffentlich = (await paar.extractPublicKey()).bytes;
  datei
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert({
      'hinweis': 'Ed25519-Signierschlüssel für audio-index.json. Geheim halten, nicht ins Repository.',
      'privat_base64': base64Encode(privat),
      'oeffentlich_base64': base64Encode(oeffentlich),
    }));
  stdout.writeln('Angelegt: ${datei.path}');
  stdout.writeln('Öffentlicher Schlüssel (in die App): ${base64Encode(oeffentlich)}');
}
