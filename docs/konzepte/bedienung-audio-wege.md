# Bedienung, Weiterhören, Finden und gemeinsames Erleben

02.11.2026. Nutzer hat die fünf Vorschläge ausdrücklich mit „Klingt alles gut. Mach“ freigegeben. Gemeinsames Hören war bereits in `gemeinsam-erleben.md` geplant. Ergänzende ausdrückliche Entscheidung: Passende Aufnahme auf beiden Geräten erforderlich, keine Geräte-Stimme als gemeinsamer Ersatz.

## Freigegebener Umfang

1. Wiedergaben nach Schließen wiederfinden und fortsetzen; gemeinsame laufende Wiedergabe mit kleinem Player über die Bereiche hinweg. Bestehende Audioinhalte, Abläufe und Intensitäten erhalten.
2. Lokale Suche über Kurse, Lektionen, Audioangebote und Übungen. Nur gerade zugängliche Inhalte, keine privaten Tagebuch-/Paar-/Coach-Daten, keine Suchhistorie und keine Cloud-Anfrage.
3. Persönlicher Weg aus Wissen, passender vorhandener Übung und Nachspüren; freiwillig, ohne Serien-/Leistungsdruck. Keine neuen Inhaltstexte produzieren. Bestehende Aufgaben/Reflexionen weiterverwenden.
4. Gemeinsames Hören nach `gemeinsam-erleben.md`: Einladung, beide bereit, Uhrabgleich/Countdown, Pause von beiden Seiten, Fortsetzen erst nach beiderseitiger Bereitschaft, Rückblick über bestehenden Reflexionsweg. Keine perfekte Echtzeitgleichheit versprechen.
5. Verfügbarkeit direkt am Angebot anzeigen: Aufnahme vorhanden, Paket erforderlich, Geräte-Stimme verfügbar bzw. passende Datei für gemeinsames Hören erforderlich. Bestehende signierte Paketverwaltung nutzen.

## Architekturentscheidungen

- Gemeinsame Wiedergabesitzung besitzt die Player, statt dass ein verschwundener Bildschirm die laufende Wiedergabe zerstört. Genaue Ablauf-/Segment-IDs und Position sichern, einen zufällig geplanten Abend nicht beim Fortsetzen neu zusammenstellen.
- Gemeinsame Zustands-/Steuerungsoberfläche für Lektionen und segmentierte Angebote. Native Aufnahmeenden und tatsächlich verstrichene Zeit berücksichtigen; Pausezeiten nicht mitzählen. Kopf­hörertrennung und Lautsprecher-Nachfrage bleiben verbindlich nach den vorhandenen Einstellungen.
- Neue gespeicherte Zustände in Sicherung und deterministischen Backup-Merge aufnehmen. Keine Texte, Schlüssel oder private Gesprächsdaten in Wiedergabemerkern. Spicy-Merker beim Ausschalten nicht öffnen/abspielen; diskrete Titel auch im kleinen Player neutral.
- Suchindex als generischer, rein lokaler Textindex; Adapter liefert bereits gefilterte öffentliche Inhalte. DE/EN und bestehende Inhalte/IDs erhalten.
- Für gemeinsames Hören bestehende verschlüsselte flüchtige Signale nach deren vorhandener Signatur-/Absender-/Altersprüfung verwenden. Zusätzlich Sitzung/Nonce/Sequenz und Teilnehmerzustand prüfen; ein fremdes, altes oder doppeltes Signal darf keine Wiedergabe auslösen. Keine neue Krypto.
- Gemeinsames Hören nur bei passender Aufnahme auf beiden Geräten, bestätigter Einladung/Bereitschaft und bei Spicy nur mit beiderseitig aktiviertem Modus. Keine automatische Wiedergabe durch den Eingang eines Signals. Der Kopfhörerhinweis bleibt Hinweis, Lautsprecherfreigabe wie bisher.
- Das frühere Konzept wird in seinen Stufen 1 und 2 umgesetzt. Jede Person darf ihren Rückblick beginnen; keine Pflichtantwort. Gemeinsames Atem-/Beckenbodentiming und zusätzliche Paar-Abend-Stationen sind spätere eigene Ausbaustufen, keine Voraussetzung dieses Auftrags.
- Verbindungsverlust nach bestehendem Konzept sichtbar melden; lokale Pause bleibt immer möglich, perfekte Fernpause ohne Netz wird nicht behauptet. Reconnect startet niemals automatisch weiter.
- Kein App-Release und kein Paketupload ohne die gesonderten Freigaben. UI-Texte DE/EN ausschließlich ARB; Anleitung und Release-Entwurf mitführen.

## Arbeit und Prüfung

Branch `codex/bedienung-audio-gemeinsam-20261102`, bestehende Arbeitsdateien erhalten. Vorheriger verfolgter Stand zusätzlich in `build/bedienung/bestand-vor-ausbau.patch`, Liste der vorher unversionierten Dateien daneben. Keine alten Änderungen überschreiben.

Reihenfolge: gemeinsame Wiedergabe-/Speichergrundlage, Weiterhören und Steuerelemente, Suche/Offline-Status, persönlicher Weg, gemeinsames Hören und Rückblick. Jede Stufe separat prüfen; Abschluss mit Analyse, vollständigen Tests, Sicherheits-/Backup-Merge-Tests und gerenderten DE/EN-Ansichten in den drei Atmosphären. Gerätetest nur als tatsächlich durchgeführt ausweisen.
