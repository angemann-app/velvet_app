# KI-Coach vollständig entfernen

Stand 12.11.2026, Entwurf zur Abstimmung. **Nichts davon ist umgesetzt.**

## Warum

Der Coach hört nur eine Seite einer Beziehung, ist als flirtende Figur angelegt und schickt Profilangaben
(Name, Alter, Geschlecht, Beziehungsstatus, Fokus) und Fragen an Google. Er kommt ganz weg. Der Plan eines
lokalen Modells (`tools/handy_ki_test.ps1`, Notiz in `AENDERUNGEN_SEIT_UEBERNAHME.md`) entfällt damit.

## Bestandsliste

### Code löschen
| Datei | Inhalt |
|---|---|
| `lib/screens/ai_coach/ai_coach_screen.dart` | Chat-Oberfläche |
| `lib/screens/ai_coach/api_key_guide_sheet.dart` | Anleitung „Key erstellen“ |
| `lib/services/ai_service.dart` | Gemini-Zugriff, Systemprompt |
| `lib/services/coach_vorschlaege.dart` | Beispielfragen nach Profil |
| `lib/models/chat_message.dart` | Chatmodell |
| `test/coach_vorschlaege_test.dart` | Test der Beispielfragen |
| `tools/handy_ki_test.ps1` | Messung lokaler KI-Modelle (Coach-Frage) |
| `docs/anleitung/05_kicoach.png`, `build/screens*/05_kicoach.png` | Bildschirmfotos (build/ ist erzeugt, nicht eingecheckt) |

### Code ändern
| Datei | Änderung |
|---|---|
| `pubspec.yaml` (+ `pubspec.lock`) | `google_generative_ai` entfernen, `flutter pub get` |
| `lib/screens/ueben/ueben_screen.dart` | dritter Reiter, Import, `coach`-Konstante weg |
| `lib/screens/main_navigation_screen.dart` | Kommentar und `_ => coach`-Zweig in `_navigateToTab`; Index 4 fällt auf Körper zurück (Aufrufer prüfen, siehe unten) |
| `lib/widgets/design/vp_tabs.dart` | nur Kommentar („03 Coach“); prüfen, ob die Kapitelleiste mit zwei Einträgen sauber aussieht |
| `lib/services/storage_service.dart` | `getApiKey`/`saveApiKey`, `getChatHistory`/`saveChatHistory`/`clearChatHistory`, `_keyChatHistory`, Onboarding-Abfrage (Z. 671), `exportWithSecrets` (Z. 759), Import/Rollback (Z. ~1009–1017) |
| `lib/services/secret_store.dart` | `apiKey` aus `_all` nehmen; Einmal-Aufräumen (siehe unten) |
| `lib/services/backup_codec.dart` | `legacySecrets['apiKey']` (Z. 104–107): weiter lesen, aber verwerfen |
| `lib/services/inhalt_suche.dart`, `traum_eintrag.dart`, `traumpraxis_verwalten.dart`, `paar_abend_screen.dart` | nur Kommentare, die Coach erwähnen |
| `lib/l10n/app_de.arb`, `app_en.arb` (+ erzeugte `app_localizations*.dart`) | siehe ARB-Schlüssel |
| `test_screens/screens_test.dart` | Z. 423–424 (Reiter „Coach“ antippen, Foto `05_kicoach`) |
| `test/security_test.dart` | Api-Key-Fälle anpassen, siehe „Tests“ |

### ARB-Schlüssel (de und en gleichzeitig)
- `aiCoach*` (rund 50, inkl. `aiCoachEinrichtung*`, Beispielfragen `aiCoachAsAWomanHowDo`, `…HowCanWeStopPerformance`, `…WhatToDoAboutRacing`, `…HowDoIExplainResponsive`, `…WhyDoesTheReverseKegel`)
- `aiService*` (u. a. der Systemprompt `aiServiceYouAreTheConfidentialSomatic`)
- `coachQ*` (15 Beispielfragen)
- `apiKeyGuideSheet*`
- `mainNavigationAiCoach`, `uebenCoach`
- **Nicht** löschen: `dailyCheckinCardCoachingInsight…`, `mainCbtSomaticCoaching`, `onboardingYourPrivateCoachingProgramme…`, `cbtNewEntry…Coach oder Freund` (andere Bedeutung, gehören nicht zum KI-Coach). Das Wort „Coaching“ im Onboarding-Untertitel („Dein privates Coaching-Programm …“) schlage ich zur Prüfung vor, ist aber kein KI-Bezug.
- Folgetexte mit KI-Bezug, die umformuliert werden: `onboardingVersprechenNetz` („Ins Netz geht nur …: KI-Coach, Paar-Kanal und die Suche nach Updates“ → nur Paar-Kanal und Update-Suche), `onboardingPrivateProfileJournalProgressStay` (nennt KI-Coach/Gemini), `onboardingAdjustsCourseRecommendationsPelvicFloor` („… und KI-Antworten“), `tagebuchPrivat` („gehen nicht an den KI-Coach“), `schlafDatenschutz` („keine Weitergabe an Coach“).
- PO-Dateien danach abgleichen: `flutter test test/uebersetzung_test.dart --dart-define=PO=sync` (u. a. `translations/po/oberflaeche/oberflaeche.pot`).

