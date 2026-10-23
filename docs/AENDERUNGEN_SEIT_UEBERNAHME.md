# Änderungen seit der Übernahme durch Claude

Übergabe-Notiz für Antigravity (und jeden, der am Code weiterarbeitet). Stand: 23.10.2026.
Sie beschreibt, was sich gegenüber dem ursprünglichen Antigravity-Stand geändert hat, welche
Entscheidungen dahinterstehen und welche Stolperfallen man kennen muss, bevor man etwas anfasst.

---

## 1. Fehlerbehebung: App hing nach dem Onboarding

- **Symptom:** Nach „Personalisieren“ oder „Überspringen“ ging es nicht weiter, kein Absturz.
- **Ursache:** Im Release-Build hat R8 (Code-Schrumpfen) Teile von `shared_preferences` entfernt,
  die nur per JNI aufgerufen werden. Das Speichern des Profils schlug fehl (`NoSuchMethodError`,
  später `ClassNotFoundException`), und auch der Notfall-Weg wollte speichern.
- **Lösung:** In `android/app/build.gradle.kts` sind `isMinifyEnabled = false` und
  `isShrinkResources = false` gesetzt. **Nicht wieder einschalten**, sonst kehrt der Fehler zurück.
- Test dafür: `test/startup_test.dart`.

## 2. Datenschutz

- Die Datensicherung landet nur noch im privaten App-Speicher, nicht mehr in öffentlich lesbaren Ordnern.
- Der Datenschutztext in der App sagt ehrlich, was wo gespeichert wird und was über das Netz geht.
- **Diskretions-Modus** (Einstellungen):
  - Fingerabdruck-Sperre: `lib/services/privacy_service.dart` und `lib/widgets/app_lock.dart`.
    Die App sperrt sich nach einer Minute im Hintergrund wieder. Während die Sperre aktiv ist,
    gilt `FLAG_SECURE`: keine Screenshots und kein Vorschaubild im App-Wechsler.
  - Neutrales App-Symbol: zwei `activity-alias`-Einträge im Manifest (`LauncherDefault`,
    `LauncherDiscreet`), umgeschaltet über den MethodChannel `velvetpulse/privacy` in `MainActivity.kt`.
  - `MainActivity` ist deshalb eine `FlutterFragmentActivity` mit AppCompat-Theme
    (Voraussetzung für `local_auth`).
  - `lib/main.dart` liest den Sperr-Status vor dem ersten Frame und legt `AppLock` über die ganze App.

- **Sicherheits-Audit (ab 4.3.0):** Details stehen in `docs/SICHERHEIT_AUDIT_BASELINE.md`.
  - API-Key und Nostr-Schlüssel liegen im Keystore (`SecretStore`). Sie dürfen nie wieder in die
    SharedPreferences oder in ein unverschlüsseltes Backup.
  - Sicherungen laufen nur über `BackupCodec` (Schema 2, Geheimnisse nur mit Passwort).
  - Eingehende Nostr-Events laufen immer durch `NostrEventCheck`.
  - `test/security_test.dart` muss grün bleiben.

## 3. Technik und Build

- **Werkzeuge:** AGP 8.11.1, Gradle 8.14.3, Kotlin 2.2.20, Flutter 3.47.
- **Core Library Desugaring** ist aktiv (`desugar_jdk_libs 2.1.5`); `ota_update` braucht das.
- **Neue Pakete:** `local_auth`, `ota_update`, `package_info_plus`, `http`.
- **Build:** `flutter build apk --release --split-per-abi --build-number N`.
  Auf dem Handy ist der versionCode 2000+N (arm64).
- **Signierung:** Release-Builds werden mit einem eigenen Schlüssel signiert. Die Daten stehen in
  `android/key.properties`, das außerhalb von Git bleibt. Fehlt die Datei, wird mit dem Debug-Schlüssel
  gebaut. Keystore und Passwort gehören **nie** ins Repo. Den Schlüssel erzeugt
  `tools/schluessel_erstellen.ps1`.
- **In-App-Updates:**
  - `lib/services/update_service.dart` und `lib/widgets/update_dialog.dart` prüfen einmal täglich
    die GitHub-Releases von `angemann-app/velvet_app`.
  - Tag-Format: `v<version>+<build>`. Assets: `velvetpulse-<abi>.apk` plus `.sha256`.
    Die Prüfsumme ist Pflicht, ohne sie wird nichts installiert.
  - Im Manifest: `REQUEST_INSTALL_PACKAGES` und ein FileProvider (`res/xml/filepaths.xml`).
