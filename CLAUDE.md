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
- Traum-Reise: `docs/konzepte/traum-reise.md` (Entwurf; Reihenfolge: Paketverwaltung und Traumtagebuch,
  dann sanfte Traum-Absicht, dann Fantasie-Räume, dann nächtliches Wecken)

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
- Fehlt eine Aufnahme, liest die Geräte-Stimme. Englisch kommt als nachladbares Audiopaket
  (`AudioPaket` in `lib/services/sprachausgabe.dart`, Releases `audio-en-vN`; ältere Pakete nie löschen).
- Aussprache-Korrekturen in `tools/aussprache.json`.

## Git

- Größere Änderungen auf einem eigenen Branch, nicht direkt auf `main`.
- Releases baut der Nutzer selbst mit `tools/release.ps1`; Build-Nummer steigt immer.
