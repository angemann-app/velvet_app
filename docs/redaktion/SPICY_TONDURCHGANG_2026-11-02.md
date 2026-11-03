# Spicy-Tondurchgang – 02.11.2026

## Spicy-Neuvertonung abgeschlossen – maßgeblicher Abschlussstand

Der serielle Nachtlauf ist erfolgreich beendet: **174/174 Aufnahmen technisch vollständig geprüft**, davon 150 reguläre Ersatzaufnahmen und 24 Szenendateien der vier Sehr-spicy-Innenansichten DE/EN. Gesamtumfang rund 3,59 Stunden Audio. Vollständige Dekodierung, Text-/Dateihashes und Dauern geprüft; private Originalquelle unverändert. Bekannte espeak-DLL-Aufräumwarnungen beim Prozessende haben die geprüften Ausgaben nicht verhindert.

Maßgeblich: `build/redaktion/spicy-ton/abschluss.json`, `UEBERGABE_AUDIO.json` (exakte Quellen/Paketziele/Hashes/Dauern), `HOERPROBEN.html`; private Textentwürfe unter `innenansichten/`. **Hörstichprobe der neuen Aufnahmen noch offen.** Alte AG-26-Abnahme nicht auf diese neuen Dateien übertragen. Kein Upload, keine Paketübernahme, keine Veröffentlichung durch Codex. Für Claude: gegenhören, gezielt in vollständige Paketbestände übernehmen, geänderte private Texte zusammenführen und Dauern/Herkunft mitführen; separate AG-26-Datei `de/prost_3` erhalten. Danach Beta nach vereinbartem Build-/Freigabeworkflow. Nicht erneut synthetisieren. Ältere Laufmeldungen unten sind Verlauf und überholt.

## Auftrag und Ergebnis

Nutzerauftrag: ausschließlich Spicy-Varianten, vorhandene Erotik direkt erhalten, weniger vorsichtige/belehrende Sprache. Keine Normaltexte, privaten Innenansichten, Aufgaben, IDs, Stimmen oder Kurszuordnungen geändert. Bestehende explizite Handlungen nicht erweitert. Medizinisch/anatomische Aussagen sowie konkrete Grenzen/Stoppsignale erhalten; Rollenspiel-Erlaubnis nicht mechanisch entfernt.

- 25 von 27 vorhandenen Spicy-Lektionseinstiegen jeweils DE/EN individuell gestrafft. `prost_s1` und `touch_w_s1` mit ihrer anatomischen Einführung unverändert. Bestehender Haupttext einschließlich erotischer Dialoge und Aufgaben der Lektionen erhalten.
- 25 explizit Spicy-geschützte geführte Bausteine je Sprache gezielt überarbeitet: Paar-Abend 12, Selbst-Reise 5, Einschlaf-Reise 4, Traum-Reise 4.
- Zusammen 100 geänderte Sprachfassungen. Alle übrigen Texte, insbesondere allgemeine Traumabsichten, Kurzfassungen v3 und Normalvarianten unverändert.

## Konkrete redaktionelle Änderungen

Einstiege auf Tätigkeit und Erfahrung ausgerichtet, wiederkehrende abstrakte Einladungsformeln reduziert. Zum Beispiel „Vielleicht … Beides darf … Wir nähern uns …“ im Squirting-Einstieg durch eine kürzere Orientierung ersetzt; keine neue medizinische Aussage. Beim Paar-Abend die doppelte Ergebnisabsicherung am Rundenende entfernt, Entscheidung zwischen Höhepunkt und Halten beibehalten. Rollenwechsel direkter formuliert. Konkrete Pause auf Wunsch bleibt im betreffenden Spicy-Baustein stehen. Im Einschlafteil Ruhe beibehalten, aber die mehrfach wiederholte Erklärung „Lust ist eine Möglichkeit“ gestrafft. Nur die Spicy-Traumbilder erhalten direktere sprachliche Übergänge; keine Änderung allgemeiner Affirmationen.

## Quellen und Vergleich

Reproduzierbar mit `python tools/redaktion_spicy_ton.py` (nur prüfen), Übernahme mit `--uebernehmen`. Exakte Vorher-/Nachherstellen in `tools/redaktion_spicy_ton_einstiege.json` und `tools/redaktion_spicy_ton_bausteine.json`. Vollständige Quellensicherung unter `build/redaktion/spicy-ton/*.vorher.json`; lokaler Vergleich `VERGLEICH.html`, Übernahmeprotokoll `uebernahme.json`.

Das Werkzeug prüft die Spicy-Zugangsmarkierungen und erlaubt nur die aufgelisteten content-/text-Felder. Es erhält Reihenfolge, Metadaten, Personalisierungsmarker, Aufgaben und Normaltexte. DE/EN wird gemeinsam vorbereitet, fehlende oder mehrdeutige Ausgangsstellen verhindern die Übernahme.

