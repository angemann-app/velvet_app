# Konzept: Freiwilliges „Hallo“

Stand: abgestimmt am 27.10.2026, Umsetzung als Auftrag AG-9.

## Idee

Wer mag, sagt der Entwicklerin bzw. dem Entwickler einmal anonym „Hallo“. So lässt sich grob erkennen, ob die
App irgendwo genutzt wird, ohne heimlichen Ping und ohne Tracking.

## Entscheidungen

1. **Nur auf Knopfdruck:** „Einmal anonym Hallo sagen“ im Profil, standardmäßig nichts gesendet, nie automatisch.
2. **Inhalt:** nur App-Version und Sprache. Keine Geräte-Kennung, kein Name, kein Profil, keine Nutzungsdaten.
3. **Weg:** wie die Rückmeldungen (`lib/services/rueckmeldung.dart`): NIP-17 mit Gift Wrap an das
   Rückmelde-Postfach, Einmal-Schlüssel, die Relays sehen nicht, wer schreibt.
4. **Einmal je Installation;** danach zeigt der Eintrag „Danke, gesendet am …“. Der Merker ist Teil der
   Sicherung, damit nach einer Wiederherstellung nicht doppelt gezählt wird.
5. **Offen erklärt** im Datenschutz-Abschnitt der Anleitung.
6. **Auswertung:** `tools/rueckmeldungen_abholen.dart` zählt Hallos getrennt (Anzahl je Version und Sprache)
   und gibt sie nicht als einzelne Rückmeldungen aus.
