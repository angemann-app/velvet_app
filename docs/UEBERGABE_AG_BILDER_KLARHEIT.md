# Auftrag an Antigravity: Sehr-spicy-Bilder eindeutig abgeben

Stand: 05.11.2026, von Claude Code.

## Warum

Deine Übergabe `docs/UEBERGABE_CLAUDE.md` nennt 35 fertige Sehr-spicy-Bilder. Beim Nachzählen in `build/redaktion/*/webp/`
passen Anzahl und Namen nicht eindeutig zu dem, was die App lädt. Ich kann so nichts ins Paket `reihe-bilder` übernehmen,
ohne zu raten. Bitte schaffe Klarheit und gib die Bilder in einer festen Form ab.

## Was die App erwartet

Pfad im Paket: `bilder/<folge>_sehrspicy_<szene>.webp`. Es gibt genau diese 35 Zielnamen:

| Folge | Szenen (Reihenfolge) | Anzahl |
|---|---|---|
| `frau_mann` | opening, attraction, first_contact, building_desire, climax, afterglow | 6 |
| `im_eigenen_koerper` | opening, awareness, building_desire, climax, afterglow | 5 |
| `zwei_frauen` | opening, attraction, first_contact, building_desire, climax, afterglow | 6 |
| `zwei_maenner` | opening, attraction, first_contact, building_desire, climax, afterglow | 6 |
| `drei_ffm` | opening, attraction, first_contact, building_desire, climax, afterglow | 6 |
| `drei_mmf` | opening, attraction, first_contact, building_desire, climax, afterglow | 6 |

Beispiel: `zwei_frauen_sehrspicy_opening.webp`, `drei_ffm_sehrspicy_climax.webp`.
Je Folge **ein** Satz für alle Rollen (kein Satz je Rolle).

## Was ich vorgefunden habe (bitte prüfen und berichtigen)

- Viele Dateien tragen nicht den Zielnamen, zum Beispiel `drei_ffm_opening.webp`, `drei_mmf_opening.webp`, `zwei_frauen_opening.webp`
  (ohne „sehrspicy“). In `dreier_ffm/webp` trägt nur `drei_ffm_sehrspicy_afterglow.webp` den richtigen Namen.
- Im Ordner liegen zusätzliche Dateien, die keine Szenenbilder sind: `*_galerie.webp`, `*_cloud_galerie.webp`, `drei_ffm_climax_akt.webp`,
  `drei_mmf_drei_frauen_galerie.webp` u. a. Es ist unklar, ob sie zum Satz gehören.
- `sehrspicy_zwei_maenner` wird in deiner Übergabe als „6 Szenen“ geführt; ich habe die Namen noch nicht gegen die Szenenliste geprüft.

## Zu tun

1. Lege den Ordner `build/redaktion/sehrspicy_bilder_abgabe/` an und lege **genau 35 Dateien** mit den Zielnamen oben hinein (Kopien, die
   Originale und alle Kandidaten bleiben, wo sie sind). Nichts anderes in diesen Ordner.
2. Schreibe `build/redaktion/sehrspicy_bilder_abgabe/BERICHT.md`: eine Tabelle mit den Spalten **Zielname, Quelldatei, Seed, Figuren
   im Bild (z. B. „2 Männer, 1 Frau“), Figurenzahl laut Szene stimmt (ja/nein), Hände/Beine/Körper ohne Fehler (ja/nein), Format
   (Breite × Höhe, KB)**. Fehlt ein Bild oder ist es nur ein Kompromiss, steht das ausdrücklich dort. Nichts als „fertig“ melden, was du
   nicht selbst angesehen hast.
3. Liste im Bericht getrennt auf, was bewusst **nicht** in die 35 gehört (Galerie-Extras, Cloud-Kandidaten, Alt-Bilder) und warum.
4. Zeige im Bericht, ob der Stil in allen 35 derselbe ist (Chiaroscuro, Sehr spicy), und nenne Ausreißer.
5. Melde bei Zweifeln an Figuren oder Motiven nicht „ok“, sondern nenne das Bild. Fehlgriffe neu erzeugen (anderer Seed), wie in
   CLAUDE.md unter „Bilder“ beschrieben.

## Nicht ändern

`reihe.json`, `tools/pakete/*`, die App, die Soft/Spicy-Bilder (Bleistift) und alles in `lib/` und `assets/`. Paket und Veröffentlichung
macht Claude; die Bilder gehen erst nach Sichtprüfung durch mich und Abnahme durch den Nutzer in `reihe-bilder`.

## Rückmeldung

Kurzer Eintrag unter „Erledigt“ in `AG.md` ist nicht nötig; sag dem Nutzer Bescheid, sobald `BERICHT.md` liegt.
