"""Prüft und vertont drei Traumpraxis-Texte lokal, ohne Produktionspakete zu ändern.

--einschieben pausiert die bestehende Produktion zwischen Dateien, erzeugt die
zwölf Aufnahmen und setzt anschließend die geführten Audios fort.
"""
import argparse
import gc
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'docs/redaktion/traumpraxis/hoertexte.json'
OUT = ROOT / 'build/redaktion/traumpraxis'
PRODUCTION = ROOT / 'build/redaktion/gesamt/produktion'


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def schreiben(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    temporary.replace(path)


def vorbereiten():
    data = json.loads(SOURCE.read_text(encoding='utf-8'))
    assert data['spicy'] is True and data['mindestalter'] == 18
    assert data['stimmen'] == ['victoria', 'martin']
    assert [x['id'] for x in data['texte']] == ['praxis_abend', 'praxis_klarheit', 'praxis_morgen']
    tasks = []
    counts = []
    OUT.mkdir(parents=True, exist_ok=True)
    for lang in ('de', 'en'):
        review = ['# Traumpraxis · ' + lang.upper(), '',
                  'Produktionsfassung. Hörprüfung offen. Nur die Absätze unter Sprechtext werden gesprochen.', '']
        for entry in data['texte']:
            version = entry[lang]
            assert len(version['absaetze']) == 10
            assert all(isinstance(p, str) and p.strip() for p in version['absaetze'])
            text = '\n\n'.join(version['absaetze'])
            assert not any(c in text for c in '{}[]<>'), 'Unaufgelöste Marker'
            words = len(text.split())
            counts.append({'id': entry['id'], 'sprache': lang, 'woerter': words})
            review += ['## ' + version['titel'], '', '**ID:** ' + entry['id'], '',
                       '**Einsatz:** ' + entry['einsatz'], '', '### Sprechtext', '', text, '']
            for voice in data['stimmen']:
                tasks.append({'id': entry['id'], 'sprache': lang, 'stimme': voice,
                              'text': text, 'quelle': sha(SOURCE.read_bytes())})
        (OUT / f'HOERTEXTE.{lang}.md').write_text('\n'.join(review), encoding='utf-8')
    for entry in data['texte']:
        de = next(x['woerter'] for x in counts if x['id'] == entry['id'] and x['sprache'] == 'de')
        en = next(x['woerter'] for x in counts if x['id'] == entry['id'] and x['sprache'] == 'en')
        # Unterschiedliche Wortlängen sind kein Anlass zum künstlichen Kürzen.
        assert 0.65 < en / de < 1.5, 'Sprachfassungen auf Vollständigkeit prüfen'
    schreiben(OUT / 'textpruefung.json', {'quelle_sha256': sha(SOURCE.read_bytes()), 'texte': counts,
                                        'aufnahmen': len(tasks), 'hoerpruefung': 'offen'})
    print(json.dumps(counts, ensure_ascii=False), flush=True)
    return tasks


def produzieren(tasks, lock, pause=None, marker=None):
    import msvcrt
    import generate_audio as de
    import generate_audio_en as en
    import reihe_ausdruck

    approved = json.loads((ROOT / 'build/redaktion/gesamt/hoerproben/freigabe.json').read_text(encoding='utf-8'))
    assert approved['status'] == 'freigegeben' and approved['profil'] == reihe_ausdruck.LEKTIONS_PROFIL
    # Gemeinsame Sperre mit der laufenden Audioproduktion. Nur einen TTS-Prozess laden.
    while True:
        try:
            lock.seek(0)
            msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
            break
        except OSError:
            time.sleep(1)
    try:
        if pause is not None:
            assert pause.read_text(encoding='utf-8') == marker, 'Pausensignal wurde geändert'
            pause.unlink()
        os.environ['HF_HUB_OFFLINE'] = '1'
        os.environ['TRANSFORMERS_OFFLINE'] = '1'
        import numpy as np
        import soundfile as sf
        import torch
        torch.set_num_threads(4)
        manifest = OUT / 'manifest.json'
        state = json.loads(manifest.read_text(encoding='utf-8')) if manifest.exists() else {}
        code = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
                           ('generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py', 'traumpraxis_hoertexte.py')))
        lex = sha(de.LEXICON_JSON.read_bytes())
        engine = None
        language = None
        for i, task in enumerate(tasks, 1):
            key = f"{task['sprache']}/{task['stimme']}_{task['id']}"
            dest = OUT / 'audio' / (key + '.opus')
            fingerprint = sha(json.dumps({'auftrag': task, 'code': code,
                'lexikon': lex if task['sprache'] == 'de' else None,
                'profil': reihe_ausdruck.LEKTIONS_PROFIL, 'szene': 'wissen',
                'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
            previous = state.get(key, {})
            if dest.exists() and previous.get('fingerprint') == fingerprint and previous.get('sha256') == sha(dest.read_bytes()):
                continue
            schreiben(OUT / 'status.json', {'status': 'läuft', 'aufnahme': key, 'nummer': i, 'gesamt': len(tasks)})
            if language != task['sprache']:
                del engine
                gc.collect()
                language = task['sprache']
                engine = de.Kokoro() if language == 'de' else en.Englisch()
            dest.parent.mkdir(parents=True, exist_ok=True)
            wav = dest.with_suffix('.wav')
            part = dest.with_suffix('.part.opus')
            print(f'[{i}/{len(tasks)}] START {key}', flush=True)
            if language == 'de':
                engine.synthesize_ausdruck('wissen', task['text'], task['stimme'], wav)
            else:
                engine.wav(task['text'], task['stimme'], wav,
                           pause=f'ausdruck:{reihe_ausdruck.LEKTIONS_PROFIL}:wissen')
            audio, rate = sf.read(wav)
            assert rate == 24000 and audio.ndim == 1 and len(audio) > 0
            assert np.isfinite(audio).all() and np.max(np.abs(audio)) > 0.00001
            de.to_opus(wav, part)
            assert part.stat().st_size > 100
            part.replace(dest)
            state[key] = {'fingerprint': fingerprint, 'sha256': sha(dest.read_bytes()),
                'dauer_ms': round(len(audio) / rate * 1000), 'samplerate': rate,
                'peak': float(np.max(np.abs(audio))),
                'clipping_anteil': float(np.mean(np.abs(audio) >= 0.999)),
                'profil': reihe_ausdruck.LEKTIONS_PROFIL, 'status': 'technisch erzeugt; Hörprüfung offen'}
            schreiben(manifest, state)
            schreiben(dest.parent / 'dauer.json', {k.split('/', 1)[1]: v['dauer_ms'] for k, v in state.items() if k.startswith(language + '/')})
            wav.unlink()
            print(f"[{i}/{len(tasks)}] FERTIG {key}: {state[key]['dauer_ms']/1000:.1f} s", flush=True)
        schreiben(OUT / 'status.json', {'status': 'zwölf Aufnahmen technisch erzeugt', 'hoerpruefung': 'offen'})
    finally:
        lock.seek(0)
        msvcrt.locking(lock.fileno(), msvcrt.LK_UNLCK, 1)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--produzieren', action='store_true')
    parser.add_argument('--einschieben', action='store_true')
    args = parser.parse_args()
    tasks = vorbereiten()
    if not (args.produzieren or args.einschieben):
        return
    PRODUCTION.mkdir(parents=True, exist_ok=True)
    pause = PRODUCTION / 'pause.flag'
    marker = 'traumpraxis-' + str(os.getpid())
    if args.einschieben:
        # Fremde oder vom Nutzer gesetzte Pausen niemals aufheben.
        with pause.open('x', encoding='utf-8') as f:
            f.write(marker)
        schreiben(OUT / 'status.json', {'status': 'wartet auf Ende der laufenden Einzelaufnahme', 'gesamt': 12})
    try:
        with (PRODUCTION / 'produktion.lock').open('a+b') as lock:
            if lock.seek(0, 2) == 0:
                lock.write(b'0')
                lock.flush()
            produzieren(tasks, lock, pause if args.einschieben else None, marker)
    finally:
        gc.collect()
        if args.einschieben:
            if pause.exists() and pause.read_text(encoding='utf-8') == marker:
                pause.unlink()
            if not pause.exists():
                print('Bestehende geführte Produktion wird fortgesetzt.', flush=True)
                result = subprocess.run([sys.executable, str(ROOT / 'tools/redaktion_audio_stapel.py'), '--gruppe', 'gefuehrt'], cwd=ROOT)
                print(f'Geführter Folgelauf beendet: {result.returncode}', flush=True)


if __name__ == '__main__':
    main()
