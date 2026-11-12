# Aufgaben

## Aktuell vorrangig: gezielte Spicy-Neuvertonung vor Claudes Beta

02.11.2026: Neuer Nutzerauftrag Spicy-Ton einschließlich separater Sehr-spicy-Innenansichten und Neuvertonung. Textdurchgang umgesetzt und geprüft; Produktion von 150 regulären Dateien plus 24 Szenendateien erfolgreich abgeschlossen, 174/174 technisch geprüft. Hörstichprobe und Paketübernahme offen. Morgen zuerst Fortschritt/Abschluss prüfen: `docs/redaktion/SPICY_TONDURCHGANG_2026-11-02.md` und `build/redaktion/spicy-ton/nachtlauf.json` / `abschluss.json`. Dann gezielte Paketübernahme, Hörstichprobe und Claudes Beta-Build nach bestehendem Freigabeworkflow. Kein neuer Gesamtlauf und kein Upload durch Codex.

Stand: 27.10.2026. Reihenfolge = Priorität. Erledigtes nach unten unter „Erledigt“ verschieben.
Für jede Aufgabe eine eigene Sitzung und ein eigener Branch.

## Aktuell: Bedienung und gemeinsames Hören

Freigegeben am 02.11.2026, Branch `codex/bedienung-audio-gemeinsam-20261102`, Konzept `docs/konzepte/bedienung-audio-wege.md`. Implementiert: lokale Suche, persönlicher Weg, globaler Player/Mini-Player, genaue Wiederaufnahme des gespeicherten Ablaufs, Offline-/Downloadwege, gemeinsames Hören derselben Fassung und freiwilliger gemeinsamer Rückblick. 419 Tests grün, Analyse ohne Befund; DE/EN und alle Atmosphären sowie kleine/große Displays geprüft. Gemeinsames Hören braucht passende tatsächliche Aufnahmen auf beiden Geräten; keine Geräte-Stimme. **Offen im Team:** Claude baut/veröffentlicht morgen eine Beta für den In-App-Download; erst danach echter Geräte-/Zweigeräte-/Hintergrundtest. Kein USB-/Alpha-Weg. Übergabe `docs/UEBERGABE_BETA_BEDIENUNG.md`, aktuelle Belege `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md`. Keine APK und keine Veröffentlichung durch Codex.

## 0b. SOS neu: Rest (Konzept: docs/konzepte/sos-neu.md)

Offen: Test am Gerät (Anrufen mit `tel:`, „Schnell verlassen“, große Schrift), „Was ist neu“-Eintrag beim Release, Nummern vor jedem Release erneut prüfen (Schweizer Notrufe 117/144, RAINN-Details und 911 nur indirekt belegt), Text für Menschen, die selbst eine Grenze überschritten haben, Abschnitt nach einem Übergriff (Spurensicherung, Notfallverhütung, PEP; offene Fragen 6 und 7), Stellen für queere Menschen, Männer in Österreich und häusliche Gewalt in UK/USA.

## 1. Lust im Traum: Rest

Weiterentwicklung 01.11.2026 → `docs/konzepte/traumpraxis.md`: persönlicher Übungsweg, dauerhafte Traumzeichen, Abendvorbereitung und privater Tagesrückblick im Codex-Branch implementiert, DE/EN, mit Sicherung und Merge. Renderprüfung beider Sprachen und Formular-/Backup-Tests bestanden. Noch nicht veröffentlicht; echter Gerätetest und Release stehen aus. Keine Behauptung eines nachgewiesenen Lustzuwachses. Aktuelle Übergabe und Prüflogs in `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md`.

Serie, Traumtagebuch und Paket sind gebaut (siehe Konzept, „Umsetzung“). Offen:
- Auf dem Handy testen: Paket laden, Folge 1, Freischaltung, Traumkörper und Gegenüber ab Folge 3.
- Nachfrage vor Lautsprecher-Wiedergabe, Pause beim Abziehen der Kopfhörer → AG-8
- Realitätschecks sichtbarer (Zeile im Traum-Abend und im Tagebuch) → mit AG-8, für die nächste Beta
- Freiwilliges anonymes „Hallo“ (`docs/konzepte/hallo.md`) → AG-9
  (`docs/konzepte/lautsprecher.md`)

