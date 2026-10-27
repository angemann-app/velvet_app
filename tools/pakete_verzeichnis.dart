// Erzeugt das signierte Paket-Verzeichnis aus build/pakete/eintraege.json (tools/pakete_bauen.py):
// build/pakete/audio-index.json und audio-index.json.sig. Die Laufnummer steigt bei jedem Lauf
// (gespeichert in C:\TOOLS\velvet-pakete\laufnummer.txt, neben dem privaten Schlüssel).
//
//   C:\TOOLS\flutter\bin\dart.bat run tools/pakete_verzeichnis.dart
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

const ordner = r'C:\TOOLS\velvet-pakete';
const r2 = 'https://pub-d8ea2c70c3a04c79b5af86a1f29599b4.r2.dev';
const github = 'https://github.com/angemann-app/velvet_app/releases/download/pakete';

Future<void> main() async {
  final schluessel = jsonDecode(File('$ordner\\paket_key.json').readAsStringSync()) as Map<String, dynamic>;
  final paar = await Ed25519().newKeyPairFromSeed(base64Decode(schluessel['privat_base64'] as String));
  final oeffentlich = base64Encode((await paar.extractPublicKey()).bytes);
  if (oeffentlich != schluessel['oeffentlich_base64']) throw StateError('Schlüsseldatei passt nicht zusammen');

  final laufDatei = File('$ordner\\laufnummer.txt');
  final laufnummer = (laufDatei.existsSync() ? int.parse(laufDatei.readAsStringSync().trim()) : 0) + 1;

  final eintraege = (jsonDecode(File('build/pakete/eintraege.json').readAsStringSync()) as List)
      .cast<Map<String, dynamic>>();
  final verzeichnis = {
    'format': 1,
    'laufnummer': laufnummer,
    'erstellt': DateTime.now().toUtc().toIso8601String(),
    'pakete': [
      for (final e in eintraege)
        {
          'name': e['name'],
          'sprache': e['sprache'],
          'version': e['version'],
          'groesse': e['groesse'],
          'sha256': e['sha256'],
          // Pakete mit „nur_r2“ (z. B. Lust im Traum) liegen nicht auf GitHub.
          'adressen': ['$r2/${e['datei']}', if (e['nur_r2'] != true) '$github/${e['datei']}'],
        },
    ],
  };
  final json = utf8.encode(const JsonEncoder.withIndent('  ').convert(verzeichnis));
  final sig = await Ed25519().sign(json, keyPair: paar);
  File('build/pakete/audio-index.json').writeAsBytesSync(json);
  File('build/pakete/audio-index.json.sig').writeAsStringSync(base64Encode(sig.bytes));
  laufDatei.writeAsStringSync('$laufnummer');
  stdout.writeln('audio-index.json mit Laufnummer $laufnummer und ${eintraege.length} Paketen signiert.');
}
