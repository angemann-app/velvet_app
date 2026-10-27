"""Spricht Lektionen aus assets/data/velvet_content.json neu ein.

Standard ist Kokoro mit deutschen Stimmen, lokal auf diesem Rechner:
  Victoria (kikiri-tts/kikiri-german-victoria) für Kurse mit category="women",
  beide im Wechsel (Absatz für Absatz) für category="couples",
  Martin   (kikiri-tts/kikiri-german-martin) für alle anderen.
  Eine Lektion kann mit "voice": "victoria" | "martin" | "both" abweichen.
Ergebnis: assets/audio/<lesson_id>.opus (Opus, 32 kbit/s, mono) per ffmpeg.

Kokoro braucht die deutschen Forks von kokoro/misaki, darum mit dieser Umgebung starten:
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py tease_1 tease_2
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --courses 8-17
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --all
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --zeige "liefern" "Pedal"
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --paar      (Paar-Abend, beide Stimmen)
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --selbst    (Selbsterkundung, beide Stimmen)
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --klang     (Klangschale, Klangteppich)

Aussprache-Fehler einzelner Wörter korrigiert tools/aussprache.json.
Mit --engine edge wird stattdessen Microsoft Edge TTS genutzt (Text geht an Microsoft).
"""
import argparse
import asyncio
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT_JSON = ROOT / "assets" / "data" / "velvet_content.json"
AUDIO_DIR = ROOT / "assets" / "audio"
LEXICON_JSON = Path(__file__).resolve().parent / "aussprache.json"

SPEED = 0.9
# Martin spricht bei gleichem Wert rund 12 % schneller als Victoria und wirkte hektisch,
# darum bekommt er überall ein eigenes, ruhigeres Tempo.
VOICE_SPEED = {"martin": 0.8}
PARAGRAPH_PAUSE_S = 0.6
SAMPLE_RATE = 24000

KOKORO_VOICES = {
    "victoria": ("kikiri-tts/kikiri-german-victoria", "kikiri_german_victoria_ep10.pth", "voices/victoria.pt"),
    "martin": ("kikiri-tts/kikiri-german-martin", "kikiri_german_martin_ep10.pth", "voices/martin.pt"),
}
EDGE_VOICES = {"victoria": "de-DE-SeraphinaMultilingualNeural", "martin": "de-DE-FlorianMultilingualNeural"}


BOTH = "both"  # Victoria und Martin wechseln sich Absatz für Absatz ab


def voice_for(course, lesson=None):
    # Eine Lektion kann ihre Stimme selbst festlegen (Feld "voice"), sonst entscheidet der Kurs:
    # Frauen-Kurse spricht Victoria, Paar-Kurse beide im Wechsel, alle anderen Martin.
    if lesson and (lesson.get("voice") in KOKORO_VOICES or lesson.get("voice") == BOTH):
        return lesson["voice"]
    category = course.get("category")
    return {"women": "victoria", "couples": BOTH}.get(category, "martin")


def alternate_voices(text):
    """Teilt einen Lektionstext in (Stimme, Abschnitt)-Paare für das Einsprechen mit zwei Stimmen.

    Gewechselt wird an jedem Absatz; eine kurze Zwischenüberschrift bleibt bei dem Absatz, der ihr folgt,
    damit nicht eine Stimme die Überschrift und die andere den Inhalt spricht.
    """
    lines = [l for l in text.split("\n") if l.strip()]
    sections, pending = [], []
    for line in lines:
        pending.append(line)
        if len(line) >= 60:
            sections.append("\n".join(pending))
            pending = []
    if pending:
        sections.append("\n".join(pending))
    names = list(KOKORO_VOICES)
    return [(names[i % 2], s) for i, s in enumerate(sections)]


