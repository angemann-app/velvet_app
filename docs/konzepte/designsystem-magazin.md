# Konzept: Designsystem „Magazin“ (Papier, Graphit, Rosé)

Stand: Entwurf vom 31.10.2026, **nicht abgestimmt**. Baut auf `redesign-bleistift.md` auf und ersetzt dessen offene Entscheidungen
durch die unten stehenden. Bis zur Abstimmung wird nichts am Code geändert.

## 1. Bewertung des Ist-Stands

### Was bereits gut trägt

- **Vier Bereiche** (Heute, Lernen, Üben, Wir) mit klarer Aufgabenteilung; Sprungziele laufen zentral über `_navigateToTab`.
- **Zentrale Farben mit Spicy-Umschaltung:** `AppTheme` liefert alle Farben als Getter, die am Spicy-Modus hängen; der Neuaufbau
  über `SpicyModus.neuAufbauen` funktioniert. Das ist die richtige Grundlage, um eine dritte Palette einzuziehen.
- **Bildsprache:** Graphit-Linien, Raster, Kreuzmarken und Konstruktionsbögen in den SVG-Titelbildern (`assets/images/ver_*.svg`,
  `cover_*`, `guided_*`) sind genau das gewünschte „technische Markierungs“-Motiv und schon ein Platzhalter-System.
- **Eyebrow-Zeile** („DEIN NÄCHSTER SCHRITT“, „KURSE NACH SCHWERPUNKTEN“): Versalien, gesperrt, gedämpft. Das ist ein
  redaktionelles Element, das bleiben und zur Komponente werden soll.
- Karten mit dünnem Rand statt Schatten; Fortschritt unaufdringlich; Datenschutz-Hinweis („Bleibt auf deinem Handy“) gut platziert.

### Inkonsistenzen (belegt)

| # | Befund | Beleg |
|---|---|---|
| 1 | **Normal ist dunkel** (Graphit `1D1F22`), das Briefing verlangt helle Papier- und Elfenbeintöne. | `app_theme.dart:13` |
| 2 | **Mehr als ein Akzent:** Rosé (Button), Gold/Sand (Navigation, Check-in-Rahmen, Tabs, Senden), Rot-Rosa `F43F5E` (Play-Knöpfe, SOS, Avatar), dazu Grün, Blau, Smaragd. Das Konzept sah *einen* Akzent vor. | Screens `01_kurse`, `04_paarkanal_verbunden`; 524 Zugriffe auf `sageGreen/amber/rose` |
| 3 | **Namen lügen:** `sageGreen` ist Rosé, `amber` ist Sand. Wer dort neu schreibt, wählt nach dem Namen, nicht nach der Rolle. | `app_theme.dart:17,20` |
| 4 | **Serif greift kaum:** nur `headline*` und `titleLarge` im `TextTheme`; Bildschirme setzen eigene `TextStyle` (rund 260 Stellen in 60+ Dateien), „Heute“, „Hallo, Alex“, Kartentitel sind Sans, fett. Die Typohierarchie existiert nicht. | `app_theme.dart:32`, `main_navigation_screen.dart:121` |
| 5 | **Nur Farben sind zentral.** Abstände, Radien (250 × `BorderRadius.circular` mit 8 bis 24), Linienstärken, Textstile und Kartenvarianten sind es nicht. | Suche über `lib/` |
| 6 | **Fremde Festfarben:** Smaragdgrün für Ja (`10B981`, `064E3B`), Blau `38BDF8`, Pink `FB7185` für Kategorien, `Colors.black/white` auf Knöpfen, `0xFF022C22`, `0xFF0F172A`. | `yes_no_maybe_screen.dart`, `courses_screen.dart:321,405,635,641`, `lesson_detail_screen.dart:531`, `pairing_modal.dart` |
| 7 | **Spicy ist Effekt statt Welt:** Flammen-Symbol in der Leiste, rotes Glühen mit 18 Funken (`SpicyAtmosphaere`, `E11D48`), Verlauf in der AppBar, Flamme am „Funke“-Chip, Emojis (🔥🌿🌸) in Chips und Schnellantworten. Das ist die Feuer-Ästhetik, die das Briefing ausschließt. Die Palette (Weinrot) ist dagegen ein guter Anfang, nur zu knallig (`EE8497`, `FF4D6D`). | `spicy_atmosphaere.dart`, `main_navigation_screen.dart:101-115` |
| 8 | **Karte in Karte:** Auf „Lernen“ liegt jede Kurskarte in einer Schwerpunktkarte (zwei Rahmen, große Rundung), das Vorschaubild ist eine kleine dunkle Kachel. Wirkt eher wie Einstellungsliste als wie Magazin. | `01_lernen.png` |
| 9 | **„Heute“ ist ein Dashboard:** Nächster Schritt, zwei Umschalt-Chips, Check-in-Karte, Banner „Aufnahmen laden“, Audio-Kopf, Karussell: sechs Blöcke, alle gleich laut, alle gerahmt. | `01_kurse.png` |
| 10 | **Bildverwaltung verstreut:** Pfade stecken in den Inhalts-JSONs, `spicyBild()` schaltet per Regex auf `_spicy.svg` um, vier weitere `Image.asset`-Stellen, Pakete (`kurse-bilder-spicy`) mit eigenen Pfaden. Fehlt ein Bild, entsteht eine leere dunkle Kachel. | `spicy_bild.dart`, `lesson_detail_screen.dart:72ff`, `courses_screen.dart:577` |
| 11 | Wir: eigene Blase mit Rosa-Verlauf (hell, laut), Gegenüber-Blase mit Skizzenrand, Kopfleiste in dritter Fläche, Gold-Akzent für Senden. Funktional gut, atmosphärisch ein Standard-Messenger. | `04_paarkanal_verbunden.png` |

