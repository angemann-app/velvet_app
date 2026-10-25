// Regel: Jeder neue oder geänderte Inhalt wird auch ins Englische übersetzt (translations/en/).
//
// Jeder englische Eintrag merkt sich in `_source` eine Prüfsumme seines deutschen Ausgangstexts.
// Dieser Test schlägt fehl, wenn eine Übersetzung fehlt oder der deutsche Text sich seitdem geändert hat.
//
// Nach dem Übersetzen die Prüfsummen eintragen (nur für wirklich übersetzte Einträge!):
//   flutter test test/translation_test.dart --dart-define=STAMP=lesson:desire_1,block:ankommen_1
//   flutter test test/translation_test.dart --dart-define=STAMP=ALL      (nur bei der Ersteinrichtung)
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'uebersetzung/quellen.dart';

// Englisch ist Pflicht und wird bei jedem Testlauf geprüft. Weitere Sprachen (Beiträge der Community)
// lassen sich mit --dart-define=LANG=fr usw. prüfen und stempeln, blockieren aber keine Releases.
const _lang = String.fromEnvironment('LANG', defaultValue: 'en');
const _enDir = 'translations/$_lang';
const _stamp = String.fromEnvironment('STAMP');

void main() {
  final sources = germanSources();

  if (_stamp.isNotEmpty) {
    test('Prüfsummen eintragen ($_stamp)', () {
      final wanted = _stamp == 'ALL' ? null : _stamp.split(',').toSet();
      for (final entry in sources.entries) {
        final file = File('$_enDir/${entry.key}');
        final en = jsonLesen(file.path);
        final translated = translatedKeys(entry.key, en);
        final stamps = Map<String, dynamic>.from(en['_source'] as Map? ?? {});
        for (final s in entry.value.entries) {
          if ((wanted == null || wanted.contains(s.key)) && translated.contains(s.key)) stamps[s.key] = s.value;
        }
        en['_source'] = Map.fromEntries(stamps.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
        file.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(en)}\n');
      }
    });
    return;
  }

  for (final entry in sources.entries) {
    test('Englische Übersetzung vollständig und aktuell: ${entry.key}', () {
      final file = File('$_enDir/${entry.key}');
      expect(file.existsSync(), isTrue, reason: '$_enDir/${entry.key} fehlt');
      final en = jsonLesen(file.path);
      final translated = translatedKeys(entry.key, en);
      final stamps = Map<String, dynamic>.from(en['_source'] as Map? ?? {});

      final missing = entry.value.keys.where((k) => !translated.contains(k) || !stamps.containsKey(k)).toList();
      final outdated = entry.value.entries
          .where((s) => stamps.containsKey(s.key) && stamps[s.key] != s.value)
          .map((s) => s.key)
          .toList();
      expect(missing, isEmpty, reason: 'Ohne englische Übersetzung: ${missing.join(', ')}');
      expect(outdated, isEmpty,
          reason: 'Deutscher Text geändert, Englisch nicht nachgezogen: ${outdated.join(', ')}');
    });
  }
}
