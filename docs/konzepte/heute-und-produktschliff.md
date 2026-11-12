# Konzept: „Heute“ und Produktschliff

Stand: Entwurf vom 31.10.2026, Richtung vom Nutzer abgestimmt („Gehe mit allem mit“), Einzelheiten offen.

> **Vermerk 12.11.2026: Der KI-Coach ist entfallen** (`docs/konzepte/coach-entfernen.md`). Die Stellen zum Coach unten (Punkte 5 und 6, Stufe 5) sind überholt; Üben hat nur noch Körper und Gedanken.
Ausgangspunkt war ein Blick von oben auf die App als Produktdesigner. Baut auf `startseite.md` und
`redesign-bleistift.md` auf.
Vermerk 12.11.2026: Heute im Paar-Modus, Geschlechtsauswahl und „Eure erste Woche“ stehen in `eine-tonlage.md`.

## Leitgedanke

Die App soll sich bei jedem Start ruhig und einladend anfühlen und eine Frage beantworten: **Was tut mir jetzt gut?**
Keine Leistungsanzeige, kein Druck, nichts, was wie ein Fehler aussieht. Das Versprechen „Alles bleibt auf deinem
Handy“ gehört dauerhaft sichtbar dazu.

## Die zehn Punkte

| # | Problem | Entscheidung (Entwurf) |
|---|---|---|
| 1 | Fünf Blöcke vor dem ersten Kurs | Startseite wird **Heute**: Begrüßung, eine Karte „Dein nächster Schritt“, Kurse. Check-in und Erotik-Funke werden zu einer gemeinsamen Karte mit zwei Reitern. |
| 2 | Prozentbalken und Streak widersprechen „Nähe ohne Ziel“ | Kein Prozentbalken, keine Flamme. Statt dessen „Dein nächster Schritt“ und „zuletzt vor 3 Tagen“. Fortschritt je Kurs bleibt als feiner Strich, ohne Gesamtprozent. |
| 3 | Kurs-Liste zu schwer, ohne Titelbilder | Schmale Zeilen: kleines Bleistift-Titelbild, Titel, eine Zeile, feiner Fortschrittsstrich. Gruppen bleiben die Schwerpunkte, besser sichtbar. |
| 4 | SOS laut und dauernd da | Kleines Schild-Symbol ohne Beschriftung, Antippen öffnet die Hilfe wie bisher. Bleibt auf allen Hauptseiten erreichbar. |
| 5 | Tab-Leiste mischt Denkmodelle, Jargon | Neue Reihenfolge **Heute, Lernen, Üben, Wir**. Üben vereint Beckenboden, Atem und Gedanken (Reframing, ohne „KVT“ im Namen). „Wir“ ist der Paar-Kanal, für Singles mit freundlicher Erklärung. Der KI-Coach wird Unterpunkt von „Üben“. |
| 6 | KI-Coach: Einstieg wirkt wie ein Fehler | Willkommensschritt mit Nutzen und Einrichtung in zwei Schritten; kurzer Begrüßungstext; Vorschläge mit sichtbarem Rand. |
| 7 | Onboarding ist ein Formular | Zuerst das Versprechen (privat, lokal), dann eine Frage pro Bild mit Skizze; Datenschutz-Detail verlinkt statt vorangestellt. |
| 8 | Vertrauen zu leise | Kleines Schloss mit „Bleibt auf deinem Handy“ auf Heute und in „Wir“. |
| 9 | Geführte Audios jetzt versteckt | **Weiter hören** auf Heute (zuletzt gehörtes Audio mit Fortsetzen-Knopf). Der Audio-Bereich selbst ist **einklappbar** und merkt sich den Zustand dauerhaft (Entscheidung des Nutzers). |
| 10 | Kleinigkeiten | Mindestschrift 13 pt, kräftigere Beschreibungsfarbe, Vorschlags-Reihe mit Auslauf-Schatten, Serifen-Überschriften auf dem Handy prüfen. |

## Heute (Aufbau von oben)

1. **Kopf:** „Guten Abend, Alex“, kleines Profil-Symbol, kleines Schloss, SOS-Symbol.
2. **Dein nächster Schritt:** eine große Karte. Regel: laufende Lektion fortsetzen, sonst das zuletzt gehörte Audio,
   sonst die nächste Lektion im Schwerpunkt aus dem Profil. Daneben „Etwas anderes“.
3. **Für heute:** Check-in und Erotik-Funke als zwei Reiter einer Karte.
4. **Geführte Audios:** einklappbarer Balken (vorhanden); der Zustand wird dauerhaft gespeichert und gehört in die
   Sicherung. Beim ersten Start offen.
