// Spicy-Stimmungsbilder der Praxis-Lektionen: Feld „bilder“ und Paket kurse-bilder-spicy.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/content_models.dart';
import 'package:velvetpulse/services/pakete.dart';

void main() {
  test('Lesson liest das Feld bilder, fehlt es, ist die Liste leer', () {
    final json = {
      'id': 'x_1',
      'title': 'T',
      'bilder': ['kurse/x_allein_a.webp', 'kurse/x_zweit_a.webp'],
    };
    expect(Lesson.fromJson(json).bilder, ['kurse/x_allein_a.webp', 'kurse/x_zweit_a.webp']);
    expect(Lesson.fromJson({'id': 'y', 'title': 'T'}).bilder, isEmpty);
    expect(Lesson.fromJson(json).toJson()['bilder'], hasLength(2));
  });

  test('Pakete.datei findet Bilder im sprachunabhängigen Paket kurse-bilder-spicy', () {
    final ordner = Directory.systemTemp.createTempSync('pakete_kurse');
    addTearDown(() {
      Pakete.basisFuerTest = null;
      ordner.deleteSync(recursive: true);
    });
    Pakete.basisFuerTest = ordner.path;
    expect(Pakete.datei('kurse/x_allein_a.webp'), isNull);
    final datei = File('${ordner.path}/${Pakete.kurseBilderSpicy}/kurse/x_allein_a.webp')..createSync(recursive: true);
    expect(Pakete.datei('kurse/x_allein_a.webp'), datei.path);
  });
}
