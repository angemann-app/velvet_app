# AG-26 – finale Aufnahme für Claude

## Abnahme und technische Prüfung abgeschlossen

02.11.2026. AG hat die Aufnahme multimodal akustisch geprüft; der Nutzer hat die finale Freigabe übermittelt. Codex hat die tatsächliche Datei am genannten AG-Scratch-Pfad geprüft und unverändert ins lokale Projekt übernommen. Keine eigene Codex-Hörprüfung behauptet.

- Datei: `build/redaktion/gesamt/korrektur-ag26/abgenommen-ag/prost_3_test_gesamt.opus`
- SHA256: `fad66de4df536448f181723513a26fb4b09907a2ca422d0213c53c62cbd1ad5e`
- Dauer: **196,65 Sekunden**, 196650 ms
- OGG/Opus, 48.000 Hz, Mono, vollständig dekodiert; Samples endlich und nicht stumm.
- Master-WAV und tatsächliches AG-Erzeugungsskript im selben Ordner gesichert. Details/Prüfsummen in `abnahme.json`, aktuelle Textquelle in `aktueller_auftrag.json`.
- Freigegebene Einstellungen: `lektionsausdruck-1`, `wissen`, `martin`, Grundtempo 0,8; `prostata: pɾˈɔstata`, `herstellerangaben: hˈɛɾʃtɛlɐˌaŋɡaːbən`.

## Gezielte Übernahme durch Claude

Nur diese Datei verwenden, nicht die verworfenen Codex-Korrekturfassungen (`korrektur-ag26/prost_3_korrektur.opus` und `final-runde3/prost_3_korrektur.opus`). Keine erneute Synthese erforderlich. Aktuelle reguläre Produktionsaufnahme, Produktionsmanifest, Dauern und Pakete wurden bewusst noch nicht überschrieben; keine Veröffentlichung erfolgt.

Bei Übernahme `de/prost_3` mit der exakten freigegebenen Datei ersetzen und Dauer, Hash sowie Aufnahmeherkunft sauber nachführen. Herkunft ist AGs externe Synthese mit lokalen Overrides; nicht einfach den Fingerprint einer unmodifizierten Standardproduktion vergeben. Der aktuelle Quelltext ist separat gesichert; das AG-Skript lädt ihn aus dem Projekt, hat aber keinen historischen Text-Fingerprint protokolliert.

Globales Lexikon noch unverändert: `prostata` entspricht bereits der finalen Vorgabe. Den zusätzlichen Eintrag für `herstellerangaben` bei der koordinierten Lexikon-/Paketübernahme pflegen. Achtung: Das bestehende Produktionswerkzeug verwendet den Hash des gesamten Lexikons für alle deutschen Dateien. Ein neuer Eintrag darf deshalb keinen unbeabsichtigten Komplettlauf auslösen; vorhandene abgenommene Dateien erhalten und den abweichenden Aussprachekontext dieser Aufnahme ausdrücklich dokumentieren. Andere Aufnahmen mit dem Wort nach bestehendem Ausspracheablauf gezielt erfassen; keine erneute Gesamtproduktion.

Die ursprüngliche 28er-Stichprobe ist laut AG einschließlich der finalen Ersatzaufnahme akustisch abgenommen. Technische Gesamtprüfung des übrigen Bestands bleibt unverändert; dieser Nachtrag dokumentiert genau die Ersatzdatei. Paketversionen, Uploads und Beta-Build verbleiben im vereinbarten Claude-Workflow.