5. **Hinweise:** Aufnahmen laden und Updates als dünne Zeile am Ende, nicht als große Karte.
6. **Kurse:** nach Schwerpunkten, schmale Zeilen mit Titelbild (siehe 3).

## Umsetzung in Stufen

1. **Heute-Seite:** Kopf, nächster Schritt, Funke/Check-in-Karte, Audios dauerhaft einklappbar, Hinweiszeile, ohne
   Prozentbalken und Flamme. (Punkte 1, 2, 8, 9)
2. **Kurs-Zeilen mit Titelbildern** und kräftigere Lesbarkeit. (3, 10)
3. **SOS-Symbol** auf allen Hauptseiten. (4)
4. **Tab-Umbau** zu Heute, Lernen, Üben, Wir mit neuen Beschriftungen DE und EN und Anleitung. (5)
5. **KI-Coach-Einstieg** und **Onboarding** neu. (6, 7)

Jede Stufe einzeln, mit Tests, Screens-Test und „Was ist neu“. Englisch wird mitgepflegt.

## Entscheidungen (abgestimmt)

- Richtung aller zehn Punkte; Punkt 9 mit einklappbarem Audio-Bereich.

## Offene Fragen

- Name der ersten Tab-Seite: „Heute“ oder „Start“?
- Bleibt die Streak irgendwo (z. B. nur im Profil, ohne Flamme), oder entfällt sie ganz?
- Tab „Lernen“ nur Kurse oder auch Lektions-Suche und Lesezeichen?
- Wohin mit dem KI-Coach für Menschen ohne Schlüssel: unter „Üben“ sichtbar, oder erst nach Einrichtung?
- Erste Stufe als Beta mit alter Tab-Leiste (Umbau erst in Stufe 4), damit Rückmeldungen nicht an zwei Dingen hängen?
## Stand der Umsetzung

**Stufe 1 gebaut am 31.10.2026** (noch nicht veröffentlicht): Tab und Titel heißen „Heute“; Kopf mit Begrüßung, Fokus und
Hinweis „Bleibt auf deinem Handy“; „Dein nächster Schritt“ (nächste offene Lektion, zuerst im Schwerpunkt zum Fokus);
Check-in und Funke als zwei Reiter; Aufnahmen-Hinweis als dünne Zeile; geführte Audios einklappbar, Zustand dauerhaft
gespeichert und in der Sicherung (`audioBereichOffen`). Prozentbalken und Serienflamme entfallen.

Noch offen aus Stufe 1: **„Weiter hören“** (zuletzt gehörtes Audio mit Fortsetzen-Knopf) braucht erst eine Speicherung des
zuletzt gehörten Audios und kommt als Stufe 1b; „Zuletzt vor X Tagen“ im nächsten Schritt braucht denselben Zeitstempel
je Lektion.

## Entscheidungen (Vorschläge, vom Nutzer mit „Erst Heute bauen“ übernommen)

Name „Heute“; Streak entfällt; Tab „Lernen“ mit Kursen, Suche und Lesezeichen; KI-Coach unter „Üben“ sichtbar mit
freundlicher Einrichtung; Stufe 1 zuerst mit alter Tab-Leiste.
**Stufe 3 und 4 gebaut am 31.10.2026** (noch nicht veröffentlicht): SOS ist ein kleines Schild ohne Beschriftung. Die Tab-Leiste hat
vier Tabs: **Heute** (Kopf, nächster Schritt, Check-in/Funke, geführte Audios, Einstieg „Alle Kurse ansehen“), **Lernen**
(Filter und Kurse nach Schwerpunkten), **Üben** (Bereiche Körper, Gedanken, KI-Coach in `lib/screens/ueben/ueben_screen.dart`)
und **Wir** (Paar-Kanal). Aufrufer wie Lektionen springen weiter mit den alten Tab-Nummern; `MainNavigationScreen` ordnet sie zu.
Noch offen: Suche und Lesezeichen in „Lernen“, Willkommensschritt im KI-Coach und Onboarding (Stufe 5), „Weiter hören“ (Stufe 1b).
**Stufe 5 gebaut am 31.10.2026** (noch nicht veröffentlicht): Die Ersteinrichtung beginnt mit einer Willkommensseite (drei
Versprechen, Datenschutz-Einzelheiten hinter „Mehr zum Datenschutz“, „Loslegen“, Wiederherstellen), danach eine Frage pro
Bild mit Fortschrittsstrich, „Weiter“ und „Zurück“; „Überspringen“ steht immer da. Das Bearbeiten des Profils bleibt eine
Seite. Der KI-Coach zeigt ohne Schlüssel einen Einstieg in zwei Schritten (Anleitung, Einfügen) statt einer Fehlermeldung.