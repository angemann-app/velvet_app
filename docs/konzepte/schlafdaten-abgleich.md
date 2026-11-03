# Optionaler Schlafdaten-Abgleich für die Traumpraxis

## Verbindliche Nutzerentscheidung

„Dann streichen wir vorerst die live funktionen und würden nur die Schlafdaten abgleichen.“ Damit ist der Umfang auf nachträglich verfügbare Schlafdaten begrenzt. Live-Funktionen werden zurückgestellt, nicht als technisch zugesicherte spätere Fähigkeit eines Geräts angekündigt.

## Ziel

Freiwillig verfügbare Schlafdaten neben den eigenen Traumpraxis-Beobachtungen derselben Nacht anzeigen. Schlafdauer und Zeitfenster, verfügbare Wach-/Schlafphasen und die selbst berichtete Erholung beziehungsweise Tageslust lassen sich im Rückblick gemeinsam betrachten. Keine automatische Traumdeutung, Diagnose oder behauptete Ursache für Lust oder Höhepunkte.

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

Richtung freigegeben, Konzept dokumentiert. Noch keine Wearable-Anbindung implementiert, keine neue Abhängigkeit und kein Release ausgelöst. Kein neuer Blocker für den laufenden Beta-Bau aus dieser Konzeptentscheidung allein ableiten.