- **Release-Skript:** `tools/release.ps1 -Version x.y.z -Build N -Notes "..."` baut, legt die Prüfsummen an
  und veröffentlicht das Release. Es braucht `key.properties` und einen sauberen Git-Stand.
- **Update-Kanäle Beta und Stabil:**
  - Eine Beta ist ein GitHub-„Pre-release“: `release.ps1 -Version 4.2.0-beta.1 -Build N -Beta`.
  - Der Stabil-Kanal sieht nur normale Releases. Der Beta-Kanal sieht beide und nimmt die höchste Build-Nummer.
  - Die Nutzer schalten das in „Profil & Einstellungen“ um, gespeichert als `update_channel`.
- **Regeln, damit Beta und Stabil immer kompatibel bleiben:**
  - Gleicher Schlüssel und gleicher Paketname in beiden Kanälen.
  - Eine gemeinsame Build-Nummer, die mit jedem Release steigt, egal in welchem Kanal. Das Skript bricht ab,
    wenn sie nicht höher ist als die aller bisherigen Releases.
  - Releases nur von `main`. Eine stabile Version enthält damit immer alles aus den Betas davor.
  - Gespeicherte Daten (SharedPreferences, Backup-Format, Paar-Kanal-Nachrichten, Item-IDs) nur abwärtskompatibel
    erweitern: neue Felder optional, nichts umbenennen oder entfernen. Eine Beta darf nichts speichern,
    das eine stabile Version nicht lesen kann. So funktionieren auch Backups und der Paar-Kanal zwischen
    einem Partner auf Beta und einem auf Stabil.
- **Screenshot-Test:** `flutter test test_screens/screens_test.dart` rendert die Hauptscreens als PNG
  nach `build/screens/` und protokolliert Layout-Fehler.
  - Er meldet immer „failed“, weil das audioplayers-Plugin im Test fehlt. Das ist harmlos.
  - Weiße oder schwarze Balken in Titeln und Knöpfen kommen nur von den Test-Schriften.

## 4. Repository und Lizenz

- **Repo:** https://github.com/angemann-app/velvet_app, öffentlich. `.gitignore` und `README.md` sind angelegt.
- **Commits** laufen unter `angemann-app <346896525+angemann-app@users.noreply.github.com>`.
  Keine private Mailadresse verwenden.
- **Lizenz getrennt:**
  - Code: MIT (`LICENSE`).
  - Inhalte (Texte, Audio, Bilder, `docs/`, Texte in den Model-Dateien): CC BY-NC-SA 4.0 (`LICENSE-CONTENT.md`).
- **Tester:** Die Anleitung steht in `docs/TESTER.md`.
- **Wichtig:** Die App ist eine eigenständige Entwicklung. Sie wird nirgends als Nachbau einer anderen
  App bezeichnet, andere Produktnamen tauchen in Code und Texten nicht auf.

## 5. Inhalte

Alle Kursinhalte stehen in `assets/data/velvet_content.json`.

- **Format:** Alle Lektionen von Kurs 1–17 folgen jetzt einem therapeutischen Rahmen mit
  Klartext-Abschnitten:
  - „Warum das wirkt“
  - „Die Übung“
  - „Einvernehmen und Sicherheit“
  - eine Reflexionsfrage

  Kein Markdown verwenden: Der Text wird als `SelectableText` angezeigt und vorgelesen.
- **Korrekturen:**
  - Fachliche Fehler korrigiert (z. B. Zwei-Pedale-Modell, responsive Lust).
  - Unbelegte Zahlen und Heilversprechen entfernt.
  - Ärztliche Hinweise ergänzt.
- **Neuer Kurs 18 „Sich selbst erkunden“** (`course_self_exploration`):
  - Selbstberührung für Vulva **und** Penis, mit Technik-Grafiken.
  - Titel in Rot über das neue Feld `title_color` (in `Course.titleColor`).
  - **Mein Lust-Profil** (`lib/screens/self_exploration/lust_profile_screen.dart`): Wer mag, hält fest,
    was gefällt, und schickt es über den Paar-Kanal an den Partner.
- **Beckenboden-Training** (`lib/screens/training/kegel_timer_view.dart`, `kegel_guide_sheet.dart`):
  - Vier Übungsarten: Loslassen, Kräftigen, Schnelle Impulse, Wellen.
  - Wählbar sind drei Stufen sowie 5, 10 oder 15 Runden.
  - Sprachansagen aus `assets/audio/cues/`.
  - Die Anleitung enthält jetzt einen Sechs-Wochen-Plan und typische Fehler.
