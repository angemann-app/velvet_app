"""Wartet ohne geladenes Sprachmodell auf den laufenden öffentlichen Stapel.

Danach seriell Innenansichten und Abschlussprüfung. Nie zwei Synthesen zugleich.
Fortsetzbar: kein bereits quellen-/hashgleiches Ergebnis erneut sprechen.
"""
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'build/redaktion/spicy-ton'


def main():
    status = BASE / 'nachtlauf.json'
    def meldung(text):
        status.write_text(json.dumps({'status': text, 'zeit_unix': time.time()}, ensure_ascii=False, indent=2), encoding='utf-8')
        print(text, flush=True)
    meldung('Wartet auf laufenden 150er-Stapel; kein weiteres Sprachmodell geladen')
    start = time.monotonic()
    while True:
        path = BASE / 'produktion/status.json'
        if path.exists():
            try:
                data = json.loads(path.read_text(encoding='utf-8'))
            except (ValueError, OSError):
                data = {}
            if data.get('fertig') == data.get('gesamt') == 150 and data.get('status') == 'vollständig technisch erzeugt und dekodiert':
                break
        if time.monotonic() - start > 8 * 3600:
            raise TimeoutError('150er-Stapel nach acht Stunden nicht fertig; kein paralleler Neustart')
        time.sleep(5)
    # Status wird vor Freigabe des exklusiven Locks geschrieben; kurz auf Prozessende warten.
    time.sleep(15)
    for script, log in [('spicy_ton_innen_produktion.py', 'innenansichten/produktion-lauf.log'),
                        ('spicy_ton_abschluss.py', 'abschluss-lauf.log')]:
        meldung('Start: ' + script)
        with (BASE / log).open('a', encoding='utf-8') as output:
            subprocess.run([sys.executable, str(ROOT / 'tools' / script)], cwd=ROOT, stdout=output,
                stderr=subprocess.STDOUT, check=True)
    meldung('Fertig: 174 Dateien technisch geprüft; Übergabe bereit, Hörabnahme offen, kein Upload')


if __name__ == '__main__':
    import ctypes
    # Nur Systemschlaf verhindern; Bildschirm darf sich ausschalten.
    kernel = ctypes.windll.kernel32
    held = bool(kernel.SetThreadExecutionState(0x80000001))
    try:
        main()
    except Exception as error:
        (BASE / 'nachtlauf.json').write_text(json.dumps({'status': 'Fehler – Fortsetzung prüfen',
            'typ': type(error).__name__, 'meldung': str(error)}, ensure_ascii=False, indent=2), encoding='utf-8')
        raise
    finally:
        if held:
            kernel.SetThreadExecutionState(0x80000000)
