"""Technische Endprüfung der vorhandenen Neuaufnahmen, ohne Synthese/Upload.

Prüft aktuellen Quell-/Aussprache-Fingerprint, SHA-256, Mono/Opus/48 kHz,
Laufzeit und vollständige libsndfile-Dekodierung. Vier kleine Prüfthreads, niemals
eine Kokoro-Instanz. ffprobe kontrolliert repräsentative Dateien unabhängig.
Mit C:/TOOLS/kikiri-venv/Scripts/python.exe ausführen (SoundFile/NumPy vorhanden).
Eine gemeinsame Dateisperre verhindert gleichzeitige Produktion.
Hörabnahme bleibt ausdrücklich offen. Texte und Originalaufnahmen unverändert.
"""
import concurrent.futures
import hashlib
import html
import json
from pathlib import Path
import shutil
import subprocess
import time

import numpy as np
import soundfile as sf

import redaktion_audio_stapel as producer

ROOT=Path(__file__).resolve().parents[1]
PRODUCTION=ROOT/'build/redaktion/gesamt/produktion'
OUT=ROOT/'build/redaktion/gesamt/abnahme'


def sha(data):return hashlib.sha256(data).hexdigest()


def write(file,data):
    temp=file.with_suffix(file.suffix+'.tmp')
    temp.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');temp.replace(file)


def decode(file):
    with sf.SoundFile(file) as audio:
        if (audio.format,audio.subtype,audio.samplerate,audio.channels)!=('OGG','OPUS',48000,1):
            raise ValueError('Codec/Kanäle/Abtastrate abweichend')
        expected=audio.frames;frames=0;peak=0.0
        while True:
            block=audio.read(65536,dtype='float32',always_2d=True)
            if len(block)==0:break
            if not np.isfinite(block).all():raise ValueError('Nicht endliche Audiosamples')
            frames+=len(block);peak=max(peak,float(np.abs(block).max()))
        if frames!=expected or frames<=0:raise ValueError('Unvollständig dekodiert')
        if peak==0:raise ValueError('Datei vollständig stumm')
        return dict(codec='opus',samplerate=audio.samplerate,kanaele=audio.channels,
                    dauer_sekunden=round(frames/audio.samplerate,4),dekodiert=True,peak=round(peak,6))


def check(task,group,manifest,lex,code):
    name=f"{task['sprache']}/{task['id']}"
    file=PRODUCTION/task['sprache']/'audio'/(task['id']+'.opus')
    result=dict(id=name,gruppe=group,stimme=task['stimme'],profil=task['profil'],datei=str(file),fehler=[])
    expected=sha(json.dumps(dict(auftrag=task,aussprache=lex if task['sprache']=='de' else 'englisches Kokoro',
                   code=code,tempo=producer.de.SPEED,stimmtempo=producer.de.VOICE_SPEED),sort_keys=True).encode())
    previous=manifest.get(name,{})
    if previous.get('fingerprint')!=expected:result['fehler'].append('Quell-/Sprechregel-Fingerprint abweichend')
    if not file.is_file():result['fehler'].append('Datei fehlt');return result
    actual=sha(file.read_bytes());result['sha256']=actual
    if actual!=previous.get('sha256'):result['fehler'].append('Dateiprüfsumme abweichend')
    try:
        result.update(decode(file));duration=result['dauer_sekunden']
        if duration<=0 or abs(duration*1000-previous.get('dauer_ms',0))>100:result['fehler'].append('Laufzeit abweichend')
    except (RuntimeError,ValueError,KeyError,IndexError) as e:
        result['fehler'].append('Dekodier-/Formatprüfung: '+str(e)[:300])
    return result


def probe_sample(r,probe):
    info=json.loads(subprocess.check_output([probe,'-v','error','-select_streams','a:0',
        '-show_entries','stream=codec_name,sample_rate,channels:format=duration','-of','json',r['datei']],timeout=30))
    stream=info['streams'][0]
    assert (stream['codec_name'],int(stream['sample_rate']),stream['channels'])==('opus',48000,1),r['id']
    assert abs(float(info['format']['duration'])-r['dauer_sekunden'])<.1,r['id']


def samples(results):
    """Sprach-/Stimmenwechsel und alle vier geführten Familien abdecken."""
    picked=[]
    for lang in ('de','en'):
        for voice in ('victoria','martin','both'):
            choice=next((r for r in results if r['gruppe']=='alle-lektionen' and r['id'].startswith(lang+'/') and r['stimme']==voice),None)
            if choice:picked.append(choice)
        spicy=next((r for r in results if r['id'].startswith(lang+'/spduo_')),None)
        if spicy:picked.append(spicy)
        for family in ('paar','selbst','einschlaf','traum'):
            for voice in ('victoria','martin'):
                choice=next(r for r in results if r['id'].startswith(f'{lang}/{family}/{voice}_'))
                picked.append(choice)
    return list({r['id']:r for r in picked}.values())


