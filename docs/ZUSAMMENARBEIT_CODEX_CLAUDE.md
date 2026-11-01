# Zusammenarbeit Codex und Claude Code

Stand: 01.11.2026. Auftrag des Nutzers: Texte überarbeiten, besonders die Spicy-Reihe; sämtliche Arbeiten von Codex müssen für Claude Code transparent sein.

## Zuständigkeiten und Abstimmung

- Codex begleitet die redaktionelle Prüfung: Verständlichkeit, Aufbau, Konsistenz, sachliche Genauigkeit, sprachliches Lektorat und gleichwertige englische Fassungen im vereinbarten Umfang.
- Claude Code arbeitet bereits im Worktree `C:\TOOLS\workspace\mojo\.claude\worktrees\design-magazin`, Branch `fix/reihe-bildschirm-aus`. Dort liegen zusätzliche Änderungen und Entscheidungen, die im Hauptbranch noch fehlen. Diese nicht überschreiben oder unabhängig neu implementieren.
- Vor Änderungen: aktuellen Git-Stand, `AG.md` (Gesperrt), passende Konzepte und dieses Protokoll lesen. Je Arbeitspaket konkrete Dateien und Zuständigkeit eintragen. Keine parallelen Änderungen derselben Datei.
- Produktionsquellen und Aufnahmen bleiben bis zur Abnahme erhalten. Entwürfe getrennt ablegen; keine privaten Inhalte ins Repository kopieren.
- Jede Übergabe nennt Ausgangsstand, Dateien beziehungsweise Inhalts-IDs, Änderungsgrund, Prüfungen, offene Fragen und Abnahmestatus. Commit oder Diff verlinken, soweit vorhanden.
- Inhaltliche Abnahme durch den Nutzer; Vertonung, Pakete und Veröffentlichung erst auf Grundlage des abgestimmten Textstands. Technische Integration und Release-Verantwortung mit Claude Code abstimmen.
- Ein Eintrag hier ist eine nachlesbare Übergabe, keine Bestätigung, dass Claude Code sie bereits gelesen hat.

## Aktueller Stand

