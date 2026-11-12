# Konzept: Eine Tonlage, alle Paare

Stand: Entwurf vom 12.11.2026, **noch nicht abgestimmt**. Erarbeitet von Sexualtherapeut:in (Texte), Designer:in (Aufbau),
Grafiker:in (Bilder) und Programmierer:in (Stellen im Code). Umgesetzt wird erst nach dem OK des Nutzers.
Nicht Teil dieses Pakets: KI-Coach (`coach-entfernen.md`) und SOS (`sos-neu.md`).

## Stand der Umsetzung (12.11.2026)

Stufen 1 bis 5 sind gebaut auf Branch `claude/eine-tonlage-20261112` (Commits e937d14, 4a4085a, 5de0f85, 4534e97, c55cb33,
5cdeacf). **Nicht veröffentlicht, nicht zusammengeführt.**

Abweichungen vom Entwurf:

- Der Satz zur Privatsphäre im Einladungs-Bildschirm 2 ist neu formuliert: Wunsch-Stimmen gehen verbunden sofort ans Gegenüber,
  Lesebestätigungen sind standardmäßig an (abschaltbar).
- Die Körperfrage steht nur im Profil; Selbst-Reise und Lust im Traum fragen selbst.
- Der Paar-Abend nimmt kein „anderes Geschlecht“ mehr an.
- Die Karte „Eure erste Woche“ steht im Tab Wir oben über den Tabs, nur bei genug Höhe.
- Die Symbole sind noch Material-Icons (SVG-Symbole offen).

Noch offen: Lektionstexte und Neuaufnahmen (Frau/Mann-Liste unten), der AG-Bildauftrag ist noch nicht in `AG.md`, und der
Eintrag in „Was ist neu“ fehlt (braucht die Build-Nummer). Anleitung (DE/EN) ist nachgezogen. Folgepunkte in `docs/AUFGABEN.md`.

Maßstab: Die App soll zwei Menschen einander näherbringen. Nichts erzeugt Druck, niemand wird ausgeschlossen, ein Nein ist
immer eine vollwertige Antwort.

## Ziele

- **a)** Fachjargon raus aus Einstieg, Check-in, Begrüßungen, Einstellungen (Abschnitt 1).
- **b)** Fantasie-Landkarte ruhiger (Abschnitt 2).
- **c)** Keine Hetero-Annahme: Geschlechtsfrage, Filter, Wunschkarten, Beispieltexte (Abschnitte 3, 5).
- **d)** „Eure erste Woche“ und sanfter Start für die eingeladene Person (Abschnitt 4).
- **e)** Startseite bei Fokus „Paar“ mit deutlich weniger Blöcken (Abschnitt 6).

## Wichtige Befunde (aus dem Code)

1. **Der Standard `male`** steht im Onboarding (`onboarding_screen.dart:42`) und in `UserProfile.fromJson`. Wer nur „Weiter“ tippt oder
   „Überspringen“ wählt, wird als Mann gespeichert. Alle, die nicht `male` sind, bekommen still Stimme Victoria und Körper Vulva
   (`selbst_reise_screen.dart`, `lust_im_traum_screen.dart`, `einschlaf_reise_screen.dart`, `wecken_screen.dart`, `kegel_timer_view.dart`).
2. **Das Überspringen speichert** außerdem Alter 32 und Fokus „Leistungsdruck“. Auf Heute steht dann „Dein Fokus: Leistungsdruck lösen“.
3. **Der Paar-Abend** nimmt bei unbekanntem Gegenüber das „andere Geschlecht“ an (`paar_abend_screen.dart:128–142`).
4. **Das Jubel-Banner** der Landkarte erscheint immer, sobald verbunden, auch bei null Treffern („VOLLTREFFER … 0 …“).
5. **Der Satz „Ein Match ist eine Einladung, kein Versprechen“** steht in `couplesChannelAMatchIsAnInvitation` (Paar-Kanal-Banner),
   nicht in `yesNoMaybe*`.
6. **Die Einladung trägt kein Zeichen** (fester GitHub-Link). Die App kann nicht erkennen, dass jemand eingeladen wurde.
7. **„Eure erste Woche“ gibt es noch nicht.** Auch die Schrittinhalte sind neu zusammengestellt (aus vorhandenen Lektionen, Abschnitt 4).
8. **Gesprochene Texte:** Kurstitel werden nicht gesprochen, Lektionstitel und -inhalte schon (`generate_audio.py: speech_text`). Texte in
   Lektionen mit „Frau/Mann“ werden daher **in dieser Sitzung nicht geändert**, sondern als Liste gemeldet (Abschnitt 3d).
9. **Der Fehler in `dailySimmeringCardCoursesBody`** (EN „3 & 9“, DE „7 & 9“) wird mitkorrigiert.

## Vorschlag zum Vorgehen und zur Reihenfolge der Umsetzung

Je Stufe ein Commit auf einem eigenen Branch (`claude/eine-tonlage-<datum>`), Tests je Stufe:

1. **Texte (a, b):** nur ARB DE/EN, kleine Codeänderung an der Landkarte (Banner nur bei Treffern, Großschreibung weg, leiseres Symbol).
2. **Geschlecht und Filter (c):** `unspecified`, 2×2-Auswahl ohne Vorauswahl, neutraler Fokus beim Überspringen, Filterbeschriftung, Titel Kurs 18/19, Wunschkarten.
3. **Sanfter Start (d, zweiter Teil):** Weg „Jemand hat mich eingeladen“ im Onboarding, Einladungstext.
4. **Eure erste Woche (d, erster Teil):** Datenhaltung in `BedienDaten`, Karte, Schritt-Seite.
5. **Heute bei Paar-Fokus (e):** Paar-Zweig auf der Startseite.

## Entscheidungen im Entwurf (zum Bestätigen)

- **Geschlecht:** Vier Karten Frau, Mann, Divers, Keine Angabe im 2×2-Raster, **keine Vorauswahl**. Neuer Wert `unspecified`; `fromJson` liefert ihn bei
  fehlendem Schlüssel (gespeicherte `male/female/other` bleiben). Stimme und Körper werden bei `unspecified` weiter als Voreinstellung
  vorgeschlagen, nie als Tatsache.
- **Körperfrage:** nicht als sechste Onboarding-Seite, sondern im Profil und einmalig beim ersten Gebrauch einer Übung, die den Körper braucht
  (mit „Später fragen“). Wert gehört in `StorageService`, Sicherung und Backup-Merge. Der Paar-Abend fragt „Wer empfängt?“ statt „anderes Geschlecht“ anzunehmen.
- **Kurs-Filter:** Werte `all/women/men/couples` bleiben (kein Migrationsaufwand, Stimmenwahl der Aufnahmen hängt an `category`), nur die Beschriftung wird körperbezogen:
  „Alle Kurse / Zu zweit / Mit Vulva / Mit Penis“. Die Vorbelegung nach Geschlecht entfällt, Standard ist „Alle Kurse“.
- **Eure erste Woche:** lokal, ohne Prozente, Serien, Erinnerungen. Je Schritt „Heute nicht“ ohne Folge. Teilen nur freiwillig als vorformulierte Nachricht („Sagen, wo ich bin“).
  Speicherort: neues Feld in `BedienDaten` (Sicherung und Merge gratis; `saveBedienDaten` muss das Feld ausdrücklich führen).
- **Paar-Modus auf Heute:** gilt bei `primaryGoal == couple_intimacy` und `relationshipStatus != single`. Der Rest wandert hinter „Mehr für dich allein“
  (eingeklappt, nur für die Sitzung, kein neuer Speicherschlüssel).
- **Sanfter Start:** dritter Weg unter „Loslegen“: „Jemand hat mich eingeladen“; drei kurze Bildschirme, „Ich schau erst mal nur“ immer sichtbar.
- **Wunschkarten:** Titel „(Nur für Sie/Ihn)“ werden „(eine Person empfängt)“; die IDs `match_yoni_ritual` und `match_lingam_ritual` bleiben (werden mit dem Gegenüber abgeglichen).
  Die Karten stehen dreifach (`velvet_content.json`, `couple_channel_models.dart`, `translations/en/*`), alle gemeinsam ändern.

## Bilder und Symbole (Grafiker:in)

Menschen nur im vorhandenen Bleistift-Stil (über AG), keine Fotobilder, Symbole als SVG von mir. Bis Bilder da sind, bleiben die bestehenden Platzhalter
(`VpBildFeld` zeichnet nie eine leere Fläche).

| Was | Wer | Priorität |
|---|---|---|
| `bereich.zu_zweit.kopf`, `bereich.erste_woche.kopf` (je Paarform: Frau+Mann, Frau+Frau, Mann+Mann, nicht eindeutig), `bereich.einladung.willkommen` (figurenlos oder „leerer Stuhl“) | AG (Bleistift), Auftrag unten | muss, mindestens „nicht eindeutig“ |
| Vier gleichwertige Symbole für die Geschlechtsauswahl (ohne Mars/Venus, „Keine Angabe“ als ruhiger Strichkreis) | Claude (SVG) | muss |
| Symbole „gemeinsames Ja“ und „gemeinsame Neugier“ (Landkarte, ersetzen `auto_awesome` und `check_circle`) | Claude (SVG) | muss |
| Symbole der Einladungsseiten (nichts erwartet, Nein gilt, bleibt auf dem Handy, nur schauen) | Claude (SVG) | muss |
| Schritt-Symbole der ersten Woche, Überschneidungs-Diagramm | Claude (SVG) | nett |

Technik: Symbole nach `assets/images/` mit Präfix `symbol_` (kein neuer pubspec-Eintrag, `assets/icons/` gibt es nicht); Register `bilder.json` braucht dafür
einen Abschnitt `symbole` (Entscheidung offen). Eine Paarform-Wahl für vierfache Bildvarianten gibt es im Code nicht: bis dahin nur die Variante „nicht eindeutig“.

