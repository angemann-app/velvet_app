# Gesamtlektorat und Neuvertonung

Verbindliche Nutzerpräzisierung 01.11.2026: „Spicy muss allerdings spicy bleiben.“ Direkte vorhandene Wortwahl, konkrete bestehende Berührungsanleitungen, erotische Dialoge und spielerische Spannung erhalten. Literarische Qualität über Rhythmus, Übergänge und treffenden Ausdruck erhöhen. Sicherheitsinformationen gezielt und kompakt halten. Keine neuen expliziten Szenen ergänzen. Vorhandene explizite Dialogabsätze und Aufgaben im Literaturdurchgang über alle 54 Spicy-Sprachfassungen wortgleich gegen den gesicherten Vorherstand geprüft.

## Nachtrag: literarischer Durchgang

Nutzer bat nach Einsicht in die konkreten Änderungen ausdrücklich um eine stärkere literarische Komponente. Deshalb ersten Aufnahmestapel angehalten: sechs deutsche Dateien fertig, siebte angefangen; keine Produktionsaufnahmen ersetzt. Nicht als abgeschlossenen 54er-Lauf behandeln.

Zwei Muster (`neuro_1`, `alltag_6`) jeweils DE/EN überarbeitet und auf dem Arbeitsbranch übernommen. Ziel: erlebensnaher Einstieg, zusammenhängende Gedanken, abwechslungsreicher Satzrhythmus und natürliche Übergänge statt einer Folge von Korrekturhinweisen. Die fachlichen Präzisierungen bleiben; vorhandene explizite Dialogbeispiele werden nicht erweitert. Spicy-Aufgabe und bestehende Dialogabsätze wortgleich erhalten.

Nachvollziehbare Ersatzstellen: `tools/redaktion_literarisch_korrekturen.json`; gezielte Übernahme mit `python tools/redaktion_gesamt_anwenden.py --literarisch --uebernehmen`. Vergleich reproduzierbar mit `python tools/redaktion_literatur_vergleich.py`, Ausgabe `build/redaktion/gesamt/literatur/VERGLEICH.html` und vier Markdown-Fassungen. Quellen vor diesem Schritt unter `build/redaktion/gesamt/velvet_content.<sprache>.vor-literatur.json` gesichert.

Eine der sechs fertigen Aufnahmen (`de/alltag_6`) ist durch die literarische Änderung veraltet; der Text-Fingerprint erzwingt beim Wiederaufnehmen die Neuerzeugung. Die übrigen fünf vollständigen Aufnahmen erhalten. Keine erneute Gesamtsynthese vor Stabilisierung des literarischen Textstands. Die Wissens-Sprechprofilfreigabe des Nutzers bleibt gültig, ist aber keine Abnahme einer Aufnahme mit inzwischen geändertem Text. Erst zwei Muster bearbeitet, kein abgeschlossener literarischer Durchgang über alle Lektionen behauptet.

Prüfung: Schutzabgleich der Spicy-Dialoge/Aufgabe bestanden, elf Übersetzungs-/PO-Prüfungen bestanden; nur tatsächlich bearbeitete Übersetzungsquellen gestempelt. Kein App-Code in diesem Schritt geändert.

Aktualisierung 01.11.2026: Wissensprofil DE/EN mit „passt“ vom Nutzer freigegeben. Erster Stapel der 27 abgenommenen Lektionen wird mit genau diesem Profil lokal erzeugt, separat unter `build/redaktion/gesamt/produktion/`. Fortsetzbares Werkzeug `tools/redaktion_audio_stapel.py`, pro Datei Fingerprint aus Text, Stimme, Tempo, Profilcode und deutschem Aussprachelexikon, Audio-SHA und gemessene Dauer; Einprozess-Sperre. Die weiter unten dokumentierte ausstehende Wissens-Hörabnahme ist damit erledigt; ein neues Praxisprofil bleibt gesondert. Gesamtes Lektorat und gesamte Neuvertonung sind noch nicht abgeschlossen.

