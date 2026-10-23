# Sicherheits-Audit v4.2.0+17: Baseline und Ergebnis

Stand: 23.10.2026. Teil 1 ist die Baseline vor den Änderungen, Teil 2 das Ergebnis der Fixes
(Produktentscheidung zu A: Schlüssel nur mit Passwort in eine Sicherung).

## Teil 2: Ergebnis

| Befund | Status | Wo |
|---|---|---|
| A: Geheimnisse im Klartext | **behoben** (Gerätetest offen) | `lib/services/secret_store.dart`, `backup_codec.dart`, `storage_service.dart:325-460`, `res/xml/*_rules.xml` |
| B: Auto-Restore externer Dateien | **behoben** | `lib/services/auto_backup_service.dart`, `backup_codec.dart` (`validate`), `storage_service.dart` (`importBackup`) |
| C: Nostr-Events ungeprüft | **behoben** | `lib/services/nostr_event_check.dart`, `nostr_service.dart:412-431` |
| Zusatz: KI-Key in URL, Modell-Cache | **behoben** | `lib/services/ai_service.dart` (Header `x-goog-api-key`, Cache an Key gebunden) |
| Zusatz: Produkttexte | **behoben** | KI-Coach-Hinweise (Daten gehen an Google), README-Datenschutztabelle |
| Zusatz: Update-Integrität | **offen**, kein akuter Fix | Updates sind durch Androids Signaturprüfung geschützt; eine unabhängige Signatur der Releases wäre der nächste Schritt |

### Was geändert wurde

- **A – Geheimnisse:**
  - API-Key und privater Nostr-Schlüssel liegen jetzt in `flutter_secure_storage` 11.2.0 (Android-Keystore,
    RSA-OAEP-gesicherter AES-GCM-Schlüssel).
  - Die Dateien dieses Speichers sind vom Cloud-Backup und von der Geräteübertragung ausgeschlossen.
  - Beim ersten Start einer neuen Version wird der Altbestand aus den SharedPreferences einmalig umgezogen. Der
    Klartext wird erst gelöscht, wenn das sichere Speichern geklappt hat.
  - Der öffentliche Nostr-Schlüssel wird immer aus dem privaten abgeleitet.
  - Das Backup-Schema 2 enthält keine Geheimnisse. Ein optionaler Block `secrets` ist mit dem Passwort
    verschlüsselt (PBKDF2-HMAC-SHA256 mit 210 000 Runden, AES-256-GCM, zufälliges Salt und zufällige Nonce).
    Das Passwort steht nicht in der Datei. Ein falsches Passwort oder manipulierte Daten scheitern an der
    GCM-Prüfung.
  - Alte Klartext-Sicherungen (Schema 1) werden erkannt, mit Warnung angezeigt und bleiben einspielbar.
- **B – Import:**
  - Automatisch wird nur noch die private Sicherung im App-Speicher gelesen.
  - Jeder Import wird zuerst vollständig geprüft:
    - Schema-Version, Feldtypen und Größengrenzen (Datei ≤ 2 MB, Listen ≤ 5000, Strings ≤ 200 000),
    - private Schlüssel als Skalar zwischen 1 und n−1,
    - ob öffentlicher und privater Schlüssel zusammenpassen,
    - Partner-Schlüssel als Hex.
  - Danach wird alles vorbereitet und dann geschrieben. Scheitert ein Schreibvorgang, wird der vorherige Stand
    wiederhergestellt.
  - Die Paar-Verbindung wird nur übernommen, wenn der eigene Schlüssel mitkommt oder die Sicherung von genau
    diesem Schlüssel stammt.
- **C – Nostr:**
  - Ein Event wird erst verarbeitet, wenn Folgendes stimmt:
    - Format und Größen,
    - die ID als SHA-256 der kanonischen Serialisierung (`EventApi.getEventHash`),
    - die BIP-340-Signatur (`EventApi.verifySignature`),
    - der p-Tag an den eigenen Schlüssel,
    - ein Zeitstempel nicht mehr als 10 Minuten in der Zukunft,
    - der Absender ist der Partner.
  - Erst danach wird die ID als verarbeitet gemerkt.
  - Relay-Nachrichten über 256 KB werden nicht geparst.
- **Gates:**
  - `tools/release.ps1` bricht ab, wenn `flutter test` fehlschlägt.
  - `.github/workflows/tests.yml` führt `flutter analyze` (nur Fehler fatal) und `flutter test` bei jedem Push aus.

