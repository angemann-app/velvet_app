# Aufgaben

Stand: 27.10.2026. Reihenfolge = Priorität. Erledigtes nach unten unter „Erledigt“ verschieben.
Für jede Aufgabe eine eigene Sitzung und ein eigener Branch.

## 1. Lust im Traum (aufbauende Serie)

Konzept (abgestimmt): `docs/konzepte/lust-im-traum.md`. Baut auf Traum-Reise Schritt 1,
Traumtagebuch und nächtlichem Wecken auf, kommt daher danach.

## Laufend: Aussprache korrigieren (täglich) → AG-1

Übernimmt Antigravity als Auftrag **AG-1** in `AG.md` (dort der genaue Ablauf, auch das Nachsprechen aller
betroffenen Aufnahmen in Schritt B). Kurzfassung:

Nutzer melden falsch ausgesprochene Wörter in der App („Wort falsch ausgesprochen?“) oder als Issue.

1. Meldungen abholen: `tools/rueckmeldungen_abholen.dart`.
2. Je Meldung prüfen: Welches Wort, welche Stimme, welche Lektion? Korrektur als Lautschrift-Eintrag in
   `tools/aussprache.json` vorschlagen; betroffene Lektionen/Bausteine auflisten.
3. Einsprechen und Anhören macht der Nutzer gebündelt auf seinem Windows-Rechner mit Kokoro
   (`tools/generate_audio.py`, Prüfen mit `--zeige "<Wort>"`), z. B. einmal pro Woche.
4. Nach dem Neu-Einsprechen: betroffene Aufnahmen anhören, Meldung bzw. Issue schließen.

Diese Routine kann auch von einem anderen Werkzeug (z. B. Antigravity) übernommen werden; dann vorher
`CLAUDE.md` lesen lassen.

## Erledigt

- 26.10.2026: Konzept Traum-Reise abgestimmt, `CLAUDE.md` angelegt, Cloudflare R2 eingerichtet und
  Verbindung geprüft.
- 27.10.2026: Bildübertragung repariert (PR #14), NIP-17 Stufe 1 im Paar-Kanal (PR #17), signierte
  Paketverwaltung und alle Aufnahmen ausgelagert, Deutsch und Englisch (PR #18, #19), Konzepte NIP-17 und
  Lust im Traum (PR #15, #16), Zusammenarbeit mit Antigravity neu geregelt (PR #13).
