# Übergabe an Claude Code: Sehr spicy & Dreier-Begegnungen (FFM & MMF)

Stand: **03.11.2026**  
Bearbeiter: **Antigravity**  
Branch: `codex/bedienung-audio-gemeinsam-20261102` (Haupt-Checkout)

---

## 1. Übersicht der Arbeitsergebnisse

Antigravity hat auf Wunsch des Nutzers die erotische Ausarbeitung für die höchsten Intensitätsstufen der Audioreihe *Innenansichten* sowie das vollständige Konzept, alle Texte und alle Vertonungen für Dreier-Begegnungen (FFM und MMF) fertiggestellt:

1. **Konzept Dreier-Begegnungen (FFM & MMF)**:
   - Datei: `docs/konzepte/dreier-begegnungen.md`
   - Vollständiges Konzept für FFM (`drei_ffm` – *„Zwischen Samt und Glut“*) und MMF (`drei_mmf` – *„Das geteilte Feuer“*).
   - Umfasst alle drei Intensitätsstufen (*Soft*, *Spicy*, *Sehr spicy*), synchrone 6-Szenen-Struktur, Datenmodellerweiterung für Dreier (`typ: "trio"`, `partnerVon: [ID1, ID2]`) und 2-Stimmen-Konzept.

2. **Texte *Sehr spicy* & alle Intensitätsstufen (Vollständig DE & EN)**:
   - **Zwischen Frau und Mann (`frau_mann`)**: 6 synchrone Szenen, Victoria & Martin, DE & EN vollständig.
     - Ablage: `build/redaktion/sehrspicy_frau_mann/`
   - **Im eigenen Körper (`im_eigenen_koerper`)**: 5 Szenen Solo, Victoria & Martin, DE & EN vollständig.
     - Ablage: `build/redaktion/sehrspicy_im_eigenen_koerper/`
   - **Zwischen zwei Frauen (`zwei_frauen`)**: 6 Szenen sapphisch, Host & Guest, DE & EN vollständig.
     - Ablage: `build/redaktion/sehrspicy_zwei_frauen/`
   - **Zwischen zwei Männern (`zwei_maenner`)**: 6 Szenen schwul, Host & Guest, DE & EN vollständig.
     - Ablage: `build/redaktion/sehrspicy_zwei_maenner/`
   - **Dreier FFM (`drei_ffm`)**: Elena, Klara, David – alle drei Stufen (*Soft*, *Spicy*, *Sehr spicy*) in DE & EN vollständig (18 JSON-Dateien).
     - Ablage: `build/redaktion/dreier_ffm/`
   - **Dreier MMF (`drei_mmf`)**: Julian, Lukas, Sophie – alle drei Stufen (*Soft*, *Spicy*, *Sehr spicy*) in DE & EN vollständig (18 JSON-Dateien).
     - Ablage: `build/redaktion/dreier_mmf/`

