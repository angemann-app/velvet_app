"""Zweisprachige Werbebroschüre im bestehenden VelvetPulse-Markensystem.

Mit dem gebündelten Python ausführen (reportlab, pypdfium2, pypdf, Pillow).
Private Originale nur lesen; sie werden ausschließlich in die beauftragte PDF
eingebettet, nicht als einzelne Assets übernommen. Keine App-Dateien ändern.
"""
import hashlib
import math
import json
from pathlib import Path
import re

from PIL import Image, ImageDraw, ImageOps
from reportlab.graphics import renderPDF
from reportlab.graphics.barcode import qr
from reportlab.graphics.shapes import Drawing
from reportlab.lib.colors import HexColor
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph

import markenleitfaden as guide

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'marketing/broschuere'
PREVIEW = OUT / 'vorschau'
TMP = ROOT / 'tmp/pdfs/broschuere'
TEXT = json.loads((OUT / 'texte.json').read_text(encoding='utf-8'))
TOTAL = len(TEXT['de'])
W, H = 595.276, 841.89
M = 42
CW = W - M * 2
PAPER, INK, MUTED = '#F6F0E6', '#2A2A2C', '#5A5750'
ROSE, LINE, DEEP, LIGHT = '#8E4A57', '#D8CFBF', '#1F1017', '#F3E8E2'
URL = 'https://github.com/angemann-app/velvet_app/releases/latest'
ATTACH = ROOT / '.codex-remote-attachments/01a19710-1855-7460-bfcc-29bf0fbfb6d0/02ad3119-7be5-4032-a746-df9d91b01ae7'
COURSE = Path('C:/TOOLS/velvet-inhalte/kurse/bilder/final')
SOURCE = {
    'cover': (ATTACH / '1-57591.jpg', (188, 26, 1105, 689)),
    'massage': (ATTACH / '2-57592.jpg', None),
    'spicy': (ATTACH / '3-57590.jpg', None),
    'self': (ROOT / 'tools/zeichnungen/self_1.webp', None),
    'couple': (COURSE / 'couples_2_spicy.webp', None),
    'hands': (COURSE / 'alltag_8_spicy.webp', None),
    'sleep': (COURSE / 'self_2_spicy.webp', None),
    'inside': (COURSE / 'tease_1_spicy.webp', None),
}
boxlog, imagelog = [], []
c = None
page = 0
language = 'de'
dark = False


def clean(s):
    return s.replace('\u2011', '-').replace('\u2013', '-').replace('\u2014', '-').replace('\n', '<br/>')


def paragraph(text, x, y, width, size=11.5, font='Body', color=None, leading=1.43):
    text = clean(text)
    color = color or (LIGHT if dark else INK)
    style = ParagraphStyle('text', fontName=font, fontSize=size, leading=size*leading,
                           textColor=HexColor(color), splitLongWords=False)
    p = Paragraph(text, style)
    _, h = p.wrap(width, H)
    assert x >= 20 and x+width <= W-20, (language,page,'horizontal',x,width)
    assert y >= 0 and y+h <= H-48, (language,page,'vertikal',text[:50],y+h)
    p.drawOn(c, x, H-y-h)
    boxlog.append(dict(sprache=language,seite=page,x=x,y=y,breite=width,hoehe=h,text=re.sub('<[^>]+>',' ',text)))
    return y+h


def rule(y, x=M, width=CW, color=None, technical=False):
    c.setStrokeColor(HexColor(color or ('#55303F' if dark else LINE)))
    c.setLineWidth(.5)
    c.line(x,H-y,x+width,H-y)
    if technical:
        for a in [0, width/2, width]:
            c.line(x+a,H-y-3,x+a,H-y+3)


