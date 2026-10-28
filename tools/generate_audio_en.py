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
# 3: wildere Spicy-Bausteine, Kurse 25/26, Spicy-Lektionen; geänderte Texte werden neu eingesprochen.
VERSION = "3"
STIMMEN = {"victoria": "af_heart", "martin": "am_michael"}
SR = 24000
LANGSAM = "langsam"
# Geführte Audios mit eigener dauer.json (die App plant die Stillen danach).
MIT_DAUER = ("paar", "selbst", "einschlaf", "traum")


class Englisch:
    def __init__(self):
        from kokoro import KPipeline
        self.pipe = KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")

    def wav(self, text, name, pfad, pause=True):
        import numpy as np
        import soundfile as sf

        # pause == LANGSAM: Tempo und Absatzpausen der Einschlaf-Reise (wie generate_audio.generate_einschlaf).
        langsam = pause == LANGSAM
        stille = np.zeros(int((1.5 if langsam else de.PARAGRAPH_PAUSE_S) * SR), dtype=np.float32)
        teile = de.alternate_voices(text) if name == de.BOTH else [(name, text)]
        stuecke = []
        for stimme, abschnitt in teile:
            tempo = (0.7 if stimme == "martin" else 0.75) if langsam else de.SPEED
            for absatz in [a for a in abschnitt.split("\n") if a.strip()]:
                for r in self.pipe(absatz, voice=STIMMEN[stimme], speed=tempo):
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


# Merkt sich pro Aufnahme eine Prüfsumme über Text, Stimme und Tempo: Ändert sich ein Text, wird neu
# eingesprochen. Liegt neben dem Paket, nicht darin.
TEXTE = ROOT / "build" / "audio_en_texte.json"
# Stand, aus dem die Aufnahmen von Paket 1 und 2 stammen (für Dateien, die noch keine Prüfsumme haben).
GRUNDSTAND = "6751a39"


def pruefsumme(text, name, pause):
    return hashlib.sha256(f"{name}|{de.SPEED}|{pause}|{text}".encode("utf-8")).hexdigest()[:16]


def auftraege(lesen):
    """Alle Aufnahmen des Pakets: {relativer Pfad: (Text, Stimme, Pause)}. [lesen] liefert eine Datei als Text."""
    auf = {}
    # Ansagen des Beckenboden-Timers: Texte aus der englischen Oberfläche (lib/l10n/app_en.arb, cue*)
    arb = json.loads(lesen("lib/l10n/app_en.arb"))
    cues = {re.sub(r"(?<!^)([A-Z])", r"_\1", k[3:]).lower(): v for k, v in arb.items() if k.startswith("cue")}
    namen = {"einatmen_weit", "weich_bleiben", "anspannen", "halten", "loslassen", "nachspueren", "an", "los",
             "welle", "seufzen", "start", "fertig"}
    assert set(cues) == namen, sorted(set(cues) ^ namen)
    for name in STIMMEN:
        for cue, text in cues.items():
            auf[f"cues/{name}_{cue}.opus"] = (text, name, False)
    for quelle, ordner in (("paar_abend.json", "paar"), ("selbst_reise.json", "selbst")):
        for name in STIMMEN:
            for b in json.loads(lesen(f"translations/en/{quelle}"))["bausteine"]:
                auf[f"{ordner}/{name}_{b['id']}.opus"] = (b["text"], name, False)
    for kurs in json.loads(lesen("translations/en/velvet_content.json"))["courses"]:
        for lesson in kurs["lessons"]:
            auf[f"{lesson['id']}.opus"] = (sprechtext(lesson), de.voice_for(kurs, lesson), True)
    # Einschlaf- und Traum-Reise langsam; fehlen im Grundstand und kommen dort einfach nicht vor.
    for quelle, ordner in (("einschlaf_reise.json", "einschlaf"), ("traum_reise.json", "traum")):
        try:
            bausteine = json.loads(lesen(f"translations/en/{quelle}"))["bausteine"]
        except Exception:  # noqa: BLE001
            continue
        for name in STIMMEN:
            for b in bausteine:
                auf[f"{ordner}/{name}_{b['id']}.opus"] = (b["text"], name, LANGSAM)
    return auf


def grundstand():
    """Prüfsummen der Aufnahmen, wie sie aus dem Stand GRUNDSTAND entstanden sind."""
    import subprocess

    def lesen(pfad):
        return subprocess.run(["git", "show", f"{GRUNDSTAND}:{pfad}"], cwd=ROOT, capture_output=True,
                              check=True).stdout.decode("utf-8")
    return {pfad: pruefsumme(*a) for pfad, a in auftraege(lesen).items()}


