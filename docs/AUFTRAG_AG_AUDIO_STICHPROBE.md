# AG-26: gezielte Hörstichprobe der Neuaufnahmen

**Abgeschlossen (02.11.2026):** Finale Datei übergeben, Hash und Dekodierung durch Codex bestätigt. Keine weitere Synthese oder Hörprüfung beauftragt. Maßgebliche Übergabe: `docs/pruefungen/AG26_FINALE_UEBERGABE.md`; ältere Auftragsnachträge unten sind Verlauf.

Nutzerentscheidung 02.11.2026: **Stichproben reichen.** Kein vollständiges Durchhören des gesamten Bestands. Claude Code koordiniert diese Abnahme und den anschließenden Beta-Workflow. Codex hat den Hörplan vorbereitet, aber keine Probe als angehört markiert.

## Material und Umfang

28 vorhandene Aufnahmen: Deutsch/Englisch, Victoria/Martin und gemischte Lektionsstimmen, normale/Spicy-Lektion, alle vier geführten Familien sowie vier Traumpraxis-Aufnahmen über alle Sprach-/Stimmkombinationen und die drei Themen verteilt.

- Hörseite: `C:\TOOLS\workspace\mojo\build\redaktion\gesamt\abnahme\AG_STICHPROBEN.html`
- Verbindliche Dateiliste/Fenster/Prüfsummen: gleicher Ordner, `AG_STICHPROBEN.json`.
- Berichtvorlage mit allen 28 IDs: gleicher Ordner, `AG_BERICHT_VORLAGE.md`.
- Aussprache-Referenz nur lesend: `C:\TOOLS\workspace\mojo\tools\aussprache.json`, Ablauf `docs/AUSSPRACHE.md`.

Geplante Ausschnitte rund **22 Minuten**, mit Stimmwechseln und Wiederholungen etwa **25–30 Minuten**. Dateien bis 75 Sekunden ganz hören; längere jeweils 20 Sekunden am Anfang, in der Mitte und am Ende. Die Schaltflächen stoppen an der Fenstergrenze. Bei gemischten Stimmen zusätzlich einen tatsächlichen Wechsel anhören. Auffällige Dateien vollständig hören, weitere Proben nur gezielt aus derselben Stimme/demselben Profil.

Alle 1.744 regulären Neuaufnahmen sowie die zwölf Traumpraxis-Aufnahmen haben bereits die vollständige technische Prüfung bestanden. Das ersetzt diese Hörstichprobe nicht. Die acht privaten Abendfolgen und Innenansichten gehören nicht zu dieser Neuvertonungsprüfung; `C:\TOOLS\velvet-inhalte` nicht öffnen oder verändern.

## Worauf achten

1. Aussprache und Betonung, besonders die im Plan genannten Lexikonwörter. Problem mit Wort und Zeitmarke festhalten.
2. Natürlicher Satzfluss, sinnvoller Spannungsbogen, keine künstlich gezogenen oder gehetzten Silben.
3. Pausen und Satzenden, keine verschluckten Wörter, abgebrochenen Enden, Klicks oder unerwarteten Sprünge.
4. Stimmenwechsel: verständlich und ohne störenden Lautstärkesprung. Die Stimmen sollen unterscheidbar bleiben.
5. Einschlaf-/Traumprofile sind absichtlich ruhiger; nicht am Lektionstempo messen. Spicy darf direkt und sinnlich bleiben. Keine Textglättung, Zensur oder neue Formulierungen beauftragt.

Nur tatsächliches akustisches Prüfen als „angehört“ kennzeichnen. Wenn deine Umgebung eine Aufnahme nicht akustisch prüfen kann: **nicht prüfbar** notieren. Transkription, Metadaten oder technische Dekodierung allein sind keine Hörabnahme und belegen keine Natürlichkeit.

## Erlaubte Arbeit und Ablage

- Im eigenen Klon `C:\TOOLS\workspace\mojo-ag`, Branch `ag/26-audio-stichprobe-20261102`.
- Die genannten Dateien im Hauptarbeitsordner ausschließlich lesen/abspielen; dort keinen Branch wechseln und keine Dateien verändern.
- Einzige erlaubte Änderung im AG-Klon: **`docs/pruefungen/AG26_AUDIO_STICHPROBE.md`**. Berichtvorlage übernehmen, je ID Status `unauffällig`, `Befund` oder `nicht prüfbar`, Zeitmarke und konkrete Beobachtung eintragen. Bei Erweiterung zusätzliche IDs mit Grund aufführen. Keine ganzen Sprechtexte in den Bericht kopieren.
- Kein Kokoro starten, keine Neuvertonung, keine Text-/Lexikon-/Code-/Originalaudioänderungen, keine Paketversionen oder Uploads. `AG.md` im AG-Branch unverändert lassen.
- Prüfen: IDs/Dateien gegen das Manifest abgleichen; nur die Reportdatei im `git diff`. Flutter-Tests nicht nötig, da reiner Hörbericht. Danach PR mit Bericht nach dem bestehenden AG-Ablauf. Kein eigenständiges Zusammenführen oder Veröffentlichen.

## Ergebnis für Claude

