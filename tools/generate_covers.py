"""Erzeugt die Kursbilder (assets/images/cover_<nr>.svg) als sinnliche Silhouetten in warmem Licht.

Format 840x300: Die App zeigt die Bilder als Banner (ca. 350x125, BoxFit.cover)
mit Verlauf nach unten, deshalb sitzt das Motiv oben mittig und es gibt keinen Text.

Aufruf: python tools/generate_covers.py          (schreibt alle 17 Dateien)
"""
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "assets" / "images"

# Profilbüste mit Blick nach rechts, Ursprung etwa in der Kopfmitte.
BUST = ("M-100 175 C-96 135 -82 112 -42 100 C-33 80 -30 55 -34 30 C-52 0 -40 -50 -5 -56 "
        "C22 -58 36 -40 38 -20 C40 -12 42 -6 46 0 C52 8 56 12 50 15 L45 17 C47 21 48 24 45 27 "
        "C47 30 47 33 44 36 C44 42 42 47 34 50 C26 53 20 54 18 62 C16 74 20 90 40 108 "
        "C62 124 78 150 82 175 Z")
LONG_HAIR = "M-5 -58 C-62 -62 -84 20 -80 112 C-66 98 -46 64 -36 28 Z"
SHORT_HAIR = "M-8 -57 C-40 -60 -52 -30 -46 2 C-40 -18 -24 -40 -8 -44 Z"
BLINDFOLD = "M-44 -18 C-10 -26 26 -22 42 -14 L45 -2 C26 -8 -10 -12 -42 -4 Z"

# Liegend auf der Seite, Kopf links auf die Hand gestützt, oberes Knie angewinkelt, Bettlinie bei y=130.
RECLINE_F = ("M30 130 L52 128 C56 100 60 70 66 46 C70 28 82 16 100 16 C122 16 134 32 132 50 "
             "C130 62 126 70 134 76 C150 86 175 88 200 92 C235 98 255 102 280 96 "
             "C305 90 315 50 345 46 C375 42 400 56 430 64 C460 72 480 56 505 60 "
             "C530 64 545 92 580 100 C610 108 640 108 652 116 C658 124 652 130 640 130 Z")
RECLINE_F_HAIR = "M84 22 C60 30 58 70 76 96 C90 116 112 112 128 100 C116 88 112 70 118 52 C110 40 98 30 84 22 Z"
RECLINE_M = ("M30 130 L52 128 C56 100 60 70 66 44 C70 26 82 14 100 14 C122 14 134 30 132 48 "
             "C130 60 128 66 138 70 C160 72 185 70 210 76 C245 84 265 92 290 92 "
             "C315 92 330 64 355 62 C385 60 405 66 435 70 C465 74 485 58 510 62 "
             "C535 66 550 92 585 100 C615 108 645 108 657 116 C663 124 657 130 645 130 Z")


