# Sondierung des Bildbedarfs für die Kurse 1 bis 25

Stand: 28.10.2026. Analyse im Rahmen von Auftrag AG-12 auf Basis von `docs/konzepte/kursbilder.md`.
Untersucht wurden alle 113 Lektionen der Kurse 1 bis 25 aus `assets/data/velvet_content.json` (die Spicy-Kurse 26 und 27 blieben vereinbarungsgemäß unberührt).

## Kriterien und Maßstab

- **Bild hilft = ja:** Nur dort, wo eine Grafik ein komplexes anatomisches, körpermechanisches oder ablaufbezogenes Prinzip erklärt (Anatomie, Ablauf, Haltung, Material, Atem) und Text allein schwer verständlich bleibt.
- **Bild hilft = optional:** Wo eine Visualisierung das Verständnis vertieft oder die Atmosphäre unterstützt, aber für das Kernverständnis nicht zwingend erforderlich ist.
- **Bild hilft = nein:** Bei reinen Audio-Praxis-Lektionen, philosophisch-reflexiven Texten, reinen Kommunikationsleitfäden oder Spicy-Lektionen (deren Bildmaterial in das Nur-R2-Paket gehört).
- **vorhanden:** Die 9 Lektionen, die bereits über ein Vektordiagramm (`diagram_*.svg`) in der App verfügen.
- **Motive:** Alle Vorschläge sind strikt neutral und ohne Körperdarstellung (schematische Modelle, Vektoren, Zonen, Haltungslinien, Matrizen, Abläufe).

## Übersichtstabelle je Lektion (113 Lektionen)

