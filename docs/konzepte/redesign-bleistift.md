# Konzept: Redesign „Skizzenbuch“ (Bleistift-Bildsprache)

Stand: Entwurf vom 30.10.2026, noch nicht abgestimmt. Vor jeder Umsetzung Entscheidungen unten klären.

## Idee

Die Bildsprache der Bleistift-Studien (Körperzeichnungen, Stimmungsbilder) wird zur Gestaltungssprache der ganzen App:
ein anatomisches Skizzenbuch. Ruhig, erwachsen, lehrbuchhaft, therapeutisch, und anders als Hochglanz-Fotos oder
Pink-Apps im Markt. Heute: dunkles Schiefer-Marine mit Smaragdgrün (`lib/theme/app_theme.dart`).

## Gestaltungssprache (als Code, ohne erzeugte Bilder)

- **Papier** (hell) und **Nachtpapier** (dunkel, Standard bleibt dunkel wegen Abendnutzung): warmes Off-White bzw. tiefes Graphit.
- **Graphit** für Text und Linien, **ein** Akzent: gedämpftes Rosé (Normal sparsam, Spicy kräftiger). Grün und Amber entfallen
  als Markenfarben, Statusfarben bleiben.
- **Linien statt Flächen:** dünne Konturen, Kartenränder wie Skizzenrahmen, feines Raster nur als Hintergrund-Andeutung,
  Maßlinien und Pfeile als Zierde an Überschriften und Trennern.
- **Schrift:** Überschriften in einer ruhigen Serif (z. B. Source Serif oder Lora, mitgeliefert, offline), Fließtext
  serifenlos; Beschriftungen in Handschrift-Optik nur in Zeichnungen, nie für Fließtext.
- **Bewegung:** Linien „zeichnen sich“ beim Einblenden (kurz, abschaltbar bei „Bewegung reduzieren“).

## Normal und Spicy

| | Normal | Spicy |
|---|---|---|
| Palette | Graphit auf Papier, Rosé nur für Hervorhebung | Graphit mit kräftigerem Rosé, wärmeres Papier |
| Motive | Anatomie, Diagramme, abstrakte Skizzen, Stillleben | zusätzlich sinnliche Figuren (Bleistift-Studien) |
| Titelbilder Menü | Skizzen-Vektoren (SVG) | dezente Silhouetten (`*_spicy.svg`, wie jetzt) |
| Herkunft | in der App (SVG) | Paket aus R2, nie in Repository oder APK |

Der Wechsel bleibt der bekannte Spicy-Schalter. Diskretions-Modus: neutrale Titel und Skizzen ohne Figuren, kein Rosé-Akzent.

## Bildregeln

- Normale Motive als **Vektor-Skizzen** (SVG, wie die Diagramme): mechanisch, auch durch OpenCode machbar, Deutsch und Englisch.
- Spicy-Motive **nur** über das bestehende Verfahren (AG-Ausnahme, lokal gelagert, R2-Paket). Die Ausnahme gilt je Auftrag; für
  weitere Mengen braucht es neue Zustimmung. Kein Redesign hängt an einem Spicy-Bild: Fehlt es, steht die Skizze ohne Figuren da.
- Jede Figur erwachsen, keine realen Personen, wer vorkommt, ist sichtbar.

## Umfang in Stufen

1. **Theme:** Farben, Schrift, Karten, Buttons, Dunkel/Hell in `app_theme.dart`; alles wirkt sofort in der gesamten App.
2. **Pilot (Beta):** Startseite und ein Kurs (Kurs 1) mit Skizzen-Kopf, Karten im Skizzenrahmen, Papier-Hintergrund.
3. **Kurs- und Menütitelbilder** als Skizzen-SVG (normal), Spicy-Silhouetten angleichen.
4. **Übrige Bereiche** (Journal, Paar-Kanal, Coach, Einstellungen), Onboarding.
5. Anleitung (`anleitung.json`, `docs/ANLEITUNG.md`), „Was ist neu“, Screenshots.

## Risiken

- Lesbarkeit und Kontrast (Graphit auf Papier, Rosé auf Dunkel): Prüfung nach WCAG AA, Schrift skalierbar.
- Größe der Schrift-Dateien in der APK (nur zwei Schnitte).
- Wer sich an Grün gewöhnt hat, erkennt die App neu: Beta mit Rückmeldung, Umschalter „Klassisches Design“ erwägen.
- Hängt nicht von AGs Tageslimit ab (Stufen 1 bis 4 brauchen keine Cloud-Bilder).

## Entscheidungen (offen)

1. Standard dunkel (Nachtpapier) oder hell (Papier)? Empfehlung: dunkel Standard, hell wählbar.
2. Serif-Überschriften ja/nein? Empfehlung: ja.
3. Umschalter „Klassisches Design“ in der Beta? Empfehlung: ja, bis zum stabilen Release.
4. Pilot: Startseite und Kurs 1? Empfehlung: ja.