Nicht ausgewertet: „Üben“ (Körper, Gedanken, Coach), Player, Dialoge, Onboarding im Einzelnen. Das geschieht in Stufe 5 und 6 anhand der gerenderten Screens.

## 2. Zielbild

**Eine Markenwelt, drei Stimmungen, ein Token-Satz.**

| | Papier (Normal, Standard) | Nachtpapier (Normal, dunkel) | Spicy |
|---|---|---|---|
| Fläche | warmes Elfenbein `F6F0E6`, Karten `FBF7F0` | heutiges Graphit, nur sprachlich bereinigt | tiefes Bordeaux-Pflaume `22121A`, Karten `2E1822` |
| Text | Graphit `2A2A2C` / `5A5750` | Papierweiß | warmes Papierweiß mit Rosé-Stich |
| Linie | Graphit 25 % | Graphit hell | Altrosa 30 % |
| Akzent | gedecktes Altrosa `C98A93` (sparsam) | `D9A3AB` | Altrosa kräftiger `D07A8E`, Pflaume `7B3F5E` als Tiefe |
| Tiefe | Papierkorn (statisch, billig), keine Schatten | wie Papier | weiche Vignette statt Glühen, mehr Graphitschattierung in Bildern |

Ein Akzent (Altrosa), Gold entfällt als Markenfarbe, Rot bleibt **nur** für SOS und Fehler. Status (Ja/Vielleicht/Nein) bekommt
gedämpfte Töne im Token-Satz (Salbei, Sand, Altrosa-grau), kein Smaragd.

## 3. Technische Architektur

### 3.1 Tokens (zentral, `lib/theme/`)

Neue `ThemeExtension` `VpTokens` plus die bestehenden `AppTheme`-Getter als Alias (nichts bricht):

- **Farben nach Rolle:** `papier`, `papierErhoben`, `tinte`, `tinteLeise`, `tinteStumm`, `linie`, `linieStark`, `akzent`, `akzentTief`,
  `signal` (SOS), `statusJa/Vielleicht/Nein`. Die alten Namen (`sageGreen` …) bleiben als `@Deprecated`-Alias, später per Umbenennung
  (mechanisch, OpenCode-tauglich) abgelöst.
- **Abstände:** 4 / 8 / 12 / 16 / 24 / 32 / 48. **Radien:** 6 (Chip, Feld), 10 (Karte), voll nur für Play- und Avatar-Kreise (weniger
  rund = magazinhafter). **Linien:** Haar 0,8, Rahmen 1,2.
- **Typografie:** mitgelieferte Serif (Vorschlag Source Serif 4, zwei Schnitte, OFL, etwa 300 KB) für Anzeige, Überschrift, Zahl;
  Fließtext bleibt Systemschrift. Stile: `anzeige`, `ueberschrift`, `titel`, `fliesstext`, `eyebrow`, `beschriftung`, `zahl`. Bildschirme
  lesen sie über `Theme.of(context).textTheme` bzw. `context.vp`, nicht mehr über eigene `TextStyle`.
