"""Erzeugt die Kursbilder im Skizzenbuch-Stil (Bleistift auf Nachtpapier), rein als SVG ohne Filter.

Ersetzt die Farb-Silhouetten aus generate_covers.py (dessen Formen und Zuordnung werden weiterverwendet).
Normal: Graphit-Linien, schraffierte Flächen, ein Rosé-Akzent, Maßlinien und Konstruktionskreise.
Spicy:  wärmeres Papier, Rosé-Linien, dichtere Schraffur, intimere Motive und kleine Funken-Kreuze.

Die Handschrift entsteht durch zwei leicht versetzte, verwackelte Konturlinien und Schraffur (clipPath),
weil flutter_svg keine Filter (feTurbulence) kann. Format 840x300 wie bisher: Motiv oben mittig, kein Text.

Aufruf: python tools/generate_covers_skizze.py          (schreibt cover_*, guided_*, ynm_* und die *_spicy-Fassungen)
"""
import random
import re

import generate_covers as g

OUT = g.OUT

NORMAL = dict(bg="#1D1F22", linie="#E9E4D8", hatch=0.40, grid=0.05, akzent="#D9A3AB", konstr=0.18,
              abstand=6.5, w1=1.1, w2=0.5, wh=0.5)
SPICY = dict(bg="#25191D", linie="#F4D3D0", hatch=0.50, grid=0.06, akzent="#E58A98", konstr=0.22,
             abstand=5.5, w1=1.0, w2=0.45, wh=0.45, glow="#E58A98")


def wackeln(d, seed, amp=1.1):
    """Jede Zahl im Pfad leicht verschieben: die Linie wird zur Handzeichnung."""
    r = random.Random(seed)
    return re.sub(r"-?\d+(?:\.\d+)?", lambda m: f"{float(m.group()) + r.uniform(-amp, amp):.1f}", d)


class Blatt:
    def __init__(self, stil, nummer):
        self.s = stil
        self.n = nummer
        self.defs = []
        self.körper = []
        self._id = 0

    def neu_id(self):
        self._id += 1
        return f"c{self._id}"

    def schraffur(self, bbox, abstand, winkel_rechts=True, op=None, breite=None):
        x0, y0, x1, y1 = bbox
        h = y1 - y0
        zeilen = []
        x = x0 - h
        while x < x1 + h:
            if winkel_rechts:
                zeilen.append(f"M{x:.0f} {y1:.0f}L{x + h:.0f} {y0:.0f}")
            else:
                zeilen.append(f"M{x:.0f} {y0:.0f}L{x + h:.0f} {y1:.0f}")
            x += abstand
        return (f'<path d="{"".join(zeilen)}" fill="none" stroke="{self.s["linie"]}" '
                f'stroke-opacity="{op if op is not None else self.s["hatch"]}" stroke-width="{breite or self.s["wh"]}"/>')

    def form(self, pfad, bbox, transform, schatten_bis=None, accent_hatch=False, dicht=1.0, seed=0):
        """Eine gezeichnete Form: schraffiert, mit doppelter verwackelter Kontur und Licht-Akzent rechts."""
        cid = self.neu_id()
        self.defs.append(f'<clipPath id="{cid}"><path d="{pfad}"/></clipPath>')
        ab = self.s["abstand"]
        innen = self.schraffur(bbox, ab / dicht, True)
        if schatten_bis is not None:  # Schattenseite (links) zusätzlich quer schraffiert
            sid = self.neu_id()
            x0, y0, x1, y1 = bbox
            self.defs.append(f'<clipPath id="{sid}"><rect x="{x0 - 50}" y="{y0 - 50}" width="{schatten_bis - x0 + 50}" '
                             f'height="{y1 - y0 + 100}"/></clipPath>')
            innen += f'<g clip-path="url(#{sid})">{self.schraffur(bbox, ab / dicht, False, self.s["hatch"] * 0.9)}</g>'
        if accent_hatch:
            innen += self.schraffur(bbox, 18 / dicht, True, 0.5, 0.8).replace(self.s["linie"], self.s["akzent"])
        l = self.s["linie"]
        kontur = (f'<path d="{wackeln(pfad, seed * 7 + 1)}" fill="none" stroke="{l}" stroke-width="{self.s["w1"]}" '
                  f'stroke-linejoin="round" stroke-opacity="0.92"/>'
                  f'<path d="{wackeln(pfad, seed * 7 + 2, 1.6)}" fill="none" stroke="{l}" stroke-width="{self.s["w2"]}" '
                  f'stroke-opacity="0.6" transform="translate(1.4 -1)"/>')
        licht = (f'<g clip-path="url(#{cid})"><path d="{pfad}" fill="none" stroke="{self.s["akzent"]}" stroke-width="2" '
                 f'stroke-opacity="0.85" transform="translate(-2.4 0)"/></g>')
        self.körper.append(f'<g transform="{transform}"><g clip-path="url(#{cid})">{innen}</g>{kontur}{licht}</g>')

    def raw(self, svg):
        self.körper.append(svg)

    def svg(self):
        s, n = self.s, self.n
        rnd = random.Random(n)
        # Raster und Konstruktionslinien
        gx = rnd.randint(0, 29)
        raster = "".join(f"M{x} 0V300" for x in range(gx, 840, 30)) + "".join(f"M0 {y}H840" for y in range(10, 300, 30))
        bg = (f'<rect width="840" height="300" fill="{s["bg"]}"/>'
              f'<path d="{raster}" stroke="{s["linie"]}" stroke-opacity="{s["grid"]}" stroke-width="0.6" fill="none"/>')
        # Maßlinie unten mit Endstrichen und Pfeilen, Lücke in der Mitte (dort stünde die Zahl)
        x0, x1 = rnd.randint(110, 200), rnd.randint(640, 730)
        mid = (x0 + x1) // 2
        a = s["akzent"]
        mass = (f'<path d="M{x0} 283H{mid - 26}M{mid + 26} 283H{x1}M{x0} 276V290M{x1} 276V290'
                f'M{x0} 283l8-4M{x0} 283l8 4M{x1} 283l-8-4M{x1} 283l-8 4" stroke="{a}" stroke-opacity="0.75" '
                f'stroke-width="0.9" fill="none"/>')
        # gestrichelter Konstruktionskreis, je Bild an anderer Stelle
        cx, cy, r = rnd.randint(330, 520), rnd.randint(110, 150), rnd.randint(100, 150)
        konstr = (f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="{s["linie"]}" stroke-opacity="{s["konstr"]}" '
                  f'stroke-width="0.9" stroke-dasharray="3 6"/>'
                  f'<path d="M{cx - r - 14} {cy}H{cx + r + 14}M{cx} {cy - r - 14}V{cy + r + 14}" stroke="{s["linie"]}" '
                  f'stroke-opacity="{s["konstr"] * 0.8}" stroke-width="0.6" stroke-dasharray="14 5 2 5" fill="none"/>')
        glow = ""
        if s.get("glow"):  # Spicy: warmer Schimmer hinter den Körpern, wie Kerzenlicht auf Papier
            self.defs.append(f'<radialGradient id="gl" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="{s["glow"]}" '
                             f'stop-opacity="0.30"/><stop offset="1" stop-color="{s["glow"]}" stop-opacity="0"/></radialGradient>')
            glow = f'<ellipse cx="{cx + 30}" cy="130" rx="330" ry="170" fill="url(#gl)"/>'
        return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 840 300" width="840" height="300">\n'
                f'<defs>{"".join(self.defs)}</defs>\n{bg}{glow}{konstr}{"".join(self.körper)}{mass}\n</svg>\n')


