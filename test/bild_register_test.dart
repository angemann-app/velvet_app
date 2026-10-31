// Das Bildregister (assets/data/bilder.json): jede ID löst auf, keine Datei fehlt, nichts bleibt unbeschriftet.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/bild_register.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/vp_tokens.dart';
import 'package:velvetpulse/widgets/design/vp_bild_feld.dart';
import 'package:velvetpulse/widgets/design/vp_grafik.dart';

Map<String, dynamic> _json() => jsonDecode(File('assets/data/bilder.json').readAsStringSync()) as Map<String, dynamic>;

void main() {
  setUpAll(() => BildRegister.ladenAusText(File('assets/data/bilder.json').readAsStringSync()));

  test('Jeder Eintrag hat gültiges Format, vorhandene Dateien und Alt-Texte in beiden Sprachen', () {
    final bilder = (_json()['bilder'] as Map).cast<String, dynamic>();
    expect(bilder, isNotEmpty);
    for (final e in bilder.entries) {
      final m = e.value as Map;
      expect(VpBildFormat.ausName(m['format'] as String?), isNotNull, reason: '${e.key}: Format');
      for (final feld in ['normal', 'spicy', 'englisch']) {
        final pfad = m[feld] as String?;
        if (pfad == null || m['paket'] != null) continue;
        expect(File(pfad).existsSync(), isTrue, reason: '${e.key}: $feld fehlt ($pfad)');
      }
      final alt = m['alt'] as Map;
      expect((alt['de'] as String).trim(), isNotEmpty, reason: '${e.key}: Alt-Text DE');
      expect((alt['en'] as String).trim(), isNotEmpty, reason: '${e.key}: Alt-Text EN');
    }
  });

  test('Alle Bilder in assets/images sind im Register (außer den Fassungen _en und _spicy)', () {
    final registriert = BildRegister.alle.expand((e) => [e.normal, if (e.spicy != null) e.spicy!, if (e.englisch != null) e.englisch!]).toSet();
    final fehlen = [
      for (final f in Directory('assets/images').listSync().whereType<File>())
        if (!registriert.contains(f.path.replaceAll('\\', '/'))) f.path,
    ];
    expect(fehlen, isEmpty, reason: 'Nicht im Register: $fehlen. tools/bilder_register.py ausführen.');
  });

  test('Bilder aus den Kursdaten (DE und EN) stehen im Register', () {
    final pfade = <String>{};
    for (final datei in ['assets/data/velvet_content.json', 'translations/en/velvet_content.json']) {
      final d = jsonDecode(File(datei).readAsStringSync()) as Map<String, dynamic>;
      for (final kurs in (d['courses'] as List).cast<Map<String, dynamic>>()) {
        if (kurs['image'] != null) pfade.add(kurs['image'] as String);
        for (final l in (kurs['lessons'] as List).cast<Map<String, dynamic>>()) {
          for (final f in ['image', 'zeichnung']) {
            if (l[f] != null) pfade.add(l[f] as String);
          }
        }
      }
    }
    for (final p in pfade) {
      expect(BildRegister.nachPfad(p), isNotNull, reason: '$p fehlt im Register');
    }
  });

  test('IDs sind eindeutig und die Grafik-IDs sind die der Bausteine', () {
    final ids = BildRegister.alle.map((e) => e.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final id in BildRegister.grafikIds) {
      expect(VpGrafik.malerFuer(id, Colors.black), isNotNull);
    }
  });

  test('Auflösung: Spicy-Fassung nur im Spicy-Modus, Englisch nur wo es eine gibt', () {
    final kurs = BildRegister.eintrag('kurs.01.titel')!;
    expect(BildRegister.loese(kurs, spicy: false, englisch: false)!.pfad, kurs.normal);
    expect(BildRegister.loese(kurs, spicy: true, englisch: false)!.pfad, kurs.spicy);
    final diagramm = BildRegister.alle.firstWhere((e) => e.englisch != null);
    expect(BildRegister.loese(diagramm, spicy: false, englisch: true)!.pfad, diagramm.englisch);
    expect(BildRegister.loese(diagramm, spicy: false, englisch: false)!.pfad, diagramm.normal);
  });

  group('VpBildFeld', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      StorageService.resetForTest();
      await StorageService.init();
    });

    Widget app(Widget kind) => MaterialApp(home: Scaffold(body: SizedBox(width: 200, height: 133, child: kind)));

    testWidgets('Unbekannte ID und fehlende Datei zeigen den Platzhalter, nie eine leere Fläche', (tester) async {
      await tester.pumpWidget(app(const VpBildFeld('gibt.es.nicht')));
      expect(find.byType(VpPlatzhalter), findsOneWidget);
      await tester.pumpWidget(app(const VpBildFeld.datei('/gibt/es/nicht.webp', format: VpBildFormat.studie)));
      expect(find.byType(VpPlatzhalter), findsOneWidget);
    });

    testWidgets('Ein registriertes Bild wird gezeigt, Alt-Text liegt an', (tester) async {
      await tester.pumpWidget(app(const VpBildFeld('kurs.01.titel')));
      await tester.pump();
      expect(find.bySemanticsLabel(RegExp('.+')), findsWidgets);
    });
  });
}
