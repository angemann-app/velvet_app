"""Gezielte DE/EN-Korrekturen geführter Texte, mit Metadatenprüfung und Sicherung."""
import argparse
import copy
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/gesamt'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--uebernehmen', action='store_true')
    args = parser.parse_args()
    changes = json.loads((ROOT / 'tools/redaktion_gefuehrt_korrekturen.json').read_text(encoding='utf-8'))
    prepared = []
    stamps = []
    prefixes = {'paar_abend': 'block', 'selbst_reise': 'self_block',
                'einschlaf_reise': 'sleep_block', 'traum_reise': 'dream_block'}
    for name, corrections in changes.items():
        stamps.extend(f'{prefixes[name]}:{key}' for key in corrections)
        for lang, folder, offset in [('de', 'assets/data', 0), ('en', 'translations/en', 2)]:
            path = ROOT / folder / f'{name}.json'
            original = path.read_bytes()
            data = json.loads(original)
            before = copy.deepcopy(data)
            blocks = {b['id']: b for b in data['bausteine']}
            assert set(corrections) <= set(blocks)
            for key, pairs in corrections.items():
                text = blocks[key]['text']
                markers = re.findall(r'\{[^{}]*\}', text)
                for pair in pairs:
                    old, new = pair[offset:offset + 2]
                    if text.count(old) == 1:
                        text = text.replace(old, new)
                    elif text.count(old) == 0 and text.count(new) == 1:
                        continue
                    else:
                        raise ValueError(f'{lang}/{name}/{key}: unklare Ausgangsstelle')
                blocks[key]['text'] = text
                assert re.findall(r'\{[^{}]*\}', text) == markers, 'Personalisierungsmarker verändert'
            check = copy.deepcopy(data)
            for old, new in zip(before['bausteine'], check['bausteine']):
                new['text'] = old['text']
            assert check == before, 'Metadaten verändert'
            prepared.append((path, original, data, name, lang))
    OUT.mkdir(parents=True, exist_ok=True)
    for path, original, data, name, lang in prepared:
        if args.uebernehmen:
            backup = OUT / f'{name}.{lang}.vor-lektorat.json'
            if not backup.exists():
                backup.write_bytes(original)
            path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    (OUT / 'stamps-gefuehrt.txt').write_text(','.join(stamps), encoding='utf-8')
    print(f'{len(stamps)} Bausteine DE/EN ' + ('übernommen.' if args.uebernehmen else 'geprüft.'))


if __name__ == '__main__':
    main()