def funken(blatt, anzahl, seed):
    r = random.Random(seed)
    a = blatt.s["akzent"]
    teile = []
    for _ in range(anzahl):
        x, y, k = r.uniform(40, 800), r.uniform(14, 240), r.uniform(2.5, 5.5)
        teile.append(f"M{x - k:.0f} {y:.0f}H{x + k:.0f}M{x:.0f} {y - k:.0f}V{y + k:.0f}")
    blatt.raw(f'<path d="{"".join(teile)}" stroke="{a}" stroke-opacity="0.8" stroke-width="1.1" fill="none"/>')


def zeichne(kind, stil, nummer):
    b = Blatt(stil, nummer)
    bust_bb = (-100, -60, 85, 178)

    def bust(x, y, s, flip=False, hair=None, blindfold=False, tilt=0):
        sx = -s if flip else s
        tf = f"translate({x} {y}) scale({sx} {s}) rotate({tilt})"
        if hair:
            b.form(hair, (-90, -65, 0, 115), tf, seed=nummer + 3)
        b.form(g.BUST, bust_bb, tf, schatten_bis=-20, seed=nummer)
        if blindfold:
            b.raw(f'<g transform="{tf}"><path d="{g.BLINDFOLD}" fill="{stil["akzent"]}" fill-opacity="0.55" '
                  f'stroke="{stil["linie"]}" stroke-width="1"/></g>')

    def recline(shape, x, y, s, flip=False, schatten=False):
        sx = -s if flip else s
        tf = f"translate({x} {y}) scale({sx} {s})"
        if shape == g.RECLINE_F:
            b.form(g.RECLINE_F_HAIR, (50, 14, 140, 120), tf, seed=nummer + 5)
        b.form(shape, (30, 10, 665, 132), tf, schatten_bis=(330 if schatten else None), dicht=(1.6 if schatten else 1.0),
               seed=nummer + (9 if schatten else 0))

    def back(fig, x, y, s):
        tf = f"translate({x} {y}) scale({s})"
        b.form(fig["arms"], (-200, 20, 200, 430), tf, seed=nummer + 1)
        b.form(fig["torso"], (-170, -40, 170, 335), tf, schatten_bis=-30, seed=nummer + 2)
        b.form(fig["head"], (-42, -125, 42, -26), tf, seed=nummer + 4)
        b.form(fig["hair"], (-45, -155, 45, -70), tf, dicht=1.8, seed=nummer + 6)
        b.raw(f'<g transform="{tf}"><path d="{g.SPINE}" fill="none" stroke="{stil["akzent"]}" stroke-width="2" '
              f'stroke-opacity="0.6" stroke-dasharray="4 6"/></g>')

    if kind == "bust_single":
        bust(400, 125, 1.3, hair=g.SHORT_HAIR, tilt=-6)
    elif kind == "bust_single_f":
        bust(400, 122, 1.3, hair=g.LONG_HAIR, tilt=-8)
    elif kind == "near_kiss":
        bust(335, 122, 1.3, hair=g.LONG_HAIR)
        bust(505, 116, 1.38, flip=True, hair=g.SHORT_HAIR)
    elif kind == "talk":
        bust(300, 128, 1.2, hair=g.LONG_HAIR, tilt=-4)
        bust(545, 122, 1.28, flip=True, hair=g.SHORT_HAIR, tilt=-4)
    elif kind == "blindfold":
        bust(335, 122, 1.3, hair=g.LONG_HAIR, blindfold=True)
        bust(505, 116, 1.38, flip=True, hair=g.SHORT_HAIR)
    elif kind == "back_f":
        back(g.BACK_F, 420, 104, 0.64)
    elif kind == "back_m":
        back(g.BACK_M, 420, 104, 0.64)
    elif kind == "forehead":
        bust(352, 124, 1.3, hair=g.LONG_HAIR, tilt=8)
        bust(488, 118, 1.38, flip=True, hair=g.SHORT_HAIR, tilt=8)
    elif kind == "massage":
        back(g.BACK_F, 350, 108, 0.66)
        bust(610, 122, 1.2, flip=True, hair=g.SHORT_HAIR, tilt=18)
    elif kind == "kiss_close":         # Spicy: ganz nah, Stirnen und Lippen fast ineinander, Haar im Wind
        bust(372, 124, 1.34, hair=g.LONG_HAIR, tilt=6)
        bust(468, 120, 1.4, flip=True, hair=g.SHORT_HAIR, tilt=6)
    elif kind == "spoon":              # Spicy: zwei Körper in einer Linie, die Wärme der anderen im Rücken
        recline(g.RECLINE_M, 78, 70, 1.04, schatten=True)
        recline(g.RECLINE_F, 112, 104, 1.02)
        b.raw(f'<path d="M30 245H820" stroke="{stil["linie"]}" stroke-opacity="0.35" stroke-width="1" fill="none"/>')
        funken(b, 12, nummer + 41)
    elif kind == "recline_sparks":
        recline(g.RECLINE_F, 95, 112, 1.0)
        b.raw(f'<path d="M30 243H820" stroke="{stil["linie"]}" stroke-opacity="0.35" stroke-width="1.2" fill="none"/>')
        funken(b, 14, nummer + 40)
    elif kind == "recline_pair":
        recline(g.RECLINE_M, 60, 74, 1.04, schatten=True)
        recline(g.RECLINE_F, 130, 120, 0.96)
        b.raw(f'<path d="M30 245H820" stroke="{stil["linie"]}" stroke-opacity="0.35" stroke-width="1.2" fill="none"/>')
        funken(b, 16, nummer + 41)
    return b.svg()


