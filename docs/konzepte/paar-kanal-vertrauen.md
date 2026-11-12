# Konzept: Sicherheit und Vertrauen im Paar-Kanal

Stand: 12.11.2026, Entwurf zur Abstimmung. Noch nichts umgesetzt.
Maßstab: Nichts erzeugt Druck, niemand wird bloßgestellt, ein Nein ist immer eine vollwertige Antwort.

## Ziel

Vier Lücken schließen, ohne das Verfahren (NIP-04/NIP-17, Beta und Stabil) anzufassen:

1. **Trennen** erreicht heute nur das eigene Handy (`NostrService.unpairPartner`). Das Gegenüber erfährt nichts und behält Verlauf, Antworten und Reflexionen.
2. **Spicy-Einladung** (`sendSpicyEinladung`) kennt nur „ansehen“. Ein freundliches Nein fehlt.
3. **Funken** „Heute lieber nicht“ und „Lass uns reden“ bleiben ohne Antwort; „Heute lieber nicht“ steht ganz hinten in der Wisch-Leiste.
4. **Foto senden**: kein Hinweis, dass Gesendetes nach einer Trennung nicht zurückzuholen ist (Frage e, siehe unten).

Bewusst unverändert (Punkt d): Antworten der Fantasie-Landkarte werden weiter vollständig übertragen; Foto-Ideen bleiben.

## Grundprinzip der Übertragung (Kompatibilität)

Ältere Versionen zeigen unbekannte Nachrichtenarten (`type`) als rohen JSON-Text (`_parseAndAddMessage`, Zweig „kein bekannter Typ“). Darum gehen alle neuen Dinge als **normale `chat`-Nachricht mit lesbarem, neutralem Satz und einem Zusatzfeld** (wie `spicy_invite`, `lesson`, `foto`). Ältere Versionen zeigen den Satz, neue Versionen erkennen das Feld und zeigen die passende Oberfläche. Kein neues Verfahren, keine Aushandlung nötig; Beta und Stabil bleiben kompatibel. Das Zusatzfeld ist bei NIP-04 und NIP-17 gleich, weil nur die Verpackung wechselt.

Neue Zusatzfelder: `trennung` (Trenn-Hinweis), `antwort` (Antwort auf Einladung/Funken, Werte siehe unten). Beide werden beim Empfang streng geprüft (nur bekannte Werte, Längen begrenzt, nur vom gekoppelten Gegenüber; das gilt bereits über `NostrEventCheck`).

## a) Trennen mit Signal und zweifacher Bestätigung

**Entscheidungen (12.11.):** Trenn-Signal als normale Nachricht (kommt auch später an). Beim Gegenüber ruhiger Hinweis mit Schalter zum Bestätigen; die Trennung wird von **beiden Seiten je zweimal** bestätigt, damit sie nicht versehentlich passiert.

**Auslösende Person:**
1. Menü „Verbindung trennen“ → Dialog 1: sagt klar, was auf diesem Handy gelöscht wird, **und dass beim anderen Handy bleibt**, was dort schon liegt (Verlauf, Antworten, Reflexionen), falls das Signal nicht ankommt (App zu, kein Netz). Knöpfe „Abbrechen“ / „Weiter“.
2. Dialog 2: kurze Rückfrage „Wirklich trennen?“ (rückgängig nur durch neues Koppeln). Knöpfe „Abbrechen“ / „Ja, trennen“.
3. Dann: erst Trenn-Nachricht senden (neutraler Satz plus `trennung: 1`), danach lokal wie bisher aufräumen. Scheitert das Senden (kein Server), meldet die App ehrlich: „Getrennt. Hinweis konnte nicht gesendet werden; auf dem Handy von {Name} bleibt alles, bis die Person selbst löscht.“ Das Trennen selbst wird nicht blockiert.

**Gegenüber (neue Version):**
- Im Paar-Kanal erscheint eine ruhige Karte statt einer Chat-Blase: „{Name} hat die Verbindung getrennt.“ Kein Vorwurf, keine Gründe. Der Chat bleibt lesbar, Senden wird nicht mehr angeboten, bis entschieden ist (die Person würde sonst ins Leere schreiben).
- Auf der Karte ein **Schalter** „Auch auf diesem Handy trennen und die Daten dieser Verbindung löschen“. Einschalten öffnet die zweifache Bestätigung wie oben (Dialog 1: was wird gelöscht, Dialog 2: wirklich?). Erst danach wird gelöscht (`unpairPartner`, ohne erneutes Signal).
- Wer nichts tut, behält alles; die Karte bleibt, nichts drängt. Nach dem Löschen eigener Antworten: bleiben wie bisher erhalten.

