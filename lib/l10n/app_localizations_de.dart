// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
  String get mainNavigationProgrammeCourses => 'Programm & Kurse';

  @override
  String get mainNavigationSomaticsTraining => 'Somatik & Training';

  @override
  String get mainNavigationCbtReframing => 'KVT-Reframing';

  @override
  String get mainNavigationCoupleChannel => 'Paar-Kanal';

  @override
  String get mainNavigationAiCoach => 'KI-Coach';

  @override
  String get mainNavigationCourses => 'Kurse';

  @override
  String get mainNavigationTraining => 'Training';

  @override
  String get mainNavigationReframing => 'Reframing';

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
  String get coursesForHer => 'Für Sie 🌸';

  @override
  String get coursesForHim => 'Für Ihn 🌿';

  @override
  String get coursesForCouples => 'Für Paare 💫';

  @override
  String get coursesCoupleChannel => 'PAAR-KANAL';

  @override
  String get coursesYourPrivateSpace => 'Euer privater Raum';

  @override
  String get coursesSendSparksSecretlyMatchWishes =>
      'Funken senden & Wünsche heimlich abgleichen';

  @override
  String get coursesYourCurriculum => 'DEIN CURRICULUM';

  @override
  String coursesHelloProfilename(Object profileName) {
    return 'Hallo, $profileName';
  }

  @override
  String get coursesWelcome => 'Willkommen';

  @override
  String coursesYourFocusGoallabel(Object goalLabel) {
    return 'Dein Fokus: $goalLabel';
  }

  @override
  String get coursesUnderstandTheBiologyQuietThe =>
      'Biologie verstehen. Kopfkino stoppen. Körper spüren.';

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
  String get coursesPracticeCbt => 'Praxis: KVT';

  @override
  String get lessonDetailLessonMarkedAsCompleted =>
      'Lektion als abgeschlossen markiert! 🎉';

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
      'Atem-Pacer (Down-Regulation) starten';

  @override
  String get lessonDetailCalmDownWithBreathingOr =>
      'Vagusnerv aktivieren & Adrenalin senken mit 4-7-8 oder Seufzer';

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
  String get sosModalSosQuickHelp => 'SOS Akut-Hilfe';

  @override
  String get sosModalCalmDownRightNowEmergency =>
      'Sofortige Down-Regulation & Notfall-Schritte';

  @override
  String get sosModalBefore => 'Vorab';

  @override
  String get sosModalInTheMoment => 'Im Moment';

  @override
  String get sosModalAfterwards => 'Danach';

  @override
  String get sosModalYourMantraForThisMoment => 'DEIN MANTRA FÜR DIESEN MOMENT';

  @override
  String sosModalMantra(Object mantra) {
    return '„$mantra“';
  }

  @override
  String get sosModalImmediateStepsTickOff => 'SOFORT-SCHRITTE (ABHAKEN)';

  @override
  String sosModalCheckedlengthImmediatestepslengthDone(
      Object checkedLength, Object immediateStepsLength) {
    return '$checkedLength/$immediateStepsLength erledigt';
  }

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
}