- **Marker:** Kreuzmarke, Eckmarke, Maßlinie als kleine wiederverwendbare Maler (`CustomPainter`), ohne Bilddateien.

### 3.2 Komponenten

Wiederverwendbar (nur umhäuten, Logik bleibt): `audio_player_card`, `gefuehrte_audios`, `daily_checkin_card`, `daily_simmering_card`,
`aufnahmen_karte`, `update_dialog`, `backup_dialogs`, `lautsprecher_frage`, `app_lock`, Navigationsrahmen.

Neu (klein, in `lib/widgets/design/`):

| Baustein | Zweck |
|---|---|
| `VpSeite` | Papierfläche, optional feines Raster/Korn; ersetzt `SpicyAtmosphaere` |
| `VpAbschnitt` | Eyebrow + Serif-Titel + Haarlinie (Maßlinie), Ersatz für die Kartenköpfe |
| `VpKarte` | Varianten `flach` (nur Haarlinie), `gerahmt` (Eckmarken), `hervorgehoben` (Akzentlinie) |
| `VpListenzeile` | Nummer in Serif, Titel, Meta, Bildfeld rechts; für Kurse, Lektionen, Audios |
| `VpFortschritt` | dünne Linie mit Teilstrichen statt runder Balken |
| `VpChip` | Linien-Icon statt Emoji |
| `VpBildFeld` | siehe 3.3 |

Buttons, Eingabefelder, Dialoge, Bottom Sheets, Slider, Schalter, Navigationsleiste: **nur über das Theme** (`ThemeData`-Erweiterung),
ohne Eingriff in die Bildschirme.

### 3.3 Zentrale Bildverwaltung (ja, sinnvoll)

- **Registerdatei** `assets/data/bilder.json`: `id → { format, normal, spicy, quelle (asset|paket), alt_de, alt_en }`.
  IDs sprechend: `kurs.01.titel`, `lektion.03.02.studie`, `audio.einschlafen.cover`, `bereich.heute.einladung`, `wir.kopf`.
- **Vier Formate:** `marke` (1:1, Listen), `kopf` (3:2, Kartenkopf), `studie` (16:9, Lektion, wie die vorhandenen Bleistift-Studien),
  `hoch` (3:4, Praxis/Einladung). Antigravity bekommt je Auftrag ID und Format, mehr nicht.
- **`VpBildFeld(id)`** löst auf: Paket (Spicy, R2) → Asset → **Platzhalter**. Der Platzhalter ist deterministisch aus der ID
  gezeichnet (Raster, Kreuzmarken, Konstruktionsbogen, ggf. Kursnummer in Serif) in den aktuellen Tokenfarben, also nie eine leere Fläche.
  Das vorhandene Generator-Skript `tools/generate_covers.py` liefert die Motive; der Platzhalter wird in Dart nachgebaut, damit er
  auch in Papier und Nachtpapier passt.
- Neue Bilder landen nur noch in Registerdatei und Asset/Paket, **kein Bildschirm ändert sich**. `spicyBild()` wird zur Auflösungsregel
  im Register; Spicy-Motive bleiben Paket-only, Diskretions-Modus zeigt neutrale Platzhalter.
- Hell/Dunkel: Die bisherigen SVGs sind für dunklen Grund gezeichnet. Für Papier die Linienfarbe über die Token einfärben
  (`ColorFilter`/SVG-Variable) statt Dateien zu verdoppeln; Bleistift-Studien (WebP) bekommen ein Papier-Passepartout.

## 4. Die vier Bereiche

- **Heute:** Datum und Begrüßung als Serif-Anzeige, *eine* Einladungskarte (Nächster Schritt, Bildfeld `bereich.heute.einladung`),
  darunter ein leiser Satz für Check-in/Funke statt zweier Chips plus Karte, Banner und Audio-Köpfe als Abschnitte mit Haarlinie.
  Alles Untergeordnete ruhiger und kleiner.
- **Lernen:** Redaktionsliste. Schwerpunkt = Abschnittskopf (Eyebrow + Serif + Haarlinie), Kurs = `VpListenzeile` mit Nummer, Titel,
  Teaser, Fortschrittslinie, Bild rechts. Eine Rahmenebene statt zwei.