def listening(results):
    cards=[]
    for r in samples(results):
        url=Path(r['datei']).as_uri();name=html.escape(r['id'])
        cards.append(f'<article><h2>{name}</h2><p>{html.escape(r["stimme"])} · {r.get("dauer_sekunden",0):.1f} s · {html.escape(r["profil"])}</p><audio controls preload="none" src="{url}"></audio></article>')
    source=(ROOT/'build/redaktion/traumpraxis/ABNAHME.html').as_uri()
    doc=f'''<!doctype html><html lang="de"><meta charset="utf-8"><title>VelvetPulse / Hörabnahme</title>
    <style>body{{margin:40px auto;max-width:1000px;padding:0 24px;background:#F6F0E6;color:#2A2A2C;font:16px/1.5 'Segoe UI',sans-serif}}
    h1,h2{{font-family:Georgia,serif;font-weight:400}}h2{{font-size:21px}}article{{padding:16px 0;border-top:1px solid #D8CFBF}}audio{{width:100%}}a{{color:#8E4A57}}.grid{{display:grid;grid-template-columns:1fr 1fr;gap:25px}}@media(max-width:700px){{.grid{{grid-template-columns:1fr}}}}</style>
    <h1>VelvetPulse / Hörabnahme</h1><p>Technische Prüfung ersetzt keine Hörabnahme. Alles liegt lokal; nichts wurde veröffentlicht.</p>
    <p>Prüfen: Aussprache nach dem bestehenden Lexikon, Natürlichkeit, Tempo, Pausen, Stimmwechsel und hörbare Übergänge. Geführte Schlaftexte sind absichtlich langsamer. Probleme mit Datei-ID und Zeitmarke notieren.</p>
    <p><a href="{source}">Zusätzlich: alle zwölf Traumpraxis-Aufnahmen</a></p><div class="grid">{''.join(cards)}</div></html>'''
    (OUT/'HOERPROBEN.html').write_text(doc,encoding='utf-8')


def main():
    import msvcrt
    OUT.mkdir(parents=True,exist_ok=True)
    probe=shutil.which('ffprobe')
    assert probe,'ffprobe fehlt'
    # Nur prüfen, wenn kein anderer Produktionslauf gerade Dateien ersetzt.
    with (PRODUCTION/'produktion.lock').open('r+b') as lock:
        lock.seek(0);msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1)
        try:
            manifest=json.loads((PRODUCTION/'manifest.json').read_text(encoding='utf-8'))
            lex=sha(producer.de.LEXICON_JSON.read_bytes())
            basecode=sha(b''.join((ROOT/'tools'/f).read_bytes() for f in ('generate_audio.py','generate_audio_en.py','reihe_ausdruck.py')))
            guidedcode=sha((basecode+sha((ROOT/'tools/redaktion_audio_gefuehrt.py').read_bytes())).encode())
            jobs=[(t,g) for g in ('alle-lektionen','gefuehrt') for t in producer.auftraege(g)]
            assert len(jobs)==1744
            started=time.time();results=[]
            write(OUT/'status.json',dict(status='technische Prüfung läuft',geprueft=0,gesamt=len(jobs)))
            with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
                fs=[pool.submit(check,t,g,manifest,lex,guidedcode if g=='gefuehrt' else basecode) for t,g in jobs]
                for f in concurrent.futures.as_completed(fs):
                    results.append(f.result())
                    if len(results)%50==0 or len(results)==len(jobs):
                        status=dict(status='technische Prüfung läuft',geprueft=len(results),gesamt=len(jobs),fehler=sum(bool(r['fehler']) for r in results))
                        write(OUT/'status.json',status);print(json.dumps(status,ensure_ascii=False),flush=True)
            results.sort(key=lambda r:r['id'])
            for r in samples(results):
                if not r['fehler']:probe_sample(r,probe)
            errors=[r for r in results if r['fehler']]
            report=dict(gesamt=len(results),bestanden=len(results)-len(errors),fehler=len(errors),
                        laufzeit_sekunden=round(time.time()-started,1),audio_stunden=round(sum(r.get('dauer_sekunden',0) for r in results)/3600,2),
                        dekoder='libsndfile '+sf.__libsndfile_version__,ffprobe_stichproben=len(samples(results)),
                        hoerabnahme='offen',veroeffentlicht=False,aufnahmen=results)
            write(OUT/'technische-pruefung.json',report)
            listening(results)
            write(OUT/'status.json',{k:v for k,v in report.items() if k!='aufnahmen'})
            text=f'''# Technische Audio-Endprüfung

{report['bestanden']} von {report['gesamt']} Aufnahmen bestanden, {report['fehler']} mit Befund.
256 Lektionsaufnahmen und 1.488 geführte Bausteine, Deutsch und Englisch.
Insgesamt {report['audio_stunden']} Stunden Audio; mehrere Stimmen/Sprachen und alternative Bausteine, keine App-Gesamtlaufzeit.

Geprüft: aktueller Text-/Aussprache-/Sprechregel-Fingerprint, SHA-256, Opus, Mono, 48 kHz,
Laufzeit gegen Produktionsmanifest und vollständige Dekodierung mit libsndfile.
24 Sprach-/Stimmen-/Familienproben unabhängig mit ffprobe gegengeprüft.
Keine neue Synthese und keine Änderung an Originalen, Paketversionen oder Uploads.

Hörabnahme ausdrücklich offen. `HOERPROBEN.html` enthält repräsentative Stimmen-/Familienproben;
die zwölf neuen Traumpraxis-Aufnahmen haben eine getrennte Abnahmeseite.
Die acht privaten Abendfolgen und Innenansichten sind nicht Gegenstand dieser Neuvertonungsprüfung.
'''
            if errors:text+='\n## Befunde\n\n'+'\n'.join('- '+r['id']+': '+', '.join(r['fehler']) for r in errors)
            (OUT/'BERICHT.md').write_text(text,encoding='utf-8')
            print(json.dumps({k:v for k,v in report.items() if k!='aufnahmen'},ensure_ascii=False),flush=True)
            if errors:raise SystemExit(1)
        finally:
            lock.seek(0);msvcrt.locking(lock.fileno(),msvcrt.LK_UNLCK,1)


if __name__=='__main__':main()
