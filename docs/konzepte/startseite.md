# Konzept: Startseite mit Schwerpunkten

Stand: abgestimmt und umgesetzt am 27.10.2026 (4.12.0-beta.2).

## Problem

Die Startseite war überladen: Begrüßung, Hinweis, bis zu sechs große Audio-Karten, Check-in, Funke,
Paar-Kanal-Hinweis und 27 große Kurskarten untereinander.

## Aufbau

1. **Kopf:** Begrüßung und Fortschritt; Hinweise (Aufnahmen laden) darunter.
2. **Heute:** Check-in und Erotik-Funke.
3. **Geführte Audios:** Reihe kleiner Kacheln zum Wischen (`GefuehrteAudios(kompakt: true)`). Die
   Traumtagebuch-Karte am Morgen steht voll breit darüber. Im Paar-Kanal bleiben die großen Karten.
4. **Filter:** Alle, Für Sie, Für Ihn, Für Paare („Berührung“ ist jetzt ein Schwerpunkt).
5. **Kurse nach Schwerpunkten:** aufklappbare Karten mit Beschreibung und Fortschritt, darin die Kurse ohne
   Titelbild. Anfangs offen: der Schwerpunkt zum Fokus im Profil (Leistungsdruck → Grundlagen,
   Beckenboden → Annehmen und Lösen, Lust am Körper → Sich selbst entdecken, Paar-Intimität → Lust als Paar),
   sonst der erste mit offenen Lektionen.
6. Der Paar-Kanal-Hinweis entfällt (eigener Tab).

## Schwerpunkte (Feld `schwerpunkt` je Kurs in `velvet_content.json`)

| Id | Name | Kurse |
|---|---|---|
| grundlagen | Grundlagen | 1 bis 4 |
| annehmen | Annehmen und Lösen | 5 bis 7 |
| entdecken | Sich selbst entdecken | 8 bis 11 |
| paar | Lust als Paar | 12 bis 17 |
| beruehrung | Berührung | 18 bis 22 |
| fantasie | Fantasie und Spiel | 23 bis 27 (26, 27 nur Spicy) |

Die Kursnummern bleiben. Neue Kurse bekommen ihr Feld `schwerpunkt` in Deutsch und Englisch.
