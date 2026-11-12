# Konzept: Schutz der Privatsphäre (App-Sperre, Spicy-Dauer, Fantasie-Hinweis)

**Status:** Abgestimmt am 12.11.2026 (Entscheidungen unten), umgesetzt auf Branch `claude/privatsphaere-20261112`;
die Texte in der App sind die therapeutisch geprüfte Endfassung (ARB `appSperre…`, `fantasieHinweis…`, `spicyAbgelaufen…`),
die Tabellen unten sind der ältere Entwurf. Ergänzt `altersnachweis.md` (Schicht 2) und
`velvetpulse-produktblick` (Paar-Fallstricke). Offene Fragen am Ende.

**Maßstab:** Was jemand allein erkundet (Fantasien, Träume, Tagebuch), darf nicht versehentlich zum Vertrauensbruch
in der Beziehung werden. Zwei Wege dorthin: Mitlesen verhindern (a, b) und Fantasien einordnen (c).

## Ist-Stand

- `PrivacyService` (`privacy_lock_enabled`, Standard **aus**); `AppLock` sperrt beim Start und nach **1 Minute** im Hintergrund
  (`PrivacyService.relockAfter`). Einschalten im Profil, nur wenn `isSupported()` (Bildschirmsperre vorhanden).
- Spicy: `AlterDienst` fällt nach App-Neustart oder **30 Minuten** im Hintergrund auf „aus“ (`erneutNach`); `spicyMode()` wird
  dann `false`, die ganze App wechselt die Farben (`reassembleApplication`) und man muss neu entsperren.
- Kein Fantasie-Hinweis in der App.

## a) App-Sperre wird Standard

- **Neue Einrichtung** (`!hasCompletedOnboarding()` beim Abschluss): Sperre wird eingeschaltet, **wenn** `isSupported()`. Einmal
  Gerätesperre bestätigen (wie bisher in `setLockEnabled`, sonst sperrt man sich aus), danach kurze Karte „Nur für dich“.
  Im Profil jederzeit abschaltbar. Ohne Bildschirmsperre: Karte „Bildschirmsperre einrichten“ (Anleitung in zwei Sätzen),
  Sperre bleibt aus; beim nächsten Start nach Einrichten der Sperre wird nicht erneut aufdringlich gefragt, der Profil-Schalter
  wird dann nutzbar.
- **Bestand**: wird nicht umgestellt. Beim nächsten Start nach dem Update einmal ein freundliches Blatt mit „Ja, sperren“ /
  „Nicht jetzt“. „Nicht jetzt“ merkt sich das; die App fragt nie wieder von selbst (Profil-Schalter bleibt). Hat der Bestand
  bereits eine Sperre, kommt nichts.
- Neuer Schlüssel `app_sperre_frage_gestellt` (SharedPreferences, gerätegebunden, **nicht** in der Sicherung, wie der Altersnachweis:
  eine Sicherung auf ein anderes Gerät darf dort nicht die Sperrentscheidung übertragen).
- Dateien: `lib/services/privacy_service.dart` (`standardEinrichten()`, `frageNoetig()`), `lib/widgets/app_lock.dart` unverändert,
  neues Blatt `lib/widgets/app_sperre_frage.dart`, Aufruf aus `main.dart`/Onboarding-Ende.

Texte (ARB-Schlüssel `appSperre…`):

| Schlüssel | DE | EN |
|---|---|---|
| `appSperreNeuTitel` | Nur für dich | Just for you |
| `appSperreNeuText` | VelvetPulse öffnet sich nur mit deiner Gerätesperre – Fingerabdruck, PIN oder Muster. Im Profil kannst du das jederzeit ändern. | VelvetPulse only opens with your device lock – fingerprint, PIN or pattern. You can change this any time in your profile. |
| `appSperreNeuOk` | Gut so | Sounds good |
| `appSperreFrageTitel` | Soll VelvetPulse nur für dich aufgehen? | Should VelvetPulse open only for you? |
| `appSperreFrageText` | Dann fragt die App beim Öffnen nach deiner Gerätesperre. So liest niemand mit, wenn dein Handy mal herumliegt. | Then the app asks for your device lock when it opens. That way nobody reads along if your phone is left lying around. |
| `appSperreFrageJa` / `…Nein` | Ja, sperren / Nicht jetzt | Yes, lock it / Not now |
| `appSperreKeineTitel` | Dein Handy hat noch keine Bildschirmsperre | Your phone has no screen lock yet |
| `appSperreKeineText` | Richte in den Android-Einstellungen unter „Sicherheit“ eine PIN, ein Muster oder einen Fingerabdruck ein. Danach kannst du im Profil die App-Sperre einschalten. | In Android settings under “Security”, set up a PIN, pattern or fingerprint. After that you can turn on the app lock in your profile. |
| `appSperreKeineOk` | Verstanden | Understood |