## 1b. Heute und Produktschliff (Konzept: docs/konzepte/heute-und-produktschliff.md)

Richtung abgestimmt, Muster gezeigt, offene Fragen am Ende des Konzepts. Stufen: 1 Heute-Seite (Audio-Bereich dauerhaft einklappbar), 2 Kurs-Zeilen mit Titelbildern, 3 SOS-Symbol, 4 Tab-Umbau, 5 KI-Coach-Einstieg und Onboarding.

## 1c. Eine Tonlage, alle Paare (Konzept: docs/konzepte/eine-tonlage.md)

Status: gebaut (Stufen 1 bis 5, Branch `claude/eine-tonlage-20261112`, Anleitung DE/EN nachgezogen), main am 12.11.2026 eingearbeitet; wartet auf Beta und Freigabe des Nutzers. Offene Folgepunkte:
- (a) Bestehender Fehler: Die Whitelist in `backup_codec.dart` enthält vermutlich `kursFilter`, `designPalette`, `audioBereichOffen` nicht (Merge-Tests laufen trivial). Prüfen und beheben.
- (b) SVG-Symbole (Geschlechtsauswahl, Landkarte, Einladung) statt Material-Icons; Abschnitt `symbole` im Bild-Register.
- (c) AG-Bildauftrag → AG-27 (12.11.2026 eingetragen): zunächst vier Motive ohne erkennbares Geschlecht (zu_zweit, erste_woche, einladung_willkommen, heute_einladung); Varianten je Paarform erst, wenn die App sie auswählen kann.
- (d) Gesprochene Lektionstexte mit Frau/Mann neu schreiben (Claude, sechs Lektionen DE/EN, Nutzer liest gegen), danach neu einsprechen → AG-28 (eingetragen, gesperrt bis zur Textfreigabe).
- (e) „Was ist neu“-Eintrag und Build-Nummer vor dem Release.
- (f) Erledigt beim Zusammenführen: Die zwei Texte `onboardingVersprechenNetz` und `onboardingPrivateProfileJournalProgressStay` stehen in der Fassung „ohne Coach“.
- (g) Name „Fantasie-Landkarte“ offen.
- (h) Funke-Kacheln weiter prüfen.

## 2. Pflege: technische Schulden (nach AG-8 und AG-9)

- **Abspieler entflechten:** `einschlaf_reise_screen.dart` trägt Einschlafen, Traum-Abend, Lust im Traum und
  Wecken. Gemeinsamer Abspieler plus schlanke Einrichtungsseiten. Erst wenn AG-8/AG-9 zusammengeführt sind
  (AG-8 ändert diese Datei).
- **Kotlin und Gradle** auf die von Flutter verlangten Versionen heben (Build-Warnungen: Kotlin 2.2.20, Gradle
  8.10.2 älter als das Minimum). R8 bleibt aus. Danach auf dem Handy prüfen.
- CI: Screen-Test läuft, scheitert dort aber (Zeitüberschreitung nach 10 Minuten, vermutlich Netzzugriffe von Nostr/HTTP); bis zur Reparatur nicht blockierend. Netz im Test abschalten bzw. Dienste attrappen.

## 3. Pflege: Inhalte, Schwerpunkt für Schwerpunkt

Je Schwerpunkt (Grundlagen, Annehmen und Lösen, Sich selbst entdecken, Lust als Paar, Berührung, Fantasie und
Spiel) eine Prüfliste: Ton und Länge einheitlich, fachlich aktuell, Englisch gleichwertig, Aufnahmen Deutsch und
Englisch (Stichproben anhören, Aussprache über OpenCode), Anleitung, Handytest. Dazu Startseite: Kurskarten in den
Schwerpunkten kompakter, Check-in und Funke nebeneinander.

## Später

- Schlafdaten-Abgleich: echter Fitbit-Air-/Health-Connect-Import auf Android 15/16 und Berechtigungs-/Löschabläufe am Gerät prüfen. Implementierung im Arbeitsbaum abgeschlossen, Übergabe oben in `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md`. Keine Live-Funktionen.

- Eigene Domain für R2 statt `r2.dev` (bewusst aufgeschoben).
- Stabile Version nach den Handytests (Nutzer testet, Testmodus hilft).
- Fantasie-Räume, Statistik Selbstliebe, NIP-17 Stufe 2 (nach fünf stabilen Versionen).