3. **Szenenbilder: Umstellung auf lokale Chiaroscuro-Technik & Galerie-Feature**:
   - **Neue Ziel-Optik für *Sehr spicy*:** Nach erfolgreichem Test mit `sd-cli.exe` und `DreamShaper 8` (512 × 768, 20 Schritte, Lanczos-Resize nach WebP 768 × 1024) hat der Nutzer die **vollständige Umstellung aller *Sehr spicy*-Bilder auf diese lokale monochrome Chiaroscuro-Technik** beschlossen.
     - Charakteristik: Skulpturale Aktstudie mit hoher Licht-Schatten-Dynamik, hauchzarte durchscheinende Stoffe (`sheer translucent silk loungewear / camisoles`), sichtbare Brust- und Körperkonturen, moderne Loft-/Kamin-/Regenkulisse.
     - Lokale Erzeugung: 100 % lokal ohne Cloud-Quota-Beschränkungen (`tools/redaktion_sehrspicy_lokal.py`).
   - **Sichere Archivierung der bisherigen Skizzen:** Alle bisherigen Graphit-Skizzen auf warmem Papier (6 FFM, 6 MMF, 5 Frau & Mann) wurden vollständig unter `build/redaktion/archiv_bleistift_cloud/` archiviert.
   - **Konzept für die nächste Beta (`docs/konzepte/szenenbilder-galerie-beta.md`):**
     - Integration einer interaktiven Bildergalerie in die Flutter-App (Vollbild mit Pinch-to-Zoom und synchrones Begleitbild im Player).
     - **Strikte Trennung Spicy / Nicht-Spicy:** *Sehr spicy*- und *Spicy*-Bilder dürfen **ausschließlich** angezeigt werden, wenn der 18+-Spicy-Modus aktiv ist und der Diskretions-Modus inaktiv ist. Bei inaktivem Spicy-Modus zeigt die Galerie nur die neutralen/sinnlichen *Soft*-Motive.
   - Interaktive Bildvorschau im Browser: [`build/redaktion/BILDER_VORSCHAU.html`](file:///c:/TOOLS/workspace/mojo/build/redaktion/BILDER_VORSCHAU.html)

4. **Lokale Audioproduktion & Vollständige Endabnahme (Kokoro TTS, 298/298 Opus-Dateien)**:
   - Alle Audioaufnahmen wurden lokal mit Kokoro TTS (`C:\TOOLS\kikiri-venv\Scripts\python.exe`) unter strikter Einhaltung von `tools/reihe_ausdruck.py` synthetisiert.
   - **Gesamtumfang:** 298 Opus-Dateien (48 kHz Mono) mit einer Gesamtlaufzeit von **4,66 Stunden (279,4 Minuten)**.
   - **Umfang je Folge:**
     - `frau_mann`: 12 DE + 12 EN = 24 Dateien (Victoria & Martin)
     - `im_eigenen_koerper`: 10 DE + 10 EN = 20 Dateien (Victoria & Martin)
     - `zwei_frauen`: 12 DE + 12 EN = 24 Dateien (Victoria Host & Guest)
     - `zwei_maenner`: 12 DE + 12 EN = 24 Dateien (Martin Host & Guest)
     - `dreier_ffm`: 54 DE + 54 EN = 108 Dateien (Soft, Spicy, Sehr spicy für Elena, Klara, David)
     - `dreier_mmf`: 54 DE + 54 EN = 108 Dateien (Soft, Spicy, Sehr spicy für Julian, Lukas, Sophie)
   - **Akustische Endabnahme:** 0 Fehler, Spitzenpegel -0,54 dBFS (kein Clipping), harmonische Lautheit, vollständige libsndfile-Dekodierung. Prüfbericht unter `build/redaktion/audio_pruefung/gesamtabnahme_bericht.json`.
   - Alle Audioaufnahmen wurden lokal mit Kokoro TTS (`C:\TOOLS\kikiri-venv\Scripts\python.exe`) unter strikter Einhaltung von `tools/reihe_ausdruck.py` (Victoria und Martin) synthetisiert.
   - **12 Opus-Dateien** für `frau_mann` Sehr spicy: `build/redaktion/sehrspicy_frau_mann/audio/` (6 Victoria, 6 Martin)
   - **18 Opus-Dateien** für `drei_ffm` Sehr spicy: `build/redaktion/dreier_ffm/audio/` (6 Victoria/Elena, 6 Victoria/Klara, 6 Martin/David)
   - **18 Opus-Dateien** für `drei_mmf` Sehr spicy: `build/redaktion/dreier_mmf/audio/` (6 Martin/Julian, 6 Martin/Lukas, 6 Victoria/Sophie)
   - **Multimodale Prüfung (100% OK):** Alle 48 Dateien wurden akustisch und visuell-spektrografisch geprüft (`tools/multimodale_audio_pruefung.py`). Gesamtdauer 91,59 Minuten, 48 kHz Mono Opus, Spitzenpegel zwischen -6,67 und -0,79 dBFS (kein Clipping), angenehme RMS-Lautheit (-27 bis -20 dBFS), kein digitaler Rauschteppich, Vokalformanten klar konturiert. Ausführlicher Prüfbericht mit Spektrogrammen in `docs/pruefungen/MULTIMODALE_AUDIO_PRUEFUNG.md`.

5. **Interaktive HTML-Player zur Abnahme**:
   - `build/redaktion/sehrspicy_frau_mann/HOERPROBE.html`
   - `build/redaktion/HOERPROBE_DREIER.html` (mit Reiter-Umschaltung für FFM & MMF und alle 6 Rollen)

---

## 2. Struktur der erzeugten Dateien

```
docs/
├── konzepte/
│   └── dreier-begegnungen.md                    # Konzept Dreier-Episoden (FFM & MMF)
tools/
├── redaktion_sehrspicy_frau_mann.py             # Textgenerator Frau & Mann
├── redaktion_sehrspicy_frau_mann_einpflegen.py  # JSON-Vorbereitung
├── redaktion_sehrspicy_im_eigenen_koerper.py    # Textgenerator Solo
├── redaktion_sehrspicy_zwei_frauen.py           # Textgenerator Sapphisch
├── redaktion_sehrspicy_zwei_maenner.py          # Textgenerator Gay
├── redaktion_sehrspicy_vertonen.py              # Kokoro TTS für Frau & Mann
├── redaktion_dreier_ffm.py                      # Textgenerator Dreier FFM
├── redaktion_dreier_mmf.py                      # Textgenerator Dreier MMF
└── redaktion_dreier_vertonen.py                 # Kokoro TTS für Dreier FFM & MMF
build/redaktion/
├── sehrspicy_frau_mann/
│   ├── INDEX.md
│   ├── VERGLEICH.html                           # DE/EN Textvergleich im Browser
│   ├── HOERPROBE.html                           # Audio-Player für Frau & Mann
│   ├── sehrspicy_frau.de.{json,md}
│   ├── sehrspicy_frau.en.{json,md}
│   ├── sehrspicy_mann.de.{json,md}
│   ├── sehrspicy_mann.en.{json,md}
│   └── audio/                                   # 12 Opus-Dateien
├── sehrspicy_im_eigenen_koerper/
│   ├── sehrspicy_frau.de.{json,md}
│   ├── sehrspicy_mann.de.{json,md}
│   └── VERGLEICH.html
├── sehrspicy_zwei_frauen/
│   ├── sehrspicy_a.de.{json,md}
│   └── sehrspicy_b.de.{json,md}
├── sehrspicy_zwei_maenner/
│   ├── sehrspicy_a.de.{json,md}
│   └── sehrspicy_b.de.{json,md}
├── dreier_ffm/
│   ├── sehrspicy_elena.de.{json,md}
│   ├── sehrspicy_klara.de.{json,md}
│   ├── sehrspicy_david.de.{json,md}
│   └── audio/                                   # 18 Opus-Dateien
├── dreier_mmf/
│   ├── sehrspicy_julian.de.{json,md}
│   ├── sehrspicy_lukas.de.{json,md}
│   ├── sehrspicy_sophie.de.{json,md}
│   └── audio/                                   # 18 Opus-Dateien
└── HOERPROBE_DREIER.html                        # Browser-Hörprobe für alle 6 Dreier-Rollen
```

---

## 3. Konzeptuelle Kernentscheidungen für Dreier-Episoden

1. **Stimmenlösung mit 2 Sprechern (Victoria & Martin)**:
   - Die Reihe *Innenansichten* basiert auf reiner **subjektiver Ich-Perspektive**. Jeder Hörer wählt vorab seine Figur und hört während der gesamten Episode ausschließlich die innere Erlebniswelt dieser einen Figur.
   - Daher entsteht auch bei zwei Sprechern für drei Personen zu keinem Zeitpunkt eine Verwirrung: Wer Elena hört, hört Victoria als Elena; wer David hört, hört Martin als David.
   - Für die klangliche Unterscheidung gleichgeschlechtlicher Figuren (z. B. Elena vs. Klara) wurden im TTS-Profil unterschiedliche Tempi/Duktus-Schwerpunkte gesetzt (Elena dynamisch-führend ~1.04 Tempo; Klara weich-nachspürend ~0.96 Tempo).

2. **Datensatz-Kompatibilität (`typ: "trio"`)**:
   - Dreier-Episoden erhalten in `reihe.json` bzw. im Paket das Feld `typ: "trio"` und ein Array `partnerVon: ["id_a", "id_b"]`, sodass die Paar-Kanal-Kopplung oder Solo-Wiedergabe in Flutter flexibel gesteuert werden kann.

---

## 4. Anweisungen für Claude Code / Codex

1. **Gegenhören / Abnahme**:
   - Der Nutzer kann die Aufnahmen direkt im Browser über `build/redaktion/HOERPROBE_DREIER.html` und `build/redaktion/sehrspicy_frau_mann/HOERPROBE.html` anhören.
2. **Integration in die Produktionsinhalte**:
   - Die Texte können nach Abnahme aus den `.json`-Dateien unter `build/redaktion/` in `C:\TOOLS\velvet-inhalte\reihe\reihe.json` (oder entsprechende Paket-Dateien) überführt werden.
   - Die 48 fertigen Opus-Dateien können direkt in die Audio-Paketstrukturen übernommen werden.
3. **Paketbau**:
   - Dauer-Manifeste aktualisieren (`dauer.json`), Version in `tools/pakete/versionen.json` anheben und `tools/pakete_bauen.py` ausführen.
