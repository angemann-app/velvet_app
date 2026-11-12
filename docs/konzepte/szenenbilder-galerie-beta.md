# Konzept: Szenenbilder-Galerie (Beta) & Strikte Trennung Spicy / Nicht-Spicy

Stand: **03.11.2026**  
Status: **Zur Abstimmung mit Claude Code / Codex und dem Nutzer**  
Bezug: `docs/konzepte/lust-reihe-szenenbilder.md`, `AGENTS.md`, `docs/UEBERGABE_SEHRSPICY_UND_DREIER.md`

---

## 1. Ausgangslage & Zielsetzung

Für die Audioreihe *Innenansichten* und die neuen Dreier-Episoden wurden auf Wunsch des Nutzers visuelle Szenenbilder entwickelt. Nach einem erfolgreichen lokalen Test mit `sd-cli.exe` und dem Modell `DreamShaper 8` hat der Nutzer entschieden:

1. **Vollständige Umstellung aller „Sehr spicy“-Bilder auf die neue lokale Chiaroscuro-Technik**:
   - Skulpturale monochrome Aktstudie mit hoher Licht-Schatten-Dynamik.
   - Hauchzarte, durchscheinende Stoffe (`sheer translucent silk loungewear / camisoles`), die natürliche Konturen und sichtbare anatomische Details betonen.
   - Zeitgemäße Kulissen (modernes Loft, strömender Regen an Panoramafenstern, Kaminfeuer, weiche Laken).
   - 100 % lokale Generierung auf dem Entwicklerrechner (keine Cloud-Quota-Limits, kein Abfluss von 18+-Prompts an Drittanbieter).
2. **Archivierung & Weiterverwendung der bisherigen Skizzenbuch-Zeichnungen**:
   - Alle bisherigen Cloud-Zeichnungen (Graphit auf warmem Skizzenpapier) wurden gesichert unter `build/redaktion/archiv_bleistift_cloud/`.
3. **Einführung einer Galerie in der nächsten Beta**:
   - Die Hörer sollen die zu den Szenen gehörenden Kunstwerke in der App interaktiv betrachten können.

---

## 2. Kernanforderung: Strikte Trennung zwischen Spicy / Sehr spicy und Nicht-Spicy

In Übereinstimmung mit den **festen Regeln** von VelvetPulse (`AGENTS.md`) gilt für die Galerie und alle Bildanzeigen:

> **Spicy-Inhalte nur hinter dem Spicy-Modus. Alle Figuren in Texten und Bildern sind erwachsen, alles ist einvernehmlich.**  
> **Diskretion: Benachrichtigungen, Sperrbildschirm und Diskretions-Modus bleiben vollkommen neutral.**

### 2.1 Die drei Intensitätsstufen für Bilder

| Stufe | Bildstil | Inhalt & Erotik-Level | Freigabe-Bedingung |
| :--- | :--- | :--- | :--- |
| **Soft** | Malerische Illustration / Ölgemälde oder ruhige Skizze | Sinnlich, bekleidet, atmosphärisch. Keine Nacktheit, keine durchscheinenden Intimbereiche. | **Immer sichtbar** (auch ohne Spicy-Modus). |
| **Spicy** | Malerisch / feine Skizze | Körperbetont, sinnliche Umarmungen, verdeckte Intimität. | **Nur bei aktivem Spicy-Modus (18+)**. |
| **Sehr spicy** | Monochrome Chiaroscuro-Aktstudie (DreamShaper 8) | Erotische Intimität, durchscheinende Stoffe, sichtbare Brust- und Körperkonturen. | **Ausschließlich bei aktivem Spicy-Modus (18+)** UND **inaktivem Diskretions-Modus**. |

### 2.2 Technische Schutzmechanismen in Flutter

