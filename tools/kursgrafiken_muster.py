"""Lokale SVG-/HTML-Designstudien, keine produktiven Assets ändern.

python tools/kursgrafiken_muster.py [--render]
Vorhandene Bilder nur lesen; sämtliche Bildausgaben bleiben im ignorierten build/.
"""
import argparse
import base64
import hashlib
import html
import json
from pathlib import Path
import re
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/designstudien/kursgrafiken'
ATTACH=ROOT/'.codex-remote-attachments/01a19710-1855-7460-bfcc-29bf0fbfb6d0/02ad3119-7be5-4032-a746-df9d91b01ae7'
PALETTES=json.loads((ROOT/'marketing/marke/v1/quellen/marke.json').read_text(encoding='utf-8'))['farben']
TOPICS=['course_neuro','course_touch_women','course_fantasies_shadow']
IMAGES={
    'course_touch_women': {
        'normal':ROOT/'tools/zeichnungen/touch_w_1.webp',
        'spicy':ATTACH/'2-57592.jpg',
    },
    'course_fantasies_shadow':{
        'normal':ROOT/'tools/zeichnungen/pos_2.webp',
        'spicy':ATTACH/'3-57590.jpg',
    },
}
COPY={
 'de':{
  'eyebrow':'VELVETPULSE / DESIGNSTUDIE 01',
  'title':'Weniger Kulisse. Mehr Erleben.',
  'intro':'Drei redaktionelle Bildideen. Gleiche Markenwelt, unterschiedliche Intensität. Titel und Kursnummer bleiben Text in der Oberfläche.',
  'modes':['Papier','Nachtpapier','Spicy'],
  'topics':[
   ['Raum für Wahrnehmung.','Mehr Spannung in der Bewegung.'],
   ['Berührung bewusst wahrnehmen.','Direkter Kontakt. Mehr Haut.'],
   ['Nähe, Vertrauen und Vorfreude.','Augenbinde, weiches Tuch und Halskuss.']
  ],
  'footer':'Gestaltungsmuster mit vorhandenen Zeichnungen. Keine App-Änderung. Spicy-Motive nur für den freigeschalteten Modus. Alle dargestellten Personen sind erwachsen.',
 },
 'en':{
  'eyebrow':'VELVETPULSE / DESIGN STUDY 01',
  'title':'Less scenery. More experience.',
  'intro':'Three editorial image concepts. One shared world, different intensity. Titles and course numbers remain live interface text.',
  'modes':['Paper','Night Paper','Spicy'],
  'topics':[
   ['Room for awareness.','More tension in the movement.'],
   ['Notice the touch.','Direct contact. More skin.'],
   ['Closeness, trust and anticipation.','Blindfold, soft fabric and a kiss on the neck.']
  ],
  'footer':'Design studies using existing drawings. No app changes. Spicy images are intended only for the enabled mode. All people depicted are adults.',
 }
}
sources=[]


def data_url(file):
    data=file.read_bytes();suffix=file.suffix.lower();mime={'.webp':'image/webp','.jpg':'image/jpeg','.png':'image/png'}[suffix]
    sources.append(dict(pfad=str(file),sha256=hashlib.sha256(data).hexdigest()))
    return f'data:{mime};base64,'+base64.b64encode(data).decode()