### Inhalte und Texte
- `assets/data/anleitung.json` + `translations/en/anleitung.json`: Abschnitt `coach` entfernen (Z. 66–70), Hinweis „gehen nicht an Partner oder KI-Coach“ (Z. 63) umformulieren, Übersetzungs-Hash `guide:coach` entfällt, Abschnittszahl beachten.
- `docs/ANLEITUNG.md`, `docs/GUIDE.md`: Abschnitt und Inhaltsverzeichnis, Bild `05_kicoach.png`.
- `assets/data/neuigkeiten.json` + `translations/en/neuigkeiten.json`: neuer Eintrag (Wortlaut unten). **Alte Einträge (Build 25 und 60er) bleiben unverändert** (Verlauf, sonst bricht die Prüfung je Build-Nummer).
- `README.md`, `README.de.md`: Abschnitte „AI coach (optional)“, „Adding a Gemini API key“, Datenschutztabelle.
- `docs/TESTER.md` (Z. 63), `docs/SICHERHEIT_AUDIT_BASELINE.md` (Hinweis: Coach entfällt), `docs/AENDERUNGEN_SEIT_UEBERNAHME.md` (Lokaler KI-Coach), `docs/AUFGABEN.md`, `docs/konzepte/heute-und-produktschliff.md` (Vermerk „entfallen“), ggf. `docs/konzepte/werbebroschuere.md` und `tools/werbebroschuere.py`.
- Datenschutz-/Onboarding-Hinweise, dass nichts mehr an Google geht: Die einzigen Netzwege sind danach Paar-Kanal (Nostr, verschlüsselt) und Update-Suche (GitHub). `INTERNET`-Berechtigung bleibt.

### SOS
Die SOS-Karten im aktuellen Stand (`lib/screens/sos/`) enthalten **keinen** Coach-Verweis, das habe ich per Suche geprüft. Das neue SOS-Konzept (`docs/konzepte/sos-neu.md`, im Worktree `mojo_sos`) sagt ausdrücklich „kein Verweis“. Der Hinweis in deinem Auftrag trifft also vermutlich einen älteren Stand. Ich bitte die Sexualtherapeut:in-Rolle zu prüfen, ob irgendwo (Lektionen, Kurse, Suche) ein Hinweis „frag den Coach“ steht.

## Datenmigration

1. **Beim ersten Start der neuen Version** (in `SecretStore.init` bzw. direkt danach in `StorageService.init`):
   - `SecretStore.write('gemini_api_key', null)` löscht den Schlüssel aus dem Keystore; zusätzlich Altbestand `prefs.remove('gemini_api_key')`.
   - `prefs.remove('ai_chat_history')`.
   - Einmal und idempotent; kein Merker nötig, da Löschen eines nicht vorhandenen Schlüssels harmlos ist. Die Schlüsselnamen bleiben dafür als private Konstanten in einer kleinen „Altlasten“-Funktion stehen.
2. **Alte Sicherungen**: `apiKey` in `secrets` und `legacySecrets` wird weiter gelesen (Größenprüfung bleibt), aber nicht mehr gespeichert. Unbekannte Felder werden still übergangen; kein Fehler. Der Chatverlauf war nie Teil der Sicherung (`exportAllUserData` enthält ihn nicht), das wird mit einem Test festgehalten.
3. **Neue Sicherungen** enthalten keinen `apiKey` mehr. Ältere App-Versionen, die so eine Sicherung einspielen, kommen damit zurecht (Feld war optional).
4. **Beta und Stabil**: keine Formatänderung; ältere Versionen lesen neue Sicherungen weiter. Die neue Version nennt „Was ist neu“ mit neuer Build-Nummer in beiden Kanälen.

