# Konzept: Oberfläche aufräumen

Stand 12.11.2026, abgestimmt (Empfehlungen angenommen) und umgesetzt, siehe „Umsetzungsstand“ am Ende.

Maßstab: Der Magazin-Look (`designsystem-magazin.md`) bleibt. Aufräumen heißt: Inhalt vor Technik, das Wichtige ohne Scrollen,
nichts Unbeschriftetes, das man erraten muss. Es entsteht kein neuer Stil und keine neue Komponentenfamilie; wo es geht, werden
vorhandene Bausteine (`VpAbschnitt`, `VpKarte`, `VpChip`, `VpListenzeile`, `VpKapitelLeiste`, `VpTabs`) benutzt.

Grundlage der Befunde: die Testbilder unter `build/screens/` (390 × 844) und der Quelltext. Testbilder sind kein Gerätetest. Die
Bilder können älter sein als der Code (Beispiel: auf `01_kurse.png` steht das Profil-Symbol im Inhalt, im Code ebenfalls); die
Ausgangslage rendere ich vor dem Start neu und lege sie als „Vorher“ ab.

## Rollen und wann sie eingreifen

| Rolle | Auftrag | Wann |
|---|---|---|
| Designer:in (führt) | Skizzen unten, Abnahme jedes Bildes im bestehenden System | durchgehend |
| Grafiker:in | Liste fehlender Bilder und Symbole (Abschnitt „Grafikliste“), keine fertigen Bilder | nach deinem OK, vor Bildschirm 1 |
| Programmierer:in | Umsetzung, Tests, Texte nur über ARB (de, en) | je Bildschirm |
| Sexualtherapeut:in | Prüft Paar-Kanal und Fantasie-Landkarte auf Druck (Reihenfolge, Gewichtung, Zähler) | nach Bildschirm 2 und 3 |

Die Rollen laufen als Subagenten mit je vollständigem Auftrag; Bilder sehe ich selbst an.

## Skizzen je Bildschirm

### 1. Heute (`lib/screens/main_navigation_screen.dart`, `lib/screens/courses/courses_screen.dart`)

Befund: Die Einladungskarte hat ein Bildfeld von 190 pt (Spicy 300 pt); bei Kursen ohne Bild zeigt es nur zwei Wellen. „Für heute“
beginnt erst bei etwa y = 620, der Check-in ist angeschnitten. Das Profil-Symbol (`account_circle`, 30 pt) steht neben „Hallo, Alex“
und hat keine Beschriftung.

```
Heute                    🔍  ?  SOS        <- Profil kommt hierher (nur auf Heute): 👤
MONTAG, 2. NOVEMBER
Hallo, Alex
Dein Fokus: Leistungsdruck abbauen
🔒 Bleibt auf deinem Handy
┌─ [Bildfeld 92 pt] ──────────────┐
│ DEIN NÄCHSTER SCHRITT            │
│ Gaspedal und Bremse              │
│ 1. Kopf und Körper … · 5 Min.    │
│ [ Starten ]                      │
└──────────────────────────────────┘
Für heute  ───────────
[Check-in] [Funke]
┌ 30-Sekunden Tages-Check-in ┐       <- jetzt vollständig sichtbar
```

- Bildfeld höchstens halb so hoch: **92 pt** statt 190. Hat der Kurs ein echtes Bild, wird es zugeschnitten gezeigt (Format `kopf`,
  Mitte), sonst bleibt der Platzhalter niedrig. Kein neues Motiv nötig.
- Spicy: die Poster-Dramaturgie (Titel über dem Bild) bleibt, aber 300 → **168 pt**; siehe offene Frage 2.
- Profil-Symbol: nur im Tab Heute in `AppBar.actions` vor Suche und Hilfe, Tooltip bleibt `coursesProfileSettings`; aus dem
  Kopf entfernt. Der Kopf gewinnt die Breite zurück. Das SOS-Symbol bleibt unangetastet.
- Ziel als Test: In `screens_test` (390 × 844, Skala 1,0) liegt die Kopfzeile des Check-ins vollständig im sichtbaren Bereich.

### 2. Paar-Kanal (`lib/screens/couples_channel/couples_channel_screen.dart`)

