# Vollständige App-Übergabe für Claude

### Ergänzung von Codex: übrige App-Änderungen für denselben Beta-Stand

Der Nutzer möchte ausdrücklich **auch sämtliche übrigen App-Änderungen** berücksichtigt wissen, nicht nur Texte und Aufnahmen. Folgende Übersicht bezieht sich auf den vorhandenen Arbeitsstand; keine neuen Funktionen implementiert und keine Builds/Uploads ausgeführt. Einzeldateien vollständig unter `build/redaktion/abgleich-claude/APP_DATEIEN.csv` (Pfad, Status, SHA256).

**Wichtig für die Übernahme:** Im ausgewerteten App-/Android-/Grafik-/Testumfang stehen 218 Datei-Differenzen bzw. neue Dateien, darunter 87 unversionierte Dateien. **37 unversionierte Dateien betreffen direkt `lib/`, Android oder Tests.** Ein reiner `git diff`, Patch verfolgter Dateien oder Cherry-pick der bisherigen Commits würde diese neuen Quelldateien nicht vollständig mitnehmen. Arbeitsstand gezielt vollständig sichern/übernehmen; keine Anhänge, privaten Inhalte oder Build-Ausgaben pauschal hinzufügen. Die CSV ist eine Übernahmeliste, kein Auftrag zu `git add -A`.

#### A. Umgesetzt: Bedienung, Player und gemeinsames Hören

| Bereich | Verhalten im vorhandenen Code | Zentrale Dateien |
|---|---|---|
| Globaler Player | Eine Sitzung für Lektionen und geführte Angebote; Seitenwechsel beendet das Audio nicht. Mini-Player, Pause, Fortsetzen, Springen und Beenden. | `lib/services/wiedergabe_lauf.dart`, `wiedergabe_dienst.dart`, `wiedergabe_ausgabe.dart`, `wiedergabe_plaene.dart`; `lib/models/wiedergabe_plan.dart`; `lib/screens/wiedergabe_screen.dart` |
| Wiederfinden | Merkt Ablauf/Segment/Position, nicht erneut zufällig planen. Wiederfinden ohne automatisches Abspielen; Geräte-Stimme beginnt ihren Abschnitt neu. | `lib/models/bedien_daten.dart`, `lib/services/storage_service.dart`, Playerdienste |
| Hintergrundaudio | Native Abschnittsenden, aktive Zeit ohne Pausen, Fokus-/Kopfhörerunterbrechung, Wachhalten/Klangteppich; neutraler Android-Mediendienst mit Pause/Beenden. | `android/app/src/main/java/org/velvetpulse/app/WiedergabeService.java`, `MainActivity.kt`, Manifest; `audio_service.dart`, `tts_service.dart`, `sprachausgabe.dart` |
| Lokale Suche | Kurse/Lektionen/Hörangebote/Übungen lokal durchsuchen; Spicy-Zugang berücksichtigt, keine privaten Journale/Chats/Coachverläufe oder Suchhistorie. | `lib/screens/suche_screen.dart`, `lib/services/such_index.dart`, `inhalt_suche.dart` |
| Persönlicher Weg | Freiwillige Kombination aus bestehender Lektion, Übung und Nachspüren; kein Streak-/Leistungszwang. | `lib/widgets/weg_begleiter.dart`, `lib/models/bedien_daten.dart`, Integration in Kurs-/Lektionsseiten |
| Verfügbarkeit/Downloads | Tatsächliche Dateien statt nur Paketversion prüfen; passende Sprache/Stimme/Fassung nachladen, Fehler erneut laden; fehlende private Inhalte nicht unkontrolliert öffnen. | `lib/services/aufnahme_stand.dart`, `lib/widgets/aufnahme_status.dart`, `lib/services/pakete.dart` |
| Gemeinsam hören | Identische Aufnahme auf zwei Geräten, Einladung/Annahme, beide bereit, Uhrabgleich/Countdown; Pause von beiden, Weiter erst nach erneuter Bereitschaft. Keine Geräte-Stimme. | `lib/services/gemeinsam_hoeren.dart`, `gemeinsam_dienst.dart`, `lib/screens/gemeinsam_screen.dart` |
| Gemeinsamer Rückblick | Freiwillige Worte und optionales Gefühl; Partnerantwort erst nach beiderseitigem erfolgreichen Teilen. Vorhandenen Reflexionsweg weiterverwendet. | `lib/models/gemeinsam_antwort.dart`, gemeinsamer Screen, `couples_channel_screen.dart` |

