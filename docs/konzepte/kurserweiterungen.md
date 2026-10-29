# Konzept: Kurserweiterungen aus der Rückmeldung vom 28.10.2026

Stand: 29.10.2026, Entwurf. Nichts umgesetzt. Die Abschnitte „Offene Fragen“ klärt der Nutzer vor dem ersten Text
(CLAUDE.md: Konzepte zuerst).

## Ausgangslage

Über das Rückmelde-Postfach kamen am 28.10. abends mehrere Themenideen (Funktionswunsch, anonym, Version 4.14.0-beta.1).
Der Nutzer fragte, ob sich das in bestehende Kurse einbauen lässt, statt neue Kurse anzulegen. Ein Abgleich mit allen
27 Kursen (`assets/data/velvet_content.json`, Quelltexte unter `tools/content/kurs_NN_*.json` mit `_en`) ergab: Die
meisten Ideen sind schon teilweise gedeckt. Es bleiben **sechs neue Lektionen** und ein paar Verweise.

## Abgleich

| Idee aus der Rückmeldung | Schon vorhanden | Entscheidung |
|---|---|---|
| Nach dem Sex, Aftercare, Nachklang | nur „Nachsorge“ in Kurs 23 Lektion 3 (Spiele) | neue Lektion, Kurs 17 |
| Lust und Alltag | Kurs 16 (Alltagserotik, 11 Lektionen), Kurs 15 | neue Lektion, Kurs 16 |
| Scham und innerer Kritiker | Kurs 3 L4, Kurs 4, Kurs 5 L4 | gedeckt; nur Verweis auf das Reframing-Journal |
| Körperbild und Berührung | Kurs 3, Kurs 6 | neue Lektion, Kurs 3 |
| Lust in längeren Beziehungen | Kurs 6 L2, Kurs 14 L3 („Mit den Jahren“), Kurs 15 | neue Lektion, Kurs 13 |
| Wenn einer will und der andere nicht | Kurs 13 (4 Lektionen) | neue Lektion „Nein sagen und Nein hören“, Kurs 13 |
| Schmerz und Lust | Kurs 5 L1 (medizinisch: Sex tut weh) | neue Spicy-Lektion, Kurs 23 |
| Stimme und Lautstärke | Kurs 21 (4 Lektionen, Audio-Praxis) | gedeckt |

## Die sechs Lektionen (Arbeitstitel)

1. **Kurs 17, „Nach dem Höhepunkt: Nachklang und Nähe“.** Was nach intensiver Nähe im Körper und Nervensystem passiert;
   warum manche danach still, traurig oder unruhig werden (das ist häufig und kein Zeichen, dass etwas fehlt);
   drei kleine Rituale für danach, allein und zu zweit; ein Satz, mit dem man sagt, was man jetzt braucht. Anknüpfung:
   die „Nachklang“-Szenen der Audioreihe. Audio-Praxis möglich.
2. **Kurs 16, „Wenn der Alltag keine Kraft lässt“.** Stress, Erschöpfung, Kinder, Schichtarbeit, Krankheit; Brücken zur
   Lust ohne „richtig Sex haben zu müssen“; Mikro-Rituale und niederschwellige Berührung; Zwei-Pedale-Modell
   (Kurs 1) als Rahmen. Kein Druck, keine Zähler.
3. **Kurs 3, „Berührung verändert das Körperbild“.** Wenn man den eigenen oder den Körper des Gegenübers nicht mag;
   wie Aufmerksamkeit und freundliche Berührung die Wahrnehmung verändern; eine kurze somatische Übung (allein) und
   eine zu zweit. Anknüpfung: Kurs 2 (Landkarte), Kurs 6 (freundlicher Blick).
4. **Kurs 13, „Lange zusammen: Sicherheit und Erregung“.** Was sich verändert, wenn die Neuheit weg ist; das Dilemma
   zwischen Geborgenheit und Spannung; Wege, Neugier zuzulassen, ohne die Beziehung zu gefährden (neue Orte, neue
   Fragen, getrennte Erfahrungen teilen). Keine Heilsversprechen.
5. **Kurs 13, „Nein sagen und Nein hören“.** Ein Nein ist keine Ablehnung der Person; wie man es ohne Kränkung sagt
   und hört; was danach hilft (Nähe ohne Ziel statt Rückzug); Verweis auf die Ampel (Kurs 17) und das Lust-Menü
   (Kurs 13 L3). Praxisnäher als die bestehenden Lektionen.
6. **Kurs 23, „Schmerz und Lust“ (Spicy).** Wann Schmerz ein Warnsignal ist und wann er einvernehmlich Teil von Lust sein
   kann; Absprache, Stoppwort, Skala; Körper erkennt Grenzen anders als der Kopf; was danach hilft. Fester Verweis auf
   Kurs 5 L1 (medizinischer Schmerz) und auf die Nachsorge in Kurs 23 L3. Nur im Spicy-Modus.

## Ton und Form

Wie die bestehenden Lektionen (Länge, Aufbau, Du-Ansprache, Einladung statt Anweisung, ein Satz zum Mitnehmen).
Alle Figuren in Beispielen sind erwachsen und einvernehmlich. Keine Diagnosen; wo es medizinisch wird, ein Hinweis auf
Ärztin oder Arzt. Spicy-Inhalte nur hinter dem Spicy-Modus, Diskretion bei Titeln wie bei den anderen Kursen.

## Technischer Weg

- Texte in `tools/content/kurs_NN_*.json` und `assets/data/velvet_content.json` (wie bisher), Englisch in `_en` und
  `translations/en/`; danach `flutter test test/translation_test.dart` (Prüfsummen) und PO-Abgleich.
- Neue Inhalte: nach dem Grundsatz „Inhalte als Pakete“ prüfen, ob die Lektionen schon in ein Paket gehören. Solange
  die Kurse noch in der App liegen, bleiben auch diese Lektionen dort.
- Audio-Praxis (nur Lektion 1 und 3, falls gewünscht): mit dem Ausdrucksprofil neu einsprechen (Hörprobe vorher).
- Anleitung (`assets/data/anleitung.json`) und „Was ist neu“ nachziehen.
- Texte schreibt Claude selbst, nicht OpenCode (neue Inhaltstexte). OpenCode übernimmt später die Englisch-Fassung
  nur als Entwurf, Claude prüft.

## Offene Fragen

1. **Umfang:** alle sechs Lektionen oder nur einige? Vorschlag: zuerst 1, 2 und 5, weil sie am häufigsten gebraucht
   werden; 4 und 6 danach.
2. **Audio:** Soll es zu Lektion 1 (Nachklang) und 3 (Körperbild) eine Audio-Praxis geben, oder nur Text?
3. **Länge:** gleiche Länge wie die vorhandenen Lektionen (etwa 450 bis 650 Wörter) oder kürzer?
4. **Lektion 6:** Soll „Schmerz und Lust“ wirklich in die Spicy-Reihe, oder gehört das Thema in einen eigenen
   Spicy-Kurs? Vorschlag: in Kurs 23, weil dort Absprache und Nachsorge schon stehen.
5. **Quelle:** Die Rückmeldung ist anonym; Dank im Nostr-Beitrag (Feature-Wünsche kamen an) ja oder nein?

## Entscheidungen

Noch keine.
