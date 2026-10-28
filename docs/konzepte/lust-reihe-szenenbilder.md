# Szenenbilder im Player der Audioreihe „Innenansichten“

Stand: 28.10.2026, Entwurf. Noch nichts umgesetzt. Die Abschnitte „Offene Fragen“ müssen vor dem ersten Bild mit dem
Nutzer geklärt werden (CLAUDE.md: Konzepte zuerst). Wunsch des Nutzers vom 28.10.2026: Beim Hören soll je Szene ein
Bild zu sehen sein.

Bezug: `docs/konzepte/lust-audioreihe.md` (Reihe), `docs/konzepte/kursbilder.md` und `docs/kursbilder-bedarf.md`
(Dual-Bild-Prinzip, Nur-R2, lokale Erzeugung mit stable-diffusion.cpp).

## 1. Ausgangslage (aus dem Bestand)

- Der Player (`lib/screens/self_exploration/lust_reihe_screen.dart`, `_spieler()`) zeigt heute Titel, „Soft · Perspektive“,
  „Szene i von n“, die Szenenbeschreibung, einen Fortschrittsbalken und die Bedienung. Kein Bild.
- Szenen-IDs gehören zum gemeinsamen Szenenbuch einer Folge und sind in allen Fassungen gleich. Ein Bild je Szene lässt
  sich also an `folge.id` + `szene.id` hängen, ohne dass das Modell sich ändert.
- Szenen je Folge (laut `reihe.json`): Frau und Mann 6, Im eigenen Körper 5, Zwischen zwei Frauen 6, Zwischen zwei
  Männern 6, Der andere Körper 6. Zusammen **29 Szenen**.
- Die ganze Reihe ist nur im Spicy-Modus sichtbar, Inhalte liegen nur im Paket `<sprache>-reihe` (nur R2).
- Der Player springt über `_index` zwischen Szenen; ein Bildwechsel hängt damit schon an einer vorhandenen Stelle.

## 2. Ziel

Pro Szene ein ruhiges, atmosphärisches Bild, das die Stimmung trägt und beim Szenenwechsel mitwechselt. Es soll das
Hören unterstützen, nicht ablenken: keine Handlung zeigen, die der Text erst erzählt, keine Pflicht, hinzusehen.

## 3. Regeln (feststehend, aus Reihe und Kursbildern)

- Nur Erwachsene, alles einvernehmlich, keine echten Personen und keine Nachbildung echter Personen, keine Fotos.
- Illustrativ, nicht fotorealistisch; Andeutung vor Deutlichkeit (Silhouetten, Licht, Stoff, Raum). Die Grenze legt der
  Nutzer fest (Frage 2).
- Bilder der Reihe **nie im Repository, nie in der APK**, nur im Nur-R2-Paket, mit demselben verschlüsselten Transport
  wie die Audios. Im Diskretions-Modus erscheint die Reihe ohnehin nur neutral als „Hörgeschichte“; dort keine Bilder
  in Vorschau, Kachel oder Benachrichtigung.
- Spicy-Motive nicht an Cloud-Modelle (auch nicht an AG oder OpenCode); Erzeugung nur lokal.
- Keine Bildbeschriftung im Bild; nötige Texte (Szenenbeschreibung) bleiben App-Text in Deutsch und Englisch.
- Kein Bild ist Voraussetzung für die Wiedergabe: fehlt es, bleibt der Player wie heute.

## 4. Umfang und Zuordnung

Ein Bild gehört zu **Folge + Variante + Szene**, nicht zur Perspektive: Beide Perspektiven erzählen dieselbe Szene, ein
gemeinsames Bild passt zu beiden und stützt das „gemeinsam startbar“.

| Vorschlag | Bilder | Bemerkung |
|---|---|---|
| Je Folge ein Satz für Soft und einer für Spicy | 29 × 2 = **58** | Soft zeigt Raum, Licht, Stoff, Hände, Spicy sinnlicher |
| Nur ein Satz je Folge (für beide Varianten) | 29 | Spicy-Wirkung geht verloren |
| Je Perspektive eigenes Bild | 29 × 4 = 116 | nur sinnvoll, wenn Blickwinkel (Sie/Er, Gastgeberin/Gast) das Bild ändern soll |

Empfehlung: 58 Bilder, Soft und Spicy getrennt, Perspektive geteilt. Bei Solo-Folgen ist das ohnehin eindeutig.

## 5. Technischer Weg

1. **Erzeugung lokal** mit stable-diffusion.cpp (MCP `sd-cli`, siehe `docs/kursbilder-bedarf.md`). Je Folge ein
   Stilblock (Farbwelt, Licht, Format) und je Szene ein Motivsatz aus der `beschreibung` des Szenenbuchs, damit ein
   Satz einheitlich wirkt. Seed und Prompt je Bild in einer Liste festhalten (Nachvollziehbarkeit, Lizenz).
