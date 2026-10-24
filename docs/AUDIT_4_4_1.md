# Audit 4.4.0+29 → 4.4.1 (veröffentlicht als Teil von 4.5.0-beta.1+30)

> **Hinweis:** 4.4.1 wurde nie einzeln veröffentlicht. Die Änderungen unten stecken zusammen mit der
> englischen Fassung in `v4.5.0-beta.1+30`. Die Prüfung dieser Beta steht im zweiten Teil
> [„Beta-Prüfung 4.5.0-beta.1“](#beta-prüfung-450-beta1) am Ende.

## Teil 1: Audit-Änderungen (geplant als 4.4.1)

Grundlage: externer Prüfauftrag zu v4.4.0+29. Jeder Punkt wurde zuerst am Code geprüft; die Befunde
unten sind die tatsächlich bestätigten. Format: **Finding → Test → Fix → Regression-Test → CI-Gate**.

Ausgangsstand: `main` = Tag `v4.4.0+29` (c8aabe5), sauberer Arbeitsbaum, CI-Workflow „Tests“ für diesen
Commit erfolgreich (GitHub Actions, 24.10.2026).

## Befunde

### P1-1 Erektionsprobleme: Morgenerektionen zu kategorisch gedeutet (Lektion `pain_2`)
- **Finding:** „Wenn morgendliche Erektionen … normal sind, liegt die Ursache meist im Kopf oder in der
  Situation.“ Das schließt körperliche Ursachen zu stark aus. Außerdem „Jeder Mann erlebt …“ und eine
  Abklärung erst, „wenn sie häufiger auftreten“.
- **Test:** Textsuche über alle Lektionen, Glaubenssätze und SOS-Karten (Skript im Arbeitsverlauf).
- **Fix:** Morgenerektionen als *möglicher Hinweis*; körperliche Ursachen ausdrücklich nicht ausgeschlossen,
  oft wirkt beides zusammen; Abklärung bei anhaltenden, wiederkehrenden oder belastenden Beschwerden.
- **Regression-Test / CI-Gate:** `test/translation_test.dart` erzwingt die englische Fassung jeder Änderung
  (Prüfsumme). Inhaltliche Richtigkeit ist nicht automatisch prüfbar → manuelle Durchsicht.

### P1-2 Schmerzen: „die Frau bestimmt alles“ (Lektionen `pain_1`, `pos_3`)
- **Finding:** Geschlechtsspezifische Formulierung; Abbruch und Pause nicht ausdrücklich als legitim benannt.
- **Fix:** „Die Person, die Schmerzen hatte, bestimmt alles: ob, wann, wie tief, wie schnell.“ Ergänzt:
  Schmerzen müssen nicht ausgehalten werden, auch nicht dem Gegenüber zuliebe; Pause, Abbruch oder andere
  Nähe sind jederzeit in Ordnung. Abklärung auch bei starken oder wiederkehrenden Schmerzen. Einstieg
  inklusiv („Viele Menschen …, besonders häufig Frauen und andere Menschen mit Vulva“). In `pos_3`
  (ausdrücklich ein Szenario mit Vulva und Penis) bleibt die Szene, der Grundsatz ist neutral formuliert.
- **CI-Gate:** wie P1-1.

### P1-3 Physiologie als gesichert dargestellt (Kurs 22, `anat_2`–`anat_4`)
- **Finding:** (a) Vagusnerv im Ohr als *Ursache* für das wohlige Gefühl; (b) Kreuzbein „aus demselben
  Abschnitt des Rückenmarks“ als Wirkmechanismus; (c) eine einzelne Hirnscan-Studie als allgemeine Tatsache;
  (d) C-taktile Fasern „beruhigen“.
- **Fix:** (a) Innervation belegt, Erklärung des Empfindens ausdrücklich offen; (b) als Nachbarschaft
  beschrieben, Zusammenhang „nicht belegt“; (c) „kleine Studie … ein Hinweis, kein Beweis, dass es allen so
  geht“; (d) „in Studien als besonders angenehm beschrieben, viele empfinden sie als beruhigend“.
- **Stichprobe weiterer Kurse:** zwei Glaubenssätze vereinfachten zu stark und wurden entschärft
  (`belief_female_body`: „entzieht dem Körper das Blut“; `belief_non_concordance`: „Zeitversatz“ und
  „wegen Rest-Adrenalin“). Unverändert, weil belegt oder ausreichend vorsichtig: Ejakulationsreflex im
  unteren Rückenmark (`touch_m_5`), Herzgesundheit bei Erektionsproblemen (`phase_3`).
- **CI-Gate:** wie P1-1. Die geänderten Lektionen sind neu eingesprochen.

### P1-4 Geführte Audios: Abbruch und Freiwilligkeit nicht deutlich genug (Selbsterkundung, Gemeinsamer Abend)
- **Finding:** Pausieren/Überspringen/Beenden gab es, aber nur als unbeschriftete Symbole; der große
  Pause-Knopf war für Screenreader unsichtbar (GestureDetector ohne Semantik). Kein Hinweis vor dem Start,
  dass nichts passieren muss.
- **Fix:** Gemeinsamer Baustein `lib/widgets/player_steuerung.dart` mit sichtbaren Beschriftungen
  („Beenden“, „Pause/Fortsetzen“, „Überspringen“) und Screenreader-Bezeichnungen. Vor der Selbsterkundung
  ein ruhiger Hinweis: Du bestimmst; nichts muss passieren; bei einer nicht sexuellen Berührung zu bleiben
  ist genauso richtig; bei Unbehagen oder schwierigen Erinnerungen darf man jederzeit aufhören. Vorzeitiges
  Beenden (Knopf oder Zurück-Taste mit Rückfrage) stoppt Stimme, Klangschale und Klangteppich sofort (Code
  geprüft, `_beenden`).
- **Regression-Test:** `test/player_steuerung_test.dart` (Beschriftungen, Semantik-Bezeichnungen/Tooltips,
  Rückrufe, Zustand pausiert).
- **CI-Gate:** `flutter test` in `.github/workflows/tests.yml` und vor jedem Release in `tools/release.ps1`.

### P1-5 Datenschutz-Hinweise zum Paar-Kanal zu optimistisch
- **Finding:** App, README und TESTER.md sagten sinngemäß „die Server sehen nur, *dass* geschrieben wird“.
  Tatsächlich sichtbar: öffentliche Schlüssel von Absender und Empfänger (p-Tag), `created_at`, Größe des
  verschlüsselten Inhalts, Art des Events (4 bzw. 30078 für Lesebestätigungen), IP-Adresse. Der
  Startbildschirm nannte außerdem die Update-Suche (GitHub) nicht als Internetzugriff.
- **Fix:** Texte in `couples_channel_screen.dart` (Info-Dialog), `onboarding_screen.dart`, `README.md`,
  `docs/TESTER.md` präzisiert.
- **CI-Gate:** keines automatisch (Text); Bestandteil dieser Durchsicht.

### P1-6 Nostr-Verarbeitung (geprüft, kein neuer Fehler)
- Geprüft im Code: ID-Hash, Schnorr-Signatur, p-Tag, Zeitstempel, Größenlimits (`NostrEventCheck`);
  Absender = Partner; ohne Kopplung nur bei offener Einladung; Duplikate über Event-ID, ungültige Events
  blockieren keine echten; Partnerwechsel/Trennen löscht Verlauf, Stimmen, Reflexionen, Lesestatus;
  ältere Stimmen überschreiben keine neueren; nicht erreichbare Relays werden einzeln mit Backoff neu
  versucht, Senden ohne Verbindung meldet einen Fehler (keine Warteschlange).
- **Ergänzter Regression-Test:** manipulierte Lesebestätigungen (anderer Inhalt, falsche Signatur, falsche
  Event-Art) werden verworfen (`test/lesebestaetigung_test.dart`). Bestehend: `security_test.dart` Gruppe C,
  `paar_kanal_test.dart`, `lesebestaetigung_test.dart`.
- **Benachrichtigungen:** ohne Inhalt und Namen („Neue Nachricht(en)“, im Diskretions-Modus „Pulse“),
  Sichtbarkeit `secret` auf dem Sperrbildschirm, eine einzige Benachrichtigungs-ID (mehrere Nachrichten
  ersetzen sich), Löschen beim Öffnen des Paar-Kanals. Nicht automatisiert prüfbar: tatsächliche Anzeige,
  WorkManager-Takt, Hersteller-Energiesparen (Xiaomi) → nur auf echten Geräten.

### P2-1 Sicherung: beschädigte Felder ohne verständliche Meldung
- **Finding:** War in einer Sicherung `yesNoMaybe` oder `reflectionAnswers` kein gültiges JSON, warf der
  Import eine technische `FormatException` (vor dem Schreiben, also ohne Datenänderung, aber mit
  unverständlicher Meldung). Werte wurden nicht auf Text geprüft. Ein beschädigter Passwort-Block meldete
  „Das Passwort stimmt nicht“.
- **Fix:** `_textMap` prüft diese Felder (Zuordnung Text → Text) und wirft `BackupException`; ein kaputter
  *lokaler* Stand zählt beim Zusammenführen als leer. Meldung: „Das Passwort stimmt nicht, oder die
  Sicherung wurde beschädigt.“ (GCM kann beides nicht unterscheiden.)
- **Regression-Tests:** `test/backup_merge_test.dart`: beschädigte Felder (3 Varianten + Reflexionen) →
  Meldung und unveränderte Einstellungen; abgeschnittene Datei → abgelehnt; Sicherung ohne Daten ändert
  nichts Wesentliches; beschädigter Passwort-Block (3 Varianten) → `BackupException`. Bestehend:
  falsches Passwort, manipulierter Geheimtext, ungültige Sicherungen, nicht passende Schlüssel mit
  vollständigem Rückfall (`security_test.dart` A/B).
- **Geprüft, unverändert:** normale Sicherungen enthalten weder API-Key noch privaten Schlüssel;
  PBKDF2-HMAC-SHA256 (210 000 Runden) + AES-256-GCM; `SecretStore` hat keinen Klartext-Rückfall; alte
  Klartext-Sicherungen (Schema 1) bleiben einspielbar und werden in der Oberfläche als unsicher gemeldet.

### P2-2 Update: Prüfsumme und Herkunft nicht streng genug geprüft
- **Finding:** Der Inhalt der `.sha256`-Datei wurde ungeprüft übernommen (z. B. eine Fehlerseite), ihr
  Abruf hatte kein Zeitlimit, und die Download-Adressen wurden nicht auf dieses Repository beschränkt.
- **Geprüft:** `ota_update` 7.1.0 vergleicht die Prüfsumme nach dem Download und **vor** der Installation;
  fehlende Datei → `DOWNLOAD_ERROR`, Abweichung oder leere Prüfsumme → `CHECKSUM_ERROR`, jeweils ohne
  Installation. Nur bei *gar keiner* übergebenen Prüfsumme prüft es nicht – das verhindert unser Code.
- **Fix:** `parseSha256` (genau 64 Hex-Zeichen, sonst kein Update), Zeitlimit 10 s, `isReleaseDownloadUrl`
  (nur `https://github.com/angemann-app/velvet_app/releases/download/…`).
- **Regression-Tests:** `test/update_channel_test.dart` (gültige/ungültige Prüfsummen, fremde Adressen).
- **Vertrauensmodell:** Die Prüfsumme stammt aus derselben Quelle wie die APK und schützt nur vor
  Übertragungsfehlern. Der unabhängige Echtheitsanker ist die **APK-Signatur**: Android installiert ein
  Update nur, wenn es mit demselben Schlüssel signiert ist wie die installierte App. Der Schlüssel liegt nur
  lokal beim Maintainer (nicht im Repo, `android/key.properties` ignoriert). Wer das GitHub-Konto übernimmt,
  kann ohne diesen Schlüssel kein Update unterschieben. Eine zusätzliche signierte Metadaten-Datei würde
  denselben Schlüsselbesitz voraussetzen und brächte darum keinen weiteren unabhängigen Anker – nicht
  umgesetzt (keine Schein-Sicherheit).

## Ausgeführte Prüfungen (lokal, 24.10.2026)
| Prüfung | Ergebnis |
|---|---|
| `flutter test` (alle 69 Tests) | bestanden |
| `flutter analyze` (gesamtes Projekt) | keine Befunde |
| Übersetzungstest (Prüfsummen DE/EN) | bestanden |
| Release-Build `flutter build apk --release --split-per-abi` (4.4.1+30) | erfolgreich (3 APKs, arm64 76,9 MB) |
| Neu eingesprochen: `pain_1`, `pain_2`, `pos_3`, `anat_2`–`anat_4` | erledigt |
| `dart format` | nicht als Gate genutzt: 48 von 75 Dateien weichen vom Standardformat ab (Projekt nie damit formatiert); Massen-Umformatierung bewusst nicht vorgenommen |
| CI (GitHub Actions „Tests“) für Commit fda1305 | erfolgreich (Lauf 40085922216, 1 min 21 s) |
| Prüfung auf echtem Gerät (Selbsterkundung, Screenreader, Audio-Stopp, Update) | vor dem Stabil-Release offen |

## Nicht automatisch prüfbar / offen
- Fachliche Richtigkeit der Gesundheitstexte: manuell durchgesehen, keine ärztliche Prüfung.
- Benachrichtigungen, Hintergrundabruf, Update-Installation, Screenreader-Ausgabe: nur auf echten Geräten.
- Rückfall *während* des Schreibens einer Sicherung (Fehler mitten im Schreiben) ist im Code vorhanden,
  aber ohne Fehlerinjektion nicht automatisiert getestet.

## Verbleibende Risiken
- **Metadaten:** NIP-04 verschlüsselt nur den Inhalt; Server sehen Schlüssel, Zeitpunkte, Größen, IP.
  NIP-17/44 (Gift Wrap) würde mehr verbergen, ist aber ein größerer Umbau mit Kompatibilitätsfragen.
- **NIP-04 selbst:** AES-CBC ohne eigene Authentifizierung des Geheimtexts; die Event-Signatur schützt die
  Integrität, NIP-04 gilt dennoch als veraltet.
- **Android-Cloud-Sicherung:** Die normalen App-Einstellungen (inkl. Verlauf, Reflexionen, Tagebuch) gehen
  in Androids Sicherung (bei gesetzter Bildschirmsperre dort Ende-zu-Ende verschlüsselt). Schlägt bei
  Altnutzern (bis 4.3.0-beta.1) der Umzug eines Klartext-Geheimnisses in den Keystore fehl, bleibt es in den
  Einstellungen und damit in dieser Sicherung. Sehr enger Fall, bewusst nicht geändert (sonst Verlust der
  Paar-Verbindung).
- **Gemini (KI-Coach):** Nachrichten und Profilangaben gehen an Google (in der App beschrieben).

## Empfehlung
Die Änderungen sind klein, getestet und ändern keine Datenformate. Sie eignen sich für einen
**Patch-Release 4.4.1**. Vorher empfohlen: kurzer Blick auf die Selbsterkundung auf einem echten Gerät.

---

## Beta-Prüfung 4.5.0-beta.1

Grundlage: externer Prüfauftrag zu `v4.5.0-beta.1+30` (24.10.2026). Neu gegenüber Teil 1 sind die englische
Fassung (Oberfläche, Inhalte, Grafiken, Audiopaket) und zwei neue Fragen der Ja/Nein-Liste.
Vergleichsbasis: `v4.4.0+29`.

### Geprüft, ohne Befund
- **Ja/Nein-Liste auf Englisch:** Alle 10 Kategorien und 65 Fragen (inkl. `item_64`, `item_65`) erscheinen
  übersetzt; ids, Grafiken und Lektionsverweise sind unverändert, jede verknüpfte Lektion existiert auch auf
  Englisch; Antwortstufen und leere Zustände übersetzt. Gespeicherte Antworten und der Partnerabgleich laufen
  über die ids und sind sprachunabhängig. → `test/ja_nein_sprachen_test.dart` (Deutsch und Englisch).
- **Verbliebene deutsche Texte:** Suche über `lib/` mit `tools/l10n_umzug.py kandidaten`; übrig nur gespeicherte
  Kennungen (angezeigt übersetzt), die Vorlage für Aussprache-Meldungen an das deutsche Projekt und eine interne
  Fehlermeldung. → `test/oberflaeche_texte_test.dart` (gleiche Schlüssel und Platzhalter, nichts leer, keine
  Kodierungsfehler).
- **Sprachwechsel ohne Datenverlust:** Er ändert nur `app_language`. → `test/sprache_test.dart`.
- **Geräte-Stimme als Ersatz:** Ohne englisches Audiopaket liefert `Sprachausgabe.quelle` keine Aufnahme; Lektionen,
  Gemeinsamer Abend, Selbsterkundung und Beckenboden-Ansagen lesen dann mit der Geräte-Stimme (`en-US`).
  Codeprüfung; die tatsächliche Ausgabe braucht ein echtes Gerät.
- **Grafiken passend zur Sprache:** Jede beschriftete Anleitungsgrafik hat eine `_en`-Fassung. → `test/sprache_test.dart`.
- **Paar-Kanal, Backup, OTA gegenüber 4.4.0:** `nostr_service.dart` nur umbenannte lokale Variablen und übersetzte
  Texte (keine Logikänderung); Backup und Update entsprechen Teil 1.
- **Release `v4.5.0-beta.1+30`:** als Vorabversion, drei APKs mit Prüfsummen; CI „Tests“ für den Release-Commit
  erfolgreich (Lauf 40090718016).

### Befunde

**B1 – Sprachwechsel verlangt erneut den Fingerabdruck**
- *Finding:* Ein Sprachwechsel baut die ganze App neu auf (`MaterialApp` mit Schlüssel je Sprache). Dabei entstand
  auch die App-Sperre neu und sperrte sofort – wer die Sperre nutzt, musste mitten in den Einstellungen erneut
  entsperren.
- *Reproduktionstest:* `test/app_lock_test.dart` – ohne Fix 2 Abfragen statt 1 (ausgeführt und bestätigt).
- *Fix:* `AppLock` merkt sich, dass die Sitzung entsperrt ist; nach einem Neustart oder zu langer Zeit im
  Hintergrund wird wie bisher gesperrt.
- *Regressionstest / CI-Gate:* `test/app_lock_test.dart` in `flutter test` (CI und `tools/release.ps1`).

**B2 – Datum im Gedanken-Tagebuch immer deutsch**
- *Finding:* `cbt_journal_screen.dart` formatierte fest als `TT.MM.JJJJ`.
- *Fix:* `DateFormat.yMd(Sprache.code)` mit deutschem Rückfall.
- *Test:* Sichtprüfung; das Format kommt aus `intl`. Gerätetest empfohlen.

**B3 – Versionsnummer in `pubspec.yaml` veraltet**
- *Finding:* `4.4.0-beta.4+25`. Releases setzen Name und Build über `tools/release.ps1` korrekt, nur
  Entwickler-Builds zeigten eine falsche Version.
- *Fix:* `4.5.0-beta.1+30`.

### Bereits während der Entwicklung von 4.5 gefunden und behoben (vor der Beta)
- Unbelegte Versprechen in der CAT-Grafik („verdoppelte Orgasmus-Wahrscheinlichkeit“, „20+ Min. Ausdauer“),
  auch auf Deutsch korrigiert.
- 20 ungenutzte Wirkungssätze der Tagesimpulse („halbiert den Adrenalinspiegel“) entfernt.
- Übersetzte Listen als einmal gefüllte Variablen hätten nach einem Sprachwechsel die alte Sprache behalten → Getter.
- Gespeicherte Kennungen (Denkfallen, Check-in-Antworten) bleiben deutsch, angezeigt wird übersetzt – Datenformat
  und Kompatibilität Beta/Stabil unverändert.

### Ausgeführte Prüfungen (lokal, 24.10.2026, nach den Fixes)
| Prüfung | Ergebnis |
|---|---|
| `flutter test` (86 Tests) | bestanden |
| `flutter analyze` (gesamtes Projekt) | keine Befunde |
| Release-Build (`--build-name 4.5.0-beta.2 --build-number 31`, nur Kontrolle) | erfolgreich |
| Screenshots Deutsch und Englisch (`test_screens`, `--dart-define=LANG=en`) | durchgesehen |

### Nur auf einem echten Gerät prüfbar (offen)
- Sprachwechsel im Profil mit eingeschalteter Fingerabdruck-Sperre (B1 auf dem Gerät).
- Geräte-Stimme auf Englisch (installierte englische Sprachausgabe nötig), Download des Audiopakets
  (`audio-en-v1`, noch nicht hochgeladen), Wiedergabe der Pakete.
- Benachrichtigung in englischer Sprache aus dem Hintergrund.
- Screenreader auf Englisch.

### Empfehlung
B1–B3 sind klein und getestet; sie gehören in `4.5.0-beta.2`. Für die stabile 4.5.0 zusätzlich: Audiopaket
hochladen und die offenen Geräteprüfungen durchführen.