**Entwurf Auftrag an AG** (wird erst nach OK in `AG.md` eingetragen): neun Bleistift-Motive als WebP (1536 × 1024) nach `build/redaktion/paar_bilder/`:
`bereich_zu_zweit_kopf_{fm,ff,mm,neutral}`, `bereich_erste_woche_kopf_{fm,ff,mm,neutral}`, `bereich_einladung_willkommen`; Stil wie AG-22 bis AG-24;
alle Figuren erwachsen und bekleidet, nichts Erotisches, keine Fotos; jedes Bild ansehen, Figurenzahl und Hände prüfen; `BERICHT.md` mit Tabelle; Branch `ag/paar-bilder-<datum>`;
`lib/`, `assets/`, `AG.md` nicht ändern.

## Heute bei Fokus „Paar“ (Aufbau, Designer:in)

Paar-Modus (siehe oben), von oben nach unten:

1. Kopf: Datum, Begrüßung, bei Kopplung „Du und {Name}“ (statt „Dein Fokus: …“), Schloss „Bleibt auf deinem Handy“.
2. Karte **Eure erste Woche** (ersetzt „Dein nächster Schritt“ als Hauptangebot; Menü: Überspringen, Ausblenden).
3. Abschnitt **Heute zu zweit**: Gemeinsamer Abend; Audios für euch (`AudioGruppe.fuerUns`); gekoppelt „Wir: Nachricht oder Funke an {Name}“, ungekoppelt „Partner:in einladen“ plus „Schon einen Code? Verbinden“.
4. Dünne Zeile „Aufnahmen laden“ (nur bei Bedarf, bleibt sichtbar, sonst sprechen gemeinsame Audios nur mit der Geräte-Stimme).
5. **Mehr für dich allein** (eingeklappt): Weg fortsetzen, nächster Schritt, Für heute (Check-in/Funke), Audios, Alle Kurse.

Single: unverändert. Dating/kompliziert mit Paar-Fokus: Paar-Modus, Unterzeile „Wenn ihr beide mögt – ein Nein ist vollwertig“. Beziehung mit anderem Fokus: heutige Seite, die Karte steht im Tab „Wir“.
Fortschritt als sieben Punkte (offen, gemeinsam gemacht, übersprungen, gleich ruhig), kein „3 von 7“. Knöpfe als `Wrap` (360 dp).

Betroffen: `courses_screen.dart` (Paar-Zweig, Kopf, Chips), `couples_channel_screen.dart` (Karte oben, Menü „wieder zeigen“), `bedien_daten.dart`, `storage_service.dart` (`saveBedienDaten`),
`user_profile.dart`, `onboarding_screen.dart`, ARB, Anleitung, „Was ist neu“, neue Widgets unter `lib/widgets/`.

## Texte (Therapeut:in): alt/neu in beiden Sprachen

Die Tabellen unten sind der vollständige Bericht der Fachrolle. Platzhalter bleiben unverändert, Schlüsselnamen ändern sich nicht (nur Werte),
generierte Dateien (`app_localizations*.dart`) entstehen durch `flutter gen-l10n`. Bei Schlüsseln „(nur ohne Coach)“ gilt: erst umsetzen, wenn der Coach wirklich entfernt ist.

### Teil 1. Jargon-Inventur und Neufassung

Platzhalter bleiben unverändert. Es werden nur Werte geändert, keine Schlüsselnamen.

**Befunde zum Ton**
- "Kopfkino" hat in der App zwei Bedeutungen: ängstliche Gedanken (Onboarding, Check-in) und erotische Fantasie (Kurs 24 "Kopfkino: Szenarien", Funke-Kachel). Im Einstieg verwirrt das. Ich nehme es dort heraus.
- Die Kachel "Leistungsdruck & Kopfkino stoppen" ist selbst ein Druckwort: stoppen, Priorität, Ziel.
- Die Ziel-Kacheln haben zwei Beschriftungssätze für dieselben Optionen: `onboarding*` und `userProfile*`. Beide sollten gleich lauten.
- Die Sätze zum KI-Coach (`onboardingVersprechenNetz`, `onboardingPrivateProfileJournalProgressStay`) sind überholt, wenn der Coach laut `docs/konzepte/coach-entfernen.md` entfällt. Ich markiere sie als "nur wenn der Coach wirklich weg ist".
- In den Bereichen `lautsprecher*`, `design*`, `hallo*`, `sprache*` und bei den Schlüsseln `heute*` fand ich keinen Jargon. Diese Texte sind ok.

### Teil 1a Onboarding und Profil-Fokus

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| onboardingYourPrivateCoachingProgrammeFor | Dein privates Coaching-Programm für somatische Ruhe, Beckenboden & Intimität. | Ein privater Begleiter für Ruhe im Körper, Beckenboden und Nähe. | Your private coaching programme for calm, pelvic floor & intimacy. | A private companion for calm in your body, your pelvic floor and closeness. | "Coaching-Programm" und "somatisch" sind Fachsprache. Das Wort Programm verspricht Leistung. |
| onboardingVersprechenNetz (nur ohne Coach) | Ins Netz geht nur, was du selbst einschaltest: KI-Coach, Paar-Kanal und die Suche nach Updates. | Ins Netz geht nur, was du selbst einschaltest: der Paar-Kanal und die Suche nach Updates. | Only what you switch on yourself goes online: the AI coach, the couple channel and the check for updates. | Only what you switch on yourself goes online: the couple channel and the check for updates. | Folge der Coach-Entfernung. |
| onboardingPrivateProfileJournalProgressStay (nur ohne Coach) | …Ins Internet gehen nur der KI-Coach (Google Gemini), der verschlüsselte Paar-Kanal und die Suche nach Updates (GitHub). | Privat: Profil, Tagebuch & Fortschritt bleiben auf deinem Handy. Ins Internet gehen nur der verschlüsselte Paar-Kanal und die Suche nach Updates (GitHub). | Private: profile, journal & progress stay on your phone. Only the AI coach (Google Gemini), the encrypted couple channel and the update check (GitHub) go online. | Private: profile, journal & progress stay on your phone. Only the encrypted couple channel and the update check (GitHub) go online. | Wie oben. |
| onboardingWhatSYourBiggestPriority | 5. Was ist aktuell deine größte Priorität? | 5. Was wünschst du dir im Moment am meisten? | 5. What's your biggest priority right now? | 5. What would you most like right now? | "Priorität" klingt nach Projektplan. Der Zusatz "Das kannst du jederzeit ändern" kann als eigene Zeile darunter stehen. |
| onboardingStopPerformancePressureRacingThoughts | Leistungsdruck & Kopfkino stoppen | Weniger Druck, ein ruhigerer Kopf | Stop performance pressure & racing thoughts | Less pressure, a calmer mind | "stoppen" ist ein Imperativ. "Kopfkino" ist doppeldeutig, siehe oben. |
| onboardingBreakThoughtLoopsStopSpectatoring | Gedankenkreise durchbrechen, Spectatoring beenden. | Aus dem Kopf zurück ins Spüren, ohne dich selbst zu beobachten. | Break thought loops, stop spectatoring. | Out of your head and back into feeling, without watching yourself. | "Spectatoring" ist ein Fachbegriff. In Kurs 4 heißt es "Beobachter-Falle". Der Begriff darf in der Lektion stehen, nicht im Einstieg. |
| onboardingPelvicFloorRelaxationBodyAwareness | Beckenboden-Entspannung & Somatik | Beckenboden entspannen & den Körper spüren | Pelvic floor relaxation & body awareness | Relax your pelvic floor & feel your body | "Somatik" ist Fachwort. EN war schon fast ok. |
| onboardingReleaseTensionPractiseReverseKegels | Hypertonie lösen, Reverse Kegel trainieren, Vagusnerv beruhigen. | Anspannung loslassen, den Beckenboden weich werden lassen, zur Ruhe kommen. | Release tension, practise reverse Kegels, calm down. | Let go of tension, let your pelvic floor soften, find calm. | Vier Fachwörter in einem Satz. Die Kurse nennen "Hypertonie" nicht. "Trainieren" ist wieder Leistung. |
| onboardingCoupleIntimacyPressureFreeSex | Paar-Intimität & Druckfreier Sex | Nähe zu zweit, ohne Druck | Couple intimacy & pressure-free sex | Closeness together, without pressure | "Druckfreier" ist falsch großgeschrieben. "Intimität" ist abstrakt. |
| onboardingSensateFocusTogetherCalmingEach | Sensate Focus zu zweit, Co-Regulierung & verletzliche Nähe. | Berührung ohne Ziel, gemeinsam zur Ruhe kommen, sich nahe sein dürfen. | Sensate focus together, calming each other & vulnerable closeness. | Touch without a goal, settling together, being allowed to be close. | Sensate Focus und Co-Regulierung sind Therapiewörter. In Kurs 17 heißt die Reihe "Nähe ohne Ziel". "Verletzlich" kann abschrecken. |
| onboardingDesireSelfAcceptanceBodyAwareness | Lust, Selbstannahme & Körperempfinden | Lust, dich annehmen & deinen Körper spüren | Desire, self-acceptance & body awareness | Desire, accepting yourself & feeling your body | Nur eine sanfte Glättung, optional. |
| onboardingUnderstandResponsiveDesireEaseOrgasm | Responsive Lust verstehen, Orgasmusdruck abbauen. | Verstehen, wie Lust bei dir entsteht, und den Druck herausnehmen. | Understand responsive desire, ease orgasm pressure. | Understand how desire arises for you, and take the pressure off. | "Responsive Lust" ist Fachbegriff. "Orgasmusdruck" benennt den Druck erst. |
| onboardingPersonaliseProgrammeNow | Programm jetzt personalisieren | Fertig, los geht's | Personalise programme now | Done, let's go | "Programm personalisieren" klingt nach Konfiguration. |
| onboardingSkipGoStraightToThe | Überspringen & Direkt zur App | Später, direkt zur App | Skip & go straight to the app | Later, straight to the app | Optional. "Später" ist freundlicher als "Überspringen". |
| userProfilePelvicFloorBody | Beckenboden & Somatik | Beckenboden & Körper spüren | Pelvic floor & body | Pelvic floor & feeling your body | Muss zur Onboarding-Kachel passen. |
| userProfileEasingPerformancePressure | Leistungsdruck abbauen | Weniger Druck | Easing performance pressure | Less pressure | Gleiche Linie wie oben. |
| userProfileNonBinaryOpen | Divers / Offen | Divers / nicht-binär | Non-binary / open | Non-binary | "Offen" ist unklar. Das Onboarding zeigt "Divers", das Profil "Divers / Offen". Das sollte einheitlich sein. |

