# SOS neu: für alle, mit Hilfe bei Druck

Stand: 12.11.2026, **umgesetzt auf Branch `claude/sos-neu-20261112`** (nicht zusammengeführt, nicht am Gerät getestet).
Entworfen aus den vier Fachsichten (Therapie, Design, Grafik, Technik). Die Texte im Abschnitt „Texte“ sind der Entwurf; die
Gegenlese (Sexualtherapie, Code) hat Änderungen gebracht, maßgeblich sind `assets/data/velvet_content.json`,
`translations/en/velvet_content.json` und die ARB-Schlüssel `sos*`.

## Entscheidungen (Nutzer, 12.11.2026: „Empfehlungen übernehmen“)

1. Kapsel „Hilfe“ mit Rettungsring (Vorschlag A). 2. Tipp auf die Nummer wählt direkt (`tel:`); klappt das nicht, steht die
Nummer als Hinweis im Blatt (nichts in der Zwischenablage). 3. Alle fünf Länder, vorgewählt nach Geräteregion.
4. „Schnell verlassen“ schließt Blatt und alles darüber bis zur Hauptseite (springt nicht zur Heute-Seite). 5. „Ich werde gedrängt …“
steht als letzte Antwort, farblich abgesetzt. 6. und 7. (Person mit überschrittener Grenze; Abschnitt nach einem Übergriff
mit Spurensicherung, Notfallverhütung, PEP) bleiben **offen**, brauchen offizielle Quellen je Land. 8. Weg 6 nennt den Bereich
„Reframing“, wie ihn die App zeigt. 9. Englische Fassung geschrieben (Gleichlauf per `test/sos_test.dart`).
Weg 6 („Es lief anders als gedacht“) führt nach der Gegenlese ebenfalls zum Hilfe-Teil.

## Ziel

SOS soll in einem verletzlichen Moment **in Sekunden und mit einer Hand** helfen, für **alle Körper, Geschlechter und
Paarformen**, und die Person daneben mitdenken. Es benennt ehrlich, statt zu überspielen (passend zu Kurs 12,
„Warum Verstecken den Druck verdoppelt“). Es lädt ein, statt zu befehlen, und nutzt schlichte Worte.
Dazu kommt ein **fester Teil „Hilfe, wenn ein Nein nicht gilt“** mit Anlaufstellen.

## Was heute nicht stimmt

| Heute | Problem | Neu |
|---|---|---|
| „Stoßen“, „Liebhaber“, „Erektion“, „Penetration“ | nur Männer, nur ein Szenario | Szenarien für alle Körper |
| „Charmanten Druckbrecher“: Lust vorspielen, „Gang zurückschalten“ | überspielen; Kurs 12 sagt das Gegenteil | benennen: „Mein Körper macht gerade nicht mit“ |
| „Rückzugs-Verbot“, „auf keinen Fall“, „verbotener Bonus“ | Befehlston, neuer Druck | einladend („du darfst“) |
| „Down-Regulation“, „Sympathikus“, „KVT“ | Fachjargon | Alltagswörter |
| drei Reiter Vorab/Im Moment/Danach, fünf Schritte zum Abhaken, Mantra | zu lang, zu viel Lesen | eine Frage, wenige Schritte einzeln |
| nur die Sicht der Person, die Probleme hat | Gegenüber fehlt; Schmerz, „Ich will nicht mehr“ fehlen | eigene Wege dafür |
| kein Weg bei „Mein Nein gilt nicht“ | Lücke | fester Hilfe-Teil |

## Ablauf (Funktion)

1. **Antippen** (Symbol oben rechts) öffnet ein ruhiges Blatt: **„Was ist gerade los?“** mit sieben großen Antworten,
   unten im Daumenbereich. Kein Reiter, kein Abhaken, nichts wird gespeichert.
2. Jede Antwort führt in einen **kurzen Weg**: ein Satz zum Einstieg, dann **ein Schritt pro Seite** (3 bis 4 Schritte,
   großer „Weiter“-Knopf unten, „Zurück“ daneben), am Ende **„Ein Satz, den du sagen kannst“** und ein Schlusssatz.