Kurzurteil: Stichprobe unauffällig / konkrete Korrekturen nötig / akustisch nicht prüfbar. Nur belegte Auffälligkeiten zur gezielten Korrektur weitergeben; kein erneuter Komplettlauf. Die Stichprobe gibt keine Garantie für jede einzelne Datei. Paketübernahme und morgige Beta bleiben ein eigener Schritt unter Claudes Koordination und dem bestehenden Freigabeworkflow. **Noch keine Hörabnahme erfolgt.**


## Nachtrag: gezieltes Gegenhören der Korrekturfassung

02.11.2026: Codex hat auf Nutzerauftrag ausschließlich `de/prost_3` neu erzeugt, getrennt unter `C:\TOOLS\workspace\mojo\build\redaktion\gesamt\korrektur-ag26\`. Öffne dort `VERGLEICH.html`: alte Stellen, korrigierte bestehende Sätze und vollständige Korrekturfassung (196,85 Sekunden). Direkte multimodale Audioverarbeitung wie im erklärten AG-26-Bericht verwenden; Modell und Methode erneut benennen.

Gezielt prüfen: „Prostata“ jetzt ohne „sch“-Eindruck, natürliche Betonung; „Herstellerangaben“ ohne falsche Silbentrennung. Die lokale o-Längenvariante ebenfalls auf Natürlichkeit prüfen. Bei unnatürlicher Aussprache konkret melden, nicht bloß die technische Lautschrift bestätigen. Kurzprobe und Übergänge in der vollständigen Fassung gegenhören, ursprüngliche Zeitmarken sind nach Neusynthese nur Orientierung. Ergebnis als Nachtrag in derselben erlaubten Datei `docs/pruefungen/AG26_AUDIO_STICHPROBE.md`, inklusive `korrektur_sha256` aus `bericht.json`. Keine weiteren Dateien ändern; keine neue 28er-Stichprobe, keine Synthese oder Uploads. Bisherige Regeln zum separaten Klon und Datenschutz bleiben bestehen.


## Aktuell: zweite Runde, nur zwei kurze Ausspracheproben

Die erste Korrekturfassung ist nach deinem Gegenhören verworfen und wird nicht übernommen. Neue lokale Proben unter `C:\TOOLS\workspace\mojo\build\redaktion\gesamt\korrektur-ag26\varianten-2\`: `variante_a.wav` (9,16 s) und `variante_b.wav` (9,36 s). Beide enthalten ausschließlich die beiden Wörter, je zweimal. `bericht.json` nennt Hashes und tatsächlich übergebene Phoneme. Technisch geprüft; akustische Auswahl offen.

Bitte beide direkt akustisch vergleichen: sauberes s in „Prostata“, kein künstlicher Wortbruch, natürliches „Herstellerangaben“ ohne eingefügtes t. Je Wort separat bessere Variante nennen oder beide ablehnen. Variante b enthält absichtlich einen Punkt in der Lautschrift als Versuch einer Silbenfuge: ausdrücklich auf störende Pause achten. Noch keine Gesamtkorrekturfassung verfügbar, deshalb keine Abnahme der ganzen Lektion behaupten. Nachtrag mit Modell/Methode/Dateihashes weiterhin ausschließlich in `docs/pruefungen/AG26_AUDIO_STICHPROBE.md`. Keine Synthese/Dateiänderungen außerhalb des Berichts. Erst nach positivem Wortvergleich werden bestehende Sätze bzw. die Lektion erneut erzeugt.


## Nächster Schritt: Gesamtkorrektur Runde 3

Deine Auswahl aus Runde 2 wurde übernommen: „Prostata“ Variante B, „Herstellerangaben“ Variante A. Die nächste vollständige Aufnahme entsteht getrennt unter `C:\TOOLS\workspace\mojo\build\redaktion\gesamt\korrektur-ag26\final-runde3\`. Erst nach Vorliegen von `bericht.json` und `prost_3_korrektur.opus` prüfen. `nachher_aussprache.wav` enthält die betroffenen bestehenden Sätze als kurze Probe.

Gezielt direkte Audioverarbeitung der vollständigen `prost_3_korrektur.opus`: alle Vorkommen der zwei Wörter im Satzfluss und Übergänge/Schluss prüfen. Keine Übertragung der Wortproben-Abnahme auf die Gesamtaufnahme. Im Bericht Methode, Hash der tatsächlich geprüften Gesamtkorrektur aus `bericht.json`, Ergebnis und gegebenenfalls genaue Zeitmarke nennen. Gleiche erlaubte Reportdatei, keine Synthese oder sonstige Änderungen. Nur unauffällige Gesamtkorrektur zur gezielten Übernahme empfehlen; andernfalls konkreten Befund melden.


## Dateiübergabe der final abgenommenen Aufnahme

Finaler Bericht/Nutzerfreigabe erhalten. Bitte den **absoluten Pfad** der tatsächlich gehörten `prost_3_test_gesamt.opus` (SHA256 `fad66de4df536448f181723513a26fb4b09907a2ca422d0213c53c62cbd1ad5e`) mitteilen. In beiden Projektordnern ist diese Datei derzeit nicht auffindbar. Vorhandene Datei nicht erneut synthetisieren oder überschreiben. Dazu Erzeugungsbefehl/-skript, verwendeten Quelltextstand und Sprechprofil nennen, damit Claude/Codex genau die geprüfte Datei übernehmen können. Keine andere Datei gleichen Namens erzeugen und keine Pakete veröffentlichen. Unsere Runde 3 ist verworfen und darf nicht ersatzweise übernommen werden.