01.11.2026. Nutzerfreigabe: die 27 vorbereiteten Spicy-Lektionen in DE/EN übernehmen, außerdem alle übrigen Texte lektorieren und neu einsprechen; vorhandene Aussprachehinweise beachten.

## Entscheidungen und Umfang

- Ausgangsstand `2c34cc5`; eigener Branch `codex/gesamtlektorat-audio`. Vorhandene Beta-Prüfdokumentation erhalten.
- Die 54 Sprachfassungen der 27 Spicy-Lektionen sind textlich freigegeben. Vor Integration die Ersatzstellen gegen den aktuellen Produktionsstand erneut prüfen; keine neueren Metadaten überschreiben.
- Weiterer Textbestand: alle 128 Kurslektionen sowie die bestehenden geführten Bausteine in Paar-Abend, Selbsterkundung, Einschlaf- und Traum-Reise, jeweils DE/EN. Anleitungen und Oberflächentexte werden auf Konsistenz mitgeprüft; nicht gesprochene Oberflächentexte erhalten keine künstlichen Audio-Dateien. Historische Neuigkeiten werden nicht umgeschrieben.
- Lektorat bedeutet bestehende Texte verbessern, keine neuen erotischen Szenen verfassen oder vorhandene explizite Szenen erweitern. IDs, Navigation, Aufgabenstruktur, Personalisierungsmarker, Sprecherrollen und Reihenfolge erhalten.
- Private Reihen-/Fantasiequellen bleiben im lokalen Inhaltsordner. Keine Texte an Cloud-Dienste oder OpenCode übergeben. Die separat von AG erstellten Sehr-spicy-Texte sind nicht Teil der vorherigen 27er-Abnahme.
- Neuvertonung lokal mit Kokoro und den bestehenden Stimmen. Deutsch über das bestehende Aussprachelexikon; englische Stimmen über deren englische Lautverarbeitung. Deutsche Lautschrift nicht auf Englisch anwenden.
- Vorhandene Langsamkeits- und Pausenregeln geführter Audios erhalten. Wissenslektionen erhalten ein sachliches Ausdrucksprofil, praktische Lektionen ein ruhiges Profil. Paarlektionen müssen den Absatzwechsel zwischen Victoria und Martin behalten.
- Ausgaben zunächst unter `build/redaktion/gesamt/`, nicht über produktive Aufnahmen schreiben. Pro Aufnahme Quelltext-, Lexikon- und Profilprüfsumme, Stimme, Dauer und Status festhalten; fortsetzbare Verarbeitung.
- Kein Upload, Release oder Paketversionswechsel im Rahmen der Vorbereitung. Die spätere Verteilung erfolgt mit Claude Code nach Aufnahmeabnahme.

## Ablauf und notwendige Hörprobe

1. Freigabe protokollieren, Originaltexte sichern, 27 freigegebene Lektionen konfliktgeprüft in DE/EN übernehmen.
2. Gesamten öffentlichen Text-/Audiobestand inventarisieren und Lektorat in nachvollziehbaren Paketen bearbeiten. Keine automatische Synonymersetzung als angebliches Volllektorat ausgeben.
3. Ausdrucksweg für zwei Stimmen korrigieren und ohne TTS-Modelle testen. Lokale DE/EN-Hörproben mit beiden Stimmen und deutscher Ausspracheprobe erzeugen.
4. Nutzer hört die Profile an. Diese Hörabnahme ist nach `AGENTS.md` und `docs/konzepte/spicy-lektorat.md` vor einem Gesamtlauf erforderlich; die Textfreigabe ersetzt keine Bewertung eines neuen Sprechprofils.
5. Nach Hörabnahme stufenweise vollständige Neuvertonung; technische Audio-Prüfung, Dauern und Änderungen dokumentieren. Keine unkontrollierte Parallelproduktion.