**Gegenüber (ältere Version):** Sieht den Satz als Chat-Nachricht, etwa „{Name} hat die Verbindung getrennt. Du kannst sie unter ⋮ › Verbindung trennen ebenfalls beenden.“ (Text ohne Namen der absendenden App-Version; der Name steht im Satz, daher wird der Satz beim Senden mit dem eigenen Namen des Absenders gebildet, falls bekannt, sonst neutral „Die Verbindung wurde getrennt.“).

**Technik:** Neue Methode `sendeTrennung()` in `NostrService` (über `_sendLearning`), in `_parseAndAddMessage` Erkennung von `trennung`, dazu `getrenntNotifier` (gespeichert in SharedPreferences, Teil von Sicherung und `StorageService`/Backup-Merge, Test in `backup_merge_test.dart`). `_clearPartnerData` setzt ihn zurück. Eingehende Nachricht läuft wie bisher durch `NostrEventCheck`. Ablaufzeit auf den Servern wie bei verschwindenden Nachrichten (7 Tage), damit der Hinweis dort nicht ewig liegt.

**Neutralität:** Der Satz enthält kein „Sex“ o. Ä.; Benachrichtigung neutral wie bisher.

## b) Spicy-Einladung: „Gerade nicht“

Unter der eingehenden Einladung (`_spicyAnnehmen`) steht neben „Spicy-Modus ansehen“ ein zweiter, gleichrangiger Knopf **„Gerade nicht“**. Tippen sendet ohne Erklärung eine Antwort mit `antwort: spicy_nein`; der Knopf wird danach durch den Satz „Du hast geantwortet.“ ersetzt (kein Druck, später kann trotzdem „ansehen“ gewählt werden, solange der Knopf „ansehen“ sichtbar bleibt).

Beim Einladenden: warmer Satz in der Blase, zum Beispiel „Danke, dass du es mir sagst. Es eilt nichts.“ Nur sichtbar, keine Benachrichtigung mit Inhalt (Benachrichtigung bleibt neutral). Ältere Versionen zeigen den Satz als normale Nachricht.

## c) Funken: Antworten und „Heute lieber nicht“ erreichbar

- **Antwort:** Bei eingehenden „Heute lieber nicht“ und „Lass uns reden“ erscheint beim **Empfänger** unter dem Funken ein Knopf **„Danke fürs Sagen“** und ein kurzer Tipp nur für ihn (zum Beispiel: „Ein Nein ist eine ganze Antwort. Du musst nichts erklären und nichts wiedergutmachen.“ bzw. für den Absender-Seite beim „Lass uns reden“: „Frag, wann es passt, und hör erst mal zu.“). Das Gerät antwortet **nie von selbst**; die Person entscheidet. Tippen sendet `antwort: danke` an den Absender, dort erscheint „{Name}: Danke fürs Sagen.“
- **Erreichbarkeit:** „Heute lieber nicht“ steht künftig als **fester Knopf links vor der Wisch-Leiste**, die Leiste scrollt daneben weiter. Er sendet wie bisher den Funken, ohne Wischen.

## e) Foto-Hinweis (Frage an den Nutzer)

Vorschlag: Beim Foto-Senden **einmal pro Verbindung** ein kurzer Satz im Auswahlfenster: „Gesendetes lässt sich nach einer Trennung nicht zurückholen.“ Danach nicht wieder (kein Dauer-Warnen). Offen, ob gewünscht.

## Texte (Entwurf, Therapeut:in-Prüfung folgt)

| Schlüssel | Deutsch | Englisch |
|---|---|---|
| `trennungHinweis` (Karte) | {name} hat die Verbindung getrennt. | {name} has ended the connection. |
| `trennungSchalter` | Auch auf diesem Handy trennen und die Daten dieser Verbindung löschen | Also disconnect on this phone and delete the data of this connection |
| `trennungDialog1` | Auf diesem Handy werden der Verlauf, die Antworten von {name} und die geteilten Reflexionen gelöscht. Auf dem Handy von {name} bleibt alles, bis die Person selbst löscht, auch wenn dieser Hinweis nicht ankommt (App geschlossen, kein Netz). | The history, {name}'s answers and shared reflections will be deleted on this phone. On {name}'s phone everything stays until they delete it themselves, even if this notice does not arrive (app closed, no connection). |
| `trennungDialog2` | Wirklich trennen? Das lässt sich nur durch erneutes Koppeln rückgängig machen. | Really disconnect? This can only be undone by pairing again. |
| `trennungNichtGesendet` | Getrennt. Der Hinweis konnte nicht gesendet werden. | Disconnected. The notice could not be sent. |
| `spicyEinladungNein` (Knopf) | Gerade nicht | Not right now |
| `spicyEinladungNeinAntwort` | Danke, dass du es mir sagst. Es eilt nichts. | Thank you for telling me. There's no rush. |
| `funkeDanke` (Knopf) | Danke fürs Sagen | Thanks for telling me |
| `funkeTippNein` | Ein Nein ist eine ganze Antwort. Du musst nichts erklären. | A no is a whole answer. You don't have to explain. |
| `funkeTippReden` | Sag, wann es für dich passt. Zuhören reicht erst mal. | Say when it suits you. Listening is enough for now. |
| `fotoHinweisTrennung` | Gesendetes lässt sich nach einer Trennung nicht zurückholen. | What you send can't be taken back after a disconnection. |

