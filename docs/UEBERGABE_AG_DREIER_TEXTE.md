# Übergabe an Antigravity: neue Dreier-Texte einsprechen

Stand: 04.11.2026, von Claude Code.

## Was sich geändert hat

- Die **Soft- und Spicy-Texte der beiden Dreier-Folgen** waren nur Skizzen (1 bis 4 Minuten je Rolle) und sind **neu geschrieben**
  (jetzt 4,4 bis 7 Minuten). Handlung, Ort und Szenenfolge bleiben gleich, die drei Rollen erzählen dieselben Ereignisse.
- Außerdem war `spicy_elena.de.json` im Zeichensatz beschädigt (UTF-8 doppelt kodiert). Die neue Fassung ersetzt sie.
- Vier **Sehr-spicy-Rollen** waren ebenfalls zu kurz und ungleich (5 bis 8 Minuten gegen 11) und sind **neu geschrieben**: Klara und David (FFM), Lukas und Sophie (MMF), jetzt 10 bis 13 Minuten. **Elena und Julian bleiben unverändert**, ihre bisherigen deutschen Aufnahmen gelten weiter.
- Die englischen Fassungen aller betroffenen Texte liegen vor (siehe auch `docs/UEBERGABE_AG_ENGLISCH_DREIER.md`).

## Wo die Texte liegen

`build/redaktion/dreier_ffm/` und `build/redaktion/dreier_mmf/`:
`soft_<rolle>.de.json`, `spicy_<rolle>.de.json` sowie `….en.json` (Rollen: elena, klara, david, julian, lukas, sophie).
Die alten Fassungen liegen daneben als `….vor-neutext.json`.

## Zu tun

1. Deutsch neu einsprechen: alle **zwölf Soft/Spicy-Rollen** (72 Aufnahmen) und die **vier neuen Sehr-spicy-Rollen** (Klara, David, Lukas, Sophie; 24 Aufnahmen). Englisch: dieselben 96 sowie Elena und Julian in Sehr spicy (12), zusammen 108. Wie bisher mit `tools/reihe_ausdruck.py` (Victoria: Elena, Klara, Sophie; Martin: David, Julian, Lukas).
2. Dateinamen wie bisher: `<stimme>_<folge>_<stufe>_<rolle>_<szene>.opus`, zum Beispiel `victoria_drei_ffm_soft_frau_a_opening.opus`;
   Rollenschlüssel: FFM `frau_a` (Elena), `frau_b` (Klara), `mann` (David); MMF `mann_a` (Julian), `mann_b` (Lukas), `frau` (Sophie).
   Sehr spicy Englisch mit `sehrspicy_` vor dem Rollenschlüssel. Ablage in `…/audio/` bzw. `…/audio_en/`, `dauer.json` ergänzen
   (Schlüssel ohne `.opus`).
3. Die alten Soft/Spicy-Aufnahmen **nicht** überschreiben, bevor die neuen abgenommen sind; sie gehören zum alten Text.

## Nicht ändern

`C:\TOOLS\velvet-inhalte\reihe\reihe.json`, `tools/pakete/*`, die App. Paket und Veröffentlichung macht Claude.