# Rückenansicht mit Kopf, Mitte bei x=0, Nacken bei y=0; unten unterhalb der Hüfte angeschnitten.
BACK_F = {
    "head": "M0 -118 C26 -118 38 -96 36 -72 C34 -48 20 -30 0 -30 C-20 -30 -34 -48 -36 -72 C-38 -96 -26 -118 0 -118 Z",
    "hair": "M0 -122 C30 -122 42 -98 38 -76 C30 -92 14 -100 0 -100 C-14 -100 -30 -92 -38 -76 C-42 -98 -30 -122 0 -122 Z "
            "M0 -150 C16 -150 24 -138 22 -126 C18 -116 -18 -116 -22 -126 C-24 -138 -16 -150 0 -150 Z",
    "torso": "M-16 -34 C-14 -18 -16 -6 -24 0 C-50 8 -92 10 -104 34 C-112 56 -100 96 -88 126 "
             "C-80 150 -80 166 -88 184 C-112 214 -134 262 -132 330 L132 330 C134 262 112 214 88 184 "
             "C80 166 80 150 88 126 C100 96 112 56 104 34 C92 10 50 8 24 0 C16 -6 14 -18 16 -34 Z",
    "arms": "M-106 30 C-128 40 -134 90 -132 140 C-130 200 -138 300 -142 420 L-120 420 C-116 300 -112 200 -112 140 "
            "C-112 106 -106 74 -100 54 Z M106 30 C128 40 134 90 132 140 C130 200 138 300 142 420 L120 420 "
            "C116 300 112 200 112 140 C112 106 106 74 100 54 Z",
}
BACK_M = {
    "head": "M0 -122 C28 -122 40 -98 38 -72 C36 -46 22 -28 0 -28 C-22 -28 -36 -46 -38 -72 C-40 -98 -28 -122 0 -122 Z",
    "hair": "M0 -126 C30 -126 44 -104 40 -82 C30 -96 16 -102 0 -102 C-16 -102 -30 -96 -40 -82 C-44 -104 -30 -126 0 -126 Z",
    "torso": "M-22 -34 C-20 -16 -24 -4 -40 2 C-80 10 -142 12 -156 44 C-166 74 -150 120 -132 156 "
             "C-118 186 -108 214 -106 250 C-104 280 -104 300 -104 330 L104 330 C104 300 104 280 106 250 "
             "C108 214 118 186 132 156 C150 120 166 74 156 44 C142 12 80 10 40 2 C24 -4 20 -16 22 -34 Z",
    "arms": "M-158 46 C-182 60 -188 110 -184 160 C-180 220 -186 320 -188 420 L-166 420 C-162 320 -158 220 -158 160 "
            "C-156 124 -150 96 -142 78 Z M158 46 C182 60 188 110 184 160 C180 220 186 320 188 420 L166 420 "
            "C162 320 158 220 158 160 C156 124 150 96 142 78 Z",
}
SPINE = "M0 14 C-3 70 3 130 0 200"


def defs(p):
    return f"""  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="{p['bg1']}"/>
      <stop offset="1" stop-color="#0F172A"/>
    </linearGradient>
    <radialGradient id="light" cx="0.5" cy="0.5" r="0.5">
      <stop offset="0" stop-color="{p['core']}" stop-opacity="0.95"/>
      <stop offset="0.4" stop-color="{p['halo']}" stop-opacity="0.45"/>
      <stop offset="1" stop-color="{p['halo']}" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="skinR" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#120A16"/>
      <stop offset="0.75" stop-color="{p['body']}"/>
      <stop offset="1" stop-color="{p['edge']}"/>
    </linearGradient>
    <linearGradient id="skinT" x1="0" y1="1" x2="0" y2="0">
      <stop offset="0" stop-color="#120A16"/>
      <stop offset="0.7" stop-color="{p['body']}"/>
      <stop offset="1" stop-color="{p['edge']}"/>
    </linearGradient>
    <linearGradient id="rimR" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0.45" stop-color="{p['core']}" stop-opacity="0"/>
      <stop offset="1" stop-color="{p['core']}" stop-opacity="0.95"/>
    </linearGradient>
    <linearGradient id="rimT" x1="0" y1="1" x2="0" y2="0">
      <stop offset="0.5" stop-color="{p['core']}" stop-opacity="0"/>
      <stop offset="1" stop-color="{p['core']}" stop-opacity="0.95"/>
    </linearGradient>
  </defs>
  <rect width="840" height="300" fill="url(#bg)"/>
"""


def glow(cx, cy, rx, ry):
    return f'  <ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="url(#light)"/>\n'


def bust(x, y, s, flip=False, hair=None, blindfold=False, tilt=0):
    sx = -s if flip else s
    parts = []
    if hair:
        parts.append(f'<path d="{hair}" fill="#170D16"/>')
    parts.append(f'<path d="{BUST}" fill="url(#skinR)" stroke="url(#rimR)" stroke-width="2"/>')
    if blindfold:
        parts.append(f'<path d="{BLINDFOLD}" fill="#7F1D3A" stroke="#FDA4AF" stroke-width="0.8" stroke-opacity="0.6"/>')
    inner = "".join(parts)
    return f'  <g transform="translate({x} {y}) scale({sx} {s}) rotate({tilt})">{inner}</g>\n'


def recline(shape, x, y, s, flip=False, shade=False):
    sx = -s if flip else s
    fill = "#160D16" if shade else "url(#skinT)"
    # Auch die Person im Schatten bekommt eine feine Lichtkante, sonst verschwimmt ihr Umriss.
    stroke = 'url(#rimT)" stroke-opacity="0.55' if shade else "url(#rimT)"
    hair = f'<path d="{RECLINE_F_HAIR}" fill="#170D16"/>' if shape == RECLINE_F else ""
    return (f'  <g transform="translate({x} {y}) scale({sx} {s})">'
            f'<path d="{shape}" fill="{fill}" stroke="{stroke}" stroke-width="2"/>{hair}</g>\n')


