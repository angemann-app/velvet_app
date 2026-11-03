# VelvetPulse – Werbebroschüre

Stand: 02.11.2026. Beauftragt vom Nutzer nach Freigabe des Markenauftritts.

## Lieferung

- `output/pdf/VelvetPulse-Broschuere-DE.pdf`: 24 Seiten, A4-Hochformat, Deutsch.
- `output/pdf/VelvetPulse-Broschuere-EN.pdf`: 24 Seiten, gleichwertige englische Fassung.
- `texte.json`: gemeinsame redaktionelle Quelle, DE und EN; `lesefassung-de.md` und `lesefassung-en.md` zum Gegenlesen.
- `vorschau/de/` und `vorschau/en/`: vollständig gerenderte Seiten; `vorschau/uebersicht-de.jpg` und `uebersicht-en.jpg`: Kontaktbögen.
- `pruefung.json`: Seitenzahlen, Textabdeckung, Überlagerungsprüfung, Schrift-Einbettung, Linkziel, Bildauflösungen und PDF-Prüfsummen.
- Erzeugung: `tools/werbebroschuere.py` mit dem gebündelten Python (ReportLab, pypdfium2, pypdf und Pillow). Logo-Funktionen aus `tools/markenleitfaden.py` und Geometrie aus `tools/markenpaket.py`.

## Inhalt

1. Titel; 2. Haltung und Überblick; 3. Heute; 4. Lernen; 5. Kursschwerpunkte;
6. Körperwissen und Selbstwahrnehmung; 7. Berührung und Massage; 8. Körperpraxis;
9. Gedanken und SOS; 10. Paarraum; 11. Wünsche und Grenzen; 12. Spicy;
13. Hörbegleitungen; 14. Weiterhören und Offline-Verfügbarkeit; 15. Gemeinsames Hören;
16. Lokale Suche; 17. Persönlicher Weg; 18. Innenansichten; 19. Traumpraxis;
20. Tagespraxis; 21. KI-Coach; 22. Datenschutz und Diskretion;
23. Einstieg und Darstellung; 24. Rückseite mit QR-Code und Link zur App.

## Tatsachengrundlage

`assets/data/velvet_content.json` enthält bei Erstellung 27 Kurse und 128 Lektionen einschließlich Spicy. Die Zahlen werden beim Erzeugen geprüft. Funktionen anhand `docs/ANLEITUNG.md`, `docs/konzepte/traumpraxis.md` und aktueller App-Ansichten beschrieben. Gesamtzahl und ohne Spicy zugängliche 25 Kurse sind ausdrücklich unterschieden.

Keine Aussage über eine bereits veröffentlichte Versionsnummer. Hinweis auf Entwicklungsstand und nötige Beta-Version auf Seite 23. Drei zusätzliche Traumpraxis-Hörbegleitungen sind noch nicht als neue Einträge integriert und werden nicht als bereits verfügbare Funktion beworben. Kein Wearable, kein Schlaftracking und keine Wirksamkeitsgarantie versprochen. Lokale Daten von externen Paar-/Foto-/Coach-Diensten klar unterschieden.

## Bildherkunft

Die drei vom Nutzer angehängten JPEGs werden auf Titel-, Massage- und Spicy-Seite verwendet. Beim Titel wird ausschließlich der graue Umgebungsrand im Layout beschnitten; Original unverändert. Ergänzend vorhandene Bleistiftzeichnungen: `tools/zeichnungen/self_1.webp` sowie lokale Kursbilder `couples_2_spicy.webp`, `alltag_8_spicy.webp`, `self_2_spicy.webp` und `tease_1_spicy.webp` aus `C:/TOOLS/velvet-inhalte/kurse/bilder/final/`.

