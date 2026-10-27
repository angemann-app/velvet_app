# Arbeitsaufträge für Antigravity

Diese Datei steuert Antigravity. Der Nutzer sagt nur: **„Hol ab und bearbeite.“** Dann gilt der Ablauf
unten.

## Wer macht was

| Wer | Aufgabe |
|---|---|
| **Nutzer** | entscheidet, hört an, liest gegen, gibt Releases frei |
| **Claude Code** | Konzepte, Code, Aufgabenliste `docs/AUFGABEN.md`; schreibt Aufträge in diese Datei; prüft die Pull Requests von Antigravity vor dem Zusammenführen; führt alle Pull Requests zusammen (bei Aufnahmen und Texten erst nach dem OK des Nutzers); pflegt „Gesperrt“ und „Erledigt“; baut und veröffentlicht Releases nach Freigabe |
| **Antigravity** | arbeitet die Aufträge in dieser Datei ab, jeder in eigenem Branch und eigenem Pull Request |

`docs/AUFGABEN.md` ist die Prioritätenliste des Projekts. Was davon an Antigravity geht, steht hier als
Auftrag (AG-n) und dort mit Verweis „→ AG-n“.

## Ablauf bei „Hol ab und bearbeite“

**Arbeitsordner:** Antigravity arbeitet immer im eigenen Klon `C:\TOOLS\workspace\mojo-ag`, nie in
`C:\TOOLS\workspace\mojo` (dort arbeitet Claude Code; ein gemeinsamer Ordner hat nur einen aktuellen Branch, und
Branch-Wechsel würden die andere Arbeit stören).

1. `git checkout main` und `git pull`. Gibt es lokale, nicht gesicherte Änderungen: anhalten und den Nutzer
   fragen, nichts verwerfen.
2. `CLAUDE.md` lesen. Die Regeln dort gelten auch für Antigravity (Sprache Deutsch, feste Regeln, Diskretion,
   Übersetzungen mitpflegen).
3. Den **ersten offenen Auftrag** nehmen (Reihenfolge = Priorität). Daueraufträge („laufend“) kommen dran,
   wenn sonst nichts offen ist oder sie ausdrücklich fällig sind.
4. Eigenen Branch anlegen, wie im Auftrag angegeben (sonst `ag/<auftrag-id>-<datum>`).
5. **Nur die im Auftrag genannten Dateien ändern.** Braucht es mehr, anhalten und fragen. Nie an Dateien
   arbeiten, die unter „Gesperrt“ stehen.
6. **Diese Datei (`AG.md`) im Auftrags-Branch nicht ändern.** Sonst kommen sich parallele Pull Requests in
   die Quere. „Erledigt“ trägt Claude nach dem Zusammenführen ein.
7. Prüfen, wie im Auftrag beschrieben (mindestens `flutter test`, wenn Code oder Inhalte betroffen sind).
8. Commit, Push, Pull Request gegen `main`. **Nicht selbst zusammenführen** (das macht Claude).
9. Die Beschreibung des Pull Requests nach der Vorlage unten schreiben. Kurz, keine Liste der Git-Befehle.

Wenn etwas unklar ist oder schiefgeht: anhalten und den Nutzer fragen statt raten. Lieber ein halber
Auftrag mit klarer Notiz als ein ganzer mit Vermutungen.

### Vorlage für die Beschreibung des Pull Requests

```
Auftrag: AG-n

### Erledigt
- (ein Punkt je Ergebnis)

### Für den Nutzer
- Anhören / Gegenlesen: (Datei, Stelle, worauf achten)

### Offen oder unsicher
- (Fragen, Vermutungen, was nicht ging; sonst „nichts“)

### Geprüft
- flutter test: grün / nicht nötig
```

### Nach dem Pull Request

Claude prüft ihn (Nutzer: „Prüf die AG-Pull-Requests“), schreibt das Ergebnis als Kommentar in den Pull
Request und bessert Kleinigkeiten auf Wunsch direkt im Branch nach. Danach hört bzw. liest der Nutzer; nach
seinem OK führt Claude zusammen, trägt den Auftrag unter „Erledigt“ ein und entfernt einmalige Aufträge.

## Gesperrt (hier arbeitet gerade Claude Code)

Jede Zeile mit Datum. Einträge, die älter als drei Tage sind, fragt Antigravity beim Nutzer nach, statt sie
stillschweigend zu übergehen.

(zurzeit nichts gesperrt)

## Offene Aufträge

### AG-4: Traum-Reise einsprechen (einmalig, heute zuerst)

**Branch:** `ag/4-traum-aufnahmen`
**Darf ändern:** neue Dateien unter `assets/audio/traum/` (Aufnahmen und `dauer.json`), nichts sonst.

1. Einsprechen, beide Stimmen (dauert eine Weile, im Hintergrund laufen lassen):
   `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py --traum`
   Das nimmt alle 39 Bausteine aus `assets/data/traum_reise.json` langsam wie die Einschlaf-Reise auf.
