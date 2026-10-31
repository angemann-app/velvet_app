# Konzept: Wünsche und Fantasie-Landkarte zusammenführen

Stand: Entwurf vom 31.10.2026, noch nicht abgestimmt. Anlass: Rückfrage des Nutzers, ob sich die Landkarte und die
Wünsche-Liste im Tab „Wünsche“ des Paar-Kanals widersprechen. Baut auf `heute-und-produktschliff.md` auf (Tab „Wir“).

## Befund (im Code geprüft)

Im Tab „Wünsche“ (`couples_channel_screen.dart`, `_buildWishesTab`) stehen untereinander:

1. ein Erklärtext, die geführten Audios für Paare und die Karte **Fantasie-Landkarte** (öffnet `YesNoMaybeScreen`);
2. bei Treffern ein **Treffer-Banner**;
3. **zwölf Schnell-Wünsche** (`match_cards` in `velvet_content.json`, z. B. „Hingabe unter der Augenbinde“,
   „Flüstern im Dunkeln“, „Halbschlaf-Löffelchen am Morgen“), jeder mit zwei Knöpfen **Ja gerne** und **Lieber nicht**.

Beide Teile benutzen **denselben Speicher und denselben Weg**: Die Landkarte liest und schreibt ihre Antworten über
`myFantasyVotesNotifier` und `sendFantasyVote` und gleicht über `syncAllYesNoMaybeVotes` ab, genau wie die Schnell-Wünsche.
Der Unterschied liegt nur in Umfang und Bedienung:

| | Landkarte | Schnell-Wünsche |
|---|---|---|
| Umfang | viele Einzelfragen in mehreren Bereichen | zwölf ganze Szenen („Abende“) |
| Antworten | Ja, Vielleicht, Nein | Ja gerne, Lieber nicht |
| Allein ausfüllbar | ja, später abgleichen | ja, Treffer erst bei beiden Ja |
| Treffer | im Landkarten-Screen | Banner im Tab Wünsche |

Für Nutzer wirkt das wie zwei Orte für dasselbe, mit verschiedenen Wörtern. Das ist der Widerspruch.

## Vorschlag

1. **Eine Antwortskala überall:** Ja, Vielleicht, Nein (die Landkarte hat sie schon, „Vielleicht“ fehlt den Schnell-Wünschen).
   Die Wörter „Ja gerne“ und „Lieber nicht“ entfallen oder werden auch in der Landkarte verwendet (offene Frage 1).
2. **Aufbau des Tabs:** oben **Treffer** (Banner, aus beiden Quellen zusammen), darunter die Karte **Fantasie-Landkarte**
   als Haupteinstieg, darunter der Block **Zum Einstieg** mit den zwölf Szenen, jetzt mit den drei Antworten.
3. **Technisch nichts Neues:** Gespeichert und gesendet wird weiter über dieselben Stimmen. Es ändern sich nur Oberfläche und
   Wörter. Rückwärtskompatibel: Eine Stimme „yes“ bleibt „yes“, „no“ bleibt „no“, „maybe“ kommt für die Szenen hinzu
   (ältere Geräte zeigen sie als „nicht beantwortet“, bis sie aktualisiert sind; vorher prüfen, ob `NostrEventCheck` den
   Wert „maybe“ für Szenen schon akzeptiert).
4. **Beschriftung:** Die zwölf Szenen heißen „Einstiegs-Wünsche“ oder „Abende zum Ausprobieren“, damit klar ist, dass sie
   ganze Szenen sind und die Landkarte einzelne Dinge abfragt.
5. **Treffer an einer Stelle:** Das Banner zählt Treffer aus Landkarte und Szenen zusammen und führt zur jeweiligen Quelle.

## Nicht Teil dieses Schritts

- Neue Inhalte oder Fragen. Die zwölf Szenen und die Landkarte bleiben, wie sie sind.
- Änderungen am Protokoll (Nostr-Ereignisse) und an der Verschlüsselung.

## Offene Fragen

1. Welche Wörter für die Antworten? Ja / Vielleicht / Nein (nüchtern, wie in der Landkarte) oder weichere Formulierungen
   („Ja, gern“, „Vielleicht“, „Lieber nicht“) in beiden Teilen?
2. Soll „Vielleicht“ bei den Szenen für einen Treffer zählen (z. B. „Ja“ bei ihr, „Vielleicht“ bei ihm = „Besprechen“), oder
   zählt nur Ja und Ja?
3. **Spicy-Modus:** Die Szenen und Teile der Landkarte sind deutlich. Gelten sie schon heute nur im Spicy-Modus, oder sind sie
   immer sichtbar? Nach den festen Regeln gehören sie hinter den Spicy-Modus; vor der Umsetzung klären, was jetzt gilt.
4. Heißt der Tab „Wünsche“ weiter so, oder „Gemeinsam entdecken“ (passt besser zur Landkarte)?

## Entscheidungen

Noch keine.
