"""Baut assets/data/bilder.json: das zentrale Bildregister (docs/konzepte/designsystem-magazin.md, Abschnitt 3.3).

Die Datei entsteht aus dem Bestand in assets/images und den Kursdaten (Alt-Texte aus den Titeln). Neue Bilder ergänzt man hier
(oder direkt in der JSON-Datei) und lässt `python tools/bilder_register.py --pruefen` laufen; die App liest nur die JSON-Datei.

  python tools/bilder_register.py            schreibt assets/data/bilder.json neu
  python tools/bilder_register.py --pruefen  vergleicht, ändert nichts (Exit 1 bei Abweichung)

Handgepflegte Einträge (Abschnitt "handgepflegt" unten) bleiben erhalten, auch wenn die Datei neu geschrieben wird.
"""
import json
import os
import re
import sys
from kursgrafiken_webp import eintrag as dekorativer_eintrag

WURZEL = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BILDER = os.path.join(WURZEL, "assets", "images")
AUSGABE = os.path.join(WURZEL, "assets", "data", "bilder.json")

FORMATE = {
    "marke": "1:1, kleine Marke in Listen",
    "kopf": "3:2, Kartenkopf und Titelbild",
    "studie": "16:9, Lektion und Körperzeichnung",
    "hoch": "3:4, Einladung und Hochformat",
    "diagramm": "4:3, Erklärdiagramm (wird ganz gezeigt, nie beschnitten)",
}

GEFUEHRT = {
    "selbst": ("Körperreise", "Body journey"),
    "paar": ("Gemeinsamer Abend", "Shared evening"),
    "einschlaf": ("Einschlafen", "Falling asleep"),
}

JA_NEIN = {
    "sensory_basics": ("Sinne und Grundlagen", "Senses and basics"),
    "communication_mind": ("Kommunikation und Kopf", "Communication and mind"),
    "touch_techniques": ("Berührung und Techniken", "Touch and techniques"),
    "mouth_kissing": ("Mund und Küsse", "Mouth and kissing"),
    "positions_movement": ("Stellungen und Bewegung", "Positions and movement"),
    "power_dynamics": ("Macht und Hingabe", "Power and surrender"),
    "deep_somatics": ("Tiefe Körperarbeit", "Deep body work"),
    "toys_aids": ("Spielzeug und Hilfsmittel", "Toys and aids"),
    "roles_settings": ("Rollen und Szenarien", "Roles and settings"),
    "fantasy_watching": ("Fantasie und Zuschauen", "Fantasy and watching"),
    "spicy": ("Spicy", "Spicy"),
}

# Bestellte, noch nicht gelieferte Bilder (ID -> Format, Alt-Text DE, Alt-Text EN).
AUSSTEHEND = {
    "bereich.heute.einladung": ("hoch", "Einladung zum nächsten Schritt", "Invitation to the next step"),
}

# Grafische Gestaltungselemente: in Dart gezeichnet (lib/widgets/design/vp_grafik.dart), keine Dateien.
GRAFIK = {
    "marke.kreuz": "Kreuzmarke",
    "marke.eck": "Eckmarken eines Bildfelds",
    "linie.mass": "Maßlinie mit Endstrichen",
    "linie.haar": "Haarlinie",
    "linie.doppel": "Doppellinie",
    "raster.fein": "Feines Raster",
    "bogen.konstruktion": "Konstruktionsbögen",
    "rahmen.passepartout": "Passepartout um ein Bild",
}


def lade(pfad):
    with open(pfad, encoding="utf-8") as f:
        return json.load(f)


def inhalte():
    de = lade(os.path.join(WURZEL, "assets", "data", "velvet_content.json"))
    en = lade(os.path.join(WURZEL, "translations", "en", "velvet_content.json"))
    return de, en


def lektionen(daten):
    for kurs in daten["courses"]:
        for lek in kurs["lessons"]:
            yield kurs, lek


def existiert(rel):
    return os.path.exists(os.path.join(WURZEL, rel.replace("/", os.sep)))


