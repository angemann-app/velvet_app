"""Inventar und lokale Hörproben zum Gesamtlektorat; keine Produktionsaudios ändern."""
import argparse
import gc
import hashlib
import json
import os
from pathlib import Path

import generate_audio as de
import generate_audio_en as en
import reihe_ausdruck as ausdruck

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt'
QUELLEN=('velvet_content.json','paar_abend.json','selbst_reise.json','einschlaf_reise.json','traum_reise.json','anleitung.json','foto_ideen.json')


def inventar():
    records=[]
    for lang,dir in [('de',ROOT/'assets/data'),('en',ROOT/'translations/en')]:
        for name in QUELLEN:
            path=dir/name
            if not path.exists(): continue
            data=json.loads(path.read_text(encoding='utf-8'))
            records.append({'sprache':lang,'datei':path.relative_to(ROOT).as_posix(),
                            'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
                            'lektionen':sum(len(c['lessons']) for c in data.get('courses',[])),
                            'bausteine':len(data.get('bausteine',[])),
                            'status':'Inventar; kein vollständiges Lektorat behauptet'})
    lex=de.LEXICON_JSON.read_bytes()
    result={'quellen':records,'aussprache_sha256':hashlib.sha256(lex).hexdigest(),
            'profil':ausdruck.LEKTIONS_PROFIL,'textfreigabe_spicy':'Nutzer 01.11.2026',
            'hoerprobe':'ausstehend','gesamtlektorat':'in Arbeit'}
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'inventar.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(f'{len(records)} Inhaltsdateien inventarisiert; Aussprachelexikon und Profil protokolliert.',flush=True)


def hoerproben():
    # Bestehender, nicht expliziter Wissensabschnitt; weder neue Szene noch neuer Inhalt.
    # Zwei lange Absätze sichern den bestehenden Sprecherwechsel.
    os.environ['HF_HUB_OFFLINE']='1'
    os.environ['TRANSFORMERS_OFFLINE']='1'
    import torch
    torch.set_num_threads(4)
    target=OUT/'hoerproben'
    target.mkdir(parents=True,exist_ok=True)
    for lang,source in [('de',ROOT/'assets/data/velvet_content.json'),('en',ROOT/'translations/en/velvet_content.json')]:
        lesson=json.loads(source.read_text(encoding='utf-8'))['courses'][0]['lessons'][0]
        paragraphs=[p for p in lesson['content'].split('\n\n') if p.strip()]
        # Der zweite Block ist lang; davon nur die erste Erklärungszeile übernehmen.
        first=paragraphs[0]
        second=next(line for p in paragraphs[1:] for line in p.splitlines() if len(line)>100)
        text=first+'\n\n'+second
        engine=de.Kokoro() if lang=='de' else en.Englisch()
        wav=target/f'{lang}_wissen_beide.wav'
        if lang=='de': engine.synthesize_ausdruck('wissen',text,de.BOTH,wav)
        else: engine.wav(text,de.BOTH,wav,pause=f'ausdruck:{ausdruck.LEKTIONS_PROFIL}:wissen')
        de.to_opus(wav,wav.with_suffix('.opus'))
        print(f'Hörprobe fertig: {wav}',flush=True)
        if lang=='de':
            words='Gaspedal. Bremspedal. Prostata. Klitoris. Beckenboden. Oxytocin. Sensate Focus. Gleitgel.'
            for voice in de.KOKORO_VOICES:
                wp=target/f'de_aussprache_{voice}.wav'
                engine.synthesize_ausdruck('wissen',words,voice,wp)
                de.to_opus(wp,wp.with_suffix('.opus'))
                print(f'Ausspracheprobe fertig: {wp}',flush=True)
        del engine
        gc.collect()
        (target/f'{lang}_wissen_beide.txt').write_text(text+'\n',encoding='utf-8')
    (target/'profil.json').write_text(json.dumps({'profil':ausdruck.LEKTIONS_PROFIL,
        'aussprache_sha256':hashlib.sha256(de.LEXICON_JSON.read_bytes()).hexdigest(),
        'status':'Nur Hörprobe, keine Freigabe des Sprechprofils'},ensure_ascii=False,indent=2),encoding='utf-8')


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--hoerproben',action='store_true')
    a=p.parse_args(); inventar()
    if a.hoerproben: hoerproben()
