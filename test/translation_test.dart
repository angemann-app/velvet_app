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

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/couple_channel_models.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';

// Englisch ist Pflicht und wird bei jedem Testlauf geprüft. Weitere Sprachen (Beiträge der Community)
// lassen sich mit --dart-define=LANG=fr usw. prüfen und stempeln, blockieren aber keine Releases.
const _lang = String.fromEnvironment('LANG', defaultValue: 'en');
const _enDir = 'translations/$_lang';
const _stamp = String.fromEnvironment('STAMP');

String _hash(Object value) => sha256.convert(utf8.encode(jsonEncode(value))).toString().substring(0, 16);

Map<String, dynamic> _readJson(String path) => jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// Deutsche Quelle: Schlüssel → Prüfsumme der übersetzbaren Texte.
Map<String, Map<String, String>> germanSources() {
  final content = _readJson('assets/data/velvet_content.json');
  final paar = _readJson('assets/data/paar_abend.json');
  final selbst = _readJson('assets/data/selbst_reise.json');
  final news = _readJson('assets/data/neuigkeiten.json');
  final anleitung = _readJson('assets/data/anleitung.json');
  final fotoIdeen = _readJson('assets/data/foto_ideen.json');
  return {
    'velvet_content.json': {
      for (final c in content['courses'] as List) ...{
        'course:${c['id']}': _hash({'title': c['title'], 'subtitle': c['subtitle']}),
        for (final l in c['lessons'] as List)
          'lesson:${l['id']}': _hash({
            'title': l['title'],
            'summary': l['summary'],
            'content': l['content'],
            'reflection_question': l['reflection_question'],
          }),
      },
      for (final s in content['sos_cards'] as List) 'sos:${s['id']}': _hash(s),
      for (final b in content['belief_library'] as List) 'belief:${b['id']}': _hash(b),
      for (final m in content['match_cards'] as List) 'match:${m['id']}': _hash(m),
    },
    'paar_abend.json': {
      for (final b in paar['bausteine'] as List) 'block:${b['id']}': _hash(b['text'] as String),
    },
    'selbst_reise.json': {
      for (final b in selbst['bausteine'] as List) 'self_block:${b['id']}': _hash(b['text'] as String),
    },
    'neuigkeiten.json': {
      for (final e in news['eintraege'] as List) 'news:${e['build']}': _hash(e['punkte']),
    },
    'anleitung.json': {
      for (final a in anleitung['abschnitte'] as List) 'guide:${a['id']}': _hash({'titel': a['titel'], 'text': a['text']}),
    },
    'foto_ideen.json': {
      for (final i in fotoIdeen['ideen'] as List) 'photo_idea:${i['id']}': _hash(i['text'] as String),
    },
    'yes_no_maybe.json': {
      for (final c in velvetYesNoMaybeCategories) ...{
        'ynm_cat:${c.id}': _hash({'title': c.title, 'description': c.description}),
        for (final i in c.items) 'ynm:${i.id}': _hash({'text': i.text, 'explanation': i.explanation}),
      },
    },
    'fantasy_options.json': {
      for (final o in defaultFantasyOptions)
        'fantasy:${o.id}': _hash({'title': o.title, 'subtitle': o.subtitle, 'tag': o.tag}),
    },
  };
}

/// Schlüssel, zu denen es in der englischen Datei tatsächlich einen übersetzten Eintrag gibt.
Set<String> translatedKeys(String file, Map<String, dynamic> en) {
  switch (file) {
    case 'velvet_content.json':
      return {
        for (final c in en['courses'] as List) ...{
          if ((c['title'] as String?)?.isNotEmpty ?? false) 'course:${c['id']}',
          for (final l in c['lessons'] as List)
            if ((l['content'] as String?)?.isNotEmpty ?? false) 'lesson:${l['id']}',
        },
        for (final s in en['sos_cards'] as List) 'sos:${s['id']}',
        for (final b in en['belief_library'] as List) 'belief:${b['id']}',
        for (final m in en['match_cards'] as List) 'match:${m['id']}',
      };
    case 'paar_abend.json':
      return {for (final b in en['bausteine'] as List) 'block:${b['id']}'};
    case 'selbst_reise.json':
      return {for (final b in en['bausteine'] as List) 'self_block:${b['id']}'};
    case 'neuigkeiten.json':
      return {for (final e in en['eintraege'] as List) 'news:${e['build']}'};
    case 'anleitung.json':
      return {for (final a in en['abschnitte'] as List) 'guide:${a['id']}'};
    case 'foto_ideen.json':
      return {for (final i in en['ideen'] as List) 'photo_idea:${i['id']}'};
    case 'yes_no_maybe.json':
      return {
        for (final c in en['categories'] as List) ...{
          'ynm_cat:${c['id']}',
          for (final i in c['items'] as List) 'ynm:${i['id']}',
        },
      };
    case 'fantasy_options.json':
      return {for (final o in en['options'] as List) 'fantasy:${o['id']}'};
  }
  return {};
}

void main() {
  final sources = germanSources();

  if (_stamp.isNotEmpty) {
    test('Prüfsummen eintragen ($_stamp)', () {
      final wanted = _stamp == 'ALL' ? null : _stamp.split(',').toSet();
      for (final entry in sources.entries) {
        final file = File('$_enDir/${entry.key}');
        final en = _readJson(file.path);
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
      final en = _readJson(file.path);
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
