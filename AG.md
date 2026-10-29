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

- 27.10.2026: `C:\TOOLS\velvet-inhalte\` (private Inhalte, nie anfassen)

## Offene Aufträge

### AG-22: Probe „sanfte Spicy-Version“ der Bleistift-Studien (acht Bilder, nur Bildsammlung)

**Kein Branch, kein Pull Request, kein Commit.** Ausnahme von der Regel „Spicy-Motive nicht an Cloud-Modelle“ und von der Sperre oben, mit
**ausdrücklichem Einverständnis des Nutzers (29.10.2026)**, als **Probe**: Du darfst die Bilder dieses Auftrags erzeugen und in den Ordner
`C:\TOOLS\velvet-inhalte\kurse\bilder\ag_spicy\` schreiben (neuer Ordner, **außerhalb des Repositorys**, nie ins Repository kopieren). Sonst nichts
in `velvet-inhalte` anfassen, keine Lektionstexte lesen (nur die Motivzeilen unten).

**Ziel:** Dieselbe Bildart wie AG-21 (Bleistift, technische Studie, blasses Raster mit Maßlinien, dünne Pfeile, off-white Papier, Graphit mit Rosé-Akzenten,
**kein Text im Bild**), aber **sanft spicy**: intim, sinnlich, zärtlich, nackt, ruhig und künstlerisch, **keine Nahaufnahme von Genitalien**, keine
Darstellung eines Aktes der Vereinigung. Erwachsene, keine Ähnlichkeit mit einer echten Person, natürliche Körper. Querformat, etwa 1024 × 576,
WebP, höchstens 150 KB. Dateiname `<Lektions-ID>_spicy.webp`. **Bricht dein Filter bei einem Motiv ab: nicht umgehen, nicht entschärfen**, in
`ag_spicy\_liste.txt` mit „Filter, übersprungen“ vermerken und weitermachen.

**Stil-Prompt (Grundlage):** „detailed pencil drawing, technical illustration style, natural adult bodies with soft shading on skin and muscle, faint
blueprint grid in the background with scale markers and thin dimension lines, thin non-obstructive arrows, off-white paper, graphite with soft rose accents,
no text, no labels, sensual and tender, <Motiv>“.

**Die acht Motive** (alle in beiden Fassungen zeigen alle, die in der Szene vorkommen):
1. `touch_w_s1`: eine nackte Frau liegt auf dem Rücken, die Hand ihres Partners ruht sanft auf ihrer Hüfte, er liegt nackt neben ihr, beide ganz sichtbar.
2. `touch_m_s1`: ein nackter Mann liegt auf dem Rücken, die Hand seiner nackten Partnerin gleitet über seine Brust und seinen Bauch, beide ganz sichtbar.
3. `mass_s1`: ein nacktes Paar liegt eng umschlungen auf einem Massagetuch, Stirn an Stirn, beide ganz sichtbar.
4. `pos_s1`: ein nacktes Paar liegt im Löffelchen, sein Arm um sie, seine Hand auf ihrem Bauch, seitliche Ansicht.
5. `scen_1`: eine nackte Frau mit Augenbinde liegt auf dem Rücken, die Fingerspitzen ihres nackten Partners ruhen auf ihrem Schlüsselbein, beide ganz sichtbar.
6. `self_2`: eine nackte erwachsene Frau liegt entspannt auf dem Bett und berührt sich sanft an Brust und Bauch, Augen geschlossen, ganze Gestalt.
7. `self_3`: ein nackter erwachsener Mann liegt entspannt auf dem Bett, eine Hand auf der Brust, eine auf dem Bauch, Augen geschlossen, ganze Gestalt.
8. `couples_1`: ein nacktes Paar steht eng umarmt, Stirn an Stirn, Rückenansicht oder seitliche Ansicht, beide ganz sichtbar.

**Liste** `ag_spicy\_liste.txt`: je Motiv eine Zeile (Datei, Filter-Status, eine kurze Bemerkung). **Meldung an den Nutzer**, sobald die Bilder liegen.
**Nicht tun:** Bilder ins Repository oder in `assets/` legen, Texte der Lektionen lesen, die Bilder weitergeben.

### AG-3: Texte für „Lust im Traum“ (an Claude Code abgegeben)

Der Inhaltsfilter von Antigravity bricht diese Texte ab. Claude Code schreibt sie (lokal unter
`C:\TOOLS\velvet-inhalte\lust\lust.json`); das Einsprechen kommt danach als eigener Auftrag.

### AG-1: Aussprache korrigieren (beendet)

Seit 27.10.2026 erledigt das Claude Code mit OpenCode (Ablauf in `docs/AUSSPRACHE.md`). Antigravity holt
keine Aussprache-Meldungen mehr ab und legt keine `aussprache/`-Branches mehr an.

## Erledigt

- 26.10.2026, AG-1 Schritt A (`aussprache/2026-10-26`, PR #12): 16 Lexikon-Einträge, 8 Aufnahmen neu.
- 26.10.2026, AG-2 (`ag/2-traum-sanft`, PR #11): sanfte Texte der Traum-Reise, 39 Bausteine je Sprache;
  Fantasie-Räume (31 Bausteine) lokal unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json` zum Gegenlesen.
