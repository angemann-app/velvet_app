"""Prüft Lektoratsumfang, Metadaten, Marker und geschützte Spicy-Absätze.

Schreibt Prüfbericht und vollständigen Vorher/Nachher-Vergleich nach build/.
Keine TTS-Modelle, kein Netzwerk und keine Änderungen an Produktionsquellen.
"""
import hashlib
import html
import json
import re
import subprocess
from pathlib import Path

from redaktion_spicy_entwuerfe import geschuetzte_absaetze

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt'


def main():
    ids=set(json.loads((ROOT/'tools/redaktion_gesamt_korrekturen.json').read_text(encoding='utf-8')))
    for p in (ROOT/'tools').glob('redaktion_weiter_*.json'):
        ids.update(json.loads(p.read_text(encoding='utf-8')))
    ids.update(x['id'] for x in json.loads((ROOT/'build/redaktion/spicy/manifest.json').read_text(encoding='utf-8'))['lektionen'])
    report={'lektionen':[],'quellen':{},'status':'Kurslektorat vollständig; geführte Texte separat'}
    sections=[]
    for lang,path in [('de','assets/data/velvet_content.json'),('en','translations/en/velvet_content.json')]:
        before=json.loads(subprocess.check_output(['git','show','HEAD:'+path],cwd=ROOT))
        after=json.loads((ROOT/path).read_text(encoding='utf-8'))
        spicy=json.loads((OUT/f'velvet_content.{lang}.vor-literatur.json').read_text(encoding='utf-8'))
        protected={l['id']:l for c in spicy['courses'] for l in c['lessons'] if c.get('spicy') or l.get('spicy')}
        seen=set()
        assert len(before['courses'])==len(after['courses'])==27
        for a,b in zip(before['courses'],after['courses']):
            assert {k:v for k,v in a.items() if k!='lessons'}=={k:v for k,v in b.items() if k!='lessons'}
            assert len(a['lessons'])==len(b['lessons'])
            for old,new in zip(a['lessons'],b['lessons']):
                key=old['id']; seen.add(key)
                assert {k:v for k,v in old.items() if k!='content'}=={k:v for k,v in new.items() if k!='content'},key
                assert re.findall(r'\{[^{}]*\}',old['content'])==re.findall(r'\{[^{}]*\}',new['content']),key
                assert old['content']!=new['content'],(lang,key,'Keine Änderung trotz Lektoratsliste')
                if key in protected:
                    assert geschuetzte_absaetze(protected[key]['content'],lang)==geschuetzte_absaetze(new['content'],lang),key
                report['lektionen'].append({'sprache':lang,'id':key,'vorher':len(old['content']),'nachher':len(new['content'])})
                sections.append(f'<details><summary>{html.escape(key)} · {lang.upper()} · {html.escape(new["title"])}</summary><div class="paar"><article><h3>Bisher</h3><pre>{html.escape(old["content"])}</pre></article><article><h3>Lektorat</h3><pre>{html.escape(new["content"])}</pre></article></div></details>')
        assert seen==ids and len(seen)==128
        report['quellen'][path]=hashlib.sha256((ROOT/path).read_bytes()).hexdigest()
    header='<!doctype html><html lang="de"><meta charset="utf-8"><title>Gesamtlektorat · Kursvergleich</title><style>body{font:16px/1.65 system-ui;background:#f6f0e6;color:#2a2a2c;margin:32px}.paar{display:grid;grid-template-columns:1fr 1fr;gap:24px}article{background:#fbf7f0;padding:24px}pre{font:inherit;white-space:pre-wrap}details{margin:16px 0}summary{cursor:pointer}h1,h3{font-family:Georgia,serif}@media(max-width:850px){.paar{grid-template-columns:1fr}}</style><h1>128 Kurslektionen · Deutsch und Englisch</h1><p>Vergleich zum Git-Ausgangsstand. Geführte Bausteine und Audioabnahme sind separate Arbeitspakete.</p>'
    (OUT/'KURSVERGLEICH.html').write_text(header+'\n'.join(sections)+'</html>',encoding='utf-8')
    (OUT/'kurslektorat-pruefung.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print('256 Sprachfassungen geprüft: 128/128 IDs je Sprache, Metadaten und Marker erhalten, Spicy-Dialoge/Aufgaben erhalten.')


if __name__=='__main__':main()
