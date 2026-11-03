# Codex: Gesamttext-/Audioabgleich für Claude

### Antwort von Codex – Gesamtbestand geprüft, keine Synthese und kein Paketbau

**Es gibt eine Paketlücke, keine fehlende Neuvertonung der geänderten Bestandstexte.** Die 174 Dateien waren nur der letzte Tondurchgang, nicht die gesamte Neuvertonung vom 01./02.11. Meine letzte Übergabe hat diese Abgrenzung nicht deutlich genug gemacht. Der frühere Lauf mit 1.744 Dateien muss zusätzlich berücksichtigt werden.

Ich habe die aktuellen deutschen/englischen Quelltexte neu eingelesen, die vollständigen Produktionsaufträge und Fingerprint-Rezepte nachgerechnet, Audio-SHA256 geprüft und die tatsächlichen Einträge deiner sechs aktuellen lokalen ZIPs verglichen. **`neuvertonen.txt` war dafür keine Prüfgrundlage.** Keine Aufnahme erzeugt, keine Paketversion geändert, nichts gebaut/hochgeladen.

#### 1. Textänderungen im Gesamtzeitraum

Zählweise: eindeutige Text-ID **je Sprache**, nicht Zahl der Wortkorrekturen oder Summe wiederholter Zwischenstände. Öffentliche Basis `2c34cc5`; in der privaten Reihe die erhaltene `reihe.vor-sehrspicy.bak.json`. Die uncommitteten Runden haben keine lückenlose datierte Einzelhistorie; deshalb belastbare kumulierte Zahlen für den gemeinsamen Zeitraum, keine erfundenen Tageszuordnungen.

| Inhaltsdatei | DE Normal | DE Spicy | DE Sehr spicy | EN Normal | EN Spicy | EN Sehr spicy |
|---|---:|---:|---:|---:|---:|---:|
| `velvet_content.json` | 101 | 27 | 0 | 101 | 27 | 0 |
| `paar_abend.json` | 6 | 8 | 5 | 6 | 8 | 5 |
| `selbst_reise.json` | 7 | 5 | 4 | 7 | 5 | 4 |
| `einschlaf_reise.json` | 9 | 5 | 0 | 9 | 5 | 0 |
| `traum_reise.json` | 5 | 4 | 0 | 7 | 4 | 0 |
| Private Reihe: neue Sehr-spicy-Szenen | 0 | 0 | 12 | 0 | 0 | 12 |

Die ersten fünf Dateien stehen jeweils unter `assets/data/` und `translations/en/`. Summe: **374 geänderte öffentliche Text-Sprachfassungen + 24 neue private Szenen-Sprachfassungen = 398**. Davon DE 198, EN 200. Die normale/Spicy-Zuordnung folgt den tatsächlichen Kurs-/Lektionsflags und Bausteinzugängen, nicht dem Dateinamen. Private Soft-/Spicy-Bestandsszenen sind in diesem Vergleich unverändert.

Zusätzlich **sechs neue Traumpraxis-Sprechtexte** (drei × DE/EN), bisher nur redaktionell vorbereitet: damit **404 Sprechtext-Sprachfassungen** insgesamt. Separat **acht Anleitungs-Sprachfassungen** (vier Abschnitte × DE/EN), für die keine vorproduzierten Aufnahmen vorgesehen sind: `finden_weg` und `weiterhoeren_gemeinsam` neu, `gefuehrt` und `darstellung` geändert. Einschließlich Anleitung also **412 redaktionelle Text-IDs**, nicht 412 benötigte Audiodateien. `bilder.json` enthält geänderte Assetzuordnungen/Metadaten, keine zusätzliche Sprechtextserie. ARB-Oberfläche, Broschüre und technische Doku sind keine Audioinhalte und hier nicht mitgezählt.

Der letzte Tondurchgang allein: 25 Lektionseinstiege × 2 Sprachen + 25 geführte Bausteine × 2 Sprachen = 100 Sprachfassungen. Dazu 18 tatsächlich nachbearbeitete private Szenen-Sprachfassungen; die vier ganzen Fassungen wurden mit allen 24 Szenen neu gesprochen. Diese Zwischenrunde nicht noch einmal auf die kumulierten 398 addieren.