## b) Spicy: Dauer der Entsperrung

Nur die **Dauer**, nicht das Prinzip, ändert sich. Neustart der App verlangt weiterhin Entsperren. Schutz vor Mitlesenden:
Die App-Sperre (a) greift ohnehin nach 1 Minute Hintergrund; Spicy ist die zweite Schicht für den Fall „App ist offen, Handy liegt da“.

**Variante A: längere, wählbare Frist.** `erneutNach` wird einstellbar im Profil: 30 Minuten (heute) / 2 Stunden / 12 Stunden.
Vorgeschlagener Standard: **2 Stunden**. Vorteil: einfach, vorhersehbar, kleine Änderung (`AlterDienst`, Profil-Auswahl, Schlüssel
`spicy_erneut_nach_min`). Nachteil: Wer das Handy mit offener App weglegt, ist bis zu 2 Stunden ohne zweite Hürde; das Handy-Display
sperrt der Nutzer aber ohnehin meist selbst.

**Variante B: Kopplung an das Gerät.** Spicy bleibt entsperrt, **bis der Bildschirm gesperrt wurde** (Android: Bildschirm aus /
Gerät gesperrt, über den vorhandenen Kanal `velvetpulse/privacy` oder `ACTION_SCREEN_OFF`), nicht nach einer festen Zeit. Vorteil:
Genau der Schutz, der zählt: Sobald das Handy aus der Hand ist, muss man neu entsperren; mitten in einer langen Sitzung nie.
Nachteil: neuer nativer Code (Android-Receiver), Test nur auf dem Gerät, bei kurzen Bildschirm-Aus-Pausen (Anruf, Audio mit
Bildschirm aus beim Einschlafen!) wird neu verlangt. Bei geführten Audios mit ausgeschaltetem Bildschirm muss die Wiedergabe
davon ausgenommen werden, sonst unterbricht die Gerätesperre die Einschlaf-Reise.

Empfehlung: **A mit 2 Stunden** jetzt, B später, wenn es Rückmeldungen gibt. Nutzer entscheidet (Frage 1).

## c) Fantasie-Hinweis

Ein einziger kurzer Hinweis, einmal je Gerät sichtbar, an der **ersten** der beiden Stellen, die geöffnet wird; danach nicht mehr
automatisch. Dauerhaft nachlesbar in der Anleitung (neuer Abschnitt unter „Selbst erkunden“).

- **Lust im Traum:** Blatt vor der Wahl des Gegenübers (`lust_im_traum_screen.dart`, `_gegenueber`).
- **Innenansichten** (`lust_reihe_screen.dart`): Blatt beim ersten Öffnen der Folgenliste, bei „Zu dritt“ mit einem zusätzlichen Satz.
- Gemeinsamer Merker `fantasie_hinweis_gesehen` (SharedPreferences, **in Sicherung und Backup-Merge**: wer wiederherstellt, wird
  nicht erneut belehrt; Merge: `true` gewinnt).
- Kurz, warm, kein „du solltest“, kein Appell. Ein Knopf „Verstanden“.

| Schlüssel | DE | EN |
|---|---|---|
| `fantasieHinweisTitel` | Eine Fantasie ist nur eine Fantasie | A fantasy is just a fantasy |
| `fantasieHinweisText` | Was dir hier in den Sinn kommt, ist kein Wunsch und kein Urteil über deine Beziehung. Fantasien dürfen frei sein. Du entscheidest, was du davon teilst – und wann. | What comes to mind here is not a wish and not a verdict on your relationship. Fantasies are allowed to be free. You decide what you share – and when. |
| `fantasieHinweisDrei` | Das gilt auch für Szenen zu dritt. | That includes scenes with more than two people. |
| `fantasieHinweisOk` | Verstanden | Got it |

