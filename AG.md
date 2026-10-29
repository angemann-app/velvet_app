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

### AG-19: Toys-Diagramme für die Produktion (aus der Probe AG-11)

**Branch:** `ag/19-toys-diagramme`
**Vorher lesen:** `docs/kursbilder-probe/README.md` und die vier SVG-Paare dort (deine eigene Probe), die Regeln von AG-14 bis AG-16.
**Darf ändern:** nur neue Dateien `assets/images/diagram_toys_2.svg` und `_en.svg` (aus `toys_uebersicht`), `diagram_toys_3.svg` und `_en.svg`
(aus `toys_material`), `diagram_toys_4.svg` und `_en.svg` (aus `toys_sicherheit`) und `docs/kursbilder-liste-ag19.md`. Die Probedateien nicht ändern.

Übernimm die Motive der Probe, auch die Trennung der Toy-Arten **für Frauen und für Männer** in `toys_2` (so wie vom Nutzer gewünscht),
und behebe diesen **Fehler aus der Probe**: In `toys_material.svg` und `_en.svg` bricht der Text in den Pflegehinweisen **mitten im
Wort** um („Silikongel z / erstört“, „un / d“, „Elektr / onik“). Setze Zeilenumbrüche nur **zwischen Wörtern**, plane breitere Kästen oder
kürzere Zeilen ein und prüfe jedes Wort am rechten Rand. Prüfe außerdem alle sechs Dateien, ob Text über den Kastenrand ragt.
Die Form wie bei AG-14 bis AG-16 (`viewBox 0 0 800 600`, Palette, Schrift mindestens 16, höchstens 20 KB, Deutsch und Englisch). Der Titel
`toys_titel` ist kein Lektionsbild und bleibt ein Vorschlag; ihn übernimmt der Nutzer später.
**Prüfen:** SVGs im Browser öffnen, jedes Wort am Rand lesen. Im Pull Request: nur zur Einbindung durch Claude Code.
**Nicht tun:** Körperdarstellungen, Bildmodell-Rasterbilder für die Produktion.

### AG-18: Vier Anatomie- und Ablauf-Schemata für die neuen Lektionen Squirting und Gebärmutterhals (SVG)

**Branch:** `ag/18-schemata-squirting-zervix`
**Vorher lesen:** `docs/recherche/squirting.md` und `docs/recherche/gebaermutterhals.md` (nur für Beschriftung und Fachlichkeit),
`assets/images/diagram_selbst_vulva.svg` und `_en.svg` (so zurückhaltend und schematisch soll Anatomie aussehen), die Regeln der
Aufträge AG-14 bis AG-16 (Form, Palette, Größe). Aus `assets/data/velvet_content.json` darfst du **nur** die Lektionen `female_5` und
`female_6` lesen. **Die Lektionen `touch_w_s2` und `touch_w_s3` (Spicy) nicht lesen und nicht bearbeiten;** ihre Motive stehen unten.
**Darf ändern:** nur diese acht neuen Dateien in `assets/images/`: `diagram_female_5.svg`, `diagram_female_6.svg`,
`diagram_touch_w_s2.svg`, `diagram_touch_w_s3.svg` und jeweils `_en.svg`. Nichts anderes.

Form wie bei AG-14 bis AG-16: `viewBox="0 0 800 600"`, Hintergrund `#140D1C`, Akzent `#FB7185`, Text `#F1F5F9`, `sans-serif`, Schrift
mindestens 16, nichts abgeschnitten, höchstens 20 KB, `<title>` und `<desc>` (Deutsch bzw. Englisch), keine Skripte oder Bilder. Rein
schematisch, **keine Körper, keine Personen**; Anatomie als stilisierter Seitenschnitt mit Linien und Beschriftung. Auf jedem Bild
steht klein: „schematisch, Lage und Größe sind individuell“ (englisch: „schematic, position and size vary“).

1. `female_5` (Kurs 9, Squirting, Wissen): Seitenansicht (Schnitt) mit Harnblase, Harnröhre, Vorderwand der Vagina, paraurethralen
   (Skene-)Drüsen neben dem unteren Ende der Harnröhre und der inneren Struktur der Klitoris (Eichel außen, Schenkel und
   Schwellkörper innen). Dazu ein kleiner Kasten: „Vorderwand und Klitoris hängen zusammen; ob es einen eigenen ‚G-Punkt‘ gibt, ist
   umstritten.“ Keine Pfeile, die einen „Punkt“ versprechen.
