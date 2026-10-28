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

- 28.10.2026, AG-9 (`ag/9-hallo`, PR #52): freiwilliges Hallo (einmalig), nur Version und Sprache, samt Sicherung, Abholwerkzeug und Tests.
- 28.10.2026, AG-8 (`ag/8-lautsprecher`, PR #50): Nachfrage vor Lautsprecher-Wiedergabe, Pause beim Abziehen der
  Kopfhörer, zwei Schalter in Profil und Sicherung, Realitätschecks sichtbarer (Traum-Abend, Tagebuch).
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

### AG-12: Bildbedarf der Kurse sondieren (nur Analyse)

**Branch:** `ag/12-bildbedarf`
**Vorher lesen:** `docs/konzepte/kursbilder.md` (alles), `assets/data/velvet_content.json` (nur die Kurse 1 bis 25;
die Spicy-Kurse 26 und 27 **nicht lesen und nicht bearbeiten**), die vorhandenen Bilder in `assets/images/`.
**Darf ändern:** nur eine neue Datei `docs/kursbilder-bedarf.md`. Keine Bilder erzeugen, nichts in `assets/`, `lib/`,
`translations/`.

Ziel: herausfinden, **wo ein Bild mehr erklärt als Text**, damit wir die Kursbilder gezielt planen.

1. Gehe jede Lektion der Kurse 1 bis 25 durch (124 Lektionen). Die 9 Lektionen, die schon ein Diagramm haben, nur
   als „vorhanden“ aufführen.
2. `docs/kursbilder-bedarf.md`: eine Tabelle mit einer Zeile je Lektion: Kurs, Lektions-ID, Titel, **Bild hilft**
   (ja, optional, nein), **Art** (Diagramm, Stimmungsbild, Ablauf), **Motiv in einem Satz** (neutral, ohne Körper),
   **Beschriftung nötig** (ja/nein, denn dann DE und EN), **Priorität** (hoch, mittel, niedrig), Bemerkung.
   Maßstab: nur dort „ja“, wo ein Bild etwas erklärt (Anatomie, Ablauf, Haltung, Material, Atem). Höchstens etwa
   40 % der Lektionen „ja“ oder „optional“.
3. Am Ende: Zusammenfassung mit Anzahl je Art, den zehn wichtigsten Bildern und einem Vorschlag für die
   Reihenfolge (Pilotkurs ist Kurs 25 „Toys“).
4. Bricht dein Inhaltsfilter bei einer Lektion ab: **nicht umgehen**, die Lektion in der Datei vermerken
   („Filter, übersprungen“) und weitermachen.

**Nicht tun:** Bilder erzeugen, Texte ändern, Spicy-Kurse anfassen, Körperbilder vorschlagen.

**Prüfen:** nur Markdown; jede der 124 Lektionen (minus die der Kurse 26 und 27) hat genau eine Zeile.
`flutter test` nicht nötig, es ändert sich kein App-Code.

### AG-11: Probe Kursbilder, Pilotkurs „Toys“ (Normalfassung)

**Branch:** `ag/11-kursbilder-probe`
**Vorher lesen:** `docs/konzepte/kursbilder.md` (alles, besonders Abschnitte 4, 5 und 7), `tools/generate_diagrams.py`,
`assets/images/diagram_yoni_clock.svg` und `assets/images/cover_27.svg` als Stilvorbild, Kurs 25 „Toys“ in
`assets/data/velvet_content.json` (Lektionen `toys_2`, `toys_3`, `toys_4`).
**Darf ändern:** nur neue Dateien in `docs/kursbilder-probe/` (kein Bild geht in die App, kein anderer Ordner).
Nichts in `assets/`, `lib/`, `translations/`.

Das ist ein **Probeauftrag**. Er soll klären, ob und wie gut Antigravity Grafiken für die Kurse erzeugen kann.

1. **Zuerst melden:** Kannst du Bilder mit einem Bildmodell erzeugen, oder nur SVG als Code schreiben? Schreibe es
   in die erste Zeile von `docs/kursbilder-probe/README.md`. Verweigert dein Inhaltsfilter ein Motiv: **abbrechen,
   nicht umgehen, nicht entschärfen**, das Ergebnis in der README festhalten und die übrigen Motive weiterführen.
2. **Vier Motive** (neutral, ohne Körper, ohne Marken; ruhiger Stil wie die vorhandenen Diagramme, dunkle Töne
   `#140D1C`/`#0F172A`, Akzent `#FB7185`):
   a. `toys_uebersicht`: stilisierte, neutrale Silhouetten der Toy-Arten (Vibratoren, Massagestab, Ringe, Kugeln,
      Gleitmittel) als Überblick, ohne Körper.
   b. `toys_material`: Vergleich der Materialien (Silikon, Glas, Metall, ABS) mit je einem Pflegehinweis.
   c. `toys_sicherheit`: Ampel- oder Merkbild „Wo es heikel wird“ (Hygiene, passendes Gleitmittel, Stopp-Signal).
   d. `toys_titel`: Titelbild für Kurs 25 in Stimmung der anderen Titelbilder (840 × 300).
3. **Jedes Motiv als SVG** (a bis c im Format 800 × 600, d 840 × 300), **Deutsch und Englisch**
   (`<name>.svg`, `<name>_en.svg`). Wenn du ein Bildmodell hast: zusätzlich je Motiv ein Rasterbild
   (`<name>_modell.webp`, höchstens 150 KB) zum Vergleich.
4. `docs/kursbilder-probe/README.md`: erste Zeile Fähigkeit (siehe 1), dann eine kurze Tabelle: Motiv, SVG ja/nein,
   Modellbild ja/nein, Dateigröße, was nicht klappte (Filter, Stil, Lesbarkeit, Beschriftung).

**Nicht tun:** Spicy- oder körperbezogene Motive, Bilder von Personen, Marken, Produktfotos. Nichts an Claude oder
andere Sitzungen weitergeben, was nicht in der README steht.

**Prüfen:** SVGs öffnen sich im Browser, Text ist lesbar und nicht abgeschnitten. `flutter test` nicht nötig, es
ändert sich kein App-Code. In den Pull Request: Hinweis, dass alles nur zum Ansehen ist.

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
