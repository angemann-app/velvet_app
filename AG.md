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
5. **Zusatz: Realitätschecks sichtbarer machen** (Wunsch des Nutzers, 27.10.2026). Auf der Einrichtungsseite
   des Traum-Abends (`einschlaf_reise_screen.dart`, nur im Traum-Modus) eine Zeile „Realitätschecks“ mit
   Ein/Aus-Anzeige, die den `RealitaetscheckScreen` öffnet. Im Traumtagebuch (`traum_tagebuch_screen.dart`, dafür
   zusätzlich erlaubt) den Eintrag aus dem Drei-Punkte-Menü als eigene Zeile unter den Wochenrückblick holen.

**Prüfen:** `flutter analyze --no-fatal-infos --no-fatal-warnings`, `flutter test`, Screen-Test; Tests für die
Entscheidungslogik (Lautsprecher → Dialog, Kopfhörer/Bluetooth → kein Dialog, abgeschaltet → kein Dialog).
Im Pull Request unter „Für den Nutzer“: auf dem Handy testen mit und ohne Kopfhörer, Kopfhörer während eines
Abends abziehen, Bluetooth aus- und einschalten.

### AG-9: Freiwilliges „Hallo“ (einmalig, nach AG-8)

**Branch:** `ag/9-hallo`
**Vorher lesen:** `docs/konzepte/hallo.md` (alles), `lib/services/rueckmeldung.dart`, `lib/screens/rueckmeldung_screen.dart`.
**Darf ändern:** `lib/services/rueckmeldung.dart` (nur eine Funktion für das Hallo, gleicher Versandweg),
die Profil-Einstellungen (ein Eintrag „Einmal anonym Hallo sagen“), `lib/services/storage_service.dart`,
`lib/services/backup_codec.dart` und `test/backup_merge_test.dart` (nur der Merker „gesendet am“),
`tools/rueckmeldungen_abholen.dart` (Hallos getrennt zählen), neue Tests `test/hallo_test.dart`, ARB (Präfix
`hallo`), erzeugte `app_localizations*.dart`, Anleitung (Datenschutz-Abschnitt in `assets/data/anleitung.json`,
`translations/en/anleitung.json`, `docs/ANLEITUNG.md`, `docs/GUIDE.md`).

1. Eintrag im Profil mit kurzem Text: was gesendet wird (nur Version und Sprache), wie (verschlüsselt, ohne
   Absender) und dass es freiwillig ist. Knopf „Hallo sagen“; danach „Danke, gesendet am …“, kein zweites Mal.
2. Versand wie bei den Rückmeldungen (NIP-17, Gift Wrap, Einmal-Schlüssel), mit einer eigenen Art `hallo`,
   damit das Abholwerkzeug sie erkennt. Inhalt ausschließlich Version und Sprache.
3. `tools/rueckmeldungen_abholen.dart`: Hallos am Ende als Zählung ausgeben („Hallo: 3 (de 2, en 1; 4.13.0: 3)“),
   nicht einzeln. Den privaten Schlüssel nie ausgeben.
4. Nie automatisch senden, auch nicht nach Updates oder Wiederherstellung.

**Prüfen:** `flutter analyze --no-fatal-infos --no-fatal-warnings`, `flutter test`, Screen-Test; Tests: Inhalt
enthält nur Version und Sprache, ohne Tipp wird nichts gesendet, nach dem Senden kein zweites Mal, Merker in
Sicherung und Backup-Merge. Übersetzung stempeln und PO abgleichen.

### AG-3: Texte für „Lust im Traum“ (an Claude Code abgegeben)

Der Inhaltsfilter von Antigravity bricht diese Texte ab. Claude Code schreibt sie (lokal unter
`C:\TOOLS\velvet-inhalte\lust\lust.json`); das Einsprechen kommt danach als eigener Auftrag.

### AG-1: Aussprache korrigieren (beendet)

Seit 27.10.2026 erledigt das Claude Code mit OpenCode (Ablauf in `docs/AUSSPRACHE.md`). Antigravity holt
keine Aussprache-Meldungen mehr ab und legt keine `aussprache/`-Branches mehr an.

### AG-10: Anleitung für die Audioreihe „Innenansichten“ (einmalig, nach Merge von `feature/lust-reihe`)

**Branch:** `ag/10-anleitung-reihe`
**Vorher lesen:** `docs/konzepte/lust-audioreihe.md` (Abschnitte 1, 2, 4, 7), `lib/screens/self_exploration/lust_reihe_screen.dart`
(nur zum Verstehen der Bedienung).
**Darf ändern:** `assets/data/anleitung.json`, die zugehörige Datei in `translations/en/`, `docs/ANLEITUNG.md`,
`docs/GUIDE.md`.
**Aufgabe:** Einen kurzen Abschnitt „Innenansichten“ ergänzen: zusammenhängende Hörgeschichten von etwa 20 bis 30
Minuten, nicht zum Einschlafen; Soft und Spicy (Spicy nur im Spicy-Modus); Perspektive wählen, die Gegenperspektive
derselben Begegnung hat dieselbe Szenenfolge; Aufnahmen als eigenes Paket laden, danach offline; Szenen
überspringen im Player; nur ab 18, alle Figuren erwachsen, einvernehmlich. **Nicht schreiben:** Inhalte der
Geschichten, Wirkversprechen, „garantierte“ Synchronität zwischen zwei Handys (die App gleicht Geräte nicht ab).
Neutral und sachlich formulieren. Deutsch und Englisch.
**Prüfen:** `flutter test`. Wenn `test/translation_test.dart` fehlschlägt, anhalten und melden.

## Erledigt

- 26.10.2026, AG-1 Schritt A (`aussprache/2026-10-26`, PR #12): 16 Lexikon-Einträge, 8 Aufnahmen neu.
- 26.10.2026, AG-2 (`ag/2-traum-sanft`, PR #11): sanfte Texte der Traum-Reise, 39 Bausteine je Sprache;
  Fantasie-Räume (31 Bausteine) lokal unter `C:\TOOLS\velvet-inhalte\traum\fantasie.json` zum Gegenlesen.
- 27.10.2026, AG-1 Schritt B (`aussprache/2026-10-27-nachsprechen`, PR #20): 96 übrige Aufnahmen
  mit den Wörtern aus Schritt A nachgesprochen (55 Lektionen, 41 geführte Bausteine).
- 27.10.2026, AG-4 (`ag/4-traum-aufnahmen`, PR #27): Traum-Reise eingesprochen, 39 Bausteine für beide
  Stimmen (78 Aufnahmen) samt `dauer.json`.
- 27.10.2026, AG-5 bis AG-7 (PR #38, #40, #41, zusammen über #42): Wochenrückblick, Realitätschecks,
  nächtliches Wecken samt Texten und Aufnahmen. Claude ergänzte die SET_ALARM-Berechtigung.
