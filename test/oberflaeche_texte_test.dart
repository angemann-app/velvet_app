// Oberflächentexte (lib/l10n/app_de.arb, app_en.arb): beide Sprachen vollständig und sauber.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String sprache) =>
    jsonDecode(File('lib/l10n/app_$sprache.arb').readAsStringSync()) as Map<String, dynamic>;

Set<String> _platzhalter(String text) {
  // Mehrzahl-Regeln ({count, plural, …}) zählen nur mit ihrem Namen.
  final namen = RegExp(r'\{(\w+)(?:,|\})').allMatches(text).map((m) => m.group(1)!).toSet();
  return namen..removeAll({'other'});
}

void main() {
  final de = _arb('de');
  final en = _arb('en');
  final schluessel = {for (final k in de.keys) if (!k.startsWith('@')) k};

  test('Jeder Text gibt es auf Deutsch und Englisch, keiner ist leer', () {
    final enSchluessel = {for (final k in en.keys) if (!k.startsWith('@')) k};
    expect(schluessel.difference(enSchluessel), isEmpty, reason: 'fehlt auf Englisch');
    expect(enSchluessel.difference(schluessel), isEmpty, reason: 'fehlt auf Deutsch');
    for (final k in schluessel) {
      expect((de[k] as String).trim(), isNotEmpty, reason: 'de: $k');
      expect((en[k] as String).trim(), isNotEmpty, reason: 'en: $k');
    }
  });

  test('Platzhalter stimmen in beiden Sprachen überein', () {
    for (final k in schluessel) {
      expect(_platzhalter(en[k] as String), _platzhalter(de[k] as String), reason: k);
    }
  });

  test('Keine kaputten Zeichen (falsch gelesene Kodierung)', () {
    final kaputt = RegExp('Ã|â€|ðŸ|Â');
    for (final k in schluessel) {
      expect(kaputt.hasMatch(de[k] as String), isFalse, reason: 'de: $k');
      expect(kaputt.hasMatch(en[k] as String), isFalse, reason: 'en: $k');
    }
  });
}
