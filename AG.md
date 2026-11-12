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


- 01.11.2026, AG-22 bis AG-24 (kein Branch, Bilder lokal unter C:\TOOLS\velvet-inhalte\): 52 Kurs-Stimmungsbilder (1024 × 576) und 58 Szenenbilder der Audioreihe (768 × 1024) im Bleistift-Stil, eingebaut in die Pakete kurse-bilder-spicy v4 und
eihe-bilder v3. Der Nutzer ist sehr zufrieden; vier Bilder gehen als AG-25 in die Korrektur.
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













- 02.11.2026, Codex: drei neue Traumpraxis-Hörtexte DE/EN unter `docs/redaktion/traumpraxis/`, neue Produktions-/Prüfwerkzeuge und lokale Aufnahmen unter `build/redaktion/traumpraxis/`. Nutzer hat Textarbeit und alle zwölf Aufnahmen (Victoria/Martin, DE/EN) beauftragt. Keine parallele Kokoro-Instanz; keine Änderungen an Claudes acht privaten Folgen.



- 01.11.2026, Codex: `assets/data/velvet_content.json`, `translations/en/velvet_content.json`, `tools/generate_audio.py`, `tools/generate_audio_en.py`, `tools/reihe_ausdruck.py`, Geführte Texte DE/EN (paar_abend.json, selbst_reise.json, einschlaf_reise.json und traum_reise.json unter assets/data/ und translations/en/), neue Gesamtlektorat-Werkzeuge und Tests. Auftrag Gesamtlektorat/Audio auf `codex/gesamtlektorat-audio`; Stand im gemeinsamen Übergabeprotokoll. Keine parallelen Änderungen dieser Dateien.

Zusammenarbeit mit Codex: `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md` vor paralleler Text- oder Diagrammarbeit lesen. Codex hat getrennte DE/EN-Lektoratsentwürfe unter `build/redaktion/spicy/` erstellt; Prüfbericht und Erzeugung stehen in `docs/konzepte/spicy-lektorat.md`. Stand Gesamtlektorat: 128 Kurslektionen sowie 372 geführte Bausteine je Sprache gelesen; 82 geführte Sprachfassungen korrigiert. 345 Flutter-Tests und acht Python-Audiotests grün. Lokale Neuvertonung läuft getrennt; bestehende Paketaufnahmen unverändert. Details im Übergabeprotokoll. Die 100 Diagramm-SVGs sind neu gezeichnet; Quelle, Prüfungen und Übergabe stehen im selben Protokoll.

Jede Zeile mit Datum. Einträge, die älter als drei Tage sind, fragt Antigravity beim Nutzer nach, statt sie
stillschweigend zu übergehen.