Vorhandene Player-Einstiege auf dieselbe Sitzung umgestellt: Paar-Abend, Selbst-Reise, Einschlaf-/Traum-/Lust-Reisen, Wecken und Innenansichten; Hauptnavigation, Lektionsdetail und Player-Bedienung angepasst. Konfigurationen/Ablaufplaner nicht durch neue Inhalte ersetzt. Gegenperspektiven der Innenansichten **nicht** miteinander synchronisiert; implementiert ist dieselbe Aufnahme auf beiden Geräten. Bei Verbindungsverlust lokale Steuerung möglich, keine garantierte Fernpause ohne Netz und kein automatischer Wiederanlauf nach Reconnect.

#### B. Umgesetzt: Traumpraxis als App-Modul

- Tages-/Abend-/Morgenpraxis auf Grundlage vorhandener Traum-Erinnerungen, private Traumzeichen, Abendvorbereitung und freiwillige Tagesbeobachtung.
- Bearbeiten/Löschen sowie chronologischer Rückblick; Erholung/Tageslust und optionale Beobachtungen ohne Orgasmusquote, automatische Deutung oder Erfolgsversprechen.
- Einstieg über `lust_im_traum_screen.dart`; zentrale neue Dateien `lib/models/traumpraxis.dart`, `traumpraxis_daten.dart`, `lib/screens/self_exploration/traumpraxis_screen.dart`, `traumpraxis_verwalten.dart`.
- Bestehende Traumtagebuch-/Abendfolgen-/Reminderwege genutzt; keine neue REM-Erkennung oder automatische Signale während des Schlafs.
- **Davon unterscheiden:** die zwölf neu produzierten Dateien für drei zusätzliche Hörbegleitungen. Deren App-Einstiege/Paketreferenzen fehlen noch, siehe Audioantwort oben. Das bereits implementierte Modul wird dadurch nicht insgesamt zu einem bloßen Konzept.
- **Wearables/Fitbit/Health Connect:** im überprüften Quellstand keine produktive Anbindung gefunden. Nicht als umgesetzte oder bereits testbare Funktion ankündigen. Das Modul funktioniert ohne Uhr/Armband. Der frühere Wunsch nach einer grundsätzlichen Anbindung ist damit noch nicht als erledigte Implementation belegt.

#### C. Speicherung, Übersetzungen und Schutzmechanismen

- Neue Zustände `traumpraxis` und `bedienung` in lokaler Speicherung, verschlüsselter Sicherung und deterministischem Backup-Merge; Löschmarkierungen verhindern Wiederauferstehen gelöschter Daten.
- `StorageService`, `BackupCodec`, `test/backup_merge_test.dart` und zugehörige Modelltests gehören vollständig zur Übernahme. BackupCodec um Datenfelder ergänzt, nicht das Kryptoverfahren ersetzt.
- DE/EN-Oberfläche über ARB samt generierten Lokalisierungsdateien; neue Anleitungsabschnitte und vorhandene Anleitungstexte DE/EN synchronisiert. Keine neue ausschließlich deutsche UI voraussetzen.
- Spicy-Aus beim Player/gemeinsamen Rückblick, neutrale Systemtexte, Lautsprecherprüfung/Fokus/Kopfhörertrennung berücksichtigt. Bestehende SecretStore-/Nostr-Prüfung/Krypto unverändert genutzt. R8/Ressourcenschrumpfung weiterhin aus.

#### D. Design, Grafiken und App-Symbol

| Arbeit | Umgesetzt / zu übernehmen | Abgrenzung |
|---|---|---|
| Dekorative Bildwelt | 41 Motive (27 Kurse, 3 Audioeinstiege, 11 Themenbereiche), 82 alte dekorative SVGs durch 45 WebPs ersetzt. | 900×600, zentrale Zuordnung statt Bildschirm-Sonderpfade. Nicht die anatomischen Erklärdiagramme entfernen. |
| Spicy-Bilder | 37 Zuordnungen zu 25 vorhandenen Zeichnungen aus dem privaten Kursbildpaket, zusätzlich vier abstrakte Spicy-WebPs in der App. | Private Originalzeichnungen bleiben außerhalb Git/APK. Ohne Paket reguläres Bild statt Leerfläche. |
| Bildladen | Zentrales Register mit Altpfad-Aliassen, Paketquelle getrennt vom APK-Asset; `VpBildFeld` reagiert auf Paketinstallation/-löschung. Heute zeigt das passende nächste Kursbild; Kurszeilen unterstützen Rasterbilder. | `bild_register.dart`, `vp_bild_feld.dart`, `vp_komponenten.dart`, `assets/data/bilder.json`; Erzeugung `tools/kursmotive.json`, `kursgrafiken_webp.py`, `bilder_register.py`. |
| Erklärdiagramme | Die 100 neu gezeichneten Diagramm-SVGs sind vorhanden und wurden bereits in der früheren Beta-58-Prüfung bestätigt. | Bereits Teil der Git-Basis `2c34cc5`, kein weiterer fehlender uncommitteter Diagrammstapel. 16 beschriftete Pencil-SVGs wurden beim späteren WebP-Austausch nicht ersetzt. |
| App-Icon | Neues Graphit-/Rosé-Bogen-/V-Zeichen: fünf Legacy-Dichten, adaptive Vektor- und Android-13-Monochromebene. | Dateien unter Android `res/` und Quelle `tools/app_symbol/`. Diskretes Pulse-Icon/Launcher-Aliasse erhalten; kein äußerlich sichtbarer Spicy-Wechsel. |
| Markenunterlagen | Markenleitfaden, Logo-/Markenquellen, deutsche/englische Broschüre mit 24 Seiten und neuen App-Funktionen. | Marketingdateien, keine zusätzliche Laufzeitfunktion und kein APK-Inhalt. PDFs unter `output/pdf/`, Quellen `marketing/` und zugehörige Generatoren. |

