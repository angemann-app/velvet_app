# Aufgaben

## Aktuell vorrangig: gezielte Spicy-Neuvertonung vor Claudes Beta

02.11.2026: Neuer Nutzerauftrag Spicy-Ton einschließlich separater Sehr-spicy-Innenansichten und Neuvertonung. Textdurchgang umgesetzt und geprüft; Produktion von 150 regulären Dateien plus 24 Szenendateien erfolgreich abgeschlossen, 174/174 technisch geprüft. Hörstichprobe und Paketübernahme offen. Morgen zuerst Fortschritt/Abschluss prüfen: `docs/redaktion/SPICY_TONDURCHGANG_2026-11-02.md` und `build/redaktion/spicy-ton/nachtlauf.json` / `abschluss.json`. Dann gezielte Paketübernahme, Hörstichprobe und Claudes Beta-Build nach bestehendem Freigabeworkflow. Kein neuer Gesamtlauf und kein Upload durch Codex.

Stand: 27.10.2026. Reihenfolge = Priorität. Erledigtes nach unten unter „Erledigt“ verschieben.
Für jede Aufgabe eine eigene Sitzung und ein eigener Branch.

## Aktuell: Bedienung und gemeinsames Hören

Freigegeben am 02.11.2026, Branch `codex/bedienung-audio-gemeinsam-20261102`, Konzept `docs/konzepte/bedienung-audio-wege.md`. Implementiert: lokale Suche, persönlicher Weg, globaler Player/Mini-Player, genaue Wiederaufnahme des gespeicherten Ablaufs, Offline-/Downloadwege, gemeinsames Hören derselben Fassung und freiwilliger gemeinsamer Rückblick. 419 Tests grün, Analyse ohne Befund; DE/EN und alle Atmosphären sowie kleine/große Displays geprüft. Gemeinsames Hören braucht passende tatsächliche Aufnahmen auf beiden Geräten; keine Geräte-Stimme. **Offen im Team:** Claude baut/veröffentlicht morgen eine Beta für den In-App-Download; erst danach echter Geräte-/Zweigeräte-/Hintergrundtest. Kein USB-/Alpha-Weg. Übergabe `docs/UEBERGABE_BETA_BEDIENUNG.md`, aktuelle Belege `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md`. Keine APK und keine Veröffentlichung durch Codex.

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

- Optionaler Schlafdaten-Abgleich für Traumpraxis, Konzept `docs/konzepte/schlafdaten-abgleich.md`: freiwilliger Import bereits synchronisierter Daten, auch ohne Wearable voll nutzbar. Live-Funktionen vom Nutzer vorerst ausdrücklich ausgeschlossen. Schnittstellenweg noch prüfen; noch nicht implementiert.

- Eigene Domain für R2 statt `r2.dev` (bewusst aufgeschoben).
- Stabile Version nach den Handytests (Nutzer testet, Testmodus hilft).
- Fantasie-Räume, Statistik Selbstliebe, NIP-17 Stufe 2 (nach fünf stabilen Versionen).

## Laufend: Aussprache korrigieren (wöchentlich, mittwochs) → OpenCode

Meldungen werden täglich gesammelt, abgearbeitet wird einmal pro Woche am Mittwoch. Claude Code holt die Meldungen, OpenCode pflegt `tools/aussprache.json` und spricht neu ein, Claude prüft und
führt nach dem OK des Nutzers zusammen. Ablauf in `docs/AUSSPRACHE.md` (früher AG-1).

## Erledigt

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