2. **Format:** Hochformat passend zur Player-Ansicht (Vorschlag 3:4 oder 9:16 zugeschnitten), WebP, Ziel 80 bis 120 KB
   je Bild, damit das Paket klein bleibt (58 Bilder ≈ 6 MB).
3. **Ablage und Paket:** Quelle `C:\TOOLS\velvet-inhalte\reihe\bilder\<folge>_<variante>_<szene>.webp`. Bauen über
   `tools/pakete_bauen.py` in dasselbe Paket `<sprache>-reihe` unter `bilder/…` (kein eigenes Paket, solange die Größe
   passt; Version hochzählen). Die Bilder sind sprachunabhängig und liegen daher in beiden Sprachpaketen oder, falls
   das stört, in einem gemeinsamen `reihe-bilder` (Frage 4).
4. **Anzeige:** Neue Hilfsfunktion `ReiheDaten.bildPfad(folge, fassung, szene)` analog zu `audioPfad`, Auflösung über
   `Pakete.datei(...)`. Im Player füllt das Bild den oberen Teil oder dient als abgedunkelter Hintergrund hinter
   Titel und Bedienung; Überblendung (etwa 800 ms) beim Szenenwechsel, kein hartes Umschalten. Lesbarkeit durch
   Verlauf von unten gesichert. Fehlt das Bild, bleibt der Player wie heute.
5. **Bildschirm schonen:** Das Hören läuft oft mit dunklem Display. Ein Schalter „Bilder anzeigen“ (Standard an) und
   Rücksicht auf den Bildschirm-aus-Modus. Spät abends nicht blenden: Bilder gedämpft, dunkel gehalten.
6. **Vorschau:** Keine Bilder in der Einrichtungsansicht und in Kacheln, bis jemand die Folge startet (Diskretion,
   Mitlesen). Ob ein Titelbild je Folge gewünscht ist, ist Frage 5.
7. **Tests:** `bildPfad` (Test wie `audioPfad`), Paketbau prüft, dass zu jeder Szene beider Varianten ein Bild
   existiert oder die Folge bewusst ohne Bilder geführt wird. `test_screens` rendert den Player mit und ohne Bild.

## 6. Reihenfolge (Vorschlag)

1. Pilotfolge ist **Frau und Mann**, wie im Reihenkonzept (`lust-audioreihe.md`, Abschnitt 9 und 11, „Die Priorität
   liegt auf einer überzeugenden, vollständig ausgearbeiteten Pilotfolge“); Aufnahmen vorhanden, Szenen bekannt:
   6 Szenen × Soft/Spicy = 12 Bilder.
2. Player-Anzeige und `bildPfad` mit den Pilotbildern bauen und auf dem Gerät prüfen (Helligkeit, Lesbarkeit,
   Überblendung).
3. Erst danach die übrigen vier Folgen (17 Szenen, 34 Bilder), parallel zum Einsprechen.

## 7. Offene Fragen (vor dem ersten Bild klären)

1. **Zuordnung:** ein Bild je Folge, Variante und Szene (Empfehlung) oder je Perspektive?
3. **Paket:** Bilder in beide Sprachpakete legen (einfach, doppelt etwa 6 MB) oder ein gemeinsames Paket
   `reihe-bilder` (neuer Paketweg, spart Platz und Upload)?
4. **Gesichter und Körper:** nur Silhouetten und Details (Hände, Stoff, Raum), oder auch erkennbare Figuren?
5. **Einstellung:** Soll es einen Schalter „Bilder aus“ geben, und gilt er für alle Folgen?
6. **Titelbild je Folge** in der Einrichtungsansicht gewünscht? (Standard: nein, wegen Diskretion.)

## 8. Entscheidungen

- 28.10.2026: Wunsch geäußert, Konzept entworfen.
- 28.10.2026: **Pilot ist die Folge „Zwischen Frau und Mann“** (gilt für die Reihe und damit auch für die Bilder).
- 28.10.2026: **Deutlichkeit:** Spicy-Bilder sind deutlich, alle anderen (Soft) sinnlich. Es bleibt bei illustrativ,
  nur Erwachsene, einvernehmlich, keine echten Personen, nur lokal erzeugt und nur im Nur-R2-Paket (Abschnitt 3).
  Die Grenze zwischen „sinnlich“ und „deutlich“ im Einzelfall legt der Nutzer am Pilotsatz fest.
- 28.10.2026: **Paketbau erst nach dem Gestalten der Bilder** (Entscheidung des Nutzers). Aufnahmen dürfen vorher
  entstehen, aber `de-reihe` und `en-reihe` werden erst gebaut und hochgeladen, wenn die Bilder (Pilotsatz, danach die
  übrigen Folgen) fertig sind, damit die Pakete nicht zweimal erscheinen.
- 28.10.2026: Player-Anzeige und `ReiheDaten.bildPfad` sind gebaut (Rückfall ohne Bild); Bilder fehlen noch.
