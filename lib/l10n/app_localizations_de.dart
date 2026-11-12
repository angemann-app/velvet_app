// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get gemeinsamWiedergabeFehler =>
      'Eine Wiedergabe konnte nicht starten. Prüft die Aufnahmen und die Audioausgabe und versucht es erneut.';

  @override
  String get gemeinsamZurueckziehen => 'Einladung zurückziehen';

  @override
  String get aufnahmePaketFehlt =>
      'Das passende Inhaltspaket muss geladen werden.';

  @override
  String get wiedergabeStimmenStand => 'Aufnahmen für diese Stimme';

  @override
  String get gemeinsamAntwortZuLang =>
      'Der Rückblick ist zu lang. Kürze ihn bitte etwas und versuche es erneut.';

  @override
  String get gemeinsamGefuehlRuhig => 'Ruhig';

  @override
  String get gemeinsamGefuehlNah => 'Verbunden';

  @override
  String get gemeinsamGefuehlOffen => 'Noch offen';

  @override
  String get gemeinsamGefuehlBewegt => 'Bewegt';

  @override
  String get gemeinsamTitel => 'Gemeinsame Übung';

  @override
  String get gemeinsamHinweis =>
      'Ihr hört denselben Ablauf auf euren eigenen Geräten. Beide brauchen passende Aufnahmen und bestätigen ihre Bereitschaft. Kopfhörer können angenehm sein. Jede Person kann pausieren; weiter geht es erst, wenn beide bereit sind. Eine Einladung beginnt den Ablauf von vorn.';

  @override
  String get gemeinsamAnnehmen => 'Annehmen';

  @override
  String get gemeinsamSpaeter => 'Später';

  @override
  String get gemeinsamWarten => 'Du bist bereit. Warte auf dein Gegenüber.';

  @override
  String get gemeinsamBereitHinweis =>
      'Richte dich in Ruhe ein und bestätige dann deine Bereitschaft.';

  @override
  String get gemeinsamBereit => 'Bereit';

  @override
  String get gemeinsamPlayer => 'Wiedergabe öffnen';

  @override
  String get gemeinsamRueckblick => 'Gemeinsamer Rückblick';

  @override
  String get gemeinsamBeenden => 'Für beide beenden';

  @override
  String get gemeinsamSchliessen => 'Schließen';

  @override
  String get gemeinsamEinladung => 'Eine Einladung wartet auf dich.';

  @override
  String get gemeinsamVorbereiten => 'In Ruhe bereit werden';

  @override
  String get gemeinsamWartenAnnahme => 'Warte auf dein Gegenüber.';

  @override
  String get gemeinsamLaeuft => 'Ihr hört gemeinsam.';

  @override
  String get gemeinsamPause => 'Pause. Weiter erst, wenn beide bereit sind.';

  @override
  String get gemeinsamAbgeschlossen => 'Euer gemeinsamer Moment ist beendet.';

  @override
  String get gemeinsamAufnahmenFehlen =>
      'Passende Aufnahmen fehlen oder unterscheiden sich. Ladet beide die aktuellen Aufnahmen und ladet euch erneut ein. Gemeinsames Hören verwendet keine Geräte-Stimme.';

  @override
  String get gemeinsamPartnerFehlt =>
      'Dein Gegenüber ist gerade nicht erreichbar, bereits beschäftigt oder braucht eine aktuelle App. Öffnet beide den Paar-Kanal und versucht es erneut.';

  @override
  String get gemeinsamFehler =>
      'Die Verbindung hat nicht geklappt. Bitte versucht es erneut.';

  @override
  String get gemeinsamLeer => 'Wähle bei einer Wiedergabe „Gemeinsam hören“.';

  @override
  String get gemeinsamStatusOeffnen => 'Gemeinsamen Ablauf öffnen';

  @override
  String get gemeinsamStarten => 'Gemeinsam hören';

  @override
  String get gemeinsamDuEmpfaengst => 'Du empfängst, dein Gegenüber gibt.';

  @override
  String get gemeinsamVerbindungFehlt =>
      'Die Verbindung zum Gegenüber ist unterbrochen. Deine Wiedergabe läuft lokal weiter. Du kannst jederzeit pausieren; ein Wiederverbinden startet nichts automatisch.';

  @override
  String get gemeinsamRueckblickFrage => 'Wie war dieser Moment für dich?';

  @override
  String get gemeinsamRueckblickHinweis =>
      'Dein Rückblick ist freiwillig. Die Antwort deines Gegenübers wird erst sichtbar, wenn ihr beide eine eigene Antwort geteilt habt.';

  @override
  String get gemeinsamAntwort => 'Dein Rückblick';

  @override
  String get gemeinsamTeilen => 'Antwort speichern und teilen';

  @override
  String get gemeinsamGeteilt => 'Dein Rückblick wurde geteilt.';

  @override
  String get gemeinsamNochVerdeckt =>
      'Der gemeinsame Rückblick ist noch verdeckt.';

  @override
  String gemeinsamCountdown(int sekunden) {
    return 'Gemeinsamer Start in $sekunden';
  }

  @override
  String get wiedergabeNeutral => 'Wiedergabe';

  @override
  String get wiedergabeLeer => 'Keine zugängliche Wiedergabe ausgewählt.';

  @override
  String get wiedergabeBehalten =>
      'Du kannst diese Seite schließen und während des Hörens weiter entdecken.';

  @override
  String get wiedergabeTts =>
      'Geräte-Stimme: Beim Wiederaufnehmen beginnt dieser Abschnitt von vorn.';

  @override
  String get wiedergabeFehler =>
      'Die Wiedergabe konnte nicht fortgesetzt werden. Prüfe die Aufnahmen und versuche es erneut.';

  @override
  String get wiedergabeFertig => 'Für diesen Moment abgeschlossen.';

  @override
  String get wiedergabeTeilweise =>
      'Nicht alle Aufnahmen sind offline vorhanden. Fehlende Texte liest die Geräte-Stimme.';

  @override
  String get wiedergabeAbschnitte => 'Abschnitte';

  @override
  String get wiedergabeRuhe => 'Ruhe & Nachspüren';

  @override
  String get wiedergabeEntfernen => 'Aus Weiterhören entfernen';

  @override
  String get wiedergabeLaeuft => 'Läuft weiter';

  @override
  String get wiedergabeFortsetzen => 'Weiterhören';

  @override
  String wiedergabeRunde(int runde) {
    return 'Runde $runde';
  }

  @override
  String get sucheTitel => 'Entdecken & finden';

  @override
  String get aufnahmeOffline => 'Aufnahme offline verfügbar';

  @override
  String get wegTitel => 'Dein persönlicher Weg';

  @override
  String get wegEinladung =>
      'Wissen, Ausprobieren, Nachspüren. Drei freiwillige Schritte in deinem Tempo – ohne Zeitvorgabe oder Pflichtantwort.';

  @override
  String get wegWissen => 'Wissen entdecken';

  @override
  String get wegUeben => 'Übung ausprobieren';

  @override
  String get wegNachspueren => 'Nachspüren';

  @override
  String get wegBeginnen => 'Diesen Weg beginnen';

  @override
  String get wegNochEinmal => 'Noch einmal entdecken';

  @override
  String get wegOeffnen => 'Schritt öffnen';

  @override
  String get wegWeiter => 'Zum nächsten Schritt';

  @override
  String get wegAbschliessen => 'Für mich abschließen';

  @override
  String get wegFehler =>
      'Der Stand konnte nicht gespeichert werden. Bitte versuche es noch einmal.';

  @override
  String get aufnahmeGeraetestimme => 'Ohne Aufnahme: Geräte-Stimme';

  @override
  String get aufnahmeVerwalten => 'Aufnahmen laden';

  @override
  String get sucheFeld => 'Kurse, Lektionen und Übungen suchen';

  @override
  String get sucheLeeren => 'Suche leeren';

  @override
  String get sucheHinweis =>
      'Was möchtest du entdecken? Suche nach einem Thema oder einem Angebot. Deine Suche bleibt auf diesem Gerät und wird nicht gespeichert.';

  @override
  String get sucheLeer =>
      'Dazu wurde nichts gefunden. Versuche ein anderes Wort.';

  @override
  String get sucheFehler =>
      'Die Inhalte konnten nicht geladen werden. Öffne die Suche bitte erneut.';

  @override
  String get sucheKurs => 'Kurs';

  @override
  String get sucheLektion => 'Lektion';

  @override
  String get sucheAngebot => 'Audio & Praxis';

  @override
  String get suchePaarAbend => 'Geführter Paar-Abend';

  @override
  String get sucheInnenansichten => 'Innenansichten';

  @override
  String get appName => 'VelvetPulse';

  @override
  String get spracheTitel => 'Sprache';

  @override
  String get spracheAutomatisch => 'Automatisch (wie das Gerät)';

  @override
  String get spracheDeutsch => 'Deutsch';

  @override
  String get spracheEnglisch => 'English';

  @override
  String get mainNavigationProgrammeCourses => 'Heute';

  @override
  String get mainNavigationSomaticsTraining => 'Körper & Üben';

  @override
  String get mainNavigationCbtReframing => 'Gedanken';

  @override
  String get mainNavigationCoupleChannel => 'Paar-Kanal';

  @override
  String get mainNavigationCourses => 'Heute';

  @override
  String get mainNavigationTraining => 'Körper';

  @override
  String get mainNavigationReframing => 'Gedanken';

  @override
  String get whatsNewWelcomeBack => 'Willkommen zurück';

  @override
  String whatsNewThisIsNewInVersion(Object version) {
    return 'Das ist neu in Version $version.';
  }

  @override
  String get whatsNewLetSGo => 'Los geht\'s';

  @override
  String get playerSteuerungStop => 'Beenden';

  @override
  String get playerSteuerungResume => 'Fortsetzen';

  @override
  String get playerSteuerungPause => 'Pausieren';

  @override
  String get playerSteuerungPause2 => 'Pause';

  @override
  String get playerSteuerungSkip => 'Überspringen';

  @override
  String get ausspracheMeldenWordMispronounced => 'Wort falsch ausgesprochen?';

  @override
  String get ausspracheMeldenThanksForHelpingTheReport =>
      'Danke, dass du hilfst! Die Meldung landet öffentlich auf GitHub und braucht dort ein Konto. Sie ist unter deinem Kontonamen sichtbar.\n\nÜbertragen werden nur die Stelle im Audio und die Stimme. Das Wort trägst du selbst ein.';

  @override
  String get ausspracheMeldenCancel => 'Abbrechen';

  @override
  String get ausspracheMeldenContinueToGithub => 'Weiter zu GitHub';

  @override
  String get ausspracheMeldenTheBrowserCouldNotBe =>
      'Der Browser ließ sich nicht öffnen.';

  @override
  String get updateDialogYouHaveTheLatestVersion =>
      'Du hast die neueste Version.';

  @override
  String get updateDialogPleaseAllowTheAppTo =>
      'Bitte erlaube der App im nächsten Schritt, Updates zu installieren, und tippe dann erneut.';

  @override
  String get updateDialogTheDownloadedFileIsDamaged =>
      'Die heruntergeladene Datei ist beschädigt. Bitte später noch einmal versuchen.';

  @override
  String updateDialogTheUpdateDidnTWork(Object statusName) {
    return 'Das Update hat nicht geklappt ($statusName). Bitte später noch einmal versuchen.';
  }

  @override
  String get updateDialogDownloadFailedPleaseCheckYour =>
      'Download fehlgeschlagen. Bitte Internetverbindung prüfen.';

  @override
  String updateDialogNewBetaVersion(Object version) {
    return 'Neue Beta $version';
  }

  @override
  String updateDialogNewVersionVersion(Object version) {
    return 'Neue Version $version';
  }

  @override
  String get updateDialogImprovementsAndBugFixes =>
      'Verbesserungen und Fehlerbehebungen.';

  @override
  String updateDialogDownloadingProgress(Object progress) {
    return 'Wird heruntergeladen … $progress %';
  }

  @override
  String get updateDialogYourDataIsKeptDuring =>
      'Deine Daten bleiben bei der Aktualisierung erhalten.';

  @override
  String get updateDialogLater => 'Später';

  @override
  String get updateDialogUpdateNow => 'Jetzt aktualisieren';

  @override
  String get coursesAllCourses => 'Alle Kurse';

  @override
  String get coursesTouch => 'Berührung';

  @override
  String get coursesForHer => 'Mit Vulva';

  @override
  String get coursesForHim => 'Mit Penis';

  @override
  String get coursesForCouples => 'Zu zweit';

  @override
  String get coursesKoerperHilfe =>
      'Kurse zum Körperwissen. Ihr könnt beides ansehen.';

  @override
  String get coursesCoupleChannel => 'PAAR-KANAL';

  @override
  String get coursesYourPrivateSpace => 'Euer privater Raum';

  @override
  String get coursesSendSparksSecretlyMatchWishes =>
      'Funken schicken & Wünsche vergleichen, sichtbar wird nur, was ihr beide wollt';

  @override
  String get coursesYourCurriculum => 'DEINE KURSE';

  @override
  String coursesHelloProfilename(Object profileName) {
    return 'Hallo, $profileName';
  }

  @override
  String get coursesWelcome => 'Willkommen';

  @override
  String get heuteNaechsterSchritt => 'Dein nächster Schritt';

  @override
  String get heuteStarten => 'Starten';

  @override
  String get heuteWeitermachen => 'Weitermachen';

  @override
  String heuteKursUndDauer(String kurs, int min) {
    return '$kurs · $min Min.';
  }

  @override
  String get heuteAllesErledigt =>
      'Du hast alle Lektionen durch. Stöbere in den Kursen oder hör ein Audio.';

  @override
  String get heuteBleibtLokal => 'Bleibt auf deinem Handy';

  @override
  String get heuteReiterCheckin => 'Check-in';

  @override
  String get heuteReiterFunke => 'Funke';

  @override
  String get heuteKurse => 'Kurse';

  @override
  String get wuenscheSzenenTitel => 'Szenen zum Ausprobieren';

  @override
  String get wuenscheSzenenText =>
      'Ganze Abende statt einzelner Fragen. Beantwortet sie getrennt, wie in der Landkarte. Nur im Spicy-Modus.';

  @override
  String get wuenscheBesprechenTitel => 'Zum Besprechen';

  @override
  String get wuenscheBesprechenText =>
      'Hier ist mindestens ein „Vielleicht“ dabei. Sprecht kurz darüber, was ihr euch vorstellen könnt.';

  @override
  String get onboardingLosGehts => 'Loslegen';

  @override
  String get onboardingWeiter => 'Weiter';

  @override
  String get onboardingZurueck => 'Zurück';

  @override
  String get onboardingOk => 'OK';

  @override
  String get onboardingMehrDatenschutz => 'Mehr zum Datenschutz';

  @override
  String get onboardingVersprechenLokal =>
      'Alles bleibt auf deinem Handy: Profil, Tagebuch und Fortschritt.';

  @override
  String get onboardingVersprechenKeinKonto =>
      'Kein Konto, keine Werbung, keine Auswertung.';

  @override
  String get onboardingVersprechenNetz =>
      'Ins Netz geht nur, was du selbst einschaltest: der Paar-Kanal, das Laden von Aufnahmen und die Suche nach Updates.';

  @override
  String get onboardingEingeladenLink => 'Jemand hat mich eingeladen';

  @override
  String get onboardingEingeladenTitel1 => 'Schön, dass du da bist';

  @override
  String get onboardingEingeladenText1 =>
      'Jemand, der dir wichtig ist, hat dich eingeladen, VelvetPulse auszuprobieren. Die App ist ein ruhiger Ort für Nähe, Körper und Gespräche, zum Lesen, Hören und Üben, allein oder zu zweit. Du musst nichts können und nichts leisten.';

  @override
  String get onboardingEingeladenTitel2 => 'Nein ist immer eine Antwort';

  @override
  String get onboardingEingeladenText2 =>
      'Nichts hier ist eine Aufgabe. Zu jedem Schritt gibt es ein „Heute nicht“, und es hat keine Folgen. Deine Antworten bleiben bei dir, bis du dich verbindest. Auch danach sieht dein Gegenüber nicht, was du ansiehst, ausprobierst oder überspringst, nur, was du selbst schickst. Zwei Ausnahmen: Bei den Wünschen seht ihr beide nur, wo ihr übereinstimmt, und im Chat sieht dein Gegenüber, ob du gelesen hast (abschaltbar).';

  @override
  String get onboardingEingeladenTitel3 =>
      'Deine Daten bleiben auf deinem Handy';

  @override
  String get onboardingEingeladenText3 =>
      'Kein Konto, keine Werbung, keine Auswertung. Du kannst jederzeit aufhören, die App schließen oder sie ganz entfernen. Verbinden mit der Person, die dich eingeladen hat, geht später und nur, wenn du magst.';

  @override
  String get onboardingEingeladenEinrichten =>
      'Einrichten (fünf kurze Fragen, alle freiwillig)';

  @override
  String get onboardingEingeladenVerbinden => 'Mit der Person verbinden';

  @override
  String get onboardingEingeladenNurSchauen => 'Ich schau erst mal nur';

  @override
  String onboardingSchritt(int n, int gesamt) {
    return 'Frage $n von $gesamt';
  }

  @override
  String get heuteAlleKurse => 'Alle Kurse ansehen';

  @override
  String get navLernen => 'Lernen';

  @override
  String get navUeben => 'Üben';

  @override
  String get navWir => 'Wir';

  @override
  String get uebenKoerper => 'Körper';

  @override
  String get uebenGedanken => 'Gedanken';

  @override
  String coursesYourFocusGoallabel(Object goalLabel) {
    return 'Dein Fokus: $goalLabel';
  }

  @override
  String get coursesUnderstandTheBiologyQuietThe =>
      'Verstehen, was in dir passiert. Zur Ruhe kommen. Den Körper spüren.';

  @override
  String get coursesProfileSettings => 'Profil & Einstellungen';

  @override
  String coursesOverallProgressCompletedcountOfTotallessons(
      Object completedCount, Object totalLessons) {
    return 'Gesamtfortschritt: $completedCount von $totalLessons Lektionen';
  }

  @override
  String coursesDurationminMin(Object durationMin) {
    return '$durationMin Min.';
  }

  @override
  String get coursesPracticePelvicFloor => 'Praxis: Beckenboden';

  @override
  String get coursesPracticeBreath => 'Praxis: Atem';

  @override
  String get coursesPracticeCbt => 'Praxis: Gedanken';

  @override
  String get lessonDetailLessonMarkedAsCompleted =>
      'Lektion als abgeschlossen markiert!';

  @override
  String get lessonDetailLessonMarkedAsOpenAgain =>
      'Lektion wieder als offen markiert.';

  @override
  String lessonDetailLessonSentToPartnername(Object partnerName) {
    return 'Lektion an $partnerName geschickt.';
  }

  @override
  String get lessonDetailSendingDidnTWorkPlease =>
      'Senden hat nicht geklappt. Bitte gleich noch einmal versuchen.';

  @override
  String lessonDetailYourThoughtsAreWithPartnername(Object partnerName) {
    return 'Deine Gedanken sind bei $partnerName. Sichtbar werden sie, wenn auch dort eine Antwort steht.';
  }

  @override
  String lessonDetailNameHasAlreadyAnswered(Object name) {
    return '$name hat schon geantwortet';
  }

  @override
  String lessonDetailNameSThoughts(Object name) {
    return 'Die Gedanken von $name';
  }

  @override
  String lessonDetailWriteAndSaveYourOwn(Object name) {
    return 'Schreib und speichere zuerst deine eigene Antwort, dann siehst du die von $name.';
  }

  @override
  String lessonDetailShareWithPartnername(Object partnerName) {
    return 'Mit $partnerName teilen';
  }

  @override
  String get lessonDetailCompleted => 'Abgeschlossen';

  @override
  String get lessonDetailMarkAsCompleted => 'Als abgeschlossen markieren';

  @override
  String get lessonDetailAudioExercise => 'AUDIO-ÜBUNG';

  @override
  String get lessonDetailLesson => 'LEKTION';

  @override
  String lessonDetailDurationminMinRead(Object durationMin) {
    return '$durationMin Min. Lesezeit';
  }

  @override
  String get lessonDetailLessonCompletedDone =>
      'Lektion abgeschlossen (Erledigt)';

  @override
  String get lessonDetailMarkLessonAsCompleted =>
      'Lektion als abgeschlossen markieren';

  @override
  String get lessonDetailOpenPelvicFloorTimer => 'Beckenboden-Timer öffnen';

  @override
  String get lessonDetailGoStraightIntoRelaxationStrengthening =>
      'Direkt in die Entspannungs- & Kräftigungs-Praxis einsteigen';

  @override
  String get lessonDetailStartBreathPacerDownRegulation =>
      'Atem-Begleiter starten (langes Ausatmen)';

  @override
  String get lessonDetailCalmDownWithBreathingOr =>
      'Mit 4-7-8-Atmung oder dem langen Seufzer zur Ruhe kommen';

  @override
  String get lessonDetailMyDesireProfile => 'Mein Lust-Profil';

  @override
  String get lessonDetailTickWhatYouLikeAnd =>
      'Ankreuzen, was dir gefällt – und auf Wunsch deinem Gegenüber schicken';

  @override
  String get lessonDetailGuidedSelfExploration => 'Geführte Selbsterkundung';

  @override
  String get lessonDetailToMinutesAVoiceGuides =>
      '10 bis 30 Minuten, eine Stimme begleitet dich – so nah, wie du möchtest';

  @override
  String get lessonDetailStartCbtThoughtRecord =>
      'KVT-Gedankenprotokoll starten';

  @override
  String get lessonDetailReframeAnticipatoryAnxietyAndCatastrophic =>
      'Erwartungsangst und innere Katastrophengedanken reframen';

  @override
  String get lessonDetailMatchingPractice => 'PASSENDE PRAXIS-ÜBUNG';

  @override
  String get lessonDetailStartThePracticeNow => 'Jetzt Praxis-Übung starten';

  @override
  String get lessonDetailYourPersonalReflection =>
      'Deine persönliche Reflexion';

  @override
  String get lessonDetailWriteDownYourHonestThoughts =>
      'Schreibe hier deine ehrlichen Gedanken auf. Sie bleiben auf deinem Gerät, außer du teilst sie.';

  @override
  String get lessonDetailSavedLocally => 'Lokal gespeichert!';

  @override
  String get lessonDetailSaveAnswer => 'Antwort speichern';

  @override
  String lessonDetailShareWithPartnername2(Object partnerName) {
    return 'Mit $partnerName teilen';
  }

  @override
  String get audioPlayerCardDeviceVoice => 'GERÄTE-STIMME';

  @override
  String get audioPlayerCardGuidedExercise => 'GEFÜHRTE ÜBUNG';

  @override
  String get audioPlayerCardListen => 'ZUM ANHÖREN';

  @override
  String get audioPlayerCardJustFollowTheVoice => 'Folge einfach der Stimme …';

  @override
  String get audioPlayerCardReadingAloud => 'Wird vorgelesen …';

  @override
  String get audioPlayerCardPausedTapToResume =>
      'Pausiert • Tippe zum Fortsetzen';

  @override
  String get audioPlayerCardCloseYourEyesAndListen =>
      'Schließ die Augen und lausche';

  @override
  String audioPlayerCardListenToTheLessonApprox(Object durationMin) {
    return 'Lektion anhören (ca. $durationMin Min.)';
  }

  @override
  String get audioPlayerCardBackS => '10 Sek. zurück';

  @override
  String get audioPlayerCardForwardS => '10 Sek. vor';

  @override
  String get audioPlayerCardStopReset => 'Stoppen & Zurücksetzen';

  @override
  String get trainingPelvicFloor => 'Beckenboden';

  @override
  String get trainingBreathPacer => 'Atem-Pacer';

  @override
  String get breathPacerViewBreatheIn => 'EINATMEN';

  @override
  String get breathPacerViewBreatheInCalmlyAndDeeply =>
      'Ruhig und tief durch die Nase einatmen...';

  @override
  String get breathPacerViewHold => 'HALTEN';

  @override
  String get breathPacerViewHoldYourBreathKeepThe =>
      'Atem anhalten, Brustkorb entspannt lassen...';

  @override
  String get breathPacerViewBreatheOutSlowly => 'LANGSAM AUSATMEN';

  @override
  String get breathPacerViewBreatheOutFullyThroughThe =>
      'Vollständig und mit sanftem Zischen durch den Mund ausatmen...';

  @override
  String get breathPacerViewBreatheInDeeply => 'TIEF EINATMEN';

  @override
  String get breathPacerViewBreatheDeepIntoTheBelly =>
      'Tief durch die Nase in den Bauch einatmen...';

  @override
  String get breathPacerViewSecondBreath => 'ZWEITER ATEMZUG';

  @override
  String get breathPacerViewTakeOneMoreShortSip =>
      'Noch einen kurzen Luftzug oben drauf ziehen...';

  @override
  String get breathPacerViewSighItOut => 'SEUFZEND AUSATMEN';

  @override
  String get breathPacerViewBreatheOutVeryLongAnd =>
      'Sehr lang und hörbar durch den Mund ausatmen, Schultern fallen lassen...';

  @override
  String get breathPacerViewBreathing => '4-7-8 Atmung';

  @override
  String get breathPacerViewDeepCalmingBreath => 'Tiefe, beruhigende Atmung';

  @override
  String get breathPacerViewPhysiologicalSigh => 'Physiol. Seufzer';

  @override
  String get breathPacerViewQuickWayToCalmDown => 'Schnell zur Ruhe kommen';

  @override
  String breathPacerViewCompletedcyclesCyclesCompleted(Object completedCycles) {
    return '$completedCycles Zyklen abgeschlossen';
  }

  @override
  String get breathPacerViewALongerExhaleMeasurablySlows =>
      'Längeres Ausatmen verlangsamt messbar den Herzschlag.';

  @override
  String get breathPacerViewTheDoubleInhaleIsMeant =>
      'Der doppelte Atemzug entfaltet kollabierte Lungenbläschen.';

  @override
  String get breathPacerViewStart => 'Start';

  @override
  String get breathPacerViewBackgroundWhenTheExhaleLasts =>
      'Hintergrund: Wenn das Ausatmen länger dauert als das Einatmen, wird der Herzschlag mit jedem Ausatmen ein wenig langsamer. Das ist ein normaler Reflex, den viele als beruhigend erleben.';

  @override
  String get sosTitel => 'Hilfe';

  @override
  String get sosAuswahlTitel => 'Was ist gerade los?';

  @override
  String get sosAuswahlUntertitel =>
      'Du musst nichts erklären. Such aus, was am ehesten passt.';

  @override
  String get sosAuswahlHilfe => 'Ich werde gedrängt, mein Nein gilt nicht';

  @override
  String get sosWeiter => 'Weiter';

  @override
  String get sosZurueck => 'Zurück';

  @override
  String get sosZurAuswahl => 'Zur Auswahl';

  @override
  String get sosSchliessen => 'Schließen';

  @override
  String sosSchrittVon(int aktuell, int gesamt) {
    return 'Schritt $aktuell von $gesamt';
  }

  @override
  String get sosSatzTitel => 'Ein Satz, den du sagen kannst';

  @override
  String get sosHilfeKnopf => 'Hilfe bei Druck oder Gewalt';

  @override
  String get sosHilfeTitel => 'Hilfe, wenn ein Nein nicht gilt';

  @override
  String get sosHilfeEinstieg =>
      'Wenn du Nein gesagt hast oder nichts sagen konntest und es trotzdem weiterging, ist das nicht in Ordnung. Du bist nicht schuld. Auch nicht, wenn ihr ein Paar seid, wenn du vorher Ja gesagt hast oder wenn du es nicht deutlich genug gesagt hast. Erstarren ist eine normale Schutzreaktion.';

  @override
  String get sosHilfeGiltTitel => 'Was gilt';

  @override
  String get sosHilfeGilt1 =>
      'Ein Nein gilt, auch mittendrin und auch in einer Beziehung.';

  @override
  String get sosHilfeGilt2 =>
      'Ein Ja nach Überreden, Drängen, Schmollen, Drohen oder Schweigen als Druckmittel ist keine freie Zustimmung.';

  @override
  String get sosHilfeGilt3 =>
      'Wer schläft, bewusstlos, stark betrunken oder berauscht ist oder Angst hat, kann nicht frei zustimmen.';

  @override
  String get sosHilfeGilt4 =>
      'Du musst nichts beweisen, um Hilfe zu bekommen. Beratung geht auch ohne Anzeige. Du entscheidest, was du tust und wann.';

  @override
  String get sosHilfeNotrufTitel => 'Bei akuter Gefahr';

  @override
  String get sosHilfeAnrufenTitel => 'Mit jemandem sprechen';

  @override
  String get sosHilfeDiskretion =>
      'Anrufe stehen in der Anrufliste und manchmal auf der Rechnung. Aus der Anrufliste kannst du sie löschen. Ein Chat steht im Browserverlauf. Ein privates Fenster hinterlässt weniger.';

  @override
  String sosHilfeStand(String stand) {
    return 'Stand der Angaben: $stand. Nummern und Zeiten können sich ändern.';
  }

  @override
  String get sosHilfeAnrufen => 'Anrufen';

  @override
  String get sosHilfeWebseite => 'Webseite';

  @override
  String sosSatzZitat(String satz) {
    return '„$satz“';
  }

  @override
  String sosHilfeAnrufenNummer(String nummer) {
    return '$nummer anrufen';
  }

  @override
  String sosHilfeNummerWaehlen(String nummer) {
    return 'Bitte wähle $nummer';
  }

  @override
  String get sosHilfeSchnellVerlassen => 'Schnell verlassen';

  @override
  String get sosLandDe => 'Deutschland';

  @override
  String get sosLandAt => 'Österreich';

  @override
  String get sosLandCh => 'Schweiz';

  @override
  String get sosLandUk => 'Vereinigtes Königreich';

  @override
  String get sosLandUs => 'USA';

  @override
  String get sosNotrufDe => 'Polizei 110 · Rettung und Feuerwehr 112';

  @override
  String get sosNotrufAt => 'Polizei 133 · Rettung 144 · europaweit 112';

  @override
  String get sosNotrufCh => 'Polizei 117 · Sanität 144 · 112';

  @override
  String get sosNotrufUk => '999 (Polizei, Rettung)';

  @override
  String get sosNotrufUs => '911 (Polizei, Rettung)';

  @override
  String get sosStelleDeFrauenName => 'Hilfetelefon Gewalt gegen Frauen';

  @override
  String get sosStelleDeFrauenHinweis =>
      'Rund um die Uhr, kostenlos und anonym. Berät auch bei sexueller Gewalt, per Telefon, Chat und in vielen Sprachen.';

  @override
  String get sosStelleDeMaennerName => 'Hilfetelefon Gewalt an Männern';

  @override
  String get sosStelleDeMaennerHinweis =>
      'Kostenlos und anonym. Telefon: Mo bis Do 8 bis 20 Uhr, Fr 8 bis 15 Uhr. Der Chat hat kürzere Zeiten.';

  @override
  String get sosStelleDeWeisserName => 'WEISSER RING Opfer-Telefon';

  @override
  String get sosStelleDeWeisserHinweis =>
      'Täglich 7 bis 22 Uhr, kostenlos und anonym, für Opfer von Straftaten.';

  @override
  String get sosStelleDeSeelsorgeName => 'Telefonseelsorge';

  @override
  String get sosStelleDeSeelsorgeHinweis =>
      'Telefon rund um die Uhr und kostenlos, auch unter 0800 111 0 222 und 116 123. Chat nur nach Anmeldung und mit Termin. Beratung auf Deutsch.';

  @override
  String get sosStelleAtFrauenName => 'Frauenhelpline gegen Gewalt';

  @override
  String get sosStelleAtFrauenHinweis =>
      'Rund um die Uhr, kostenlos, anonym und vertraulich.';

  @override
  String get sosStelleAtGewaltschutzName => 'Gewaltschutzzentren';

  @override
  String get sosStelleAtGewaltschutzHinweis =>
      'Kostenlos und vertraulich. Bundesweite Nummer laut Frauenhelpline.';

  @override
  String get sosStelleChOpferhilfeName => 'Opferhilfe 142';

  @override
  String get sosStelleChOpferhilfeHinweis =>
      'Seit 1. Mai 2026 in der ganzen Schweiz, rund um die Uhr, kostenlos und anonym. Kein Notruf: Bei Gefahr zuerst die Polizei rufen.';

  @override
  String get sosStelleUkRapeName => 'Rape Crisis Support Line';

  @override
  String get sosStelleUkRapeHinweis =>
      'Rund um die Uhr, kostenlos, auch per Chat. Für Menschen ab 16 in England und Wales, die Vergewaltigung oder sexuelle Gewalt erlebt haben.';

  @override
  String get sosStelleUsRainnName => 'RAINN National Sexual Assault Hotline';

  @override
  String get sosStelleUsRainnHinweis =>
      'Rund um die Uhr, kostenlos und vertraulich, auf Englisch und Spanisch. Chat auf online.rainn.org.';

  @override
  String get sosStelleUs988Name => '988 Suicide & Crisis Lifeline';

  @override
  String get sosStelleUs988Hinweis =>
      'Anruf oder SMS, rund um die Uhr, kostenlos, bei seelischen Krisen.';

  @override
  String get appLockLocked => 'Gesperrt';

  @override
  String get appLockUnlock => 'Entsperren';

  @override
  String get mainCbtSomaticCoaching => 'KVT & SOMATIK COACHING';

  @override
  String coursesCourseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kurse',
      one: '1 Kurs',
    );
    return '$_temp0';
  }

  @override
  String coursesStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage in Folge aktiv',
      one: '1 Tag in Folge aktiv',
    );
    return '$_temp0';
  }

  @override
  String get coursesPracticeSelfExploration => 'Praxis: Selbsterkundung';

  @override
  String get coursesPracticeDesireProfile => 'Praxis: Lust-Profil';

  @override
  String get couplesChannelIWantYou => 'Lust auf dich';

  @override
  String get couplesChannelJustCuddlesToday => 'Heute nur kuscheln';

  @override
  String get couplesChannelLookingForwardToLater => 'Freu mich auf später';

  @override
  String get couplesChannelVerySlowlyToday => 'Heute ganz langsam';

  @override
  String get couplesChannelLetSTalk => 'Lass uns reden';

  @override
  String get couplesChannelNotToday => 'Heute lieber nicht';

  @override
  String get couplesChannelReconnect => 'Neu verbinden';

  @override
  String get couplesChannelConnectWithYourPartnerAnd =>
      'Verbinde dich mit deinem Gegenüber und teilt Wünsche, die sonst schwer auszusprechen sind.';

  @override
  String get couplesChannelSendSparks => 'Funken senden';

  @override
  String get couplesChannelShowWithOneTapWhat =>
      'Mit einem Tippen zeigen, worauf du heute Lust hast – oder eben nicht.';

  @override
  String get couplesChannelSecretlyMatchWishes => 'Wünsche leise vergleichen';

  @override
  String get couplesChannelYouVoteSeparatelyOnlyWhat =>
      'Ihr stimmt getrennt ab. Sichtbar wird nur, was ihr beide wollt.';

  @override
  String get couplesChannelJustForTheTwoOf => 'Nur für euch beide';

  @override
  String get couplesChannelEndToEndEncryptedNo =>
      'Ende-zu-Ende-verschlüsselt, ohne Konto und ohne Telefonnummer.';

  @override
  String get couplesChannelConnectWithPartner => 'Mit Partner verbinden';

  @override
  String get couplesChannelInvitePartner => 'Partner einladen';

  @override
  String get couplesChannelHowDoesItWork => 'Wie funktioniert das?';

  @override
  String get couplesChannelYouCanAlsoFillIt =>
      'Kannst du auch allein ausfüllen und später mit deinem Gegenüber vergleichen.';

  @override
  String get couplesChannelSharedEvening => 'Gemeinsamer Abend';

  @override
  String get couplesChannelGuidedTouchForTheTwo =>
      'Geführte Berührung für euch beide, 20 bis 45 Minuten. Jedes Mal anders.';

  @override
  String get couplesChannelFantasyMap => 'Fantasie-Landkarte';

  @override
  String get couplesChannelMessages => 'Nachrichten';

  @override
  String get couplesChannelWishes => 'Gemeinsam entdecken';

  @override
  String get couplesChannelConnectedEncrypted => 'verbunden & verschlüsselt';

  @override
  String get couplesChannelConnecting => 'verbindet …';

  @override
  String get couplesChannelOfflineTapToConnect =>
      'offline – tippe zum Verbinden';

  @override
  String couplesChannelYouName(Object name) {
    return 'Du & $name';
  }

  @override
  String get couplesChannelPartnerSNameGender =>
      'Name & Geschlecht des Gegenübers';

  @override
  String get couplesChannelReadReceipts => 'Lesebestätigungen';

  @override
  String get couplesChannelEncryptionDetails => 'Verschlüsselung & Details';

  @override
  String get couplesChannelManageConnection => 'Verbindung verwalten';

  @override
  String get couplesChannelDisconnect => 'Verbindung trennen';

  @override
  String get couplesChannelItSStillQuietHere => 'Noch ist es still hier';

  @override
  String get couplesChannelSendASparkFromThe =>
      'Schick einen Funken aus der Leiste unten oder schreib ein paar Worte.';

  @override
  String get couplesChannelRead => ' · Gelesen';

  @override
  String get couplesChannelSent => ' · Gesendet';

  @override
  String get couplesChannelOpenLesson => 'Lektion öffnen';

  @override
  String get couplesChannelWriteAMessage => 'Nachricht schreiben …';

  @override
  String get couplesChannelSend => 'Senden';

  @override
  String get couplesChannelVoteSeparatelyAWishOnly =>
      'Antwortet getrennt. Ein Wunsch wird erst sichtbar, wenn ihr beide „Ja, gern“ gesagt habt. Ein „Vielleicht“ kommt zu „Zum Besprechen“. Ein „Lieber nicht“ wird deinem Gegenüber nicht angezeigt.';

  @override
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche) {
    return '$fragen Fragen in $bereiche Bereichen – mit passenden Kurs-Empfehlungen.';
  }

  @override
  String get couplesChannelYouHaveAMatch => 'Bei einer Sache sagt ihr beide Ja';

  @override
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength) {
    return 'Bei $matchesLength Dingen sagt ihr beide Ja';
  }

  @override
  String get couplesChannelAMatchIsAnInvitation =>
      'Ein gemeinsames Ja ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt. Und ein „Heute nicht“ gilt immer.';

  @override
  String get couplesChannelYesPlease => 'Ja, gern';

  @override
  String get couplesChannelRatherNot => 'Lieber nicht';

  @override
  String get couplesChannelDisconnect2 => 'Verbindung trennen?';

  @override
  String couplesChannelTheHistoryWithNameName(
      Object name, Object name2, Object name3) {
    return 'Der Verlauf mit $name, die Antworten von $name2 auf die Ja/Nein-Liste und die geteilten Reflexionen werden auf diesem Handy gelöscht. Deine eigenen Antworten bleiben erhalten.\n\nAuf dem Handy von $name3 ändert sich nichts.';
  }

  @override
  String get couplesChannelDisconnect3 => 'Trennen';

  @override
  String get couplesChannelDisconnected => 'Verbindung getrennt.';

  @override
  String get couplesChannelHowItStaysPrivate => 'So bleibt es privat';

  @override
  String get couplesChannelMessagesAreEncryptedOnYour =>
      'Nachrichten werden auf deinem Handy verschlüsselt und erst auf dem Handy deines Gegenübers wieder lesbar. Dazwischen laufen sie über öffentliche Nostr-Server. Die können den Inhalt nicht lesen. Sichtbar sind für sie aber die Schlüssel von Absender und Empfänger, Zeitpunkt und ungefähre Größe jeder Nachricht sowie deine IP-Adresse – also dass, wann und wie oft ihr schreibt. Die Schlüssel tragen keinen Namen. Es gibt kein Konto, keine Telefonnummer und keinen Server von uns.';

  @override
  String get couplesChannelEncryption => 'Verschlüsselung';

  @override
  String get couplesChannelEncryptionSealed => 'Nostr NIP-17 (versiegelt)';

  @override
  String get couplesChannelSealedNote =>
      'Schreibt ihr beide mit einer neuen Version, gehen die Nachrichten versiegelt raus: Die Server sehen nicht, wer sie schickt, und nur einen ungenauen Zeitpunkt. Sichtbar bleiben für sie, dass jemand an einen von euch schreibt, deine IP-Adresse und die ungefähre Größe.';

  @override
  String get couplesChannelServers => 'Server';

  @override
  String get couplesChannelYourConnectionCode => 'Dein Verbindungscode';

  @override
  String get couplesChannelClose => 'Schließen';

  @override
  String get paarAbendYou => 'Du';

  @override
  String get paarAbendYourPartner => 'dein Gegenüber';

  @override
  String get paarAbendEndTheEvening => 'Abend beenden?';

  @override
  String get paarAbendTheGuidanceStopsThenYou =>
      'Die Begleitung hört dann auf. Ihr könnt jederzeit neu beginnen.';

  @override
  String get paarAbendContinue => 'Weitermachen';

  @override
  String get paarAbendPutThePhoneNextTo =>
      'Legt das Handy neben euch. Eine Stimme führt euch durch Ankommen, zwei Runden Berührung mit Rollenwechsel und einen ruhigen Ausklang. Die meiste Zeit ist Stille, damit ihr ganz bei euch seid. Jeder Abend wird neu zusammengestellt.';

  @override
  String get paarAbendDuration => 'Dauer';

  @override
  String paarAbendMMin(Object m) {
    return '$m Min.';
  }

  @override
  String get paarAbendHowFarMayItGo => 'Wie weit darf es gehen?';

  @override
  String get paarAbendClothed => 'Bekleidet';

  @override
  String get paarAbendBackShouldersHandsHeadLegs =>
      'Rücken, Schultern, Hände, Kopf, Beine und Füße.';

  @override
  String get paarAbendSkinToSkin => 'Haut an Haut';

  @override
  String get paarAbendPlusMassageWithOilBelly =>
      'Dazu Massage mit Öl, Bauch, Hüften und Po.';

  @override
  String get paarAbendIntimate => 'Intim';

  @override
  String get paarAbendPlusChestInnerThighsAnd =>
      'Dazu Brust, Innenschenkel und Geschlecht, ganz ohne Ziel.';

  @override
  String get paarAbendWhoGivesFirst => 'Wer gibt zuerst?';

  @override
  String get paarAbendMe => 'Ich';

  @override
  String get paarAbendMyPartner => 'Mein Gegenüber';

  @override
  String get paarAbendVoice => 'Stimme';

  @override
  String get paarAbendSoftSoundBed => 'Leiser Klangteppich';

  @override
  String get paarAbendCalmBackgroundDuringTheSilences =>
      'Ruhiger Hintergrund in den Stillen';

  @override
  String get paarAbendAgreeOnAStopWord =>
      'Vereinbart vorher ein Stoppwort. Die Stimme lädt ein, sie bestimmt nichts: Was sich nicht gut anfühlt, lasst ihr einfach aus.';

  @override
  String get paarAbendBeginTheEvening => 'Abend beginnen';

  @override
  String get paarAbendThankYouForYourEvening => 'Danke für euren Abend';

  @override
  String get paarAbendStayLyingDownAsLong =>
      'Bleibt liegen, solange es sich gut anfühlt.';

  @override
  String paarAbendRoundRunde(Object runde) {
    return 'Runde $runde';
  }

  @override
  String paarAbendYouGivePartnernameReceives(Object partnerName) {
    return 'Du gibst · $partnerName empfängt';
  }

  @override
  String paarAbendPartnernamePartnernameGivesYouReceive(
      Object partnerName, Object partnerName2) {
    return '$partnerName$partnerName2 gibt · du empfängst';
  }

  @override
  String get paarAbendArriving => 'Ankommen';

  @override
  String get paarAbendEnding => 'Ausklang';

  @override
  String get paarAbendChangeOfRoles => 'Rollenwechsel';

  @override
  String get paarAbendBreatheTogether => 'Atmet gemeinsam.';

  @override
  String get paarAbendPaused => 'Pausiert';

  @override
  String get paarAbendTheVoiceIsSpeaking => 'Die Stimme spricht …';

  @override
  String paarAbendSilenceStillerestLeft(Object stilleRest) {
    return 'Stille · noch $stilleRest';
  }

  @override
  String invitePartnerIDLikeToTry(Object stableApkUrl, Object testerGuideUrl) {
    return '\nIch möchte VelvetPulse mit dir ausprobieren 💛 Eine private App für Nähe und Gespräche, nur für uns zwei. Du musst nichts können, und zu allem darfst du „Heute nicht“ oder „Nein“ sagen. Schau gern erst mal nur rein. Deine Daten bleiben auf deinem Handy.\n\n1. App laden (Android):\n$stableApkUrl\nWenn Android fragt, die Installation erlauben. Tippe beim ersten Start auf „Jemand hat mich eingeladen“.\n\n2. Meinen Verbindungscode schicke ich dir gleich als eigene Nachricht. Kopiere ihn und füge ihn in der App ein: Paar-Kanal › Mit Partner verbinden › Partner scannen › Code einfügen › „Verbinden & Koppeln“.\n\n3. Schick mir danach einen Funken, dann sind wir verbunden.\n\nAusführliche Anleitung: $testerGuideUrl';
  }

  @override
  String get invitePartnerYouSendALinkTo =>
      'Du schickst einen Link zur App und deinen Verbindungscode, z. B. per Messenger. Dein Gegenüber kann sich in Ruhe umsehen und entscheidet selbst, ob und wann es sich verbindet. Dann bestätigst du hier die Verbindung.';

  @override
  String get invitePartnerNameEGAnna => 'Name, z. B. Anna';

  @override
  String get invitePartnerShareInvitation => 'Einladung teilen';

  @override
  String get invitePartnerInvitationToVelvetpulse => 'Einladung zu VelvetPulse';

  @override
  String get invitePartnerNowYourCode => 'Jetzt noch deinen Code';

  @override
  String get invitePartnerSendYourConnectionCodeAfterwards =>
      'Schick deinen Verbindungscode als eigene Nachricht hinterher, am besten an dieselbe Person. So lässt er sich mit einem Tippen kopieren.';

  @override
  String get invitePartnerShareCode => 'Code teilen';

  @override
  String get invitePartnerMyVelvetpulseCode => 'Mein VelvetPulse-Code';

  @override
  String get invitePartnerCopiedPasteTheTextInto =>
      'Kopiert. Füge den Text in einen Messenger ein.';

  @override
  String invitePartnerNameWantsToConnect(Object name) {
    return '$name möchte sich verbinden';
  }

  @override
  String invitePartnerInvitationSentToName(Object name) {
    return 'Einladung an $name verschickt';
  }

  @override
  String invitePartnerAMessageJustArrivedAt(Object name) {
    return 'Gerade kam eine Nachricht an deinen Code. Wenn sie von $name ist, nimm die Verbindung an.';
  }

  @override
  String invitePartnerAsSoonAsNameInstalls(Object name) {
    return 'Sobald $name die App installiert, deinen Code eingibt und dir einen Funken schickt, kannst du die Verbindung hier bestätigen. Lass $name Zeit.';
  }

  @override
  String get invitePartnerDecline => 'Ablehnen';

  @override
  String invitePartnerConnectedWithName(Object name) {
    return 'Verbunden mit $name';
  }

  @override
  String get invitePartnerAccept => 'Annehmen';

  @override
  String get invitePartnerWithdraw => 'Zurückziehen';

  @override
  String get invitePartnerShareAgain => 'Erneut teilen';

  @override
  String get pairingModalConnectWithSomeoneElse =>
      'Mit jemand anderem verbinden?';

  @override
  String pairingModalYouReCurrentlyConnectedWith(
      Object old, Object old2, Object old3) {
    return 'Du bist gerade mit $old verbunden. Diese Verbindung wird ersetzt, und der Verlauf mit $old2, die Antworten von $old3 und die geteilten Reflexionen werden auf diesem Handy gelöscht.';
  }

  @override
  String get pairingModalReplace => 'Ersetzen';

  @override
  String get pairingModalHiIMConnectedNow =>
      '👋 Hallo, ich bin jetzt verbunden.';

  @override
  String pairingModalConnectedWithName(Object name) {
    return 'Verbunden mit $name';
  }

  @override
  String get pairingModalThisCodeDoesnTFit =>
      'Dieser Code passt nicht. Scanne den QR-Code deines Gegenübers oder füge den vollständigen Code (beginnt mit npub1…) ein.';

  @override
  String get pairingModalMyCode => 'Mein Code';

  @override
  String get pairingModalScanPartner => 'Partner scannen';

  @override
  String get pairingModalLetYourPartnerScanThis =>
      'Lass diesen Code von deinem Partner scannen, um euren privaten Kanal zu öffnen.';

  @override
  String get pairingModalCopyCode => 'Code kopieren';

  @override
  String get pairingModalYourConnectionCodeHasBeen =>
      'Dein Verbindungscode wurde kopiert.';

  @override
  String get pairingModalEndToEndEncryptedNo =>
      'Ende-zu-Ende-verschlüsselt • ohne Konto';

  @override
  String get pairingModalHoldYourPartnerSQr =>
      'Partner-QR-Code im Rahmen halten';

  @override
  String get pairingModalPartnerSNameEG =>
      'Partner-Name (z.B. Mein Schatz, Anna)';

  @override
  String get pairingModalOrPasteNpubHexKey =>
      'Oder npub1... / Hex-Schlüssel einfügen';

  @override
  String get pairingModalPasteFromClipboard => 'Aus Zwischenablage einfügen';

  @override
  String get pairingModalConnectPair => 'Verbinden & Koppeln';

  @override
  String get partnerProfileDialogWoman => 'Frau';

  @override
  String get partnerProfileDialogMan => 'Mann';

  @override
  String get partnerProfileDialogNonBinary => 'Divers';

  @override
  String get partnerProfileDialogNotSpecified => 'Keine Angabe';

  @override
  String get partnerProfileDialogYourPartner => 'Dein Gegenüber';

  @override
  String get partnerProfileDialogThisLetsLessonsCallYour =>
      'Damit können Lektionen dein Gegenüber beim Namen nennen, etwa „Anna liegt auf dem Rücken“ statt „sie liegt“. Beides bleibt nur auf deinem Handy.';

  @override
  String get partnerProfileDialogSave => 'Speichern';

  @override
  String get partnerProfileDialogHowMayLessonsReferTo =>
      'Wie dürfen Lektionen dein Gegenüber nennen?';

  @override
  String get partnerProfileDialogWithNameAndGenderThe =>
      'Mit Name und Geschlecht sprechen die Texte euch persönlich an. Das bleibt auf deinem Handy.';

  @override
  String get partnerProfileDialogAdd => 'Ergänzen';

  @override
  String get distortionSpectatoring => 'Spectatoring / Selbstbeobachtung';

  @override
  String get distortionCatastrophizing => 'Katastrophisieren';

  @override
  String get distortionAllOrNothing => 'Alles-oder-Nichts-Denken';

  @override
  String get distortionMindReading => 'Gedankenlesen';

  @override
  String get distortionPerformancePressure => 'Leistungsdruck';

  @override
  String get distortionTunnelVision => 'Tunnelblick auf Körpersignale';

  @override
  String cbtJournalProtocolsSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gedankenprotokolle lokal gesichert',
      one: '1 Gedankenprotokoll lokal gesichert',
    );
    return '$_temp0';
  }

  @override
  String get selbstReiseEndTheJourney => 'Reise beenden?';

  @override
  String get selbstReiseTheGuidanceStopsThenYou =>
      'Die Begleitung hört dann auf. Du kannst jederzeit neu beginnen.';

  @override
  String get selbstReiseAVoiceGuidesYouThrough =>
      'Eine Stimme begleitet dich durch Ankommen, Atem und eine Reise über deinen Körper. Die meiste Zeit ist Stille, damit du ganz bei dir bist. Jede Reise wird neu zusammengestellt, und es gibt kein Ziel.';

  @override
  String get selbstReiseYouDecideYouCanPause =>
      'Du bestimmst. Pausieren, einen Schritt überspringen oder aufhören geht jederzeit über die Knöpfe unten. Es muss nichts passieren: Bei einer angenehmen, nicht sexuellen Berührung zu bleiben ist genauso richtig. Wird etwas unangenehm oder kommen schwierige Erinnerungen hoch, darfst du jederzeit aufhören.';

  @override
  String selbstReiseMMin(Object m) {
    return '$m Min.';
  }

  @override
  String get selbstReiseHowCloseWouldYouLike =>
      'Wie nah möchtest du dir heute kommen?';

  @override
  String get selbstReiseGentle => 'Sanft';

  @override
  String get selbstReiseFaceScalpEarsNeckArms =>
      'Gesicht, Kopfhaut, Ohren, Hals, Arme, Hände, Brust, Bauch, Beine und Füße, gern bekleidet.';

  @override
  String get selbstReiseSkin => 'Haut';

  @override
  String get selbstReisePlusBareSkinWithOil =>
      'Dazu nackte Haut mit Öl, Hüften und Innenschenkel.';

  @override
  String get selbstReisePlusPerineumAndGenitalsWith =>
      'Dazu Damm und Geschlecht, mit Wellen statt Ziel.';

  @override
  String get selbstReiseYourBody => 'Dein Körper';

  @override
  String get selbstReiseVulva => 'Vulva';

  @override
  String get selbstReisePenis => 'Penis';

  @override
  String get selbstReiseBeginTheJourney => 'Reise beginnen';

  @override
  String get selbstReiseThankYou => 'Danke dir';

  @override
  String get selbstReiseBodyJourney => 'Körperreise';

  @override
  String selbstReiseSilenceStillerestLeft(Object stilleRest) {
    return 'Stille · noch $stilleRest';
  }

  @override
  String get selbstReiseStayLyingDownAsLong =>
      'Bleib liegen, solange es sich gut anfühlt.';

  @override
  String get lustProfileCircling => 'Kreisen';

  @override
  String get lustProfileUpAndDown => 'Auf und ab';

  @override
  String get lustProfileSideToSide => 'Seitwärts';

  @override
  String get lustProfilePressAndHold => 'Drücken und halten';

  @override
  String get lustProfileFramingTwoFingersLeftAnd =>
      'Rahmen – zwei Finger links und rechts';

  @override
  String get lustProfileLightTapping => 'Leichtes Klopfen';

  @override
  String get lustProfileInsideAndOutsideAtOnce => 'Innen und außen zugleich';

  @override
  String get lustProfileOpenOiledHand => 'Offene, eingeölte Hand';

  @override
  String get lustProfileTwoHandedGliding => 'Zweihand-Gleiten';

  @override
  String get lustProfileTwisting => 'Drehen';

  @override
  String get lustProfileRingAtTheBase => 'Ring an der Wurzel';

  @override
  String get lustProfileCirclingTheFrenulum => 'Das Bändchen umkreisen';

  @override
  String get lustProfileIncludingTesticlesAndPerineum =>
      'Hoden und Damm einbeziehen';

  @override
  String get lustProfileWavesPausingJustBeforeClimax =>
      'Wellen – kurz vor dem Höhepunkt innehalten';

  @override
  String get lustProfileStartSlowlyAroundRatherThan =>
      'Langsam beginnen, rundherum statt direkt';

  @override
  String get lustProfileWhenItSGoodKeep =>
      'Wenn es gut ist: genau so weitermachen';

  @override
  String get lustProfileWithPlentyOfLubricant => 'Mit viel Gleitmittel';

  @override
  String get lustProfileLotsOfTimeNoGoal => 'Viel Zeit, ohne Ziel';

  @override
  String get lustProfileMyDesireProfileThisIs =>
      '💛 Mein Lust-Profil – das habe ich über mich entdeckt:\n';

  @override
  String get lustProfileWouldYouLikeToTry =>
      '\nMagst du es mit mir ausprobieren?';

  @override
  String get lustProfileYourDesireProfileIsOn =>
      'Dein Lust-Profil ist verschlüsselt unterwegs';

  @override
  String get lustProfileSendingDidnTWorkPlease =>
      'Senden hat nicht geklappt. Bitte gleich noch einmal.';

  @override
  String get lustProfileTextCopied => 'Text kopiert.';

  @override
  String get lustProfileWithVulva => 'Mit Vulva';

  @override
  String get lustProfileWithPenis => 'Mit Penis';

  @override
  String get lustProfileTickWhatYouEnjoyedWhile =>
      'Hake an, was dir beim Erkunden gefallen hat. Nur du entscheidest, ob und wann du es teilst – gesendet wird ausschließlich, was du hier auswählst.';

  @override
  String get lustProfileGeneral => 'Allgemein';

  @override
  String get lustProfilePersonalNote => 'Eigene Notiz';

  @override
  String get lustProfileForExampleAtTheBeginning =>
      'Zum Beispiel: Am Anfang mag ich große, langsame Kreise …';

  @override
  String get lustProfileSendToMyPartner => 'An mein Gegenüber senden';

  @override
  String get lustProfileConnectCoupleChannelAndSend =>
      'Paar-Kanal verbinden und senden';

  @override
  String get lustProfileJustCopyAsText => 'Nur als Text kopieren';

  @override
  String get lustProfileTipEvenNicerThanAny =>
      'Tipp: Noch schöner als jede Nachricht ist es, die Hand deines Gegenübers zu führen oder es dir zeigen zu lassen. Die Nachricht kann der Anstoß dafür sein.';

  @override
  String get yesNoMaybeMatchingAnswersEncrypted =>
      'Antworten werden verschlüsselt verglichen …';

  @override
  String yesNoMaybeCountAnswersMatched(Object count) {
    return 'Fertig: $count Antworten verglichen.';
  }

  @override
  String get yesNoMaybeReadMore => 'WEITERLESEN';

  @override
  String get yesNoMaybeYesMaybeNo => 'Ja, gern / Vielleicht / Lieber nicht';

  @override
  String get yesNoMaybeSyncWithPartner => 'Mit deinem Gegenüber vergleichen';

  @override
  String get yesNoMaybePairingRequired => 'Erst verbinden';

  @override
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
      Object answeredCount, Object totalItems) {
    return 'Fragenkatalog ($answeredCount von $totalItems)';
  }

  @override
  String yesNoMaybeMatchesMatchcount(Object matchCount) {
    return 'Gemeinsam ($matchCount)';
  }

  @override
  String get yesNoMaybeMeineAntworten => 'Meine Antworten';

  @override
  String get yesNoMaybeGemeinsam => 'Gemeinsam';

  @override
  String get yesNoMaybeDigitalSafeSpace => 'Deine Antworten, dein Tempo';

  @override
  String get yesNoMaybeFindOutWhatExcitesYou =>
      'Hier darfst du in Ruhe spüren, was dir gefällt, was vielleicht und was lieber nicht. Du musst nichts beantworten. Unklar, was gemeint ist? Tippe auf das i. Wenn ihr verbunden seid, wird nur sichtbar, wo ihr beide mindestens „Vielleicht“ gesagt habt. Ein „Lieber nicht“ wird deinem Gegenüber nicht angezeigt.';

  @override
  String get yesNoMaybeYes => 'Ja, gern';

  @override
  String get yesNoMaybeMaybe => 'Vielleicht';

  @override
  String get yesNoMaybeNo => 'Lieber nicht';

  @override
  String yesNoMaybeAllEintraegelength(Object eintraegeLength) {
    return 'Alle ($eintraegeLength)';
  }

  @override
  String get yesNoMaybeOpen => 'Offen';

  @override
  String yesNoMaybeYesYescount(Object yesCount) {
    return 'Ja, gern ($yesCount)';
  }

  @override
  String yesNoMaybeMaybeMaybecount(Object maybeCount) {
    return 'Vielleicht ($maybeCount)';
  }

  @override
  String yesNoMaybeNoNocount(Object noCount) {
    return 'Lieber nicht ($noCount)';
  }

  @override
  String get yesNoMaybePairingRequired2 => 'Erst verbinden';

  @override
  String get yesNoMaybeConnectWithYourPartnerIn =>
      'Wenn ihr im Paar-Kanal verbunden seid, könnt ihr eure Antworten verschlüsselt vergleichen. Sichtbar wird nur das Gemeinsame. Allein ausfüllen geht auch.';

  @override
  String get yesNoMaybePairViaQrCodeNow => 'Per QR-Code verbinden';

  @override
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName) {
    return 'Gemeinsam mit $partnerName';
  }

  @override
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
      Object yesMatchesLength, Object curiosityMatchesLength) {
    return 'Ja bei euch beiden: $yesMatchesLength · Gemeinsam neugierig: $curiosityMatchesLength';
  }

  @override
  String get yesNoMaybeNoRejectionAllLimitsWere =>
      'Hier steht nur, was ihr beide gesagt habt. Alles andere wird deinem Gegenüber nicht angezeigt. Ein „Lieber nicht“ ist eine vollwertige Antwort.';

  @override
  String get yesNoMaybePerfectMatchBothSaidYes => 'Ihr beide: Ja';

  @override
  String get yesNoMaybeSharedCuriosityOpenToExploring =>
      'Gemeinsame Neugier, ein Vielleicht reicht';

  @override
  String get yesNoMaybeNoMatchesYet => 'Hier ist es noch still';

  @override
  String get yesNoMaybeBothKeepVotingInThe =>
      'Das heißt nicht, dass etwas fehlt. Vielleicht habt ihr noch nicht alles beantwortet, oder eure Antworten liegen einfach an verschiedenen Stellen. Beides ist normal. Ihr müsst nichts tun.';

  @override
  String get yesNoMaybeYouBothYes => 'Ihr beide: Ja';

  @override
  String get yesNoMaybeCuriousTogether => 'Gemeinsam neugierig';

  @override
  String get yesNoMaybeCourse => 'Mehr dazu';

  @override
  String get cbtNewEntryPleaseChooseAtLeastOne =>
      'Bitte wähle mindestens ein Denkmuster / eine Verzerrung aus.';

  @override
  String get cbtNewEntryNewThoughtRecord => 'Neues Gedankenprotokoll';

  @override
  String get cbtNewEntryEditEntry => 'Eintrag bearbeiten';

  @override
  String get cbtNewEntryCognitiveRestructuringUnmaskIrrationalAlarm =>
      'Kognitive Umstrukturierung: Enttarne irrationale Alarmgedanken und formuliere eine biologisch realistische Antwort.';

  @override
  String get cbtNewEntryTriggerSituation => 'Auslöser / Situation';

  @override
  String get cbtNewEntryWhenOrDuringWhatDid =>
      'Wann oder wobei trat die Anspannung auf? (z.B. „Als wir ins Bett gingen“, „Als sie mich berührte“)';

  @override
  String get cbtNewEntryDescribeTheSpecificSituation =>
      'Konkrete Situation beschreiben...';

  @override
  String get cbtNewEntryPleaseDescribeASituation =>
      'Bitte gib eine Situation an.';

  @override
  String get cbtNewEntryAutomaticThoughtMentalMovie =>
      'Automatischer Gedanke (Kopfkino)';

  @override
  String get cbtNewEntryWhatShotThroughYourHead =>
      'Was schoss dir sofort durch den Kopf? Was sagte der innere Kritiker? (z.B. „Ich werde gleich wieder versagen“)';

  @override
  String get cbtNewEntryNoteTheUnfilteredThought =>
      'Den ungefilterten Gedanken notieren...';

  @override
  String get cbtNewEntryPleaseNoteYourThought =>
      'Bitte notiere deinen Gedanken.';

  @override
  String get cbtNewEntryExposeTheCognitiveDistortion =>
      'Kognitive Verzerrung entlarven';

  @override
  String get cbtNewEntryWhichThinkingTrapIsThis =>
      'Welche Denkfalle liegt hier vor? (Wähle mindestens eine aus)';

  @override
  String get cbtNewEntryReappraisalRealityCheck =>
      'Neubewertung / Realitätscheck';

  @override
  String get cbtNewEntryWhatSTheRealisticView =>
      'Was ist die biologische Wahrheit? Was würde ein empathischer Coach oder Freund dazu sagen?';

  @override
  String get cbtNewEntryEGMyBodyIs =>
      'z.B.: „Mein Körper reagiert nur auf Adrenalin. Ich muss heute niemanden beeindrucken. Wenn ich den Fokus auf Hautkontakt und Atmung lenke, fällt der Druck ab.“';

  @override
  String get cbtNewEntryPleasePhraseAReappraisal =>
      'Bitte formuliere eine Neubewertung.';

  @override
  String get cbtNewEntrySaving => 'Wird gespeichert...';

  @override
  String get cbtNewEntrySaveThoughtRecord => 'Gedankenprotokoll speichern';

  @override
  String get cbtJournalDeleteEntry => 'Eintrag löschen?';

  @override
  String get cbtJournalDoYouReallyWantTo =>
      'Möchtest du dieses Gedankenprotokoll wirklich von deinem Gerät entfernen?';

  @override
  String get cbtJournalDelete => 'Löschen';

  @override
  String get cbtJournalNewEntry => 'Neuer Eintrag';

  @override
  String cbtJournalMyRecordsEntrieslength(Object entriesLength) {
    return 'Meine Protokolle ($entriesLength)';
  }

  @override
  String get cbtJournalBeliefs => 'Glaubenssätze';

  @override
  String get cbtJournalNoThoughtRecordsYet => 'Noch keine Gedankenprotokolle';

  @override
  String get cbtJournalWhenYourHeadBlocksBefore =>
      'Wenn der Kopf vor oder bei der Intimität blockiert, hilft es ungemein, den automatischen Gedanken aufzuschreiben und die kognitive Verzerrung schwarz auf weiß zu entlarven.';

  @override
  String get cbtJournalNewRecord => 'Neues Protokoll';

  @override
  String get cbtJournalStartWithABelief => 'Mit einem Glaubenssatz starten';

  @override
  String get cbtJournalCognitiveRestructuring => 'Kognitive Umstrukturierung';

  @override
  String get cbtJournalEdit => 'Bearbeiten';

  @override
  String get cbtJournalAutomaticThoughtAlarm => 'AUTOMATISCHER GEDANKE (ALARM)';

  @override
  String cbtJournalAutomaticthought(Object automaticThought) {
    return '„$automaticThought“';
  }

  @override
  String get cbtJournalReappraisalRealityCheck =>
      'NEUBEWERTUNG & REALITÄTSCHECK';

  @override
  String beliefLibraryViewRealitycheckPracticalShiftPracticalshift(
      Object realityCheck, Object practicalShift) {
    return '$realityCheck\n\nPraktischer Shift: $practicalShift';
  }

  @override
  String get beliefLibraryViewBeliefToolkit => 'Glaubenssätze-Baukasten';

  @override
  String get beliefLibraryViewTheMostCommonMentalTraps =>
      'Die häufigsten mentalen Fallen bei Leistungsangst – und die biologische Wahrheit dahinter. Tippe auf eine Karte, um sie direkt in dein eigenes Journal zu übernehmen.';

  @override
  String get beliefLibraryViewForHer => 'Für Menschen mit Vulva';

  @override
  String get beliefLibraryViewForHim => 'Für Menschen mit Penis';

  @override
  String get beliefLibraryViewTypicalMisbeliefMentalMovie =>
      'TYPISCHER IRRGLAUBE (KOPFKINO)';

  @override
  String beliefLibraryViewIrrationalthought(Object irrationalThought) {
    return '„$irrationalThought“';
  }

  @override
  String get beliefLibraryViewRealityCheck => 'BIOLOGISCHER REALITÄTSCHECK';

  @override
  String get beliefLibraryViewTakeIntoMyJournal =>
      'In eigenes Journal übernehmen';

  @override
  String get kegelTimerViewBreatheInWiden => 'EINATMEN & WEIT WERDEN';

  @override
  String get kegelTimerViewBreatheDeepIntoTheBelly =>
      'Tief in den Bauch atmen. Den Beckenboden sanft nach unten nachgeben lassen – kein Pressen.';

  @override
  String get kegelTimerViewStaySoft => 'WEICH BLEIBEN';

  @override
  String get kegelTimerViewBreatheOutSlowlyAndStay =>
      'Langsam ausatmen und weit bleiben, wie eine Hängematte, die locker durchhängt.';

  @override
  String get kegelTimerViewNotice => 'NACHSPÜREN';

  @override
  String get kegelTimerViewKeepBreathingNormallyAndFeel =>
      'Normal weiteratmen und spüren, wie warm und ruhig das Becken ist.';

  @override
  String get kegelTimerViewTighten => 'ANSPANNEN';

  @override
  String get kegelTimerViewGentlyDrawTheAreaBetween =>
      'Den Bereich zwischen Schambein und Steißbein sanft nach innen und oben ziehen. Po und Bauch bleiben locker.';

  @override
  String get kegelTimerViewHoldTheTensionAtAbout =>
      'Die Spannung halten, etwa mit halber Kraft. Weiter ruhig atmen.';

  @override
  String get kegelTimerViewLetGoCompletely => 'GANZ LOSLASSEN';

  @override
  String get kegelTimerViewRelaxCompletelyLettingGoLasts =>
      'Vollständig entspannen. Das Loslassen dauert mindestens so lange wie das Halten.';

  @override
  String get kegelTimerViewQuickSqueeze => 'KURZ AN';

  @override
  String get kegelTimerViewAQuickShortSqueezeLike =>
      'Ein schnelles, kurzes Anspannen – wie ein Zwinkern mit dem Beckenboden.';

  @override
  String get kegelTimerViewRelease => 'LOS';

  @override
  String get kegelTimerViewLetGoCompletelyRightAway =>
      'Sofort wieder ganz loslassen.';

  @override
  String get kegelTimerViewBreatheInSoften => 'EINATMEN & WEICH';

  @override
  String get kegelTimerViewBreatheDeepIntoTheBelly2 =>
      'Tief in den Bauch atmen. Damm und Po bewusst weich werden lassen.';

  @override
  String get kegelTimerViewLongExhale => 'LANG AUSATMEN';

  @override
  String get kegelTimerViewBreatheOutLongAndAudibly =>
      'Lang und hörbar ausatmen, der Beckenboden bleibt weit. So übst du, bei Erregung locker zu bleiben.';

  @override
  String get kegelTimerViewKeepBreathingCalmlyAndFeel =>
      'Ruhig weiteratmen und die Wärme im Becken spüren.';

  @override
  String get kegelTimerViewDone => 'Geschafft';

  @override
  String kegelTimerViewYouPractisedTotalroundsRoundsA(Object totalRounds) {
    return 'Du hast $totalRounds Runden geübt. Regelmäßig ein paar Minuten bringen mehr als selten lange – bis morgen!';
  }

  @override
  String get kegelTimerViewFinish => 'Fertig';

  @override
  String get kegelTimerViewLetGo => 'Loslassen';

  @override
  String get kegelTimerViewWiden => 'weit werden';

  @override
  String get kegelTimerViewStrengthen => 'Kräftigen';

  @override
  String get kegelTimerViewHoldRelease => 'halten & lösen';

  @override
  String get kegelTimerViewQuickPulses => 'Schnelle Impulse';

  @override
  String get kegelTimerViewQuickOnQuickOff => 'kurz an, kurz los';

  @override
  String get kegelTimerViewWaves => 'Wellen';

  @override
  String get kegelTimerViewSoftWhenAroused => 'weich bei Erregung';

  @override
  String get kegelTimerViewRounds => 'Runden';

  @override
  String kegelTimerViewMinutesMin(Object minutes) {
    return '≈ $minutes Min.';
  }

  @override
  String get kegelTimerViewLevel => 'Stufe';

  @override
  String get kegelTimerViewVoiceCues => 'Ansage';

  @override
  String get kegelTimerViewAVoiceGuidesYou => 'Stimme führt dich durch';

  @override
  String get kegelTimerViewVibrationOnly => 'nur Vibration';

  @override
  String kegelTimerViewRoundCurrentroundOfTotalrounds(
      Object currentRound, Object totalRounds) {
    return 'Runde $currentRound von $totalRounds';
  }

  @override
  String kegelTimerViewPhaseCurrentphaseindexPhaseslength(
      Object currentPhaseIndex, Object phasesLength) {
    return 'Phase $currentPhaseIndex/$phasesLength';
  }

  @override
  String get kegelTimerViewGuidePracticePlan => 'Anleitung & Übungsplan';

  @override
  String get kegelTimerViewFindingTheMuscleWhichExercise =>
      'Muskel finden, welche Übung wofür, typische Fehler, Plan für 6 Wochen';

  @override
  String get kegelGuideSheetPelvicFloorGuide => 'Beckenboden-Anleitung';

  @override
  String get kegelGuideSheetFindingTheMuscleExercisesPlan =>
      'Muskel finden, Übungen, Plan';

  @override
  String get kegelGuideSheetFindingTheMuscle => '1. Den Muskel finden';

  @override
  String get kegelGuideSheetBasics => 'GRUNDLAGEN';

  @override
  String get kegelGuideSheetThePelvicFloorStretchesLike =>
      'Der Beckenboden spannt sich wie eine Hängematte zwischen Schambein und Steißbein – bei allen Menschen. Er kann zwei Dinge: heben und halten, und weit werden und loslassen. Beides gehört zum Training.';

  @override
  String get kegelGuideSheetTightenAndLift => 'Anspannen und heben';

  @override
  String get kegelGuideSheetImagineHoldingBackWindAnd =>
      'Stell dir vor, du hältst einen Wind zurück und stoppst gleichzeitig den Urinstrahl – nur in der Vorstellung.\n• Mit Vulva: Scheideneingang und Damm ziehen sich sanft nach innen und oben.\n• Mit Penis: Die Peniswurzel hebt sich ein kleines Stück, die Hoden ziehen leicht nach oben.';

  @override
  String get kegelGuideSheetLetGoAndWiden => 'Loslassen und weit werden';

  @override
  String get kegelGuideSheetBreatheDeepIntoTheBelly =>
      'Atme tief in den Bauch. Während sich der Bauch wölbt, lass den Beckenboden sanft nach unten nachgeben – wie beim Beginn des Wasserlassens, aber ohne zu pressen. Der Bereich zwischen Schambein und Steißbein wird weich und warm.';

  @override
  String get kegelGuideSheetButtocksThighsAndBellyStay =>
      'Po, Oberschenkel und Bauch bleiben locker. Eine Hand auf dem Po verrät, ob er mitarbeitet.';

  @override
  String get kegelGuideSheetWhichExerciseForWhat => '2. Welche Übung wofür?';

  @override
  String get kegelGuideSheetExercises => 'ÜBUNGEN';

  @override
  String get kegelGuideSheetForTensionPainOnPenetration =>
      'bei Anspannung, Schmerzen beim Eindringen, frühem Samenerguss';

  @override
  String get kegelGuideSheetForEveryoneWhosePelvicFloor =>
      'Für alle, deren Beckenboden eher zu viel festhält. Das ist bei Stress, viel Sitzen und Leistungsdruck häufig. Fang hier an, wenn du unsicher bist.';

  @override
  String get kegelGuideSheetForSupportControlAndStability =>
      'für Halt, Kontrolle und Stabilität';

  @override
  String get kegelGuideSheetStrengthensTheMusclesForExample =>
      'Stärkt die Muskulatur, etwa nach einer Geburt, bei leichter Blasenschwäche oder für mehr Kontrolle. Mit halber Kraft üben, das Loslassen danach ist genauso wichtig wie das Halten.';

  @override
  String get kegelGuideSheetForResponsiveness => 'für Reaktionsfähigkeit';

  @override
  String get kegelGuideSheetAShortSqueezeAndImmediate =>
      'Kurzes An und sofortiges Los trainiert die schnellen Muskelfasern – zum Beispiel für den Moment beim Husten oder Niesen.';

  @override
  String get kegelGuideSheetStayingLooseWhenItGets =>
      'locker bleiben, wenn es spannend wird';

  @override
  String get kegelGuideSheetALongAudibleExhaleWith =>
      'Langes, hörbares Ausatmen mit weichem Damm und Po. Genau das hilft beim Wellen-Surfen aus den Kursen 8 und 9, die Erregung hoch zu halten, ohne dass sie überläuft.';

  @override
  String get kegelGuideSheetCommonMistakes => '3. Typische Fehler';

  @override
  String get kegelGuideSheetCareful => 'ACHTUNG';

  @override
  String get kegelGuideSheetSqueezingTheButtocks => 'Den Po zusammenkneifen';

  @override
  String get kegelGuideSheetTheBigGlutealMuscleLikes =>
      'Der große Gesäßmuskel mogelt sich gern hinein. Der Po bleibt weich.';

  @override
  String get kegelGuideSheetHoldingYourBreath => 'Die Luft anhalten';

  @override
  String get kegelGuideSheetKeepBreathingCalmlyWhileHolding =>
      'Atme beim Halten ruhig weiter. Angehaltener Atem erhöht den Druck im Bauch.';

  @override
  String get kegelGuideSheetPushingInsteadOfLettingGo =>
      'Pressen statt loslassen';

  @override
  String get kegelGuideSheetWhenLettingGoNothingIs =>
      'Beim Loslassen wird nichts nach unten gedrückt. Es ist ein Nachgeben, kein Schieben.';

  @override
  String get kegelGuideSheetPractisingWhileActuallyUrinating =>
      'Beim echten Wasserlassen üben';

  @override
  String get kegelGuideSheetRegularlyStoppingTheFlowOf =>
      'Den Urinstrahl regelmäßig zu stoppen kann die Blasenentleerung stören. Nur in der Vorstellung üben.';

  @override
  String get kegelGuideSheetBetterShortAndRegular =>
      'Lieber kurz und regelmäßig';

  @override
  String get kegelGuideSheetAFewMinutesOnMost =>
      'Ein paar Minuten an den meisten Tagen bringen mehr als selten eine lange Einheit.';

  @override
  String get kegelGuideSheetAPlanForSixWeeks => '4. Ein Plan für sechs Wochen';

  @override
  String get kegelGuideSheetPlan => 'PLAN';

  @override
  String get kegelGuideSheetWeek => 'Woche 1–2';

  @override
  String get kegelGuideSheetLetGoDailyRoundsEasy =>
      'Täglich Loslassen, 5 Runden, Stufe leicht. Ziel: das Weitwerden sicher spüren.';

  @override
  String get kegelGuideSheetWeek2 => 'Woche 3–4';

  @override
  String get kegelGuideSheetLetGoRoundsThenStrengthen =>
      'Loslassen 5 Runden, danach Kräftigen 5 Runden, Stufe leicht. An zwei Tagen Wellen.';

  @override
  String get kegelGuideSheetWeek3 => 'Woche 5–6';

  @override
  String get kegelGuideSheetRoundsOfYourMainExercise =>
      '10 Runden in deiner Hauptübung, Stufe mittel. Dazu ein paar Schnelle Impulse.';

  @override
  String get kegelGuideSheetAfterThatKeepTwoOr =>
      'Danach: Behalte zwei, drei kurze Einheiten pro Woche bei. Und nutze das Loslassen bewusst in intimen Momenten – tief in den Bauch atmen, den Beckenboden sinken lassen.';

  @override
  String get kegelGuideSheetWhenToSeeAPhysiotherapist =>
      '5. Wann zur Physiotherapie?';

  @override
  String get kegelGuideSheetHealth => 'GESUNDHEIT';

  @override
  String get kegelGuideSheetSpecialisedPelvicFloorPhysiotherapyCan =>
      'Eine spezialisierte Beckenboden-Physiotherapie kann genau untersuchen, ob dein Beckenboden eher zu schwach oder zu fest ist, und dich gezielt anleiten. Lass dich beraten bei:\n• Schmerzen im Becken, beim Sex oder beim Training\n• Blasen- oder Darmschwäche\n• Beschwerden nach einer Geburt oder einer Operation im Becken\n• dem Gefühl, den Muskel gar nicht ansteuern zu können';

  @override
  String get kegelGuideSheetBackToTraining => 'Zurück zum Training';

  @override
  String get dailyCheckinCardVeryCalm => 'Sehr ruhig';

  @override
  String get dailyCheckinCardMild => 'Leicht';

  @override
  String get dailyCheckinCardModerate => 'Mäßig';

  @override
  String get dailyCheckinCardHigh => 'Hoch';

  @override
  String get dailyCheckinCardExtremeStress => 'Extremer Stress';

  @override
  String get dailyCheckinCardClearHead => 'Frei im Kopf';

  @override
  String get dailyCheckinCardHardlyAnyPressure => 'Kaum Druck';

  @override
  String get dailyCheckinCardSomeRestlessness => 'Unruhe da';

  @override
  String get dailyCheckinCardNoticeablyHigh => 'Spürbar hoch';

  @override
  String get dailyCheckinCardStrongPressure => 'Starker Druck';

  @override
  String get dailyCheckinCardSecondDailyCheckIn => '30-Sekunden Tages-Check-in';

  @override
  String get dailyCheckinCardDone => 'Erledigt';

  @override
  String dailyCheckinCardStressStresslevelPressurePressurelevel(
      Object stressLevel, Object pressureLevel) {
    return 'Stress: $stressLevel • Druck: $pressureLevel';
  }

  @override
  String get dailyCheckinCardHowDoStressPerformancePressure =>
      'Wie geht es dir heute?';

  @override
  String get dailyCheckinCardEverydayStressTodayJobAppointments =>
      '1. Alltagsstress heute (Job, Termine, Schlaf)';

  @override
  String get dailyCheckinCardInnerPerformancePressureRacingThoughts =>
      '2. Wie viel Druck spürst du innerlich?';

  @override
  String get dailyCheckinCardWhatDidYouGoodToday =>
      '3. Was hat dir heute gut getan?';

  @override
  String get dailyCheckinCardSaveDailyCheckIn => 'Tages-Check-in speichern';

  @override
  String get dailyCheckinCardUpdateValues => 'Werte aktualisieren';

  @override
  String get dailyCheckinCardCoachingInsightYourEverydayStress =>
      'Dein Alltagsstress ist heute hoch. Das ist okay: Stress und Erschöpfung bremsen die Lust oft ganz von selbst. Das ist normal und kein Fehler von dir.';

  @override
  String get dailyCheckinCardCoachingInsightWhenEverydayStress =>
      'Wenn der Alltag ruhiger ist, fällt Entspannen oft leichter. Wenn du magst, spür heute einfach in deinen Körper, ganz ohne Ziel.';

  @override
  String get onboardingGuest => 'Gast';

  @override
  String get onboardingProfileUpdated => 'Profil erfolgreich aktualisiert.';

  @override
  String get onboardingRestoreBackup => 'Sicherung wiederherstellen';

  @override
  String get onboardingRestoreYourProfileLessonsCouple =>
      'Stelle dein Profil, Lektionen & Nostr-Kanal wieder her';

  @override
  String get onboardingBackupFoundOnThisDevice =>
      'Sicherung auf dem Gerät gefunden!';

  @override
  String onboardingProfileProfilename(Object profileName) {
    return 'Profil: $profileName';
  }

  @override
  String get onboardingRestoreAutomaticBackupNow =>
      'Automatische Sicherung jetzt einspielen';

  @override
  String get onboardingReadyInClipboard => 'IN ZWISCHENABLAGE BEREIT';

  @override
  String onboardingBackupForProfilename(Object profileName) {
    return 'Sicherung für: „$profileName“';
  }

  @override
  String get onboardingRestoreFromClipboard => 'Aus Zwischenablage einspielen';

  @override
  String get onboardingPasteBackupCodeJsonManually =>
      'Backup-Code / JSON manuell einfügen:';

  @override
  String get onboardingPasteJsonTextHereE =>
      'Hier den Text der Sicherung einfügen (beginnt mit \"app\": \"VelvetPulse\")';

  @override
  String get onboardingPleasePasteTheBackupJson =>
      'Bitte füge zuerst den Backup-JSON-Text ein.';

  @override
  String get onboardingApplyBackupNow => 'Sicherung jetzt anwenden';

  @override
  String get onboardingTheBackupCouldNotBe =>
      'Die Sicherung konnte nicht eingespielt werden.';

  @override
  String get onboardingUser => 'Nutzer';

  @override
  String onboardingBackupForNameRestored(Object name) {
    return 'Sicherung für \"$name\" erfolgreich eingespielt!';
  }

  @override
  String get onboardingProfilePersonalisation => 'Profil & Personalisierung';

  @override
  String get onboardingWelcomeToVelvetpulse => 'Willkommen bei VelvetPulse';

  @override
  String get onboardingYourPrivateCoachingProgrammeFor =>
      'Ein privater Begleiter für Ruhe im Körper, Beckenboden und Nähe.';

  @override
  String get onboardingPrivateProfileJournalProgressStay =>
      'Privat: Profil, Tagebuch & Fortschritt bleiben auf deinem Handy. Ins Internet gehen nur der verschlüsselte Paar-Kanal, das Laden von Aufnahmen und die Suche nach Updates (GitHub).';

  @override
  String get onboardingAlreadyUsingVelvetpulse => 'Bereits VelvetPulse-Nutzer?';

  @override
  String get onboardingLoadABackupFromFile =>
      'Sicherung aus Datei oder Zwischenablage laden';

  @override
  String get onboardingRestore => 'Wiederherstellen';

  @override
  String get onboardingWhatShouldWeCallYou =>
      '1. Wie dürfen wir dich ansprechen?';

  @override
  String get onboardingYourFirstNameOrA => 'Dein Vorname oder Pseudonym';

  @override
  String get onboardingYourGender => '2. Dein Geschlecht (freiwillig)';

  @override
  String get onboardingAdjustsCourseRecommendationsPelvicFloor =>
      'Wir nutzen das nur, um dir eine passende Stimme und einen Körper-Vorschlag zu machen und um Lektionen verständlich zu halten, wenn von „sie“ oder „er“ die Rede ist. Du kannst es jederzeit ändern, und es bleibt auf deinem Handy. „Keine Angabe“ ist völlig in Ordnung.';

  @override
  String get onboardingMale => 'Mann';

  @override
  String get onboardingFemale => 'Frau';

  @override
  String get onboardingGenderWeitergehen =>
      'Du kannst auch einfach weitergehen.';

  @override
  String get onboardingKoerperTitel => 'Körperbezogene Übungen (freiwillig)';

  @override
  String get onboardingKoerperText =>
      'Manche Übungen und Körperreisen sprechen den Körper ganz konkret an. Damit wir dir nichts vorschlagen, das nicht zu dir passt: Welche Beschreibung stimmt am ehesten? Das ist unabhängig von deinem Geschlecht. Du kannst überspringen, dann fragen wir erst, wenn eine Übung es braucht.';

  @override
  String get onboardingKoerperVulva => 'Vulva';

  @override
  String get onboardingKoerperPenis => 'Penis';

  @override
  String get onboardingKoerperBeides => 'Beides oder anders';

  @override
  String get onboardingKoerperSpaeter => 'Später fragen';

  @override
  String onboardingYourAgeSelectedageYears(Object selectedAge) {
    return '3. Dein Alter: $selectedAge Jahre';
  }

  @override
  String get onboardingYourRelationshipStatus => '4. Dein Beziehungsstatus';

  @override
  String get onboardingInARelationshipMarried =>
      'In fester Beziehung / Verheiratet';

  @override
  String get onboardingDatingGettingToKnowSomeone => 'Dating / Kennenlernphase';

  @override
  String get onboardingSingle => 'Single';

  @override
  String get onboardingItSComplicated => 'Es ist kompliziert';

  @override
  String get onboardingWhatSYourBiggestPriority =>
      '5. Was wünschst du dir im Moment am meisten?';

  @override
  String get onboardingStopPerformancePressureRacingThoughts =>
      'Weniger Druck, ein ruhigerer Kopf';

  @override
  String get onboardingBreakThoughtLoopsStopSpectatoring =>
      'Aus dem Kopf zurück ins Spüren, ohne dich selbst zu beobachten.';

  @override
  String get onboardingPelvicFloorRelaxationBodyAwareness =>
      'Beckenboden entspannen & den Körper spüren';

  @override
  String get onboardingReleaseTensionPractiseReverseKegels =>
      'Anspannung loslassen, den Beckenboden weich werden lassen, zur Ruhe kommen.';

  @override
  String get onboardingCoupleIntimacyPressureFreeSex =>
      'Nähe zu zweit, ohne Druck';

  @override
  String get onboardingSensateFocusTogetherCalmingEach =>
      'Berührung ohne Ziel, gemeinsam zur Ruhe kommen, sich nahe sein dürfen.';

  @override
  String get onboardingDesireSelfAcceptanceBodyAwareness =>
      'Lust, dich annehmen & deinen Körper spüren';

  @override
  String get onboardingUnderstandResponsiveDesireEaseOrgasm =>
      'Verstehen, wie Lust bei dir entsteht, und den Druck herausnehmen.';

  @override
  String get onboardingSaveChanges => 'Änderungen speichern';

  @override
  String get onboardingPersonaliseProgrammeNow => 'Fertig, los geht\'s';

  @override
  String get onboardingSkipGoStraightToThe => 'Später, direkt zur App';

  @override
  String onboardingVersionData(Object data) {
    return 'Version $data';
  }

  @override
  String get onboardingCheckForUpdates => 'Nach Updates suchen';

  @override
  String get onboardingReceiveBetaVersions => 'Beta-Versionen erhalten';

  @override
  String get onboardingYouGetNewFeaturesEarlier =>
      'Du bekommst neue Funktionen früher, dafür vielleicht mit kleinen Fehlern.';

  @override
  String get onboardingOnlyTestedVersionsWhenSwitching =>
      'Nur geprüfte Versionen. Beim Zurückwechseln von Beta bleibt deine Version, bis eine neuere stabile erscheint.';

  @override
  String get onboardingDiscretion => 'Diskretion';

  @override
  String get onboardingLockWithFingerprint => 'Mit Fingerabdruck sperren';

  @override
  String get onboardingOnOpeningAndAfterOne =>
      'Beim Öffnen und nach einer Minute im Hintergrund. Inhalte sind in der App-Übersicht verborgen, Screenshots gesperrt.';

  @override
  String get onboardingNoScreenLockIsSet =>
      'Auf diesem Gerät ist keine Displaysperre eingerichtet.';

  @override
  String get onboardingTheAppIsNowCalled =>
      'Die App heißt jetzt „Pulse“. Der Startbildschirm braucht dafür ein paar Sekunden.';

  @override
  String get onboardingTheAppIsCalledVelvetpulse =>
      'Die App heißt wieder „VelvetPulse“.';

  @override
  String get onboardingDiscreetAppIcon => 'Unauffälliges App-Symbol';

  @override
  String get onboardingShowsPulseWithANeutral =>
      'Zeigt „Pulse“ mit neutralem Symbol auf dem Startbildschirm.';

  @override
  String get onboardingCallYourPartnerByName =>
      'Gegenüber in Lektionen beim Namen nennen';

  @override
  String get onboardingForExampleAnnaLiesOn =>
      'Zum Beispiel „Anna liegt auf dem Rücken“ statt „sie liegt“. Aus, wenn öfter jemand mitliest.';

  @override
  String get onboardingAndroidHasnTAllowedNotifications =>
      'Android hat Mitteilungen für die App nicht erlaubt. Das lässt sich in den Android-Einstellungen ändern.';

  @override
  String get onboardingNotifyAboutNewMessages =>
      'Hinweis bei neuen Nachrichten';

  @override
  String get onboardingEvenWhenTheAppIs =>
      'Auch wenn die App geschlossen ist: nur „Neue Nachricht“, ohne Inhalt und Namen. Bei geschlossener App kann es bis zu 15 Minuten dauern.';

  @override
  String get onboardingPrivacyUpdateSafety => 'Datenschutz & Update-Sicherheit';

  @override
  String get onboardingEverythingStaysLocalOnYour =>
      'Alles bleibt lokal auf deinem Gerät und übersteht Updates. Die Paar-Verbindung liegt verschlüsselt im Android-Schlüsselspeicher und geht nur mit Passwort in eine Sicherung.';

  @override
  String get onboardingExportBackup => 'Backup exportieren';

  @override
  String get backupDialogsWhatShouldGoIntoThe => 'Was soll in die Sicherung?';

  @override
  String get backupDialogsOnlyYourDataProfileProgress =>
      'Nur deine Daten: Profil, Fortschritt, Reflexionen, Tagebuch, Wünsche. Reicht für dieses Handy.\n\nMit Passwort: zusätzlich die Verbindung im Paar-Kanal, verschlüsselt. Das brauchst du für einen Umzug auf ein anderes Handy.';

  @override
  String get backupDialogsDataOnly => 'Nur Daten';

  @override
  String get backupDialogsWithPassword => 'Mit Passwort';

  @override
  String get backupDialogsBackupCopied => 'Sicherung kopiert';

  @override
  String get backupDialogsOk => 'OK';

  @override
  String get backupDialogsOlderBackup => 'Ältere Sicherung';

  @override
  String get backupDialogsThisBackupComesFromAn =>
      'Diese Sicherung stammt aus einer älteren Version und enthält deinen Verbindungsschlüssel unverschlüsselt. Sie wird trotzdem eingespielt.\n\nLösche die alte Sicherung danach dort, wo du sie aufbewahrt hast, und erstelle bei Bedarf eine neue mit Passwort.';

  @override
  String get backupDialogsRestore => 'Einspielen';

  @override
  String get backupDialogsBackupPassword => 'Passwort der Sicherung';

  @override
  String get backupDialogsThisAlsoBringsBackThe =>
      'Damit kommt auch die Verbindung im Paar-Kanal zurück.';

  @override
  String get backupDialogsPassword => 'Passwort';

  @override
  String get backupDialogsWithoutKeys => 'Ohne Schlüssel';

  @override
  String get backupDialogsPasswordForTheBackup => 'Passwort für die Sicherung';

  @override
  String get backupDialogsPasswordAtLeastCharacters =>
      'Passwort (mindestens 8 Zeichen)';

  @override
  String get backupDialogsRepeatPassword => 'Passwort wiederholen';

  @override
  String get backupDialogsPleaseUseAtLeastCharacters =>
      'Bitte mindestens 8 Zeichen.';

  @override
  String get backupDialogsThePasswordsDonTMatch =>
      'Die Passwörter sind verschieden.';

  @override
  String get backupDialogsEncrypt => 'Verschlüsseln';

  @override
  String get backupDialogsOneMoment => 'Einen Moment …';

  @override
  String get backupDialogsBackupCopiedText =>
      'Die Sicherung liegt in der Zwischenablage. Füge sie in eine Notiz oder ein privates Dokument ein.';

  @override
  String get backupDialogsPasswordCannotBeReset =>
      '\n\nOhne dein Passwort lässt sich die Verbindung nicht wiederherstellen. Auch wir können es nicht zurücksetzen.';

  @override
  String get checkinActionBreathed => 'Ein paar Mal tief durchgeatmet';

  @override
  String get checkinActionPelvicFloor =>
      'Den Beckenboden bewusst weich gelassen';

  @override
  String get checkinActionPhoneAway => 'Das Handy abends weggelegt';

  @override
  String get checkinActionWalk => 'Spaziergang an frischer Luft gemacht';

  @override
  String get checkinActionSkinContact => 'Hautkontakt bewusst gespürt';

  @override
  String get checkinActionOpenWord =>
      'Ein offenes Wort mit meinem Gegenüber gesprochen';

  @override
  String get dailySimmeringCardTheSecondWallTease =>
      'Das 45-Sekunden-Wand-Teasing';

  @override
  String get dailySimmeringCardCourseTeasing => 'KURS 15 • TEASING';

  @override
  String get dailySimmeringCardTodayBrieflyPressYourPartner =>
      'Wenn ihr beide so etwas mögt: Zieh dein Gegenüber heute kurz an dich, küss langsam den Hals, flüstere ein Versprechen ins Ohr. Nach 45 Sekunden lächelst du und gehst weiter: \"Den Rest heben wir uns für später auf.\"';

  @override
  String get dailySimmeringCardJawMeltVoiceActivation =>
      'Die Kiefer-Schmelze & Stimm-Aktivierung';

  @override
  String get dailySimmeringCardCourseAudiblePleasure =>
      'KURS 21 • HÖRBARE LUST';

  @override
  String get dailySimmeringCardPlaceYourFingersOnYour =>
      'Lege die Finger an deine Kiefergelenke, öffne den Mund und lass 3 tiefe, dunkle Seufzer hörbar durch den Raum vibrieren. Spüre, wie dein Beckenboden gleichzeitig nach unten nachgibt.';

  @override
  String get dailySimmeringCardThePmAnticipation =>
      'Die 15:00-Uhr-Antizipation';

  @override
  String get dailySimmeringCardCourseAnticipation => 'KURS 15 • KOPFKINO';

  @override
  String get dailySimmeringCardThisAfternoonSendYourPartner =>
      'Nur wenn ihr das mögt: Schick deinem Gegenüber heute Nachmittag eine Nachricht, die Vorfreude macht, ohne etwas zu erwarten.';

  @override
  String get dailySimmeringCardSlowMotionWhilePouring =>
      'Zeitlupe beim Einschenken';

  @override
  String get dailySimmeringCardCourseSlowSex => 'KURS 15 • SLOW SEX';

  @override
  String get dailySimmeringCardTodayTouchYourPartnerDuring =>
      'Berühre dein Gegenüber heute bei einer Alltagsgelegenheit (am Tisch, auf dem Sofa) im extremen 10%-Zeitlupen-Tempo. Streiche 60 Sekunden ganz langsam über Handrücken und Unterarm.';

  @override
  String get dailySimmeringCardTheMinuteSilkScarfRitual =>
      'Das 15-Minuten-Seidentuch-Ritual';

  @override
  String get dailySimmeringCardCourseSurrender => 'KURS 23 • HINGABE';

  @override
  String get dailySimmeringCardAgreeForTonightOneOf =>
      'Verabredet für heute Abend: Einer bekommt die Augen verbunden und darf absolut nichts leisten oder zurückgeben. Der andere dirigiert 15 Minuten sanfte Berührungen.';

  @override
  String get dailySimmeringCardTheStrictNoPenetrationRule =>
      'Heute ohne Eindringen';

  @override
  String get dailySimmeringCardCourseSensateFocus =>
      'KURS 17 • BERÜHRUNG OHNE ZIEL';

  @override
  String get dailySimmeringCardAgreeTodayYouMayHug =>
      'Verabredet heute: Ihr dürft euch nackt umarmen, küssen und streicheln – Eindringen bleibt heute außen vor. Alles darf sein, nichts muss.';

  @override
  String get dailySimmeringCardSensoryNarratingWordsInThe =>
      'Sensory Narrating (Worte im Ohr)';

  @override
  String get dailySimmeringCardCbtLettingGoOfPropriety =>
      'KVT • ANSTÄNDIGKEIT LÖSEN';

  @override
  String get dailySimmeringCardTonightInTheDarkWhisper =>
      'Flüstere deinem Gegenüber heute im Dunkeln eine einzige ehrliche, sinnliche Empfindung ins Ohr: \"Es macht mich verrückt, wie warm und weich deine Haut gerade unter meiner Hand ist.\"';

  @override
  String get dailySimmeringCardTheCharmingDreamBridge =>
      'Die charmante Traum-Brücke';

  @override
  String get dailySimmeringCardCourseFantasies => 'KURS 23 • FANTASIEN';

  @override
  String get dailySimmeringCardTodayCasuallyAndWithA =>
      'Erzähle heute beiläufig mit einem Schmunzeln von einem \"unanständigen Traum\", den du über euch beide hattest. Beobachte die Reaktion.';

  @override
  String get dailySimmeringCardTheSeatedPelvicFloorCheck =>
      'Der Beckenboden-Check im Sitzen';

  @override
  String get dailySimmeringCardCoursesBody => 'KURS 7 & 9 • KÖRPER';

  @override
  String get dailySimmeringCardNoticeRightNowAreYou =>
      'Achte genau jetzt darauf: Hältst du im Becken oder After fest? Atme tief ein und lass den Beckenboden wie eine weite Blüte nach unten sinken (Reverse Kegel).';

  @override
  String get dailySimmeringCardSoftBellyFullSurrender =>
      'Weicher Bauch • Volle Hingabe';

  @override
  String get dailySimmeringCardCourseRadicalBodyLove =>
      'KURS 6 • RADICAL BODY LOVE';

  @override
  String get dailySimmeringCardTodayConsciouslyLetYourBelly =>
      'Lass deinen Bauch heute ganz bewusst locker nach außen sinken. Perfektion ist kalt – Hingabe und Wärme sind unwiderstehlich.';

  @override
  String get dailySimmeringCardJawMeltPelvicVibration =>
      'Die Kiefer-Schmelze & Becken-Vibration';

  @override
  String get dailySimmeringCardOpenYourMouthSmoothOut =>
      'Öffne den Mund, streiche deine Wangen aus und seufze 3x tief und dunkel nach unten aus. Spüre, wie die Schwingung bis in dein Schambein hinabwandert.';

  @override
  String get dailySimmeringCardBroadPalmTouchWithWarm =>
      'Broad Palm Touch mit warmem Öl';

  @override
  String get dailySimmeringCardCourseBodyLab =>
      'KURS 19 • BERÜHRUNG NEU LERNEN';

  @override
  String get dailySimmeringCardTodaySkipAnyTightGrip =>
      'Verzichte heute beim Spüren auf jeden engen Klammergriff. Nutze viel Gleitmittel und bewege die gesamte flache Handfläche in Zeitlupe über das Becken.';

  @override
  String get dailySimmeringCardOrbitingExploringThePerineum =>
      'Orbiting: Das Perineum erforschen';

  @override
  String get dailySimmeringCardCoursesOrbiting => 'KURS 18 & 9 • ORBITING';

  @override
  String get dailySimmeringCardLeaveTheHighlySensitiveTip =>
      'Lass die hochsensible Spitze heute für 10 Minuten völlig unberührt. Konzentriere Berührung nur auf Damm, Schaftbasis und Leiste.';

  @override
  String get dailySimmeringCardPlateauSurfingAtLevel =>
      'Erregung ohne Ziel spüren';

  @override
  String get dailySimmeringCardCourseStayingPower => 'KURS 19 • AUSDAUER';

  @override
  String get dailySimmeringCardBringYourArousalToLevel =>
      'Wenn du magst: Spür heute, wie sich deine Erregung anfühlt, und lass sie ohne Ziel kommen und gehen. Wird es zu viel, halte inne, atme 3x tief aus und lass den Beckenboden weich werden.';

  @override
  String get dailySimmeringCardScreenFreeSensing => 'Bildschirmfreies Spüren';

  @override
  String get dailySimmeringCardCourseRecalibration =>
      'KURS 10 • REKALIBRIERUNG';

  @override
  String get dailySimmeringCardTakeMinutesTodayWithoutAny =>
      'Nimm dir heute 10 Minuten Zeit ganz ohne Smartphone oder Bildschirme. Schließe die Augen und achte nur auf Temperatur und Atem.';

  @override
  String get dailySimmeringCardTheSphincterReleaseTest =>
      'Der Schließmuskel-Entlastungstest';

  @override
  String get dailySimmeringCardCourseMultipleOrgasms => 'KURS 19 • LOSLASSEN';

  @override
  String get dailySimmeringCardObserveYourReflexesWhenArousal =>
      'Beobachte deine Reflexe: Wenn Erregung steigt, lass den Anal-Schließmuskel bewusst locker, statt ihn anzuspannen.';

  @override
  String get dailySimmeringCardZeroPressureSquatMalasana =>
      'Zero-Pressure Hocke (Malasana)';

  @override
  String get dailySimmeringCardCourseFascia => 'KURS 7 • FASZIEN';

  @override
  String get dailySimmeringCardGoIntoADeepSquat =>
      'Gehe für 2 Minuten in die tiefe Hocke (Deep Squat). Atme 10 tiefe Atemzüge in das geöffnete Becken hinein.';

  @override
  String get dailySimmeringCardBodyCompassionInTheMirror =>
      'Körper-Mitgefühl vor dem Spiegel';

  @override
  String get dailySimmeringCardCourseSelfCompassion =>
      'KURS 6 • SELBSTMITGEFÜHL';

  @override
  String get dailySimmeringCardLookAtYourBodyToday =>
      'Betrachte deinen Körper heute ohne Bewertung. Sag dir: \"Mein Körper ist lebendig, atmend und fähig zu tiefster Lust.\"';

  @override
  String get dailySimmeringCardPhysiologicalSighQuickCalming =>
      'Der lange Seufzer';

  @override
  String get dailySimmeringCardToolCalmDown => 'ÜBUNG • RUHE';

  @override
  String get dailySimmeringCardBreatheInTwiceDeeplyThrough =>
      'Doppelt durch die Nase tief einatmen, dann sehr lang und hörbar durch den offenen Mund seufzen. 3 Wiederholungen.';

  @override
  String get dailySimmeringCardThePercentPactWithYourself =>
      'Der 90-Prozent-Pakt mit dir selbst';

  @override
  String get dailySimmeringCardGiveYourselfMinutesOfPleasure =>
      'Schenke dir heute 10 Minuten Genuss – aber nimm dir vor, bei 90% bewusst aufzuhören, ohne zum Abschluss zu eilen.';

  @override
  String get dailySimmeringCardTodaySEroticSpark => 'HEUTIGER EROTIK-FUNKE';

  @override
  String get dailySimmeringCardSimmeringEverydayTeasing =>
      'Simmering & Alltags-Teasing';

  @override
  String get dailySimmeringCardTapHereToRevealToday =>
      'Tippe hier, um deinen heutigen 45-Sekunden-Funken aufzudecken...';

  @override
  String get dailySimmeringCardOpen => 'ÖFFNEN';

  @override
  String get userProfileNonBinaryOpen => 'Divers / nicht-binär';

  @override
  String get userProfileInARelationshipMarried => 'In Beziehung / Verheiratet';

  @override
  String get userProfileDatingGettingToKnowSomeone =>
      'Dating / Kennenlernphase';

  @override
  String get userProfileSingle => 'Single';

  @override
  String get userProfileComplicated => 'Kompliziert';

  @override
  String get userProfilePelvicFloorBody => 'Beckenboden & Körper spüren';

  @override
  String get userProfileCoupleIntimacyCloseness => 'Paar-Intimität & Nähe';

  @override
  String get userProfileDesireRelaxation => 'Lust & Entspannung';

  @override
  String get userProfileJustLookingAround => 'Erstmal umsehen';

  @override
  String get userProfileEasingPerformancePressure => 'Weniger Druck';

  @override
  String get contentModelsTheArtOfTouchFor => 'BERÜHRUNGSKUNST • MIT VULVA';

  @override
  String get contentModelsTouchLabForHim => 'TAST-LABOR • MIT PENIS';

  @override
  String get contentModelsSelfExploration => 'SELBST ERKUNDEN';

  @override
  String get contentModelsVoiceBody => 'STIMME & SOMATIK';

  @override
  String get contentModelsAnticipationDesire => 'HINHALTEN & VERLANGEN';

  @override
  String get contentModelsPolarityRoles => 'POLARITÄT & ROLLEN';

  @override
  String get contentModelsBodyPresence => 'KÖRPER-PRÄSENZ';

  @override
  String get contentModelsForHer => 'MIT VULVA';

  @override
  String get contentModelsForCouples => 'FÜR PAARE';

  @override
  String get contentModelsForHim => 'MIT PENIS';

  @override
  String get yesNoMaybeModelsExcitesMeIDLike =>
      'Reizt mich, möchte ich ausprobieren';

  @override
  String get yesNoMaybeModelsCuriousButUnsureDependsOn =>
      'Neugierig, aber unsicher – kommt auf den Moment an';

  @override
  String get yesNoMaybeModelsNotForMe => 'Kommt für mich nicht infrage';

  @override
  String get backupCodecTheBackupIsTooLarge => 'Die Sicherung ist zu groß.';

  @override
  String get backupCodecThisIsNotAValid =>
      'Das ist keine gültige Sicherung (kein JSON).';

  @override
  String get backupCodecThisIsNotAValid2 => 'Das ist keine gültige Sicherung.';

  @override
  String get backupCodecThisIsNotAVelvetpulse =>
      'Das ist keine VelvetPulse-Sicherung.';

  @override
  String get backupCodecThisBackupComesFromA =>
      'Diese Sicherung stammt aus einer neueren App-Version. Bitte erst aktualisieren.';

  @override
  String backupCodecTheBackupIsDamagedField(Object key) {
    return 'Die Sicherung ist beschädigt (Feld „$key“).';
  }

  @override
  String get backupCodecTheBackupContainsAnInvalid =>
      'Die Sicherung enthält einen ungültigen Verbindungsschlüssel.';

  @override
  String get backupCodecTheBackupIsDamagedField2 =>
      'Die Sicherung ist beschädigt (Feld „secrets“).';

  @override
  String backupCodecTheBackupIsDamagedField3(Object field) {
    return 'Die Sicherung ist beschädigt (Feld „$field“ zu lang).';
  }

  @override
  String backupCodecTheBackupIsDamagedField4(Object field) {
    return 'Die Sicherung ist beschädigt (Feld „$field“ zu lang).';
  }

  @override
  String get backupCodecThePasswordIsWrongOr =>
      'Das Passwort stimmt nicht, oder die Sicherung wurde beschädigt.';

  @override
  String get backupCodecTheBackupIsDamaged => 'Die Sicherung ist beschädigt.';

  @override
  String get messageNotifierNewMessages => 'Neue Nachrichten';

  @override
  String get messageNotifierNewMessage => 'Neue Nachricht';

  @override
  String get messageNotifierNoticeOfNewMessagesIn =>
      'Hinweis auf neue Nachrichten im Paar-Kanal, ohne Inhalt';

  @override
  String get nostrServiceWeReConnected => '💛 Wir sind verbunden!';

  @override
  String nostrServiceCountOfFallbackrelayslengthServers(
      Object count, Object fallbackRelaysLength) {
    return '$count von $fallbackRelaysLength Servern';
  }

  @override
  String get nostrServiceVotedOnTheFantasySelection =>
      'Fantasie-Auswahl abgestimmt';

  @override
  String nostrServiceHaveAReadLessontitleCoursetitle(
      Object lessonTitle, Object courseTitle) {
    return '📖 Lies mal: „$lessonTitle“ ($courseTitle)';
  }

  @override
  String nostrServiceIVeSharedMyThoughts(Object lessonTitle) {
    return '💭 Ich habe meine Gedanken zu „$lessonTitle“ geteilt. Du siehst sie, sobald du selbst geantwortet hast.';
  }

  @override
  String get nostrServiceIVeSharedMyAnswers =>
      '🗳️ Ich habe meine Antworten der Ja/Nein-Liste geteilt.';

  @override
  String get privacyServiceUnlockTheApp => 'Entsperre die App';

  @override
  String get privacyServiceConfirmToTurnOnThe =>
      'Bestätige, um die App-Sperre einzuschalten';

  @override
  String get storageServiceTheBackupIsDamagedProfile =>
      'Die Sicherung ist beschädigt (Profil).';

  @override
  String get storageServiceReflections => 'Reflexionen';

  @override
  String get storageServiceYesNoList => 'Ja/Nein-Liste';

  @override
  String get storageServiceTheKeysInTheBackup =>
      'Die Schlüssel in der Sicherung passen nicht zusammen.';

  @override
  String get storageServiceTheBackupCouldNotBe =>
      'Die Sicherung konnte nicht eingespielt werden. Es wurde nichts verändert.';

  @override
  String storageServiceTheBackupIsDamagedFeld(Object feld) {
    return 'Die Sicherung ist beschädigt ($feld).';
  }

  @override
  String get spracheHinweis =>
      'Oberfläche, Kurse und Übungen. Die Aufnahmen gibt es auf Deutsch in der App; englische Aufnahmen lassen sich nachladen.';

  @override
  String get cueEinatmenWeit => 'Einatmen. Und weit werden.';

  @override
  String get cueWeichBleiben => 'Weich bleiben.';

  @override
  String get cueAnspannen => 'Anspannen. Und sanft heben.';

  @override
  String get cueHalten => 'Halten. Weiter atmen.';

  @override
  String get cueLoslassen => 'Und ganz loslassen.';

  @override
  String get cueNachspueren => 'Nachspüren.';

  @override
  String get cueAn => 'An.';

  @override
  String get cueLos => 'Los.';

  @override
  String get cueWelle => 'Einatmen. Damm und Po weich.';

  @override
  String get cueSeufzen => 'Ausatmen. Lang und hörbar.';

  @override
  String get cueStart => 'Wir beginnen.';

  @override
  String get cueFertig => 'Geschafft. Spür noch einen Moment nach.';

  @override
  String get audioPaketTitel => 'Englische Stimmen';

  @override
  String audioPaketText(int mb) {
    return 'Englische Aufnahmen für Lektionen, Gemeinsamen Abend, Selbsterkundung und Beckenboden-Training (ca. $mb MB). Ohne sie liest die Geräte-Stimme vor.';
  }

  @override
  String audioPaketInstalliert(int mb) {
    return 'Installiert ($mb MB). Die Aufnahmen liegen nur auf diesem Gerät.';
  }

  @override
  String get audioPaketLaden => 'Herunterladen';

  @override
  String get audioPaketLoeschen => 'Löschen';

  @override
  String get audioPaketFertig => 'Englische Stimmen sind bereit.';

  @override
  String get audioPaketFehler =>
      'Das hat nicht geklappt. Bitte Internetverbindung prüfen und später noch einmal versuchen.';

  @override
  String get navPaarKanalKurz => 'Paar-Kanal';

  @override
  String get spicyModus => 'Spicy-Modus';

  @override
  String get spicyModusText =>
      'Ab 18. Schaltet in Körperreise und Gemeinsamem Abend die Stufen „Spicy“ und „Sehr spicy“ frei.';

  @override
  String get heuteFuerHeute => 'Für heute';

  @override
  String get designTitel => 'Darstellung';

  @override
  String get designText =>
      'Papier ist hell, Nachtpapier dunkel. Im Spicy-Modus gelten eigene Farben.';

  @override
  String get designPapier => 'Papier';

  @override
  String get designNacht => 'Nachtpapier';

  @override
  String get designKlassisch => 'Klassisch';

  @override
  String get spicyEinschaltenTitel => 'Spicy-Modus einschalten?';

  @override
  String get spicyEinschaltenText =>
      'Nur für Erwachsene. In Körperreise und Gemeinsamem Abend erscheinen dann zwei zusätzliche Stufen:\n\n„Spicy“: heiß und direkt, Spiel mit der Erregung bis kurz vor den Höhepunkt, für Paare auch Küsse, Necken und der Mund.\n\n„Sehr spicy“: dasselbe mit Dirty Talk und derben Wörtern.\n\nAlles bleibt eine Einladung, ein Stoppwort gilt immer. Du kannst den Modus hier jederzeit ausschalten, dann verschwinden die Stufen sofort.';

  @override
  String get spicyEinschalten => 'Ich bin 18+, einschalten';

  @override
  String get alterTitel => 'Bist du volljährig?';

  @override
  String get alterText =>
      'Dieser Bereich ist nur für Erwachsene. Gib Monat und Jahr deiner Geburt an. Die App rechnet nur nach und speichert das Datum nicht. Alles bleibt auf diesem Gerät. Das ersetzt keinen Ausweis.';

  @override
  String get alterMonat => 'Monat';

  @override
  String get alterJahr => 'Jahr';

  @override
  String get alterWeiter => 'Weiter';

  @override
  String get alterGesperrtTitel => 'Gerade nicht möglich';

  @override
  String get alterGesperrtText =>
      'Dieser Bereich ist erst ab 18 verfügbar. Du kannst es später noch einmal versuchen.';

  @override
  String get alterSperreFehltTitel => 'Gerätesperre nötig';

  @override
  String get alterSperreFehltText =>
      'Richte zuerst eine Bildschirmsperre (PIN, Muster oder Fingerabdruck) auf deinem Gerät ein. Sie schützt diesen Bereich vor fremdem Zugriff.';

  @override
  String get alterSperreGrund =>
      'Bitte bestätige, dass du diesen Bereich öffnen willst.';

  @override
  String get alterAbsichern => 'Immer erneut absichern';

  @override
  String get alterAbsichernText =>
      'Nach einem App-Neustart oder 5 Stunden im Hintergrund fragt die App wieder nach deiner Gerätesperre.';

  @override
  String get alterGesperrtKurz => 'Gesperrt. Zum Entsperren einschalten.';

  @override
  String get spicyStufe => 'Spicy';

  @override
  String get selbstReiseSpicyText =>
      'Direkt auf der Haut beginnen, dann Erregungswellen bis kurz vor die Kante, und am Ende deine Wahl: kommen oder genießen.';

  @override
  String get paarAbendSpicyText =>
      'Necken, Küsse über den ganzen Körper, Hand und Mund am Geschlecht, Spiel mit der Kante. Nur wenn ihr beide es wollt.';

  @override
  String get paarAbendSpicyHinweis =>
      'Sprecht vorher kurz über Wünsche und Grenzen und vereinbart ein Stoppwort. Wer es sagt, bekommt sofort Ruhe, ohne Diskussion. Grün, gelb, rot hilft zwischendurch.';

  @override
  String get sehrSpicyStufe => 'Sehr spicy';

  @override
  String get selbstReiseSehrSpicyText =>
      'Wie Spicy, aber mit Dirty Talk: derbe Wörter, gierig und schamlos.';

  @override
  String get paarAbendSehrSpicyText =>
      'Wie Spicy, aber mit Dirty Talk: derbe Wörter, gierig und schamlos. Nur wenn ihr beide es wollt.';

  @override
  String audioPaketUpdate(int mb) {
    return 'Neue englische Aufnahmen sind verfügbar (ca. $mb MB). Bis dahin liest die Geräte-Stimme die neuen Texte vor.';
  }

  @override
  String get audioPaketAktualisieren => 'Aktualisieren';

  @override
  String get gefuehrtTitel => 'Geführte Audios';

  @override
  String get gefuehrtSelbstTitel => 'Körperreise';

  @override
  String get gefuehrtSelbstText =>
      '10 bis 30 Minuten nur für dich: eine Stimme führt dich über deinen Körper, so nah, wie du möchtest.';

  @override
  String get lessonDetailTryGuidedEvening =>
      'Jetzt geführt ausprobieren: Gemeinsamer Abend';

  @override
  String get spicyEinladen => 'Zum Spicy-Modus einladen';

  @override
  String get spicyEinladungText =>
      'Ich habe den Spicy-Modus eingeschaltet. Magst du ihn auch ausprobieren? (Profil › Spicy-Modus)';

  @override
  String get spicyEinladungAnnehmen => 'Spicy-Modus ansehen';

  @override
  String get spicyEinladungSchonAn => 'Bei dir ist der Spicy-Modus schon an.';

  @override
  String get spicyEinladungGesendet => 'Einladung gesendet.';

  @override
  String get spicyEinladungFehler =>
      'Das hat nicht geklappt. Bitte später noch einmal versuchen.';

  @override
  String get spicyFunkeLippen => 'Ich denk gerade an deine Lippen';

  @override
  String get spicyFunkeHeuteAbend => 'Heute Abend gehörst du mir';

  @override
  String get spicyFunkeScharf => 'Ich bin den ganzen Tag scharf auf dich';

  @override
  String get spicyFunkeSchmecken => 'Ich will dich heute Abend schmecken';

  @override
  String get spicyFunkeNichtsDrunter => 'Zieh heute nichts drunter an';

  @override
  String get spicyFunkeNackt => 'Ich will dich nackt sehen';

  @override
  String get spicyFunkeFicken => 'Ich will dich ficken. Heute.';

  @override
  String get spicyFunkeNachHause => 'Komm sofort nach Hause';

  @override
  String get verschwindenSchalter => 'Verschwindende Nachricht';

  @override
  String get verschwindenHinweis => 'Verschwindet 10 Min. nach dem Lesen …';

  @override
  String get verschwindetLabel => 'Verschwindet nach dem Lesen';

  @override
  String get fotoNachricht =>
      '📷 Ein Foto für dich, nur einmal ansehbar. Öffne VelvetPulse, dann kommt es direkt zu dir.';

  @override
  String get fotoSenden => 'Foto senden';

  @override
  String get fotoKamera => 'Kamera';

  @override
  String get fotoGalerie => 'Galerie';

  @override
  String get fotoSicherheitHinweis =>
      'Das Foto geht verschlüsselt direkt von Handy zu Handy und lässt sich nur einmal ansehen. Am sichersten ohne Gesicht und ohne erkennbare Umgebung. Ein zweites Handy kann den Bildschirm trotzdem abfotografieren.';

  @override
  String get fotoNichtDa =>
      'Dein Gegenüber hat VelvetPulse gerade nicht offen. Das Foto bleibt verschlüsselt bei dir und geht raus, sobald ihr beide die App offen habt.';

  @override
  String get fotoFehler =>
      'Das Foto konnte nicht angekündigt werden. Bitte später noch einmal versuchen.';

  @override
  String get fotoStatusWartet =>
      'Foto kommt, sobald ihr beide die App offen habt';

  @override
  String get fotoStatusLaedt => 'Foto wird übertragen …';

  @override
  String get fotoAnsehen => 'Foto ansehen (nur einmal)';

  @override
  String get fotoStatusAngesehen => 'Foto angesehen';

  @override
  String get fotoStatusWartetRaus => 'Wartet auf dein Gegenüber';

  @override
  String get fotoStatusZugestellt => 'Zugestellt';

  @override
  String get fotoStatusFehler => 'Nicht zugestellt';

  @override
  String get fotoAnsichtHinweis =>
      'Nur jetzt sichtbar. Beim Schließen ist das Foto gelöscht.';

  @override
  String get fotoWeg => 'Dieses Foto ist nicht mehr da.';

  @override
  String get anleitungTitel => 'So funktioniert VelvetPulse';

  @override
  String get anleitungEinleitung =>
      'Hier findest du alle Bereiche der App kurz erklärt. Tippe auf einen Abschnitt, um ihn aufzuklappen.';

  @override
  String get fotoIdeeTitel => 'FOTO-IDEE FÜR HEUTE';

  @override
  String get fotoIdeeHinweis =>
      'Ganz freiwillig. Ohne Gesicht ist am sichersten.';

  @override
  String get fotoIdeeAndere => 'Andere Idee';

  @override
  String get fotoIdeeHeuteNicht => 'Heute nicht';

  @override
  String get fotoIdeenAnzeigen => 'Foto-Ideen anzeigen';

  @override
  String get fotoIdeeHinweisHeiss =>
      'Ganz freiwillig. Bitte ohne Gesicht, Tattoos oder erkennbaren Raum.';

  @override
  String get fotoAlleinTitel => 'Bist du allein?';

  @override
  String get fotoAlleinText =>
      'Das Foto lässt sich nur einmal ansehen. Schau es dir am besten an, wenn du allein bist und dir niemand über die Schulter schaut.';

  @override
  String get fotoJetztAnsehen => 'Jetzt ansehen';

  @override
  String get fotoSpaeter => 'Später';

  @override
  String get fotoExperimentell => 'Experimentell';

  @override
  String get fotoExperimentellHinweis =>
      'Fotos sind neu: In manchen Mobilfunknetzen kommt die direkte Verbindung noch nicht zustande.';

  @override
  String get pairingAnfrageTitel => 'Dein Code wurde gescannt';

  @override
  String get pairingAnfrageText =>
      'Ein Handy hat gerade deinen Code gescannt und möchte sich mit dir verbinden. Bestätige nur, wenn es das Handy deines Gegenübers ist.';

  @override
  String get pairingAnfrageVerbinden => 'Verbinden';

  @override
  String get rueckmeldungTitel => 'Rückmeldung senden';

  @override
  String get rueckmeldungEinleitung =>
      'Ein Wunsch für eine neue Funktion, ein Fehler oder ein Wort, das falsch klingt? Schreib es uns, anonym und verschlüsselt.';

  @override
  String get rueckmeldungWunsch => 'Wunsch';

  @override
  String get rueckmeldungFehlerArt => 'Fehler';

  @override
  String get rueckmeldungAussprache => 'Aussprache';

  @override
  String get rueckmeldungNachricht => 'Deine Nachricht';

  @override
  String get rueckmeldungFehlerHinweis =>
      'Was ist passiert, und wo in der App?';

  @override
  String get rueckmeldungWort => 'Welches Wort klingt falsch?';

  @override
  String get rueckmeldungSoll => 'So sollte es klingen (freiwillig)';

  @override
  String get rueckmeldungSollHinweis => 'z. B. Betonung auf der zweiten Silbe';

  @override
  String get rueckmeldungAnmerkung => 'Anmerkung (freiwillig)';

  @override
  String get rueckmeldungKontakt => 'Kontakt für Rückfragen (freiwillig)';

  @override
  String get rueckmeldungKontaktHinweis => 'z. B. E-Mail oder Nostr-npub';

  @override
  String get rueckmeldungDatenschutz =>
      'Die Nachricht geht verschlüsselt über Nostr an das Rückmelde-Postfach von VelvetPulse, mit einem Einmal-Schlüssel, ohne Bezug zu deinem Paar-Kanal. Übertragen wird nur, was hier steht, dazu App-Version und Sprache. Die Server sehen deine IP-Adresse, nicht den Inhalt.';

  @override
  String get rueckmeldungSenden => 'Anonym senden';

  @override
  String get rueckmeldungDanke => 'Danke! Deine Rückmeldung ist angekommen.';

  @override
  String get rueckmeldungFehler =>
      'Senden hat nicht geklappt. Bitte prüfe die Internetverbindung und versuch es noch einmal.';

  @override
  String get rueckmeldungGithub => 'Lieber öffentlich auf GitHub melden';

  @override
  String get einschlafKarteTitel => 'Einschlafen';

  @override
  String get einschlafKarteTitelNeutral => 'Entspannung';

  @override
  String get einschlafKarteText =>
      'Eine lange, ruhige Reise in den Schlaf: 60 bis 120 Minuten mit Sätzen, die du im Halbschlaf mitnimmst.';

  @override
  String get einschlafTitel => 'Einschlaf-Reise';

  @override
  String get einschlafEinleitung =>
      'Eine Stimme begleitet dich im Bett in den Schlaf. Sie spricht immer weniger, die Pausen werden länger, und zum Schluss bleibt nur ein leiser Klang. Du darfst und sollst dabei einschlafen.';

  @override
  String get einschlafWirkung =>
      'Die Sätze wirken vor allem in der ruhigen Zeit, bevor du einschläfst, und durch die Wiederholung an vielen Abenden. Gelernt wird nicht im Tiefschlaf.';

  @override
  String get einschlafHinweise =>
      'Nicht beim Autofahren oder wenn du wach bleiben musst. Stell es leise ein; Kopfhörer nur, wenn sie bequem sind, sonst den Lautsprecher. Am besten mit Ladekabel. Die Einschlaf-Reise ersetzt keine Behandlung von Schlafstörungen.';

  @override
  String get einschlafLaenge => 'Länge';

  @override
  String get einschlafSchwerpunkt => 'Schwerpunkt';

  @override
  String get traumKarteTitel => 'Traum-Abend';

  @override
  String get traumKarteTitelNeutral => 'Ruhe';

  @override
  String get traumKarteText =>
      'Sanft in den Schlaf und in einen sinnlichen Traum: 30 bis 60 Minuten mit einem Traumbild deiner Wahl.';

  @override
  String get traumTitel => 'Traum-Abend';

  @override
  String get traumEinleitung =>
      'Eine Stimme begleitet dich in den Schlaf und legt dir ein Traumbild nahe. Danach wiederholt sie leise deine Traum-Absicht, mit immer längeren Pausen, bis nur Stille bleibt. Du darfst dabei einschlafen.';

  @override
  String get traumBild => 'Traumbild';

  @override
  String get traumBildWarmesWasser => 'Warmes Wasser';

  @override
  String get traumBildOrtFuerMich => 'Ein Ort für mich';

  @override
  String get traumBildKoerperImLicht => 'Körper im Licht';

  @override
  String get traumBildBegegnung => 'Begegnung';

  @override
  String get traumBildKlarheit => 'Klarheit';

  @override
  String get einschlafUeberrasch => 'Überrasch mich';

  @override
  String get einschlafThemaKoerper => 'Mein Körper ist willkommen';

  @override
  String get einschlafThemaWelle => 'Lust ist eine Welle';

  @override
  String get einschlafThemaGaspedal => 'Gaspedal und Bremse';

  @override
  String get einschlafThemaSpueren => 'Spüren statt beobachten';

  @override
  String get einschlafThemaBecken => 'Ein weiches Becken';

  @override
  String get einschlafThemaGeniessen => 'Ich darf genießen';

  @override
  String get einschlafOhneBezug => 'Ohne Bezug';

  @override
  String get einschlafSpicyTitel => 'Deutlichere Worte';

  @override
  String get einschlafSpicyText =>
      'Ruhige, anatomische Sprache für dein eigenes Geschlecht. Kein Dirty Talk, nichts Aufregendes.';

  @override
  String get einschlafStart => 'Einschlaf-Reise beginnen';

  @override
  String get einschlafLaeuft => 'Du darfst einschlafen';

  @override
  String get einschlafLaeuftText =>
      'Die Stimme wird leiser und seltener. Am Ende stoppt alles von selbst.';

  @override
  String get einschlafBeenden => 'Einschlaf-Reise beenden?';

  @override
  String get einschlafBeendenText => 'Die Begleitung hört dann auf.';

  @override
  String get aufnahmenTitel => 'Aufnahmen';

  @override
  String get aufnahmenText =>
      'Die gesprochenen Aufnahmen von Victoria und Martin lädst du hier nach, am besten im WLAN. Ohne sie liest die Stimme deines Handys vor.';

  @override
  String get aufnahmenLektionen => 'Lektionen';

  @override
  String get aufnahmenGefuehrt => 'Geführte Audios';

  @override
  String aufnahmenGroesse(int mb) {
    return '$mb MB';
  }

  @override
  String aufnahmenInstalliert(int mb) {
    return 'geladen, $mb MB';
  }

  @override
  String get aufnahmenLaden => 'Laden';

  @override
  String aufnahmenAlleLaden(int mb) {
    return 'Alle laden ($mb MB)';
  }

  @override
  String get aufnahmenFertig => 'Aufnahmen geladen.';

  @override
  String get aufnahmenFehler =>
      'Laden hat nicht geklappt. Bitte prüfe die Internetverbindung und versuch es noch einmal.';

  @override
  String get aufnahmenNichtErreichbar =>
      'Das Verzeichnis der Aufnahmen ist gerade nicht erreichbar. Bitte später noch einmal versuchen.';

  @override
  String get aufnahmenHinweisTitel => 'Aufnahmen laden';

  @override
  String get aufnahmenHinweisText =>
      'Damit Victoria und Martin die Lektionen und geführten Audios sprechen, lade einmal die Aufnahmen. Bis dahin liest die Stimme deines Handys vor.';

  @override
  String get aufnahmenSpaeter => 'Später';

  @override
  String get aufnahmenAnsehen => 'Ansehen';

  @override
  String get fotoErneutVersuchen => 'Jetzt erneut versuchen';

  @override
  String get fotoStatusWeg => 'Foto nicht mehr verfügbar';

  @override
  String get tagebuchTitel => 'Traumtagebuch';

  @override
  String get tagebuchTipp =>
      'Gleich nach dem Aufwachen kurz still liegen bleiben und den Traum zurückholen, bevor du dich bewegst. Ein paar Stichworte reichen. Auch „nichts erinnert“ zählt.';

  @override
  String get tagebuchPause =>
      'Zuletzt hast du öfter unangenehme Träume oder schlechten Schlaf notiert. Das ist normal und kein Fehler. Vielleicht tut dir eine Pause gut oder nur Tagebuch und sanfte Traumbilder. Wenn dich etwas belastet, hilft der SOS-Knopf.';

  @override
  String get tagebuchWoranErinnerst => 'Woran erinnerst du dich?';

  @override
  String get tagebuchNichtsErinnert => 'Nichts erinnert';

  @override
  String get tagebuchPrivat =>
      'Dein Traumtagebuch ist privat. Sinnliche Träume sind ein Zeichen, dass deine Lust lebendig ist. Wer darin vorkommt und was geschieht, muss nichts bedeuten. Die Einträge gehen nicht an dein Gegenüber und nicht ins Netz; sie sind Teil deiner verschlüsselten Sicherung.';

  @override
  String get tagebuchHinweisText => 'Stichworte, ein Bild, ein Gefühl …';

  @override
  String get tagebuchLoeschen => 'Löschen';

  @override
  String get tagebuchSpeichern => 'Speichern';

  @override
  String get tagebuchMarkeErinnert => 'erinnert';

  @override
  String get tagebuchMarkeLuzide => 'luzide';

  @override
  String get tagebuchMarkeSinnlich => 'sinnlich';

  @override
  String get tagebuchMarkeHoehepunkt => 'Höhepunkt';

  @override
  String get tagebuchMarkeUnangenehm => 'unangenehm';

  @override
  String get tagebuchMarkeSchlechtGeschlafen => 'schlecht geschlafen';

  @override
  String get tagebuchKarteTitel => 'Woran erinnerst du dich?';

  @override
  String get tagebuchKarteTitelNeutral => 'Morgennotiz';

  @override
  String get tagebuchKarteText =>
      'Halte deinen Traum fest, solange er noch nah ist. Ein paar Worte genügen.';

  @override
  String get tagebuchKarteTextNeutral =>
      'Ein paar Worte für dich, gleich am Morgen.';

  @override
  String get traumpraxisTitel => 'Deine Traumpraxis';

  @override
  String get praxisZeichenTitel => 'Deine Traumzeichen';

  @override
  String get praxisZeichenText =>
      'Was taucht in deinen Träumen wieder auf? Ein Ort, ein unmöglicher Übergang, ein besonderes Licht? Benenne ein Zeichen, an dem du einen Traum erkennen möchtest.';

  @override
  String get praxisZeichenLeer =>
      'Noch keine Traumzeichen. Du kannst mit einem Detail aus deinem Tagebuch beginnen.';

  @override
  String get praxisZeichenFeld => 'Mein Traumzeichen';

  @override
  String get praxisZeichenBeispiel =>
      'Zum Beispiel: eine Tür an einem unmöglichen Ort';

  @override
  String get praxisHinzufuegen => 'Hinzufügen';

  @override
  String get praxisSpeichern => 'Speichern';

  @override
  String get praxisAbbrechen => 'Abbrechen';

  @override
  String get praxisBearbeiten => 'Bearbeiten';

  @override
  String get praxisLoeschen => 'Löschen';

  @override
  String get praxisLoeschenFrage => 'Diesen Eintrag löschen?';

  @override
  String get praxisLoeschenText =>
      'Der Eintrag wird entfernt. Eine spätere Wiederherstellung einer älteren Sicherung holt ihn nicht automatisch zurück.';

  @override
  String get praxisFehler =>
      'Das Speichern hat nicht geklappt. Deine bisherigen Daten bleiben erhalten. Bitte versuche es erneut.';

  @override
  String get praxisZeichenWaehlen => 'Ein Zeichen für heute Abend';

  @override
  String get praxisZeichenAbsicht =>
      'Stell dir vor, dieses Zeichen erscheint in deinem Traum. Du bemerkst es und erkennst: Ich träume. Danach darf deine persönliche Absicht ruhen.';

  @override
  String get praxisAbendStart => 'Zu deiner Abendfolge';

  @override
  String get praxisBeobachten => 'Heute nachspüren';

  @override
  String get praxisBeobachtungTitel => 'Deine Tagesbeobachtung';

  @override
  String get praxisBeobachtungText =>
      'Was beobachtest du heute? Du kannst einzelne Fragen offenlassen. Ein erlebter Höhepunkt ist eine Möglichkeit, kein Ziel für jeden Abend.';

  @override
  String get praxisSchlaf => 'Wie erholt bist du?';

  @override
  String get praxisLust => 'Wie fühlt sich deine Lust heute an?';

  @override
  String get praxisUnbeantwortet => 'Offenlassen';

  @override
  String get praxisSchlaf0 => 'Gar nicht erholt';

  @override
  String get praxisSchlaf1 => 'Wenig erholt';

  @override
  String get praxisSchlaf2 => 'Teils erholt';

  @override
  String get praxisSchlaf3 => 'Gut erholt';

  @override
  String get praxisSchlaf4 => 'Sehr erholt';

  @override
  String get praxisLust0 => 'Keine Lust spürbar';

  @override
  String get praxisLust1 => 'Wenig Lust';

  @override
  String get praxisLust2 => 'Mittlere Lust';

  @override
  String get praxisLust3 => 'Deutliche Lust';

  @override
  String get praxisLust4 => 'Viel Lust';

  @override
  String get praxisSinnlich => 'War dein Traum sinnlich?';

  @override
  String get praxisKlar => 'Wusstest du im Traum, dass du träumst?';

  @override
  String get praxisOrgasmus => 'Hast du im Traum einen Orgasmus erlebt?';

  @override
  String get praxisJa => 'Ja';

  @override
  String get praxisNein => 'Nein';

  @override
  String get praxisNotiz => 'Was möchtest du festhalten?';

  @override
  String get praxisRueckblick => 'Dein privater Rückblick';

  @override
  String get praxisRueckblickText =>
      'Hier stehen deine eigenen Beobachtungen. Ähnliche Verläufe können neugierig machen, belegen aber keine Ursache. Es gibt keine Punkte und keine Zielquote.';

  @override
  String get praxisRueckblickLeer =>
      'Noch keine Tagesbeobachtung. Schon eine einzelne Notiz kann ein Anfang sein.';

  @override
  String get praxisNurOffeneFelder => 'Noch keine Fragen beantwortet';

  @override
  String get praxisPfad => 'Dein Weg für heute';

  @override
  String get praxisPfadErinnern =>
      'Beginne mit Erinnern und Körperwahrnehmung. Die ersten beiden Folgen begleiten dich dabei.';

  @override
  String get praxisPfadErkennen =>
      'Verbinde ein persönliches Traumzeichen mit deiner Abendvorbereitung. Die Folgen drei bis fünf vertiefen das Erkennen.';

  @override
  String get praxisPfadEntfalten =>
      'Du kannst Lust im Klartraum erkunden und nachspüren, was du in den Tag mitnehmen möchtest. Die Folgen sechs bis acht geben dir dafür Raum.';

  @override
  String get traumpraxisNurSpicy =>
      'Diese Traumpraxis gehört zum Spicy-Modus für Erwachsene.';

  @override
  String get traumpraxisEinladung => 'Lust darf über die Nacht hinausreichen.';

  @override
  String get traumpraxisZiel =>
      'Erkunde sinnliche Träume, das bewusste Erkennen im Traum und das, was davon am Tag nachklingen darf. Ein Höhepunkt kann dazugehören. Du bestimmst, wie weit du gehen möchtest.';

  @override
  String get traumpraxisErinnern => 'Am Morgen · Erinnern';

  @override
  String get traumpraxisErinnernText =>
      'Halte fest, woran du dich erinnerst: einen Ort, eine Empfindung, eine Begegnung. Sinnlichkeit, Klarheit und ein erlebter Höhepunkt dürfen im Tagebuch markiert werden. Auch ein Traum ohne Höhepunkt oder eine Nacht ohne Erinnerung gehört dazu.';

  @override
  String get traumpraxisErkennen => 'Am Abend · Erkennen üben';

  @override
  String get traumpraxisMildEinleitung =>
      'Diese Vorstellungsübung orientiert sich an MILD: Du verbindest die Erinnerung an einen Traum mit der Absicht, den nächsten Traum zu erkennen. Übe kurz und ohne dich wachzuhalten. Einen zusätzlichen Wecker brauchst du dafür nicht.';

  @override
  String get traumpraxisVorlage => 'Eine angenehme Traumerinnerung';

  @override
  String get traumpraxisOhneEintrag =>
      'Noch kein passender Eintrag? Erinnere dich an einen angenehmen Traum. Du kannst zunächst auch nur einen vertrauten Ort vor Augen haben und das bewusste Erkennen üben.';

  @override
  String get traumpraxisMildSchritte =>
      'Rufe deinen Traum ruhig in Erinnerung. Wo war etwas ungewöhnlich? Vielleicht ein Ort, der sich verändert hat, oder ein unmöglicher Übergang.\n\nStell dir dieselbe Stelle noch einmal vor. Diesmal bemerkst du sie und erkennst: Ich träume. Lass die Vorstellung für einen Moment bestehen, ohne eine Handlung erzwingen zu müssen.';

  @override
  String get traumpraxisAbsicht =>
      'Wenn ich wieder träume, möchte ich mich daran erinnern, dass ich träume.';

  @override
  String get traumpraxisLoslassen =>
      'Danach darf die Absicht ruhen. Du darfst einschlafen. Wenn die Übung dich wacher macht, lässt du sie für heute los. Die acht Abendfolgen stehen dir weiterhin zur Verfügung.';

  @override
  String get traumpraxisRuhe => 'Heute darf Ruhe genügen';

  @override
  String get traumpraxisMitnehmen => 'Am Tag · Das Angenehme mitnehmen';

  @override
  String get traumpraxisMitnehmenText =>
      'Wenn dein Traum angenehm war, erinnere dich an eine Empfindung: Wärme, Leichtigkeit oder Nähe. Was davon ist jetzt, im wachen Körper, noch spürbar? Es darf viel sein, wenig oder gar nichts. Bei einem belastenden Traum lässt du diese Übung aus.';

  @override
  String get traumpraxisNachspueren =>
      'Wähle eine kleine, freiwillige sinnliche Erfahrung für deinen Tag: warmes Wasser auf der Haut, einen weichen Stoff oder einen Moment ungestörter Körperwahrnehmung. Spüre danach nach: Hat sich deine Lust verändert? Deine Neugier? Oder vor allem deine Ruhe? Notiere deine eigene Beobachtung, ohne sie bewerten zu müssen.';

  @override
  String get traumpraxisNotieren => 'Im Tagebuch nachspüren';

  @override
  String get traumpraxisHoehepunkt => 'Wenn du im Traum einen Orgasmus erlebst';

  @override
  String get traumpraxisHoehepunktText =>
      'Du darfst das Erlebnis genießen und festhalten, auch wenn es sich wiederholt. Die App misst keine körperlichen Reaktionen: Ein erinnerter Orgasmus im Traum ist ein berichtetes Erlebnis, kein körperlicher Messbefund. Du musst weder im Traum bleiben noch einen weiteren Höhepunkt erreichen.';

  @override
  String get traumpraxisHoeren => 'Zum Hören';

  @override
  String get traumpraxisHoerenText =>
      'Drei kurze Begleitungen mit Victoria oder Martin. Sie ergänzen die Praxis, ersetzen nichts davon und enden von selbst. Nur für dich allein, nicht für das gemeinsame Hören.';

  @override
  String get traumpraxisHoerenAbend =>
      'Einmal vor dem Einschlafen oder vor einer Abendfolge.';

  @override
  String get traumpraxisHoerenKlarheit =>
      'Tagsüber oder am frühen Abend, wach und im Sitzen oder Liegen.';

  @override
  String get traumpraxisHoerenMorgen =>
      'Nach dem Aufwachen oder in einem ruhigen Moment am Tag, danach gern die Tagesbeobachtung.';

  @override
  String get traumpraxisHoerenStarten => 'Anhören';

  @override
  String get traumpraxisHoerenPaket =>
      'Der Inhalt dieser Begleitungen kommt mit den Aufnahmen. Lade sie in der Paketverwaltung nach, dann erscheinen die Titel hier.';

  @override
  String get audioFuerHeute => 'Für heute';

  @override
  String get audioAlleAnzeigen => 'Alle anzeigen';

  @override
  String get audioGruppeFuerMich => 'Für mich';

  @override
  String get audioGruppeFuerMichText =>
      'Zeit nur für dich: deinen Körper spüren, dich erkunden, Träume bewusster erleben. Du bestimmst Länge und Nähe.';

  @override
  String get audioGruppeFuerUns => 'Für uns';

  @override
  String get audioGruppeFuerUnsText =>
      'Zu zweit hören oder abwechselnd geben und empfangen. Eine Stimme führt, ihr bestimmt das Tempo.';

  @override
  String get audioGruppeNacht => 'Nacht';

  @override
  String get audioGruppeNachtNeutral => 'Ruhe';

  @override
  String get audioGruppeNachtText =>
      'Zum Einschlafen, für den Traum-Abend und zum Wiedereinschlafen. Die Stimme wird leiser, du darfst einschlafen.';

  @override
  String get audioGruppeGeschichten => 'Geschichten';

  @override
  String get audioGruppeGeschichtenNeutral => 'Hörgeschichten';

  @override
  String get audioGruppeGeschichtenText =>
      'Zusammenhängende Hörgeschichten für Erwachsene, nicht zum Einschlafen. Du wählst Perspektive und Intensität.';

  @override
  String get audioGemeinsamTitel => 'Gemeinsam hören';

  @override
  String get audioGemeinsamText =>
      'Startet eine Aufnahme und tippt im Player auf „Gemeinsam hören“. Beide brauchen dieselbe Aufnahme auf dem Gerät; ihr hört im selben Takt und beide können pausieren.';

  @override
  String get traumpraxisKarteTitel => 'Traumpraxis';

  @override
  String get traumpraxisKarteTitelNeutral => 'Praxis';

  @override
  String get traumpraxisKarteText =>
      'Erinnern, erkennen, nachspüren: deine Praxis rund um die Nacht.';

  @override
  String get traumpraxisErkundung =>
      'Mehr Lust im Traum und im Alltag ist das Ziel dieser Erkundung. Ob diese Übungen deine Tageslust erhöhen, ist offen und individuell zu beobachten. MILD wird zur Klartraumförderung untersucht; diese kurze Abendfassung und der Transfer in den Tag sind keine nachgewiesene Behandlung. Erholsamer Schlaf bleibt wichtiger als ein bestimmtes Traumerlebnis.';

  @override
  String get lustTitel => 'Lust im Traum';

  @override
  String lustFolgeN(int n) {
    return 'Folge $n';
  }

  @override
  String get lustFolge1 => 'Lust im Körper';

  @override
  String get lustFolge2 => 'Die Welle';

  @override
  String get lustFolge3 => 'Den Traum einladen';

  @override
  String get lustFolge4 => 'Erkennen';

  @override
  String get lustFolge5 => 'Im Klartraum bleiben';

  @override
  String get lustFolge6 => 'Lust im Traum entfalten';

  @override
  String get lustFolge7 => 'Mehr als einmal';

  @override
  String get lustFolge8 => 'Eigene Wege';

  @override
  String get lustSerieEinleitung =>
      'Acht Abende, die aufeinander aufbauen: vom entspannten, lustvollen Körper beim Einschlafen über das Erinnern und Erkennen von Träumen bis zum luziden, sinnlichen Traum. Die nächste Folge wird frei, wenn du die vorige an zwei Abenden gehört hast. Zurückgehen und Wiederholen geht jederzeit.';

  @override
  String get lustEinleitung =>
      'Eine Stimme begleitet dich in den Schlaf und in die Folge dieses Abends. Danach wiederholt sie leise die Absicht, mit immer längeren Pausen, bis nur Stille bleibt. Du darfst dabei einschlafen.';

  @override
  String get lustEhrlich =>
      'Ein Höhepunkt im Traum lässt sich einladen, nicht erzwingen. Manche erleben ihn nach wenigen Nächten, manche nach vielen, manche erleben dafür sinnliche Träume ohne Höhepunkt. Alles davon ist richtig.';

  @override
  String get lustFolgen => 'Folgen';

  @override
  String get lustTraumkoerper => 'Dein Körper im Traum';

  @override
  String get lustTraumkoerperEigener => 'Mein eigener';

  @override
  String get lustTraumkoerperFrau => 'Frauenkörper';

  @override
  String get lustTraumkoerperMann => 'Männerkörper';

  @override
  String get lustGegenueber => 'Mit wem im Traum';

  @override
  String get lustGegenueberNiemand => 'Nur ich';

  @override
  String get lustGegenueberFrau => 'Eine Frau';

  @override
  String get lustGegenueberMann => 'Ein Mann';

  @override
  String get lustGegenueberOffen => 'Offen';

  @override
  String get lustWeiter => 'Weiter zum Abend';

  @override
  String get lustHinweise =>
      'Nur ab achtzehn. Kein Ersatz für eine Behandlung bei Schlafstörungen; bei häufigen Albträumen, Epilepsie oder schwerem Schlafmangel lieber nicht. Starke Erregung weckt oft auf, das ist normal. Was im Traum geschieht, ist ein Traumerlebnis; Fantasien darin sagen wenig über Wünsche im Wachleben.';

  @override
  String get lustHinweisHandtuch =>
      'Ein Handtuch in Reichweite ist kein schlechter Gedanke.';

  @override
  String lustAbendeGehoert(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'an $n Abenden gehört',
      one: 'an einem Abend gehört',
      zero: 'noch nicht gehört',
    );
    return '$_temp0';
  }

  @override
  String lustGesperrt(int n) {
    return 'Frei nach zwei Abenden mit Folge $n';
  }

  @override
  String get lustPaketFehlt =>
      'Für diese Serie fehlen noch die Aufnahmen. Sie kommen als eigenes Paket, am besten im WLAN laden.';

  @override
  String get lustPaketLaden => 'Aufnahmen laden';

  @override
  String get lustLadenFehler =>
      'Laden hat nicht geklappt. Bitte später noch einmal versuchen.';

  @override
  String get lustKarteTitel => 'Lust im Traum';

  @override
  String get lustKarteTitelNeutral => 'Abendserie';

  @override
  String get lustKarteText =>
      'Acht Abende, die aufeinander aufbauen, bis zum luziden, sinnlichen Traum.';

  @override
  String get lustKarteTextNeutral =>
      'Acht ruhige Abende, die aufeinander aufbauen.';

  @override
  String get startSchwerpunkte => 'KURSE NACH SCHWERPUNKTEN';

  @override
  String startLektionenVon(int n, int m) {
    return '$n von $m Lektionen';
  }

  @override
  String get schwerpunktGrundlagen => 'Grundlagen';

  @override
  String get schwerpunktGrundlagenText =>
      'Wie Kopf und Körper zusammenspielen, wie Erregung funktioniert und warum dein Körper gut ist, wie er ist.';

  @override
  String get schwerpunktAnnehmen => 'Annehmen und Lösen';

  @override
  String get schwerpunktAnnehmenText =>
      'Schmerz, Scham und Druck verstehen, freundlich mit dir sein, den Beckenboden lösen und stärken.';

  @override
  String get schwerpunktEntdecken => 'Sich selbst entdecken';

  @override
  String get schwerpunktEntdeckenText =>
      'Den eigenen Körper erkunden: weibliche Lust, neue Reize, Prostata und Damm.';

  @override
  String get schwerpunktPaar => 'Lust als Paar';

  @override
  String get schwerpunktPaarText =>
      'Reden, unterschiedliche Lust, Lebensphasen, Vorfreude und Erotik im Alltag.';

  @override
  String get schwerpunktBeruehrung => 'Berührung';

  @override
  String get schwerpunktBeruehrungText =>
      'Berührung für sie und für ihn, Intim-Massage, Stimme und entspannte Stellungen.';

  @override
  String get schwerpunktFantasie => 'Fantasie und Spiel';

  @override
  String get schwerpunktFantasieText =>
      'Fantasien, Führung und Hingabe, Kopfkino und Spielzeug.';

  @override
  String get rueckblickTitel => 'Diese Woche';

  @override
  String get rueckblickKeineEintraege =>
      'Keine Notizen in den letzten sieben Tagen.';

  @override
  String rueckblickEintraegeGesamt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Notizen in den letzten sieben Tagen',
      one: '1 Notiz in den letzten sieben Tagen',
    );
    return '$_temp0';
  }

  @override
  String rueckblickErinnertMorgen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'An $n Morgen erinnert',
      one: 'An 1 Morgen erinnert',
    );
    return '$_temp0';
  }

  @override
  String rueckblickNichtsErinnertMorgen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal nichts erinnert',
      one: '1 Mal nichts erinnert',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeLuzide(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal luzide',
      one: '1 Mal luzide',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeSinnlich(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal sinnlich',
      one: '1 Mal sinnlich',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeHoehepunkt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal Höhepunkt',
      one: '1 Mal Höhepunkt',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeUnangenehm(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal unangenehm',
      one: '1 Mal unangenehm',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeSchlechtGeschlafen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Mal schlecht geschlafen',
      one: '1 Mal schlecht geschlafen',
    );
    return '$_temp0';
  }

  @override
  String get rueckblickNachAbenden => 'Nach den Abenden';

  @override
  String get rueckblickKeineMarken => 'ohne Markierung';

  @override
  String get realitaetTitel => 'Realitätscheck';

  @override
  String get realitaetFrage => 'Träume ich gerade?';

  @override
  String get realitaetEinleitung =>
      'Ein kurzer Moment der Achtsamkeit. Wenn du dich tagsüber fragst, ob du wach bist, taucht diese Gewohnheit auch im Traum auf.';

  @override
  String get realitaetUebungHaendeTitel => 'Auf die Hände schauen';

  @override
  String get realitaetUebungHaendeText =>
      'Sieh dir deine Handflächen und Finger aufmerksam an. Im Traum verändern Hände oft ihre Form oder Linien.';

  @override
  String get realitaetUebungFingerTitel => 'Finger durch die Handfläche';

  @override
  String get realitaetUebungFingerText =>
      'Drücke sanft mit einem Finger gegen deine andere Handfläche. Stell dir vor, hindurchzugleiten. Im Traum gibt feste Materie manchmal nach.';

  @override
  String get realitaetUebungTextTitel => 'Text zweimal lesen';

  @override
  String get realitaetUebungTextText =>
      'Lies eine Zeile oder eine Uhrzeit, schau kurz weg und lies noch einmal. Im Traum wechseln Buchstaben und Ziffern oft ihr Aussehen.';

  @override
  String get realitaetBestaetigenWach => 'Ich bin wach';

  @override
  String get realitaetBestaetigenTraum => 'Ich träume!';

  @override
  String get realitaetErinnerungenAktiv => 'Erinnerungen am Tag';

  @override
  String realitaetZeitfenster(int von, int bis) {
    return 'Zeitfenster: $von bis $bis Uhr';
  }

  @override
  String realitaetAnzahlTag(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Erinnerungen pro Tag',
      one: '1 Erinnerung pro Tag',
    );
    return '$_temp0';
  }

  @override
  String get realitaetMotiveTitel => 'Motive aus deinem Tagebuch';

  @override
  String get realitaetMotiveKeine =>
      'Sobald du mehr Notizen im Tagebuch hast, schlägt die App hier wiederkehrende Bilder als Auslöser vor.';

  @override
  String realitaetMotivSatz(String wort) {
    return 'Wenn ich $wort sehe, frage ich mich, ob ich träume.';
  }

  @override
  String get realitaetMitteilungTitel => 'Kurzer Moment für dich';

  @override
  String get realitaetMitteilungText =>
      'Nimm dir einen kurzen Augenblick Zeit.';

  @override
  String get realitaetHinweisXiaomi =>
      'Hinweis für Xiaomi- und MIUI-Geräte: Damit Erinnerungen verlässlich eintreffen, sollten Akku-Optimierung und Autostart in den Telefoneinstellungen für die App freigegeben sein.';

  @override
  String get realitaetKanalName => 'Achtsamkeit';

  @override
  String get realitaetKanalBeschreibung =>
      'Erinnerungen für den Realitätscheck am Tag';

  @override
  String get weckenTitel => 'Heute Nacht wecken';

  @override
  String get weckenUntertitel =>
      'Einmaliger System-Wecker nach etwa fünf Stunden Schlaf';

  @override
  String weckenUhrzeit(String zeit) {
    return 'Weckzeit: $zeit Uhr';
  }

  @override
  String get weckenAendern => 'Zeit ändern';

  @override
  String get weckenWeckerName => 'Kurzer Moment';

  @override
  String get weckenGesperrt =>
      'Du hast das nächtliche Wecken in den letzten sieben Tagen bereits zweimal genutzt. Dein Schlaf geht vor.';

  @override
  String get weckenSicherheit =>
      'Höchstens zweimal pro Woche. Nicht nutzen bei Schichtarbeit, in der Schwangerschaft, mit einem Baby, das nachts weckt, oder bei Schlafmangel. Beim Wiedereinschlafen kann selten eine harmlose Schlafparalyse auftreten: ruhig atmen und einen Finger bewegen.';

  @override
  String weckenWeckerGesetzt(String zeit) {
    return 'System-Wecker für $zeit Uhr geöffnet';
  }

  @override
  String get weckenBegleitungTitel => 'Wiedereinschlafen';

  @override
  String get weckenBegleitungEinleitung =>
      'Halte deinen Traum kurz in Stichworten fest und lass dich danach ruhig zurück in den Schlaf begleiten.';

  @override
  String get weckenTagebuchKarteTitel => 'Nach dem Wecken weiterschlafen';

  @override
  String get weckenTagebuchKarteText =>
      'Kurze, leise Begleitung zurück in den Traum (ca. 15 Min.)';

  @override
  String get weckenBegleitungStarten => 'Begleitung starten';

  @override
  String get weckenTraumNotieren => 'Traum kurz festhalten';

  @override
  String get weckenLaeuft => 'Gute Nacht';

  @override
  String get weckenLaeuftText =>
      'Leg das Gerät weg und schließ die Augen. Die Begleitung endet von selbst.';

  @override
  String get testmodusAn => 'Testmodus an: kurze Pausen, alles frei.';

  @override
  String get testmodusAus => 'Testmodus aus.';

  @override
  String get testmodusSchild =>
      'Testmodus: kurze Pausen, alles frei. Ausschalten: siebenmal auf die Versionsnummer im Profil tippen.';

  @override
  String get reiheKarteTitel => 'Innenansichten';

  @override
  String get reiheKarteTitelNeutral => 'Hörgeschichte';

  @override
  String get reiheKarteText =>
      'Lust von innen erzählt, in Soft und Spicy, auch aus zwei Perspektiven derselben Begegnung.';

  @override
  String get reiheKarteTextNeutral => 'Eine zusammenhängende Hörgeschichte.';

  @override
  String get reiheTitel => 'Innenansichten';

  @override
  String get reiheEinleitung =>
      'Zusammenhängende Erzählungen von etwa 20 bis 30 Minuten, nicht zum Einschlafen. Sie beschreiben, wie sich Lust von innen anfühlen kann. Jeder Mensch erlebt das anders; nichts davon ist ein Maßstab oder ein Versprechen.';

  @override
  String get reiheFolgen => 'Folge';

  @override
  String get reiheVariante => 'Intensität';

  @override
  String get reiheSoft => 'Soft';

  @override
  String get reiheBilderAnsehen => 'Bilder ansehen';

  @override
  String get reiheGalerieTitel => 'Bilder';

  @override
  String get reiheGalerieLeer => 'Zu dieser Folge gibt es noch keine Bilder.';

  @override
  String get reiheSpicy => 'Spicy';

  @override
  String get reiheSehrSpicy => 'Sehr spicy';

  @override
  String get reihePerspektive => 'Perspektive';

  @override
  String get reihePerspektiveFrau => 'Sie';

  @override
  String get reihePerspektiveMann => 'Er';

  @override
  String reihePartnerHinweis(String name) {
    return 'Die passende Gegenperspektive derselben Begegnung: $name. Beide folgen derselben Szenenfolge. „Gemeinsam hören“ gleicht dieselbe Fassung auf zwei Geräten ab. Unterschiedliche Gegenperspektiven stimmt ihr weiterhin selbst aufeinander ab.';
  }

  @override
  String reihePartnerHinweisDrei(String name) {
    return 'Die beiden anderen Perspektiven derselben Begegnung: $name. Alle drei folgen derselben Szenenfolge. Dreier-Folgen hörst du allein, „Gemeinsam hören“ gibt es dafür nicht.';
  }

  @override
  String reiheDauer(int minuten) {
    return 'Etwa $minuten Minuten';
  }

  @override
  String get reiheStart => 'Starten';

  @override
  String reiheSzene(int n, int m) {
    return 'Szene $n von $m';
  }

  @override
  String get reiheSzeneVor => 'Nächste Szene';

  @override
  String get reiheSzeneZurueck => 'Szene von vorn';

  @override
  String get reiheBeenden => 'Beenden';

  @override
  String get reiheBeendenFrage => 'Die Erzählung stoppen?';

  @override
  String get reiheBeendenText => 'Du kannst später neu beginnen.';

  @override
  String get reiheFertig =>
      'Fertig. Nimm dir einen Moment, bevor du weitermachst.';

  @override
  String get reiheHinweise =>
      'Nur ab achtzehn. Alle Figuren sind erwachsen, alles geschieht einvernehmlich. Nichts davon ist ein Leistungsmaßstab: Erregung, Höhepunkt und Zufriedenheit sind nicht dasselbe, und jeder Körper reagiert anders.';

  @override
  String get reiheLeer => 'Im Paket sind noch keine Folgen.';

  @override
  String get reihePaketFehlt =>
      'Für diese Reihe fehlen noch die Aufnahmen. Sie kommen als eigenes Paket, am besten im WLAN laden. Danach läuft alles ohne Netz.';

  @override
  String get reihePaketLaden => 'Aufnahmen laden';

  @override
  String get kursBildAllein => 'Allein';

  @override
  String get kursBildZuZweit => 'Zu zweit';

  @override
  String get reihePaketNeu =>
      'Es gibt neue Folgen und Bilder für diese Reihe. Am besten im WLAN aktualisieren. Danach läuft alles wieder ohne Netz.';

  @override
  String get reiheLadenFehler =>
      'Laden hat nicht geklappt. Bitte später noch einmal versuchen.';

  @override
  String get reiheOffline => 'Offline verfügbar';

  @override
  String get reiheKeineAufnahme =>
      'Zu dieser Fassung gibt es noch keine Aufnahme; die Geräte-Stimme liest vor.';

  @override
  String get lautsprecherFrageTitel => 'Lautsprecher';

  @override
  String get lautsprecherFrageNachricht =>
      'Die Wiedergabe läuft über den Lautsprecher. Trotzdem abspielen?';

  @override
  String get lautsprecherAbspielen => 'Abspielen';

  @override
  String get lautsprecherAbbrechen => 'Abbrechen';

  @override
  String get lautsprecherNichtMehrFragen => 'Nicht mehr fragen';

  @override
  String get lautsprecherEinstellungFrageTitel =>
      'Vor Lautsprecher-Wiedergabe fragen';

  @override
  String get lautsprecherEinstellungFrageText =>
      'Fragt vor dem Abspielen, wenn keine Kopfhörer angeschlossen sind.';

  @override
  String get lautsprecherEinstellungPauseTitel =>
      'Pausieren, wenn Kopfhörer getrennt werden';

  @override
  String get lautsprecherEinstellungPauseText =>
      'Hält die Wiedergabe an, sobald Kabel- oder Bluetooth-Kopfhörer getrennt werden.';

  @override
  String get realitaetStatusEin => 'Ein';

  @override
  String get realitaetStatusAus => 'Aus';

  @override
  String get halloTitel => 'Einmal anonym Hallo sagen';

  @override
  String get halloErklaerung =>
      'Freiwillig: Wenn du magst, sagst du uns einmal Hallo. Übertragen werden ausschließlich Version und Sprache der App – verschlüsselt und ohne Absender.';

  @override
  String get halloKnopf => 'Hallo sagen';

  @override
  String halloDankeGesendet(String datum) {
    return 'Danke, gesendet am $datum.';
  }

  @override
  String get halloGesendet => 'Danke für dein Hallo!';

  @override
  String get schlafTitel => 'Schlafdaten abgleichen';

  @override
  String get schlafEinladung => 'Deine Nacht im Rückblick';

  @override
  String get schlafErklaerung =>
      'Optional: Bereits synchronisierte Schlafdaten aus Health Connect neben deinen eigenen Beobachtungen ansehen. Keine Live-Erkennung, keine Signale während der Nacht. Die Traumpraxis funktioniert auch ohne Gerät.';

  @override
  String get schlafDatenschutz =>
      'VelvetPulse liest nur Schlafsitzungen der letzten 30 Tage, wenn du den Abgleich ausdrücklich startest. Es schreibt nichts nach Health Connect. Importierte Kopien bleiben lokal und werden in deine Sicherung aufgenommen; keine Weitergabe an dein Gegenüber oder den Paarraum.';

  @override
  String get schlafHinweis =>
      'Aktiviere die Freigabe deiner Schlafdaten in Fitbit bzw. Google Health für Health Connect. Es werden nur Daten angezeigt, die dort tatsächlich verfügbar sind. Schlafphasen sind Schätzungen, keine Diagnose.';

  @override
  String get schlafVerbinden => 'Health Connect verbinden';

  @override
  String get schlafImportieren => 'Letzte 30 Tage abgleichen';

  @override
  String get schlafUebernehmen => 'Ausgewählte Quelle übernehmen';

  @override
  String get schlafQuelle => 'Datenquelle';

  @override
  String get schlafQuelleWaehlen =>
      'Bitte wähle eine Quelle. Aufzeichnungen verschiedener Geräte werden nicht addiert.';

  @override
  String get schlafTrennen => 'Abgleich ausschalten';

  @override
  String get schlafGetrennt =>
      'Abgleich ausgeschaltet. Importierte Daten bleiben erhalten. Die Android-Berechtigung kannst du in Health Connect widerrufen.';

  @override
  String get schlafVerbunden =>
      'Abgleich aktiviert. Daten werden nur auf deinen Wunsch gelesen.';

  @override
  String get schlafBerechtigungFehlt =>
      'Zugriff auf Schlafdaten fehlt. Du kannst ihn in Health Connect erlauben; die übrige Traumpraxis bleibt nutzbar.';

  @override
  String get schlafNichtVerfuegbar =>
      'Dieser optionale Import benötigt Android 14 oder neuer und verfügbares Health Connect. Alle übrigen Übungen bleiben nutzbar.';

  @override
  String get schlafLeer => 'Noch keine Schlafaufzeichnungen importiert.';

  @override
  String get schlafKeineDaten =>
      'Keine abgeschlossenen Schlafsitzungen verfügbar. Prüfe die Synchronisierung und die Freigabe in deiner Quell-App.';

  @override
  String get schlafFehler =>
      'Der Abgleich konnte nicht abgeschlossen werden. Deine bisherigen Daten bleiben erhalten.';

  @override
  String get schlafGespeichert =>
      'Die ausgewählten Schlafdaten wurden übernommen.';

  @override
  String get schlafEinstellungen => 'Android-Berechtigungen';

  @override
  String get schlafLoeschen => 'Importierte Schlafdaten löschen';

  @override
  String get schlafLoeschenFrage =>
      'Alle importierten Schlafdaten aus VelvetPulse löschen? Deine eigenen Tagebuch- und Traumpraxis-Einträge bleiben erhalten. Daten in Health Connect werden nicht gelöscht.';

  @override
  String get schlafAbbrechen => 'Abbrechen';

  @override
  String get schlafZeitfenster => 'Erfasstes Zeitfenster';

  @override
  String get schlafSchlafzeit => 'Schlafzeit laut Phasen';

  @override
  String get schlafUnbekannt => 'Nicht vollständig bestimmbar';

  @override
  String get schlafPhasen => 'Erfasste Phasen';

  @override
  String get schlafWach => 'Wach';

  @override
  String get schlafLeicht => 'Leichtschlaf';

  @override
  String get schlafTief => 'Tiefschlaf';

  @override
  String get schlafRem => 'REM';

  @override
  String get schlafOhnePhase => 'Schlaf ohne Phasenangabe';

  @override
  String get schlafUnbekanntePhase => 'Unbekannt';

  @override
  String get schlafEigeneAngaben => 'Deine Angaben zu diesem Aufwachdatum';

  @override
  String get schlafKeineAngaben =>
      'Noch keine eigene Tagesbeobachtung vorhanden.';

  @override
  String get schlafBeobachtung => 'Tagesbeobachtung öffnen';

  @override
  String get schlafLetzterAbgleich => 'Letzter Abgleich';

  @override
  String get schlafImportierteKopie =>
      'Gespeicherte Kopie. Änderungen oder Löschungen in der Quell-App entfernen diese Kopie nicht automatisch. Hinweise auf einen Zusammenhang sind kein Nachweis einer Wirkung auf Lust oder Träume.';

  @override
  String schlafDauer(int stunden, int minuten) {
    return '$stunden Std. $minuten Min.';
  }

  @override
  String get schlafBlickTitel => 'Was deine Nächte erzählen';

  @override
  String get schlafBlickEinladung =>
      'Ein Traumzeichen bemerkt? Ein Gefühl mit in den Tag genommen? Entdecke deine letzten sieben Tage – mit deinen Erinnerungen und, wenn du möchtest, deinen Schlafdaten.';

  @override
  String get schlafBlickGrenze =>
      'Deine Angaben erzählen vom Erleben. Die Uhr liefert Schlafschätzungen. Daraus wird kein Klartraum oder Orgasmus erkannt. Tagebucheinträge werden nach ihrem Eintragsdatum zugeordnet.';

  @override
  String get schlafBlickWoche => 'Deine letzten sieben Tage';

  @override
  String get schlafBlickKlar => 'Klarheit im Traum notiert';

  @override
  String get schlafBlickErinnert => 'Traumerinnerung notiert';

  @override
  String get schlafBlickSinnlich => 'Sinnlicher Traum notiert';

  @override
  String get schlafBlickHoehepunkt => 'Höhepunkt im Traum notiert';

  @override
  String get schlafBlickOhneErinnerung =>
      'Nichts erinnert – auch das gehört dazu';

  @override
  String get schlafBlickUnbekannt => 'Noch keine Traumangabe';

  @override
  String get schlafBlickOhneMessung => 'Ohne Schlafmessung';

  @override
  String get schlafBlickMehrere =>
      'Mehrere Schlafaufzeichnungen – einzeln unter Messwerten ansehen';

  @override
  String get schlafBlickNacht => 'Diese Nacht festhalten';

  @override
  String get schlafBlickNaechster => 'Deine nächste Entdeckung';

  @override
  String get schlafBlickStart =>
      'Beginne mit einem kleinen Rest Erinnerung: ein Bild, eine Stimmung, ein Ort. Daraus kann dein persönliches Traumzeichen entstehen.';

  @override
  String get schlafBlickUeben =>
      'Du hast bereits etwas festgehalten. Schau nach einem ungewöhnlichen Detail und nimm es als ruhige Absicht in deine nächste Abendpraxis mit.';

  @override
  String get schlafBlickVertiefen =>
      'Du hast Klarheit im Traum notiert. Was möchtest du beim nächsten Mal bewusst wahrnehmen? Deine Traumpraxis lässt Raum für Sinnlichkeit und das Nachspüren am Tag.';

  @override
  String get schlafBlickRuhe =>
      'Deine letzten Einträge sprechen für eine Pause. Heute darf Erholung genügen. Du musst keine neue Übung oder nächtliche Unterbrechung hinzufügen.';

  @override
  String get schlafBlickPraxis => 'Traumpraxis entdecken';

  @override
  String get schlafBlickHeute => 'Heute';

  @override
  String get schlafBlickGestern => 'Gestern';

  @override
  String schlafBlickGeschlafen(String dauer) {
    return 'Geschlafen: $dauer';
  }

  @override
  String schlafBlickImBett(String dauer) {
    return 'Im Bett: $dauer';
  }

  @override
  String get schlafBlickKeineBesonderheiten => 'Nichts Besonderes notiert';

  @override
  String get schlafBlickAendern => 'Angaben ansehen oder ändern';

  @override
  String get schlafBlickNochNichts => 'Noch nichts festgehalten';

  @override
  String get schlafMesswerte => 'Schlafdaten verbinden und Messwerte ansehen';

  @override
  String schlafBlickBilanz(int klar, int tage) {
    return '$klar von $tage Tagen mit eigenen Angaben enthalten einen berichteten Klartraum. Das ist ein Rückblick, kein Leistungsziel.';
  }

  @override
  String get ersteWocheEyebrow => 'Eure erste Woche';

  @override
  String get ersteWocheEinstieg =>
      'Sieben kleine Schritte, jeder höchstens eine Viertelstunde. Ihr müsst keinen davon machen, und keiner ist eine Prüfung. Zu jedem gibt es ein „Heute nicht“.';

  @override
  String ersteWocheSchrittMin(int n, int min) {
    return 'Schritt $n · ca. $min Min.';
  }

  @override
  String ersteWocheSchrittNr(int n) {
    return 'Schritt $n';
  }

  @override
  String get ersteWocheAnsehen => 'Ansehen';

  @override
  String get ersteWocheHeuteNicht => 'Heute nicht';

  @override
  String get ersteWocheHeuteNichtAntwort =>
      'Alles gut. Der Schritt wartet, ohne dass etwas verfällt.';

  @override
  String get ersteWocheZugeklappt => 'Eure erste Woche wartet, ohne Eile.';

  @override
  String get ersteWocheMenue => 'Mehr';

  @override
  String get ersteWocheUeberspringen => 'Diesen Schritt überspringen';

  @override
  String get ersteWocheAusblenden => 'Ausblenden';

  @override
  String get ersteWocheWiederZeigen => 'Eure erste Woche wieder zeigen';

  @override
  String ersteWocheLangePause(int n) {
    return 'Weiter mit Schritt $n, wenn ihr mögt';
  }

  @override
  String get ersteWocheGeschafft => 'Eure erste Woche liegt hinter euch';

  @override
  String get ersteWocheZumAbend => 'Weiter mit dem Gemeinsamen Abend';

  @override
  String get ersteWocheGutSo => 'Das reicht mir';

  @override
  String ersteWochePunktOffen(int n) {
    return 'Schritt $n: offen';
  }

  @override
  String ersteWochePunktGetan(int n) {
    return 'Schritt $n: gemacht';
  }

  @override
  String ersteWochePunktUebersprungen(int n) {
    return 'Schritt $n: übersprungen';
  }

  @override
  String get ersteWocheGemacht => 'Haben wir gemacht';

  @override
  String get ersteWocheLektionOeffnen => 'Lektion öffnen';

  @override
  String get ersteWocheLandkarteOeffnen => 'Fantasie-Landkarte öffnen';

  @override
  String get ersteWocheAlleBereiche => 'Alle Bereiche ansehen';

  @override
  String get ersteWocheAlternative => 'Lieber jede Person für sich';

  @override
  String get ersteWocheFragen => 'Zwei Fragen genügen';

  @override
  String get ersteWocheFrage1 => 'Was war schön?';

  @override
  String get ersteWocheFrage2 => 'Was machen wir davon wieder?';

  @override
  String get ersteWocheWeiterMenue => 'Ein Menü für eure Wünsche';

  @override
  String get ersteWocheWeiterTitel => 'Wenn ihr mögt, geht es so weiter';

  @override
  String get ersteWocheNichtVerfuegbar => 'Das ist gerade nicht verfügbar.';

  @override
  String get ersteWocheSagenWo => 'Sagen, wo ich bin';

  @override
  String ersteWocheNachricht(int n) {
    return 'Ich habe Schritt $n gemacht. Wenn du magst, schau dir den nächsten an. Kein Druck.';
  }

  @override
  String get ersteWocheNachrichtTitel => 'Das schicken?';

  @override
  String get ersteWocheNachrichtHinweis =>
      'Du kannst den Text ändern. Gesendet wird erst, wenn du auf „Senden“ tippst.';

  @override
  String get ersteWocheAbbrechen => 'Abbrechen';

  @override
  String get ersteWocheSenden => 'Senden';

  @override
  String get ersteWocheS1Titel => 'Ein Wort, das alles anhält';

  @override
  String get ersteWocheS1Text =>
      'Hilfreich, bevor etwas anderes kommt: ein Wort, das alles sofort anhält. Die Lektion zeigt eine Ampel für Wünsche und Grenzen. Wenn ihr mögt, verabredet ihr danach ein Wort für „Stopp“. Wer weiß, dass Stopp immer gilt, kann sich auf alles Weitere leichter einlassen.';

  @override
  String get ersteWocheS2Titel => 'Zusammen atmen';

  @override
  String get ersteWocheS2Text =>
      'Ankommen, ohne dass eine Berührung etwas will. Wenn ihr mögt, atmet ihr ein paar Minuten im gleichen Takt, der Taktgeber hilft dabei. Möchtet ihr noch nicht eng beieinander liegen, geht es auch jede Person für sich mit einer kurzen Audio-Übung.';

  @override
  String get ersteWocheS3Titel => 'Warum Druck keine Schuld ist';

  @override
  String get ersteWocheS3Text =>
      'Viele Paare spüren Druck, wenn es um Nähe geht, und halten das für ihre Schuld. Die Lektion erklärt Gaspedal und Bremse im Körper: Das ist kein Defekt, so arbeitet jeder Körper. Wenn ihr mögt, lest sie jede Person für sich. Danach muss niemand darüber sprechen.';

  @override
  String get ersteWocheS4Titel => 'Berührung ohne Ziel';

  @override
  String get ersteWocheS4Text =>
      'Wenn ihr mögt: Berührung, bekleidet und ohne Ziel, zum Beispiel Rücken, Schultern, Arme, Hände, Füße. Nichts muss daraus werden, und jede Person kann jederzeit „Stopp“ sagen. Etwa 10 bis 15 Minuten, ihr entscheidet.';

  @override
  String get ersteWocheS5Titel => 'Wünsche leise sammeln';

  @override
  String get ersteWocheS5Text =>
      'Nach der Berührung wisst ihr vielleicht ein wenig besser, was sich gut anfühlt. In der Fantasie-Landkarte ist nur die ruhige Kategorie „Sinnlichkeit & Sinne“ gemeint. Jede Person antwortet für sich, das geht auch allein. Gezeigt wird nur, was ihr beide mögt.';

  @override
  String get ersteWocheS6Titel => 'Ein Satz, der leicht fällt';

  @override
  String get ersteWocheS6Text =>
      'Ein Gespräch fällt leichter, wenn Ruhe und Vertrauen da sind. Sucht euch aus der Lektion einen der drei Satzbausteine aus und sagt ihn, wenn ihr mögt. Mehr braucht es nicht, es ist kein Problemgespräch.';

  @override
  String get ersteWocheS7Titel => 'Rückblick ohne Bewertung';

  @override
  String get ersteWocheS7Text =>
      'Zum Schluss ein Blick zurück, ohne Zeugnis. Zwei Fragen genügen, antwortet laut oder nur für euch, ganz wie es sich anfühlt. Danach könnt ihr weitermachen, wenn ihr mögt, oder es einfach gut sein lassen.';

  @override
  String heutePaarDuUnd(Object name) {
    return 'Du und $name';
  }

  @override
  String get heutePaarEyebrow => 'Für euch';

  @override
  String get heutePaarTitel => 'Heute zu zweit';

  @override
  String get heutePaarAbendMeta => 'In eurem Tempo, mit einer Stimme';

  @override
  String get heutePaarAudios => 'Audios für euch';

  @override
  String get heutePaarAudiosMeta => 'Zu zweit hören';

  @override
  String heutePaarWir(Object name) {
    return 'Wir: eine Nachricht oder ein Funke an $name';
  }

  @override
  String get heutePaarEinladen => 'Dein Gegenüber einladen';

  @override
  String get heutePaarSchonCode => 'Schon einen Code?';

  @override
  String get heutePaarVerbinden => 'Verbinden';

  @override
  String get heutePaarMehrAllein => 'Mehr für dich allein';

  @override
  String get heutePaarWegMeta => 'Du bist mitten in einem Weg';

  @override
  String get ersteWocheUnterzeileVorsichtig =>
      'Wenn ihr beide mögt – ein Nein ist vollwertig';

  @override
  String get appSperreNeuTitel => 'Nur für dich';

  @override
  String get appSperreNeuText =>
      'VelvetPulse öffnet sich nur mit deiner Gerätesperre, also mit Fingerabdruck, Gesicht, PIN oder Muster. So bleibt bei dir, was du hier erkundest. Im Profil kannst du das jederzeit ändern.';

  @override
  String get appSperreNeuOk => 'Gut so';

  @override
  String get appSperreFrageTitel => 'VelvetPulse nur für dich öffnen?';

  @override
  String get appSperreFrageText =>
      'Dann fragt die App beim Öffnen und nach einer kurzen Pause nach deiner Gerätesperre. So liest niemand mit, wenn dein Handy mal herumliegt.';

  @override
  String get appSperreFrageJa => 'Ja, sperren';

  @override
  String get appSperreFrageNein => 'Nicht jetzt';

  @override
  String get appSperreKeineTitel =>
      'Dein Handy hat noch keine Bildschirmsperre';

  @override
  String get appSperreKeineText =>
      'Richte in den Android-Einstellungen eine PIN, ein Muster oder einen Fingerabdruck ein (meist unter „Sicherheit“ oder „Sperrbildschirm“). Danach kannst du im Profil die App-Sperre einschalten.';

  @override
  String get appSperreKeineOk => 'Verstanden';

  @override
  String get fantasieHinweisTitel => 'Deine Fantasie gehört dir';

  @override
  String get fantasieHinweisText =>
      'Eine Fantasie ist kein Wunsch, den du erfüllen musst, und kein Urteil über deine Beziehung. Was dir hier in den Sinn kommt, darf einfach da sein. Ob, was und wann du davon teilst, entscheidest du.';

  @override
  String get fantasieHinweisDrei =>
      'Auch eine Szene zu dritt heißt nicht, dass deiner Beziehung etwas fehlt.';

  @override
  String get fantasieHinweisOk => 'Gut zu wissen';

  @override
  String get spicyAbgelaufenTitel => 'Spicy-Modus ist aus';

  @override
  String get spicyAbgelaufenText =>
      'Die App war länger als 5 Stunden im Hintergrund. Damit niemand mitliest, der dein Handy in die Hand nimmt, wurde der Spicy-Modus ausgeschaltet. Deine Einstellungen und Inhalte bleiben, wie sie sind.';

  @override
  String get spicyAbgelaufenEntsperren => 'Wieder entsperren';

  @override
  String get spicyAbgelaufenSpaeter => 'Später';

  @override
  String get trennungDialog1Titel => 'Verbindung trennen?';

  @override
  String trennungDialog1(Object name) {
    return 'Auf diesem Handy werden der Verlauf mit $name, die Antworten von $name und die geteilten Reflexionen gelöscht. Deine eigenen Antworten bleiben.\n\nAuf dem Handy von $name bleibt, was dort liegt, bis die Person selbst löscht.';
  }

  @override
  String get trennungDialog1Weiter => 'Weiter';

  @override
  String get trennungDialog2Titel => 'Wirklich trennen?';

  @override
  String get trennungDialog2 =>
      'Das lässt sich nur rückgängig machen, indem ihr euch neu koppelt.';

  @override
  String get trennungDialog2Ja => 'Ja, trennen';

  @override
  String trennungNichtGesendet(Object name) {
    return 'Getrennt. Der Hinweis an $name ist nicht angekommen. Auf dem Handy von $name bleibt alles, bis die Person selbst löscht.';
  }

  @override
  String trennungHinweis(Object name) {
    return '$name hat die Verbindung getrennt. Du musst nichts tun, und es eilt nichts. Der Chat bleibt hier lesbar, solange du magst.';
  }

  @override
  String get trennungSchalter =>
      'Auch auf diesem Handy trennen und die Daten dieser Verbindung löschen';

  @override
  String get trennungGegenueberDialog1Titel => 'Auf diesem Handy trennen?';

  @override
  String trennungGegenueberDialog1(Object name) {
    return 'Auf diesem Handy werden der Verlauf mit $name, die Antworten von $name und die geteilten Reflexionen gelöscht. Deine eigenen Antworten bleiben.\n\nDu kannst auch warten. Erst wenn du bestätigst, wird etwas gelöscht.';
  }

  @override
  String get trennungGegenueberDialog2Titel => 'Wirklich löschen?';

  @override
  String get trennungGegenueberDialog2 => 'Das lässt sich nicht zurückholen.';

  @override
  String get trennungGegenueberLoeschenJa => 'Ja, löschen';

  @override
  String get trennungGegenueberFertig => 'Auf diesem Handy getrennt.';

  @override
  String get trennungSatzAelter => 'Die Verbindung wurde getrennt.';

  @override
  String get spicyEinladungNein => 'Gerade nicht';

  @override
  String get spicyNeinSatz => 'Gerade nicht, danke dir.';

  @override
  String get spicyEinladungNeinAntwort =>
      'Danke, dass du es mir sagst. Es eilt nichts.';

  @override
  String get spicyEinladungNeinGesendet =>
      'Du hast geantwortet. Du kannst es dir jederzeit anders überlegen.';

  @override
  String get funkeDanke => 'Danke fürs Sagen';

  @override
  String get funkeTippNein =>
      'Ein Nein heute ist kein Nein zu dir. Du musst nichts nachfragen.';

  @override
  String get funkeTippReden =>
      'Du musst nicht sofort antworten. Sag, wann es für dich passt.';

  @override
  String get funkeTippLabel => 'Nur für dich';

  @override
  String trennungHinweisSenden(Object name) {
    return 'Hinweis an $name senden';
  }

  @override
  String get trennungHinweisInfoAn =>
      'Kommt er nicht an (App geschlossen, kein Netz), bleibt dort alles unverändert.';

  @override
  String trennungHinweisInfoAus(Object name) {
    return '$name erfährt nichts von der Trennung. Auf dem Handy von $name bleibt alles, bis die Person selbst löscht.';
  }

  @override
  String get trennungHilfe => 'Brauchst du Unterstützung?';

  @override
  String funkeDankeAntwort(Object name) {
    return '$name: Danke fürs Sagen.';
  }

  @override
  String get fotoHinweisTrennung =>
      'Gesendete Fotos bleiben auf dem Handy des anderen, auch wenn ihr euch später trennt.';

  @override
  String get yesNoMaybeInfoZeile => 'Wie das hier funktioniert';

  @override
  String lektionEyebrow(Object durationMin) {
    return 'Lektion · $durationMin Min.';
  }

  @override
  String lektionEyebrowAudio(Object durationMin) {
    return 'Audio-Übung · $durationMin Min.';
  }
}