## Üben ohne dritten Reiter (Designer:in)
Zwei Kapitel „01 Körper · 02 Gedanken“ in der `VpKapitelLeiste`. Vorschlag: Leiste bleibt, zwei Einträge nutzen die Breite gleichmäßig (kein Leerraum rechts). Das Design prüft die Rolle anhand der erzeugten Bilder (`build/screens/`, drei Themes, 360×640 und 430×932, Schriftskalierung 1.3 und 1.6).

## „Was ist neu“ (Entwurf, zwei ruhige Sätze)
> **Der KI-Coach ist weggefallen.** Er hörte immer nur eine Seite einer Beziehung, und seine Antworten kamen von einem fremden Dienst, an den deine Angaben gingen.
> Dein gespeicherter Schlüssel und der Chatverlauf wurden von diesem Gerät gelöscht; Antworten findest du in den Kursen, und bei Sorgen hilft eine Beratungsstelle oder dein Arzt.

(Englisch: translations/en/neuigkeiten.json. Der Text erscheint nur einmal nach dem Update, gilt für alle, die die App aktualisieren – die Zahl derer, die den Coach genutzt haben, lässt sich nicht erkennen, ohne Daten zu lesen; der Satz muss daher auch für Nichtnutzer ruhig klingen.)

## Tests
- `test/coach_vorschlaege_test.dart` fällt weg.
- `test/security_test.dart`: Fälle mit `saveApiKey`/`getApiKey` entfallen oder werden zu Migrationstests: (a) Altbestand `gemini_api_key` in prefs und im SecretStore ist nach `init` weg, (b) alte Sicherung mit `apiKey` (Klartext und `secrets`) lässt sich einspielen, Schlüssel wird nicht gespeichert, (c) Nostr-Schlüssel bleibt davon unberührt, (d) Export enthält weder `apiKey` noch `ai_chat_history`.
- `test/backup_merge_test.dart`: unverändert grün; ggf. Fall „alte Sicherung mit Coach-Feldern“ ergänzen.
- Zusätzlich ein Test gegen Rückfall: kein ARB-Schlüssel `aiCoach*`/`coachQ*` mehr (einfacher Abgleich der ARB-Dateien) und kein Import von `google_generative_ai`.
- Danach `flutter analyze`, `flutter test`, `flutter test test_screens/screens_test.dart`, Bilder unter `build/screens/` ansehen.

## Ablauf nach OK
1. Branch `claude/coach-entfernen-20261112` aus dem aktuellen Stand (Achtung: es gibt weitere Worktrees `design-magazin`, `paar-vertrauen`, `mojo_sos`; `main_navigation_screen.dart`, ARB und `neuigkeiten.json` sind dort evtl. auch betroffen → vorher in `AG.md` unter „Gesperrt“ eintragen, nur eigene Dateien stagen, kein `git add -A`).
2. Programmierer:in setzt um; Sexualtherapeut:in prüft Verweise (vor allem Lektionen, Anleitung, Onboarding, `tagebuchPrivat`) und schlägt Ersatz vor; Designer:in gestaltet „Üben“ mit zwei Kapiteln.
3. Prüfen, Gegenlesen durch frischen Subagenten, Doku nachziehen, committen. Nicht zusammenführen, nichts bauen, nichts veröffentlichen.

## Offene Fragen
1. **Branch-Basis**: Du bist auf `claude/altersnachweis-20261103` mit nicht eingecheckten Änderungen anderer Sitzungen (`AG.md`, `.mcp.json`, …). Soll der Branch von `main` oder von diesem Stand aus beginnen? Ich empfehle `main` (über einen eigenen Worktree, damit die offenen Änderungen unberührt bleiben).
2. **Coach-Beispielfragen**: Sollen sinnvolle Fragen (z. B. „Wie sprechen wir offen über Wünsche und Grenzen?“) irgendwo anders weiterleben, etwa als Gesprächsanstöße im Paar-Kanal oder als Lektionsimpulse? Ich schlage vor: nein, einfach löschen.
3. **„Dein privates Coaching-Programm …“** im Onboarding: lassen oder umformulieren? (Kein KI-Bezug, aber das Wort „Coaching“ bleibt dann stehen.)
4. **Alte „Was ist neu“-Einträge** (Build 25, 60 ff.), die den Coach nennen: unverändert lassen (mein Vorschlag).
5. **Neues Tab-Verhalten**: Aufrufer, die bisher Index 4 (Coach) nutzten, landen künftig bei „Körper“. Gibt es Lektionen oder Karten, die auf den Coach verlinken? (Suche nach `onNavigateToTool` mit 4 steht in Schritt 3 an.)
