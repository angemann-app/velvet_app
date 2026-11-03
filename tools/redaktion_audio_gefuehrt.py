"""Aufträge und bestehende Sprechregeln geführter Texte; keine neuen Ausdrucksprofile."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUELLEN = {'paar_abend': 'paar', 'selbst_reise': 'selbst', 'einschlaf_reise': 'einschlaf', 'traum_reise': 'traum'}


def auftraege():
    report = json.loads((ROOT / 'build/redaktion/gesamt/gefuehrt-lektorat-pruefung.json').read_text(encoding='utf-8'))
    result = []
    for lang, folder in [('de', 'assets/data'), ('en', 'translations/en')]:
        for source, target in QUELLEN.items():
            path = f'{folder}/{source}.json'
            raw = (ROOT / path).read_bytes()
            assert report['quellen'][path] == hashlib.sha256(raw).hexdigest(), f'Erneute Textprüfung nötig: {path}'
            slow = target in ('einschlaf', 'traum')
            for block in json.loads(raw)['bausteine']:
                for voice in ('victoria', 'martin'):
                    result.append({'sprache': lang, 'id': f'{target}/{voice}_{block["id"]}',
                                   'text': block['text'], 'stimme': voice,
                                   'profil': 'bestand-langsam-1' if slow else 'bestand-gefuehrt-1',
                                   'langsam': slow})
    assert len(result) == 1488
    return result


def sprechen(engine, task, wav, de, en):
    if task['sprache'] == 'en':
        engine.wav(task['text'], task['stimme'], wav, pause=en.LANGSAM if task['langsam'] else False)
        return
    previous = de.SPEED, de.VOICE_SPEED, de.PARAGRAPH_PAUSE_S
    try:
        if task['langsam']:
            de.SPEED, de.VOICE_SPEED, de.PARAGRAPH_PAUSE_S = 0.75, {'martin': 0.7}, 1.5
        engine.synthesize_wav(task['text'], task['stimme'], wav, pause=task['langsam'])
    finally:
        de.SPEED, de.VOICE_SPEED, de.PARAGRAPH_PAUSE_S = previous
