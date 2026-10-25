// PO-Dateien für Übersetzerinnen und Übersetzer (translations/po/<bereich>/<sprache>.po).
//
// Jeder Text der App ist dort ein eigener Eintrag: deutsches Original, Zusammenhang, englische
// Fassung als Hilfe und ein Feld für die Übersetzung. Für andere Sprachen als Englisch sind die
// PO-Dateien die Quelle; translations/<sprache>/*.json wird daraus erzeugt. Englisch pflegen wir
// weiter direkt in translations/en/ und lib/l10n/app_en.arb.
//
// Aufruf über test/uebersetzung_test.dart, Erklärung in translations/README.md.
import 'dart:convert';
import 'dart:io';

import 'package:velvetpulse/models/couple_channel_models.dart';
import 'package:velvetpulse/models/yes_no_maybe_models.dart';

import 'quellen.dart';

/// Ein einzelner übersetzbarer Text, z. B. `lesson:neuro_1#content`.
class Feld {
  final String schluessel;
  final String deutsch;
  const Feld(this.schluessel, this.deutsch);

  int get woerter => deutsch.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

/// Was zusammen übersetzt und geprüft wird, z. B. eine Lektion mit Titel, Text und Frage.
class Einheit {
  final String schluessel;
  final String pruefsumme;
  final String kontext;
  final List<Feld> felder;
  const Einheit(this.schluessel, this.pruefsumme, this.kontext, this.felder);
}

/// Eine PO-Datei je Sprache, z. B. alle Kurse.
class Bereich {
  final String name;
  final String titel;
  final String quelle;
  final bool erwachsen;
  final List<Einheit> einheiten;
  const Bereich(this.name, this.titel, this.quelle, this.erwachsen, this.einheiten);
}

const poOrdner = 'translations/po';

const sprachNamen = {
  'en': 'English',
  'fr': 'Français',
  'es': 'Español',
  'it': 'Italiano',
  'pt': 'Português',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'cs': 'Čeština',
  'sv': 'Svenska',
  'da': 'Dansk',
  'no': 'Norsk',
  'fi': 'Suomi',
  'tr': 'Türkçe',
  'uk': 'Українська',
  'ru': 'Русский',
};

/// Textfelder eines Objekts in fester Reihenfolge: Zeichenketten direkt, Listen als `feld.0`, `feld.1` …
Map<String, String> _textFelder(Map<String, dynamic> m, {Set<String> ohne = const {'id', 'target'}}) => {
      for (final e in m.entries)
        if (!ohne.contains(e.key)) ...{
          if (e.value is String) e.key: e.value as String,
          if (e.value is List)
            for (var i = 0; i < (e.value as List).length; i++)
              if ((e.value as List)[i] is String) '${e.key}.$i': (e.value as List)[i] as String,
        },
    };

/// Alle deutschen Texte der App, in der Reihenfolge, in der sie in der App vorkommen.
List<Bereich> bereiche() {
  final summen = {for (final m in germanSources().values) ...m};
  Einheit einheit(String schluessel, String kontext, Map<String, String> felder, {String? summe}) => Einheit(
        schluessel,
        summe ?? summen[schluessel]!,
        kontext,
        [
          for (final f in felder.entries)
            if (f.value.trim().isNotEmpty) Feld('$schluessel#${f.key}', f.value)
        ],
      );
  String merkmale(Map<String, dynamic> b) => [
        for (final e in b.entries)
          if (e.key != 'id' && e.key != 'text') '${e.key}: ${e.value is String ? e.value : jsonEncode(e.value)}'
      ].join(', ');

  final arb = jsonLesen('lib/l10n/app_de.arb');
  final oberflaeche = [
    for (final e in arb.entries)
      if (!e.key.startsWith('@') && e.value is String)
        einheit('ui:${e.key}', _arbKontext(arb['@${e.key}']), {'text': e.value as String},
            summe: quellHash(e.value as String)),
  ];

  final inhalt = jsonLesen('assets/data/velvet_content.json');
  final kurse = <Einheit>[
    for (final c in inhalt['courses'] as List) ...[
      einheit('course:${c['id']}', 'Kurs: Titel und Untertitel', {'title': c['title'], 'subtitle': c['subtitle']}),
      for (final l in c['lessons'] as List)
        einheit(
          'lesson:${l['id']}',
          'Lektion im Kurs „${c['title']}“${l['spicy'] == true ? ' (nur im Spicy-Modus)' : ''}',
          {
            'title': l['title'],
            'summary': l['summary'],
            'content': l['content'],
            'reflection_question': l['reflection_question'],
          },
        ),
    ],
    for (final s in inhalt['sos_cards'] as List)
      einheit('sos:${s['id']}', 'Soforthilfe-Karte (SOS)', _textFelder(s as Map<String, dynamic>)),
    for (final b in inhalt['belief_library'] as List)
      einheit('belief:${b['id']}', 'Glaubenssatz mit Gegenstück', _textFelder(b as Map<String, dynamic>)),
    for (final m in inhalt['match_cards'] as List)
      einheit('match:${m['id']}', 'Wunsch-Karte', _textFelder(m as Map<String, dynamic>)),
  ];

  final jaNein = <Einheit>[
    for (final c in velvetYesNoMaybeCategories) ...[
      einheit('ynm_cat:${c.id}', 'Kategorie der Ja/Nein/Vielleicht-Liste${c.spicy ? ' (nur im Spicy-Modus)' : ''}',
          {'title': c.title, 'description': c.description}),
      for (final i in c.items)
        einheit('ynm:${i.id}', 'Frage in „${c.title}“: Aussage und Erklärung', {'text': i.text, 'explanation': i.explanation}),
    ],
    for (final o in defaultFantasyOptions)
      einheit('fantasy:${o.id}', 'Fantasie-Karte: Titel, Beschreibung, Schlagwort',
          {'title': o.title, 'subtitle': o.subtitle, 'tag': o.tag}),
  ];

  List<Einheit> bausteine(String datei, String praefix, String art) => [
        for (final b in jsonLesen('assets/data/$datei')['bausteine'] as List)
          einheit('$praefix:${b['id']}', '$art, ${merkmale(b as Map<String, dynamic>)}', {'text': b['text'] as String}),
      ];

  return [
    Bereich('oberflaeche', 'Oberfläche (Knöpfe, Menüs, Meldungen)', 'lib/l10n/app_de.arb', false, oberflaeche),
    Bereich('kurse', 'Kurse und Lektionen', 'assets/data/velvet_content.json', true, kurse),
    Bereich('ja_nein', 'Ja/Nein/Vielleicht-Liste und Fantasie-Karten', 'lib/models/yes_no_maybe_models.dart, '
        'lib/models/couple_channel_models.dart', true, jaNein),
    Bereich('selbst_reise', 'Geführte Selbsterkundung (Audio-Bausteine)', 'assets/data/selbst_reise.json', true,
        bausteine('selbst_reise.json', 'self_block', 'Baustein der geführten Selbsterkundung')),
    Bereich('einschlaf_reise', 'Einschlaf-Reise (Audio-Bausteine)', 'assets/data/einschlaf_reise.json', true,
        bausteine('einschlaf_reise.json', 'sleep_block', 'Baustein der Einschlaf-Reise')),
    Bereich('paar_abend', 'Gemeinsamer Abend (Audio-Bausteine)', 'assets/data/paar_abend.json', true,
        bausteine('paar_abend.json', 'block', 'Baustein des gemeinsamen Abends')),
    Bereich('anleitung', 'Anleitung in der App', 'assets/data/anleitung.json', false, [
      for (final a in jsonLesen('assets/data/anleitung.json')['abschnitte'] as List)
        einheit('guide:${a['id']}', 'Abschnitt der Anleitung', {'titel': a['titel'], 'text': a['text']}),
    ]),
    Bereich('neuigkeiten', 'Was ist neu (nach Updates)', 'assets/data/neuigkeiten.json', false, [
      for (final e in jsonLesen('assets/data/neuigkeiten.json')['eintraege'] as List)
        einheit('news:${e['build']}', 'Was ist neu in Version ${e['version']}', {
          for (var i = 0; i < (e['punkte'] as List).length; i++) ...{
            '$i.titel': e['punkte'][i]['titel'] as String,
            '$i.text': e['punkte'][i]['text'] as String,
          },
        }),
    ]),
    Bereich('foto_ideen', 'Foto-Ideen im Paar-Chat (nur im Spicy-Modus)', 'assets/data/foto_ideen.json', true, [
      for (final i in jsonLesen('assets/data/foto_ideen.json')['ideen'] as List)
        einheit('photo_idea:${i['id']}', i['heiss'] == true ? 'Foto-Idee, deutlich' : 'Foto-Idee, sanft',
            {'text': i['text'] as String}),
    ]),
  ];
}

String _arbKontext(Object? meta) {
  if (meta is! Map) return 'Text der Oberfläche';
  final teile = <String>[
    if (meta['description'] is String) meta['description'] as String,
    if (meta['placeholders'] is Map && (meta['placeholders'] as Map).isNotEmpty)
      'Platzhalter unverändert übernehmen: ${(meta['placeholders'] as Map).keys.map((k) => '{$k}').join(', ')}',
  ];
  return teile.isEmpty ? 'Text der Oberfläche' : teile.join('. ');
}

// ---------------------------------------------------------------------------
// Übersetzungen lesen und schreiben (translations/<sprache>/)

/// Alle übersetzten Texte einer Sprache: Feld-Schlüssel → Text. Leere Texte zählen als fehlend.
Map<String, String> felderLesen(String ordner, {String? arb}) {
  final f = <String, String>{};
  void setzen(String schluessel, Object? wert) {
    if (wert is String && wert.trim().isNotEmpty) f[schluessel] = wert;
  }

  Map<String, dynamic>? datei(String name) {
    final d = File('$ordner/$name');
    return d.existsSync() ? jsonLesen(d.path) : null;
  }

  final inhalt = datei('velvet_content.json');
  if (inhalt != null) {
    for (final c in inhalt['courses'] as List? ?? const []) {
      setzen('course:${c['id']}#title', c['title']);
      setzen('course:${c['id']}#subtitle', c['subtitle']);
      for (final l in c['lessons'] as List? ?? const []) {
        for (final feld in const ['title', 'summary', 'content', 'reflection_question']) {
          setzen('lesson:${l['id']}#$feld', l[feld]);
        }
      }
    }
    for (final (liste, praefix) in const [('sos_cards', 'sos'), ('belief_library', 'belief'), ('match_cards', 'match')]) {
      for (final m in inhalt[liste] as List? ?? const []) {
        for (final e in _textFelder(m as Map<String, dynamic>).entries) {
          setzen('$praefix:${m['id']}#${e.key}', e.value);
        }
      }
    }
  }
  for (final c in datei('yes_no_maybe.json')?['categories'] as List? ?? const []) {
    setzen('ynm_cat:${c['id']}#title', c['title']);
    setzen('ynm_cat:${c['id']}#description', c['description']);
    for (final i in c['items'] as List? ?? const []) {
      setzen('ynm:${i['id']}#text', i['text']);
      setzen('ynm:${i['id']}#explanation', i['explanation']);
    }
  }
  for (final o in datei('fantasy_options.json')?['options'] as List? ?? const []) {
    for (final feld in const ['title', 'subtitle', 'tag']) {
      setzen('fantasy:${o['id']}#$feld', o[feld]);
    }
  }
  for (final b in datei('selbst_reise.json')?['bausteine'] as List? ?? const []) {
    setzen('self_block:${b['id']}#text', b['text']);
  }
  for (final b in datei('einschlaf_reise.json')?['bausteine'] as List? ?? const []) {
    setzen('sleep_block:${b['id']}#text', b['text']);
  }
  for (final b in datei('paar_abend.json')?['bausteine'] as List? ?? const []) {
    setzen('block:${b['id']}#text', b['text']);
  }
  for (final a in datei('anleitung.json')?['abschnitte'] as List? ?? const []) {
    setzen('guide:${a['id']}#titel', a['titel']);
    setzen('guide:${a['id']}#text', a['text']);
  }
  for (final e in datei('neuigkeiten.json')?['eintraege'] as List? ?? const []) {
    final punkte = e['punkte'] as List? ?? const [];
    for (var i = 0; i < punkte.length; i++) {
      setzen('news:${e['build']}#$i.titel', punkte[i]['titel']);
      setzen('news:${e['build']}#$i.text', punkte[i]['text']);
    }
  }
  for (final i in datei('foto_ideen.json')?['ideen'] as List? ?? const []) {
    setzen('photo_idea:${i['id']}#text', i['text']);
  }
  final arbDatei = File(arb ?? '$ordner/oberflaeche.arb');
  if (arbDatei.existsSync()) {
    for (final e in jsonLesen(arbDatei.path).entries) {
      if (!e.key.startsWith('@')) setzen('ui:${e.key}#text', e.value);
    }
  }
  return f;
}

/// Prüfsummen der deutschen Texte, gegen die übersetzt wurde: Einheit → Prüfsumme.
Map<String, String> stempelLesen(String ordner) {
  final s = <String, String>{};
  for (final name in const [
    'velvet_content.json',
    'yes_no_maybe.json',
    'fantasy_options.json',
    'selbst_reise.json',
    'einschlaf_reise.json',
    'paar_abend.json',
    'anleitung.json',
    'neuigkeiten.json',
    'foto_ideen.json',
  ]) {
    final d = File('$ordner/$name');
    if (d.existsSync()) s.addAll(Map<String, String>.from(jsonLesen(d.path)['_source'] as Map? ?? const {}));
  }
  final ui = File('$ordner/oberflaeche_quelle.json');
  if (ui.existsSync()) s.addAll(Map<String, String>.from(jsonLesen(ui.path)));
  return s;
}

void _jsonSchreiben(String pfad, Object daten) {
  File(pfad)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(daten)}\n');
}