def geometry(spicy,p):
    """Abstrakte Aufmerksamkeit/Annäherung; keine Pseudo-Anatomie."""
    ink,rose=p['tinte'],p['akzent']
    soft=not spicy
    # Bewusste asymmetrische Komposition mit viel Luft und einem Bezugspunkt.
    d1=('M-40 428 C130 428 190 175 355 178 C500 180 491 420 640 425 C765 430 780 273 940 274'
        if soft else 'M-40 468 C133 479 160 108 341 153 C481 187 403 434 555 425 C718 415 691 144 940 181')
    d2=('M-25 485 C165 493 228 255 365 255 C506 255 560 453 687 445 C822 436 839 335 942 335'
        if soft else 'M-40 520 C174 508 208 272 343 285 C501 300 510 174 621 181 C785 191 771 443 940 438')
    lines=f'<path d="{d1}" stroke="{ink}" stroke-width="3.2"/><path d="{d2}" stroke="{rose}" stroke-width="4.2"/>'
    if spicy:lines+=f'<path d="M-30 551 C190 544 270 382 370 386 C526 393 566 315 659 319 C788 324 842 500 947 489" stroke="{rose}" stroke-opacity=".35" stroke-width="1.1"/>'
    return f'''<g fill="none" stroke-linecap="round">{lines}
      <path d="M128 100H321M128 94V106M321 94V106" stroke="{rose}" stroke-width="1" stroke-opacity=".7"/>
      <circle cx="712" cy="172" r="54" stroke="{ink}" stroke-opacity=".15" stroke-width=".9"/>
      <path d="M712 107V237M647 172H777" stroke="{ink}" stroke-opacity=".16" stroke-width=".7"/>
      </g>'''


def make_svg(topic,mode):
    p=PALETTES[mode];spicy=mode=='spicy'
    if topic=='course_neuro':
        art=geometry(spicy,p)
    else:
        file=IMAGES[topic]['spicy' if spicy else 'normal']
        # Bildinhalt bleibt unverändert. Nur eine vorhandene Zeichnung ins
        # kanonische Bildfeld setzen; keine neue Figur oder Hand nachzeichnen.
        uri=data_url(file)
        art=f'<image href="{uri}" x="0" y="0" width="900" height="600" preserveAspectRatio="xMidYMid slice"/>'
    svg=f'<svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 900 600"><rect width="900" height="600" fill="{p["grund"]}"/>{art}</svg>'
    ET.fromstring(svg)
    assert '<text' not in svg
    return svg


def page(lang,comparison=False):
    text=COPY[lang];columns=['papier','spicy'] if comparison else ['papier','nachtpapier','spicy']
    db=json.loads((ROOT/('assets/data/velvet_content.json' if lang=='de' else 'translations/en/velvet_content.json')).read_text(encoding='utf-8'))
    courses={c['id']:c for c in db['courses']}
    cards=[]
    for idx,topic in enumerate(TOPICS):
        course=courses[topic]
        title=course['title'];number=re.match(r'\d+',title).group()
        title=re.sub(r'^\d+\.\s*','',title)
        for mode in columns:
            p=PALETTES[mode];mi=['papier','nachtpapier','spicy'].index(mode)
            label=text['modes'][mi];desc=text['topics'][idx][1 if mode=='spicy' else 0]
            cards.append(f'''<article style="--paper:{p['grund']};--ink:{p['tinte']};--quiet:{p['sekundaer']};--rose:{p['akzent_text']};--line:{p['linie']}">
              <div class="top"><span>{label}</span><span>{number.zfill(2)}</span></div>
              <h2>{html.escape(title)}</h2>
              <img src="{topic}-{mode}.svg" alt=""/>
              <p class="caption">{html.escape(desc)}</p>
             </article>''')
    cols=len(columns);width=1500 if cols==3 else 1440
    serif=(ROOT/'assets/fonts/SourceSerif4-Regular.ttf').as_uri()
    return f'''<!doctype html><html lang="{lang}"><meta charset="utf-8"><title>VelvetPulse / Grafikmuster</title>
    <style>@font-face{{font-family:Serif;src:url('{serif}')}}*{{box-sizing:border-box}}
    body{{margin:0;background:#E7E1D7;font-family:'Segoe UI',Arial,sans-serif;color:#2A2A2C}}
    main{{width:{width}px;padding:50px}}
    header{{padding:0 0 35px}}.eyebrow{{font-size:12px;letter-spacing:1.7px;color:#8E4A57}}
    h1{{font-family:Serif,serif;font-size:44px;font-weight:400;margin:13px 0 10px}}
    header p{{font-size:16px;line-height:1.5;max-width:1050px;margin:0;color:#5A5750}}
    .grid{{display:grid;grid-template-columns:repeat({cols},1fr);gap:24px}}
    article{{min-width:0;background:var(--paper);color:var(--ink);padding:24px 24px 18px}}
    .top{{display:flex;justify-content:space-between;color:var(--rose);font-size:12px;text-transform:uppercase;letter-spacing:1px}}
    h2{{font-family:Serif,serif;font-size:{27 if cols==3 else 30}px;font-weight:400;line-height:1.2;margin:17px 0 21px;min-height:{100 if cols==3 else 78}px}}
    img{{display:block;width:100%;height:auto;aspect-ratio:3/2;object-fit:cover}}
    .caption{{color:var(--quiet);font-size:14px;line-height:1.4;margin:18px 0 0;padding-top:14px;border-top:1px solid var(--line);min-height:52px}}
    footer{{font-size:12px;color:#5A5750;line-height:1.5;padding-top:25px;max-width:1100px}}
    </style><main><header><div class="eyebrow">{text['eyebrow']}</div><h1>{text['title']}</h1><p>{text['intro']}</p></header>
    <section class="grid">{''.join(cards)}</section><footer>{text['footer']}</footer></main></html>'''


