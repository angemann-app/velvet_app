// Signiertes Paket-Verzeichnis: nur gültig signierte, nicht zurückgerollte Verzeichnisse zählen.
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/paket_verzeichnis.dart';
import 'package:velvetpulse/services/sprachausgabe.dart';

const adresse = 'https://test.example/audio-index.json';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SimpleKeyPair schluessel;
  late String oeffentlich;
  late Directory tmp;

  setUpAll(() async {
    schluessel = await Ed25519().newKeyPair();
    oeffentlich = base64Encode((await schluessel.extractPublicKey()).bytes);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PaketVerzeichnis.vergessen();
    tmp = Directory.systemTemp.createTempSync('pakete');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  Map<String, dynamic> eintrag({String sha = '', List<String>? adressen, int version = 3}) => {
        'name': 'audio-en',
        'sprache': 'en',
        'version': version,
        'groesse': 10,
        'sha256': sha.isEmpty ? 'a' * 64 : sha,
        'adressen': adressen ?? ['https://test.example/audio-en.zip'],
      };

  Future<(Uint8List, String)> verzeichnis(int laufnummer, {int format = 1, List<Map<String, dynamic>>? pakete,
      SimpleKeyPair? mit}) async {
    final json = utf8.encode(jsonEncode({'format': format, 'laufnummer': laufnummer, 'pakete': pakete ?? [eintrag()]}));
    final sig = await Ed25519().sign(json, keyPair: mit ?? schluessel);
    return (Uint8List.fromList(json), base64Encode(sig.bytes));
  }

  MockClient server(Map<String, http.Response> antworten) =>
      MockClient((a) async => antworten[a.url.toString()] ?? http.Response('nicht gefunden', 404));

  Future<PaketVerzeichnis?> laden(http.Client c) => PaketVerzeichnis.laden(
      client: c, adressenFuerTest: [adresse], schluesselFuerTest: oeffentlich, ablageFuerTest: () async => tmp.path);

  test('Gültig signiertes Verzeichnis wird angenommen', () async {
    final (json, sig) = await verzeichnis(1);
    final v = await PaketVerzeichnis.pruefen(json, sig, schluessel: oeffentlich);
    expect(v.laufnummer, 1);
    expect(v.paket('audio-en')!.version, 3);
    expect(v.paket('gibt-es-nicht'), isNull);
  });

  test('Verändertes Verzeichnis oder fremder Schlüssel werden abgelehnt', () async {
    final (json, sig) = await verzeichnis(1);
    final veraendert = Uint8List.fromList(json)..[json.length - 3] ^= 1;
    await expectLater(PaketVerzeichnis.pruefen(veraendert, sig, schluessel: oeffentlich), throwsFormatException);
    final (json2, sig2) = await verzeichnis(1, mit: await Ed25519().newKeyPair());
    await expectLater(PaketVerzeichnis.pruefen(json2, sig2, schluessel: oeffentlich), throwsFormatException);
  });

  test('Unbekanntes Format und Adressen ohne https werden abgelehnt', () async {
    final (json, sig) = await verzeichnis(1, format: 2);
    await expectLater(PaketVerzeichnis.pruefen(json, sig, schluessel: oeffentlich), throwsFormatException);
    final (json2, sig2) = await verzeichnis(1, pakete: [eintrag(adressen: ['http://unsicher.example/a.zip'])]);
    await expectLater(PaketVerzeichnis.pruefen(json2, sig2, schluessel: oeffentlich), throwsFormatException);
  });

  test('Kein Zurückrollen: ein älteres, gültig signiertes Verzeichnis wird nicht angenommen', () async {
    final (neu, neuSig) = await verzeichnis(5);
    expect((await laden(server({adresse: http.Response.bytes(neu, 200), '$adresse.sig': http.Response(neuSig, 200)})))!
        .laufnummer, 5);
    final (alt, altSig) = await verzeichnis(4);
    final v = await laden(server({adresse: http.Response.bytes(alt, 200), '$adresse.sig': http.Response(altSig, 200)}));
    expect(v!.laufnummer, 5, reason: 'die gespeicherte neuere Fassung bleibt');
  });

  test('Offline: die zuletzt angenommene Fassung wird erneut geprüft und genutzt', () async {
    final (json, sig) = await verzeichnis(2);
    await laden(server({adresse: http.Response.bytes(json, 200), '$adresse.sig': http.Response(sig, 200)}));
    final offline = MockClient((_) async => throw const SocketException('offline'));
    expect((await laden(offline))!.laufnummer, 2);
    File('${tmp.path}/audio-index.json').writeAsStringSync('{"format":1,"laufnummer":9,"pakete":[]}');
    expect(await laden(offline), isNull, reason: 'manipulierte Ablage zählt nicht');
  });

  group('Englisches Audiopaket über das Verzeichnis', () {
    List<int> zipMit(String version) {
      final a = Archive()..addFile(ArchiveFile.bytes('audio/version.txt', utf8.encode(version)));
      return ZipEncoder().encode(a);
    }

    setUp(() => AudioPaket.ordnerFuerTest = '${tmp.path}/audio_en');

    test('Erste Adresse gestört: die zweite wird genommen, Prüfsumme aus dem Verzeichnis', () async {
      final zip = zipMit('${AudioPaket.version}');
      final v = PaketVerzeichnis(1, [
        PaketEintrag.ausJson(eintrag(
            sha: sha256.convert(zip).toString(),
            adressen: ['https://kaputt.example/a.zip', 'https://spiegel.example/a.zip'])),
      ]);
      await AudioPaket.laden(
          verzeichnis: v,
          client: server({'https://spiegel.example/a.zip': http.Response.bytes(zip, 200)}));
      expect(AudioPaket.installierteVersion, AudioPaket.version);
    });

    test('Falsche Prüfsumme im Verzeichnis: nichts wird installiert', () async {
      final zip = zipMit('${AudioPaket.version}');
      final v = PaketVerzeichnis(1, [PaketEintrag.ausJson(eintrag())]);
      await expectLater(
          AudioPaket.laden(
              verzeichnis: v, client: server({'https://test.example/audio-en.zip': http.Response.bytes(zip, 200)})),
          throwsA(isA<StateError>()));
      expect(AudioPaket.vorhanden, isFalse);
    });

    test('Verzeichnis kennt nur eine ältere Version: Rückfall auf die feste Adresse', () async {
      final zip = zipMit('${AudioPaket.version}');
      final v = PaketVerzeichnis(1, [PaketEintrag.ausJson(eintrag(version: AudioPaket.version - 1))]);
      await AudioPaket.laden(
          verzeichnis: v,
          client: server({
            AudioPaket.pruefsummeUrl: http.Response('${sha256.convert(zip)}  paket.zip\n', 200),
            AudioPaket.paketUrl: http.Response.bytes(zip, 200),
          }));
      expect(AudioPaket.installierteVersion, AudioPaket.version);
    });
  });
}
