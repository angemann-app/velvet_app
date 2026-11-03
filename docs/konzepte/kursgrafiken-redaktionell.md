# Redaktionelle Kursgrafiken – drei Muster

02.11.2026. Nutzer findet die stilisierten dekorativen SVG-Grafiken unzureichend; ausdrücklich nicht die Bleistiftzeichnungen oder Erklärdiagramme. Vorschlag mit Kursnummer/Typografie, vorhandenen Zeichnungen und wenigen sinnvollen Linienmotiven angenommen. Präzisierung: „Spicy dann aber auch spicy“.

## Entscheidungen für die Muster

- Drei Themen: Kopf/Körper, Berührung, Fantasie. Papier, Nachtpapier und Spicy vergleichen; DE und EN.
- Dekorative Figuren und künstlich verwackelte Konturen entfallen. Für abstrakte Zusammenhänge wenige bewusst komponierte Linien, für Körperthemen echte bestehende Zeichnungen.
- Spicy unterscheidet sich durch Motiv und Ausschnitt: direkte Berührung an Haut statt neutraler Nähe; Augenbinde, weiches Tuch und Halskuss statt bloßem Blickkontakt. Vorhandene erwachsene, einvernehmliche Motive nutzen. Keine neue Cloud-Bildproduktion und keine automatische Änderung an Inhaltssperren.
- Im Grundlagenmotiv werden Annäherung und rhythmische Bewegung intensiviert, ohne dadurch eine neue sexuelle Übung oder nicht vorhandene Spicy-Lektion zu behaupten.
- Kursnummern, Titel und Teaser bleiben lebender, übersetzbarer Text außerhalb der Bilddatei. Die Illustration allein enthält keine Wörter. Vorschau zeigt beides zusammen. Keine neuen Titeltexte in der App hardcodieren.
- Musterbildformat `kopf` 3:2 aus dem vorhandenen Bildsystem. Bisherige Kursassets und Navigation zunächst unverändert. Erst nach visueller Abstimmung die konkrete Einbindung und restliche Reihe überarbeiten.
- Vorschauen und eingebettete Bildkopien ausschließlich unter dem ignorierten `build/designstudien/kursgrafiken/`; private Originale nicht ändern und nicht als Rohdateien ins Repository aufnehmen. Werkzeug `tools/kursgrafiken_muster.py`, Herkunfts-/Prüfprotokoll neben den Vorschauen.

## Prüfung

Native SVGs und lokale HTML-Vorschau ohne Netz rendern. Titel/Textgrenzen DE/EN, Figuren/Ausschnitt, drei Paletten und visuelle Unterscheidbarkeit prüfen. App-Texte, Pencil-Originale, Erklärdiagramme und bestehende Funktionen bleiben von der Musterproduktion unberührt.

## Freigegebene Umsetzung – WebP, 02.11.2026

Nutzer nach Formatvergleich: „Passe alles an“. Die drei Muster werden auf die gesamte dekorative Reihe übertragen: 27 Kurstitel, drei geführte Audio-Einstiege und elf Ja/Nein/Vielleicht-Themen. Erklärdiagramme, Logo und Icons bleiben Vektor, vorhandene Pencil-Originale unverändert.

- Wortfreie WebP-Bildflächen im zentralen Format `kopf` (3:2), warmes Papier, echte vorhandene Zeichnungen bei körperlichen Themen; bewusst reduzierte abstrakte Motive bei Gedanken, Atmung und Aufmerksamkeit. Keine Umwandlung der alten schematischen Figuren als bloßer Formatwechsel.
- Spicy-Illustrationen aus dem bereits vorhandenen Paket `kurse-bilder-spicy`, anhand einer expliziten zentralen Motivzuordnung. Keine privaten Originale ins Repository oder in die APK kopieren; keine Cloud-Generierung. Rein abstrakte Spicy-Motive ohne private Vorlagen können als kleine WebPs mitgeliefert werden.
- Das Register bekommt alte Pfade als Aliasse und eine getrennte Paketangabe für Spicy. Bestehende Kursdaten, Übersetzungen, Navigation und Text-/Audioarbeit brauchen damit keine Pfadmigration. Die Bildauflösung fällt bei einem fehlenden Paket auf das reguläre Asset zurück; Paketinstallation/-löschung aktualisiert sichtbare Bildfelder.
- Dekorative SVG-Altdateien aus `assets/images` entfernen; alte Generatoren dürfen sie nicht versehentlich zurückschreiben. Bestandsbezeichner bleiben kompatibel. Zentrale Zuordnung und reproduzierbare Erzeugung statt einzelner Bildschirmsonderfälle.
- Prüfen: vollständige Zuordnung, WebP-Dateien, Spicy-Abgrenzung mit und ohne Paket, Reaktion auf Paketwechsel, Übersetzungs-/Sicherheitsregression, Analyse und gerenderte Ansichten DE/EN in Papier/Nachtpapier/Spicy. Kein Paketupload, kein App-Release beauftragt.

## Umsetzung und Abnahmeunterlagen

41 Motive umgesetzt: 45 lokale WebPs, 37 Paketverweise auf 25 unterschiedliche Spicy-Zeichnungen. 82 dekorative SVG-Altdateien abgelöst. Ursprüngliche Lektionsdaten bleiben dank Register-Aliassen kompatibel. Heute verwendet das passende Bild der nächsten Lektion. Zentrale Erzeugung, geprüfte Paket-Fallbacks, reaktive Bildfelder und DE/EN-Anleitung fertig.

363 Flutter-Tests, Analyse und sechs Renderkombinationen erfolgreich. Der Screenshot-Harness wartet jetzt auf Seitenaufbau und tatsächliche Rasterbilddekodierung; private Prüfbilder ausschließlich im ignorierten Build-Ordner. Ausführliche Übergabe, Befehle, Grenzen und Vorschaupfade im gemeinsamen Claude-Protokoll. Keine Veröffentlichung und kein neuer Paketstand.
