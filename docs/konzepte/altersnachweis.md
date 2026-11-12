# Konzept: Altersnachweis für den Spicy-Modus

**Status:** Entwurf, mit dem Nutzer abgestimmt in den Grundzügen (03.11.2026: Geburtsmonat/-jahr **und** Gerätesperre). Offene Punkte am Ende.

## Ziel und Grenze

Der Spicy-Modus (ab 18) soll nicht mit einem bloßen „Ja“ erreichbar sein. Alles bleibt **auf dem Gerät**, keine Drittdienste,
keine Kamera, kein Ausweis. Ehrlich gesagt: Ohne Server lässt sich das Alter nicht beweisen. Es ist eine Selbstauskunft
mit Hürden. Der Schutz hängt an der Ehrlichkeit der Person und an der Gerätesperre.

## Ist-Stand

- `StorageService.spicyMode()` (Schlüssel `spicy_mode`, SharedPreferences, **nicht** in der Sicherung).
- Einschalten über `spicyModusEinschalten` (`lib/widgets/spicy_modus_dialog.dart`): ein Dialog „Ich bin 18+“.
- Auch eine Einladung im Paar-Kanal führt dort hinein.
- Gerätesperre vorhanden: `PrivacyService` (`local_auth`, `FlutterFragmentActivity` bereits eingerichtet).
- Spicy-Pakete (`reihe`, `reihe-bilder`, `kurse-bilder-spicy`, `lust`) sind nur über R2 und nur im Spicy-Modus gedacht.

## Schicht 1: Geburtsmonat und -jahr

- Statt „Ja“ gibt die Person Monat und Jahr der Geburt ein (zwei Auswahlfelder, keine Tastatur).
- Gerechnet wird vorsichtig, weil der Tag fehlt: Es zählt der **letzte Tag** des Geburtsmonats; „18“ gilt erst, wenn der
  Geburtsmonat des 18. Jahres vollständig vorbei ist.
- Gespeichert wird **nur** `spicy_alter_bestaetigt` = Zeitpunkt der Bestätigung. Das Geburtsdatum wird nie gespeichert.
- Unter 18: Sperre. `spicy_alter_gesperrt_bis` = jetzt + 30 Tage (nur Datum, kein Grund). Währenddessen zeigt der Dialog
  einen ruhigen Text ohne Details und nimmt keine neue Eingabe an. Eine Neuinstallation hebt die Sperre auf; das lässt sich
  ohne Server nicht verhindern und wird so in der Anleitung nicht versprochen.
- Der Dialog nennt kurz, was Spicy ist, dass alles lokal bleibt und dass die Angabe keinen Ausweis ersetzt.

## Schicht 2: Gerätesperre

- Vor dem Einschalten: `PrivacyService` prüft, ob das Gerät eine Bildschirmsperre hat (`isDeviceSupported`, PIN/Muster/
  Fingerabdruck). **Ohne Sperre wird Spicy nicht angeboten**; Hinweis, die Gerätesperre einzurichten.
- Beim Einschalten einmal Gerätesperre bestätigen (`authenticate`). Das liest und sendet nichts.
- Danach gilt der Spicy-Modus als „entsperrt“ für die Dauer einer Sitzung. Nach **Neustart der App** oder **mehr als
  5 Stunden im Hintergrund** fragt die App beim ersten Spicy-Zugriff erneut nach der Gerätesperre (Einstellung im Profil:
  „Spicy immer erneut absichern“, Standard **an**; wer das nicht will, schaltet es aus und der Schalter bleibt wie heute).
- Ist die Gerätesperre später weg (Gerät entsperrt gesetzt), fällt Spicy auf **aus** zurück.

> **Nachtrag 12.11.2026:** Die früheren 30 Minuten waren zu kurz. Entschieden: fest **5 Stunden** im Hintergrund
> (`AlterDienst.erneutNach`, keine Auswahl im Profil). Läuft die Frist ab, zeigt die App beim Zurückkehren einmal den
> Hinweis „Spicy-Modus ist aus“ mit „Wieder entsperren“. Einzelheiten in `privatsphaere-schutz.md`, Abschnitt b.

## Schicht 3: Sicherung, Pakete, Paar-Kanal

- Altersnachweis, Sperre und Entsperr-Status gehören **nicht** in Sicherung und Backup-Merge; nach einem Import muss
  neu bestätigt werden. (Test: `test/backup_merge_test.dart` bleibt grün, plus ein Test, dass die Schlüssel fehlen.)
- Spicy-Pakete werden nur geladen und angeboten, wenn Spicy **bestätigt und entsperrt** ist. Bereits geladene Dateien
  bleiben auf dem Gerät, sind aber ohne Entsperren nicht abspielbar (Wiedergabe-Gate prüft den Katalog wie bisher, plus
  den Entsperr-Status).
- Einladung im Paar-Kanal schaltet Spicy nie selbst frei; sie öffnet denselben Ablauf mit eigener Bestätigung.
- Altbestand: Wer Spicy heute schon an hat, bekommt **einmal** den neuen Ablauf beim nächsten Spicy-Zugriff; bis dahin bleibt
  Spicy sichtbar aus, ohne dass Daten verloren gehen.

## Bewusst nicht

Ausweisfoto, Kameraprüfung, Alterschätzung, Konto, Server, Analyse. Diskretion bleibt: Texte im Dialog und in
Benachrichtigungen neutral (kein „Sex“ in Titeln der Systembenachrichtigungen).

## Technik (Umsetzung später)

- Neuer `lib/services/alter_dienst.dart`: `bestaetigt`, `gesperrtBis`, `entsperrt` (Sitzungsstatus, Zeitstempel), `pruefenUndEntsperren()`.
- `spicyModusEinschalten` ruft ihn auf; `StorageService.spicyMode()` bleibt der Schalter, wird aber zusätzlich an
  `AlterDienst.istFrei` geknüpft (eine zentrale Stelle, nicht an den 78 Aufrufern).
- Texte in `app_de.arb`/`app_en.arb`, Anleitung, „Was ist neu“, DE/EN-Übersetzung.
- Tests: Altersrechnung (Grenzfälle Geburtsmonat), Sperrfrist, Rückfall ohne Gerätesperre, Entsperrung nach Hintergrund,
  Sicherung enthält nichts davon.

## Entscheidungen (03.11.2026, Nutzer)

1. Sperrfrist 30 Tage: ja.
2. Erneute Abfrage der Gerätesperre nach App-Neustart oder 30 Minuten im Hintergrund: ja (abschaltbar im Profil).
   Seit 12.11.2026: 5 Stunden statt 30 Minuten (siehe Nachtrag in Schicht 2).
3. Altbestand: wer Spicy schon an hat, bestätigt Alter und Gerätesperre einmal neu; bis dahin bleibt Spicy aus, die Wahl bleibt erhalten.

## Umsetzung

`lib/services/alter_dienst.dart`, Gate zentral in `StorageService.spicyMode()` (`spicyGewaehlt()` ist die reine Wahl),
Dialog `lib/widgets/spicy_modus_dialog.dart`, Profil-Schalter in `onboarding_screen.dart`, Tests `test/alter_dienst_test.dart`.
Die Prüfung wird erst durch `AlterDienst.init()` (main.dart) scharf; ohne sie verhält sich `spicyMode()` wie bisher (Tests).