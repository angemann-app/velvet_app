# VelvetPulse

> **KVT, Somatik und Intimität ohne Leistungsdruck – für Sie, für Ihn und für Paare**
> Private Flutter-App für Android · Daten bleiben auf dem Gerät · Ende-zu-Ende-verschlüsselter Paar-Kanal über Nostr

[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-blue.svg)](https://flutter.dev)
[![Nostr](https://img.shields.io/badge/Nostr-NIP--04-purple.svg)](https://github.com/nostr-protocol/nips/blob/master/04.md)

> **Hinweis:** Die App richtet sich an Erwachsene und enthält offene Aufklärungsinhalte zu Sexualität.
> Sie ersetzt keine ärztliche oder psychotherapeutische Behandlung. Wo es medizinisch sinnvoll ist,
> weisen die Lektionen ausdrücklich darauf hin, wann eine Abklärung ratsam ist.

---

## Worum es geht

Leistungsdruck, Kopfkino und angespannte Körper sind die häufigsten Bremsen für erfüllte Intimität.
VelvetPulse verbindet Methoden der **Kognitiven Verhaltenstherapie (KVT)** mit **Körperarbeit (Somatik)**
und praktischem **Ratgeberwissen**: erst verstehen, warum der Körper bremst, dann mit Übungen,
Atmung und Berührung den Fuß von der Bremse nehmen – allein oder zu zweit.

**Ausprobieren:** [Anleitung für Tester](docs/TESTER.md) · [Neueste Version](https://github.com/angemann-app/velvet_app/releases/latest)

## Funktionen

### Kurse und Lektionen
- **17 Kurse mit 53 Lektionen** in zwei Teilen:
  - *Grundlagen* (Kurse 1–7): Zwei-Pedale-Modell, Beobachter-Falle, Beckenboden, Kommunikation, Sensate Focus.
  - *Praxis* (Kurse 8–17): Berührung für Sie und Ihn, Stimme und Atem, Vorfreude und Langsamkeit, Fantasien,
    Intim-Massage, Prostata und Damm, entspannte Stellungen, Szenarien für zwei.
- Jede Praxis-Lektion folgt demselben Aufbau: **Warum das wirkt** · **Die Übung** ·
  **Einvernehmen und Sicherheit** · bei Bedarf **Wann ärztlich abklären**.
- **Audio zu jeder Lektion** (offline, eingesprochen von den Stimmen Victoria und Martin), mit Play/Pause,
  10-Sekunden-Sprüngen und Fortschrittsbalken.
- **Anleitungsgrafiken** (z. B. Yoni- und Lingam-Massage) – antippen öffnet sie im Vollbild mit Zoom.
- Kursfilter nach *Für Sie*, *Für Ihn*, *Für Paare* und *Berührung*.

### Training und Akuthilfe
- **Atem-Taktgeber** (u. a. 4-7-8-Atmung, physiologischer Seufzer).
- **Beckenboden-Timer** für Loslassen und Kräftigen.
- **SOS-Knopf** mit Checklisten für *vorher*, *im Moment* und *danach*.

### Reframing-Tagebuch
- Gedankenprotokolle nach KVT: automatischer Gedanke, Realitätscheck, neue Perspektive.
- Baukasten mit typischen Glaubenssätzen zum Übernehmen.
- Täglicher 30-Sekunden-Check-in zu Stress und Leistungsdruck.

### Paar-Kanal
- Verbinden per **QR-Code** – ohne Konto, ohne Telefonnummer.
- **Funken:** ein Tippen sagt, worauf man heute Lust hat – oder eben nicht („Heute lieber nicht“).
- **Wünsche heimlich abgleichen:** Beide stimmen getrennt ab; sichtbar wird nur, was beide wollen.
- **Fantasie-Landkarte:** 22 Fragen in 5 Bereichen, auch allein ausfüllbar.

### Diskretion und Updates
- **App-Sperre per Fingerabdruck** (beim Start und nach einer Minute im Hintergrund); Inhalte sind in der
  App-Übersicht verborgen.
- **Unauffälliges App-Symbol** „Pulse“ auf Wunsch.
- **Updates direkt in der App** aus den GitHub-Releases, mit Prüfsummen-Kontrolle.

### KI-Coach (optional)
- Vertraulicher Gesprächspartner über **Google Gemini** mit eigenem API-Key (*bring your own key*).

## Datenschutz

| Was | Wo |
|---|---|
| Profil, Fortschritt, Tagebuch, Check-ins | nur auf dem Gerät (`SharedPreferences`) |
| Automatisches Backup | privater App-Speicher (für andere Apps nicht lesbar), über Androids Cloud-Backup gesichert |
| Paar-Kanal | NIP-04-verschlüsselt über öffentliche Nostr-Server; diese sehen, *dass* zwei anonyme Schlüssel schreiben, nicht *was* |
| KI-Coach | Nachrichten gehen an Google Gemini – nur wenn du einen eigenen API-Key hinterlegst |

Es gibt keine Benutzerkonten, kein Tracking und keinen eigenen Server.
Ein manuelles Backup lässt sich unter *Profil → Backup exportieren* in die Zwischenablage kopieren.

## Gemini-API-Key hinterlegen (optional)

1. Bei [Google AI Studio](https://aistudio.google.com/) anmelden.
2. **Get API key → Create API key** wählen.
3. In der App im Tab **KI-Coach** auf das Einstellungs-Symbol tippen und den Schlüssel einfügen.

## Entwicklung

### Voraussetzungen
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Dart ≥ 3.0)
- JDK 17
- Android SDK
- Für Releases: [GitHub CLI](https://cli.github.com/) (`gh auth login`)
- Für die Audio-Erzeugung: Python 3.10–3.13 und `ffmpeg`

### Starten und bauen
```bash
flutter pub get
flutter run
```

Release-APK zum Testen (pro Architektur, kleiner):
```bash
flutter build apk --release --split-per-abi --build-number <N>
```
Die APKs liegen danach unter `build/app/outputs/flutter-apk/`.

### Release veröffentlichen (Updates für Tester)
Die App prüft beim Start einmal täglich die [GitHub-Releases](https://github.com/angemann-app/velvet_app/releases)
und bietet neue Versionen zum Installieren an (`lib/services/update_service.dart`).
```bash
powershell -ExecutionPolicy Bypass -File tools\release.ps1 -Version 4.1.0 -Build 13 -Notes "Neu: …"
```
Das Skript baut die App, legt je Architektur `velvetpulse-<abi>.apk` samt `.sha256`-Prüfsumme an und
erstellt das Release mit dem Tag `v<Version>+<Build>` über die [GitHub CLI](https://cli.github.com/).
Die Build-Nummer muss bei jedem Release steigen.

### Signierschlüssel
Releases werden mit einem eigenen Schlüssel signiert. Er wird einmalig mit `tools\schluessel_erstellen.ps1`
erzeugt und über `android/key.properties` eingebunden (nicht im Repository). Ohne diese Datei baut die App mit
dem Debug-Schlüssel – das Release-Skript bricht dann ab.

> **Schlüssel und Passwort niemals verlieren.** Android installiert Updates nur mit demselben Schlüssel.
> Ohne ihn müssten alle Nutzer die App löschen und neu installieren.

> **Hinweise zum Build**
> - Die Build-Nummer bei jedem Update erhöhen. Bei `--split-per-abi` wird daraus der Versionscode 2000 + N (arm64);
>   ein kleinerer Versionscode wird vom Gerät als Downgrade abgelehnt.
> - Code-Minifizierung (R8) ist im Release bewusst **aus**: `shared_preferences` ruft Kotlin-Code per JNI auf,
>   den R8 sonst entfernt – die App kann dann nichts mehr speichern.
> - `MainActivity` ist eine `FlutterFragmentActivity` und die Themes erben von AppCompat – beides braucht die
>   Fingerabdruck-Sperre (`local_auth`).

### Tests
```bash
flutter test                                   # Startablauf: Onboarding → alle Tabs
flutter test test_screens/screens_test.dart    # rendert alle Screens als PNG nach build/screens/
```
Der Screenshot-Test meldet außerdem Layout-Überläufe pro Screen. Graue Balken in Titeln und Buttons
auf den PNGs sind ein Schriftartefakt der Testumgebung, kein Fehler der App.

### Inhalte und Medien

| Datei / Werkzeug | Zweck |
|---|---|
| `assets/data/velvet_content.json` | alle Kurse, Lektionen, SOS-Karten und Glaubenssätze |
| `assets/audio/<lektions-id>.opus` | Audio je Lektion (fehlt sie, liest die Geräte-Sprachausgabe vor) |
| `tools/generate_audio.py` | Lektionen neu einsprechen, z. B. `tease_1` oder `--courses 8-17` (siehe unten) |
| `tools/aussprache.json` | Aussprache-Wörterbuch für einzelne Wörter |
| `tools/generate_covers.py` | Kursbilder `assets/images/cover_NN.svg` neu erzeugen |
| `assets/images/diagram_*.svg` | Anleitungsgrafiken (800×600) |

### Audio neu einsprechen
Die Lektionen werden **lokal** mit [Kokoro](https://github.com/hexgrad/kokoro) und deutschen Community-Stimmen erzeugt:
[Victoria](https://huggingface.co/kikiri-tts/kikiri-german-victoria) für die Kurse „Für Sie“,
[Martin](https://huggingface.co/kikiri-tts/kikiri-german-martin) für alle anderen (beide Apache-2.0).
Nach jeder Textänderung an einer Lektion sollte ihr Audio neu erzeugt werden.

Einmalige Einrichtung einer eigenen Python-Umgebung (die deutschen Kokoro-Forks):
```bash
python -m venv C:\TOOLS\kikiri-venv
C:\TOOLS\kikiri-venv\Scripts\python.exe -m pip install torch --index-url https://download.pytorch.org/whl/cpu
C:\TOOLS\kikiri-venv\Scripts\python.exe -m pip install huggingface_hub soundfile numpy espeakng-loader edge-tts "git+https://github.com/semidark/misaki.git@6d252a2e02f3b030f22f56686f1a73786c16ffc8" "git+https://github.com/semidark/kokoro.git"
```
Einsprechen und Aussprache prüfen:
```bash
C:\TOOLS\kikiri-venv\Scripts\python.exe tools\generate_audio.py tease_1
C:\TOOLS\kikiri-venv\Scripts\python.exe tools\generate_audio.py --zeige "Pedal" "liefern"
```
Klingt ein Wort falsch, kommt seine Lautschrift in `tools/aussprache.json`. Mit `--engine edge` wird stattdessen
Microsoft Edge TTS genutzt; der Text geht dann an Microsofts Dienst.

## Lizenz

[MIT](LICENSE)
