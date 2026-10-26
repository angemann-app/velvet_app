# Aufgaben

Stand: 26.10.2026. Reihenfolge = Priorität. Erledigtes nach unten unter „Erledigt“ verschieben.
Für jede Aufgabe eine eigene Sitzung und ein eigener Branch.

## 1. Bildübertragung reparieren (Fehler, zuerst)

Bilder im Paar-Kanal lassen sich nach Offline-Phasen teilweise nicht mehr abrufen, obwohl sie als vorhanden
angezeigt werden.

- Zuerst die Ursache finden, nicht raten: Was passiert beim Wiederverbinden? Wird ein Bild als vorhanden
  markiert, bevor es vollständig übertragen und gespeichert ist? Was passiert bei abgebrochener Übertragung?
- Betroffene Stellen vermutlich `lib/services/foto_kanal.dart`, `foto_verbindung.dart`, `nostr_service.dart`,
  `lib/screens/couples_channel/foto_ansicht.dart`.
- Einen Test schreiben, der den Fehler nachstellt (`test/foto_kanal_test.dart`), dann beheben.
- Bereits betroffene Bilder: erneut anfordern können statt dauerhaft „vorhanden, aber leer“.

## 2. Nostr-Migration auf NIP-17

Von NIP-04 auf NIP-17 (Gift-Wrap) umstellen, ohne dass Paare mit unterschiedlichen App-Versionen sich
verlieren.

- **Stufe 1:** Versions- und Fähigkeitsaushandlung. Die App versteht beide Verfahren, kündigt an, was sie
  kann, und sendet NIP-17 nur, wenn das Gegenüber es sicher kann. Sonst Rückfall auf NIP-04.
- **Stufe 2 (späteres Release):** NIP-04 abschalten, wenn beide Geräte umgestellt sind bzw. nach einer
  Übergangszeit.
- Regeln aus `docs/SICHERHEIT_AUDIT_BASELINE.md` gelten: eingehende Events immer durch `NostrEventCheck`,
  Schlüssel nur über `SecretStore`. `test/security_test.dart` und `test/paar_kanal_test.dart` müssen grün
  bleiben; neue Tests für Aushandlung und Rückfall. Live-Prüfung mit `test_live/relay_live_test.dart`.

## 3. Traum-Reise, Schritt 1

Paketverwaltung mit signierter `audio-index.json` (englisches Paket muss weiter funktionieren) und
Upload-Workflow nach Cloudflare R2. Danach in eigener Sitzung das Traumtagebuch.
Details: `docs/konzepte/traum-reise.md`.

## Laufend: Aussprache korrigieren (täglich)

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