Befund: Über dem Verlauf liegt eine leere Fläche (auf `04_paarkanal_verbunden.png` etwa 140 pt hoch); vermutlich `PartnerProfilePrompt`
oder `_fotoIdee`, die bei „nichts offen“ ein leeres Gerüst zeichnen (Ursache wird vor der Änderung geklärt). Die Kopfzeile hat drei
Symbole ohne Beschriftung: Lotus (Gemeinsamer Abend), Kompass (Fantasie-Landkarte), drei Punkte (Menü).

```
(A) Ansehen   Du & Anna            ⋮
              ● verbunden · verschlüsselt
[ Gemeinsamer Abend ]  [ Fantasie-Landkarte ]   <- beschriftete Chips, eine Zeile
Nachrichten │ Gemeinsam entdecken
(Verlauf beginnt direkt)
```

- Leere Karte: wird nur gebaut, wenn es etwas anzuzeigen gibt (Profilfrage offen, Foto-Idee aktiv, Anfrage da); sonst `SizedBox.shrink`
  ohne Rest-Abstand.
- Lotus und Kompass werden zu zwei kleinen beschrifteten Chips (`VpChip` mit Linien-Symbol und Text, einzeilig, `Flexible`), unter der
  Kopfzeile. Bei schmalem Display/großer Schrift wird der Text gekürzt, das Symbol bleibt; Tooltips bleiben. Das Menü bleibt als
  Drei-Punkte-Symbol (allgemein verständlich). Alternative in Frage 3.
- Gesprächsinhalt unverändert; Reihenfolge und Gewichtung prüft Sexualtherapeut:in (kein „Pflicht“-Eindruck für Abend und Landkarte).
- Rest: 2 px Überlauf im Nachrichten-Reiter bei Skala 1,6 (Stand `designsystem-magazin.md` Abschnitt 18) mitnehmen.

### 3. Fantasie-Landkarte (`lib/screens/yes_no_maybe/yes_no_maybe_screen.dart`)

Befund: Vor der ersten Frage stehen zwei Reiter (Fragenkatalog / Matches), der Infokasten „Digitaler Safe Space“ mit drei
Zählern, die Filterleiste (Alle/Offen/Ja/Vielleicht/Lieber nicht) mit denselben Zahlen noch einmal, und ein Kategoriebild (96 pt). Das
sind rund 480 pt vor der ersten Frage. Titel: Zweizeiliger `AppBar`-Titel (17 pt + 11 pt) mit `TextStyle` ohne Serif im 56-pt-Toolbar; im
Testbild ist er oben abgeschnitten. Wahrscheinliche Ursache: Höhe der Spalte (Schriftgröße × Zeilenhöhe) > Toolbar-Höhe; wird
nachgemessen und durch einen einzeiligen Serif-Titel (`Fantasie-Landkarte`) mit der Unterzeile als Teil der Infobox ersetzt.

```
Fantasie-Landkarte                       ⟳(Abgleich)
Fragen 1/65  │  Matches 0
┌ ⓘ Wie das funktioniert (einklappbar; nach erstem Besuch zu) ┐
[Alle 65] [Offen] [Ja 1] [Vielleicht 0] [Lieber nicht 0] →   <- Zähler = Filter, eine Leiste
[Kategoriebild 72 pt]
Sinnlichkeit & Sinne
 Langsame Ganzkörper-Massage …           ⓘ
 ( ) Ja, gern  ( ) Vielleicht  ( ) Lieber nicht
```

- Zähler und Filter werden **eine** Leiste: Die Chips tragen die Zahl, die drei Zählerpillen entfallen.
- Infokasten: aufgeklappt nur beim ersten Besuch (Einstellung `ynm_info_gesehen`, kommt in `StorageService` und in Sicherung/Merge,
  Regel aus `CLAUDE.md`), danach eine Zeile „Wie funktioniert das?“ zum Aufklappen. Der Inhalt (nur ihr beide seht, was ihr beide wollt)
  bleibt gleich und wird nicht gekürzt, nur eingeklappt.
- Kategoriebild 96 → 72 pt, damit die erste Frage vor 480 pt beginnt (Ziel: Kopf der ersten Frage bei y < 420).
- Ob die zwei Reiter bleiben, ist Frage 4.

### 4. Lektion (`lib/screens/courses/lesson_detail_screen.dart`)

Befund: Der Kurstitel steht im AppBar (`widget.courseTitle`, Zeile 317), in der Eyebrow über dem Titel (Zeile 398, dort in Kombination
mit Art und Dauer, bricht im Testbild um: „20. DIE KUNST DER INTIM-MASSAGE · LEKTION · 6 MIN. LESEZEIT“) und ein drittes Mal in der
Meldeadresse bzw. der Reflexion; die dritte sichtbare Stelle bestätige ich im gerenderten Bild.