### Teil 1b Check-in (dailyCheckin* und checkinAction*)

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| dailyCheckinCardHowDoStressPerformancePressure | Wie stehen Stress & Leistungsdruck heute zueinander? | Wie geht es dir heute? | How do stress & performance pressure relate today? | How are you doing today? | Die Frage ist analytisch, der Check-in soll leicht sein. |
| dailyCheckinCardInnerPerformancePressureRacingThoughts | 2. Innerer Leistungsdruck & Kopfkino | 2. Wie viel Druck spürst du innerlich? | 2. Inner performance pressure & racing thoughts | 2. How much inner pressure do you feel? | "Kopfkino" siehe oben. |
| dailyCheckinCardWhatDidYouGoodToday | 3. Was hat deinem Nervensystem heute gut getan? | 3. Was hat dir heute gut getan? | 3. What did you some good today? | 3. What felt good today? | "Nervensystem" als Anrede ist Fachsprache. Der EN-Satz ist grammatisch kaputt. |
| dailyCheckinCardCoachingInsightYourEverydayStress | Coaching-Insight: Dein Alltagsstress ist heute hoch. Erinnere dich: Stress und Erschöpfung bremsen die Lust oft ganz von selbst. Das ist eine normale Reaktion und kein Defekt. | Dein Alltagsstress ist heute hoch. Das ist okay: Stress und Erschöpfung bremsen die Lust oft ganz von selbst. Das ist normal und kein Fehler von dir. | Coaching insight: your everyday stress is high today. Remember: stress and exhaustion often slow desire down by themselves. That's a normal reaction, not a defect. | Your everyday stress is high today. That's okay: stress and tiredness often slow desire down all by themselves. That's normal, not a flaw. | Das Präfix "Coaching-Insight" fällt weg. "Defekt" ruft genau das Wort auf, das vermieden werden soll. |
| dailyCheckinCardCoachingInsightWhenEverydayStress | Coaching-Insight: Wenn der Alltagsstress sinkt, fällt es oft leichter, sich zu entspannen. Nutze die heutige Ruhe, um ohne Erfolgsdruck in den Körper zu spüren. | Wenn der Alltag ruhiger ist, fällt Entspannen oft leichter. Wenn du magst, spür heute einfach in deinen Körper, ganz ohne Ziel. | Coaching insight: when everyday stress drops, it's often easier to relax. Use today's calm to feel into your body without pressure to perform. | When everyday life is calmer, relaxing often comes more easily. If you like, simply feel into your body today, with no goal at all. | "Nutze" ist ein Auftrag. "Wenn du magst" macht ihn zur Einladung. |
| checkinActionBreathed | Bewusst tief geatmet (Physiol. Seufzer) | Ein paar Mal tief durchgeatmet | Breathed deeply on purpose (physiological sigh) | Took a few deep breaths | Der Klammerzusatz ist Jargon und eine Abkürzung. |
| checkinActionPelvicFloor | Beckenboden entspannt (Reverse Kegel) | Den Beckenboden bewusst weich gelassen | Relaxed the pelvic floor (reverse Kegel) | Let my pelvic floor soften | "Reverse Kegel" nur in der Lektion. |
| checkinActionSkinContact | Fokus auf Hautkontakt gelenkt | Hautkontakt bewusst gespürt | Focused on skin contact | Noticed skin contact | "Fokus lenken" klingt nach Training. |
| checkinActionOpenWord | Offenes Wort mit Partner/in gewagt | Ein offenes Wort mit meinem Gegenüber gesprochen | Dared an open word with my partner | Shared an honest word with my partner | "Gewagt" legt nahe, dass es Mut kostet und Pflicht ist. "Partner/in" ist eine Schreibweise, die die App sonst vermeidet. |

### Teil 1c Begrüßungen und Navigation

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| coursesUnderstandTheBiologyQuietThe | Biologie verstehen. Kopfkino stoppen. Körper spüren. | Verstehen, was in dir passiert. Zur Ruhe kommen. Den Körper spüren. | Understand the biology. Quiet the head. Feel the body. | Understand what's happening in you. Settle. Feel your body. | Zwei Imperative und das Wort Kopfkino. Wird in `courses_screen.dart:319` angezeigt. |
| coursesPracticeCbt | Praxis: KVT | Praxis: Gedanken | Practice: CBT | Practice: thoughts | KVT ist ein Kürzel. Die Tab-Leiste sagt schon "Gedanken". |
| mainNavigationTraining | Training | Körper | Training | Body | Wird in der Suche gezeigt (`suche_screen.dart:62`). Die Üben-Seite sagt "Körper". |
| mainNavigationReframing | Reframing | Gedanken | Reframing | Thoughts | Wie oben, Zeile 64. |
| mainNavigationSomaticsTraining und mainNavigationCbtReframing | Somatik & Training / KVT-Reframing | Körper & Üben / Gedanken | Somatics & training / CBT reframing | Body & practice / Thoughts | Beide Schlüssel finde ich im Code nicht mehr in Gebrauch. Löschen oder neutralisieren. |
| coursesYourCurriculum | DEIN CURRICULUM | DEINE KURSE | YOUR CURRICULUM | YOUR COURSES | Ich finde keine Nutzung, vermutlich Altlast. |
| coursesSendSparksSecretlyMatchWishes | Funken senden & Wünsche heimlich abgleichen | Funken schicken & Wünsche vergleichen, sichtbar wird nur, was ihr beide wollt | Send sparks & secretly match wishes | Send sparks & compare wishes, only what you both want becomes visible | "Heimlich" klingt nach Tricksen. Auch ohne Nutzung im Code mitziehen. |

### Teil 1d Funke auf "Heute" (dailySimmeringCard*)

Das ist nicht ausdrücklich im Auftrag, steht aber auf der Heute-Seite und enthält am meisten Jargon.

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| dailySimmeringCardPhysiologicalSighQuickCalming | Physiologischer Seufzer (Quick-Downregulation) | Der lange Seufzer | Physiological sigh (quick calming) | The long sigh | Down-Regulation ist Jargon. |
| dailySimmeringCardToolCalmDown | TOOL • VAGUS-RESET | ÜBUNG • RUHE | TOOL • CALM DOWN | PRACTICE • CALM | Vagus ist Jargon. |
| dailySimmeringCardCourseSensateFocus | KURS 17 • SENSATE FOCUS | KURS 17 • BERÜHRUNG OHNE ZIEL | COURSE 17 • SENSATE FOCUS | COURSE 17 • TOUCH WITHOUT A GOAL | Wie bei der Ziel-Kachel. |
| dailySimmeringCardCourseBodyLab | KURS 19 • SOMATISCHES LAB | KURS 19 • BERÜHRUNG NEU LERNEN | COURSE 19 • BODY LAB | COURSE 19 • RELEARNING TOUCH | Passt zum Kurstitel. |
| dailySimmeringCardCoursesBody | KURS 7 & 9 • SOMATIK | KURS 7 & 9 • KÖRPER | COURSES 3 & 9 • BODY | COURSES 7 & 9 • BODY | **Fehler:** EN nennt "3 & 9", DE "7 & 9". |
| dailySimmeringCardScreenFreeSensing | Dopamin-Reset: Bildschirmfreies Spüren | Bildschirmfreies Spüren | Screen-free sensing | (unverändert) | Das Wort "Reset" ist Jargon. EN ist schon neutral. |
| dailySimmeringCardTheStrictNoPenetrationRule | Das strikte Penetrations-Verbot | Heute ohne Eindringen | The strict no-penetration rule | No penetration today | "Verbot", "strikt" und "tabu" sind Druck. Im Text "Penetration ist strikt tabu" ersetzen durch "Eindringen bleibt heute außen vor". |
| dailySimmeringCardCourseMultipleOrgasms | KURS 19 • MULTI-ORGASMIE | KURS 19 • LOSLASSEN | COURSE 19 • MULTIPLE ORGASMS | COURSE 19 • LETTING GO | Orgasmus-Ziel. Dazu "Plateau-Surfen auf Stufe 7" und "Stoppe jede Bewegung" bei Stufe 8: Leistungston. Die ganze Kachel kürzen. |

**Weitere Sätze in der Funke, die über Jargon hinausgehen (Zustimmung und Druck)**
- `…TodayBrieflyPressYourPartner`: "Drücke deinen Partner heute kurz fordernd an die Wand." Neu: "Wenn ihr beide so etwas mögt: Zieh dein Gegenüber heute kurz an dich, küss langsam den Hals, flüstere ein Versprechen. Nach 45 Sekunden lächelst du und gehst weiter." Außerdem "deinen Partner" durch "dein Gegenüber" ersetzen. Das generische Maskulinum kommt in mehreren Kacheln vor.
- `…ThisAfternoonSendYourPartner`: "Heute Abend ab 21 Uhr gehört dein Körper mir." Das klingt nach Besitz und nach angekündigter Erwartung. Vorschlag: "Nur wenn ihr das mögt: Schick eine Nachricht, die Vorfreude macht, ohne etwas zu erwarten."