- **Üben:** Körper, Gedanken, Coach als gemeinsame Kapitelleiste (Nummer + Linie), dieselben Listenzeilen, Bedienung unverändert.
- **Wir:** wie ein Briefpapier-Raum. Warme Papierfläche, Kopf mit Namen in Serif, eigene Blase in getöntem Altrosa ohne Verlauf,
  Gegenüber auf Papier mit Haarlinie, Senden in Akzent statt Gold, kein Rot außer Fehler.
- **Übergreifend:** Player (Wellenlinie als Fortschritt, Graphit), Dialoge (Papier, Haarlinie, Serif-Titel), Formulare, Onboarding
  (Serif-Anzeige, Bildfeld je Seite) folgen allein aus Theme und Komponenten.

## 5. Spicy ohne Glühen

Raus: Flammen-Symbol in der Leiste, `SpicyAtmosphaere` (Glühen, Funken), Verlauf in der AppBar, Flamme im „Funke“-Chip (stattdessen
Linien-Symbol), Emoji-Chips. Rein: Bordeaux-Pflaume-Palette, gedecktes Altrosa, kräftigere Graphit-Schraffur in den Bildern, weiche
Vignette als einzige Tiefe, ausdrucksstärkere Studien aus dem Paket. Erkennbar am Ton, nicht an Effekten; die Leiste zeigt weiter
neutral (Diskretion), nur etwas dunkler.

## 6. Priorisierung (Wirkung / Aufwand)

| Stufe | Inhalt | Wirkung | Aufwand | Bilder nötig? |
|---|---|---|---|---|
| 1 | Tokens, Serif-Schrift, Papier-/Nachtpapier-/Spicy-Palette, Theme für Karten, Buttons, Felder, Dialoge, Navigation; `AppTheme`-Alias | sehr hoch (alles sofort) | mittel | nein |
| 2 | Festfarben und Emojis ersetzen, Spicy-Effekte entfernen (`SpicyAtmosphaere` → `VpSeite`) | hoch | gering, mechanisch | nein |
| 3 | `VpBildFeld`, Register, Platzhalter, vorhandene 4 `Image.asset`-Stellen und `spicyBild()` umstellen | hoch (Bildlücken unsichtbar, spätere Bilder ohne Screenarbeit) | mittel | nein |
| 4 | **Pilot:** Heute und Kurs 1 neu komponiert (`VpAbschnitt`, `VpKarte`, `VpListenzeile`) | hoch | mittel | nein |
| 5 | Lernen, Üben, Wir | mittel bis hoch | mittel | nein |
| 6 | Player, Onboarding, Einstellungen, Dialoge nachziehen | mittel | mittel | nein |
| 7 | Kontrastprüfung (WCAG AA als Test über alle Token-Paare), Schriftskalierung, Anleitung, „Was ist neu“, Screenshots | Pflicht | gering | nein |

Jede Stufe läuft auf eigenem Branch, die Stufen 1 und 2 sind unabhängig von jedem Bild. Gerendert wird mit
`test_screens/screens_test.dart` für alle drei Paletten. Die nächste Beta kommt wie vereinbart erst nach den Pilotbildern; das Design
wird bis dahin hinter einer Option „Klassisches Design“ gehalten.

## 7. Risiken

- Das Hell-Theme deckt versteckte Dunkel-Annahmen auf (98 × `Colors.*`, weiße Texte auf Bildern): Stufe 2 räumt zuerst auf.
- Kontrast Altrosa auf Papier ist knapp: Akzent nur für Flächen und große Elemente, Text immer Graphit.
- Wer die dunkle App gewohnt ist, bekommt eine andere: Nachtpapier bleibt wählbar, optional automatisch abends.
- Schrift: etwa 300 KB mehr in der APK.
- R8 bleibt aus, keine Datenformate betroffen; Sicherung/Backup unverändert (Einstellung „Design“ kommt als neues Feld in
  `StorageService` und Backup-Merge).

## 8. Entscheidungen (offen)

1. Standard **Papier (hell)**, Nachtpapier als Option und optional automatisch ab Abend? Empfehlung: ja.
2. Spicy **dunkel** (Bordeaux-Pflaume) als Gegenpol? Empfehlung: ja, weil es die Abendstimmung trägt.
3. Serif **Source Serif 4** mitliefern? Empfehlung: ja.
4. Emojis in Oberflächenelementen (Chips, Kategorien) durch Linien-Icons ersetzen? Empfehlung: ja. Nachrichten-Emojis der Nutzer bleiben.
5. Rundungen reduzieren (Karte 16 → 10)? Empfehlung: ja.
6. Option „Klassisches Design“ bis zum stabilen Release? Empfehlung: ja.
7. Pilot: Heute und Kurs 1 (Stufe 4)? Empfehlung: ja.