def bauen():
    de, en = inhalte()
    en_kurse = {k["id"]: k for k in en["courses"]}
    en_lekt = {l["id"]: l for _, l in lektionen(en)}
    bilder = {}

    # Kurs-Titelbilder
    for kurs in de["courses"]:
        pfad = kurs.get("image")
        if not pfad:
            continue
        nr = re.search(r"cover_(\d+)\.(?:svg|webp)$", pfad).group(1)
        eintrag = dekorativer_eintrag('cover_'+nr, {"de": kurs["title"], "en": en_kurse[kurs["id"]]["title"]})
        bilder["kurs.%s.titel" % nr] = eintrag

    # Geführte Audios
    for name, (alt_de, alt_en) in GEFUEHRT.items():
        e = dekorativer_eintrag('guided_'+name, {"de": alt_de, "en": alt_en})
        bilder["audio.%s.cover" % name] = e

    # Ja/Nein/Vielleicht-Bereiche
    for name, (alt_de, alt_en) in JA_NEIN.items():
        e = dekorativer_eintrag('ynm_'+name, {"de": alt_de, "en": alt_en})
        bilder["bereich.%s" % name] = e

    # Diagramme und Körperzeichnungen der Lektionen (deutsche und englische Fassung)
    def nach_lektion(feld, praefix, fmt, alt_de, alt_en):
        for _, lek in lektionen(de):
            pfad = lek.get(feld)
            if not pfad:
                continue
            name = re.search(r"%s_(.+)\.svg$" % feld.replace("zeichnung", "zeichnung").replace("image", "diagram"), pfad)
            if not name:
                continue
            bid = "%s.%s" % (praefix, name.group(1))
            if bid in bilder:
                continue
            en_titel = en_lekt.get(lek["id"], lek)["title"]
            e = {
                "format": fmt,
                "normal": pfad,
                "alt": {"de": alt_de % lek["title"], "en": alt_en % en_titel},
            }
            if existiert(pfad.replace(".svg", "_en.svg")):
                e["englisch"] = pfad.replace(".svg", "_en.svg")
            bilder[bid] = e

    nach_lektion("image", "diagramm", "diagramm", "Diagramm zur Lektion „%s“", "Diagram for the lesson “%s”")
    nach_lektion("zeichnung", "zeichnung", "studie", "Körperzeichnung zur Lektion „%s“", "Body drawing for the lesson “%s”")

    # Nicht aus Kursdaten erreichbare Diagramme (z. B. im Ja/Nein-Modell): trotzdem aufnehmen
    for datei in sorted(os.listdir(BILDER)):
        m = re.match(r"diagram_(.+)\.svg$", datei)
        if not m or datei.endswith("_en.svg"):
            continue
        bid = "diagramm.%s" % m.group(1)
        if bid in bilder:
            continue
        pfad = "assets/images/" + datei
        e = {"format": "diagramm", "normal": pfad, "alt": {"de": "Diagramm", "en": "Diagram"}}
        if existiert(pfad.replace(".svg", "_en.svg")):
            e["englisch"] = pfad.replace(".svg", "_en.svg")
        bilder[bid] = e

    # Noch nicht gelieferte Illustrationen: im Register, damit Bildschirme die ID schon nennen; bis zum Bild steht der Platzhalter da.
    for bid, (fmt, alt_de, alt_en) in AUSSTEHEND.items():
        bilder[bid] = {"format": fmt, "ausstehend": True, "alt": {"de": alt_de, "en": alt_en}}

    return {
        "version": 1,
        "formate": FORMATE,
        "bilder": dict(sorted(bilder.items())),
        "grafik": {k: {"art": "painter", "beschreibung": v} for k, v in GRAFIK.items()},
    }


def main():
    neu = json.dumps(bauen(), ensure_ascii=False, indent=2) + "\n"
    if "--pruefen" in sys.argv:
        alt = open(AUSGABE, encoding="utf-8").read() if os.path.exists(AUSGABE) else ""
        if alt.replace("\r\n", "\n") != neu:
            print("bilder.json weicht ab: python tools/bilder_register.py ausführen")
            sys.exit(1)
        print("bilder.json ist aktuell")
        return
    with open(AUSGABE, "w", encoding="utf-8", newline="\n") as f:
        f.write(neu)
    print("geschrieben:", AUSGABE)


if __name__ == "__main__":
    main()