## Audio-Übergabe für Claude

**Keine Aufnahmen verändert oder neu erzeugt.** Die bisherige AG-Hörabnahme gilt für die bisherigen Dateien, nicht automatisch für diese neuen Texte. Genau 150 Audio-IDs sind durch die Textänderungen veraltet: 50 Lektionsdateien (25 × 2 Sprachen) und 100 geführte Dateien (25 × 2 Sprachen × 2 Stimmen). Vollständige Zielauswahl in `build/redaktion/spicy-ton/neuvertonen.txt`. Diese Liste bezeichnet zu erneuernde Dateien, keine zusätzliche Menge neuer Inhalte.

Für einen späteren Aufnahmelauf nur diese IDs mit dem bisherigen freigegebenen Profil, Victoria/Martin und Aussprachepflege wählen; kein Komplettlauf aller 1.756 Aufnahmen. Vor der Aufnahme aktuellen Textstand/Fingerprints prüfen. Die separat abgenommene Korrektur `de/prost_3` ist unverändert und nicht betroffen. Paketübernahme/Veröffentlichung bleiben bei Claude. Bis zur gezielten Neuvertonung Texte und alte Audio-Pakete nicht als deckungsgleich bezeichnen.


## Erweiterung und ausdrücklicher Produktionsauftrag des Nutzers

Nutzer hat die separaten Sehr-spicy-Innenansichten ausdrücklich einbezogen und anschließend die Neuvertonung durch Codex beauftragt, damit Claude morgen bauen kann. Beide bestehenden Geschichten in DE/EN mit 42 gezielten Einzeländerungen lektoriert: Ich-Form, sechs Szenen, Figuren, vorhandene Handlungen, Höhepunkte und vollständige Rückverwandlung erhalten; erklärende Einschübe und pauschale Geschlechteraussagen gestrafft. Keine neuen expliziten Szenen. Körperliches Erleben als eigene Erfahrung statt allgemeingültiger Hormonerklärung erzählt.

Private Texte ausschließlich lokal unter `build/redaktion/spicy-ton/innenansichten/`: Vorherstand, vier neue Fassungen, Gesamtentwurf der Reihe, Einzelvergleich und Quellnachweis. Die ursprüngliche private Reihenquelle wird nicht überschrieben. Quelle/Abgleich im lokalen `quellnachweis.json`; keine privaten Texte in diesem Dokument oder einem Auftrag an Cloud-Hilfsagenten.

## Neuvertonung läuft seriell

- `tools/spicy_ton_produktion.py`: genau 150 reguläre Aufnahmen, getrennt unter `build/redaktion/spicy-ton/produktion/`.
- `tools/spicy_ton_fortsetzen.py`: wartet ohne geladenes Sprachmodell auf den laufenden Stapel, startet danach `tools/spicy_ton_innen_produktion.py` für 24 Szenendateien (vier Fassungen × sechs Szenen), dann `tools/spicy_ton_abschluss.py`.
- Gleiche exklusiv gesperrte Produktion, bisherige freigegebene Sprechprofile/Stimmen, Offline-Kokoro und bestehende Aussprachepflege. Keine zweite parallele Synthese. Lokale Overrides aus AG-26 ausdrücklich in Fingerprints erfasst; globales Lexikon unverändert.
- Fortschritt/Fehler: `build/redaktion/spicy-ton/produktion/status.json`, `innenansichten/produktion/status.json`, `nachtlauf.json`; Logs daneben. Ein Fehler wird festgehalten, nicht als Abschluss gemeldet.
- Nach erfolgreichem Abschluss entstehen `abschluss.json`, `UEBERGABE_AUDIO.json` (174 genaue Dateien, Hashes, Dauern und Paketziele) und `HOERPROBEN.html`. Bis diese Dateien vollständig vorliegen, keine Fertigmeldung der Audios. Hörabnahme neuer Dateien bleibt gesondert offen.
- Die Ziele sind Teilbestände der vorhandenen Pakete. Claude muss sie in vollständige Bestände übernehmen; niemals nur diese Teilbestände als komplettes Paket ausliefern. Die gesondert abgenommene AG-26-Aufnahme `de/prost_3` zusätzlich erhalten.

## Bereits geprüft

33 gezielte Flutter-Tests (DE/EN, PO-Abgleich, Paar-Abend, Selbst-/Einschlaf-/Traum-Reise, Spicy-Gates) bestanden. Alle fünf neuen Werkzeuge kompilierbar. Vorher-/Nachher-Abgleich aller zehn öffentlichen JSON-Dateien bestanden: nur erlaubte Textfelder geändert, Aufgaben/Metadaten/Normaltexte erhalten; Kurs-Haupttexte unverändert. Gleichwertige Prüfung der privaten Struktur: vier Fassungen, jeweils sechs Szenen, Stimmenzuordnung und andere Fassungen unverändert.