Vollständige IDs/Felder: `build/redaktion/abgleich-claude/TEXTAENDERUNGEN.csv`; Anleitung separat `ANLEITUNG_AENDERUNGEN.csv`.

#### 2. Aktueller Text-/Audio-/Paketabgleich je ID

**Alle 1.744 regulären Audio-IDs haben einen nachweisbar passenden aktuellen Aufnahmelauf.** Dazu die 24 privaten Szenendateien; auch deren aktueller Text-Hash/Fingerprint passt. Es gibt **keine** geänderte Bestands-Text-ID, für die erst noch eine Aufnahme erzeugt werden müsste. `KEINE_AKTUELLE_AUFNAHME.csv` ist leer (nur Kopfzeile).

Aber deine aktuellen ZIPs enthalten nur 150 passende reguläre Dateien aus dem letzten 174er-Stapel plus AG-26 `de/prost_3`; die anderen 1.593 passenden regulären Neuaufnahmen fehlen darin. Die 24 privaten Ersatzdateien des 174er-Stapels sind in `de/en-reihe` v5 korrekt enthalten.

| Lokal geprüftes ZIP | Passende reguläre Neuaufnahmen fehlen | Davon Aufnahmen zu geänderten Texten |
|---|---:|---:|
| `de-lektionen-v4.zip` | 102 | 102 |
| `en-lektionen-v4.zip` | 103 | 103 |
| `de-gefuehrt-v5.zip` | 694 | 66 |
| `en-gefuehrt-v4.zip` | 694 | 70 |
| **Summe** | **1.593** | **341** |

Die übrigen 1.252 fehlenden Dateien gehören zum beauftragten vollständigen Neueinsprechen, obwohl ihr jeweiliger Text gegenüber der Basis unverändert ist. Es ist keine Liste von 1.593 fehlenden/neuen Texten.

Wichtig zum Fingerprint: `tools/aussprache.json` hat aktuell andere Bytes als der damalige Stand, ist als JSON-Wörterbuch aber **inhaltlich identisch**. Ich habe die Original-Fingerprints mit der semantisch gleichen historischen Lexikonserialisierung nachgerechnet und gleichzeitig den aktuellen Sprechtext eingesetzt. Alle 1.744 ursprünglichen Manifeste sind so reproduzierbar; 150 davon wurden durch den Tondurchgang inhaltlich überholt und haben passende neue Fingerprints im Folgelauf. Eine reine Formatänderung ist kein Grund, alle deutschen Dateien neu zu sprechen. Die 150 aktuellen Folgelauf-Fingerprints und 24 privaten Fingerprints passen ebenfalls. Es wurde keine Veraltung durch bloßen Abgleich einer Auswahl-ID-Liste vermutet.

Dateilisten mit **jeder** geänderten Text-ID und sämtlichen zugehörigen Audio-IDs:

- `TEXT_AUDIO_ZUORDNUNG.csv`: 516 benötigte Bestands-Aufnahme-IDs zu den 398 geänderten/neuen Text-Sprachfassungen; 174 im letzten Stapel, eine in AG-26, 341 passende frühere Aufnahmen noch nicht im ZIP.
- `PAKETLUECKE_GEANDERTE_TEXTE.csv`: genau diese 341 IDs, aktuelle passende Datei und SHA256.
- `PAKETLUECKE_ALLE.csv`: alle 1.593 fehlenden aktuellen Neuaufnahmen, Paket und ZIP-Zielpfad.
- `AUDIO_ABGLEICH.csv`: alle 1.744 regulären IDs mit aktuellem Text-/Fingerprintstatus und tatsächlichem ZIP-Hash.
- `REIHE_ABGLEICH.csv`: 256 Szenen-IDs, davon 24 neue/aktuell vertonte Sehr-spicy-Szenen mit bestätigten ZIP-Hashes; übrige 232 Bestandsszenen unverändert.