Die bereits vorher vorhandene Magazin-Theme-Struktur mit Papier/Nachtpapier/Spicy ist die Grundlage, kein in diesem Auftrag neu erfundener Komplettumbau. Die Änderungen an Bildfeldern/Karten sollen mit dem bestehenden Token-System übernommen werden.

#### E. Belegte Prüfungen und tatsächlich offene Schritte

- **Letzter dokumentierter vollständiger App-Lauf:** 419 Tests bestanden, Analyse ohne Befunde; `build/bedienung/gesamt-player-tests.log` und `player-analyse.log`. Enthält Sicherheits-/Backup-/Sprachprüfungen und Simulationen von Player-/Gemeinsam-Rennen, verlorenen/verspäteten Signalen sowie Fehlversand-/Spicy-Rückblickschutz.
- DE/EN und Papier/Nachtpapier/Spicy gerendert, kleine Displays 360×640 mit 1,6-facher Schrift sowie größere Anzeige; keine gemeldeten Überläufe. Neue Player-/Einladungs-/Rückblick-/Mini-Player-Zustände sowie vorhandene Navigation geprüft; Belege in `build/bedienung/` und `build/screens…/`.
- Bildwelt: Generator-/Registerprüfung, zwölf gezielte Bild-/Pakettests und damaliger vollständiger 363er-Lauf; sechs Bild-Renderkombinationen DE/EN × Atmosphären. Galerie unter `build/designstudien/kursgrafiken-webp/`.
- App-Icon isoliert mit aapt2 kompiliert/verlinkt und Masken/Kleinformen geprüft. Mediendienst separat gegen SDK 36 kompiliert. **Beides ist kein vollständiger nativer APK-Build.** Der frühere Offline-Gradle-Versuch scheiterte an fehlenden Cache-Abhängigkeiten; nicht als bestandenen Build darstellen.
- Der nachfolgende reine Textdurchgang hatte 33 gezielte Tests einschließlich DE/EN/PO und Spicy-Inhaltsabläufen grün; nicht mit einem neuen kompletten 419er-Lauf verwechseln. Nach Zusammenführen des finalen Beta-Stands die regulären Gesamtprüfungen erneut ausführen.
- **Offen:** Claudes vollständiger Android-Build; echter Handytest mit Bildschirm aus über Szenengrenzen, Bluetooth/Kopfhörer/Anrufunterbrechung und Systemsteuerung; echter Zweigerätetest mit identischen Paketen, Countdown/Pause/Reconnect/Rückblick. Keine dieser realen Prüfungen durch Desktop-Renderbilder oder Fakebus-Tests als bestanden ausgeben.
- **Release:** In-App-Beta nach bestehendem Versions-/Buildnummer-/Nutzerfreigabeworkflow, keine Alpha-/USB-Ersatzinstallation. DE/EN-„Was ist neu“-Entwurf `docs/konzepte/bedienung-neuigkeiten-entwurf.md` um Bildwelt/App-Symbol/Traumpraxis ergänzen und dem echten Build zuordnen. Keine neue Nummer von Codex vergeben.

**Fazit für die Arbeitsreihenfolge:** vollständigen App-Arbeitsstand einschließlich neuer/unversionierter Dateien übernehmen; die oben belegte Audiopaketlücke schließen; Release-Einträge und tatsächlichen Paket-/Textstand abstimmen; Gesamtprüfung und Android-Build; Beta über In-App-Download; danach reale Geräteabnahme. Nicht nur die 174 Audios übernehmen und die App-Änderungen außen vor lassen.

Die vollständige Bedienungsübergabe mit detailliertem Gerätetestplan bleibt `docs/UEBERGABE_BETA_BEDIENUNG.md`. Diese Ergänzung erfasst auch die vorherigen Design-/Traumpraxisarbeiten, die im reinen Audioauftrag nicht auftauchen.