1. **Kein Vorab-Laden in ungeschützte Caches:**  
   Bilder aus `sehrspicy_*` und `spicy_*` dürfen nicht in globale, unverschlüsselte Bild-Caches oder temporäre Ordner gelegt werden, die von Galerie-Apps des Betriebssystems (Android MediaStore) gescannt werden.
2. **Schutz vor versehentlichem Einblick (Diskretions-Modus & App-Switch):**  
   - Ist der Diskretions-Modus aktiv, schaltet die Galerie automatisch alle *Sehr spicy*-Bilder stumm bzw. zeigt stattdessen das neutrale *Soft*-Motiv der Szene.
   - Im Android Task-Switcher (Recent Apps) greift `FLAG_SECURE`, sodass in der App-Übersicht keine intimen Bilder sichtbar sind.
3. **Explizite Galerie-Schranke:**  
   Öffnet der Nutzer die Galerie, wird der aktuelle Status von `SpicyService.istAktiv` und `DiskretionService.istAktiv` geprüft:
   - Ist Spicy-Modus **aus**, zeigt die Galerie nur die *Soft*-Motive. Ein dezenter Umschalter „Spicy-Motive anzeigen“ führt zur bekannten 18+-PIN-/Aktivierungsabfrage.
   - Ist Spicy-Modus **an**, kann der Nutzer frei zwischen *Soft* (Atmosphäre) und *Sehr spicy* (Chiaroscuro-Aktstudie) umschalten.

---

## 3. Architektur & Datenhaltung der Galerie

### 3.1 Paketierung (Nur-R2, keine APK-Vergrößerung)

Wie in `AGENTS.md` vorgegeben, wandern alle Szenenbilder **nie in die APK**, sondern in das signierte Release-Paket der Reihe auf Cloudflare R2:
- Pfad im R2-Paket: `bilder/<folge>_<variante>_<szene>.webp`
- Format: Standard-WebP, 768 × 1024 Pixel, 80–120 KB, optimiert mit PIL Lanczos.

### 3.2 Metadaten in `reihe.json`

Jede Szene in `reihe.json` enthält den Bildverweis je Variante:

```json
{
  "szene": "opening",
  "titel": "Die Erwartung im Regen",
  "bilder": {
    "soft": "frau_mann_soft_opening.webp",
    "spicy": "frau_mann_spicy_opening.webp",
    "sehrspicy": "frau_mann_sehrspicy_opening.webp"
  }
}
```

### 3.3 UI-Komponenten für die Beta

1. **Begleitbild im Audio-Player:**
   - Während des Hörens zeigt der Player das Bild der aktuellen Szene.
   - Bei Szenenwechsel (z. B. von *Attraction* zu *First Contact*) blendet das Bild sanft über (Cross-Fade 800ms).
   - Tippen auf das Bild öffnet die Vollbild-Galerie.
2. **Vollbild-Galerie (Pinch-to-Zoom):**
   - Elegantes Schwarz (`#111827`), Bild zentriert.
   - Horizontales Swipen zwischen den 5–6 Szenen der aktuellen Episode.
   - Umschalter Soft / Sehr spicy (nur bei 18+ freigeschaltet).
   - Dezente Einblendung von Szenentitel und Beschreibung am unteren Rand.

---

## 4. Offene Fragen & Entscheidungen für Codex / Claude Code

- [x] **Bildstil für *Sehr spicy*:** Einstimmig entschieden für die lokale DreamShaper-8-Chiaroscuro-Technik mit durchscheinenden Stoffen.
- [x] **Archivierung der Skizzen:** Unter `build/redaktion/archiv_bleistift_cloud/` gesichert.
- [ ] **Galerie-Icon / Einstiegspunkt:** Soll die Galerie als eigener Tab in der Reihe erreichbar sein oder als Vollbild-Option aus dem Audio-Player? (Empfehlung: Beides – Icon im Player oben rechts sowie ein Karten-Element „Bildergalerie“ auf der Episodenseite).
- [ ] **Offline-Verfügbarkeit:** Werden Bilder beim Download einer Folge mitgeladen (ca. 600 KB pro Folge) oder on-demand nachgeladen? (Empfehlung: Mit dem Folgen-Audiopaket bündeln, damit alles offline funktioniert).


