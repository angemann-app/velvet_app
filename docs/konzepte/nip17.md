# Konzept: Paar-Kanal von NIP-04 auf NIP-17

Stand: abgestimmt am 27.10.2026, noch nicht umgesetzt. Entscheidungen am Ende. Aufgabe 2 in `docs/AUFGABEN.md`.
Öffentlich angekündigt im Nostr-Beitrag vom 25.10.2026 („Moving to NIP-17 is on the list“).

## Warum

Heute verschlüsselt der Paar-Kanal mit **NIP-04** (kind 4). Das hat drei Schwächen:

1. **Metadaten:** Die Server sehen bei jeder Nachricht Absender, Empfänger, Zeitpunkt und Größe. Sie wissen also,
   dass diese zwei Schlüssel miteinander schreiben, wann und wie oft.
2. **Ein geleakter Schlüssel öffnet alles:** Wer einen privaten Schlüssel erbeutet, kann jede je gespeicherte
   Nachricht entschlüsseln, die noch auf einem Server liegt.
3. **Veraltetes Verfahren:** NIP-04 nutzt AES-CBC ohne Integritätsschutz und gilt in der Nostr-Welt als
   überholt. Viele Programme zeigen es nur noch mit Warnung an.

**NIP-17** (private Direktnachrichten) löst 1 weitgehend und verbessert 3:

- Verschlüsselung mit **NIP-44** (ChaCha20 + HMAC-SHA256, mit Längen-Auffüllung, damit die Größe weniger verrät).
- **Gift Wrap** (NIP-59): Die eigentliche Nachricht steckt, signiert vom echten Absender, in einem „Siegel“
  (kind 13), und das Siegel in einer Hülle (kind 1059), die mit einem **frischen Wegwerf-Schlüssel** signiert
  ist. Die Server sehen nur „irgendwer schreibt an diesen Empfänger“; der Absender und der echte Zeitpunkt
  sind verborgen (der Zeitstempel der Hülle wird zufällig um bis zu zwei Tage zurückgesetzt).

Ehrlich bleiben: Auch NIP-17 hat **keine Vorwärtssicherheit**. Wer den privaten Schlüssel des Empfängers hat,
kann alte Hüllen weiterhin öffnen. Was sich ändert: Ohne Schlüssel ist nicht mehr zu sehen, wer mit wem
schreibt. Der Satz aus der Nostr-Antwort („one leaked key should not unlock the whole history“) wird erst mit
späteren Verfahren (z. B. MLS, NIP-EE) ganz erfüllt; das bleibt ein eigenes, späteres Thema.

## Was umgestellt wird

| Heute | Neu |
|---|---|
| Chat, Funken, Ja/Nein-Stimmen, Lektionen, Reflexionen, Spicy-Einladung, Foto-Angebote: kind 4, NIP-04 | kind 14 (Rumor) in Siegel und Hülle, NIP-44 |
| Lesebestätigung: kind 30078 (ersetzbar), NIP-04 | bleibt kind 30078, Inhalt NIP-44 (Zeitpunkt und Paar bleiben dort sichtbar, siehe Frage 3) |
| Flüchtige Signale der Fotos: kind 21555, NIP-04 | bleibt kind 21555, Inhalt NIP-44 (siehe Frage 3) |
| Rückmeldungen ans Postfach: kind 4, NIP-04, Einmal-Schlüssel | NIP-17 an das Postfach (siehe Frage 4) |

Die Nachrichteninhalte selbst (JSON mit `type`, `text`, `vote` …) bleiben gleich. Nur die Verpackung ändert sich.

## Übergang ohne dass sich Paare verlieren

**Stufe 1 (eine Beta, dann stabil):**
- Die App **versteht beide Verfahren** beim Empfangen, immer.
- Sie **kündigt an**, was sie kann: Jede Nachricht, die sie noch per NIP-04 schickt, trägt zusätzlich das Feld
  `"nip17": 1` im verschlüsselten Inhalt (ältere Versionen ignorieren unbekannte Felder, eine eigene
  Nachrichtenart könnte dort als Text auftauchen). Dazu ein flüchtiges Signal `{"t": "faehig", "nip17": 1}`
  beim Start, damit es auch ohne Chatnachricht schnell geht (ältere Versionen ignorieren unbekannte Signale).
- Sie **sendet NIP-17 erst**, wenn vom Gegenüber eine solche Ankündigung kam (gespeichert pro Paar). Sonst
  bleibt sie bei NIP-04. Kommt eine NIP-17-Nachricht vom Gegenüber, gilt das ebenfalls als Ankündigung.