### Tests (tatsächlich ausgeführt)

Umgebung: Flutter 3.47.7, Windows 11. Befehle: `flutter test`, `flutter analyze lib test` und
`flutter build apk --release --split-per-abi`.

- `flutter test`: **22 Tests, alle bestanden**. Davon sind 13 neu in `test/security_test.dart`:
  - **A:**
    - Umzug aus den SharedPreferences in den sicheren Speicher.
    - Kein API-Key und kein privater Schlüssel in Backup oder Auto-Backup.
    - Export mit Passwort: ein falsches Passwort und ein verändertes Byte im Chiffretext werden abgelehnt.
    - Kompletter Umzug auf ein „neues Gerät“ mit Passwort.
    - Keine scheinbare Paar-Verbindung ohne Schlüssel.
  - **B:**
    - Zwölf ungültige Sicherungen, darunter kein JSON, ein fremder App-Marker, ein unbekanntes Schema, falsche
      Typen, Übergrößen, ein ungültiger Partner-Schlüssel und kaputte `secrets`.
    - Ungültige private Schlüssel: 0, ≥ n, kein Hex, falsche Länge.
    - Eine alte Klartext-Sicherung wird eingespielt.
    - Bei nicht zusammenpassenden Schlüsseln bricht der Import ab, alle SharedPreferences sind unverändert.
  - **C:**
    - Ein gültiges Event wird angenommen, ein Duplikat nur einmal verarbeitet.
    - Manipulierter Inhalt, `created_at`, ID, Signatur, fehlende Signatur, Zeit als Text, Zukunft und ein
      falscher Empfänger werden verworfen.
    - Ein gültig signiertes Event eines Fremden wird verworfen.
    - Ein ungültiger Vorläufer mit derselben ID blockiert das echte Event nicht.
- `flutter analyze`: keine Fehler, nur die drei alten Warnungen (unbenutzte Variablen).
- Release-Build: erfolgreich. Damit sind Kotlin, Manifest und Backup-XML von Gradle verarbeitet.

### Rest-Risiko und offene Prüfungen

- **Nicht auf einem Gerät getestet** (kein Handy und kein Emulator verbunden):
  - der Umzug in den Keystore auf einer installierten 4.2.0 mit echter Paar-Verbindung,
  - das Verhalten nach einer Cloud-Wiederherstellung,
  - die Dialoge für Export und Import.

  Das sollte vor einer stabilen Version auf dem Handy geprüft werden.
- **Nach einer Wiederherstellung aus Googles Cloud-Backup** fehlen API-Key und Nostr-Schlüssel. Das ist gewollt.
  Der Paar-Kanal muss dann neu gekoppelt werden, außer man nutzt die Sicherung mit Passwort.
- **Die übrigen Nutzerdaten** (Profil, Tagebuch, Reflexionen, Chat-Verlauf) liegen weiter unverschlüsselt im
  privaten App-Speicher und im Cloud-Backup. Andere Apps können sie nicht lesen, wer Zugriff auf das
  Google-Konto oder ein gerootetes Gerät hat, schon.
- **Das Passwort für die Sicherung ist so stark wie seine Wahl** (mindestens 8 Zeichen). Gegen Raten hilft nur
  die langsame Schlüsselableitung.
- **Die Verbindungsanfrage bei einer offenen Einladung** kann jeder auslösen, der den Code kennt. Schutz ist
  das ausdrückliche „Annehmen“.

### Release-Empfehlung

**Zuerst als Beta auf das eigene Handy, dann stabil.** Die Unit-Tests sind grün, entscheidend ist aber der
einmalige Umzug der Schlüssel auf echten Geräten. Ein akuter Hotfix für Stabil ist nach den Tests nicht nötig:
- Befund A betrifft vor allem Sicherungen, die der Nutzer selbst weitergibt.
- Befund B ist ab Android 11 kaum auszunutzen.
- Befund C erlaubt keine gefälschten neuen Nachrichten.

---

## Teil 1: Baseline (vor den Änderungen)

## Umgebung und Ausgangslage

