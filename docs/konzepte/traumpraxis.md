# Traumpraxis: Lust vom Traum in den Tag tragen

01.11.2026. Nutzerauftrag: luzides Träumen mit dem Ziel sinnlicher Träume, möglicher Orgasmen und mehr Lust im Alltag weiterentwickeln; bei Bedarf Modul umbauen. Auch noch nicht belegte Möglichkeiten dürfen erkundet werden. Ergänzt `lust-im-traum.md`, ersetzt nicht dessen acht Folgen oder Textgrenzen.

Aktueller Stand: persönlicher Übungsweg mit dauerhaften Traumzeichen, eigener Abendvorbereitung und freiwilligen Tagesbeobachtungen umgesetzt. Die Produktionsentscheidungen weiter unten ersetzen die zunächst nur flüchtige Auswahl des ersten Schritts. Bestehende acht Audiofolgen werden weiterverwendet.

## Frühere Entscheidungen für den ersten Umsetzungsschritt

- Eigener Einstieg „Deine Traumpraxis“ in Lust im Traum, nur im Spicy-Modus. Drei zusammenhängende Schritte: Erinnern, Erkennen, Mitnehmen. Die vorhandenen Folgen und Pakete bleiben nutzbar.
- Erinnern: vorhandenes privates Tagebuch öffnen, Sinnlichkeit und Höhepunkte weiterhin mit den vorhandenen Markierungen festhalten. Keine Orgasmusquote, kein Erfolgsscore.
- Erkennen: einen eigenen, angenehmen Tagebucheintrag auswählen und eine MILD-orientierte Vorstellungsübung durchgehen: Traum erinnern, ungewöhnliches Zeichen bemerken, Erkennen vorstellen, Absicht setzen, loslassen. Alternativ ohne Eintrag mit einer eigenen Erinnerung arbeiten. Die kurze Abendfassung ist eine Produktanpassung, keine in dieser Form validierte Intervention.
- Mitnehmen: angenehme Empfindung erinnern, im wachen Körper nachspüren, freiwillig eine kleine sinnliche Alltagserfahrung wählen und später im vorhandenen Tagebuch notieren, was tatsächlich anders war. Keine neue erotische Szene und keine Berührungsanweisung zur Orgasmusinduktion.
- Ein Höhepunkt darf als mögliche Erfahrung ausdrücklich genannt bleiben. Traumbericht und körperlich nachgewiesener Orgasmus sind verschieden; die App erkennt oder misst keinen körperlichen Orgasmus. Mehrere Höhepunkte sind kein Fortschrittskriterium.
- Ziel und Hypothese auseinanderhalten: mehr Tageslust ist ein Erkundungsziel, keine bereits bewiesene Wirkung der App. Individuelle Beobachtungen zeigen keine Kausalität.
- Vorlagen lokal und nur für die aktuelle Sitzung wählen, keine neue gespeicherte Datenstruktur. Bestehendes Tagebuch bleibt in Backup/Merge. Keine automatische Analyse, Übertragung an Coach/Partner oder Textverarbeitung in der Cloud.
- Belastend markierte/nicht erinnerte Einträge werden nicht als Übungsvorlagen angeboten. Bestehende Pause-Regel (drei belastende der letzten sieben Einträge) gilt auch hier: Hinweis und Tagebuch statt aktiver MILD-Anleitung.
- Kein neues nächtliches Wecken, keine REM-Erkennung, keine Signale im Schlaf. Bestehendes freiwilliges Wecken bleibt unverändert.
- DE/EN-Oberfläche aus ARB; Magazin-Tokens, skalierende Texte und schmale Displays berücksichtigen. Kein Paket-, Audio- oder Releasewechsel.

## Wissenschaftliche Einordnung

