"""Nur lesender Bestandsabgleich für Claudes Rückfrage, keine Synthese/Builds.

Aktuelle Texte gegen gespeicherte Produktionsaufträge/Fingerprints, Audiodateien
und tatsächlich gebaute ZIP-Einträge. Ausgaben nur als lokale Metadatenlisten.
Private Sprechtexte werden weder ausgegeben noch ins Repository geschrieben.
"""
import collections
import csv
import hashlib
import json
from pathlib import Path
import subprocess
import zipfile

import generate_audio as de
import generate_audio_en as en
import reihe_ausdruck

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/redaktion/abgleich-claude'
OLD = ROOT / 'build/redaktion/gesamt/produktion'
TON = ROOT / 'build/redaktion/spicy-ton'
PRIV = Path('C:/TOOLS/velvet-inhalte/reihe')
FILES = {'paar_abend': 'paar', 'selbst_reise': 'selbst', 'einschlaf_reise': 'einschlaf', 'traum_reise': 'traum'}
VERSIONS = json.loads((ROOT / 'tools/pakete/versionen.json').read_text(encoding='utf-8'))


def sha(b):
    return hashlib.sha256(b).hexdigest()


def read(p):
    return json.loads(p.read_text(encoding='utf-8'))


def gitbytes(name):
    return subprocess.check_output(['git', 'show', '2c34cc5:' + name], cwd=ROOT)


def category(name, item, course=None):
    if name == 'velvet_content':
        return 'Spicy' if item.get('spicy') or course.get('spicy') else 'Normal'
    if item.get('tiefe') == 'sehrSpicy' or item.get('variante') == 'sehrspicy':
        return 'Sehr spicy'
    if item.get('tiefe') == 'spicy' or item.get('teil') in ('s1', 's2') or item.get('stufe') == 'spicy':
        return 'Spicy'
    return 'Normal'