def speech_text(lesson):
    # Platzhalter für den Namen des Gegenübers ({W:sie}, {P:dein Gegenüber} …) werden neutral
    # eingesprochen; personalisiert wird nur der angezeigte Text (lib/services/personalize.dart).
    content = re.sub(r"\{(?:W2|M2|W|M|P):([^{}]*)\}", r"\1", lesson["content"])
    lines = []
    for line in content.split("\n"):
        line = line.strip()
        # Zwischenüberschriften ("Warum das wirkt") bekommen einen Punkt, damit die Stimme absetzt.
        if line and not re.search(r"[.!?:…“”\"')]$", line):
            line += "."
        lines.append(line)
    text = f"{lesson['title']}.\n\n" + "\n".join(lines)
    return text.replace("&", "und")


def _demote_extra_stress(token: str) -> str:
    # espeak betont "-ität"-Wörter doppelt ("aktˈiːviːtˈɛːt"); nur die letzte Silbe trägt den Hauptakzent.
    if token.rstrip(".,!?;:)").endswith("ˈɛːt") and token.count("ˈ") > 1:
        last = token.rfind("ˈ")
        token = token[:last].replace("ˈ", "ˌ") + token[last:]
    return token


def fix_phonemes(ps: str) -> str:
    # Die deutschen Kokoro-Modelle bekommen von misaki englisch gefärbte Vokale:
    # "-er" als ɜ statt ɐ und "a" als ɑ. Im Hörtest klang die Korrektur deutlich natürlicher.
    # ʏ kennt Kokoros Vokabular nicht.
    ps = ps.replace("ɜ", "ɐ").replace("ɑ", "a").replace("ʏ", "y")
    return re.sub(r"\S+", lambda m: _demote_extra_stress(m.group()), ps)


MAX_PHONEMES = 400  # Kokoro verarbeitet höchstens 510 Lautzeichen pro Durchgang


def _chunks(ps: str):
    """Teilt Lautschrift an Satzenden (notfalls an Kommas) in Stücke unter MAX_PHONEMES."""
    sentences = re.split(r"(?<=[.!?…])\s+", ps)
    parts = []
    for sentence in sentences:
        if len(sentence) <= MAX_PHONEMES:
            parts.append(sentence)
        else:
            parts.extend(re.split(r"(?<=,)\s+", sentence))
    chunk = ""
    for part in parts:
        if chunk and len(chunk) + 1 + len(part) > MAX_PHONEMES:
            yield chunk
            chunk = part
        else:
            chunk = f"{chunk} {part}".strip()
    if chunk:
        yield chunk