| | |
|---|---|
| Flutter | 3.47.7 (stable), Windows 11 |
| Branch / Commit | `main` / `8d58a8b` |
| Arbeitsbaum | sauber (bis auf diesen Bericht) |
| Abstand zu `v4.2.0+17` | 1 Commit: Beta 4.3.0-beta.1 „Partner einladen“ (9 Dateien, +311/−2). Betrifft `nostr_service.dart` (Einladung, Code-Erkennung), nicht Backup oder Updater. |
| `flutter test` | ausgeführt: 9 Tests, alle bestanden (startup, paar_abend, update_channel, invite) |
| `flutter analyze` | keine Fehler; nur alte Warnungen (unbenutzte Variablen) und Stil-Hinweise |
| Gerätetests | keine. Android-Backup, Geräteübertragung und Update-Signatur nicht auf dem Gerät geprüft. |

Es gibt bisher **keine** Tests für Backup/Import, Auto-Restore oder den Nostr-Empfang.

## Befund A: Geheimnisse im Klartext-Backup – **bestätigt**

- `lib/services/storage_service.dart:335-361` `exportAllUserData()` enthält `apiKey`, `nostrPrivKey` und `nostrPubKey` im Klartext.
- `lib/services/auto_backup_service.dart:81-109` schreibt das als JSON in den privaten App-Speicher.
- Der Knopf „Backup exportieren“ (`onboarding_screen.dart`) legt dasselbe JSON in die Zwischenablage.
- `android/app/src/main/res/xml/backup_rules.xml` und `data_extraction_rules.xml` schließen `sharedpref`, `database` und `file`
  für Cloud-Backup und Geräteübertragung ein, `allowBackup="true"`.
- **Ergänzung:** API-Key und Nostr-Schlüssel liegen auch in den SharedPreferences selbst. Nur `file` auszuschließen
  reicht also nicht.
- **Warum es so gebaut ist:** Genau dieser Export hat beim Umstieg auf den Release-Schlüssel die Verbindung im
  Paar-Kanal und den API-Key über die Neuinstallation gerettet. Ein Fix muss das ersetzen, nicht nur streichen.

## Befund B: Automatische Wiederherstellung externer Dateien – **bestätigt**

- `main.dart` ruft beim Start `AutoBackupService.checkAndAutoRestore()` auf.
- Ist die App noch nicht eingerichtet, liest diese Methode (`auto_backup_service.dart:45-78`) neben dem privaten Pfad auch
  `Android/data/…`, `Documents/VelvetPulse`, `Documents` und `Download`.
- Einzige Prüfung ist `parsed['app'] == 'VelvetPulse'`, danach folgt ohne Rückfrage `importUserData()`.
- `importUserData()` (`storage_service.dart:363-488`):
  - Es ist nicht atomar und schreibt Feld für Feld. Bricht es mittendrin ab, ist der Zustand halb überschrieben.
  - Die Nostr-Schlüssel werden nur auf Länge 64 geprüft. Ob es gültiges Hex ist und ob der öffentliche Schlüssel zum
    privaten passt, wird nicht geprüft. `NostrService.init()` übernimmt einen gespeicherten öffentlichen Schlüssel
    ungeprüft.
  - Es gibt keine Grenzen für Größe, Listen oder Strings und keine Schema-Version (`version` ist fest `'4.0.0'`).
- **Ob das auf einem Gerät ausnutzbar ist, bleibt offen.** Ab Android 11 darf die App fremde Dateien in `Download`
  meist gar nicht lesen. Die Rechte enden bei `READ_EXTERNAL_STORAGE maxSdk 32`.
- **Beobachtet am Gerät des Entwicklers:** Im Download-Ordner liegt eine alte `velvetpulse_backup.json` einer frühen
  Version, also genau so eine Datei.

## Befund C: Keine Prüfung eingehender Nostr-Events – **bestätigt, mit Einordnung**

- `nostr_service.dart` `_handleIncomingKind4Map()` merkt sich die Event-ID in `_processedEventIds`, **bevor**
  irgendetwas geprüft ist. Es gibt weder eine Neuberechnung der ID noch eine Signaturprüfung.
- **Bibliothek `nostr_tools 1.0.9`:**
  - `EventApi().getEventHash(Event)` und `EventApi().verifySignature(Event)` sind vorhanden (`impl/event_impl.dart`).
  - Achtung: Der Parameter `verify` im `Event`-Konstruktor ist **wirkungslos**, die Prüfung dort ist auskommentiert
    (`models/event.dart:56-65`). Man muss also selbst prüfen.