/// Schreibt die Übersetzungen einer Sprache im selben Aufbau wie translations/en/.
void uebersetzungSchreiben(String ordner, String sprache, Map<String, String> felder, Map<String, String> stempel) {
  final hinweis = 'Übersetzung ($sprache), erzeugt aus $poOrdner/*/$sprache.po. Nicht von Hand ändern, '
      'sondern die PO-Dateien (translations/README.md).';
  Map<String, String> quelle(List<String> praefixe) => Map.fromEntries(
      (stempel.entries.where((e) => praefixe.any((p) => e.key.startsWith('$p:'))).toList()
        ..sort((a, b) => a.key.compareTo(b.key))));
  String text(String schluessel) => felder[schluessel] ?? '';
  bool irgendwas(String einheit) => felder.keys.any((k) => k.startsWith('$einheit#'));
  Map<String, dynamic> ersetzt(Map<String, dynamic> deutsch, String einheit) {
    final kopie = jsonDecode(jsonEncode(deutsch)) as Map<String, dynamic>;
    for (final feld in _textFelder(deutsch).keys) {
      final teile = feld.split('.');
      if (teile.length == 2 && kopie[teile[0]] is List) {
        (kopie[teile[0]] as List)[int.parse(teile[1])] = text('$einheit#$feld');
      } else {
        kopie[feld] = text('$einheit#$feld');
      }
    }
    return kopie;
  }

  final inhalt = jsonLesen('assets/data/velvet_content.json');
  _jsonSchreiben('$ordner/velvet_content.json', {
    '_hinweis': hinweis,
    'version': inhalt['version'],
    'courses': [
      for (final c in inhalt['courses'] as List)
        {
          ...{for (final e in (c as Map<String, dynamic>).entries) if (e.key != 'lessons') e.key: e.value},
          'title': text('course:${c['id']}#title'),
          'subtitle': text('course:${c['id']}#subtitle'),
          'lessons': [
            for (final l in c['lessons'] as List)
              {
                ...l as Map<String, dynamic>,
                for (final feld in const ['title', 'summary', 'content', 'reflection_question'])
                  feld: text('lesson:${l['id']}#$feld'),
              },
          ],
        },
    ],
    for (final (liste, praefix) in const [('sos_cards', 'sos'), ('belief_library', 'belief'), ('match_cards', 'match')])
      liste: [
        for (final m in inhalt[liste] as List)
          if (irgendwas('$praefix:${m['id']}')) ersetzt(m as Map<String, dynamic>, '$praefix:${m['id']}'),
      ],
    '_source': quelle(const ['course', 'lesson', 'sos', 'belief', 'match']),
  });

  _jsonSchreiben('$ordner/yes_no_maybe.json', {
    '_hinweis': hinweis,
    'categories': [
      for (final c in velvetYesNoMaybeCategories)
        if (irgendwas('ynm_cat:${c.id}') || c.items.any((i) => irgendwas('ynm:${i.id}')))
          {
            'id': c.id,
            'title': text('ynm_cat:${c.id}#title'),
            'description': text('ynm_cat:${c.id}#description'),
            'items': [
              for (final i in c.items)
                if (irgendwas('ynm:${i.id}'))
                  {'id': i.id, 'text': text('ynm:${i.id}#text'), 'explanation': text('ynm:${i.id}#explanation')},
            ],
          },
    ],
    '_source': quelle(const ['ynm_cat', 'ynm']),
  });

  _jsonSchreiben('$ordner/fantasy_options.json', {
    '_hinweis': hinweis,
    'options': [
      for (final o in defaultFantasyOptions)
        if (irgendwas('fantasy:${o.id}'))
          {
            'id': o.id,
            'title': text('fantasy:${o.id}#title'),
            'subtitle': text('fantasy:${o.id}#subtitle'),
            'tag': text('fantasy:${o.id}#tag'),
          },
    ],
    '_source': quelle(const ['fantasy']),
  });

  for (final (datei, praefix) in const [('selbst_reise.json', 'self_block'), ('einschlaf_reise.json', 'sleep_block'), ('paar_abend.json', 'block')]) {
    _jsonSchreiben('$ordner/$datei', {
      '_hinweis': hinweis,
      'bausteine': [
        for (final b in jsonLesen('assets/data/$datei')['bausteine'] as List)
          if (irgendwas('$praefix:${b['id']}')) {...b as Map<String, dynamic>, 'text': text('$praefix:${b['id']}#text')},
      ],
      '_source': quelle([praefix]),
    });
  }

  _jsonSchreiben('$ordner/anleitung.json', {
    '_hinweis': hinweis,
    'abschnitte': [
      for (final a in jsonLesen('assets/data/anleitung.json')['abschnitte'] as List)
        if (irgendwas('guide:${a['id']}'))
          {...a as Map<String, dynamic>, 'titel': text('guide:${a['id']}#titel'), 'text': text('guide:${a['id']}#text')},
    ],
    '_source': quelle(const ['guide']),
  });

  _jsonSchreiben('$ordner/neuigkeiten.json', {
    '_hinweis': hinweis,
    'eintraege': [
      for (final e in jsonLesen('assets/data/neuigkeiten.json')['eintraege'] as List)
        if (irgendwas('news:${e['build']}'))
          {
            ...e as Map<String, dynamic>,
            'punkte': [
              for (var i = 0; i < (e['punkte'] as List).length; i++)
                {
                  ...e['punkte'][i] as Map<String, dynamic>,
                  'titel': text('news:${e['build']}#$i.titel'),
                  'text': text('news:${e['build']}#$i.text'),
                },
            ],
          },
    ],
    '_source': quelle(const ['news']),
  });

  _jsonSchreiben('$ordner/foto_ideen.json', {
    '_hinweis': hinweis,
    'ideen': [
      for (final i in jsonLesen('assets/data/foto_ideen.json')['ideen'] as List)
        if (irgendwas('photo_idea:${i['id']}')) {...i as Map<String, dynamic>, 'text': text('photo_idea:${i['id']}#text')},
    ],
    '_source': quelle(const ['photo_idea']),
  });

  // Oberfläche: wie lib/l10n/app_<sprache>.arb, damit sie später direkt in die App übernommen werden kann.
  _jsonSchreiben('$ordner/oberflaeche.arb', {
    '@@locale': sprache,
    for (final e in jsonLesen('lib/l10n/app_de.arb').entries)
      if (!e.key.startsWith('@') && felder.containsKey('ui:${e.key}#text')) e.key: felder['ui:${e.key}#text'],
  });
  _jsonSchreiben('$ordner/oberflaeche_quelle.json', quelle(const ['ui']));
}

