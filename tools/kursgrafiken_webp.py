"""Neue dekorative WebP-Reihe: vorhandene Zeichnungen und reduzierte Linienmotive.

python tools/kursgrafiken_webp.py             erzeugt nur unkritische App-Assets
python tools/kursgrafiken_webp.py --pruefen   Dateiformat/Zuordnung/Altbestand prüfen
python tools/kursgrafiken_webp.py --pruefpaket kopiert lokal vorhandene Spicy-Bilder
    ausschließlich ins ignorierte build/designstudien/kurspakete für Rendertests.

Private Originale nie ändern, neue Spicy-Illustrationen nicht in die APK kopieren.
"""
import argparse
import hashlib
import html
import json
import math
from pathlib import Path
import re
import shutil

ROOT=Path(__file__).resolve().parents[1]
ASSETS=ROOT/'assets/images'
MOTIVE=json.loads((ROOT/'tools/kursmotive.json').read_text(encoding='utf-8'))
AUSSCHNITTE=MOTIVE.pop('_ausschnitte',{})
SIZE=(900,600)  # vorhandenes Registerformat kopf: 3:2
PAPER='#F6F0E6'
PALETTES={False:(PAPER,'#2A2A2C','#B47C84','#D8CFBF'),True:('#1F1017','#F3E8E2','#D07A8E','#55303F')}
OLD=re.compile(r'^(cover_\d+|guided_[a-z]+|ynm_[a-z_]+?)(_spicy)?\.svg$')


def dekorativ(name):
    return name in MOTIVE


def eintrag(name,alt):
    """Eine Quelle pro Rolle, ältere Inhalts-/Widget-Pfade bleiben gültig."""
    normal,spicy=MOTIVE[name]
    e=dict(format='kopf',normal=f'assets/images/{name}.webp',alt=alt,
           altePfade=[f'assets/images/{name}.svg',f'assets/images/{name}_spicy.svg'])
    if spicy.startswith('abstrakt:'):
        e['spicy']=f'assets/images/{name}_spicy.webp'
    else:
        e['spicy']=spicy;e['paketSpicy']='kurse-bilder-spicy'
    return e


def curve(draw,pts,fill,width,scale=3):
    points=[]
    for a,b,c,d in zip(pts[0::3],pts[1::3],pts[2::3],pts[3::3]):
        for k in range(81):
            t=k/80;u=1-t
            points.append((scale*(u**3*a[0]+3*u*u*t*b[0]+3*u*t*t*c[0]+t**3*d[0]),
                           scale*(u**3*a[1]+3*u*u*t*b[1]+3*u*t*t*c[1]+t**3*d[1])))
    draw.line(points,fill=fill,width=round(width*scale),joint='curve')


def abstract(kind,spicy,seed):
    from PIL import Image, ImageDraw
    bg,ink,rose,line=PALETTES[spicy];s=3
    im=Image.new('RGB',(SIZE[0]*s,SIZE[1]*s),bg);d=ImageDraw.Draw(im)
    def path(points,color=ink,width=2.3):curve(d,points,color,width,s)
    def ln(points,color=line,width=.8):d.line([(x*s,y*s) for x,y in points],fill=color,width=max(1,round(width*s)))
    if kind in ('wahrnehmung','impuls','atem'):
        peaks=2 if kind=='wahrnehmung' else (3 if kind=='impuls' else 1)
        phase=(int(hashlib.sha256(seed.encode()).hexdigest()[:4],16)%12)/12
        for j,color in enumerate((ink,rose)):
            pts=[]
            for x in range(-10,912,2):
                y=350+92*math.sin(x/900*math.pi*peaks*2+phase+j*.55)+(j*48)
                if spicy:y+=28*math.sin(x/90+j*1.7)
                pts.append((x*s,y*s))
            d.line(pts,fill=color,width=round((2.1+j*.5)*s),joint='curve')
    elif kind=='raum':
        for j in range(4):
            x=170+j*44;y=105+j*35
            d.arc((x*s,y*s,(840-j*55)*s,(690-j*27)*s),180,510,fill=rose if j==2 else ink,width=round((1.2 if j%2 else 2.1)*s))
    elif kind=='dialog':
        path([(75,415),(100,150),(350,140),(438,300),(520,445),(730,455),(830,230)],ink,2.7)
        path([(75,470),(180,490),(325,420),(430,265),(550,115),(740,170),(835,410)],rose,2.7)
    else: # Spiel: offene, sich kreuzende Fäden statt schematischer Figuren.
        path([(70,385),(110,120),(350,150),(450,350),(540,545),(785,420),(820,185)],ink,2.7)
        path([(95,200),(185,410),(380,495),(505,265),(635,35),(815,215),(815,455)],rose,2.4)
    ln([(115,100),(300,100)]);ln([(115,94),(115,106)]);ln([(300,94),(300,106)])
    ln([(748,103),(748,220)]);ln([(690,161),(807,161)])
    d.ellipse((705*s,118*s,791*s,204*s),outline=line,width=2)
    return im.resize(SIZE,Image.Resampling.LANCZOS)


