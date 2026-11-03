"""Erzeugt den Markenleitfaden mit echten Vektorlogos und rendert die PDF-Prüfung.

Mit dem gebündelten Python ausführen (reportlab, pypdfium2, pypdf).
"""
import json
import math
from pathlib import Path
import re

from reportlab.lib.colors import HexColor
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph

import markenpaket as brand

ROOT = brand.ROOT
OUT = brand.OUT
PDF = ROOT / 'output/pdf/VelvetPulse-Markenleitfaden-v1.pdf'
W, H = 960, 640
PAPER = '#F6F0E6'
INK = '#2A2A2C'
MUTED = '#5A5750'
ROSE = '#8E4A57'
ACCENT = '#B47C84'
DEEP = '#1F1017'
LIGHT = '#F3E8E2'
boxes = []
page_number = 0
c = None


def path(d, fill=None, stroke=None, width=1):
    tokens = re.findall(r'[MLCZ]|-?\d+(?:\.\d+)?', d)
    p = c.beginPath()
    i = 0
    while i < len(tokens):
        cmd = tokens[i]
        i += 1
        if cmd in ('M', 'L'):
            x, y = map(float, tokens[i:i+2]); i += 2
            (p.moveTo if cmd == 'M' else p.lineTo)(x, y)
        elif cmd == 'C':
            p.curveTo(*map(float, tokens[i:i+6])); i += 6
        else:
            assert cmd == 'Z'
            p.close()
    if fill:
        c.setFillColor(HexColor(fill))
    if stroke:
        c.setStrokeColor(HexColor(stroke)); c.setLineWidth(width)
    c.setLineCap(1); c.setLineJoin(1)
    # Schriftkonturen enthalten überlappende Teilflächen. Wie SVGs die
    # Nonzero-Regel verwenden, sonst entstehen helle Schlitze in der Wortmarke.
    c.drawPath(p, stroke=int(stroke is not None), fill=int(fill is not None), fillMode=1)


def signet(x, top, size, ink=INK, accent=ACCENT, compact=False):
    c.saveState(); c.translate(x, H-top); c.scale(size/256, -size/256)
    path(brand.arc(45, 310), stroke=ink, width=13 if compact else 9.5)
    path(brand.arc(310, 348), stroke=ink if compact else accent, width=13 if compact else 9.5)
    path(brand.V, stroke=ink, width=17 if compact else 12)
    c.restoreState()


def logo(x, top, width, ink=INK, accent=ACCENT):
    s = width/810
    signet(x, top, 184.32*s, ink, accent)
    c.saveState(); c.translate(x+216*s, H-top-50*s); c.scale(s, -s)
    path(brand.WORD_PATH, fill=ink)
    c.restoreState()


def rect(x, top, w, h, color, stroke=None):
    c.setFillColor(HexColor(color))
    if stroke:
        c.setStrokeColor(HexColor(stroke)); c.setLineWidth(.7)
    c.rect(x, H-top-h, w, h, stroke=int(stroke is not None), fill=1)


def para(text, x, top, width, size=16, color=INK, font='Body', leading=1.4):
    style = ParagraphStyle('body', fontName=font, fontSize=size, leading=size*leading,
                           textColor=HexColor(color), spaceAfter=0)
    p = Paragraph(text, style)
    w, h = p.wrap(width, H)
    assert top+h <= H-35, (page_number, text[:50], top+h)
    p.drawOn(c, x, H-top-h)
    boxes.append({'seite': page_number, 'text': re.sub('<[^>]*>', '', text), 'x':x, 'y':top, 'w':w, 'h':h})
    return top+h


def label(text, x=60, top=46, color=ROSE):
    return para(text.upper(), x, top, 840, 11, color, leading=1.1)


def heading(text, top=90, color=INK, width=840, size=38):
    return para(text, 60, top, width, size, color, 'Serif', 1.13)


def block(title, body, x, top, width=385, color=INK, bodycolor=MUTED):
    y = para(title, x, top, width, 23, color, 'Serif', 1.15)
    return para(body, x, y+12, width, 15, bodycolor)+27


def start(name, dark=False):
    global page_number
    page_number += 1
    rect(0,0,W,H,DEEP if dark else PAPER)
    label(name, color='#EDB3C0' if dark else ROSE)
    c.setFont('Body',9); c.setFillColor(HexColor('#D2BCBC' if dark else MUTED))
    c.drawString(60,22,'VelvetPulse / Markenleitfaden / Version 1.0 / 02.11.2026')
    c.drawRightString(900,22,f'{page_number:02d} / 14')


