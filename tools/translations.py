"""Pflege der englischen Übersetzungen in translations/en/.

Regel: Jeder neue oder geänderte Inhalt wird auch ins Englische übersetzt.
test/translation_test.dart prüft das über Prüfsummen der deutschen Ausgangstexte.

  python tools/translations.py --skelett          englisches Grundgerüst anlegen bzw. um neue Einträge ergänzen
  python tools/translations.py --dump 1-7         deutsche Lektionen der Kurse 1–7 als Text ausgeben
  python tools/translations.py --einspielen DATEI übersetzte Kurse/Lektionen/Einträge aus einer JSON-Datei übernehmen

Danach die Prüfsummen eintragen:
  flutter test test/translation_test.dart --dart-define=STAMP=lesson:desire_1,course:course_desire_gap
"""
import argparse
import copy
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
DE = ROOT / "assets" / "data" / "velvet_content.json"
EN = ROOT / "translations" / "en" / "velvet_content.json"
LESSON_TEXT = ("title", "summary", "content", "reflection_question")


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def skeleton():
    """Gerüst mit der deutschen Struktur; fehlende Texte bleiben leer und fallen im Test auf."""
    de = load(DE)
    en = load(EN) if EN.exists() else {"_source": {}}
    old_courses = {c["id"]: c for c in en.get("courses", [])}
    courses = []
    for c in de["courses"]:
        old = old_courses.get(c["id"], {})
        old_lessons = {l["id"]: l for l in old.get("lessons", [])}
        course = {k: v for k, v in c.items() if k != "lessons"}
        course["title"] = old.get("title", "")
        course["subtitle"] = old.get("subtitle", "")
        course["lessons"] = []
        for l in c["lessons"]:
            lesson = copy.deepcopy(l)
            for field in LESSON_TEXT:
                lesson[field] = old_lessons.get(l["id"], {}).get(field, "")
            course["lessons"].append(lesson)
        courses.append(course)
    result = {
        "_hinweis": "Englische Fassung der Inhalte (nicht Teil des App-Releases). Struktur wie assets/data/velvet_content.json.",
        "version": de["version"],
        "courses": courses,
        "sos_cards": en.get("sos_cards", []),
        "belief_library": en.get("belief_library", []),
        "match_cards": en.get("match_cards", []),
        "_source": en.get("_source", {}),
    }
    save(EN, result)
    print(f"Gerüst: {len(courses)} Kurse")


def dump(first, last):
    de = load(DE)
    for c in de["courses"]:
        number = int(re.match(r"(\d+)\.", c["title"]).group(1))
        if first <= number <= last:
            print(f"### COURSE {c['id']} | {c['title']} | {c['subtitle']}")
            for l in c["lessons"]:
                print(f"--- LESSON {l['id']} | {l['title']}\nSUMMARY: {l['summary']}\nREFLECTION: {l['reflection_question']}\n{l['content']}\n")


def merge(path):
    """Datei: {"courses": {id: {"title","subtitle"}}, "lessons": {id: {title,summary,content,reflection_question}},
    "sos_cards": [...], "belief_library": [...], "match_cards": [...]} – alles optional."""
    data = load(pathlib.Path(path))
    en = load(EN)
    for c in en["courses"]:
        c.update(data.get("courses", {}).get(c["id"], {}))
        for l in c["lessons"]:
            l.update(data.get("lessons", {}).get(l["id"], {}))
    for key in ("sos_cards", "belief_library", "match_cards"):
        if key in data:
            en[key] = data[key]
    save(EN, en)
    print("übernommen:", len(data.get("courses", {})), "Kurse,", len(data.get("lessons", {})), "Lektionen")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    p = argparse.ArgumentParser()
    p.add_argument("--skelett", action="store_true")
    p.add_argument("--dump")
    p.add_argument("--einspielen")
    a = p.parse_args()
    if a.skelett:
        skeleton()
    if a.dump:
        first, _, last = a.dump.partition("-")
        dump(int(first), int(last or first))
    if a.einspielen:
        merge(a.einspielen)
