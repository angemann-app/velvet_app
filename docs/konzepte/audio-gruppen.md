# Geführte Audios nach Anlass gliedern

Stand 03.11.2026, Entwurf zur Abstimmung. Auslöser: Die Menge der geführten Audios auf Heute wirkt erschlagend, die Einstiege sind nach Technik benannt (Körperreise, Traum-Abend, Lust im Traum …) statt nach dem, was jemand gerade braucht.

## Entscheidung des Nutzers

„OK“ zum Vorschlag in der Fassung **gruppieren plus Weiterhören und Tages-Empfehlung**. Je Gruppe ein kleiner Erklärtext (unten). Umsetzung erst nach Abnahme dieses Konzepts.

## Aufbau

Heute zeigt statt der Reihe aller Einstiege:

1. **Weiterhören** ganz oben, nur wenn ein Ablauf gemerkt ist (Mini-Player und Merker bestehen bereits). Kein Autostart.
2. **Für heute** eine einzelne Empfehlung nach Tageszeit und bisherigem Weg, ohne Zwang; der Rest bleibt eingeklappt.
3. **Vier Gruppen** als Kacheln, jede öffnet eine eigene Seite mit den vorhandenen Einstiegen, sortiert nach Dauer und Stimmung.

| Gruppe | Enthält | Sichtbarkeit |
|---|---|---|
| Für mich | Körperreise, Selbsterkundung, Traumpraxis (Zum Hören) | Traumpraxis nur Spicy |
| Für uns | Gemeinsamer Abend, Gemeinsam hören | nur mit Paar-Kanal sinnvoll, sonst Hinweis |
| Nacht | Einschlafen, Traum-Abend, Wecken, Lust im Traum | Lust im Traum nur Spicy |
| Geschichten | Innenansichten | nur Spicy, 18+ |

Gruppen ohne sichtbaren Inhalt (Spicy aus) verschwinden. Aufnahmen, Pakete, Player und Gates bleiben unverändert; es ändert sich nur die Oberfläche.

## Erklärtexte (je Kachel, eine bis zwei Zeilen)

| Gruppe | Deutsch | English |
|---|---|---|
| Für mich | Zeit nur für dich: deinen Körper spüren, dich erkunden, Träume bewusster erleben. Du bestimmst Länge und Nähe. | Time just for you: feel your body, explore yourself, experience dreams more consciously. You choose the length and how close you go. |
| Für uns | Zu zweit hören oder abwechselnd geben und empfangen. Eine Stimme führt, ihr bestimmt das Tempo. | Listen together or take turns giving and receiving. A voice guides you, you set the pace. |
| Nacht | Zum Einschlafen, für den Traum-Abend und zum Wiedereinschlafen. Die Stimme wird leiser, du darfst einschlafen. | For falling asleep, the dream evening and getting back to sleep. The voice grows quieter, you may drift off. |
| Geschichten | Zusammenhängende Hörgeschichten für Erwachsene, nicht zum Einschlafen. Du wählst Perspektive und Intensität. | Connected audio stories for adults, not for falling asleep. You choose the perspective and intensity. |

## Diskretions-Modus

Kartentitel bleiben neutral, ohne „Sex“, „erotisch“, „Traum“ o. ä.: **Für mich** → „Für mich“, **Für uns** → „Für uns“, **Nacht** → „Ruhe“, **Geschichten** → „Hörgeschichten“. Erklärtexte erscheinen im Diskretions-Modus nicht auf der Kachel, sondern erst auf der geöffneten Seite.

## Entscheidungen (03.11.2026)

- **Reihenfolge der Gruppen nach Tageszeit:** abends und nachts steht „Nacht“ vorn, sonst „Für mich“. Die übrigen folgen in fester Reihenfolge.
- **„Gemeinsam hören“ liegt unter „Für uns“.** Im Player bleibt der Einstieg für laufende Wiedergabe bestehen.

## Abgestimmt (03.11.2026)

- **Empfehlung „Für heute“:** Tageszeit plus zuletzt geöffnete Gruppe. Die zuletzt geöffnete Gruppe zählt nur, wenn sie heute war, sichtbar ist und zur Tageszeit passt („Nacht“ tagsüber nie). Spicy-Angebote nur bei eingeschaltetem Spicy-Modus. Gemerkt wird auf diesem Gerät (`SharedPreferences`), nicht in der Sicherung.
- **„Alle anzeigen“:** Link unter den Gruppen, öffnet die bisherige vollständige Liste.
- **Weiterhören:** Der Mini-Player und der gemerkte Ablauf stehen bereits global; keine zusätzliche Karte auf Heute.

## Umsetzung (03.11.2026)

`lib/services/audio_gruppen.dart` (Sichtbarkeit, Reihenfolge, Empfehlung), `lib/widgets/gefuehrte_audios.dart` (`AudioGruppenBereich`, `AudioGruppeSeite`, `AlleAudiosSeite`), Heute nutzt `AudioGruppenBereich`. Gemeinsam hören steht unter „Für uns“ als Hinweis mit Weg zum laufenden Abgleich, der Start bleibt im Player. Tests: `test/audio_gruppen_test.dart`, `test/audio_gruppen_widget_test.dart`. Anleitung DE/EN angepasst. „Was ist neu“ folgt mit dem nächsten Build.
