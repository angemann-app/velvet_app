"""Spricht Lektionen aus assets/data/velvet_content.json neu ein.

Standard ist Kokoro mit deutschen Stimmen, lokal auf diesem Rechner:
  Victoria (kikiri-tts/kikiri-german-victoria) für Kurse mit category="women",
  Martin   (kikiri-tts/kikiri-german-martin) für alle anderen.
Ergebnis: assets/audio/<lesson_id>.opus (Opus, 32 kbit/s, mono) per ffmpeg.

Kokoro braucht die deutschen Forks von kokoro/misaki, darum mit dieser Umgebung starten:
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py tease_1 tease_2
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --courses 8-17
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --all
  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/generate_audio.py --zeige "liefern" "Pedal"

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
PARAGRAPH_PAUSE_S = 0.6
SAMPLE_RATE = 24000

KOKORO_VOICES = {
    "victoria": ("kikiri-tts/kikiri-german-victoria", "kikiri_german_victoria_ep10.pth", "voices/victoria.pt"),
    "martin": ("kikiri-tts/kikiri-german-martin", "kikiri_german_martin_ep10.pth", "voices/martin.pt"),
}
EDGE_VOICES = {"victoria": "de-DE-SeraphinaMultilingualNeural", "martin": "de-DE-FlorianMultilingualNeural"}


def voice_for(course):
    return "victoria" if course.get("category") == "women" else "martin"


def speech_text(lesson):
    lines = []
    for line in lesson["content"].split("\n"):
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

    def synthesize_wav(self, text, name, wav_path):
        import numpy as np
        import soundfile as sf

        pipeline, pack = self._load(name)
        pause = np.zeros(int(PARAGRAPH_PAUSE_S * SAMPLE_RATE), dtype=np.float32)
        pieces = []
        for paragraph in [p for p in text.split("\n") if p.strip()]:
            for chunk in _chunks(self.phonemes(paragraph, name)):
                for result in pipeline.generate_from_tokens(chunk, voice=pack, speed=SPEED):
                    pieces.append(result.audio.numpy())
            pieces.append(pause)
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
    args = parser.parse_args()
    if args.courses and len(args.courses) == 1:
        args.courses = (args.courses[0], args.courses[0])

    if args.zeige:
        sys.stdout.reconfigure(encoding="utf-8")
        engine = Kokoro()
        for word in args.zeige:
            print(f"{word:30} {engine.phonemes(word)}")
        return

    data = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))

    if args.pruefe:
        check_pronunciation(data)
        return

    picked = select(data, args)
    unknown = set(args.ids) - {l["id"] for _, l in picked}
    if unknown or not picked:
        sys.exit(f"Keine oder unbekannte Lektionen: {sorted(unknown)}")

    engine = Kokoro() if args.engine == "kokoro" else None
    for i, (course, lesson) in enumerate(picked, 1):
        name = voice_for(course)
        out = AUDIO_DIR / f"{lesson['id']}.opus"
        with tempfile.TemporaryDirectory() as tmp:
            if engine:
                src = Path(tmp) / "speech.wav"
                engine.synthesize_wav(speech_text(lesson), name, src)
            else:
                src = Path(tmp) / "speech.mp3"
                asyncio.run(edge_synthesize(speech_text(lesson), name, src))
            to_opus(src, out)
        print(f"[{i}/{len(picked)}] {lesson['id']} ({name}) -> {out.stat().st_size // 1024} KB", flush=True)


if __name__ == "__main__":
    main()
