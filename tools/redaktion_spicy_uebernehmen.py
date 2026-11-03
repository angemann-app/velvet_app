"""Übernimmt ausschließlich die am 01.11.2026 freigegebenen 27 DE/EN-Entwürfe.

Standard: konfliktgeprüfte Vorschau. Mit --uebernehmen: Produktionsquellen ändern.
Vorherige Quellen, Prüfsummen und Übernahmebericht unter build/redaktion/gesamt/.
"""
import argparse
import hashlib
import json
from pathlib import Path

from redaktion_beruehrung_muster import KORREKTUREN

ROOT = Path(__file__).resolve().parents[1]


def vorbereiten():
    extra = json.loads((ROOT/'tools/redaktion_spicy_korrekturen.json').read_text(encoding='utf-8'))
    aufgaben = json.loads((ROOT/'tools/redaktion_spicy_aufgaben.json').read_text(encoding='utf-8'))['lektionen']
    ergebnis = []
    for lang, quelle in [('de', 'assets/data/velvet_content.json'), ('en', 'translations/en/velvet_content.json')]:
        datei = ROOT/quelle
        original = datei.read_bytes()
        daten = json.loads(original)
        mapping = dict(KORREKTUREN[lang])
        offset = 0 if lang == 'de' else 2
        for kennung, paare in extra.items():
            mapping[kennung] = [(p[offset], p[offset+1]) for p in paare]
        for kennung, paare in aufgaben.items():
            mapping[kennung] = mapping[kennung] + [(p[offset], p[offset+1]) for p in paare]
        gesehen = set()
        for kurs in daten['courses']:
            for lesson in kurs['lessons']:
                kennung = lesson['id']
                if kennung not in mapping:
                    continue
                gesehen.add(kennung)
                freigabe = json.loads((ROOT/f'build/redaktion/spicy/{kennung}.{lang}.json').read_text(encoding='utf-8'))
                ziel = freigabe['lesson']['content']
                assert freigabe['course'] == kurs['id'], kennung
                if lesson['content'] != ziel:
                    erwartet = lesson['content']
                    for alt, neu in mapping[kennung]:
                        if erwartet.count(alt) != 1:
                            raise ValueError(f'{lang}/{kennung}: Quelle geändert, Übernahme abgebrochen')
                        erwartet = erwartet.replace(alt, neu)
                    if erwartet != ziel:
                        raise ValueError(f'{lang}/{kennung}: Abweichung vom freigegebenen Entwurf')
                    lesson['content'] = ziel
        assert gesehen == set(mapping) and len(gesehen) == 27
        ergebnis.append((lang, datei, original, daten))
    return ergebnis


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--uebernehmen', action='store_true')
    args = p.parse_args()
    bestand = vorbereiten()  # Beide Sprachen vollständig prüfen, bevor etwas geschrieben wird.
    out = ROOT/'build/redaktion/gesamt'
    out.mkdir(parents=True, exist_ok=True)
    report = {'freigabe': 'Nutzer, 01.11.2026', 'status': 'uebernommen' if args.uebernehmen else 'geprueft', 'quellen': []}
    for lang, path, original, daten in bestand:
        report['quellen'].append({'sprache': lang, 'datei': path.relative_to(ROOT).as_posix(),
                                 'sha256_vorher': hashlib.sha256(original).hexdigest(), 'lektionen': 27})
        if args.uebernehmen:
            backup = out/f'velvet_content.{lang}.vor-uebernahme.json'
            if not backup.exists(): backup.write_bytes(original)
            path.write_text(json.dumps(daten, ensure_ascii=False, indent=2)+'\n', encoding='utf-8', newline='\n')
    (out/'spicy-uebernahme.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(f"54 freigegebene Sprachfassungen {report['status']}; aktuelle Metadaten erhalten.")


if __name__ == '__main__': main()