---

# Nachtrag vom 01.11.2026: Freigabe mit Präzisierungen und Umsetzungsplan

Die Richtung ist freigegeben, die Entscheidungen 1 bis 7 gelten wie empfohlen. Dieser Nachtrag hält fest, was übernommen ist, was
technisch trägt, was Risiko ist, und wie Stufe 1 bis 4 laufen. **Es gibt noch keinen Code; Start erst nach Freigabe dieses Nachtrags.**

## 9. Übernommene Entscheidungen (Bestätigung)

- Drei Atmosphären auf einem Token-Satz: **Papier** (Standard), **Nachtpapier** (dunkle Lesart derselben Gestaltung), **Spicy**
  (eigene Dramaturgie, nicht nur dunklere Farben). Dazu **Klassisch** als vierte, nur übergangsweise wählbare Palette (heutige Farben).
- Ausgangswerte Papier: `F6F0E6`, Karten `FBF7F0`, Text `2A2A2C` / `5A5750`, Akzent `C98A93`; Werte werden nach Kontrasttest und
  Augenschein nachgestellt. Rollenbenennung nach Funktion; alte Getter bleiben als Übergangs-Alias, mit `@Deprecated`.
- `VpTokens` (ThemeExtension), Source Serif 4, Komponenten `VpSeite`, `VpAbschnitt`, `VpKarte`, `VpListenzeile`, `VpFortschritt`,
  `VpChip`, `VpBildFeld`; Bildregister `assets/data/bilder.json`, Formate `marke` 1:1, `kopf` 3:2, `studie` 16:9, `hoch` 3:4.
- Auflösung: Spicy-Bild (wenn Modus an und Paket da) → reguläres Asset → erzeugter Platzhalter; nie leer oder schwarz.
- **Neu:** zentrale grafische Asset-Bibliothek (Abschnitt 13), im selben Register geführt.
- Spicy: keine Flammen, Funken, Feuer-Emojis, Glow. Vignette erlaubt. Spicy bekommt eine eigene Komposition je Bildschirm (Abschnitt 12).
- Grenzen: Navigation, 27 Kurse, Audio/Offline, Daten, Paarkanal, Backup unverändert. Eigener Branch, nichts auf `main`.

## 10. Technische Einschätzung

**Direkt umsetzbar (Stufe 1 und 2):**
- `AppTheme` ist schon der einzige Farbzugang (rund 1.340 Zugriffe), die Getter lösen über `StorageService.spicyMode()` auf. Eine
  Paletten-Auswahl (`papier | nacht | klassisch`, Spicy bleibt der bestehende Schalter und hat Vorrang) lässt sich an derselben Stelle
  einhängen. Neuaufbau beim Umschalten existiert (`SpicyModus.neuAufbauen`, `spicyAenderung`).
- `main.dart:154` kennt nur `AppTheme.darkTheme`; die Systemleisten (`main.dart:31`) sind fest auf dunkel. Es braucht einen
  `ThemeData`-Bauer je Palette mit `Brightness.light/dark` und passenden Statusleistensymbolen.
- Eingabefelder, Karten, Buttons, Navigation sind schon im Theme; Dialoge, Bottom Sheets, Slider, Schalter, Chips, Snackbars,
  Fortschritt, Tabs fehlen und kommen dazu. Das erledigt den größten Teil der „restlichen App“ (Abschnitt 6 im Auftrag) ohne Eingriff
  in die Bildschirme.
- Source Serif 4: OFL, Einbindung über `pubspec.yaml` (`fonts:`), offline, zwei bis drei Schnitte (Regular, SemiBold, Italic) rund
  300 bis 450 KB; Lizenztext in die App-Lizenzen. Die heutige Zuweisung `fontFamily: 'serif'` entfällt.

**Braucht Vorarbeit:**
- Rund 98 × `Colors.*` und 48 feste Hex-Werte (u. a. `yes_no_maybe_screen`, `courses_screen`, `lesson_detail_screen`, `pairing_modal`,
  `cbt_new_entry_screen`, `ai_coach_screen`) kippen im Hellmodus. Ausnahmen mit Sinn bleiben: QR-Code (Schwarz auf Weiß), Vollbild-Foto
  (Schwarz).