## Offene Punkte

- Hörabnahme des Wissensprofils vom Nutzer mit „passt“ erteilt. Dieses Profil gilt für die Kursproduktion; kein weiteres neues Praxisprofil eingeführt. Die vollständigen Aufnahmen müssen noch fertig erzeugt und geprüft werden.
- Fachliche Unsicherheiten im übrigen Bestand individuell belegen und separat dokumentieren; keine unbelegten medizinischen Zusicherungen ergänzen.

## Aktueller Abschluss des Kurs- und geführten Textdurchgangs

Alle 128 Lektionen je Sprache vollständig gelesen und gezielt geändert. Alle 372 geführten Bausteine je Sprache vollständig gelesen, davon 40 DE und 42 EN geändert. Bestehende literarische Bilder und die unterschiedlichen Tonlagen bleiben erhalten. Keine pauschale Vollneufassung behauptet. Metadatenprüfung und vollständige Vorher/Nachher-Vergleiche durch `tools/redaktion_gesamt_pruefen.py` und `tools/redaktion_gefuehrt_pruefen.py`.

Neuvertonung getrennt und fortsetzbar: 256 Lektionsaufnahmen plus 1.488 geführte Aufnahmen. Geführte Texte behalten ihre vorhandenen Tempi/Pausen. Geänderte Quellen nach Prüfung erzwingen eine erneute Prüfung vor dem geführten Aufnahmestapel. Aussprachelexikon unverändert, alle 102 Einträge weiterhin berücksichtigt. Übergabe und laufende Prüfungen stehen in `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md`. Nicht mit einer fertigen Audioveröffentlichung verwechseln.

Anleitung und Foto-Ideen DE/EN vollständig gelesen; kleine Konsistenzkorrekturen noch offen. Oberflächentexte und private zusätzliche Inhaltsquellen sind durch die beiden abgeschlossenen Durchgänge nicht automatisch vollständig lektoriert.

Weitere fachliche Quellen, gelesen am 01.11.2026:

- [NHS: Vaginismus](https://www.nhs.uk/conditions/vaginismus/) und [EAU: Ejakulationsstörungen](https://uroweb.org/guidelines/sexual-and-reproductive-health/chapter/disorders-of-ejaculation): variable Beschwerden/Behandlung statt pauschaler Versprechen.
- [Salama et al.: Squirting](https://pubmed.ncbi.nlm.nih.gov/25545022/): kleine Studie, nicht als universelle Beschreibung verwenden.
- [NHS: Sex und Verhütung nach der Geburt](https://www.nhs.uk/baby/support-and-services/sex-and-contraception-after-birth/) und [WHO: Menopause](https://www.who.int/news-room/fact-sheets/detail/menopause): Schwangerschaftsmöglichkeiten nicht durch Stillen oder Perimenopause pauschal ausschließen.
- [Klitoris-Innervation, 2023](https://pubmed.ncbi.nlm.nih.gov/36763957/): Nervenfasern eines untersuchten Nervs sind keine pauschale Zahl sichtbarer Nervenendigungen.
- [NHS: Schlafparalyse](https://www.nhs.uk/conditions/sleep-paralysis/): gewöhnlich vorübergehend, unter Umständen beängstigend; keine garantiert sofortige Aufhebung durch kleine Bewegung behaupten.
- [NHLBI: Schlafphasen](https://www.nhlbi.nih.gov/health/sleep/stages-of-sleep): mehr REM-Schlaf später in der Nacht bedeutet keine per App exakt bekannte Schwelle zu den „längsten und ruhigsten“ Träumen.

## Bestand bei Auftragseingang

27 Kurse, 128 Lektionen je Sprache; 27 davon bereits lektoriert. Geführte Quellen DE: Paar-Abend 110, Selbsterkundung 100, Einschlaf-Reise 119, Traum-Reise 43 Bausteine (jeweils vor Multiplikation nach Stimmen und Sprachen). 102 Ausspracheeinträge, alle mit Hauptbetonung. Ein Quellhash hat sich seit Entwurfserzeugung geändert; deshalb Integration nur nach erneutem Ersatzstellenabgleich.

## Erster weiterer Lektoratsstapel

`neuro_1` bis `neuro_3` und `anat_1` bis `anat_5` in DE/EN vollständig gelesen und gezielt lektoriert. Änderungen in `tools/redaktion_gesamt_korrekturen.json`; konfliktgeprüfte Übernahme über `tools/redaktion_gesamt_anwenden.py`. Weniger pauschale Aussagen, angenehmere englische Formulierungen, Atemübung ohne erzwungenes Füllen oder Ausatmen, präzisere genitale Anatomie. Aufgabenstruktur und Platzhalter erhalten. Zusammen mit den 27 freigegebenen Spicy-Lektionen sind damit 35 von 128 Kurslektionen je Sprache bearbeitet. Weitere 93 sowie die geführten Bausteine sind noch offen.

Fachliche Grundlage der gezielten Änderungen, gelesen 01.11.2026:

- [Kinsey Institute: Dual Control Model](https://www.kinseyinstitute.org/research/dual-control-model.html): Erregung und Hemmung als getrennte Einflussgrößen; keine generelle Behauptung, geringe Lust sei meistens allein zu viel Hemmung.
- [Balban et al., 2023](https://pubmed.ncbi.nlm.nih.gov/36630953/): untersuchte tägliche Atemübungen über einen Monat; daraus folgt keine garantierte sofortige Wirkung einer einzelnen kurzen Übung.
- [Cleveland Clinic: Klitoris](https://my.clevelandclinic.org/health/body/22823-clitoris) und [Pudendusnerv](https://my.clevelandclinic.org/health/body/22000-pudendal-nerve): anatomische Einordnung, individuelle Variabilität; keine Zusage, die Klitorisschenkel durch äußeren Dammdruck direkt zu erreichen.

## Hörproben und Prüfungen

- `build/redaktion/gesamt/hoerproben/de_wissen_beide.opus` (49,45 s), `en_wissen_beide.opus` (49,85 s): bestehender Wissensabschnitt, erst Victoria, dann Martin.
- `de_aussprache_victoria.opus` (16,52 s), `de_aussprache_martin.opus` (16,25 s): ausgewählte vorhandene Lexikonwörter. Alle vier Dateien lokal erzeugt und technisch lesbar, keine Hörabnahme durch Codex behauptet.
- Wissensproben nutzen den Textstand vor dem ersten weiteren Lektoratsstapel; genaue gesprochene Fassungen liegen als TXT daneben. Sie bewerten die Stimmen und das Profil, nicht die redaktionelle Endfassung.
- Aussprachelexikon unverändert. Die Phonemizer-Bibliothek meldete beim Prozessende Windows-Aufräumwarnungen zu geladenen espeak-DLLs; Ausgabe vollständig, Prozess Exit 0. Keine Dateien außerhalb des Projekts dafür gelöscht.
- Vier Python-Regressionstests für DE/EN-Stimmenwechsel, Einzelstimme und Hauptbetonung bestanden. Alle 341 Flutter-Tests im PO-Synchronisationslauf bestanden. Die Übersetzungsprüfsummen wurden gezielt nur für die 35 tatsächlich bearbeiteten Lektionen aktualisiert.
- Wissensprofil beim Nutzer zur Hörabnahme angefragt; praktisches Lektionsprofil bisher nur vorbereitet, noch keine Hörprobe/Abnahme. Alte Produktionsaudios bleiben erhalten. Daher stimmen die neuen Lektionstexte bis zur abgeschlossenen Neuvertonung noch nicht mit den bisherigen Aufnahmen überein; diesen Branch noch nicht als fertiges Text-/Audio-Paket veröffentlichen.
