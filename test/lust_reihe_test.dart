import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/lust_reihe.dart';
import 'package:velvetpulse/services/pakete.dart';

/// Szenen-IDs des gemeinsamen Szenenbuchs, in dieser Reihenfolge.
const szenenIds = ['opening', 'attraction', 'afterglow'];

Map<String, dynamic> _segment(String szene, String text) => {'szene': szene, 'text': text};

Map<String, dynamic> _fassung(
  String id,
  String variante,
  String perspektive,
  String stimme, {
  List<String> texte = const ['Text A', 'Text B', 'Text C'],
}) =>
    {
      'id': id,
      'variante': variante,
      'perspektive': perspektive,
      'stimme': stimme,
      'segmente': [for (var i = 0; i < szenenIds.length; i++) _segment(szenenIds[i], texte[i])],
    };

/// Kleine, neutrale Fixture: eine Folge mit drei Szenen und vier Fassungen.
Map<String, dynamic> _folge() => {
      'id': 'f1',
      'typ': 'frau_mann',
      'titel': 'Titel der Folge',
      'beschreibung': 'Beschreibung der Folge',
      'szenen': [
        {'id': 'opening', 'beschreibung': 'Beschreibung A', 'start': 0, 'ende': 60},
        {'id': 'attraction', 'beschreibung': 'Beschreibung B', 'start': 60, 'ende': 120},
        {'id': 'afterglow', 'beschreibung': 'Beschreibung C', 'start': 120, 'ende': 180},
      ],
      'fassungen': [
        _fassung('soft_frau', 'soft', 'frau', 'victoria'),
        _fassung('soft_mann', 'soft', 'mann', 'martin'),
        _fassung('spicy_frau', 'spicy', 'frau', 'victoria'),
        _fassung('spicy_mann', 'spicy', 'mann', 'martin'),
      ],
    };

ReiheFolge _parseFolge([Map<String, dynamic>? json]) => ReiheFolge.fromJson(json ?? _folge());

ReiheDaten _daten({Map<String, int> dauerMs = const {}}) => ReiheDaten([_parseFolge()], dauerMs);

List<Map<String, dynamic>> _segmenteVon(Map<String, dynamic> folge, String fassungId) {
  final fassung = (folge['fassungen'] as List).cast<Map<String, dynamic>>().firstWhere((f) => f['id'] == fassungId);
  return (fassung['segmente'] as List).cast<Map<String, dynamic>>();
}

void _erwarteProblem(List<String> probleme, String teil) {
  expect(probleme, isNotEmpty);
  expect(probleme.any((p) => p.contains(teil)), isTrue, reason: 'erwartet „$teil“ in $probleme');
}

