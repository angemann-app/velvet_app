"""Erstellt nur einen lokalen Hörplan aus vorhandenen Prüfberichten.

Keine Synthese, keine Aufnahmen ändern, kein Upload und keine Hörabnahme behaupten.
"""
import hashlib
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/gesamt/abnahme'
BEGRIFFE = ('gaspedal', 'bremspedal', 'prostata', 'klitoris', 'psoas',
            'exzitation', 'edging', 'squirting', 'beckenboden', 'sinnesspüren')


def lesen(p):
    return json.loads(p.read_text(encoding='utf-8'))


def main():
    geprueft = lesen(OUT / 'technische-pruefung.json')['aufnahmen']
    quellen = {}
    for code, basis in [('de', ROOT / 'assets/data'), ('en', ROOT / 'translations/en')]:
        for kurs in lesen(basis / 'velvet_content.json')['courses']:
            for lektion in kurs['lessons']:
                quellen[f"{code}/{lektion['id']}"] = lektion['content'].lower()

    def rang(r):
        text = quellen.get(r['id'], '')
        return (sum(w in text for w in BEGRIFFE), min(r['dauer_sekunden'], 180))

    proben = []
    for code in ('de', 'en'):
        lektionen = [r for r in geprueft if r['gruppe'] == 'alle-lektionen' and r['id'].startswith(code + '/')]
        for stimme in ('victoria', 'martin', 'both'):
            r = max((r for r in lektionen if r['stimme'] == stimme), key=rang)
            proben.append(dict(r, fokus='Aussprache und Satzfluss' if stimme != 'both' else 'Stimmwechsel und Lautstärkebalance',
                               begriffe=[w for w in BEGRIFFE if w in quellen.get(r['id'], '')]))
        spicy = next((r for r in lektionen if r['id'] == code + '/spduo_4'),
                     next(r for r in lektionen if r['id'].startswith(code + '/spduo_')))
        proben.append(dict(spicy, fokus='Spicy: direkt und sinnlich, dabei natürlich gesprochen', begriffe=[]))
        for familie in ('paar', 'selbst', 'einschlaf', 'traum'):
            daten = lesen((ROOT / 'assets/data' if code == 'de' else ROOT / 'translations/en') /
                          ('paar_abend.json' if familie == 'paar' else familie + '_reise.json'))
            meta = {b['id']: b for b in daten['bausteine']}
            for stimme in ('victoria', 'martin'):
                kandidaten = [r for r in geprueft if r['id'].startswith(f'{code}/{familie}/{stimme}_')]
                lang = [r for r in kandidaten if r['dauer_sekunden'] >= 25]
                if lang:
                    kandidaten = lang
                spicy_gewuenscht = (code == 'de') == (stimme == 'victoria')

                def stufe(r):
                    b = meta.get(r['id'].split('/')[-1][len(stimme) + 1:], {})
                    return b.get('spicy') is True or b.get('tiefe') in ('spicy', 'sehrSpicy')

                passend = [r for r in kandidaten if stufe(r) == spicy_gewuenscht]
                r = max(passend or kandidaten, key=lambda r: min(r['dauer_sekunden'], 110))
                proben.append(dict(r, fokus=('Ruhiges Tempo und Satzenden' if familie in ('einschlaf', 'traum')
                    else 'Natürlichkeit, Sinnbögen und Pausen') + (' · Spicy' if stufe(r) else ''), begriffe=[]))

    praxis = lesen(ROOT / 'build/redaktion/traumpraxis/technische-pruefung.json')['aufnahmen']
    for ident in ('de/victoria_praxis_abend', 'de/martin_praxis_klarheit',
                  'en/victoria_praxis_morgen', 'en/martin_praxis_abend'):
        r = next(r for r in praxis if r['id'] == ident)
        code, name = ident.split('/')
        proben.append(dict(r, datei=str(ROOT / 'build/redaktion/traumpraxis/audio' / code / (name + '.opus')),
            stimme=name.split('_')[0], profil='traumpraxis', fokus='Traumpraxis: angenehmer literarischer Fluss, kein künstliches Ziehen', begriffe=[]))

    assert len(proben) == len({r['id'] for r in proben}) == 28
    for r in proben:
        p = Path(r['datei'])
        assert p.is_file(), p
        assert hashlib.sha256(p.read_bytes()).hexdigest() == r['sha256'], p
        d = r['dauer_sekunden']
        r['hoerfenster'] = [[0, round(d, 2)]] if d <= 75 else [
            [0, 20], [round(d / 2 - 10, 2), 20], [round(max(0, d - 20), 2), 20]]
        r['hoerstatus'] = 'offen'
    minuten = sum(sum(f[1] for f in r['hoerfenster']) for r in proben) / 60
    plan = dict(stand='2026-11-02', status='Hörprüfung offen', proben=28,
        geplante_hoerminuten=round(minuten, 1), dateipfade_und_sha256_geprueft=True, aufnahmen=proben)
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'AG_STICHPROBEN.json').write_text(json.dumps(plan, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    karten = []
    for i, r in enumerate(proben):
        grenzen = ' · '.join(f'{f[0]:g}s / {f[1]:g}s' for f in r['hoerfenster'])
        knoepfe = ' '.join(f'<button onclick="fenster(\'a{i}\',{f[0]},{f[1]})">{titel}</button>'
                          for titel, f in zip(('Anfang', 'Mitte', 'Ende'), r['hoerfenster']))
        knoepfe += f' <button onclick="fenster(\'a{i}\',0,Infinity)">Ganz anhören</button>'
        karten.append(f'<article><h2>{html.escape(r["id"])}</h2><p>{html.escape(r["fokus"])} · {r["dauer_sekunden"]:.1f}s</p>'
            f'<p>{html.escape(", ".join(r["begriffe"]))}</p><audio id="a{i}" controls preload="none" src="{Path(r["datei"]).as_uri()}"></audio>'
            f'<p>{knoepfe}</p><small>Hörfenster: {grenzen}. Status: offen.</small></article>')
    (OUT / 'AG_STICHPROBEN.html').write_text('<!doctype html><html lang="de"><meta charset="utf-8"><title>AG / Hörstichproben</title>'
        '<style>body{max-width:1000px;margin:32px auto;padding:20px;background:#F6F0E6;color:#2A2A2C;font:16px/1.5 system-ui}'
        'h1,h2{font-family:Georgia,serif}h2{font-size:21px}article{border-top:1px solid #d8cfbf;padding:20px 0}audio{width:100%}'
        'button{margin-right:8px;padding:8px 14px}</style><h1>28 gezielte Hörstichproben</h1>'
        f'<p>Etwa {minuten:.0f} Minuten, zuzüglich Stellen mit Stimmwechsel oder Aussprachezweifel. Keine Aufnahme gilt hier als angehört.</p>'
        '<p>Kurze Dateien vollständig, längere an Anfang/Mitte/Ende prüfen. Bei gemischten Stimmen zusätzlich einen tatsächlichen Wechsel anhören. '
        'Auffällige Dateien vollständig prüfen und ID, Zeitmarke sowie Befund notieren. Originaldateien bleiben unverändert.</p>'
        + ''.join(karten) + '''<script>
function fenster(id,von,dauer){
 document.querySelectorAll('audio').forEach(a=>{a.pause();a.ontimeupdate=null;});
 const a=document.getElementById(id);a.currentTime=von;
 a.ontimeupdate=()=>{if(a.currentTime>=von+dauer)a.pause();};
 a.play();
}
</script></html>''', encoding='utf-8')
    bericht = ['# AG: Hörstichproben – noch offen', '', 'Keine Hörprüfung erfolgt. AG trägt je Probe sein tatsächliches Ergebnis ein.', '',
               '| ID | Status | Zeitmarke | Befund |', '|---|---|---|---|']
    bericht += [f'| {r["id"]} | offen | | |' for r in proben]
    (OUT / 'AG_BERICHT_VORLAGE.md').write_text('\n'.join(bericht) + '\n', encoding='utf-8')
    print(json.dumps(dict(proben=28, hoerminuten=round(minuten, 1), pfade_und_hashes='bestanden', hoerpruefung='offen'), ensure_ascii=False))


if __name__ == '__main__':
    main()