// ---------------------------------------------------------------------------
// PO-Format

String _poText(String s) {
  String esc(String x) => x.replaceAll('\\', r'\\').replaceAll('"', r'\"').replaceAll('\t', r'\t');
  final zeilen = s.replaceAll('\r', '').split('\n');
  if (zeilen.length == 1) return '"${esc(s)}"';
  final b = StringBuffer('""');
  for (var i = 0; i < zeilen.length; i++) {
    final z = i < zeilen.length - 1 ? '${esc(zeilen[i])}\\n' : esc(zeilen[i]);
    if (z.isNotEmpty) b.write('\n"$z"');
  }
  return b.toString();
}

String _kommentar(String praefix, String text) =>
    [for (final z in text.split('\n')) '#. $praefix$z'.trimRight()].join('\n');

/// Baut eine PO-Datei. Ohne [sprache] entsteht die Vorlage (.pot) mit leeren Übersetzungen.
String poBauen(Bereich b, String? sprache, Map<String, String> felder, Map<String, String> stempel,
    Map<String, String> englisch) {
  final o = StringBuffer()
    ..writeln('# VelvetPulse: ${b.titel}')
    ..writeln('# Ausgangssprache Deutsch, Quelle: ${b.quelle}')
    ..writeln('# Anleitung für Übersetzer / Guide for translators: translations/README.md');
  if (b.erwachsen) {
    o.writeln('# Enthält Inhalte über Sexualität für Erwachsene. / Contains adult content about sexuality.');
  }
  o
    ..writeln('#')
    ..writeln('msgid ""')
    ..writeln('msgstr ""')
    ..writeln(r'"Project-Id-Version: VelvetPulse\n"')
    ..writeln('"Language: ${sprache ?? ''}\\n"')
    ..writeln(r'"MIME-Version: 1.0\n"')
    ..writeln(r'"Content-Type: text/plain; charset=UTF-8\n"')
    ..writeln(r'"Content-Transfer-Encoding: 8bit\n"')
    ..writeln(r'"X-Source-Language: de\n"');
  for (final e in b.einheiten) {
    final veraltet = sprache != null && stempel[e.schluessel] != null && stempel[e.schluessel] != e.pruefsumme;
    for (final f in e.felder) {
      final uebersetzt = sprache == null ? '' : (felder[f.schluessel] ?? '');
      o
        ..writeln()
        ..writeln(_kommentar('', e.kontext));
      final en = englisch[f.schluessel];
      if (en != null && sprache != 'en') o.writeln(_kommentar('EN: ', en));
      if (veraltet && uebersetzt.isNotEmpty) o.writeln('#, fuzzy');
      o
        ..writeln('msgctxt ${_poText(f.schluessel)}')
        ..writeln('msgid ${_poText(f.deutsch)}')
        ..writeln('msgstr ${_poText(uebersetzt)}');
    }
  }
  return o.toString();
}

