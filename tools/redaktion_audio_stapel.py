"""Fortsetzbare lokale Neuvertonung freigegebener Lektionen, getrennt von Paketen.

C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/redaktion_audio_stapel.py --gruppe spicy
Ausgabe nur unter build/redaktion/gesamt/produktion; keine Uploads.
"""
import argparse
import gc
import hashlib
import json
import os
from pathlib import Path
import time

import generate_audio as de
import generate_audio_en as en
import reihe_ausdruck
import redaktion_audio_gefuehrt

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt/produktion'


def sha(data): return hashlib.sha256(data).hexdigest()


def schreiben(path,data):
    temp=path.with_suffix(path.suffix+'.tmp')
    temp.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    temp.replace(path)


def auftraege(gruppe):
    if gruppe == 'gefuehrt':
        return redaktion_audio_gefuehrt.auftraege()
    tasks=[]
    freigabe=ROOT/'build/redaktion/gesamt/hoerproben/freigabe.json'
    if not freigabe.exists(): raise SystemExit('Hörfreigabe des Wissensprofils fehlt.')
    approved=json.loads(freigabe.read_text(encoding='utf-8'))
    assert approved['profil']==reihe_ausdruck.LEKTIONS_PROFIL
    assert approved['status']=='freigegeben'
    for lang,path in [('de',ROOT/'assets/data/velvet_content.json'),('en',ROOT/'translations/en/velvet_content.json')]:
        data=json.loads(path.read_text(encoding='utf-8'))
        for course in data['courses']:
            for lesson in course['lessons']:
                if gruppe=='spicy' and not (course.get('spicy') or lesson.get('spicy')): continue
                tasks.append({'sprache':lang,'id':lesson['id'],'stimme':de.voice_for(course,lesson),
                              'text':de.speech_text(lesson) if lang=='de' else en.sprechtext(lesson),
                              'szene':'wissen','profil':reihe_ausdruck.LEKTIONS_PROFIL})
    if gruppe=='spicy': assert len(tasks)==54
    return tasks


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--gruppe',choices=['spicy','alle-lektionen','gefuehrt'],default='spicy')
    p.add_argument('--hoechstens',type=int)
    args=p.parse_args()
    os.environ['HF_HUB_OFFLINE']='1'; os.environ['TRANSFORMERS_OFFLINE']='1'
    import msvcrt
    import soundfile as sf
    import torch
    torch.set_num_threads(4)
    OUT.mkdir(parents=True,exist_ok=True)
    # Verhindert zwei gleichzeitig laufende Produktionsprozesse auf Windows.
    with (OUT/'produktion.lock').open('a+b') as lock:
        lock.seek(0); lock.write(b'0'); lock.flush(); lock.seek(0)
        msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1)
        tasks=auftraege(args.gruppe)
        manifest=OUT/'manifest.json'
        state=json.loads(manifest.read_text(encoding='utf-8')) if manifest.exists() else {}
        # Vollständiger Quellstand bleibt getrennt; gehört nicht ins Repository.
        schreiben(OUT/f'auftraege-{args.gruppe}.json',tasks)
        engine=None; language=None; made=0
        lex=sha(de.LEXICON_JSON.read_bytes())
        code=sha(b''.join((ROOT/'tools'/f).read_bytes() for f in ('generate_audio.py','generate_audio_en.py','reihe_ausdruck.py')))
        if args.gruppe == 'gefuehrt':
            code = sha((code + sha((ROOT/'tools/redaktion_audio_gefuehrt.py').read_bytes())).encode())
        schreiben(OUT/'status.json',{'status':'läuft','gruppe':args.gruppe,'auftraege':len(tasks),
                                    'profil':'bestehende geführte Sprechregeln' if args.gruppe=='gefuehrt' else reihe_ausdruck.LEKTIONS_PROFIL})
        for i,task in enumerate(tasks,1):
            if (OUT/'pause.flag').exists():
                schreiben(OUT/'status.json',{'status':'angehalten zwischen Aufnahmen','gruppe':args.gruppe})
                print('Pausensignal erkannt. Fertige Aufnahmen bleiben erhalten.',flush=True)
                return
            name=f"{task['sprache']}/{task['id']}"
            fingerprint=sha(json.dumps({'auftrag':task,'aussprache':lex if task['sprache']=='de' else 'englisches Kokoro',
                                       'code':code,'tempo':de.SPEED,'stimmtempo':de.VOICE_SPEED},sort_keys=True).encode())
            dest=OUT/task['sprache']/'audio'/f"{task['id']}.opus"
            previous=state.get(name,{})
            if dest.exists() and previous.get('fingerprint')==fingerprint and previous.get('sha256')==sha(dest.read_bytes()):
                continue
            if args.hoechstens is not None and made>=args.hoechstens: break
            if language!=task['sprache']:
                del engine; gc.collect()
                language=task['sprache']; engine=de.Kokoro() if language=='de' else en.Englisch()
            dest.parent.mkdir(parents=True,exist_ok=True)
            wav=dest.with_suffix('.wav')
            part=dest.with_suffix('.part.opus')
            print(f"[{i}/{len(tasks)}] START {name} ({task['stimme']})",flush=True)
            started=time.time()
            if args.gruppe == 'gefuehrt': redaktion_audio_gefuehrt.sprechen(engine,task,wav,de,en)
            elif language=='de': engine.synthesize_ausdruck(task['szene'],task['text'],task['stimme'],wav)
            else: engine.wav(task['text'],task['stimme'],wav,pause=f"ausdruck:{task['profil']}:{task['szene']}")
            info=sf.info(wav)
            assert info.duration>0 and info.samplerate==24000 and info.channels==1
            de.to_opus(wav,part)
            assert part.stat().st_size>100
            part.replace(dest)
            wav.unlink()
            state[name]={'fingerprint':fingerprint,'sha256':sha(dest.read_bytes()),'dauer_ms':round(info.duration*1000),
                         'stimme':task['stimme'],'profil':task['profil'],'status':'technisch erzeugt; Hörabnahme offen'}
            schreiben(manifest,state)
            prefix = language + '/' + (task['id'].rsplit('/', 1)[0] + '/' if '/' in task['id'] else '')
            durations={k[len(prefix):]:v['dauer_ms'] for k,v in state.items()
                       if k.startswith(prefix) and '/' not in k[len(prefix):]}
            schreiben(dest.parent/'dauer.json',durations)
            made+=1
            print(f"[{i}/{len(tasks)}] FERTIG {name}: {info.duration:.1f} s Audio, {time.time()-started:.1f} s Rechenzeit",flush=True)
        schreiben(OUT/'status.json',{'status':'Stapel beendet','gruppe':args.gruppe,'neu_in_diesem_lauf':made,
                                    'hoerabnahme':'offen'})
        print(f'Stapel beendet: {made} Aufnahmen neu; Ergebnisse und Prüfsummen in {OUT}',flush=True)
    # Erst nach Freigabe der Dateisperre weitermachen. Der bestehende Folgelauf
    # startet dieses Skript nach Spicy; daran schließen die geführten Texte an.
    if args.gruppe == 'alle-lektionen' and args.hoechstens is None:
        import subprocess
        import sys
        raise SystemExit(subprocess.run([sys.executable, __file__, '--gruppe', 'gefuehrt'], cwd=ROOT).returncode)


if __name__=='__main__': main()