2. `female_6` (Kurs 9, Gebärmutterhals, Wissen): Seitenansicht mit Gebärmutter, Gebärmutterhals, Muttermund, Scheide (Tiefe etwa 7 bis
   10 cm als Maß) und Harnblase. Zwei kleine Nebenbilder oder Pfeile: „bei Erregung hebt sich die Gebärmutter, die Scheide verlängert
   sich“ und „Lage und Neigung sind verschieden (zum Beispiel nach hinten gekippt)“. Hinweis: „Beim Sex dringt nichts in die
   Gebärmutter ein, man drückt gegen den Gebärmutterhals.“
3. `touch_w_s2` (Ablaufbild „Entspannen statt Pressen“, Beschriftung ohne Anatomie): Fünf Stationen von links nach rechts: Zeit
   nehmen, außen erregen, Druck an der Vorderwand, Harndrang erkennen, entscheiden (laufen lassen mit Unterlage oder pausieren).
   Darunter ein roter Balken: „Schmerz, Brennen oder Unbehagen heißen Stopp.“ Kein Erfolgsversprechen, kein „Ziel“.
4. `touch_w_s3` (Ablaufbild „Tiefe und Stopp“, Beschriftung ohne Anatomie): Eine Treppe oder Ampel in vier Stufen: Erregung zuerst,
   flach beginnen, Tiefe nur auf ein deutliches „mehr“, Schmerz oder Druck mit Unwohlsein heißt sofort Stopp. Die Person mit
   Gebärmutterhals bestimmt Tiefe und Tempo (als Satz am unteren Rand).

**Liste:** `docs/kursbilder-liste-ag18.md` mit einer Zeile je Lektion (ID, Dateien, Beschriftung deutsch und englisch, Anmerkung).
**Prüfen:** SVGs im Browser öffnen (Text lesbar), je Lektion zwei Dateien, Liste vollständig; `flutter test` nicht nötig. Im Pull
Request: Hinweis, dass die Bilder noch nicht eingebunden sind. **Filter:** Bricht dein Inhaltsfilter ab, nicht umgehen, in der
Liste vermerken und weitermachen. **Nicht tun:** Körperdarstellungen, Spicy-Inhalte, Texte der Lektionen ändern.

### AG-14, AG-15, AG-16: Erklär-Diagramme der Kurse als SVG (Deutsch und Englisch), in drei Stufen

Gemeinsam für alle drei Aufträge. **Zuerst AG-11 abarbeiten** (Probe „Toys“): Stil und Maße dort festlegen, dann hier in
derselben Art weiterarbeiten. Ergibt AG-11, dass du kein brauchbares SVG zeichnen kannst, halte an und frage den Nutzer.

**Vorher lesen:** `docs/konzepte/kursbilder.md` (Abschnitte 3 bis 5), `docs/kursbilder-bedarf.md` (die Tabelle je Lektion und die
Zusammenfassung am Ende), `tools/generate_diagrams.py`, `assets/images/diagram_yoni_clock.svg` und `_en.svg` als Stilvorbild.
**Welche Lektionen:** Zeilen der Tabelle mit „Bild hilft“ = **ja** und mit „optional“, deren Art **Diagramm** oder **Ablauf** ist
(zusammen 39). Reihenfolge und Zuordnung zu den Aufträgen unten. Die drei „optional“-Zeilen der Art **Stimmungsbild** und alle
Titelbilder macht der Nutzer lokal, nicht du. Die neun Lektionen mit Status „vorhanden“ bleiben unberührt.
**Lektionen aus den Kursen 26 und 27 (Spicy) nicht anfassen, nicht lesen.**

