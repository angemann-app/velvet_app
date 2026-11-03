"""Erzeugt native SVG-Master, Anwendungen und editierbare Marken-Vorlagen.

python tools/markenpaket.py [--render]
Keine App-Dateien ändern. Schriftpfade vorher mit marke_schriftpfade.ps1 erzeugen.
"""
import argparse
import base64
import html
import json
import math
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'marketing/marke/v1'
DATA = json.loads((OUT / 'quellen/marke.json').read_text(encoding='utf-8'))
WORD = json.loads((OUT / 'quellen/wortmarke-pfade.json').read_text(encoding='utf-8-sig'))
SERIF = base64.b64encode((ROOT / 'assets/fonts/SourceSerif4-Regular.ttf').read_bytes()).decode()


def outline():
    result = []
    i = 0
    points = WORD['punkte']
    while i < len(points):
        x, y, kind = points[i]
        base = kind & 7
        if base in (0, 1):
            result.append(f'{"M" if base == 0 else "L"}{x:.3f},{y:.3f}')
            if kind & 128:
                result.append('Z')
            i += 1
        else:
            assert base == 3 and i + 2 < len(points)
            triple = points[i:i + 3]
            result.append('C' + ' '.join(f'{a:.3f},{b:.3f}' for a, b, _ in triple))
            if triple[-1][2] & 128:
                result.append('Z')
            i += 3
    return ''.join(result)


WORD_PATH = outline()


def arc(start, end):
    n = math.ceil(abs(end - start) / 90)
    result = []
    for i in range(n):
        a = math.radians(start + (end - start) * i / n)
        b = math.radians(start + (end - start) * (i + 1) / n)
        k = 4 / 3 * math.tan((b - a) / 4)
        p = (128 + 94 * math.cos(a), 128 + 94 * math.sin(a))
        q = (128 + 94 * math.cos(b), 128 + 94 * math.sin(b))
        c1 = (p[0] - k * 94 * math.sin(a), p[1] + k * 94 * math.cos(a))
        c2 = (q[0] + k * 94 * math.sin(b), q[1] - k * 94 * math.cos(b))
        if i == 0:
            result.append(f'M{p[0]:.3f},{p[1]:.3f}')
        result.append(f'C{c1[0]:.3f},{c1[1]:.3f} {c2[0]:.3f},{c2[1]:.3f} {q[0]:.3f},{q[1]:.3f}')
    return ''.join(result)


V = 'M66,104 C84,96 97,129 111,151 C122,169 133,170 144,152 L165,117 C177,99 190,98 202,111'


def mark(ink, accent, compact=False):
    ring = 13 if compact else 9.5
    line = 17 if compact else 12
    return (f'<g fill="none" stroke-linecap="round" stroke-linejoin="round">'
            f'<path d="{arc(45, 310)}" stroke="{ink}" stroke-width="{ring}"/>'
            f'<path d="{arc(310, 348)}" stroke="{accent}" stroke-width="{ring}"/>'
            f'<path d="{V}" stroke="{ink}" stroke-width="{line}"/></g>')


def logo(kind='horizontal', ink='#2A2A2C', accent='#B47C84'):
    if kind == 'signet':
        return mark(ink, accent), 256, 256
    if kind == 'kompakt':
        return mark(ink, ink, True), 256, 256
    if kind == 'gestapelt':
        return (f'<g transform="translate(192 0)">{mark(ink, accent)}</g>'
                f'<path d="{WORD_PATH}" transform="translate(38.864 277)" fill="{ink}"/>', 640, 410)
    return (f'<g transform="translate(0 0) scale(.72)">{mark(ink, accent)}</g>'
            f'<path d="{WORD_PATH}" transform="translate(216 50)" fill="{ink}"/>', 810, 184)


def svg(body, w, h, title, font=False):
    style = (f'<style>@font-face{{font-family:VPSerif;src:url(data:font/ttf;base64,{SERIF})}}'
             'text{font-family:VPSerif,Georgia,serif}.ui{font-family:Segoe UI,Arial,sans-serif}</style>') if font else ''
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" role="img">'
            f'<title>{html.escape(title)}</title>{style}{body}</svg>')


def text(lines, x, y, size, fill, ui=False, leading=1.13):
    return ''.join(f'<text x="{x}" y="{y + i * size * leading:.2f}" font-size="{size}" fill="{fill}"'
                   f' class="{"ui" if ui else "serif"}">{html.escape(line)}</text>' for i, line in enumerate(lines))


def put(relative, content):
    target = OUT / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding='utf-8')


def art():
    return base64.b64encode((OUT / 'bildwelt/naehe-graphit.png').read_bytes()).decode()


def rule(y, w, color):
    return f'<path d="M72,{y} H{w - 72}" stroke="{color}" stroke-width="1.5"/>'


