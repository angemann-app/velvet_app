"""Wandelt die fertigen Szenenbilder der Audioreihe in WebP um (Quelle und Ziel liegen außerhalb des Repositorys).

  C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe tools/bilder_webp.py

Quelle: C:\\TOOLS\\velvet-inhalte\\reihe\\bilder\\final\\<folge>_<variante>_<szene>.png (512 x 768, lokal erzeugt)
Ziel:   C:\\TOOLS\\velvet-inhalte\\reihe\\bilder\\webp\\<folge>_<variante>_<szene>.webp
Die Namen sind dieselben wie in ReiheDaten.bildPfad (ohne Ordner „bilder/“). Umwandlung mit ffmpeg (libwebp).
Konzept: docs/konzepte/lust-reihe-szenenbilder.md.
"""
import subprocess
from pathlib import Path

BILDER = Path(r"C:\TOOLS\velvet-inhalte\reihe\bilder")
QUALITAET = "88"


def main():
    quelle = BILDER / "final"
    ziel = BILDER / "webp"
    ziel.mkdir(parents=True, exist_ok=True)
    for alt in ziel.glob("*.webp"):
        alt.unlink()
    pngs = sorted(quelle.glob("*.png"))
    if not pngs:
        raise SystemExit(f"Keine Bilder in {quelle}")
    for png in pngs:
        webp = ziel / f"{png.stem}.webp"
        subprocess.run(
            ["ffmpeg", "-y", "-loglevel", "error", "-i", str(png), "-c:v", "libwebp", "-quality", QUALITAET, str(webp)],
            check=True,
        )
        print(f"{webp.name}: {webp.stat().st_size // 1024} KB")
    print(f"{len(pngs)} Bilder umgewandelt")


if __name__ == "__main__":
    main()
