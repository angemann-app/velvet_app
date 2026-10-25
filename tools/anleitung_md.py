"""Erzeugt docs/ANLEITUNG.md (Deutsch) und docs/GUIDE.md (Englisch) aus der Anleitung der App.

Quelle: assets/data/anleitung.json und translations/en/anleitung.json. Bildschirmfotos liegen in
docs/anleitung/ (aus test_screens/screens_test.dart, dort unter build/screens/ erzeugt).

  python tools/anleitung_md.py
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEXTE = {
    "de": {
        "quelle": ROOT / "assets/data/anleitung.json",
        "ziel": ROOT / "docs/ANLEITUNG.md",
        "titel": "So funktioniert VelvetPulse",
        "kopf": "Diese Anleitung steht auch in der App (Fragezeichen oben rechts oder im Profil). "
                "[English version](GUIDE.md)",
        "inhalt": "Inhalt",
    },
    "en": {
        "quelle": ROOT / "translations/en/anleitung.json",
        "ziel": ROOT / "docs/GUIDE.md",
        "titel": "How VelvetPulse works",
        "kopf": "This guide is also inside the app (question mark at the top right, or in your profile). "
                "[Deutsche Fassung](ANLEITUNG.md)",
        "inhalt": "Contents",
    },
}


def anker(text):
    return "".join(c for c in text.lower().replace(" ", "-") if c.isalnum() or c == "-")


for sprache, t in TEXTE.items():
    abschnitte = json.loads(t["quelle"].read_text(encoding="utf-8"))["abschnitte"]
    zeilen = [f"# {t['titel']}", "", t["kopf"], "", f"## {t['inhalt']}", ""]
    zeilen += [f"- [{a['titel']}](#{anker(a['titel'])})" for a in abschnitte]
    for a in abschnitte:
        zeilen += ["", f"## {a['titel']}", ""]
        if a.get("bild") and (ROOT / "docs/anleitung" / a["bild"]).exists():
            zeilen += [f'<img src="anleitung/{a["bild"]}" width="260" alt="{a["titel"]}">', ""]
        for absatz in a["text"].split("\n"):
            zeilen += [absatz, ""]
    t["ziel"].write_text("\n".join(zeilen).rstrip() + "\n", encoding="utf-8")
    print(t["ziel"].name, len(abschnitte))
