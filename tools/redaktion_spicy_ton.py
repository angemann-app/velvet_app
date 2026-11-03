"""Gezielter Spicy-Tondurchgang DE/EN; Standard prüft, --uebernehmen schreibt.

Nur exakte freigegebene Stellen, keine Synthese oder Paketänderung.
Sichert Quellen, prüft Spicy-Gates und erhält sämtliche übrigen Daten.
"""
import argparse
import copy
import html
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/spicy-ton'
FAMILIEN = {'paar_abend': 'paar', 'selbst_reise': 'selbst',
            'einschlaf_reise': 'einschlaf', 'traum_reise': 'traum'}
PREFIX = {'paar_abend': 'block', 'selbst_reise': 'self_block',
          'einschlaf_reise': 'sleep_block', 'traum_reise': 'dream_block'}


def lesen(p):
    return json.loads(p.read_text(encoding='utf-8'))


def ersetzen(text, old, new):
    if old == new:
        return text
    if text.count(old) == 1:
        out = text.replace(old, new, 1)
    elif old not in text and text.count(new) == 1:
        return text
    else:
        raise ValueError('Ausgangsstelle fehlt oder ist mehrdeutig: ' + old[:80])
    assert re.findall(r'\{[^{}]*\}', out) == re.findall(r'\{[^{}]*\}', text)
    return out


def spicy(name, b):
    if name in ('paar_abend', 'selbst_reise'):
        return b.get('tiefe') in ('spicy', 'sehrSpicy')
    if name == 'einschlaf_reise':
        return b.get('teil') in ('s1', 's2')
    return b.get('stufe') == 'spicy'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--uebernehmen', action='store_true')
    args = parser.parse_args()
    intros = lesen(ROOT / 'tools/redaktion_spicy_ton_einstiege.json')
    bloecke = lesen(ROOT / 'tools/redaktion_spicy_ton_bausteine.json')
    prepared, changes, stamps, audio = [], [], set(), []
    for lang, basis, offset in [('de', 'assets/data', 0), ('en', 'translations/en', 2)]:
        for name in ('velvet_content', *FAMILIEN):
            path = ROOT / basis / (name + '.json')
            original = path.read_bytes()
            data = json.loads(original)
            before = copy.deepcopy(data)
            if name == 'velvet_content':
                all_lessons = {l['id']: (c, l) for c in data['courses'] for l in c['lessons']}
                assert set(intros) <= set(all_lessons)
                candidates = []
                for key, pair in intros.items():
                    course, lesson = all_lessons[key]
                    assert course.get('spicy') or lesson.get('spicy'), key
                    old, new = pair[offset:offset + 2]
                    text = lesson['content']
                    assert text.split('\n')[0] in (old, new), key
                    lesson['content'] = ersetzen(text, old, new)
                    candidates.append((key, text, lesson['content']))
                    stamps.add('lesson:' + key)
                # Nur content der erlaubten Spicy-Lektionen darf abweichen.
                checked = copy.deepcopy(data)
                for c0, c1 in zip(before['courses'], checked['courses']):
                    for l0, l1 in zip(c0['lessons'], c1['lessons']):
                        if l0['id'] in intros:
                            l1['content'] = l0['content']
                assert checked == before, 'Andere Kursdaten verändert'
            else:
                blocks = {b['id']: b for b in data['bausteine']}
                assert set(bloecke[name]) <= set(blocks)
                candidates = []
                for key, pair in bloecke[name].items():
                    b = blocks[key]
                    assert spicy(name, b), (name, key, 'kein Spicy-Gate')
                    text = b['text']
                    b['text'] = ersetzen(text, *pair[offset:offset + 2])
                    candidates.append((key, text, b['text']))
                    stamps.add(PREFIX[name] + ':' + key)
                checked = copy.deepcopy(data)
                for b0, b1 in zip(before['bausteine'], checked['bausteine']):
                    if b0['id'] in bloecke[name]:
                        b1['text'] = b0['text']
                assert checked == before, 'Andere Bausteine/Metadaten verändert'
            for key, old, new in candidates:
                if old != new:
                    changes.append(dict(sprache=lang, datei=name, id=key, vorher=old, nachher=new))
                # Auch beim wiederholten Prüfen bleibt die Liste des Gesamtauftrags erhalten.
                if name == 'velvet_content':
                    audio.append(f'{lang}/{key}')
                else:
                    audio.extend(f'{lang}/{FAMILIEN[name]}/{voice}_{key}' for voice in ('victoria', 'martin'))
            prepared.append((path, original, data, name, lang))
    OUT.mkdir(parents=True, exist_ok=True)
    if args.uebernehmen:
        for path, original, data, name, lang in prepared:
            snapshot = OUT / f'{name}.{lang}.vorher.json'
            if not snapshot.exists():
                snapshot.write_bytes(original)
            path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    report = OUT / ('uebernahme.json' if args.uebernehmen else 'pruefung.json')
    report.write_text(json.dumps({'status': 'übernommen' if args.uebernehmen else 'geprüft',
        'aenderungen': changes, 'aufnahme_ids_fuer_gezielte_neuvertonung': audio,
        'aufnahme_status': 'Vorhandene Audios nicht geändert; betroffene Textfassungen noch nicht neu gesprochen',
        'scope': 'nur Spicy, IDs/Metadaten/Normalfassungen unverändert'}, ensure_ascii=False, indent=2), encoding='utf-8')
    (OUT / 'stamps.txt').write_text(','.join(sorted(stamps)), encoding='utf-8')
    (OUT / 'neuvertonen.txt').write_text('\n'.join(audio) + '\n', encoding='utf-8')
    if changes:
        cards = []
        for a in changes:
            cards.append('<article><h2>' + html.escape(f"{a['sprache']}/{a['datei']}/{a['id']}") +
                '</h2><div><pre>' + html.escape(a['vorher']) + '</pre><pre>' + html.escape(a['nachher']) + '</pre></div></article>')
        (OUT / 'VERGLEICH.html').write_text('<!doctype html><html lang="de"><meta charset="utf-8">'
            '<title>Spicy-Tondurchgang DE/EN</title><style>body{background:#f6f0e6;color:#2a2a2c;font:16px system-ui;margin:40px}h1,h2{font-family:Georgia}article{border-top:1px solid #bba99f;padding:20px 0}div{display:grid;grid-template-columns:1fr 1fr;gap:30px}pre{white-space:pre-wrap;font:inherit;line-height:1.5}</style>'
            '<h1>Spicy-Tondurchgang · Vorher / Nachher</h1>' + ''.join(cards) + '</html>', encoding='utf-8')
    print(json.dumps({'geaenderte_sprachfassungen': len(changes), 'gezielte_aufnahme_ids': len(audio),
                      'uebernommen': args.uebernehmen, 'normal_und_metadaten': 'unverändert'}, ensure_ascii=False))


if __name__ == '__main__':
    main()
