"""Kurze lokale Varianten nach negativem AG-Gegenhören; keine Paketänderung."""
import os
os.environ['HF_HUB_OFFLINE']='1'
os.environ['TRANSFORMERS_OFFLINE']='1'
import json
from pathlib import Path
import generate_audio as de
import misaki.de
import torch
import soundfile as sf
import numpy as np
import hashlib
import msvcrt

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt/korrektur-ag26/varianten-2'
VARIANTEN={
 'a': {'prostata':'pɾˈɔs tata','herstellerangaben':'hˈɛɾʃtɛlɐˌaŋɡaːbən'},
 'b': {'prostata':'pɾˈɔs.tata','herstellerangaben':'hˈɛɾʃtɛlɐ ˈanɡaːbən'},
}

def main():
 torch.set_num_threads(4)
 OUT.mkdir(parents=True,exist_ok=True)
 with (ROOT/'build/redaktion/gesamt/produktion/produktion.lock').open('a+b') as lock:
  lock.seek(0); lock.write(b'0'); lock.flush(); lock.seek(0)
  msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1)
  engine=de.Kokoro()
  bericht=[]
  for name,werte in VARIANTEN.items():
   for wort,laut in werte.items():
    misaki.de._OVERRIDES[misaki.de.normalize_for_lookup(wort)]=laut
   text='Prostata. Prostata. Herstellerangaben. Herstellerangaben.'
   wav=OUT/f'variante_{name}.wav'
   engine.synthesize_ausdruck('wissen',text,'martin',wav)
   data,rate=sf.read(wav,dtype='float32')
   assert rate==24000 and np.isfinite(data).all() and np.max(np.abs(data))>0
   bericht.append({'variante':name,'lautvorgaben':werte,'tatsaechliche_phoneme':engine.phonemes(text),
     'dauer_sekunden':len(data)/rate,'sha256':hashlib.sha256(wav.read_bytes()).hexdigest(),
     'status':'technisch geprüft; akustischer Vergleich offen'})
   print(f'Variante {name} fertig: {len(data)/rate:.2f} s',flush=True)
  (OUT/'bericht.json').write_text(json.dumps(bericht,ensure_ascii=False,indent=2),encoding='utf-8')

if __name__=='__main__': main()