def aufnehmen(auf, audio, texte_datei, texte, ordner_mit_dauer, hoechstens=None):
    """Spricht alle neuen oder geänderten Aufnahmen ein (setzt fort). Gibt die Zahl der noch offenen zurück."""
    engine = Englisch()
    # Aufnahmen, deren Text es nicht mehr gibt, kommen raus.
    for f in audio.rglob("*.opus"):
        if f.relative_to(audio).as_posix() not in auf:
            f.unlink()
            print(f"entfernt: {f.relative_to(audio).as_posix()}", flush=True)
    dauern = {}
    for ordner in ordner_mit_dauer:
        p = audio / ordner / "dauer.json"
        dauern[ordner] = json.loads(p.read_text(encoding="utf-8")) if p.exists() else {}
        dauern[ordner] = {k: v for k, v in dauern[ordner].items()
                          if (f"{ordner}/{k}.opus" if ordner else f"{k}.opus") in auf}
    offen = [p for p, a in auf.items() if not (audio / p).exists() or texte.get(p) != pruefsumme(*a)]
    print(f"{len(offen)} von {len(auf)} Aufnahmen neu", flush=True)
    jetzt = offen[:hoechstens] if hoechstens else offen

    def dauern_schreiben():
        for ordner, dauer in dauern.items():
            (audio / ordner).mkdir(parents=True, exist_ok=True)
            (audio / ordner / "dauer.json").write_text(json.dumps(dict(sorted(dauer.items())), indent=1),
                                                       encoding="utf-8")

    for i, pfad in enumerate(jetzt, 1):
        text, name, pause = auf[pfad]
        ziel = audio / pfad
        ziel.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory() as tmp:
            wav = Path(tmp) / "x.wav"
            ms = engine.wav(text, name, wav, pause=pause)
            de.to_opus(wav, ziel)
        texte[pfad] = pruefsumme(text, name, pause)
        texte_datei.write_text(json.dumps(dict(sorted(texte.items())), indent=1), encoding="utf-8")
        ordner = pfad.rsplit("/", 1)[0] if "/" in pfad else ""
        if ordner in dauern:
            dauern[ordner][ziel.stem] = ms
            dauern_schreiben()
        print(f"[{i}/{len(jetzt)}] {pfad} ({name})", flush=True)
    dauern_schreiben()
    texte_datei.write_text(json.dumps(dict(sorted({p: texte[p] for p in auf if p in texte}.items())), indent=1),
                           encoding="utf-8")
    rest = len(offen) - len(jetzt)
    print(f"noch offen: {rest}", flush=True)
    return rest


def alles(hoechstens=None):
    auf = auftraege(lambda pfad: (ROOT / pfad).read_text(encoding="utf-8"))
    texte = json.loads(TEXTE.read_text(encoding="utf-8")) if TEXTE.exists() else grundstand()
    if aufnehmen(auf, ZIEL / "audio", TEXTE, texte, MIT_DAUER, hoechstens) == 0:
        packen()


# „Lust im Traum“: Texte und Aufnahmen nur außerhalb des Repositorys (wie generate_audio.generate_lust).
def lust(hoechstens=None):
    auf = {f"{name}_{b['id']}.opus": (b["text"], name, LANGSAM)
           for name in STIMMEN
           for b in json.loads((de.LUST_ORDNER / "lust.json").read_text(encoding="utf-8"))["en"]}
    texte_datei = de.LUST_ORDNER / "audio_en_texte.json"
    texte = json.loads(texte_datei.read_text(encoding="utf-8")) if texte_datei.exists() else {}
    aufnehmen(auf, de.LUST_ORDNER / "audio_en", texte_datei, texte, ("",), hoechstens)


# Audioreihe „Innenansichten“: Englisch nach REIHE_ORDNER\audio_en, setzt fort (Prüfsumme je Aufnahme).
def reihe(hoechstens=None):
    auf = {k: (t, n, True) for k, (t, n) in de.reihe_auftraege("en").items()}
    texte_datei = de.REIHE_ORDNER / "audio_en_texte.json"
    texte = json.loads(texte_datei.read_text(encoding="utf-8")) if texte_datei.exists() else {}
    aufnehmen(auf, de.REIHE_ORDNER / "audio_en", texte_datei, texte, ("",), hoechstens)


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
    p.add_argument("--lust", action="store_true", help="„Lust im Traum“ (nach C:\\TOOLS\\velvet-inhalte\\lust\\audio_en)")
    p.add_argument("--reihe", action="store_true", help="Audioreihe „Innenansichten“ (nach C:\\TOOLS\\velvet-inhalte\\reihe\\audio_en)")
    p.add_argument("--hoechstens", type=int, help="nur so viele Aufnahmen in diesem Lauf (setzt beim nächsten fort)")
    a = p.parse_args()
    if a.packen:
        packen()
    elif a.lust:
        lust(a.hoechstens)
    elif a.reihe:
        reihe(a.hoechstens)
    else:
        alles(a.hoechstens)