Keine neue Bildgenerierung, kein Cloud-Upload. Private Originale nicht verändert und nicht als Einzeldateien kopiert. Die vom Nutzer gewünschte Einbettung erfolgt ausschließlich in den Broschüren-PDFs und deren gerenderten Vorschauen. Die internen Herkunftspfade stehen in `pruefung.json`; zum erneuten Erzeugen werden die lokalen Originale benötigt.

Echte gerenderte App-Ansichten mit fiktiven Beispieldaten, je Sprache aus `build/screens[_en]/`, Traumpraxis aus `build/screens_spicy[_en]/`. Englische Papier-Ansichten am 02.11.2026 neu gerendert: Flutter-Prüfung mit `STRICT=true` bestanden; vorhandene Plugin-/Rahmen-Warnungen des allgemeinen Renderharness bleiben im Testprotokoll und sind keine durch die Broschüre behobenen App-Fehler.

## Qualität und Verwendung

48 Seiten gerendert. Sämtliche redaktionellen Textfelder auf Vorhandensein in der PDF geprüft, keine Text-/Text- oder Text-/Bild-Überlagerungen, keine Textfelder außerhalb der Seitenränder. Redaktionelle und funktionale Schriften eingebettet; Logo als echte Vektorpfade. Die Nonzero-Füllregel korrigiert helle Schlitze bei überlappenden Wortmarkenkonturen, auch im aktualisierten Markenleitfaden.

Der QR-Code enthält denselben GitHub-Release-Link wie die klickbaren PDF-Verweise. Es gibt keine erfundene Domain und keine Store-Auszeichnung. Keine Veröffentlichung ausgelöst.

RGB-PDF für digitale Weitergabe und Büroausdruck. A4-Seiten, keine Druckbogenmontage, kein Beschnitt und keine PDF/X-Zertifizierung. Die Originalbilder begrenzen die effektive Auflösung; keine künstliche Hochskalierung als vermeintlicher Qualitätsgewinn. Für professionellen Offsetdruck sind hochauflösende Originale, Beschnitt, Druckprofil und Druckerei-Abstimmung erforderlich.


## Überarbeitung mit den neuen Informationen – 02.11.2026

Von 20 auf 24 Seiten je Sprache erweitert. Neue Seiten 14–17 erläutern den globalen Player mit Wiederfinden ohne Autostart, Offline-/Downloadstatus, gemeinsames Hören derselben Aufnahme mit beidseitiger Bereitschaft und Pause sowie freiwilligem Rückblick, lokale Suche und persönlichen Weg. Bestehende Szenenbilder/Pencil-Illustrationen und Markenwelt beibehalten; drei neue Seiten mit DE/EN-Renderansichten, persönlicher Weg als redaktionelle Bildseite.

Faktenbasis: `docs/konzepte/bedienung-audio-wege.md`, `docs/konzepte/gemeinsam-erleben.md`, `docs/UEBERGABE_BETA_BEDIENUNG.md`, aktuelle Implementierung/Renderansichten und `docs/pruefungen/AG26_FINALE_UEBERGABE.md`. Kein falsches Versprechen automatischer Synchronisierung unterschiedlicher Innenansichten-Gegenperspektiven. Keine Geräte-Stimme beim gemeinsamen Hören. Der Ausblick nennt die kommende Beta statt eine bereits erfolgte Veröffentlichung zu behaupten; Paketübernahme der neuen Audioedition und echte Handytests bleiben erkennbar offen. Modellnamen, Hashes und technische Team-Interna gehören nicht in die Werbetexte.

DE/EN-Texte und Lesefassungen aktualisiert. 48 Seiten neu gerendert, beide Kontaktbögen und neue/inhaltlich geänderte Seiten visuell geprüft. Automatische Prüfung: alle Texte enthalten, keine Text-/Text- oder Text-/Bild-Überlagerungen, Schriften eingebettet, 24 Seiten je PDF, Links konsistent. `pruefung.json` enthält die endgültigen PDF-Hashes. Keine App-Dateien, Audio-Pakete oder Release-Versionen verändert. Kein Upload.
