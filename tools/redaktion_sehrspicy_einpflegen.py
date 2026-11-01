"""Pflegt die freigegebenen 'Sehr spicy'-Fassungen in C:\\TOOLS\\velvet-inhalte\\reihe\\reihe.json ein."""
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REIHE_ORDNER = Path(r"C:\TOOLS\velvet-inhalte\reihe")
REIHE_JSON = REIHE_ORDNER / "reihe.json"
BACKUP_JSON = REIHE_ORDNER / "reihe.vor-sehrspicy.bak.json"
ENTWURF_DIR = ROOT / "build" / "redaktion" / "sehrspicy"

def fuege_ein():
    # 1. Backup erstellen
    if not BACKUP_JSON.exists():
        shutil.copy2(REIHE_JSON, BACKUP_JSON)
        print(f"Backup erstellt: {BACKUP_JSON}")

    daten = json.loads(REIHE_JSON.read_text(encoding="utf-8"))

    # Entwürfe laden
    de_mann = json.loads((ENTWURF_DIR / "sehrspicy_mann.de.json").read_text(encoding="utf-8"))
    de_frau = json.loads((ENTWURF_DIR / "sehrspicy_frau.de.json").read_text(encoding="utf-8"))
    en_mann = json.loads((ENTWURF_DIR / "sehrspicy_mann.en.json").read_text(encoding="utf-8"))
    en_frau = json.loads((ENTWURF_DIR / "sehrspicy_frau.en.json").read_text(encoding="utf-8"))

    def bereinige_segmente(fassung):
        return {
            "id": fassung["id"],
            "variante": fassung["variante"],
            "perspektive": fassung["perspektive"],
            "name": fassung["name"],
            "stimme": fassung["stimme"],
            "segmente": [{"szene": s["szene"], "text": s["text"]} for s in fassung["segmente"]]
        }

    # Deutsch einpflegen
    folge_de = [f for f in daten["de"]["folgen"] if f["id"] == "der_andere_koerper"][0]
    bestehende_ids_de = {fa["id"] for fa in folge_de["fassungen"]}
    for f in [bereinige_segmente(de_frau), bereinige_segmente(de_mann)]:
        if f["id"] in bestehende_ids_de:
            folge_de["fassungen"] = [fa if fa["id"] != f["id"] else f for fa in folge_de["fassungen"]]
        else:
            folge_de["fassungen"].append(f)

    # Englisch einpflegen
    folge_en = [f for f in daten["en"]["folgen"] if f["id"] == "der_andere_koerper"][0]
    bestehende_ids_en = {fa["id"] for fa in folge_en["fassungen"]}
    for f in [bereinige_segmente(en_frau), bereinige_segmente(en_mann)]:
        if f["id"] in bestehende_ids_en:
            folge_en["fassungen"] = [fa if fa["id"] != f["id"] else f for fa in folge_en["fassungen"]]
        else:
            folge_en["fassungen"].append(f)

    REIHE_JSON.write_text(json.dumps(daten, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"reihen.json erfolgreich aktualisiert. DE fassungen: {len(folge_de['fassungen'])}, EN fassungen: {len(folge_en['fassungen'])}")

if __name__ == "__main__":
    fuege_ein()
