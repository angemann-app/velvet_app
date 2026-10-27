# Konzept: Nachfrage vor der Wiedergabe über den Lautsprecher

Stand: abgestimmt am 27.10.2026, Umsetzung als Auftrag AG-8.

## Idee

Diskretion beim Hören: Läuft eine Aufnahme über den eingebauten Lautsprecher statt über Kopfhörer, fragt die
App vorher nach. Wird während der Wiedergabe der Kopfhörer abgezogen oder bricht Bluetooth ab, pausiert sie,
statt laut weiterzuspielen.

## Entscheidungen (27.10.2026)

1. **Gefragt wird bei allen Aufnahmen:** Lektionen, Körperreise, Gemeinsamer Abend, Einschlaf-Reise,
   Traum-Abend, Lust im Traum und die Sprachansagen des Beckenboden-Trainings.
2. **Pause beim Abziehen** der Kopfhörer bzw. bei Bluetooth-Abbruch: **abschaltbar**, Standard an.
3. Die Nachfrage selbst lässt sich im Dialog („Nicht mehr fragen“) und im Profil abschalten, Standard an.

## Verhalten

- Vor dem Start einer Wiedergabe: Ausgabe prüfen. Kabel-, USB- und Bluetooth-Geräte gelten als „nicht der
  Lautsprecher“ (Bluetooth-Kopfhörer und -Lautsprecher lassen sich nicht sicher unterscheiden). Nur beim
  eingebauten Lautsprecher kommt der Dialog „Die Wiedergabe läuft über den Lautsprecher. Trotzdem abspielen?“
  mit „Abspielen“, „Abbrechen“ und dem Häkchen „Nicht mehr fragen“.
- Einmal bestätigt, gilt es für diese Wiedergabe (ein ganzer Abend fragt nicht bei jedem Baustein neu).
- Pause beim Abziehen: Android-Signal „Audio becoming noisy“ bzw. Gerätewechsel; die Wiedergabe pausiert,
  der Klangteppich auch. Fortsetzen nur durch Tippen.
- Kein Ton, keine Benachrichtigung dabei.

## Technik

Ein Dienst `lib/services/audio_ausgabe.dart` (Ausgabegerät abfragen, Signal beim Abziehen), umgesetzt mit dem
Paket `audio_session` oder einem kleinen MethodChannel in `MainActivity`. Einstellungen in `StorageService`,
Teil von Sicherung und Backup-Merge.
