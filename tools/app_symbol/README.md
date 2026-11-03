# VelvetPulse – Android-App-Icon

Aktives Zeichen: `velvetpulse.svg`, identische Bogen-/V-Geometrie wie das freigegebene Markensignet.
`lotus.svg` bleibt ausschließlich als historische Quelle erhalten.

Erzeugen: `python tools/app_symbol/erzeugen.py` (Pillow vorhanden).
Prüfen ohne Überschreiben: `python tools/app_symbol/erzeugen.py --pruefen`.

## Android-Dateien

- Fünf `mipmap-*/ic_launcher.png` mit 48, 72, 96, 144 und 192 Pixeln: Android-7-Varianten.
- `drawable-anydpi/ic_launcher_foreground.xml`: transparenter nativer Vektor, keine eingebauten Masken oder Schatten.
- `drawable-anydpi/ic_launcher_monochrome.xml`: einfarbiger Vordergrund für Android-Themensymbole.
- `mipmap-anydpi-v26/ic_launcher.xml`: adaptive Ebenen; `mipmap-anydpi-v33/ic_launcher.xml`: zusätzlich monochrome Ebene.
- `values/ic_launcher_background.xml`: warmes Papier `#F6F0E6`.

Die fünf alten Lotus-Vordergrund-PNGs werden entfernt. Keine Änderung am Manifest, den beiden Launcher-Aliassen oder am neutralen „Pulse“-Symbol. Das normale Zeichen gilt für alle App-Modi; die Spicy-Einstellung wird nicht nach außen am Icon sichtbar.

## Prüfung und Vorschau

Unter `build/designstudien/app-icon/`: `uebersicht.png`, Export `velvetpulse-1024.png`, `pruefung.json`.
Die Prüfung kontrolliert alle fünf Dichten, beide adaptiven XMLs, Vektorpfade und den zentralen 66-dp-Sicherheitskreis innerhalb einer 108-dp-Ebene. Runde und abgerundete Masken sowie kleine Größen visuell geprüft. Der Rasterexport zeichnet geschlossene Strichflächen, damit keine feinen Zwickel an dichten Kurvensegmenten entstehen.

Die zehn aktiven Icon-Ressourcen wurden mit Android SDK 36 / aapt2 kompiliert und gegen `android.jar` verlinkt. Artefakte der isolierten Prüfung ebenfalls im ignorierten Vorschauordner. Kein installierbares Release erzeugt.

Ein vollständiges `:app:processDebugResources --offline` scheiterte an fehlenden gecachten Flutter-/Debug-Abhängigkeiten, nicht an den Icons. Protokoll `android-ressourcen.log`; deshalb keine Behauptung eines erfolgreichen vollständigen Gradle-Builds. Die isolierte Icon-Kompilierung und Verlinkung sind erfolgreich.

Referenz: https://developer.android.com/develop/ui/compose/system/icon_design_adaptive
