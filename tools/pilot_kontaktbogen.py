"""Legt je Bildschirm die Darstellungen eines Screenshot-Satzes nebeneinander auf einen Bogen (Kontaktbogen).

  python tools/pilot_kontaktbogen.py
  python tools/pilot_kontaktbogen.py --nur start,profil

Quelle: build/screens (Papier), build/screens_nacht (Nachtpapier), build/screens_spicy (Spicy),
        optional build/screens_klassisch (Klassisch); PNG mit gleichem Dateinamen, je 390 x 844.
Ziel:   build/pilot/<dateiname>.png

Ein Bogen entsteht für jeden Dateinamen, der in mindestens zwei Ordnern vorkommt. Die vorhandenen
Fassungen stehen von links nach rechts in der Reihenfolge Papier, Nachtpapier, Spicy, Klassisch,
mit 24 px Abstand und 24 px Rand auf neutralem Grau (#888888). Über jedem Bild steht die Beschriftung
in der Pillow-Standardschrift. Ohne --nur werden alle gemeinsamen Dateien verarbeitet.
"""
import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

WURZEL = Path(__file__).resolve().parent.parent
QUELLEN = [
    ("Papier", "screens"),
    ("Nachtpapier", "screens_nacht"),
    ("Spicy", "screens_spicy"),
    ("Klassisch", "screens_klassisch"),
]
ZIEL = WURZEL / "build" / "pilot"
RAND = 24
ABSTAND = 24
LABEL_HOEHE = 18
LABEL_ABSTAND = 8
HINTERGRUND = (136, 136, 136)  # #888888, neutral
SCHRIFT_FARBE = (255, 255, 255)


def finde_bilder():
    """Ordnet jedem Dateinamen (ohne .png) die vorhandenen Fassungen nach Beschriftung zu."""
    gefunden = {}
    for beschriftung, ordner in QUELLEN:
        pfad = WURZEL / "build" / ordner
        if not pfad.is_dir():
            continue
        for datei in sorted(pfad.glob("*.png")):
            gefunden.setdefault(datei.stem, {})[beschriftung] = datei
    return gefunden


def namen_aus_argument(text):
    """Liest die Namensliste aus --nur (Komma getrennt, .png ist optional, Reihenfolge bleibt)."""
    namen = []
    for teil in text.split(","):
        name = teil.strip()
        if not name:
            continue
        if name.lower().endswith(".png"):
            name = name[:-4]
        if name not in namen:
            namen.append(name)
    return namen


def lade_fassungen(fassungen):
    """Lädt die vorhandenen Bilder in der festen Reihenfolge; unlesbare Dateien werden übersprungen."""
    geladen = []
    for beschriftung, _ in QUELLEN:
        pfad = fassungen.get(beschriftung)
        if pfad is None:
            continue
        try:
            with Image.open(pfad) as bild:
                geladen.append((beschriftung, bild.convert("RGBA")))
        except OSError as fehler:
            print(f"  {pfad.name} ({beschriftung}) nicht lesbar: {fehler}")
    return geladen


def textmasse(schrift, text):
    """Breite, Höhe und Versatz der Beschriftung in der Standardschrift."""
    links, oben, rechts, unten = schrift.getbbox(text)
    return links, oben, rechts - links, unten - oben


def baue_bogen(geladen, ziel):
    """Setzt die geladenen Fassungen nebeneinander und speichert den Bogen."""
    breite = max(bild.width for _, bild in geladen)
    hoehe = max(bild.height for _, bild in geladen)
    spalten = len(geladen)
    zell_hoehe = LABEL_HOEHE + LABEL_ABSTAND + hoehe
    bogen_breite = RAND * 2 + spalten * breite + (spalten - 1) * ABSTAND
    bogen_hoehe = RAND * 2 + zell_hoehe

    bogen = Image.new("RGB", (bogen_breite, bogen_hoehe), HINTERGRUND)
    zeichner = ImageDraw.Draw(bogen)
    schrift = ImageFont.load_default()

    for spalte, (beschriftung, bild) in enumerate(geladen):
        x = RAND + spalte * (breite + ABSTAND)

        links, oben, text_breite, text_hoehe = textmasse(schrift, beschriftung)
        text_x = x + (breite - text_breite) // 2 - links
        text_y = RAND + (LABEL_HOEHE - text_hoehe) // 2 - oben
        zeichner.text((text_x, text_y), beschriftung, font=schrift, fill=SCHRIFT_FARBE)

        bild_y = RAND + LABEL_HOEHE + LABEL_ABSTAND
        bogen.paste(bild, (x, bild_y), bild)

    ziel.parent.mkdir(parents=True, exist_ok=True)
    bogen.save(ziel)


def main():
    zerleger = argparse.ArgumentParser(description="Kontaktbögen der Screenshot-Fassungen erzeugen")
    zerleger.add_argument(
        "--nur",
        metavar="NAME1,NAME2",
        help="nur diese Dateinamen (ohne .png, durch Komma getrennt)",
    )
    argumente = zerleger.parse_args()

    gefunden = finde_bilder()
    gemeinsam = {name: fassungen for name, fassungen in gefunden.items() if len(fassungen) >= 2}

    if argumente.nur:
        gewaehlt = namen_aus_argument(argumente.nur)
        for name in gewaehlt:
            if name not in gemeinsam:
                print(f"Übersprungen: {name} (nicht in mindestens zwei Ordnern vorhanden)")
        gewaehlt = [name for name in gewaehlt if name in gemeinsam]
    else:
        gewaehlt = sorted(gemeinsam)

    if not gewaehlt:
        if argumente.nur:
            print("Keine der gewählten Dateien ist in mindestens zwei Ordnern vorhanden; nichts zu tun.")
        else:
            print("Keine gemeinsamen Dateien gefunden; nichts zu tun.")
        return

    ZIEL.mkdir(parents=True, exist_ok=True)
    erzeugt = 0
    for name in gewaehlt:
        geladen = lade_fassungen(gemeinsam[name])
        if len(geladen) < 2:
            print(f"Übersprungen: {name} (weniger als zwei lesbare Fassungen)")
            continue
        ziel = ZIEL / f"{name}.png"
        baue_bogen(geladen, ziel)
        erzeugt += 1
        print(f"{ziel.name}: {', '.join(beschriftung for beschriftung, _ in geladen)}")

    print(f"{erzeugt} Bögen erzeugt in {ZIEL}")


if __name__ == "__main__":
    main()