- 27.10.2026, AG-1 Schritt B (`aussprache/2026-10-27-nachsprechen`, PR #20): 96 übrige Aufnahmen
  mit den Wörtern aus Schritt A nachgesprochen (55 Lektionen, 41 geführte Bausteine).
- 27.10.2026, AG-4 (`ag/4-traum-aufnahmen`, PR #27): Traum-Reise eingesprochen, 39 Bausteine für beide
  Stimmen (78 Aufnahmen) samt `dauer.json`.
- 27.10.2026, AG-5 bis AG-7 (PR #38, #40, #41, zusammen über #42): Wochenrückblick, Realitätschecks,
  nächtliches Wecken samt Texten und Aufnahmen. Claude ergänzte die SET_ALARM-Berechtigung.
- 28.10.2026, AG-8 (`ag/8-lautsprecher`, PR #50): Nachfrage vor Lautsprecher-Wiedergabe, Pause beim Abziehen der
  Kopfhörer, zwei Schalter in Profil und Sicherung, Realitätschecks sichtbarer (Traum-Abend, Tagebuch).
- 28.10.2026, AG-9 (`ag/9-hallo`, PR #52): freiwilliges Hallo (einmalig), nur Version und Sprache, samt Sicherung,
  Abholwerkzeug und Tests.
- 28.10.2026, AG-12 (`ag/12-bildbedarf`, PR #55): Bildbedarf der Kurse sondiert, `docs/kursbilder-bedarf.md`.
- 28.10.2026, AG-13 (kein Branch): Hörprüfung von vier Aufnahmen der Reihe, Bericht `C:\TOOLS\velvet-inhalte\reihe\pruefung_ag.md`.
- 29.10.2026, AG-11 (`ag/11-kursbilder-probe`, PR #56): Probe Toys, vier Motive als SVG (Deutsch und Englisch) und Bildmodell-Rasterbild, `docs/kursbilder-probe/`. Textumbrüche mitten im Wort in `toys_material`, siehe AG-19.
- 29.10.2026, AG-17 (kein Branch): Hörprüfung vier englische Aufnahmen, Bericht `C:\TOOLS\velvet-inhalte\reihe\pruefung_ag_en.md`; Lexikon-Vorschlag „vertebrae“ kommt auf die Mittwochsliste.
- 29.10.2026, AG-14 bis AG-16, AG-18, AG-19, AG-20 (`ag/14-…`, `ag/15-…`, `ag/16-…`, `ag/18-…`, `ag/19-…`): 23 Erklär-Diagramme (SVG, Deutsch und Englisch), nach Korrektur der Textüberläufe zusammengeführt und in den Lektionen eingebunden (Toys, Anatomie, Beckenboden, Positionen, Squirting, Gebärmutterhals).
- 29.10.2026, AG-21 (`ag/21-koerperzeichnungen`): acht Körperzeichnungen im Bleistift-Stil (WebP, jetzt Basis in `tools/zeichnungen/`); Claude Code hat Beschriftungen und Zielpunkte selbst gesetzt und als SVG (Deutsch und Englisch) eingebunden, die Koordinatenvorschläge von AG passten nicht zu den Bildern.