Anleitung (`anleitung.json`, Abschnitt `selbst_erkunden` o. ä.; Titel „Fantasien sind frei“ / “Fantasies are free”): derselbe Text
plus: „Dein Tagebuch und deine Träume bleiben auf diesem Gerät. Nur was du ausdrücklich im Paar-Kanal sendest, sieht dein Gegenüber.“

Rolle Sexualtherapeut:in: prüft diese Texte nach dem OK, bevor sie in die ARB gehen. Designer:in: Blatt im bestehenden
Magazin-Look (`VpKomponenten`, `papierErhoben`, `VpRadius.karte`), Beschreibung ohne Spicy-Farben, damit der Hinweis auch
außerhalb des Spicy-Modus (Lust im Traum ist dort nutzbar?) neutral bleibt (Frage 4).

## Sicherung, Diskretion, Tests

- Sicherung: nur `fantasie_hinweis_gesehen`. Sperrschlüssel bleiben gerätegebunden (Begründung oben). `test/backup_merge_test.dart`
  ergänzen; Test, dass die Sperrschlüssel **nicht** in der Sicherung stehen.
- Diskretion: Blätter neutral, kein „Sex“/„Traum“ in Titeln, die in Systemoberflächen auftauchen (Hinweis erscheint nur in der App).
- Tests: Standard-Einrichtung mit/ohne `isSupported` (`unterstuetztFuerTest`), Bestandsfrage einmalig, Spicy-Frist-Grenzen
  (30 min / 2 h / 12 h), Hinweis erscheint genau einmal, `test/security_test.dart` bleibt grün. Screens-Test um die neuen Blätter erweitern.
- Nachziehen: `anleitung.json` + `docs/ANLEITUNG.md`, `neuigkeiten.json`, `translations/en/`, `docs/AUFGABEN.md`,
  `altersnachweis.md` (Schicht-2-Abschnitt auf den neuen Schlüssel verweisen).

## Entscheidungen (12.11.2026, Nutzer)

1. Spicy-Dauer: **5 Stunden** im Hintergrund (Variante A, Standard 5 h statt 2 h). Läuft die Frist ab, zeigt die App einen **klaren
   Hinweis, dass Spicy deaktiviert wurde** (Blatt/Snackbar beim Zurückkehren, neutral formuliert, mit Knopf „Wieder entsperren“),
   statt dass die Farben stumm umspringen. Texte folgen in der Umsetzung (`spicyAbgelaufen…`, DE/EN).

## Offene Fragen

1. ~~**Spicy-Dauer:**~~ entschieden (siehe oben); offen nur noch: Auswahl im Profil (30 min / 5 h / 12 h) oder fest 5 h? –
   Ursprüngliche Frage: **Spicy-Dauer:** Variante A (Frist wählbar, Standard 2 h) oder B (bis Bildschirm gesperrt) oder A jetzt, B später? Welche Dauer
   als Standard und welche Auswahlstufen?
2. **Neu-Einrichtung:** App-Sperre gleich am Ende des Onboardings einschalten (mit einmaliger Fingerabdruck/PIN-Abfrage)? Oder erst
   beim ersten Start danach?
3. **Bestand:** Blatt beim nächsten Start nach dem Update, oder erst beim ersten Spicy-Zugriff? Vorschlag: nächster Start, einmal.
4. **Fantasie-Hinweis:** Ein Mal insgesamt (Vorschlag) oder je Bereich einmal (Lust im Traum, Innenansichten)? Ist Lust im Traum auch
   ohne Spicy-Modus erreichbar, soll der Hinweis dort dann auch ohne Spicy-Farben erscheinen?
5. **Sicherung:** Merker `fantasie_hinweis_gesehen` in die Sicherung, Sperr-Merker nicht: einverstanden?
6. **App-Sperre-Wartezeit:** `relockAfter` bleibt 1 Minute?
