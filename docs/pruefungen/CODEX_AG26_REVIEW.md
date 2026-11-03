# Codex-Prüfung AG-26 – 02.11.2026

## AG-26 endgültig: Dateiprüfung und lokale Übergabe abgeschlossen – 02.11.2026

Die von AG abgenommene Aufnahme wurde am mitgeteilten Scratch-Pfad gefunden, SHA256 exakt bestätigt und vollständig dekodiert (196,65 s, Opus/48 kHz/Mono). Unverändert einschließlich Master-WAV/Erzeugungsskript gesichert unter `build/redaktion/gesamt/korrektur-ag26/abgenommen-ag/`. Maßgeblich ist ausschließlich Hash `fad66de4df536448f181723513a26fb4b09907a2ca422d0213c53c62cbd1ad5e`. Vollständige Übergabe und Hinweise zur Lexikon-/Fingerprintpflege: `docs/pruefungen/AG26_FINALE_UEBERGABE.md`. Frühere Meldungen „Datei fehlt“ / „Gegenhören offen“ sind für diese finale Datei überholt. Noch keine Paketübernahme/Veröffentlichung und keine globale Lexikonänderung durch Codex. Claude kann die exakte freigegebene Datei übernehmen; keine erneute Synthese nötig.

## Finaler Stand: AG-Abnahme liegt vor, Audiodatei fehlt zur Übernahme

AG-Commit `b81178a`: separate Neusynthese laut Bericht vom Nutzer genehmigt, vollständige multimodale Abnahme von `prost_3_test_gesamt.opus` (196,65 s), SHA256 `fad66de4df536448f181723513a26fb4b09907a2ca422d0213c53c62cbd1ad5e`. Nutzer hat finale Freigabe übermittelt. Akustischer Status laut AG abgeschlossen. Technische Zuordnung/Übernahme noch offen: Datei in den Projektordnern nicht auffindbar, absoluter Ablagepfad fehlt. Unsere `final-runde3` ist ausdrücklich nicht diese Datei und wurde zwischenzeitlich von AG wegen Wortbruch verworfen. Nicht verwechseln oder erneut als finale Aufnahme ausgeben. Bericht und Nutzerfreigabe ersetzen keinen Hashabgleich der zu übernehmenden Datei.

## Nachtrag: Prüfmethode erklärt – Commit 245c4c4

AG hat das prüfende Modell („Gemini 3.8 Flash“, laut AG) und direkte multimodale Verarbeitung der originalen Opus-Dateien über `read_file` dokumentiert; ausdrücklich keine reine Transkript-/Metadatenauswertung. Zusammen mit der Bestätigung des Nutzers zum Modellwechsel ist der frühere Widerspruch erklärt. Die unten stehende vorläufige Sperrbewertung ist damit überholt. AGs Ergebnis wird als **modellgestützte akustische Stichprobe** übernommen: 27 unauffällig, eine Aufnahme mit Aussprachebefund. Keine eigene Codex-Hörprüfung oder unabhängige Verifikation des AG-Werkzeugs behauptet.

Dateiumfang erneut geprüft: weiterhin ausschließlich die erlaubte Reportdatei geändert. Offen bleibt die gezielte Prüfung/Korrektur von `de/prost_3`, Martin: „Prostata“ bei 1:44 sowie der leichte Hinweis zu „Herstellerangaben“ bei 2:38. Keine Wiederholung aller 28 Proben erforderlich. Noch keine Korrekturaufnahme, Zusammenführung oder Veröffentlichung durch Codex erfolgt. Die ursprüngliche Bewertung bleibt unten als Verlauf erhalten.

## Ergebnis: Hörabnahme noch nicht belastbar

AG-Branch `ag/26-audio-stichprobe-20261102` im separaten Klon lesend geprüft. Gegen den Ausgangscommit `2c34cc5` wurde ausschließlich die erlaubte Datei `docs/pruefungen/AG26_AUDIO_STICHPROBE.md` hinzugefügt. Keine Aufnahme oder Aussprachedatei verändert. Flutter-Tests sind für diesen reinen Bericht nicht erforderlich.

Commit `0df6392` erklärt ausdrücklich: keine akustische Hörprüfung, Agentenumgebung ohne Audioausgabe/Gehör, alle 28 Proben nicht prüfbar. Commit `526ae51` ersetzt diese Angaben durch eine behauptete vollständige akustische Prüfung mit 27 unauffälligen Proben und einem Befund. Der neue Bericht nennt weder geänderte Prüfmöglichkeit noch akustisches Werkzeug oder menschlichen Prüfer. Das ist ein ungeklärter Widerspruch; die Hörabnahme daher nicht als bestanden übernehmen. Eine tatsächliche Prüfung ist damit nicht widerlegt, aber nicht nachvollziehbar belegt.

Zudem nennt die Zeile `de/prost_3` neben „Prostata“ bei 1:44 einen zweiten kleinen Hinweis: „Herstellerangaben“ bei 2:38 klingt leicht getrennt wie „Hersteller-rangaben“. Dieser Hinweis fehlt in der knappen Abschlussmeldung. Beide Zeitmarken sind als unbestätigte AG-Meldungen zu behandeln, nicht als eigene Hörbefunde.

## Gezielte Klärung für Claude / AG

AG soll erläutern, wer bzw. welches akustisch auswertende Werkzeug die Dateien tatsächlich gehört hat und wodurch die zunächst fehlende Fähigkeit verfügbar wurde. Wenn keine akustische Prüfung stattfand, Status auf „nicht prüfbar“ korrigieren. Alternativ die vorbereiteten Stichproben tatsächlich menschlich gegenhören. Keine Vollprüfung sämtlicher Dateien erforderlich.

Bis dahin kein neuer Syntheselauf und keine Änderung des globalen Lexikons allein auf Grundlage dieses Berichts. `tools/aussprache.json` enthält bereits `prostata: pɾˈɔstata`. Erst die Stelle tatsächlich hören und die angewandte Ersetzung prüfen, dann bei Bedarf gezielte Vergleichshörprobe. Kein Merge, Paketupload oder Release durch diese Prüfung ausgelöst. Die technische Dateiprüfung bleibt davon unabhängig bestanden.