def make():
    for name, ink, accent in [('papier', '#2A2A2C', '#B47C84'), ('hell', '#F3E8E2', '#D07A8E'),
                              ('einfarbig-dunkel', '#2A2A2C', '#2A2A2C'), ('einfarbig-weiss', '#FFFFFF', '#FFFFFF')]:
        for kind in ('horizontal', 'gestapelt', 'signet'):
            body, w, h = logo(kind, ink, accent)
            put(f'logos/velvetpulse-{kind}-{name}.svg', svg(body, w, h, f'VelvetPulse · {kind} · {name}'))
    for name, ink in [('dunkel', '#2A2A2C'), ('weiss', '#FFFFFF')]:
        body, w, h = logo('kompakt', ink, ink)
        put(f'logos/velvetpulse-kompakt-{name}.svg', svg(body, w, h, 'VelvetPulse · kompaktes Signet'))
    for name, bg, ink, accent in [('papier', '#F6F0E6', '#2A2A2C', '#B47C84'),
                                 ('spicy', '#1F1017', '#F3E8E2', '#D07A8E')]:
        put(f'icons/app-symbol-{name}-1024.svg', svg(f'<path fill="{bg}" d="M0 0H1024V1024H0Z"/>'
            f'<g transform="translate(112 112) scale(3.125)">{mark(ink, accent)}</g>', 1024, 1024, f'VelvetPulse · App-Symbol {name}'))
        put(f'icons/avatar-{name}-512.svg', svg(f'<circle cx="256" cy="256" r="256" fill="{bg}"/>'
            f'<g transform="translate(56 56) scale(1.5625)">{mark(ink, accent)}</g>', 512, 512, f'VelvetPulse · Avatar {name}'))
    put('icons/favicon-32.svg', svg(f'<g transform="scale(.125)">{mark("#2A2A2C", "#2A2A2C", True)}</g>', 32, 32, 'VelvetPulse'))
    # Wiederkehrende grafische Elemente separat; keine Dekoration im eigentlichen Logo.
    put('elemente/konstruktionsbogen.svg', svg('<path d="M80 560 A480 480 0 0 1 880 200" fill="none" stroke="#B47C84" stroke-width="1.3"/>'
        '<path d="M80 80V580M60 560H900M860 140V220M820 180H900" fill="none" stroke="#D8CFBF"/>', 960, 640, 'Redaktioneller Konstruktionsbogen'))
    put('elemente/eckmarkierungen.svg', svg('<path d="M24 0V48M0 24H48M456 0V48M432 24H480M24 272V320M0 296H48M456 272V320M432 296H480" '
        'fill="none" stroke="#B47C84" stroke-width="1"/>', 480, 320, 'Redaktionelle Eckmarkierungen'))
    base, _, _ = logo()
    dark, _, _ = logo(ink='#F3E8E2', accent='#D07A8E')
    picture = art()
    # Alle Texte bleiben als Text editierbar; Logo selbst ist vollständig in Pfade umgewandelt.
    body = '<path fill="#F6F0E6" d="M0 0H1080V1350H0Z"/>' + f'<g transform="translate(72 65) scale(.77)">{base}</g>'
    body += text(['TRAUMPRAXIS'], 78, 290, 25, '#8E4A57', True)
    body += text(['Deine Nacht.', 'Dein Raum', 'zum Entdecken.'], 72, 410, 95, '#2A2A2C')
    body += text(['Nimm deine Lust mit in den Traum.', 'Und etwas davon mit in den Tag.'], 78, 780, 29, '#5A5750', True, 1.5)
    body += f'<image x="60" y="820" width="960" height="430" href="data:image/png;base64,{picture}" preserveAspectRatio="xMidYMid meet"/>'
    body += rule(1270, 1080, '#D8CFBF') + text(['Dein Körper. Dein Erleben.'], 78, 1310, 25, '#8E4A57')
    put('vorlagen/feed-traumpraxis-1080x1350.svg', svg(body, 1080, 1350, 'VelvetPulse · Traumpraxis · Feed', True))
    body = '<path fill="#1F1017" d="M0 0H1080V1920H0Z"/>' + f'<g transform="translate(80 110) scale(.95)">{dark}</g>'
    body += text(['ZEIT FÜR DICH'], 90, 480, 27, '#EDB3C0', True)
    body += text(['Was spürst du,', 'wenn du dir', 'Raum gibst?'], 80, 670, 112, '#F3E8E2', leading=1.2)
    body += f'<g transform="translate(340 1150) scale(1.6)">{mark("#F3E8E2", "#D07A8E")}</g>'
    body += text(['Verstehen. Spüren. Verbinden.'], 90, 1680, 39, '#EDB3C0')
    body += rule(1775, 1080, '#55303F') + text(['Dein Körper. Dein Erleben.'], 90, 1840, 31, '#D2BCBC', True)
    put('vorlagen/story-marke-1080x1920.svg', svg(body, 1080, 1920, 'VelvetPulse · Story', True))
    body = '<path fill="#FBF7F0" d="M0 0H1080V1080H0Z"/>' + f'<g transform="translate(80 80) scale(.68)">{base}</g>'
    body += text(['DEIN MOMENT'], 86, 350, 25, '#8E4A57', True)
    body += text(['Nähe beginnt', 'mit einem', 'Moment', 'Aufmerksamkeit.'], 80, 480, 83, '#2A2A2C', leading=1.12)
    body += rule(960, 1080, '#D8CFBF') + text(['Für dich. Oder für euch.'], 86, 1015, 29, '#8E4A57')
    put('vorlagen/zitat-1080x1080.svg', svg(body, 1080, 1080, 'VelvetPulse · redaktionelle Zitatkarte', True))
    body = '<path fill="#F6F0E6" d="M0 0H1200V630H0Z"/>' + f'<g transform="translate(62 40) scale(.63)">{base}</g>'
    body += text(['Verstehen.', 'Spüren.', 'Verbinden.'], 65, 265, 75, '#2A2A2C')
    body += text(['Körperwissen und Nähe.', 'In deinem Tempo.'], 70, 565, 25, '#5A5750', True, 1.4)
    body += f'<image x="560" y="130" width="600" height="470" href="data:image/png;base64,{picture}" preserveAspectRatio="xMidYMid meet"/>'
    put('vorlagen/banner-1200x630.svg', svg(body, 1200, 630, 'VelvetPulse · Banner', True))
    english_templates(base, dark, picture)
    body = '<path fill="#FFFFFF" d="M0 0H794V1123H0Z"/>' + f'<g transform="translate(56 40) scale(.57)">{base}</g>'
    body += '<path d="M56 1020H738" stroke="#D8CFBF"/>' + text(['Dein Körper. Dein Erleben.'], 60, 1060, 17, '#8E4A57')
    put('vorlagen/briefpapier-a4.svg', svg(body, 794, 1123, 'VelvetPulse · Briefpapier A4', True))
    body = '<path fill="#1F1017" d="M0 0H1920V1080H0Z"/>' + f'<g transform="translate(100 75) scale(1.1)">{dark}</g>'
    body += text(['Raum für', 'eigenes Erleben.'], 100, 510, 116, '#F3E8E2')
    body += text(['Verstehen. Spüren. Verbinden.'], 110, 900, 42, '#EDB3C0')
    body += f'<g transform="translate(1390 400) scale(1.4)">{mark("#F3E8E2", "#D07A8E")}</g>'
    put('vorlagen/praesentationscover-1920x1080.svg', svg(body, 1920, 1080, 'VelvetPulse · Präsentationscover', True))
    # Ein sauberer Überblick ohne Bildgenerierung: native Logos und reale Vorlagen.
    brandboard(base, dark)
    print('SVG-Master, vier Vorlagen und Markenübersicht erzeugt.')


