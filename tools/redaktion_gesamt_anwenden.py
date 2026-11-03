"""Wendet einzeln geprüfte DE/EN-Lektoratsstellen an; keine pauschalen Ersetzungen.

Standard nur prüfen, mit --uebernehmen schreiben. Fehlende Ausgangsstellen
stoppen den gesamten Vorgang, bevor eine Produktionsdatei geändert wird.
"""
import argparse
import difflib
import json
import re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt'


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--uebernehmen',action='store_true')
    p.add_argument('--literarisch',action='store_true',help='Gezielter literarischer zweiter Durchgang')
    p.add_argument('--stapel',help='Weitere geprüfte Korrekturdatei unter tools/')
    args=p.parse_args()
    quelle=args.stapel or ('redaktion_literarisch_korrekturen.json' if args.literarisch else 'redaktion_gesamt_korrekturen.json')
    assert Path(quelle).name==quelle and quelle.endswith('.json')
    changes=json.loads((ROOT/'tools'/quelle).read_text(encoding='utf-8'))
    prepared=[]
    for lang,path in [('de',ROOT/'assets/data/velvet_content.json'),('en',ROOT/'translations/en/velvet_content.json')]:
        original=path.read_bytes()
        data=json.loads(original)
        offset=0 if lang=='de' else 2
        seen=set()
        for c in data['courses']:
            for lesson in c['lessons']:
                if lesson['id'] not in changes: continue
                seen.add(lesson['id'])
                before=lesson['content']
                text=before
                for pair in changes[lesson['id']]:
                    old,new=pair[offset:offset+2]
                    if text.count(old)==1: text=text.replace(old,new)
                    elif text.count(old)==0 and text.count(new)==1: continue
                    else: raise ValueError(f'{lang}/{lesson["id"]}: Quelle unklar: {old[:60]}')
                assert re.findall(r'\{[^{}]*\}',before)==re.findall(r'\{[^{}]*\}',text)
                lesson['content']=text
        assert seen==set(changes)
        prepared.append((lang,path,original,data))
    OUT.mkdir(parents=True,exist_ok=True)
    for lang,path,original,data in prepared:
        if args.uebernehmen:
            stand=Path(quelle).stem if args.stapel else ('literatur' if args.literarisch else 'stapel1')
            backup=OUT/f'velvet_content.{lang}.vor-{stand}.json'
            if not backup.exists(): backup.write_bytes(original)
            path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
    # Nur die wirklich bearbeiteten und parallel übersetzten Lektionen stempeln.
    ids=set(changes)
    ids.update(json.loads((ROOT/'tools/redaktion_gesamt_korrekturen.json').read_text(encoding='utf-8')))
    for file in (ROOT/'tools').glob('redaktion_weiter_*.json'):
        ids.update(json.loads(file.read_text(encoding='utf-8')))
    manifest=json.loads((ROOT/'build/redaktion/spicy/manifest.json').read_text(encoding='utf-8'))
    ids.update(x['id'] for x in manifest['lektionen'])
    (OUT/'stamps.txt').write_text(','.join('lesson:'+x for x in sorted(ids)),encoding='utf-8')
    print(f'{len(changes)} weitere Lektionen DE/EN '+('übernommen.' if args.uebernehmen else 'geprüft.'))


if __name__=='__main__': main()
