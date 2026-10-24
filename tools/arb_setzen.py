"""Setzt oder ändert einzelne Einträge in lib/l10n/app_de.arb und app_en.arb und erzeugt neu.

  python tools/arb_setzen.py eintraege.json
eintraege.json: {"schlüssel": {"de": "...", "en": "...", "platzhalter": {"name": "int"}}}
Ein Eintrag ohne "de" oder "en" lässt die jeweilige Sprache unverändert.
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
neu = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8-sig"))
for sprache in ("de", "en"):
    pfad = ROOT / f"lib/l10n/app_{sprache}.arb"
    arb = json.loads(pfad.read_text(encoding="utf-8"))
    for key, e in neu.items():
        if sprache in e:
            arb[key] = e[sprache]
        if sprache == "de" and e.get("platzhalter"):
            arb["@" + key] = {"placeholders": {n: {"type": t} for n, t in e["platzhalter"].items()}}
    pfad.write_text(json.dumps(arb, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
subprocess.run([r"C:\TOOLS\flutter\bin\flutter.bat", "gen-l10n"], cwd=ROOT, capture_output=True)
print(len(neu), "Einträge gesetzt")
