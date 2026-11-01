"""Prüft neue SVGs strukturell; optional Browserprüfung und lokale Kontaktbögen.

python tools/diagramme_magazin_pruefen.py --browser
Browserprüfung benötigt Playwright und den lokal installierten Edge.
"""
import argparse
import base64
import json
from pathlib import Path
import xml.etree.ElementTree as E

from diagramme_magazin import BILDER, OUT, ROOT, zeichne, PAPIER, TINTE, LEISE, ROSÉ, SIGNAL, STATUS


def pruefe():
    def licht(farbe):
        werte=[v/255 for v in bytes.fromhex(farbe[1:])]
        return sum(w*(v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4)
                   for w,v in zip((.2126,.7152,.0722),werte))
    for farbe in (TINTE, LEISE, ROSÉ, SIGNAL, STATUS):
        assert (licht(PAPIER)+.05)/(licht(farbe)+.05)>=4.5, farbe
    for kennung in BILDER:
        for lang in ('de','en'):
            svg=zeichne(kennung,lang)
            r=E.fromstring(svg)
            assert r.attrib['viewBox']=='0 0 800 600'
            assert len(r.findall('{http://www.w3.org/2000/svg}title'))==1
            assert len(r.findall('{http://www.w3.org/2000/svg}desc'))==1
            assert not any(w in svg for w in ('<image','<filter','<script','linearGradient','radialGradient'))
            name=f'diagram_{kennung}'+('_en' if lang=='en' else '')+'.svg'
            assert (OUT/name).read_text(encoding='utf-8')==svg, name
    print('100 SVGs: Struktur, Reproduzierbarkeit und Sprachpaare geprüft.')


def browser():
    from playwright.sync_api import sync_playwright
    from PIL import Image, ImageDraw
    ziel=ROOT/'build/redaktion/diagramm-review/neu'
    ziel.mkdir(parents=True,exist_ok=True)
    probleme=[]; boxen=[]; begriffe=[]
    serif=base64.b64encode((ROOT/'assets/fonts/SourceSerif4-Regular.ttf').read_bytes()).decode('ascii')
    with sync_playwright() as p:
        b=p.chromium.launch(executable_path=r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',headless=True,timeout=20000)
        page=b.new_page(viewport={'width':800,'height':600},device_scale_factor=1)
        for i,kennung in enumerate(BILDER):
            for lang in ('de','en'):
                name=f'diagram_{kennung}'+('_en' if lang=='en' else '')
                page.goto((OUT/(name+'.svg')).as_uri(),wait_until='load')
                page.evaluate('''async data => {
                    const font = new FontFace('SourceSerif4', 'url(data:font/ttf;base64,' + data + ')');
                    document.fonts.add(await font.load());
                    await document.fonts.ready;
                }''', serif)
                daten=page.evaluate('''() => Array.from(document.querySelectorAll('text')).map(e => {let b=e.getBBox();return {text:e.textContent,x:b.x,y:b.y,w:b.width,h:b.height};})''')
                for k,v in enumerate(daten):
                    if v['x']<20 or v['y']<15 or v['x']+v['w']>780 or v['y']+v['h']>588:
                        probleme.append({'datei':name,'typ':'Rand','text':v['text'],'box':v})
                    for w in daten[:k]:
                        dx=min(v['x']+v['w'],w['x']+w['w'])-max(v['x'],w['x'])
                        dy=min(v['y']+v['h'],w['y']+w['h'])-max(v['y'],w['y'])
                        if dx>1 and dy>2:
                            probleme.append({'datei':name,'typ':'Textüberlappung','text':[v['text'],w['text']]})
                boxen.append({'datei':name,'texte':daten})
                page.screenshot(path=str(ziel/(name+'.png')))
            begriffe.append(kennung)
        b.close()
    for start in range(0,len(begriffe),8):
        sheet=Image.new('RGB',(1600,660),'#d8d2c9'); draw=ImageDraw.Draw(sheet)
        for j,kennung in enumerate(begriffe[start:start+8]):
            with Image.open(ziel/f'diagram_{kennung}.png') as im:
                # Zwei Reihen, vier Spalten, je 400 × 300 mit Platz für die ID.
                thumb=im.resize((400,300))
                x=(j%4)*400; y=(j//4)*330
                sheet.paste(thumb,(x,y+20)); draw.text((x+8,y+4),kennung,fill='#2A2A2C')
        sheet.save(ziel/f'kontakt_{start//8+1:02d}.png')
    (ziel/'textgrenzen.json').write_text(json.dumps(boxen,ensure_ascii=False,indent=2),encoding='utf-8')
    (ziel/'pruefung.json').write_text(json.dumps(probleme,ensure_ascii=False,indent=2),encoding='utf-8')
    print(f'100 Browserrenderings, {len(probleme)} Befunde. {ziel}')
    for p in probleme[:20]:print(p)
    if probleme:raise SystemExit(1)


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__); ap.add_argument('--browser',action='store_true'); a=ap.parse_args()
    pruefe()
    if a.browser:browser()