**Ausdrücklich außerhalb der genannten Bereiche, aber Jargon (Lektionsansicht)**

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| lessonDetailStartBreathPacerDownRegulation | Atem-Pacer (Down-Regulation) starten | Atem-Begleiter starten (langes Ausatmen) | Start breath pacer (down-regulation) | Start the breathing guide | Jargon. |
| lessonDetailCalmDownWithBreathingOr | Vagusnerv aktivieren & Adrenalin senken mit 4-7-8 oder Seufzer | Mit 4-7-8-Atmung oder dem langen Seufzer zur Ruhe kommen | Calm down with 4-7-8 breathing or the sigh | (unverändert) | EN ist schon neutral. DE zieht nach. |

**Hinweis:** In Lektionen darf Fachsprache bleiben, wenn die Lektion sie erklärt. Beispiele sind `comm_3` (erklärt "Co-Regulation") und `couples_1` (erklärt Sensate Focus). Nur Einstieg und Anrede sind zu ändern.

---

### Teil 2. Fantasie-Landkarte ruhiger

**Tatsächlicher Wortlaut:**
- Der Satz "Ein Match ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt." steht in `couplesChannelAMatchIsAnInvitation`, nicht in `yesNoMaybe*`. Er erscheint im Paar-Kanal-Banner `_buildMatchBanner` (`couples_channel_screen.dart:1087`).
- `yesNoMaybeNoRejectionAllLimitsWere` lautet: "Keine Zurückweisung: Alle Grenzen wurden diskret gewahrt. Nur echte gemeinsame Lust wird enthüllt."
- "Mehr erfahren" in `yesNoMaybeFindOutWhatExcitesYou` passt nicht zum Knopf, der "WEITERLESEN" heißt (`yesNoMaybeReadMore`).

**Beobachtungen zum Verhalten (`yes_no_maybe_screen.dart`)**
- Das Jubel-Banner (ab Zeile 788) erscheint immer, sobald ihr verbunden seid. Es erscheint auch bei 0 Treffern: "VOLLTREFFER MIT {partnerName}", "0 gemeinsame Ja-Übereinstimmungen…". Das ist der schwerste Druckmoment.
- Die Überschrift steht in `.toUpperCase()` und Schriftstärke w900 (Zeile 803). Daneben `auto_awesome` in Ja-Grün.
- Der Tab zeigt eine Zahl am Herz-Symbol (Badge, Zeilen 339 bis 344). Die Zahl zählt nur Ja+Ja, während das Banner auch Neugier zählt.
- Der erste Tab zeigt einen Fortschrittszähler "Fragenkatalog (a/b)". Das lädt zum Abarbeiten ein.
- Der Leer-Zustand nutzt eine Sanduhr (`hourglass_empty_rounded`), die Warten und Ungeduld signalisiert.

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| couplesChannelFantasyMap | Fantasie-Landkarte | (unverändert, Variante "Wunsch-Landkarte", siehe offene Fragen) | Fantasy map | (unverändert, Variante "Wish map") | Die Karte enthält auch nicht-spicy Dinge wie Massage und Küssen. "Fantasie" kann zur Erwartung werden. |
| yesNoMaybeDigitalSafeSpace | DIGITALER SAFE SPACE | Deine Antworten, dein Tempo | DIGITAL SAFE SPACE | Your answers, your pace | Anglizismus und Großbuchstaben. Ein "Safe Space" ist ein Versprechen, das ein Handy nicht halten muss. |
| yesNoMaybeFindOutWhatExcitesYou | Finde heraus, was dich reizt und wo deine Grenzen liegen. Unklar, was gemeint ist? Tippe auf „Mehr erfahren“. Seid ihr im Paar-Kanal verbunden, seht ihr nur, was ihr beide wollt – ein Nein bleibt unsichtbar. | Hier darfst du in Ruhe spüren, was dir gefällt, was vielleicht und was lieber nicht. Du musst nichts beantworten. Unklar, was gemeint ist? Tippe auf das i. Wenn ihr verbunden seid, wird nur sichtbar, wo ihr beide mindestens „Vielleicht“ gesagt habt. Ein „Lieber nicht“ sieht dein Gegenüber nie. | Find out what excites you and where your limits are. Not sure what is meant? Tap “Learn more”. If you're connected in the couple channel, you only see what you both want – a no stays invisible. | Take your time to notice what you like, what might be okay and what you'd rather not. You don't have to answer anything. Not sure what something means? Tap the i. If you're connected, only places where you both said at least “Maybe” become visible. Your partner never sees a “Rather not”. | Nimmt den Antwortdruck weg. Sagt genau, was sichtbar wird. Das passt zum Verhalten: Ja+Ja und Ja+Vielleicht sowie Vielleicht+Vielleicht werden gezeigt. |
| yesNoMaybeQuestionsAnsweredcountTotalitems (Tab 1) | Fragenkatalog ({answeredCount}/{totalItems}) | Fragenkatalog ({answeredCount} von {totalItems}) | Questions ({answeredCount}/{totalItems}) | Questions ({answeredCount} of {totalItems}) | Besser: Zähler ganz weglassen. Dafür ein neuer Schlüssel "Meine Antworten" / "My answers" ohne Platzhalter. |
| yesNoMaybeMatchesMatchcount (Tab 2) | Matches ({matchCount}) | Gemeinsam ({matchCount}) | Matches ({matchCount}) | Together ({matchCount}) | Ohne das Wort Match. Mit einem neuen Schlüssel "Gemeinsam" / "Together" ohne Zahl entfällt die "(0)"-Anzeige. Die rote Zahl am Herz im Code entfernen oder leise machen. |
| yesNoMaybeSyncWithPartner | Mit Partner synchronisieren | Mit deinem Gegenüber vergleichen | Sync with partner | Compare with your partner | "Synchronisieren" ist technisch. |
| yesNoMaybePairingRequired | Koppeln erforderlich | Erst verbinden | Pairing required | Connect first | Weniger Zwang. |
| yesNoMaybeMatchingAnswersEncrypted | Antworten werden verschlüsselt abgeglichen … | Antworten werden verschlüsselt verglichen … | Matching answers, encrypted … | Comparing answers, encrypted … | "Matching" ist englisch. |
| yesNoMaybeCountAnswersMatched | {count} Antworten erfolgreich abgeglichen! | Fertig: {count} Antworten verglichen. | {count} answers matched! | Done: {count} answers compared. | Kein Ausrufezeichen, keine Erfolgsmeldung. |
| yesNoMaybePairingRequired2 | Kopplung erforderlich | Erst verbinden | Pairing required | Connect first | Titel im ungekoppelten Tab. |
| yesNoMaybeConnectWithYourPartnerIn | Verbinde dich im Paar-Kanal per QR-Code mit deinem Gegenüber. Eure Antworten werden dann Ende-zu-Ende-verschlüsselt abgeglichen. | Wenn ihr im Paar-Kanal verbunden seid, könnt ihr eure Antworten verschlüsselt vergleichen. Sichtbar wird nur das Gemeinsame. Allein ausfüllen geht auch. | Connect with your partner in the couple channel via QR code. Your answers are then matched end-to-end encrypted. | Once you're connected in the couple channel, you can compare your answers, encrypted. Only what you share becomes visible. Filling it in alone works too. | Nennt das Alleine-Ausfüllen. |
| yesNoMaybePairViaQrCodeNow | Jetzt per QR-Code koppeln | Per QR-Code verbinden | Pair via QR code now | Connect via QR code | Weniger Dringlichkeit. |
| yesNoMaybePerfectMatchWithPartnername (Banner, nur bei Treffern) | VOLLTREFFER MIT {partnerName} | Gemeinsam mit {partnerName} | PERFECT MATCH WITH {partnerName} | Together with {partnerName} | Platzhalter bleibt. Im Code `.toUpperCase()` und w900 weg, Icon leiser. |
| yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints | {yesMatchesLength} gemeinsame Ja-Übereinstimmungen & {curiosityMatchesLength} Neugier-Punkte entdeckt! | Ja bei euch beiden: {yesMatchesLength} · Gemeinsam neugierig: {curiosityMatchesLength} | {yesMatchesLength} shared yeses & {curiosityMatchesLength} points of curiosity discovered! | Yes from both of you: {yesMatchesLength} · Curious together: {curiosityMatchesLength} | Plural-sicher, weil "1 Dingen" vermieden wird. Keine Entdecker-Rhetorik. |
| yesNoMaybeNoRejectionAllLimitsWere | Keine Zurückweisung: Alle Grenzen wurden diskret gewahrt. Nur echte gemeinsame Lust wird enthüllt. | Hier steht nur, was ihr beide gesagt habt. Alles andere bleibt bei jedem für sich. Ein „Lieber nicht“ ist eine vollwertige Antwort. | No rejection: all limits were kept discreetly. Only real shared desire is revealed. | Only what you both said is shown here. Everything else stays private. A “Rather not” is a complete answer. | "Zurückweisung" und "enthüllt" sind schwere Wörter. "Echte Lust" wertet andere Antworten ab. |
| yesNoMaybePerfectMatchBothSaidYes | Volltreffer (Beide haben JA gesagt) | Ihr beide: Ja | Perfect match (both said YES) | You both said yes | Gruppenüberschrift. |
| yesNoMaybeSharedCuriosityOpenToExploring | Gemeinsame Neugier (Offen für Erkundung) | Gemeinsame Neugier, ein Vielleicht reicht | Shared curiosity (open to exploring) | Curious together, a maybe is enough | Betont, dass ein Vielleicht genügt. |
| yesNoMaybeNoMatchesYet (**Leer-Zustand, Titel**) | Noch keine Übereinstimmungen | Hier ist es noch still | No matches yet | It's still quiet here | Parallel zu `couplesChannelItSStillQuietHere`. |
| yesNoMaybeBothKeepVotingInThe (**Leer-Zustand, Text**) | Stimmt beide weiter im Fragenkatalog ab. Sobald ihr denselben Punkt mit Ja oder Vielleicht bewertet habt, leuchtet er hier auf. | Das heißt nicht, dass etwas fehlt. Vielleicht habt ihr noch nicht alles beantwortet, oder eure Antworten liegen einfach an verschiedenen Stellen. Beides ist normal. Ihr müsst nichts tun. | Both keep voting in the questions. As soon as you've both rated the same item yes or maybe, it lights up here. | That doesn't mean anything is missing. Maybe you haven't answered everything yet, or your answers simply lie in different places. Both are normal. There's nothing you have to do. | Das ist der leise Text für "noch nichts Gemeinsames". Das Banner entfällt dann ganz. |
| yesNoMaybeCourse | Kurs ▶ | Mehr dazu | Course ▶ | Learn more | Kleinigkeit, passt zum "i"-Button. |

