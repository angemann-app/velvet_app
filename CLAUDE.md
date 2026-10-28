# VelvetPulse – Hinweise für Claude

Flutter-App (Android, ab 7) für Sexualaufklärung und Paar-Sexualität mit therapeutischem Hintergrund:
Kurse und Lektionen, geführte Audios, Beckenboden-Training, Reflexions-Journal, verschlüsselter Paar-Kanal
(Nostr), KI-Coach, Spicy-Modus (18+). Alles bleibt lokal auf dem Gerät. Inhalte für Erwachsene.

## Sprache

- Mit dem Nutzer **Deutsch** sprechen. Code-Bezeichner, Kommentare, Commit-Nachrichten und Doku sind
  überwiegend deutsch; so weiterschreiben.
- Deutsch ist die Originalsprache der Inhalte, Englisch wird immer mitgepflegt.

## Konzepte zuerst

Neue Funktionen werden vor der Umsetzung in `docs/konzepte/` beschrieben und abgestimmt. Vor der Arbeit an
einer Funktion das passende Konzept lesen, besonders den Abschnitt „Entscheidungen“ bzw. „Offene Fragen“.
Ist eine Frage für den aktuellen Schritt noch offen, nachfragen statt raten.

- Einschlaf-Reise: `docs/konzepte/einschlaf-reise.md`, Texte nach `docs/konzepte/einschlaf-reise-textvorgabe.md`
- Lust im Traum: `docs/konzepte/lust-im-traum.md` (abgestimmt, Entscheidungen am Ende)
- Startseite: `docs/konzepte/startseite.md`; Lautsprecher-Nachfrage: `docs/konzepte/lautsprecher.md`; Hallo: `docs/konzepte/hallo.md`
- Traum-Reise: `docs/konzepte/traum-reise.md` (abgestimmt, Entscheidungen am Ende; Reihenfolge: Paketverwaltung und Traumtagebuch,
  dann sanfte Traum-Absicht, dann Fantasie-Räume, dann nächtliches Wecken)

**Aufgabenliste:** `docs/AUFGABEN.md` (Reihenfolge = Priorität). Erledigtes dort nach unten verschieben.

**Antigravity:** Arbeitet parallel auf dem Rechner des Nutzers nach `AG.md` (dort „Wer macht was“).
Claude schreibt die Aufträge (klar abgegrenzt, mit erlaubten Dateien), prüft die Pull Requests von
Antigravity (Kommentar im PR, Kleinigkeiten auf Wunsch im Branch nachbessern), führt **alle** Pull Requests
selbst zusammen (bei Aufnahmen und Texten erst nach dem OK des Nutzers) und trägt unter „Erledigt“ ein. Antigravity ändert `AG.md` in seinen Branches nicht.
Dateien, an denen Claude Code gerade arbeitet, mit Datum unter „Gesperrt“ eintragen und nach Abschluss
wieder freigeben. Rückmeldungen holt Claude mit `tools/rueckmeldungen_abholen.dart` (eigener Lesestand),
Antigravity mit `--leser ag`.

**OpenCode (Routine abgeben, spart Tokens):** Über das MCP-Werkzeug `opencode_auftrag` (`.mcp.json`,
`tools/opencode_mcp.py`) erledigt OpenCode 2 (`C:\TOOLS\opencode\opencode.exe`) Aufgaben mit dem kostenlosen
Modell `opencode/deepseek-v4.1-flash-free`. Soll AG langfristig als Arbeitstier ablösen.
- **Abgeben:** klar abgegrenzte, mechanische Arbeit mit eindeutigem Prüfbefehl, z. B. Tests an geänderte Stellen
  anpassen, Umbenennungen über viele Dateien, englische Fassungen von App-Texten (ARB, `translations/en/`)
  entwerfen, Doku nachziehen, Fehlerausgaben auswerten. Der Auftrag nennt Ziel, erlaubte Dateien und den
  Prüfbefehl; vorher eigenen Branch anlegen.
- **Nicht abgeben** (das Modell läuft in der Cloud): Fantasie-Räume, „Lust im Traum“ und alles aus
  `C:\TOOLS\velvet-inhalte`, Rückmeldungen und Postfach, Schlüssel und Geheimnisse, Sicherheitscode
  (`SecretStore`, `BackupCodec`, `NostrEventCheck`, Krypto), neue Inhaltstexte und Entscheidungen aus
  „Offene Fragen“.
- **Danach immer selbst prüfen:** `git diff` lesen, Tests laufen lassen, erst dann committen. OpenCode
  committet, pusht und veröffentlicht nie.
- **Rechte** stehen in `~/.config/opencode/opencode.jsonc` (Vorlage `tools/opencode/opencode.jsonc`): kein
  Zugriff außerhalb des Projekts, Shell nur `flutter test/analyze/gen-l10n/pub get`, `dart format` und Git lesen.
  Beim Lockern daran denken: Über die Shell lässt sich jede Datei lesen.