def end():
    c.showPage()


def image(file, x, top, width, height):
    c.drawImage(ImageReader(str(file)),x,H-top-height,width,height,mask='auto',preserveAspectRatio=True,anchor='c')


def swatch(name, value, x, top, width=250):
    rect(x,top,width,42,value, '#D8CFBF')
    para(name,x,top+50,width,13)
    para(value,x,top+69,width,11,MUTED)


def contrast(a,b):
    def lum(v):
        s=[int(v[i:i+2],16)/255 for i in (1,3,5)]
        s=[x/12.92 if x<=.04045 else ((x+.055)/1.055)**2.4 for x in s]
        return sum(x*w for x,w in zip(s,[.2126,.7152,.0722]))
    x,y=sorted([lum(a),lum(b)])
    return (y+.05)/(x+.05)


def make():
    global c
    for name,file in [('Serif','SourceSerif4-Regular.ttf'),('SerifBold','SourceSerif4-SemiBold.ttf'),('SerifItalic','SourceSerif4-Italic.ttf')]:
        pdfmetrics.registerFont(TTFont(name,str(ROOT/'assets/fonts'/file)))
    pdfmetrics.registerFont(TTFont('Body',r'C:\Windows\Fonts\segoeui.ttf'))
    PDF.parent.mkdir(parents=True,exist_ok=True)
    c=canvas.Canvas(str(PDF),pagesize=(W,H))
    c.setTitle('VelvetPulse - Markenleitfaden v1')
    c.setAuthor('VelvetPulse')
    # 01: Die Marke
    start('Eine Marke für eigenes Erleben')
    logo(55,100,750)
    heading('Dein Körper.<br/>Dein Erleben.',top=300,width=490,size=53)
    para('Verstehen. Spüren. Verbinden.',64,460,450,18,MUTED)
    image(OUT/'bildwelt/naehe-graphit.png',485,300,430,285)
    para('Markensystem, Gestaltung und Anwendung.<br/>Papier. Graphit. Rosé.',64,545,420,13,ROSE)
    end()
    # 02: Positionierung
    start('01 / Haltung und Positionierung')
    heading('Ein persönlicher Raum.<br/>Kein vorgegebenes Erlebnis.')
    y=block('Was VelvetPulse ist',brand.DATA['positionierung'],60,220)
    block('Für wen', 'Für Erwachsene, die ihren Körper besser verstehen, sich selbst bewusster wahrnehmen oder Nähe gestalten möchten. Allein und zu zweit. Unterschiedliche Körper, Beziehungen und Lebensphasen sind willkommen.',60,y)
    y=block('Was die Marke vermittelt','Wärme und Diskretion schaffen einen ruhigen Einstieg. Wissen gibt Orientierung. Sinnlichkeit macht neugierig. Die eigene Erfahrung bleibt frei.',515,220)
    block('Was wir nicht versprechen','Keine garantierten Orgasmen, Heilung oder automatische Veränderung der Lust. Keine Körpernorm als Ziel. Möglichkeiten werden konkret beschrieben, Ergebnisse bleiben individuell.',515,y)
    end()
    # 03: Logo
    start('02 / Das prägnantere Markenzeichen')
    heading('Ein Bogen. Eine Bewegung. Ein V.')
    logo(65,215,790)
    y=block('Offener Bogen','Ein Raum, der nicht abschließt. Der kleine Rosé-Akzent verbindet Wärme mit der graphitfarbenen Kontur.',60,440)
    block('Weiche V-/Pulslinie','Eine klare eigene Bewegung statt Herz, Flamme oder medizinischer Kurve. Weniger Striche und kräftigere Konturen halten das Zeichen auch klein zusammen.',515,440)
    end()
    # 04: Varianten
    start('03 / Die Logo-Familie')
    heading('Eine Form. Viele sinnvolle Anwendungen.')
    rect(60,190,840,125,'#FBF7F0');logo(85,200,500)
    rect(60,335,840,125,DEEP);logo(85,345,500,LIGHT,'#D07A8E')
    signet(70,482,80);signet(183,482,80,INK,INK);signet(296,482,80,INK,INK,True)
    para('Horizontal als Standard. Gestapelt bei wenig Breite. Signet für App und Avatar. Einfarbig dunkel oder weiß für reduzierte Anwendungen.',420,497,455,15,MUTED)
    end()
    # 05: Regeln
    start('04 / Schutzraum und Kleinformate')
    heading('Erkennbar statt dekorativ.')
    signet(70,210,185)
    c.setStrokeColor(HexColor(ACCENT));c.setDash(3,3);c.rect(65,H-405,200,205,stroke=1,fill=0);c.setDash()
    para('Mindestens ein Viertel der sichtbaren Signethöhe bleibt ringsum frei. Diese Luft gehört zum Logo.',60,438,360,16,MUTED)
    y=block('Mindestgrößen','Horizontale Kombination: 160 Pixel oder 35 Millimeter Breite. Signet: ab 24 Pixeln. Für 16 bis 23 Pixel nur die kräftigere einfarbige Kompaktfassung.',515,200)
    y=block('Unverändert verwenden','Nicht stauchen, drehen, schraffieren oder mit Schatten versehen. Kein Text im offenen Bogen. Keine zusätzliche Umrandung oder Verlaufsfüllung.',515,y)
    block('Varianten bewusst wählen','Helle Logos brauchen dunklen Grund. Die Wortmarke bleibt in den gelieferten Pfaden unverändert; sie ist unabhängig von installierten Schriften.',515,y)
    end()
    # 06: Farben
    start('05 / Farben mit einer Aufgabe')
    heading('Papier, Graphit und ein leiser Akzent.')
    for i,(name,key) in enumerate([('Papier','papier'),('Nachtpapier','nachtpapier'),('Spicy','spicy')]):
        x=60+i*285;p=brand.DATA['farben'][key]
        para(name,x,175,250,24,INK,'Serif')
        for j,(label_,value) in enumerate([('Grundfläche',p['grund']),('Haupttext',p['tinte']),('Akzent',p['akzent'])]):
            swatch(label_,value,x,225+j*100)
    para('Die aktuellen App-Paletten sind die Grundlage. Dekoratives Rosé #C98A93 bleibt ein Bildakzent. Kleine Texte verwenden Graphit bzw. die geprüften Akzent-Textfarben.',60,550,840,14,MUTED)
    end()
    # 07: Kontrast
    start('06 / Lesbarkeit und Kontrast')
    heading('Ruhig darf trotzdem klar sein.')
    report=[]
    for i,(label_,key) in enumerate([('Papier','papier'),('Nachtpapier','nachtpapier'),('Spicy','spicy')]):
        p=brand.DATA['farben'][key];x=60+i*285
        rect(x,190,260,165,p['grund'])
        para(label_,x+18,210,224,25,p['tinte'],'Serif')
        para('Körperwissen in deinem Tempo.',x+18,255,224,15,p['sekundaer'])
        para('Dein nächster Schritt',x+18,308,224,14,p['akzent_text'])
        entries=[]
        for role in ['tinte','sekundaer','akzent_text']:
            ratio=contrast(p[role],p['grund']);assert ratio>=4.5
            report.append({'palette':key,'rolle':role,'kontrast':round(ratio,2)})
            entries.append(f'{role}: {ratio:.1f}:1')
        para('<br/>'.join(entries),x,375,260,14,MUTED)
    para('Mindestens 4,5:1 für normalen Text. Dekorative Linien sind keine Textfarben. Bedeutung nie allein durch Farbe vermitteln. Auf Fotos zuerst die Lesefläche prüfen, nicht mit Glühen nachhelfen.',60,515,840,16,MUTED)
    (OUT/'quellen/kontrastpruefung.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    end()
    # 08: Schrift
    start('07 / Typografie')
    heading('Redaktionelle Ruhe.<br/>Funktionale Klarheit.')
    para('Source Serif 4',60,235,410,39,INK,'Serif')
    para('Dein Körper. Dein Erleben.',60,302,410,25,ROSE,'SerifItalic')
    para('Wissen. Wahrnehmung. Nähe.',60,355,410,23,INK,'SerifBold')
    para('Regular für Headlines und Wortmarke. SemiBold für klare redaktionelle Titel. Italic nur als bewusste Betonung. Die OFL-Schriftdateien und Lizenz liegen im Paket.',60,430,390,15,MUTED)
    y=block('System UI für die Bedienung','Fließtexte, Schaltflächen, Formulare und Zahlen im Alltag bleiben funktional. Die vorhandene Plattformschrift verwenden; keine zusätzliche Sans-Schrift in die App einführen.',515,235)
    block('Hierarchie statt Stilwechsel','Eine große Serif-Headline, eine ruhige Erklärung, ein klarer nächster Schritt. Nicht jedes Detail braucht Fettdruck. Zeilenlängen begrenzen und Fließtext großzügig setzen.',515,y)
    end()
    # 09: Bilder
    start('08 / Bildsprache')
    heading('Körper als Erfahrung, nicht als Ideal.')
    image(OUT/'bildwelt/naehe-graphit.png',45,190,525,360)
    y=block('Graphit und natürliches Licht','Feine Zeichnung, differenzierte Schraffur, natürliche Proportionen. Papier darf sichtbar sein. Haut, Stoff und Hände wirken greifbar und menschlich.',600,205,300)
    block('Vielfalt als Bildauftrag','Solo und Paar sind gleichwertig. Verschiedene Geschlechter, Körperformen und Lebensphasen zeigen. Technische Bögen und Maßmarken sparsam einsetzen. Keine Comicfiguren, stockhafte Perfektion oder erotischen Klischees.',600,y,300)
    para('Die gelieferte Illustration ist ein Markenmotiv für Nähe. Sie definiert keine Norm für die gesamte Bildbibliothek.',60,558,840,13,MUTED)
    end()
    # 10: Sprache
    start('09 / Stimme und Ton')
    heading('Einladend. Direkt. Ohne Druck.')
    y=block('Deutsch','Dein Körper. Dein Erleben.<br/><br/>Körperwissen, Sinnlichkeit und Nähe. In deinem Tempo.<br/><br/>Entdecke deinen nächsten Schritt.',60,220)
    block('So schreiben wir','Du-Ansprache, konkrete Verben und kurze, zusammenhängende Gedanken. Anatomisch präzise. Spicy darf direkt sein und bleibt respektvoll. Gesundheitshinweise klar formulieren, nicht dramatisieren.',60,y)
    y=block('English','Your body. Your experience.<br/><br/>Body knowledge, sensuality and closeness. At your own pace.<br/><br/>Discover your next step.',515,220)
    block('So nicht','Keine garantierten Erlebnisse, künstliche Verknappung oder Beschämung. Nicht jede Zeile braucht ein Sinnlichkeitswort. Keine pauschalen Datenschutzversprechen, wenn externe Dienste beteiligt sind.',515,y)
    end()
    # 11: Architektur
    start('10 / Marke und Angebote')
    heading('VelvetPulse bleibt die Dachmarke.')
    entries=[('Heute','Persönliche Einladung und ein nächster Schritt.'),('Lernen','Körperwissen verstehen und Zusammenhänge entdecken.'),('Üben','Wahrnehmung und bewusste Erfahrung vertiefen.'),('Wir','Nähe und Verständigung zu zweit gestalten.'),('Traumpraxis','Träume erinnern, Erkennen üben und Erfahrungen nachspüren.')]
    for i,(name,desc) in enumerate(entries):
        top=195+i*66
        c.setStrokeColor(HexColor('#D8CFBF'));c.line(60,H-top+6,900,H-top+6)
        para(name,60,top+12,210,24,INK,'Serif')
        para(desc,300,top+14,600,16,MUTED)
    para('Produktnamen werden als redaktionelle Überschriften gesetzt. Kein eigenes Logo pro Funktion. Spicy ist eine Atmosphäre derselben Marke.',60,550,840,14,ROSE)
    end()
    # 12: Social
    start('11 / Social Media und Kampagnen')
    heading('Eine erkennbare Familie, vier Formate.')
    samples=[('feed-traumpraxis-1080x1350',60,190,205,256),('story-marke-1080x1920',300,190,144,256),('zitat-1080x1080',480,190,205,205),('banner-1200x630',720,190,180,95)]
    for filename,x,top,w,h in samples:
        image(OUT/'vorlagen'/f'{filename}.png',x,top,w,h)
    para('Feed 4:5',60,465,205,14,MUTED);para('Story 9:16',300,465,150,14,MUTED)
    para('Zitat 1:1',480,415,205,14,MUTED);para('Banner 1,91:1',720,305,180,14,MUTED)
    para('Vier Formate, jeweils auf Deutsch und Englisch. Ein Gedanke pro Motiv, große Serif und kurze Erklärung. Bilder bestimmen die Komposition. SVGs sind editierbar, PNGs direkt nutzbar. Briefpapier und ein Präsentationscover ergänzen die Vorlagen.',60,525,840,15,MUTED)
    end()
    # 13: App / Audio
    start('12 / App, Avatar und Audio')
    heading('Wiedererkennung auch ohne große Bühne.')
    image(OUT/'icons/app-symbol-papier-1024.png',65,210,175,175)
    image(OUT/'icons/app-symbol-spicy-1024.png',275,210,175,175)
    for i,size in enumerate([64,32,24,16]):
        signet(65+i*110,450,size,INK,INK,True)
        para(f'{size} px',65+i*110,530,95,12,MUTED)
    y=block('App und Avatar','Das Signet ist die Hauptform. Keine Schrift im kleinen App-Symbol. Sicherheitsabstände für adaptive Icons beachten. Vorhandene diskrete App-Identität nicht durch das sichtbare Markenlogo ersetzen.',515,210)
    block('Die hörbare Marke','Victoria und Martin bleiben vertraute Stimmen. Warme, klare Aussprache, natürlicher Satzfluss und passende Pausen. Konkrete Profile sind in der Audio-Produktion versioniert. Keine neue Klangsignatur oder Musik ohne gesonderte Ausarbeitung.',515,y)
    end()
    # 14: Übergabe
    start('13 / Dateien und Anwendung')
    heading('Eine Grundlage, die sich weitertragen lässt.')
    y=block('Logos und Icons','SVG-Master mit echten Pfaden, transparente PNGs und einfarbige Varianten. App-Symbole und Avatare sind Entwürfe für die spätere Integration, keine ungefragten Änderungen der produktiven App.',60,180)
    y=block('Vorlagen und Quellen','Vier Social-Formate, separate Grafikelemente, Bildmotiv, Marken-JSON, Schriftdateien mit OFL-Lizenz und reproduzierbare Erzeugungswerkzeuge. Alle wesentlichen Texte liegen auch auf Englisch vor.',60,y)
    block('Digital zuerst','RGB-Farben für App und Social Media. Für verbindlichen Druck Farben mit dem jeweiligen Druckprofil abstimmen. Keine erfundenen Domainnamen, Kontakte oder Store-Badges.',60,y)
    y=block('Vor jedem Einsatz','Passende Logo-Variante wählen. Schutzraum und Lesbarkeit prüfen. Persönliche Daten und intime Inhalte gehören nicht auf allgemeine Benachrichtigungen oder öffentliche Motive.',515,180)
    y=block('Bewusst weiterentwickeln','Das Markenpaket ist Version 1. Die App-Paletten bleiben die technische Referenz. Beim Ausbau auch Altersgruppen, Körper und Beziehungskonstellationen der Bildwelt erweitern.',515,y)
    block('Nicht automatisch veröffentlicht','Alle Dateien sind für Prüfung und Nutzung vorbereitet. Bestehende App-Assets, Kanäle und Inhalte wurden nicht überschrieben. Umsetzung in der App und Veröffentlichungen bleiben getrennte Schritte.',515,y)
    end()
    assert page_number==14
    c.save()
    (OUT/'quellen/pdf-textgrenzen.json').write_text(json.dumps(boxes,ensure_ascii=False,indent=2),encoding='utf-8')
    print(PDF)


def render():
    import pypdfium2 as pdfium
    from PIL import Image, ImageDraw
    from pypdf import PdfReader
    reader=PdfReader(PDF)
    assert len(reader.pages)==14
    assert all(page.extract_text().strip() for page in reader.pages)
    doc=pdfium.PdfDocument(str(PDF))
    folder=OUT/'guide/vorschau';folder.mkdir(parents=True,exist_ok=True)
    tiles=[]
    for i in range(len(doc)):
        im=doc[i].render(scale=1.5).to_pil()
        im.save(folder/f'seite-{i+1:02}.png')
        thumb=im.copy();thumb.thumbnail((480,320));tiles.append(thumb)
    sheet=Image.new('RGB',(1440,5*350),'#DDD4C6');draw=ImageDraw.Draw(sheet)
    for i,im in enumerate(tiles):
        x=(i%3)*480;y=(i//3)*350
        sheet.paste(im,(x,y));draw.text((x+8,y+324),f'{i+1:02}',fill='#2A2A2C')
    sheet.save(OUT/'vorschau/leitfaden-kontaktbogen.jpg',quality=90)
    print('14 PDF-Seiten gerendert und Textextraktion geprüft.')


if __name__=='__main__':
    make()
    render()
