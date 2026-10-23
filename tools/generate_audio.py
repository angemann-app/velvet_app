"""Spricht Lektionen aus assets/data/velvet_content.json neu ein.

Nutzt Microsoft Edge TTS (edge-tts, sendet den Text an Microsofts Dienst) und
wandelt das Ergebnis mit ffmpeg in assets/audio/<lesson_id>.opus um.

Aufruf:
  python tools/generate_audio.py tease_1 tease_2     # einzelne Lektionen
  python tools/generate_audio.py --courses 8-17      # ganze Kurse (Nummer laut Titel)
  python tools/generate_audio.py --all
"""
import argparse
import asyncio
import re
import subprocess
import sys
import tempfile
from pathlib import Path
import json

import edge_tts

ROOT = Path(__file__).resolve().parent.parent
CONTENT_JSON = ROOT / "assets" / "data" / "velvet_content.json"
AUDIO_DIR = ROOT / "assets" / "audio"

VOICE_WOMEN = "de-DE-SeraphinaMultilingualNeural"
VOICE_DEFAULT = "de-DE-ConradNeural"
RATE = "-12%"
PITCH = "-4Hz"


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


async def synthesize(lesson, voice):
    out = AUDIO_DIR / f"{lesson['id']}.opus"
    with tempfile.TemporaryDirectory() as tmp:
        mp3 = Path(tmp) / "speech.mp3"
        for attempt in range(3):
            try:
                await edge_tts.Communicate(speech_text(lesson), voice, rate=RATE, pitch=PITCH).save(str(mp3))
                break
            except Exception as e:  # Netzwerkfehler: kurz warten und erneut versuchen
                if attempt == 2:
                    raise
                print(f"  Fehler ({e}), neuer Versuch ...")
                await asyncio.sleep(3)
        subprocess.run(
            ["ffmpeg", "-y", "-loglevel", "error", "-i", str(mp3),
             "-c:a", "libopus", "-b:a", "32k", "-ac", "1", "-ar", "48000", str(out)],
            check=True,
        )
    return out


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


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("ids", nargs="*")
    parser.add_argument("--courses", type=lambda s: tuple(int(x) for x in s.split("-")))
    parser.add_argument("--all", action="store_true")
    args = parser.parse_args()
    if args.courses and len(args.courses) == 1:
        args.courses = (args.courses[0], args.courses[0])

    data = json.loads(CONTENT_JSON.read_text(encoding="utf-8"))
    picked = select(data, args)
    unknown = set(args.ids) - {l["id"] for _, l in picked}
    if unknown or not picked:
        sys.exit(f"Keine oder unbekannte Lektionen: {sorted(unknown)}")

    for i, (course, lesson) in enumerate(picked, 1):
        voice = VOICE_WOMEN if course.get("category") == "women" else VOICE_DEFAULT
        out = await synthesize(lesson, voice)
        print(f"[{i}/{len(picked)}] {lesson['id']} ({voice.split('-')[2]}) -> {out.stat().st_size // 1024} KB")


if __name__ == "__main__":
    asyncio.run(main())
