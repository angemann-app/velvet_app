# Optionaler Schlafdaten-Abgleich für die Traumpraxis

## Verbindliche Nutzerentscheidung

„Dann streichen wir vorerst die live funktionen und würden nur die Schlafdaten abgleichen.“ Damit ist der Umfang auf nachträglich verfügbare Schlafdaten begrenzt. Live-Funktionen werden zurückgestellt, nicht als technisch zugesicherte spätere Fähigkeit eines Geräts angekündigt.

## Ziel

Freiwillig verfügbare Schlafdaten neben den eigenen Traumpraxis-Beobachtungen derselben Nacht anzeigen. Schlafdauer und Zeitfenster, verfügbare Wach-/Schlafphasen und die selbst berichtete Erholung beziehungsweise Tageslust lassen sich im Rückblick gemeinsam betrachten. Keine automatische Traumdeutung, Diagnose oder behauptete Ursache für Lust oder Höhepunkte.

### Ergänzung vom Nutzer freigegeben: verständlicher Traum-Rückblick

Die Einstiegsansicht verbindet die letzten sieben lokalen Kalendertage mit dem vorhandenen Traumtagebuch und den Tagesbeobachtungen. Zuordnung über das Aufwachdatum der importierten Sitzung, bei Tagebucheinträgen über deren lokales Eintragsdatum; keine Behauptung einer exakten Ereigniszeit. Eine Nacht mit mehreren Quellen/Sitzungen wird nicht zu einer erfundenen Gesamtdauer verrechnet. Ohne Wearable bleiben eigene Beobachtungen sichtbar. Fehlende Angaben sind unbekannt, kein negatives Ergebnis.

Redaktioneller Einstieg „Was deine Nächte erzählen“, danach tageweise Messwerte und eigene Traumerinnerung/Klarheit/Sinnlichkeit, nachvollziehbare Zählung berichteter Klarträume im Siebentagefenster und ein freiwilliger nächster Schritt zum bestehenden Tagebuch oder zur bestehenden Traumpraxis. Belastende Einträge haben Vorrang vor Fortschrittsanreizen; vorhandene Pausenregel wiederverwenden. Keine Erfolgsquote, Diagnose, automatische Deutung oder Ableitung von Klarträumen/Orgasmen aus Schlafphasen. Import und technische Details werden in einem aufklappbaren Abschnitt untergeordnet. DE/EN, lokal berechnet, keine neuen gespeicherten Daten oder Audiofassungen nötig.

## Abgestimmter Umfang

- Optionaler Import bereits synchronisierter Daten, kein permanenter Sensorzugriff.
- Nächte anhand Beginn/Ende und Zeitzone zuordnen, nicht bloß nach Synchronisierungstag. Spätere Korrekturen und fehlende Daten sichtbar behandeln; Messwerte und eigene Angaben getrennt lassen.
- Traumpraxis bleibt vollständig ohne Wearable und ohne Berechtigung nutzbar. Verweigerung oder Widerruf blockiert keine Übung.
- Import und Anzeige lokal; keine automatische Weitergabe an Paarraum oder Coach. Datenquelle und Zeitpunkt des letzten Abgleichs sichtbar halten.
- Berechtigungen auf tatsächlich benötigte Schlafdaten beschränken. Löschen/Trennen und Umgang mit bereits importierten Daten vor Umsetzung konkretisieren. Neue gespeicherte Daten in Backup/Backup-Merge berücksichtigen.
- Oberfläche, Anleitung und Fehlzustände DE/EN. Vorhandene diskrete Beschriftungen und Spicy-Zugänge respektieren.

## Vorerst ausgeschlossen

Keine Live-REM-Erkennung, Echtzeit-Schlafphasenerkennung, Vibrations-/Audioauslösung anhand einer vermeintlichen aktuellen Schlafphase, nächtliche Live-Steuerung oder automatische Wearable-Wecksignale. Vorhandenes freiwilliges zeitbasiertes Wecken bleibt ein eigenes bestehendes Angebot und wird nicht als Wearable-Funktion umgedeutet.

## Technisch noch zu klären

