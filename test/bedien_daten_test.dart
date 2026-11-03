import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/bedien_daten.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';

WiedergabePlan plan() => WiedergabePlan(
        art: WiedergabeArt.selbst,
        id: 'selbst',
        sprache: 'de',
        spicy: false,
        titel: 'Nicht sichern',
        parameter: {
          'stimme': 'martin'
        },
        abschnitte: const [
          WiedergabeAbschnitt(
              id: 'a',
              art: AbschnittArt.sprache,
              dauer: Duration(seconds: 15),
              pfad: 'audio/selbst/martin_a.opus',
              text: 'Dieser Text bleibt nur im Speicher.'),
          WiedergabeAbschnitt(
              id: 'b', art: AbschnittArt.stille, dauer: Duration(seconds: 30)),
        ]);

void main() {
  test(
      'Parameter behalten ihre Bedeutung statt beliebiger Werte mit gültigem JSON-Typ',
      () {
    for (final falsch in [
      <String, Object>{'teppichLaut': false},
      {'stimmeVon': 4},
      {'teppich': 'ja'},
      {'minuten': 1.5},
      {'stimme': 1}
    ]) {
      expect(
          () => WiedergabePlan.fromJson(
              {...plan().toJson(), 'parameter': falsch}),
          throwsFormatException);
    }
  });
  final zeit = DateTime.utc(2026, 11, 2);
  test('Merker behält Ablauf, Sprache und Position, aber keine Inhaltstexte',
      () {
    final original = WiedergabeMerker(
        plan: plan(),
        index: 1,
        position: const Duration(seconds: 8),
        geaendert: zeit);
    final raw = jsonEncode(original.toJson());
    expect(raw, isNot(contains('Nicht sichern')));
    expect(raw, isNot(contains('Dieser Text')));
    final restored = WiedergabeMerker.fromJson(jsonDecode(raw));
    expect(restored.index, 1);
    expect(restored.position.inSeconds, 8);
    expect(restored.plan!.abschnitte.map((s) => s.id), ['a', 'b']);
    expect(restored.plan!.sprache, 'de');
    expect(restored.plan!.dauer.inSeconds, 45);
  });

  test('Merge wählt die Komponenten unabhängig und in beiden Richtungen gleich',
      () {
    final a = BedienDaten(
        wiedergabe: WiedergabeMerker(
            plan: plan(), index: 0, position: Duration.zero, geaendert: zeit),
        weg: WegStand(
            lektion: 'l1',
            schritt: 2,
            geaendert: zeit.add(const Duration(seconds: 2))));
    final b = BedienDaten(
        wiedergabe: WiedergabeMerker(
            plan: null,
            index: 0,
            position: Duration.zero,
            geaendert: zeit.add(const Duration(seconds: 1))),
        weg: WegStand(lektion: 'l1', schritt: 1, geaendert: zeit));
    expect(a.zusammen(b).toJson(), b.zusammen(a).toJson());
    expect(a.zusammen(b).wiedergabe!.geloescht, isTrue);
    expect(a.zusammen(b).weg!.schritt, 2);
    expect(a.zusammen(a).toJson(), a.toJson());
  });

  test('Löschmarkierung gewinnt auch bei gleichem Zeitstempel', () {
    final a = BedienDaten(
        wiedergabe: WiedergabeMerker(
            plan: plan(), index: 0, position: Duration.zero, geaendert: zeit));
    final b = BedienDaten(
        wiedergabe: WiedergabeMerker(
            plan: null, index: 0, position: Duration.zero, geaendert: zeit));
    expect(a.zusammen(b).wiedergabe!.geloescht, isTrue);
    expect(b.zusammen(a).wiedergabe!.geloescht, isTrue);
  });

  test(
      'Import weist absolute Pfade, Traversal, Netzquellen und fremde Einstellungen ab',
      () {
    for (final pfad in [
      '../a.opus',
      'audio/../a.opus',
      'C:/a.opus',
      'https://example.com/a.opus',
      'audio/a.mp3'
    ]) {
      final j = plan().toJson();
      (j['abschnitte'] as List).first['pfad'] = pfad;
      expect(() => WiedergabePlan.fromJson(j), throwsFormatException,
          reason: pfad);
    }
    expect(
        () => WiedergabePlan.fromJson({
              ...plan().toJson(),
              'parameter': {'text': 'Nicht erlaubt'}
            }),
        throwsFormatException);
    expect(
        () => WiedergabePlan.fromJson({
              ...plan().toJson(),
              'parameter': {'minuten': double.nan}
            }),
        throwsFormatException);
  });

  test('Beschädigte Positionen und unbekannte Schema-Version werden abgewiesen',
      () {
    final j = WiedergabeMerker(
            plan: plan(), index: 0, position: Duration.zero, geaendert: zeit)
        .toJson();
    for (final index in [-1, 2]) {
      expect(() => WiedergabeMerker.fromJson({...j, 'index': index}),
          throwsFormatException);
    }
    expect(() => WiedergabeMerker.fromJson({...j, 'positionMs': -1}),
        throwsFormatException);
    expect(() => BedienDaten.fromJson({'schema': 99}), throwsFormatException);
  });
}