- [ILDIS, 2020](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2020.01746/full): MILD/SSILD, vor allem in Verbindung mit WBTB untersucht; kein Nachweis einer Libido-Steigerung durch diese App.
- [Erlacher und Stumbrys, 2020](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2020.01383/full): Laboruntersuchung WBTB/MILD, kein Erfolg für alle.
- [Schredl et al., Tagebuchstudie](https://pubmed.ncbi.nlm.nih.gov/33089191/): Erholung und Schlafdauer mitbeobachten; keine pauschale Aussage, jede Klartraumübung verbessere den Schlaf.
- [Aspy, Dissertation, 2017](https://digital.library.adelaide.edu.au/dspace/bitstream/2440/119335/1/Aspy2017_PhD.pdf): historische Kleinststudien zu sexuellen Klarträumen besprochen; keine belastbare Methode zur gezielten Erzeugung von Orgasmen oder Mehrfachorgasmen ableiten.

## Umsetzung des ersten Schritts

`lib/models/traumpraxis.dart` filtert Vorlagen und übernimmt die vorhandene Pause-Regel. `traumpraxis_screen.dart` führt durch die drei Tageszeiten und öffnet das bestehende Traumtagebuch. Der Einstieg liegt in `lust_im_traum_screen.dart`. 21 neue ARB-Schlüssel je Sprache, sechs gezielte Modell-/Widgettests, inklusive Spicy-Umschaltung und 360 × 640 mit 1,6-facher Schrift in DE/EN. Analyse ohne Befund, alle 351 Flutter-Tests bestanden. Anleitung in beiden Sprachen und Markdown mitgeführt. Screenshotlauf unter `build/redaktion/gesamt/traumpraxis-screens.log`. Noch kein Release oder neues Audiopaket.

## Produktionsumfang (Freigabe 01.11.2026)

„Mach deine Vision produktionsreif“ gibt die folgenden Erweiterungen frei:

- Persönliche Traumzeichen lokal anlegen, auswählen und löschen; Auswahl konkret in die MILD-Vorbereitung aufnehmen. Zeichen stehen für selbst benannte Beobachtungen, keine automatische Traumdeutung.
- Eine freiwillige Tagesbeobachtung pro Kalendertag: Erholung und Tageslust (je fünf Stufen), optional sinnlicher Traum, Klartraum, erlebter Höhepunkt und freie Notiz. Nicht beantwortete Felder bleiben unbekannt. Kein Erfolgsscore und keine Kausalitätsaussage.
- Privater chronologischer Rückblick mit Datum, beantworteten Beobachtungen und Notiz. Kein Partner-/Coach-Zugriff. Alle Werte wieder bearbeitbar und löschbar.
- Neue Daten in einem getrennten lokalen `traumpraxis`-Block; BackupCodec nimmt dessen Map auf. Zusammenführung je Datensatz-ID nach Änderungszeit; Löschmarkierungen verhindern Wiederauferstehen beim Import alter Sicherungen. Bei Gleichstand deterministischer Vergleich. Alte Sicherungen ohne Block lassen neue Daten unverändert.
- Navigation zur vorhandenen Abendserie mit einer passenden freigeschalteten Folge; bestehende Sperrregeln bleiben verbindlich. Keine erfundenen neuen Audios oder veränderten privaten Pakettexte. Die persönliche Vorbereitung ist eine funktionale Anleitung, nicht Teil einer neu vertonten erotischen Erzählung.
- Modell-, Speicher-/Backup-Merge-, Spicy- und Formularprüfungen; DE/EN, kleine Displays und Schriftskalierung, gerenderte Ansicht. Keine Veröffentlichung ohne separate Releasefreigabe.

## Implementierung und Prüfung des Produktionsausbaus

- Datenmodell `lib/models/traumpraxis_daten.dart`: validierte Zeichen/Tagesbeobachtungen, unbekannte Antworten als null, chronologische Anzeige, deterministische Zusammenführung und inhaltsfreie Löschmarkierungen.
- `StorageService`: lokale Speicherung, Auto-Backup, validierter Import/Merge. Bestehende beschädigte Daten werden nicht durch eine neue Speicherung überschrieben. Bei zurückgestellter Geräteuhr bleiben ausdrückliche Bearbeitungen möglich. `BackupCodec` nur um das neue Map-Feld ergänzt; Krypto- und Sicherheitslogik unverändert.
- `traumpraxis_screen.dart` mit Zeichenwahl und Orientierung anhand bereits freier Folgen; `traumpraxis_verwalten.dart` für Anlegen/Bearbeiten/Löschen und Rückblick. Keine Orgasmusquote und keine automatische Wertung der Tageslust. Alle neuen Texte DE/EN, Anleitung synchronisiert.
- Tests für Speicherwiederherstellung, Löschungen gegen alte Backups, Null/Nein/Nullstufe, mehrere Tage, beschädigte Imports ohne Teiländerung, defekte lokale Daten, doppelte IDs sowie Formulare, Auswahl, Spicy-Zugang und 1,6-fache Schrift auf kleinem Display.
- Reproduzierbare Renderprüfung: `flutter test test_screens/screens_test.dart --dart-define=SPICY=true --dart-define=STRICT=true --dart-define=TRAUMPRAXIS=true`, Englisch zusätzlich `--dart-define=LANG=en`. Der isolierte Lauf verlangt Fehlerfreiheit aller neuen Ansichten. Separate DE/EN-Verzeichnisse; geladene Testschriften auch für FilledButton und ChoiceChip. Ausschließlich erfundene Beispieldaten, kein privater Inhalt.
- Gerenderte Ansichten unter `build/screens_spicy/` und `build/screens_spicy_en/`: `15_traumpraxis`, `15_traumpraxis_abend`, `16_traumzeichen`, `17_tagesbeobachtung`, `17_tagesbeobachtung_unten`, `18_traumpraxis_rueckblick`.
- Vor Veröffentlichung bleibt ein echter Gerätetest sinnvoll; kein Release beauftragt. Neue Texte/Vertonungen der privaten acht Abendfolgen sind durch diese Funktionsumsetzung nicht ersetzt. Laufende Gesamt-Neuvertonung getrennt weitergeführt.
- Abschlussprüfung: 361 Flutter-Tests, Analyse ohne Befund, isolierte Renderprüfung DE/EN ohne Fehler; neue Ansichten visuell geprüft. Übergabe und genauer Audio-Status im gemeinsamen Claude-Protokoll.

## Eigene Hörbegleitungen (02.11.2026)

Nutzer hat nach der Textarbeit ausdrücklich auch die Produktion durch Codex beauftragt. Die folgenden drei Begleitungen ergänzen Claudes acht vorhandene Folgen:

| ID | Titel | Einsatz |
|---|---|---|
| `praxis_abend` | Eine Spur in die Nacht | einmal vor dem Einschlafen oder einer Abendfolge; ruhiges offenes Ende |
| `praxis_klarheit` | Wenn du den Traum erkennst | wache Vorstellungsübung am Tag/frühen Abend; keine Wiedergabe im Schlaf |
| `praxis_morgen` | Etwas von der Nacht mitnehmen | angenehme Erinnerung, Körperwahrnehmung, freiwillige Tagesbeobachtung |

- Kanonische Quelle `docs/redaktion/traumpraxis/hoertexte.json`, mit vollständigen DE/EN-Fassungen. Je zehn Absätze, keine persönlichen Platzhalter und kein dynamisches Einsprechen privater Tagebuchtexte. Sprachlich eigenständige englische Übertragung; 360 bis 392 deutsche und 380 bis 406 englische Wörter.
- Die Hörtexte sind aktive Vorbereitungen bzw. Morgenbegleitung, keine passiven Lernbausteine der Einschlaf-Reise. Deshalb sanfte Anleitungen erlaubt. Ruhiger Ton, keine ausgeführte sexuelle Handlung, Höhepunkte nur als mögliche Erfahrung/Erlaubnis. Die wache Übung endet mit Orientierung im tatsächlichen Raum, die Abendbegleitung ohne Rückholsignal.
- Zwölf Dateien: drei Texte, zwei Sprachen, zwei Einzelstimmen (Victoria und Martin). Keine Sprecherwechsel. Vorhandenes vom Nutzer mit „passt“ freigegebenes Ausdrucksprofil `lektionsausdruck-1`, Szene `wissen`, unverändert; kein heimlich neu eingeführtes Sprechprofil. Aussprache über bestehendes Lexikon bei DE, englische Lautverarbeitung bei EN. Hörbewertung der neuen Inhalte ausdrücklich offen.
- Produktion lokal durch `tools/traumpraxis_hoertexte.py --einschieben`. Gemeinsame Windows-Dateisperre, kontrollierter Halt der vorhandenen Produktion zwischen Dateien, danach automatisches Fortsetzen der geführten Aufnahmen. Fremde Pausen werden nie entfernt. Drei modellfreie Koordinationstests bestanden.
- Aufnahmen nur unter `build/redaktion/traumpraxis/audio/<de|en>/`. Separate Manifeste, Prüfsummen, gemessene Dauern, WAV-Pegel/Clipping-Anteil. `traumpraxis_abnahme.py` prüft Quellen/Fingerprints, Opus-Dekodierinformationen, Mono und Laufzeit; erstellt `ABNAHME.html`. `traumpraxis_pruefung_fortsetzen.py` aktualisiert diese Prüfung bei neuen Dateien.
- Lesefassungen `build/redaktion/traumpraxis/HOERTEXTE.de.md` und `.en.md`. Kein Upload, keine Paketversion geändert, keine vorhandenen Audios überschrieben. Erst nach Hörprüfung die Paket-/Playerintegration dieser zusätzlichen Dateien abschließen; aktuell sind sie noch keine abspielbaren neuen Einträge in der App. Die vorhandene Traumpraxis-Oberfläche und die acht alten Folgen funktionieren unverändert.


## Präzisierung des Audio-Anschlusses durch Nutzer-Nachfrage

Die drei vorbereiteten Begleitungen gehören in die kommende Beta. Konkrete Titel/IDs und Spicy-18+-Zuordnung aus der vorhandenen kanonischen Quelle bestätigt. `de-gefuehrt` / `en-gefuehrt`, Aufnahmen unter `audio/traum/<stimme>_<id>.opus`, sprachbezogener Inhaltskatalog `audio/traum/traumpraxis.json`. Bestehenden globalen Player und drei direkte Einstiege im Traumpraxis-Modul nutzen, nicht in die zufällige Einschlafplanung mischen. Kataloge und zwölf Hash-/Dauer-Zuordnungen sind lokal vorbereitet. Vollständiger technischer Anschlussauftrag an Claude: `docs/pruefungen/TRAUMPRAXIS_AUDIO_INTEGRATION_CLAUDE.md`. App-/Paketanschluss noch von Claude auszuführen; keine Veröffentlichung oder Versionsfreigabe durch diese Dokumentation.