- **Ja/Nein/Vielleicht-Liste** (`lib/models/yes_no_maybe_models.dart`):
  - 63 Einträge in 10 Bereichen, jeweils mit Erklärung, Bereichsbild und optionalem Link zur Lektion („Weiterlesen“).
  - **Die IDs `item_1` bis `item_22` dürfen nie geändert werden**, weil der Partner-Abgleich daran hängt.
    Neue Einträge bekommen IDs ab `item_23`.
- **Bilder:**
  - Kursbilder `assets/images/cover_01..18.svg` als gezeichnete Silhouetten in warmem Licht.
  - Diagramme neu gezeichnet, teils anatomisch explizit.
  - Erzeugt per `tools/generate_covers.py` und `tools/generate_diagrams.py`. Bitte dort ändern,
    nicht in den SVGs.
- **Oberfläche:**
  - Paar-Kanal neu gestaltet (Funken, Nachrichten, Wünsche).
  - Layout-Fehler behoben, Texte durchgehend auf Deutsch.

## 5a. Englische Fassung (Pflicht)

- Alle Inhalte liegen zusätzlich auf Englisch in 	ranslations/en/ (nicht Teil des App-Releases).
- **Regel:** Jeder neue oder geänderte Inhalt wird im selben Arbeitsgang übersetzt. Das gilt für Lektionen,
  Kurse, SOS-Karten, Glaubenssätze, Bausteine des gemeinsamen Abends und die Ja/Nein/Vielleicht-Liste.
- 	est/translation_test.dart vergleicht Prüfsummen der deutschen Texte mit den eingetragenen Werten in
  _source. Fehlt eine Übersetzung oder ist sie veraltet, scheitert der Test und damit jedes Release.
- Nach dem Übersetzen: lutter test test/translation_test.dart --dart-define=STAMP=<schlüssel,…>.
  Nie stempeln, ohne vorher wirklich übersetzt zu haben.

## 6. Stimmen und Audio

- **Engine:** Alle Lektionen sind mit **Kokoro** neu eingesprochen, lokal und ohne Cloud.
  - Stimme Victoria für Kurse mit `category: women`, sonst Martin.
  - Eine Lektion kann die Stimme über das Feld `voice` selbst festlegen.
- **Skript:** `tools/generate_audio.py`. Es braucht die Python-Umgebung mit den deutschen Kokoro- und
  misaki-Forks (Aufruf siehe Kopf des Skripts).
  - `--pruefe` sucht nach verdächtiger Aussprache.
  - `--zeige "Wort"` zeigt die Lautschrift eines Wortes.
- **Aussprache-Korrekturen** stehen in `tools/aussprache.json`.
- **Änderst du einen Lektionstext, muss die Lektion neu eingesprochen werden**, sonst passt das Audio
  nicht mehr zum Text.

## 7. Neu: „Gemeinsamer Abend“ (geführtes Paar-Audio)

- **Einstieg:** im Paar-Kanal über die Karte bzw. das Blüten-Symbol im Kopf.
- **Ablauf:** 20, 30 oder 45 Minuten. Ankommen, zwei Berührungsrunden mit Rollenwechsel, Ausklang.
  Die meiste Zeit ist Stille, mit Klangschale an den Übergängen und optionalem Klangteppich.
- **Tiefe:** bekleidet, Haut an Haut oder intim.
- **Abwechslung:** Jeder Abend wird neu aus 54 Bausteinen zusammengestellt. Zuletzt gehörte
  Varianten werden gemieden.
- **Dateien:**
  - Texte: `assets/data/paar_abend.json`
  - Planer: `lib/models/paar_abend.dart`
  - Bildschirm: `lib/screens/couples_channel/paar_abend_screen.dart`
  - Audio: `assets/audio/paar/`, erzeugt mit `generate_audio.py --paar` und `--klang`.
    Dabei entsteht auch `dauer.json`, aus der der Planer die Stillen berechnet.
  - Test: `test/paar_abend_test.dart` prüft Dauer und Tiefe.

## 8. Offen

- Die Aufnahmen für Teil 1, Kurs 18 und den Gemeinsamen Abend sind noch nicht vollständig committet.
- Das erste Release über `tools/release.ps1` steht noch aus. Wer bisher eine Debug-Version hat, muss
  einmal eine Sicherung exportieren, die App deinstallieren und neu installieren.
- Später geplant:
  - Lernpfad als optionaler Modus.
  - Gemeinsam lernen im Paar-Kanal (Lektion teilen, gemeinsame Reflexion).
  - Feedback-Kanal für Tester.