/// Ein Eintrag aus einer PO-Datei: deutscher Text, Übersetzung, als überholt markiert?
typedef PoEintrag = ({String deutsch, String text, bool fuzzy});

/// Liest eine PO-Datei: Feld-Schlüssel (msgctxt) → Eintrag.
Map<String, PoEintrag> poLesen(String inhalt) {
  final ergebnis = <String, PoEintrag>{};
  String unescape(String s) => s.replaceAllMapped(RegExp(r'\\(.)'), (m) {
        switch (m[1]) {
          case 'n':
            return '\n';
          case 't':
            return '\t';
          default:
            return m[1]!;
        }
      });
  String? ctxt, id, str;
  var fuzzy = false;
  String? aktuell;
  void abschliessen() {
    if (ctxt != null && id != null && str != null) ergebnis[ctxt!] = (deutsch: id!, text: str!, fuzzy: fuzzy);
    ctxt = id = str = aktuell = null;
    fuzzy = false;
  }

  for (final roh in const LineSplitter().convert(inhalt)) {
    final z = roh.trim();
    if (z.isEmpty) {
      abschliessen();
      continue;
    }
    if (z.startsWith('#,')) {
      if (str != null) abschliessen();
      fuzzy = z.contains('fuzzy');
      continue;
    }
    if (z.startsWith('#')) {
      if (str != null) abschliessen();
      continue;
    }
    final m = RegExp(r'^(msgctxt|msgid|msgstr)\s+"(.*)"$').firstMatch(z);
    if (m != null) {
      if (m[1] == 'msgctxt' || (m[1] == 'msgid' && str != null)) {
        if (str != null) abschliessen();
      }
      aktuell = m[1];
      final wert = unescape(m[2]!);
      switch (aktuell) {
        case 'msgctxt':
          ctxt = wert;
        case 'msgid':
          id = wert;
        case 'msgstr':
          str = wert;
      }
      continue;
    }
    final fortsetzung = RegExp(r'^"(.*)"$').firstMatch(z);
    if (fortsetzung != null) {
      final wert = unescape(fortsetzung[1]!);
      switch (aktuell) {
        case 'msgctxt':
          ctxt = '${ctxt ?? ''}$wert';
        case 'msgid':
          id = '${id ?? ''}$wert';
        case 'msgstr':
          str = '${str ?? ''}$wert';
      }
    }
  }
  abschliessen();
  return ergebnis;
}

