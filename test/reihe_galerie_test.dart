// Szenenbilder-Galerie der Reihe (docs/konzepte/szenenbilder-galerie-beta.md).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/lust_reihe.dart';
import 'package:velvetpulse/screens/self_exploration/reihe_galerie_screen.dart';
import 'package:velvetpulse/services/alter_dienst.dart';
import 'package:velvetpulse/services/storage_service.dart';

Map<String, dynamic> _fassung(String id, String variante, String perspektive) => {
      'id': id,
      'variante': variante,
      'perspektive': perspektive,
      'stimme': 'victoria',
      'segmente': [
        {'szene': 'opening', 'text': 'A'},
        {'szene': 'afterglow', 'text': 'B'},
      ],
    };

ReiheFolge _folge({String? bildersatz}) => ReiheFolge.fromJson({
      'id': 'f1',
      'typ': 'frau_mann',
      'titel': 'Titel',
      'beschreibung': '',
      if (bildersatz != null) 'bildersatz': bildersatz,
      'szenen': [
        {'id': 'opening', 'beschreibung': 'Ankommen', 'start': 0, 'ende': 60},
        {'id': 'afterglow', 'beschreibung': 'Nachklang', 'start': 60, 'ende': 120},
      ],
      'fassungen': [
        _fassung('soft_frau', 'soft', 'frau'),
        _fassung('spicy_frau', 'spicy', 'frau'),
        _fassung('sehrspicy_frau', 'sehrspicy', 'frau'),
        _fassung('sehrspicy_mann', 'sehrspicy', 'mann'),
      ],
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bildzuordnung', () {
    test('Ohne Angabe bleibt Sehr spicy je Perspektive (wie „Der andere Körper“)', () {
      final f = _folge();
      expect(f.bildersatz, 'fassung');
      final mann = f.fassungen.last;
      expect(ReiheDaten.bildPfad(f, mann, mann.segmente.first), 'bilder/f1_sehrspicy_mann_opening.webp');
    });

    test('„stufe“: ein Satz je Folge und Stufe, auch bei Sehr spicy', () {
      final f = _folge(bildersatz: 'stufe');
      for (final fassung in f.fassungen.where((x) => x.sehrSpicy)) {
        expect(ReiheDaten.bildPfad(f, fassung, fassung.segmente.first), 'bilder/f1_sehrspicy_opening.webp');
      }
      final soft = f.fassungen.first;
      expect(ReiheDaten.bildPfad(f, soft, soft.segmente.first), 'bilder/f1_soft_opening.webp');
    });

    test('Unbekannte Werte gelten als „fassung“', () {
      expect(_folge(bildersatz: 'quatsch').bildersatz, 'fassung');
    });
  });

  group('Auswahl der Bilder', () {
    final vorhanden = {
      'bilder/f1_soft_opening.webp',
      'bilder/f1_soft_afterglow.webp',
      'bilder/f1_sehrspicy_afterglow.webp',
    };
    String? suche(String p) => vorhanden.contains(p) ? '/x/$p' : null;

    test('nur Bilder, die es gibt, in der Reihenfolge des Szenenbuchs', () {
      final f = _folge(bildersatz: 'stufe');
      final soft = ReiheGalerieScreen.bilder(f, 'soft', null, spicyErlaubt: true, dateiVon: suche);
      expect(soft.map((b) => b.szene), ['opening', 'afterglow']);
      expect(soft.first.beschreibung, 'Ankommen');
      expect(ReiheGalerieScreen.bilder(f, 'spicy', null, spicyErlaubt: true, dateiVon: suche), isEmpty);
      expect(ReiheGalerieScreen.bilder(f, 'sehrspicy', null, spicyErlaubt: true, dateiVon: suche).map((b) => b.szene),
          ['afterglow']);
    });

    test('Ohne Spicy gibt es für Spicy-Stufen nichts', () {
      final f = _folge(bildersatz: 'stufe');
      expect(ReiheGalerieScreen.bilder(f, 'sehrspicy', null, spicyErlaubt: false, dateiVon: suche), isEmpty);
      expect(ReiheGalerieScreen.hatBilder(f, null, spicyErlaubt: false, dateiVon: suche), isTrue); // Soft
      expect(ReiheGalerieScreen.hatBilder(f, null, spicyErlaubt: true, dateiVon: (_) => null), isFalse);
    });
  });

  group('Seite', () {
    late Directory ordner;
    late String bild;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      StorageService.resetForTest();
      AlterDienst.zuruecksetzen();
      await StorageService.init();
      await StorageService.setSpicyMode(true);
      ordner = Directory.systemTemp.createTempSync('galerie');
      bild = '${ordner.path}/b.png';
      // 1×1-PNG
      File(bild).writeAsBytesSync(const [
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01,
        0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41,
        0x54, 0x78, 0x9C, 0x63, 0xF8, 0xCF, 0xC0, 0xF0, 0x1F, 0x00, 0x05, 0x00, 0x01, 0xFF, 0x89, 0x99, 0x3D, 0x1D, 0x00, 0x00,
        0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
      ]);
    });

    tearDown(() => ordner.deleteSync(recursive: true));

    Future<void> zeigen(WidgetTester tester, ReiheFolge f, String variante, Set<String> pfade) async {
      await tester.pumpWidget(MaterialApp(
        home: ReiheGalerieScreen(
          folge: f,
          variante: variante,
          dateiVon: (p) => pfade.contains(p) ? bild : null,
        ),
      ));
      await tester.pump();
    }

    testWidgets('zeigt Bild, Beschreibung und Zähler; Stufenwechsel nur bei mehreren Stufen mit Bildern', (tester) async {
      await zeigen(tester, _folge(bildersatz: 'stufe'), 'soft', {
        'bilder/f1_soft_opening.webp',
        'bilder/f1_soft_afterglow.webp',
        'bilder/f1_sehrspicy_opening.webp',
      });
      expect(find.text('Ankommen'), findsOneWidget);
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNWidgets(2)); // Soft und Sehr spicy, Spicy hat keine Bilder
      await tester.tap(find.widgetWithText(ChoiceChip, 'Sehr spicy'));
      await tester.pump();
      expect(find.text('1 / 1'), findsOneWidget);
    });

    testWidgets('wischen wechselt die Szene', (tester) async {
      await zeigen(tester, _folge(bildersatz: 'stufe'), 'soft',
          {'bilder/f1_soft_opening.webp', 'bilder/f1_soft_afterglow.webp'});
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Nachklang'), findsOneWidget);
      expect(find.text('2 / 2'), findsOneWidget);
    });

    testWidgets('ohne Bilder erscheint ein ruhiger Hinweis', (tester) async {
      await zeigen(tester, _folge(bildersatz: 'stufe'), 'soft', {});
      expect(find.text('Zu dieser Folge gibt es noch keine Bilder.'), findsOneWidget);
    });

    testWidgets('das diskrete App-Symbol schließt die Seite', (tester) async {
      SharedPreferences.setMockInitialValues({'privacy_discreet_icon': true});
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReiheGalerieScreen(
                        folge: _folge(bildersatz: 'stufe'), variante: 'soft', dateiVon: (_) => bild))),
            child: const Text('auf'),
          ),
        ),
      ));
      await tester.tap(find.text('auf'));
      await tester.pumpAndSettle();
      expect(find.byType(ReiheGalerieScreen), findsNothing);
    });
  });
}
