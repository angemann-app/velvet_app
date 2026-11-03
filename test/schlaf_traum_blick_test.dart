import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/schlafdaten.dart';
import 'package:velvetpulse/models/schlaf_traum_blick.dart';
import 'package:velvetpulse/models/traum_eintrag.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';

void main() {
  final heute = DateTime(2026, 11, 3);
  List<SchlafTraumTag> blick(
          {List<TraumEintrag> traeume = const [],
          TraumpraxisDaten praxis = const TraumpraxisDaten()}) =>
      SchlafTraumTag.woche(
          heute: heute,
          schlaf: const SchlafDaten(),
          traeume: traeume,
          praxis: praxis);

  test('Ohne Gerät sieben Tage, fehlende Angaben bleiben unbekannt', () {
    final w = blick();
    expect(w, hasLength(7));
    expect(w.first.datum, '2026-11-03');
    expect(w.last.datum, '2026-10-28');
    expect(
        w.every(
            (t) => t.messungen.isEmpty && !t.hatAngaben && !t.nichtsErinnert),
        isTrue);
  });
  test('Tagebuch und Tagesbeobachtung zählen Klarheit je Tag nur einmal', () {
    final w = blick(
        traeume: [
          TraumEintrag(id: 'a', zeit: heute, marken: {'luzide'}),
          TraumEintrag(id: 'b', zeit: heute, marken: {'luzide', 'sinnlich'}),
          TraumEintrag(
              id: 'alt',
              zeit: heute.subtract(const Duration(days: 9)),
              marken: {'luzide'}),
        ],
        praxis: TraumpraxisDaten([
          PraxisEintrag(
              id: '2026-11-03',
              art: 'tag',
              geaendert: heute,
              klar: true,
              hoehepunkt: true),
        ]));
    expect(w.where((t) => t.klar), hasLength(1));
    expect(w.first.sinnlich, isTrue);
    expect(w.first.hoehepunkt, isTrue);
    expect(w.where((t) => t.hatAngaben), hasLength(1));
  });
  test(
      'Nichts erinnert, explizites Nein und gelöschte Angaben getrennt behandeln',
      () {
    final w = blick(
        traeume: [
          TraumEintrag(id: 'a', zeit: heute, marken: {'nichts'})
        ],
        praxis: TraumpraxisDaten([
          PraxisEintrag(
              id: '2026-11-03', art: 'tag', geaendert: heute, klar: false),
          PraxisEintrag(
              id: '2026-11-02',
              art: 'tag',
              geaendert: heute,
              klar: true,
              geloescht: true),
        ]));
    expect(w.first.nichtsErinnert, isTrue);
    expect(w.first.erinnert, isFalse);
    expect(w.first.klar, isFalse);
    expect(w[1].hatAngaben, isFalse);
  });
}
