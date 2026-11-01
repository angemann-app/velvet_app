# Diagramme in der Magazinwelt

Stand 01.11.2026. Nutzerauftrag: alle Diagrammgrafiken neu zeichnen, an die neue Optik anpassen und notwendige Textkorrekturen vornehmen. Deutsch und Englisch gemeinsam pflegen.

## Umsetzung

- Umfang: 50 Diagramme, jeweils DE/EN. Bestehende Dateinamen, Zuordnungen und das Format 800 × 600 bleiben erhalten.
- Eigenständige, neu gezeichnete SVGs: warmes Papier, Graphit, gedecktes Rosé, feine Orientierungslinien, ruhige Typografie. Keine alten Formen lediglich umfärben.
- Diagrammtypen passend zum Inhalt: anatomische Übersicht, Nervenzweige, Kreislauf, Zeitverlauf, Vergleich, Entscheidung, Körperwahrnehmung und Materialstudie. Keine universelle Textkachel für sämtliche Themen.
- Beschriftungen auf die Kernaussage begrenzen; größere Schrift, klare Führungslinien und kurze Legenden. Ausführliche Erklärungen bleiben im Lektionstext.
- Anatomische Darstellungen ausdrücklich schematisch, nicht maßstabsgetreu. Organlage von Bewegungs- und Erfahrungsmodellen unterscheiden.
- Erfahrungsverläufe nicht als Messkurven oder feste biologische Gesetze zeichnen: keine vorgegebenen Orgasmusschwellen, keine erfundenen Dopaminmessungen, keine garantierte Schmerzlinderung.
- Keine feste Reihenfolge erwünschter Nähe oder automatischer Zustimmung aus Körpersignalen ableiten. Jederzeitige Rückmeldung sichtbar machen.
- DE und EN entstehen aus derselben zweisprachigen Datenquelle. Ein Generator baut beide; alte Generatoraufrufe müssen die neue Quelle verwenden, damit sie den Bestand nicht zurücksetzen.

## Zusammenarbeit und Prüfung

Codex arbeitet auf `codex/lektorat-beruehrung`. Claude Code findet Stand, Dateien und Übergaben in `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md` sowie den Hinweis in `AG.md`.

Prüfen: vollständiger Dateibestand, gültiges SVG, reproduzierbare Ausgabe, Übersetzungsabdeckung, Textgrenzen und Kontraste; alle Grafiken in einer Browserübersicht und repräsentative Diagramme zusätzlich durch Flutter rendern. Die Browserdarstellung allein belegt keine Flutter-Kompatibilität.

Fachliche Grundlagen: Quellen des Spicy-Lektorats; Cleveland Clinic zur Klitoris und zum Pudendusnerv, NHS zu Schmerzen, CDC zu Infektionsrisiken. Die Überarbeitung ersetzt keine unabhängige medizinische Gesamtbegutachtung.

## Pflege und Integration

- Quelle der Beschriftungen: `tools/diagramme_magazin_daten.py`; zentrale Zeichenregeln und Farben: `tools/diagramme_magazin.py`.
- Erzeugen: `python tools/diagramme_magazin.py`. Nur prüfen: derselbe Aufruf mit `--pruefen`.
- Alte Aufrufe `generate_diagrams.py` und `diagramme_en.py` verwenden jetzt ebenfalls die neue Quelle. `diagramme_en.json` ist ein historisches Übersetzungsartefakt und wird nicht mehr eingelesen.
- Die hellen Bildtafeln bleiben in Papier, Nachtpapier und Spicy bewusst als gedruckte Studien erhalten. Navigation, Theme-Werte, Kurse, Audios und Bild-IDs bleiben erhalten.
- Lokale Browserübersichten: `python tools/diagramme_magazin_pruefen.py --browser`; benötigt optional Playwright, Pillow und den bereits installierten Edge. Keine neue App-Abhängigkeit.
- Die Prüfung verwendet die echte Source Serif 4, prüft alle 100 Textlayouts auf Randüberschreitungen und Textüberschneidungen und erstellt sieben Kontaktbögen unter `build/redaktion/diagramm-review/neu/`.
- Textfarben erreichen mindestens WCAG-AA 4,5:1 auf dem Papiergrund (Graphit 12,64:1, Sekundärtext 6,36:1, Rosé 4,73:1). Feine Hintergrundraster sind dekorativ.
- Flutter-Prüfung: `flutter test test_screens/diagramme_test.dart`; rendert alle 100 SVGs in Handybreite unter `build/redaktion/diagramm-review/flutter/`. Die Tests laden die Systemschrift explizit; auf Android übernimmt dies das System.
- Beschriftungen sind Bildinhalt und skalieren als Vektorgrafik, nicht mit der Systemschriftskala. Die bestehende vergrößerte Bildansicht bleibt daher für kleine Displays wichtig.

## Fachliche Referenzen

- [Klitoris: sichtbare und innere Anteile, individuelle Anatomie](https://my.clevelandclinic.org/health/body/22823-clitoris).
- [Pudendusnerv: Verlauf und Äste](https://my.clevelandclinic.org/health/body/22000-pudendal-nerve).
- [Beckenschmerzen: unterschiedliche Ursachen und Abklärung](https://111.wales.nhs.uk/Pelvicpain/).
- [Sicherer Umgang mit Toys und Hygiene](https://www.healthdirect.gov.au/healthy-living/physical-wellbeing/safe-sex).

Erfahrungs- und Bewegungsmodelle sind als solche beschriftet. Sie stellen keine Messdaten oder individuellen Behandlungsempfehlungen dar.