---

## 5. Integration in die App (Prüfung durch Claude Code, 03.11.2026)

### 5.1 Was es schon gibt

- Das Paket `reihe-bilder` (sprachfrei, nur R2, nur Spicy) mit `bilder/<folge>_<variante>_<szene>.webp`; Pfad aus
  `ReiheDaten.bildPfad`, ein Bild gehört zu Folge, Variante und Szene.
- Der Player (`wiedergabe_screen.dart`) zeigt das Bild der aktuellen Szene im Format 3:2 (Querformat, `BoxFit.cover`), fehlt es,
  bleibt er wie bisher. Das Paket wird beim Öffnen der Reihe nachgeladen.
- Das Gate ist `StorageService.spicyMode()`. Es gilt seit dem Altersnachweis (`altersnachweis.md`) nur nach Altersangabe und
  Gerätesperre. Ein eigener „Spicy-Dienst“ oder eine „18+-PIN-Abfrage“ (Abschnitt 2.2) existiert nicht und ist nicht nötig.

### 5.2 Was nicht zusammenpasst

1. **Hochformat gegen Querformat:** Die neuen Bilder sind 2:3 (768 × 1152). Der Player schneidet auf 3:2 zu und zeigt von einem
   Hochformat nur einen Streifen. Deshalb gehört die Vollbildansicht (die Galerie) zu den Bildern: sie zeigt sie ganz.
2. **Dateinamen:** AG nennt `frau_mann_sehrspicy_<szene>.webp` (ein Satz je Folge) und `drei_ffm_<szene>.webp` (ohne Stufe).
   Die App erwartet `<folge>_sehrspicy_<fassung>_<szene>` je Perspektive. Neu: ein Folgenfeld `bildersatz` (`"stufe"` oder
   `"fassung"`, Standard `"stufe"`); `"fassung"` behält nur „Der andere Körper“. Dreier-Bilder heißen
   `drei_ffm_sehrspicy_<szene>.webp`, dazu Soft und Spicy.
3. **Stufentrennung:** Die Dreier-Bilder sind Sehr spicy. Soft und Spicy brauchen eigene, bekleidete bzw. andeutende Bilder,
   sonst zeigt die Soft-Stufe nichts oder Falsches. Ohne Bild bleibt die Soft-Stufe sauber ohne Bild.
4. **Zwei Bildstile im selben Paket:** Pencil-Bilder (Soft, Spicy, bisher) und Chiaroscuro (Sehr spicy). Ob das ein Bruch ist,
   entscheidet der Nutzer an der Vorschau (Abschnitt 5.5).

### 5.3 Vorschlag für die Galerie

- **Vollbild-Ansicht** `GalerieSeite`: schwarzer Grund, `PageView` über die Szenen der Folge, `InteractiveViewer` (Zoomen),
  Szenentitel am unteren Rand. Einstiege: Tippen auf das Bild im Player und eine Zeile „Bilder ansehen“ in der Einrichtung der
  Folge. Beide öffnen dieselbe Seite.
- **Stufen:** Die Auswahl zeigt nur die Stufen, die das Paket hat und die der Modus erlaubt (`folge.varianten(spicyErlaubt: …)`).
  Ohne Spicy gibt es nur Soft, und auch das nur, wenn Bilder da sind. Kein eigener Umschalter „Spicy-Motive anzeigen“.
- **Diskretion:** Ist das diskrete App-Symbol aktiv (`PrivacyService.isDiscreetIcon()`), erscheint kein Galerie-Einstieg und
  das Bild im Player bleibt wie bisher (Reihe ist dort ohnehin neutral). Kein Soft-Ersatzbild, es entfällt einfach.
