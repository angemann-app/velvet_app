# Konzept: Gemeinsam erleben (synchrones Hören und Üben im Paar-Kanal)

Stand: Entwurf vom 30.10.2026; Richtung am 02.11.2026 vom Nutzer zur Umsetzung freigegeben. Entscheidungen unten aktualisiert; Gesamtauftrag `bedienung-audio-wege.md`.

## Idee

Zwei Menschen hören oder üben **zur selben Zeit**, jeder auf dem eigenen Handy, und spüren, dass der andere dabei ist.
Mit jederzeit möglichem Stopp, ohne Begründung, und mit einem Rückblick, den beide erst aufdecken, wenn beide geantwortet haben.

## Technisch machbar (geprüft)

- `NostrService.sendSignal` und `signale` (`lib/services/nostr_service.dart`, Art 21555) sind flüchtige, verschlüsselte Signale: Server reichen sie nur
  live weiter und speichern sie nicht. Sie tragen schon „bist du da?“ (`faehigSignal`) und den Aufbau für Fotos. Neue Signaltypen passen dort hinein,
  ohne neue Server oder neue gespeicherte Daten.
- Genauigkeit: Relay-Verzögerung typisch unter 1 bis 2 Sekunden. Für geführte Audios reicht das, wenn der Start über einen gemeinsamen Countdown läuft
  (Startzeit in Weltzeit plus abgeglichene Uhrdifferenz per Ping-Pong). Perfekte Gleichzeitigkeit wird nicht versprochen.
- Beide brauchen die App geöffnet (keine Hintergrund-Zustellung). Einladung nur, wenn „bist du da?“ antwortet.

## Ablauf

1. **Einladen:** Bei Audio oder Übung „Gemeinsam hören“ wählen. Signal `ge_einladung` (Audio-Id, Dauer).
2. **Annehmen:** Beim Gegenüber erscheint eine neutrale Karte „Gemeinsame Übung?“ mit Annehmen oder Später.
3. **Bereit:** Beide tippen „Bereit“ (Kopfhörer-Hinweis, Lautsprecher-Nachfrage wie in `lautsprecher.md`).
4. **Countdown 5, 4, 3 …:** Beide Geräte spielen die **eigene lokale Aufnahme** zur vereinbarten Zeit.
5. **Stopp jederzeit:** Eine Berührung pausiert **beide** sofort (`ge_pause`). Das Gegenüber sieht nur „Pause“, nie einen Grund.
   Weiter erst, wenn beide „Weiter“ sagen.
6. **Ende und Rückblick:** Jeder beantwortet eine Frage und wählt ein Gefühl. Erst wenn beide geantwortet haben, wird gemeinsam aufgedeckt.
   Der Rückblick läuft über den bestehenden Reflexions-Weg (`sendReflection`), die Antworten bleiben lokal.

## Regeln

- **Diskretion:** Alle Texte und Benachrichtigungen neutral („Gemeinsame Übung“, nie „Sex“, „erotisch“, „Traum“).
- **Datensparsam:** Signale flüchtig. Gespeichert wird lokal nur der Rückblick; er gehört in Sicherung und Backup-Merge
  (`StorageService`, `test/backup_merge_test.dart`).
- **Sicherheit:** Eingehende Signale laufen durch `NostrEventCheck`, alte Signale (über 120 s) werden verworfen, wie in `handleSignal`.
- **Einvernehmen:** Spicy-Audios nur, wenn **beide** den Spicy-Modus eingeschaltet haben. Sonst bietet die App die neutrale Fassung an.
- **Zusammen oder gar nicht:** Fällt die Verbindung aus, läuft das eigene Audio weiter, mit leisem Hinweis „Verbindung zum Gegenüber unterbrochen“.
- Neue Funktion: Anleitung (`assets/data/anleitung.json`, `docs/ANLEITUNG.md`) und „Was ist neu“ nachziehen, Texte auch auf Englisch.

## Stufen

1. **Gemeinsam hören** mit Countdown und gemeinsamer Pause (ein Audio, beide).
2. **Rückblick gemeinsam aufdecken.**
3. **Gemeinsam atmen:** Atem-Pacer und Beckenboden-Übung mit gemeinsamem Takt und sichtbarem Zeichen, dass das Gegenüber dabei ist.
4. **Anbindung an den Paar-Abend** (`paar_abend_screen.dart`): Abendablauf mit Einladung zu den Stationen.

## Tests

Wie `test/foto_kanal_test.dart`: Signalfluss mit Doppelgänger-Server, Uhrabgleich, Pause von beiden Seiten, Wiederholung nach Abbruch,
Verwerfen alter oder fremder Signale.

## Entscheidungen (02.11.2026)

1. Nutzer hat gemeinsames Hören zusammen mit den weiteren Bedienungsverbesserungen zur Umsetzung freigegeben. Stufe 1 und 2, kein ungefragtes Veröffentlichen einer Beta.
2. Ausdrücklich vom Nutzer beantwortet: **Passende Aufnahme auf beiden Geräten erforderlich.** Die frühere Geräte-Stimmen-Empfehlung entfällt; verschiedene Laufzeiten würden den gemeinsamen Ablauf verfälschen.
3. Rückblick wie empfohlen beidseitig freiwillig beginnen; Antworten erst nach beiden Eingaben sichtbar. Kein weiterer gespeicherter privater Datenbestand außerhalb des bestehenden Reflexionswegs.
4. Kopfhörer-Hinweis, kein Zwang. Vorhandene Lautsprecher-Nachfrage bleibt erhalten, Bereitschaft jeweils bewusst bestätigen.
