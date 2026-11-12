# Paar-Kanal Vertrauen: Texte (Prüfung Therapeut:in und Redaktion)

Stand: 12.11.2026. Gehört zu `paar-kanal-vertrauen.md`. Du-Form, kurz, ohne Druck. Alle Sätze, die als Chat-Nachricht
in älteren Versionen erscheinen können (Spalte „Ältere App“), sind neutral gehalten: kein „Sex“, „erotisch“, „Traum“,
kein „Spicy“, keine Namen, keine Gründe.

Leitlinien: Eine Trennung wird nie begründet oder bewertet. Ein Nein braucht keine Erklärung. Jeder Hinweis sagt
mindestens einmal, dass nichts eilt oder dass die Person selbst entscheidet.

## Trennen: auslösende Person

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `trennungDialog1Titel` | Verbindung trennen? | Disconnect? | | Neu; entspricht dem bestehenden Titel. |
| `trennungDialog1` | Auf diesem Handy werden der Verlauf mit {name}, die Antworten von {name} und die geteilten Reflexionen gelöscht. Deine eigenen Antworten bleiben.\n\nAuf dem Handy von {name} bleibt, was dort liegt, bis die Person selbst löscht. Wir senden ihr einen kurzen Hinweis; kommt er nicht an (App geschlossen, kein Netz), merkt sie nichts. | The history with {name}, {name}'s answers and the shared reflections will be deleted on this phone. Your own answers stay.\n\nOn {name}'s phone, whatever is there stays until they delete it themselves. We'll send a short notice; if it doesn't arrive (app closed, no connection), they won't notice. | {name} | Geändert: klar zweigeteilt (hier gelöscht / dort bleibt), „Hinweis kommt womöglich nicht an“ ehrlich benannt; Satz „Deine Antworten bleiben“ aus dem bestehenden Dialog übernommen. |
| `trennungDialog1Weiter` | Weiter | Continue | | Knopf; links „Abbrechen“. |
| `trennungDialog2Titel` | Wirklich trennen? | Really disconnect? | | Neu. |
| `trennungDialog2` | Das lässt sich nur rückgängig machen, indem ihr euch neu koppelt. | This can only be undone by pairing again. | | Geändert: kürzer, ohne Doppelung des Titels. |
| `trennungDialog2Ja` | Ja, trennen | Yes, disconnect | | Knopf; links „Abbrechen“. |
| `couplesChannelDisconnected` (besteht) | Verbindung getrennt. | Disconnected. | | Unverändert, Snackbar bei gesendetem Hinweis. |
| `trennungNichtGesendet` | Getrennt. Der Hinweis an {name} ist nicht angekommen. Auf dem Handy von {name} bleibt alles, bis die Person selbst löscht. | Disconnected. The notice to {name} didn't go through. On {name}'s phone everything stays until they delete it themselves. | {name} | Geändert: ruhige Tatsache statt „konnte nicht gesendet werden“ (klingt nach Fehler der Person); sagt, was Sache ist. |

## Trennen: Gegenüber

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `trennungHinweis` (Karte) | {name} hat die Verbindung getrennt. Du musst nichts tun, und es eilt nichts. Der Chat bleibt hier lesbar, bis du entscheidest. | {name} has ended the connection. You don't need to do anything, and there's no hurry. The chat stays readable here until you decide. | {name} | Ergänzt: „nichts eilt“ und was mit dem Chat ist; weiterhin ohne Schuld und Gründe. |
| `trennungSchalter` | Auch auf diesem Handy trennen und die Daten dieser Verbindung löschen | Also disconnect on this phone and delete this connection's data | | Fast unverändert, nur „diese Verbindung“ (flüssiger). |
| `trennungGegenueberDialog1Titel` | Auf diesem Handy trennen? | Disconnect on this phone? | | Neu. |
| `trennungGegenueberDialog1` | Auf diesem Handy werden der Verlauf mit {name}, die Antworten von {name} und die geteilten Reflexionen gelöscht. Deine eigenen Antworten bleiben.\n\nDu kannst auch warten. Erst wenn du bestätigst, wird etwas gelöscht. | The history with {name}, {name}'s answers and the shared reflections will be deleted on this phone. Your own answers stay.\n\nYou can also wait. Nothing is deleted until you confirm. | {name} | Neu: sagt klar, was gelöscht wird, und dass Warten gleichwertig ist (kein Handlungsdruck). Knöpfe „Abbrechen“ / „Weiter“. |
| `trennungGegenueberDialog2Titel` | Wirklich löschen? | Really delete? | | Neu. |
| `trennungGegenueberDialog2` | Das lässt sich nicht zurückholen. Neu koppeln könnt ihr euch später trotzdem. | This can't be brought back. You can still pair again later. | | Neu; ehrlich zur Endgültigkeit, lässt den Weg zurück offen. Knöpfe „Abbrechen“ / „Ja, löschen“. |
| `trennungGegenueberLoeschenJa` | Ja, löschen | Yes, delete | | Knopf. |
| `trennungGegenueberFertig` | Auf diesem Handy getrennt. | Disconnected on this phone. | | Snackbar nach dem Löschen. |

## Neutraler Satz für ältere Versionen (Chat-Text)

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `trennungSatzAelter` | Die Verbindung wurde getrennt. | The connection was ended. | | Wie entschieden, ohne Namen. Hinweis „unter ⋮ › Verbindung trennen“ wird nicht angehängt (alte Menüs können abweichen, und es klänge nach Aufforderung). |