**Paar-Kanal-Banner und Wunschkarten**

| Schlüssel | alt DE | neu DE | alt EN | neu EN | Begründung |
|---|---|---|---|---|---|
| couplesChannelYouHaveAMatch | Ihr habt ein Match | Bei einer Sache sagt ihr beide Ja | You have a match | You both said yes to one thing | Ohne Match. Einzahl. |
| couplesChannelYouHaveMatcheslengthMatches | Ihr habt {matchesLength} Matches | Bei {matchesLength} Dingen sagt ihr beide Ja | You have {matchesLength} matches | You both said yes to {matchesLength} things | Mehrzahl. |
| couplesChannelAMatchIsAnInvitation | Ein Match ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt. | Ein gemeinsames Ja ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt. Und ein „Heute nicht“ gilt immer. | A match is an invitation, not a promise. Talk briefly beforehand about how you imagine it. | A shared yes is an invitation, not a promise. Talk briefly beforehand about how you imagine it. And “not today” always counts. | Der Satz bleibt, ergänzt um das "Heute nicht". |
| couplesChannelSecretlyMatchWishes | Wünsche heimlich abgleichen | Wünsche leise vergleichen | Secretly match wishes | Compare wishes quietly | "Heimlich" klingt nach Tricksen. |
| couplesChannelVoteSeparatelyAWishOnly | Stimmt getrennt ab. Ein Wunsch erscheint erst als Treffer, wenn ihr beide „Ja, gern“ sagt. Ein „Vielleicht“ landet zum Besprechen, ein „Lieber nicht“ wird nie angezeigt. | Antwortet getrennt. Ein Wunsch wird erst sichtbar, wenn ihr beide „Ja, gern“ gesagt habt. Ein „Vielleicht“ kommt zu „Zum Besprechen“. Ein „Lieber nicht“ sieht dein Gegenüber nie. | Vote separately. A wish only shows up as a match when you both say “Yes, please”. A “Maybe” goes into “To talk about”, a “Rather not” is never shown. | Answer separately. A wish only becomes visible when you've both said “Yes, please”. A “Maybe” goes to “To talk about”. Your partner never sees a “Rather not”. | Kein "Treffer", kein "Match". |
| couplesChannelYouCanAlsoFillIt | Kannst du auch allein ausfüllen – und später mit deinem Gegenüber abgleichen. | Kannst du auch allein ausfüllen und später mit deinem Gegenüber vergleichen. | You can also fill it in alone – and match it with your partner later. | You can also fill it in alone and compare it with your partner later. | Kleine Glättung. |

**Code-Hinweise (nicht geändert)**
- Banner nur zeigen, wenn `yesMatches.isNotEmpty || curiosityMatches.isNotEmpty`. Sonst nur den Leer-Zustand.
- Beim Leer-Zustand das Sanduhr-Symbol durch etwas Ruhigeres ersetzen, z. B. `spa_outlined`.

---

### Teil 3. Hetero-Annahmen in Texten

**Grundbefund**
- Die Kurslogik kennt nur `women`, `men`, `couples`, `all` (Feld `category` je Kurs). Daran hängen drei Dinge: der Filter `coursesForHer` / `coursesForHim` / `coursesForCouples`, die Vorauswahl aus dem Profil (`courses_screen.dart:85` bis `90`) und die Stimmenwahl beim Einsprechen.
- Die Stimmenwahl steht in `tools/generate_audio.py` Zeile 60: women → Victoria, couples → beide, sonst Martin. Das ist bereits eingesprochen. Nur die Bezeichnungen zu ändern ändert die Stimme nicht.
- Die Personalisierung in Lektionen (`lib/services/personalize.dart`) hat Platzhalter `{W:…}` (Frau) und `{M:…}` (Mann). Der Text hinter dem Doppelpunkt ist **genau das, was eingesprochen wurde**. Er bleibt, wenn das Gegenüber divers oder unbekannt ist. Beispiel: In `mass_2` steht "{W:Sie} liegt auf dem Rücken". Bei Personen ohne Angabe oder divers bleibt "Sie" stehen. Wer das neutral will, ändert den Text und muss neu aufnehmen.

### Teil 3a Beschriftungen und Titel

Spalte "gesprochen": nein, ja, unklar. Bei Kurstiteln gilt nein, weil `speech_text` nur den Lektionstitel sagt (`generate_audio.py:93`).

| Ort | alt | Annahme | Vorschlag DE | Vorschlag EN | gesprochen? |
|---|---|---|---|---|---|
| ARB coursesForHer / coursesForHim | Für Sie / Für Ihn | Filter nach Geschlecht | Mit Vulva / Mit Penis | With a vulva / With a penis | nein (UI) |
| ARB coursesForCouples | Für Paare | neutral, aber "Paare" wirkt wie Mann+Frau | Für Paare (unverändert) | For couples | nein |
| ARB contentModelsForHer / Him | FÜR SIE / FÜR IHN | Geschlecht | MIT VULVA / MIT PENIS | WITH A VULVA / WITH A PENIS | nein |
| ARB contentModelsTheArtOfTouchFor | BERÜHRUNGSKUNST • FÜR SIE | Geschlecht | BERÜHRUNGSKUNST • MIT VULVA | THE ART OF TOUCH • WITH A VULVA | nein |
| ARB contentModelsTouchLabForHim | TAST-LABOR • FÜR IHN | Geschlecht | TAST-LABOR • MIT PENIS | TOUCH LAB • WITH A PENIS | nein |
| ARB beliefLibraryViewForHer / Him | (for her / for him) | Geschlecht | Für Menschen mit Vulva / mit Penis | For people with a vulva / a penis | nein |
| velvet_content.json, Kurs 18 (course_touch_women) | 18. Berührung, die trägt (Für Sie) | Geschlecht | 18. Berührung, die trägt (mit Vulva) | 18. Touch That Carries (with a vulva) | nein (Kurstitel) |
| velvet_content.json, Kurs 19 (course_touch_men) | 19. Berührung neu lernen (Für Ihn) | Geschlecht | 19. Berührung neu lernen (mit Penis) | 19. Relearning Touch (with a penis) | nein |
| velvet_content.json, Kurs 9 (course_female_somatics) | 9. Weibliche Lust und Körperwissen | Geschlecht | 9. Lust und Körperwissen mit Vulva | (EN-Titel nicht geprüft) | nein |
| bilder.json, kurs.08.titel und kurs.09.titel (alt-Texte) | …(Für Sie) / …(Für Ihn) / (For Her) / (For Him) | Geschlecht | nach den neuen Kurstiteln anpassen | wie Kurs-EN | nein |
| velvet_content.json, match_cards `match_yoni_ritual` | 45 Minuten Yoni-Verehrung (Nur für Sie) | Geschlecht | 45 Minuten Yoni-Verehrung (eine Person empfängt) | 45 minutes of yoni worship (one person receives) | nein (Karte, kein Audio gefunden) |
| velvet_content.json, `match_lingam_ritual` | 45 Minuten Lingam- und Damm-Reise (Nur für Ihn) | Geschlecht | 45 Minuten Lingam- und Damm-Reise (eine Person empfängt) | 45-minute lingam and perineum journey (one person receives) | nein |
| Beschreibung `match_yoni_ritual` | Sie darf nur daliegen, die Augen schließen und empfangen… | "Sie" | Eine Person liegt nur da, schließt die Augen und empfängt, mit warmem Öl, ohne jede Gegenleistung. | One person simply lies there, closes their eyes and receives, with warm oil, giving nothing in return. | nein |
| Beschreibung `match_lingam_ritual` | Eine langsame, beidhändige Ölmassage von Bauch, Damm und Schaft… | neutral | (unverändert) | (unverändert) | nein |

**Hinweis zu den Wunschkarten**
- Die Karten stehen **dreifach** im Repo: `assets/data/velvet_content.json`, `lib/models/couple_channel_models.dart` (Zeilen 154 bis 165, Titel gekürzt: "45 Min. Yoni-Verehrung (Nur für Sie)") und die EN-Dateien `translations/en/velvet_content.json` und `translations/en/fantasy_options.json` (mit Hashes). Alle gemeinsam ändern.
- Für `couple_channel_models.dart` und `velvet_content.json` die Wunsch-IDs `match_yoni_ritual` und `match_lingam_ritual` nicht ändern, sie werden mit dem Gegenüber abgeglichen.
- Die Schreibweise der Titel muss zwischen DE und EN gleich bleiben. Mein Vorschlag "(eine Person empfängt)" ist ehrlicher als "(zum Geben und Empfangen)", denn die Karte beschreibt eine einseitige Massage, bei der eine Person nur empfängt.