def start(data, number, isdark=False):
    global page,dark
    page,dark=data.get('_seite', number),isdark
    c.setFillColor(HexColor(DEEP if dark else PAPER));c.rect(0,0,W,H,fill=1,stroke=0)
    guide.c,guide.W,guide.H=c,W,H
    paragraph(data['tag'].upper(),M,39,CW-40,9,'Body','#EDB3C0' if dark else ROSE,1.12)
    guide.signet(W-M-22,31,26,LIGHT if dark else INK,'#D07A8E' if dark else '#B47C84')
    c.setFillColor(HexColor('#D2BCBC' if dark else MUTED));c.setFont('Body',8)
    c.drawString(M,23,'VelvetPulse / '+('Entdecken' if language=='de' else 'Explore'))
    c.drawRightString(W-M,23,f'{page:02d} / {TOTAL}')


def title(data, size=35):
    end=paragraph(data['title'],M,85,CW,size,'Serif',leading=1.1)
    return paragraph(data['lead'],M,end+20,CW,13,'Body', '#D2BCBC' if dark else MUTED,1.45)


def block(heading, body, x,y,width, size=11.3, title_size=18):
    end=paragraph(heading,x,y,width,title_size,'Serif',leading=1.16)
    return paragraph(body,x,end+9,width,size,'Body','#D2BCBC' if dark else MUTED)


def picture(key,x,y,w,h):
    file,crop=SOURCE[key]
    im=Image.open(file).convert('RGB')
    if crop: im=im.crop(crop)
    scale=min(w/im.width,h/im.height)
    dw,dh=im.width*scale,im.height*scale
    c.drawImage(ImageReader(im),x+(w-dw)/2,H-y-(h+dh)/2,dw,dh,mask='auto')
    imagelog.append(dict(sprache=language,seite=page,quelle=str(file),beschnitt=crop,
                         x=x+(w-dw)/2,y=y+(h-dh)/2,pixel=list(im.size),breite_pt=round(dw,2),hoehe_pt=round(dh,2),ppi=round(72/scale,1)))


def phone(filename,x=354,y=266,w=184,spicy=False):
    folder=('screens_spicy' if spicy else 'screens')+('_en' if language=='en' else '')
    file=ROOT/'build'/folder/filename
    im=Image.open(file).convert('RGB');h=w*im.height/im.width
    c.setFillColor(HexColor('#34262B' if dark else '#2A2A2C'))
    c.roundRect(x-5,H-y-h-5,w+10,h+10,14,stroke=0,fill=1)
    c.drawImage(ImageReader(im),x,H-y-h,w,h)
    imagelog.append(dict(sprache=language,seite=page,quelle=str(file),x=x,y=y,pixel=list(im.size),breite_pt=w,hoehe_pt=h,ppi=round(72*im.width/w,1)))


def small(data,y=748):
    if data.get('small'):
        paragraph(data['small'],M,y,CW,8.8,'Body','#D2BCBC' if dark else MUTED,1.4)


def phone_page(data,number,filename,spicy=False):
    start(data,number,spicy);title(data)
    phone(filename,spicy=spicy)
    y=268
    for a,b in data['blocks']:
        y=block(a,b,M,y,279,11.3,18)+23
    assert y<738,(language,number,'Text neben Telefon zu lang',y)
    if data.get('quote'):
        paragraph(data['quote'],M,704,CW,23,'SerifItalic',ROSE,1.15)
    small(data,746)


def hero_page(data,number,key,isdark=False):
    start(data,number,isdark);title(data)
    picture(key,M,244,CW,278)
    rule(541,technical=True)
    gap=21;w=(CW-2*gap)/3
    bottom=0
    for i,(a,b) in enumerate(data['blocks']):
        bottom=max(bottom,block(a,b,M+i*(w+gap),560,w,10.5,16.5))
    assert bottom<746,(language,number,'Spalten zu lang',bottom)
    if data.get('quote'):
        paragraph(data['quote'],M,max(707,bottom+20),CW,20,'SerifItalic',ROSE,1.15)
    small(data,max(751,bottom+15))


def cover(data):
    start(data,1)
    guide.logo(37,76,305)
    paragraph(data['title'],M,174,CW,46,'Serif',leading=1.06)
    paragraph(data['lead'],M,291,465,14,'Body',MUTED)
    picture('cover',M,372,CW,370)
    rule(763,technical=True)
    paragraph(data['small'],M,775,CW,9,'Body',ROSE,1.2)