def csvwrite(name, rows):
    keys = list(dict.fromkeys(k for r in rows for k in r))
    with (OUT / name).open('w', encoding='utf-8-sig', newline='') as f:
        writer = csv.DictWriter(f, keys)
        writer.writeheader()
        writer.writerows(rows)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    texts, current, all_spicy, counts = [], {}, [], []
    last = read(TON / 'uebernahme.json')['aenderungen']
    last_keys = {(a['sprache'], a['datei'], a['id']) for a in last}
    for lang, base in [('de', 'assets/data'), ('en', 'translations/en')]:
        for name in ('velvet_content', *FILES):
            now = read(ROOT / base / (name + '.json'))
            old = json.loads(gitbytes(base + '/' + name + '.json'))
            count = collections.Counter()
            if name == 'velvet_content':
                oldmap = {l['id']: l for c in old['courses'] for l in c['lessons']}
                rows = [(l, c) for c in now['courses'] for l in c['lessons']]
            else:
                oldmap = {b['id']: b for b in old['bausteine']}
                rows = [(b, None) for b in now['bausteine']]
            for item, course in rows:
                ident = item['id']
                kind = category(name, item, course)
                fields = ['title', 'summary', 'content', 'reflection_question', 'task'] if course is not None else ['text']
                changed = [k for k in fields if oldmap.get(ident, {}).get(k) != item.get(k)]
                if course is not None:
                    speech = de.speech_text(item) if lang == 'de' else en.sprechtext(item)
                    task = {'sprache': lang, 'id': ident, 'stimme': de.voice_for(course, item), 'text': speech,
                        'szene': 'wissen', 'profil': reihe_ausdruck.LEKTIONS_PROFIL}
                    keys = [lang + '/' + ident]
                    current[keys[0]] = (task, dict(task, art='lektion'))
                else:
                    slow = name in ('einschlaf_reise', 'traum_reise')
                    keys = []
                    for voice in ('victoria', 'martin'):
                        keyid = f'{FILES[name]}/{voice}_{ident}'
                        key = lang + '/' + keyid
                        task = {'sprache': lang, 'id': keyid, 'text': item['text'], 'stimme': voice,
                            'profil': 'bestand-langsam-1' if slow else 'bestand-gefuehrt-1', 'langsam': slow}
                        current[key] = (task, dict(task, art='gefuehrt'))
                        keys.append(key)
                if changed:
                    count[kind] += 1
                    texts.append({'sprache': lang, 'datei': name, 'id': ident, 'klasse': kind,
                        'felder': ','.join(changed), 'audio_ids': '|'.join(keys),
                        'letzter_tondurchgang': (lang, name, ident) in last_keys})
                if kind != 'Normal':
                    all_spicy.append({'sprache': lang, 'datei': name, 'id': ident, 'klasse': kind,
                        'gesamt_geaendert': bool(changed), 'letzter_tondurchgang': (lang, name, ident) in last_keys,
                        'audio_ids': '|'.join(keys), 'grund_unveraendert_im_letzten_durchgang': {
                            'velvet_content': 'Anatomischer Einstieg beibehalten; früheres Gesamtlektorat und Neuvertonung vorhanden',
                            'paar_abend': 'Vorhandene direkte Passage bzw. bedeutungstragende Spielregel/Check-in beibehalten',
                            'selbst_reise': 'Vorhandene direkte Passage bzw. bewusst gesetzter Abschluss beibehalten',
                            'einschlaf_reise': 'Ruhiges Einschlafprofil beibehalten, keine flächige erotische Erweiterung',
                            'traum_reise': 'Bestehendes klares Spicy-Traumbild beibehalten',
                        }[name] if (lang, name, ident) not in last_keys else ''})
            counts.append({'sprache': lang, 'datei': name, **{k: count[k] for k in ('Normal', 'Spicy', 'Sehr spicy')}})
    assert len(current) == 1744
    # Fingerprint-Rezepte ohne Synthese und ohne veraltete Auswahllisten anwenden.
    baseline_tasks = {}
    for name in ('auftraege-alle-lektionen.json', 'auftraege-gefuehrt.json'):
        for t in read(OLD / name):
            baseline_tasks[t['sprache'] + '/' + t['id']] = t
    baseline = read(OLD / 'manifest.json')
    ton = read(TON / 'produktion/manifest.json')
    lex = de.LEXICON_JSON.read_bytes()
    lexgit = gitbytes('tools/aussprache.json')
    assert json.loads(lex) == json.loads(lexgit), 'Lexikon semantisch verändert: gesonderte Prüfung nötig'
    lexes = list(dict.fromkeys([sha(lex), sha(lexgit)]))
    code0 = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in ('generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py')))
    codeg = sha((code0 + sha((ROOT / 'tools/redaktion_audio_gefuehrt.py').read_bytes())).encode())
    code1 = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
        ('spicy_ton_produktion.py', 'generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py', 'redaktion_audio_gefuehrt.py')))
    overrides = {'prostata': 'pɾˈɔstata', 'herstellerangaben': 'hˈɛɾʃtɛlɐˌaŋɡaːbən'}
    packages = {}
    def ziphash(package, member):
        if package not in packages:
            path = ROOT / 'build/pakete' / f'{package}-v{VERSIONS[package]}.zip'
            packages[package] = (path, zipfile.ZipFile(path))
        z = packages[package][1]
        return sha(z.read(member)) if member in z.namelist() else None
    audio_rows = []
    baseline_inventory = []
    for key, (t0, t1) in current.items():
        old = baseline[key]
        saved = baseline_tasks[key]
        rel = t0['id'] + '.opus'
        lang = t0['sprache']
        package = lang + ('-lektionen' if '/' not in t0['id'] else '-gefuehrt')
        packed = ziphash(package, 'audio/' + rel)
        def fp0(task, lx):
            return sha(json.dumps({'auftrag': task, 'aussprache': lx if lang == 'de' else 'englisches Kokoro',
                'code': code0 if '/' not in t0['id'] else codeg,
                'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
        base_path = OLD / lang / 'audio' / rel
        assert sha(base_path.read_bytes()) == old['sha256'], 'Basisdatei verändert: ' + key
        baseline_fp_current = [fp0(t0, lx) for lx in lexes]
        baseline_fp_saved = [fp0(saved, lx) for lx in lexes]
        baseline_valid_recipe = old['fingerprint'] in baseline_fp_saved
        baseline_current_text = saved == t0
        baseline_inventory.append({'id': key, 'quelle': str(base_path), 'sha256': old['sha256'],
            'aktueller_text': baseline_current_text, 'original_fingerprint_reproduziert': baseline_valid_recipe,
            'paket_hash_gleich': packed == old['sha256'], 'im_174er_stapel': key in ton})
        candidates = []
        if baseline_current_text and old['fingerprint'] in baseline_fp_current:
            candidates.append(('1744er', base_path, old['sha256']))
        ton_fp = False
        ton_text = False
        if key in ton:
            r = ton[key]
            def fp1(lx):
                return sha(json.dumps({'auftrag': t1, 'code': code1, 'lexikon': lx if lang == 'de' else 'en',
                    'lokale_overrides': overrides if lang == 'de' else {}, 'tempo': de.SPEED,
                    'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
            ton_fp = r['fingerprint'] in [fp1(lx) for lx in lexes]
            ton_text = r['text_sha256'] == sha(t0['text'].encode())
            p = TON / 'produktion' / lang / 'audio' / rel
            assert sha(p.read_bytes()) == r['sha256']
            if ton_fp and ton_text:
                candidates.append(('174er', p, r['sha256']))
        if key == 'de/prost_3':
            ag = read(ROOT / 'build/redaktion/gesamt/korrektur-ag26/abgenommen-ag/abnahme.json')
            p = Path(ag['datei'])
            assert sha(p.read_bytes()) == ag['sha256']
            if ag['aktueller_text_sha256'] == sha(t0['text'].encode()):
                candidates.append(('AG26', p, ag['sha256']))
        chosen = candidates[-1] if candidates else None
        audio_rows.append({'id': key, 'paket': package, 'mitglied': 'audio/' + rel,
            'basis_text_aktuell': baseline_current_text, 'basis_fingerprint_reproduziert': baseline_valid_recipe,
            'basis_fingerprint_gegen_aktuellen_text': old['fingerprint'] in baseline_fp_current,
            'im_174er_stapel': key in ton, '174er_text_hash_aktuell': ton_text if key in ton else None,
            '174er_fingerprint_aktuell': ton_fp if key in ton else None,
            'passender_lauf': chosen[0] if chosen else None, 'passende_datei': str(chosen[1]) if chosen else None,
            'passender_sha256': chosen[2] if chosen else None, 'gebautes_paket_sha256': packed,
            'paket_enthaelt_passende_neuaufnahme': bool(chosen and packed == chosen[2]),
            'grund': 'passende Aufnahme im ZIP' if chosen and packed == chosen[2] else
                     ('passende Neuaufnahme vorhanden, aber nicht im ZIP' if chosen else 'kein belegter aktueller Aufnahmestand')})
    # Private Reihe: nur IDs, Hashes und Metadaten in den Ausgaben.
    priv_now = read(PRIV / 'reihe.json')
    priv_before = read(PRIV / 'reihe.vor-sehrspicy.bak.json')
    priv_last = read(TON / 'innenansichten/reihe.vorher.json')
    priv_manifest = read(TON / 'innenansichten/produktion/manifest.json')
    codep = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
        ('spicy_ton_innen_produktion.py', 'generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py')))
    priv_rows = []
    for lang in ('de', 'en'):
        def mapping(root):
            return {(e['id'], f['id'], s['szene']): (f, s) for e in root[lang]['folgen'] for f in e['fassungen'] for s in f['segmente']}
        bmap, lmap = mapping(priv_before), mapping(priv_last)
        count = collections.Counter()
        for (episode, ident, scene), (f, s) in mapping(priv_now).items():
            tuplekey = (episode, ident, scene)
            old = bmap.get(tuplekey)
            changed = old is None or old[1]['text'] != s['text']
            kind = 'Sehr spicy' if f['variante'] == 'sehrspicy' else ('Spicy' if f['variante'] == 'spicy' else 'Soft')
            name = f"{f['stimme']}_{episode}_{ident}_{scene}"
            key = lang + '/' + name
            p = PRIV / ('audio' if lang == 'de' else 'audio_en') / (name + '.opus')
            packed = ziphash(lang + '-reihe', 'audio/reihe/' + name + '.opus')
            row = {'id': key, 'sprache': lang, 'datei': 'reihe', 'episode': episode,
                'fassung': ident, 'variante': f['variante'], 'szene': scene, 'klasse': kind,
                'gesamt_geaendert_oder_neu': changed, 'neu': old is None,
                'letzter_tondurchgang': tuplekey in lmap and lmap[tuplekey][1]['text'] != s['text'],
                'im_174er_stapel': key in priv_manifest, 'quelle': str(p),
                'quelldatei_sha256': sha(p.read_bytes()) if p.exists() else None}
            if changed:
                count[kind] += 1
                texts.append({'sprache': lang, 'datei': 'reihe', 'id': episode + '/' + ident + '/' + scene,
                    'klasse': kind, 'felder': 'text (neu)' if old is None else 'text', 'audio_ids': key,
                    'letzter_tondurchgang': row['letzter_tondurchgang']})
            if key in priv_manifest:
                r = priv_manifest[key]
                task = {'sprache': lang, 'id': ident, 'stimme': f['stimme'], 'szene': scene, 'text': s['text']}
                def fpp(lx):
                    return sha(json.dumps({'auftrag': task, 'code': codep, 'lexikon': lx if lang == 'de' else 'en',
                        'lokale_overrides': overrides if lang == 'de' else {}, 'profil': reihe_ausdruck.PROFIL,
                        'tempo': de.SPEED, 'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
                row.update({'text_hash_aktuell': r['text_sha256'] == sha(s['text'].encode()),
                    'fingerprint_aktuell': r['fingerprint'] in [fpp(lx) for lx in lexes],
                    'passender_sha256': r['sha256'], 'paket_enthaelt_passende_neuaufnahme': packed == r['sha256'],
                    'passende_datei': str(TON / 'innenansichten/produktion' / lang / (name + '.opus'))})
            priv_rows.append(row)
        counts.append({'sprache': lang, 'datei': 'reihe', **{k: count[k] for k in ('Normal', 'Spicy', 'Sehr spicy')}})
    # Zwölf Traumpraxis-Dateien, vom aktuellen Text und Originalrezept abgeleitet.
    dreambase = ROOT / 'build/redaktion/traumpraxis'
    dreamdata = read(ROOT / 'docs/redaktion/traumpraxis/hoertexte.json')
    dream_manifest = read(dreambase / 'manifest.json')
    coded = sha(b''.join((ROOT / 'tools' / f).read_bytes() for f in
        ('generate_audio.py', 'generate_audio_en.py', 'reihe_ausdruck.py', 'traumpraxis_hoertexte.py')))
    dream_rows = []
    for lang in ('de', 'en'):
        for entry in dreamdata['texte']:
            for voice in dreamdata['stimmen']:
                key = f"{lang}/{voice}_{entry['id']}"
                task = {'id': entry['id'], 'sprache': lang, 'stimme': voice,
                    'text': '\n\n'.join(entry[lang]['absaetze']),
                    'quelle': sha((ROOT / 'docs/redaktion/traumpraxis/hoertexte.json').read_bytes())}
                def fpd(lx):
                    return sha(json.dumps({'auftrag': task, 'code': coded, 'lexikon': lx if lang == 'de' else None,
                        'profil': reihe_ausdruck.LEKTIONS_PROFIL, 'szene': 'wissen', 'tempo': de.SPEED,
                        'stimmtempo': de.VOICE_SPEED}, sort_keys=True).encode())
                r = dream_manifest[key]
                p = dreambase / 'audio' / (key + '.opus')
                actual = sha(p.read_bytes())
                # Kein App-/Paketeintrag: explizit alle gebauten ZIP-Namen auf Praxisdatei prüfen.
                matches = []
                for pkg, (zpath, z) in packages.items():
                    for member in z.namelist():
                        if member.endswith(voice + '_' + entry['id'] + '.opus'):
                            matches.append(str(zpath) + ':' + member)
                dream_rows.append({'id': key, 'quelle': str(p), 'sha256': actual,
                    'hash_manifest_gleich': actual == r['sha256'], 'fingerprint_aktuell': r['fingerprint'] in [fpd(lx) for lx in lexes],
                    'paketfundstellen': '|'.join(matches)})
    missing = [r for r in audio_rows if not r['paket_enthaelt_passende_neuaufnahme']]
    textkeys = {key for t in texts if t['datei'] != 'reihe' for key in t['audio_ids'].split('|')}
    missing_changed = [r for r in missing if r['id'] in textkeys]
    no_recording = [r for r in audio_rows if not r['passender_lauf']]
    unshipped_old = [r for r in baseline_inventory if r['aktueller_text'] and r['original_fingerprint_reproduziert']
        and not r['paket_hash_gleich'] and not r['im_174er_stapel'] and r['id'] != 'de/prost_3']
    # Jede geänderte Text-ID mit den konkret zugehörigen Aufnahmen verknüpfen.
    amap = {r['id']: r for r in audio_rows}
    pmap = {r['id']: r for r in priv_rows}
    joined = []
    for t in texts:
        for key in t['audio_ids'].split('|'):
            r = amap.get(key) or pmap[key]
            joined.append({'sprache': t['sprache'], 'textdatei': t['datei'], 'text_id': t['id'],
                'klasse': t['klasse'], 'audio_id': key, 'im_174er_stapel': r['im_174er_stapel'],
                'passende_aufnahme_vorhanden': bool(r.get('passender_lauf') or r.get('fingerprint_aktuell')),
                'passende_datei': r.get('passende_datei'), 'sha256': r.get('passender_sha256'),
                'in_gebautem_paket': r['paket_enthaelt_passende_neuaufnahme']})
    manual = []
    for lang, base in [('de', 'assets/data'), ('en', 'translations/en')]:
        n = read(ROOT / base / 'anleitung.json')
        o = json.loads(gitbytes(base + '/anleitung.json'))
        omap = {b['id']: b for b in o['abschnitte']}
        for b in n['abschnitte']:
            if omap.get(b['id']) != b:
                manual.append({'sprache': lang, 'datei': base + '/anleitung.json', 'id': b['id'],
                    'neu': b['id'] not in omap, 'audio': 'Keine vorproduzierte Aufnahme vorgesehen'})
    summary = {'zaehlbasis': 'Öffentliche Quellen gegen Git 2c34cc5; Reihe gegen vor-sehrspicy-Sicherung; Sprachfassungen/IDs, keine addierten Zwischenstände',
        'dateien': counts, 'geaenderte_sprach_text_ids': len(texts), 'davon_oeffentlich': sum(t['datei'] != 'reihe' for t in texts),
        'neue_traumpraxis_sprachtexte': 6, 'aktuelle_oeffentliche_audio_ids': len(audio_rows),
        'aktueller_passender_lauf_vorhanden': len(audio_rows) - len(no_recording),
        'ohne_belegten_aktuellen_lauf': len(no_recording),
        'oeffentliche_paket_hash_matches': len(audio_rows) - len(missing),
        'oeffentliche_passende_dateien_nicht_im_zip': len(missing),
        'davon_zu_geaenderten_text_ids': len(missing_changed),
        '1744er_aktuell_aber_ungepackt_ausserhalb_174_ohne_ag26': len(unshipped_old),
        '174er_oeffentlich': len(ton), '174er_oeffentlich_fingerprint_aktuell': sum(r['174er_fingerprint_aktuell'] is True for r in audio_rows),
        '174er_private': len(priv_manifest), '174er_private_aktuell': sum(r.get('fingerprint_aktuell', False) and r.get('text_hash_aktuell', False) for r in priv_rows),
        'traumpraxis_aktuell': sum(r['fingerprint_aktuell'] and r['hash_manifest_gleich'] for r in dream_rows),
        'audio_ids_zu_geaenderten_texten_ohne_traumpraxis': len(joined),
        'anleitung_text_ids_zusaetzlich': len(manual),
        'lexikon_semantisch_gleich_aber_bytes_abweichend': sha(lex) != sha(lexgit),
        'keine_synthese_keine_builds': True}
    for name, rows in [('TEXTAENDERUNGEN.csv', texts), ('AUDIO_ABGLEICH.csv', audio_rows),
        ('PAKETLUECKE_GEANDERTE_TEXTE.csv', missing_changed), ('PAKETLUECKE_ALLE.csv', missing),
        ('KEINE_AKTUELLE_AUFNAHME.csv', no_recording), ('FRUEHERE_AUFNAHMEN_UNGEPACKT.csv', unshipped_old),
        ('SPICY_UNVERAENDERT_IM_LETZTEN_DURCHGANG.csv', [r for r in all_spicy if not r['letzter_tondurchgang']]),
        ('SPICY_UNVERAENDERT_IM_GESAMTZEITRAUM.csv', [r for r in all_spicy if not r['gesamt_geaendert']]),
        ('REIHE_ABGLEICH.csv', priv_rows), ('TRAUMPRAXIS_ABGLEICH.csv', dream_rows)]:
        csvwrite(name, rows)
    csvwrite('TEXT_AUDIO_ZUORDNUNG.csv', joined)
    csvwrite('ANLEITUNG_AENDERUNGEN.csv', manual)
    csvwrite('REIHE_UNVERAENDERT.csv', [r for r in priv_rows if not r['gesamt_geaendert_oder_neu']])
    (OUT / 'ZUSAMMENFASSUNG.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding='utf-8')
    for _, z in packages.values():
        z.close()
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
