"""Android-App-Symbol aus der freigegebenen SVG-Geometrie erzeugen und prüfen.

python tools/app_symbol/erzeugen.py [--pruefen]
Nur das normale Launcher-Symbol ändern, Diskretions-Symbol unverändert lassen.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFont

ROOT=Path(__file__).resolve().parents[2]
RES=ROOT/'android/app/src/main/res'
OUT=ROOT/'build/designstudien/app-icon'
NS='http://schemas.android.com/apk/res/android'
ET.register_namespace('android',NS)
PAPER='#F6F0E6'
SCALE=.3
OFFSET=54-128*SCALE
DENSITIES={'mdpi':48,'hdpi':72,'xhdpi':96,'xxhdpi':144,'xxxhdpi':192}
PATHS=list(ET.parse(Path(__file__).with_name('velvetpulse.svg')).getroot().iter('{http://www.w3.org/2000/svg}path'))


def vector(mono=False):
    root=ET.Element('vector',{f'{{{NS}}}width':'108dp',f'{{{NS}}}height':'108dp',
        f'{{{NS}}}viewportWidth':'108',f'{{{NS}}}viewportHeight':'108'})
    group=ET.SubElement(root,'group',{f'{{{NS}}}scaleX':str(SCALE),f'{{{NS}}}scaleY':str(SCALE),
        f'{{{NS}}}translateX':str(OFFSET),f'{{{NS}}}translateY':str(OFFSET)})
    for p in PATHS:
        attrs={'pathData':p.attrib['d'],'strokeColor':'#FFFFFF' if mono else p.attrib['stroke'],
               'strokeWidth':p.attrib['stroke-width'],'strokeLineCap':'round','strokeLineJoin':'round','fillColor':'#00000000'}
        ET.SubElement(group,'path',{f'{{{NS}}}{k}':v for k,v in attrs.items()})
    ET.indent(root,space='    ')
    return ET.tostring(root,encoding='unicode')+'\n'


def points(d):
    tokens=re.findall(r'[MLC]|-?\d+(?:\.\d+)?',d);result=[];i=0;last=(0,0)
    while i<len(tokens):
        cmd=tokens[i];i+=1
        if cmd in ('M','L'):
            last=tuple(map(float,tokens[i:i+2]));i+=2;result.append(last)
        else:
            coords=list(zip(map(float,tokens[i:i+6:2]),map(float,tokens[i+1:i+6:2])));i+=6
            p0=last;p1,p2,p3=coords
            for n in range(1,101):
                t=n/100;u=1-t
                result.append(tuple(u**3*p0[k]+3*u*u*t*p1[k]+3*u*t*t*p2[k]+t**3*p3[k] for k in (0,1)))
            last=p3
    return result


def foreground(size,mono=False,crop=False,tint=None):
    # Adaptives Sichtfenster: zentrale 72 von 108 dp. Wichtige Striche
    # bleiben vollständig im noch kleineren 66-dp-Sicherheitskreis.
    supersampling=4;span=72 if crop else 108;origin=18 if crop else 0
    factor=size/span*supersampling
    im=Image.new('RGBA',(size*supersampling,size*supersampling));d=ImageDraw.Draw(im)
    for p in PATHS:
        coords=[((OFFSET+x*SCALE-origin)*factor,(OFFSET+y*SCALE-origin)*factor) for x,y in points(p.attrib['d'])]
        width=float(p.attrib['stroke-width'])*SCALE*factor
        color=tint or ('#FFFFFF' if mono else p.attrib['stroke'])
        # Eine geschlossene Strichfläche verhindert die kleinen Zwickel, die
        # Pillow bei sehr dichten line/joint-Kombinationen ins Innere zeichnet.
        left=[];right=[]
        for i,(x,y) in enumerate(coords):
            a=coords[max(0,i-1)];b=coords[min(len(coords)-1,i+1)]
            dx,dy=b[0]-a[0],b[1]-a[1];length=math.hypot(dx,dy)
            nx,ny=-dy/length*width/2,dx/length*width/2
            left.append((x+nx,y+ny));right.append((x-nx,y-ny))
        d.polygon(left+right[::-1],fill=color)
        for x,y in (coords[0],coords[-1]):d.ellipse((x-width/2,y-width/2,x+width/2,y+width/2),fill=color)
    return im.resize((size,size),Image.Resampling.LANCZOS)


def icon(size,shape='rounded',mono=False):
    im=Image.new('RGBA',(size,size),'#E5DBE8' if mono else PAPER)
    fg=foreground(size,mono,crop=True,tint='#49334C' if mono else None)
    im.alpha_composite(fg)
    mask=Image.new('L',(size*4,size*4));d=ImageDraw.Draw(mask)
    box=(0,0,size*4-1,size*4-1)
    if shape=='circle':d.ellipse(box,fill=255)
    else:d.rounded_rectangle(box,radius=size*.23*4,fill=255)
    im.putalpha(mask.resize((size,size),Image.Resampling.LANCZOS))
    return im


def adaptive(mono=False):
    root=ET.Element('adaptive-icon')
    ET.SubElement(root,'background',{f'{{{NS}}}drawable':'@color/ic_launcher_background'})
    ET.SubElement(root,'foreground',{f'{{{NS}}}drawable':'@drawable/ic_launcher_foreground'})
    if mono:ET.SubElement(root,'monochrome',{f'{{{NS}}}drawable':'@drawable/ic_launcher_monochrome'})
    ET.indent(root,space='    ')
    return '<?xml version="1.0" encoding="utf-8"?>\n'+ET.tostring(root,encoding='unicode')+'\n'


def save(path,text):
    path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text,encoding='utf-8')


def make():
    discreet={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in RES.rglob('*') if p.is_file() and 'discreet' in p.name}
    for density,size in DENSITIES.items():
        icon(size).save(RES/f'mipmap-{density}/ic_launcher.png')
        old=RES/f'drawable-{density}/ic_launcher_foreground.png'
        if old.exists():
            assert old.resolve().is_relative_to(RES.resolve())
            old.unlink()
    save(RES/'drawable-anydpi/ic_launcher_foreground.xml',vector())
    save(RES/'drawable-anydpi/ic_launcher_monochrome.xml',vector(True))
    save(RES/'mipmap-anydpi-v26/ic_launcher.xml',adaptive())
    save(RES/'mipmap-anydpi-v33/ic_launcher.xml',adaptive(True))
    save(RES/'values/ic_launcher_background.xml',f'<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <color name="ic_launcher_background">{PAPER}</color>\n</resources>\n')
    assert all(hashlib.sha256(Path(p).read_bytes()).hexdigest()==sha for p,sha in discreet.items())
    preview()


def preview():
    OUT.mkdir(parents=True,exist_ok=True)
    icon(1024).save(OUT/'velvetpulse-1024.png')
    sheet=Image.new('RGB',(1400,760),'#E7E1D7');d=ImageDraw.Draw(sheet)
    serif=ImageFont.truetype(str(ROOT/'assets/fonts/SourceSerif4-Regular.ttf'),46)
    small=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',21)
    d.text((50,30),'VelvetPulse / App-Icon',font=serif,fill='#2A2A2C')
    d.text((50,94),'Papier. Graphit. Rosé. Ein Zeichen für alle Modi.',font=small,fill='#5A5750')
    for x,shape,mono,label in [(60,'rounded',False,'Abgerundetes Quadrat'),(510,'circle',False,'Runde Launcher-Maske'),(960,'rounded',True,'Android-Themensymbol')]:
        image=icon(350,shape,mono);sheet.paste(image,(x,175),image);d.text((x,550),label,font=small,fill='#2A2A2C')
    for i,size in enumerate((72,48,32,24)):
        image=icon(size);x=60+i*145;sheet.paste(image,(x,625+(72-size)//2),image);d.text((x,712),f'{size} px',font=small,fill='#5A5750')
    d.text((760,646),'Das diskrete Pulse-Symbol bleibt neutral.',font=small,fill='#5A5750')
    sheet.save(OUT/'uebersicht.png')


def check():
    fg=foreground(432)
    alpha=fg.getchannel('A');outside=0
    for y in range(432):
        for x in range(432):
            if alpha.getpixel((x,y))>4 and math.hypot(x+.5-216,y+.5-216)>33*4:outside+=1
    assert outside==0,outside
    for density,size in DENSITIES.items():
        file=RES/f'mipmap-{density}/ic_launcher.png'
        with Image.open(file) as im:assert im.size==(size,size) and im.mode=='RGBA'
    for folder,mono in [('mipmap-anydpi-v26',False),('mipmap-anydpi-v33',True)]:
        root=ET.parse(RES/f'{folder}/ic_launcher.xml').getroot()
        assert (root.find('monochrome') is not None)==mono
    for name in ('foreground','monochrome'):
        root=ET.parse(RES/f'drawable-anydpi/ic_launcher_{name}.xml').getroot()
        assert root.tag=='vector'
        assert len(list(root.iter('path')))==3
    report=dict(legacy_dichten=5,adaptiv='108 dp / 66 dp Sicherheitskreis',pixel_ausserhalb=outside,monochrom=True,diskretes_symbol='unverändert')
    OUT.mkdir(parents=True,exist_ok=True);(OUT/'pruefung.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--pruefen',action='store_true');args=parser.parse_args()
    if not args.pruefen:make()
    check()
