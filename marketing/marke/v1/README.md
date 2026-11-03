# VelvetPulse - Markenpaket v1

02.11.2026. Gleiche Markenwelt wie die freigegebene Gestaltungsrichtung, mit prägnanterem offenem Bogen und V-/Pulslinie. Die Wortmarke ist aus Source Serif 4 in echte Vektorpfade umgewandelt. Hauptclaim: **Dein Körper. Dein Erleben.**

## Schnell verwenden

- `logos/velvetpulse-horizontal-papier.svg`: Standard auf hellem Grund. Für kleine Webanwendungen PNG verwenden; für freie Skalierung SVG.
- `logos/velvetpulse-horizontal-hell.svg`: auf dunklem oder Spicy-Grund. Einfarbige Fassungen stehen daneben.
- `logos/velvetpulse-signet-*.svg`: Zeichen ohne Wortmarke. Kompaktfassung für 16 bis 23 Pixel, Standard ab 24 Pixeln.
- `icons/`: App-Symbol-Entwürfe, transparente runde Avatare, Favicon. Das bestehende diskrete App-Symbol bleibt unverändert.
- `vorlagen/`: vier Social-Formate jeweils auf Deutsch und Englisch, Briefpapier A4 und Präsentationscover. SVG editieren, PNG direkt verwenden. Die vier Hauptformate sind Feed 1080x1350, Story 1080x1920, Zitat 1080x1080 und Banner 1200x630.
- `guide/VelvetPulse-Markenleitfaden-v1.pdf`: Regeln, Hintergründe und Anwendung auf 14 Seiten.
- `vorschau/markenuebersicht.png`: schneller Überblick; der Kontaktbogen zeigt alle Leitfadenseiten.

## Farben und Schrift

Die aktuellen App-Paletten sind die Quelle: Papier, Nachtpapier und Spicy. Alle Werte und Texte liegen in `quellen/marke.json`. Die Textfarben sind für mindestens 4,5:1 auf ihrer Grundfläche geprüft; dekoratives Rosé ist keine pauschale Textfarbe. Prüfwerte stehen in `quellen/kontrastpruefung.json`.

Source Serif 4 mit Regular, SemiBold und Italic ist unter SIL OFL beigefügt, einschließlich Original-Lizenz. Funktionale Texte verwenden die jeweilige Systemschrift. Proprietäre Systemschriftdateien werden nicht mitgeliefert. Die Logos benötigen dank Pfaden keine installierte Schrift.

## Bildwelt und Quellen

`bildwelt/naehe-graphit.png` ist ein eigenständiges, nicht explizites Illustrationsmotiv mit transparentem Hintergrund, erzeugt mit integriertem Imagegen. Vollständiger Prompt: `quellen/bildwelt-prompt.txt`. Keine privaten Szenenbilder oder Nutzerdaten als Eingabe. Grafik und Text wurden visuell geprüft. Die Vorlage zeigt ein Paar; sie ist keine Vorgabe, die Bildwelt auf eine Körper- oder Beziehungskonstellation zu beschränken.

Logo, Layouts und grafische Elemente sind native Vektorgrafiken. Erzeugungswerkzeuge im Repository: `tools/marke_schriftpfade.ps1`, `tools/markenpaket.py`, `tools/markenleitfaden.py`. Die Werkzeuge verwenden die Projektpfade; die fertigen SVG-/PNG-Dateien und das PDF sind unabhängig davon nutzbar.

## Stand und Grenzen

Markenauftritt v1 zur praktischen Verwendung und gestalterischen Prüfung. Kein bestehendes App-Asset ersetzt, keine Plattform veröffentlicht. Neue App-Icons erst im vorgesehenen Integrationsschritt übernehmen. RGB-Ausgaben für digitale Verwendung; für verbindlichen Druck ein passendes Druckprofil festlegen. Keine erfundenen Kontakte, Domains oder Store-Badges in den Vorlagen.

English usage notes: `README.en.md`.
