"""Validiert das fertige Markenpaket und erstellt Galerie, Manifest und ZIP."""
import hashlib
import html
import json
from pathlib import Path
import re
import shutil
import xml.etree.ElementTree as ET
import zipfile

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'marketing/marke/v1'


def main():
    files = sorted(OUT.rglob('*.svg'))
    assert len(files) == 32
    for file in files:
        root = ET.fromstring(file.read_text(encoding='utf-8'))
        assert root.find('{http://www.w3.org/2000/svg}title') is not None
        w, h = int(root.attrib['width']), int(root.attrib['height'])
        with Image.open(file.with_suffix('.png')) as im:
            assert im.size == (w,h), file
            if file.parent.name == 'logos':
                assert im.mode == 'RGBA' and im.getchannel('A').getextrema()[0] == 0
                assert im.getchannel('A').getbbox() is not None
        if file.parent.name == 'logos':
            assert root.find('.//{http://www.w3.org/2000/svg}text') is None, 'Logo muss echte Pfade enthalten'
            assert root.find('.//{http://www.w3.org/2000/svg}image') is None
    report=json.loads((OUT/'quellen/renderpruefung.json').read_text(encoding='utf-8'))
    assert report['svg_dateien'] == 32 and not report['fehler']
    colors=json.loads((OUT/'quellen/marke.json').read_text(encoding='utf-8'))['farben']
    source=(ROOT/'lib/theme/vp_palette.dart').read_text(encoding='utf-8')
    roles={'grund':'papier','erhoben':'papierErhoben','tinte':'tinte','sekundaer':'tinteLeise',
           'linie':'linie','akzent':'akzent','akzent_text':'akzentTief'}
    for name,constant in [('papier','papierPalette'),('nachtpapier','nachtPalette'),('spicy','spicyPalette')]:
        block=re.search(r'static const '+constant+r' = VpPalette\((.*?)\n  \);',source,re.S).group(1)
        for role,field in roles.items():
            value=re.search(r'\b'+field+r': Color\(0xFF([0-9A-Fa-f]{6})\)',block).group(1)
            assert colors[name][role].upper()=='#'+value.upper(), (name,role)
    contrasts=json.loads((OUT/'quellen/kontrastpruefung.json').read_text(encoding='utf-8'))
    assert len(contrasts)==9 and all(x['kontrast']>=4.5 for x in contrasts)
    for filename in ['feed-traumpraxis-1080x1350','story-marke-1080x1920','zitat-1080x1080','banner-1200x630']:
        for suffix in ['', '-en']:
            assert (OUT/'vorlagen'/f'{filename}{suffix}.svg').exists()
            assert (OUT/'vorlagen'/f'{filename}{suffix}.png').exists()
    (OUT/'guide').mkdir(exist_ok=True)
    shutil.copyfile(ROOT/'output/pdf/VelvetPulse-Markenleitfaden-v1.pdf',OUT/'guide/VelvetPulse-Markenleitfaden-v1.pdf')
    for name in ['marke_schriftpfade.ps1','markenpaket.py','markenleitfaden.py','markenpaket_pruefen.py']:
        target=OUT/'quellen/werkzeuge'/name
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(ROOT/'tools'/name,target)
    cards=[]
    for file in sorted((OUT/'vorlagen').glob('*.png')):
        rel=file.relative_to(OUT).as_posix()
        cards.append(f'<article><img src="{rel}" alt="{html.escape(file.stem)}"><h3>{html.escape(file.stem)}</h3>'
                     f'<a href="{rel}">PNG</a> · <a href="{rel[:-4]}.svg">SVG</a></article>')
    page='''<!doctype html><html lang="de"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>VelvetPulse · Markenpaket</title><style>
@font-face{font-family:VP;src:url(fonts/SourceSerif4-Regular.ttf)}
body{background:#F6F0E6;color:#2A2A2C;font:16px/1.6 system-ui;margin:0;padding:48px;max-width:1300px;margin:auto}
h1,h2,h3{font-family:VP,Georgia,serif;font-weight:400}h1{font-size:48px}a{color:#8E4A57}
.logo{width:min(810px,100%)}.hero{width:100%}.grid{display:grid;grid-template-columns:1fr 1fr;gap:32px}
article{border-top:1px solid #D8CFBF;padding:24px 0}article img{width:100%;height:400px;object-fit:contain}
@media(max-width:700px){body{padding:24px}.grid{grid-template-columns:1fr}h1{font-size:36px}}
</style><img class="logo" src="logos/velvetpulse-horizontal-papier.svg" alt="VelvetPulse">
<h1>Dein Körper. Dein Erleben.</h1><p>Markenpaket v1 · Papier, Graphit und Rosé.</p>
<p><a href="guide/VelvetPulse-Markenleitfaden-v1.pdf">Markenleitfaden</a> · <a href="README.md">Verwendung</a> · <a href="README.en.md">English notes</a></p>
<img class="hero" src="vorschau/markenuebersicht.png" alt="Überblick der Markenwelt">
<h2>Logos</h2><p><a href="logos/velvetpulse-horizontal-papier.svg">Standard SVG</a> · <a href="logos/velvetpulse-horizontal-hell.svg">Hell SVG</a> ·
<a href="logos/velvetpulse-gestapelt-papier.svg">Gestapelt</a> · <a href="logos/velvetpulse-signet-papier.svg">Signet</a> · <a href="logos/velvetpulse-kompakt-dunkel.svg">Kompakt</a></p>
<h2>Vorlagen</h2><p>Editierbare SVGs und nutzbare PNGs. Social-Motive auf Deutsch und Englisch.</p><div class="grid">'''
    (OUT/'START.html').write_text(page+'\n'.join(cards)+'</div></html>',encoding='utf-8')
    selected=[p for p in sorted(OUT.rglob('*')) if p.is_file() and 'guide/vorschau/' not in p.relative_to(OUT).as_posix()
              and p.name!='manifest.json']
    manifest={'version':'1.0','datum':'2026-11-02','svg_master':32,'dateien':[
        {'pfad':p.relative_to(OUT).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in selected]}
    (OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    selected.append(OUT/'manifest.json')
    archive=OUT.parent/'VelvetPulse-Markenpaket-v1.zip'
    with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for file in selected:
            z.write(file,'VelvetPulse-Markenpaket-v1/'+file.relative_to(OUT).as_posix())
    with zipfile.ZipFile(archive) as z:
        assert z.testzip() is None
        assert len(z.namelist())==len(selected)
    print(f'{len(selected)} Dateien gepackt; 32 SVG-/PNG-Paare, 9 Textkontraste und alle drei App-Paletten geprüft.')
    print(f'{archive} · {archive.stat().st_size/1024/1024:.1f} MB')


if __name__=='__main__':
    main()