3. Die siebte Antwort („Ich werde gedrängt …“) führt in den **festen Hilfe-Teil**. Er ist auch aus Weg D (Ich möchte nicht
   mehr) und aus der Auswahl immer erreichbar.
4. Nach jedem Weg: „Zurück zur Auswahl“ und „Schließen“. Der Schließen-Knopf ist groß und sitzt immer an derselben Stelle.

Alles ohne KI-Coach (kein Verweis). Das Journal darf in Weg F erwähnt werden.

## Texte (Deutsch)

Anrede: du. Für das Gegenüber: „dein Gegenüber“. Keine Geschlechtswörter für Körperteile als Normalfall; wo nötig, nennt
die Aufzählung mehrere Körper.

### Auswahl

**Titel:** Was ist gerade los?
**Untertitel:** Du musst nichts erklären. Such aus, was am ehesten passt.

1. Ich bin nervös oder unsicher
2. Mein Körper macht gerade nicht mit
3. Es tut weh oder mein Körper verkrampft
4. Ich möchte gerade nicht mehr
5. Mein Gegenüber wirkt still oder zieht sich zurück
6. Es lief anders als gedacht
7. Ich werde gedrängt, mein Nein gilt nicht

### Weg 1: Ich bin nervös oder unsicher (vorher)

**Einstieg:** Nervosität vor Nähe ist häufig. Dein Körper macht sich bereit, auch wenn es sich nach Anspannung anfühlt. Du musst heute nichts leisten.
1. Atme dreimal ein und lass die Luft länger wieder hinaus, als du eingeatmet hast. Mehr braucht es nicht.
2. Lass Kiefer und Schultern los. Du kannst dabei sanft deine Ohrläppchen kneten.
3. Frag dich: Was möchte ich heute Abend? „Nur kuscheln“ und „heute lieber nicht“ sind vollwertige Antworten.

**Ein Satz, den du sagen kannst:** „Mein Kopf ist heute ziemlich voll. Ich würde gern langsam anfangen.“ / „Ich bin nervös. Können wir erst einmal einfach nah beieinander sein?“
**Schluss:** Nähe braucht kein Ziel. Du darfst jederzeit anhalten.

### Weg 2: Mein Körper macht gerade nicht mit

**Einstieg:** Erregung kommt und geht, bei allen Körpern: Die Erektion lässt nach, die Feuchtigkeit bleibt aus, der Kopf macht dicht. Das sagt nichts über dich und nichts über eure Nähe. Oft ist es Stress.
1. Halte kurz inne. Mehr Tempo oder Druck macht es meist schwerer. Atme aus.
2. Richte die Aufmerksamkeit auf das, was du gerade spürst: die Wärme der Haut, einen Atemzug, die Hand deines Gegenübers.
3. Sag es, sobald du magst, mit einem Satz. Ehrlich ist leichter als überspielen: Dein Gegenüber merkt ohnehin, dass etwas anders ist, und bezieht Schweigen oft auf sich.
4. Ihr könnt die Berührung wechseln: streicheln, küssen, reden, eine Pause. Es muss nichts „fertig“ werden.

**Ein Satz, den du sagen kannst:** „Mein Körper macht gerade nicht mit. Das liegt nicht an dir. Können wir kurz langsamer machen?“ / „Ich bin gerade im Kopf. Magst du mich einfach halten?“
**Schluss:** Eine Pause ist kein Scheitern.

### Weg 3: Es tut weh oder mein Körper verkrampft