### Teil 3b Lektionstexte (Stichproben)

Diese Texte sind wahrscheinlich gesprochen. Jede Änderung braucht eine Neuaufnahme. Das entscheidest du und nicht ich. Siehe Abschnitt "gesprochen".

| Lektion | Stelle | Annahme | Vorschlag |
|---|---|---|---|
| touch_w_1 (Kurs 18) | "Viele Frauen kennen diesen Moment…", "bei vielen Frauen" | nur Frauen | "Viele Menschen mit Vulva kennen diesen Moment…" |
| touch_m_1 (Kurs 19) | "Viele Männer haben sich seit der Jugend…" | nur Männer | "Viele Menschen mit Penis haben sich…" |
| female_1 (Kurs 9) | **Titel gesprochen:** "Der weibliche Beckenboden: Loslassen statt Festhalten" | Geschlecht im Titel | "Der Beckenboden mit Vulva: Loslassen statt Festhalten" (Neuaufnahme nötig) |
| pos_1 (Kurs 22) | "Das Schambein des Mannes liegt flächig auf der Klitoris", "{M:er} oben, nachdem er sanft eingedrungen ist" | Mann+Frau | "…das Schambein der eindringenden Person liegt flächig auf der Klitoris" |
| mass_1 (Kurs 20) | "Yoni-Massage für Frauen und Lingam-Massage für Männer" | Geschlecht | "Yoni-Massage für Menschen mit Vulva, Lingam-Massage für Menschen mit Penis" |
| mass_2 | "Viele Frauen erleben genitale Berührung…", "{W:Sie} liegt…" | Frau als Empfangende | Fallback "{W:die empfangende Person}" (Neuaufnahme) |
| course_every_body, Untertitel und Summaries (Zeilen ~128 bis 198) | "Frauen und Männer ihren Körper…" | zwei Geschlechter | "alle Körper" bzw. "Menschen jeden Geschlechts" (nur Anzeigetexte, nicht gesprochen) |
| positions summary (~Zeile 1425) | "…dem Mann den Stoß-Stress nimmt" | Mann | "…der eindringenden Person den Stoß-Stress nimmt" (Anzeige) |
| belief_library, `reality_check` (~Zeile 2012) | "Ein Mann kann vor Lust brennen… Eine Frau kann tief erregt sein…" | Mann/Frau | "Wer einen Penis hat, kann… Wer eine Vulva hat, kann…" (Anzeige) |
| belief_library, `irrational_thought` (~Zeile 1955) | "Mein Wert als Mann hängt direkt von der Härte meiner Erektion ab." | Mann | "Mein Wert hängt von der Härte meiner Erektion ab." |
| yes_no_maybe_models.dart `item_44` | "Sie bestimmt beim Eindringen jeden Millimeter" / "Er bewegt sich nicht, sie führt…" | Mann+Frau | "Wer aufnimmt, bestimmt beim Eindringen jeden Millimeter" |
| yes_no_maybe_models.dart `item_15` | "…lässt viele Männer zum ersten Mal ganz loslassen" | Männer | "…lässt viele Menschen mit Penis…" |
| yes_no_maybe_models.dart (~Zeile 624) | "Viele Frauen kommen beim Sex leichter, wenn die Klitoris…" | Frauen | "Viele Menschen mit Klitoris…" |

Als **gutes Beispiel**, an dem man sich orientieren kann: Die Kategorie "Intim-Massage, Prostata & Damm" in der Fantasie-Landkarte (`item_14`, `item_15`) benennt Körper statt Geschlecht ("Massage der Vulva", "Massage des Penis"). Auch die Lektionen "Mit Vulva…" und "Mit Penis…" in Kurs 8 gehen so vor. Das ist die Linie.

### Teil 3c Paarformen im Überblick

- **Frau + Mann:** Die Filter "Mit Vulva / Mit Penis" funktionieren. Die Karten "(eine Person empfängt)" ebenfalls.
- **Zwei Frauen:** Der Filter "Mit Vulva" passt auf beide. Die Lektion mit {W}-Platzhalter bleibt neutral, weil `personalize.dart` bei zwei Frauen nur im Gebenden-Blickwinkel ersetzt. Das ist gut gedacht. Kritisch sind die Texte, die "Mann" und "Frau" fest benennen (pos_1, mass_1).
- **Zwei Männer:** Wie oben. Der Filter "Mit Penis" passt auf beide. Pos_1 ("Schambein des Mannes auf der Klitoris") passt nicht.
- **Divers / keine Angabe:** Heute greift nichts. Die Vorauswahl im Kursfilter fehlt, sie sollte aus der Körperfrage (Abschnitt 5) kommen. Die {W}/{M}-Fallbacks sagen "sie" oder "er". Für Gegenüber ohne Angabe ist eine Variante wie "{P:dein Gegenüber}" besser, aber ein Eingriff in gesprochene Texte.
- Als Orientierung für Gesprochenes: Der Paar-Abend (`assets/data/paar_abend.json`) enthält in den geprüften Texten kein Geschlechtswort (Treffer 0 für Frau, Mann, Penis, Vulva und weitere). Er nutzt "Gegenüber", "gebende Person", "empfangende Person". So soll es überall klingen.

### Teil 3d Einträge, die bestimmt gesprochen sind

Hier gilt: nicht ohne Neuaufnahme ändern.
- Alle Lektionstexte mit Geschlechtswörtern (touch_w_*, touch_m_*, female_*, pos_*, mass_*, prost_* je nach Wortlaut). Die Zählung der Stellen mit Frau / Mann / Frauen / Männer: Kurs 3 = 16, Kurs 9 = 7, Kurs 11 = 6, Kurs 16 = 6, Kurs 18 = 6, Kurs 19 = 9, Kurs 20 = 6, Kurs 2 = 5, Kurs 14 = 5.
- Titel der Lektion `female_1`.
- Die Titel von Audio-Lektionen (neuro_3, spec_3, body_3, pelvic_4, self_5, dopa_3, mass_4, vocal_2, scen_4) enthalten **kein** Geschlechtswort. Alles gut.

Nicht gesprochen (frei änderbar): Kurstitel, Kategorie-Etiketten, Wunschkarten (Titel und Beschreibung), Texte der Fantasie-Landkarte, Zusammenfassungen (`summary`), `bilder.json`.

Sonderfall: Wegen `generate_audio.py:60` entscheidet die Kurskategorie die Stimme. Beim Umbenennen der Filter nicht an `category` rühren.

---

### Teil 4. "Eure erste Woche" und sanfter Start

### Teil 4a Was schon da ist

- **Onboarding (nur für die einladende oder die eigene Person):** Es gibt eine Willkommensseite mit drei Versprechen (`onboardingVersprechenLokal`, `…KeinKonto`, `…Netz`) und "Loslegen", dann Fragen 1 bis 5. "Überspringen & Direkt zur App" ist immer erreichbar. Damit gibt es schon eine "Ich schau erst mal nur"-Tür, sie heißt nur anders.
- **Einladung (`invite_partner.dart`):** Der Text `invitePartnerIDLikeToTry` ist rein technisch: App laden, Code einfügen, Funken schicken. Er sagt nichts darüber, was die App ist, dass nichts erwartet wird und dass man nein sagen darf. Der Dialog `invitePartnerYouSendALinkTo` ist ebenfalls sachlich. Einen Einladungs-Link mit Kennung gibt es nicht (`stableApkUrl` und `testerGuideUrl` sind feste GitHub-Links). Die App kann also nicht erkennen, dass jemand eingeladen wurde.
- **`pairing_modal.dart`:** Zeigt Code, Scanner, Partnername. Die Anfrage "Dein Code wurde gescannt" (`pairingAnfrageTitel`) hat einen bestätigenden Schritt für die einladende Person. Für die eingeladene Person gibt es keine Einführung.
- Die "Heute"-Seite hat laut `docs/konzepte/heute-und-produktschliff.md` bewusst keinen Prozentbalken und keine Serie mehr. Dort passt "Eure erste Woche" hin, mit demselben Prinzip.

### Teil 4b Sieben Schritte (alle Inhalte vorhanden, IDs geprüft)

Jeder Schritt hat ein "Heute nicht". Es hat keine Folgen. Der Schritt bleibt stehen, nichts verfällt, es gibt keine Erinnerung, keinen Zähler und keine Meldung an das Gegenüber. Das muss im Code so umgesetzt werden (kein Ping über Nostr, keine Streak-Anzeige).