## Betroffene Dateien

`lib/services/nostr_service.dart`, `lib/models/couple_channel_models.dart`, `lib/screens/couples_channel/couples_channel_screen.dart`, `lib/l10n/app_de.arb`, `app_en.arb`, `lib/services/storage_service.dart` (Sicherung), Tests (`test/paar_kanal_test.dart`, `backup_merge_test.dart`, `security_test.dart` bleibt grün), `assets/data/anleitung.json`, `docs/ANLEITUNG.md`, `docs/GUIDE.md`, `assets/data/neuigkeiten.json`, `translations/en/`, `docs/AUFGABEN.md`.

## Prüfung

`flutter analyze`, `flutter test`, `flutter test test_screens/screens_test.dart` (Bilder unter `build/screens/` ansehen). Neue Tests: Trenn-Nachricht senden/empfangen, ältere Version zeigt Satz (Textfassung), Bestätigungsablauf, Antworten auf Einladung und Funken, unbekannte Werte werden ignoriert. Nichts am Gerät getestet, solange der Nutzer es nicht war.

## Offene Fragen nach der Umsetzung (Gegenlesen 12.11.2026)

Vom Therapeut:in-Gegenlesen, bewusst NICHT umgesetzt, weil sie die abgestimmte Entscheidung ändern würden:

1. **Gewalt/Kontrolle beim Trennen:** Der Hinweis ist zwingend; wer vor einer kontrollierenden Person flieht, löst damit eine Nachricht an genau diese aus. Vorschlag: im ersten Dialog wählbar „Hinweis senden“ (Standard) oder „Nur auf diesem Handy trennen“, dazu ein dezenter Verweis auf Hilfe/SOS.
2. **Belege:** Ein Satz in den Löschdialogen („Brauchst du etwas davon als Beleg, sichere es vorher.“).
3. **„Gerade nicht“ ist immer ein Aufschub** („Es eilt nichts“); ein gleichrangiges „Nein, danke“ wäre ehrlicher.
4. **„Lass uns reden“** bekommt nur „Danke fürs Sagen“; eine eigene Antwort („Gern, wann passt es dir?“) wäre passender.
5. **Warten beim Trennen:** bis zu 6 Sekunden ohne Anzeige, wenn kein Server verbunden ist.
6. **Ältere Versionen** zeigen den neutralen Satz „Die Verbindung wurde getrennt.“ auch in der Benachrichtigung; das lässt sich dort nicht ändern.

Behoben aus dem Gegenlesen: Perspektive des „Gerade nicht“, Knöpfe nach der Trennung ausgeblendet, „Nein“ auch bei schon eingeschaltetem Spicy-Modus, Tipp als „Nur für dich“ gekennzeichnet, Senden nach der Trennung gesperrt, erneutes Koppeln hebt den Trenn-Stand auf.

## Offene Fragen (vor der Umsetzung, erledigt)

1. **„Von beiden zweimal bestätigen“:** Ich lese es so, dass jede Seite für ihre eigene Trennung zwei Bestätigungsschritte durchläuft (zwei Dialoge). Gemeint auch, dass das Gegenüber zustimmen muss, bevor bei der auslösenden Person gelöscht wird? Das hielte die Trennung für beide offen, falls das Gegenüber nie antwortet. Vorschlag: nein, die auslösende Person trennt sofort lokal nach ihren zwei Bestätigungen.
2. **Foto-Satz (Frage e):** ja/nein, einmal pro Verbindung?
3. **Tipp-Texte** dürfen die Therapeut:in-Prüfung noch ändern.
4. Soll der Name im Trenn-Satz für ältere Versionen genannt werden, oder nur „Die Verbindung wurde getrennt.“ (neutraler, nichts zu verfälschen)?

## Entscheidungen

12.11.2026, Nutzer:
1. Trenn-Signal als normale Nachricht; ruhiger Hinweis beim Gegenüber mit Schalter; Trennung je Seite zweifach bestätigt. Die auslösende Person trennt nach ihren zwei Bestätigungen sofort lokal und wartet nicht auf das Gegenüber.
2. Foto-Satz ja, einmal pro Verbindung.
3. Ältere Versionen zeigen den neutralen Satz ohne Namen („Die Verbindung wurde getrennt.“).
4. Tipp-Texte werden von der Therapeut:in-Rolle geprüft (siehe `paar-kanal-vertrauen-texte.md`).
5. Funken-Antwort tippt der Empfänger selbst an, das Gerät antwortet nie von selbst.
