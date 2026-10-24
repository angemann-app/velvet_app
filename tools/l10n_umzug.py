"""Zieht feste Oberflächentexte aus dem Dart-Code in lib/l10n/app_de.arb und app_en.arb.

Schritt 1 – Kandidaten finden:
  python tools/l10n_umzug.py kandidaten lib/screens/foo.dart [...]  > umzug.json
  Gibt je Text eine Zeile aus: {"datei", "nr", "de", "en": ""}. Zusammenhängende Texte
  ('a ' 'b') sind zusammengefasst, Interpolationen (${x}, $x) werden zu Platzhaltern {x}.

Schritt 2 – „en“ ausfüllen (leer lassen oder Zeile löschen = bleibt im Code, z. B. Schlüssel, ids).

Schritt 3 – Anwenden:
  python tools/l10n_umzug.py anwenden umzug.json
  Ersetzt die Texte durch t.<schlüssel>(…), ergänzt den Import von lib/l10n/t.dart, schreibt
  beide ARB-Dateien und entfernt danach „const“ dort, wo der Analyzer es verlangt.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ARB_DE = ROOT / "lib/l10n/app_de.arb"
ARB_EN = ROOT / "lib/l10n/app_en.arb"
DART = r"C:\TOOLS\flutter\bin\dart.bat"


# --------------------------------------------------------------------------- Dart-Strings lesen

def literale(src):
    """Findet String-Literale (ohne Kommentare) als (start, ende, roh_ohne_anführungszeichen, raw)."""
    out, i, n = [], 0, len(src)
    while i < n:
        c = src[i]
        if src.startswith("//", i):
            i = src.find("\n", i)
            i = n if i < 0 else i
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        raw = False
        if c == "r" and i + 1 < n and src[i + 1] in "'\"" and (i == 0 or not (src[i - 1].isalnum() or src[i - 1] == "_")):
            raw, i = True, i + 1
            c = src[i]
        if c in "'\"":
            q = src[i:i + 3] if src[i:i + 3] in ("'''", '"""') else c
            start = i - (1 if raw else 0)
            j = i + len(q)
            depth = 0
            while j < n:
                if not raw and src[j] == "\\":
                    j += 2
                    continue
                if not raw and src.startswith("${", j):
                    depth += 1
                    j += 2
                    continue
                if depth and src[j] == "}":
                    depth -= 1
                    j += 1
                    continue
                if depth == 0 and src.startswith(q, j):
                    break
                j += 1
            out.append((start, j + len(q), src[i + len(q):j], raw))
            i = j + len(q)
            continue
        i += 1
    return out


def gruppen(src, lits):
    """Fasst direkt aufeinanderfolgende Literale ('a' 'b') zusammen."""
    out = []
    for lit in lits:
        if out and re.fullmatch(r"\s*", src[out[-1][-1][1]:lit[0]]):
            out[-1].append(lit)
        else:
            out.append([lit])
    return [(g[0][0], g[-1][1], g) for g in out]


ESC = {"n": "\n", "t": "\t", "'": "'", '"': '"', "$": "$", "\\": "\\"}


def zu_text(gruppe):
    """Dart-Literal(e) → angezeigter Text mit {platzhaltern}, plus Liste der Ausdrücke."""
    text, ausdruecke = "", []
    for _, _, inhalt, raw in gruppe:
        if raw:
            text += inhalt
            continue
        k = 0
        while k < len(inhalt):
            ch = inhalt[k]
            if ch == "\\" and k + 1 < len(inhalt):
                text += ESC.get(inhalt[k + 1], inhalt[k + 1])
                k += 2
            elif inhalt.startswith("${", k):
                depth, m = 1, k + 2
                while depth:
                    depth += {"{": 1, "}": -1}.get(inhalt[m], 0)
                    m += 1
                ausdruecke.append(inhalt[k + 2:m - 1].strip())
                text += "{%s}" % platzhalter_name(ausdruecke[-1], len(ausdruecke), text)
                k = m
            elif ch == "$" and k + 1 < len(inhalt) and (inhalt[k + 1].isalpha() or inhalt[k + 1] == "_"):
                m = k + 1
                while m < len(inhalt) and (inhalt[m].isalnum() or inhalt[m] == "_"):
                    m += 1
                ausdruecke.append(inhalt[k + 1:m])
                text += "{%s}" % platzhalter_name(ausdruecke[-1], len(ausdruecke), text)
                k = m
            else:
                text += ch
                k += 1
    return text, ausdruecke


