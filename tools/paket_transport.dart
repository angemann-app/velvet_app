// Transport-Verschlüsselung für Pakete, die nur auf Cloudflare R2 liegen dürfen (z. B. „Lust im Traum“):
// Sie gehen verschlüsselt in das GitHub-Release „pakete“, der Workflow „Pakete nach R2“ entschlüsselt sie
// mit dem Secret PAKETE_TRANSPORT_KEY, legt sie auf R2 und löscht die verschlüsselte Datei wieder.
// Format: AES-256-GCM, Datei = Nonce (12 Byte) | Geheimtext | Tag (16 Byte).
//
//   dart run tools/paket_transport.dart schluessel                    (legt den Schlüssel an, falls er fehlt)
//   dart run tools/paket_transport.dart verschluesseln <ein.zip> <aus.enc>
//
// Der Schlüssel liegt in C:\TOOLS\velvet-pakete\transport_key.txt (Base64) und wird nie ausgegeben.
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

const schluesselDatei = r'C:\TOOLS\velvet-pakete\transport_key.txt';

Future<void> main(List<String> args) async {
  final datei = File(schluesselDatei);
  if (args.isNotEmpty && args.first == 'schluessel') {
    if (datei.existsSync()) {
      stdout.writeln('Schlüssel vorhanden: $schluesselDatei');
      return;
    }
    final schluessel = await AesGcm.with256bits().newSecretKey();
    datei.writeAsStringSync(base64Encode(await schluessel.extractBytes()));
    stdout.writeln('Schlüssel angelegt: $schluesselDatei');
    return;
  }
  if (args.length != 3 || args.first != 'verschluesseln') {
    stderr.writeln('Aufruf: schluessel | verschluesseln <ein> <aus>');
    exit(64);
  }
  if (!datei.existsSync()) throw StateError('Schlüssel fehlt: $schluesselDatei');
  final aes = AesGcm.with256bits();
  final schluessel = SecretKey(base64Decode(datei.readAsStringSync().trim()));
  final box = await aes.encrypt(File(args[1]).readAsBytesSync(), secretKey: schluessel);
  File(args[2]).writeAsBytesSync([...box.nonce, ...box.cipherText, ...box.mac.bytes]);
  stdout.writeln('verschlüsselt: ${args[2]}');
}
