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

### AG-2: Texte der Traum-Reise aus dem Argon-Entwurf überarbeiten (einmalig)

**Quelle:** Argon-Entwurf, vom Nutzer abgelegt unter `C:\TOOLS\velvet-inhalte\traum\argon_entwurf.txt`.
Fehlt die Datei: anhalten und den Nutzer bitten, sie dort abzulegen.

**Vorher lesen:** `docs/konzepte/traum-reise.md` (besonders „Traumbilder“, „Fantasie-Räume“, „Selbstwahrnehmung
im anderen Körper“, „Grenze für die Texte“, „Sprache und Stil“, „Entscheidungen“) und
`docs/konzepte/einschlaf-reise-textvorgabe.md` (verbindlicher Stil). Format wie
`tools/content/einschlaf/welle.json`.

**Zwei Teile, zwei Ablageorte:**

| Teil | Inhalt | Ablage | Ins Repository? |
|---|---|---|---|
| A, sanft | `sinken`, die 5 Traumbilder (sanft und spicy), `absicht`, `wach`, Kurztexte für Oberfläche und Tagebuch | `tools/content/traum/sanft.json` | ja, Branch `ag/2-traum-sanft`, Pull Request |
| B, Fantasie | die 5 Fantasie-Räume: `ort`, `koerper`, `begegnung`, `schwelle`, `absicht` | `C:\TOOLS\velvet-inhalte\traum\fantasie.json` | **nein, niemals** (auch nicht als Entwurf, Issue oder Pull Request) |

**Format:** JSON (UTF-8 ohne BOM) mit Listen `de` und `en`, Ids und Felder in beiden identisch. Felder wie im
Konzept unter „Technik“: Traumbilder mit `phase: "traumbild"`, `bild`, `teil` (`v1` lang, `v2` mittel,
`v3` kurz, `f` Absicht) und bei Spicy `stufe: "spicy"` sowie `koerper` (`vulva` | `penis`); Fantasie mit
`phase: "fantasie"`, `raum`, `teil` (`ort` | `koerper` | `begegnung` | `schwelle`), `mein_koerper`,
`gegenueber`. Absätze mit `\n`.

**Was zu tun ist:**
1. Die guten Bilder und Traum-Hinweise übernehmen (z. B. goldenes Licht unter Wasser, aufsteigende Funken,
   Licht ohne Schatten, zwei Monde, Uhren ohne Zeiger).
2. **Streichen:** alle pseudowissenschaftlichen Begründungen (Reverse Kegel, Prolaktin, Dopamin, „mehrere
   Höhepunkte“) und Versprechen wie „du wirst das Licht bemerken“. Bilder von Weite und Loslassen im Becken
   bleiben.
3. **Textvorgabe einhalten:** keine Gedankenstriche, keine Anführungszeichen, keine Klammern; im Traumbild-
   und Fantasie-Teil keine Aufforderungen („Lass …“, „Nimm …“), sondern feststellen oder erlauben; wenig
   Verneinungen; ein Gedanke pro Absatz; Zahlen als Wörter.
4. **Drei Fassungen je Traumbild** (`v1`, `v2`, `v3`) mit unterschiedlichen Bildern und derselben Absicht.
5. **Grenze prüfen** (Konzept „Grenze für die Texte“): Berührung bis zum Geschlecht und Erregung benennen ist
   erlaubt; keine sexuelle Handlung selbst, kein Höhepunkt, kein Dirty Talk; jede Szene endet an der
   Schwelle mit „Was jetzt geschieht, erzählt dir dein Traum.“ Alle Figuren erwachsen, alles gegenseitig
   gewollt, keine echten oder benannten Personen.
6. Im sanften Teil: Normaltext ohne Geschlechtsorgane; Spicy nur mit `koerper` vulva oder penis.
7. Englisch jeweils gleicher Funktion und Länge (±15 %), nicht Wort für Wort.
8. Prüfen: `python -c "import json;d=json.load(open(r'<Datei>',encoding='utf-8'));print(len(d['de']),len(d['en']))"`
   für beide Dateien; Ids in `de` und `en` gleich.

**Abschluss:** Für Teil A Pull Request mit kurzer Liste der Bausteine. Für Teil B **kein** Pull Request,
sondern dem Nutzer melden: Datei fertig unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json`, Anzahl der
Bausteine, offene Fragen. Der Nutzer liest beide gegen.

## Erledigt

(noch nichts)
