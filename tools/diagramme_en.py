"""Englische Fassungen der Anleitungsgrafiken (assets/images/diagram_*.svg → diagram_*_en.svg).

  python tools/diagramme_en.py --texte       zeigt alle Beschriftungen, die noch keine Übersetzung haben
  python tools/diagramme_en.py               erzeugt die _en.svg-Dateien

Übersetzt wird nur der sichtbare Text in <text>/<tspan>; Grafik und Aufbau bleiben gleich.
Fehlt eine Übersetzung, bricht das Skript ab, damit keine halb deutsche Grafik entsteht.
"""
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BILDER = ROOT / "assets" / "images"
UEBERSETZUNG = Path(__file__).parent / "diagramme_en.json"
TEXT = re.compile(r"(<(?:text|tspan)\b[^>]*>)([^<]+)(<)")


def quellen():
    return sorted(p for p in BILDER.glob("diagram_*.svg") if not p.stem.endswith("_en"))


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    ueb = json.loads(UEBERSETZUNG.read_text(encoding="utf-8")) if UEBERSETZUNG.exists() else {}
    fehlend = []
    for p in quellen():
        svg = p.read_text(encoding="utf-8")

        def ersetze(m):
            roh = html.unescape(m.group(2))
            if not roh.strip() or not re.search(r"[A-Za-zÄÖÜäöüß]", roh):
                return m.group(0)
            if roh.strip() not in ueb:
                fehlend.append((p.name, roh.strip()))
                return m.group(0)
            neu = roh.replace(roh.strip(), ueb[roh.strip()])
            return m.group(1) + html.escape(neu, quote=False) + m.group(3)

        neu = TEXT.sub(ersetze, svg)
        if "--texte" not in sys.argv and not fehlend:
            (BILDER / f"{p.stem}_en.svg").write_text(neu, encoding="utf-8")
    if fehlend:
        for datei, text in dict.fromkeys(fehlend):
            print(f"{datei}: {json.dumps(text, ensure_ascii=False)}")
        if "--texte" not in sys.argv:
            sys.exit(f"{len(set(fehlend))} Beschriftungen ohne Übersetzung (tools/diagramme_en.json)")
    elif "--texte" not in sys.argv:
        print(f"{len(quellen())} englische Grafiken erzeugt")


if __name__ == "__main__":
    main()
