// Eigene Spicy-Motive; private Bilder bleiben außerhalb der APK.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Alle 41 dekorativen Bildflächen sind WebP und haben eine eigene Spicy-Quelle',
      () {
    final j =
        jsonDecode(File('assets/data/bilder.json').readAsStringSync()) as Map;
    final bilder = (j['bilder'] as Map)
        .values
        .cast<Map>()
        .where((e) =>
            (e['altePfade'] as List?)?.any((p) =>
                RegExp(r'/(cover_|guided_|ynm_)').hasMatch(p as String)) ??
            false)
        .toList();
    expect(bilder, hasLength(41));
    for (final e in bilder) {
      expect(e['normal'], endsWith('.webp'));
      expect(File(e['normal'] as String).existsSync(), isTrue);
      final spicy = e['spicy'] as String;
      expect(spicy, endsWith('.webp'));
      if (spicy.startsWith('kurse/')) {
        expect(e['paketSpicy'], 'kurse-bilder-spicy');
        expect(File('assets/images/${spicy.split('/').last}').existsSync(),
            isFalse,
            reason:
                'Private Illustration gehört ins Inhaltspaket, nicht in die APK');
      } else {
        expect(File(spicy).existsSync(), isTrue);
      }
    }
    expect(
        Directory('assets/images').listSync().where((f) =>
            RegExp(r'[/\\](cover_|guided_|ynm_).*\.svg$').hasMatch(f.path)),
        isEmpty);
  });
}