def platzhalter_name(ausdruck, nr, bisher=""):
    # Methodenaufrufe wie .toString() oder .round() benennen den Wert schlecht: das Objekt davor nehmen.
    woerter = [w for w in re.findall(r"[A-Za-z][A-Za-z0-9]*", ausdruck)
               if w not in ("toString", "trim", "round", "toUpperCase", "toLowerCase", "padLeft", "substring",
                            "toStringAsFixed", "remainder", "inMinutes", "inSeconds")] or ["wert"]
    kandidat = woerter[-1]
    if kandidat in ("length", "value", "first", "last", "name") and len(woerter) > 1:
        kandidat = woerter[-2] + kandidat[0].upper() + kandidat[1:]
    kandidat = kandidat[0].lower() + kandidat[1:]
    return kandidat if "{%s}" % kandidat not in bisher else f"{kandidat}{nr}"


def ist_kandidat(zeile, text):
    if not re.search(r"[A-Za-zÄÖÜäöüß]{2,}", text):
        return False
    if re.match(r"\s*(import|export|part)\b", zeile) or "debugPrint(" in zeile or "@pragma" in zeile:
        return False
    if re.fullmatch(r"[a-z0-9_./:-]+", text):  # Schlüssel, ids, Pfade
        return False
    if text.startswith(("assets/", "audio/", "http", "wss://", "package:")):
        return False
    return True


def kandidaten(dateien):
    for d in dateien:
        pfad = ROOT / d
        src = pfad.read_text(encoding="utf-8")
        for nr, (s, e, g) in enumerate(gruppen(src, literale(src))):
            zeile = src[src.rfind("\n", 0, s) + 1: src.find("\n", s)]
            text, _ = zu_text(g)
            if ist_kandidat(zeile, text):
                print(json.dumps({"datei": d, "nr": nr, "zeile": src.count("\n", 0, s) + 1, "de": text, "en": ""},
                                 ensure_ascii=False))


# --------------------------------------------------------------------------- anwenden

def schluessel(en, vergeben, praefix):
    woerter = re.findall(r"[A-Za-z]+", en)[:5] or ["text"]
    basis = praefix + "".join(w.capitalize() for w in woerter)
    k, i = basis, 2
    while k in vergeben:
        k, i = f"{basis}{i}", i + 1
    return k


def arb_lesen(p):
    return json.loads(p.read_text(encoding="utf-8"))


def arb_schreiben(p, data):
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def import_pfad(datei):
    tiefe = len(Path(datei).parts) - 2  # lib/<...>/datei.dart
    return "../" * tiefe + "l10n/t.dart" if tiefe else "l10n/t.dart"


