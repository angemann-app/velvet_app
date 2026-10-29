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

### AG-21: Erklärende Körperzeichnungen im Stil einer technischen Bleistift-Studie (8 Bilder, mit Beschriftungsvorschlägen)

**Branch:** `ag/21-koerperzeichnungen`
**Hintergrund:** Der Nutzer hat mit dir ein Muster erzeugt (erwachsene Frau liegt auf der Seite, Bleistift, feine Schraffur, blasses Raster mit
Maßlinien und dünnen Pfeilen, off-white, ohne Text) und möchte diesen Stil für **erklärende** Bilder in Lektionen. Genau diesen Stil und
diese Qualität wieder verwenden. Nackt, wenn dein Filter es zulässt (Entscheidung des Nutzers); **bricht dein Filter ab, nicht umgehen, nicht
entschärfen**, das Motiv in der Liste als „Filter, übersprungen“ vermerken und mit dem nächsten weitermachen.
**Darf ändern:** nur neue Dateien `assets/images/zeichnung_<Lektions-ID>.webp` und `docs/kursbilder-liste-ag21.md`. Nichts anderes.
**Vorher lesen:** nur die jeweilige Lektion in `assets/data/velvet_content.json` (Felder title, summary, content; **keine Spicy-Lektionen**, keine
Kurse 26 und 27), damit die Beschriftung zum Text passt.

**Stil-Prompt (Grundlage, pro Motiv das Motiv ersetzen):** „detailed pencil drawing, technical illustration style, natural adult body with soft
shading on skin and muscle, faint blueprint grid in the background with scale markers and thin dimension lines, thin non-obstructive arrows
pointing to areas of the body, off-white paper, graphite with soft rose accents, no text, no labels, <Motiv>“.
**Regeln:** nur Erwachsene; **keine Ähnlichkeit mit einer echten Person**; **keine Maße, Zahlen, Buchstaben oder Beschriftung im Bild**; natürliche,
unterschiedliche Körper (nicht nur schlank und jung); keine Nahaufnahme von Genitalien; ruhig und sachlich, nicht erotisch inszeniert. Format Querformat,
etwa 1024 × 576, WebP, höchstens 150 KB. Gesichter dürfen erkennbar sein, aber nicht an eine bekannte Person erinnern.

**Die acht Motive:**
1. `anat_1` (Kurs 2, Erregung als Ganzkörper-Ereignis): erwachsene Frau liegt entspannt auf der Seite, ganze Gestalt (wie das Muster).
2. `anat_3` (Kurs 2, Rücken, Bauch, Kniekehlen, Füße): erwachsener Mann liegt auf dem Bauch, Rückenansicht, ganze Gestalt.
3. `beauty_1` (Kurs 3, Mythos vom perfekten Körper): **vier erwachsene Körper nebeneinander** stehend, Rückenansicht oder Seitenansicht, sehr
   unterschiedlich (schlank, kurvig, athletisch, älter), ruhige Haltung.
4. `touch_w_1` (Kurs 18, Gleichmäßigkeit): eine Frau liegt auf dem Bauch, die flache Hand eines Mannes ruht auf ihrem unteren Rücken, Rückenansicht,
   beide ganz sichtbar.
5. `touch_m_1` (Kurs 19, Offene Hand): ein Mann liegt auf dem Rücken, die offene, flache Hand einer Frau ruht auf seiner Brust, beide ganz sichtbar.
6. `mass_1` (Kurs 20, Einer gibt, einer empfängt): ein Mann liegt auf dem Bauch auf einem Tuch, eine Frau kniet daneben und streicht mit beiden Händen
   über seinen Rücken, beide ganz sichtbar.
7. `pos_2` (Kurs 22, Positionen für Ausdauer): ein Paar liegt im Löffelchen auf der Seite, sein Arm um sie, seitliche Ansicht, beide ganz sichtbar.
8. `self_1` (Kurs 8, Warum sich selbst erkunden): eine erwachsene Frau sitzt entspannt im Schneidersitz, eine Hand auf dem Bauch, eine auf der
   Brust, Vorderansicht.

**Liste** `docs/kursbilder-liste-ag21.md`: je Bild vier bis sechs **Beschriftungsvorschläge** für spätere Pfeile und Texte, jeweils mit deutschem und
englischem Text (kurz, höchstens vier Wörter), dem **Zielpunkt** am Körper (x, y in Prozent der Bildbreite und -höhe) und einer **Textposition**
(x, y in Prozent), die weder Körper noch Linien verdeckt. Die Beschriftungen beschreiben Zonen und Berührungsarten, **keine Zentimeter oder Maße**.
**Prüfen:** Bilder ansehen (Anatomie, Hände, Figurenzahl), Liste vollständig; `flutter test` nicht nötig. Im Pull Request: Hinweis, dass die Bilder noch nicht
eingebunden sind (das macht Claude Code, die Texte legt er als SVG darüber).

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
