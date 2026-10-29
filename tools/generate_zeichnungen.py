"""Erzeugt die erklärenden Körperzeichnungen (assets/images/zeichnung_<Lektion>.svg und _en.svg).

Basis ist je ein Bleistift-Bild (tools/zeichnungen/<Lektion>.webp, von Antigravity im Stil einer technischen Studie gezeichnet, ohne Text).
Darüber liegen als Vektor kurze Beschriftungen mit dünnen Linien zu den Zielpunkten, Deutsch und Englisch. Die Bilder sind eingebettet
(data-URI), damit die App sie wie die anderen Diagramme als SVG lädt (Sprache.bild wählt _en).

Aufruf: python tools/generate_zeichnungen.py
Koordinaten sind Prozent der Bildbreite und -höhe: (Zielpunkt am Körper, Textposition). Keine Maße, keine Zentimeter: nur Zonen und Berührungsarten.
"""
import base64
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
QUELLE = ROOT / "tools" / "zeichnungen"
OUT = ROOT / "assets" / "images"
B, H = 1024, 576
SCHRIFT = 24

# Lektion -> [(deutsch, englisch, (zx, zy), (tx, ty)), ...]
ZEICHNUNGEN = {
    "anat_1": [
        ("Kopf und Sinne", "Head and senses", (84, 45), (84, 10)),
        ("Atem und Brust", "Breath and chest", (66, 38), (52, 10)),
        ("Weicher Bauch", "Soft belly", (45, 40), (24, 10)),
        ("Füße", "Feet", (14, 56), (14, 90)),
    ],
    "anat_3": [
        ("Große Rückenfläche", "Broad back", (32, 47), (26, 10)),
        ("Kreuzbein", "Sacrum", (48, 45), (50, 10)),
        ("Kniekehlen", "Knee hollows", (72, 52), (74, 10)),
        ("Fußgewölbe", "Foot arches", (91, 58), (84, 90)),
    ],
    "beauty_1": [
        ("Schlank", "Slim", (17, 22), (17, 5)),
        ("Kurvig", "Curvy", (37, 22), (37, 5)),
        ("Athletisch", "Athletic", (61, 22), (61, 5)),
        ("Reif", "Mature", (83, 22), (83, 5)),
    ],
    "touch_w_1": [
        ("Flache, ruhende Hand", "Flat, resting hand", (40, 49), (34, 10)),
        ("Gleichmäßiger Druck", "Steady pressure", (46, 53), (66, 10)),
        ("Entspannter Nacken", "Relaxed neck", (80, 50), (86, 90)),
        ("Weicher Atemraum", "Soft breathing space", (62, 46), (58, 90)),
    ],
    "touch_m_1": [
        ("Offene, flache Hand", "Open flat hand", (37, 60), (68, 10)),
        ("Breite Druckverteilung", "Broad pressure", (42, 67), (72, 26)),
        ("Gelöstes Gesicht", "Relaxed face", (21, 68), (16, 90)),
        ("Weicher Bauch", "Soft belly", (48, 68), (62, 90)),
    ],
    "mass_1": [
        ("Flächiges Ausstreichen", "Broad strokes", (43, 54), (24, 10)),
        ("Gebende Präsenz", "Giving presence", (55, 38), (80, 12)),
        ("Hingabe ohne Ziel", "Surrender, no goal", (20, 63), (18, 92)),
        ("Lockerer Rücken", "Loose back", (36, 62), (52, 92)),
    ],
    "pos_2": [
        ("Umschließende Nähe", "Enfolding closeness", (38, 50), (50, 10)),
        ("Freier Atem", "Free breath", (28, 40), (16, 10)),
        ("Gewicht an die Unterlage", "Weight into the bed", (50, 66), (40, 90)),
        ("Weicher Beckenboden", "Soft pelvic floor", (58, 58), (76, 90)),
    ],
    "self_1": [
        ("Hand auf dem Herzen", "Hand on the heart", (49, 42), (24, 24)),
        ("Hand auf dem Bauch", "Hand on the belly", (53, 66), (24, 52)),
        ("Fließender Atem", "Flowing breath", (50, 52), (80, 32)),
        ("Offenes Becken", "Open pelvis", (52, 76), (80, 62)),
    ],
}


def svg(lektion, sprache):
    daten = base64.b64encode((QUELLE / f"{lektion}.webp").read_bytes()).decode("ascii")
    titel = {"de": "Körperzeichnung mit Beschriftung", "en": "Body drawing with labels"}[sprache]
    teile = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {B} {H}" width="{B}" height="{H}">',
        f"<title>{titel}</title>",
        f'<image width="{B}" height="{H}" href="data:image/webp;base64,{daten}"/>',
    ]
    for de, en, (zx, zy), (tx, ty) in ZEICHNUNGEN[lektion]:
        text = de if sprache == "de" else en
        x1, y1, x2, y2 = tx / 100 * B, ty / 100 * H, zx / 100 * B, zy / 100 * H
        breite = len(text) * SCHRIFT * 0.56 + 24
        teile.append(f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#FB7185" stroke-width="2" stroke-opacity="0.9"/>')
        teile.append(f'<circle cx="{x2:.0f}" cy="{y2:.0f}" r="6" fill="#FB7185" stroke="#FFFFFF" stroke-width="1.5"/>')
        teile.append(f'<rect x="{x1 - breite / 2:.0f}" y="{y1 - 20:.0f}" width="{breite:.0f}" height="40" rx="12" fill="#140D1C" fill-opacity="0.86" '
                     f'stroke="#FB7185" stroke-width="1.2"/>')
        teile.append(f'<text x="{x1:.0f}" y="{y1 + 8:.0f}" text-anchor="middle" font-family="sans-serif" font-size="{SCHRIFT}" '
                     f'font-weight="600" fill="#F1F5F9">{text}</text>')
    teile.append("</svg>")
    return "\n".join(teile) + "\n"


if __name__ == "__main__":
    for lektion in ZEICHNUNGEN:
        for sprache, suffix in (("de", ""), ("en", "_en")):
            (OUT / f"zeichnung_{lektion}{suffix}.svg").write_text(svg(lektion, sprache), encoding="utf-8", newline="\n")
        print("zeichnung_" + lektion)