| # | Titel DE / EN | Inhalt (ID) | Dauer | Warum an dieser Stelle |
|---|---|---|---|---|
| 1 | Ein Wort, das alles anhält / One word that stops everything | `couples_3` "Die Ampel: Wünsche und Grenzen ohne Kränkung" (Lesen 4 Min.); dazu ein Wort für "Stopp" verabreden (Stoppwort wird auch in `mass_1` und im Paar-Abend verlangt) | ca. 10 Min. mit Gespräch | Erst Sicherheit. Wer weiß, dass Stopp immer gilt, kann sich auf alles Weitere einlassen. |
| 2 | Zusammen atmen / Breathing together | `couples_2` "Bauch an Bauch: gemeinsam atmen" (Übung 3 Min., Werkzeug Atem-Taktgeber `breath_pacer`). Alternative, jeder für sich: `neuro_3` "Audio-Praxis: Die Bremse lösen" (3 Min. Audio) | ca. 7 Min. | Ankommen ohne Berührung, die etwas will. Die Alternative ist für alle, die noch nicht eng liegen möchten. |
| 3 | Warum Druck keine Schuld ist / Why pressure is nobody's fault | `neuro_1` "Gaspedal und Bremse" (5 Min. Lesen), jede Person für sich | ca. 5 Min. | Nimmt die Last der Erwartung, bevor Berührung kommt: "Das ist kein Defekt." |
| 4 | Berührung ohne Ziel / Touch without a goal | `couples_1` Stufe eins (Rücken, Schultern, Arme, Hände, Füße; "ausdrücklich kein Sex"), hier auf 10 bis 15 Minuten verkürzt. Alternativ der Paar-Abend "Bekleidet" (kürzeste Dauer **20** Min., siehe offene Fragen) | 10 bis 15 Min. | Erst jetzt Berührung, bekleidet, ohne Ziel. Jede Person kann jederzeit "Stopp" sagen (Schritt 1). |
| 5 | Wünsche leise sammeln / Gathering wishes quietly | Fantasie-Landkarte, nur die Kategorie "Sinnlichkeit & Sinne" (`sensory_basics`, nicht spicy; z. B. `item_1` "Langsame Ganzkörper-Massage mit warmem Öl", `item_2` "Spiel mit Wärme und Kälte", `item_3` "Mit verbundenen Augen berührt werden"). Jede Person für sich, Antworten sind auch allein möglich | 10 Min. | Nach der Berührung wissen beide, was sich gut anfühlt. Antworten bleiben privat. Gezeigt wird nur Gemeinsames. |
| 6 | Ein Satz, der leicht fällt / One easy sentence | `comm_2` "Das Gespräch öffnen" (5 Min.): einen der drei Satzbausteine aussuchen und sagen | ca. 10 Min. | Gespräch erst, wenn Vertrauen und Ruhe da sind. Ein einziger Satz, kein Problemgespräch. |
| 7 | Rückblick ohne Bewertung / A look back without judging | Keine neue Lektion. Zwei Fragen: "Was war schön?" und "Was machen wir davon wieder?" Als Orientierung die Reflexionsfrage von `couples_2`. Vorschläge zum Weitermachen: `desire_3` "Das Lust-Menü" oder `couples_1` ganz | 5 bis 10 Min. | Beendet die Woche ohne Zeugnis. |

Weitere vorhandene Bausteine als Ersatz für jeden Schritt: `comm_3` "Gemeinsam zur Ruhe kommen" (Herz-Atem, Hand auf dem Herz), `spec_3` "Sinnes-Anker und Körperreise" (5 Min. Audio, allein).

**Texte für die Karte (Einstieg)**
- DE: "Eure erste Woche. Sieben kleine Schritte, jeder höchstens eine Viertelstunde. Ihr müsst keinen davon machen, und keiner ist eine Prüfung. Zu jedem gibt es ein „Heute nicht“."
- EN: "Your first week. Seven small steps, each no longer than a quarter of an hour. You don't have to do any of them, and none is a test. Every one has a “Not today”."
- Knopf: "Heute nicht" / "Not today". Danach: "Alles gut. Der Schritt wartet, ohne dass etwas verfällt." / "All good. The step will wait, and nothing expires."

### Teil 4c Sanfter Start für die eingeladene Person (3 Bildschirme)

Auslöser: Ein Knopf auf der Willkommensseite des Onboardings, z. B. "Jemand hat mich eingeladen" / "Someone invited me". Ein Einladungs-Link mit Kennung gibt es nicht, deshalb ist das der einfachste Weg.

**Bildschirm 1**
- DE-Titel: "Schön, dass du da bist"
- DE-Text: "Jemand, der dir wichtig ist, hat dich eingeladen, VelvetPulse auszuprobieren. Die App ist ein ruhiger Ort für Nähe, Körper und Gespräche, zum Lesen, Hören und Üben, allein oder zu zweit. Du musst nichts können und nichts leisten."
- EN-Titel: "Glad you're here"
- EN-Text: "Someone who matters to you has invited you to try VelvetPulse. It's a quiet place for closeness, body and conversation, to read, listen and practise, alone or together. You don't need to be good at anything or achieve anything."
- Knöpfe: "Weiter" / "Next". Darunter, immer sichtbar: "Ich schau erst mal nur" / "I'll just have a look".

**Bildschirm 2**
- DE-Titel: "Nein ist immer eine Antwort"
- DE-Text: "Nichts hier ist eine Aufgabe. Zu jedem Schritt gibt es ein „Heute nicht“, und es hat keine Folgen. Deine Antworten bleiben bei dir, bis du selbst etwas schickst. Dein Gegenüber sieht nicht, was du ansiehst, ausprobierst oder überspringst."
- EN-Titel: "No is always an answer"
- EN-Text: "Nothing here is an assignment. Every step has a “Not today”, and it has no consequences. Your answers stay with you until you send something yourself. Your partner can't see what you look at, try or skip."
- **Nachprüfen vor dem Einbau:** Dass das Gegenüber nichts sieht, stimmt für Lektionsfortschritt und Landkarte-Antworten nach meinem Stand. Lesebestätigungen im Chat (`couplesChannelReadReceipts`) und geteilte Lektionen sind separate Funktionen. Bitte beim Einbau gegenprüfen.

**Bildschirm 3**
- DE-Titel: "Alles bleibt auf deinem Handy"
- DE-Text: "Kein Konto, keine Werbung, keine Auswertung. Du kannst jederzeit aufhören, die App schließen oder sie ganz entfernen. Verbinden mit der Person, die dich eingeladen hat, geht später und nur, wenn du magst."
- EN-Titel: "Everything stays on your phone"
- EN-Text: "No account, no ads, no tracking. You can stop at any time, close the app or remove it completely. Connecting with the person who invited you can happen later, and only if you like."
- Knöpfe: "Einrichten (fünf kurze Fragen, alle freiwillig)" / "Set up (five short questions, all optional)" und weiter "Ich schau erst mal nur" / "I'll just have a look". Der letzte führt direkt zur App (wie das heutige "Überspringen").

**Einladungstext (`invitePartnerIDLikeToTry`) mit neuem Anfang, Platzhalter `{stableApkUrl}` und `{testerGuideUrl}` bleiben:**
- DE: "Ich möchte VelvetPulse mit dir ausprobieren 💛 Eine private App für Nähe und Gespräche, nur für uns zwei. Du musst nichts können, und zu allem darfst du „Heute nicht“ oder „Nein“ sagen. Schau gern erst mal nur rein. Alles bleibt auf deinem Handy." Danach die Schritte 1 bis 3 und die Anleitung wie bisher.
- EN: "I'd like to try VelvetPulse with you 💛 A private app for closeness and conversation, just for the two of us. You don't need to be good at anything, and you can say “not today” or “no” to anything. Feel free to just have a look first. Everything stays on your phone." Then steps 1 to 3 and the guide as before.

**Dialog der einladenden Person**
- `invitePartnerYouSendALinkTo`, DE neu: "Du schickst einen Link zur App und deinen Verbindungscode, z. B. per Messenger. Dein Gegenüber kann sich in Ruhe umsehen und entscheidet selbst, ob und wann es sich verbindet. Dann bestätigst du hier die Verbindung." EN: "You send a link to the app and your connection code, e.g. via a messenger. Your partner can take a look in peace and decides whether and when to connect. You then confirm the connection here."
- `invitePartnerAsSoonAsNameInstalls`, DE: Satz am Ende ergänzen: "Lass {name} Zeit." EN: "Give {name} time." (Platzhalter `{name}` bleibt.)

---

### Teil 5. Geschlechtsauswahl im Onboarding

### Teil 5a Wofür die Angabe wirklich gebraucht wird (aus dem Code)

- **Stimmenvorschlag** (nur Voreinstellung): `kegel_timer_view.dart:220`, `einschlaf_reise_screen.dart:115`, `wecken_screen.dart:55`, `selbst_reise_screen.dart:65`, `paar_abend_screen.dart:74`. Ob Frau oder Mann gewählt ist, bestimmt, wer vorgeschlagen wird.
- **Vorauswahl im Kursfilter** ("Für Sie" oder "Für Ihn", nur solange nie gewählt wurde): `courses_screen.dart:85`.
- **Namensnennung in Lektionen:** `lesson_detail_screen.dart:191` gibt `myGender` an `personalize()`. Das Gegenüber wird beim Namen genannt, nur wenn klar ist, wer gemeint ist.
- **Körper-Voreinstellung:** `selbst_reise_screen.dart:63` (penis oder vulva), `lust_im_traum_screen.dart:67`, `lust_profile_screen.dart:133` (Reihenfolge). Das ist eigentlich eine Körperfrage, keine Geschlechtsfrage.
- **Paar-Abend:** `paar_abend_screen.dart:128` bis `142` leitet die Körper ab. Ist das Gegenüber unbekannt, nimmt der Code **das andere Geschlecht** an (männlich → weiblich, weiblich → männlich). Bei divers oder keine Angabe bleibt der Körper offen (null).
- Der **KI-Coach** (`ai_coach_screen.dart:31`) nutzt das Geschlecht ebenfalls, ist aber laut `coach-entfernen.md` entfallen. Der alte Erklärtext nennt noch "KI-Antworten". Das ist nicht mehr nötig.
- "Anrede": Die App sagt immer "du" bzw. "ihr". Das Geschlecht steuert **keine** grammatische Anrede. Ich würde das Wort nicht verwenden.
- "Körperbilder in manchen Übungen": belegt nur indirekt, über die Körper-Voreinstellung (Selbst-Reise) und die Reihenfolge in `lust_profile_screen.dart`.

**Zwei Dinge, die ich im Code gesehen habe und die zur Frage gehören**
- `_selectedGender` ist beim ersten Start auf `'male'` voreingestellt (`onboarding_screen.dart:42`). Wer die Frage überspringt oder nur "Weiter" tippt, wird als Mann gespeichert. `UserProfile.fromJson` setzt ebenfalls `'male'` als Standard. Das sollte ein neutraler Wert werden.
- Alle, die nicht `male` sind, bekommen als Voreinstellung Vulva und die Stimme Victoria (Selbst-Reise, Lust im Traum). Das ist eine stille Annahme.

