"""Englisches Audiopaket: alle englischen Texte mit dem Original-Kokoro einsprechen und als ZIP packen.

Das Paket wird nicht in die App eingebaut, sondern bei Bedarf nachgeladen (lib/services/sprachausgabe.dart,
AudioPaket). Struktur wie assets/: audio/<lektion>.opus, audio/paar/<stimme>_<id>.opus (+ dauer.json),
audio/selbst/<stimme>_<id>.opus (+ dauer.json), audio/cues/<stimme>_<ansage>.opus, audio/version.txt.

  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio_en.py          (alles, setzt fort)
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio_en.py --packen (nur ZIP + Prüfsumme)

Stimmen: „victoria“ → af_heart, „martin“ → am_michael (englische Originalstimmen von Kokoro-82M).
Die Dateinamen behalten victoria/martin, damit die App dieselben Pfade nutzt wie auf Deutsch.
"""
import argparse
import hashlib
import json
import re
import sys
import tempfile
import zipfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import generate_audio as de  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
EN = ROOT / "translations" / "en"
ZIEL = ROOT / "build" / "audio_en"
PAKET = ROOT / "build" / "velvetpulse-audio-en.zip"
# Paketversion: muss zu AudioPaket.version in lib/services/sprachausgabe.dart passen.
# 2: Spicy-Bausteine und Kurse 23/24 dazu (Aufnahmen aus 1 bleiben, es wird nur ergänzt).
VERSION = "2"
STIMMEN = {"victoria": "af_heart", "martin": "am_michael"}
SR = 24000


class Englisch:
    def __init__(self):
        from kokoro import KPipeline
        self.pipe = KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")

    def wav(self, text, name, pfad, pause=True):
        import numpy as np
        import soundfile as sf

        stille = np.zeros(int(de.PARAGRAPH_PAUSE_S * SR), dtype=np.float32)
        teile = de.alternate_voices(text) if name == de.BOTH else [(name, text)]
        stuecke = []
        for stimme, abschnitt in teile:
            for absatz in [a for a in abschnitt.split("\n") if a.strip()]:
                for r in self.pipe(absatz, voice=STIMMEN[stimme], speed=de.SPEED):
                    stuecke.append(r.audio.numpy())
                if pause:
                    stuecke.append(stille)
        audio = np.concatenate(stuecke)
        sf.write(pfad, audio, SR)
        return int(len(audio) / SR * 1000)


def sprechtext(lesson):
    inhalt = re.sub(r"\{(?:W2|M2|W|M|P):([^{}]*)\}", r"\1", lesson["content"])
    zeilen = []
    for z in inhalt.split("\n"):
        z = z.strip()
        if z and not re.search(r"[.!?:…“”\"')]$", z):
            z += "."
        zeilen.append(z)
    return (f"{lesson['title']}.\n\n" + "\n".join(zeilen)).replace("&", "and")


def aufnehmen(engine, text, name, ziel, pause=True):
    """Spricht ein, falls die Datei noch fehlt. Gibt die Länge in ms zurück (oder None, wenn vorhanden)."""
    if ziel.exists():
        return None
    ziel.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        wav = Path(tmp) / "x.wav"
        ms = engine.wav(text, name, wav, pause=pause)
        de.to_opus(wav, ziel)
    return ms


def bausteine(engine, quelle, ordner):
    bloecke = json.loads((EN / quelle).read_text(encoding="utf-8"))["bausteine"]
    dauer_pfad = ZIEL / "audio" / ordner / "dauer.json"
    dauer = json.loads(dauer_pfad.read_text(encoding="utf-8")) if dauer_pfad.exists() else {}
    for name in STIMMEN:
        for b in bloecke:
            ziel = ZIEL / "audio" / ordner / f"{name}_{b['id']}.opus"
            ms = aufnehmen(engine, b["text"], name, ziel, pause=False)
            if ms is not None:
                dauer[ziel.stem] = ms
                dauer_pfad.write_text(json.dumps(dict(sorted(dauer.items())), indent=1), encoding="utf-8")
                print(f"{ordner}: {ziel.name}", flush=True)


def alles():
    engine = Englisch()
    # Ansagen des Beckenboden-Timers: Texte aus der englischen Oberfläche (lib/l10n/app_en.arb, cue*)
    arb = json.loads((ROOT / "lib/l10n/app_en.arb").read_text(encoding="utf-8"))
    cues = {re.sub(r"(?<!^)([A-Z])", r"_\1", k[3:]).lower(): v for k, v in arb.items() if k.startswith("cue")}
    namen = {"einatmen_weit", "weich_bleiben", "anspannen", "halten", "loslassen", "nachspueren", "an", "los",
             "welle", "seufzen", "start", "fertig"}
    assert set(cues) == namen, sorted(set(cues) ^ namen)
    for name in STIMMEN:
        for cue, text in cues.items():
            if aufnehmen(engine, text, name, ZIEL / "audio" / "cues" / f"{name}_{cue}.opus", pause=False) is not None:
                print(f"cue: {name}_{cue}", flush=True)
    bausteine(engine, "paar_abend.json", "paar")
    bausteine(engine, "selbst_reise.json", "selbst")
    data = json.loads((EN / "velvet_content.json").read_text(encoding="utf-8"))
    for kurs in data["courses"]:
        for lesson in kurs["lessons"]:
            name = de.voice_for(kurs, lesson)
            ziel = ZIEL / "audio" / f"{lesson['id']}.opus"
            if aufnehmen(engine, sprechtext(lesson), name, ziel) is not None:
                print(f"lektion: {lesson['id']} ({name})", flush=True)
    packen()


def packen():
    (ZIEL / "audio" / "version.txt").write_text(VERSION, encoding="utf-8")
    PAKET.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(PAKET, "w", compression=zipfile.ZIP_STORED) as z:  # Opus ist schon komprimiert
        for f in sorted(ZIEL.rglob("*")):
            if f.is_file():
                z.write(f, f.relative_to(ZIEL).as_posix())
    sha = hashlib.sha256(PAKET.read_bytes()).hexdigest()
    Path(str(PAKET) + ".sha256").write_text(f"{sha}  {PAKET.name}\n", encoding="ascii")
    print(f"Paket: {PAKET} ({PAKET.stat().st_size / 1e6:.1f} MB), sha256 {sha}")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    p = argparse.ArgumentParser()
    p.add_argument("--packen", action="store_true")
    a = p.parse_args()
    packen() if a.packen else alles()