- Die vorhandenen SVGs (20 × `ver_*`, `cover_*`, `guided_*`, `ynm_*`) sind für dunklen Grund gezeichnet. `flutter_svg` ≥ 2.0.8 bietet
  einen `ColorMapper`; damit lassen sich Linie und Fläche je Palette umfärben, ohne Dateien zu verdoppeln. Vorher an zwei Dateien
  prüfen; Rückfall: Generator `tools/generate_covers.py` mit Papierpalette erneut laufen lassen.
- **Entwurf der Spicy-Dramaturgie** braucht gerenderte Vergleiche, kein reines Rechnen (Abschnitt 12).
- **Backup:** Das Feld `spicy_mode` taucht in `StorageService` nicht in einer erkennbaren Sicherungsliste auf. Vor Stufe 1 klären,
  wie Einstellungen in Backup und `backup_merge_test` geführt werden, und die neue Einstellung `design_palette` genauso einhängen
  (Regel aus `CLAUDE.md`).
- **Tests erweitern:** `test_screens/screens_test.dart` kennt nur `SPICY=true`; ergänzen um `PALETTE=papier|nacht|klassisch`, `TEXTSCALE`
  und weitere Größen.

**Noch nicht entscheidbar:** Welche Spicy-Studien (Paket `kurse-bilder-spicy`) für den Pilot nutzbar sind, und wie weit
Antigravity bis zum Pilot liefert. Der Pilot läuft deshalb mit Platzhaltern und tauscht Bilder später ohne Codeänderung.

## 11. Risiken und nötige Anpassungen

| Risiko | Gegenmaßnahme |
|---|---|
| Kontrast Altrosa `C98A93` auf Papier ≈ 2,6 : 1, zu schwach für Text | Akzent nur für Flächen, Linien, große Elemente; Text immer `tinte`; Test über alle Token-Paare (AA 4,5 : 1 Text, 3 : 1 große Elemente); `akzentTief` für kleine Akzenttexte |
| Altes Dunkel-Verhalten versteckt in 10 Dateien | Stufe 2 räumt vor dem Hellmodus auf; Suche nach `Colors.` und `Color(0x` als Prüfung |
| Spicy wirkt nur wie „dunkleres Papier“ | eigene Komposition je Seite (Abschnitt 12), Vergleich im Pilot ist Abnahmekriterium |
| Platzhalter wirken billig | deterministisch aus ID, aber aus kuratierten Bausteinen (Abschnitt 13), im Pilot beurteilt |
| Serif-Schrift bricht Zeilen, Umbrüche in langen deutschen Titeln | Schriftskala 1,0 / 1,3 / 1,6 im Test, Überläufe meldet `screens_test` |
| Paralleler Zugriff (Nebensitzungen, Antigravity) | eigener Worktree, Sperrliste in `docs/AUFGABEN.md` für `lib/theme/`, `lib/widgets/`, Kernbildschirme |
| APK-Größe, Ladezeit | Schrift 2 bis 3 Schnitte, Papierkorn als kleine Kachel, SVGs statt großer Bitmaps, `RepaintBoundary` |
| Nutzer verliert Daten durch Designwechsel | nur eine neue Einstellung, kein Datenformat berührt; Backup-Test erweitern |
| Diskretion | Platzhalter und Titel im Diskretions-Modus neutral, kein Rosé-Akzent, keine Figuren (wie im Redesign-Konzept) |
| Cloud-Modelle sehen Spicy-Bilder | Spicy-Bewertung durch mich nur an Platzhalter-Screens; die Beurteilung echter Spicy-Studien macht der Nutzer lokal |

## 12. Spicy-Dramaturgie (Entwurf, im Pilot zu bewerten)

Spicy ändert nicht nur Farben, sondern Komposition. Konkret je Bildschirm, als Parameter im Token-Satz (`VpTokens.dramaturgie`):

| Merkmal | Papier / Nachtpapier | Spicy |
|---|---|---|
| Bildfeld Heute | `kopf` 3:2, oben, mittlere Höhe | `hoch` 3:4 bis zum Rand, Text überlappt unten auf Vignette |
| Anzeige-Typo | Serif Regular, mittlere Größe | größer, Serif Italic für die Begrüßung |
| Weißraum | großzügig | dichter, mehr Dunkelfläche um Text |
| Linien | Graphit-Haarlinie | Altrosa-Haarlinie, Eckmarken stärker |
| Platzhalter | Raster, dünne Bögen | dichte Schraffur, Vignette, ein anatomischer Umriss als Linienmotiv |
| Bildauswahl | Anatomie, Stillleben, Diagramme | Paket-Studien, Figuren, wo vorhanden |
| Rhythmus | gleichmäßig | weniger Elemente je Bildschirm, größere Abstände zwischen Abschnitten |

