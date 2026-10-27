"""Baut die Audio-Pakete (je Sprache Lektionen und geführte Audios) als ZIP samt Prüfsumme.

  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/pakete_bauen.py [--en-quelle C:\\TOOLS\\workspace\\mojo\\build\\audio_en]

Quelle Deutsch: assets/audio/ (Lektionen direkt darin, geführte Audios in paar/, selbst/, einschlaf/).
Quelle Englisch: das eingesprochene englische Paket (tools/generate_audio_en.py, Ordner build/audio_en/).
Die Versionen stehen in tools/pakete/versionen.json; nach geänderten Aufnahmen dort hochzählen.

Ergebnis in build/pakete/: <name>-v<version>.zip und eintraege.json (Name, Sprache, Version, Größe, SHA-256,
Datei) für tools/pakete_verzeichnis.dart. Ansagen (cues), Klangschale und Klangteppich bleiben in der App.
"""
import argparse
import hashlib
import json
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ZIEL = ROOT / "build" / "pakete"
GEFUEHRT = ("paar", "selbst", "einschlaf", "traum")
NICHT_INS_PAKET = {"klangschale.opus", "klangteppich.opus"}


def dateien(quelle: Path, art: str):
    """(Datei, Pfad im Paket) für eine Art."""
    audio = quelle / "audio" if (quelle / "audio").is_dir() else quelle
    if art == "lektionen":
        for f in sorted(audio.glob("*.opus")):
            yield f, f"audio/{f.name}"
    else:
        for unter in GEFUEHRT:
            for f in sorted((audio / unter).glob("*")):
                if f.is_file() and f.name not in NICHT_INS_PAKET:
                    yield f, f"audio/{unter}/{f.name}"


def bauen(name, sprache, art, quelle, version):
    ZIEL.mkdir(parents=True, exist_ok=True)
    datei = ZIEL / f"{name}-v{version}.zip"
    anzahl = 0
    with zipfile.ZipFile(datei, "w", compression=zipfile.ZIP_STORED) as z:  # Opus ist schon komprimiert
        z.writestr("paket.json", json.dumps({"name": name, "sprache": sprache, "version": version}))
        for f, pfad in dateien(quelle, art):
            z.write(f, pfad)
            anzahl += 1
    if anzahl == 0:
        raise SystemExit(f"{name}: keine Aufnahmen in {quelle}")
    daten = datei.read_bytes()
    print(f"{datei.name}: {anzahl} Dateien, {len(daten) / 1e6:.1f} MB")
    return {"name": name, "sprache": sprache, "version": version, "groesse": len(daten),
            "sha256": hashlib.sha256(daten).hexdigest(), "datei": datei.name}


LUST_ORDNER = Path(r"C:\TOOLS\velvet-inhalte\lust")


def lust_bauen(sprache, version):
    """„Lust im Traum“: Texte (lust/lust.json) und Aufnahmen (audio/lust/) aus dem privaten Ordner, nie aus dem
    Repository. Nur wenn für jede Id beide Stimmen da sind; sonst None. Liegt nur auf R2 („nur_r2“)."""
    texte = json.loads((LUST_ORDNER / "lust.json").read_text(encoding="utf-8"))[sprache]
    audio = LUST_ORDNER / ("audio" if sprache == "de" else "audio_en")
    fehlt = [f"{s}_{b['id']}" for s in ("victoria", "martin") for b in texte if not (audio / f"{s}_{b['id']}.opus").exists()]
    if fehlt or not (audio / "dauer.json").exists():
        print(f"{sprache}-lust: übersprungen, {len(fehlt)} Aufnahmen fehlen")
        return None
    name = f"{sprache}-lust"
    datei = ZIEL / f"{name}-v{version}.zip"
    with zipfile.ZipFile(datei, "w", compression=zipfile.ZIP_STORED) as z:
        z.writestr("paket.json", json.dumps({"name": name, "sprache": sprache, "version": version}))
        z.writestr("lust/lust.json", json.dumps({"bausteine": texte}, ensure_ascii=False))
        for f in sorted(audio.glob("*")):
            if f.suffix in (".opus", ".json") and f.name != "audio_en_texte.json":
                z.write(f, f"audio/lust/{f.name}")
    daten = datei.read_bytes()
    print(f"{datei.name}: {len(texte) * 2} Aufnahmen, {len(daten) / 1e6:.1f} MB (nur R2)")
    return {"name": name, "sprache": sprache, "version": version, "groesse": len(daten),
            "sha256": hashlib.sha256(daten).hexdigest(), "datei": datei.name, "nur_r2": True}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--en-quelle", default=str(ROOT / "build" / "audio_en"))
    a = p.parse_args()
    versionen = json.loads((ROOT / "tools" / "pakete" / "versionen.json").read_text(encoding="utf-8"))
    quellen = {"de": ROOT / "assets", "en": Path(a.en_quelle)}
    eintraege = []
    for alt in ZIEL.glob("*-lust-v*.zip"):
        alt.unlink()
    for sprache in ("de", "en"):
        for art in ("lektionen", "gefuehrt"):
            name = f"{sprache}-{art}"
            eintraege.append(bauen(name, sprache, art, quellen[sprache], versionen[name]))
        if (LUST_ORDNER / "lust.json").exists() and f"{sprache}-lust" in versionen:
            e = lust_bauen(sprache, versionen[f"{sprache}-lust"])
            if e:
                eintraege.append(e)
    (ZIEL / "eintraege.json").write_text(json.dumps(eintraege, indent=2), encoding="utf-8")
    print(f"eintraege.json: {len(eintraege)} Pakete")


if __name__ == "__main__":
    main()