- **Einordnung der Folgen:**
  - Der Inhalt ist NIP-04-verschlüsselt mit einem Schlüssel aus Absender- und Empfängerschlüssel. Eine **neue**
    Nachricht „vom Partner“ kann ohne einen der privaten Schlüssel niemand fälschen, denn sie würde sich nicht
    entschlüsseln lassen.
  - Möglich ist aber:
    1. Ein Relay oder Angreifer kann eine echte Nachricht mit verändertem `created_at` oder neuer ID erneut
       einspielen. Sie erscheint dann doppelt oder mit falscher Zeit, und ein Fantasie-Vote kann wiederholt werden.
    2. Ein ungültiges Event mit der ID einer echten Nachricht kann diese vorab „verbrauchen“, sodass die echte
       Nachricht verworfen wird.
- **Ergänzung für die Beta 4.3.0-beta.1:**
  - Ist eine Einladung offen, erscheint jede entschlüsselbare Nachricht an den eigenen Code als
    Verbindungsanfrage. Das kann jeder auslösen, der den Code kennt, denn man kann mit dem eigenen Schlüssel an
    jeden Code verschlüsseln.
  - Abgefangen wird das nur durch das ausdrückliche „Annehmen“. Das sollte im Fix-Block mitbedacht werden.
- **Nebenbefund:** Jede Relay-Antwort setzt den Status auf „verbunden“ (`nostr_service.dart:377`). Das zeigt nur, dass
  die Leitung steht, nicht dass etwas authentifiziert ist. Der Text in der App lautet derzeit
  „verbunden & verschlüsselt“.

## Zusatzbefunde

- **Update-Integrität:**
  - Die Einschätzung stimmt, APK und `.sha256` kommen aus derselben Quelle.
  - Ergänzung: Android installiert ein **Update** nur, wenn es mit demselben Schlüssel signiert ist wie die
    installierte App. Ein manipuliertes Release mit fremdem Schlüssel würde also beim Aktualisieren abgelehnt.
    Das hat sich heute beim Schlüsselwechsel genau so gezeigt.
  - Für **Erstinstallationen** über den Einladungslink gilt das nicht: Dort wird dem ersten Download vertraut.
- **KI-Key in der URL:** bestätigt.
  - `ai_service.dart:29` hängt beim Abruf der Modell-Liste `?key=` an die URL. Die eigentlichen Anfragen
    (Paket `google_generative_ai`) laufen nicht über diese Stelle.
  - Die Modell-Liste `_cachedWorkingModels` ist nicht an den Key gebunden, nach einem Fehler wird die Liste des
    alten Keys zurückgegeben (Zeile 88).
  - An Google gehen Profil (Name, Geschlecht, Alter, Beziehungsstatus, Fokus) und die letzten 10 Nachrichten.
- **Datenschutztext:** muss nach den Fixes an die tatsächlichen Backup-Orte angepasst werden.

## Was vor den Fixes entschieden werden muss

Nur Befund A braucht eine Produktentscheidung. B und C lassen sich ohne spürbare Verhaltensänderung beheben,
außer dass Dateien aus `Download` und `Documents` nicht mehr automatisch eingelesen werden.

**Empfehlung für A:**
1. API-Key und privaten Nostr-Schlüssel aus den SharedPreferences in einen per Android-Keystore verschlüsselten
   Speicher verschieben. Der Speicher wird vom Cloud-Backup und von der Geräteübertragung ausgeschlossen, alle
   anderen Daten bleiben im Backup. Die Migration beim ersten Start einer neuen Version ist einmalig und automatisch.
2. Das automatische Backup und der normale Export enthalten keine Geheimnisse mehr. Ein Backup bekommt eine
   Schema-Version.
3. Ein **Export mit Passwort** wird neu angeboten: Die Geheimnisse werden mit einem selbst gewählten Passwort
   verschlüsselt (Schlüsselableitung plus AES-GCM). Das Passwort steht nicht in der Datei. So bleibt der Umzug auf
   ein neues Handy möglich.
4. Alte Klartext-Backups bleiben importierbar, aber nur über den manuellen Import, mit einem Hinweis, dass sie
   Geheimnisse im Klartext enthalten.

**Kompatibilität mit Stabil und Beta:**
- Neue Backups sind für ältere Versionen lesbar. Die geheimen Felder fehlen dann einfach, und ein verschlüsselter
  Block wird ignoriert.
- Der Wechsel zwischen den Kanälen bleibt ohne Datenverlust möglich.
