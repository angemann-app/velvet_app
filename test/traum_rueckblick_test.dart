import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/traum_eintrag.dart';
import 'package:velvetpulse/models/traum_rueckblick.dart';

void main() {
  final jetzt = DateTime(2026, 10, 27, 10, 0);

  test('Leere Liste liefert Nullen und leere Maps', () {
    final r = TraumRueckblick.berechnen([], jetzt: jetzt);
    expect(r.eintraegeGesamt, 0);
    expect(r.erinnert, 0);
    expect(r.nichtsErinnert, 0);
    expect(r.markenZaehlung, isEmpty);
    expect(r.abendMarken, isEmpty);
  });

  test('Einträge außerhalb des 7-Tage-Fensters werden ignoriert', () {
    final eintraege = [
      TraumEintrag(
        id: '1',
        zeit: jetzt.subtract(const Duration(days: 8)),
        marken: {'erinnert', 'luzide'},
        abend: 'traum:warmes_wasser',
      ),
      TraumEintrag(
        id: '2',
        zeit: jetzt.subtract(const Duration(days: 3)),
        marken: {'erinnert', 'luzide'},
        abend: 'traum:warmes_wasser',
      ),
      TraumEintrag(
        id: '3',
        zeit: jetzt.add(const Duration(hours: 1)), // Zukunft
        marken: {'erinnert'},
      ),
    ];

    final r = TraumRueckblick.berechnen(eintraege, jetzt: jetzt);
    expect(r.eintraegeGesamt, 1);
    expect(r.erinnert, 1);
    expect(r.markenZaehlung['luzide'], 1);
  });

  test('Zählung von erinnert, nichts erinnert und individuellen Marken', () {
    final eintraege = [
      TraumEintrag(
        id: '1',
        zeit: jetzt.subtract(const Duration(days: 1)),
        marken: {'erinnert', 'luzide', 'sinnlich'},
      ),
      TraumEintrag(
        id: '2',
        zeit: jetzt.subtract(const Duration(days: 2)),
        marken: {'erinnert', 'sinnlich', 'hoehepunkt'},
      ),
      TraumEintrag(
        id: '3',
        zeit: jetzt.subtract(const Duration(days: 3)),
        marken: {TraumEintrag.nichts},
      ),
      TraumEintrag(
        id: '4',
        zeit: jetzt.subtract(const Duration(days: 4)),
        marken: {'erinnert', 'unangenehm'},
      ),
    ];

    final r = TraumRueckblick.berechnen(eintraege, jetzt: jetzt);
    expect(r.eintraegeGesamt, 4);
    expect(r.erinnert, 3);
    expect(r.nichtsErinnert, 1);
    expect(r.markenZaehlung['luzide'], 1);
    expect(r.markenZaehlung['sinnlich'], 2);
    expect(r.markenZaehlung['hoehepunkt'], 1);
    expect(r.markenZaehlung['unangenehm'], 1);
    expect(r.markenZaehlung.containsKey(TraumEintrag.nichts), isFalse);
  });

  test('Abend-Zuordnung fasst Markierungen je Abend zusammen', () {
    final eintraege = [
      TraumEintrag(
        id: '1',
        zeit: jetzt.subtract(const Duration(days: 1)),
        marken: {'erinnert', 'luzide'},
        abend: 'traum:warmes_wasser',
      ),
      TraumEintrag(
        id: '2',
        zeit: jetzt.subtract(const Duration(days: 2)),
        marken: {'erinnert', 'sinnlich'},
        abend: 'traum:warmes_wasser',
      ),
      TraumEintrag(
        id: '3',
        zeit: jetzt.subtract(const Duration(days: 3)),
        marken: {TraumEintrag.nichts},
        abend: 'lust:1',
      ),
      TraumEintrag(
        id: '4',
        zeit: jetzt.subtract(const Duration(days: 4)),
        marken: {'erinnert'},
        abend: null, // ohne Abend
      ),
    ];

    final r = TraumRueckblick.berechnen(eintraege, jetzt: jetzt);
    expect(r.abendMarken.keys, containsAll(['traum:warmes_wasser', 'lust:1']));
    expect(r.abendMarken.containsKey(null), isFalse);

    final wasser = r.abendMarken['traum:warmes_wasser']!;
    expect(wasser['erinnert'], 2);
    expect(wasser['luzide'], 1);
    expect(wasser['sinnlich'], 1);

    final lust = r.abendMarken['lust:1']!;
    expect(lust[TraumEintrag.nichts], 1);
  });
}
