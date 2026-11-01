"""Zeichnet alle 50 Magazin-Diagramme in DE und EN neu (SVG 800 × 600).

  python tools/diagramme_magazin.py            erzeugt 100 SVG-Dateien
  python tools/diagramme_magazin.py --pruefen  vergleicht den Bestand ohne Schreiben

Alle Farben, Schriftstufen und Strichbreiten sind hier zentral definiert.
Keine Rasterbilder, Fremdschriften, Netzwerkzugriffe oder SVG-Filter.
"""
import argparse
import html
import math
from pathlib import Path
import textwrap

from diagramme_magazin_daten import BILDER

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets' / 'images'
PAPIER = '#F6F0E6'
TINTE = '#2A2A2C'
LEISE = '#5A5750'
LINIE = '#B6AB9E'
ROSÉ = '#925B68'  # Auch kleine Beschriftungen: mindestens 4,5:1 auf Papier.
HELL = '#EBD9D8'
SIGNAL = '#983F4F'
STATUS = '#526D60'
HAAR = 1.2
STIFT = 2.4


def esc(s):
    return html.escape(str(s), quote=True)


class Blatt:
    def __init__(self, kennung, daten, lang):
        self.daten, self.lang = daten, lang
        self.s = [f'<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600" role="img" aria-labelledby="titel beschreibung">',
                  f'<title id="titel">{esc(daten["titel"][lang])}</title>',
                  f'<desc id="beschreibung">{esc(daten["unter"][lang])}. {esc(daten["hinweis"][lang])}</desc>',
                  f'<rect width="800" height="600" fill="{PAPIER}"/>']
        # Feine Randmarkierungen statt eines Kastens um jede Information.
        for x, y, dx, dy in [(24,24,1,1),(776,24,-1,1),(24,576,1,-1),(776,576,-1,-1)]:
            self.linie(x,y,x+10*dx,y,LINIE,HAAR)
            self.linie(x,y,x,y+10*dy,LINIE,HAAR)
        self.text(48,39,'VELVETPULSE  /  '+('KÖRPERWISSEN' if lang=='de' else 'BODY KNOWLEDGE'),14,LEISE,abstand=1.6)
        self.text(752,39,f'{list(BILDER).index(kennung)+1:02d}',14,LEISE,anker='end')
        self.text(48,83,daten['titel'][lang],32,TINTE,serif=True)
        self.text(48,117,daten['unter'][lang],22,LEISE)
        self.linie(48,137,752,137,LINIE,HAAR)
        # Orientierungslinien bleiben außerhalb der Beschriftung.
        self.linie(400,157,400,493,LINIE,0.7,strich='2 9',opacity=0.45)

    def roh(self, s):
        self.s.append(s)

    def linie(self,x1,y1,x2,y2,farbe=TINTE,breite=STIFT,strich=None,opacity=1):
        extra=f' stroke-dasharray="{strich}"' if strich else ''
        self.roh(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{farbe}" stroke-width="{breite}" stroke-linecap="round" opacity="{opacity}"{extra}/>')

    def pfad(self,d,farbe=TINTE,breite=STIFT,fill='none',opacity=1,strich=None):
        extra=f' stroke-dasharray="{strich}"' if strich else ''
        self.roh(f'<path d="{d}" fill="{fill}" stroke="{farbe}" stroke-width="{breite}" stroke-linecap="round" stroke-linejoin="round" opacity="{opacity}"{extra}/>')

    def kreis(self,x,y,r,farbe=TINTE,fill='none',breite=STIFT):
        self.roh(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{farbe}" stroke-width="{breite}"/>')

    def ellipse(self,x,y,rx,ry,farbe=TINTE,fill='none',breite=STIFT):
        self.roh(f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="{fill}" stroke="{farbe}" stroke-width="{breite}"/>')

    def text(self,x,y,s,groesse=24,farbe=TINTE,anker='start',serif=False,gewicht='400',abstand=0):
        schrift='SourceSerif4' if serif else 'sans-serif'
        self.roh(f'<text x="{x}" y="{y}" font-family="{schrift}" font-size="{groesse}" font-weight="{gewicht}" letter-spacing="{abstand}" text-anchor="{anker}" fill="{farbe}">{esc(s)}</text>')

    def zeilen(self,x,y,s,breite=28,groesse=24,farbe=TINTE,anker='start',maxzeilen=3):
        lines=textwrap.wrap(s,width=breite,break_long_words=False,break_on_hyphens=False)
        if len(lines)>maxzeilen:
            raise ValueError(f'Beschriftung zu lang: {s}')
        for k,line in enumerate(lines): self.text(x,y+k*(groesse+6),line,groesse,farbe,anker)

    def nummer(self,x,y,n):
        self.kreis(x,y,15,ROSÉ,fill=PAPIER,breite=1.4)
        self.text(x,y+5,n,17,ROSÉ,anker='middle')

    def pfeil(self,x1,y1,x2,y2,farbe=ROSÉ):
        self.linie(x1,y1,x2,y2,farbe,2)
        a=math.atan2(y2-y1,x2-x1)
        pts=[(x2-9*math.cos(a+v),y2-9*math.sin(a+v)) for v in (-0.5,0.5)]
        self.pfad(f'M {pts[0][0]:.1f} {pts[0][1]:.1f} L {x2} {y2} L {pts[1][0]:.1f} {pts[1][1]:.1f}',farbe,2)

    def legende(self,koordinaten=None):
        p=self.daten['punkte']
        for i,item in enumerate(p):
            y=205+i*(260/max(len(p)-1,1)) if len(p)>1 else 280
            self.nummer(460,y-8,i+1)
            self.zeilen(490,y,item['titel'][self.lang],20,24,maxzeilen=2)
            if koordinaten:
                x,yy=koordinaten[i]
                self.nummer(x,yy,i+1)

    def ende(self):
        self.linie(48,518,752,518,LINIE,HAAR)
        self.zeilen(48,550,self.daten['hinweis'][self.lang],62,22,LEISE,maxzeilen=2)
        return '\n'.join(self.s+['</svg>'])+'\n'


def netz(b):
    # Vier getrennte Beiträge, die in der Mitte zusammenkommen.
    coords=[(160,221),(640,221),(160,401),(640,401)]
    b.kreis(400,313,66,LINIE,breite=1.2)
    b.kreis(400,313,49,ROSÉ,fill=HELL,breite=1.7)
    for i,((x,y),p) in enumerate(zip(coords,b.daten['punkte'])):
        sign=1 if x<400 else -1
        b.linie(x+sign*29,y,400-sign*58,313,LINIE,1.4)
        b.nummer(x,y,i+1)
        b.zeilen(x,y+46,p['titel'][b.lang],20,26,anker='middle',maxzeilen=2)
        if p['detail'][b.lang]: b.zeilen(x,y+83,p['detail'][b.lang],23,20,LEISE,'middle',maxzeilen=2)
    b.text(400,320,'+',32,ROSÉ,'middle')


def nerv(b):
    b.pfad('M 105 183 C 130 240 125 330 154 414',TINTE,4)
    for i,p in enumerate(b.daten['punkte']):
        y=203+i*115
        b.pfad(f'M 128 {y+30} C 190 {y+30} 177 {y} 240 {y}',ROSÉ,2)
        b.nummer(261,y,i+1)
        b.zeilen(297,y+7,p['titel'][b.lang],31,27,maxzeilen=2)
        b.zeilen(297,y+47,p['detail'][b.lang],35,22,LEISE,maxzeilen=2)
    for y in (195,237,279,321,363,405): b.linie(83,y,112,y+5,LINIE,1)


def wahrnehmung(b):
    # Drei eigenständige Wahrnehmungsfelder; keine behauptete anatomische Reflexkette.
    for i,p in enumerate(b.daten['punkte']):
        y=218+i*110
        if i==0:
            b.pfad(f'M 100 {y-31} Q 79 {y-5} 99 {y+13} Q 117 {y+29} 139 {y+5}',TINTE,2)
            b.pfad(f'M 99 {y+13} Q 119 {y+5} 137 {y+8}',ROSÉ,1.5)
        elif i==1:
            b.pfad(f'M 84 {y} Q 99 {y-27} 115 {y} T 148 {y}',ROSÉ,2)
        else:
            b.pfad(f'M 86 {y-14} Q 115 {y+38} 149 {y-14} Q 116 {y+8} 86 {y-14}',TINTE,2,HELL)
        b.nummer(224,y-5,i+1)
        b.text(263,y,p['titel'][b.lang],28,serif=True)
        b.zeilen(263,y+38,p['detail'][b.lang],35,23,LEISE,maxzeilen=1)


def karte(b):
    labels=['gern','vielleicht','nicht heute'] if b.lang=='de' else ['yes','maybe','not today']
    for x,t in zip((410,545,690),labels): b.text(x,186,t,22,LEISE,'middle')
    for i,p in enumerate(b.daten['punkte']):
        y=240+i*70
        b.text(64,y,p['titel'][b.lang],25)
        b.linie(64,y+24,736,y+24,LINIE,1)
        for x in (410,545,690): b.kreis(x,y-7,10,LINIE,breite=1.2)


def kreis(b):
    # Platz für vier kurze Begriffe, ohne Pfeile durch Beschriftungen.
    coords=[(252,210),(548,210),(548,429),(252,429)]
    b.pfad('M 312 210 C 370 167 431 167 488 210 M 567 251 C 609 297 609 344 567 389 M 488 429 C 431 471 369 471 312 429 M 233 389 C 190 344 190 297 233 251',LINIE,2)
    for i,((x,y),p) in enumerate(zip(coords,b.daten['punkte'])):
        b.nummer(x,y-20,i+1)
        b.zeilen(x,y+24,p['titel'][b.lang],19,25,anker='middle',maxzeilen=2)
    b.kreis(400,320,48,LINIE,breite=1.1)
    b.pfad('M 382 331 A 24 24 0 1 1 419 318',ROSÉ,1.8)
    b.pfeil(420,314,412,327)


def pfadfolge(b):
    p=b.daten['punkte']; n=len(p); xs=[140+i*520/(n-1) for i in range(n)]
    for i in range(n-1): b.pfeil(xs[i]+25,263,xs[i+1]-25,263,LINIE)
    for i,(x,item) in enumerate(zip(xs,p)):
        b.nummer(x,263,i+1)
        b.zeilen(x,325,item['titel'][b.lang],15 if n==4 else 18,25,anker='middle',maxzeilen=2)
        b.zeilen(x,400,item['detail'][b.lang],15 if n==4 else 18,21,LEISE,'middle',maxzeilen=3)


def menue(b):
    for i,p in enumerate(b.daten['punkte']):
        x=66+i*143
        b.linie(x,218,x+115,218,LINIE,1.2)
        b.text(x,292,f'0{i+1}',52,ROSÉ,serif=True)
        b.zeilen(x,349,p['titel'][b.lang],10,25,maxzeilen=2)
        b.linie(x,438,x+115,438,LINIE,1.2)
    b.text(400,484,'↔',30,LEISE,'middle')


def ampel(b):
    for i,p in enumerate(b.daten['punkte']):
        y=216+i*104
        farbe=[STATUS,ROSÉ,SIGNAL][i]
        b.kreis(103,y,24,farbe,breite=2)
        b.text(103,y+7,i+1,22,farbe,'middle')
        b.text(161,y-1,p['titel'][b.lang],30,farbe,serif=True)
        b.text(161,y+35,p['detail'][b.lang],25,TINTE)
        b.linie(161,y+57,734,y+57,LINIE,1)


def vergleich(b):
    for i,p in enumerate(b.daten['punkte']):
        x=235+i*330
        b.nummer(x,194,i+1)
        b.ellipse(x,300,82,38,LINIE,breite=1.3)
        if b.daten['_id']=='spec_1':
            if i==0:
                b.kreis(x,300,26,TINTE,breite=1.6)
                b.linie(x+21,321,x+43,343,ROSÉ,2)
            else:
                b.pfad(f'M {x-42} 302 Q {x-21} 273 {x} 302 T {x+42} 302',ROSÉ,2)
        elif b.daten['_id']=='desire_1':
            if i==0: b.pfeil(x-42,300,x+42,300)
            else: b.pfad(f'M {x-30} 315 C {x-60} 267 {x+55} 261 {x+34} 308 C {x+25} 331 {x-15} 335 {x-28} 320',ROSÉ,2)
        elif i==0:
            b.pfeil(x-56,300,x+56,300)
        else:
            b.pfad(f'M {x-55} 304 C {x-38} 268 {x+35} 268 {x+55} 304',ROSÉ,3)
            b.pfad(f'M {x-55} 311 C {x-32} 335 {x+34} 335 {x+55} 311',ROSÉ,1.5)
        b.zeilen(x,394,p['titel'][b.lang],22,29,anker='middle',maxzeilen=2)
        b.zeilen(x,454,p['detail'][b.lang],25,22,LEISE,'middle',maxzeilen=2)


def waage(b):
    b.linie(400,258,400,420,TINTE,2)
    b.pfad('M 352 448 L 400 420 L 448 448',TINTE,2)
    b.linie(170,265,630,265,TINTE,3)
    b.kreis(400,265,8,ROSÉ,fill=HELL)
    for i,p in enumerate(b.daten['punkte']):
        x=210+i*380
        b.linie(x-40,265,x-65,358,LINIE,1.5); b.linie(x+40,265,x+65,358,LINIE,1.5)
        b.pfad(f'M {x-68} 357 Q {x} 408 {x+68} 357',ROSÉ,2,HELL)
        b.zeilen(x,211,p['titel'][b.lang],23,27,anker='middle',maxzeilen=2)
        b.text(x,455,p['detail'][b.lang],22,LEISE,'middle')


def welle(b):
    b.linie(86,436,724,436,LINIE,1.2)
    b.linie(86,436,86,196,LINIE,1.2)
    if b.daten['typ']=='atem':
        d='M 94 358 C 160 358 160 223 235 223 S 310 405 387 405 S 470 223 547 223 S 620 358 711 358'
        b.pfad(d,ROSÉ,3)
        b.pfad('M 94 385 C 150 385 171 253 245 253 S 324 424 405 424 S 480 242 555 242 S 633 381 711 381',LINIE,1.6,strich='6 7')
    elif b.daten['typ']=='muskelkurve':
        b.pfad('M 94 411 L 173 411 C 195 411 204 232 246 232 C 290 232 281 408 347 411 L 708 411',ROSÉ,3)
    else:
        b.pfad('M 94 411 C 142 411 160 305 213 301 S 264 391 311 391 S 367 257 425 260 S 492 375 538 375 S 614 278 708 304',ROSÉ,3)
    for x,p in zip((180,400,636),b.daten['punkte']): b.zeilen(x,480,p['titel'][b.lang],20,23,anker='middle',maxzeilen=1)


def skala(b):
    for i in range(10):
        x=91+i*68
        b.linie(x,280,x,315,ROSÉ if i%3==0 else LINIE,2)
        b.text(x,357,i+1,25,LEISE,'middle')
    b.linie(91,297,703,297,LINIE,1)
    for x,p in zip((150,400,656),b.daten['punkte']): b.zeilen(x,441,p['titel'][b.lang],18,27,anker='middle')
    b.pfad('M 160 225 C 258 183 392 181 476 220 S 613 244 683 210',ROSÉ,2)


def becken(b):
    # Schematischer Beckenring von oben; keine erfundenen anatomischen Schichtgrenzen.
    b.pfad('M 225 189 C 118 173 73 245 87 340 C 98 403 147 438 226 447 C 302 438 355 403 366 340 C 380 245 334 173 225 189 Z',TINTE,2)
    b.pfad('M 226 223 C 148 211 121 262 136 330 C 147 373 178 401 226 412 C 275 400 306 372 316 330 C 332 261 303 210 226 223 Z',LINIE,1.4)
    b.pfad('M 127 312 Q 225 410 325 312 Q 225 355 127 312 Z',ROSÉ,2,HELL)
    for x in range(150,302,18): b.linie(x,331,x+13,349,ROSÉ,0.8,opacity=0.5)
    for y,d in [(275,-28),(350,0),(412,25)]: b.pfeil(390,y,390,y+d if d else y+1,ROSÉ if d else LINIE)
    b.legende()


def klitoris(b):
    # Frontaler Überblick: Eichel, Körper und paarige Schenkel; keine Zentimeterwerte.
    b.pfad('M 231 246 C 227 278 221 309 205 336 C 186 364 161 401 139 432 M 243 246 C 247 278 253 309 269 336 C 288 364 313 401 335 432',ROSÉ,19)
    b.pfad('M 226 249 C 232 228 242 228 248 249',TINTE,2)
    b.ellipse(237,230,16,21,ROSÉ,HELL,2)
    b.linie(237,180,237,463,LINIE,1,strich='3 7')
    b.pfad('M 230 252 C 225 296 211 323 198 344 M 244 252 C 249 296 263 323 276 344',TINTE,1.2)
    b.legende([(279,228),(281,286),(326,404)])


def prostata(b):
    b.ellipse(215,234,65,43,TINTE,HELL,2)
    b.pfad('M 192 282 C 181 301 193 334 218 338 C 245 329 252 298 239 283 Z',ROSÉ,2,HELL)
    b.pfad('M 215 271 L 215 326 C 207 370 180 406 116 434',TINTE,4)
    b.pfad('M 346 187 C 314 262 333 303 322 356 C 309 407 333 434 345 456',LINIE,24)
    b.pfad('M 346 187 C 314 262 333 303 322 356 C 309 407 333 434 345 456',TINTE,1.8)
    b.linie(159,467,355,467,LINIE,1)
    b.legende([(267,221),(263,311),(166,384),(366,354)])


def harnwege(b):
    b.ellipse(180,232,63,46,TINTE,HELL,2)
    b.pfad('M 180 279 C 175 313 186 354 171 412',TINTE,5)
    b.pfad('M 301 229 C 303 286 272 329 269 414',LINIE,34)
    b.pfad('M 301 229 C 303 286 272 329 269 414',TINTE,1.5)
    b.kreis(157,392,7,ROSÉ,HELL,1.4); b.kreis(184,392,7,ROSÉ,HELL,1.4)
    b.linie(131,444,332,444,LINIE,1)
    b.legende([(223,216),(199,341),(319,351),(137,391)])


def uterus(b):
    b.pfad('M 179 210 C 194 180 270 180 285 210 C 301 246 264 277 250 315 L 212 315 C 202 274 164 248 179 210 Z',TINTE,2,HELL)
    b.pfad('M 193 218 C 210 203 255 203 271 218 L 236 292 Z',ROSÉ,1.4)
    b.pfad('M 211 315 L 214 348 Q 232 365 250 348 L 252 315',ROSÉ,3)
    b.pfad('M 218 358 Q 206 408 216 458 M 249 358 Q 260 408 249 458',TINTE,3)
    b.pfad('M 178 211 Q 145 192 111 220 M 285 211 Q 316 192 350 220',LINIE,2)
    b.legende([(287,250),(281,333),(281,415)])


def zonen(b):
    # Klinische Außenkontur, keine Handlung und keine Hand im Bild.
    b.pfad('M 196 204 C 180 260 165 311 164 360 C 164 389 217 389 219 360 C 221 307 245 260 235 204',TINTE,2,HELL)
    b.pfad('M 197 204 Q 213 188 235 204 M 191 224 Q 213 237 237 222',ROSÉ,2)
    b.ellipse(179,421,29,37,LINIE,breite=1.6); b.ellipse(235,421,29,37,LINIE,breite=1.6)
    b.linie(209,468,209,492,ROSÉ,2)
    b.legende([(260,205),(248,305),(278,420),(243,478)])


def orientierung(b):
    if b.daten['punkte'][0]['titel']['de']=='Vorne':
        b.ellipse(225,321,104,140,TINTE,breite=1.6)
        b.pfad('M 225 208 C 185 240 179 328 225 420 C 271 328 265 240 225 208',ROSÉ,1.8)
        b.text(225,174,'12',24,LEISE,'middle'); b.text(225,490,'6',24,LEISE,'middle')
        b.text(92,330,'9',24,LEISE,'middle'); b.text(359,330,'3',24,LEISE,'middle')
        b.legende([(268,221),(326,326),(269,424)])
    else:
        b.ellipse(226,236,65,38,TINTE,breite=1.8)
        b.pfad('M 164 282 Q 225 320 288 282 L 269 397 Q 225 425 181 397 Z',ROSÉ,1.6,HELL)
        b.kreis(225,452,15,TINTE,breite=1.8)
        b.legende([(312,239),(305,350),(274,451)])


def bewegungen(b):
    for i,p in enumerate(b.daten['punkte']):
        x=144+i*172; y=290
        b.kreis(x,y,58,LINIE,breite=0.9)
        if 'kreis' in p['titel']['de'].lower():
            b.pfad(f'M {x-25} {y+20} A 33 33 0 1 1 {x+30} {y+6}',ROSÉ,3)
            b.pfeil(x+31,y+5,x+21,y+17)
        elif 'pause' in p['titel']['de'].lower():
            b.linie(x-9,y-22,x-9,y+22,ROSÉ,4); b.linie(x+9,y-22,x+9,y+22,ROSÉ,4)
        elif any(w in p['titel']['de'].lower() for w in ('streichen','gleiten')):
            b.pfeil(x-28,y,x+28,y)
            b.linie(x-32,y+18,x+28,y+18,LINIE,1)
        else:
            b.ellipse(x,y,30,15,ROSÉ,HELL,1.8)
            b.linie(x-37,y+25,x+37,y+25,LINIE,1)
        b.nummer(x,187,i+1)
        b.zeilen(x,407,p['titel'][b.lang],14,25,anker='middle',maxzeilen=2)


def druck(b):
    for i,p in enumerate(b.daten['punkte']):
        x=236+i*330
        b.linie(x-100,325,x+100,325,TINTE,2)
        width=20 if i==0 else 140
        b.pfad(f'M {x-width/2} 278 L {x+width/2} 278 L {x+width/2} 317 L {x-width/2} 317 Z',LINIE,1.4,HELL)
        for xx in range(int(x-width/2),int(x+width/2)+1,20): b.pfeil(xx,342,xx,383)
        b.text(x,216,p['titel'][b.lang],30,anker='middle',serif=True)
        b.text(x,445,p['detail'][b.lang],23,LEISE,'middle')


def objekte(b):
    for i,p in enumerate(b.daten['punkte']):
        x=142+i*173
        if b.daten['typ']=='material':
            if i==0:
                b.pfad(f'M {x-50} 316 C {x-37} 224 {x+37} 344 {x+50} 252 L {x+50} 279 C {x+26} 356 {x-29} 249 {x-50} 341 Z',ROSÉ,1.6,HELL)
            elif i==1:
                b.pfad(f'M {x-40} 259 L {x+26} 240 L {x+48} 310 L {x-19} 331 Z',TINTE,1.6)
                b.linie(x-24,265,x+18,254,LINIE,1.2); b.linie(x-19,281,x+24,270,LINIE,1.2)
            elif i==2:
                b.ellipse(x,257,44,16,TINTE,breite=1.5)
                b.linie(x-44,257,x-44,318,TINTE,1.5); b.linie(x+44,257,x+44,318,TINTE,1.5)
                b.pfad(f'M {x-44} 318 Q {x} 347 {x+44} 318',TINTE,1.5)
                for k in range(4):b.linie(x-26+k*14,278,x-26+k*14,318,LINIE,0.8)
            else:
                b.pfad(f'M {x-45} 265 Q {x-45} 249 {x-29} 249 L {x+29} 249 Q {x+45} 249 {x+45} 265 L {x+45} 320 L {x-45} 320 Z',TINTE,1.6,HELL)
                b.kreis(x,281,12,ROSÉ,breite=1.2)
        elif b.daten['_id']=='toys_2':
            b.pfad(f'M {x-23} 331 L {x-23} 260 Q {x-23} 228 {x} 228 Q {x+23} 228 {x+23} 260 L {x+23} 331 Z',TINTE,2,HELL)
            if i==0:
                for dx in (-40,40): b.pfad(f'M {x+dx} 258 Q {x+dx+7} 280 {x+dx} 302',ROSÉ,1.6)
            elif i==1:
                b.ellipse(x,261,13,17,ROSÉ,PAPIER,1.3)
                for k in range(3): b.kreis(x,267+k*15,2,ROSÉ,ROSÉ,1)
            elif i==2:
                b.ellipse(x,241,23,10,TINTE,PAPIER,1.4)
                b.pfad(f'M {x-11} 258 Q {x+10} 270 {x-11} 284 T {x-11} 315',LINIE,1)
            else: b.linie(x-41,335,x+41,335,ROSÉ,5)
        else:
            if i==0:
                b.pfad(f'M {x} 235 C {x-53} 293 {x-34} 329 {x} 329 C {x+34} 329 {x+53} 293 {x} 235 Z',ROSÉ,1.6,HELL)
            elif i==1:
                b.linie(x-45,334,x+45,334,TINTE,1.4)
                for dx in (-24,0,24):b.pfad(f'M {x+dx} 321 Q {x+dx-15} 304 {x+dx} 288 T {x+dx} 254',ROSÉ,1.4)
            elif i==2:
                b.pfad(f'M {x-57} 260 L {x-15} 260 L {x-15} 328 L {x-57} 328 Z M {x+15} 260 L {x+57} 260 L {x+57} 328 L {x+15} 328 Z',TINTE,1.5)
                b.linie(x,244,x,342,ROSÉ,1.2,strich='3 5')
            else:
                b.pfad(f'M {x-47} 250 L {x+47} 250 L {x+47} 333 L {x-47} 333 Z M {x-56} 242 L {x+56} 242',TINTE,1.5)
                b.pfad(f'M {x-18} 289 L {x-4} 303 L {x+23} 273',ROSÉ,2)
        b.nummer(x,184,i+1)
        b.zeilen(x,401,p['titel'][b.lang],15,25,anker='middle',maxzeilen=2)
        b.zeilen(x,457,p['detail'][b.lang],16,21,LEISE,'middle',maxzeilen=2)


def haltung(b):
    for i,p in enumerate(b.daten['punkte']):
        x=212+i*365; y=302
        b.linie(x-120,y+81,x+130,y+81,LINIE,1.2)
        kennung=b.daten['_id']
        if kennung=='pelvic_3' and i==1:
            # Seitliche Hocke mit festem Halt vor dem Körper.
            b.kreis(x-28,y-71,20,TINTE,breite=2)
            b.pfad(f'M {x-23} {y-46} L {x-45} {y+8} L {x+15} {y+22} L {x-13} {y+68} L {x+33} {y+68}',TINTE,4)
            b.pfad(f'M {x-20} {y-33} L {x+11} {y-7} L {x+60} {y-24}',TINTE,3)
            b.linie(x+65,y-90,x+65,y+78,LINIE,4)
        elif kennung=='pelvic_3' or (kennung=='pos_3' and i==0):
            # Rückenlage von oben: gebeugte Knie auf seitlichen Kissen.
            b.kreis(x,y-76,20,TINTE,breite=2)
            b.pfad(f'M {x} {y-51} L {x} {y+8} M {x-27} {y-29} L {x+27} {y-29} M {x} {y+8} L {x-69} {y+32} L {x-15} {y+63} L {x+15} {y+63} L {x+69} {y+32} L {x} {y+8}',TINTE,3)
            for dx in (-76,76): b.ellipse(x+dx,y+48,28,17,LINIE,HELL,1.2)
        elif i==0:
            b.pfad(f'M {x-95} {y+70} Q {x-70} {y+45} {x-41} {y+70} Z',LINIE,1.2,HELL)
            b.kreis(x-72,y+18,20,TINTE,breite=2)
            b.pfad(f'M {x-45} {y+20} Q {x} {y+52} {x+28} {y+41} L {x+72} {y+70} L {x+119} {y+65}',TINTE,4)
            b.pfad(f'M {x+26} {y+41} L {x+54} {y+16} L {x+102} {y+55}',TINTE,3)
        else:
            b.kreis(x-33,y-71,20,TINTE,breite=2)
            b.pfad(f'M {x-31} {y-46} L {x-27} {y+11} L {x+44} {y+25} L {x+44} {y+69} L {x+84} {y+69} M {x-31} {y-27} L {x-79} {y+20} L {x-79} {y+61}',TINTE,3.5)
            b.pfad(f'M {x-63} {y+21} L {x+11} {y+21} L {x+11} {y+77} M {x-63} {y+21} L {x-63} {y+77}',LINIE,2)
        b.nummer(x,183,i+1)
        b.zeilen(x,424,p['titel'][b.lang],23,28,anker='middle',maxzeilen=1)
        b.zeilen(x,463,p['detail'][b.lang],25,22,LEISE,'middle',maxzeilen=2)


def gefaess(b):
    b.pfad('M 96 260 C 205 260 194 332 290 332 C 394 332 382 260 480 260',ROSÉ,18)
    b.ellipse(551,287,75,111,LINIE,HELL,1.6)
    b.pfeil(156,215,219,215); b.pfeil(344,292,405,292)
    for x,p in zip((153,400,650),b.daten['punkte']): b.zeilen(x,462,p['titel'][b.lang],18,24,anker='middle',maxzeilen=2)
    b.linie(628,290,720,290,LINIE,1.4)


def zweispur(b):
    for i,p in enumerate(b.daten['punkte']):
        y=258+i*139
        b.text(67,y-54,p['titel'][b.lang],29,serif=True)
        b.linie(68,y,731,y,LINIE,1)
        b.pfad(f'M 210 {y} C 280 {y} 297 {y-35} 365 {y-35} S 443 {y+18} 500 {y+18} S 575 {y} 711 {y}',ROSÉ if i==0 else TINTE,2.5)
        b.text(67,y+46,p['detail'][b.lang],22,LEISE)


ZEICHNER = {'netz':netz,'nerv':nerv,'karte':karte,'kreis':kreis,'pfad':pfadfolge,'pfad4':pfadfolge,'menue':menue,
 'ampel':ampel,'vergleich':vergleich,'waage':waage,'welle':welle,'atem':welle,'muskelkurve':welle,'skala':skala,
 'becken':becken,'klitoris':klitoris,'prostata':prostata,'harnwege':harnwege,'uterus':uterus,'zonen':zonen,
 'orientierung':orientierung,'bewegungen':bewegungen,'druck':druck,'material':objekte,'objekte':objekte,
 'haltung':haltung,'gefaess':gefaess,'zweispur':zweispur,'wahrnehmung':wahrnehmung}


def zeichne(kennung,lang):
    daten=dict(BILDER[kennung],_id=kennung)
    b=Blatt(kennung,daten,lang)
    ZEICHNER[daten['typ']](b)
    return b.ende()


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--pruefen',action='store_true')
    args=ap.parse_args()
    soll={f'diagram_{k}{s}.svg':zeichne(k,lang) for k in BILDER for s,lang in [('', 'de'),('_en','en')]}
    bestand={p.name for p in OUT.glob('diagram_*.svg')}
    if bestand != set(soll): raise SystemExit(f'Dateibestand abweichend: {sorted(bestand ^ set(soll))}')
    abweichend=[]
    for name,svg in soll.items():
        if args.pruefen:
            if (OUT/name).read_text(encoding='utf-8')!=svg: abweichend.append(name)
        else:
            (OUT/name).write_text(svg,encoding='utf-8',newline='\n')
    if abweichend: raise SystemExit(f'Nicht aktuell: {abweichend}')
    print(f'{len(soll)} Magazin-Diagramme '+('geprüft.' if args.pruefen else 'erzeugt.'))


if __name__=='__main__':main()