## Laufend: Aussprache korrigieren (wöchentlich, mittwochs) → OpenCode

Meldungen werden täglich gesammelt, abgearbeitet wird einmal pro Woche am Mittwoch. Claude Code holt die Meldungen, OpenCode pflegt `tools/aussprache.json` und spricht neu ein, Claude prüft und
führt nach dem OK des Nutzers zusammen. Ablauf in `docs/AUSSPRACHE.md` (früher AG-1).

## Erledigt

- 12.11.2026, Claude Code: Oberfläche aufräumen (Konzept `docs/konzepte/oberflaeche-aufraeumen.md`, Branch `claude/oberflaeche-aufraeumen-20261112`, Worktree `mojo_aufraeumen`; nicht zusammengeführt, nicht gebaut): Heute mit niedrigem Titelbild und Profil-Symbol oben, Lernen mit großer Tippfläche und Filter-Auslauf, Paar-Kanal mit beschrifteten Chips (leere Profil-Karte war ein Render-Fehler und ist behoben), Fantasie-Landkarte mit einzeiligem Titel, einklappbarem Infokasten und einer Zähler/Filter-Leiste (neues Feld `ynmInfoGesehen` in Sicherung und Merge), Lektion mit „Lektion · 6 Min.“, Player mit Knopf zuerst und Zeit „1:24 von 6:00“, Wiedergabe-Seite mit Titelfläche, Üben mit aufklappbaren Einstellungen und eingepasstem Kreis, Onboarding „Überspringen“, dunklere kleine Zeilen (Kontrasttest 5,5 : 1). Anleitung DE/EN und Bilder nachgezogen. Layout-Läufe (Papier, Nachtpapier, Spicy, Skala 1,0/1,3/1,6, 360 × 640 und 390 × 844) ohne Überlauf; kein Gerätetest. „Was ist neu“ wartet auf die Build-Nummer (Entwurf im Konzept).
- 12.11.2026, Claude: Schutz der Privatsphäre (`docs/konzepte/privatsphaere-schutz.md`, Branch `claude/privatsphaere-20261112`, nach main zusammengeführt, nicht gebaut): App-Sperre ist Standard bei neuer Einrichtung (mit Bildschirmsperre), Bestand wird einmal gefragt; Spicy-Frist fest 5 Stunden mit einmaligem Hinweis „Spicy-Modus ist aus“ beim Zurückkehren; Fantasie-Hinweis einmal je Gerät (Lust im Traum, Innenansichten, Zusatzsatz bei „Zu dritt“), Merker in Sicherung und Merge. Anleitung „Fantasien sind frei“, App-Sperre-Abschnitt, „Was ist neu“ für Build 65, DE/EN, PO abgeglichen. Tests in `test/privatsphaere_test.dart` und `test/backup_merge_test.dart`; Screens-Test um die fünf Blätter erweitert.

- 12.11.2026, Claude Code: SOS neu (Konzept `docs/konzepte/sos-neu.md`; Branch `claude/sos-neu-20261112`, nach `main` zusammengeführt, nicht gebaut, nicht veröffentlicht): Auswahl „Was ist gerade los?“, sechs Wege für alle Körper (DE/EN), fester Hilfe-Teil mit Anlaufstellen für DE/AT/CH/UK/US (Nummern auf Originalseiten gegengelesen, Stand im Konzept), Symbol „Hilfe“ mit Rettungsring, kein Mantra/Abhaken/KI-Coach-Verweis mehr. Gegenlese durch Therapie und Code eingearbeitet. 506 Tests und Bildschirmtests grün, Analyse ohne Befund. Nicht am Gerät getestet.
- 12.11.2026, Claude Code: Sicherheit und Vertrauen im Paar-Kanal (Konzept `docs/konzepte/paar-kanal-vertrauen.md`, Texte `paar-kanal-vertrauen-texte.md`; Branch `claude/paar-vertrauen-20261112`, noch nicht zusammengeführt): Trennen sendet einen ruhigen Hinweis (normale Chat-Nachricht mit Zusatzfeld, ältere Versionen zeigen einen neutralen Satz), zweifache Bestätigung auf beiden Seiten, Karte mit Schalter beim Gegenüber, Sicherung um Trenn-Stand und Verbindungsbeginn erweitert; „Gerade nicht“ bei der Spicy-Einladung; „Danke fürs Sagen“ auf „Heute lieber nicht“ und „Lass uns reden“ mit Tipp nur für den Empfänger; „Heute lieber nicht“ als fester Knopf; einmaliger Foto-Hinweis. 502 Tests und Bildschirmtests grün, Analyse ohne Befund. Nicht am Gerät getestet; Karte, Antwort-Knöpfe und Dialoge nicht als Bild geprüft. Offen (Entscheidung des Nutzers): siehe Abschnitt „Offene Fragen“ im Konzept.
- 03.11.2026, Codex: optionaler Schlafdaten-Abgleich DE/EN unter Traumpraxis mit Siebentage-Traumrückblick und freiwilligem nächsten Schritt, native Health-Connect-Brücke ab Android 14 ohne neue Abhängigkeit, manuelle Quellenwahl, Backup-Merge und getrenntes Löschen. 454 Tests und 4 Bildschirmtests grün; Analyse ohne Befund, Android-Kompilierung erfolgreich. Keine Geräteprüfung oder Veröffentlichung behauptet.