**Einstieg:** Schmerz ist ein Signal, kein Zeichen, dass du etwas falsch machst. Du musst ihn nicht aushalten.
1. Stopp. Sag „Stopp“ oder „Warte“, auch wenn es sich unangenehm anfühlt. Bewegt euch nicht weiter.
2. Atme langsam aus und lass Bauch, Gesäß und Beckenboden sinken, so gut es geht. Gegen Verkrampfen helfen Ruhe und Wärme, nicht Durchhalten.
3. Entscheide, was jetzt guttut: andere Position, mehr Gleitmittel, anderes Tempo, etwas ganz anderes oder Schluss für heute.
4. Wenn Schmerz öfter kommt, lässt er sich abklären und oft behandeln, zum Beispiel in der Gynäkologie, Urologie oder bei Beckenboden-Physiotherapie. Du bist damit nicht allein.

**Ein Satz, den du sagen kannst:** „Es tut weh. Bitte halte kurz inne.“ / „Ich verkrampfe gerade. Ich brauche eine Pause.“
**Schluss:** Schmerz ist ein guter Grund aufzuhören.

### Weg 4: Ich möchte gerade nicht mehr

**Einstieg:** Du darfst jederzeit „nicht mehr“ sagen, auch mittendrin und auch, wenn du vorher Ja gesagt hast. Das braucht keine Begründung.
1. Nimm wahr, was in dir „Nein“ sagt: Körper, Gefühl, ein Gedanke. Das genügt als Grund.
2. Sag es kurz und deutlich. Du musst es nicht freundlich verpacken oder erklären.
3. Du darfst dich bewegen, dich bedecken, aufstehen, den Raum wechseln.
4. Wenn dein Gegenüber nicht aufhört oder dich überredet, liegt das nicht an dir. Dafür gibt es Hilfe (Knopf unten).

**Ein Satz, den du sagen kannst:** „Ich möchte aufhören.“ / „Ich will jetzt nicht mehr. Das hat nichts mit dir zu tun.“ / „Stopp.“
**Schluss:** Ein Nein braucht kein Aber.
**Knopf:** Hilfe bei Druck oder Gewalt

### Weg 5: Mein Gegenüber wirkt still oder zieht sich zurück (Sicht der Person daneben)

**Einstieg:** Du merkst, dass etwas kippt. Du musst nichts lösen und nichts erraten. Du kannst anhalten und fragen.
1. Halte inne und nimm die Hände weg.
2. Frag leise und offen: „Ist alles gut? Möchtest du weitermachen, eine Pause oder aufhören?“
3. Hör die Antwort wirklich an. Zögern, Schweigen oder „Ich weiß nicht“ ist kein Ja. Im Zweifel: aufhören.
4. Antworte ohne Vorwurf und ohne Gekränktsein: „Danke, dass du es sagst.“ Dein Gegenüber soll sich nicht schuldig fühlen.

**Ein Satz, den du sagen kannst:** „Ich merke, dass etwas anders ist. Möchtest du eine Pause?“ / „Danke, dass du es mir sagst. Das ist völlig in Ordnung.“
**Schluss:** Anhalten ist ein Zeichen von Zuneigung. Wenn es dich selbst verunsichert hat: Sprecht später darüber.

### Weg 6: Es lief anders als gedacht (danach)

**Einstieg:** Vielleicht wurde abgebrochen, vielleicht war es nur anders als erhofft. Scham danach ist verbreitet und vergeht.
1. Bleibt beieinander, wenn es für euch beide guttut: eine Hand halten, nebeneinander atmen. Braucht jemand Abstand, ist das auch in Ordnung. Sag dann kurz: „Ich brauche einen Moment und komme wieder.“
2. Trenne, was geschehen ist, von dem, was du wert bist. Ein Körper reagiert auf Stress, Müdigkeit und Gedanken. Das ist keine Aussage über dich.
3. Sprecht darüber, wenn ihr beide bereit seid, heute oder morgen, ohne Schuldzuweisung. Kurs 12 hat Sätze dafür. Im Journal kannst du erst für dich aufschreiben, was los war.
4. Fragt euch beide: Was hat uns gutgetan? Was wünsche ich mir beim nächsten Mal anders?

