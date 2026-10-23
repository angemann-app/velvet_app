"""Erzeugt die Technik-Grafiken des Kurses „Sich selbst erkunden“.

  assets/images/diagram_selbst_vulva.svg  – sechs Berührungsarten an der Vulva
  assets/images/diagram_selbst_penis.svg  – sechs Berührungsarten am Penis

Format 800x600 wie alle Diagramme (die App zeigt sie mit Seitenverhältnis 4:3, antippbar zum Zoomen).
Aufruf: python tools/generate_diagrams.py
"""
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "assets" / "images"

HEAD = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 600" width="800" height="600">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#140D1C"/><stop offset="1" stop-color="#0F172A"/>
    </linearGradient>
    <linearGradient id="skin" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#E2AA92"/><stop offset="1" stop-color="#C98A74"/>
    </linearGradient>
    <linearGradient id="inner" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#C9687A"/><stop offset="1" stop-color="#A84C60"/>
    </linearGradient>
    <linearGradient id="glans" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#E39AA2"/><stop offset="1" stop-color="#C46E7C"/>
    </linearGradient>
  </defs>
  <rect width="800" height="600" fill="url(#bg)"/>
"""
ARROW = "#FBBF24"
FINGER = "#F5D0C0"

# Raster: 3 Spalten x 2 Zeilen, Feldmitte (cx, cy)
CELLS = [(135, 170), (400, 170), (665, 170), (135, 445), (400, 445), (665, 445)]


def cell_frame(cx, cy, number, label):
    label = label.replace("&", "&amp;")
    return (f'  <rect x="{cx - 125}" y="{cy - 145}" width="250" height="270" rx="18" fill="#1E293B" opacity="0.55"/>\n'
            f'  <circle cx="{cx - 98}" cy="{cy - 118}" r="17" fill="{ARROW}"/>'
            f'<text x="{cx - 98}" y="{cy - 111}" text-anchor="middle" font-family="sans-serif" font-size="20" '
            f'font-weight="800" fill="#1A1224">{number}</text>\n'
            f'  <text x="{cx}" y="{cy + 112}" text-anchor="middle" font-family="sans-serif" font-size="22" '
            f'font-weight="700" fill="#F1F5F9">{label}</text>\n')


def arrowhead(x, y, angle):
    return (f'<polygon points="0,-9 18,0 0,9" fill="{ARROW}" '
            f'transform="translate({x} {y}) rotate({angle})"/>')


# ── Vulva (Ausschnitt: Venushügel, Vorhaut, Klitoris, obere Schamlippen) ────

def vulva(cx, cy):
    return (f'<g transform="translate({cx} {cy})">'
            f'<path d="M0 -95 C-62 -92 -86 -40 -84 20 C-82 60 -58 85 0 92 C58 85 82 60 84 20 C86 -40 62 -92 0 -95 Z" '
            f'fill="url(#skin)" stroke="#8C5546" stroke-width="2"/>'
            f'<path d="M0 -55 C-22 -42 -30 -10 -26 22 C-22 52 -10 75 0 82 C10 75 22 52 26 22 C30 -10 22 -42 0 -55 Z" '
            f'fill="url(#inner)" stroke="#7E3346" stroke-width="2"/>'
            f'<path d="M-20 -30 C-20 -58 20 -58 20 -30 C12 -38 -12 -38 -20 -30 Z" fill="#B85A6D" stroke="#7E3346" stroke-width="1.5"/>'
            f'<circle cx="0" cy="-27" r="6" fill="#F4A6B4" stroke="#7E3346" stroke-width="1.2"/>'
            f'</g>')


def vulva_cells():
    s = ""
    cx, cy = CELLS[0]  # Kreisen
    s += cell_frame(cx, cy, 1, "Kreisen") + vulva(cx, cy - 20)
    s += (f'<circle cx="{cx}" cy="{cy - 47}" r="30" fill="none" stroke="{ARROW}" stroke-width="5" stroke-dasharray="12 8"/>'
          + arrowhead(cx + 30, cy - 52, 90))
    cx, cy = CELLS[1]  # Auf und ab
    s += cell_frame(cx, cy, 2, "Auf und ab") + vulva(cx, cy - 20)
    s += (f'<path d="M{cx + 46} {cy - 95} L{cx + 46} {cy + 5}" stroke="{ARROW}" stroke-width="5" stroke-linecap="round"/>'
          + arrowhead(cx + 46, cy - 100, -90) + arrowhead(cx + 46, cy + 10, 90)
          + f'<rect x="{cx - 9}" y="{cy - 75}" width="18" height="46" rx="9" fill="{FINGER}" opacity="0.85"/>')
    cx, cy = CELLS[2]  # Seitwärts
    s += cell_frame(cx, cy, 3, "Seitwärts") + vulva(cx, cy - 20)
    s += (f'<path d="M{cx - 50} {cy - 47} L{cx + 50} {cy - 47}" stroke="{ARROW}" stroke-width="5" stroke-linecap="round"/>'
          + arrowhead(cx - 55, cy - 47, 180) + arrowhead(cx + 55, cy - 47, 0))
    cx, cy = CELLS[3]  # Drücken & halten
    s += cell_frame(cx, cy, 4, "Drücken & halten") + vulva(cx, cy - 20)
    s += (f'<ellipse cx="{cx}" cy="{cy - 70}" rx="62" ry="40" fill="{FINGER}" opacity="0.55" stroke="{ARROW}" stroke-width="4"/>'
          + arrowhead(cx, cy - 122, 90))
    cx, cy = CELLS[4]  # Rahmen
    s += cell_frame(cx, cy, 5, "Rahmen (V)") + vulva(cx, cy - 20)
    s += (f'<rect x="{cx - 34}" y="{cy - 92}" width="16" height="58" rx="8" fill="{FINGER}" opacity="0.9" transform="rotate(-12 {cx - 26} {cy - 63})"/>'
          f'<rect x="{cx + 18}" y="{cy - 92}" width="16" height="58" rx="8" fill="{FINGER}" opacity="0.9" transform="rotate(12 {cx + 26} {cy - 63})"/>'
          f'<path d="M{cx + 62} {cy - 90} L{cx + 62} {cy - 20}" stroke="{ARROW}" stroke-width="5" stroke-linecap="round"/>'
          + arrowhead(cx + 62, cy - 95, -90) + arrowhead(cx + 62, cy - 15, 90))
    cx, cy = CELLS[5]  # Klopfen
    s += cell_frame(cx, cy, 6, "Leicht klopfen") + vulva(cx, cy - 20)
    s += (f'<rect x="{cx - 9}" y="{cy - 112}" width="18" height="44" rx="9" fill="{FINGER}" opacity="0.9"/>'
          f'<g stroke="{ARROW}" stroke-width="4" stroke-linecap="round">'
          f'<path d="M{cx - 30} {cy - 60} L{cx - 42} {cy - 66}"/><path d="M{cx + 30} {cy - 60} L{cx + 42} {cy - 66}"/>'
          f'<path d="M{cx - 28} {cy - 46} L{cx - 42} {cy - 44}"/><path d="M{cx + 28} {cy - 46} L{cx + 42} {cy - 44}"/></g>')
    return s


# ── Penis (Seitenansicht, liegend) ──────────────────────────────────────────

def penis(cx, cy):
    return (f'<g transform="translate({cx - 95} {cy - 30})">'
            f'<path d="M0 30 C10 75 55 85 70 55 C78 40 60 25 40 26 Z" fill="#C98A74" stroke="#7A4A3B" stroke-width="2"/>'
            f'<path d="M0 -6 C60 -14 120 -20 160 -22 C166 -6 166 14 160 30 C120 32 60 36 4 44 C0 30 -2 10 0 -6 Z" '
            f'fill="url(#skin)" stroke="#7A4A3B" stroke-width="2"/>'
            f'<path d="M156 -26 C182 -36 214 -26 220 -2 C226 22 204 38 176 38 C168 38 162 36 158 34 C168 18 168 -10 156 -26 Z" '
            f'fill="url(#glans)" stroke="#7A3E4A" stroke-width="2"/>'
            f'</g>')


def hand(x, y, w, h, angle=0):
    return (f'<rect x="{x - w / 2}" y="{y - h / 2}" width="{w}" height="{h}" rx="{h / 2}" fill="{FINGER}" '
            f'opacity="0.6" stroke="{ARROW}" stroke-width="3" transform="rotate({angle} {x} {y})"/>')


def penis_cells():
    s = ""
    cx, cy = CELLS[0]  # Offene Hand
    s += cell_frame(cx, cy, 1, "Offene Hand") + penis(cx, cy - 20)
    s += hand(cx - 5, cy - 72, 120, 34) + f'<path d="M{cx - 70} {cy - 100} L{cx + 50} {cy - 104}" stroke="{ARROW}" stroke-width="5"/>' + arrowhead(cx + 55, cy - 104, 0)
    cx, cy = CELLS[1]  # Zweihand-Gleiten
    s += cell_frame(cx, cy, 2, "Zweihand-Gleiten") + penis(cx, cy - 20)
    s += hand(cx - 45, cy - 34, 36, 80) + hand(cx + 25, cy - 40, 36, 80)
    s += f'<path d="M{cx - 75} {cy - 95} L{cx + 55} {cy - 99}" stroke="{ARROW}" stroke-width="5"/>' + arrowhead(cx + 60, cy - 99, 0)
    cx, cy = CELLS[2]  # Drehen
    s += cell_frame(cx, cy, 3, "Drehen") + penis(cx, cy - 20)
    s += hand(cx - 10, cy - 38, 40, 84)
    s += (f'<path d="M{cx - 42} {cy - 92} C{cx - 20} {cy - 108} {cx + 10} {cy - 108} {cx + 28} {cy - 92}" fill="none" stroke="{ARROW}" stroke-width="5"/>'
          + arrowhead(cx + 30, cy - 90, 50) + arrowhead(cx - 44, cy - 90, 130))
    cx, cy = CELLS[3]  # Ring an der Wurzel
    s += cell_frame(cx, cy, 4, "Ring an der Wurzel") + penis(cx, cy - 20)
    s += f'<ellipse cx="{cx - 88}" cy="{cy - 30}" rx="14" ry="36" fill="none" stroke="{ARROW}" stroke-width="6" stroke-dasharray="10 5"/>'
    cx, cy = CELLS[4]  # Bändchen
    s += cell_frame(cx, cy, 5, "Bändchen") + penis(cx, cy - 20)
    s += (f'<circle cx="{cx + 68}" cy="{cy - 14}" r="9" fill="#FB7185" stroke="#FFFFFF" stroke-width="2"/>'
          f'<circle cx="{cx + 68}" cy="{cy - 14}" r="26" fill="none" stroke="{ARROW}" stroke-width="4" stroke-dasharray="9 6"/>')
    cx, cy = CELLS[5]  # Hoden & Damm
    s += cell_frame(cx, cy, 6, "Hoden & Damm") + penis(cx, cy - 20)
    s += (f'<ellipse cx="{cx - 62}" cy="{cy + 32}" rx="40" ry="18" fill="{FINGER}" opacity="0.55" stroke="{ARROW}" stroke-width="3"/>'
          f'<circle cx="{cx - 110}" cy="{cy + 40}" r="20" fill="none" stroke="#34D399" stroke-width="4" stroke-dasharray="8 5"/>')
    return s


if __name__ == "__main__":
    (OUT / "diagram_selbst_vulva.svg").write_text(HEAD + vulva_cells() + "\n</svg>\n", encoding="utf-8")
    (OUT / "diagram_selbst_penis.svg").write_text(HEAD + penis_cells() + "\n</svg>\n", encoding="utf-8")
    print("diagram_selbst_vulva.svg, diagram_selbst_penis.svg geschrieben")
