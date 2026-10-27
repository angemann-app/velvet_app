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

Jede Zeile mit Datum. Einträge, die älter als drei Tage sind, fragt Antigravity beim Nutzer nach, statt sie
stillschweigend zu übergehen.

- seit 27.10.2026, Aufgabe 1 (Bildübertragung, PR #14): `lib/services/foto_kanal.dart`,
  `lib/services/foto_verbindung.dart`, `test/foto_kanal_test.dart`
- seit 27.10.2026, Aufgabe 2 (NIP-17, eigene Sitzung): `lib/services/nostr_service.dart`,
  `lib/services/nostr_event_check.dart`, `lib/services/rueckmeldung.dart`, `lib/services/nip44.dart`,
  `lib/services/gift_wrap.dart`

## Offene Aufträge

### AG-1: Aussprache korrigieren (laufend, täglich)

**Branch:** `aussprache/<JJJJ-MM-TT>`
**Darf ändern:** `tools/aussprache.json`, neu erzeugte Dateien unter `assets/audio/` (nur die betroffenen)
samt der zugehörigen `dauer.json` (`assets/audio/paar/`, `selbst/`, `einschlaf/`).

1. Neue Meldungen abholen, **mit eigenem Lesestand**:
   `C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart --leser ag`
   Dazu offene GitHub-Issues mit der Vorlage „Aussprache“ ansehen.
2. Nur Aussprache-Meldungen bearbeiten (Wort, Stimme, Lektion, Minute). Andere Rückmeldungen nicht
   bearbeiten; im Pull Request nur ihre Anzahl nennen. Um die kümmert sich Claude.
3. Je Wort die aktuelle Lautschrift ansehen:
   `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py --zeige "<Wort>"`
   Dann einen Eintrag in `tools/aussprache.json` ergänzen oder korrigieren und mit `--zeige` erneut prüfen.
   **Jeder Eintrag braucht eine Hauptbetonung `ˈ`** (eine Nebenbetonung `ˌ` allein klingt flach).
   Bei Unsicherheit zwei Varianten als Hörproben erzeugen und den Nutzer wählen lassen, statt zu raten.
4. Ein Lexikon-Eintrag gilt für **alle** künftigen Aufnahmen. Deshalb zwei Schritte:
   - **Schritt A (dieser Pull Request):** Eintrag plus die gemeldeten Aufnahmen neu einsprechen; im Pull
     Request alle übrigen betroffenen Aufnahmen auflisten.
   - **Schritt B (nächster Lauf, nachdem der Nutzer Schritt A zusammengeführt hat):** die übrigen
     Aufnahmen mit diesen Wörtern gebündelt neu einsprechen, eigener Pull Request
     `aussprache/<datum>-nachsprechen`, im Bericht nur Stichproben zum Anhören.
5. Neu einsprechen, z. B. `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py <lektions-id>`,
   bzw. `--paar`, `--selbst`, `--einschlaf` mit `--stimme` für geführte Audios. Geänderte `dauer.json`
   mit committen.
6. Im Pull Request eine **Anhörliste**: Datei, Wort, ungefähre Stelle.

**Datenschutz:** Den Inhalt der Rückmeldungen nie in Commits, Pull Requests oder Issues kopieren, nur das
betroffene Wort, die Stimme und die Lektion. `C:\TOOLS\velvet-feedback\` und der Schlüssel dort bleiben
außerhalb des Repositorys.

**Wenn nichts Neues gemeldet ist** und kein Schritt B offen ist: nichts ändern, keinen Branch anlegen, dem
Nutzer „keine neuen Aussprache-Meldungen“ melden.

## Erledigt

- 26.10.2026, AG-1 Schritt A (`aussprache/2026-10-26`, PR #12): 16 Lexikon-Einträge, 8 Aufnahmen neu.
  Schritt B (übrige Aufnahmen mit diesen Wörtern) folgt nach dem Zusammenführen.
- 26.10.2026, AG-2 (`ag/2-traum-sanft`, PR #11): sanfte Texte der Traum-Reise, 39 Bausteine je Sprache;
  Fantasie-Räume (31 Bausteine) lokal unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json` zum Gegenlesen.