## Spicy-Einladung

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `spicyEinladungNein` (Knopf) | Gerade nicht | Not right now | | Unverändert; „gerade“ lässt die Tür offen, ohne zu drängen. |
| `spicyEinladungNeinAntwort` (beim Einladenden) | Danke, dass du es mir sagst. Es eilt nichts. | Thank you for telling me. There's no rush. | | Unverändert warm; als Chat-Satz neutral (kein „Spicy“). |
| `spicyEinladungNeinGesendet` (beim Antwortenden) | Du hast geantwortet. Du kannst es dir jederzeit anders überlegen. | You've replied. You can change your mind any time. | | Ergänzt, weil das Konzept nur „Du hast geantwortet.“ hatte; zweiter Satz nimmt die Endgültigkeit. Nur anzeigen, solange „ansehen“ sichtbar bleibt. |

## Funken

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `funkeDanke` (Knopf) | Danke fürs Sagen | Thanks for telling me | | Unverändert. Tippt der Empfänger selbst, das Gerät antwortet nie. |
| `funkeTippNein` (Empfänger von „Heute lieber nicht“) | Ein Nein heute ist kein Nein zu dir. Du musst nichts nachfragen, und etwas Nahes ohne Erwartung geht trotzdem. | A no today isn't a no to you. You don't need to ask why, and something close without expectations is still possible. | | Geändert: Der Entwurf („Du musst nichts erklären“) richtete sich an die Person, die absagt. Der Tipp erscheint aber beim Empfänger des Neins, also beim Gegenüber; er soll helfen, das Nein ohne Kränkung anzunehmen. |
| `funkeTippReden` (Empfänger von „Lass uns reden“) | Du musst nicht sofort antworten. Sag, wann es für dich passt, und hör erst mal zu. | You don't have to answer right away. Say when it suits you, and listen first. | | Geändert: Der Entwurf sprach nur von „Zuhören“; ergänzt, dass die Person nicht sofort reagieren muss (ein „Lass uns reden“ kann Angst auslösen). Hinweis an den Empfänger, nicht an den Absender. |
| `funkeDankeAntwort` (beim Absender) | {name}: Danke fürs Sagen. | {name}: Thanks for telling me. | {name} | Wie im Konzept. Hinweis: Als Chat-Satz in älteren Versionen steht nur „Danke fürs Sagen.“ ohne Namen (der Name kommt aus dem Absender der Blase). |

## Foto-Hinweis

| Schlüssel | Deutsch | Englisch | Platzhalter | Anmerkung |
|---|---|---|---|---|
| `fotoHinweisTrennung` | Gesendete Fotos bleiben auf dem Handy des anderen, auch wenn ihr euch trennt. | Photos you send stay on the other person's phone, even if you disconnect. | | Geändert: konkreter und aus Sicht des Sendenden verständlich („nicht zurückholen“ ist abstrakt). Einmal pro Verbindung. |

## Bedenken zum Konzept

1. **Gewalt / Kontrolle:** Trennen löst eine Nachricht an das Gegenüber aus. Lebt jemand mit einer kontrollierenden oder gewalttätigen Person, kann genau dieser Hinweis gefährlich sein (Eskalation, Nachfragen). Vorschlag: im Trenn-Dialog 1 den Hinweis-Versand als wählbar anbieten („Hinweis senden“ vorangekreuzt, abwählbar), oder einen stillen Weg „Nur auf diesem Handy trennen“ anbieten, ohne Begründung. Die SOS-/Hilfe-Seite sollte im Dialog verlinkt werden.
2. **Schalter ohne Gewalt-Rücksicht:** Wer vom Gegenüber getrennt wurde und dort Daten löscht, kann Beweise (Nachrichten, Fotos) verlieren. Kurzer Satz im Löschdialog wäre sinnvoll: „Brauchst du etwas davon als Beleg, sichere es vorher.“ (Entscheidung offen, daher nicht in der Tabelle).
3. **Ehrlichkeit zum Foto-Satz:** Er darf nicht Sicherheit vorgaukeln: auch ohne Trennung ist ein Foto nicht rückholbar. Deshalb formuliert er neutral „bleiben beim anderen“.
4. **Ablauf 7 Tage:** Kommt der Hinweis erst nach Tagen an, erfährt das Gegenüber es verspätet und evtl. nach längerer Funkstille; die Karte darf dann nicht „gerade eben“ suggerieren (kein Zeitstempel-Wortlaut wie „soeben“).
5. **Hinweis kommt nie an:** Ein Teil bleibt ohne Wissen auf dem alten Stand; die Absender-Snackbar sagt das ehrlich (`trennungNichtGesendet`). Es sollte keinen „Zustellt“-Haken suggerieren, der Sicherheit vorgibt.
6. **Sperrbildschirm:** Der Trenn-Satz („Die Verbindung wurde getrennt.“) ist neutral, verrät aber, dass es eine Verbindung gab. Im Diskretions-Modus eher ohne Inhalt benachrichtigen.
7. **Funken-Tipps:** Tipps erscheinen nur beim Empfänger und nur auf Antippen („Mehr dazu“) wäre ruhiger als dauerhaft eingeblendet; sonst können sie belehrend wirken.