**Ein Satz, den du sagen kannst:** „Danke, dass du da warst. Es war schwer, aber ich möchte mit dir darüber reden.“ / „Ich brauche kurz Ruhe. Kann ich dich später ansprechen?“
**Schluss:** Nähe, die so etwas aushält, trägt.

### Weg 7 und fester Teil: Hilfe, wenn ein Nein nicht gilt

(kein Schrittweg, sondern eine feste Seite; bleibt in der App, kein Paket, nichts davon wird gespeichert)

**Titel:** Hilfe, wenn ein Nein nicht gilt
**Einstieg:** Wenn du Nein gesagt hast und es zählt nicht, ist das nicht in Ordnung. Du bist nicht schuld. Auch nicht, wenn ihr zusammen seid, wenn du vorher Ja gesagt hast oder wenn du nicht „genug“ gesagt hast.

**Was gilt:**
- Ein Nein gilt, auch mittendrin und auch in einer Beziehung.
- Überreden, Drängen, Schmollen, Drohen oder Schweigen als Druckmittel ist keine Zustimmung.
- Wer schläft, betrunken oder eingeschüchtert ist, kann nicht zustimmen.
- Du musst nichts beweisen, um Hilfe zu bekommen.

**Bei akuter Gefahr** (Notruf, kostenlos): Deutschland 110 (Polizei) / 112 (Rettung); Österreich 133 / 112; Schweiz 117 / 144 (Stand siehe „noch zu prüfen“); Vereinigtes Königreich 999; USA 911.
**Ruf an, wenn du reden möchtest:** (Stellen siehe unten; Auswahl nach Land, aufgeklappt für das Land des Geräts)
**Diskretion:** „Anrufe können in der Anrufliste oder auf der Rechnung auftauchen. Du kannst sie danach dort löschen. Mit dem Chat bleibt in der Regel weniger zurück.“ (nur sagen, was zutrifft; vor Einbau prüfen)
**Wenn du selbst Grenzen überschritten hast:** (offene Frage 6, noch nicht ausformuliert)

### Anlaufstellen (nur belegte Angaben)

| Land | Stelle | Nummer | Angabe laut Quelle |
|---|---|---|---|
| DE | Hilfetelefon Gewalt gegen Frauen (auch sexuelle Gewalt) | 116 016 | rund um die Uhr, kostenlos, anonym, Beratung auch per Chat und in vielen Sprachen; hilfetelefon.de. Die alte Nummer 08000 116 016 galt laut einer Quelle parallel |
| DE | Hilfetelefon Gewalt an Männern | 0800 123 99 00 | kostenlos, anonym, Telefon und Chat; Zeiten laut Quelle Mo bis Do 8 bis 20, Fr 8 bis 15 Uhr; maennerhilfetelefon.de |
| DE | WEISSER RING Opfer-Telefon | 116 006 | täglich 7 bis 22 Uhr, kostenlos, anonym; Opfer von Straftaten |
| DE | Telefonseelsorge | 0800 111 0 111 / 0800 111 0 222 | rund um die Uhr, kostenlos; Chat nach Anmeldung auf online.telefonseelsorge.de |
| AT | Frauenhelpline gegen Gewalt | 0800 222 555 | rund um die Uhr, kostenlos, auf Wunsch anonym, mehrsprachig |
| AT | Gewaltschutzzentren | 0800 700 217 | kostenlos, laut oesterreich.gv.at |
| CH | Opferhilfe | 142 | seit 1. Mai 2026 schweizweit, rund um die Uhr, kostenlos, anonym; kein Notruf; opferhilfe-schweiz.ch |
| UK | Rape Crisis England & Wales Support Line | 0808 500 2222 | rund um die Uhr, kostenlos, Chat auf 247sexualabusesupport.org.uk, ab 16 Jahren, England und Wales; im Notfall 999 |
| US | RAINN National Sexual Assault Hotline | 800.656.HOPE (4673) | rund um die Uhr, kostenlos, vertraulich, Englisch und Spanisch; online.rainn.org |
| US | 988 Suicide & Crisis Lifeline | 988 | Anruf oder SMS, rund um die Uhr, kostenlos |