def welcome(data):
    start(data,2);title(data)
    y=277
    for a,b in data['blocks']:
        y=block(a,b,M,y,CW,12,21)+22
    paragraph(data['quote'],M,y+8,CW,27,'SerifItalic',ROSE,1.15)
    rule(562,technical=True)
    for i,(name,desc,ref) in enumerate(data['nav']):
        y=580+i*47
        paragraph(name,M,y,100,19,'Serif')
        paragraph(desc,160,y+4,325,11.3,'Body',MUTED)
        paragraph(ref,500,y+4,53,10,'Body',ROSE)


def collection(data):
    start(data,5);title(data)
    gap=30;w=(CW-gap)/2
    for i,(a,b) in enumerate(data['blocks']):
        x=M+(i%2)*(w+gap);y=268+(i//2)*166
        rule(y-13,x,w,technical=True)
        block(a,b,x,y,w,11.3,19)
    guide.signet(473,727,77,INK,'#B47C84')


def steps(data):
    start(data,16);title(data)
    for i,(a,b) in enumerate(data['blocks']):
        y=274+i*147
        paragraph(str(i+1).zfill(2),M,y-10,63,39,'Serif','#B47C84',1)
        block(a.split(' / ',1)[1],b,123,y,430,11.6,22)
        if i<2: rule(y+126,123,430)
    small(data,745)


def privacy(data):
    start(data,18);title(data,33)
    y=277
    for i,(a,b) in enumerate(data['blocks']):
        guide.signet(M,y+2,43,INK,'#B47C84',compact=True)
        y=block(a,b,112,y,441,11.7,21)+28
        if i<2: rule(y-12,112,441)
    small(data,751)


def onboarding(data):
    start(data,19);title(data)
    names=['Papier','Nachtpapier','Spicy'] if language=='de' else ['Paper','Night Paper','Spicy']
    cols=[(PAPER,INK),( '#1D1F22','#E9E4D8'),(DEEP,LIGHT)]
    for i,(name,(bg,ink)) in enumerate(zip(names,cols)):
        x=M+i*176
        c.setFillColor(HexColor(bg));c.setStrokeColor(HexColor(LINE));c.setLineWidth(.5)
        c.rect(x,H-316,159,67,fill=1,stroke=1)
        paragraph(name,x+12,269,135,15,'Serif',ink,1.1)
        c.setStrokeColor(HexColor('#B47C84'));c.line(x+12,H-301,x+145,H-301)
    y=349
    for a,b in data['blocks']:
        y=block(a,b,M,y,CW,11.7,20)+23
    assert y<740,(language,19,y)
    small(data,728)


def qr_code(x,y,size):
    q=qr.QrCodeWidget(URL,barFillColor=HexColor(INK))
    bounds=q.getBounds();bw=bounds[2]-bounds[0];bh=bounds[3]-bounds[1]
    d=Drawing(size,size,transform=[size/bw,0,0,size/bh,0,0]);d.add(q)
    c.setFillColor(HexColor('#FFFFFF'));c.rect(x,H-y-size,size,size,fill=1,stroke=0)
    renderPDF.draw(d,c,x,H-y-size)
    c.linkURL(URL,(x,H-y-size,x+size,H-y),relative=0,thickness=0)


def back(data):
    start(data,20)
    guide.logo(37,93,330)
    paragraph(data['title'],M,223,CW,43,'Serif',leading=1.08)
    paragraph(data['lead'],M,342,450,15,'Body',MUTED)
    picture('hands',M,405,CW,162)
    qr_code(M,596,110)
    paragraph(data['cta'],177,602,376,21,'Serif')
    paragraph('github.com/angemann-app/velvet_app<br/>/releases/latest',177,648,376,11,'Body',ROSE)
    c.linkURL(URL,(177,H-688,553,H-602),relative=0,thickness=0)
    paragraph(data['small'],M,731,CW,9,'Body',MUTED)
    paragraph(data['end'],M,777,CW,11,'SerifItalic',ROSE,1.1)


def make(lang):
    global c,language
    language=lang
    path=ROOT/f'output/pdf/VelvetPulse-Broschuere-{lang.upper()}.pdf'
    path.parent.mkdir(parents=True,exist_ok=True)
    c=canvas.Canvas(str(path),pagesize=(W,H),pageCompression=1)
    c.setTitle('VelvetPulse - '+('Dein Körper. Dein Erleben.' if lang=='de' else 'Your body. Your experience.'))
    c.setAuthor('VelvetPulse');c.setSubject('App-Broschüre / Stand 02.11.2026')
    c.setViewerPreference('DisplayDocTitle', 'true')
    for n,data in enumerate(TEXT[lang],1):
        data['_seite']=n
        n=data.get('layout',n)
        if n==1: cover(data)
        elif n==2: welcome(data)
        elif n in (3,4,8,9,15,17):
            fname={3:'01_kurse.png',4:'01_lernen.png',8:'02_training.png',9:'03_reframing.png',15:'15_traumpraxis.png',17:'05_kicoach.png'}[n]
            phone_page(data,n,fname,n==15)
        elif n==5: collection(data)
        elif n in (6,7,10,11,12,13,14):
            key={6:'self',7:'massage',10:'couple',11:'hands',12:'spicy',13:'sleep',14:'inside'}[n]
            hero_page(data,n,key,n==12)
        elif n==16: steps(data)
        elif n==18: privacy(data)
        elif n==19: onboarding(data)
        elif n==20: back(data)
        elif n=='path':
            hero_page(data,data['_seite'],'hands')
        elif n in ('player','shared','search','path'):
            filename={'player':'20_wiedergabe.png','shared':'22_gemeinsam_countdown.png',
                      'search':'00_suche.png','path':'00_weg_aktiv.png'}[n]
            phone_page(data,data['_seite'],filename)
        c.showPage()
    c.save()
    return path


def render_and_check(path):
    import pypdfium2 as pdfium
    from pypdf import PdfReader
    lang=path.stem[-2:].lower();folder=PREVIEW/lang;folder.mkdir(parents=True,exist_ok=True)
    reader=PdfReader(path);assert len(reader.pages)==TOTAL
    assert all(p.extract_text().strip() for p in reader.pages)
    norm=lambda s: re.sub(r'\s+','',re.sub('<[^>]+>','',clean(s))).casefold()
    for idx,(d,p) in enumerate(zip(TEXT[lang],reader.pages),1):
        extracted=norm(p.extract_text())
        expected=[d[k] for k in ('tag','title','lead','quote','small','cta','end') if k in d]
        expected += [s for pair in d.get('blocks',[]) for s in pair]
        expected += [s for triple in d.get('nav',[]) for s in triple]
        # Schrittzahlen sind eigenständig gesetzt statt mit dem Titel verklebt.
        if d.get('layout',idx)==16:expected=[s.split(' / ',1)[1] if ' / ' in s and s[:2].isdigit() else s for s in expected]
        for s in expected:
            assert norm(s) in extracted,(lang,idx,'Text fehlt',s[:80])
    current=[b for b in boxlog if b['sprache']==lang]
    for i,a in enumerate(current):
        for b in current[i+1:]:
            if a['seite']!=b['seite']:continue
            overlap_x=min(a['x']+a['breite'],b['x']+b['breite'])-max(a['x'],b['x'])
            overlap_y=min(a['y']+a['hoehe'],b['y']+b['hoehe'])-max(a['y'],b['y'])
            assert overlap_x<=.1 or overlap_y<=.1,(lang,a['seite'],'Textüberlagerung',a['text'][:25],b['text'][:25])
        for b in [b for b in imagelog if b['sprache']==lang and b['seite']==a['seite']]:
            overlap_x=min(a['x']+a['breite'],b['x']+b['breite_pt'])-max(a['x'],b['x'])
            overlap_y=min(a['y']+a['hoehe'],b['y']+b['hoehe_pt'])-max(a['y'],b['y'])
            assert overlap_x<=.1 or overlap_y<=.1,(lang,a['seite'],'Text über Bild',a['text'][:25])
    doc=pdfium.PdfDocument(str(path));tiles=[]
    for i in range(len(doc)):
        pdfpage=doc[i];bitmap=pdfpage.render(scale=1.6);im=bitmap.to_pil().copy()
        im.save(folder/f'seite-{i+1:02}.png')
        thumb=im.copy();thumb.thumbnail((238,337));tiles.append(thumb)
        bitmap.close();pdfpage.close()
    doc.close()
    sheet=Image.new('RGB',(5*258,math.ceil(TOTAL/5)*368),'#E7E1D7');draw=ImageDraw.Draw(sheet)
    for i,im in enumerate(tiles):
        x=(i%5)*258+10;y=(i//5)*368+8
        sheet.paste(im,(x,y));draw.text((x,y+340),f'{i+1:02}',fill=INK)
    sheet.save(PREVIEW/f'uebersicht-{lang}.jpg',quality=91)
    # Einbettung der tatsächlich verwendeten Schriftprogramme prüfen.
    fonts=[]
    for p in reader.pages:
        for obj in p['/Resources'].get('/Font',{}).values():
            font=obj.get_object();name=str(font.get('/BaseFont',''))
            if name in ('/Helvetica','/Times-Roman'):continue  # ReportLab-/QR-Vorgaben
            desc=font.get('/FontDescriptor')
            assert desc and '/FontFile2' in desc.get_object(),name
            fonts.append(name)
    links=[a.get_object().get('/A',{}).get('/URI') for p in reader.pages for a in p.get('/Annots',[])]
    assert links.count(URL)==2
    return dict(sprache=lang,seiten=TOTAL,textabdeckung='vollständig',ueberlagerungen=0,schriften=sorted(set(fonts)),link=URL,
                bytes=path.stat().st_size,sha256=hashlib.sha256(path.read_bytes()).hexdigest())


def main():
    PREVIEW.mkdir(parents=True,exist_ok=True);TMP.mkdir(parents=True,exist_ok=True)
    for name,file in [('Serif','SourceSerif4-Regular.ttf'),('SerifBold','SourceSerif4-SemiBold.ttf'),('SerifItalic','SourceSerif4-Italic.ttf')]:
        pdfmetrics.registerFont(TTFont(name,str(ROOT/'assets/fonts'/file)))
    pdfmetrics.registerFont(TTFont('Body',r'C:\Windows\Fonts\segoeui.ttf'))
    assert len(TEXT['de'])==len(TEXT['en'])==24
    actual=json.loads((ROOT/'assets/data/velvet_content.json').read_text(encoding='utf-8'))
    assert len(actual['courses'])==27
    assert sum(len(x['lessons']) for x in actual['courses'])==128
    report=[]
    for lang in ('de','en'):
        path=make(lang);report.append(render_and_check(path))
        lines=['# VelvetPulse / '+('Werbebroschüre' if lang=='de' else 'App brochure'),'Stand: 02.11.2026','']
        for n,d in enumerate(TEXT[lang],1):
            lines+=['',f'## {n:02} / '+d['tag'],d['title'].replace('\n',' '),'',d['lead'],'']
            for a,b in d.get('blocks',[]): lines += ['### '+a,b,'']
            for name,desc,pages in d.get('nav',[]):lines += [f'- {name}: {desc} ({pages})']
            for key in ('quote','small','cta','end'):
                if key in d:lines += [d[key],'']
        (OUT/f'lesefassung-{lang}.md').write_text('\n'.join(lines),encoding='utf-8')
    (OUT/'pruefung.json').write_text(json.dumps(dict(pdfs=report,textfelder=boxlog,bilder=imagelog),ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False,indent=2))


if __name__=='__main__':main()