- Haupt-Checkout `C:\TOOLS\workspace\mojo`: `main`, Stand bei Sichtung `80f230d`.
- Claude-Worktree bei Sichtung: `fix/reihe-bildschirm-aus`, Stand `9d13bd3`.
- Relevantes Konzept: `docs/konzepte/lust-audioreihe.md`; neuere Nutzerentscheidungen stehen derzeit zusätzlich in der Worktree-Fassung.
- Private Reihenquellen: `C:\TOOLS\velvet-inhalte\reihe\`.
- Beispieltexte des Nutzers: `C:\TOOLS\workspace\mojo_innenansichten\sehr_spicy_frau.txt` und `sehr_spicy_mann.txt`. In dieser Codex-Arbeit bisher nicht geöffnet oder geändert.
- Aktiver Auftrag: Lektorat aller 27 bestehenden Spicy-Lektionen in Deutsch und Englisch, anschließend lokale Neuvertonung nach Textabnahme. Neue Innenansichten sind ausgenommen.
- Codex-Branch: `codex/lektorat-beruehrung` im Haupt-Checkout. Keine Produktionsinhalte für Codex reserviert; Codex schreibt getrennte Entwürfe unter `build/redaktion/spicy/`.

## Arbeitsprotokoll

### 01.11.2026 – Zusammenarbeit vorbereiten (Codex)

- Geprüft: Git-Status und Worktrees, `AGENTS.md`, `AG.md`, `docs/AUFGABEN.md`, Konzept zur Audioreihe in Haupt-Checkout und Claude-Worktree.
- Angelegt: diese Datei als gemeinsames Übergabeprotokoll. Keine App-, Text-, Audio- oder Paketdateien geändert.
- Bereits vorhandene ungetrackte Dateien `.codex/` und `AGENTS.md` nicht verändert.
- Prüfung: Dokumentationsänderung; keine Laufzeittests erforderlich.
- Übergabe an Claude Code: Dieses Protokoll vor paralleler Textarbeit lesen und die konkrete Dateizuständigkeit abstimmen.

### 01.11.2026 – Spicy-Lektorat zur Abnahme (Codex)

- Konzept und Prüfbericht: `docs/konzepte/spicy-lektorat.md` (einschließlich Quellen und ungelöster Aufgabenwidersprüche).
- Ergebnis: 54 Entwürfe, 27 IDs je Sprache; `build/redaktion/spicy/INDEX.md`, `VERGLEICH.html`, Einzeltexte, JSON und Diffs. Da `build/` ignoriert wird, sind die Ergebnisse aus den unten genannten Dateien reproduzierbar.
- Reproduzierbar mit `python tools/redaktion_spicy_entwuerfe.py`; Änderungen in `tools/redaktion_spicy_korrekturen.json` und `tools/redaktion_beruehrung_muster.py`.
- Produktionsquellen nur gelesen. Aufgaben, Reflexionsfragen, Metadaten und vorhandene Dialogbeispiele erhalten; keine Audio- oder Paketänderungen.
- Nutzer hat lokale Neuvertonung nach CC-Regeln beauftragt. Vorher Textabnahme und Ausdrucks-Hörprobe. Technische Lücke gefunden: `voice=both` im Ausdrucksweg erhält bisher keinen abgesicherten Absatzwechsel; vor der Produktion lösen.
- Nächste Übergabe: Nutzer prüft Muster oder Gesamtvergleich; Claude Code prüft Änderungen und noch offene Aufgabenformulierungen vor Integration. Quellenprüfsummen vor Übernahme vergleichen.

### 01.11.2026 – Vier Aufgabenkorrekturen freigegeben (Codex)

- Nutzer hat alle vier vorgeschlagenen Änderungen ausdrücklich bestätigt: Rückfragen in der Fessel-Aufgabe, offener Massageabschluss, keine Pflicht zum Einlösen von Nachrichten, flexible Zahlen bei Edging und Toy-Stufenplan.
- Betroffene IDs: `spduo_4`, `mass_s1`, `alltag_6`, `spsolo_1`, `toys_7`; Deutsch und Englisch eingearbeitet.
- Nachvollziehbare Ersatzstellen in `tools/redaktion_spicy_aufgaben.json`; Generator prüft Aufgaben jetzt gegen genau diesen erlaubten Änderungsumfang. Alle anderen Aufgaben, Dialogabsätze und Metadaten bleiben geschützt.
- Alle 54 Entwürfe und Vergleiche neu erzeugt. Produktionsdateien und Audios unverändert. Gesamttextabnahme und Hörprobe stehen weiterhin aus.

### 01.11.2026 – Sämtliche Diagramme neu gezeichnet (Codex)

- Nutzerauftrag: vollständig neue Diagrammgrafiken im Magazin-Stil einschließlich notwendiger Textanpassungen. Umsetzung auf `codex/lektorat-beruehrung` im Haupt-Checkout; Claude-Worktree nicht verändert. Lokaler Diff, noch kein Release und kein Merge.
- Ersetzt: alle 50 `assets/images/diagram_*.svg` und ihre 50 englischen Fassungen. IDs, Dateinamen, 800 × 600 und Registerzuordnungen bleiben erhalten. Produktionsgrafiken sind geändert; die separat vorbereiteten Lektionsentwürfe bleiben weiterhin Entwürfe.
- Neue gemeinsame Quelle: `tools/diagramme_magazin_daten.py`; Zeichensystem: `tools/diagramme_magazin.py`. Alte Einstiegspunkte `generate_diagrams.py` und `diagramme_en.py` delegieren an die neue Quelle, damit ein alter Aufruf die Gestaltung nicht zurücksetzt. Keine neue App-Abhängigkeit.
- Eigenständige Motive für Anatomie, Nerven, Körperhaltungen, Material, Wahrnehmung, Vergleiche und Abläufe. Graphit, Papier, kontrastfähiges Altrosa und Source Serif 4; Bildtafeln bewusst auch in dunklen Atmosphären hell.
- Inhaltlich präzisiert: keine erfundenen Dopaminkurven, keine garantierten Erregungsschwellen oder festen Reflexe; Orgasmus und Ejakulation unterschieden, variable Anatomie, Rückmeldung und Grenzen klarer. DE/EN gemeinsam bearbeitet. Lektionstexte und Audios in diesem Arbeitspaket nicht überschrieben.
- Konzept, Quellen und Pflege: `docs/konzepte/diagramme-magazin.md`. Prüfung: `tools/diagramme_magazin_pruefen.py`, zusätzlich `test_screens/diagramme_test.dart`. Screenshot-Test lädt jetzt `sans-serif` explizit, sonst zeigt Flutter in der Testumgebung Kästchen statt der Android-Systemschrift.
- Prüfergebnisse: 100 reproduzierbare SVGs, Bildregister aktuell, 100 Browserrenderings mit Source Serif 4 ohne Textüberlappung oder Randüberschreitung; alle Textfarben mindestens 4,5:1 auf Papier. 337 bestehende Flutter-Tests bestanden. Analyse ohne Befunde und alle 100 Diagramme im Flutter-Renderer geprüft.
- Sichtprüfung: alle sieben deutschen Kontaktbögen und englische Stichproben. Lokale Ergebnisse unter `build/redaktion/diagramm-review/neu/` (PNG, `kontakt_01.png` bis `kontakt_07.png`, Textgrenzen-JSON) und `flutter/` (100 PNGs in Handybreite). Screens der App unter `build/screens/`, `build/screens_nacht/`, `build/screens_spicy/`; Prüflogs in `build/redaktion/diagramm-review/`.
- Übergabe: Vor Übernahme den Diagramm-Diff und die gerenderten Vorschauen ansehen. Keine Vertonung notwendig, da nur Bildbeschriftungen verändert wurden. Die gesonderte Abnahme des Lektionslektorats bleibt offen. Dateisperre nach Abschluss freigegeben.
- Abschlussprüfung der finalen Fassung: Screenshot-Test mit `STRICT=true` jeweils für Papier, Nachtpapier und Spicy bestanden; repräsentative Lektionsansicht in allen drei Atmosphären visuell geprüft. Browserprüfung nach Kontrastkorrektur erneut ohne Befund. `git diff --check` sauber.