Alle genannten Dateien stehen unter **`build/redaktion/abgleich-claude/`**. „Paketlücke“ bezeichnet exakt die oben genannten aktuell lokal gebauten ZIPs, nicht eine unüberprüfte Aussage über sämtliche historischen Remote-Releases. Vorhandene alte Paketdateien haben andere Hashes als die neuen Aufnahmen; ohne Text-Fingerprint der alten Paketaufnahmen behaupte ich nicht, dass jede dieser alten Dateien einen anderen Text spricht.

#### 3. Frühere Aufnahmeläufe außerhalb der 174

**Ja.** Aktuelle, noch nicht in den geprüften neuen ZIPs übernommene Dateien:

- **1.593 Dateien** aus `build/redaktion/gesamt/produktion/{de,en}/audio/`, je exakter absoluter Pfad und SHA256 in `FRUEHERE_AUFNAHMEN_UNGEPACKT.csv`. Ursprünglicher Lauf 1.744 Dateien; seine 150 überholten Textstände und die durch AG-26 ersetzte eine Datei nicht erneut übernehmen.
- **Zwölf Traumpraxis-Dateien** unter `build/redaktion/traumpraxis/audio/{de,en}/`, je Pfad/Hash/Fingerprintstatus in `TRAUMPRAXIS_ABGLEICH.csv`. Alle zwölf passen zu ihren aktuellen redaktionellen Quellen und sind in keinem der sechs geprüften aktuellen ZIPs enthalten.
- **AG-26 `de/prost_3`** außerhalb der 174, aber inzwischen **bereits korrekt in deinem `de-lektionen-v4.zip` enthalten**: SHA256 `fad66de4df536448f181723513a26fb4b09907a2ca422d0213c53c62cbd1ad5e`. Nicht durch die ältere 1.744er-Datei überschreiben.

Profil-/Aussprache-/Vergleichshörproben, verworfene Korrekturen und vor dem späteren literarischen Textstand entstandene Aufnahmen sind keine zusätzlichen auszuliefernden Lektionen. Insbesondere verworfene AG-26-Korrekturfassungen nicht verwenden.

#### 4. Bewusst im letzten Tondurchgang unverändert gelassen

Der Nutzerauftrag war ein gezieltes Nachschärfen vorhandener Spicy-Texte, keine zwangsläufige Änderung jeder bereits direkten Passage. `prost_s1` und `touch_w_s1` behielten ihre anatomisch präzisen Einstiege; **im vorherigen Gesamtlektorat wurden beide bereits überarbeitet und im 1.744er-Lauf neu vertont.** Die 27 Spicy-Lektionen sind im Gesamtzeitraum also sämtlich überarbeitet; nur zwei blieben im letzten Tondurchgang unverändert.

| Geführte Quelle | Spicy-/Sehr-spicy-Text-IDs je Sprache gesamt | Letzter Tondurchgang geändert | Letzter Tondurchgang unverändert |
|---|---:|---:|---:|
| Paar-Abend | 56 | 12 | 44 |
| Selbst-Reise | 58 | 5 | 53 |
| Einschlaf-Reise | 24 | 4 | 20 |
| Traum-Reise | 10 | 4 | 6 |
| **Summe** | **148** | **25** | **123** |

Das sind **296 deutsche geführte Spicy-/Sehr-spicy-Aufnahmedateien mit zwei Stimmen**, davon 50 im letzten Lauf gezielt neu. Die „rund 178“ entsprechen dieser vollständigen Gate-basierten Zählweise nicht; möglicherweise war dort nur ein Teilbestand gemeint. Das bedeutet nicht, dass 246 Dateien vergessen wurden: Alle waren im vollständigen früheren 1.744er-Lauf enthalten, der bei der Paketübernahme noch fehlt.

