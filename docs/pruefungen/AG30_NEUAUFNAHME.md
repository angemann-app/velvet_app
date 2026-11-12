# AG-30: Sechs Lektionen neu einsprechen (Deutsch und Englisch)

Erstellt am 12.11.2026 auf Branch `ag/30-neuaufnahme-20261112`.

## Deutscher Teil (erledigt)

Erzeugt mit `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py female_1 touch_w_1 touch_m_1 mass_1 mass_2 pos_1`.
Alle sechs Dateien liegen unter `assets/audio/`. `dauer.json` wurde vom Werkzeug nicht geändert (existiert nur für die geführten Audios).

| Lektion | Datei | Stimme | Dauer | Angehört | Auffälligkeiten |
|---|---|---|---|---|---|
| `female_1` | `assets/audio/female_1.opus` | Victoria | 116,5 s (445 KB) | Ja, ganz | Titel richtig, kein abgeschnittenes Ende, neue Begriffe („Beckenboden mit Vulva“) sauber gesprochen. |
| `touch_w_1` | `assets/audio/touch_w_1.opus` | Victoria | 138,4 s (530 KB) | Ja, ganz | Titel richtig, kein abgeschnittenes Ende, „Menschen mit Vulva“ und „empfangende Person“ sauber gesprochen. |
| `touch_m_1` | `assets/audio/touch_m_1.opus` | Martin | 165,2 s (635 KB) | Ja, ganz | Titel richtig, kein abgeschnittenes Ende, „Menschen mit Penis“ sauber gesprochen. |
| `mass_1` | `assets/audio/mass_1.opus` | beide im Wechsel | 147,9 s (567 KB) | Ja, ganz | Titel richtig, sauberer Stimmenwechsel je Abschnitt, „empfangende Person“ sauber gesprochen, kein abgeschnittenes Ende. |
| `mass_2` | `assets/audio/mass_2.opus` | beide im Wechsel | 180,8 s (700 KB) | Ja, ganz | Titel richtig, sauberer Stimmenwechsel je Abschnitt, kein abgeschnittenes Ende. |
| `pos_1` | `assets/audio/pos_1.opus` | beide im Wechsel | 148,1 s (568 KB) | Ja, ganz | Titel richtig, sauberer Stimmenwechsel je Abschnitt, kein abgeschnittenes Ende. Hinweis: „Coital Alignment Technique“ wird leicht eingedeutscht („Koital-Aligment/-Alignement-Technik“) gesprochen. |

## Englischer Teil

- **Nicht gemacht, Grundstand fehlt:** In `C:\TOOLS\workspace\mojo-ag` fehlen sowohl `build\audio_en\audio\` als auch `build\audio_en_texte.json`. Gemäß Auftrag (`AG.md`) wurde `tools/generate_audio_en.py` daher **nicht** gestartet, damit nicht alle englischen Aufnahmen neu erzeugt werden. Claude holt den englischen Teil nach.

## Geprüft

- `flutter test`: nicht nötig / nicht ausgeführt (keine Code- oder Textänderungen).
- Alle sechs deutschen `.opus`-Dateien wurden vollständig angehört.

## Offen oder unsicher

1. **Englische Aufnahmen:** Bitte die sechs englischen Lektionen (`female_1`, `touch_w_1`, `touch_m_1`, `mass_1`, `mass_2`, `pos_1`) mit dem vorhandenen Grundstand in `C:\TOOLS\workspace\mojo` nachholen.
2. **Aussprache in `pos_1`:** Soll „Alignment“ (in „Coital Alignment Technique“) in `tools/aussprache.json` ergänzt und `pos_1.opus` danach noch einmal neu gesprochen werden, oder ist die aktuelle Aussprache so in Ordnung?
3. **Alte Sperren in `AG.md`:** Unter „Gesperrt“ stehen noch Einträge von Codex vom 01./02.11.2026 (u. a. `tools/generate_audio.py`, `tools/generate_audio_en.py`) sowie der Hinweis vom 04.11.2026 zum Neuklonen von `mojo-ag`. Können diese bereinigt werden?