class Kokoro:
    def __init__(self):
        import espeakng_loader

        os.environ.setdefault("PHONEMIZER_ESPEAK_LIBRARY", espeakng_loader.get_library_path())
        os.environ.setdefault("ESPEAK_DATA_PATH", espeakng_loader.get_data_path())

        import misaki.de
        import torch
        from huggingface_hub import hf_hub_download
        from kokoro import KModel, KPipeline

        self.torch, self.hf, self.KModel, self.KPipeline = torch, hf_hub_download, KModel, KPipeline
        self.config = hf_hub_download("Thorsten-Voice/Kokoro", "config.json")  # unverändertes Kokoro-82M-Config
        self.cache = {}

        # Projekt-Wörterbuch in misakis Ausnahmeliste einspielen.
        lexicon = json.loads(LEXICON_JSON.read_text(encoding="utf-8"))
        for word, phonemes in lexicon.items():
            if not word.startswith("_"):
                misaki.de._OVERRIDES[misaki.de.normalize_for_lookup(word)] = phonemes

    def _load(self, name):
        if name not in self.cache:
            repo, model_file, voice_file = KOKORO_VOICES[name]
            model = self.KModel(repo_id="hexgrad/Kokoro-82M", config=self.config,
                                model=self.hf(repo, model_file)).eval()
            pipeline = self.KPipeline(lang_code="d", repo_id="hexgrad/Kokoro-82M", model=model)
            pack = self.torch.load(self.hf(repo, voice_file), map_location="cpu", weights_only=True)
            self.cache[name] = (pipeline, pack)
        return self.cache[name]

    def phonemes(self, text, name="martin"):
        pipeline, _ = self._load(name)
        # Bindestrich-Wörter in Teile zerlegen, damit das Wörterbuch auch "Prostata-Stimulation" erfasst.
        text = re.sub(r"(?<=\w)-(?=\w)", " ", text)
        ps, _ = pipeline.g2p(text)
        return fix_phonemes(ps)

    def _speak(self, text, name, pause):
        import numpy as np

        pipeline, pack = self._load(name)
        speed = VOICE_SPEED.get(name, SPEED)
        silence = np.zeros(int(PARAGRAPH_PAUSE_S * SAMPLE_RATE), dtype=np.float32)
        pieces = []
        for paragraph in [p for p in text.split("\n") if p.strip()]:
            for chunk in _chunks(self.phonemes(paragraph, name)):
                for result in pipeline.generate_from_tokens(chunk, voice=pack, speed=speed):
                    pieces.append(result.audio.numpy())
            if pause:
                pieces.append(silence)
        return pieces

    def synthesize_wav(self, text, name, wav_path, pause=True):
        import numpy as np
        import soundfile as sf

        if name == BOTH:
            pieces = [p for voice, section in alternate_voices(text) for p in self._speak(section, voice, pause)]
        else:
            pieces = self._speak(text, name, pause)
        sf.write(wav_path, np.concatenate(pieces), SAMPLE_RATE)


async def edge_synthesize(text, name, out_path):
    import edge_tts

    await edge_tts.Communicate(text, EDGE_VOICES[name], rate="-12%", pitch="-4Hz").save(str(out_path))


def to_opus(src, out):
    subprocess.run(
        ["ffmpeg", "-y", "-loglevel", "error", "-i", str(src),
         "-c:a", "libopus", "-b:a", "32k", "-ac", "1", "-ar", "48000", str(out)],
        check=True,
    )


SUSPICIOUS = [
    (re.compile(r"ˈ.*ˈ"), "zwei Hauptbetonungen"),
    (re.compile(r"tj[ˈˌ]?oːn"), "-tion als „tjon“ statt „tsjon“"),
    (re.compile(r"[ðθæʌɹ]"), "englischer Laut"),
    (re.compile(r"^[^ˈ]*$"), "keine Betonung"),
]


def check_pronunciation(data):
    """Listet Wörter mit verdächtiger Lautschrift, damit sie in aussprache.json korrigiert werden können."""
    sys.stdout.reconfigure(encoding="utf-8")
    words = {}
    for course in data["courses"]:
        for lesson in course["lessons"]:
            for word in re.findall(r"[A-Za-zÄÖÜäöüß]+(?:-[A-Za-zÄÖÜäöüß]+)*", speech_text(lesson)):
                if len(word) >= 7:  # kurze Wörter sind praktisch immer richtig
                    words.setdefault(word.lower(), (word, lesson["id"]))
    engine = Kokoro()
    hits = 0
    for word, lesson_id in sorted(words.values()):
        ps = engine.phonemes(word)
        reasons = [label for pattern, label in SUSPICIOUS if pattern.search(ps)]
        if reasons:
            hits += 1
            print(f"{word:32} {ps:36} {', '.join(reasons)}  ({lesson_id})")
    print(f"\n{hits} verdächtige von {len(words)} geprüften Wörtern.")


# Ansagen für den Beckenboden-Timer (lib/screens/training/kegel_timer_view.dart, Feld "cue").
CUES = {
    "einatmen_weit": "Einatmen. Und weit werden.",
    "weich_bleiben": "Weich bleiben.",
    "anspannen": "Anspannen. Und sanft heben.",
    "halten": "Halten. Weiter atmen.",
    "loslassen": "Und ganz loslassen.",
    "nachspueren": "Nachspüren.",
    "an": "An.",
    "los": "Los.",
    "welle": "Einatmen. Damm und Po weich.",
    "seufzen": "Ausatmen. Lang und hörbar.",
    "start": "Wir beginnen.",
    "fertig": "Geschafft. Spür noch einen Moment nach.",
}