def back(fig, x, y, s):
    skin = 'fill="url(#skinR)" stroke="url(#rimR)" stroke-width="2.5"'
    return (f'  <g transform="translate({x} {y}) scale({s})">'
            f'<path d="{fig["arms"]}" {skin}/>'
            f'<path d="{fig["torso"]}" {skin}/>'
            f'<path d="{fig["head"]}" {skin}/>'
            f'<path d="{fig["hair"]}" fill="#170D16"/>'
            f'<path d="{SPINE}" fill="none" stroke="#000000" stroke-opacity="0.22" stroke-width="4" stroke-linecap="round"/>'
            f'</g>\n')


def bed(y, color):
    return f'  <rect x="0" y="{y}" width="840" height="{300 - y}" fill="{color}" opacity="0.55"/>\n'


def funken(p, anzahl=26, seed=7):
    """Kleine schwebende Lichtpunkte, immer gleich verteilt (fester Startwert)."""
    import random
    r = random.Random(seed)
    s = ""
    for _ in range(anzahl):
        x, y = r.uniform(40, 800), r.uniform(10, 230)
        rad, op = r.uniform(1.2, 3.6), r.uniform(0.25, 0.85)
        s += f'  <circle cx="{x:.0f}" cy="{y:.0f}" r="{rad:.1f}" fill="{p["core"]}" opacity="{op:.2f}"/>\n'
    return s


PALETTES = {
    "amber":   dict(bg1="#1A1208", core="#FDBA74", halo="#F59E0B", body="#2A1A14", edge="#7C3A1D"),
    "rose":    dict(bg1="#1F0E18", core="#FDA4AF", halo="#F472B6", body="#2A1424", edge="#7A2E45"),
    "crimson": dict(bg1="#1E0A10", core="#FCA5A5", halo="#E11D48", body="#2A1018", edge="#7F1D2D"),
    "violet":  dict(bg1="#150E24", core="#F0ABFC", halo="#A855F7", body="#1F1430", edge="#5B2A7A"),
    "sunset":  dict(bg1="#1E1010", core="#FDE68A", halo="#FB7185", body="#2A1618", edge="#8A3A2E"),
    "gold":    dict(bg1="#1A150A", core="#FEF3C7", halo="#FBBF24", body="#2A2114", edge="#8A6420"),
    "teal":    dict(bg1="#0C1A1C", core="#FDE68A", halo="#2DD4BF", body="#14262A", edge="#3F6F5E"),
}


def scene(kind, pal):
    p = PALETTES[pal]
    s = defs(p)
    if kind == "bust_single":          # eine Person, Kopf leicht zurückgelegt
        s += glow(470, 110, 300, 210) + bust(400, 125, 1.3, hair=SHORT_HAIR, tilt=-6)
    elif kind == "bust_single_f":
        s += glow(470, 110, 300, 210) + bust(400, 122, 1.3, hair=LONG_HAIR, tilt=-8)
    elif kind == "near_kiss":          # zwei Profile kurz vor dem Kuss
        s += glow(420, 105, 280, 200)
        s += bust(335, 122, 1.3, hair=LONG_HAIR) + bust(505, 116, 1.38, flip=True, hair=SHORT_HAIR)
    elif kind == "talk":               # zugewandt, mit etwas Abstand
        s += glow(420, 110, 300, 190)
        s += bust(300, 128, 1.2, hair=LONG_HAIR, tilt=-4) + bust(545, 122, 1.28, flip=True, hair=SHORT_HAIR, tilt=-4)
    elif kind == "blindfold":          # Kuss, eine Person mit Augenbinde
        s += glow(420, 105, 280, 200)
        s += bust(335, 122, 1.3, hair=LONG_HAIR, blindfold=True) + bust(505, 116, 1.38, flip=True, hair=SHORT_HAIR)
    elif kind == "back_f":             # Rückenansicht Frau, Taille und Hüfte im Gegenlicht
        s += glow(470, 120, 280, 210) + back(BACK_F, 420, 104, 0.64)
    elif kind == "back_m":             # Rückenansicht Mann, breite Schultern
        s += glow(470, 110, 300, 210) + back(BACK_M, 420, 104, 0.64)
    elif kind == "forehead":           # Stirn an Stirn, ganz nah
        s += glow(420, 100, 260, 190)
        s += bust(352, 124, 1.3, hair=LONG_HAIR, tilt=8) + bust(488, 118, 1.38, flip=True, hair=SHORT_HAIR, tilt=8)
    elif kind == "massage":            # Rücken der Empfangenden, daneben die gebende Person, die sich zu ihr neigt
        s += glow(470, 110, 320, 210)
        s += back(BACK_F, 350, 108, 0.66) + bust(610, 122, 1.2, flip=True, hair=SHORT_HAIR, tilt=18)
    elif kind == "recline_sparks":     # eine Person liegt im warmen Licht, darüber schwebende Funken
        s += glow(430, 120, 360, 170) + funken(p)
        s += recline(RECLINE_F, 95, 112, 1.0) + bed(242, "#000000")
    elif kind == "recline_pair":       # zwei liegen eng aneinander, die hintere Person im Schatten
        s += glow(430, 112, 380, 180) + funken(p, 30, 11)
        s += recline(RECLINE_M, 60, 74, 1.04, shade=True) + recline(RECLINE_F, 130, 120, 0.96) + bed(244, "#000000")
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 840 300" width="840" height="300">\n{s}</svg>\n'