// ---------------------------------------------------------------------------
// Abgleich: PO → translations/<sprache>/, dann translations/<sprache>/ → PO

String poPfad(String bereich, String sprache) => '$poOrdner/$bereich/$sprache.po';

/// Sprachen, für die es PO-Dateien gibt (Englisch nicht: das pflegen wir direkt).
List<String> poSprachen() {
  final s = <String>{};
  final d = Directory(poOrdner);
  if (!d.existsSync()) return [];
  for (final f in d.listSync(recursive: true).whereType<File>()) {
    final name = f.uri.pathSegments.last;
    if (name.endsWith('.po')) s.add(name.substring(0, name.length - 3));
  }
  return s.toList()..sort();
}

Map<String, String> englischLesen() => felderLesen('translations/en', arb: 'lib/l10n/app_en.arb');

/// Übernimmt die PO-Dateien einer Sprache nach translations/<sprache>/. Die Prüfsumme des aktuellen
/// deutschen Texts bekommt eine Einheit nur, wenn sie vollständig übersetzt, nicht als überholt markiert
/// und gegen genau diesen deutschen Text übersetzt ist (msgid in der PO-Datei = aktueller Text).
/// Hat sich der deutsche Text seit dem letzten Abgleich geändert, bleibt die alte Prüfsumme stehen
/// und die Einheit erscheint danach als überholt.
void poEinspielen(String sprache, List<Bereich> alle) {
  final ordner = 'translations/$sprache';
  final eintraege = <String, PoEintrag>{};
  for (final b in alle) {
    final f = File(poPfad(b.name, sprache));
    if (f.existsSync()) eintraege.addAll(poLesen(f.readAsStringSync()));
  }
  final felder = {
    for (final e in eintraege.entries)
      if (e.value.text.trim().isNotEmpty) e.key: e.value.text
  };
  final stempel = stempelLesen(ordner);
  for (final b in alle) {
    for (final e in b.einheiten) {
      final da = e.felder.where((f) => felder.containsKey(f.schluessel)).toList();
      if (da.isEmpty) {
        stempel.remove(e.schluessel);
      } else if (da.length == e.felder.length &&
          da.every((f) => eintraege[f.schluessel]?.fuzzy != true && eintraege[f.schluessel]?.deutsch == f.deutsch)) {
        stempel[e.schluessel] = e.pruefsumme;
      }
    }
  }
  uebersetzungSchreiben(ordner, sprache, felder, stempel);
}