| Kurs | Lektions-ID | Titel | Bild hilft | Art | Motiv in einem Satz | Beschriftung nötig | Priorität | Bemerkung |
|---|---|---|---|---|---|---|---|---|
| Kurs 1 | `neuro_1` | Gaspedal und Bremse | **ja** | Diagramm | Waage- bzw. Balancemodell von Erregungsbeschleunigern (Gaspedal) und Hemmfaktoren (Bremse) | ja | hoch | Visualisiert das Duale Kontrollmodell nach Bancroft/Janssen |
| Kurs 1 | `neuro_2` | Der Teufelskreis der Erwartungsangst | **ja** | Ablauf | Zirkuläres Ablaufdiagramm des Teufelskreises aus Erwartungsangst, Anspannung und Funktionsverlust | ja | mittel | Zeigt Unterbrechungspunkte der Angstspirale auf |
| Kurs 1 | `neuro_3` | Audio-Praxis: Die Bremse lösen | **nein** | – | – | – | – | Audio-geführte Atemübung; rein auditiver Fokus |
| Kurs 2 | `anat_1` | Erregung ist ein Ganzkörper-Ereignis | **optional** | Diagramm | Stilisierte Nervendichte und sensorische Zonen als abstraktes Wärmebild | ja | niedrig | Veranschaulicht Erregung als Ganzkörperphänomen |
| Kurs 2 | `anat_2` | Kopf, Ohren, Hals und Nacken | **nein** | – | – | – | – | Deskriptiver Text zu Kopf, Ohren und Nacken |
| Kurs 2 | `anat_3` | Rücken, Bauch, Kniekehlen und Füße | **nein** | – | – | – | – | Deskriptiver Text zu Rücken, Bauch und Füßen |
| Kurs 2 | `anat_4` | Brust, Damm und Po – bei allen Körpern | **optional** | Diagramm | Schematischer Verlauf des Nervus pudendus und seiner Äste im Beckenbereich | ja | mittel | Zeigt gemeinsame nervliche Versorgung ohne Nacktheit |
| Kurs 2 | `anat_5` | Deine eigene Landkarte | **ja** | Diagramm | Neutrale Matrix und Legende zur Erstellung einer persönlichen erogenen Landkarte | ja | mittel | Praktische Vorlage für die individuelle Erkundung |
| Kurs 3 | `beauty_1` | Der Mythos vom perfekten Körper | **nein** | – | – | – | – | Medienkritischer Reflexionstext |
| Kurs 3 | `beauty_2` | Der freundliche Blick in den Spiegel | **nein** | – | – | – | – | Selbstreflexion vor dem Spiegel |
| Kurs 3 | `beauty_3` | Sexy ist ein Gefühl, kein Maß | **nein** | – | – | – | – | Einstellungs- und Mindset-Lektion |
| Kurs 3 | `beauty_4` | Licht an: Scham im Bett lösen | **nein** | – | – | – | – | Psychologischer Umgang mit Scham |
| Kurs 3 | `beauty_5` | Wenn der Körper sich verändert | **nein** | – | – | – | – | Thematisiert Alterung und Körperveränderungen |
| Kurs 3 | `beauty_6` | Verpackt: Wäsche für jeden Körper | **optional** | Stimmungsbild | Stilisierte Schnittformen verschiedener Wäschestücke auf neutralen Bügeln | nein | niedrig | Ruhiges Bild zur Entdramatisierung von Erotikwäsche |
| Kurs 4 | `spec_1` | Die Beobachter-Falle | **ja** | Diagramm | Gegenüberstellung von Außenperspektive (Prüfer-Kamera) und Innenperspektive (Sinnesfluss) | ja | mittel | Macht den Mechanismus des Spectatoring anschaulich |
| Kurs 4 | `spec_2` | Spüren statt prüfen: Die Kunst der Aufmerksamkeit | **nein** | – | – | – | – | Anleitung zur Achtsamkeitslenkung |
| Kurs 4 | `spec_3` | Audio-Praxis: Sinnes-Anker und Körperreise | **nein** | – | – | – | – | Audio-Übung mit Sinnesankern |
| Kurs 5 | `pain_1` | Wenn Sex wehtut | **ja** | Ablauf | Schmerz-Verspannungs-Spirale mit somatischen Rückkopplungen und Ausstiegswegen | ja | hoch | Klärt über Schmerzentstehung und Vaginismus/Dyspareunie auf |
| Kurs 5 | `pain_2` | Wenn die Erektion nicht mitspielt | **ja** | Diagramm | Gefäß- und Nervenmechanik: Parasympathikus (Füllung) vs. Sympathikus (Abfluss) | ja | hoch | Baut Leistungsdruck ab durch Aufklärung über autonome Reflexe |
| Kurs 5 | `pain_3` | Zu früh kommen: Kontrolle durch Entspannung | **ja** | Diagramm | Erregungsskala von 1 bis 10 mit Markierung des Point of no Return und Entspannungsfenster | ja | hoch | Standard-Therapiemodell zur Ejakulationskontrolle |
| Kurs 5 | `pain_4` | Scham: Wenn der eigene Körper im Weg steht | **nein** | – | – | – | – | Psychologische Auseinandersetzung mit Körperscham |
| Kurs 6 | `body_1` | Lebendig statt perfekt | **nein** | – | – | – | – | Reflexion über Perfektionismus |
| Kurs 6 | `body_2` | Erotische Reife: Was mit den Jahren besser wird | **nein** | – | – | – | – | Text über erotische Reife im Lebenslauf |
| Kurs 6 | `body_3` | Audio-Praxis: Ein freundlicher Blick auf den eigenen Körper | **nein** | – | – | – | – | Audio-Praxis für Selbstmitgefühl |
| Kurs 7 | `pelvic_1` | Zu fest statt zu schwach | **ja** | Diagramm | Dreidimensionales Schalenmodell des Beckenbodens mit Pfeilen für Heben, Senken und Weiten | ja | hoch | Korrigiert das Missverständnis des reinen Anspannens |
| Kurs 7 | `pelvic_2` | Anspannen und Öffnen: zwei Bewegungen | **ja** | Ablauf | Phasenkurve einer Kontraktion mit betonter, verlängerter Entspannungs- und Öffnungsphase | ja | hoch | Unterstützt direkt den Beckenboden-Timer der App |
| Kurs 7 | `pelvic_3` | Hüfte und Becken weit werden lassen | **ja** | Diagramm | Stilisierte Posen zur passiven Beckenöffnung (Hocke, Schmetterlingssitz) mit Kraftlinien | ja | mittel | Erklärt Haltungen zur Entlastung des Beckens |
| Kurs 7 | `pelvic_4` | Audio-Praxis: Schnell zur Ruhe kommen | **nein** | – | – | – | – | Audio-Übung zur Entspannung |
| Kurs 8 | `self_1` | Warum sich selbst erkunden? | **nein** | – | – | – | – | Pädagogischer Einführungstext |
| Kurs 8 | `self_2` | Mit Vulva: sieben Arten, dich zu berühren | **vorhanden** | Diagramm | Sieben Berührungsarten der Vulva (vorhanden: diagram_selbst_vulva.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 8 | `self_3` | Mit Penis: sieben Arten, dich zu berühren | **vorhanden** | Diagramm | Sieben Berührungsarten des Penis (vorhanden: diagram_selbst_penis.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 8 | `self_4` | Was du entdeckt hast, teilen | **nein** | – | – | – | – | Kommunikation mit dem Partner über Selbstbefriedigung |
| Kurs 8 | `self_5` | Audio-Reise: Zeit mit dir | **nein** | – | – | – | – | Geführte Audio-Reise |
| Kurs 9 | `female_1` | Der weibliche Beckenboden: Loslassen statt Festhalten | **optional** | Diagramm | Schematischer Schichtenaufbau der vaginalen Muskelschlingen | ja | niedrig | Ergänzung zu Kurs 7 für die weibliche Beckenanatomie |
| Kurs 9 | `female_2` | Kopfkino und der Druck, schnell genug zu sein | **nein** | – | – | – | – | Umgang mit Zeitdruck beim Orgasmus |
| Kurs 9 | `female_3` | Die Klitoris: größer, als man denkt | **ja** | Diagramm | Dreidimensionale Architektur des Klitoris-Netzwerks mit Eichel, Schenkeln und Schwellkörpern | ja | hoch | Zentrales Aufklärungsdiagramm (Klitoris-Eisberg-Modell) |
| Kurs 9 | `female_4` | Der Zyklus und die Lust | **ja** | Diagramm | Zyklusrad mit Hormonkurven (Östrogen, Progesteron) und typischen Lustphasen | ja | mittel | Visualisiert hormonelle Einflüsse auf Energie und Libido |
| Kurs 10 | `dopa_1` | Schnelle Reize und das Belohnungssystem | **ja** | Diagramm | Vergleichskurve: Schneller Dopamin-Peak (Kick & Crash) vs. getragene Plateaulinie | ja | mittel | Macht neurochemische Gewöhnungseffekte verständlich |
| Kurs 10 | `dopa_2` | Zeit mit dir selbst, neu gedacht | **nein** | – | – | – | – | Praxisanregungen zur Reizreduktion |
| Kurs 10 | `dopa_3` | Audio-Praxis: Wellen statt Sprint | **nein** | – | – | – | – | Audio-Praxis |
| Kurs 11 | `prost_1` | Anatomie ohne Scham | **ja** | Diagramm | Neutraler Querschnitt der männlichen Beckenorgane (Blase, Prostata, Damm, Rektum) | ja | hoch | Gibt räumliche Orientierung und nimmt Ängste |
| Kurs 11 | `prost_2` | Der Damm: Die Brücke von außen | **ja** | Diagramm | Zonenkarte des äußeren Damms mit Ansatzpunkten für Druck und Streichung | ja | mittel | Zeigt Zugang zur äußeren Prostata-Stimulation |
| Kurs 11 | `prost_3` | Der Weg nach innen: Langsam, sicher, ohne Ziel | **optional** | Ablauf | Schrittweise Sicherheits-Checkliste (Hygiene, Entspannung, Gleitmittel, Winkel) | ja | niedrig | Ablaufschritte für sichere Erkundung |
| Kurs 11 | `prost_s1` | Spicy: Prostata-Massage von innen | **nein** | – | – | – | – | Spicy-Lektion; detaillierte Illustrationen gehören ins R2-Paket |
| Kurs 12 | `comm_1` | Warum Verstecken den Druck verdoppelt | **nein** | – | – | – | – | Psychologischer Text zu Sprachlosigkeit |
| Kurs 12 | `comm_2` | Das Gespräch öffnen | **nein** | – | – | – | – | Gesprächsleitfaden für Paare |
| Kurs 12 | `comm_3` | Gemeinsam zur Ruhe kommen | **nein** | – | – | – | – | Übung zur Beruhigung vor dem Gespräch |
| Kurs 13 | `desire_1` | Kein Defekt: Warum Lust selten gleich verteilt ist | **ja** | Diagramm | Zirkuläres Modell reaktiver Lust (Basson) im Vergleich zum linearen Triebmodell | ja | hoch | Klärt über das Konzept der reaktiven Lustbereitschaft auf |
| Kurs 13 | `desire_2` | Der Teufelskreis aus Drängen und Ausweichen | **optional** | Ablauf | Dynamik-Schleife zwischen Initiative, Druckempfinden, Rückzug und Frustration | ja | mittel | Macht Beziehungsmuster ohne Schuldzuweisung sichtbar |
| Kurs 13 | `desire_3` | Das Lust-Menü: Mehr als Ja oder Nein | **optional** | Diagramm | Stufenleiter der Intimität (Präsenz, Zärtlichkeit, Massage, Erotik, Vereinigung) | ja | niedrig | Veranschaulicht Zwischenschritte zwischen Rückzug und Vollzug |
| Kurs 13 | `desire_4` | Bedingungen für Lust: Was eure Bremse löst | **nein** | – | – | – | – | Analyse individueller Lustbedingungen |
| Kurs 14 | `phase_1` | Nach der Geburt: Ein neuer Körper, ein neues Paar | **nein** | – | – | – | – | Sexualität nach der Entbindung |
| Kurs 14 | `phase_2` | Wechseljahre: Wenn sich die Lust verändert | **optional** | Diagramm | Schutz- und Befeuchtungsfaktoren der Schleimhaut im hormonellen Wandel | ja | niedrig | Funktionale Übersicht über Pflege und Gleitmittel |
| Kurs 14 | `phase_3` | Mit den Jahren: Langsamer, aber nicht weniger | **nein** | – | – | – | – | Sexualität im Alter |
| Kurs 14 | `phase_4` | Krankheit, Medikamente und Krisen | **nein** | – | – | – | – | Einfluss von Medikamenten und Erkrankungen |
| Kurs 15 | `tease_1` | Das Neunzig-Prozent-Prinzip: Vorfreude statt Pflichtprogramm | **optional** | Diagramm | Spannungsverlauf: Beenden bei 90 % Erregung zur Konservierung von Vorfreude | ja | niedrig | Stellt das Plateau-Prinzip zeitlich dar |
| Kurs 15 | `tease_2` | Die Kunst der Zeitlupe | **nein** | – | – | – | – | Übung in extremer Verlangsamung |
| Kurs 15 | `tease_3` | Vorfreude im Alltag: Die Kunst der Andeutung | **nein** | – | – | – | – | Alltagsandeutungen |
| Kurs 16 | `alltag_1` | Das erotische Klima | **nein** | – | – | – | – | Atmosphäre im Beziehungsalltag |
| Kurs 16 | `alltag_2` | Vorfreude über den Tag | **nein** | – | – | – | – | Aufbau von Tagesspannung |
| Kurs 16 | `alltag_3` | Rituale gegen Routine | **nein** | – | – | – | – | Feste Zeitfenster und Rituale |
| Kurs 16 | `alltag_4` | Kleine Spiele für zwischendurch | **nein** | – | – | – | – | Mikro-Interaktionen |
| Kurs 16 | `alltag_5` | Allein erotisch bleiben | **nein** | – | – | – | – | Eigene Lust im Alltag lebendig halten |
| Kurs 16 | `alltag_9` | Gut verpackt: Wäsche im Alltag | **nein** | – | – | – | – | Wäsche und Stoffe im Alltag |
| Kurs 16 | `alltag_11` | Striptease zum Mitmachen | **nein** | – | – | – | – | Spielerische Anleitung |
| Kurs 16 | `alltag_6` | Heiße Nachrichten | **nein** | – | – | – | – | Spicy-Lektion; Nachrichten im Alltag |
| Kurs 16 | `alltag_7` | Quickies | **nein** | – | – | – | – | Spicy-Lektion; Quickies |
| Kurs 16 | `alltag_8` | Ein Tag voller Spannung | **nein** | – | – | – | – | Spicy-Lektion; Spannungsaufbau |
| Kurs 16 | `alltag_10` | Heiß verpackt | **nein** | – | – | – | – | Spicy-Lektion; Dessous |
| Kurs 17 | `couples_1` | Sensate Focus: In drei Stufen zurück zur Leichtigkeit | **ja** | Ablauf | Drei-Stufen-Modell des Sensate Focus (Nicht-Genital, Genital-Absichtslos, Vereinigung) | ja | hoch | Klassisches therapeutisches Stufenprogramm |
| Kurs 17 | `couples_2` | Bauch an Bauch: gemeinsam atmen | **ja** | Diagramm | Phasendiagramm synchroner Sinuswellen zur Veranschaulichung geteilter Atmung | ja | mittel | Visualisiert Co-Regulation des Nervensystems |
| Kurs 17 | `couples_3` | Die Ampel: Wünsche und Grenzen ohne Kränkung | **ja** | Diagramm | Drei-Zonen-Ampelsystem (Grün, Gelb, Rot) mit Handlungsempfehlungen | ja | hoch | Klares visuelles Signal-System für Paare |
| Kurs 18 | `touch_w_1` | Gleichmäßigkeit: Wenn genau so genau so bleiben darf | **nein** | – | – | – | – | Bedeutung gleichförmigen Rhythmus |
| Kurs 18 | `touch_w_2` | Umkreisen und der flache Finger | **vorhanden** | Diagramm | Umkreisende Fingerbewegung und flache Auflage (vorhanden: diagram_umkreisen.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 18 | `touch_w_3` | Wellen statt Sprint: Das Plateau genießen | **vorhanden** | Diagramm | Plateau- und Wellenverlauf der Erregung (vorhanden: diagram_wellen.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 18 | `touch_w_4` | Reiz-Schichtung: Wenn der Kopf Pause machen darf | **optional** | Diagramm | Schichtenmodell sich überlagernder Reize (Rhythmus, Atmung, Druck, Vibration) | ja | niedrig | Veranschaulicht multisensorische Erregung |
| Kurs 18 | `touch_w_s1` | Spicy: Die Klitoris richtig verwöhnen | **nein** | – | – | – | – | Spicy-Lektion; gehört ins R2-Paket |
| Kurs 19 | `touch_m_1` | Offene Hand statt Klammergriff | **ja** | Diagramm | Druckverteilung und Handhaltung: Flächige Berührung vs. beengender Klammergriff | ja | mittel | Hilft gegen Taubheitsgefühle durch zu festen Griff |
| Kurs 19 | `touch_m_2` | Das ganze Becken einbeziehen: Wurzel, Leisten und Damm | **vorhanden** | Diagramm | Zonen des Lingam und Beckenraums (vorhanden: diagram_lingam_zones.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 19 | `touch_m_3` | Wellen surfen: Ausdauer durch mehr Gefühl statt weniger | **vorhanden** | Diagramm | Erregungswellen surfen (vorhanden: diagram_wellen.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 19 | `touch_m_4` | Loslassen statt Zukneifen: Der entspannte Beckenboden | **nein** | – | – | – | – | Entspannung des Beckenbodens; inhaltlich durch Kurs 7 abgedeckt |
| Kurs 19 | `touch_m_5` | Höhepunkt und Samenerguss: Zwei Vorgänge, die sich trennen lassen | **ja** | Ablauf | Zeitstrahldiagramm zur Trennung von orgastischem Peak und motorischem Samenerguss | ja | hoch | Erklärt die physiologische Entkopplung beider Vorgänge |
| Kurs 19 | `touch_m_s1` | Spicy: Handarbeit, die umhaut | **nein** | – | – | – | – | Spicy-Lektion; gehört ins R2-Paket |
| Kurs 20 | `mass_1` | Einer gibt, einer empfängt | **optional** | Stimmungsbild | Atmosphärisches Arrangement für Paarmassage (Tuch, Ölschale, warmes Licht) | nein | niedrig | Stimmt auf achtsames Massagesetting ein |
| Kurs 20 | `mass_2` | Die Yoni-Massage: Behutsam und Schritt für Schritt | **vorhanden** | Diagramm | Zifferblatt der Yoni-Massage (vorhanden: diagram_yoni_clock.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 20 | `mass_3` | Die Lingam-Massage: Berührung ohne Erfolgsdruck | **vorhanden** | Diagramm | Zonen der Lingam-Massage (vorhanden: diagram_lingam_zones.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 20 | `mass_4` | Audio-Ritual: Geführte Paar-Massage | **nein** | – | – | – | – | Geführtes Audio-Ritual |
| Kurs 20 | `mass_s1` | Spicy: Massage mit Höhepunkt | **nein** | – | – | – | – | Spicy-Lektion; gehört ins R2-Paket |
| Kurs 21 | `vocal_1` | Das Stummfilm-Muster im Bett | **ja** | Diagramm | Faszienschematische Achse zwischen Kiefergelenk, Stimmritze und Beckenboden | ja | mittel | Erklärt neurosomatische Verbindung von Mund und Becken |
| Kurs 21 | `vocal_2` | Audio-Praxis: Kiefer lösen und tiefe Töne | **nein** | – | – | – | – | Audio-Übung für Töne und Atmung |
| Kurs 21 | `vocal_3` | Laute als Wegweiser: Ohne Worte sagen, was gefällt | **nein** | – | – | – | – | Kommunikation durch Laute |
| Kurs 21 | `vocal_s1` | Spicy: Lauter werden zu zweit | **nein** | – | – | – | – | Spicy-Lektion; gehört ins R2-Paket |
| Kurs 22 | `pos_1` | Wiegen statt Stoßen: Die hohe Verschmelzung | **vorhanden** | Diagramm | Coital Alignment Technique / Wiegen (vorhanden: diagram_cat_position.svg) | ja | – | Bereits als SVG-Diagramm in der App |
| Kurs 22 | `pos_2` | Positionen für Ausdauer und eine entspannte Erektion | **ja** | Diagramm | Geometrische Haltelinien der Löffelhaltung mit Gewichtsabgabe an die Unterlage | ja | hoch | Zeigt Ausdauerförderung durch Muskelentlastung |
| Kurs 22 | `pos_3` | Positionen für ein enges Becken und sanftes Öffnen | **ja** | Diagramm | Keilkissen-Winkeldiagramm zur Entlastung des Beckens und Optimierung des Eintrittswinkels | ja | hoch | Praktische Lösung bei Schmerzen und Beckenenge |
| Kurs 22 | `pos_s1` | Spicy: Stellungen für Tiefe und Intensität | **nein** | – | – | – | – | Spicy-Lektion; Stellungen für R2-Paket |
| Kurs 23 | `fant_1` | Kontrolle abgeben, Kontrolle übernehmen | **nein** | – | – | – | – | Psychologie von Führung und Hingabe |
| Kurs 23 | `fant_2` | Fantasien teilen, ohne zu verunsichern | **nein** | – | – | – | – | Leitfaden zum Aussprechen von Fantasien |
| Kurs 23 | `fant_3` | Spiele sicher gestalten: Absprache, Signale, Nachsorge | **optional** | Ablauf | Vier-Phasen-Ablauf sicherer Rollenspiele (Absprache, Signale, Spiel, Aftercare) | ja | mittel | Sicherheits- und Fürsorgeleitfaden für Paare |
| Kurs 23 | `fant_s1` | Spicy: Rollenspiele und Machtspiele mit Drehbuch | **nein** | – | – | – | – | Spicy-Lektion; gehört ins R2-Paket |
| Kurs 24 | `scen_1` | Szenario eins: Hingabe mit verbundenen Augen | **optional** | Stimmungsbild | Stilisierte Seidenaugenbinde mit sanften Tastsinn-Wellen | nein | niedrig | Fokussiert auf sensorische Deprivation |
| Kurs 24 | `scen_2` | Szenario zwei: Nicht bewegen – sanftes Festhalten | **nein** | – | – | – | – | Szenario sanftes Festhalten |
| Kurs 24 | `scen_3` | Szenario drei: Worte, die berühren | **nein** | – | – | – | – | Szenario erotische Sprache |
| Kurs 24 | `scen_4` | Audio-Reise: Geführte Fantasie unter der Seidenbinde | **nein** | – | – | – | – | Audio-Reise |
| Kurs 24 | `scen_s1` | Spicy: Drei heiße Szenarien zum Nachspielen | **nein** | – | – | – | – | Spicy-Lektion; Szenarien für R2-Paket |
| Kurs 25 | `toys_1` | Ersetzt mich das? | **nein** | – | – | – | – | Vorurteile und Scham abbauen |
| Kurs 25 | `toys_2` | Der Überblick: Was es gibt | **ja** | Diagramm | Katalog neutraler Silhouetten der Hauptkategorien (Auflege-, Druckwellen-, Ring-, Analtoys) | ja | hoch | Strukturierte Toy-Übersicht für Einsteiger (Pilotkurs) |
| Kurs 25 | `toys_3` | Material, Pflege und Gleitmittel | **ja** | Diagramm | Kompatibilitätsmatrix: Toy-Materialien (Silikon, Glas, Metall, ABS) vs. Gleitmittelarten | ja | hoch | Verhindert Materialschäden und Reizungen (Pilotkurs) |
| Kurs 25 | `toys_4` | Sicherheit: Wo es heikel wird | **ja** | Diagramm | Sicherheitsampel: Breiter Sockel (Flared Base), Wasserdichtigkeit und Stoppsignale | ja | hoch | Zentrales Unfallschutz-Diagramm (Pilotkurs) |
| Kurs 25 | `toys_5` | Kaufen, aufbewahren, diskret bleiben | **optional** | Diagramm | Materialschonende Aufbewahrung (Baumwollbeutel, UV-Schutz, Trennung) | ja | niedrig | Praxistipps für Haltbarkeit und Diskretion |
| Kurs 25 | `toys_6` | Zu zweit darüber sprechen | **nein** | – | – | – | – | Kommunikationsleitfaden für das Paargespräch |
| Kurs 25 | `toys_7` | Allein mit Toy: ein Stufenplan | **optional** | Ablauf | Fünf-Stufen-Leiter zur schrittweisen, druckfreien Erkundung von Toys allein | ja | mittel | Nimmt Hemmschwellen beim Ausprobieren |
| Kurs 25 | `toys_8` | Zu zweit mit Toy: Führen und geführt werden | **nein** | – | – | – | – | Paaranwendung von Toys |

*Gesamtzahl untersuchter Lektionen: 113 (genau 113 Lektionen der Kurse 1 bis 25).*

## Zusammenfassung und Auswertung

### Mengen und Anteile

- **Bereits vorhanden:** 9 Lektionen (8.0 %)
- **Bild hilft (ja):** 27 Lektionen (23.9 %)
- **Optional sinnvoll:** 15 Lektionen (13.3 %)
- **Kein Bild nötig (nein):** 62 Lektionen (54.9 %)
- **Quote „ja“ + „optional“:** 42 von 113 Lektionen = **37.2 %** (Vorgabe: maximal ~40 % eingehalten).

### Verteilung nach Art der neu vorgeschlagenen Bilder (ja & optional)

- **Diagramme (Erklär-Grafiken, Schemata, Anatomie, Haltung, Skalen):** 30
- **Abläufe (Phasen, Zyklen, Stufenmodelle, Checklisten):** 9
- **Stimmungsbilder (ruhige Settings, Gegenstände):** 3
- **Beschriftung:** Bei 39 Bildern ist eine zweisprachige Beschriftung (DE/EN) zwingend erforderlich; 3 Stimmungsbilder kommen ohne Text aus.

### Die zehn wichtigsten Bilder

Diese zehn Bilder besitzen den höchsten didaktischen Mehrwert und klären entscheidende Missverständnisse oder Sicherheitsfragen:
1. **`toys_3` (Kurs 25): Material- und Gleitmittel-Kompatibilität** – Matrix: Silikon, Glas, Metall, ABS vs. Wasser, Silikon, Öl (schützt vor Materialzerstörung und Infektionen; Pilotkurs).
2. **`toys_4` (Kurs 25): Sicherheits-Kriterien für Toys** – Ampel: Breiter Sockel (Flared Base für Analbereich), Wasserdichtigkeit, Stopp-Signal (verhindert Unfälle; Pilotkurs).
3. **`toys_2` (Kurs 25): Systematische Toy-Übersicht** – Stilisierte Silhouetten der Hauptkategorien (Auflege-, Druckwellen-, Ring-, Analtoys) zur Orientierung ohne Überforderung (Pilotkurs).
4. **`neuro_1` (Kurs 1): Duales Kontrollmodell (Gaspedal & Bremse)** – Schematische Waage aus erregenden Reizen und Hemmfaktoren; Fundament der Sexualtherapie.
5. **`female_3` (Kurs 9): Das vollständige Klitoris-Netzwerk** – Dreidimensionale Architektur (Eichel, Schenkel, Schwellkörper); baut das weit verbreitete Missverständnis der Klitoris als reiner kleiner Punkt ab.
6. **`prost_1` (Kurs 11): Anatomischer Lageplan der Prostata** – Schematischer Querschnitt zur Orientierung; nimmt Ängste und verhindert falsches Vorgehen.
7. **`pain_3` (Kurs 5): Erregungsskala (1 bis 10)** – Skalenmodell mit Point of no Return bei Stufe 8 und Zone rechtzeitiger Entspannung; Schlüssel zur Ejakulationskontrolle.
8. **`pelvic_1` (Kurs 7): Schalen- und Weitungsmodell des Beckenbodens** – Verdeutlicht, dass Beckenbodentraining vor allem Öffnen und Entspannen statt ständiges Zukneifen bedeutet.
9. **`couples_1` (Kurs 17): Drei Phasen des Sensate Focus** – Stufenmodell nach Masters & Johnson (Nicht-Genital, Genital-Absichtslos, Vereinigung) als Paar-Orientierung.
10. **`pos_3` (Kurs 22): Keilkissen-Prinzip & Beckenwinkel** – Geometrisches Schema zur Veränderung des Eintrittswinkels; simple mechanische Lösung bei Schmerzen oder Engegefühl.

### Empfohlene Reihenfolge der Umsetzung

1. **Pilotkurs: Kurs 25 („Toys“)**
   - Beginn mit den drei Kernbildern `toys_2`, `toys_3` und `toys_4` (bereits in AG-11 als Probe skizziert).
   - Klärt die grafische Sprache, SVG-Format, Farbpalette (`#140D1C`, `#0F172A`, Akzent `#FB7185`) und zweisprachige Beschriftung (DE/EN).
2. **Stufe 1: Grundlegende Erklär-Modelle & Anatomie (hohe Priorität)**
   - Kurs 1 (`neuro_1`, `neuro_2`), Kurs 9 (`female_3`, `female_4`), Kurs 11 (`prost_1`, `prost_2`), Kurs 2 (`anat_5`).
   - Baut die didaktische Basis der App massiv aus.
3. **Stufe 2: Körpermechanik & Entlastung (hohe Priorität)**
   - Kurs 7 (`pelvic_1`, `pelvic_2`, `pelvic_3`), Kurs 5 (`pain_1`, `pain_2`, `pain_3`), Kurs 10 (`dopa_1`).
   - Direkte Unterstützung für Übungsfunktionen (Beckenboden-Timer) und Schmerzbewältigung.
4. **Stufe 3: Paardynamik, Haltung & Technik (mittlere Priorität)**
   - Kurs 17 (`couples_1`, `couples_2`, `couples_3`), Kurs 19 (`touch_m_1`, `touch_m_5`), Kurs 22 (`pos_2`, `pos_3`), Kurs 13 (`desire_1`), Kurs 21 (`vocal_1`), Kurs 4 (`spec_1`).
   - Unterstützt die Beziehungs- und Stellungslektionen.
5. **Stufe 4: Optionale Verfeinerungen & Stimmungsbilder (niedrige Priorität)**
   - Umsetzung der 15 optionalen Grafiken nach Feedback des Nutzers und praktischem Bedarf in der App.