### Teil 5b Neue Fassung der Frage

Auswahl: **Frau, Mann, Divers, Keine Angabe**. Das gleicht das Onboarding an `partner_profile_dialog.dart` an. Dazu `onboardingMale` auf "Mann" und `onboardingFemale` auf "Frau" ändern, weil "Männlich/Weiblich" biologisch klingt, und `partnerProfileDialogNotSpecified` wiederverwenden (der Code nutzt `partnerProfileDialogNonBinary` schon so). Vier Karten passen nicht mehr in eine Zeile (`Row` mit drei `Expanded`), Layout als zweimal zwei oder `Wrap`.

| Schlüssel | alt DE | neu DE | alt EN | neu EN |
|---|---|---|---|---|
| onboardingYourGender | 2. Dein Geschlecht | 2. Dein Geschlecht (freiwillig) | 2. Your gender | 2. Your gender (optional) |
| onboardingAdjustsCourseRecommendationsPelvicFloor | Passt Kursempfehlungen, Beckenboden-Physiologie und KI-Antworten an. | Wir nutzen das nur, um dir eine passende Stimme und eine erste Kursauswahl vorzuschlagen und um Lektionen verständlich zu halten, wenn von „sie“ oder „er“ die Rede ist. Du kannst es jederzeit ändern, und es bleibt auf deinem Handy. „Keine Angabe“ ist völlig in Ordnung. | Adjusts course recommendations, pelvic floor content and AI answers. | We only use this to suggest a voice and a first selection of courses, and to keep lessons clear when they talk about “she” or “he”. You can change it any time, and it stays on your phone. “Not specified” is completely fine. |
| onboardingMale | Männlich | Mann | Male | Man |
| onboardingFemale | Weiblich | Frau | Female | Woman |
| (vorhanden) partnerProfileDialogNonBinary | Divers | Divers | Non-binary | Non-binary |
| (vorhanden) partnerProfileDialogNotSpecified | Keine Angabe | Keine Angabe | Not specified | Not specified |

**Voraussetzung dafür, dass der Satz "Keine Angabe ist völlig in Ordnung" stimmt:**
1. Neuer Wert (z. B. `'none'`) für "Keine Angabe". Zusätzlich `_selectedGender` und `UserProfile.fromJson` auf diesen Wert als Standard stellen. `genderLabel` braucht einen Fall dafür.
2. Die Körper-Voreinstellung nicht mehr aus dem Geschlecht ableiten (siehe 5c).
3. `paar_abend_screen.dart:138` nicht mehr ein Gegenüber "des anderen Geschlechts" annehmen.

### Teil 5c Zweite, optionale Frage nach dem Körper

**Empfehlung: ja, aber nicht als sechste Onboarding-Seite, sondern an zwei Stellen: im Profil-Bearbeiten und beim ersten Gebrauch einer Übung, die den Körper braucht** (Selbst-Reise, Lust im Traum, Paar-Abend), einmal und mit "Später fragen". Vorhandene Schlüssel für diese Auswahl gibt es in der Selbst-Reise schon (`_keyKoerper`).

**Gründe dafür**
- Die App fragt den Körper heute schon, nur verdeckt: Selbst-Reise hat 37 körperabhängige Textstellen, Lust im Traum hat einen eigenen Schalter (`_bett`), und beide setzen den Standard aus dem Geschlecht. Geschlecht und Körper sind aber zwei Dinge (trans, inter, nach Operationen).
- Die Frage lässt sich getrennt vom Geschlecht beantworten und nimmt die stille Annahme aus dem Code.

**Gründe gegen eine Onboarding-Seite**
- Die Ersteinrichtung hat fünf Fragen ("Frage x von 5") und soll leicht bleiben. Eine Frage zu Genitalien beim Erststart wirkt für eingeladene und zögerliche Menschen aufdringlich.
- Wer nie eine körperbezogene Übung öffnet, braucht sie nicht.

**Texte (neue Schlüssel, Namen sind mein Vorschlag):**

| Neuer Schlüssel | DE | EN |
|---|---|---|
| onboardingKoerperTitel | Körperbezogene Übungen (freiwillig) | Body-related exercises (optional) |
| onboardingKoerperText | Manche Übungen und Körperreisen sprechen den Körper ganz konkret an. Damit wir dir nichts vorschlagen, das nicht zu dir passt: Welche Beschreibung stimmt am ehesten? Das ist unabhängig von deinem Geschlecht. Du kannst überspringen, dann fragen wir erst, wenn eine Übung es braucht. | Some exercises and body journeys speak about the body very concretely. So we don't suggest anything that doesn't fit you: which description fits best? This is separate from your gender. You can skip it, and we'll only ask when an exercise needs it. |
| onboardingKoerperVulva | Vulva | Vulva |
| onboardingKoerperPenis | Penis | Penis |
| onboardingKoerperBeides | Beides oder anders | Both, or something else |
| onboardingKoerperSpaeter | Später fragen | Ask me later |

- **Gegenüber:** Den Körper des Gegenübers nicht im Onboarding fragen. Im Paar-Abend einmal beim Start ("Wer empfängt?") und mit "Ohne Angabe". Das ist die Stelle, an der es wirklich gebraucht wird.
- **Speichern und Sichern:** Wird ein neuer Wert gespeichert, gehört er in `StorageService`, Sicherung und `test/backup_merge_test.dart`. Ob `_keyKoerper` aus der Selbst-Reise schon in der Sicherung ist, habe ich nicht geprüft.

## Als Liste gemeldet, in dieser Sitzung nicht geändert (gesprochene Texte)

- `female_1` (Lektionstitel „Der weibliche Beckenboden …“), `touch_w_1`, `touch_m_1`, `pos_1`, `mass_1`, `mass_2`; weitere Stellen mit Frau/Mann in Kurs 3 (16), 9 (7), 11, 16, 18 (je 6), 19 (9), 20 (6), 2 und 14 (je 5).
- Die `{W}/{M}`-Fallbacks sind das, was eingesprochen wurde; sie bleiben, bis neu aufgenommen wird. Neuaufnahmen gibt es nicht in dieser Sitzung.
- Nicht gesprochen und deshalb mit änderbar: Kurstitel, Kategorie-Etiketten, Wunschkarten, Summaries, Landkarte-Beispiele (Stichproben in 3b).

## Prüfung

`flutter analyze`, `flutter test`, `flutter test test_screens/screens_test.dart` zusätzlich mit `SIZE=360x800` und `TEXTSCALE=1.3` sowie Profilen Paar-Fokus
(ungekoppelt, gekoppelt), `dating`, `single`, Geschlecht `unspecified`. Neu: Tests für `fromJson`/`genderLabel`, Wochenstand in `backup_merge_test.dart`, Altdaten ohne Feld.
`security_test.dart` bleibt grün. Nach den Textänderungen `translation_test` und PO-Abgleich. Danach liest ein frischer Subagent gegen.

## Offene Fragen (Entscheidung des Nutzers)

1. **Eure erste Woche – Inhalt:** Sind die sieben Schritte aus Abschnitt 4 richtig (Stopp-Wort, Atmen, Druck ist keine Schuld, Berührung ohne Ziel, Wünsche leise, ein Satz, Rückblick)? Heißt es „Woche“ (nichts ist an Tage gebunden) oder „Eure ersten Schritte“?
2. **Schritt 4 (Berührung):** Der Paar-Abend „Bekleidet“ dauert mindestens 20 Minuten. Reicht für „höchstens 15 Minuten“ die Anleitung `couples_1` Stufe eins in eigener Länge?
3. **Paar-Modus:** Nur bei Fokus „Paar“ und nicht `single` (Vorschlag) oder bei jeder Kopplung?
4. **Neutraler Fokus beim Überspringen:** `primaryGoal: 'open'` einführen (Zweig in `goalLabel`, kein Eintrag in `_schwerpunktZumFokus`)?
5. **Alter im Onboarding:** Bleibt die Alters-Frage (Slider, Standard 32)? Hängt an `altersnachweis.md`.
6. **Filter:** „Mit Vulva / Mit Penis“ wie vorgeschlagen, oder „Für meinen Körper“ mit der Körperfrage als Vorauswahl? Kurs 9 „Weibliche Lust und Körperwissen“ mitändern? Vorbelegung ganz weg?
7. **Gesprochene Lektionen:** Sollen sie später neu geschrieben und neu eingesprochen werden (Liste oben)?
8. **Körperfrage:** Im Profil und beim ersten Gebrauch (Vorschlag) oder als Onboarding-Seite?
9. **Auslöser des sanften Starts:** Knopf auf der Willkommensseite (Vorschlag) oder später ein Einladungslink mit Kennung? Soll der Einladungstext selbst darauf hinweisen?
10. **Name der Landkarte:** „Fantasie-Landkarte“ behalten oder „Wunsch-Landkarte“?
11. **Funke-Kacheln auf Heute** (Imperativ, „gehört dein Körper mir“, strikt tabu): hier mitändern (Abschnitt 1d) oder eigener Auftrag?
12. **Coach:** Ist die Entfernung endgültig? Davon hängen zwei Texte in 1a ab.
13. **Datenhaltung der Wochenkarte und Symbole:** Feld in `BedienDaten` und Abschnitt `symbole` in `bilder.json` wie vorgeschlagen?
14. **AG-Auftrag:** Den Bildauftrag nach dem OK in `AG.md` eintragen (neun Motive, oder zunächst nur die drei „nicht eindeutig“)?
15. **Alte Nutzer mit Paar-Fokus** sehen nach dem Update eine andere Startseite. Reicht der Hinweis in „Was ist neu“ mit dem Verweis auf „Mehr für dich allein“?
