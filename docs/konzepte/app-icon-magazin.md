# App-Icon im Markenauftritt Magazin

02.11.2026. Nutzerauftrag: „Jetzt noch das App Icon.. Danach kannst du dich wieder auf die Audios konzentrieren“. Die freigegebene Bogen-/V-Pulslinienmarke wird als tatsächliches Android-App-Symbol eingebaut.

## Entscheidungen

- Graphitfarbener offener Bogen und V-/Pulslinie, kleiner gedeckter Rosé-Bogen auf warmem Papier. Wortfreies Zeichen, dieselbe Geometrie wie im Markenleitfaden.
- Eine gemeinsame Launcher-Identität, kein nach außen sichtbarer Wechsel beim Aktivieren von Spicy. Keine neue Alias-/Speicherlogik. Das neutrale Symbol „Pulse“ bleibt unverändert.
- Adaptive Ebenen für Android ab 8 mit eigener Hintergrundfarbe; zusätzliche monochrome Ebene für Themensymbole ab Android 13. Vordergrund als native VectorDrawable, Rastervarianten für Android 7 in allen fünf bestehenden Dichten.
- Zeichen innerhalb des zentralen 66-dp-Sicherheitskreises auf 108-dp-Ebene, gerenderte Prüfung als Kreis und abgerundetes Quadrat sowie in kleinen Größen. Keine eingebauten Schatten oder Rundungsmaske im adaptiven Vordergrund.
- Native SVG-Quelle unter `tools/app_symbol/velvetpulse.svg`, reproduzierbare Erzeugung und Prüfbilder. Alte Lotus-Quelle bleibt als historische Vorlage erhalten, aber nicht aktiv eingebunden.
- Android-Ressourcenprüfung lokal kompilieren, kein Release bauen oder veröffentlichen. Danach bestehende Audioproduktion prüfen, niemals eine zweite Kokoro-Instanz starten.

## Referenz

Android-Vorgaben: https://developer.android.com/develop/ui/compose/system/icon_design_adaptive

Im gemeinsamen Claude-Protokoll Quellen, erzeugte Dateien, Prüfung und Audio-Fortsetzung dokumentieren.

## Umgesetzt

Native Farb-/Monochrom-Vektoren, adaptive API-26-/API-33-Ressourcen, fünf Legacy-Dichten und Papierhintergrund eingebaut. Alle Striche innerhalb des Sicherheitskreises; Masken und Kleinformen gerendert und visuell geprüft. Diskretes Symbol per Prüfsumme unverändert.

Zehn Icon-Ressourcen mit aapt2 kompiliert und gegen SDK 36 verlinkt. Vollständiger Offline-Gradle-Lauf an fehlenden gecachten Debug-Abhängigkeiten gescheitert; keine Release-Aussage. Quellen, Reproduktion und Protokoll in `tools/app_symbol/README.md`. Danach technische Prüfung der fertig erzeugten 1.744 Kurs-/geführten Audiodateien aufgenommen; keine neue Kokoro-Instanz.
