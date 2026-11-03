"""Lokale AG-26-Korrekturfassung, ohne Originale oder globales Lexikon zu ändern."""
import hashlib
import json
import os
from pathlib import Path

os.environ['HF_HUB_OFFLINE'] = '1'
os.environ['TRANSFORMERS_OFFLINE'] = '1'

import generate_audio as de
import redaktion_audio_stapel as stapel

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/gesamt/korrektur-ag26/final-runde3'
LAUTSCHRIFT = {
    'prostata': 'pɾˈɔs.tata',
    'herstellerangaben': 'hˈɛɾʃtɛlɐˌaŋɡaːbən',
}


def main():
    import msvcrt
    import numpy as np
    import soundfile as sf
    import torch
    import misaki.de

    torch.set_num_threads(4)
    OUT.mkdir(parents=True, exist_ok=True)
    original = stapel.OUT / 'de/audio/prost_3.opus'
    vorher = hashlib.sha256(original.read_bytes()).hexdigest()
    with (stapel.OUT / 'produktion.lock').open('a+b') as lock:
        lock.seek(0)
        lock.write(b'0')
        lock.flush()
        lock.seek(0)
        msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
        task = next(t for t in stapel.auftraege('alle-lektionen')
                    if t['sprache'] == 'de' and t['id'] == 'prost_3')
        engine = de.Kokoro()
        alt = {w: engine.phonemes(w) for w in LAUTSCHRIFT}
        for wort, laut in LAUTSCHRIFT.items():
            misaki.de._OVERRIDES[misaki.de.normalize_for_lookup(wort)] = laut
        neu = {w: engine.phonemes(w) for w in LAUTSCHRIFT}
        for wort, laut in LAUTSCHRIFT.items():
            assert neu[wort] == laut, (wort, neu[wort])
        wav = OUT / 'prost_3_korrektur.wav'
        print('START de/prost_3: getrennte Korrekturfassung', flush=True)
        engine.synthesize_ausdruck(task['szene'], task['text'], task['stimme'], wav)
        dest = OUT / 'prost_3_korrektur.opus'
        de.to_opus(wav, dest)
        data, rate = sf.read(dest, dtype='float32')
        assert rate == 48000 and data.ndim == 1
        assert len(data) > rate and np.isfinite(data).all() and np.max(np.abs(data)) > 0
        # Alte gemeldete Stellen zum unmittelbaren Vergleich bereitstellen.
        old, old_rate = sf.read(original, dtype='float32')
        for titel, start, ende in [('prostata', 96, 112), ('herstellerangaben', 150, 166)]:
            sf.write(OUT / f'vorher_{titel}.wav', old[int(start*old_rate):int(ende*old_rate)], old_rate)
        # Dieselben bestehenden Sätze separat mit dem korrigierten Profil sprechen.
        import reihe_ausdruck
        saetze = [s for s, _, _ in reihe_ausdruck.plan(task['szene'], task['text'], de.VOICE_SPEED['martin'])
                  if any(w in s.lower() for w in LAUTSCHRIFT)]
        engine.synthesize_ausdruck(task['szene'], '\n'.join(saetze), 'martin', OUT / 'nachher_aussprache.wav')
        assert hashlib.sha256(original.read_bytes()).hexdigest() == vorher
        bericht = {'id': 'de/prost_3', 'status': 'technisch geprüft; Gegenhören offen',
                   'original_sha256': vorher, 'korrektur_sha256': hashlib.sha256(dest.read_bytes()).hexdigest(),
                   'dauer_sekunden': len(data)/rate, 'laut_vorher': alt, 'laut_nachher': neu,
                   'profil': task['profil'], 'text_sha256': hashlib.sha256(task['text'].encode()).hexdigest(),
                   'quelle': task, 'globale_aenderungen': False,
                   'hinweis': 'Lokale Aussprachevariante, keine eigene akustische Abnahme. Keine Paketübernahme.'}
        (OUT / 'bericht.json').write_text(json.dumps(bericht, ensure_ascii=False, indent=2), encoding='utf-8')
        print(f'FERTIG: {len(data)/rate:.1f} Sekunden; Original unverändert; Gegenhören offen.', flush=True)


if __name__ == '__main__':
    main()