```
← 20. Die Kunst der Intim-Massage   ♡ ✓     <- Kurstitel bleibt hier, einmal
[Bild]
LEKTION · 6 MIN.                              <- eine Zeile, kein Umbruch
Die Yoni-Massage: Behutsam und Schritt für Schritt
```

- Eyebrow: `Lektion · 6 Min.` bzw. `Audio-Übung · 4 Min.`, `maxLines: 1`, `softWrap: false`, Ellipse als Notbremse.
  Neue ARB-Texte `lektionEyebrow`/`lektionEyebrowAudio` mit Platzhalter für die Minuten (de, en); „Min. Lesezeit“ entfällt dort.
- Der Kurstitel steht nur im AppBar. Weitere Vorkommen im sichtbaren Text werden entfernt; die technische Meldeadresse bleibt.

### 5. Player (`lib/widgets/audio_player_card.dart`, `lib/screens/wiedergabe_screen.dart`)

Befund: In der Lektion steht der Player mit Eyebrow, Zeit „00:00 / 06:00“, Untertitel, Aufnahmestatus („Ohne Aufnahme: Geräte-Stimme“), Link
„Aufnahmen laden“, Slider und erst dann der Abspielknopf (auf `06_lektion.png` angeschnitten). Die Wiedergabe-Seite zeigt „1 / 1 ·
00:47 / 05:00“ (Spur 1 von 1, dann Zeit) in Akzentfarbe; Titelfläche leer, Knopf ohne Bild.

```
Karte (Lektion)                         Wiedergabe-Seite
 ▶  Lektion anhören · 6 Min.            [Kursbild / ruhige Titelfläche]
 ━━●━━━━━━━  1:24 von 6:00              Gaspedal und Bremse
 ↺10   ⏸   10↻                          ━━●━━━━━  0:47 von 5:00
 (nur wenn keine Aufnahme da:           ↺10   ⏸   10↻   ⏹  ⏭
  klein: „Geräte-Stimme · Aufnahmen laden“)    Abschnitte ⌄
```

- Reihenfolge: Titel/Anlass, Abspielknopf, Slider und Zeit. `AufnahmeStatus` („Geräte-Stimme“, „Aufnahmen laden“) wird eine kleine,
  einzeilige Notiz **unter** den Knöpfen und nur sichtbar, wenn für diese Lektion keine Aufnahme geladen ist.
- Zeit menschlich: `1:24 von 6:00` (ARB mit Platzhaltern), keine führenden Nullen, keine Spurzählung („1 / 1“) bei nur einer Spur.
  Bei mehreren Spuren „Teil 2 von 3“ als eigene Zeile.
- Wiedergabe-Seite: Kursbild (Format `kopf`) aus der Quelle der laufenden Lektion bzw. ein ruhiger Platzhalter (`VpBildFeld`). Im
  Diskretions-Modus bleibt die Seite neutral (nur Titelfläche, keine Figuren, kein Rosé-Akzent); die Prüfung wiederhole ich im Test.
- Wiedergabe-Mini-Leiste und Hörplan-Logik werden nicht angefasst.

### 6. Üben (`lib/screens/ueben/ueben_screen.dart`, `lib/screens/training/`)

Befund: Zwei Reiterreihen (Körper/Gedanken/Coach und Beckenboden/Atem-Pacer), dann Programmwahl (4 Programme), dann Runden/Stufe/Ansage; erst
darunter der Kreis, unten abgeschnitten.

```
Üben
01 Körper │ 02 Gedanken │ 03 KI-Coach     <- Coach siehe Frage 5
Beckenboden │ Atem-Pacer                 <- bleibt (zwei Übungen)
Loslassen · weit werden           ⌄       <- Programm (aufklappbar)
10 Runden · leicht · mit Stimme  ⌄        <- Einstellungen (aufklappbar)
        (   4   )                         <- Kreis vollständig, mittig
   EINATMEN & WEIT WERDEN
        [ Start ]
```

- Programm und Einstellungen als je **eine** aufklappbare Zeile mit Zusammenfassung („10 Runden · leicht · mit Stimme“). Zugeklappt Standard;
  aufgeklappt wie heute. Auswahl wird in der Zeile als Klartext wiedergegeben.