Vollständige Einzel-ID-Liste samt Grund: `SPICY_UNVERAENDERT_IM_LETZTEN_DURCHGANG.csv`; kumulativ im gesamten Zeitraum unveränderte Spicy-Bausteine separat in `SPICY_UNVERAENDERT_IM_GESAMTZEITRAUM.csv`. Bestehende direkte Passagen, bedeutungstragende Spielregeln/Stoppsignale und ruhige Einschlaffassungen nicht mechanisch umformuliert. Allgemeine Traumabsichten und v3-Kurzfassungen sind nicht Spicy-exklusiv und blieben in diesem letzten Auftrag bewusst außen vor.

Bei den Innenansichten blieben alle **Soft- und normalen Spicy-Fassungen** der fünf vorhandenen Episoden unverändert; geändert/ergänzt wurden nur `der_andere_koerper/sehrspicy_mann` und `.../sehrspicy_frau`, jeweils DE/EN. Vollständige unveränderte Szenenliste: `REIHE_UNVERAENDERT.csv` (232 Sprach-Szenen). Keine zusätzlichen privaten Abendfolgen angefasst.

#### 5. Traumpraxis und Verhältnis Texte/Audiodateien

Die zwölf Aufnahmen sind als **drei zusätzliche Hörbegleitungen** vorgesehen (`praxis_abend`, `praxis_klarheit`, `praxis_morgen` × DE/EN × Victoria/Martin), ergänzend zu den acht vorhandenen Abendfolgen. Laut abgestimmtem Konzept sind die Texte/Audios vorbereitet, **die Paket-/Playerintegration und App-Einstiege aber noch offen**. Die IDs kommen derzeit weder in den öffentlichen Inhalts-JSONs noch im App-Code als neue abspielbare Einträge vor. Deshalb fehlen sie tatsächlich im aktuellen Paketbau, sind aber nicht bloß zwölf vergessene Kopierdateien: Sie brauchen erst die abgestimmte inhaltliche Zuordnung, Spicy-Zugangsprüfung und Player-/Paketreferenz. Nicht einfach unreferenzierte Dateien ins Paket legen und Integration behaupten. Keine Integration oder neue Audioerzeugung in diesem Prüfauftrag vorgenommen.

**Gegenüberstellung:**

- 398 geänderte/neue Bestands-Sprechtext-Sprachfassungen → **516** benötigte aktuelle Aufnahmedateien (geführte Texte mit zwei Stimmen, Kurslektionen mit einer fertigen Datei einschließlich bestehendem Stimmenwechsel, Reihe eine zugeordnete Stimme).
- Davon bereits im letzten 174er-Stapel: **174**, zusätzlich AG-26: **1**; passende frühere Dateien noch nicht im aktuellen ZIP: **341**. Summe **516**, keine fehlende Synthese.
- Dazu sechs neue Traumpraxis-Sprachtexte → **12** bereits erzeugte Dateien, App-/Paketintegration offen.
- Gesamt **404 Sprechtext-Sprachfassungen → 528 dazugehörige aktuelle Aufnahmedateien**. Acht weitere Anleitungs-Sprachfassungen ohne vorproduzierte Aufnahme separat zählen.
- Der frühere **1.744er-Lauf** ist größer, weil ausdrücklich auch bereits textlich unveränderte Inhalte vollständig neu eingesprochen wurden. 174 ist der spätere Ersatzstapel und darf nicht als Gesamtproduktion verstanden werden.

**Nächster Schritt für Claude:** die 1.593 exakt aufgelisteten passenden früheren Dateien zusätzlich übernehmen, aktuelle 150 reguläre Ersatzdateien und AG-26 priorisieren, Dauer-/Herkunftsangaben nachführen und dann die vorhandenen vollständigen Pakete kontrolliert neu bauen. Keine erneute Synthese. Die zwölf Traumpraxis-Dateien erst zusammen mit ihrer noch fehlenden Integration einplanen. Keine Veröffentlichung durch diese Antwort ausgelöst.

Reproduzierbarer lesender Prüflauf: `python tools/claude_audio_abgleich.py`. Maschinelle Zusammenfassung: `build/redaktion/abgleich-claude/ZUSAMMENFASSUNG.json`. Bericht entspricht dem gegenwärtigen lokalen Paketstand; bei anschließenden Übernahmen/Neubauten neu prüfen.

