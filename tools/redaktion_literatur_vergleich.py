"""Lokaler Vorher/Nachher-Vergleich des literarischen Durchgangs, DE und EN."""
import html
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt/literatur'


def main():
    mapping=json.loads((ROOT/'tools/redaktion_literarisch_korrekturen.json').read_text(encoding='utf-8'))
    OUT.mkdir(parents=True,exist_ok=True)
    sections=[]
    for lang,path in [('de',ROOT/'assets/data/velvet_content.json'),('en',ROOT/'translations/en/velvet_content.json')]:
        data=json.loads(path.read_text(encoding='utf-8'))
        for course in data['courses']:
            for lesson in course['lessons']:
                key=lesson['id']
                if key not in mapping: continue
                after=lesson['content']; before=after
                offset=0 if lang=='de' else 2
                for pair in reversed(mapping[key]):
                    old,new=pair[offset:offset+2]
                    assert before.count(new)==1,(lang,key)
                    before=before.replace(new,old)
                # Vorhandene Aufgaben und explizite Dialogbeispiele wortgleich.
                from redaktion_spicy_entwuerfe import geschuetzte_absaetze
                if lesson.get('spicy') or course.get('spicy'):
                    assert geschuetzte_absaetze(before,lang)==geschuetzte_absaetze(after,lang)
                (OUT/f'{key}.{lang}.md').write_text(f"# {lesson['title']}\n\n{after}\n",encoding='utf-8')
                sections.append(f'<section><h2>{html.escape(key)} · {lang.upper()}</h2><div class="paar"><article><h3>Bisher</h3><pre>{html.escape(before)}</pre></article><article><h3>Literarischer Durchgang</h3><pre>{html.escape(after)}</pre></article></div></section>')
    header='<!doctype html><html lang="de"><meta charset="utf-8"><title>Literarischer Durchgang</title><style>body{font:17px/1.65 system-ui;background:#f6f0e6;color:#2a2a2c;margin:32px}.paar{display:grid;grid-template-columns:1fr 1fr;gap:24px}article{background:#fbf7f0;padding:24px}pre{font:inherit;white-space:pre-wrap}section{margin:48px 0}h1,h2,h3{font-family:Georgia,serif}@media(max-width:850px){.paar{grid-template-columns:1fr}}</style><h1>Literarischer Durchgang · DE/EN</h1>'
    (OUT/'VERGLEICH.html').write_text(header+'\n'.join(sections)+'</html>',encoding='utf-8')
    print(f'{len(sections)} Sprachfassungen exportiert; Spicy-Aufgaben und bestehende Dialogbeispiele unverändert.')


if __name__=='__main__':main()
