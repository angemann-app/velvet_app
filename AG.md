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

### AG-23: Alle restlichen sanft-spicy Stimmungsbilder im Bleistift-Stil (45 Motive, in Etappen, mit Warten bei Kapazitätslimit)

**Kein Branch, kein Pull Request, kein Commit.** Fortsetzung und Erweiterung von AG-22 (gleiche Ausnahme mit Einverständnis des Nutzers, 29.10.2026): Bilder nur in
`C:\TOOLS\velvet-inhalte\kurse\bilder\ag_spicy\` schreiben, **nie ins Repository** und nie in `assets/`. Erledigt sind dort schon `touch_m_s1`, `mass_s1`, `scen_1`;
**überspringe vorhandene Dateien**. Zuerst die offenen Motive aus AG-22 (`pos_s1`, `self_2`, `self_3`, `couples_1`), dann die Liste unten in dieser Reihenfolge.

**Wichtig, das Warten:** Ist die **Bildgenerierung gerade nicht verfügbar** (Kapazitätslimit, Fehler 429, „Resource Exhausted“ oder Ähnliches), **brich nicht ab und melde
nicht „fertig“.** Notiere es in `_liste.txt`, **warte** (die Wartezeit steht meist in der Fehlermeldung, sonst 30 Minuten) und **versuche dasselbe Motiv danach erneut**. Mach das so lange,
bis **alle** Motive entweder erzeugt oder wegen deines Inhaltsfilters bewusst übersprungen sind. Schreibe nach **jedem** Bild eine Zeile in `ag_spicy\_liste.txt` (Datei, Status
„erzeugt“, „Filter, übersprungen“ oder „wartet auf Kapazität“, Uhrzeit), damit bei einer Unterbrechung nichts verloren geht und du genau dort weitermachst. Meldung an den Nutzer erst
am Ende oder wenn du dauerhaft nicht weiterkommst.

**Stil (wie AG-21 und AG-22):** detailed pencil drawing, technical illustration style, natural adult bodies with soft shading, faint blueprint grid with thin dimension lines and thin arrows,
off-white paper, graphite with soft rose accents, **no text, no labels**, sensual and tender. **Sanft spicy:** intim, nackt oder angedeutet, **keine Nahaufnahme von Genitalien, keine
Darstellung der Vereinigung.** Erwachsene, keine Ähnlichkeit mit einer echten Person, natürliche Körper, **alle, die in der Szene vorkommen, ganz sichtbar**. Querformat 1024 × 576, WebP,
höchstens 150 KB, Dateiname `<Lektions-ID>_spicy.webp`. **Bricht dein Inhaltsfilter ab: nicht umgehen, nicht entschärfen**, vermerken und weitermachen.

**Teil A, Spicy-Lektionen (zuerst):**
`touch_w_s1` a woman lying on her side, her partner's hand resting on her shoulder, tender (Ersatz für das abgelehnte Motiv) | `pos_s1` a nude couple in a deep embrace on a bed, side view, no close-up |
`fant_s1` a man gently holding a woman's chin, she looks up devotedly | `scen_s1` a woman with silk scarves lightly draped around her wrists, a man leaning over her |
`prost_s1` a man lying relaxed on his stomach, a woman beside him with her hand on his lower back | `vocal_s1` a couple embracing in backlight, her head thrown back |
`alltag_6` a smartphone on a silk sheet showing a glowing message, a woman's bare hand beside it | `alltag_7` a man and a woman pressed against a wall in half shadow, passionate, clothed or nude |
`alltag_8` a restaurant table, a woman's hand and a man's hand touching under the table | `alltag_10` a woman in elegant lace lingerie, torso crop |
`toys_7` a woman lying in bed, a softly glowing smooth toy beside her hand | `toys_8` a man and a woman in bed together holding a smooth toy, laughing |
`spsolo_1` a man sitting on the edge of a bed, tension in his body | `spsolo_2` a woman sitting on a bed holding a smooth toy, curious |
`spsolo_3` a woman lying with closed eyes, her imagination as soft mist above her head | `spsolo_4` a man lying back with his mouth open in pleasure, a sheet at his hips |
`spsolo_5` a woman on a bed in unusual light with silk and candles | `spduo_1` a man whispering into a woman's ear, she smiles |
`spduo_2` a man kissing the inside of a woman's thigh, she lies back with a blissful face, sheet covering | `spduo_3` a woman with her hand flat on a man's chest holding him back playfully |
`spduo_4` a woman with a blindfold and a soft silk tie lightly around her wrists, a man kissing her neck | `spduo_5` a man and a woman in bed laughing with a smooth toy between them |
`spduo_6` a man and a woman, she guides his hand to her hip, leading and following.

**Teil B, normale Lektionen mit zweiter Bildfassung (danach):**
`anat_1` a nude woman standing in profile | `anat_4` a man and a woman, his hand resting on her lower back from behind | `beauty_6` lace and silk lingerie on a woman's collarbone, face out of frame |
`pelvic_3` a woman lying on her back, knees relaxed and open, a pillow under her hips | `female_3` an opening orchid in warm light, still life without a person |
`prost_2` a man lying on his side, a woman behind him with her hand on his hip | `tease_1` a man and a woman face to face, lips almost touching | `couples_1` a couple embracing, foreheads touching |
`couples_2` a couple belly to belly, foreheads touching, at rest | `touch_w_2` a woman's bare back with a man's fingertips gently circling her skin |
`touch_m_1` a man lying on his front, a woman's flat hands on his back | `touch_m_2` a man lying on his back, a woman's hand sliding across his chest |
`mass_1` a nude woman lying on silk, a man kneeling beside her | `mass_2` a man's hand pouring warm oil on a woman's bare back | `mass_3` a woman lying on her stomach, a man stroking her lower back |
`vocal_1` a woman's slightly open lips and bare throat as she breathes out | `pos_1` a man and a woman in a deep embrace, she wrapped around him |
`pos_2` a couple in spoon position on white sheets | `pos_3` a woman with her hips raised on a wedge pillow, a man kneeling in front of her | `toys_2` an elegant ensemble of modern toys on a silk cloth, still life.

**Nicht tun:** Bilder ins Repository oder in `assets/` legen, Lektionstexte lesen, die Bilder weitergeben, einen Filter umgehen.

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
