"""Erzeugt DE/EN-Lektoratsentwürfe aller bestehenden Spicy-Lektionen zur Abnahme.

Produktionsdateien werden ausschließlich gelesen. Keine Aufnahmen oder Pakete werden erzeugt.
Die Korrekturen sind einzeln in redaktion_spicy_korrekturen.json und im Berührungsmuster nachvollziehbar.
"""
import difflib
import hashlib
import html
import json
from pathlib import Path

from redaktion_beruehrung_muster import KORREKTUREN

ROOT = Path(__file__).resolve().parents[1]
ZIEL = ROOT / 'build' / 'redaktion' / 'spicy'
QUELLEN = {'de': 'assets/data/velvet_content.json', 'en': 'translations/en/velvet_content.json'}


def geschuetzte_absaetze(text, sprache):
    """Aufgaben und vorhandene explizite Dialogabsätze werden wortgleich verglichen."""
    result = []
    for absatz in text.split('\n\n'):
        zeilen = absatz.splitlines()
        if not zeilen:
            continue
        kopf = zeilen[0].strip()
        if kopf.startswith(('Die Aufgabe', 'The task', 'The exercise', 'Sehr spicy:', 'Extra spicy:', 'Very spicy:')):
            result.append(absatz)
    return result


def main():
    extra = json.loads((ROOT / 'tools/redaktion_spicy_korrekturen.json').read_text(encoding='utf-8'))
    freigabe = json.loads((ROOT / 'tools/redaktion_spicy_aufgaben.json').read_text(encoding='utf-8'))['lektionen']
    mapping = {lang: dict(eintraege) for lang, eintraege in KORREKTUREN.items()}
    for kennung, paare in extra.items():
        if kennung in mapping['de']:
            raise ValueError(f'Doppelte Definition: {kennung}')
        for lang, offset in [('de', 0), ('en', 2)]:
            mapping[lang][kennung] = [(p[offset], p[offset + 1]) for p in paare]
    for kennung, paare in freigabe.items():
        for lang, offset in [('de', 0), ('en', 2)]:
            mapping[lang][kennung] += [(p[offset], p[offset + 1]) for p in paare]

    manifest = {'status': 'Lektoratsentwurf, keine Produktionsfreigabe', 'quellen': {}, 'lektionen': []}
    ausgaben = []
    fehler = []
    reihenfolge = []
    for lang, datei in QUELLEN.items():
        pfad = ROOT / datei
        manifest['quellen'][datei] = hashlib.sha256(pfad.read_bytes()).hexdigest()
        daten = json.loads(pfad.read_text(encoding='utf-8'))
        gesehen = set()
        for kurs in daten['courses']:
            for original in kurs['lessons']:
                kennung = original['id']
                if not (original.get('spicy') or kurs.get('spicy')):
                    continue
                gesehen.add(kennung)
                if lang == 'de':
                    reihenfolge.append(kennung)
                if kennung not in mapping[lang]:
                    fehler.append(f'{lang}/{kennung}: Korrekturdefinition fehlt')
                    continue
                text = original['content']
                for alt, neu in mapping[lang][kennung]:
                    if text.count(alt) != 1:
                        fehler.append(f'{lang}/{kennung}: Ausgangsstelle fehlt oder ist mehrdeutig: {alt[:100]}')
                        continue
                    text = text.replace(alt, neu)
                # Aufgaben dürfen nur im ausdrücklich freigegebenen Umfang abweichen.
                erwartete_aufgaben = original['content']
                offset = 0 if lang == 'de' else 2
                for paar in freigabe.get(kennung, []):
                    erwartete_aufgaben = erwartete_aufgaben.replace(paar[offset], paar[offset + 1])
                if geschuetzte_absaetze(erwartete_aufgaben, lang) != geschuetzte_absaetze(text, lang):
                    fehler.append(f'{lang}/{kennung}: Aufgabe oder Dialogabsatz weicht von der Freigabe ab')
                entwurf = dict(original, content=text)
                assert {k: v for k, v in entwurf.items() if k != 'content'} == {k: v for k, v in original.items() if k != 'content'}
                name = f'{kennung}.{lang}'
                ausgaben.append((name, kurs, original, entwurf))
                manifest['lektionen'].append({
                    'sprache': lang, 'id': kennung, 'course': kurs['id'], 'voice': original.get('voice', '(Kursvorgabe)'),
                    'stellen': len(mapping[lang][kennung]), 'zeichen_vorher': len(original['content']), 'zeichen_entwurf': len(text),
                })
        if gesehen != set(mapping[lang]):
            fehler.append(f'{lang}: Abweichende IDs: {sorted(gesehen ^ set(mapping[lang]))}')
    if fehler:
        raise SystemExit('\n'.join(fehler))
    assert len(ausgaben) == 54, 'Erwartet: 27 Lektionen in zwei Sprachen'
    ZIEL.mkdir(parents=True, exist_ok=True)
    index = ['# Spicy-Lektorat – Entwürfe zur Abnahme', '',
             '27 bestehende Lektionen, je Deutsch und Englisch. Vier freigegebene Aufgaben-/Ablaufkorrekturen sind enthalten. Produktionsdateien, Reflexionsfragen, Stimmen und IDs bleiben unverändert.', '',
             '| ID | Deutsch | Englisch |', '|---|---|---|']
    vergleich = []
    for name, kurs, original, entwurf in ausgaben:
        (ZIEL / f'{name}.json').write_text(json.dumps({'course': kurs['id'], 'lesson': entwurf}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        (ZIEL / f'{name}.md').write_text(f"# {entwurf['title']}\n\nEntwurf zur Abnahme · {name} · {kurs['id']}\n\n{entwurf['summary']}\n\n{entwurf['content']}\n\n## Reflexion\n\n{entwurf['reflection_question']}\n", encoding='utf-8')
        differenz = ''.join(difflib.unified_diff(original['content'].splitlines(True), entwurf['content'].splitlines(True), fromfile=name + '/vorher', tofile=name + '/entwurf'))
        (ZIEL / f'{name}.diff').write_text(differenz, encoding='utf-8')
        vergleich.append(f'<section><h2>{html.escape(name)} – {html.escape(entwurf["title"])}</h2><div class="paar"><article><h3>Vorher</h3><pre>{html.escape(original["content"])}</pre></article><article><h3>Entwurf</h3><pre>{html.escape(entwurf["content"])}</pre></article></div></section>')
    for kennung in reihenfolge:
        index.append(f'| {kennung} | [Entwurf]({kennung}.de.md) · [Diff]({kennung}.de.diff) | [Draft]({kennung}.en.md) · [Diff]({kennung}.en.diff) |')
    (ZIEL / 'INDEX.md').write_text('\n'.join(index) + '\n', encoding='utf-8')
    kopf = '<!doctype html><html lang="de"><meta charset="utf-8"><title>Spicy-Lektorat – Vergleich</title><style>body{font:16px/1.6 system-ui;margin:32px;background:#f6f0e6;color:#2a2a2c}.paar{display:grid;grid-template-columns:1fr 1fr;gap:24px}article{padding:20px;background:#fbf7f0;border:1px solid #aaa}pre{font:inherit;white-space:pre-wrap}section{margin-bottom:64px}@media(max-width:800px){.paar{grid-template-columns:1fr}}</style><h1>Spicy-Lektorat: Vorher und Entwurf</h1><p>27 Lektionen in Deutsch und Englisch. Zur Abnahme; Produktionsstand unverändert.</p>'
    (ZIEL / 'VERGLEICH.html').write_text(kopf + '\n'.join(vergleich) + '</html>', encoding='utf-8')
    (ZIEL / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'{len(ausgaben)} Fassungen erzeugt. Aufgaben gegen Freigabe geprüft; Metadaten und Dialogabsätze unverändert. {ZIEL}')


if __name__ == '__main__':
    main()
