# Antigravity kann sowohl Vektorgrafiken als SVG-Code schreiben als auch Rasterbilder mit einem Bildmodell (über den Subagenten `image-generator`) erzeugen.

## Auswertung der Probe für Kurs 25 („Toys“)

Auftrag: **AG-11**  
Datum: 29.10.2026  
Status: Alle 4 Motive als SVG (Deutsch und Englisch) sowie als Modellbild (WebP, unter 150 KB) erfolgreich erzeugt.

### Übersicht der Dateien

| Motiv | SVG (DE / EN) | Modellbild (WebP) | Dateigröße SVG | Dateigröße Modellbild | Was nicht klappte / Anmerkungen |
|---|---|---|---|---|---|
| `toys_uebersicht` (Lektion `toys_2`) | ja | ja | 9,6 KB / 9,5 KB | 12,3 KB (`12.558 B`) | **Filter:** kein Abbruch. **Stil:** Neutrale Silhouetten ohne Körper; getrennt in zwei Gruppen („Für Frauen“: Auflege-, Druckwellen-, Stab- und Kugel-Formen; „Für Männer“: Ringe, Masturbator, Prostata-Stimulator; unten gemeinsam: Gleitmittel). **Lesbarkeit:** Sehr klar, skalierbar. |
| `toys_material` (Lektion `toys_3`) | ja | ja | 6,8 KB / 6,8 KB | 9,7 KB (`9.978 B`) | **Filter:** kein Abbruch. **Stil:** Vier Kacheln für Medizinisches Silikon, Borosilikatglas, Edelstahl und ABS-Kunststoff mit je Piktogramm, Haptik und Pflegehinweis. |
| `toys_sicherheit` (Lektion `toys_4`) | ja | ja | 5,1 KB / 5,1 KB | 14,2 KB (`14.574 B`) | **Filter:** kein Abbruch. **Stil:** Ampel-/Merkbild mit den drei Kernregeln (Anal-Sicherheit mit breiter Basis, passendes Gleitmittel nach Material, Stopp-Signale & Hygiene). |
| `toys_titel` (Titelbild Kurs 25, 840 × 300) | ja | ja | 3,6 KB / 3,6 KB | 10,9 KB (`11.190 B`) | **Filter:** kein Abbruch. **Stil:** Format 840 × 300 im Stil der vorhandenen Titelbilder (`cover_25` / `cover_27`), warme Licht-Aura, schwebende Staubpartikel, stilisierte Konturen im Gegenlicht. *Hinweis zum Modellbild:* Bildmodell erzeugte nativ 16:9, wurde verlustfrei horizontal zentriert auf 840 × 300 skaliert/beschnitten. |

---

### Vergleich SVG vs. Bildmodell

1. **SVG (Code):**
   - **Vorteile:** Extrem kompakt (alle unter 10 KB), beliebig und gestochen scharf skalierbar (Vollbild-Zoom in Flutter), Texte können sauber zweisprachig (DE / EN) gepflegt werden, Barrierefreiheit durch `<title>` und `<desc>`, exakte Einhaltung der VelvetPulse-Farbpalette (`#140D1C`, `#0F172A`, `#FB7185`, `#38BDF8`, `#FBBF24`).
   - **Eignung:** Perfekt für schematische Erklär-Diagramme, Übersichten, Materialvergleiche und Sicherheits-Leitfäden (Lektionen).

2. **Rasterbild (Bildmodell, WebP):**
   - **Vorteile:** Weiche, plastische Lichtverläufe, Tiefenschärfe und Studio-Atmosphäre.
   - **Grenzen:** Beschriftungen/Text im Bild sind unzuverlässig und nicht lokalisierbar; für Lektionsdiagramme mit Text daher ungeeignet, für reine Stimmungsbilder oder Banner jedoch sehr ansprechend.
