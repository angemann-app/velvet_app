"""Prüft alle geführten DE/EN-Quellen gegen Git und erzeugt den Lektoratsvergleich."""
import hashlib
import html
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/gesamt'
QUELLEN = {'paar_abend': 110, 'selbst_reise': 100, 'einschlaf_reise': 119, 'traum_reise': 43}


def main():
    report = {'status': 'Alle 372 öffentlichen geführten Bausteine DE/EN gelesen; gezielte Korrekturen',
              'quellen': {}, 'bausteine': []}
    sections = []
    for name, count in QUELLEN.items():
        ids = None
        for lang, folder in [('de', 'assets/data'), ('en', 'translations/en')]:
            path = f'{folder}/{name}.json'
            before = json.loads(subprocess.check_output(['git', 'show', 'HEAD:' + path], cwd=ROOT))
            after = json.loads((ROOT / path).read_bytes())
            assert {k: v for k, v in before.items() if k not in ('bausteine', '_source')} == {
                k: v for k, v in after.items() if k not in ('bausteine', '_source')}
            old = {b['id']: b for b in before['bausteine']}
            assert len(after['bausteine']) == len(old) == count
            assert [b['id'] for b in before['bausteine']] == [b['id'] for b in after['bausteine']]
            if ids is None:
                ids = set(old)
            assert ids == set(old)
            for new in after['bausteine']:
                previous = old[new['id']]
                assert {k: v for k, v in previous.items() if k != 'text'} == {
                    k: v for k, v in new.items() if k != 'text'}, new['id']
                assert re.findall(r'\{[^{}]*\}', previous['text']) == re.findall(r'\{[^{}]*\}', new['text'])
                changed = previous['text'] != new['text']
                report['bausteine'].append({'quelle': name, 'sprache': lang, 'id': new['id'], 'geaendert': changed})
                if changed:
                    sections.append(f'<details><summary>{name} · {lang} · {new["id"]}</summary><div>'
                                    f'<pre>{html.escape(previous["text"])}</pre><pre>{html.escape(new["text"])}</pre>'
                                    '</div></details>')
            report['quellen'][path] = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
    header = ('<!doctype html><html lang="de"><meta charset="utf-8"><title>Geführte Texte · Lektorat</title>'
              '<style>body{font:16px/1.6 system-ui;background:#f6f0e6;color:#2a2a2c;margin:32px}'
              'div{display:grid;grid-template-columns:1fr 1fr;gap:24px}pre{white-space:pre-wrap;font:inherit;'
              'background:#fbf7f0;padding:20px}details{margin:16px 0}@media(max-width:800px){div{display:block}}'
              '</style><h1>Geführte Texte · Deutsch und Englisch</h1><p>372 Bausteine je Sprache gelesen. '
              'Hier stehen nur tatsächliche Änderungen. Links bisher, rechts lektoriert.</p>')
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'GEFUEHRTVERGLEICH.html').write_text(header + '\n'.join(sections) + '</html>', encoding='utf-8')
    (OUT / 'gefuehrt-lektorat-pruefung.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'744 Sprachfassungen geprüft, {sum(b["geaendert"] for b in report["bausteine"])} geändert; Metadaten/Marker erhalten.')


if __name__ == '__main__':
    main()
