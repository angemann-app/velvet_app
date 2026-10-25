// PO-Dateien für Übersetzer (translations/po/) und die Fortschrittsseite translations/STATUS.md.
//
// Abgleich nach jeder Änderung an deutschen Texten oder nach neuen Übersetzungen:
//   flutter test test/uebersetzung_test.dart --dart-define=PO=sync
// Neue Sprache beginnen (legt leere PO-Dateien an), danach wie oben abgleichen:
//   flutter test test/uebersetzung_test.dart --dart-define=PO=neu --dart-define=LANG=fr
//
// Ohne Angaben prüft der Test, dass Hin- und Rückweg nichts verlieren und dass Vorlagen, PO-Dateien
// und Fortschrittsseite zum aktuellen Stand passen.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'uebersetzung/po_werkzeug.dart';

const _modus = String.fromEnvironment('PO');
const _sprache = String.fromEnvironment('LANG');

void _schreiben(Map<String, String> dateien) {
  for (final e in dateien.entries) {
    File(e.key)
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(e.value);
  }
}

/// Alles, was aus dem aktuellen Stand erzeugt wird: Vorlagen, PO-Dateien je Sprache, Fortschritt.
Map<String, String> _erzeugt(List<Bereich> alle) {
  final englisch = englischLesen();
  return {
    ...vorlagenErzeugen(alle, englisch),
    for (final s in poSprachen()) ...poDateienErzeugen(s, alle, englisch),
    'translations/STATUS.md': statusErzeugen(alle, englisch),
  };
}

void main() {
  final alle = bereiche();

  if (_modus == 'neu') {
    test('Neue Sprache $_sprache anlegen', () {
      expect(RegExp(r'^[a-z]{2,3}(_[A-Z]{2})?$').hasMatch(_sprache), isTrue,
          reason: 'Sprachcode mit --dart-define=LANG=fr angeben');
      expect(_sprache, isNot('en'), reason: 'Englisch wird direkt gepflegt (translations/en/)');
      for (final b in alle) {
        final f = File(poPfad(b.name, _sprache));
        if (!f.existsSync()) _schreiben({f.path: poBauen(b, _sprache, const {}, const {}, englischLesen())});
      }
    });
    return;
  }

  if (_modus == 'sync') {
    test('PO-Dateien abgleichen', () {
      for (final s in poSprachen()) {
        poEinspielen(s, alle);
      }
      _schreiben(_erzeugt(alle));
    });
    return;
  }

  final englisch = englischLesen();
  final bekannt = {for (final b in alle) for (final e in b.einheiten) for (final f in e.felder) f.schluessel};
  final enFelder = {for (final e in englisch.entries) if (bekannt.contains(e.key)) e.key: e.value};

  test('Jeder deutsche Text steckt genau einmal in einer PO-Datei', () {
    final alleSchluessel = [for (final b in alle) for (final e in b.einheiten) for (final f in e.felder) f.schluessel];
    expect(alleSchluessel.toSet().length, alleSchluessel.length);
    expect(alleSchluessel.length, greaterThan(2000));
  });

  test('PO schreiben und lesen verliert nichts (alle englischen Texte als Probe)', () {
    for (final b in alle) {
      final gelesen = poLesen(poBauen(b, 'xx', enFelder, const {}, const {}));
      for (final e in b.einheiten) {
        for (final f in e.felder) {
          expect(gelesen[f.schluessel]?.text, enFelder[f.schluessel] ?? '', reason: f.schluessel);
          expect(gelesen[f.schluessel]?.fuzzy, isFalse, reason: f.schluessel);
        }
      }
    }
  });

  test('Übersetzung schreiben und wieder lesen verliert nichts', () {
    final tmp = Directory.systemTemp.createTempSync('uebersetzung');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final stempel = stempelLesen('translations/en');
    uebersetzungSchreiben(tmp.path, 'xx', enFelder, stempel);
    expect(felderLesen(tmp.path), enFelder);
    final einheiten = {for (final b in alle) for (final e in b.einheiten) e.schluessel};
    expect(stempelLesen(tmp.path), {for (final s in stempel.entries) if (einheiten.contains(s.key)) s.key: s.value});
  });

  test('Geänderter deutscher Text wird als überholt markiert, nach dem Übersetzen nicht mehr', () {
    final lektion = alle.firstWhere((b) => b.name == 'kurse').einheiten.firstWhere((e) => e.schluessel.startsWith('lesson:'));
    final bereich = Bereich('probe', 'Probe', '-', false, [lektion]);
    final felder = {for (final f in lektion.felder) f.schluessel: 'Übersetzt'};
    final alt = poLesen(poBauen(bereich, 'xx', felder, {lektion.schluessel: 'alte-pruefsumme'}, const {}));
    expect(alt.values.every((e) => e.fuzzy), isTrue);
    final neu = poLesen(poBauen(bereich, 'xx', felder, {lektion.schluessel: lektion.pruefsumme}, const {}));
    expect(neu.values.any((e) => e.fuzzy), isFalse);
  });

  test('Vorlagen, PO-Dateien und Fortschrittsseite sind aktuell', () {
    final veraltet = [
      for (final e in _erzeugt(alle).entries)
        // Zeilenenden egal: Git wandelt sie unter Windows beim Auschecken um.
        if (!File(e.key).existsSync() || File(e.key).readAsStringSync().replaceAll('\r\n', '\n') != e.value) e.key
    ];
    expect(veraltet, isEmpty,
        reason: 'Nicht aktuell: ${veraltet.join(', ')}. Abgleichen mit: '
            'flutter test test/uebersetzung_test.dart --dart-define=PO=sync');
  });
}