- Der Kreis wird in den verbleibenden Platz **eingepasst** (`LayoutBuilder`, Durchmesser = min(Breite × 0,7, Resthöhe − Start/Statuszeilen)),
  nicht mehr in eine feste Größe. Prüfung bei 360 × 640 und Schrift 1,6.
- Obere Reiterreihe: Sie trägt derzeit „Gedanken“ (Reframing) und „KI-Coach“. Ist der Coach entfernt (`coach-entfernen.md`, noch
  **nicht** abgestimmt), bleiben zwei Kapitel; mehr als zwei Reiter sind kein Grund für die Reihe, aber „Körper | Gedanken“ ist weiter nötig.
  Die Umsetzung hier hängt nicht vom Coach ab, die Leiste passt sich an die Zahl der Bereiche an.

### 7. Lernen (`lib/screens/courses/courses_screen.dart`)

Befund: Das Ein-/Ausklappen eines Schwerpunkts ist ein kleines „–“ rechts (etwa 24 pt); Filterleiste horizontal scrollbar, am Rand
abgeschnitten, ohne Hinweis.

- Ganze Kopfzeile des Schwerpunkts (Nummer, Titel, Beschreibung) wird die Tippfläche (≥ 48 pt hoch), Pfeil (`expand_more` ↔ `expand_less`)
  rechts mit 24 pt Symbol; `Semantics` (button, expanded).
- Filterleiste: Randauslauf (weicher Papier-Verlauf rechts, 24 pt) und, solange nicht gescrollt wurde, ein Chip-Rand bewusst angeschnitten;
  im Zweifel ein kleiner Pfeil. Der Verlauf ist Papierfarbe → Transparent, in allen Paletten über `AppTheme.papier`.

### 8. Onboarding (`lib/screens/onboarding/`)

Befund: Unten „Überspringen & Direkt zur App“ in `tinteStumm` mit Pfeil.

- Text: **„Überspringen“** (de), **„Skip“** (en); über ARB. Pfeil bleibt, Kontrast wie Punkt 9.
- Unter dem Willkommen-Titel wird ein Platzhalter für die Unterzeile vorgesehen (`Text`-Slot, gleiche Zeile wie heute); der Wortlaut kommt
  aus dem Text-Paket, hier ändert sich der Text nicht.

### 9. Lesbarkeit

Befund: `tinteStumm` ist in Papier schon auf `66625A` angehoben (4,5 : 1 gegen `F6F0E6`, aber auf `FBF7F0`-Karten und `papierVertieft` knapp),
trotzdem erscheinen Uhrzeiten, Untertitel und „Bleibt auf deinem Handy“ durch kleine Schrift (11 bis 12,5 pt) blass.

- Kleine Zeilen (< 13 pt) in der Rolle `tinteLeise` (dunkler als `tinteStumm`) setzen, nie in `tinteStumm`; Mindestgröße 12 pt, nicht 11.
- `tinteStumm` in Papier von `66625A` auf ca. `5C584F` (mindestens 6 : 1 auf Papier und Karte), in Nachtpapier `A8A398` → ca. `B9B4A8`;
  Spicy wie Papier nachziehen. Endwerte nach Messung in `test/design_kontrast_test.dart` (Anforderung dort auf 5,5 : 1 für Text unter 13 pt).
- Prüfung in allen drei Darstellungen (Papier, Nachtpapier, Spicy) und in Skala 1,0 und 1,6 über `screens_test`; dazu ein Test, der die
  kleinen Textstile (`beschriftung`, `eyebrow`) gegen alle Hintergründe prüft.

## Grafikliste (Rolle Grafiker:in, keine fertigen Bilder)

| Bedarf | Format | Ort | Stil |
|---|---|---|---|
| Kursbild je Kurs für Heute-Karte (Zuschnitt `kopf` 3:2, mitte), wo es noch fehlt | 3:2 | Heute | nur Bleistift-Stil (AG), keine Fotobilder |
| ruhige Titelfläche Wiedergabe (Papier, Maßlinie, Kreuzmarke), neutral | Painter, kein Asset | Wiedergabe-Seite | vorhandene Marker `VpGrafik` |
| Symbole Chips: Gemeinsamer Abend, Fantasie-Landkarte | Material-Symbole genügen (`spa`, `explore`), SVG nur wenn nötig | Paar-Kanal | Linien-SVG |
| Symbol „Wie funktioniert das?“ | Material `info_outline` | Fantasie-Landkarte | Linie |
| Kreis-Übung: unverändert | | Üben | |

