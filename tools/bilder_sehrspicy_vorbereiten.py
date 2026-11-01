"""Bereitet die 12 neuen Szenenbilder aus C:\\TOOLS\\workspace\\mojo-ag\\spicy für Claude Code vor.

Schritte:
- JPGs laden (sp1 bis sp12)
- Skalieren auf Standardgröße 768 x 1024 (LANCZOS-Filter)
- Nach WebP konvertieren (Ziel: 80-120 KB, max 130 KB)
- Ablegen unter C:\\TOOLS\\velvet-inhalte\\reihe\\bilder\\sehrspicy\\
"""
import os
from pathlib import Path
from PIL import Image

QUELLE = Path(r"C:\TOOLS\workspace\mojo-ag\spicy")
ZIEL = Path(r"C:\TOOLS\velvet-inhalte\reihe\bilder\sehrspicy")
ZIEL_AG = Path(r"C:\TOOLS\velvet-inhalte\reihe\bilder\ag_sehrspicy\webp")

ZUORDNUNG = [
    # sp1 - sp6: sehrspicy_mann (Hörer: Mann, Martin - Thema: Weiblicher Körper & Orgasmen)
    ("sp1.jpg", "der_andere_koerper_sehrspicy_mann_opening"),
    ("sp2.jpg", "der_andere_koerper_sehrspicy_mann_own_body"),
    ("sp3.jpg", "der_andere_koerper_sehrspicy_mann_other_door"),
    ("sp4.jpg", "der_andere_koerper_sehrspicy_mann_other_body"),
    ("sp5.jpg", "der_andere_koerper_sehrspicy_mann_return"),
    ("sp6.jpg", "der_andere_koerper_sehrspicy_mann_afterglow"),

    # sp7 - sp12: sehrspicy_frau (Hörerin: Frau, Victoria - Thema: Männlicher Körper & Ejakulation)
    ("sp7.jpg", "der_andere_koerper_sehrspicy_frau_opening"),
    ("sp8.jpg", "der_andere_koerper_sehrspicy_frau_own_body"),
    ("sp9.jpg", "der_andere_koerper_sehrspicy_frau_other_door"),
    ("sp10.jpg", "der_andere_koerper_sehrspicy_frau_other_body"),
    ("sp11.jpg", "der_andere_koerper_sehrspicy_frau_return"),
    ("sp12.jpg", "der_andere_koerper_sehrspicy_frau_afterglow"),
]

def verarbeite():
    ZIEL.mkdir(parents=True, exist_ok=True)
    ZIEL_AG.mkdir(parents=True, exist_ok=True)

    print(f"Verarbeite 12 Bilder aus {QUELLE}...")
    uebersicht = []

    for jpg_name, ziel_name in ZUORDNUNG:
        jpg_pfad = QUELLE / jpg_name
        if not jpg_pfad.exists():
            print(f"FEHLER: {jpg_pfad} nicht gefunden!")
            continue

        im = Image.open(jpg_pfad)
        # Hochwertige Skalierung auf 768 x 1024
        im_resized = im.resize((768, 1024), Image.Resampling.LANCZOS)

        # WebP mit optimierter Kompression speichern (Qualität anpassen, um im 80-120 KB Bereich zu bleiben)
        qualitaet = 85
        webp_pfad = ZIEL / f"{ziel_name}.webp"
        im_resized.save(webp_pfad, "WEBP", quality=qualitaet, method=6)
        
        # Falls > 130 KB, leicht nachjustieren
        groesse_kb = webp_pfad.stat().st_size / 1024.0
        if groesse_kb > 130:
            qualitaet = 80
            im_resized.save(webp_pfad, "WEBP", quality=qualitaet, method=6)
            groesse_kb = webp_pfad.stat().st_size / 1024.0

        # Auch in ZIEL_AG ablegen
        im_resized.save(ZIEL_AG / f"{ziel_name}.webp", "WEBP", quality=qualitaet, method=6)

        print(f"  {jpg_name} -> {ziel_name}.webp: {groesse_kb:.1f} KB (768x1024, Q={qualitaet})")
        uebersicht.append((ziel_name, f"{groesse_kb:.1f} KB"))

    # Logdatei schreiben
    log_text = ["# Sehr spicy Bilder für 'Der andere Körper'\n", "Format: 768 x 1024, WebP, optimiert für Nur-R2-Paket.\n\n"]
    for name, groesse in uebersicht:
        log_text.append(f"- `{name}.webp`: {groesse}\n")
    (ZIEL / "INDEX.md").write_text("".join(log_text), encoding="utf-8")
    print(f"\nAlle Bilder erfolgreich vorbereitet unter {ZIEL}")

if __name__ == "__main__":
    verarbeite()
