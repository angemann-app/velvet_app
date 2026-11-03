"""Prüft die gezielte Aufnahmeproduktion und schreibt Claudes lokale Übergabe.

Keine Synthese, kein Kopieren in produktive Pakete, keine Veröffentlichung.
Private Textstände bleiben im ignorierten Build-Verzeichnis.
"""
import hashlib
import html
import json
from pathlib import Path

import numpy as np
import soundfile as sf
import spicy_ton_produktion as public

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'build/redaktion/spicy-ton'


def sha(b):
    return hashlib.sha256(b).hexdigest()


def check(path, row, text):
    assert sha(path.read_bytes()) == row['sha256'], str(path)
    assert sha(text.encode()) == row['text_sha256'], 'Textstand hat sich nach Synthese geändert'
    with sf.SoundFile(path) as f:
        assert (f.format, f.subtype, f.samplerate, f.channels) == ('OGG', 'OPUS', 48000, 1)
        total = f.frames
        frames = 0
        peak = 0.0
        while True:
            block = f.read(65536, dtype='float32')
            if len(block) == 0:
                break
            assert np.isfinite(block).all()
            frames += len(block)
            peak = max(peak, float(np.abs(block).max()))
        assert frames == total and frames > 0 and peak > 0
        assert abs(round(frames * 1000 / f.samplerate) - row['dauer_ms']) <= 1


def main():
    jobs = public.tasks()
    manifest = json.loads((public.OUT / 'manifest.json').read_text(encoding='utf-8'))
    assert len(manifest) == len(jobs) == 150
    entries = []
    for t in jobs:
        key = t['sprache'] + '/' + t['id']
        row = manifest[key]
        path = public.OUT / t['sprache'] / 'audio' / (t['id'] + '.opus')
        check(path, row, t['text'])
        group = 'lektionen' if t['art'] == 'lektion' else 'gefuehrt'
        entries.append({'id': key, 'quelle': str(path.resolve()), 'paket': f"{t['sprache']}-{group}",
            'ziel': t['id'] + '.opus', 'dauer_ms': row['dauer_ms'], 'sha256': row['sha256'],
            'profil': row['profil'], 'stimme': row['stimme'], 'hoerabnahme': 'offen'})
    private = BASE / 'innenansichten'
    priv_manifest = json.loads((private / 'produktion/manifest.json').read_text(encoding='utf-8'))
    assert len(priv_manifest) == 24
    for lang in ('de', 'en'):
        for ident in ('sehrspicy_mann', 'sehrspicy_frau'):
            data = json.loads((private / f'{ident}.{lang}.json').read_text(encoding='utf-8'))
            for s in data['segmente']:
                name = f"{data['stimme']}_der_andere_koerper_{ident}_{s['szene']}"
                key = lang + '/' + name
                row = priv_manifest[key]
                path = private / 'produktion' / lang / (name + '.opus')
                check(path, row, s['text'])
                entries.append({'id': key, 'quelle': str(path.resolve()), 'paket': lang + '-reihe',
                    'ziel': name + '.opus', 'dauer_ms': row['dauer_ms'], 'sha256': row['sha256'],
                    'profil': row['profil'], 'stimme': row['stimme'], 'hoerabnahme': 'offen'})
    # Private Originalquelle darf während der Vorbereitung nicht still verändert werden.
    source = json.loads((private / 'quellnachweis.json').read_text(encoding='utf-8'))
    original_unchanged = sha(Path(source['source']).read_bytes()) == source['source_sha256']
    assert original_unchanged, 'Private Quelle inzwischen geändert: gezielter Merge nötig'
    assert len(entries) == 174
    (BASE / 'UEBERGABE_AUDIO.json').write_text(json.dumps({'status': '174 Dateien technisch geprüft; Hörabnahme offen',
        'neuaufnahmen': entries, 'private_textquelle': str((private / 'reihe.entwurf.json').resolve()),
        'private_originalquelle_unveraendert': original_unchanged, 'paketuebernahme': False,
        'hinweis': 'Vorhandene Paketbestände gezielt ergänzen/ersetzen, niemals nur diese Teilbestände packen. AG-26 prost_3 separat erhalten.'},
        ensure_ascii=False, indent=2), encoding='utf-8')
    chosen = []
    for lang in ('de', 'en'):
        for voice in ('martin', 'victoria', 'both'):
            subset = [e for e in entries if e['id'].startswith(lang + '/') and e['stimme'] == voice and e['paket'].endswith('-lektionen')]
            if subset:
                chosen.append(subset[0])
        for family in ('paar', 'selbst', 'einschlaf', 'traum'):
            chosen.append(next(e for e in entries if e['id'].startswith(lang + '/' + family + '/')))
        for voice in ('martin', 'victoria'):
            chosen.append(next(e for e in entries if e['paket'] == lang + '-reihe' and e['stimme'] == voice and e['id'].endswith('_other_body')))
    cards = ['<!doctype html><html lang="de"><meta charset="utf-8"><title>Neue Spicy-Hörproben</title>',
        '<style>body{background:#f6f0e6;color:#2a2a2c;font:17px system-ui;max-width:950px;margin:40px auto}article{border-top:1px solid #c7b8b0;padding:18px 0}audio{width:100%}</style>',
        '<h1>Neue Spicy-Hörproben · Abnahme offen</h1><p>Direkte Tonalität, Aussprache, Rhythmus und Satzenden prüfen. Technische Prüfung ist keine Hörabnahme.</p>']
    for e in chosen:
        cards.append('<article><h2>' + html.escape(e['id']) + '</h2><p>' + html.escape(e['stimme']) +
            '</p><audio controls preload="none" src="' + Path(e['quelle']).as_uri() + '"></audio></article>')
    (BASE / 'HOERPROBEN.html').write_text('\n'.join(cards) + '</html>', encoding='utf-8')
    (BASE / 'abschluss.json').write_text(json.dumps({'status': 'technisch vollständig geprüft', 'dateien': 174,
        'audio_stunden': round(sum(e['dauer_ms'] for e in entries) / 3600000, 3),
        'hoerabnahme': 'offen', 'paketuebernahme': False, 'veroeffentlichung': False},
        ensure_ascii=False, indent=2), encoding='utf-8')
    print('ABSCHLUSS: 174/174 dekodiert und text-/hashgeprüft; Übergabe und Hörproben bereit. Kein Upload.', flush=True)


if __name__ == '__main__':
    main()
