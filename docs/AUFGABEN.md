# Aufgaben

Stand: 27.10.2026. Reihenfolge = Priorität. Erledigtes nach unten unter „Erledigt“ verschieben.
Für jede Aufgabe eine eigene Sitzung und ein eigener Branch.

## 1. Lust im Traum: Rest

Serie, Traumtagebuch und Paket sind gebaut (siehe Konzept, „Umsetzung“). Offen:
- Auf dem Handy testen: Paket laden, Folge 1, Freischaltung, Traumkörper und Gegenüber ab Folge 3.
- Nachfrage vor Lautsprecher-Wiedergabe, Pause beim Abziehen der Kopfhörer → AG-8
- Realitätschecks sichtbarer (Zeile im Traum-Abend und im Tagebuch) → mit AG-8, für die nächste Beta
- Freiwilliges anonymes „Hallo“ (`docs/konzepte/hallo.md`) → AG-9
  (`docs/konzepte/lautsprecher.md`)

## 2. Pflege: technische Schulden (nach AG-8 und AG-9)

- **Abspieler entflechten:** `einschlaf_reise_screen.dart` trägt Einschlafen, Traum-Abend, Lust im Traum und
  Wecken. Gemeinsamer Abspieler plus schlanke Einrichtungsseiten. Erst wenn AG-8/AG-9 zusammengeführt sind
  (AG-8 ändert diese Datei).
- **Kotlin und Gradle** auf die von Flutter verlangten Versionen heben (Build-Warnungen: Kotlin 2.2.20, Gradle
  8.10.2 älter als das Minimum). R8 bleibt aus. Danach auf dem Handy prüfen.
- CI: Screen-Test mit Bildern als Artefakt (erledigt 27.10.).

## 3. Pflege: Inhalte, Schwerpunkt für Schwerpunkt

Je Schwerpunkt (Grundlagen, Annehmen und Lösen, Sich selbst entdecken, Lust als Paar, Berührung, Fantasie und
Spiel) eine Prüfliste: Ton und Länge einheitlich, fachlich aktuell, Englisch gleichwertig, Aufnahmen Deutsch und
Englisch (Stichproben anhören, Aussprache über OpenCode), Anleitung, Handytest. Dazu Startseite: Kurskarten in den
Schwerpunkten kompakter, Check-in und Funke nebeneinander.

## Später

- Eigene Domain für R2 statt `r2.dev` (bewusst aufgeschoben).
- Stabile Version nach den Handytests (Nutzer testet, Testmodus hilft).
- Fantasie-Räume, Statistik Selbstliebe, NIP-17 Stufe 2 (nach fünf stabilen Versionen).

## Laufend: Aussprache korrigieren (täglich) → OpenCode

Claude Code holt die Meldungen, OpenCode pflegt `tools/aussprache.json` und spricht neu ein, Claude prüft und
führt nach dem OK des Nutzers zusammen. Ablauf in `docs/AUSSPRACHE.md` (früher AG-1).

## Erledigt

- 26.10.2026: Konzept Traum-Reise abgestimmt, `CLAUDE.md` angelegt, Cloudflare R2 eingerichtet und
  Verbindung geprüft.
- 27.10.2026: Bildübertragung repariert (PR #14), NIP-17 Stufe 1 im Paar-Kanal (PR #17), signierte
  Paketverwaltung und alle Aufnahmen ausgelagert, Deutsch und Englisch (PR #18, #19), Konzepte NIP-17 und
  Lust im Traum (PR #15, #16), Zusammenarbeit mit Antigravity neu geregelt (PR #13).
- 27.10.2026: Traum-Abend in der App (PR #23), Traum-Aufnahmen (PR #27), Beta 4.11.0-beta.1 (Build 46),
  OpenCode als Helfer (PR #25, #26), Texte und deutsche Aufnahmen „Lust im Traum“ (lokal), Serie „Lust im
  Traum“ und Traumtagebuch in der App, Startseite mit Schwerpunkten (PR #35), Wochenrückblick, Realitätschecks
  und nächtliches Wecken von Antigravity (AG-5 bis AG-7, PR #42).