/// Erzeugt die PO-Dateien einer Sprache aus translations/<sprache>/ (neue deutsche Texte kommen leer dazu,
/// geänderte werden als überholt markiert).
Map<String, String> poDateienErzeugen(String sprache, List<Bereich> alle, Map<String, String> englisch) {
  final ordner = 'translations/$sprache';
  final felder = felderLesen(ordner);
  final stempel = stempelLesen(ordner);
  return {for (final b in alle) poPfad(b.name, sprache): poBauen(b, sprache, felder, stempel, englisch)};
}

Map<String, String> vorlagenErzeugen(List<Bereich> alle, Map<String, String> englisch) =>
    {for (final b in alle) '$poOrdner/${b.name}/${b.name}.pot': poBauen(b, null, const {}, const {}, englisch)};

// ---------------------------------------------------------------------------
// Fortschritt

typedef Stand = ({int aktuell, int ueberholt, int fehlt, int woerterAktuell, int woerter});

Stand standBerechnen(Bereich b, Map<String, String> felder, Map<String, String> stempel) {
  var aktuell = 0, ueberholt = 0, fehlt = 0, wAktuell = 0, woerter = 0;
  for (final e in b.einheiten) {
    final veraltet = stempel[e.schluessel] != null && stempel[e.schluessel] != e.pruefsumme;
    for (final f in e.felder) {
      woerter += f.woerter;
      if (!felder.containsKey(f.schluessel)) {
        fehlt++;
      } else if (veraltet) {
        ueberholt++;
      } else {
        aktuell++;
        wAktuell += f.woerter;
      }
    }
  }
  return (aktuell: aktuell, ueberholt: ueberholt, fehlt: fehlt, woerterAktuell: wAktuell, woerter: woerter);
}

