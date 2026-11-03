# Traumpraxis: konkrete Audio-/App-Zuordnung für Claude

### Konkrete Antwort von Codex: zwölf Traumpraxis-Aufnahmen anschließen

Der Nutzer hat nochmals klargestellt, dass die Aufnahmen zum vorgesehenen Funktionsumfang gehören. Die Herstellung war abgeschlossen, der Anschluss an App und Pakete fehlte; meine vorherige Übergabe enthielt dafür keine vollständige technische Zuordnung. **Die drei Begleitungen sollen vor dem Bau der kommenden Beta an das bestehende Traumpraxis-Modul angeschlossen werden, nicht stillschweigend auf eine spätere Beta verschoben werden.** Das ist eine Integrationsanweisung, keine von Codex erteilte Veröffentlichungsfreigabe für Version/Build.

#### Verbindliche Zuordnung aus den vorhandenen Quellen

| Kanonische ID | Titel DE | Titel EN | Aufruf im bestehenden Traumpraxis-Modul |
|---|---|---|---|
| `praxis_abend` | Eine Spur in die Nacht | A trace into the night | Abendvorbereitung; einmal vor dem Einschlafen oder einer bestehenden Abendfolge |
| `praxis_klarheit` | Wenn du den Traum erkennst | When you recognise the dream | Tagsüber oder am frühen Abend als wache Vorstellungsübung |
| `praxis_morgen` | Etwas von der Nacht mitnehmen | Carry something of the night with you | Morgens nach dem Aufwachen bzw. ruhiger Tagesmoment, anschließend freiwillige Tagesbeobachtung |

**Alle drei ausschließlich hinter Spicy, 18+.** Das steht bereits in `docs/redaktion/traumpraxis/hoertexte.json` (`spicy: true`, `mindestalter: 18`) und passt zum vorhandenen Spicy-Gate der Traumpraxis-Seite. Keine Veröffentlichung als normale/ungeschützte Inhalte und nicht die kompletten gemischten Geführt-Pakete als Spicy-only markieren.

**Pakete:** Deutsch `de-gefuehrt`, Englisch `en-gefuehrt`. Für jede der drei IDs und jede Sprache sind Victoria **und** Martin wählbar, ohne Sprecherwechsel.

- Quelle: `build/redaktion/traumpraxis/audio/<de|en>/<victoria|martin>_<id>.opus`.
- Ziel im jeweiligen ZIP: **`audio/traum/<victoria|martin>_<id>.opus`**.
- App-Pfad identisch zum ZIP-Pfad, z. B. `audio/traum/victoria_praxis_abend.opus`, mit ursprünglicher Sprache auflösen.
- Exakte zwölf Zuordnungen mit Titel, Stimme, Millisekunden und erneut bestätigtem SHA256: **`build/redaktion/traumpraxis/PAKET_ZUORDNUNG.json`**. Keine Neuvertonung notwendig.

#### Konkrete Vorbereitung für Claude

Zusätzlich zwei fertige, sprachbezogene Inhaltskataloge vorbereitet:

- `build/redaktion/traumpraxis/paket-vorbereitung/de/audio/traum/traumpraxis.json`
- `build/redaktion/traumpraxis/paket-vorbereitung/en/audio/traum/traumpraxis.json`

Ziel beider Kataloge im jeweiligen Paket: **`audio/traum/traumpraxis.json`**. Schema: `version`, `sprache`, `spicy`, `mindestalter`, drei `eintraege`; pro Eintrag `id`, `titel`, `phase`, `spicy`, vollständiger kanonischer `text`, und `aufnahmen` mit Stimmen, `pfad`, `dauerMs`, `sha256`. Texte aus der bisherigen Produktionsquelle übernommen, Audios nicht geändert. Damit können Inhalt und Aufnahmen zusammen im signierten Paket liegen, statt neue Sprechtexte dauerhaft im App-Code einzubauen. Der vorhandene Geführt-Paketbauer nimmt Dateien im Quell-Unterordner `traum/` bereits mit; die Vorbereitung muss in dessen jeweilige Sprachquelle übernommen werden. Die Kataloge sind noch nicht in den gebauten ZIPs oder im App-Code angeschlossen.

#### App-Anschluss und Grenzen

1. Auf der vorhandenen Traumpraxis-Seite drei passende Hör-Einstiege ergänzen (Abend, Klarheit, Morgen), mit Titel aus dem Inhalt und funktionalen Beschriftungen DE/EN über ARB; vorhandenen Stimmenwähler nutzen.
2. Über den **globalen Player** als einzeln gestartete Begleitung wiedergeben. Gespeicherte IDs, native Dateienden, ursprüngliche Sprache und Dauer übernehmen. Kein neuer unabhängiger Player.
3. Die kanonische Ergänzung/Validierung in `WiedergabePlaene.ergaenzen` ausdrücklich um diesen Katalog erweitern: nur bekannte drei IDs, zugelassene Stimmen/Dateipfade, Spicy zwingend aus der kanonischen Quelle ableiten. Ein frei konstruiertes `spicy: false` darf den Zugang nicht umgehen; auch beim Wiederfinden/Import und während des Abspielens prüfen.
4. **Nicht** als zufällige `TraumDaten`-/Einschlaf-Bausteine einmischen. `praxis_klarheit` ist eine wache Übung, keine REM-Erkennung und keine nächtliche Wiederholung. `praxis_abend` einmalig mit ruhigem offenem Ende. `praxis_morgen` übergibt bei Wunsch zur vorhandenen Tagesbeobachtung. Bestehende Pause-Regel bei belastenden Träumen auch für aktive Klarheits-/Abendvorbereitung berücksichtigen.
5. Fehlendes Paket bzw. fehlender Katalog führt zum passenden Downloadhinweis. Vorhandene Aufnahmen ohne Netz nutzbar; keine Abhängigkeit von einer Uhr oder einem Armband. Keine privaten Traumzeichen/Tagebuchnotizen dynamisch einsprechen oder in den Inhaltskatalog übernehmen.
6. Integration prüfen: DE/EN, beide Stimmen, alle drei Pfade, Paket vorhanden/fehlend, Spicy an/aus inkl. Wiederaufnahme, kein Autostart aus Einladungen, native Dauer/Ende; neue Einstiege mit kleinem Display/Schriftskalierung rendern. Anleitung/„Was ist neu“ passend nachziehen. Nach Einbindung vollständige Tests und finaler App-Build durch Claude.

**Beta:** Nutzerwunsch ist Einbindung vor der kommenden Beta. Für die konkrete Veröffentlichung `4.19.0-beta.1`, Build `59`, liegt in diesem Codex-Chat noch keine ausdrückliche Versions-/Buildfreigabe des Nutzers vor. Codex erteilt sie nicht stellvertretend. Integrationsvorbereitung ist fertig; keine Synthese, kein Paket-/APK-Build, kein Upload durch diesen Antwortschritt.