def english_templates(base, dark, picture):
    body = '<path fill="#F6F0E6" d="M0 0H1080V1350H0Z"/>' + f'<g transform="translate(72 65) scale(.77)">{base}</g>'
    body += text(['DREAM PRACTICE'], 78, 290, 25, '#8E4A57', True)
    body += text(['Your night.', 'Your space', 'to explore.'], 72, 410, 95, '#2A2A2C')
    body += text(['Take your desire into your dreams.', 'Bring something of it into your day.'], 78, 780, 29, '#5A5750', True, 1.5)
    body += f'<image x="60" y="820" width="960" height="430" href="data:image/png;base64,{picture}" preserveAspectRatio="xMidYMid meet"/>'
    body += rule(1270, 1080, '#D8CFBF') + text(['Your body. Your experience.'], 78, 1310, 25, '#8E4A57')
    put('vorlagen/feed-traumpraxis-1080x1350-en.svg', svg(body, 1080, 1350, 'VelvetPulse · Dream practice · Feed', True))
    body = '<path fill="#1F1017" d="M0 0H1080V1920H0Z"/>' + f'<g transform="translate(80 110) scale(.95)">{dark}</g>'
    body += text(['A MOMENT FOR YOU'], 90, 480, 27, '#EDB3C0', True)
    body += text(['What do you feel', 'when you give', 'yourself room?'], 80, 670, 106, '#F3E8E2', leading=1.2)
    body += f'<g transform="translate(340 1150) scale(1.6)">{mark("#F3E8E2", "#D07A8E")}</g>'
    body += text(['Understand. Feel. Connect.'], 90, 1680, 39, '#EDB3C0')
    body += rule(1775, 1080, '#55303F') + text(['Your body. Your experience.'], 90, 1840, 31, '#D2BCBC', True)
    put('vorlagen/story-marke-1080x1920-en.svg', svg(body, 1080, 1920, 'VelvetPulse · Story · English', True))
    body = '<path fill="#FBF7F0" d="M0 0H1080V1080H0Z"/>' + f'<g transform="translate(80 80) scale(.68)">{base}</g>'
    body += text(['YOUR MOMENT'], 86, 350, 25, '#8E4A57', True)
    body += text(['Closeness begins', 'with a moment', 'of attention.'], 80, 480, 83, '#2A2A2C', leading=1.12)
    body += rule(960, 1080, '#D8CFBF') + text(['For you. Or for both of you.'], 86, 1015, 29, '#8E4A57')
    put('vorlagen/zitat-1080x1080-en.svg', svg(body, 1080, 1080, 'VelvetPulse · Quote · English', True))
    body = '<path fill="#F6F0E6" d="M0 0H1200V630H0Z"/>' + f'<g transform="translate(62 40) scale(.63)">{base}</g>'
    body += text(['Understand.', 'Feel.', 'Connect.'], 65, 265, 75, '#2A2A2C')
    body += text(['Body knowledge and closeness.', 'At your own pace.'], 70, 565, 25, '#5A5750', True, 1.4)
    body += f'<image x="560" y="130" width="600" height="470" href="data:image/png;base64,{picture}" preserveAspectRatio="xMidYMid meet"/>'
    put('vorlagen/banner-1200x630-en.svg', svg(body, 1200, 630, 'VelvetPulse · Banner · English', True))


