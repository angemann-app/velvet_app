import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/traum_eintrag.dart';
import 'package:velvetpulse/services/realitaetscheck.dart';

void main() {
  group('RealitaetscheckEinstellungen', () {
    test('Standardwerte sind korrekt', () {
      const e = RealitaetscheckEinstellungen();
      expect(e.aktiv, isFalse);
      expect(e.vonStunde, 9);
      expect(e.bisStunde, 21);
      expect(e.anzahlProTag, 3);
    });

    test('mit() ändert Felder partiell', () {
      const e = RealitaetscheckEinstellungen();
      final geaendert = e.mit(aktiv: true, anzahlProTag: 4);
      expect(geaendert.aktiv, isTrue);
      expect(geaendert.vonStunde, 9);
      expect(geaendert.bisStunde, 21);
      expect(geaendert.anzahlProTag, 4);
    });

    test('toJson und fromJson Roundtrip', () {
      const e = RealitaetscheckEinstellungen(
        aktiv: true,
        vonStunde: 8,
        bisStunde: 20,
        anzahlProTag: 2,
      );
      final json = e.toJson();
      final wiederhergestellt = RealitaetscheckEinstellungen.fromJson(json);

      expect(wiederhergestellt.aktiv, isTrue);
      expect(wiederhergestellt.vonStunde, 8);
      expect(wiederhergestellt.bisStunde, 20);
      expect(wiederhergestellt.anzahlProTag, 2);
    });
  });

  group('RealitaetscheckService.planeZeiten', () {
    test('gibt leere Liste zurück, wenn nicht aktiv', () {
      const e = RealitaetscheckEinstellungen(aktiv: false);
      final zeiten = RealitaetscheckService.planeZeiten(e);
      expect(zeiten, isEmpty);
    });

    test('plant Zeiten innerhalb des Zeitfensters', () {
      const e = RealitaetscheckEinstellungen(
        aktiv: true,
        vonStunde: 10,
        bisStunde: 18,
        anzahlProTag: 3,
      );
      final jetzt = DateTime(2026, 10, 27, 8, 0); // vor dem Fenster
      final rand = Random(42);

      final zeiten = RealitaetscheckService.planeZeiten(
        e,
        jetzt: jetzt,
        zufall: rand,
        tageVoraus: 3,
      );

      expect(zeiten, isNotEmpty);
      for (final zeit in zeiten) {
        expect(zeit.hour, greaterThanOrEqualTo(10));
        expect(zeit.hour, lessThan(18));
      }
    });

    test('filtert vergangene Zeiten am aktuellen Tag heraus', () {
      const e = RealitaetscheckEinstellungen(
        aktiv: true,
        vonStunde: 9,
        bisStunde: 21,
        anzahlProTag: 3,
      );
      final jetzt = DateTime(2026, 10, 27, 15, 30); // Mitten am Tag
      final rand = Random(42);

      final zeiten = RealitaetscheckService.planeZeiten(
        e,
        jetzt: jetzt,
        zufall: rand,
        tageVoraus: 2,
      );

      for (final zeit in zeiten) {
        expect(zeit.isAfter(jetzt), isTrue);
      }
    });

    test('ist deterministisch bei gleichem Zufalls-Seed und Referenzzeit', () {
      const e = RealitaetscheckEinstellungen(
        aktiv: true,
        vonStunde: 9,
        bisStunde: 21,
        anzahlProTag: 3,
      );
      final jetzt = DateTime(2026, 10, 27, 10, 0);

      final lauf1 = RealitaetscheckService.planeZeiten(
        e,
        jetzt: jetzt,
        zufall: Random(123),
        tageVoraus: 3,
      );
      final lauf2 = RealitaetscheckService.planeZeiten(
        e,
        jetzt: jetzt,
        zufall: Random(123),
        tageVoraus: 3,
      );

      expect(lauf1, equals(lauf2));
    });

    test('erzeugt für volle Folgetage genau anzahlProTag Zeiten', () {
      const e = RealitaetscheckEinstellungen(
        aktiv: true,
        vonStunde: 9,
        bisStunde: 21,
        anzahlProTag: 4,
      );
      final jetzt = DateTime(2026, 10, 27, 8, 0); // Vor Beginn des heutigen Fensters
      final rand = Random(99);

      final zeiten = RealitaetscheckService.planeZeiten(
        e,
        jetzt: jetzt,
        zufall: rand,
        tageVoraus: 3,
      );

      final tag1 = zeiten.where((z) => z.day == 27).length;
      final tag2 = zeiten.where((z) => z.day == 28).length;
      final tag3 = zeiten.where((z) => z.day == 29).length;

      expect(tag1, 4);
      expect(tag2, 4);
      expect(tag3, 4);
    });
  });

  group('RealitaetscheckService.findeMotive', () {
    test('filtert Stoppwörter und Wörter unter 4 Zeichen', () {
      final jetzt = DateTime(2026, 10, 27, 12, 0);
      final eintraege = [
        TraumEintrag(
          id: '1',
          zeit: jetzt.subtract(const Duration(days: 1)),
          text: 'ich war am see und ein hund war da',
        ),
        TraumEintrag(
          id: '2',
          zeit: jetzt.subtract(const Duration(days: 2)),
          text: 'wir sind am fluss und da war ein hund',
        ),
        TraumEintrag(
          id: '3',
          zeit: jetzt.subtract(const Duration(days: 3)),
          text: 'ein hund lief durch den wald',
        ),
      ];

      final motive = RealitaetscheckService.findeMotive(eintraege, jetzt: jetzt, mindestHaeufigkeit: 3);

      // 'hund' kommt in allen 3 Einträgen vor, hat >= 4 Buchstaben und ist kein Stoppwort.
      // 'ich', 'war', 'am', 'see' (3 buchstaben), 'und', 'da' etc. sind Stoppwörter oder zu kurz.
      expect(motive, contains('Hund'));
      expect(motive, isNot(contains('Und')));
      expect(motive, isNot(contains('Ich')));
      expect(motive, isNot(contains('See')));
    });

    test('ignoriert Einträge, die älter als 30 Tage sind', () {
      final jetzt = DateTime(2026, 10, 27, 12, 0);
      final eintraege = [
        TraumEintrag(
          id: '1',
          zeit: jetzt.subtract(const Duration(days: 5)),
          text: 'ich flog über das wasser',
        ),
        TraumEintrag(
          id: '2',
          zeit: jetzt.subtract(const Duration(days: 10)),
          text: 'klares blaues wasser am strand',
        ),
        TraumEintrag(
          id: '3',
          zeit: jetzt.subtract(const Duration(days: 35)), // älter als 30 Tage!
          text: 'schon wieder wasser gesehen',
        ),
      ];

      final motive = RealitaetscheckService.findeMotive(eintraege, jetzt: jetzt, mindestHaeufigkeit: 3);
      // 'wasser' kommt zwar in 3 Einträgen vor, aber der 3. ist > 30 Tage her
      expect(motive, isEmpty);
    });

    test('zählt ein Wort pro Eintrag nur einmal', () {
      final jetzt = DateTime(2026, 10, 27, 12, 0);
      final eintraege = [
        TraumEintrag(
          id: '1',
          zeit: jetzt.subtract(const Duration(days: 1)),
          text: 'wasser wasser wasser überall wasser',
        ),
        TraumEintrag(
          id: '2',
          zeit: jetzt.subtract(const Duration(days: 2)),
          text: 'nur ein wenig wasser',
        ),
      ];

      // Kommt nur in 2 Einträgen vor, obwohl in Eintrag 1 viermal
      final motive = RealitaetscheckService.findeMotive(eintraege, jetzt: jetzt, mindestHaeufigkeit: 3);
      expect(motive, isEmpty);
    });

    test('sortiert Motive nach Häufigkeit absteigend und großgeschrieben', () {
      final jetzt = DateTime(2026, 10, 27, 12, 0);
      final eintraege = [
        TraumEintrag(
          id: '1',
          zeit: jetzt.subtract(const Duration(days: 1)),
          text: 'am strand stand ein haus und ein baum',
        ),
        TraumEintrag(
          id: '2',
          zeit: jetzt.subtract(const Duration(days: 2)),
          text: 'das haus hatte einen garten mit baum',
        ),
        TraumEintrag(
          id: '3',
          zeit: jetzt.subtract(const Duration(days: 3)),
          text: 'im haus war es dunkel, draußen der baum',
        ),
        TraumEintrag(
          id: '4',
          zeit: jetzt.subtract(const Duration(days: 4)),
          text: 'der baum war riesengroß',
        ),
      ];

      final motive = RealitaetscheckService.findeMotive(eintraege, jetzt: jetzt, mindestHaeufigkeit: 3);

      // 'Baum' kommt in 4 Einträgen vor, 'Haus' in 3 Einträgen
      expect(motive, equals(['Baum', 'Haus']));
    });
  });
}