- **Aussprache-Pflege** (früher AG-1) läuft so: Ablauf in `docs/AUSSPRACHE.md`. Dafür darf OpenCode
  `tools/generate_audio.py` mit dem venv-Python starten (Kokoro läuft lokal), sonst kein Python.

**Grundsatz Inhalte:** Langfristig werden alle Inhalte (Texte und Audios) getrennt von der App als
signierte Pakete angeboten. Neue Inhalte deshalb so anlegen, dass sie in ein Paket wandern können; nur
Onboarding, SOS, Sicherheits- und Gesundheitshinweise, Datenschutz und Anleitung bleiben fest in der App.

Weitere Hintergründe: `docs/AENDERUNGEN_SEIT_UEBERNAHME.md` (Entscheidungen und Stolperfallen),
`docs/SICHERHEIT_AUDIT_BASELINE.md`, Bedienung in `docs/ANLEITUNG.md` / `docs/GUIDE.md`.

## Feste Regeln (nicht brechen)

- **R8 bleibt aus** (`isMinifyEnabled = false`, `isShrinkResources = false` in
  `android/app/build.gradle.kts`), sonst kann die App nichts mehr speichern.
- **Geheimnisse** (API-Key, Nostr-Schlüssel) nur über `SecretStore`, nie in SharedPreferences oder ein
  unverschlüsseltes Backup. Sicherungen nur über `BackupCodec`. Eingehende Nostr-Events immer durch
  `NostrEventCheck`. `test/security_test.dart` muss grün bleiben.
- **Neue gespeicherte Daten** gehören in Sicherung und Backup-Merge (`StorageService`,
  `test/backup_merge_test.dart`).
- **Diskretion:** Benachrichtigungen, Karten-Titel im Diskretions-Modus und Sperrbildschirm-Texte bleiben
  neutral (kein „Sex“, „erotisch“, „Traum“ o. ä.).
- **Oberflächentexte** nur über `lib/l10n/app_de.arb` und `app_en.arb` (Zugriff `t.<schlüssel>`), keine
  festen Strings im Code.
- **Inhaltsänderungen** in `assets/data/*.json` immer in `translations/en/` nachziehen, sonst schlägt
  `test/translation_test.dart` fehl. PO-Dateien danach abgleichen:
  `flutter test test/uebersetzung_test.dart --dart-define=PO=sync`.
- Spicy-Inhalte nur hinter dem Spicy-Modus. Alle Figuren in Texten sind erwachsen, alles ist einvernehmlich.
- Bei neuen Funktionen auch an Anleitung (`assets/data/anleitung.json`, `docs/ANLEITUNG.md`) und
  „Was ist neu“ (`assets/data/neuigkeiten.json`) denken.

## Prüfen

```bash
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter test test_screens/screens_test.dart   # rendert alle Screens nach build/screens/, meldet Überläufe
```

`test_live/` läuft nicht automatisch (echte Server).

## Audio

- Aufnahmen entstehen lokal mit Kokoro (Stimmen Victoria und Martin) über `tools/generate_audio.py`
  (Windows-venv unter `C:\TOOLS\kikiri-venv`, siehe README). In dieser Umgebung meist nicht ausführbar:
  Texte vorbereiten, Einsprechen macht der Nutzer.
- **Aufnahmen sind ausgelagert** (seit 4.10.0): Pakete `de-lektionen`, `de-gefuehrt`, `en-lektionen`,
  `en-gefuehrt` (`lib/services/pakete.dart`), aufgelistet im signierten Verzeichnis `audio-index.json`
  (`lib/services/paket_verzeichnis.dart`, Ed25519, Laufnummer gegen Zurückrollen). In der APK bleiben nur
  Beckenboden-Ansagen, Klangschale, Klangteppich und `dauer.json`. Nach neuen Aufnahmen: Version in
  `tools/pakete/versionen.json` hochzählen, dann `tools/pakete_hochladen.ps1`. Fehlt eine Aufnahme, liest
  die Geräte-Stimme. Das alte englische Paket (`AudioPaket`, Releases `audio-en-vN`) wird weiter gelesen;
  ältere Pakete und Releases nie löschen.
- Aussprache-Korrekturen in `tools/aussprache.json`.
- **Betonung beim Einsprechen:** Die Reihe „Innenansichten“ klingt dank `tools/reihe_ausdruck.py` (Tempo und Lücke
  je Satz, ruhige Szenen langsamer, keine künstliche Stille) besser als die älteren Aufnahmen. Wird ein Text neu
  eingesprochen, gilt dieser Weg (`synthesize_ausdruck`); für andere Texte zuerst ein passendes Profil ableiten und
  per Hörprobe abnehmen lassen.

## Git

- Größere Änderungen auf einem eigenen Branch, nicht direkt auf `main`.
- Releases baut und veröffentlicht Claude Code mit `tools/release.ps1`, aber nur nach ausdrücklicher
  Freigabe des Nutzers für genau dieses Release (Version und Build-Nummer). Die Build-Nummer steigt immer,
  über Beta und Stabil hinweg; vorher braucht es einen „Was ist neu“-Eintrag für diese Build-Nummer.
