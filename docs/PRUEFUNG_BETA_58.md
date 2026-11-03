# Prüfung 4.18.0-beta.3 – Build 58

01.11.2026, Codex. Lokale Prüfung der vorhandenen Beta und Inhaltspakete; kein Neubau und keine Veröffentlichung.

## Prüfgegenstand

- Haupt-Checkout: `main`, Commit `2c34cc5` zu Beginn, Arbeitsverzeichnis sauber.
- APK: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`, identisch mit `build/release/velvetpulse-arm64-v8a.apk`.
- Android-Metadaten: Version `4.18.0-beta.3`, versionCode `2058` (ABI-Präfix 2000 plus Build 58), Mindest-API 24; WAKE_LOCK vorhanden.
- APK-SHA-256: `73ba7abf9aabbc3a176f2e1c3abf5439027ee7abd9e6399551e1ed94e26c5a67`.
- Lokale Pakete: `de-reihe-v4.zip`, `en-reihe-v4.zip`, `reihe-bilder-v5.zip`.

## Bestanden

- `flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings`: keine Befunde.
- `flutter test --no-pub`: 345 Tests bestanden, einschließlich der vorhandenen Sicherheits-, Backup-, Sprach- und Reihenprüfungen.
- `flutter test test_screens/diagramme_test.dart --no-pub --timeout 120s`: alle 100 Diagramme mit Flutter gerendert.
- `flutter test test_screens/screens_test.dart --no-pub --dart-define=STRICT=true --dart-define=SPICY=true --timeout 120s`: bestanden, keine gemeldeten Layoutüberläufe. Dieser Test deckt nicht jeden Zustand des Reihenplayers ab.
- APK-ZIP und Paket-ZIPs ohne CRC-Fehler; APK-Signaturprüfung mit `apksigner verify --verbose` bestanden (v2).
- Alle 100 Diagramm-SVGs der APK stimmen bytegenau mit den Projektquellen überein; Neuigkeiteneintrag für Build 58 ist enthalten.
- Beide Reihenpakete enthalten fünf Folgen und jeweils 128 referenzierte Audiosegmente; Szenenfolgen vollständig und Dauereinträge positiv.
- Beide Sehr-spicy-Fassungen haben die richtige Zuordnung zu Martin bzw. Victoria und sechs Szenen. Alle zwölf erwarteten Bildpfade existieren im Bildpaket; alle Bilder sind lesbare WebPs mit 768 × 1024 Pixeln.
- Alle 24 neuen DE/EN-Aufnahmen wurden mit ffprobe geprüft. Maximale Abweichung zur hinterlegten Dauer: 6,5 ms. Dies ist keine Hörprüfung.
- Größe und SHA-256 der drei unverschlüsselten Pakete stimmen mit dem lokalen `audio-index.json` überein. Die `.enc`-Dateien sind Transportartefakte; ihre Hashes sind absichtlich anders.
- R8 und Ressourcenverkleinerung sind weiterhin ausgeschaltet.

## Offene Qualitätsbefunde

Die zwölf ausgelieferten Bilder stimmen bytegenau mit der zuvor geprüften AG-Lieferung überein. Damit sind die vier Perspektivfehler aus `docs/PRUEFUNG_AG_SEHRSPICY.md` auch im lokalen Beta-Bildpaket vorhanden:

1. `sehrspicy_mann_other_body`: männliche Darstellung statt des im Text erlebten weiblichen Körpers.
2. `sehrspicy_mann_return`: weibliche Darstellung bei der Rückkehr zum männlichen Körper.
3. `sehrspicy_mann_afterglow`: weibliche Darstellung nach der Rückkehr zum männlichen Körper.
4. `sehrspicy_frau_return`: männliche Darstellung bei der Rückkehr zum weiblichen Körper.

Alle Szenentexte der neuen Fassungen in den DE/EN-Paketen stimmen mit den zuvor geprüften Entwurfs-JSONs überein. Die dort dokumentierten fachlichen und sprachlichen Vorbehalte sind deshalb ebenfalls noch offen. Keine erneute medizinische Recherche in diesem technischen Prüflauf.

## Grenzen und Übergabe

- ADB konnte im Sandbox-Kontext keinen Server starten. Die anschließend angefragte Berechtigung für Geräteerkennung wurde vom Nutzer abgelehnt. Kein Handytest, keine Installation, kein Test mit ausgeschaltetem Bildschirm und kein Zugriff auf lokale Nutzerdaten.
- Der Szenenwechsel verwendet im Quellcode `onPlayerComplete`, mit zeitbasierter Sicherung; die Android-Teil-Wachhaltesperre ist implementiert. Das ist kein Nachweis gegen einen Abbruch auf dem konkreten Gerät.
- Keine Hörprüfung, keine vollständige interaktive Navigation, kein Online-Downloadtest und kein Abgleich mit einer tatsächlich veröffentlichten Remote-Datei. Die lokale Indexsignatur wurde nicht separat kryptografisch validiert; die vorhandenen Sicherheitstests sind grün.
- Protokolle: `build/beta-pruefung-tests.log`, `build/beta-pruefung-analyse.log`, `build/beta-pruefung-diagramme.log`, `build/beta-pruefung-screens-spicy.log`; strukturierte Paketbefunde unter `build/beta-pruefung/`. Reproduktionsskript `build/beta_pruefen.py` liegt lokal im ignorierten Build-Verzeichnis.
- Empfehlung: technisch im geprüften Umfang unauffällig; vor einer inhaltlichen Endfreigabe vier Bilder korrigieren und den vorherigen Textbericht bearbeiten. Reales Hintergrundverhalten und Hörqualität sind noch zu prüfen.

Keine App-, Inhalts-, Audio- oder Paketdateien geändert. Keine Veröffentlichung veranlasst.