def brandboard(base, dark):
    body = '<path fill="#F6F0E6" d="M0 0H1600V1200H0Z"/>'
    body += text(['VELVETPULSE / MARKENAUFTRITT 01'], 70, 67, 20, '#8E4A57', True)
    body += f'<g transform="translate(65 120) scale(1.30)">{base}</g>'
    body += text(['Dein Körper. Dein Erleben.'], 77, 420, 52, '#2A2A2C')
    body += text(['Verstehen. Spüren. Verbinden.'], 80, 485, 28, '#5A5750', True)
    body += f'<image x="800" y="380" width="720" height="460" href="data:image/png;base64,{art()}" preserveAspectRatio="xMidYMid meet"/>'
    for i, (name, fill) in enumerate([('Papier', '#F6F0E6'), ('Graphit', '#2A2A2C'), ('Rosé', '#B47C84'), ('Bordeaux', '#1F1017')]):
        x = 80 + i * 158
        body += f'<rect x="{x}" y="590" width="132" height="88" fill="{fill}" stroke="#D8CFBF"/>'
        body += text([name, fill], x, 712, 19, '#5A5750', True, 1.5)
    body += '<path fill="#1F1017" d="M0 855H1600V1200H0Z"/>'
    body += f'<g transform="translate(65 900) scale(.92)">{dark}</g>'
    body += text(['Eine Marke.', 'Drei Atmosphären.'], 950, 955, 45, '#F3E8E2')
    body += text(['Papier · Nachtpapier · Spicy'], 955, 1095, 23, '#EDB3C0', True)
    put('vorschau/markenuebersicht.svg', svg(body, 1600, 1200, 'VelvetPulse · Markenübersicht', True))


def render():
    from playwright.sync_api import sync_playwright
    from PIL import Image
    errors = []
    files = sorted(OUT.rglob('*.svg'))
    with sync_playwright() as p:
        browser = p.chromium.launch(executable_path=r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe', headless=True)
        page = browser.new_page()
        for file in files:
            root = ET.fromstring(file.read_text(encoding='utf-8'))
            width, height = int(root.attrib['width']), int(root.attrib['height'])
            page.set_viewport_size({'width': width, 'height': height})
            page.goto(file.as_uri(), wait_until='load')
            page.evaluate('async () => { await document.fonts.ready; }')
            bounds = page.evaluate('''() => Array.from(document.querySelectorAll('text')).map(e=>{
              const b=e.getBBox();return {text:e.textContent,x:b.x,y:b.y,w:b.width,h:b.height};})''')
            for b in bounds:
                if b['x'] < 0 or b['y'] < 0 or b['x'] + b['w'] > width or b['y'] + b['h'] > height:
                    errors.append({'datei': file.name, 'text': b})
            page.screenshot(path=str(file.with_suffix('.png')), omit_background=True)
            with Image.open(file.with_suffix('.png')) as im:
                assert im.size == (width, height)
        browser.close()
    (OUT / 'quellen/renderpruefung.json').write_text(json.dumps({'svg_dateien': len(files), 'fehler': errors}, ensure_ascii=False, indent=2), encoding='utf-8')
    assert not errors, errors
    print(f'{len(files)} SVGs gerendert; Textgrenzen ohne Befund.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--render', action='store_true')
    args = parser.parse_args()
    make()
    if args.render:
        render()
