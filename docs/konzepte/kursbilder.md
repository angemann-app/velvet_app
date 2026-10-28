# Kursbilder: grafische Ausarbeitung der Kurse

Stand: 28.10.2026, Entwurf. Noch nichts umgesetzt. Die Abschnitte „Offene Fragen“ müssen vor dem ersten Bild
mit dem Nutzer geklärt werden (CLAUDE.md: Konzepte zuerst).

## 1. Ausgangslage (aus dem Bestand, nicht geschätzt)

- 27 Kurse, 124 Lektionen in `assets/data/velvet_content.json`.
- Jeder Kurs hat ein Titelbild: `assets/images/cover_01.svg` bis `cover_27.svg` (eigene SVG-Silhouetten in warmem Licht,
  etwa 2 bis 4 KB, Format 840 × 300). Dazu `guided_*.svg` für die geführten Audios und `ynm_*.svg` für Ja/Nein/Vielleicht.
- Nur **9 Lektionen** haben ein eigenes Bild, alle als erklärendes Diagramm (`diagram_*.svg`, mit englischer Fassung
  `*_en.svg`): Kurse 8, 18, 19, 20 und 22. In den anderen 22 Kursen gibt es kein einziges Lektionsbild.
- Die Bilder werden mit `tools/generate_covers.py` und `tools/generate_diagrams.py` erzeugt. Geänderte Bilder bitte dort ändern.
- Die App zeigt das Titelbild in der Kurskarte und ein Lektionsbild in der Lektion (`courses_screen.dart`,
  `lesson_detail_screen.dart`); SVG und Rasterbilder sind möglich, SVG-Diagramme sind antippbar (Vollbild).
- Bilder liegen heute in der APK. Grundsatz Inhalte: Langfristig wandern Inhalte in signierte Pakete.

## 2. Ziel

„Manchmal hilft es, wenn man etwas sieht.“ Bilder sollen erklären, wo ein Bild mehr sagt als Text: Anatomie,
Beckenboden, Berührungstechniken, Toys, Wäsche, Stellungen, Körperhaltung, Atem. Sie sollen die Kurse auch
atmosphärisch aufwerten, ohne zu überladen.

Nicht Ziel: jede Lektion bebildern. Eine Lektion bekommt ein Bild nur, wenn es etwas erklärt oder die Stimmung trägt.

## 3. Bildarten

| Art | Zweck | Wie | Wo |
|---|---|---|---|
| Titelbild je Kurs | Stimmung, Wiedererkennung | Silhouetten-SVG wie bisher, ggf. überarbeitet | APK |
| Erklär-Diagramm | Anatomie, Ablauf, Körperhaltung | SVG nach Vorgabe, DE und EN beschriftet | APK |
| Stimmungsbild je Lektion | Einstieg in eine Lektion | illustrativ, ruhig | APK (Normalfassung) |
| **Spicy-Illustration** | deutlichere, sinnliche Bilder in Spicy-Kursen und -Lektionen | illustrativ, nicht fotorealistisch | **Nur-R2-Paket**, verschlüsselter Transport |

## 4. Regeln (feststehend)

- Nur Erwachsene, alles einvernehmlich, keine echten Personen und keine Nachbildung echter Personen.
- Keine Fotos, keine Marken- und Herstellerbilder.
- Illustrativ statt fotorealistisch. Erklärende Diagramme bleiben SVG.
- Beschriftungen immer Deutsch und Englisch (`*_en.svg`, `translations/en/`).
- Spicy-Bilder nie im Repository und nie in der APK, sondern wie „Lust im Traum“ und die Audioreihe als
  Nur-R2-Paket. Im Diskretions-Modus bleibt die Darstellung neutral.
- Lizenz: nur selbst erzeugte oder frei lizenzierte Bilder (CC BY-NC-SA), Herkunft je Bild in einer Liste festhalten.
- Neue Bilder paketfähig anlegen (Grundsatz Inhalte): Bild-Pfad aus dem Inhalt lösen, nicht fest in der App.

## 5. Technischer Weg

1. **Erklär-Diagramme und Titelbilder:** weiter als SVG mit den vorhandenen Skripten. Vorgaben je Bild (Motiv,
   Beschriftung, Farben der App) schreibt Claude; das Zeichnen ist gut automatisierbar.