- Neue Kopplungen zwischen zwei neuen Versionen sind damit nach der ersten Nachricht auf NIP-17.

**Stufe 2 (späteres Release):** NIP-04 beim Senden ganz abschalten, beim Empfangen noch eine Weile lesen
(alte Nachrichten auf den Servern, Rückfall), danach entfernen. **Frühestens fünf stabile Versionen nach
Stufe 1**, weil Updates nur angeboten und nie erzwungen werden; vorher bleibt der Rückfall auf NIP-04.

## Technik

- **NIP-44 selbst umsetzen** (rund 150 Zeilen): ECDH über secp256k1 (`kepler`, schon im Projekt über
  `nostr_tools`), HKDF, ChaCha20, HMAC-SHA256 (`cryptography`, schon im Projekt). Geprüft gegen die
  **offiziellen Testvektoren** von NIP-44 (`test/nip44_test.dart`). Keine neue Abhängigkeit.
- **NIP-59/NIP-17**: Rumor (unsigniert) → Siegel kind 13 (signiert vom echten Schlüssel, NIP-44 an den
  Empfänger) → Hülle kind 1059 (frischer Schlüssel, NIP-44, `p`-Tag Empfänger, Zeitstempel zufällig bis zu
  zwei Tage zurück). Jede Nachricht geht zweimal raus: an das Gegenüber und an sich selbst (damit der eigene
  Verlauf auf einem neuen Gerät wiederherstellbar wäre; optional, siehe Frage 5).
- **Prüfen eingehender Events** (`NostrEventCheck`, Pflicht laut `CLAUDE.md`): Hülle (Signatur, kind 1059,
  `p` = ich), Siegel (Signatur, kind 13, Absender = Partner), Rumor (Absender = Siegel-Absender). Alles andere
  wird verworfen.
- **Abholen:** Weil die Zeitstempel der Hüllen bis zu zwei Tage zurückliegen, holt die App kind 1059 ab
  „letzter Stand minus zwei Tage“; doppelte Nachrichten fallen über die id der Rumor heraus. Der echte
  Zeitpunkt steht in der Rumor.
- **Server:** Die fünf Server bleiben. `tools/relays_pruefen.dart` prüft zusätzlich, ob sie kind 1059 annehmen
  und ausliefern. NIP-17 empfiehlt eigene Postfach-Server (kind 10050); bei unserem festen Serverkreis ist das
  nicht nötig.
- **Tests:** NIP-44-Testvektoren; Hin- und Rückweg Gift Wrap; Aushandlung (neu ↔ neu, neu ↔ alt, Rückfall);
  gefälschte Hüllen/Siegel werden verworfen; `test/security_test.dart` und `test/paar_kanal_test.dart` bleiben
  grün; Live-Test in `test_live/relay_live_test.dart`.

## Aufwand

Mittel bis groß: NIP-44 mit Testvektoren, Gift Wrap, Aushandlung, Umbau von `nostr_service.dart` (Senden,
Abo, Empfang), Tests. Eher eine Aufgabe für Opus. Danach eine Beta und ein Test auf zwei Handys mit einer
alten und einer neuen Version.

## Entscheidungen (27.10.2026)

1. **Übergang:** Stufe 1 wie beschrieben: beides verstehen, NIP-17 erst senden, wenn das Gegenüber es angekündigt hat.
2. **Stufe 2** (NIP-04 nicht mehr senden) erst, wenn wirklich alle umgestellt sind: frühestens **fünf stabile
   Versionen** nach Stufe 1, weil Updates nur angeboten werden.
3. **Signale und Lesebestätigungen** (Entscheidung Claude): nur auf NIP-44 umstellen, keine Hüllen. Signale sind
   flüchtig und zeitkritisch (Foto-Übertragung); eine Hülle je Signal brächte wenig und bremst. Lesebestätigungen
   sind ersetzbare Events (kind 30078) und brauchen ihren festen Absender. Sichtbar bleibt dort, dass dieses Paar
   aktiv ist; die Inhalte sind geschützt. NIP-44 nur, wenn das Gegenüber NIP-17 angekündigt hat, sonst NIP-04.
4. **Rückmelde-Postfach** wird mit umgestellt; das Abhol-Skript liest beides.
5. **Keine Kopie an sich selbst** (Entscheidung Claude), solange es keine Wiederherstellung über die Server gibt:
   halber Datenverkehr, weniger auf den Servern.