**Dateien je Lektion** (nur neu anlegen, nichts ändern): `assets/images/diagram_<Lektions-ID>.svg` und
`assets/images/diagram_<Lektions-ID>_en.svg` (zum Beispiel `diagram_neuro_1.svg`, `diagram_neuro_1_en.svg`).
Beide Dateien haben dieselbe Zeichnung, nur die Beschriftung unterscheidet sich.
**Form:** `viewBox="0 0 800 600"`, Hintergrund `#140D1C` oder `#0F172A`, Akzent `#FB7185`, Text hell (`#F1F5F9`), Schrift
`font-family="sans-serif"` (keine Webfonts), Schriftgröße mindestens 16 (bezogen auf 800 Pixel Breite), Text nicht abgeschnitten
und nicht über Linien. Jede Datei höchstens 20 KB, ohne Skripte, ohne eingebettete Bilder, mit `<title>` und `<desc>`
(Deutsch bzw. Englisch). **Inhalt:** schematisch und neutral (Pfeile, Kurven, Skalen, Waagen, Schnitte, Stufen), keine
fotorealistischen Körper, keine Marken, keine Personen. Anatomische Schemata so zurückhaltend wie
`assets/images/diagram_selbst_vulva.svg`.
**Liste:** je Auftrag eine Datei `docs/kursbilder-liste-<Auftrag>.md` (zum Beispiel `docs/kursbilder-liste-ag14.md`) mit einer
Zeile je Lektion: Lektions-ID, Dateien, Beschriftung deutsch, Beschriftung englisch, Anmerkung.
**Darf ändern:** nur die neuen SVG-Dateien und die Listendatei des Auftrags. Nichts in `lib/`, `assets/data/`, `translations/`,
`pubspec.yaml`. Die Einbindung in die Lektionen macht Claude Code danach.
**Prüfen:** SVGs im Browser öffnen (Text lesbar, nichts abgeschnitten); je Lektion zwei Dateien; Liste vollständig.
`flutter test` nicht nötig. Im Pull Request: Hinweis, dass die Bilder noch nicht eingebunden sind.
**Filter:** Bricht dein Inhaltsfilter bei einer Lektion ab, **nicht umgehen**, die Lektion in der Liste vermerken
(„Filter, übersprungen“) und weitermachen.
**Nicht tun:** Spicy-Inhalte, Körperfotos oder körpernahe Illustrationen, Texte der Lektionen ändern, Bilder für
andere Lektionen erzeugen, die nicht in der Tabelle stehen.
**Schon vergeben, nicht zeichnen** (macht OpenCode, einfache Schemata ohne Anatomie): `neuro_1`, `neuro_2`, `spec_1`,
`pain_1`, `pain_3`, `pelvic_2`, `dopa_1`, `desire_1`, `desire_2`, `desire_3`, `tease_1`, `couples_1`, `couples_2`,
`couples_3`, `touch_w_4`, `touch_m_5`, `fant_3`, `toys_5`, `toys_7`, `anat_5`. **Für AG bleiben die anatomischen und
körpernahen Schemata:** `anat_1`, `anat_4`, `pain_2`, `pelvic_1`, `pelvic_3`, `female_1`, `female_3`, `female_4`, `prost_1`,
`prost_2`, `prost_3`, `phase_2`, `touch_m_1`, `vocal_1`, `pos_2`, `pos_3`. Gibt es eine Datei `assets/images/diagram_<ID>.svg`
schon, überspringe die Lektion.

**AG-14, Stufe 1 (hohe Priorität: Grundmodelle und Anatomie).** Branch `ag/14-diagramme-stufe1`. Lektionen: Kurs 1
(`neuro_1`, `neuro_2`), Kurs 9 (`female_3`, `female_4`), Kurs 11 (`prost_1`, `prost_2`), Kurs 2 (`anat_5`); dazu die übrigen
Zeilen dieser Kurse, die in der Tabelle „ja“ sind.

**AG-15, Stufe 2 (hohe Priorität: Körpermechanik und Entlastung).** Branch `ag/15-diagramme-stufe2`. Lektionen: Kurs 7
(`pelvic_1`, `pelvic_2`, `pelvic_3`), Kurs 5 (`pain_1`, `pain_2`, `pain_3`), Kurs 10 (`dopa_1`); dazu die übrigen
„ja“-Zeilen dieser Kurse.

**AG-16, Stufe 3 (mittlere Priorität: Paardynamik, Haltung und Technik).** Branch `ag/16-diagramme-stufe3`. Alle übrigen
Zeilen mit „ja“ oder „optional“ (Art Diagramm oder Ablauf), die in Stufe 1 und 2 nicht vorkommen, in der Reihenfolge der
Prioritätsspalte der Tabelle, darunter Kurs 17 (`couples_1`), Kurs 22 (`pos_3`), Kurs 19, Kurs 13, Kurs 21 und Kurs 4.
Die Toys-Lektionen (`toys_2`, `toys_3`, `toys_4`) gehören zu AG-11 und werden hier nicht noch einmal gemacht.

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