Konkreten Importweg zunächst mit dem vorhandenen Fitbit Air prüfen: welche abgeschlossenen Schlafdaten über einen unterstützten Android-Datenzugang bzw. eine offizielle Schnittstelle tatsächlich ankommen, mit welchen Berechtigungen und welcher Verzögerung. Health Connect nicht ungeprüft als funktionierenden Fitbit-Air-Pfad voraussetzen. Für einen Cloud-Import OAuth, nötige externe Infrastruktur und Datenfluss ausdrücklich im Umsetzungsvorschlag benennen; keine vorhandenen Tokens/Schlüssel übernehmen oder still neue Kontoverknüpfung einrichten.

Umsetzungsschritte: Datenzugang/Beispieldatensatz prüfen, kleiner Adapter und lokales Nachtmodell, optionaler Einstellungs-/Importweg, Abgleich im vorhandenen Rückblick, Backup-/Zeit-/Duplikat-/Berechtigungstests und Gerätetest. Keine Live-Funktionen einplanen. Konkrete Speicher-/Löschentscheidungen und Schnittstellenwahl vor Implementierung festhalten.

## Status

Richtung freigegeben; Umsetzung am 03.11.2026 im Arbeitsbaum: optionaler manueller Health-Connect-Import, lokale Speicherung mit Backup-Merge und eigener Löschfunktion, DE/EN-Seite in Traumpraxis. Automatische Tests und Android-Kompilierung geprüft. Echter Fitbit-Air-Datenweg und Berechtigungsablauf auf Android 15/16 noch am Gerät zu prüfen. Keine neue Abhängigkeit und kein Release ausgelöst.


## Umsetzung konkretisiert – Nutzerentscheidungen

Der Nutzer hat die Umsetzung jetzt beauftragt. Zielgeräte Android 15 und 16, ausdrücklich genannt. Daher nativer Health-Connect-Zugang ab Android 14 ohne zusätzliche Flutter-/Jetpack-Abhängigkeit; Haupt-App bleibt ab Android 7 nutzbar, ältere Systeme zeigen den optionalen Import als nicht verfügbar. Nur READ_SLEEP, kein Schreibrecht, kein Hintergrund-/historischer Zusatz-Zugriff, manueller Abgleich der letzten 30 Tage. Fitbit-/Google-Health-App muss ihre Schlafdaten nach Health Connect freigeben; kein Google-Login/Cloudzugriff durch VelvetPulse.

Nutzerentscheidung zum Trennen: **Daten behalten, getrenntes Löschen anbieten.** Trennen beendet den Abgleich in VelvetPulse; Android-Berechtigungen zusätzlich über die Systemverwaltung einsehbar/widerrufbar. Keine Behauptung, ein bloß lokales Trennen widerrufe automatisch die Systemberechtigung. Explizites Löschen entfernt importierte Daten, nicht eigene Tagebuch-/Praxis-Einträge. Löschwasserzeichen im Backup-Merge verhindern Wiederherstellung aus älteren Sicherungen. Gerätespezifische Verbindungs-/Berechtigungsfreigabe wird nicht aus einem Backup auf einem neuen Gerät aktiviert.

Importsitzungen nach Quelle plus stabiler Record-ID getrennt halten, nur abgeschlossene Datensätze übernehmen. Aufwachdatum mit dem gelieferten End-Zeitzonenoffset (sonst Gerätezeitzone) verwenden; Zeitfenster und Schlafzeit unterscheiden. Fehlende/überlappende/unbekannte Phasen dürfen keine erfundene Gesamtschlafdauer liefern. Mehrere Quellen nicht automatisch addieren. Beim Import eine Quelle ausdrücklich auswählen, wenn mehrere vorhanden sind. Maximal 500 gespeicherte Sitzungen, bei Überschreitung klarer Fehler statt stiller Löschung. Im ersten Ausbau keine automatische Datenbereinigung oder Hintergrundsynchronisierung.

Offizielle Grundlagen: https://developer.android.com/health-and-fitness/health-connect/experiences/sleep ; https://developer.android.com/reference/android/health/connect/HealthConnectManager ; https://support.google.com/googlehealth/answer/14506680?hl=en . Tatsächliche Fitbit-Air-Datenlieferung bleibt am Gerät zu prüfen. Keine Aussage über erfolgreiche Geräteprüfung ohne realen Import.
