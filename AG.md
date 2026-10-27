# Arbeitsaufträge für Antigravity

Diese Datei steuert Antigravity. Der Nutzer sagt nur: **„Hol ab und bearbeite.“** Dann gilt der Ablauf
unten.

## Wer macht was

| Wer | Aufgabe |
|---|---|
| **Nutzer** | entscheidet, hört an, liest gegen, gibt Releases frei |
| **Claude Code** | Konzepte, Code, Aufgabenliste `docs/AUFGABEN.md`; schreibt Aufträge in diese Datei; prüft die Pull Requests von Antigravity vor dem Zusammenführen; führt alle Pull Requests zusammen (bei Aufnahmen und Texten erst nach dem OK des Nutzers); pflegt „Gesperrt“ und „Erledigt“; baut und veröffentlicht Releases nach Freigabe |
| **Antigravity** | arbeitet die Aufträge in dieser Datei ab, jeder in eigenem Branch und eigenem Pull Request |

`docs/AUFGABEN.md` ist die Prioritätenliste des Projekts. Was davon an Antigravity geht, steht hier als
Auftrag (AG-n) und dort mit Verweis „→ AG-n“.

## Ablauf bei „Hol ab und bearbeite“

**Arbeitsordner:** Antigravity arbeitet immer im eigenen Klon `C:\TOOLS\workspace\mojo-ag`, nie in
`C:\TOOLS\workspace\mojo` (dort arbeitet Claude Code; ein gemeinsamer Ordner hat nur einen aktuellen Branch, und
Branch-Wechsel würden die andere Arbeit stören).

1. `git checkout main` und `git pull`. Gibt es lokale, nicht gesicherte Änderungen: anhalten und den Nutzer
   fragen, nichts verwerfen.
2. `CLAUDE.md` lesen. Die Regeln dort gelten auch für Antigravity (Sprache Deutsch, feste Regeln, Diskretion,
   Übersetzungen mitpflegen).
3. Den **ersten offenen Auftrag** nehmen (Reihenfolge = Priorität). Daueraufträge („laufend“) kommen dran,
   wenn sonst nichts offen ist oder sie ausdrücklich fällig sind.
4. Eigenen Branch anlegen, wie im Auftrag angegeben (sonst `ag/<auftrag-id>-<datum>`).
5. **Nur die im Auftrag genannten Dateien ändern.** Braucht es mehr, anhalten und fragen. Nie an Dateien
   arbeiten, die unter „Gesperrt“ stehen.
6. **Diese Datei (`AG.md`) im Auftrags-Branch nicht ändern.** Sonst kommen sich parallele Pull Requests in
   die Quere. „Erledigt“ trägt Claude nach dem Zusammenführen ein.
7. Prüfen, wie im Auftrag beschrieben (mindestens `flutter test`, wenn Code oder Inhalte betroffen sind).
8. Commit, Push, Pull Request gegen `main`. **Nicht selbst zusammenführen** (das macht Claude).
9. Die Beschreibung des Pull Requests nach der Vorlage unten schreiben. Kurz, keine Liste der Git-Befehle.

Wenn etwas unklar ist oder schiefgeht: anhalten und den Nutzer fragen statt raten. Lieber ein halber
Auftrag mit klarer Notiz als ein ganzer mit Vermutungen.

### Vorlage für die Beschreibung des Pull Requests

```
Auftrag: AG-n

### Erledigt
- (ein Punkt je Ergebnis)

### Für den Nutzer
- Anhören / Gegenlesen: (Datei, Stelle, worauf achten)

### Offen oder unsicher
- (Fragen, Vermutungen, was nicht ging; sonst „nichts“)

### Geprüft
- flutter test: grün / nicht nötig
```

### Nach dem Pull Request

Claude prüft ihn (Nutzer: „Prüf die AG-Pull-Requests“), schreibt das Ergebnis als Kommentar in den Pull
Request und bessert Kleinigkeiten auf Wunsch direkt im Branch nach. Danach hört bzw. liest der Nutzer; nach
seinem OK führt Claude zusammen, trägt den Auftrag unter „Erledigt“ ein und entfernt einmalige Aufträge.

## Gesperrt (hier arbeitet gerade Claude Code)

Jede Zeile mit Datum. Einträge, die älter als drei Tage sind, fragt Antigravity beim Nutzer nach, statt sie
stillschweigend zu übergehen.

