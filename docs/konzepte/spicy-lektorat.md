# Lektorat bestehender Spicy-Lektionen

Stand: 01.11.2026. Vom Nutzer beauftragt: bestehende Spicy-Lektionen überarbeiten, Deutsch und Englisch mitpflegen, anschließend lokale Neuvertonung nach den Regeln von Claude Code. Die neuen Innenansichten gehören nicht zu diesem Auftrag.

## Vereinbarter Umfang

- Sprachliches Lektorat, verständlichere Übergänge, fachliche Präzisierung, weniger pauschale Wirkversprechen.
- Vorhandene explizite Dialogbeispiele werden übernommen; keine neuen erotischen Szenen oder Erweiterungen dieser Dialoge.
- Titel, Zusammenfassungen, Reflexionsfragen, IDs, Stimmen, Kurszuordnungen und technische Metadaten bleiben erhalten. Aufgaben bleiben bis auf die vier anschließend ausdrücklich freigegebenen Korrekturen erhalten (siehe unten).
- Der aktuelle Bestand umfasst 27 Lektionen: fünf aus Spicy Solo, sechs aus Spicy zu zweit, acht aus der ursprünglichen Ergänzung, vier spätere Alltagsthemen, zwei spätere Berührungsvertiefungen und zwei Toy-Vertiefungen. In beiden Sprachdateien dieselben IDs bearbeiten.
- Entwürfe getrennt ablegen; vor Abnahme weder Produktionsinhalte ersetzen noch Aufnahmen oder Pakete veröffentlichen.

## Ergebnis zur Abnahme

Branch: `codex/lektorat-beruehrung` im Haupt-Checkout. Claude Code arbeitet weiterhin in seinem eigenen Worktree auf `fix/reihe-bildschirm-aus`.

Erzeugung: `python tools/redaktion_spicy_entwuerfe.py`.

Ausgabe unter `build/redaktion/spicy/` (von Git ignoriert):

- `INDEX.md`: alle 27 Lektionen mit Links auf Deutsch und Englisch.
- `<id>.<de|en>.md`: vollständiger Entwurf zum Lesen.
- `<id>.<de|en>.json`: vollständige Lektion mit Kurs-ID für die spätere, gezielte Übernahme.
- `<id>.<de|en>.diff`: jede Änderung am Text im Vergleich zur Produktionsquelle.
- `VERGLEICH.html`: lokale Ansicht mit Vorher und Entwurf nebeneinander, ohne externe Ressourcen.
- `manifest.json`: Quellenprüfsummen, IDs, Stimmen, Zahl der Änderungen und Textlängen. Bei späterer Übernahme zuerst prüfen, ob Claude oder AG die Quellen inzwischen geändert haben.

Die Änderungen lassen sich aus den versionierbaren Dateien `tools/redaktion_spicy_korrekturen.json`, `tools/redaktion_spicy_aufgaben.json` und `tools/redaktion_beruehrung_muster.py` reproduzieren. Es werden nur tatsächlich vorkommende Textstellen ersetzt; fehlende oder mehrdeutige Stellen führen zum Abbruch.

## Wesentliche redaktionelle Entscheidungen

- Rückmeldungen statt vermeintlich eindeutiger Körpersignale; keine automatische Bereitschaft anhand von Hüftbewegungen oder allgemeine Orgasmusvorhersage anhand der Hodenstellung.
- Empfindlichkeit und Orgasmusverläufe als individuell beschreiben; Druck, Hilfsmittel oder eine Zahl von Durchgängen nicht als Erfolgsgarantie darstellen.
- Unpräzise anatomische Ortsangaben und unbelegte Formulierungen wie „es gibt keine Studien“ oder „Studien zeigen“ enger und nachvollziehbarer formulieren.
- Schmiermittel für Genitalien und Massageöl unterscheiden. Material- und Reinigungshinweise an Herstellerangaben knüpfen.
- Safer Sex als Risikosenkung beschreiben, keine Sicherheit allein durch Exklusivität und Tests versprechen.
- Wiederkehrende oder starke Beschwerden nicht pauschal als harmlos einordnen und nicht erst nach einer Woche zur Abklärung raten.
- Rückfragen und ein Ende des Spiels jederzeit ermöglichen. Fantasie, Rolle und tatsächliche Zustimmung unterscheiden.
- Englisch sinngleich lektorieren; die jeweilige Ausgangsfassung und die vorhandenen Dialoge bleiben als Vergleich erhalten.

## Vier Aufgabenänderungen: vom Nutzer freigegeben und eingearbeitet

Der Nutzer hat am 01.11.2026 alle vier vorgeschlagenen Korrekturen ausdrücklich mit „Ja darfst du“ freigegeben. Sie betreffen fünf IDs und gelten in Deutsch und Englisch:

1. `spduo_4`: „nicht gefragt“ entfällt. Empfangen ohne Leistungsanforderung, kurze Rückfragen und ein Abbruch bleiben jederzeit möglich.
2. `mass_s1`: Ablauf und Aufgabe versprechen keinen Höhepunkt im vierten Durchgang. Gemeinsam über Weitergehen, Pause und Abschluss entscheiden; Zeit und Wiederholungen als Rahmen.
3. `alltag_6`: Keine Pflicht zum Einlösen einer Nachricht. Am Abend gemeinsam entscheiden, welche Ankündigung aufgegriffen werden soll.
4. `spsolo_1` und `toys_7`: Zahlen und Wiederholungen als subjektive Orientierung; weder eine bestimmte Stufe noch drei Durchgänge oder ein Orgasmus sind zu erreichen.

Nur diese freigegebenen Aufgabenstellen dürfen vom Original abweichen. Der Generator prüft die übrigen Aufgaben und alle bestehenden Dialogabsätze weiterhin auf wortgleichen Erhalt. Die Zustimmung betrifft diese Korrekturen; die Gesamtabnahme der Texte und Hörprobe stehen noch aus.

Weiterhin offen: `touch_w_s1` nennt in der unveränderten Zusammenfassung ein Toy, obwohl der Text keinen eigenen Toy-Abschnitt enthält. Die bestehenden Dialogbeispiele setzen vereinbarte Grenzen voraus und ersetzen keine aktuelle Zustimmung. Die Entwürfe sind keine abschließend medizinisch begutachtete Fassung.

## Quellen für die fachlichen Präzisierungen

Gelesen am 01.11.2026; keine Übernahme von Quellenformulierungen. Redaktionelle Schlussfolgerungen (z. B. keine Zusage einer Wirkung) sind von medizinisch belegten Aussagen zu unterscheiden.

- Cleveland Clinic, Anatomie und individuelle Empfindlichkeit der Klitoris: https://my.clevelandclinic.org/health/body/22823-clitoris
- NHS, Hodenschmerzen und Warnzeichen: https://www.nhs.uk/symptoms/testicle-pain/
- NHS, Vorhautbeschwerden und schmerzhafte Retraktion: https://www.nhs.uk/conditions/phimosis/
- CDC, Übertragungsrisiken bei Oralverkehr und Risikosenkung durch Barrieren: https://www.cdc.gov/sti/about/about-sti-risk-and-oral-sex.html
- NHS, Harnwegsinfekte und Empfehlungen zur Vorbeugung: https://www.nhs.uk/conditions/urinary-tract-infections-utis/
- NHS Wales, Unterbauchschmerzen und Abklärungsbedarf: https://111.wales.nhs.uk/Pelvicpain/
- healthdirect, Safer Sex, Reinigung und Risikosenkung: https://www.healthdirect.gov.au/healthy-living/physical-wellbeing/safe-sex

## Audio nach Abnahme

- Produktion lokal mit Kokoro; kein Edge-TTS und kein Versand der Texte an einen Sprachdienst.
- Deutsch: bestehende Stimmen und Stimmwechsel über `generate_audio.voice_for` und `alternate_voices` beibehalten.
- Englisch: bestehende Zuordnung `victoria -> af_heart`, `martin -> am_michael`; keine deutschen Modelle für die englische Fassung verwenden.
- Aussprachelexikon aus `tools/aussprache.json` verwenden. Neu vertonte Texte mit dem CC-Ausdrucksweg sprechen; das passende Lektionsprofil zuerst als kurze Hörprobe abnehmen lassen.
- Wichtig: `AUSDRUCK_LEKTIONEN` enthält bisher nur vier Einträge, davon zwei im aktuellen Auftrag. Vor einem Gesamtlauf die 27 Profile gezielt ergänzen und beide Generatoren prüfen.
- Wichtig: Der deutsche Ausdrucksaufruf behandelt `voice=both` derzeit nicht wie `synthesize_wav`; englisches `wav` mit Ausdrucksprofil ebenso wenig. Vor Neuvertonung dieser Paarlektionen den Absatzwechsel im Ausdrucksweg erhalten und gezielt prüfen. Keinen ungetesteten Gesamtlauf starten.
- Neue Aufnahmen zuerst getrennt erzeugen und anhören. Erst danach produktive Audios, gemessene Dauern und Prüfsummen austauschen; anschließend Paketversionen und signiertes Verzeichnis nach dem bestehenden CC-Ablauf aktualisieren.
- In dieser Bearbeitung wurden noch keine Audiodateien erzeugt, ersetzt oder hochgeladen.

## Prüfung

- Beide Muster zunächst getrennt erzeugt; anschließend alle 54 Sprachfassungen mit strengem Abgleich der Ausgangsstellen erzeugt.
- Vollständigkeit: genau 27 IDs je Sprache, je ID mindestens eine echte Textänderung.
- Aufgaben gegen den ausdrücklich freigegebenen Änderungsumfang verglichen; übrige Aufgaben und bestehende Dialogabsätze wortgleich, sämtliche Felder außer `content` unverändert.
- Produktionsquellen bleiben unverändert; Prüfsummen im Manifest dokumentiert.
- Kein Flutter-Code geändert; deshalb kein App-Testlauf für diese Entwurfsarbeit.