SPICY_KIND = {  # intimer als die Normalfassung: Nähe, Haut an Haut, nichts Frontales
    "bust_single": "recline_sparks", "bust_single_f": "recline_sparks", "talk": "kiss_close", "near_kiss": "kiss_close",
    "forehead": "kiss_close", "blindfold": "kiss_close", "massage": "spoon", "back_f": "back_f", "back_m": "back_m",
    "recline_sparks": "spoon", "recline_pair": "spoon",
}


def spicy_kind(kind):
    return SPICY_KIND[kind]


def alle():
    n = 0
    eintraege = [(k, v[0], i) for i, (k, v) in enumerate(g.GEFUEHRT.items())]
    eintraege += [(f"cover_{nr:02d}", v[0], nr) for nr, v in g.COVERS.items()]
    eintraege += [(f"ynm_{k}", v[0], 100 + i) for i, (k, v) in enumerate(g.YES_NO_MAYBE.items())]
    for name, kind, nr in eintraege:
        (OUT / f"{name}.svg").write_text(zeichne(kind, NORMAL, nr), encoding="utf-8", newline="\n")
        (OUT / f"{name}_spicy.svg").write_text(zeichne(spicy_kind(kind), SPICY, nr), encoding="utf-8", newline="\n")
        n += 2
    print(f"{n} Skizzen-Titelbilder geschrieben")


if __name__ == "__main__":
    alle()