def generate_cues(voices=None):
    out_dir = AUDIO_DIR / "cues"
    out_dir.mkdir(exist_ok=True)
    engine = Kokoro()
    for name in voices or KOKORO_VOICES:
        for cue, text in CUES.items():
            out = out_dir / f"{name}_{cue}.opus"
            with tempfile.TemporaryDirectory() as tmp:
                wav = Path(tmp) / "cue.wav"
                engine.synthesize_wav(text, name, wav, pause=False)
                to_opus(wav, out)
            print(f"{out.name} -> {out.stat().st_size // 1024} KB", flush=True)


PAAR_JSON = ROOT / "assets" / "data" / "paar_abend.json"
SELBST_JSON = ROOT / "assets" / "data" / "selbst_reise.json"


def generate_blocks(only=None, source=PAAR_JSON, folder="paar", voices=None, pause=False, blocks=None, out_dir=None):
    # Bausteine für den Paar-Abend (lib/screens/couples_channel/paar_abend_screen.dart) bzw. die
    # geführte Selbsterkundung (lib/screens/self_exploration/selbst_reise_screen.dart), jeweils beide Stimmen.
    # Mit blocks und out_dir für Inhalte außerhalb des Repositorys (siehe generate_lust).
    out_dir = out_dir or AUDIO_DIR / folder
    out_dir.mkdir(parents=True, exist_ok=True)
    if blocks is None:
        blocks = json.loads(source.read_text(encoding="utf-8"))["bausteine"]
    if only:
        blocks = [b for b in blocks if b["id"] in only]
    import soundfile as sf

    # Die App plant die Stillen anhand der echten Längen, darum landen sie in dauer.json (Millisekunden).
    durations_json = out_dir / "dauer.json"
    durations = json.loads(durations_json.read_text(encoding="utf-8")) if durations_json.exists() else {}
    engine = Kokoro()
    voices = voices or list(KOKORO_VOICES)
    total = len(blocks) * len(voices)
    i = 0
    for name in voices:
        for block in blocks:
            i += 1
            out = out_dir / f"{name}_{block['id']}.opus"
            with tempfile.TemporaryDirectory() as tmp:
                wav = Path(tmp) / "block.wav"
                engine.synthesize_wav(block["text"], name, wav, pause=pause)
                durations[out.stem] = int(sf.info(str(wav)).duration * 1000)
                to_opus(wav, out)
            durations_json.write_text(json.dumps(dict(sorted(durations.items())), indent=1), encoding="utf-8")
            print(f"[{i}/{total}] {out.name} -> {out.stat().st_size // 1024} KB", flush=True)


EINSCHLAF_JSON = ROOT / "assets" / "data" / "einschlaf_reise.json"


def generate_einschlaf(only=None, voices=None, source=None, folder="einschlaf", blocks=None, out_dir=None):
    """Einschlaf-Reise (lib/screens/self_exploration/einschlaf_reise_screen.dart): wie die Selbsterkundung,
    aber deutlich langsamer gesprochen und mit längeren Pausen zwischen den Absätzen."""
    global SPEED, VOICE_SPEED, PARAGRAPH_PAUSE_S
    alt = SPEED, VOICE_SPEED, PARAGRAPH_PAUSE_S
    SPEED, VOICE_SPEED, PARAGRAPH_PAUSE_S = 0.75, {"martin": 0.7}, 1.5
    try:
        generate_blocks(only, source or EINSCHLAF_JSON, folder, voices, pause=True, blocks=blocks, out_dir=out_dir)
    finally:
        SPEED, VOICE_SPEED, PARAGRAPH_PAUSE_S = alt


