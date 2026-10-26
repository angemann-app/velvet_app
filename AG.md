# Arbeitsaufträge für Antigravity

Diese Datei steuert Antigravity. Der Nutzer sagt nur: **„Hol ab und bearbeite.“** Dann gilt der Ablauf
unten. Aufträge schreibt Claude (bzw. der Nutzer) in „Offene Aufträge“; Antigravity arbeitet sie ab.

## Ablauf bei „Hol ab und bearbeite“

1. `git checkout main` und `git pull`. Gibt es lokale, nicht gesicherte Änderungen: anhalten und den Nutzer
   fragen, nichts verwerfen.
2. `CLAUDE.md` lesen. Die Regeln dort gelten auch für Antigravity (Sprache Deutsch, feste Regeln, Diskretion,
   Übersetzungen mitpflegen).
3. In dieser Datei den **ersten offenen Auftrag** nehmen (Reihenfolge = Priorität). Daueraufträge
   („laufend“) kommen dran, wenn sonst nichts offen ist oder sie ausdrücklich fällig sind.
4. Eigenen Branch anlegen, wie im Auftrag angegeben (sonst `ag/<auftrag-id>-<datum>`).
5. **Nur die im Auftrag genannten Dateien ändern.** Braucht es mehr, anhalten und fragen. Nie an Dateien
   arbeiten, die in „Gesperrt“ stehen; dort arbeitet gerade Claude Code.
6. Prüfen, wie im Auftrag beschrieben (mindestens `flutter test`, wenn Code oder Inhalte betroffen sind).
7. Commit, Push, Pull Request gegen `main`. **Nicht selbst zusammenführen**; das macht der Nutzer nach
   dem Anhören bzw. Durchsehen.
8. Im Pull Request kurz berichten: was erledigt, was offen, was der Nutzer prüfen oder anhören soll.
9. Den Auftrag in dieser Datei (im selben Branch) unter „Erledigt“ eintragen: Datum, Branch, ein Satz.

Wenn etwas unklar ist oder schiefgeht: anhalten und den Nutzer fragen statt raten. Lieber ein halber
Auftrag mit klarer Notiz als ein ganzer mit Vermutungen.

## Gesperrt (hier arbeitet gerade Claude Code)

- `lib/services/foto_kanal.dart`, `lib/services/foto_verbindung.dart`, `lib/services/nostr_service.dart`,
  `lib/services/nostr_event_check.dart`, `lib/services/sprachausgabe.dart`, `.github/workflows/`
  (Aufgaben 1 bis 3 aus `docs/AUFGABEN.md`)

## Offene Aufträge

### AG-1: Aussprache korrigieren (laufend, täglich)

**Branch:** `aussprache/<JJJJ-MM-TT>`
**Darf ändern:** `tools/aussprache.json`, neu erzeugte Dateien unter `assets/audio/` (nur die betroffenen),
dieser Datei-Abschnitt „Erledigt“.

1. Neue Meldungen abholen:
   `C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart`
   Sie landen auch in `C:\TOOLS\velvet-feedback\rueckmeldungen.md`. Dazu offene GitHub-Issues mit der
   Vorlage „Aussprache“ ansehen.
2. Nur Aussprache-Meldungen bearbeiten (Wort, Stimme, Lektion, Minute). Andere Rückmeldungen nicht
   bearbeiten, sondern im Pull Request kurz als „andere Rückmeldungen: n Stück“ erwähnen.
3. Je Wort die aktuelle Lautschrift ansehen:
   `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py --zeige "<Wort>"`
   Dann einen Eintrag in `tools/aussprache.json` ergänzen oder korrigieren (Format der vorhandenen Einträge
   übernehmen) und mit `--zeige` erneut prüfen.
4. Betroffene Aufnahmen finden: alle Lektionen und Bausteine, deren Text das Wort enthält, für die gemeldete
   Stimme (bei geführten Audios oft beide Stimmen). Liste in den Pull Request schreiben.
5. Neu einsprechen, z. B. `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py <lektions-id>`,
   bzw. `--paar`, `--selbst`, `--einschlaf` mit `--stimme` für geführte Audios. Ausgabe kurz halten.
6. Im Pull Request eine **Anhörliste** für den Nutzer: Datei, Wort, ungefähre Stelle. Der Nutzer hört an
   und führt dann zusammen.

**Datenschutz:** Den Inhalt der Rückmeldungen nie in Commits, Pull Requests oder Issues kopieren, nur das
betroffene Wort, die Stimme und die Lektion. `C:\TOOLS\velvet-feedback\` und der Schlüssel dort bleiben
außerhalb des Repositorys.

**Wenn nichts Neues gemeldet ist:** nichts ändern, keinen Branch anlegen, dem Nutzer „keine neuen
Aussprache-Meldungen“ melden.

## Erledigt

- 2026-10-26, Branch `ag/2-traum-sanft` (AG-2):
  - **Repository-Aktionen:** Branch `ag/2-traum-sanft` von `main` (`61e72e1`) abgezweigt, `tools/content/traum/sanft.json` (neu, 39 Bausteine je `de`/`en`) und `AG.md` geändert, Commit `5c25f89` nach `origin/ag/2-traum-sanft` gepusht, Pull Request [#11](https://github.com/angemann-app/velvet_app/pull/11) gegen `main` eröffnet (`flutter test` grün).
  - **Lokal außerhalb des Repos:** `C:\TOOLS\velvet-inhalte\traum\fantasie.json` (31 Bausteine je `de`/`en` für die 5 Fantasie-Räume) erstellt.
- 2026-10-26, Branch `aussprache/2026-10-26` (AG-1):
  - **Repository-Aktionen:** Branch `aussprache/2026-10-26` von `main` (`61e72e1`) abgezweigt, in `tools/aussprache.json` 16 Lautschrift-Einträge (`singles`, `liefert`, `liefern`, `aftercare`, `genitalien`, `scannt`, `scannen`, `atemzug`, `atemzüge`, `atemzügen`, `atemhauch`, `atemtechnik`, `atemkontrolle`, `liegen`, `app`, `apps`) ergänzt; neu eingesprochene Audios unter `assets/audio/` (`alltag_11.opus`, `spduo_5.opus`, `spduo_6.opus`, `anat_1.opus`, `scen_1.opus`, `scen_4.opus`, `desire_4.opus`, `einschlaf/victoria_sinken_kurz_1.opus`, `einschlaf/dauer.json`) sowie `AG.md` aktualisiert, nach `origin/aussprache/2026-10-26` gepusht und Pull Request gegen `main` erstellt.
