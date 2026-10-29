// Zu jedem Titelbild im Menü (cover_NN, guided_*, ynm_*) gibt es die dezente Spicy-Fassung (*_spicy.svg), sonst fehlt im Spicy-Modus das Bild.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Jedes Menü-Titelbild hat eine Spicy-Fassung', () {
    final muster = RegExp(r'^(cover_\d+|guided_[a-z]+|ynm_[a-z_]+)\.svg$');
    final fehlt = <String>[];
    var geprueft = 0;
    for (final f in Directory('assets/images').listSync().whereType<File>()) {
      final name = f.uri.pathSegments.last;
      if (!muster.hasMatch(name) || name.endsWith('_spicy.svg')) continue;
      geprueft++;
      if (!File('assets/images/${name.replaceFirst('.svg', '_spicy.svg')}').existsSync()) fehlt.add(name);
    }
    expect(geprueft, greaterThan(30));
    expect(fehlt, isEmpty, reason: 'Ohne Spicy-Fassung: ${fehlt.join(', ')} (python tools/generate_covers.py --spicy)');
  });
}