# Kursnummer -> (Motiv, Farbstimmung)
COVERS = {
    1: ("bust_single", "amber"),
    2: ("bust_single_f", "violet"),
    3: ("back_f", "teal"),
    4: ("back_m", "amber"),
    5: ("talk", "sunset"),
    6: ("back_f", "rose"),
    7: ("forehead", "rose"),
    8: ("back_f", "crimson"),
    9: ("back_m", "crimson"),
    10: ("bust_single_f", "sunset"),
    11: ("near_kiss", "rose"),
    12: ("blindfold", "violet"),
    13: ("back_f", "gold"),
    14: ("massage", "amber"),
    15: ("back_m", "violet"),
    16: ("forehead", "amber"),
    17: ("blindfold", "crimson"),
    18: ("bust_single_f", "rose"),
    19: ("talk", "teal"),
    20: ("forehead", "gold"),
    21: ("bust_single", "teal"),
    22: ("back_f", "violet"),
    23: ("bust_single_f", "crimson"),
    24: ("blindfold", "rose"),
    25: ("recline_sparks", "gold"),
    26: ("near_kiss", "sunset"),
    27: ("massage", "teal"),
}

# Bereiche der Ja/Nein/Vielleicht-Liste (lib/models/yes_no_maybe_models.dart) -> (Motiv, Farbstimmung)
YES_NO_MAYBE = {
    "sensory_basics": ("back_f", "sunset"),
    "communication_mind": ("talk", "teal"),
    "touch_techniques": ("massage", "rose"),
    "mouth_kissing": ("near_kiss", "crimson"),
    "positions_movement": ("forehead", "violet"),
    "power_dynamics": ("blindfold", "amber"),
    "deep_somatics": ("massage", "gold"),
    "toys_aids": ("back_m", "teal"),
    "roles_settings": ("talk", "violet"),
    "fantasy_watching": ("bust_single_f", "crimson"),
    "spicy": ("near_kiss", "crimson"),
}

# Geführte Audios (Startseite, Paar-Kanal) -> (Motiv, Farbstimmung)
GEFUEHRT = {
    "guided_selbst": ("recline_sparks", "rose"),
    "guided_paar": ("recline_pair", "crimson"),
}

if __name__ == "__main__":
    for name, (kind, pal) in GEFUEHRT.items():
        path = OUT / f"{name}.svg"
        path.write_text(scene(kind, pal), encoding="utf-8")
        print(path.name, kind, pal)
    for nr, (kind, pal) in COVERS.items():
        path = OUT / f"cover_{nr:02d}.svg"
        path.write_text(scene(kind, pal), encoding="utf-8")
        print(path.name, kind, pal)
    for category, (kind, pal) in YES_NO_MAYBE.items():
        path = OUT / f"ynm_{category}.svg"
        path.write_text(scene(kind, pal), encoding="utf-8")
        print(path.name, kind, pal)