- 27.10.2026: `C:\TOOLS\velvet-inhalte\` (private Inhalte, nie anfassen)

## Offene Aufträge

### AG-5: Wochenrückblick im Traumtagebuch (einmalig, zuerst)

**Branch:** `ag/5-wochenrueckblick`
**Darf ändern:** `lib/screens/self_exploration/traum_tagebuch_screen.dart`, neue Datei
`lib/models/traum_rueckblick.dart`, neuer Test `test/traum_rueckblick_test.dart`, `lib/l10n/app_de.arb` und
`app_en.arb` (nur neue Schlüssel mit Präfix `rueckblick`), erzeugte `lib/l10n/app_localizations*.dart`.

**Vorher lesen:** `docs/konzepte/traum-reise.md` (Tabelle „Bausteine“, Punkt 5; „Entscheidungen“ Punkt 6),
`lib/models/traum_eintrag.dart`, `lib/screens/self_exploration/traum_tagebuch_screen.dart`.

1. `lib/models/traum_rueckblick.dart`: reine Funktion, die aus einer Liste `TraumEintrag` für die letzten
   sieben Tage zählt: Einträge, erinnerte Träume (Marke `erinnert`), „Nichts erinnert“, je Markierung die
   Anzahl und je Abend (`abend`, z. B. `traum:warmes_wasser`) die Markierungen danach. Keine Wertung.
2. Im Tagebuch oben eine ruhige, zuklappbare Karte „Diese Woche“ mit diesen Zahlen in Sätzen
   (z. B. „An 4 Morgen erinnert, 2 Mal luzide“). Ab dem ersten Eintrag sichtbar.
3. **Grenzen (Konzept):** kein Punktestand, keine Serien, keine Rangliste, keine Hervorhebung oder Empfehlung
   „mehr davon“. Die Zuordnung Abend → Markierungen nur als stille Liste.
4. Texte über ARB, Deutsch und Englisch; Englisch danach mit
   `flutter test test/uebersetzung_test.dart --dart-define=PO=sync` abgleichen.

**Prüfen:** `flutter analyze --no-fatal-infos --no-fatal-warnings`, `flutter test`,
`flutter test test_screens/screens_test.dart` (Screen `14_traumtagebuch` ohne Überlauf).

### AG-6: Realitätschecks (einmalig, nach AG-5)

**Branch:** `ag/6-realitaetschecks`
**Darf ändern:** neue Dateien `lib/services/realitaetscheck.dart`,
`lib/screens/self_exploration/realitaetscheck_screen.dart`, `test/realitaetscheck_test.dart`;
`lib/services/message_notifier.dart` (nur falls die Initialisierung geteilt werden muss),
`lib/screens/self_exploration/traum_tagebuch_screen.dart` (nur ein Eintrag „Realitätschecks“ ins Menü),
`lib/main.dart` (nur Initialisierung), `pubspec.yaml` (nur `timezone`, falls nötig),
`android/app/src/main/AndroidManifest.xml` (nur nötige Berechtigungen), ARB-Dateien (Präfix `realitaet`),
erzeugte `app_localizations*.dart`, `lib/services/storage_service.dart` und `test/backup_merge_test.dart` (nur die
Einstellungen der Realitätschecks in Sicherung und Backup-Merge).

**Vorher lesen:** `docs/konzepte/traum-reise.md`, Abschnitte „Realitätschecks“, „Traumtagebuch“ (Motive) und
„Technik“; CLAUDE.md „Diskretion“.

1. Einstellungen: an/aus (**Standard aus**), Zeitfenster (Standard 9 bis 21 Uhr), Anzahl pro Tag (2 bis 4).
   Gespeichert lokal und Teil der Sicherung (siehe CLAUDE.md „Neue gespeicherte Daten“).
2. Benachrichtigungen mit `flutter_local_notifications` (schon im Projekt, siehe `message_notifier.dart`),
   zufällig im Zeitfenster, für die nächsten Tage vorausgeplant; beim Ausschalten alle löschen.
3. **Texte neutral:** Benachrichtigung „Kurzer Moment für dich“ ohne jeden Bezug auf Träume, Lust oder Sex,
   auch nicht im Text darunter. Ein Tipp öffnet einen kleinen Bildschirm mit der Übung (auf die Hand schauen,
   Finger durch die Handfläche drücken wollen, einen Text zweimal lesen) und der Frage „Träume ich gerade?“.
4. Motive: Wörter, die in Tagebuch-Einträgen der letzten 30 Tage mindestens dreimal vorkommen (einfache
   Wortsuche, Füllwörter ignorieren, keine KI), werden im Bildschirm als eigene Auslöser angeboten
   („Wenn ich Wasser sehe, frage ich mich, ob ich träume“). Nur Vorschlag, nichts automatisch.
5. Erreichbar über ein Menü im Traumtagebuch und im Traum-Abend.
6. Auf Xiaomi/MIUI werden Benachrichtigungen oft gebremst: im Bildschirm einen kurzen Hinweis, dass Akku-
   Optimierung und Autostart für die App freigegeben sein sollten. Telefoneinstellungen ändert der Nutzer selbst.

**Prüfen:** wie AG-5, dazu ein Test für die Planung (Zeiten im Fenster, Anzahl, Ausschalten löscht) und für die
Motiv-Suche. Im Pull Request unter „Für den Nutzer“: was auf dem Handy zu testen ist.

### AG-7: Nächtliches Wecken (einmalig, nach AG-6)

**Branch:** `ag/7-naechtliches-wecken`
**Darf ändern:** neue Dateien `lib/services/naechtliches_wecken.dart`,
`lib/screens/self_exploration/wecken_screen.dart`, `test/naechtliches_wecken_test.dart`; Einträge im
Traum-Abend (`einschlaf_reise_screen.dart`, nur ein Schalter „Heute Nacht wecken“ im Traum-Modus) und im
Traumtagebuch (nur Öffnen nach dem Wecken); `assets/data/traum_reise.json` und
`translations/en/traum_reise.json` (nur neue Bausteine mit `phase: "wecken"`); `pubspec.yaml` (nur falls ein
Paket für den System-Wecker nötig ist, vorher im Pull Request begründen); ARB (Präfix `wecken`); Sicherung
und Backup-Merge wie bei AG-6.

**Vorher lesen:** `docs/konzepte/traum-reise.md`, Abschnitte „Bausteine“ (Punkt 4), „Sicherheit und Hinweise“,
„Technik“ (Nächtliches Wecken), „Sprache und Stil“; `docs/konzepte/einschlaf-reise-textvorgabe.md`.

1. Im Traum-Abend vor dem Start ein Schalter „Heute Nacht wecken“ (Standard aus) mit Uhrzeit, vorgeschlagen
   etwa fünf Stunden nach dem Start. Gilt nur für genau diese Nacht.
2. Wecken über den System-Wecker (Intent an die Uhr-App) mit neutralem Namen „Kurzer Moment“. Ein Tipp auf die
   Benachrichtigung bzw. das Öffnen der App danach zeigt Tagebuch und eine kurze Begleitung zum
   Wiedereinschlafen.
3. **Sicherheitsregeln:** höchstens zweimal pro Woche (danach Schalter gesperrt mit Erklärung), Hinweis auf
   Schichtarbeit, Schwangerschaft, Baby, Schlafmangel und Schlafparalyse, wie im Konzept. Kein Ton-Signal im
   REM-Schlaf.
4. Texte für die Begleitung (`phase: "wecken"`, drei bis vier Bausteine: kurz notieren, Absicht wiederholen,
   wieder sinken) **sanft und nicht erotisch**, nach der Textvorgabe, Deutsch und Englisch. Danach
   Übersetzung stempeln und PO abgleichen.
5. Einsprechen: `C:\TOOLS\kikiri-venv\Scripts\python.exe tools/generate_audio.py --traum <ids>` nur, wenn
   gerade keine andere Aufnahme läuft; Aufnahmen und `dauer.json` mit in den Pull Request.

**Prüfen:** wie AG-5, dazu ein Test für die Wochenregel. Im Pull Request: was auf dem Handy zu testen ist.

### AG-8: Nachfrage vor Lautsprecher-Wiedergabe (einmalig, nach AG-7)

**Branch:** `ag/8-lautsprecher`
**Vorher lesen:** `docs/konzepte/lautsprecher.md` (alles, besonders „Entscheidungen“).
**Darf ändern:** neue Dateien `lib/services/audio_ausgabe.dart`, `lib/widgets/lautsprecher_frage.dart`,
`test/audio_ausgabe_test.dart`; an den Abspielstellen nur der Aufruf der Nachfrage vor dem Start und das
Pausieren beim Abziehen: `lib/services/audio_service.dart`, `lib/widgets/audio_player_card.dart`,
`lib/screens/courses/lesson_detail_screen.dart`, `lib/screens/self_exploration/selbst_reise_screen.dart`,
`lib/screens/couples_channel/paar_abend_screen.dart`, `lib/screens/self_exploration/einschlaf_reise_screen.dart`
(gilt auch für Traum-Abend und Lust im Traum), `lib/screens/training/kegel_timer_view.dart`; die
Profil-Einstellungen (zwei Schalter: „Vor Lautsprecher-Wiedergabe fragen“, „Pausieren, wenn Kopfhörer getrennt
werden“, beide Standard an); `lib/services/storage_service.dart` und `test/backup_merge_test.dart` (die zwei
Einstellungen in Sicherung und Backup-Merge); `pubspec.yaml` (nur `audio_session`, falls genutzt);
`android/app/src/main/kotlin/**/MainActivity.kt` (nur falls ein MethodChannel nötig ist); ARB (Präfix
`lautsprecher`), erzeugte `app_localizations*.dart`; Anleitung (`assets/data/anleitung.json`,
`translations/en/anleitung.json`, `docs/ANLEITUNG.md`, `docs/GUIDE.md`, ein Satz im Abschnitt „Datenschutz“
bzw. „Geführte Audios“).

1. Dienst: aktuelles Ausgabegerät (eingebauter Lautsprecher ja/nein) und ein Strom „Kopfhörer getrennt“.
   Bluetooth, Kabel und USB gelten als nicht Lautsprecher.
2. Dialog vor jedem Start (Texte neutral, über ARB): „Die Wiedergabe läuft über den Lautsprecher. Trotzdem
   abspielen?“, Knöpfe „Abspielen“ / „Abbrechen“, Häkchen „Nicht mehr fragen“. Ein ganzer Abend fragt nur einmal.
3. Pausieren beim Trennen (abschaltbar): Stimme und Klangteppich pausieren, Fortsetzen nur per Tipp.
4. Übersetzung stempeln und PO abgleichen, „Was ist neu“ nur, wenn Claude es im Pull Request bestätigt.

**Prüfen:** `flutter analyze --no-fatal-infos --no-fatal-warnings`, `flutter test`, Screen-Test; Tests für die
Entscheidungslogik (Lautsprecher → Dialog, Kopfhörer/Bluetooth → kein Dialog, abgeschaltet → kein Dialog).
Im Pull Request unter „Für den Nutzer“: auf dem Handy testen mit und ohne Kopfhörer, Kopfhörer während eines
Abends abziehen, Bluetooth aus- und einschalten.

### AG-3: Texte für „Lust im Traum“ (an Claude Code abgegeben)

Der Inhaltsfilter von Antigravity bricht diese Texte ab. Claude Code schreibt sie (lokal unter
`C:\TOOLS\velvet-inhalte\lust\lust.json`); das Einsprechen kommt danach als eigener Auftrag.

### AG-1: Aussprache korrigieren (beendet)

Seit 27.10.2026 erledigt das Claude Code mit OpenCode (Ablauf in `docs/AUSSPRACHE.md`). Antigravity holt
keine Aussprache-Meldungen mehr ab und legt keine `aussprache/`-Branches mehr an.

## Erledigt

- 26.10.2026, AG-1 Schritt A (`aussprache/2026-10-26`, PR #12): 16 Lexikon-Einträge, 8 Aufnahmen neu.
- 26.10.2026, AG-2 (`ag/2-traum-sanft`, PR #11): sanfte Texte der Traum-Reise, 39 Bausteine je Sprache;
  Fantasie-Räume (31 Bausteine) lokal unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json` zum Gegenlesen.
- 27.10.2026, AG-1 Schritt B (`aussprache/2026-10-27-nachsprechen`, PR #20): 96 übrige Aufnahmen
  mit den Wörtern aus Schritt A nachgesprochen (55 Lektionen, 41 geführte Bausteine).
- 27.10.2026, AG-4 (`ag/4-traum-aufnahmen`, PR #27): Traum-Reise eingesprochen, 39 Bausteine für beide
  Stimmen (78 Aufnahmen) samt `dauer.json`.