## 13. Grafische Asset-Bibliothek

Alles zentral in `assets/grafik/` plus Abschnitt `grafik` in `assets/data/bilder.json`, Zugriff nur über `VpGrafik(id)`; Bildschirme
nennen nie Pfade. Als Linien-SVG mit Rollenfarben (Tinte, Linie, Akzent), damit sie in allen Paletten stimmen. Wo möglich in Dart
gezeichnet (kein Asset, kein Bildwunsch).

| ID | Inhalt | Format | Einsatzort | Herkunft |
|---|---|---|---|---|
| `marke.kreuz`, `marke.eck` | Kreuz- und Eckmarken | Painter | `VpKarte` (gerahmt), `VpBildFeld`, Heute | Code |
| `linie.mass` | Maßlinie mit Endstrichen | Painter | `VpAbschnitt`, Trenner, Fortschritt | Code |
| `linie.haar`, `linie.doppel` | Haarlinien, Doppellinie | Painter | Trenner in Listen | Code |
| `raster.fein`, `bogen.konstruktion` | Raster, Konstruktionsbögen | Painter | Platzhalter, leere Bereiche, Hintergrund Heute | Code (Generator liefert Motive) |
| `rahmen.passepartout` | Passepartout um Bleistift-Studien | Painter | Lektion, Heute, Kursbilder | Code |
| `papier.korn` | Papiertextur, kachelbar 256² WebP | WebP | `VpSeite` Papier und Spicy | einmal erzeugt, ca. 10 KB |
| `vignette` | weiche Randabdunkelung | Painter | `VpSeite` Spicy, Hero-Bild | Code |
| `anatomie.achse`, `.wirbel`, `.becken`, `.atem` | abstrakte Orientierungslinien | SVG | Platzhalter, Kapitelköpfe, Üben-Bereiche | einmal gezeichnet (Antigravity oder OpenCode aus bestehenden Motiven) |
| `trenner.lotus`, `trenner.ranke` | kleine redaktionelle Trenner | SVG | Abschnittsenden, Lernen | einmal gezeichnet |
| `leer.tagebuch`, `.favoriten`, `.fehler`, `.laden` | ruhige Hintergründe für Leer-, Fehler-, Ladezustand | SVG | Tagebuch, Favoriten, Fehlerseiten, Ladeanzeige (Linie zeichnet sich) | einmal gezeichnet |

**Illustrationen** (Antigravity, nur diese sind zeitkritisch; Platzhalter überbrücken alle):

| ID (Vorschlag) | Format | Einsatzort | Stufe |
|---|---|---|---|
| `bereich.heute.einladung` (+ `_spicy`) | `hoch` | Heute | Pilot, später tauschbar |
| `kurs.01.titel` | `kopf` (+ `marke` abgeleitet) | Kurs 1 in Lernen und Kursdetail | Pilot |
| `lektion.01.*.studie` | `studie` | repräsentative Lektion in Kurs 1 | Pilot |
| `kurs.02` bis `kurs.27` | `kopf` | Lernen, Kursdetails | Stufe 5 |
| `onboarding.1` bis `.5` | `hoch` | Onboarding | Stufe 6 |
| `wir.kopf` | `kopf` | Wir | Stufe 5 |
| `ueben.koerper`, `.gedanken`, `.coach` | `marke` | Üben | Stufe 5 |

Vorhandene Bilder bleiben und werden dem Register zugeordnet (Bestandsübernahme in Stufe 3); es muss kein Bild neu entstehen, bevor der
Pilot läuft.

## 14. Umsetzungsplan Stufe 1 bis 4

**Vorbereitung:** eigener Worktree und Branch `design-magazin` (Nebensitzungen teilen den Ordner), Sperrliste in `docs/AUFGABEN.md`,
Backup-Frage klären. Tag je Stufe (`magazin-stufe-N`), damit jede einzeln prüfbar und zurücknehmbar ist.