Kein neues Bild wird für die Umsetzung gebraucht; alles überbrückt der Platzhalter.

## Prüfplan

1. Vorher: `flutter test test_screens/screens_test.dart` rendern, Bilder der neun Bildschirme als „Vorher“ nach `build/aufraeumen/vorher/`.
2. Je Bildschirm ein Commit; danach `flutter analyze --no-fatal-infos --no-fatal-warnings`, `flutter test`, `screens_test`.
3. Zusätzlich: Skala 1,6 (`TEXTSCALE=1.6`), Nachtpapier (`PALETTE=nacht`), Spicy (`SPICY=true`), Display 360 × 640; Nachher nach
   `build/aufraeumen/nachher/` und Kontaktbogen (`tools/pilot_kontaktbogen.py`) Vorher/Nachher.
4. Nachziehen: Bildschirmfotos `docs/anleitung/`, `assets/data/anleitung.json` und `docs/ANLEITUNG.md` soweit betroffen, „Was ist neu“
   (`neuigkeiten.json`, de/en, nur auf Freigabe einer Build-Nummer), `docs/AUFGABEN.md`.
5. Bericht ehrlich: Testbilder und Layout-Test, **kein** Gerätetest, kein TalkBack-Test.

## Grenzen und Absprachen

- Neuer Branch von `main` über einen eigenen Worktree (siehe Frage 1); kein Zusammenführen, kein APK-Bau, keine Veröffentlichung.
- Dateien dieses Auftrags werden zu Beginn in `AG.md` unter „Gesperrt“ eingetragen: `main_navigation_screen.dart`, `courses_screen.dart`,
  `couples_channel_screen.dart`, `yes_no_maybe_screen.dart`, `lesson_detail_screen.dart`, `audio_player_card.dart`, `wiedergabe_screen.dart`,
  `ueben_screen.dart`, `training_screen.dart`, `kegel_timer_view.dart`, `breath_pacer_view.dart`, Onboarding, `lib/theme/vp_palette.dart`,
  ARB. Gestaged wird nur Eigenes.
- SOS bleibt ausdrücklich unberührt.
- Neue Texte nur in `app_de.arb` und `app_en.arb`; neue Einstellung `ynm_info_gesehen` in `StorageService`, Sicherung und
  `backup_merge_test`.

## Offene Fragen

1. **Branch-Basis.** Der Ordner steht auf `claude/altersnachweis-20261103` mit uncommitteten Änderungen anderer Sitzungen
   (`AG.md`, `.mcp.json`, Konzepte, Tests). Ich empfehle einen eigenen Worktree von `main` (Branch `claude/oberflaeche-aufraeumen-20261112`).
   Passt das? Die Worktree-Stände `design-magazin` und `mojo_sos` kann ich vorher abgleichen, falls dort Heute/Üben/Wir schon geändert sind.
2. **Heute in Spicy.** Poster-Dramaturgie behalten (300 → 168 pt) oder wie Normal auf 92 pt? Meine Empfehlung: 168 pt.
3. **Paar-Kanal-Kopf.** Zwei beschriftete Chips unter der Kopfzeile (Empfehlung) oder die beiden Symbole in das Drei-Punkte-Menü
   mit Beschriftung? Letzteres spart Platz, versteckt aber „Gemeinsamer Abend“ und „Fantasie-Landkarte“.
4. **Fantasie-Landkarte, Reiter.** „Fragenkatalog | Matches“ behalten (Empfehlung, ändert nichts an der Logik) oder Matches in den Paar-Kanal
   (dort gibt es schon „Gemeinsam entdecken“) legen? Letzteres wäre eine Funktionsänderung und braucht dein Konzept-OK.
5. **KI-Coach in Üben.** Vorerst unverändert lassen (Empfehlung), bis `coach-entfernen.md` abgestimmt ist; die Leiste passt sich an.
6. **Profil-Symbol.** Nur im Tab Heute (Empfehlung) oder in allen vier Tabs? Vier Tabs bedeuten ein Symbol mehr neben SOS überall.
7. **Kontrastwerte.** Sind dunklere Grautöne (Absatz 9) im Papier-Look in Ordnung, oder soll die Schrift stattdessen größer werden (12,5 → 13 pt)?
   Empfehlung: beides in kleinen Schritten, erst Farbe.
