# Textvorgabe Einschlaf-Reise (für alle Texte der Reise)

Gelesen werden die Texte von einer ruhigen Computerstimme (Kokoro, Victoria oder Martin) in einer langen
geführten Meditation zum Einschlafen. Konzept: `docs/konzepte/einschlaf-reise.md` (zuerst lesen, besonders
„Idee“, „Ablauf“, „Sprache und Stil“, „Beispieltexte“). Die Reise soll erotisch schulen (Körperbild, Lust als
Welle, weiches Becken, Genuss ohne Leistung), ist dabei aber sinnlich und beruhigend, nie aufregend. Es gibt
keinen Höhepunkt, kein Aufwachen, keine Handlung.

## Wie die Texte verwendet werden

Jeder Baustein ist ein eigener kurzer Sprechtext, zwischen den Bausteinen liegen lange Pausen (Sekunden bis
Minuten). Jeder Baustein muss deshalb **für sich allein stehen**: keine Verweise wie „wie eben“, „wie gesagt“,
„gleich“. Derselbe Schwerpunkt wird über die Nacht mehrfach in **Runden** gesprochen: Runde 1 mit der langen
Fassung (v1), Runde 2 mit der mittleren (v2), ab Runde 3 mit der kurzen (v3), jeweils gefolgt von der
Kurzformel (f). Die drei Fassungen eines Bogens teilen dieselbe Kernaussage und enden sinngemäß bei derselben
Formel, **benutzen aber unterschiedliche Bilder und Sätze**, damit die Wiederholung nicht abgenutzt klingt.

## Stil (verbindlich)

- Du-Form, Präsens, kurze ruhige Sätze, Wiederholung erwünscht. Keine Fragen.
- Im Lernteil **keine Aufforderungen** („Atme“, „Spür“, „Stell dir vor“, „Denk“). Stattdessen feststellen oder
  erlauben: „Dein Kiefer wird weich.“, „Du darfst das Meer hören.“, „Es ist ein Meer in der Nacht.“ Nur die
  Phasen Ankommen, Sinken und Atem dürfen sanft einladen („Lass …“, „Atme …“).
- Positiv formulieren, möglichst keine Verneinungen („Dein Kiefer wird weich“ statt „Spann nicht an“).
  Wörter wie „nicht“, „kein“, „nie“ nur sparsam und nie als Schluss eines Gedankens.
- Nichts, was wach macht: keine Zahlen zum Mitzählen, keine Ausrufe, kein „jetzt“-Druck, keine Spannung,
  keine Steigerung. Der Text wird zum Ende hin eher einfacher, nicht dichter.
- Sinnlichkeit als Wärme, Gewicht, Weichheit, Haut, Atem, Dunkelheit, Wasser, Sand, Stoff.
- Keine Heilsversprechen („danach bist du …“), keine Medizin, keine Therapiesprache, kein Esoterik-Jargon
  (keine Energien, Chakren, Universum). Keine Leistungsbilder (Ziel, besser werden, üben).
- Geschlechtsoffen: Es gibt keine Annahme über Partner, Orientierung oder Beziehung. Im Normaltext (nicht
  Spicy) wird kein Geschlechtsorgan genannt, „Körper“ und „Becken“ genügen. Alle Menschen mit jedem Körper
  sind gemeint.
- Genau ein Gedanke pro Absatz, keine Aufzählungen mit mehr als drei Gliedern. Jeder Baustein beginnt ohne
  Gruß und Anrede.
- Aussprache: keine Fremdwörter, keine Abkürzungen, Zahlen als Wörter, keine Gedankenstriche (stattdessen
  Punkt oder Komma), keine Klammern, keine Anführungszeichen im Text.
- Spicy-Bausteine (nur Schwerpunkte, Körper vulva oder penis): deutlichere anatomische Wörter und Bilder von
  Wärme, Weichheit, Durchblutung, Lust als Möglichkeit. Vulva: Vulva, Schamlippen, Klitoris, Vagina, Becken.
  Penis: Penis, Eichel, Schaft, Hoden, Becken. Weiterhin ruhig und beruhigend. **Kein Dirty Talk, keine
  Handlung, keine Berührungsanweisung, kein Höhepunkt, keine Steigerung.** Die Lust „darf“ da sein oder
  ruht, sie wird nicht herbeigeführt. Lust ist ein Recht und eine Möglichkeit, kein Ziel.

## Englisch

Zu jedem Baustein gehört eine **englische Fassung gleicher Funktion**, kein Wort-für-Wort: gleicher Ton,
gleiche Länge (±15 %), gleiche Bilder, gleiche Regeln (keine Aufforderungen im Lernteil, wenig Verneinung,
keine Fremdwörter, keine Gedankenstriche, keine Anführungszeichen). Du-Form heißt „you“. Die Formeln im
Englischen so wählen, dass sie als Satz gut klingen und ohne Kontext verständlich sind. Spicy: ruhige anatomische
Wörter (vulva, labia, clitoris, vagina, penis, glans, shaft, testicles, pelvis).

## Ausgabe

Eine JSON-Datei (UTF-8, ohne BOM) mit zwei Listen `de` und `en`; jede Liste enthält Objekte
`{"id": "...", "phase": "...", "text": "..."}` (ggf. mit den weiteren Feldern der Aufgabe). Die Ids und Felder
sind in beiden Listen identisch, nur der Text unterscheidet sich. Absätze im Text mit `\n` trennen (je Absatz
wird eine Pause gesetzt; bei langen Bausteinen ruhig zwei bis vier Absätze). Danach mit
`python -c "import json;d=json.load(open(r'<Datei>',encoding='utf-8'));print(len(d['de']),len(d['en']))"` prüfen
und die Wortzahl pro Baustein gegen die Vorgabe prüfen. Keine anderen Dateien im Projekt ändern.
