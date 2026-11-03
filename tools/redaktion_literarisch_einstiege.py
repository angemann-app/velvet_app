"""Ergänzt den literarischen Durchgang um die übrigen 26 Spicy-Einstiege.

Erzeugt nachvollziehbare Alt/Neu-Stellen, ohne Produktionsdateien zu ändern.
Danach redaktion_gesamt_anwenden.py --literarisch --uebernehmen ausführen.
"""
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def main():
    targets=json.loads((ROOT/'tools/redaktion_literarisch_einstiege.json').read_text(encoding='utf-8'))
    path=ROOT/'tools/redaktion_literarisch_korrekturen.json'
    mapping=json.loads(path.read_text(encoding='utf-8'))
    sources={lang:{l['id']:l for c in json.loads((ROOT/file).read_text(encoding='utf-8'))['courses'] for l in c['lessons']}
             for lang,file in [('de','assets/data/velvet_content.json'),('en','translations/en/velvet_content.json')]}
    for key,target in targets.items():
        if key in mapping:
            assert any(p[1]==target['de'] and p[3]==target['en'] for p in mapping[key]),key
            continue
        pairs=[]
        for lang in ('de','en'):
            before=sources[lang][key]['content'].split('\n\n',1)[0]
            assert before!=target[lang],key
            pairs.extend((before,target[lang]))
        mapping[key]=[pairs]
    assert len(targets)==26
    path.write_text(json.dumps(mapping,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
    print('26 weitere DE/EN-Einstiege als einzelne Alt/Neu-Paare hinterlegt.')


if __name__=='__main__':main()
