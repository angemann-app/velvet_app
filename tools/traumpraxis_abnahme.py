"""Erstellt lokale Hörabnahme-Seite und prüft vorhandene Opus-Dateien mit ffprobe.

Ohne --zwischenstand müssen alle zwölf Dateien vollständig vorliegen.
Keine Veröffentlichung und keine automatische Hörabnahme.
"""
import argparse
import hashlib
import html
import json
from pathlib import Path
import subprocess

import generate_audio as de
import reihe_ausdruck
import traumpraxis_hoertexte as producer

ROOT = Path(__file__).resolve().parents[1]
OUT = producer.OUT


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--zwischenstand', action='store_true')
    args = parser.parse_args()
    tasks = producer.vorbereiten()
    path = OUT / 'manifest.json'
    state = json.loads(path.read_text(encoding='utf-8')) if path.exists() else {}
    code = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
                       ('generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py', 'traumpraxis_hoertexte.py')))
    lex = sha(de.LEXICON_JSON.read_bytes())
    results = []
    cards = []
    for task in tasks:
        key = f"{task['sprache']}/{task['stimme']}_{task['id']}"
        file = OUT / 'audio' / (key + '.opus')
        entry = state.get(key)
        ready = file.exists() and entry is not None
        if ready:
            fingerprint = sha(json.dumps({'auftrag': task, 'code': code,
                'lexikon': lex if task['sprache'] == 'de' else None,
                'profil': reihe_ausdruck.LEKTIONS_PROFIL, 'szene': 'wissen',
                'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
            assert entry['fingerprint'] == fingerprint, f'Veraltete Quelle: {key}'
            assert entry['sha256'] == sha(file.read_bytes()), f'Prüfsumme: {key}'
            info = json.loads(subprocess.check_output(['ffprobe', '-v', 'error', '-show_entries',
                'format=duration:stream=codec_name,sample_rate,channels', '-of', 'json', str(file)]))
            stream = info['streams'][0]
            duration = float(info['format']['duration'])
            assert stream['codec_name'] == 'opus' and stream['channels'] == 1
            assert int(stream['sample_rate']) == 48000 and duration > 0
            assert abs(duration - entry['dauer_ms'] / 1000) < 0.25, key
            results.append({'id': key, 'status': 'technisch geprüft, Hörprüfung offen',
                            'dauer_sekunden': duration, 'opus_samplerate': 48000,
                            'sha256': entry['sha256'], 'clipping_anteil_wav': entry['clipping_anteil']})
            player = f'<audio controls preload="none" src="audio/{key}.opus"></audio><p>{duration:.1f} Sekunden · Hörprüfung offen</p>'
        else:
            results.append({'id': key, 'status': 'noch nicht erzeugt'})
            player = '<p>Aufnahme steht noch aus.</p>'
        cards.append(f'<article><h2>{html.escape(key)}</h2>{player}<details><summary>Sprechtext</summary>'
                     f'<div class="text">{html.escape(task["text"])}</div></details></article>')
    ready_count = sum('dauer_sekunden' in r for r in results)
    OUT.mkdir(parents=True, exist_ok=True)
    producer.schreiben(OUT / 'technische-pruefung.json', {'fertig': ready_count, 'gesamt': 12,
                        'quelle_sha256': sha(producer.SOURCE.read_bytes()), 'aufnahmen': results,
                        'hoerabnahme': 'offen, durch AG unter Koordination von Claude Code'})
    header = ('<!doctype html><html lang="de"><meta charset="utf-8"><title>Traumpraxis · Hörabnahme</title>'
              '<style>body{font:16px/1.6 system-ui;background:#f6f0e6;color:#2a2a2c;max-width:1000px;margin:32px auto;padding:20px}'
              'h1,h2{font-family:Georgia,serif}h2{font-size:20px;overflow-wrap:anywhere}article{background:#fbf7f0;padding:24px;'
              'margin:20px 0;border:1px solid #b7aba3}.text{white-space:pre-wrap;margin-top:16px}audio{width:100%}'
              '</style><h1>Traumpraxis · zwölf Aufnahmen</h1>'
              f'<p>{ready_count} von zwölf technisch geprüft. Keine Aufnahme gilt damit als durchgehört oder abgenommen.</p>'
              '<p>Prüfen: Aussprache, angenehmes Tempo, Satzenden, Natürlichkeit der Pausen, keine Klicks oder Abbrüche. '
              'Klarheit ist eine wache Vorstellungsübung, keine nächtliche Wiedergabe. Zeitstempel und Dateiname zu jedem Befund notieren.</p>')
    (OUT / 'ABNAHME.html').write_text(header + '\n'.join(cards) + '</html>', encoding='utf-8')
    print(f'{ready_count}/12 Aufnahmen technisch geprüft; Hörabnahme offen.', flush=True)
    if not args.zwischenstand and ready_count != 12:
        raise SystemExit('Noch nicht alle Aufnahmen fertig. Für eine vorläufige Ansicht --zwischenstand verwenden.')


if __name__ == '__main__':
    main()
