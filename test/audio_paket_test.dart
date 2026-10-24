import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:velvetpulse/services/sprachausgabe.dart';

List<int> zipMit(Map<String, String> dateien) {
  final archiv = Archive();
  for (final e in dateien.entries) {
    archiv.addFile(ArchiveFile.bytes(e.key, utf8.encode(e.value)));
  }
  return ZipEncoder().encode(archiv);
}

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('audiopaket');
    AudioPaket.ordnerFuerTest = '${tmp.path}/audio_en';
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  MockClient server(List<int> zip, String sha) => MockClient((anfrage) async {
        if (anfrage.url.toString() == AudioPaket.pruefsummeUrl) return http.Response('$sha  paket.zip\n', 200);
        if (anfrage.url.toString() == AudioPaket.paketUrl) return http.Response.bytes(zip, 200);
        return http.Response('nicht gefunden', 404);
      });

  test('Gültiges Paket wird geladen, geprüft und installiert', () async {
    final zip = zipMit({'audio/version.txt': '1', 'audio/paar/victoria_x.opus': 'ton'});
    await AudioPaket.laden(client: server(zip, sha256.convert(zip).toString()));
    expect(AudioPaket.vorhanden, isTrue);
    expect(AudioPaket.datei('audio/paar/victoria_x.opus'), isNotNull);
    expect(AudioPaket.datei('audio/fehlt.opus'), isNull);
  });

  test('Falsche Prüfsumme: nichts wird installiert, ein altes Paket bleibt', () async {
    final alt = zipMit({'audio/version.txt': '1', 'audio/alt.opus': 'alt'});
    await AudioPaket.laden(client: server(alt, sha256.convert(alt).toString()));
    final neu = zipMit({'audio/version.txt': '2', 'audio/neu.opus': 'neu'});
    await expectLater(AudioPaket.laden(client: server(neu, 'a' * 64)), throwsA(isA<StateError>()));
    expect(AudioPaket.datei('audio/alt.opus'), isNotNull);
    expect(AudioPaket.datei('audio/neu.opus'), isNull);
  });

  test('Einträge, die aus dem Ordner ausbrechen wollen, brechen ab', () async {
    final boese = zipMit({'audio/version.txt': '1', '../ausgebrochen.txt': 'x'});
    await expectLater(AudioPaket.laden(client: server(boese, sha256.convert(boese).toString())),
        throwsA(isA<StateError>()));
    expect(File('${tmp.path}/ausgebrochen.txt').existsSync(), isFalse);
    expect(AudioPaket.vorhanden, isFalse);
  });

  test('Paket ohne Versionsdatei gilt als unvollständig', () async {
    final halb = zipMit({'audio/paar/victoria_x.opus': 'ton'});
    await expectLater(AudioPaket.laden(client: server(halb, sha256.convert(halb).toString())),
        throwsA(isA<StateError>()));
    expect(AudioPaket.vorhanden, isFalse);
  });

  test('Löschen entfernt das Paket', () async {
    final zip = zipMit({'audio/version.txt': '1'});
    await AudioPaket.laden(client: server(zip, sha256.convert(zip).toString()));
    await AudioPaket.loeschen();
    expect(AudioPaket.vorhanden, isFalse);
  });
}
