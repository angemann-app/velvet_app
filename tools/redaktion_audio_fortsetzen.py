"""Wartet auf den laufenden Einzelprozess und vertont danach die übrigen Kurslektionen.

Kein paralleler Kokoro-Lauf. Keine Veröffentlichung. Ein Stoppsignal unter
build/redaktion/gesamt/produktion/pause.flag beendet das Warten.
"""
import msvcrt
from pathlib import Path
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/redaktion/gesamt/produktion'


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    print('Wartet auf freien Produktionsplatz für die übrigen Kurslektionen.',flush=True)
    while True:
        if (OUT/'pause.flag').exists():
            print('Pausensignal: Folgestapel nicht gestartet.',flush=True)
            return
        with (OUT/'produktion.lock').open('r+b') as lock:
            try:
                msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1)
            except OSError:
                frei=False
            else:
                msvcrt.locking(lock.fileno(),msvcrt.LK_UNLCK,1)
                frei=True
        if frei:break
        time.sleep(10)
    # Der Aufnahmelauf prüft die Sperre erneut. Bei einem Rennen nie parallel sprechen.
    result=subprocess.run([sys.executable,str(ROOT/'tools/redaktion_audio_stapel.py'),'--gruppe','alle-lektionen'],cwd=ROOT)
    raise SystemExit(result.returncode)


if __name__=='__main__':main()
