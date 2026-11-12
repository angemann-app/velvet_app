# AG-29: Vier Bleistift-Bilder für „Zu zweit“, „Eure erste Woche“ und die Einladung

Erstellt am 12.11.2026 auf Branch `ag/29-paar-bilder-20261112` im Stil der technischen Bleistiftzeichnungen (AG-22 bis AG-24) auf vollflächigem hellem Papier ohne Schrift, Zahlen oder Ränder.

## Übersicht der gelieferten Bilder

| Datei | Maße | Größe | Versuche | Was zu sehen ist |
|---|---|---|---|---|
| `assets/images/bereich_zu_zweit_kopf.webp` | 1200 × 800 | 86,2 KB (88.318 B) | 1 | Zwei bekleidete Erwachsene mit kurzen Haaren und weiten Strickpullovern sitzen eng nebeneinander von hinten auf einem Sofa, die Köpfe leicht zueinander geneigt, eine Decke über beiden Schultern; kein Geschlecht ablesbar, zwei Personen mit je zwei Schultern. |
| `assets/images/bereich_erste_woche_kopf.webp` | 1200 × 800 | 112,2 KB (114.932 B) | 1 | Ein geschwungener Pfad aus genau sieben flachen Trittsteinen ohne Menschen, begleitet von feinen Maßlinien; davor stehen genau zwei Paar schlichte Schuhe (vier einzelne Schuhe). |
| `assets/images/bereich_einladung_willkommen.webp` | 900 × 1200 | 69,1 KB (70.778 B) | 1 | Ein schlichter Holztisch mit zwei Keramiktassen und zwei Stühlen ohne Menschen, wobei der vordere Stuhl ein Stück zurückgezogen und frei steht. |
| `assets/images/bereich_heute_einladung.webp` | 900 × 1200 | 99,4 KB (101.826 B) | 1 | Eine halb geöffnete Zimmertür ohne Menschen, durch die weiches Licht auf den Holzboden fällt; links neben dem Türrahmen steht eine Topfpflanze. |

## Geprüft

- Format und Größe: Alle vier Dateien sind WebP, erfüllen exakt die vorgegebenen Pixelmaße (`1200 × 800` bzw. `900 × 1200`) und liegen unter 150 KB.
- Sichtprüfung aller vier Bilder: Keine Schriftzeichen, keine Zahlen, keine grauen Ränder oder Blattkanten, keine verwachsenen Körper; bei `bereich_erste_woche_kopf.webp` genau 7 Steine und 4 Schuhe gezählt.
- `flutter test`: nicht ausgeführt (Bilder sind noch nicht in `assets/data/bilder.json` eingetragen).

## Offen oder unsicher

- Zu **AG-25 / AG-26**: Kein Widerspruch zum Stand in `AG.md` festgestellt. In `mojo-ag` war zuvor noch der Branch `ag/26-audio-stichprobe-20261102` ausgecheckt (entspricht dem Hinweis in `AG.md`, dass der Bericht-PR zu AG-26 noch nicht gemergt ist).
- **Frage an Claude / Nutzer:** Bei `bereich_zu_zweit_kopf.webp` sind seitlich hinter der Sofalehne die angewinkelten Knie der beiden Sitzenden leicht angedeutet; falls eine noch schlichtere Rückenansicht gewünscht ist, können wir das Motiv leicht anpassen.
- **Hinweis zum Klon `mojo-ag`:** Dort liegen noch die ungetrackten Ordner `AG pulse/` und `spicy/` lokal herum (nicht Teil dieses Branches/PRs).