void main() {
  nameUndSolo();
  test('ReiheDaten.fromJson liest Folge, Szenen und alle Fassungen', () {
    final daten = ReiheDaten.fromJson({'folgen': [_folge()]});
    expect(daten.folgen, hasLength(1));
    expect(daten.dauerMs, isEmpty);

    final folge = daten.folgen.single;
    expect(folge.id, 'f1');
    expect(folge.typ, 'frau_mann');
    expect(folge.titel, 'Titel der Folge');
    expect(folge.beschreibung, 'Beschreibung der Folge');

    expect(folge.szenen.map((s) => s.id), szenenIds);
    expect(folge.szenen.map((s) => s.start), [0, 60, 120]);
    expect(folge.szenen.map((s) => s.ende), [60, 120, 180]);
    expect(folge.szenen.map((s) => s.beschreibung), ['Beschreibung A', 'Beschreibung B', 'Beschreibung C']);

    expect(folge.fassungen.map((f) => f.id), ['soft_frau', 'soft_mann', 'spicy_frau', 'spicy_mann']);
    expect(folge.fassungen.map((f) => f.variante), ['soft', 'soft', 'spicy', 'spicy']);
    expect(folge.fassungen.map((f) => f.perspektive), ['frau', 'mann', 'frau', 'mann']);
    expect(folge.fassungen.map((f) => f.stimme), ['victoria', 'martin', 'victoria', 'martin']);
    expect(folge.fassungen.map((f) => f.spicy), [false, false, true, true]);

    for (final fassung in folge.fassungen) {
      expect(fassung.segmente.map((s) => s.szene), szenenIds);
      expect(fassung.segmente.map((s) => s.text), ['Text A', 'Text B', 'Text C']);
    }
  });

  test('Gültige Fixture ist synchron', () {
    expect(_parseFolge().pruefeSynchronitaet(), isEmpty);
  });

  group('pruefeSynchronitaet meldet', () {
    test('vertauschte Szenenfolge', () {
      final json = _folge();
      final segmente = _segmenteVon(json, 'soft_frau');
      final erstes = segmente.removeAt(0);
      segmente.insert(1, erstes);

      _erwarteProblem(ReiheFolge.fromJson(json).pruefeSynchronitaet(), 'Szenenfolge weicht vom Szenenbuch ab');
    });

    test('fehlendes Segment', () {
      final json = _folge();
      _segmenteVon(json, 'soft_mann').removeLast();

      _erwarteProblem(ReiheFolge.fromJson(json).pruefeSynchronitaet(), 'Szenenfolge weicht vom Szenenbuch ab');
    });

    test('leeren Text', () {
      final json = _folge();
      _segmenteVon(json, 'spicy_frau')[1]['text'] = '   ';

      _erwarteProblem(ReiheFolge.fromJson(json).pruefeSynchronitaet(), 'leeres Segment');
    });

    test('doppelte Szenen-ID', () {
      final json = _folge();
      (json['szenen'] as List).cast<Map<String, dynamic>>()[1]['id'] = 'opening';

      _erwarteProblem(ReiheFolge.fromJson(json).pruefeSynchronitaet(), 'Szenen-IDs doppelt');
    });

    test('Zeitmarke mit ende <= start', () {
      final json = _folge();
      (json['szenen'] as List).cast<Map<String, dynamic>>()[1]['ende'] = 60;

      _erwarteProblem(ReiheFolge.fromJson(json).pruefeSynchronitaet(), 'Zeitmarke von attraction unstimmig');
    });
  });

  test('varianten gibt spicy nur bei Freigabe zurück', () {
    final folge = _parseFolge();
    expect(folge.varianten(spicyErlaubt: false), ['soft']);
    expect(folge.varianten(spicyErlaubt: true), ['soft', 'spicy']);
  });

  test('partnerVon liefert die Fassung derselben Variante', () {
    final folge = _parseFolge();
    final softFrau = folge.fassungen.firstWhere((f) => f.id == 'soft_frau');
    expect(folge.partnerVon(softFrau).map((f) => f.id), ['soft_mann']);

    final spicyMann = folge.fassungen.firstWhere((f) => f.id == 'spicy_mann');
    expect(folge.partnerVon(spicyMann).map((f) => f.id), ['spicy_frau']);
  });

  test('audioPfad setzt Stimme, Folge, Fassung und Szene zusammen', () {
    final folge = _parseFolge();
    final fassung = folge.fassungen.first;
    expect(
      ReiheDaten.audioPfad(folge, fassung, fassung.segmente.first),
      'audio/reihe/victoria_f1_soft_frau_opening.opus',
    );
  });

  test('dauerVon nutzt gemessene Werte, sonst die Textlänge', () {
    final folge = _parseFolge();
    final fassung = folge.fassungen.first;
    final opening = fassung.segmente.first;

    // Ohne Messwert: 'Text A' hat sechs Zeichen, also rund 0,6 s.
    expect(_daten().dauerVon(folge, fassung, opening), const Duration(milliseconds: 600));

    final gemessen = _daten(dauerMs: {'victoria_f1_soft_frau_opening': 4321});
    expect(gemessen.dauerVon(folge, fassung, opening), const Duration(milliseconds: 4321));
    // Andere Segmente bleiben geschätzt.
    expect(gemessen.dauerVon(folge, fassung, fassung.segmente[1]), const Duration(milliseconds: 600));

    // Fünfzig Zeichen ergeben fünf Sekunden.
    final langerText = ReiheSegment(szene: 'opening', text: 'A' * 50);
    expect(_daten().dauerVon(folge, fassung, langerText), const Duration(seconds: 5));
  });

  test('abweichungen ist 0, wenn die Segmentdauern auf den Szenenstarts liegen', () {
    final folge = _parseFolge();
    final fassung = folge.fassungen.first;
    final daten = _daten(dauerMs: {
      'victoria_f1_soft_frau_opening': 60000,
      'victoria_f1_soft_frau_attraction': 60000,
      'victoria_f1_soft_frau_afterglow': 60000,
    });

    expect(daten.abweichungen(folge, fassung), {'opening': 0, 'attraction': 0, 'afterglow': 0});
  });

  test('abweichungen wird positiv, wenn Segmente länger dauern', () {
    final folge = _parseFolge();
    final fassung = folge.fassungen.first;
    final daten = _daten(dauerMs: {
      'victoria_f1_soft_frau_opening': 65000,
      'victoria_f1_soft_frau_attraction': 65000,
      'victoria_f1_soft_frau_afterglow': 65000,
    });

    final abweichungen = daten.abweichungen(folge, fassung);
    expect(abweichungen['opening'], 0);
    expect(abweichungen['attraction'], greaterThan(0));
    expect(abweichungen['afterglow'], greaterThan(0));
  });
}

void nameUndSolo() {
  test('Szenenbilder liegen im sprachunabhängigen Paket reihe-bilder', () {
    final ordner = Directory.systemTemp.createTempSync('pakete_bilder');
    addTearDown(() {
      Pakete.basisFuerTest = null;
      ordner.deleteSync(recursive: true);
    });
    Pakete.basisFuerTest = ordner.path;
    expect(Pakete.datei('bilder/f1_soft_opening.webp'), isNull);
    final datei = File('${ordner.path}/${Pakete.reiheBilder}/bilder/f1_soft_opening.webp')
      ..createSync(recursive: true);
    expect(Pakete.datei('bilder/f1_soft_opening.webp'), datei.path);
  });

  test('bildPfad gilt je Folge, Variante und Szene, nicht je Perspektive', () {
    final folge = _parseFolge();
    final frau = folge.fassungen[0], mann = folge.fassungen[1], spicy = folge.fassungen[2];
    expect(ReiheDaten.bildPfad(folge, frau, frau.segmente.first), 'bilder/f1_soft_opening.webp');
    expect(ReiheDaten.bildPfad(folge, mann, mann.segmente.first), 'bilder/f1_soft_opening.webp');
    expect(ReiheDaten.bildPfad(folge, spicy, spicy.segmente.first), 'bilder/f1_spicy_opening.webp');
  });

  test('name je Fassung ist optional, solo folgt aus dem Typ', () {
    final j = _folge();
    (j['fassungen'] as List)[0]['name'] = 'Die Gastgeberin';
    j['typ'] = 'solo';
    final folge = _parseFolge(j);
    expect(folge.solo, isTrue);
    expect(folge.fassungen[0].name, 'Die Gastgeberin');
    expect(folge.fassungen[1].name, isNull);
    expect(_parseFolge().solo, isFalse);
  });
}