def make():
    OUT.mkdir(parents=True,exist_ok=True)
    for topic in TOPICS:
        for mode in ['papier','nachtpapier','spicy']:
            (OUT/f'{topic}-{mode}.svg').write_text(make_svg(topic,mode),encoding='utf-8')
    for lang in ('de','en'):
        (OUT/f'galerie-{lang}.html').write_text(page(lang),encoding='utf-8')
        (OUT/f'vergleich-{lang}.html').write_text(page(lang,True),encoding='utf-8')
    (OUT/'herkunft.json').write_text(json.dumps(list({s['pfad']:s for s in sources}.values()),ensure_ascii=False,indent=2),encoding='utf-8')
    print('9 wortfreie SVG-Muster und 4 DE/EN-Vorschauseiten erstellt.')


def render():
    from playwright.sync_api import sync_playwright
    errors=[]
    with sync_playwright() as pw:
        browser=pw.chromium.launch(executable_path='C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless=True,args=['--allow-file-access-from-files'])
        for kind in ('galerie','vergleich'):
            width=1500 if kind=='galerie' else 1440
            for lang in ('de','en'):
                page=browser.new_page(viewport=dict(width=width,height=1000),device_scale_factor=1)
                page.goto((OUT/f'{kind}-{lang}.html').as_uri());page.evaluate('document.fonts.ready');page.wait_for_load_state('networkidle')
                broken=page.locator('img').evaluate_all('(xs)=>xs.filter(x=>!x.complete||x.naturalWidth===0).map(x=>x.src)')
                assert not broken,broken
                overflow=page.locator('h1,h2,p,.top').evaluate_all('(xs)=>xs.filter(x=>x.scrollWidth>x.clientWidth+1||x.scrollHeight>x.clientHeight+1).map(x=>x.innerText)')
                errors += [dict(seite=f'{kind}-{lang}',text=t) for t in overflow]
                page.screenshot(path=str(OUT/f'{kind}-{lang}.png'),full_page=True)
                if kind=='vergleich' and lang=='de':
                    for i,card in enumerate(page.locator('article').all()):card.screenshot(path=str(OUT/f'muster-{i+1:02}.png'))
                page.close()
        browser.close()
    (OUT/'pruefung.json').write_text(json.dumps(dict(svg=9,html=4,textueberlaeufe=errors),ensure_ascii=False,indent=2),encoding='utf-8')
    assert not errors,errors
    print('DE/EN gerendert, alle Bildfelder geladen, keine Textüberläufe.')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--render',action='store_true');args=parser.parse_args()
    make()
    if args.render:render()