- **Schutz:** Die Seite setzt beim Öffnen `PrivacyService.applySecureFlag(true)` (kein Screenshot, keine Vorschau im
  App-Wechsler) und stellt den vorigen Wert beim Schließen wieder her. Bilder kommen aus dem App-Ordner, nie aus dem
  Medienspeicher; beim Schließen wird der Bild-Cache der Seite geleert.
- **Offline:** Die Bilder liegen im Paket `reihe-bilder`, nicht in den Audio-Paketen. Sie werden schon beim Öffnen der Reihe
  nachgeladen, daher ist keine eigene Download-Entscheidung nötig.
- **Tests:** `bildPfad` je `bildersatz`, Galerie sichtbar nur mit Spicy und ohne diskretes Symbol, Seitenwechsel,
  Rückfall ohne Bild (Screen-Test).

### 5.4 Reihenfolge

1. Bildnamen und `bildersatz` (Zweier-Folgen zuerst, App-Änderung klein).
2. Galerie-Seite und die beiden Einstiege.
3. Dreier-Bilder (alle drei Stufen) und Dreier-Folgen, wenn deren Texte fertig sind.
4. Paketbau `reihe-bilder` und `de-/en-reihe`, danach Beta (laut Entscheidung vom 28.10.: erst nach den Bildern).

### 5.5 Offene Fragen

- [ ] Sind die beiden Stile (Bleistift für Soft/Spicy, Chiaroscuro für Sehr spicy) so gewollt, oder sollen alle Stufen
  einheitlich werden?
- [ ] Sehr spicy der Zweier-Folgen: ein Bildsatz je Folge (AG: 3 von 6 Szenen fertig) oder je Rolle?
- [ ] Beim Schließen der Galerie `FLAG_SECURE` immer setzen, auch ohne App-Sperre? (Vorschlag: ja, nur in der Galerie)

### 5.6 Umsetzung (03.11.2026)

Gebaut: `lib/screens/self_exploration/reihe_galerie_screen.dart` (Vollbild, `PageView` und `InteractiveViewer`, Stufenwahl nur mit Bildern,
`FLAG_SECURE` solange offen, Bild-Cache beim Schließen geleert, schließt sich beim diskreten App-Symbol). Einstiege: Tippen auf das Bild
im Player und „Bilder ansehen“ in der Einrichtung (nur mit Bildern und ohne diskretes Symbol). Neues Folgenfeld `bildersatz`
(`stufe` oder `fassung`, ohne Angabe `fassung`); in `reihe.json` steht `stufe` für alle Folgen außer „Der andere Körper“. Tests:
`test/reihe_galerie_test.dart`. Entschieden: Bildstile bleiben getrennt (Nutzer, 03.11.2026). Offen: Welche Sehr-spicy-Bilder ins Paket
`reihe-bilder` kommen (Namen `<folge>_sehrspicy_<szene>.webp`, bei den Dreier-Folgen `drei_ffm_sehrspicy_<szene>.webp`).
### 5.7 Entscheidung zum Bildstil (07.11.2026, Nutzer)

**Fotoähnliche Bilder werden nicht genutzt**, das heißt keine Chiaroscuro-Aktstudien (DreamShaper 8, Abschnitt 1 und 5.2 sind damit überholt), keine Nachbesserungen aus AG-27 und AG-28. Die Galerie zeigt **nur Bilder im Bleistift-Stil** (AG-22 bis AG-24): Soft und Spicy der fünf Folgen (je 29 Bilder, `reihe\bilder\ag\`) und die Sehr-spicy-Sätze „Der andere Körper“ (Frau und Mann, 12 Bilder, `reihe\bilder\sehrspicy\`). Für die übrigen Sehr-spicy-Stufen und die Dreier-Folgen gibt es vorerst keine Bilder; die Galerie zeigt nur Stufen, die das Paket hat. Die 35 Fotobilder und alle Zwischenstände liegen unter `build\redaktion\` und gehen nicht ins Paket.