2. **Stimmungsbilder und Spicy-Illustrationen:** zwei Möglichkeiten:
   - **A) SVG-Silhouetten** im bestehenden Stil. Vorteil: klein, beliebig skalierbar, keine Zusatztechnik.
     Nachteil: eingeschränkt in Ausdruck und Detail.
   - **B) Lokal erzeugte Bilder** (ComfyUI auf dem zweiten Rechner, Notiz vom 27.10.2026, noch nicht eingerichtet).
     **Entfällt derzeit** (Entscheidung des Nutzers, 28.10.2026).
   - **C) Antigravity (AG) erzeugt die Grafiken.** Zwei Unterwege, die ein kleiner Probeauftrag klären soll:
     1. *SVG als Code*: AG schreibt SVG nach Vorgabe im Stil der vorhandenen Bilder (klein, skalierbar, DE/EN
        beschriftbar, passt zu `tools/generate_diagrams.py`). Funktioniert ohne Bildmodell.
     2. *Bildmodell* (falls AG eines mitbringt): Rasterbilder (PNG/WebP). Nur Normalfassung. Offen sind
        Stilkonstanz, Dateigröße (WebP, APK-Größe), Urheberrecht an KI-Bildern und Nutzungsbedingungen.
     Spicy-Bilder gehen **nicht** an AG: Es ist ein Cloud-Modell (CLAUDE.md: Spicy-Inhalte nicht an Cloud-Modelle
     abgeben), und Bildmodelle lehnen solche Motive meist ab oder liefern unkontrollierbar.
3. **Paketierung:** Normalfassung in der APK oder in einem Bilder-Paket; Spicy als `*-bilder-spicy`-Paket nur in R2,
   mit demselben verschlüsselten Transport wie die Reihe (`tools/paket_transport.dart`).
4. **Anzeige in der App:** Lektionsansicht lädt das Bild über den Pfad, fehlt es, bleibt die Lektion ohne Bild
   (wie bisher). Spicy-Bilder nur im Spicy-Modus.

## 6. Reihenfolge (Vorschlag)

1. **Pilot mit einem Kurs**, an dem Normal und Spicy sichtbar werden, z. B. Kurs 25 „Toys“ (in der Notiz vom 27.10.2026
   als Beispiel genannt) oder Kurs 26/27 „Spicy“. Daran Stil, Größe, Paketierung und Anzeige klären.
2. Danach Schwerpunkt für Schwerpunkt wie in `docs/AUFGABEN.md` Punkt 3, immer gemeinsam mit der inhaltlichen Überarbeitung.
3. Titelbilder der 27 Kurse zuletzt prüfen, ob ein einheitlicher Stil nötig ist.

## 7. Offene Fragen (vor dem ersten Bild klären)

1. **Pilotkurs:** Toys (25), Anatomie der Erregung (2), Beckenboden (7) oder einer der Spicy-Kurse?
2. **Stil der Spicy-Bilder:** nur Silhouetten und Andeutung, oder deutlich? Wie deutlich genau (Grenze)?
3. **Technik für Stimmungs- und Spicy-Bilder:** SVG (A) oder lokal erzeugte Bilder (B)? Soll ComfyUI dafür eingerichtet werden?
4. **Normalfassung:** Soll sie neue Stimmungsbilder je Lektion bekommen, oder reichen Titelbilder und Diagramme?
5. **Titelbilder:** bleiben die 27 Cover wie sie sind, oder sollen sie neu gestaltet werden?
6. **Wo liegen Normalbilder:** weiter in der APK (Größe!) oder in einem Paket wie die Audios?
7. **Rechtliches** (nur zur Kenntnis, wie bei der Audioreihe): deutliche Bilder haben ein höheres Gewicht als Audio.
   Das ist deine Abwägung; ich nenne es nur, damit die Frage 2 bewusst entschieden wird.

## 8. Entscheidungen

- 28.10.2026: **Pilotkurs ist Kurs 25 „Toys“** (Normalfassung zuerst).
- 28.10.2026: Lokale Bilderzeugung (B) **entfällt derzeit**. Stattdessen Probe mit Antigravity (C), Auftrag **AG-11**
  in `AG.md` (vier neutrale Motive, SVG DE/EN, optional Bildmodell zum Vergleich). Spicy-Bilder gehen nicht an AG.
- Offen bleiben Frage 2 (Deutlichkeit der Spicy-Bilder) und 4 bis 6, bis die Probe ausgewertet ist.
