# Aussprache korrigieren (laufend)

Seit 27.10.2026 von Claude Code mit OpenCode erledigt (früher Auftrag AG-1 für Antigravity). Claude Code holt
die Meldungen, OpenCode pflegt das Lexikon und spricht neu ein, Claude Code prüft und führt zusammen.

Nutzer melden falsch ausgesprochene Wörter in der App („Wort falsch ausgesprochen?“, kommt über das
Rückmelde-Postfach) oder als GitHub-Issue mit der Vorlage „Aussprache“.

## 1. Meldungen holen (Claude Code)

- Zuerst `C:\TOOLS\velvet-feedback\aussprache_offen.txt` lesen: Dort trägt die tägliche Nachrichten-Aufgabe
  die Aussprache-Meldungen ein, weil sie Claudes Lesestand verbraucht. Erledigte Zeilen danach löschen.
- Dann `C:\TOOLS\flutter\bin\dart.bat run tools/rueckmeldungen_abholen.dart` (Claudes Lesestand) und offene
  Issues mit der Vorlage „Aussprache“.
- Daraus nur **Wort, Stimme, Lektion bzw. Audio und ungefähre Minute** herausziehen. Den Inhalt der
  Rückmeldungen nie an OpenCode geben (Cloud-Modell) und nie in Commits, Pull Requests oder Issues kopieren.
  `C:\TOOLS\velvet-feedback\` bleibt außerhalb des Repositorys.
- Nichts Neues und kein Schritt B offen: nichts tun, dem Nutzer „keine neuen Aussprache-Meldungen“ melden.

## 2. Lexikon und Aufnahmen (OpenCode)

Branch `aussprache/<JJJJ-MM-TT>` anlegen, dann `opencode_auftrag` mit diesem Auftrag (Liste einsetzen):

> Aussprache korrigieren nach docs/AUSSPRACHE.md, Abschnitt 2. Wörter: <Wort – Stimme – Lektion/Audio>.
> Darfst ändern: tools/aussprache.json und nur die neu erzeugten Aufnahmen unter assets/audio/ samt der
> zugehörigen dauer.json. Sonst nichts. Am Ende: je Wort alte und neue Lautschrift, Liste der neu
> eingesprochenen Dateien und Liste aller übrigen Aufnahmen, die das Wort enthalten.

Ablauf für OpenCode:

1. Je Wort die aktuelle Lautschrift ansehen:
   `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py --zeige "<Wort>"`
2. Eintrag in `tools/aussprache.json` ergänzen oder korrigieren und mit `--zeige` erneut prüfen.
   **Jeder Eintrag braucht eine Hauptbetonung `ˈ`** (eine Nebenbetonung `ˌ` allein klingt flach).
   Bei Unsicherheit zwei Varianten nennen; Claude lässt den Nutzer per Hörprobe wählen.
3. Ein Lexikon-Eintrag gilt für **alle** künftigen Aufnahmen. Deshalb zwei Schritte:
   - **Schritt A:** Eintrag plus die gemeldeten Aufnahmen neu einsprechen; alle übrigen betroffenen Aufnahmen
     nur auflisten.
   - **Schritt B** (nachdem Schritt A zusammengeführt ist): die übrigen Aufnahmen mit diesen Wörtern gebündelt
     neu einsprechen, Branch `aussprache/<datum>-nachsprechen`.
4. Neu einsprechen: `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py <lektions-id>` bzw.
   `--paar`, `--selbst`, `--einschlaf`, `--traum` mit `--stimme` und den Baustein-Ids für geführte Audios.

## 3. Prüfen und zusammenführen (Claude Code)

- `git diff` lesen: nur `tools/aussprache.json`, die genannten Aufnahmen und `dauer.json` geändert?
- Pull Request mit **Anhörliste** (Datei, Wort, ungefähre Stelle; bei Schritt B nur Stichproben) und dem
  Nutzer die Hörproben schicken. Zusammenführen erst nach seinem OK.
- Danach Paketversion in `tools/pakete/versionen.json` hochzählen und `tools/pakete_hochladen.ps1`, damit die
  korrigierten Aufnahmen ohne App-Update ankommen.