def make():
    from PIL import Image, ImageOps
    for name,(normal,spicy) in MOTIVE.items():
        for value,sp in ((normal,False),(spicy,True)):
            if value.startswith('kurse/'):continue
            if value.startswith('zeichnung:'):
                src=ROOT/'tools/zeichnungen'/f'{value.split(":")[1]}.webp'
                source=Image.open(src).convert('RGB')
                if name in AUSSCHNITTE:
                    x0,y0,x1,y1=AUSSCHNITTE[name]
                    source=source.crop((round(x0*source.width),round(y0*source.height),round(x1*source.width),round(y1*source.height)))
                fit=ImageOps.contain(source,SIZE,Image.Resampling.LANCZOS)
                image=Image.new('RGB',SIZE,PAPER)
                image.paste(fit,((SIZE[0]-fit.width)//2,(SIZE[1]-fit.height)//2))
            else:image=abstract(value.split(':')[1],sp,name)
            image.save(ASSETS/f'{name}{"_spicy" if sp else ""}.webp',quality=86,method=6)
    # Nur die eindeutig abgelöste, zentral aufgezählte dekorative Reihe entfernen.
    # Alle aufgelösten Pfade müssen im vorgesehenen Bildordner bleiben.
    for file in ASSETS.glob('*.svg'):
        match=OLD.fullmatch(file.name)
        if match and match[1] in MOTIVE:
            assert file.resolve().parent==ASSETS.resolve()
            file.unlink()


def check():
    from PIL import Image
    expected={f'{name}.webp' for name in MOTIVE}
    expected|={f'{name}_spicy.webp' for name,(_,sp) in MOTIVE.items() if sp.startswith('abstrakt:')}
    for name in expected:
        with Image.open(ASSETS/name) as im:
            assert im.format=='WEBP' and im.size==SIZE,(name,im.format,im.size)
        assert (ASSETS/name).stat().st_size<180_000,name
    assert not [f.name for f in ASSETS.glob('*.svg') if OLD.fullmatch(f.name)],'Dekorativer SVG-Altbestand'
    assert len(MOTIVE)==41
    print(f'{len(MOTIVE)} Motive, {len(expected)} lokale WebPs, {sum((ASSETS/x).stat().st_size for x in expected)/1e6:.2f} MB; keine dekorativen SVGs.')


def testpack():
    out=ROOT/'build/designstudien/kurspakete/kurse-bilder-spicy'
    for rel in sorted({sp for _,sp in MOTIVE.values() if sp.startswith('kurse/')}):
        src=Path('C:/TOOLS/velvet-inhalte/kurse/bilder/final')/Path(rel).name
        assert src.is_file(),src
        dest=out/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dest)
    (out/'paket.json').write_text(json.dumps(dict(name='kurse-bilder-spicy',version=5)),encoding='utf-8')
    print('Lokales Prüf-Paket: '+str(out.parent))


def preview():
    out=ROOT/'build/designstudien/kursgrafiken-webp';out.mkdir(parents=True,exist_ok=True)
    entries=json.loads((ROOT/'assets/data/bilder.json').read_text(encoding='utf-8'))['bilder']
    for lang in ('de','en'):
        rows=[]
        for name in MOTIVE:
            e=next(e for e in entries.values() if e.get('normal')==f'assets/images/{name}.webp')
            sp=(ROOT/'build/designstudien/kurspakete/kurse-bilder-spicy'/e['spicy'] if e.get('paketSpicy') else ROOT/e['spicy'])
            normal=ROOT/e['normal']
            alt=html.escape(e['alt'][lang])
            image=f'<img src="{sp.as_uri()}" alt="">' if sp.exists() else '<p>Spicy-Paket fehlt / Spicy pack unavailable</p>'
            rows.append(f'<section><h2>{alt}</h2><div class="pair"><figure><img src="{normal.as_uri()}" alt=""><figcaption>Papier / Paper · WebP</figcaption></figure><figure class="spicy">{image}<figcaption>Spicy · WebP</figcaption></figure></div></section>')
        title='Die neue Bildwelt' if lang=='de' else 'The new image collection'
        doc=f'''<!doctype html><html lang="{lang}"><meta charset="utf-8"><title>VelvetPulse / WebP</title>
        <style>@font-face{{font-family:Serif;src:url('{(ROOT/'assets/fonts/SourceSerif4-Regular.ttf').as_uri()}')}}
        body{{margin:40px auto;max-width:1100px;background:#E7E1D7;color:#2A2A2C;font:16px 'Segoe UI',sans-serif;padding:0 25px}}
        h1,h2{{font-family:Serif,serif;font-weight:400}}h1{{font-size:42px}}h2{{font-size:27px;margin:40px 0 18px}}
        .pair{{display:grid;grid-template-columns:1fr 1fr;gap:24px}}figure{{margin:0;background:#F6F0E6;padding:20px}}
        .spicy{{background:#1F1017;color:#F3E8E2}}img{{display:block;width:100%;height:auto;aspect-ratio:3/2;object-fit:contain}}
        figcaption{{padding-top:15px;font-size:13px}}@media(max-width:650px){{.pair{{grid-template-columns:1fr}}}}</style>
        <h1>VelvetPulse / {title}</h1><p>41 Motive · Papier / Spicy · DE / EN</p>{''.join(rows)}</html>'''
        (out/f'galerie-{lang}.html').write_text(doc,encoding='utf-8')
    print('Lokale DE/EN-Galerie: '+str(out))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--pruefen',action='store_true');parser.add_argument('--pruefpaket',action='store_true');parser.add_argument('--vorschau',action='store_true');a=parser.parse_args()
    if not a.pruefen:make()
    check()
    if a.pruefpaket:testpack()
    if a.vorschau:preview()
