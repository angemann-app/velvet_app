import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/aufnahme_stand.dart';
import 'package:velvetpulse/services/pakete.dart';

void main() {
  late Directory ordner;
  setUp(() async {
    ordner = await Directory.systemTemp.createTemp('vp_dateistand_');
    Pakete.basisFuerTest = ordner.path;
  });
  tearDown(() async {
    Pakete.basisFuerTest = null;
    await ordner.delete(recursive: true);
  });
  test(
      'Installationsmarke ersetzt keine fehlende Datei; Sprache bleibt explizit',
      () async {
    final paket = Directory('${ordner.path}/de-lektionen');
    await paket.create(recursive: true);
    await File('${paket.path}/paket.json').writeAsString('{"version":1}');
    expect(AufnahmeStand.pruefen(['audio/a.opus'], sprache: 'de').vollstaendig,
        isFalse);
    final datei = File('${paket.path}/audio/a.opus');
    await datei.parent.create(recursive: true);
    await datei.writeAsBytes([1, 2, 3]);
    expect(AufnahmeStand.pruefen(['audio/a.opus'], sprache: 'de').vollstaendig,
        isTrue);
    expect(AufnahmeStand.pruefen(['audio/a.opus'], sprache: 'en').vollstaendig,
        isFalse);
    final teilweise =
        AufnahmeStand.pruefen(['audio/a.opus', 'audio/b.opus'], sprache: 'de');
    expect(teilweise.benoetigt, 2);
    expect(teilweise.vorhanden, 1);
    expect(teilweise.vollstaendig, isFalse);
  });
  test('Eingebaute Klänge zählen, leere Liste meldet keinen fertigen Ablauf',
      () {
    expect(
        AufnahmeStand.pruefen(
                ['audio/paar/klangteppich.opus', 'audio/paar/klangschale.opus'])
            .vollstaendig,
        isTrue);
    expect(AufnahmeStand.pruefen([]).vollstaendig, isFalse);
  });
}