- 02.11.2026, Codex: App-Icon auf Magazin-Markenzeichen umgestellt, Android-7-Dichten/adaptive Ebenen/Themensymbol fertig, neutrales Pulse-Symbol erhalten. Native Icon-Ressourcen isoliert erfolgreich kompiliert/verlinkt; vollständiger Offline-Gradle-Build wegen fehlender Cache-Abhängigkeiten nicht bestätigt. Kein Release beauftragt. Anschließend technische Endprüfung der vorhandenen Neuvertonung aufgenommen.

- 02.11.2026, Codex: dekorative Kurs-/Audio-/Themenbilder auf WebP umgestellt, vorhandene Pencil-Zeichnungen und eigene Spicy-Paketmotive eingebunden; zentrale Zuordnung und Alias-Kompatibilität, automatischer Bildwechsel bei Paketinstallation/-löschung. Konzept `docs/konzepte/kursgrafiken-redaktionell.md`, Prüfung und Übergabe im Codex-/Claude-Protokoll. Noch kein App-Release beauftragt.

- 26.10.2026: Konzept Traum-Reise abgestimmt, `CLAUDE.md` angelegt, Cloudflare R2 eingerichtet und
  Verbindung geprüft.
- 27.10.2026: Bildübertragung repariert (PR #14), NIP-17 Stufe 1 im Paar-Kanal (PR #17), signierte
  Paketverwaltung und alle Aufnahmen ausgelagert, Deutsch und Englisch (PR #18, #19), Konzepte NIP-17 und
  Lust im Traum (PR #15, #16), Zusammenarbeit mit Antigravity neu geregelt (PR #13).
- 27.10.2026: Traum-Abend in der App (PR #23), Traum-Aufnahmen (PR #27), Beta 4.11.0-beta.1 (Build 46),
  OpenCode als Helfer (PR #25, #26), Texte und deutsche Aufnahmen „Lust im Traum“ (lokal), Serie „Lust im
  Traum“ und Traumtagebuch in der App, Startseite mit Schwerpunkten (PR #35), Wochenrückblick, Realitätschecks
  und nächtliches Wecken von Antigravity (AG-5 bis AG-7, PR #42).
- 12.11.2026, Claude Code: KI-Coach vollständig entfernt (Konzept `docs/konzepte/coach-entfernen.md`; Branch `claude/coach-entfernen-20261112`, nicht zusammengeführt, nicht gebaut): Code, Gemini-Abhängigkeit, ARB-Schlüssel, Anleitung und Doku weg; Üben hat zwei Kapitel; beim Start werden Gemini-Schlüssel und Chatverlauf gelöscht, alte Sicherungen mit `apiKey` bleiben einspielbar; „Was ist neu“ Build 64 (4.19.0-beta.6, `pubspec.yaml` noch unverändert).
  Offen daraus: Werbebroschüre (	ools/werbebroschuere.py Z. 268 nutzt das gelöschte  5_kicoach.png; marketing/broschuere/* und docs/konzepte/werbebroschuere.md bewerben den Coach) vor dem nächsten Broschürenbau überarbeiten.
