"""Aktualisiert die lokale Hörabnahme während der Aufnahme, ohne ein TTS-Modell zu laden."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/traumpraxis'


def main():
    previous = None
    last_progress = time.monotonic()
    while True:
        manifest = OUT / 'manifest.json'
        raw = manifest.read_bytes() if manifest.exists() else b''
        fingerprint = hashlib.sha256(raw).hexdigest()
        if fingerprint != previous:
            check = subprocess.run([sys.executable, '-X', 'utf8', str(ROOT / 'tools/traumpraxis_abnahme.py'), '--zwischenstand'],
                                   cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
            print(check.stdout.splitlines()[-1] if check.stdout else 'Keine Prüfmeldung', flush=True)
            if check.returncode:
                print(check.stderr, flush=True)
                raise SystemExit(check.returncode)
            previous = fingerprint
            last_progress = time.monotonic()
            report = json.loads((OUT / 'technische-pruefung.json').read_text(encoding='utf-8'))
            if report['fertig'] == 12:
                print('Alle zwölf Aufnahmen technisch geprüft. Hörprüfung durch AG bleibt offen.', flush=True)
                return
        if time.monotonic() - last_progress > 1200:
            raise SystemExit('Zwanzig Minuten ohne neue Aufnahme. Produktion prüfen; keine Fertigstellung behaupten.')
        time.sleep(15)


if __name__ == '__main__':
    main()