- 27.10.2026: `C:\TOOLS\velvet-inhalte\` (private Inhalte, nie anfassen)
- 04.11.2026 (Mittwoch): **GitHub-Konto wird umbenannt, Verlauf wird umgeschrieben.** Vorher alles committen und pushen, dann nicht weiterarbeiten; danach den Klon mojo-ag **verwerfen und neu klonen**. Einzelheiten: docs/UMBENENNUNG.md.

## Offene Aufträge

### AG-27: Vier Bleistift-Bilder für „Zu zweit“, „Eure erste Woche“ und die Einladung

Stand 12.11.2026, von Claude Code. Hintergrund: `docs/konzepte/eine-tonlage.md`, Abschnitt „Bilder und Symbole“. Die App hat neue
Bereiche für Paare bekommen; dort stehen bisher gezeichnete Platzhalter. Gebraucht werden vier ruhige Bilder, die **jede Paarform**
meinen können (Frau und Mann, zwei Frauen, zwei Männer, nicht eindeutig). Deshalb gilt für alle vier: **Man erkennt kein Geschlecht.**
Varianten je Paarform kommen später in einem eigenen Auftrag, sobald die App sie auswählen kann.

**Branch:** `ag/27-paar-bilder-<datum>`. **Erlaubte Dateien:** nur die vier neuen WebP unter `assets/images/` und der Bericht
`docs/pruefungen/AG27_PAAR_BILDER.md`. `assets/data/bilder.json`, `lib/`, Texte und `AG.md` nicht ändern; das Einbauen macht Claude.

**Stil (wie AG-22 bis AG-24):** detailed pencil drawing, technical illustration style, soft shading, faint blueprint grid with thin
dimension lines and thin arrows, off-white paper, dezente Rosé-Akzente, **keine Schrift, keine Zahlen**. Das Bild füllt die ganze
Fläche mit hellem Papierton, ohne grauen Rand, ohne Blattkante, ohne Stift oder Schneidematte. Keine Fotos, kein Foto-Effekt.
Alle Personen sind erwachsen und bekleidet, nichts Erotisches, nichts, was auf einem Sperrbildschirm auffiele.

| Datei | Format | Motiv |
|---|---|---|
| `assets/images/bereich_zu_zweit_kopf.webp` | 3:2, 1200 × 800 | Zwei Erwachsene sitzen eng nebeneinander auf einem Sofa, **von hinten** gesehen, die Köpfe leicht zueinander geneigt, eine Decke über beiden Schultern. Frisuren und Kleidung so, dass kein Geschlecht ablesbar ist (keine langen Haare, keine Bärte, weite Pullover). Ruhig, vertraut. |
| `assets/images/bereich_erste_woche_kopf.webp` | 3:2, 1200 × 800 | **Ohne Menschen:** ein Pfad aus **genau sieben** flachen Trittsteinen, der leicht geschwungen ins Bild führt; am Anfang stehen zwei Paar schlichte Schuhe nebeneinander. Die Maßlinien begleiten den Pfad. Wirkt einladend, nicht wie eine Aufgabe. |
| `assets/images/bereich_einladung_willkommen.webp` | 3:4, 900 × 1200 | **Ohne Menschen:** ein kleiner Tisch mit zwei Tassen, daneben zwei Stühle; einer ist ein Stück zurückgezogen und frei, als dürfe sich jemand setzen. Warmes Licht von der Seite. Sagt: Du bist willkommen, nichts wird erwartet. |
| `assets/images/bereich_heute_einladung.webp` | 3:4, 900 × 1200 | **Ohne Menschen:** eine halb geöffnete Tür, durch die weiches Licht auf den Boden fällt; daneben eine Pflanze oder ein Mantelhaken. Sagt: der nächste Schritt, wenn du magst. |

**Technik:** WebP, je Datei unter 150 KB, genau die angegebenen Maße, Dateinamen genau wie in der Tabelle.

**Jedes Bild ansehen, bevor es zählt:** Bei `bereich_zu_zweit_kopf` sind es genau zwei Personen mit je zwei Schultern, keine
verwachsenen Körper, kein drittes Paar Hände. Bei `bereich_erste_woche_kopf` Steine zählen (sieben) und Schuhe zählen (vier). In
keinem Bild Schriftzeichen, auch nicht angedeutet am Rand. Fehlgriffe neu erzeugen.

**Das Warten:** Ist die Bildgenerierung nicht verfügbar (Kapazitätslimit, 429, „Resource Exhausted“), nicht abbrechen und nicht
„fertig“ melden. Im Bericht notieren, warten (Wartezeit aus der Meldung, sonst 30 Minuten) und dasselbe Motiv erneut versuchen.

**Bericht** `docs/pruefungen/AG27_PAAR_BILDER.md`: Tabelle mit Datei, Maßen, Größe, Zahl der Versuche und einem Satz, was zu sehen
ist; dazu, was unsicher ist.

**Fertig, wenn:** alle vier Dateien mit richtigen Maßen im Branch liegen, der Bericht dabei ist und der Pull Request gegen `main`
steht. `flutter test` ist nicht nötig (die Bilder sind noch nicht eingetragen).

**Nicht tun:** andere Bilder „nebenbei verbessern“, Bilder in `bilder.json` eintragen, Menschen mit erkennbarem Geschlecht zeichnen,
Lektionstexte oder Audio anfassen.

### AG-28: Sechs Lektionen neu einsprechen (Deutsch und Englisch) – **noch nicht starten**

**Wartet auf Claude und den Nutzer.** Dieser Auftrag wird erst gültig, wenn hier die Zeile „Texte freigegeben am …“ steht. Bis
dahin überspringen und den nächsten offenen Auftrag nehmen.

Hintergrund: `docs/konzepte/eine-tonlage.md`, Abschnitt „Als Liste gemeldet … (gesprochene Texte)“. Die App spricht inzwischen
alle Paarformen an; sechs gesprochene Lektionen nennen aber noch fest „Frauen“, „Männer“ oder „der Mann“. Claude schreibt diese
Texte körperbezogen um (Deutsch und Englisch), der Nutzer liest gegen, danach wird neu eingesprochen. **An den Texten ändert
Antigravity nichts.**

| Lektion | Kurs | Stimme (wie bisher) |
|---|---|---|
| `female_1` (auch der gesprochene Titel) | 9 | Victoria |
| `touch_w_1` | 18 | Victoria |
| `touch_m_1` | 19 | Martin |
| `mass_1`, `mass_2` | 20 | beide im Wechsel |
| `pos_1` | 22 | beide im Wechsel |

**Branch:** `ag/28-neuaufnahme-<datum>`, vorher `git pull`, damit die freigegebenen Texte da sind.

**Zu tun:**
1. Deutsch: `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py female_1 touch_w_1 touch_m_1 mass_1 mass_2 pos_1`.
   Die Stimmenwahl trifft das Werkzeug selbst (Kategorie des Kurses), nichts von Hand umstellen.
2. Englisch: mit `tools/generate_audio_en.py` dieselben sechs Lektionen, wie in `README.md` beschrieben.
3. Betonung: Es gilt der Weg aus `CLAUDE.md` („Betonung beim Einsprechen“). Steht eine der sechs Lektionen in
   `reihe_ausdruck.AUSDRUCK_LEKTIONEN`, spricht das Werkzeug sie mit dem Profil; sonst normal. Kein neues Profil erfinden.
4. Aussprache: Fällt ein Wort auf, nach `docs/AUSSPRACHE.md` in `tools/aussprache.json` ergänzen und nur diese Lektion neu sprechen.
5. Jede Aufnahme einmal ganz anhören (oder ausdrücklich „nicht prüfbar“ schreiben): Titel richtig, kein abgeschnittenes Ende,
   Stimmenwechsel an den Absätzen, neue Wörter („Menschen mit Vulva“, „die empfangende Person“) sauber gesprochen.

**Erlaubte Dateien:** die zwölf neuen Aufnahmen und die zugehörigen Einträge in `dauer.json`, bei Bedarf `tools/aussprache.json`,
und der Bericht `docs/pruefungen/AG28_NEUAUFNAHME.md` (je Aufnahme: Datei, Dauer, angehört ja/nein, Auffälligkeiten).

**Nie zwei Kokoro-Läufe gleichzeitig.** Die bisherigen Aufnahmen bleiben in den veröffentlichten Paketen unberührt.

**Nicht tun:** Texte ändern, `tools/pakete/versionen.json` hochzählen, `tools/pakete_hochladen.ps1` ausführen, andere Lektionen
„mit neu sprechen“. Paket, Hörabnahme mit dem Nutzer und Veröffentlichung macht Claude.

### AG-26: Gezielte Audio-Hörstichprobe (von Claude zu koordinieren)

**Aktuell abgeschlossen:** Finale AG-Aufnahme vom Nutzer freigegeben und durch Codex anhand SHA256/Dekodierung geprüft. Exakte Datei lokal gesichert unter `build/redaktion/gesamt/korrektur-ag26/abgenommen-ag/`. Kein weiterer Hör-/Syntheseauftrag. Paketübernahme durch Claude offen; siehe `docs/pruefungen/AG26_FINALE_UEBERGABE.md`. Bericht-PR noch nicht zusammengeführt; nicht als bereits gemergt verbuchen.

Nutzerentscheidung vom 02.11.2026: Stichproben reichen. Verbindlicher Auftrag: `docs/AUFTRAG_AG_AUDIO_STICHPROBE.md`. 28 Proben, Deutsch/Englisch, Victoria/Martin und Stimmenwechsel, Lektionen sowie geführte Profile einschließlich Traumpraxis; rund 25–30 Minuten mit Wechseln und Wiederholungen. Hörseite: `C:\TOOLS\workspace\mojo\build\redaktion\gesamt\abnahme\AG_STICHPROBEN.html`.

Eigener Klon/Branch `ag/26-audio-stichprobe-20261102`; einzige erlaubte Änderung `docs/pruefungen/AG26_AUDIO_STICHPROBE.md`. Produktionsdateien nur lesen/abspielen, keine Neuvertonung oder Uploads. Private Innenansichten/Abendfolgen ausgeschlossen. Bei fehlender akustischer Prüfmöglichkeit ausdrücklich „nicht prüfbar“. Auftrag vorbereitet, Hörabnahme offen. Da dieser Stand noch lokal ist, stellt Claude AG den Auftrag und die lokalen Eingaben bereit; nicht durch bloßes Pull als verfügbar voraussetzen.


### AG-25: Korrektur von vier Bildern (drei Kursbilder und eine Szene der Audioreihe)

**Kein Branch, kein Pull Request, kein Commit.** Rückmeldung vom 01.11.2026 nach der Durchsicht von AG-22 bis AG-24: Der Nutzer ist mit den Bildern sehr zufrieden. Nur diese vier
passen nicht und werden neu erzeugt, **sonst nichts**. **Gleiche Ausnahme mit ausdrücklicher Freigabe des Nutzers (01.11.2026) wie AG-22 bis AG-24:** Die Motive dürfen an dein
Bildmodell. Bilder nur nach `C:\TOOLS\velvet-inhalte\kurse\bilder\ag_korrektur\` (Kursbilder, 1024 × 576) und `C:\TOOLS\velvet-inhalte\reihe\bilder\ag_korrektur\` (Szene,
768 × 1024) schreiben, **gleiche Dateinamen wie die Vorlage**, WebP, unter 130 KB. **Nie ins Repository, nie in `assets/`, die Originale nicht überschreiben.**

**Stil unverändert (wie AG-24):** detailed pencil drawing, technical illustration style, natural adult bodies with soft shading, faint blueprint grid with thin dimension
lines and thin arrows, off-white paper, dezente Rosé-Akzente, keine Schrift. Alle Figuren erwachsen, alles einvernehmlich. Das Bild füllt die ganze Fläche mit hellem Papierton
(wie `couples_2` oder `pos_1`).

| Datei | Problem | Soll |
|---|---|---|
| `kurse\spduo_3_spicy.webp` | Das Blatt steht auf grauem Grund (Foto-Effekt) | Dasselbe Motiv (Paar, einander zugewandt, ihre Hand auf seiner Brust) randlos auf hellem Papier, **kein** grauer Rand, **keine** Blattkante |
| `kurse\self_2_spicy.webp` | grauer Rand mit Schneidematte, Bleistift in der Ecke | Dasselbe Motiv (liegende Frau, ruhig) randlos auf hellem Papier, **ohne** Stift, Matte und Rand |
| `kurse\scen_1_spicy.webp` | am Rand angedeutete Textzeilen (die Vorgabe ist „textfrei“) | Dasselbe Motiv (Augenbinde, Hand auf der Schulter), am Rand nur Raster, Maßlinien und Pfeile, **keine** Zeilen, **keine** Schriftzeichen |
| `reihe\frau_mann_soft_climax.webp` | Frau allein im Bett, das Paar nur als Silhouette im Fenster | **Beide Figuren sind im Bild:** Mann und Frau eng umschlungen im Bett unter dem Laken, Kerze, Regen am Fenster; vom Laken bedeckt (soft), ohne deutliche Nacktheit, in der Bildsprache von `frau_mann_soft_building_desire` |

Die Vorlagen liegen in `kurse\bilder\ag_spicy\` und `reihe\bilder\ag\`; sie sind die Referenz für Motiv, Figuren und Stil. Gesichter und Frisuren der Figuren bleiben wie in der Vorlage.

**Das Warten:** Wie bei AG-24: Ist die Bildgenerierung nicht verfügbar (Kapazitätslimit, 429, „Resource Exhausted“), **brich nicht ab und melde nicht „fertig“.** Notiere es in
`ag_korrektur\_liste.txt`, **warte** (Wartezeit aus der Meldung, sonst 30 Minuten) und versuche dasselbe Motiv erneut. Nach **jedem** Bild eine Zeile in `_liste.txt` (Datei,
„erzeugt“ oder „Filter, übersprungen“, Größe, Maße, Datum).

**Fertig, wenn:** alle vier Bilder in den beiden Ordnern `ag_korrektur` liegen **und** `bericht_fuer_claude.md` im Ordner `kurse\bilder\ag_korrektur\` steht (nur Dateien, die
ersetzt werden können, Auffälligkeiten, was der Filter übersprungen hat).

**Nicht tun:** Bilder ins Repository oder nach `assets/` legen, Originale überschreiben, Lektionstexte oder Audio lesen, Bilder weitergeben, einen Filter umgehen, andere Bilder
„nebenbei verbessern“.

### AG-3: Texte für „Lust im Traum“ (an Claude Code abgegeben)

Der Inhaltsfilter von Antigravity bricht diese Texte ab. Claude Code schreibt sie (lokal unter
`C:\TOOLS\velvet-inhalte\lust\lust.json`); das Einsprechen kommt danach als eigener Auftrag.

### AG-1: Aussprache korrigieren (beendet)

Seit 27.10.2026 erledigt das Claude Code mit OpenCode (Ablauf in `docs/AUSSPRACHE.md`). Antigravity holt
keine Aussprache-Meldungen mehr ab und legt keine `aussprache/`-Branches mehr an.

## Erledigt

- 02.11.2026, Codex: Bedienung/Player/gemeinsames Hören implementiert und automatisch geprüft (419 Tests, Analyse, DE/EN-Renderansichten). Übergabe `docs/UEBERGABE_BETA_BEDIENUNG.md`; Nutzer hat den Build ausdrücklich Claude zugeordnet. Native App-/Handytests bleiben offen; kein Codex-Release.

- 01.11.2026, AG-22 bis AG-24 (kein Branch, Bilder lokal unter C:\TOOLS\velvet-inhalte\): 52 Kurs-Stimmungsbilder (1024 × 576) und 58 Szenenbilder der Audioreihe (768 × 1024) im Bleistift-Stil, eingebaut in die Pakete kurse-bilder-spicy v4 und
eihe-bilder v3. Der Nutzer ist sehr zufrieden; vier Bilder gehen als AG-25 in die Korrektur.
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
