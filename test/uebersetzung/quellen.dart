// Deutsche Ausgangstexte und ihre Prüfsummen. Gemeinsam genutzt von test/translation_test.dart
// (Englisch vollständig und aktuell?) und test/uebersetzung_test.dart (PO-Dateien für Übersetzer).
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:velvetpulse/models/couple_channel_models.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';

String quellHash(Object value) => sha256.convert(utf8.encode(jsonEncode(value))).toString().substring(0, 16);

Map<String, dynamic> jsonLesen(String path) => jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// Deutsche Quelle: Datei → (Schlüssel → Prüfsumme der übersetzbaren Texte).
Map<String, Map<String, String>> germanSources() {
  final content = jsonLesen('assets/data/velvet_content.json');
  final paar = jsonLesen('assets/data/paar_abend.json');
  final selbst = jsonLesen('assets/data/selbst_reise.json');
  final news = jsonLesen('assets/data/neuigkeiten.json');
  final anleitung = jsonLesen('assets/data/anleitung.json');
  final fotoIdeen = jsonLesen('assets/data/foto_ideen.json');
  return {
    'velvet_content.json': {
      for (final c in content['courses'] as List) ...{
        'course:${c['id']}': quellHash({'title': c['title'], 'subtitle': c['subtitle']}),
        for (final l in c['lessons'] as List)
          'lesson:${l['id']}': quellHash({
            'title': l['title'],
            'summary': l['summary'],
            'content': l['content'],
            'reflection_question': l['reflection_question'],
          }),
      },
      for (final s in content['sos_cards'] as List) 'sos:${s['id']}': quellHash(s),
      for (final b in content['belief_library'] as List) 'belief:${b['id']}': quellHash(b),
      for (final m in content['match_cards'] as List) 'match:${m['id']}': quellHash(m),
    },
    'paar_abend.json': {
      for (final b in paar['bausteine'] as List) 'block:${b['id']}': quellHash(b['text'] as String),
    },
    'selbst_reise.json': {
      for (final b in selbst['bausteine'] as List) 'self_block:${b['id']}': quellHash(b['text'] as String),
    },
    'neuigkeiten.json': {
      for (final e in news['eintraege'] as List) 'news:${e['build']}': quellHash(e['punkte']),
    },
    'anleitung.json': {
      for (final a in anleitung['abschnitte'] as List)
        'guide:${a['id']}': quellHash({'titel': a['titel'], 'text': a['text']}),
    },
    'foto_ideen.json': {
      for (final i in fotoIdeen['ideen'] as List) 'photo_idea:${i['id']}': quellHash(i['text'] as String),
    },
    'yes_no_maybe.json': {
      for (final c in velvetYesNoMaybeCategories) ...{
        'ynm_cat:${c.id}': quellHash({'title': c.title, 'description': c.description}),
        for (final i in c.items) 'ynm:${i.id}': quellHash({'text': i.text, 'explanation': i.explanation}),
      },
    },
    'fantasy_options.json': {
      for (final o in defaultFantasyOptions)
        'fantasy:${o.id}': quellHash({'title': o.title, 'subtitle': o.subtitle, 'tag': o.tag}),
    },
  };
}

/// Schlüssel, zu denen es in der übersetzten Datei tatsächlich einen übersetzten Eintrag gibt.
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
