"""Gezielte lokale Neuvertonung nach Spicy-Tondurchgang, ohne Paketübernahme.

IDs ausschließlich aus dem geprüften Änderungsauftrag. Ein exklusiver Lock,
quellgebundene Fortsetzung, vollständige Dekodierung, keine Veröffentlichung.
"""
import gc
import hashlib
import json
import os
from pathlib import Path
import time

os.environ['HF_HUB_OFFLINE'] = '1'
os.environ['TRANSFORMERS_OFFLINE'] = '1'

import generate_audio as de
import generate_audio_en as en
import redaktion_audio_gefuehrt as gefuehrt
import redaktion_audio_stapel as stapel
import reihe_ausdruck

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'build/redaktion/spicy-ton'
OUT = BASE / 'produktion'
OVERRIDES = {'prostata': 'pɾˈɔstata', 'herstellerangaben': 'hˈɛɾʃtɛlɐˌaŋɡaːbən'}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def tasks():
    wanted = set((BASE / 'neuvertonen.txt').read_text(encoding='utf-8').splitlines())
    result = []
    for t in stapel.auftraege('alle-lektionen'):
        if t['sprache'] + '/' + t['id'] in wanted:
            result.append(dict(t, art='lektion'))
    for lang, folder in [('de', 'assets/data'), ('en', 'translations/en')]:
        for source, target in gefuehrt.QUELLEN.items():
            slow = target in ('einschlaf', 'traum')
            data = json.loads((ROOT / folder / (source + '.json')).read_text(encoding='utf-8'))
            for b in data['bausteine']:
                for voice in ('victoria', 'martin'):
                    key = f'{target}/{voice}_{b["id"]}'
                    if f'{lang}/{key}' not in wanted:
                        continue
                    result.append({'sprache': lang, 'id': key, 'stimme': voice, 'text': b['text'],
                        'art': 'gefuehrt', 'langsam': slow,
                        'profil': 'bestand-langsam-1' if slow else 'bestand-gefuehrt-1'})
    assert {t['sprache'] + '/' + t['id'] for t in result} == wanted
    assert len(result) == len(wanted)
    return sorted(result, key=lambda t: (t['sprache'], t['art'], t['stimme'], t['id']))


def main():
    import msvcrt
    import soundfile as sf
    import numpy as np
    import torch
    import misaki.de
    torch.set_num_threads(4)
    OUT.mkdir(parents=True, exist_ok=True)
    with (stapel.OUT / 'produktion.lock').open('a+b') as lock:
        lock.seek(0); lock.write(b'0'); lock.flush(); lock.seek(0)
        msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
        jobs = tasks()
        stapel.schreiben(OUT / 'auftraege.json', jobs)
        manifest = OUT / 'manifest.json'
        state = json.loads(manifest.read_text(encoding='utf-8')) if manifest.exists() else {}
        code = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
            ('spicy_ton_produktion.py', 'generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py', 'redaktion_audio_gefuehrt.py')))
        lex = sha(de.LEXICON_JSON.read_bytes())
        engine = None
        language = None
        for i, t in enumerate(jobs, 1):
            key = t['sprache'] + '/' + t['id']
            fp = sha(json.dumps({'auftrag': t, 'code': code, 'lexikon': lex if t['sprache'] == 'de' else 'en',
                'lokale_overrides': OVERRIDES if t['sprache'] == 'de' else {},
                'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
            dest = OUT / t['sprache'] / 'audio' / (t['id'] + '.opus')
            if dest.exists() and state.get(key, {}).get('fingerprint') == fp and state[key].get('sha256') == sha(dest.read_bytes()):
                continue
            if language != t['sprache']:
                del engine; gc.collect()
                language = t['sprache']
                engine = de.Kokoro() if language == 'de' else en.Englisch()
                if language == 'de':
                    for word, phonemes in OVERRIDES.items():
                        misaki.de._OVERRIDES[misaki.de.normalize_for_lookup(word)] = phonemes
            dest.parent.mkdir(parents=True, exist_ok=True)
            wav = dest.with_suffix('.wav')
            part = dest.with_suffix('.part.opus')
            print(f'[{i}/{len(jobs)}] START {key}', flush=True)
            stapel.schreiben(OUT / 'status.json', {'status': 'läuft', 'aktuell': key, 'position': i, 'gesamt': len(jobs), 'fertig': len(state)})
            started = time.time()
            if t['art'] == 'gefuehrt':
                gefuehrt.sprechen(engine, t, wav, de, en)
            elif language == 'de':
                engine.synthesize_ausdruck(t['szene'], t['text'], t['stimme'], wav)
            else:
                engine.wav(t['text'], t['stimme'], wav, pause=f"ausdruck:{t['profil']}:{t['szene']}")
            de.to_opus(wav, part)
            data, rate = sf.read(part, dtype='float32')
            assert rate == 48000 and data.ndim == 1 and len(data) > 0
            assert np.isfinite(data).all() and np.max(np.abs(data)) > 0
            part.replace(dest)
            wav.unlink()
            state[key] = {'fingerprint': fp, 'sha256': sha(dest.read_bytes()), 'dauer_ms': round(len(data) * 1000 / rate),
                'text_sha256': sha(t['text'].encode()), 'stimme': t['stimme'], 'profil': t['profil'],
                'samplerate': rate, 'kanaele': 1, 'vollstaendig_dekodiert': True,
                'lokale_overrides': OVERRIDES if language == 'de' else {}, 'hoerabnahme': 'offen'}
            stapel.schreiben(manifest, state)
            prefix = language + '/' + (t['id'].rsplit('/', 1)[0] + '/' if '/' in t['id'] else '')
            durations = {k[len(prefix):]: v['dauer_ms'] for k, v in state.items()
                if k.startswith(prefix) and '/' not in k[len(prefix):]}
            stapel.schreiben(dest.parent / 'dauer.json', durations)
            print(f'[{i}/{len(jobs)}] FERTIG {key}: {len(data)/rate:.2f}s Audio / {time.time()-started:.1f}s Rechenzeit', flush=True)
        stapel.schreiben(OUT / 'status.json', {'status': 'vollständig technisch erzeugt und dekodiert',
            'fertig': len(state), 'gesamt': len(jobs), 'hoerabnahme': 'offen', 'paketuebernahme': False})
        print(f'FERTIG: {len(state)}/{len(jobs)}; Hörstichprobe offen; kein Upload.', flush=True)


if __name__ == '__main__':
    main()