Quellen (Suchtreffer, vor dem Bauen einzeln auf der Originalseite gegenlesen): [hilfetelefon.de via NRW-Ministerium](https://www.mkjfgfi.nrw/menue/gleichstellung/gewaltschutz-und-gewaltpraevention/das-hilfetelefon-gewalt-gegen-frauen),
[Männerhilfetelefon](https://maennerhilfetelefon.de/en/information-plain-language) und [NRW](https://www.mkjfgfi.nrw/menue/gleichstellung/gewaltschutz-und-gewaltpraevention/hilfetelefon-gewalt-maennern),
[Bundesnetzagentur 116 006](https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/116xyz/116006.html?nn=697214),
[Telefonseelsorge via Familienportal](https://familienportal.de/familienportal/lebenslagen/krise-und-konflikt/krisetelefone-anlaufstellen),
[Frauenhelpline (BMWET)](https://www.bmwet.gv.at/bmafjgvat/frauen-und-gleichstellung/services/frauenservice-beratung-und-gewaltschutzeinrichtungen/frauenhelpline-gegen-gewalt.html),
[oesterreich.gv.at](https://www.oesterreich.gv.at/de/themen/notfaelle_unfaelle_und_kriminalitaet/hilfe-bei-gewalt/2/Seite.290501),
[Bundesamt für Justiz Opferhilfe](https://www.bj.admin.ch/de/opferhilfe), [zh.ch Opferberatung](https://www.zh.ch/de/sicherheit-justiz/opferhilfe/opferberatung.html),
[Rape Crisis England & Wales](https://rapecrisis.org.uk/get-help/want-to-talk/), [gov.uk](https://www.gov.uk/government/news/new-24-7-support-service-for-victims-of-rape-launched),
[RAINN](https://www.rainn.org/about-national-sexual-assault-telephone-hotline).

**Noch zu prüfen, bevor es in die App kommt (nicht erfunden, nicht bestätigt):**
- Notrufnummern 110/112/133/117/144/999/911: allgemein bekannt, aber noch nicht aus einer Behördenseite belegt.
- Hilfetelefon Sexueller Missbrauch (0800 22 55 530): Zeiten widersprüchlich, richtet sich vor allem an Betroffene von Missbrauch in der Kindheit; bleibt vorerst draußen.
- Schweiz: Die Dargebotene Hand (143) taucht in keiner gelesenen Quelle auf; bleibt draußen, bis belegt.
- Österreich: eine Männer-Stelle ist nicht belegt. Ebenso Stellen speziell für queere Menschen und für Männer in der Schweiz, UK und USA.
- Öffnungszeiten und Nummern ändern sich (116 016, 142 sind jung): Die Liste bekommt ein Datum „Stand“ und eine Prüfung vor jedem Release.

## Das Symbol oben rechts (Grafik, zwei Vorschläge)

Heute: Schild (`Icons.shield_outlined`), liest sich als Datenschutz.

- **Vorschlag A (empfohlen): Wort-Kapsel „Hilfe“** mit kleinem Rettungsring links, Signalfarbe, Höhe 36 dp. Eindeutig durch das Wort,
  neutral genug für den Diskretions-Modus.
- **Vorschlag B: reiner Rettungsring** im Kreis (SVG, Linienstärke wie die übrigen Kopfzeilen-Symbole), Beschriftung nur als
  Tooltip und Screenreader-Text („Hilfe“). Ruhiger, aber ohne Wort weniger eindeutig.

Beide als SVG (`assets/icons/`), ohne Menschen. „SOS“ als Wort verworfen: klingt nach Alarm und passt nicht zu „Nervös vorher“.

## Technik

- **Inhalte:** `sos_cards` in `assets/data/velvet_content.json` bekommt ein neues Schema (`id`, `choice`, `intro`, `steps[]`,
  `phrases[]`, `closing`, `to_help`); `mantra` und `situation` entfallen. `SosCard` in `lib/models/content_models.dart` entsprechend.
  Englisch in `translations/en/velvet_content.json` und PO-Abgleich. Die Karten bleiben fest in der App (Sicherheitshinweise).
- **Hilfe-Teil:** Texte in `lib/l10n/app_de.arb` / `app_en.arb`; Stellen als feste Liste in `lib/data/sos_anlaufstellen.dart`
  (Land, Name-Schlüssel, Nummer, Hinweis-Schlüssel, Link, Stand). Anrufen über das vorhandene `url_launcher` (`tel:`), Links ebenso.
  Nichts wird gespeichert, daher keine Änderung an Sicherung/Backup-Merge. Keine neue Berechtigung.
- **UI:** `lib/screens/sos/sos_modal.dart` wird zu Auswahl, Schritt-Seiten (PageView), Hilfe-Seite. Magazin-Look:
  `AppTheme`/`VpRadius`, keine neuen Farben außer Signal für den Hilfe-Knopf. Zielflächen mindestens 56 dp.
  `lib/widgets/sos_button.dart` bekommt das neue Zeichen. Alte ARB-Schlüssel `sosModal*` werden ersetzt.
- **Tests:** Test für Datenform und Sprachabgleich der Karten; Test „kein Verweis auf Coach, Mantra, Stoßen/Liebhaber“;
  Test, dass jede Stelle Land, Nummer und Stand hat; `screens_test` mit Auswahl, Schritt und Hilfe-Seite.
- **Betroffene Dateien (zu sperren):** `lib/screens/sos/sos_modal.dart`, `lib/widgets/sos_button.dart`, `lib/models/content_models.dart`,
  `lib/services/data_service.dart`, `assets/data/velvet_content.json` (nur `sos_cards`), `translations/en/velvet_content.json`,
  ARB-Dateien, neue Dateien in `lib/data/`, `assets/icons/`, `test/`, `assets/data/anleitung.json`, `assets/data/neuigkeiten.json`,
  `docs/ANLEITUNG.md`, `docs/GUIDE.md`, `docs/AUFGABEN.md`.

## Offene Fragen

1. **Name und Zeichen:** Vorschlag A (Kapsel „Hilfe“) oder B (nur Rettungsring)? Heißt der Bereich weiter „SOS“ in der Anleitung?
2. **Anrufen aus der App:** Soll ein Tipp auf die Nummer direkt wählen (`tel:`), oder nur anzeigen und kopieren? (Anruf landet in der Anrufliste.)
3. **Länder:** Alle fünf Länder zeigen, aufgeklappt nach Gerätesprache/-region, oder nur DE/AT/CH (deutsch) und UK/US (englisch) nach App-Sprache?
4. **Schnell verlassen:** Ein Knopf im Hilfe-Teil, der das Blatt sofort schließt und zur Heute-Seite springt (für den Fall, dass jemand mitliest)?
5. **Reihenfolge der Antworten:** Soll „Ich werde gedrängt …“ als letzte, ruhige Antwort unten stehen (Vorschlag) oder ganz oben?
6. **Wenn jemand selbst Grenzen überschritten hat:** kurzer Hinweis ohne Nummern ergänzen (die Beratungsangebote dafür sind noch nicht recherchiert), oder später als eigener Schritt?
7. **Nach einem Übergriff:** medizinische Versorgung und vertrauliche Spurensicherung (ohne Anzeige) als Abschnitt? Das müsste ich erst aus offiziellen Quellen je Land recherchieren.
8. **Journal in Weg 6:** Wie heißt der Bereich in der App heute für den Nutzer: „Journal“ oder „Reframing-Tagebuch“? (Kurs 12 sagt Reframing-Tagebuch.)
9. **Englische Fassung:** schreibe ich nach deinem OK zu den deutschen Texten (inhaltsgleich, nicht wörtlich). Die Anlaufstellen sind für beide Sprachen gleich.
