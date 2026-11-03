import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/traumpraxis_hoeren.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/services/pakete.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/services/wiedergabe_plaene.dart';

const _katalog = 'assets/audio/traum/traumpraxis.json';

Map<String, dynamic> _json() =>
    jsonDecode(File(_katalog).readAsStringSync()) as Map<String, dynamic>;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory ordner;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
    ordner = Directory.systemTemp.createTempSync('praxis');
    Pakete.basisFuerTest = ordner.path;
  });
  tearDown(() {
    Pakete.basisFuerTest = null;
    ordner.deleteSync(recursive: true);
  });

  void paketLegen() {
    final ziel = File('${ordner.path}/de-gefuehrt/${PraxisBegleitung.katalogPfad}');
    ziel.parent.createSync(recursive: true);
    ziel.writeAsStringSync(File(_katalog).readAsStringSync());
  }

  WiedergabePlan plan({String id = 'praxis_abend', String stimme = 'martin', String? pfad, bool spicy = true}) =>
      WiedergabePlan(
          art: WiedergabeArt.praxis,
          id: id,
          sprache: 'de',
          spicy: spicy,
          parameter: {'stimme': stimme},
          abschnitte: [
            WiedergabeAbschnitt(
                id: id,
                art: AbschnittArt.sprache,
                dauer: const Duration(minutes: 3),
                pfad: pfad ?? 'audio/traum/${stimme}_$id.opus',
                aufnahmeEnde: true)
          ]);

  test('Katalog: drei Begleitungen mit beiden Stimmen, alle Spicy', () {
    final k = PraxisBegleitung.ausJson(_json());
    expect(k.map((b) => b.id), PraxisBegleitung.ids);
    for (final b in k) {
      expect(b.aufnahmen.keys, unorderedEquals(PraxisBegleitung.stimmen));
      expect(b.text, isNotEmpty);
    }
  });

  test('Katalog: Prüfsummen passen zu den deutschen Aufnahmen im Repository', () {
    final j = _json();
    for (final e in j['eintraege'] as List) {
      for (final a in (e['aufnahmen'] as Map).values) {
        final datei = File('assets/${a['pfad']}');
        expect(datei.existsSync(), isTrue, reason: a['pfad']);
        expect(sha256.convert(datei.readAsBytesSync()).toString(), a['sha256']);
      }
    }
  });

  test('Katalog: manipulierte Einträge werden abgelehnt', () {
    for (final aendern in <void Function(Map<String, dynamic>)>[
      (j) => j['spicy'] = false,
      (j) => j['mindestalter'] = 16,
      (j) => (j['eintraege'] as List)[0]['spicy'] = false,
      (j) => (j['eintraege'] as List)[0]['id'] = 'praxis_fremd',
      (j) => (j['eintraege'] as List).removeLast(),
      (j) => (j['eintraege'] as List)[1]['aufnahmen']['martin']['pfad'] = 'audio/traum/martin_andere.opus',
      (j) => (j['eintraege'] as List)[2]['aufnahmen']['victoria']['dauerMs'] = 5,
    ]) {
      final j = _json();
      aendern(j);
      expect(() => PraxisBegleitung.ausJson(j), throwsFormatException);
    }
  });

  test('Ohne Paket gibt es keinen Katalog und keine Wiedergabe', () async {
    expect(await PraxisBegleitung.laden(sprache: 'de'), isNull);
    await StorageService.setSpicyMode(true);
    await expectLater(WiedergabePlaene.ergaenzen(plan()), throwsStateError);
  });

  test('Spicy kommt aus dem Katalog: auch mit spicy:false nur im Spicy-Modus', () async {
    paketLegen();
    await expectLater(WiedergabePlaene.ergaenzen(plan(spicy: false)), throwsStateError);
    await StorageService.setSpicyMode(true);
    final p = await WiedergabePlaene.ergaenzen(plan(spicy: false));
    expect(p.spicy, isTrue);
    expect(p.titel, 'Eine Spur in die Nacht');
    expect(p.abschnitte.single.text, isNotEmpty);
  });

  test('Fremde ID, Stimme oder Pfad werden nicht abgespielt', () async {
    paketLegen();
    await StorageService.setSpicyMode(true);
    for (final p in [
      plan(id: 'praxis_fremd'),
      plan(stimme: 'fremd'),
      plan(pfad: 'audio/traum/martin_andere.opus'),
      plan(pfad: 'audio/traum/victoria_praxis_abend.opus'),
    ]) {
      await expectLater(WiedergabePlaene.ergaenzen(p), throwsStateError);
    }
  });

  test('Plan aus dem Katalog übersteht Serialisierung und wird neu geprüft', () async {
    paketLegen();
    await StorageService.setSpicyMode(true);
    final k = (await PraxisBegleitung.laden(sprache: 'de'))!;
    final p = WiedergabePlaene.praxis(k[1], 'victoria');
    final zurueck = await WiedergabePlaene.ergaenzen(WiedergabePlan.fromJson(p.toJson()));
    expect(zurueck.art, WiedergabeArt.praxis);
    expect(zurueck.abschnitte.single.pfad, 'audio/traum/victoria_praxis_klarheit.opus');
    expect(zurueck.abschnitte.single.dauer, p.abschnitte.single.dauer);
    expect(WiedergabePlaene.paketNamen(zurueck), ['de-gefuehrt']);
  });
}