8. **Onboarding-Unterzeile.** Nur Platz vorsehen (wie beauftragt); soll ich die Zeile bis zum Text-Paket ausblenden (Empfehlung) oder
   mit dem heutigen Satz belassen?

## Umsetzungsstand (12.11.2026)

Branch `claude/oberflaeche-aufraeumen-20261112` (Worktree `C:\TOOLS\workspace\mojo_aufraeumen`), je Bildschirm ein Commit. Nicht
zusammengeführt, nicht gebaut, nicht veröffentlicht. Vorher/Nachher: `build/aufraeumen/vorher` und `build/aufraeumen/nachher`.

| # | Bildschirm | Ergebnis | Abweichung vom Konzept |
|---|---|---|---|
| 1 | Heute | Bild 92 pt (Spicy 168 pt), Profil-Symbol nur auf Heute oben; „Für heute“ und Check-in ohne Scrollen sichtbar | |
| 2 | Paar-Kanal | beschriftete Chips „Gemeinsamer Abend“ und „Fantasie-Landkarte“ | Die leere Karte war `PartnerProfilePrompt`: Randfarben mit Radius lösen in der Debug-Version eine Assertion aus, die Karte blieb leer. Jetzt `VpKarte`. Zusätzlich: Karte „Eure erste Woche“ steht erst ab 900 pt Höhe über den Reitern (sonst in „Gemeinsam entdecken“), Profil-Nachfrage erst bei genug Platz, Chips einzeilig scrollbar |
| 3 | Fantasie-Landkarte | Zähler und Filter eine Leiste, Infokasten klappt nach dem ersten Besuch ein (`ynmInfoGesehen`), Kategoriebild 72 pt | Ursache des abgeschnittenen Titels war nicht der Titel, sondern die Reiter mit Symbol über dem Text (72 pt in 48 pt Platz). Reiter jetzt 40 pt, Titel einzeilig |
| 4 | Lektion | Eyebrow „Lektion · 6 Min.“ einzeilig, Kurstitel nur in der Leiste | |
| 5 | Player und Wiedergabe | Knopf zuerst, Aufnahme-Hinweis klein und nur wenn nötig, „1:24 von 6:00“, „Teil 2 von 3“ nur bei mehreren Teilen, Titelfläche statt leerer Seite | Im Diskretions-Modus zeigt die Seite nie das Szenenbild |
| 6 | Üben | Programm und Einstellungen als zwei aufklappbare Zeilen, Kreis vollständig und eingepasst | Obere Reiter-Reihe bleibt (Körper, Gedanken; der Coach ist in `main` schon entfernt) |
| 7 | Lernen | ganze Schwerpunkt-Kopfzeile tippbar, 48-pt-Pfeil; Filterleiste läuft rechts aus | |
| 8 | Onboarding | „Überspringen“ / „Skip“, Platz für die Unterzeile | Altlast behoben: Hallo-Titel im Profil lief bei großer Schrift über |
| 9 | Lesbarkeit | `tinteStumm` dunkler (Papier `5C5850`, Nachtpapier `B8B3A7`, Spicy `BBA5AB`), Eyebrow 12 pt in `tinteLeise`, Beschriftung 13 pt; Test verlangt 5,5 : 1 | |

Geprüft: `flutter analyze` ohne Befund, `flutter test` grün (einschließlich `backup_merge_test`, `security_test`, Kontrast- und
Übersetzungstests), Layout-Läufe ohne Überlauf in Papier, Nachtpapier und Spicy bei Skala 1,0 und 1,6 (360 × 640) sowie Skala 1,3
(390 × 844). Testbilder sind **kein** Gerätetest. Bekannte Grenze: Bei Skala 1,6 auf 360 × 640 kürzt die Leiste auf Heute den
Titel („Heu…“), weil nun vier Symbole neben dem Titel stehen.

## Entwurf „Was ist neu“ (Build-Nummer offen, erst beim Release eintragen)

- Heute: Das Titelbild ist niedriger, dein Tagesimpuls steht ohne Scrollen da; das Profil sitzt oben neben Suche und Hilfe.
- Fantasie-Landkarte: Die Erklärung klappt nach dem ersten Besuch ein, Zähler und Filter sind eine Leiste.
- Player: Abspielknopf zuerst, Zeit als „1:24 von 6:00“.
- Üben: Programm und Einstellungen klappen bei Bedarf auf, der Kreis passt immer auf den Bildschirm.
- Kleine graue Zeilen sind besser lesbar.