def anwenden(umzug_datei):
    eintraege = [json.loads(z) for z in Path(umzug_datei).read_text(encoding="utf-8-sig").splitlines() if z.strip()]
    eintraege = [e for e in eintraege if e.get("en", "").strip()]
    de, en = arb_lesen(ARB_DE), arb_lesen(ARB_EN)
    vorhanden = {v: k for k, v in de.items() if not k.startswith("@") and isinstance(v, str)}
    je_datei = {}
    for e in eintraege:
        je_datei.setdefault(e["datei"], []).append(e)

    for datei, liste in je_datei.items():
        pfad = ROOT / datei
        src = pfad.read_text(encoding="utf-8")
        gs = gruppen(src, literale(src))
        praefix = re.sub(r"_(\w)", lambda m: m.group(1).upper(), Path(datei).stem.replace("_screen", ""))
        praefix = praefix[0].lower() + praefix[1:]
        ersetzungen = []
        for e in liste:
            s, ende, g = gs[e["nr"]]
            text, ausdruecke = zu_text(g)
            if text != e["de"]:
                sys.exit(f"{datei} Nr. {e['nr']}: Text passt nicht mehr – Kandidaten neu erzeugen.")
            namen = re.findall(r"\{(\w+)\}", text)
            # gleicher deutscher Text ohne Platzhalter: vorhandenen Schlüssel wiederverwenden
            key = vorhanden.get(text) if not namen and en.get(vorhanden.get(text, "")) == e["en"] else None
            if key is None:
                key = schluessel(e["en"], de, praefix)
                de[key] = text
                en[key] = e["en"]
                if namen:
                    meta = {"placeholders": {n: {"type": "Object"} for n in namen}}
                    de["@" + key] = meta
                    fehlend = [n for n in namen if "{%s}" % n not in e["en"]]
                    if fehlend:
                        sys.exit(f"{datei}: Platzhalter {fehlend} fehlen im Englischen: {e['en']}")
                vorhanden[text] = key
            ausdruck = f"t.{key}" + (f"({', '.join(ausdruecke)})" if namen else "")
            ersetzungen.append((s, ende, ausdruck))
        for s, ende, ausdruck in sorted(ersetzungen, reverse=True):
            src = src[:s] + ausdruck + src[ende:]
        imp = f"import '{import_pfad(datei)}';"
        if imp not in src:
            letzte = [m.end() for m in re.finditer(r"^import .*;$", src, re.M)]
            pos = letzte[-1] if letzte else 0
            src = src[:pos] + "\n" + imp + src[pos:]
        pfad.write_text(src, encoding="utf-8")
        print(f"{datei}: {len(ersetzungen)} Texte")
    arb_schreiben(ARB_DE, de)
    arb_schreiben(ARB_EN, en)
    subprocess.run([r"C:\TOOLS\flutter\bin\flutter.bat", "gen-l10n"], cwd=ROOT, capture_output=True)
    const_entfernen(list(je_datei))


CONST_FEHLER = ("CONST", "INVALID_CONSTANT", "NON_CONSTANT")


def const_entfernen(dateien, runden=30):
    """Entfernt so lange das nächstliegende „const“ vor einem Fehler, bis der Analyzer zufrieden ist."""
    for _ in range(runden):
        res = subprocess.run([DART, "analyze", "--format=machine", *dateien], cwd=ROOT,
                             capture_output=True, text=True, encoding="utf-8")
        fehler = []
        for zeile in res.stderr.splitlines() + res.stdout.splitlines():
            teile = zeile.split("|")
            if len(teile) >= 8 and teile[0] == "ERROR" and any(c in teile[2] for c in CONST_FEHLER):
                fehler.append((teile[3], int(teile[4]), int(teile[5])))
        if not fehler:
            return
        erledigt = set()
        for datei, zeile, spalte in sorted(fehler, key=lambda f: (f[0], -f[1], -f[2])):
            if datei in erledigt:
                continue
            pfad = Path(datei)
            src = pfad.read_text(encoding="utf-8")
            pos = sum(len(z) + 1 for z in src.split("\n")[:zeile - 1]) + spalte - 1
            k = src.rfind("const ", 0, pos + 1)
            if k < 0:
                continue
            src = src[:k] + src[k + 6:]
            pfad.write_text(src, encoding="utf-8")
            erledigt.add(datei)
    print("Achtung: const-Fehler nach", runden, "Runden nicht vollständig behoben")


def fuellen(kandidaten_datei, uebersetzung_datei):
    """Trägt Übersetzungen aus {"deutsch": "english"} in die Kandidatenliste ein (nicht Aufgeführtes bleibt leer)."""
    ueb = json.loads(Path(uebersetzung_datei).read_text(encoding="utf-8-sig"))
    zeilen = [json.loads(z) for z in Path(kandidaten_datei).read_text(encoding="utf-8-sig").splitlines() if z.strip()]
    fehlt = set(ueb) - {z["de"] for z in zeilen}
    if fehlt:
        sys.exit(f"Nicht unter den Kandidaten: {sorted(fehlt)[:5]}")
    for z in zeilen:
        z["en"] = ueb.get(z["de"], "")
    Path(kandidaten_datei).write_text("\n".join(json.dumps(z, ensure_ascii=False) for z in zeilen) + "\n",
                                      encoding="utf-8")
    print(f"{sum(1 for z in zeilen if z['en'])} von {len(zeilen)} übersetzt")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    if sys.argv[1] == "kandidaten":
        kandidaten(sys.argv[2:])
    elif sys.argv[1] == "fuellen":
        fuellen(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "anwenden":
        anwenden(sys.argv[2])