| Stufe | Arbeit | Dateien (Kern) | Abnahme |
|---|---|---|---|
| 1 Fundament | `VpTokens` + `VpPalette` (papier, nacht, klassisch, spicy), Typografie, `ThemeData`-Bauer je Palette, Alias in `AppTheme`, Einstellung `design_palette` (Speicher + Backup), Schalter in Einstellungen, Schrift und Lizenz | `lib/theme/*`, `main.dart`, `StorageService`, `pubspec.yaml`, ARB | App startet in allen vier Paletten ohne Funktionsänderung; Token-Kontrasttest grün; `screens_test` je Palette ohne neue Überläufe |
| 2 Bereinigung | Hex- und `Colors.*`-Stellen auf Tokens, Emojis in Oberflächenelementen auf Linien-Icons, `SpicyAtmosphaere` und Flammen entfernen, Vignette-Ersatz, Funke-Chip-Symbol | rund 10 Dateien, `spicy_atmosphaere.dart` | Suche findet keine Altwerte; Spicy ohne Glühen; Tests grün |
| 3 Bildsystem | `bilder.json`, `BildRegister`, `VpBildFeld`, `VpGrafik`, Platzhalter, `spicyBild()` abgelöst, bestehende Pfade und vier `Image.asset`-Stellen umgestellt; Test: jede ID löst auf, kein Pfad fehlt, Alt-Texte de/en | `lib/services`, `lib/widgets/design`, `assets/data`, `test/` | kein leeres Bildfeld in `screens_test`; Registertest grün |
| 4 Pilot | `VpSeite`, `VpAbschnitt`, `VpKarte`, `VpListenzeile`, `VpFortschritt`, `VpChip`; **Heute**, **Kurs 1 in Lernen**, **Kursdetail**, **eine Lektion** komplett neu komponiert, in Papier, Nachtpapier, Spicy | `courses_screen.dart`, `lesson_detail_screen.dart`, Widgets für Heute | Pilotbewertung (Abschnitt 15) |

Mechanische Teile (Stufe 2 Ersetzungen, Registerbefüllung, Bildformat-Prüfungen) kann ich an OpenCode abgeben, jeweils mit Prüfbefehl
und eigener Durchsicht des Diffs. Komposition, Spicy-Dramaturgie und alles Visuelle mache ich selbst. Kein Spicy-Motiv geht an Cloud-Modelle.

## 15. Pilotbewertung mit Screenshots

- **Matrix:** Heute, Lernen mit Kurs 1, Kursdetail, Lektion × Papier, Nachtpapier, Spicy (Klassisch nur zum Vergleichen) × de.
  Aufnahme über `screens_test` mit `PALETTE`, `SPICY`, `TEXTSCALE` (1,0 / 1,3 / 1,6) und Größen 360 × 640, 390 × 844, 430 × 932.
- **Kontaktbogen:** ein Skript legt je Bildschirm die drei Atmosphären nebeneinander, dazu die Zeile „vorher“ (heutiger Stand). Ergebnis
  in `build/pilot/`, damit der Nutzer im Ganzen urteilt statt Bild für Bild.
- **Bildzustände:** je einmal mit Platzhalter und, soweit vorhanden, mit echtem Asset, damit sichtbar ist, dass der Tausch ohne
  Bildschirmänderung klappt.
- **Bewertungsbogen** nach Abschnitt 8 des Auftrags (Hierarchie, Bild-Text-Verhältnis, Proportion, Weißraum, Rhythmus, Wiedererkennbarkeit,
  Anmutung), 1 bis 5 je Kriterium und Atmosphäre, plus harte Messwerte: Kontrasttest, Überläufe, Anzahl Rahmen je Bildschirm (Ziel: weniger
  als heute), Zahl fester Werte (Ziel: null neue).
- **Gerät:** zusätzlich ein Debug-Build auf dem Handy für Echteindruck von Papierkorn, Serif und Vignette; keine Beta vor den Pilotbildern.
- **Entscheidung nach dem Pilot:** Palettenwerte und Spicy-Dramaturgie nachziehen, dann erst Stufe 5.

## 16. Offen vor dem Start

1. Freigabe dieses Nachtrags (Plan, Worktree, Stufenfolge).
2. Annahme zur Voreinstellung: **Papier** für alle; „Systemeinstellung folgen“ als Option, nicht Standard. Einverstanden?
3. Soll Antigravity vor Stufe 4 die drei Pilot-Illustrationen (`bereich.heute.einladung` normal und Spicy, `kurs.01.titel`) liefern,
   oder wird der Pilot rein mit Platzhaltern bewertet? Empfehlung: Pilot zuerst mit Platzhaltern.