String _prozent(int teil, int ganz) => ganz == 0 ? '–' : '${(100 * teil / ganz).floor()} %';

String statusErzeugen(List<Bereich> alle, Map<String, String> englisch) {
  final sprachen = <String, (Map<String, String>, Map<String, String>)>{
    'en': (englisch, stempelLesen('translations/en')),
    for (final s in poSprachen()) s: (felderLesen('translations/$s'), stempelLesen('translations/$s')),
  };
  final o = StringBuffer()
    ..writeln('# Übersetzungsstand / Translation status')
    ..writeln()
    ..writeln('Automatisch erzeugt, nicht von Hand ändern. Prozent nach Wörtern der deutschen Texte, '
        'überholte Übersetzungen zählen nicht mit. Mitmachen: [README.md](README.md).')
    ..writeln()
    ..writeln('Generated automatically, do not edit. Percentages by words of the German source; '
        'outdated translations are not counted. How to help: [README.md](README.md).')
    ..writeln()
    ..writeln('| Sprache / Language | Gesamt / Total | ${alle.map((b) => b.titel.split(' (').first).join(' | ')} |')
    ..writeln('|---|---|${alle.map((_) => '---').join('|')}|');
  for (final s in sprachen.entries) {
    final staende = [for (final b in alle) standBerechnen(b, s.value.$1, s.value.$2)];
    final gesamt = staende.fold(0, (a, x) => a + x.woerterAktuell);
    final ganz = staende.fold(0, (a, x) => a + x.woerter);
    o.writeln('| ${sprachNamen[s.key] ?? s.key} (${s.key}) | **${_prozent(gesamt, ganz)}** | '
        '${staende.map((x) => _prozent(x.woerterAktuell, x.woerter)).join(' | ')} |');
  }
  for (final s in sprachen.entries) {
    o
      ..writeln()
      ..writeln('## ${sprachNamen[s.key] ?? s.key} (${s.key})')
      ..writeln()
      ..writeln('| Bereich / Area | Aktuell / Up to date | Überholt / Outdated | Fehlt / Missing | Datei / File |')
      ..writeln('|---|---|---|---|---|');
    for (final b in alle) {
      final x = standBerechnen(b, s.value.$1, s.value.$2);
      final datei = s.key == 'en' ? '(direkt gepflegt)' : '[${b.name}/${s.key}.po](po/${b.name}/${s.key}.po)';
      o.writeln('| ${b.titel} | ${x.aktuell} | ${x.ueberholt} | ${x.fehlt} | $datei |');
    }
  }
  return o.toString();
}
