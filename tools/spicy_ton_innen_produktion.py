"""Lokale Neuvertonung der vier überarbeiteten Sehr-spicy-Fassungen.

Private Texte bleiben ausschließlich in ignorierten lokalen Build-Ausgaben.
Kein Zugriff auf andere private Reihen, keine produktiven Pakete überschreiben.
"""
import gc
import hashlib
import json
import os
from pathlib import Path

os.environ['HF_HUB_OFFLINE'] = '1'
os.environ['TRANSFORMERS_OFFLINE'] = '1'
import generate_audio as de
import generate_audio_en as en
import redaktion_audio_stapel as stapel
import reihe_ausdruck

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'build/redaktion/spicy-ton/innenansichten'
OUT = BASE / 'produktion'
SCENES = ['opening', 'own_body', 'other_door', 'other_body', 'return', 'afterglow']
VOICES = {'sehrspicy_mann': 'martin', 'sehrspicy_frau': 'victoria'}
OVERRIDES = {'prostata': 'pɾˈɔstata', 'herstellerangaben': 'hˈɛɾʃtɛlɐˌaŋɡaːbən'}


def sha(b):
    return hashlib.sha256(b).hexdigest()


def main():
    import msvcrt
    import torch
    import misaki.de
    import soundfile as sf
    import numpy as np
    torch.set_num_threads(4)
    jobs = []
    for lang in ('de', 'en'):
        for ident, voice in VOICES.items():
            data = json.loads((BASE / f'{ident}.{lang}.json').read_text(encoding='utf-8'))
            assert data['id'] == ident and data['variante'] == 'sehrspicy' and data['stimme'] == voice
            assert [s['szene'] for s in data['segmente']] == SCENES
            for s in data['segmente']:
                jobs.append({'sprache': lang, 'id': ident, 'stimme': voice, 'szene': s['szene'], 'text': s['text']})
    assert len(jobs) == 24
    OUT.mkdir(parents=True, exist_ok=True)
    with (stapel.OUT / 'produktion.lock').open('a+b') as lock:
        lock.seek(0); lock.write(b'0'); lock.flush(); lock.seek(0)
        msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
        manifest = OUT / 'manifest.json'
        state = json.loads(manifest.read_text(encoding='utf-8')) if manifest.exists() else {}
        code = sha(b''.join((ROOT / 'tools' / name).read_bytes() for name in
            ('spicy_ton_innen_produktion.py', 'generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py')))
        lex = sha(de.LEXICON_JSON.read_bytes())
        engine = None
        language = None
        for i, t in enumerate(jobs, 1):
            filename = f"{t['stimme']}_der_andere_koerper_{t['id']}_{t['szene']}"
            key = t['sprache'] + '/' + filename
            fp = sha(json.dumps({'auftrag': t, 'code': code, 'lexikon': lex if t['sprache'] == 'de' else 'en',
                'lokale_overrides': OVERRIDES if t['sprache'] == 'de' else {}, 'profil': reihe_ausdruck.PROFIL,
                'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
            dest = OUT / t['sprache'] / (filename + '.opus')
            if dest.exists() and state.get(key, {}).get('fingerprint') == fp and state[key].get('sha256') == sha(dest.read_bytes()):
                continue
            if language != t['sprache']:
                del engine; gc.collect()
                language = t['sprache']
                engine = de.Kokoro() if language == 'de' else en.Englisch()
                if language == 'de':
                    for word, ps in OVERRIDES.items():
                        misaki.de._OVERRIDES[misaki.de.normalize_for_lookup(word)] = ps
            dest.parent.mkdir(parents=True, exist_ok=True)
            wav = dest.with_suffix('.wav')
            part = dest.with_suffix('.part.opus')
            stapel.schreiben(OUT / 'status.json', {'status': 'läuft', 'aktuell': key, 'position': i, 'gesamt': 24, 'fertig': len(state)})
            print(f'[{i}/24] START {key}', flush=True)
            if language == 'de':
                engine.synthesize_ausdruck(t['szene'], t['text'], t['stimme'], wav)
            else:
                engine.wav(t['text'], t['stimme'], wav, pause=f"ausdruck:{reihe_ausdruck.PROFIL}:{t['szene']}")
            de.to_opus(wav, part)
            samples, rate = sf.read(part, dtype='float32')
            assert rate == 48000 and samples.ndim == 1 and len(samples) > 0
            assert np.isfinite(samples).all() and np.max(np.abs(samples)) > 0
            part.replace(dest)
            wav.unlink()
            state[key] = {'fingerprint': fp, 'sha256': sha(dest.read_bytes()), 'dauer_ms': round(len(samples)*1000/rate),
                'text_sha256': sha(t['text'].encode()), 'stimme': t['stimme'], 'szene': t['szene'], 'profil': reihe_ausdruck.PROFIL,
                'vollstaendig_dekodiert': True, 'samplerate': rate, 'kanaele': 1, 'hoerabnahme': 'offen'}
            stapel.schreiben(manifest, state)
            prefix = language + '/'
            stapel.schreiben(dest.parent / 'dauer.json', {k[len(prefix):]: v['dauer_ms'] for k, v in state.items() if k.startswith(prefix)})
            print(f'[{i}/24] FERTIG {key}: {len(samples)/rate:.2f}s', flush=True)
        stapel.schreiben(OUT / 'status.json', {'status': 'vollständig technisch erzeugt und dekodiert', 'fertig': len(state),
            'gesamt': 24, 'hoerabnahme': 'offen', 'paketuebernahme': False})
        print('FERTIG: 24/24; Hörstichprobe offen; kein Upload.', flush=True)


if __name__ == '__main__':
    main()