2. Stichprobe anhören bzw. mit `--zeige "<Wort>"` die Aussprache auffälliger Wörter prüfen (Vulva, Klitoris,
   Schamlippen, Eichel, Beckenboden, luzide). Falsches als Lexikon-Eintrag in `tools/aussprache.json` vorschlagen
   und nur im Pull Request nennen (nicht selbst ändern, der Auftrag erlaubt nur Audio).
3. Pull Request mit Anhörliste: je ein Traumbild sanft und spicy (Vulva und Penis) für beide Stimmen.

### AG-3: Texte für „Lust im Traum“ schreiben (einmalig, nach AG-4)

**Vorher lesen:** `docs/konzepte/lust-im-traum.md` (alle Abschnitte, besonders „Die Folgen“, „Traumkörper“,
„Gegenüber im Traum“, „Grenze für die Texte“, „Entscheidungen“), `docs/konzepte/traum-reise.md` („Sprache und
Stil“, „Selbstwahrnehmung im anderen Körper“) und `docs/konzepte/einschlaf-reise-textvorgabe.md` (verbindlicher
Stil). Format wie `tools/content/traum/sanft.json`.

**Ablage:** `C:\TOOLS\velvet-inhalte\lust\lust.json`, **nie ins Repository** (auch nicht als Entwurf, Issue
oder Pull Request), wie die Fantasie-Räume.

**Format:** JSON (UTF-8 ohne BOM) mit Listen `de` und `en`, Ids und Felder in beiden identisch, Absätze mit `\n`.
Felder: `id`, `phase` (`folge`), `folge` (1 bis 8), `koerper` (`vulva` | `penis`), `teil` (`v1` lang, `v2`
mittel, `v3` kurz, `f` Absicht als Kurzformel, `tag` Übung für den Tag), ab Folge 3 zusätzlich `gegenueber`
(`niemand` | `frau` | `mann` | `offen`) und eigene Bausteine `phase: "uebergang"` mit `koerper` = Zielkörper
(zwei Fassungen je Zielkörper) für den Körperwechsel.

**Umfang je Sprache:** jede Folge (1 bis 8) für Vulva und für Penis: `v1`, `v2`, `v3`, `f`, `tag`. Ab Folge 3
zusätzlich je Körper eine `v1`-Fassung für `frau`, `mann` und `offen` (die Standard-Fassungen gelten für
`niemand`). Die Texte für Begegnungen so schreiben, dass sie für gleich- und gegengeschlechtliche Begegnungen
gleichermaßen tragen. Frauen- und Männerfassungen unterscheiden sich wirklich (siehe Konzept: Frauen mehr ganzer
Körper, Brüste, wiederkehrende Wellen, mehrere Höhepunkte selbstverständlich; Männer Wärme und Fülle im Becken,
Leistung loslassen, in Folge 7 Höhepunkt ohne Samenerguss als Möglichkeit).

**Grenze:** Der Höhepunkt darf als Absicht und Erlaubnis vorkommen, wird aber nicht ausgemalt: keine Handlung,
keine Steigerung bis zum Höhepunkt, kein Dirty Talk, keine Geräusche. Keine Versprechen („du wirst …“), keine
pseudowissenschaftlichen Begründungen. Alle Figuren erwachsen, alles gewollt, keine echten oder benannten Personen.
Textvorgabe: keine Gedankenstriche, Anführungszeichen, Klammern, Ziffern; im Traumteil keine Aufforderungen.
Englisch gleiche Funktion und Länge (±15 %).

**Prüfen:** `python -c "import json;d=json.load(open(r'C:\TOOLS\velvet-inhalte\lust\lust.json',encoding='utf-8'));print(len(d['de']),len(d['en']))"`
und Ids in `de` und `en` gleich.

**Abschluss:** kein Pull Request. Dem Nutzer melden: Datei fertig, Anzahl der Bausteine, offene Fragen.

### AG-1: Aussprache korrigieren (beendet)

Seit 27.10.2026 erledigt das Claude Code mit OpenCode (Ablauf in `docs/AUSSPRACHE.md`). Antigravity holt
keine Aussprache-Meldungen mehr ab und legt keine `aussprache/`-Branches mehr an.

## Erledigt

- 26.10.2026, AG-1 Schritt A (`aussprache/2026-10-26`, PR #12): 16 Lexikon-Einträge, 8 Aufnahmen neu.
- 26.10.2026, AG-2 (`ag/2-traum-sanft`, PR #11): sanfte Texte der Traum-Reise, 39 Bausteine je Sprache;
  Fantasie-Räume (31 Bausteine) lokal unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json` zum Gegenlesen.
- 27.10.2026, AG-1 Schritt B (`aussprache/2026-10-27-nachsprechen`, PR #20): 96 übrige Aufnahmen
  mit den Wörtern aus Schritt A nachgesprochen (55 Lektionen, 41 geführte Bausteine).