# „Lust im Traum“ (docs/konzepte/lust-im-traum.md): Texte und Aufnahmen bleiben außerhalb des Repositorys und
# kommen nur als Paket über Cloudflare R2. Ausgabe nennt nur Dateinamen, keine Texte.
LUST_ORDNER = Path(r"C:\TOOLS\velvet-inhalte\lust")


def generate_lust(only=None, voices=None):
    blocks = json.loads((LUST_ORDNER / "lust.json").read_text(encoding="utf-8"))["de"]
    generate_einschlaf(only, voices, blocks=blocks, out_dir=LUST_ORDNER / "audio")


def generate_sounds():
    """Klangschale für Übergänge und ein ruhiger, nahtlos loopender Klangteppich für die Stillen."""
    import numpy as np
    import soundfile as sf

    out_dir = AUDIO_DIR / "paar"
    out_dir.mkdir(exist_ok=True)
    rng = np.random.default_rng(7)
    sr = 48000

    # Klangschale: leicht unharmonische Teiltöne mit langem Ausklang.
    t = np.arange(int(sr * 6)) / sr
    bowl = sum(a * np.sin(2 * np.pi * f * t) * np.exp(-t / d)
               for f, a, d in [(220, 1.0, 2.6), (221.6, 0.6, 2.4), (598, 0.45, 1.6), (1131, 0.22, 0.9), (1795, 0.1, 0.5)])
    bowl *= np.minimum(1, t / 0.004)  # weicher Anschlag ohne Knacken
    bowl = 0.5 * bowl / np.abs(bowl).max()

    # Klangteppich: 60 s, alle Frequenzen mit ganzzahligen Perioden, damit die Schleife nahtlos ist.
    n = sr * 60
    t = np.arange(n) / sr
    pad = np.zeros(n)
    for f, a, lfo in [(55, 0.5, 2), (110, 0.35, 3), (164, 0.18, 5), (220, 0.12, 4), (277, 0.06, 7)]:
        pad += a * np.sin(2 * np.pi * f * t) * (0.6 + 0.4 * np.sin(2 * np.pi * lfo * t / 60))
    # Weiches Rauschen wie fernes Meer, periodisch erzeugt über das Spektrum.
    spec = np.zeros(n // 2 + 1, dtype=complex)
    freqs = np.fft.rfftfreq(n, 1 / sr)
    band = (freqs > 40) & (freqs < 900)
    spec[band] = (rng.normal(size=band.sum()) + 1j * rng.normal(size=band.sum())) / np.sqrt(freqs[band])
    noise = np.fft.irfft(spec, n)
    noise *= 0.25 / np.abs(noise).max() * (0.55 + 0.45 * np.sin(2 * np.pi * 6 * t / 60))
    pad = pad / np.abs(pad).max() * 0.22 + noise

    with tempfile.TemporaryDirectory() as tmp:
        for name, audio in [("klangschale", bowl), ("klangteppich", pad)]:
            wav = Path(tmp) / f"{name}.wav"
            sf.write(wav, audio.astype(np.float32), sr)
            out = out_dir / f"{name}.opus"
            to_opus(wav, out)
            print(f"{out.name} -> {out.stat().st_size // 1024} KB", flush=True)


def select(data, args):
    picked = []
    for course in data["courses"]:
        number = int(re.match(r"(\d+)\.", course["title"]).group(1))
        for lesson in course["lessons"]:
            if (args.all
                    or lesson["id"] in args.ids
                    or (args.courses and args.courses[0] <= number <= args.courses[1])):
                picked.append((course, lesson))
    return picked


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("ids", nargs="*")
    parser.add_argument("--courses", type=lambda s: tuple(int(x) for x in s.split("-")))
    parser.add_argument("--all", action="store_true")
    parser.add_argument("--engine", choices=["kokoro", "edge"], default="kokoro")
    parser.add_argument("--zeige", nargs="+", metavar="WORT", help="nur die Lautschrift anzeigen")
    parser.add_argument("--pruefe", action="store_true",
                        help="alle Wörter aller Lektionen auf verdächtige Lautschrift prüfen")
    parser.add_argument("--ansagen", action="store_true",
                        help="kurze Ansagen für den Beckenboden-Timer erzeugen (assets/audio/cues/)")
    parser.add_argument("--paar", action="store_true",
                        help="Bausteine des Paar-Abends erzeugen (assets/audio/paar/), optional nur die genannten ids")
    parser.add_argument("--selbst", action="store_true",
                        help="Bausteine der Selbsterkundung erzeugen (assets/audio/selbst/), optional nur die genannten ids")
    parser.add_argument("--traum", action="store_true",
                        help="Bausteine der Traum-Reise erzeugen (assets/audio/traum/, Tempo wie Einschlaf-Reise), optional nur die genannten ids")
    parser.add_argument("--einschlaf", action="store_true",
                        help="Bausteine der Einschlaf-Reise erzeugen (assets/audio/einschlaf/), optional nur die genannten ids")
    parser.add_argument("--lust", action="store_true",
                        help="„Lust im Traum“ erzeugen (aus und nach C:\\TOOLS\\velvet-inhalte\\lust, nie ins Repository), optional nur die genannten ids")
    parser.add_argument("--klang", action="store_true", help="Klangschale und Klangteppich erzeugen")
    parser.add_argument("--stimme", choices=list(KOKORO_VOICES),
                        help="nur Aufnahmen mit dieser Stimme erneuern (Lektionen im Wechsel zählen mit)")
    args = parser.parse_args()
    voices = [args.stimme] if args.stimme else None
    if args.klang:
        generate_sounds()
        return
    if args.paar:
        generate_blocks(set(args.ids), voices=voices)
        return
    if args.selbst:
        generate_blocks(set(args.ids), SELBST_JSON, "selbst", voices)
        return
    if args.einschlaf:
        generate_einschlaf(set(args.ids), voices)
        return
    if args.traum:
        generate_einschlaf(set(args.ids), voices, ROOT / "assets" / "data" / "traum_reise.json", "traum")
        return
    if args.lust:
        generate_lust(set(args.ids), voices)
        return
    if args.courses and len(args.courses) == 1:
        args.courses = (args.courses[0], args.courses[0])

    if args.zeige:
        sys.stdout.reconfigure(encoding="utf-8")
        engine = Kokoro()
        for word in args.zeige:
            print(f"{word:30} {engine.phonemes(word)}")
        return

    if args.ansagen:
        generate_cues(voices)
        return

    data = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))

    if args.pruefe:
        check_pronunciation(data)
        return

    picked = select(data, args)
    if args.stimme:
        picked = [(c, l) for c, l in picked if voice_for(c, l) in (args.stimme, BOTH)]
    unknown = set(args.ids) - {l["id"] for _, l in picked}
    if unknown or not picked:
        sys.exit(f"Keine oder unbekannte Lektionen: {sorted(unknown)}")

    engine = Kokoro() if args.engine == "kokoro" else None
    for i, (course, lesson) in enumerate(picked, 1):
        name = voice_for(course, lesson)
        out = AUDIO_DIR / f"{lesson['id']}.opus"
        with tempfile.TemporaryDirectory() as tmp:
            if engine:
                src = Path(tmp) / "speech.wav"
                engine.synthesize_wav(speech_text(lesson), name, src)
            else:
                src = Path(tmp) / "speech.mp3"
                asyncio.run(edge_synthesize(speech_text(lesson), "martin" if name == BOTH else name, src))
            to_opus(src, out)
        print(f"[{i}/{len(picked)}] {lesson['id']} ({name}) -> {out.stat().st_size // 1024} KB", flush=True)


if __name__ == "__main__":
    main()
