// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gemeinsamWiedergabeFehler =>
      'Playback could not start. Check the recordings and audio output, then try again.';

  @override
  String get gemeinsamZurueckziehen => 'Withdraw invitation';

  @override
  String get aufnahmePaketFehlt =>
      'The matching content package needs to be downloaded.';

  @override
  String get wiedergabeStimmenStand => 'Recordings for this voice';

  @override
  String get gemeinsamAntwortZuLang =>
      'Your reflection is too long. Please shorten it a little and try again.';

  @override
  String get gemeinsamGefuehlRuhig => 'Calm';

  @override
  String get gemeinsamGefuehlNah => 'Connected';

  @override
  String get gemeinsamGefuehlOffen => 'Still open';

  @override
  String get gemeinsamGefuehlBewegt => 'Moved';

  @override
  String get gemeinsamTitel => 'Shared activity';

  @override
  String get gemeinsamHinweis =>
      'Listen to the same sequence on your own devices. You both need matching recordings and must confirm you are ready. Headphones may feel comfortable. Either person can pause; continuing needs both of you to be ready again. An invitation starts the sequence from the beginning.';

  @override
  String get gemeinsamAnnehmen => 'Accept';

  @override
  String get gemeinsamSpaeter => 'Later';

  @override
  String get gemeinsamWarten => 'You are ready. Waiting for your partner.';

  @override
  String get gemeinsamBereitHinweis =>
      'Get comfortable, then confirm that you are ready.';

  @override
  String get gemeinsamBereit => 'Ready';

  @override
  String get gemeinsamPlayer => 'Open playback';

  @override
  String get gemeinsamRueckblick => 'Shared reflection';

  @override
  String get gemeinsamBeenden => 'End for both';

  @override
  String get gemeinsamSchliessen => 'Close';

  @override
  String get gemeinsamEinladung => 'An invitation is waiting for you.';

  @override
  String get gemeinsamVorbereiten => 'Get ready at your own pace';

  @override
  String get gemeinsamWartenAnnahme => 'Waiting for your partner.';

  @override
  String get gemeinsamLaeuft => 'You are listening together.';

  @override
  String get gemeinsamPause =>
      'Paused. Continue only when both of you are ready.';

  @override
  String get gemeinsamAbgeschlossen => 'Your shared moment has ended.';

  @override
  String get gemeinsamAufnahmenFehlen =>
      'Matching recordings are missing or differ. Both of you should download the current recordings, then send a new invitation. Shared listening never uses the device voice.';

  @override
  String get gemeinsamPartnerFehlt =>
      'Your partner is unavailable, already busy or needs a current app version. Both of you should open the couple channel and try again.';

  @override
  String get gemeinsamFehler =>
      'The connection did not work. Please try again.';

  @override
  String get gemeinsamLeer => 'Choose “Listen together” during playback.';

  @override
  String get gemeinsamStatusOeffnen => 'Open shared activity';

  @override
  String get gemeinsamStarten => 'Listen together';

  @override
  String get gemeinsamDuEmpfaengst => 'You receive, your partner gives.';

  @override
  String get gemeinsamVerbindungFehlt =>
      'The connection to your partner has been interrupted. Your recording continues locally. You can pause at any time; reconnecting never starts playback automatically.';

  @override
  String get gemeinsamRueckblickFrage => 'How did this moment feel for you?';

  @override
  String get gemeinsamRueckblickHinweis =>
      'Reflection is optional. Your partner’s answer becomes visible only after both of you have shared your own answer.';

  @override
  String get gemeinsamAntwort => 'Your reflection';

  @override
  String get gemeinsamTeilen => 'Save and share answer';

  @override
  String get gemeinsamGeteilt => 'Your reflection has been shared.';

  @override
  String get gemeinsamNochVerdeckt => 'The shared reflection is still hidden.';

  @override
  String gemeinsamCountdown(int sekunden) {
    return 'Starting together in $sekunden';
  }

  @override
  String get wiedergabeNeutral => 'Playback';

  @override
  String get wiedergabeLeer => 'No accessible playback selected.';

  @override
  String get wiedergabeBehalten =>
      'You can close this page and keep exploring while you listen.';

  @override
  String get wiedergabeTts =>
      'Device voice: resuming restarts this section from the beginning.';

  @override
  String get wiedergabeFehler =>
      'Playback could not continue. Check the recordings and try again.';

  @override
  String get wiedergabeFertig => 'Complete for this moment.';

  @override
  String get wiedergabeTeilweise =>
      'Some recordings are not available offline. The device voice reads missing sections.';

  @override
  String get wiedergabeAbschnitte => 'Sections';

  @override
  String get wiedergabeRuhe => 'Rest & reflect';

  @override
  String get wiedergabeEntfernen => 'Remove from continue listening';

  @override
  String get wiedergabeLaeuft => 'Playing';

  @override
  String get wiedergabeFortsetzen => 'Continue listening';

  @override
  String wiedergabeRunde(int runde) {
    return 'Round $runde';
  }

  @override
  String get sucheTitel => 'Explore & find';

  @override
  String get aufnahmeOffline => 'Recording available offline';

  @override
  String get wegTitel => 'Your personal path';

  @override
  String get wegEinladung =>
      'Learn, explore, reflect. Three optional steps at your own pace, with no time limit or required answer.';

  @override
  String get wegWissen => 'Discover the knowledge';

  @override
  String get wegUeben => 'Try the exercise';

  @override
  String get wegNachspueren => 'Reflect';

  @override
  String get wegBeginnen => 'Begin this path';

  @override
  String get wegNochEinmal => 'Explore again';

  @override
  String get wegOeffnen => 'Open step';

  @override
  String get wegWeiter => 'Go to the next step';

  @override
  String get wegAbschliessen => 'Finish for now';

  @override
  String get wegFehler => 'Your progress could not be saved. Please try again.';

  @override
  String get aufnahmeGeraetestimme => 'Without recording: device voice';

  @override
  String get aufnahmeVerwalten => 'Download recordings';

  @override
  String get sucheFeld => 'Search courses, lessons and exercises';

  @override
  String get sucheLeeren => 'Clear search';

  @override
  String get sucheHinweis =>
      'What would you like to explore? Search for a topic or an activity. Your search stays on this device and is not saved.';

  @override
  String get sucheLeer => 'Nothing found. Try a different word.';

  @override
  String get sucheFehler =>
      'The content could not be loaded. Please reopen the search.';

  @override
  String get sucheKurs => 'Course';

  @override
  String get sucheLektion => 'Lesson';

  @override
  String get sucheAngebot => 'Audio & practice';

  @override
  String get suchePaarAbend => 'Guided evening together';

  @override
  String get sucheInnenansichten => 'Inner perspectives';

  @override
  String get appName => 'VelvetPulse';

  @override
  String get spracheTitel => 'Language';

  @override
  String get spracheAutomatisch => 'Automatic (like the device)';

  @override
  String get spracheDeutsch => 'Deutsch';

  @override
  String get spracheEnglisch => 'English';

  @override
  String get mainNavigationProgrammeCourses => 'Today';

  @override
  String get mainNavigationSomaticsTraining => 'Body & practice';

  @override
  String get mainNavigationCbtReframing => 'Thoughts';

  @override
  String get mainNavigationCoupleChannel => 'Couple channel';

  @override
  String get mainNavigationCourses => 'Today';

  @override
  String get mainNavigationTraining => 'Body';

  @override
  String get mainNavigationReframing => 'Thoughts';

  @override
  String get whatsNewWelcomeBack => 'Welcome back';

  @override
  String whatsNewThisIsNewInVersion(Object version) {
    return 'This is new in version $version.';
  }

  @override
  String get whatsNewLetSGo => 'Let\'s go';

  @override
  String get playerSteuerungStop => 'Stop';

  @override
  String get playerSteuerungResume => 'Resume';

  @override
  String get playerSteuerungPause => 'Pause';

  @override
  String get playerSteuerungPause2 => 'Pause';

  @override
  String get playerSteuerungSkip => 'Skip';

  @override
  String get ausspracheMeldenWordMispronounced => 'Word mispronounced?';

  @override
  String get ausspracheMeldenThanksForHelpingTheReport =>
      'Thanks for helping! The report is posted publicly on GitHub and needs an account there. It is visible under your account name.\n\nOnly the place in the audio and the voice are passed on. You enter the word yourself.';

  @override
  String get ausspracheMeldenCancel => 'Cancel';

  @override
  String get ausspracheMeldenContinueToGithub => 'Continue to GitHub';

  @override
  String get ausspracheMeldenTheBrowserCouldNotBe =>
      'The browser could not be opened.';

  @override
  String get updateDialogYouHaveTheLatestVersion =>
      'You have the latest version.';

  @override
  String get updateDialogPleaseAllowTheAppTo =>
      'Please allow the app to install updates in the next step, then tap again.';

  @override
  String get updateDialogTheDownloadedFileIsDamaged =>
      'The downloaded file is damaged. Please try again later.';

  @override
  String updateDialogTheUpdateDidnTWork(Object statusName) {
    return 'The update didn\'t work ($statusName). Please try again later.';
  }

  @override
  String get updateDialogDownloadFailedPleaseCheckYour =>
      'Download failed. Please check your internet connection.';

  @override
  String updateDialogNewBetaVersion(Object version) {
    return 'New beta $version';
  }

  @override
  String updateDialogNewVersionVersion(Object version) {
    return 'New version $version';
  }

  @override
  String get updateDialogImprovementsAndBugFixes =>
      'Improvements and bug fixes.';

  @override
  String updateDialogDownloadingProgress(Object progress) {
    return 'Downloading … $progress %';
  }

  @override
  String get updateDialogYourDataIsKeptDuring =>
      'Your data is kept during the update.';

  @override
  String get updateDialogLater => 'Later';

  @override
  String get updateDialogUpdateNow => 'Update now';

  @override
  String get coursesAllCourses => 'All courses';

  @override
  String get coursesTouch => 'Touch';

  @override
  String get coursesForHer => 'With a vulva';

  @override
  String get coursesForHim => 'With a penis';

  @override
  String get coursesForCouples => 'Together';

  @override
  String get coursesKoerperHilfe =>
      'Courses about body knowledge. You can look at both.';

  @override
  String get coursesCoupleChannel => 'COUPLE CHANNEL';

  @override
  String get coursesYourPrivateSpace => 'Your private space';

  @override
  String get coursesSendSparksSecretlyMatchWishes =>
      'Send sparks & compare wishes, only what you both want becomes visible';

  @override
  String get coursesYourCurriculum => 'YOUR COURSES';

  @override
  String coursesHelloProfilename(Object profileName) {
    return 'Hello, $profileName';
  }

  @override
  String get coursesWelcome => 'Welcome';

  @override
  String get heuteNaechsterSchritt => 'Your next step';

  @override
  String get heuteStarten => 'Start';

  @override
  String get heuteWeitermachen => 'Continue';

  @override
  String heuteKursUndDauer(String kurs, int min) {
    return '$kurs · $min min';
  }

  @override
  String get heuteAllesErledigt =>
      'You\'ve finished every lesson. Browse the courses or listen to an audio.';

  @override
  String get heuteBleibtLokal => 'Stays on your phone';

  @override
  String get heuteReiterCheckin => 'Check-in';

  @override
  String get heuteReiterFunke => 'Spark';

  @override
  String get heuteKurse => 'Courses';

  @override
  String get wuenscheSzenenTitel => 'Scenes to try';

  @override
  String get wuenscheSzenenText =>
      'Whole evenings instead of single questions. Answer separately, as on the map. Spicy mode only.';

  @override
  String get wuenscheBesprechenTitel => 'To talk about';

  @override
  String get wuenscheBesprechenText =>
      'At least one of you said “Maybe”. Talk briefly about what you can imagine.';

  @override
  String get onboardingLosGehts => 'Get started';

  @override
  String get onboardingWeiter => 'Next';

  @override
  String get onboardingZurueck => 'Back';

  @override
  String get onboardingOk => 'OK';

  @override
  String get onboardingMehrDatenschutz => 'More about privacy';

  @override
  String get onboardingVersprechenLokal =>
      'Everything stays on your phone: profile, journal and progress.';

  @override
  String get onboardingVersprechenKeinKonto =>
      'No account, no ads, no tracking.';

  @override
  String get onboardingVersprechenNetz =>
      'Only what you switch on yourself goes online: the couple channel, downloading recordings and the search for updates.';

  @override
  String get onboardingEingeladenLink => 'Someone invited me';

  @override
  String get onboardingEingeladenTitel1 => 'Glad you\'re here';

  @override
  String get onboardingEingeladenText1 =>
      'Someone who matters to you has invited you to try VelvetPulse. It\'s a quiet place for closeness, body and conversation, to read, listen and practise, alone or together. You don\'t need to be good at anything or achieve anything.';

  @override
  String get onboardingEingeladenTitel2 => 'No is always an answer';

  @override
  String get onboardingEingeladenText2 =>
      'Nothing here is an assignment. Every step has a “Not today”, and it has no consequences. Your answers stay with you until you connect. Even then, your partner can\'t see what you look at, try or skip, only what you send yourself. Two exceptions: with wishes, you both only see where you match, and in the chat your partner can see whether you\'ve read their messages (can be switched off).';

  @override
  String get onboardingEingeladenTitel3 => 'Your data stays on your phone';

  @override
  String get onboardingEingeladenText3 =>
      'No account, no ads, no tracking. You can stop at any time, close the app or remove it completely. Connecting with the person who invited you can happen later, and only if you like.';

  @override
  String get onboardingEingeladenEinrichten =>
      'Set up (five short questions, all optional)';

  @override
  String get onboardingEingeladenVerbinden => 'Connect with the person';

  @override
  String get onboardingEingeladenNurSchauen => 'I\'ll just have a look';

  @override
  String onboardingSchritt(int n, int gesamt) {
    return 'Question $n of $gesamt';
  }

  @override
  String get heuteAlleKurse => 'Browse all courses';

  @override
  String get navLernen => 'Learn';

  @override
  String get navUeben => 'Practice';

  @override
  String get navWir => 'Us';

  @override
  String get uebenKoerper => 'Body';

  @override
  String get uebenGedanken => 'Thoughts';

  @override
  String coursesYourFocusGoallabel(Object goalLabel) {
    return 'Your focus: $goalLabel';
  }

  @override
  String get coursesUnderstandTheBiologyQuietThe =>
      'Understand what\'s happening in you. Settle. Feel your body.';

  @override
  String get coursesProfileSettings => 'Profile & settings';

  @override
  String coursesOverallProgressCompletedcountOfTotallessons(
      Object completedCount, Object totalLessons) {
    return 'Overall progress: $completedCount of $totalLessons lessons';
  }

  @override
  String coursesDurationminMin(Object durationMin) {
    return '$durationMin min';
  }

  @override
  String get coursesPracticePelvicFloor => 'Practice: pelvic floor';

  @override
  String get coursesPracticeBreath => 'Practice: breath';

  @override
  String get coursesPracticeCbt => 'Practice: thoughts';

  @override
  String get lessonDetailLessonMarkedAsCompleted =>
      'Lesson marked as completed!';

  @override
  String get lessonDetailLessonMarkedAsOpenAgain =>
      'Lesson marked as open again.';

  @override
  String lessonDetailLessonSentToPartnername(Object partnerName) {
    return 'Lesson sent to $partnerName.';
  }

  @override
  String get lessonDetailSendingDidnTWorkPlease =>
      'Sending didn\'t work. Please try again in a moment.';

  @override
  String lessonDetailYourThoughtsAreWithPartnername(Object partnerName) {
    return 'Your thoughts are with $partnerName. They become visible once there is an answer there too.';
  }

  @override
  String lessonDetailNameHasAlreadyAnswered(Object name) {
    return '$name has already answered';
  }

  @override
  String lessonDetailNameSThoughts(Object name) {
    return '$name\'s thoughts';
  }

  @override
  String lessonDetailWriteAndSaveYourOwn(Object name) {
    return 'Write and save your own answer first, then you\'ll see $name\'s.';
  }

  @override
  String lessonDetailShareWithPartnername(Object partnerName) {
    return 'Share with $partnerName';
  }

  @override
  String get lessonDetailCompleted => 'Completed';

  @override
  String get lessonDetailMarkAsCompleted => 'Mark as completed';

  @override
  String get lessonDetailAudioExercise => 'AUDIO EXERCISE';

  @override
  String get lessonDetailLesson => 'LESSON';

  @override
  String lessonDetailDurationminMinRead(Object durationMin) {
    return '$durationMin min read';
  }

  @override
  String get lessonDetailLessonCompletedDone => 'Lesson completed (done)';

  @override
  String get lessonDetailMarkLessonAsCompleted => 'Mark lesson as completed';

  @override
  String get lessonDetailOpenPelvicFloorTimer => 'Open pelvic floor timer';

  @override
  String get lessonDetailGoStraightIntoRelaxationStrengthening =>
      'Go straight into relaxation & strengthening practice';

  @override
  String get lessonDetailStartBreathPacerDownRegulation =>
      'Start the breathing guide';

  @override
  String get lessonDetailCalmDownWithBreathingOr =>
      'Calm down with 4-7-8 breathing or the sigh';

  @override
  String get lessonDetailMyDesireProfile => 'My desire profile';

  @override
  String get lessonDetailTickWhatYouLikeAnd =>
      'Tick what you like – and send it to your partner if you want';

  @override
  String get lessonDetailGuidedSelfExploration => 'Guided self-exploration';

  @override
  String get lessonDetailToMinutesAVoiceGuides =>
      '10 to 30 minutes, a voice guides you – as close as you like';

  @override
  String get lessonDetailStartCbtThoughtRecord => 'Start CBT thought record';

  @override
  String get lessonDetailReframeAnticipatoryAnxietyAndCatastrophic =>
      'Reframe anticipatory anxiety and catastrophic thoughts';

  @override
  String get lessonDetailMatchingPractice => 'MATCHING PRACTICE';

  @override
  String get lessonDetailStartThePracticeNow => 'Start the practice now';

  @override
  String get lessonDetailYourPersonalReflection => 'Your personal reflection';

  @override
  String get lessonDetailWriteDownYourHonestThoughts =>
      'Write down your honest thoughts here. They stay on your device unless you share them.';

  @override
  String get lessonDetailSavedLocally => 'Saved locally!';

  @override
  String get lessonDetailSaveAnswer => 'Save answer';

  @override
  String lessonDetailShareWithPartnername2(Object partnerName) {
    return 'Share with $partnerName';
  }

  @override
  String get audioPlayerCardDeviceVoice => 'DEVICE VOICE';

  @override
  String get audioPlayerCardGuidedExercise => 'GUIDED EXERCISE';

  @override
  String get audioPlayerCardListen => 'LISTEN';

  @override
  String get audioPlayerCardJustFollowTheVoice => 'Just follow the voice …';

  @override
  String get audioPlayerCardReadingAloud => 'Reading aloud …';

  @override
  String get audioPlayerCardPausedTapToResume => 'Paused • Tap to resume';

  @override
  String get audioPlayerCardCloseYourEyesAndListen =>
      'Close your eyes and listen';

  @override
  String audioPlayerCardListenToTheLessonApprox(Object durationMin) {
    return 'Listen to the lesson (approx. $durationMin min)';
  }

  @override
  String get audioPlayerCardBackS => 'Back 10 s';

  @override
  String get audioPlayerCardForwardS => 'Forward 10 s';

  @override
  String get audioPlayerCardStopReset => 'Stop & reset';

  @override
  String get trainingPelvicFloor => 'Pelvic floor';

  @override
  String get trainingBreathPacer => 'Breath pacer';

  @override
  String get breathPacerViewBreatheIn => 'BREATHE IN';

  @override
  String get breathPacerViewBreatheInCalmlyAndDeeply =>
      'Breathe in calmly and deeply through the nose...';

  @override
  String get breathPacerViewHold => 'HOLD';

  @override
  String get breathPacerViewHoldYourBreathKeepThe =>
      'Hold your breath, keep the chest relaxed...';

  @override
  String get breathPacerViewBreatheOutSlowly => 'BREATHE OUT SLOWLY';

  @override
  String get breathPacerViewBreatheOutFullyThroughThe =>
      'Breathe out fully through the mouth with a soft whoosh...';

  @override
  String get breathPacerViewBreatheInDeeply => 'BREATHE IN DEEPLY';

  @override
  String get breathPacerViewBreatheDeepIntoTheBelly =>
      'Breathe deep into the belly through the nose...';

  @override
  String get breathPacerViewSecondBreath => 'SECOND BREATH';

  @override
  String get breathPacerViewTakeOneMoreShortSip =>
      'Take one more short sip of air on top...';

  @override
  String get breathPacerViewSighItOut => 'SIGH IT OUT';

  @override
  String get breathPacerViewBreatheOutVeryLongAnd =>
      'Breathe out very long and audibly through the mouth, let the shoulders drop...';

  @override
  String get breathPacerViewBreathing => '4-7-8 breathing';

  @override
  String get breathPacerViewDeepCalmingBreath => 'Deep calming breath';

  @override
  String get breathPacerViewPhysiologicalSigh => 'Physiological sigh';

  @override
  String get breathPacerViewQuickWayToCalmDown => 'Quick way to calm down';

  @override
  String breathPacerViewCompletedcyclesCyclesCompleted(Object completedCycles) {
    return '$completedCycles cycles completed';
  }

  @override
  String get breathPacerViewALongerExhaleMeasurablySlows =>
      'A longer exhale measurably slows the heartbeat.';

  @override
  String get breathPacerViewTheDoubleInhaleIsMeant =>
      'The double inhale is meant to reopen the air sacs in the lungs.';

  @override
  String get breathPacerViewStart => 'Start';

  @override
  String get breathPacerViewBackgroundWhenTheExhaleLasts =>
      'Background: when the exhale lasts longer than the inhale, the heart rate slows down a little with each breath out. This is a normal reflex that many people feel as calming.';

  @override
  String get sosTitel => 'Help';

  @override
  String get sosAuswahlTitel => 'What\'s going on right now?';

  @override
  String get sosAuswahlUntertitel =>
      'You don\'t have to explain anything. Pick what fits best.';

  @override
  String get sosAuswahlHilfe => 'I\'m being pushed, my no isn\'t respected';

  @override
  String get sosWeiter => 'Next';

  @override
  String get sosZurueck => 'Back';

  @override
  String get sosZurAuswahl => 'Back to choices';

  @override
  String get sosSchliessen => 'Close';

  @override
  String sosSchrittVon(int aktuell, int gesamt) {
    return 'Step $aktuell of $gesamt';
  }

  @override
  String get sosSatzTitel => 'A sentence you can say';

  @override
  String get sosHilfeKnopf => 'Help with pressure or violence';

  @override
  String get sosHilfeTitel => 'Help when a no isn\'t respected';

  @override
  String get sosHilfeEinstieg =>
      'If you said no, or couldn\'t say anything, and it went on anyway, that is not okay. It is not your fault. Not even if you\'re a couple, if you said yes earlier, or if you didn\'t say it clearly enough. Freezing is a normal protective response.';

  @override
  String get sosHilfeGiltTitel => 'What\'s true';

  @override
  String get sosHilfeGilt1 =>
      'A no counts, even in the middle of things and even in a relationship.';

  @override
  String get sosHilfeGilt2 =>
      'A yes that comes after persuading, pushing, sulking, threats or silence used as pressure is not free consent.';

  @override
  String get sosHilfeGilt3 =>
      'Someone who is asleep, unconscious, very drunk or high, or afraid cannot freely consent.';

  @override
  String get sosHilfeGilt4 =>
      'You don\'t have to prove anything to get help. Counseling is possible without reporting to the police. You decide what to do and when.';

  @override
  String get sosHilfeNotrufTitel => 'In immediate danger';

  @override
  String get sosHilfeAnrufenTitel => 'Talk to someone';

  @override
  String get sosHilfeDiskretion =>
      'Calls appear in your call log and sometimes on your bill. You can delete them from the call log. A chat shows up in your browser history. A private window leaves less behind.';

  @override
  String sosHilfeStand(String stand) {
    return 'Information as of $stand. Numbers and hours can change.';
  }

  @override
  String get sosHilfeAnrufen => 'Call';

  @override
  String get sosHilfeWebseite => 'Website';

  @override
  String sosSatzZitat(String satz) {
    return '“$satz”';
  }

  @override
  String sosHilfeAnrufenNummer(String nummer) {
    return 'Call $nummer';
  }

  @override
  String sosHilfeNummerWaehlen(String nummer) {
    return 'Please dial $nummer';
  }

  @override
  String get sosHilfeSchnellVerlassen => 'Leave quickly';

  @override
  String get sosLandDe => 'Germany';

  @override
  String get sosLandAt => 'Austria';

  @override
  String get sosLandCh => 'Switzerland';

  @override
  String get sosLandUk => 'United Kingdom';

  @override
  String get sosLandUs => 'USA';

  @override
  String get sosNotrufDe => 'Police 110 · ambulance and fire 112';

  @override
  String get sosNotrufAt => 'Police 133 · ambulance 144 · Europe-wide 112';

  @override
  String get sosNotrufCh => 'Police 117 · ambulance 144 · 112';

  @override
  String get sosNotrufUk => '999 (police, ambulance)';

  @override
  String get sosNotrufUs => '911 (police, ambulance)';

  @override
  String get sosStelleDeFrauenName =>
      'Violence Against Women helpline (Germany)';

  @override
  String get sosStelleDeFrauenHinweis =>
      'Around the clock, free and anonymous. Also advises on sexual violence, by phone, chat and in many languages.';

  @override
  String get sosStelleDeMaennerName =>
      'Violence Against Men helpline (Germany)';

  @override
  String get sosStelleDeMaennerHinweis =>
      'Free and anonymous. Phone: Mon to Thu 8 am to 8 pm, Fri 8 am to 3 pm. The chat has shorter hours.';

  @override
  String get sosStelleDeWeisserName => 'WEISSER RING victim helpline (Germany)';

  @override
  String get sosStelleDeWeisserHinweis =>
      'Daily 7 am to 10 pm, free and anonymous, for victims of crime.';

  @override
  String get sosStelleDeSeelsorgeName =>
      'Telefonseelsorge (crisis line, Germany)';

  @override
  String get sosStelleDeSeelsorgeHinweis =>
      'Phone around the clock and free, also at 0800 111 0 222 and 116 123. Chat only after registering and with an appointment. Counseling in German.';

  @override
  String get sosStelleAtFrauenName =>
      'Women\'s helpline against violence (Austria)';

  @override
  String get sosStelleAtFrauenHinweis =>
      'Around the clock, free, anonymous and confidential.';

  @override
  String get sosStelleAtGewaltschutzName =>
      'Violence protection centers (Austria)';

  @override
  String get sosStelleAtGewaltschutzHinweis =>
      'Free and confidential. Nationwide number according to the Frauenhelpline.';

  @override
  String get sosStelleChOpferhilfeName => 'Victim support 142 (Switzerland)';

  @override
  String get sosStelleChOpferhilfeHinweis =>
      'Across Switzerland since 1 May 2026, around the clock, free and anonymous. Not an emergency line: in danger, call the police first.';

  @override
  String get sosStelleUkRapeName =>
      'Rape Crisis Support Line (England and Wales)';

  @override
  String get sosStelleUkRapeHinweis =>
      'Around the clock, free, also by chat. For people aged 16 and over in England and Wales affected by rape or sexual violence.';

  @override
  String get sosStelleUsRainnName =>
      'RAINN National Sexual Assault Hotline (USA)';

  @override
  String get sosStelleUsRainnHinweis =>
      'Around the clock, free and confidential, in English and Spanish. Chat at online.rainn.org.';

  @override
  String get sosStelleUs988Name => '988 Suicide & Crisis Lifeline (USA)';

  @override
  String get sosStelleUs988Hinweis =>
      'Call or text, around the clock, free, for emotional crises.';

  @override
  String get appLockLocked => 'Locked';

  @override
  String get appLockUnlock => 'Unlock';

  @override
  String get mainCbtSomaticCoaching => 'CBT & SOMATIC COACHING';

  @override
  String coursesCourseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count courses',
      one: '1 course',
    );
    return '$_temp0';
  }

  @override
  String coursesStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Active $count days in a row',
      one: 'Active 1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String get coursesPracticeSelfExploration => 'Practice: self-exploration';

  @override
  String get coursesPracticeDesireProfile => 'Practice: desire profile';

  @override
  String get couplesChannelIWantYou => 'I want you';

  @override
  String get couplesChannelJustCuddlesToday => 'Just cuddles today';

  @override
  String get couplesChannelLookingForwardToLater => 'Looking forward to later';

  @override
  String get couplesChannelVerySlowlyToday => 'Very slowly today';

  @override
  String get couplesChannelLetSTalk => 'Let\'s talk';

  @override
  String get couplesChannelNotToday => 'Not today';

  @override
  String get couplesChannelReconnect => 'Reconnect';

  @override
  String get couplesChannelConnectWithYourPartnerAnd =>
      'Connect with your partner and share wishes that are otherwise hard to say out loud.';

  @override
  String get couplesChannelSendSparks => 'Send sparks';

  @override
  String get couplesChannelShowWithOneTapWhat =>
      'Show with one tap what you\'re in the mood for today – or not.';

  @override
  String get couplesChannelSecretlyMatchWishes => 'Compare wishes quietly';

  @override
  String get couplesChannelYouVoteSeparatelyOnlyWhat =>
      'You vote separately. Only what you both want becomes visible.';

  @override
  String get couplesChannelJustForTheTwoOf => 'Just for the two of you';

  @override
  String get couplesChannelEndToEndEncryptedNo =>
      'End-to-end encrypted, no account and no phone number.';

  @override
  String get couplesChannelConnectWithPartner => 'Connect with partner';

  @override
  String get couplesChannelInvitePartner => 'Invite partner';

  @override
  String get couplesChannelHowDoesItWork => 'How does it work?';

  @override
  String get couplesChannelYouCanAlsoFillIt =>
      'You can also fill it in alone and compare it with your partner later.';

  @override
  String get couplesChannelSharedEvening => 'Shared evening';

  @override
  String get couplesChannelGuidedTouchForTheTwo =>
      'Guided touch for the two of you, 20 to 45 minutes. Different every time.';

  @override
  String get couplesChannelFantasyMap => 'Fantasy map';

  @override
  String get couplesChannelMessages => 'Messages';

  @override
  String get couplesChannelWishes => 'Explore together';

  @override
  String get couplesChannelConnectedEncrypted => 'connected & encrypted';

  @override
  String get couplesChannelConnecting => 'connecting …';

  @override
  String get couplesChannelOfflineTapToConnect => 'offline – tap to connect';

  @override
  String couplesChannelYouName(Object name) {
    return 'You & $name';
  }

  @override
  String get couplesChannelPartnerSNameGender => 'Partner\'s name & gender';

  @override
  String get couplesChannelReadReceipts => 'Read receipts';

  @override
  String get couplesChannelEncryptionDetails => 'Encryption & details';

  @override
  String get couplesChannelManageConnection => 'Manage connection';

  @override
  String get couplesChannelDisconnect => 'Disconnect';

  @override
  String get couplesChannelItSStillQuietHere => 'It\'s still quiet here';

  @override
  String get couplesChannelSendASparkFromThe =>
      'Send a spark from the bar below or write a few words.';

  @override
  String get couplesChannelRead => ' · Read';

  @override
  String get couplesChannelSent => ' · Sent';

  @override
  String get couplesChannelOpenLesson => 'Open lesson';

  @override
  String get couplesChannelWriteAMessage => 'Write a message …';

  @override
  String get couplesChannelSend => 'Send';

  @override
  String get couplesChannelVoteSeparatelyAWishOnly =>
      'Answer separately. A wish only becomes visible when you\'ve both said “Yes, please”. A “Maybe” goes to “To talk about”. A “Rather not” is not shown to your partner.';

  @override
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche) {
    return '$fragen questions in $bereiche areas – with matching course recommendations.';
  }

  @override
  String get couplesChannelYouHaveAMatch => 'You both said yes to one thing';

  @override
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength) {
    return 'You both said yes to $matchesLength things';
  }

  @override
  String get couplesChannelAMatchIsAnInvitation =>
      'A shared yes is an invitation, not a promise. Talk briefly beforehand about how you imagine it. And “not today” always counts.';

  @override
  String get couplesChannelYesPlease => 'Yes, please';

  @override
  String get couplesChannelRatherNot => 'Rather not';

  @override
  String get couplesChannelDisconnect2 => 'Disconnect?';

  @override
  String couplesChannelTheHistoryWithNameName(
      Object name, Object name2, Object name3) {
    return 'The history with $name, $name2\'s answers to the yes/no list and the shared reflections will be deleted on this phone. Your own answers are kept.\n\nNothing changes on $name3\'s phone.';
  }

  @override
  String get couplesChannelDisconnect3 => 'Disconnect';

  @override
  String get couplesChannelDisconnected => 'Disconnected.';

  @override
  String get couplesChannelHowItStaysPrivate => 'How it stays private';

  @override
  String get couplesChannelMessagesAreEncryptedOnYour =>
      'Messages are encrypted on your phone and only become readable again on your partner\'s phone. In between they travel through public Nostr servers. These can\'t read the content. But they can see the keys of sender and recipient, the time and approximate size of each message and your IP address – so that, when and how often you write. The keys carry no names. There is no account, no phone number and no server of our own.';

  @override
  String get couplesChannelEncryption => 'Encryption';

  @override
  String get couplesChannelEncryptionSealed => 'Nostr NIP-17 (sealed)';

  @override
  String get couplesChannelSealedNote =>
      'When you both write with a new version, messages go out sealed: the servers cannot see who sends them and only get a vague time. They can still see that someone writes to one of you, your IP address and the approximate size.';

  @override
  String get couplesChannelServers => 'Servers';

  @override
  String get couplesChannelYourConnectionCode => 'Your connection code';

  @override
  String get couplesChannelClose => 'Close';

  @override
  String get paarAbendYou => 'You';

  @override
  String get paarAbendYourPartner => 'your partner';

  @override
  String get paarAbendEndTheEvening => 'End the evening?';

  @override
  String get paarAbendTheGuidanceStopsThenYou =>
      'The guidance stops then. You can start again any time.';

  @override
  String get paarAbendContinue => 'Continue';

  @override
  String get paarAbendPutThePhoneNextTo =>
      'Put the phone next to you. A voice guides you through arriving, two rounds of touch with a change of roles and a calm ending. Most of the time is silence, so you can be fully with each other. Every evening is put together anew.';

  @override
  String get paarAbendDuration => 'Duration';

  @override
  String paarAbendMMin(Object m) {
    return '$m min';
  }

  @override
  String get paarAbendHowFarMayItGo => 'How far may it go?';

  @override
  String get paarAbendClothed => 'Clothed';

  @override
  String get paarAbendBackShouldersHandsHeadLegs =>
      'Back, shoulders, hands, head, legs and feet.';

  @override
  String get paarAbendSkinToSkin => 'Skin to skin';

  @override
  String get paarAbendPlusMassageWithOilBelly =>
      'Plus massage with oil, belly, hips and buttocks.';

  @override
  String get paarAbendIntimate => 'Intimate';

  @override
  String get paarAbendPlusChestInnerThighsAnd =>
      'Plus chest, inner thighs and genitals, without any goal.';

  @override
  String get paarAbendWhoGivesFirst => 'Who gives first?';

  @override
  String get paarAbendMe => 'Me';

  @override
  String get paarAbendMyPartner => 'My partner';

  @override
  String get paarAbendVoice => 'Voice';

  @override
  String get paarAbendSoftSoundBed => 'Soft sound bed';

  @override
  String get paarAbendCalmBackgroundDuringTheSilences =>
      'Calm background during the silences';

  @override
  String get paarAbendAgreeOnAStopWord =>
      'Agree on a stop word beforehand. The voice invites, it decides nothing: whatever doesn\'t feel good, you simply leave out.';

  @override
  String get paarAbendBeginTheEvening => 'Begin the evening';

  @override
  String get paarAbendThankYouForYourEvening => 'Thank you for your evening';

  @override
  String get paarAbendStayLyingDownAsLong =>
      'Stay lying down as long as it feels good.';

  @override
  String paarAbendRoundRunde(Object runde) {
    return 'Round $runde';
  }

  @override
  String paarAbendYouGivePartnernameReceives(Object partnerName) {
    return 'You give · $partnerName receives';
  }

  @override
  String paarAbendPartnernamePartnernameGivesYouReceive(
      Object partnerName, Object partnerName2) {
    return '$partnerName$partnerName2 gives · you receive';
  }

  @override
  String get paarAbendArriving => 'Arriving';

  @override
  String get paarAbendEnding => 'Ending';

  @override
  String get paarAbendChangeOfRoles => 'Change of roles';

  @override
  String get paarAbendBreatheTogether => 'Breathe together.';

  @override
  String get paarAbendPaused => 'Paused';

  @override
  String get paarAbendTheVoiceIsSpeaking => 'The voice is speaking …';

  @override
  String paarAbendSilenceStillerestLeft(Object stilleRest) {
    return 'Silence · $stilleRest left';
  }

  @override
  String invitePartnerIDLikeToTry(Object stableApkUrl, Object testerGuideUrl) {
    return '\nI\'d like to try VelvetPulse with you 💛 A private app for closeness and conversation, just for the two of us. You don\'t need to be good at anything, and you can say “not today” or “no” to anything. Feel free to just have a look first. Your data stays on your phone.\n\n1. Get the app (Android):\n$stableApkUrl\nIf Android asks, allow the installation. On first start, tap “Someone invited me”.\n\n2. I\'ll send you my connection code as a separate message. Copy it and paste it into the app: Couple channel › Connect with partner › Scan partner › paste code › “Connect & pair”.\n\n3. Then send me a spark, and we\'re connected.\n\nDetailed guide (German): $testerGuideUrl';
  }

  @override
  String get invitePartnerYouSendALinkTo =>
      'You send a link to the app and your connection code, e.g. via a messenger. Your partner can take a look in peace and decides whether and when to connect. You then confirm the connection here.';

  @override
  String get invitePartnerNameEGAnna => 'Name, e.g. Anna';

  @override
  String get invitePartnerShareInvitation => 'Share invitation';

  @override
  String get invitePartnerInvitationToVelvetpulse =>
      'Invitation to VelvetPulse';

  @override
  String get invitePartnerNowYourCode => 'Now your code';

  @override
  String get invitePartnerSendYourConnectionCodeAfterwards =>
      'Send your connection code afterwards as a separate message, ideally to the same person. That way it can be copied with one tap.';

  @override
  String get invitePartnerShareCode => 'Share code';

  @override
  String get invitePartnerMyVelvetpulseCode => 'My VelvetPulse code';

  @override
  String get invitePartnerCopiedPasteTheTextInto =>
      'Copied. Paste the text into a messenger.';

  @override
  String invitePartnerNameWantsToConnect(Object name) {
    return '$name wants to connect';
  }

  @override
  String invitePartnerInvitationSentToName(Object name) {
    return 'Invitation sent to $name';
  }

  @override
  String invitePartnerAMessageJustArrivedAt(Object name) {
    return 'A message just arrived at your code. If it\'s from $name, accept the connection.';
  }

  @override
  String invitePartnerAsSoonAsNameInstalls(Object name) {
    return 'As soon as $name installs the app, enters your code and sends you a spark, you can confirm the connection here. Give $name time.';
  }

  @override
  String get invitePartnerDecline => 'Decline';

  @override
  String invitePartnerConnectedWithName(Object name) {
    return 'Connected with $name';
  }

  @override
  String get invitePartnerAccept => 'Accept';

  @override
  String get invitePartnerWithdraw => 'Withdraw';

  @override
  String get invitePartnerShareAgain => 'Share again';

  @override
  String get pairingModalConnectWithSomeoneElse => 'Connect with someone else?';

  @override
  String pairingModalYouReCurrentlyConnectedWith(
      Object old, Object old2, Object old3) {
    return 'You\'re currently connected with $old. This connection will be replaced, and the history with $old2, $old3\'s answers and the shared reflections will be deleted on this phone.';
  }

  @override
  String get pairingModalReplace => 'Replace';

  @override
  String get pairingModalHiIMConnectedNow => '👋 Hi, I\'m connected now.';

  @override
  String pairingModalConnectedWithName(Object name) {
    return 'Connected with $name';
  }

  @override
  String get pairingModalThisCodeDoesnTFit =>
      'This code doesn\'t fit. Scan your partner\'s QR code or paste the complete code (starts with npub1…).';

  @override
  String get pairingModalMyCode => 'My code';

  @override
  String get pairingModalScanPartner => 'Scan partner';

  @override
  String get pairingModalLetYourPartnerScanThis =>
      'Let your partner scan this code to open your private channel.';

  @override
  String get pairingModalCopyCode => 'Copy code';

  @override
  String get pairingModalYourConnectionCodeHasBeen =>
      'Your connection code has been copied.';

  @override
  String get pairingModalEndToEndEncryptedNo =>
      'End-to-end encrypted • no account';

  @override
  String get pairingModalHoldYourPartnerSQr =>
      'Hold your partner\'s QR code in the frame';

  @override
  String get pairingModalPartnerSNameEG =>
      'Partner\'s name (e.g. Darling, Anna)';

  @override
  String get pairingModalOrPasteNpubHexKey => 'Or paste npub1... / hex key';

  @override
  String get pairingModalPasteFromClipboard => 'Paste from clipboard';

  @override
  String get pairingModalConnectPair => 'Connect & pair';

  @override
  String get partnerProfileDialogWoman => 'Woman';

  @override
  String get partnerProfileDialogMan => 'Man';

  @override
  String get partnerProfileDialogNonBinary => 'Non-binary';

  @override
  String get partnerProfileDialogNotSpecified => 'Not specified';

  @override
  String get partnerProfileDialogYourPartner => 'Your partner';

  @override
  String get partnerProfileDialogThisLetsLessonsCallYour =>
      'This lets lessons call your partner by name, e.g. “Anna lies on her back” instead of “she lies”. Both stay on your phone only.';

  @override
  String get partnerProfileDialogSave => 'Save';

  @override
  String get partnerProfileDialogHowMayLessonsReferTo =>
      'How may lessons refer to your partner?';

  @override
  String get partnerProfileDialogWithNameAndGenderThe =>
      'With name and gender, the texts address you personally. This stays on your phone.';

  @override
  String get partnerProfileDialogAdd => 'Add';

  @override
  String get distortionSpectatoring => 'Spectatoring / self-monitoring';

  @override
  String get distortionCatastrophizing => 'Catastrophizing';

  @override
  String get distortionAllOrNothing => 'All-or-nothing thinking';

  @override
  String get distortionMindReading => 'Mind reading';

  @override
  String get distortionPerformancePressure => 'Performance pressure';

  @override
  String get distortionTunnelVision => 'Tunnel vision on body signals';

  @override
  String cbtJournalProtocolsSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thought records saved locally',
      one: '1 thought record saved locally',
    );
    return '$_temp0';
  }

  @override
  String get selbstReiseEndTheJourney => 'End the journey?';

  @override
  String get selbstReiseTheGuidanceStopsThenYou =>
      'The guidance stops then. You can start again any time.';

  @override
  String get selbstReiseAVoiceGuidesYouThrough =>
      'A voice guides you through arriving, breathing and a journey across your body. Most of the time is silence, so you can be fully with yourself. Every journey is put together anew, and there is no goal.';

  @override
  String get selbstReiseYouDecideYouCanPause =>
      'You decide. You can pause, skip a step or stop at any time with the buttons below. Nothing has to happen: staying with a pleasant, non-sexual touch is just as right. If something becomes uncomfortable or difficult memories come up, you may stop at any time.';

  @override
  String selbstReiseMMin(Object m) {
    return '$m min';
  }

  @override
  String get selbstReiseHowCloseWouldYouLike =>
      'How close would you like to come to yourself today?';

  @override
  String get selbstReiseGentle => 'Gentle';

  @override
  String get selbstReiseFaceScalpEarsNeckArms =>
      'Face, scalp, ears, neck, arms, hands, chest, belly, legs and feet, clothed if you like.';

  @override
  String get selbstReiseSkin => 'Skin';

  @override
  String get selbstReisePlusBareSkinWithOil =>
      'Plus bare skin with oil, hips and inner thighs.';

  @override
  String get selbstReisePlusPerineumAndGenitalsWith =>
      'Plus perineum and genitals, with waves instead of a goal.';

  @override
  String get selbstReiseYourBody => 'Your body';

  @override
  String get selbstReiseVulva => 'Vulva';

  @override
  String get selbstReisePenis => 'Penis';

  @override
  String get selbstReiseBeginTheJourney => 'Begin the journey';

  @override
  String get selbstReiseThankYou => 'Thank you';

  @override
  String get selbstReiseBodyJourney => 'Body journey';

  @override
  String selbstReiseSilenceStillerestLeft(Object stilleRest) {
    return 'Silence · $stilleRest left';
  }

  @override
  String get selbstReiseStayLyingDownAsLong =>
      'Stay lying down as long as it feels good.';

  @override
  String get lustProfileCircling => 'Circling';

  @override
  String get lustProfileUpAndDown => 'Up and down';

  @override
  String get lustProfileSideToSide => 'Side to side';

  @override
  String get lustProfilePressAndHold => 'Press and hold';

  @override
  String get lustProfileFramingTwoFingersLeftAnd =>
      'Framing – two fingers left and right';

  @override
  String get lustProfileLightTapping => 'Light tapping';

  @override
  String get lustProfileInsideAndOutsideAtOnce => 'Inside and outside at once';

  @override
  String get lustProfileOpenOiledHand => 'Open, oiled hand';

  @override
  String get lustProfileTwoHandedGliding => 'Two-handed gliding';

  @override
  String get lustProfileTwisting => 'Twisting';

  @override
  String get lustProfileRingAtTheBase => 'Ring at the base';

  @override
  String get lustProfileCirclingTheFrenulum => 'Circling the frenulum';

  @override
  String get lustProfileIncludingTesticlesAndPerineum =>
      'Including testicles and perineum';

  @override
  String get lustProfileWavesPausingJustBeforeClimax =>
      'Waves – pausing just before climax';

  @override
  String get lustProfileStartSlowlyAroundRatherThan =>
      'Start slowly, around rather than direct';

  @override
  String get lustProfileWhenItSGoodKeep =>
      'When it\'s good: keep going exactly like that';

  @override
  String get lustProfileWithPlentyOfLubricant => 'With plenty of lubricant';

  @override
  String get lustProfileLotsOfTimeNoGoal => 'Lots of time, no goal';

  @override
  String get lustProfileMyDesireProfileThisIs =>
      '💛 My desire profile – this is what I\'ve discovered about myself:\n';

  @override
  String get lustProfileWouldYouLikeToTry =>
      '\nWould you like to try it with me?';

  @override
  String get lustProfileYourDesireProfileIsOn =>
      'Your desire profile is on its way, encrypted';

  @override
  String get lustProfileSendingDidnTWorkPlease =>
      'Sending didn\'t work. Please try again.';

  @override
  String get lustProfileTextCopied => 'Text copied.';

  @override
  String get lustProfileWithVulva => 'With vulva';

  @override
  String get lustProfileWithPenis => 'With penis';

  @override
  String get lustProfileTickWhatYouEnjoyedWhile =>
      'Tick what you enjoyed while exploring. Only you decide whether and when to share it – only what you select here is sent.';

  @override
  String get lustProfileGeneral => 'General';

  @override
  String get lustProfilePersonalNote => 'Personal note';

  @override
  String get lustProfileForExampleAtTheBeginning =>
      'For example: at the beginning I like big, slow circles …';

  @override
  String get lustProfileSendToMyPartner => 'Send to my partner';

  @override
  String get lustProfileConnectCoupleChannelAndSend =>
      'Connect couple channel and send';

  @override
  String get lustProfileJustCopyAsText => 'Just copy as text';

  @override
  String get lustProfileTipEvenNicerThanAny =>
      'Tip: even nicer than any message is guiding your partner\'s hand or letting them show you. The message can be the start of that.';

  @override
  String get yesNoMaybeMatchingAnswersEncrypted =>
      'Comparing answers, encrypted …';

  @override
  String yesNoMaybeCountAnswersMatched(Object count) {
    return 'Done: $count answers compared.';
  }

  @override
  String get yesNoMaybeReadMore => 'READ MORE';

  @override
  String get yesNoMaybeYesMaybeNo => 'Yes, please / Maybe / Rather not';

  @override
  String get yesNoMaybeSyncWithPartner => 'Compare with your partner';

  @override
  String get yesNoMaybePairingRequired => 'Connect first';

  @override
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
      Object answeredCount, Object totalItems) {
    return 'Questions ($answeredCount of $totalItems)';
  }

  @override
  String yesNoMaybeMatchesMatchcount(Object matchCount) {
    return 'Together ($matchCount)';
  }

  @override
  String get yesNoMaybeMeineAntworten => 'My answers';

  @override
  String get yesNoMaybeGemeinsam => 'Together';

  @override
  String get yesNoMaybeDigitalSafeSpace => 'Your answers, your pace';

  @override
  String get yesNoMaybeFindOutWhatExcitesYou =>
      'Take your time to notice what you like, what might be okay and what you\'d rather not. You don\'t have to answer anything. Not sure what something means? Tap the i. If you\'re connected, only places where you both said at least “Maybe” become visible. A “Rather not” is not shown to your partner.';

  @override
  String get yesNoMaybeYes => 'Yes, please';

  @override
  String get yesNoMaybeMaybe => 'Maybe';

  @override
  String get yesNoMaybeNo => 'Rather not';

  @override
  String yesNoMaybeAllEintraegelength(Object eintraegeLength) {
    return 'All ($eintraegeLength)';
  }

  @override
  String get yesNoMaybeOpen => 'Open';

  @override
  String yesNoMaybeYesYescount(Object yesCount) {
    return 'Yes, please ($yesCount)';
  }

  @override
  String yesNoMaybeMaybeMaybecount(Object maybeCount) {
    return 'Maybe ($maybeCount)';
  }

  @override
  String yesNoMaybeNoNocount(Object noCount) {
    return 'Rather not ($noCount)';
  }

  @override
  String get yesNoMaybePairingRequired2 => 'Connect first';

  @override
  String get yesNoMaybeConnectWithYourPartnerIn =>
      'Once you\'re connected in the couple channel, you can compare your answers, encrypted. Only what you share becomes visible. Filling it in alone works too.';

  @override
  String get yesNoMaybePairViaQrCodeNow => 'Connect via QR code';

  @override
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName) {
    return 'Together with $partnerName';
  }

  @override
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
      Object yesMatchesLength, Object curiosityMatchesLength) {
    return 'Yes from both of you: $yesMatchesLength · Curious together: $curiosityMatchesLength';
  }

  @override
  String get yesNoMaybeNoRejectionAllLimitsWere =>
      'Only what you both said is shown here. Everything else is not shown to your partner. A “Rather not” is a complete answer.';

  @override
  String get yesNoMaybePerfectMatchBothSaidYes => 'You both said yes';

  @override
  String get yesNoMaybeSharedCuriosityOpenToExploring =>
      'Curious together, a maybe is enough';

  @override
  String get yesNoMaybeNoMatchesYet => 'It\'s still quiet here';

  @override
  String get yesNoMaybeBothKeepVotingInThe =>
      'That doesn\'t mean anything is missing. Maybe you haven\'t answered everything yet, or your answers simply lie in different places. Both are normal. There\'s nothing you have to do.';

  @override
  String get yesNoMaybeYouBothYes => 'You both: yes';

  @override
  String get yesNoMaybeCuriousTogether => 'Curious together';

  @override
  String get yesNoMaybeCourse => 'Learn more';

  @override
  String get cbtNewEntryPleaseChooseAtLeastOne =>
      'Please choose at least one thinking pattern / distortion.';

  @override
  String get cbtNewEntryNewThoughtRecord => 'New thought record';

  @override
  String get cbtNewEntryEditEntry => 'Edit entry';

  @override
  String get cbtNewEntryCognitiveRestructuringUnmaskIrrationalAlarm =>
      'Cognitive restructuring: unmask irrational alarm thoughts and phrase a realistic answer.';

  @override
  String get cbtNewEntryTriggerSituation => 'Trigger / situation';

  @override
  String get cbtNewEntryWhenOrDuringWhatDid =>
      'When or during what did the tension come up? (e.g. “When we went to bed”, “When she touched me”)';

  @override
  String get cbtNewEntryDescribeTheSpecificSituation =>
      'Describe the specific situation...';

  @override
  String get cbtNewEntryPleaseDescribeASituation =>
      'Please describe a situation.';

  @override
  String get cbtNewEntryAutomaticThoughtMentalMovie =>
      'Automatic thought (mental movie)';

  @override
  String get cbtNewEntryWhatShotThroughYourHead =>
      'What shot through your head right away? What did the inner critic say? (e.g. “I\'m going to fail again”)';

  @override
  String get cbtNewEntryNoteTheUnfilteredThought =>
      'Note the unfiltered thought...';

  @override
  String get cbtNewEntryPleaseNoteYourThought => 'Please note your thought.';

  @override
  String get cbtNewEntryExposeTheCognitiveDistortion =>
      'Expose the cognitive distortion';

  @override
  String get cbtNewEntryWhichThinkingTrapIsThis =>
      'Which thinking trap is this? (choose at least one)';

  @override
  String get cbtNewEntryReappraisalRealityCheck =>
      'Reappraisal / reality check';

  @override
  String get cbtNewEntryWhatSTheRealisticView =>
      'What\'s the realistic view? What would an empathetic coach or friend say?';

  @override
  String get cbtNewEntryEGMyBodyIs =>
      'e.g.: “My body is just reacting to stress. I don\'t have to impress anyone today. If I focus on skin contact and breathing, the pressure drops.”';

  @override
  String get cbtNewEntryPleasePhraseAReappraisal =>
      'Please phrase a reappraisal.';

  @override
  String get cbtNewEntrySaving => 'Saving...';

  @override
  String get cbtNewEntrySaveThoughtRecord => 'Save thought record';

  @override
  String get cbtJournalDeleteEntry => 'Delete entry?';

  @override
  String get cbtJournalDoYouReallyWantTo =>
      'Do you really want to remove this thought record from your device?';

  @override
  String get cbtJournalDelete => 'Delete';

  @override
  String get cbtJournalNewEntry => 'New entry';

  @override
  String cbtJournalMyRecordsEntrieslength(Object entriesLength) {
    return 'My records ($entriesLength)';
  }

  @override
  String get cbtJournalBeliefs => 'Beliefs';

  @override
  String get cbtJournalNoThoughtRecordsYet => 'No thought records yet';

  @override
  String get cbtJournalWhenYourHeadBlocksBefore =>
      'When your head blocks before or during intimacy, it helps a lot to write down the automatic thought and expose the cognitive distortion in black and white.';

  @override
  String get cbtJournalNewRecord => 'New record';

  @override
  String get cbtJournalStartWithABelief => 'Start with a belief';

  @override
  String get cbtJournalCognitiveRestructuring => 'Cognitive restructuring';

  @override
  String get cbtJournalEdit => 'Edit';

  @override
  String get cbtJournalAutomaticThoughtAlarm => 'AUTOMATIC THOUGHT (ALARM)';

  @override
  String cbtJournalAutomaticthought(Object automaticThought) {
    return '“$automaticThought”';
  }

  @override
  String get cbtJournalReappraisalRealityCheck => 'REAPPRAISAL & REALITY CHECK';

  @override
  String beliefLibraryViewRealitycheckPracticalShiftPracticalshift(
      Object realityCheck, Object practicalShift) {
    return '$realityCheck\n\nPractical shift: $practicalShift';
  }

  @override
  String get beliefLibraryViewBeliefToolkit => 'Belief toolkit';

  @override
  String get beliefLibraryViewTheMostCommonMentalTraps =>
      'The most common mental traps in performance anxiety – and the reality behind them. Tap a card to take it straight into your own journal.';

  @override
  String get beliefLibraryViewForHer => 'For people with a vulva';

  @override
  String get beliefLibraryViewForHim => 'For people with a penis';

  @override
  String get beliefLibraryViewTypicalMisbeliefMentalMovie =>
      'TYPICAL MISBELIEF (MENTAL MOVIE)';

  @override
  String beliefLibraryViewIrrationalthought(Object irrationalThought) {
    return '“$irrationalThought”';
  }

  @override
  String get beliefLibraryViewRealityCheck => 'REALITY CHECK';

  @override
  String get beliefLibraryViewTakeIntoMyJournal => 'Take into my journal';

  @override
  String get kegelTimerViewBreatheInWiden => 'BREATHE IN & WIDEN';

  @override
  String get kegelTimerViewBreatheDeepIntoTheBelly =>
      'Breathe deep into the belly. Let the pelvic floor gently give way downwards – no pushing.';

  @override
  String get kegelTimerViewStaySoft => 'STAY SOFT';

  @override
  String get kegelTimerViewBreatheOutSlowlyAndStay =>
      'Breathe out slowly and stay wide, like a hammock hanging loosely.';

  @override
  String get kegelTimerViewNotice => 'NOTICE';

  @override
  String get kegelTimerViewKeepBreathingNormallyAndFeel =>
      'Keep breathing normally and feel how warm and calm the pelvis is.';

  @override
  String get kegelTimerViewTighten => 'TIGHTEN';

  @override
  String get kegelTimerViewGentlyDrawTheAreaBetween =>
      'Gently draw the area between pubic bone and tailbone inwards and upwards. Buttocks and belly stay relaxed.';

  @override
  String get kegelTimerViewHoldTheTensionAtAbout =>
      'Hold the tension at about half strength. Keep breathing calmly.';

  @override
  String get kegelTimerViewLetGoCompletely => 'LET GO COMPLETELY';

  @override
  String get kegelTimerViewRelaxCompletelyLettingGoLasts =>
      'Relax completely. Letting go lasts at least as long as holding.';

  @override
  String get kegelTimerViewQuickSqueeze => 'QUICK SQUEEZE';

  @override
  String get kegelTimerViewAQuickShortSqueezeLike =>
      'A quick, short squeeze – like a wink with the pelvic floor.';

  @override
  String get kegelTimerViewRelease => 'RELEASE';

  @override
  String get kegelTimerViewLetGoCompletelyRightAway =>
      'Let go completely right away.';

  @override
  String get kegelTimerViewBreatheInSoften => 'BREATHE IN & SOFTEN';

  @override
  String get kegelTimerViewBreatheDeepIntoTheBelly2 =>
      'Breathe deep into the belly. Consciously let perineum and buttocks soften.';

  @override
  String get kegelTimerViewLongExhale => 'LONG EXHALE';

  @override
  String get kegelTimerViewBreatheOutLongAndAudibly =>
      'Breathe out long and audibly, the pelvic floor stays wide. This is how you practise staying loose when aroused.';

  @override
  String get kegelTimerViewKeepBreathingCalmlyAndFeel =>
      'Keep breathing calmly and feel the warmth in your pelvis.';

  @override
  String get kegelTimerViewDone => 'Done';

  @override
  String kegelTimerViewYouPractisedTotalroundsRoundsA(Object totalRounds) {
    return 'You practised $totalRounds rounds. A few minutes regularly do more than long sessions rarely – see you tomorrow!';
  }

  @override
  String get kegelTimerViewFinish => 'Finish';

  @override
  String get kegelTimerViewLetGo => 'Let go';

  @override
  String get kegelTimerViewWiden => 'widen';

  @override
  String get kegelTimerViewStrengthen => 'Strengthen';

  @override
  String get kegelTimerViewHoldRelease => 'hold & release';

  @override
  String get kegelTimerViewQuickPulses => 'Quick pulses';

  @override
  String get kegelTimerViewQuickOnQuickOff => 'quick on, quick off';

  @override
  String get kegelTimerViewWaves => 'Waves';

  @override
  String get kegelTimerViewSoftWhenAroused => 'soft when aroused';

  @override
  String get kegelTimerViewRounds => 'Rounds';

  @override
  String kegelTimerViewMinutesMin(Object minutes) {
    return '≈ $minutes min';
  }

  @override
  String get kegelTimerViewLevel => 'Level';

  @override
  String get kegelTimerViewVoiceCues => 'Voice cues';

  @override
  String get kegelTimerViewAVoiceGuidesYou => 'A voice guides you';

  @override
  String get kegelTimerViewVibrationOnly => 'vibration only';

  @override
  String kegelTimerViewRoundCurrentroundOfTotalrounds(
      Object currentRound, Object totalRounds) {
    return 'Round $currentRound of $totalRounds';
  }

  @override
  String kegelTimerViewPhaseCurrentphaseindexPhaseslength(
      Object currentPhaseIndex, Object phasesLength) {
    return 'Phase $currentPhaseIndex/$phasesLength';
  }

  @override
  String get kegelTimerViewGuidePracticePlan => 'Guide & practice plan';

  @override
  String get kegelTimerViewFindingTheMuscleWhichExercise =>
      'Finding the muscle, which exercise for what, common mistakes, 6-week plan';

  @override
  String get kegelGuideSheetPelvicFloorGuide => 'Pelvic floor guide';

  @override
  String get kegelGuideSheetFindingTheMuscleExercisesPlan =>
      'Finding the muscle, exercises, plan';

  @override
  String get kegelGuideSheetFindingTheMuscle => '1. Finding the muscle';

  @override
  String get kegelGuideSheetBasics => 'BASICS';

  @override
  String get kegelGuideSheetThePelvicFloorStretchesLike =>
      'The pelvic floor stretches like a hammock between pubic bone and tailbone – in everyone. It can do two things: lift and hold, and widen and let go. Both belong to training.';

  @override
  String get kegelGuideSheetTightenAndLift => 'Tighten and lift';

  @override
  String get kegelGuideSheetImagineHoldingBackWindAnd =>
      'Imagine holding back wind and stopping the flow of urine at the same time – only in your imagination.\n• With a vulva: the vaginal opening and perineum draw gently inwards and upwards.\n• With a penis: the base of the penis lifts a little, the testicles draw slightly upwards.';

  @override
  String get kegelGuideSheetLetGoAndWiden => 'Let go and widen';

  @override
  String get kegelGuideSheetBreatheDeepIntoTheBelly =>
      'Breathe deep into the belly. As the belly rounds, let the pelvic floor gently give way downwards – like at the start of urinating, but without pushing. The area between pubic bone and tailbone becomes soft and warm.';

  @override
  String get kegelGuideSheetButtocksThighsAndBellyStay =>
      'Buttocks, thighs and belly stay relaxed. A hand on your buttocks tells you whether they\'re joining in.';

  @override
  String get kegelGuideSheetWhichExerciseForWhat =>
      '2. Which exercise for what?';

  @override
  String get kegelGuideSheetExercises => 'EXERCISES';

  @override
  String get kegelGuideSheetForTensionPainOnPenetration =>
      'for tension, pain on penetration, early ejaculation';

  @override
  String get kegelGuideSheetForEveryoneWhosePelvicFloor =>
      'For everyone whose pelvic floor tends to hold too much. That\'s common with stress, lots of sitting and performance pressure. Start here if you\'re unsure.';

  @override
  String get kegelGuideSheetForSupportControlAndStability =>
      'for support, control and stability';

  @override
  String get kegelGuideSheetStrengthensTheMusclesForExample =>
      'Strengthens the muscles, for example after giving birth, with mild bladder weakness or for more control. Practise at half strength; letting go afterwards is just as important as holding.';

  @override
  String get kegelGuideSheetForResponsiveness => 'for responsiveness';

  @override
  String get kegelGuideSheetAShortSqueezeAndImmediate =>
      'A short squeeze and immediate release trains the fast muscle fibres – for example for the moment of coughing or sneezing.';

  @override
  String get kegelGuideSheetStayingLooseWhenItGets =>
      'staying loose when it gets exciting';

  @override
  String get kegelGuideSheetALongAudibleExhaleWith =>
      'A long, audible exhale with soft perineum and buttocks. Exactly this helps with the wave surfing from courses 8 and 9 to keep arousal high without it spilling over.';

  @override
  String get kegelGuideSheetCommonMistakes => '3. Common mistakes';

  @override
  String get kegelGuideSheetCareful => 'CAREFUL';

  @override
  String get kegelGuideSheetSqueezingTheButtocks => 'Squeezing the buttocks';

  @override
  String get kegelGuideSheetTheBigGlutealMuscleLikes =>
      'The big gluteal muscle likes to sneak in. The buttocks stay soft.';

  @override
  String get kegelGuideSheetHoldingYourBreath => 'Holding your breath';

  @override
  String get kegelGuideSheetKeepBreathingCalmlyWhileHolding =>
      'Keep breathing calmly while holding. Holding your breath increases pressure in the belly.';

  @override
  String get kegelGuideSheetPushingInsteadOfLettingGo =>
      'Pushing instead of letting go';

  @override
  String get kegelGuideSheetWhenLettingGoNothingIs =>
      'When letting go, nothing is pushed down. It\'s a giving way, not a pushing.';

  @override
  String get kegelGuideSheetPractisingWhileActuallyUrinating =>
      'Practising while actually urinating';

  @override
  String get kegelGuideSheetRegularlyStoppingTheFlowOf =>
      'Regularly stopping the flow of urine can disturb bladder emptying. Only practise in your imagination.';

  @override
  String get kegelGuideSheetBetterShortAndRegular => 'Better short and regular';

  @override
  String get kegelGuideSheetAFewMinutesOnMost =>
      'A few minutes on most days do more than an occasional long session.';

  @override
  String get kegelGuideSheetAPlanForSixWeeks => '4. A plan for six weeks';

  @override
  String get kegelGuideSheetPlan => 'PLAN';

  @override
  String get kegelGuideSheetWeek => 'Week 1–2';

  @override
  String get kegelGuideSheetLetGoDailyRoundsEasy =>
      'Let go daily, 5 rounds, easy level. Goal: to clearly feel the widening.';

  @override
  String get kegelGuideSheetWeek2 => 'Week 3–4';

  @override
  String get kegelGuideSheetLetGoRoundsThenStrengthen =>
      'Let go 5 rounds, then strengthen 5 rounds, easy level. Waves on two days.';

  @override
  String get kegelGuideSheetWeek3 => 'Week 5–6';

  @override
  String get kegelGuideSheetRoundsOfYourMainExercise =>
      '10 rounds of your main exercise, medium level. Plus a few quick pulses.';

  @override
  String get kegelGuideSheetAfterThatKeepTwoOr =>
      'After that: keep two or three short sessions a week. And use letting go consciously in intimate moments – breathe deep into the belly, let the pelvic floor sink.';

  @override
  String get kegelGuideSheetWhenToSeeAPhysiotherapist =>
      '5. When to see a physiotherapist?';

  @override
  String get kegelGuideSheetHealth => 'HEALTH';

  @override
  String get kegelGuideSheetSpecialisedPelvicFloorPhysiotherapyCan =>
      'Specialised pelvic floor physiotherapy can examine exactly whether your pelvic floor tends to be too weak or too tight, and guide you specifically. Get advice if you have:\n• pain in the pelvis, during sex or during training\n• bladder or bowel weakness\n• problems after giving birth or pelvic surgery\n• the feeling that you can\'t control the muscle at all';

  @override
  String get kegelGuideSheetBackToTraining => 'Back to training';

  @override
  String get dailyCheckinCardVeryCalm => 'Very calm';

  @override
  String get dailyCheckinCardMild => 'Mild';

  @override
  String get dailyCheckinCardModerate => 'Moderate';

  @override
  String get dailyCheckinCardHigh => 'High';

  @override
  String get dailyCheckinCardExtremeStress => 'Extreme stress';

  @override
  String get dailyCheckinCardClearHead => 'Clear head';

  @override
  String get dailyCheckinCardHardlyAnyPressure => 'Hardly any pressure';

  @override
  String get dailyCheckinCardSomeRestlessness => 'Some restlessness';

  @override
  String get dailyCheckinCardNoticeablyHigh => 'Noticeably high';

  @override
  String get dailyCheckinCardStrongPressure => 'Strong pressure';

  @override
  String get dailyCheckinCardSecondDailyCheckIn => '30-second daily check-in';

  @override
  String get dailyCheckinCardDone => 'Done';

  @override
  String dailyCheckinCardStressStresslevelPressurePressurelevel(
      Object stressLevel, Object pressureLevel) {
    return 'Stress: $stressLevel • Pressure: $pressureLevel';
  }

  @override
  String get dailyCheckinCardHowDoStressPerformancePressure =>
      'How are you doing today?';

  @override
  String get dailyCheckinCardEverydayStressTodayJobAppointments =>
      '1. Everyday stress today (job, appointments, sleep)';

  @override
  String get dailyCheckinCardInnerPerformancePressureRacingThoughts =>
      '2. How much inner pressure do you feel?';

  @override
  String get dailyCheckinCardWhatDidYouGoodToday => '3. What felt good today?';

  @override
  String get dailyCheckinCardSaveDailyCheckIn => 'Save daily check-in';

  @override
  String get dailyCheckinCardUpdateValues => 'Update values';

  @override
  String get dailyCheckinCardCoachingInsightYourEverydayStress =>
      'Your everyday stress is high today. That\'s okay: stress and tiredness often slow desire down all by themselves. That\'s normal, not a flaw.';

  @override
  String get dailyCheckinCardCoachingInsightWhenEverydayStress =>
      'When everyday life is calmer, relaxing often comes more easily. If you like, simply feel into your body today, with no goal at all.';

  @override
  String get onboardingGuest => 'Guest';

  @override
  String get onboardingProfileUpdated => 'Profile updated.';

  @override
  String get onboardingRestoreBackup => 'Restore backup';

  @override
  String get onboardingRestoreYourProfileLessonsCouple =>
      'Restore your profile, lessons & couple channel';

  @override
  String get onboardingBackupFoundOnThisDevice =>
      'Backup found on this device!';

  @override
  String onboardingProfileProfilename(Object profileName) {
    return 'Profile: $profileName';
  }

  @override
  String get onboardingRestoreAutomaticBackupNow =>
      'Restore automatic backup now';

  @override
  String get onboardingReadyInClipboard => 'READY IN CLIPBOARD';

  @override
  String onboardingBackupForProfilename(Object profileName) {
    return 'Backup for: “$profileName”';
  }

  @override
  String get onboardingRestoreFromClipboard => 'Restore from clipboard';

  @override
  String get onboardingPasteBackupCodeJsonManually =>
      'Paste backup code / JSON manually:';

  @override
  String get onboardingPasteJsonTextHereE =>
      'Paste the backup text here (starts with \"app\": \"VelvetPulse\")';

  @override
  String get onboardingPleasePasteTheBackupJson =>
      'Please paste the backup JSON text first.';

  @override
  String get onboardingApplyBackupNow => 'Apply backup now';

  @override
  String get onboardingTheBackupCouldNotBe =>
      'The backup could not be restored.';

  @override
  String get onboardingUser => 'User';

  @override
  String onboardingBackupForNameRestored(Object name) {
    return 'Backup for \"$name\" restored!';
  }

  @override
  String get onboardingProfilePersonalisation => 'Profile & personalisation';

  @override
  String get onboardingWelcomeToVelvetpulse => 'Welcome to VelvetPulse';

  @override
  String get onboardingYourPrivateCoachingProgrammeFor =>
      'A private companion for calm in your body, your pelvic floor and closeness.';

  @override
  String get onboardingPrivateProfileJournalProgressStay =>
      'Private: profile, journal & progress stay on your phone. Only the encrypted couple channel, downloading recordings and the update check (GitHub) go online.';

  @override
  String get onboardingAlreadyUsingVelvetpulse => 'Already using VelvetPulse?';

  @override
  String get onboardingLoadABackupFromFile =>
      'Load a backup from file or clipboard';

  @override
  String get onboardingRestore => 'Restore';

  @override
  String get onboardingWhatShouldWeCallYou => '1. What should we call you?';

  @override
  String get onboardingYourFirstNameOrA => 'Your first name or a nickname';

  @override
  String get onboardingYourGender => '2. Your gender (optional)';

  @override
  String get onboardingAdjustsCourseRecommendationsPelvicFloor =>
      'We only use this to suggest a voice and a body setting, and to keep lessons clear when they talk about “she” or “he”. You can change it any time, and it stays on your phone. “Not specified” is completely fine.';

  @override
  String get onboardingMale => 'Man';

  @override
  String get onboardingFemale => 'Woman';

  @override
  String get onboardingGenderWeitergehen => 'You can also just carry on.';

  @override
  String get onboardingKoerperTitel => 'Body-related exercises (optional)';

  @override
  String get onboardingKoerperText =>
      'Some exercises and body journeys speak about the body very concretely. So we don\'t suggest anything that doesn\'t fit you: which description fits best? This is separate from your gender. You can skip it, and we\'ll only ask when an exercise needs it.';

  @override
  String get onboardingKoerperVulva => 'Vulva';

  @override
  String get onboardingKoerperPenis => 'Penis';

  @override
  String get onboardingKoerperBeides => 'Both, or something else';

  @override
  String get onboardingKoerperSpaeter => 'Ask me later';

  @override
  String onboardingYourAgeSelectedageYears(Object selectedAge) {
    return '3. Your age: $selectedAge years';
  }

  @override
  String get onboardingYourRelationshipStatus => '4. Your relationship status';

  @override
  String get onboardingInARelationshipMarried => 'In a relationship / married';

  @override
  String get onboardingDatingGettingToKnowSomeone =>
      'Dating / getting to know someone';

  @override
  String get onboardingSingle => 'Single';

  @override
  String get onboardingItSComplicated => 'It\'s complicated';

  @override
  String get onboardingWhatSYourBiggestPriority =>
      '5. What would you most like right now?';

  @override
  String get onboardingStopPerformancePressureRacingThoughts =>
      'Less pressure, a calmer mind';

  @override
  String get onboardingBreakThoughtLoopsStopSpectatoring =>
      'Out of your head and back into feeling, without watching yourself.';

  @override
  String get onboardingPelvicFloorRelaxationBodyAwareness =>
      'Relax your pelvic floor & feel your body';

  @override
  String get onboardingReleaseTensionPractiseReverseKegels =>
      'Let go of tension, let your pelvic floor soften, find calm.';

  @override
  String get onboardingCoupleIntimacyPressureFreeSex =>
      'Closeness together, without pressure';

  @override
  String get onboardingSensateFocusTogetherCalmingEach =>
      'Touch without a goal, settling together, being allowed to be close.';

  @override
  String get onboardingDesireSelfAcceptanceBodyAwareness =>
      'Desire, accepting yourself & feeling your body';

  @override
  String get onboardingUnderstandResponsiveDesireEaseOrgasm =>
      'Understand how desire arises for you, and take the pressure off.';

  @override
  String get onboardingSaveChanges => 'Save changes';

  @override
  String get onboardingPersonaliseProgrammeNow => 'Done, let\'s go';

  @override
  String get onboardingSkipGoStraightToThe => 'Later, straight to the app';

  @override
  String onboardingVersionData(Object data) {
    return 'Version $data';
  }

  @override
  String get onboardingCheckForUpdates => 'Check for updates';

  @override
  String get onboardingReceiveBetaVersions => 'Receive beta versions';

  @override
  String get onboardingYouGetNewFeaturesEarlier =>
      'You get new features earlier, possibly with small bugs.';

  @override
  String get onboardingOnlyTestedVersionsWhenSwitching =>
      'Only tested versions. When switching back from beta, your version stays until a newer stable one is released.';

  @override
  String get onboardingDiscretion => 'Discretion';

  @override
  String get onboardingLockWithFingerprint => 'Lock with fingerprint';

  @override
  String get onboardingOnOpeningAndAfterOne =>
      'On opening and after one minute in the background. Content is hidden in the app overview, screenshots are blocked.';

  @override
  String get onboardingNoScreenLockIsSet =>
      'No screen lock is set up on this device.';

  @override
  String get onboardingTheAppIsNowCalled =>
      'The app is now called “Pulse”. The home screen takes a few seconds to update.';

  @override
  String get onboardingTheAppIsCalledVelvetpulse =>
      'The app is called “VelvetPulse” again.';

  @override
  String get onboardingDiscreetAppIcon => 'Discreet app icon';

  @override
  String get onboardingShowsPulseWithANeutral =>
      'Shows “Pulse” with a neutral icon on the home screen.';

  @override
  String get onboardingCallYourPartnerByName =>
      'Call your partner by name in lessons';

  @override
  String get onboardingForExampleAnnaLiesOn =>
      'For example “Anna lies on her back” instead of “she lies”. Turn off if someone often reads along.';

  @override
  String get onboardingAndroidHasnTAllowedNotifications =>
      'Android hasn\'t allowed notifications for the app. You can change that in the Android settings.';

  @override
  String get onboardingNotifyAboutNewMessages => 'Notify about new messages';

  @override
  String get onboardingEvenWhenTheAppIs =>
      'Even when the app is closed: only “New message”, without content or names. When the app is closed it can take up to 15 minutes.';

  @override
  String get onboardingPrivacyUpdateSafety => 'Privacy & update safety';

  @override
  String get onboardingEverythingStaysLocalOnYour =>
      'Everything stays local on your device and survives updates. The couple connection is stored encrypted in the Android keystore and only goes into a backup with a password.';

  @override
  String get onboardingExportBackup => 'Export backup';

  @override
  String get backupDialogsWhatShouldGoIntoThe =>
      'What should go into the backup?';

  @override
  String get backupDialogsOnlyYourDataProfileProgress =>
      'Only your data: profile, progress, reflections, journal, wishes. Enough for this phone.\n\nWith password: additionally the couple channel connection, encrypted. You need this for moving to another phone.';

  @override
  String get backupDialogsDataOnly => 'Data only';

  @override
  String get backupDialogsWithPassword => 'With password';

  @override
  String get backupDialogsBackupCopied => 'Backup copied';

  @override
  String get backupDialogsOk => 'OK';

  @override
  String get backupDialogsOlderBackup => 'Older backup';

  @override
  String get backupDialogsThisBackupComesFromAn =>
      'This backup comes from an older version and contains your connection key unencrypted. It will be restored anyway.\n\nAfterwards, delete the old backup wherever you kept it, and create a new one with a password if needed.';

  @override
  String get backupDialogsRestore => 'Restore';

  @override
  String get backupDialogsBackupPassword => 'Backup password';

  @override
  String get backupDialogsThisAlsoBringsBackThe =>
      'This also brings back the couple channel connection.';

  @override
  String get backupDialogsPassword => 'Password';

  @override
  String get backupDialogsWithoutKeys => 'Without keys';

  @override
  String get backupDialogsPasswordForTheBackup => 'Password for the backup';

  @override
  String get backupDialogsPasswordAtLeastCharacters =>
      'Password (at least 8 characters)';

  @override
  String get backupDialogsRepeatPassword => 'Repeat password';

  @override
  String get backupDialogsPleaseUseAtLeastCharacters =>
      'Please use at least 8 characters.';

  @override
  String get backupDialogsThePasswordsDonTMatch =>
      'The passwords don\'t match.';

  @override
  String get backupDialogsEncrypt => 'Encrypt';

  @override
  String get backupDialogsOneMoment => 'One moment …';

  @override
  String get backupDialogsBackupCopiedText =>
      'The backup is in the clipboard. Paste it into a note or a private document.';

  @override
  String get backupDialogsPasswordCannotBeReset =>
      '\n\nWithout your password, the connection can\'t be restored. We can\'t reset it either.';

  @override
  String get checkinActionBreathed => 'Took a few deep breaths';

  @override
  String get checkinActionPelvicFloor => 'Let my pelvic floor soften';

  @override
  String get checkinActionPhoneAway => 'Put the phone away in the evening';

  @override
  String get checkinActionWalk => 'Went for a walk in fresh air';

  @override
  String get checkinActionSkinContact => 'Noticed skin contact';

  @override
  String get checkinActionOpenWord => 'Shared an honest word with my partner';

  @override
  String get dailySimmeringCardTheSecondWallTease => 'The 45-second wall tease';

  @override
  String get dailySimmeringCardCourseTeasing => 'COURSE 15 • TEASING';

  @override
  String get dailySimmeringCardTodayBrieflyPressYourPartner =>
      'If you both enjoy this kind of thing: draw your partner close for a moment today, kiss their neck slowly, whisper a promise in their ear. After 45 seconds, smile and walk on: \"We\'ll save the rest for later.\"';

  @override
  String get dailySimmeringCardJawMeltVoiceActivation =>
      'Jaw melt & voice activation';

  @override
  String get dailySimmeringCardCourseAudiblePleasure =>
      'COURSE 21 • AUDIBLE PLEASURE';

  @override
  String get dailySimmeringCardPlaceYourFingersOnYour =>
      'Place your fingers on your jaw joints, open your mouth and let 3 deep, low sighs vibrate audibly through the room. Feel your pelvic floor giving way downwards at the same time.';

  @override
  String get dailySimmeringCardThePmAnticipation => 'The 3 pm anticipation';

  @override
  String get dailySimmeringCardCourseAnticipation => 'COURSE 15 • ANTICIPATION';

  @override
  String get dailySimmeringCardThisAfternoonSendYourPartner =>
      'Only if you both like this: send your partner a message this afternoon that builds anticipation without expecting anything.';

  @override
  String get dailySimmeringCardSlowMotionWhilePouring =>
      'Slow motion while pouring';

  @override
  String get dailySimmeringCardCourseSlowSex => 'COURSE 15 • SLOW SEX';

  @override
  String get dailySimmeringCardTodayTouchYourPartnerDuring =>
      'Today, touch your partner during an everyday moment (at the table, on the sofa) at an extreme 10% slow-motion pace. Stroke the back of their hand and forearm teasingly slowly for 60 seconds.';

  @override
  String get dailySimmeringCardTheMinuteSilkScarfRitual =>
      'The 15-minute silk scarf ritual';

  @override
  String get dailySimmeringCardCourseSurrender => 'COURSE 23 • SURRENDER';

  @override
  String get dailySimmeringCardAgreeForTonightOneOf =>
      'Agree for tonight: one of you is blindfolded and doesn\'t have to do or give back anything at all. The other directs 15 minutes of gentle touch.';

  @override
  String get dailySimmeringCardTheStrictNoPenetrationRule =>
      'No penetration today';

  @override
  String get dailySimmeringCardCourseSensateFocus =>
      'COURSE 17 • TOUCH WITHOUT A GOAL';

  @override
  String get dailySimmeringCardAgreeTodayYouMayHug =>
      'Agree today: you may hug, kiss and caress each other naked – penetration stays out of it today. Everything may happen, nothing has to.';

  @override
  String get dailySimmeringCardSensoryNarratingWordsInThe =>
      'Sensory narrating (words in the ear)';

  @override
  String get dailySimmeringCardCbtLettingGoOfPropriety =>
      'CBT • LETTING GO OF PROPRIETY';

  @override
  String get dailySimmeringCardTonightInTheDarkWhisper =>
      'Tonight in the dark, whisper one single honest, sensual sensation into your partner\'s ear: \"It drives me crazy how warm and soft your skin feels under my hand right now.\"';

  @override
  String get dailySimmeringCardTheCharmingDreamBridge =>
      'The charming dream bridge';

  @override
  String get dailySimmeringCardCourseFantasies => 'COURSE 23 • FANTASIES';

  @override
  String get dailySimmeringCardTodayCasuallyAndWithA =>
      'Today, casually and with a smile, mention a \"naughty dream\" you had about the two of you. Watch the reaction.';

  @override
  String get dailySimmeringCardTheSeatedPelvicFloorCheck =>
      'The seated pelvic floor check';

  @override
  String get dailySimmeringCardCoursesBody => 'COURSES 7 & 9 • BODY';

  @override
  String get dailySimmeringCardNoticeRightNowAreYou =>
      'Notice right now: are you holding tension in your pelvis or anus? Breathe in deeply and let your pelvic floor sink down like an opening flower (reverse Kegel).';

  @override
  String get dailySimmeringCardSoftBellyFullSurrender =>
      'Soft belly • full surrender';

  @override
  String get dailySimmeringCardCourseRadicalBodyLove =>
      'COURSE 6 • RADICAL BODY LOVE';

  @override
  String get dailySimmeringCardTodayConsciouslyLetYourBelly =>
      'Today, consciously let your belly relax outwards. Perfection is cold – surrender and warmth are irresistible.';

  @override
  String get dailySimmeringCardJawMeltPelvicVibration =>
      'Jaw melt & pelvic vibration';

  @override
  String get dailySimmeringCardOpenYourMouthSmoothOut =>
      'Open your mouth, smooth out your cheeks and sigh 3 times deep and low. Feel the vibration travel down towards your pubic bone.';

  @override
  String get dailySimmeringCardBroadPalmTouchWithWarm =>
      'Broad palm touch with warm oil';

  @override
  String get dailySimmeringCardCourseBodyLab => 'COURSE 19 • RELEARNING TOUCH';

  @override
  String get dailySimmeringCardTodaySkipAnyTightGrip =>
      'Today, skip any tight grip when touching yourself. Use plenty of lubricant and move your whole flat palm over your pelvis in slow motion.';

  @override
  String get dailySimmeringCardOrbitingExploringThePerineum =>
      'Orbiting: exploring the perineum';

  @override
  String get dailySimmeringCardCoursesOrbiting => 'COURSES 8 & 9 • ORBITING';

  @override
  String get dailySimmeringCardLeaveTheHighlySensitiveTip =>
      'Leave the highly sensitive tip completely untouched for 10 minutes today. Focus touch only on the perineum, the base of the shaft and the groin.';

  @override
  String get dailySimmeringCardPlateauSurfingAtLevel =>
      'Feeling arousal without a goal';

  @override
  String get dailySimmeringCardCourseStayingPower =>
      'COURSE 19 • STAYING POWER';

  @override
  String get dailySimmeringCardBringYourArousalToLevel =>
      'If you like: notice how your arousal feels today and let it come and go without a goal. If it gets to be too much, pause, breathe out deeply 3 times and let your pelvic floor soften.';

  @override
  String get dailySimmeringCardScreenFreeSensing => 'Screen-free sensing';

  @override
  String get dailySimmeringCardCourseRecalibration =>
      'COURSE 10 • RECALIBRATION';

  @override
  String get dailySimmeringCardTakeMinutesTodayWithoutAny =>
      'Take 10 minutes today without any phone or screens. Close your eyes and pay attention only to temperature and breath.';

  @override
  String get dailySimmeringCardTheSphincterReleaseTest =>
      'The sphincter release test';

  @override
  String get dailySimmeringCardCourseMultipleOrgasms =>
      'COURSE 19 • LETTING GO';

  @override
  String get dailySimmeringCardObserveYourReflexesWhenArousal =>
      'Observe your reflexes: when arousal rises, consciously let your anal sphincter relax instead of tightening it.';

  @override
  String get dailySimmeringCardZeroPressureSquatMalasana =>
      'Zero-pressure squat (malasana)';

  @override
  String get dailySimmeringCardCourseFascia => 'COURSE 7 • FASCIA';

  @override
  String get dailySimmeringCardGoIntoADeepSquat =>
      'Go into a deep squat for 2 minutes. Take 10 deep breaths into your open pelvis.';

  @override
  String get dailySimmeringCardBodyCompassionInTheMirror =>
      'Body compassion in the mirror';

  @override
  String get dailySimmeringCardCourseSelfCompassion =>
      'COURSE 6 • SELF-COMPASSION';

  @override
  String get dailySimmeringCardLookAtYourBodyToday =>
      'Look at your body today without judgement. Tell yourself: \"My body is alive, breathing and capable of deep pleasure.\"';

  @override
  String get dailySimmeringCardPhysiologicalSighQuickCalming => 'The long sigh';

  @override
  String get dailySimmeringCardToolCalmDown => 'PRACTICE • CALM';

  @override
  String get dailySimmeringCardBreatheInTwiceDeeplyThrough =>
      'Breathe in twice deeply through the nose, then sigh out very long and audibly through the open mouth. 3 repetitions.';

  @override
  String get dailySimmeringCardThePercentPactWithYourself =>
      'The 90 percent pact with yourself';

  @override
  String get dailySimmeringCardGiveYourselfMinutesOfPleasure =>
      'Give yourself 10 minutes of pleasure today – but decide to stop consciously at 90%, without rushing to the finish.';

  @override
  String get dailySimmeringCardTodaySEroticSpark => 'TODAY\'S EROTIC SPARK';

  @override
  String get dailySimmeringCardSimmeringEverydayTeasing =>
      'Simmering & everyday teasing';

  @override
  String get dailySimmeringCardTapHereToRevealToday =>
      'Tap here to reveal today\'s 45-second spark...';

  @override
  String get dailySimmeringCardOpen => 'OPEN';

  @override
  String get userProfileNonBinaryOpen => 'Non-binary';

  @override
  String get userProfileInARelationshipMarried => 'In a relationship / married';

  @override
  String get userProfileDatingGettingToKnowSomeone =>
      'Dating / getting to know someone';

  @override
  String get userProfileSingle => 'Single';

  @override
  String get userProfileComplicated => 'Complicated';

  @override
  String get userProfilePelvicFloorBody => 'Pelvic floor & feeling your body';

  @override
  String get userProfileCoupleIntimacyCloseness =>
      'Couple intimacy & closeness';

  @override
  String get userProfileDesireRelaxation => 'Desire & relaxation';

  @override
  String get userProfileJustLookingAround => 'Just looking around';

  @override
  String get userProfileEasingPerformancePressure => 'Less pressure';

  @override
  String get contentModelsTheArtOfTouchFor => 'THE ART OF TOUCH • WITH A VULVA';

  @override
  String get contentModelsTouchLabForHim => 'TOUCH LAB • WITH A PENIS';

  @override
  String get contentModelsSelfExploration => 'SELF-EXPLORATION';

  @override
  String get contentModelsVoiceBody => 'VOICE & BODY';

  @override
  String get contentModelsAnticipationDesire => 'ANTICIPATION & DESIRE';

  @override
  String get contentModelsPolarityRoles => 'POLARITY & ROLES';

  @override
  String get contentModelsBodyPresence => 'BODY PRESENCE';

  @override
  String get contentModelsForHer => 'WITH A VULVA';

  @override
  String get contentModelsForCouples => 'FOR COUPLES';

  @override
  String get contentModelsForHim => 'WITH A PENIS';

  @override
  String get yesNoMaybeModelsExcitesMeIDLike =>
      'Excites me, I\'d like to try it';

  @override
  String get yesNoMaybeModelsCuriousButUnsureDependsOn =>
      'Curious but unsure – depends on the moment';

  @override
  String get yesNoMaybeModelsNotForMe => 'Not for me';

  @override
  String get backupCodecTheBackupIsTooLarge => 'The backup is too large.';

  @override
  String get backupCodecThisIsNotAValid =>
      'This is not a valid backup (not JSON).';

  @override
  String get backupCodecThisIsNotAValid2 => 'This is not a valid backup.';

  @override
  String get backupCodecThisIsNotAVelvetpulse =>
      'This is not a VelvetPulse backup.';

  @override
  String get backupCodecThisBackupComesFromA =>
      'This backup comes from a newer app version. Please update first.';

  @override
  String backupCodecTheBackupIsDamagedField(Object key) {
    return 'The backup is damaged (field “$key”).';
  }

  @override
  String get backupCodecTheBackupContainsAnInvalid =>
      'The backup contains an invalid connection key.';

  @override
  String get backupCodecTheBackupIsDamagedField2 =>
      'The backup is damaged (field “secrets”).';

  @override
  String backupCodecTheBackupIsDamagedField3(Object field) {
    return 'The backup is damaged (field “$field” too long).';
  }

  @override
  String backupCodecTheBackupIsDamagedField4(Object field) {
    return 'The backup is damaged (field “$field” too long).';
  }

  @override
  String get backupCodecThePasswordIsWrongOr =>
      'The password is wrong, or the backup has been damaged.';

  @override
  String get backupCodecTheBackupIsDamaged => 'The backup is damaged.';

  @override
  String get messageNotifierNewMessages => 'New messages';

  @override
  String get messageNotifierNewMessage => 'New message';

  @override
  String get messageNotifierNoticeOfNewMessagesIn =>
      'Notice of new messages in the couple channel, without content';

  @override
  String get nostrServiceWeReConnected => '💛 We\'re connected!';

  @override
  String nostrServiceCountOfFallbackrelayslengthServers(
      Object count, Object fallbackRelaysLength) {
    return '$count of $fallbackRelaysLength servers';
  }

  @override
  String get nostrServiceVotedOnTheFantasySelection =>
      'Voted on the fantasy selection';

  @override
  String nostrServiceHaveAReadLessontitleCoursetitle(
      Object lessonTitle, Object courseTitle) {
    return '📖 Have a read: “$lessonTitle” ($courseTitle)';
  }

  @override
  String nostrServiceIVeSharedMyThoughts(Object lessonTitle) {
    return '💭 I\'ve shared my thoughts on “$lessonTitle”. You\'ll see them as soon as you\'ve answered yourself.';
  }

  @override
  String get nostrServiceIVeSharedMyAnswers =>
      '🗳️ I\'ve shared my answers to the yes/no list.';

  @override
  String get privacyServiceUnlockTheApp => 'Unlock the app';

  @override
  String get privacyServiceConfirmToTurnOnThe =>
      'Confirm to turn on the app lock';

  @override
  String get storageServiceTheBackupIsDamagedProfile =>
      'The backup is damaged (profile).';

  @override
  String get storageServiceReflections => 'Reflections';

  @override
  String get storageServiceYesNoList => 'Yes/no list';

  @override
  String get storageServiceTheKeysInTheBackup =>
      'The keys in the backup don\'t match.';

  @override
  String get storageServiceTheBackupCouldNotBe =>
      'The backup could not be restored. Nothing was changed.';

  @override
  String storageServiceTheBackupIsDamagedFeld(Object feld) {
    return 'The backup is damaged ($feld).';
  }

  @override
  String get spracheHinweis =>
      'Interface, courses and exercises. German recordings are built in; English recordings can be downloaded.';

  @override
  String get cueEinatmenWeit => 'Breathe in. And widen.';

  @override
  String get cueWeichBleiben => 'Stay soft.';

  @override
  String get cueAnspannen => 'Tighten. And gently lift.';

  @override
  String get cueHalten => 'Hold. Keep breathing.';

  @override
  String get cueLoslassen => 'And let go completely.';

  @override
  String get cueNachspueren => 'Notice.';

  @override
  String get cueAn => 'On.';

  @override
  String get cueLos => 'Off.';

  @override
  String get cueWelle => 'Breathe in. Perineum and buttocks soft.';

  @override
  String get cueSeufzen => 'Breathe out. Long and audible.';

  @override
  String get cueStart => 'Let\'s begin.';

  @override
  String get cueFertig => 'Done. Stay with the feeling for a moment.';

  @override
  String get audioPaketTitel => 'English voices';

  @override
  String audioPaketText(int mb) {
    return 'English recordings for lessons, shared evening, self-exploration and pelvic floor training (approx. $mb MB). Without them, your device\'s voice reads aloud.';
  }

  @override
  String audioPaketInstalliert(int mb) {
    return 'Installed ($mb MB). The recordings are stored on this device only.';
  }

  @override
  String get audioPaketLaden => 'Download';

  @override
  String get audioPaketLoeschen => 'Delete';

  @override
  String get audioPaketFertig => 'English voices are ready.';

  @override
  String get audioPaketFehler =>
      'That didn\'t work. Please check your internet connection and try again later.';

  @override
  String get navPaarKanalKurz => 'Couple';

  @override
  String get spicyModus => 'Spicy mode';

  @override
  String get spicyModusText =>
      '18+. Unlocks the levels “Spicy” and “Extra spicy” in the body journey and the shared evening.';

  @override
  String get heuteFuerHeute => 'For today';

  @override
  String get designTitel => 'Appearance';

  @override
  String get designText =>
      'Paper is light, Night paper is dark. Spicy mode uses its own colours.';

  @override
  String get designPapier => 'Paper';

  @override
  String get designNacht => 'Night paper';

  @override
  String get designKlassisch => 'Classic';

  @override
  String get spicyEinschaltenTitel => 'Turn on spicy mode?';

  @override
  String get spicyEinschaltenText =>
      'Adults only. The body journey and the shared evening will then offer two extra levels:\n\n“Spicy”: hot and direct, playing with arousal to just before climax, for couples also kisses, teasing and the mouth.\n\n“Extra spicy”: the same with dirty talk and crude words.\n\nEverything stays an invitation, and a stop word always applies. You can turn the mode off here at any time, and the levels disappear straight away.';

  @override
  String get spicyEinschalten => 'I\'m 18+, turn on';

  @override
  String get alterTitel => 'Are you 18 or older?';

  @override
  String get alterText =>
      'This area is for adults only. Enter the month and year you were born. The app only calculates and does not store the date. Everything stays on this device. This does not replace an ID check.';

  @override
  String get alterMonat => 'Month';

  @override
  String get alterJahr => 'Year';

  @override
  String get alterWeiter => 'Continue';

  @override
  String get alterGesperrtTitel => 'Not possible right now';

  @override
  String get alterGesperrtText =>
      'This area is only available from age 18. You can try again later.';

  @override
  String get alterSperreFehltTitel => 'Device lock needed';

  @override
  String get alterSperreFehltText =>
      'First set up a screen lock (PIN, pattern or fingerprint) on your device. It protects this area from other people.';

  @override
  String get alterSperreGrund =>
      'Please confirm that you want to open this area.';

  @override
  String get alterAbsichern => 'Always ask again';

  @override
  String get alterAbsichernText =>
      'After an app restart or 5 hours in the background, the app asks for your device lock again.';

  @override
  String get alterGesperrtKurz => 'Locked. Turn on to unlock.';

  @override
  String get spicyStufe => 'Spicy';

  @override
  String get selbstReiseSpicyText =>
      'Start right on the skin, then waves of arousal to just before the edge, and at the end your choice: come or savour.';

  @override
  String get paarAbendSpicyText =>
      'Teasing, kisses all over the body, hand and mouth on the genitals, playing with the edge. Only if you both want it.';

  @override
  String get paarAbendSpicyHinweis =>
      'Talk briefly beforehand about wishes and limits, and agree on a stop word. Whoever says it gets an immediate pause, no discussion. Green, yellow, red helps in between.';

  @override
  String get sehrSpicyStufe => 'Extra spicy';

  @override
  String get selbstReiseSehrSpicyText =>
      'Like Spicy, but with dirty talk: crude words, greedy and shameless.';

  @override
  String get paarAbendSehrSpicyText =>
      'Like Spicy, but with dirty talk: crude words, greedy and shameless. Only if you both want it.';

  @override
  String audioPaketUpdate(int mb) {
    return 'New English recordings are available (about $mb MB). Until then, the device voice reads the new texts.';
  }

  @override
  String get audioPaketAktualisieren => 'Update';

  @override
  String get gefuehrtTitel => 'Guided audio';

  @override
  String get gefuehrtSelbstTitel => 'Body journey';

  @override
  String get gefuehrtSelbstText =>
      '10 to 30 minutes just for you: a voice guides you across your body, as close as you like.';

  @override
  String get lessonDetailTryGuidedEvening =>
      'Try it guided now: Shared evening';

  @override
  String get spicyEinladen => 'Invite to spicy mode';

  @override
  String get spicyEinladungText =>
      'I\'ve turned on spicy mode. Would you like to try it too? (Profile › Spicy mode)';

  @override
  String get spicyEinladungAnnehmen => 'Look at spicy mode';

  @override
  String get spicyEinladungSchonAn => 'Spicy mode is already on for you.';

  @override
  String get spicyEinladungGesendet => 'Invitation sent.';

  @override
  String get spicyEinladungFehler =>
      'That didn\'t work. Please try again later.';

  @override
  String get spicyFunkeLippen => 'I\'m thinking about your lips';

  @override
  String get spicyFunkeHeuteAbend => 'Tonight you\'re mine';

  @override
  String get spicyFunkeScharf => 'I\'ve been hot for you all day';

  @override
  String get spicyFunkeSchmecken => 'I want to taste you tonight';

  @override
  String get spicyFunkeNichtsDrunter => 'Wear nothing underneath today';

  @override
  String get spicyFunkeNackt => 'I want to see you naked';

  @override
  String get spicyFunkeFicken => 'I want to fuck you. Today.';

  @override
  String get spicyFunkeNachHause => 'Come home right now';

  @override
  String get verschwindenSchalter => 'Disappearing message';

  @override
  String get verschwindenHinweis => 'Disappears 10 min after reading …';

  @override
  String get verschwindetLabel => 'Disappears after reading';

  @override
  String get fotoNachricht =>
      '📷 A photo for you, viewable only once. Open VelvetPulse and it comes straight to you.';

  @override
  String get fotoSenden => 'Send photo';

  @override
  String get fotoKamera => 'Camera';

  @override
  String get fotoGalerie => 'Gallery';

  @override
  String get fotoSicherheitHinweis =>
      'The photo travels encrypted directly from phone to phone and can be viewed only once. Safest without your face or recognisable surroundings. A second phone can still photograph the screen.';

  @override
  String get fotoNichtDa =>
      'Your partner doesn\'t have VelvetPulse open right now. The photo stays encrypted on your phone and goes out as soon as you both have the app open.';

  @override
  String get fotoFehler =>
      'The photo couldn\'t be announced. Please try again later.';

  @override
  String get fotoStatusWartet =>
      'Photo arrives once you both have the app open';

  @override
  String get fotoStatusLaedt => 'Transferring photo …';

  @override
  String get fotoAnsehen => 'View photo (only once)';

  @override
  String get fotoStatusAngesehen => 'Photo viewed';

  @override
  String get fotoStatusWartetRaus => 'Waiting for your partner';

  @override
  String get fotoStatusZugestellt => 'Delivered';

  @override
  String get fotoStatusFehler => 'Not delivered';

  @override
  String get fotoAnsichtHinweis =>
      'Visible only now. When you close it, the photo is deleted.';

  @override
  String get fotoWeg => 'This photo is no longer available.';

  @override
  String get anleitungTitel => 'How VelvetPulse works';

  @override
  String get anleitungEinleitung =>
      'Here you\'ll find every part of the app briefly explained. Tap a section to expand it.';

  @override
  String get fotoIdeeTitel => 'PHOTO IDEA FOR TODAY';

  @override
  String get fotoIdeeHinweis => 'Entirely optional. Safest without your face.';

  @override
  String get fotoIdeeAndere => 'Another idea';

  @override
  String get fotoIdeeHeuteNicht => 'Not today';

  @override
  String get fotoIdeenAnzeigen => 'Show photo ideas';

  @override
  String get fotoIdeeHinweisHeiss =>
      'Entirely optional. Please no face, tattoos or recognisable room.';

  @override
  String get fotoAlleinTitel => 'Are you alone?';

  @override
  String get fotoAlleinText =>
      'The photo can be viewed only once. It\'s best to look at it when you\'re alone and nobody is looking over your shoulder.';

  @override
  String get fotoJetztAnsehen => 'View now';

  @override
  String get fotoSpaeter => 'Later';

  @override
  String get fotoExperimentell => 'Experimental';

  @override
  String get fotoExperimentellHinweis =>
      'Photos are new: on some mobile networks the direct connection can\'t be made yet.';

  @override
  String get pairingAnfrageTitel => 'Your code was scanned';

  @override
  String get pairingAnfrageText =>
      'A phone just scanned your code and wants to connect with you. Only confirm if it\'s your partner\'s phone.';

  @override
  String get pairingAnfrageVerbinden => 'Connect';

  @override
  String get rueckmeldungTitel => 'Send feedback';

  @override
  String get rueckmeldungEinleitung =>
      'A wish for a new feature, a bug, or a word that sounds wrong? Let us know, anonymously and encrypted.';

  @override
  String get rueckmeldungWunsch => 'Wish';

  @override
  String get rueckmeldungFehlerArt => 'Bug';

  @override
  String get rueckmeldungAussprache => 'Pronunciation';

  @override
  String get rueckmeldungNachricht => 'Your message';

  @override
  String get rueckmeldungFehlerHinweis =>
      'What happened, and where in the app?';

  @override
  String get rueckmeldungWort => 'Which word sounds wrong?';

  @override
  String get rueckmeldungSoll => 'How it should sound (optional)';

  @override
  String get rueckmeldungSollHinweis => 'e.g. stress on the second syllable';

  @override
  String get rueckmeldungAnmerkung => 'Note (optional)';

  @override
  String get rueckmeldungKontakt => 'Contact for questions (optional)';

  @override
  String get rueckmeldungKontaktHinweis => 'e.g. email or Nostr npub';

  @override
  String get rueckmeldungDatenschutz =>
      'The message travels encrypted over Nostr to the VelvetPulse feedback inbox, with a one-time key and no link to your couple channel. Only what you enter here is sent, plus app version and language. The relays see your IP address, not the content.';

  @override
  String get rueckmeldungSenden => 'Send anonymously';

  @override
  String get rueckmeldungDanke => 'Thank you! Your feedback has arrived.';

  @override
  String get rueckmeldungFehler =>
      'Sending didn\'t work. Please check your internet connection and try again.';

  @override
  String get rueckmeldungGithub => 'Report publicly on GitHub instead';

  @override
  String get einschlafKarteTitel => 'Falling asleep';

  @override
  String get einschlafKarteTitelNeutral => 'Relaxation';

  @override
  String get einschlafKarteText =>
      'A long, quiet journey into sleep: 60 to 120 minutes with sentences you take with you into half-sleep.';

  @override
  String get einschlafTitel => 'Drift-off journey';

  @override
  String get einschlafEinleitung =>
      'A voice accompanies you into sleep as you lie in bed. It speaks less and less, the pauses grow longer, and in the end only a soft sound remains. You may, and are meant to, fall asleep.';

  @override
  String get einschlafWirkung =>
      'The sentences work mostly in the quiet time before you fall asleep, and through repetition over many evenings. Nothing is learned in deep sleep.';

  @override
  String get einschlafHinweise =>
      'Not while driving or when you need to stay awake. Keep the volume low; headphones only if they are comfortable, otherwise use the speaker. Best with the charger plugged in. The drift-off journey does not replace treatment for sleep disorders.';

  @override
  String get einschlafLaenge => 'Length';

  @override
  String get einschlafSchwerpunkt => 'Focus';

  @override
  String get traumKarteTitel => 'Dream evening';

  @override
  String get traumKarteTitelNeutral => 'Calm';

  @override
  String get traumKarteText =>
      'Gently into sleep and into a sensual dream: 30 to 60 minutes with a dream image of your choice.';

  @override
  String get traumTitel => 'Dream evening';

  @override
  String get traumEinleitung =>
      'A voice accompanies you into sleep and offers you a dream image. Then it quietly repeats your dream intention, with ever longer pauses, until only silence remains. You may fall asleep along the way.';

  @override
  String get traumBild => 'Dream image';

  @override
  String get traumBildWarmesWasser => 'Warm water';

  @override
  String get traumBildOrtFuerMich => 'A place for me';

  @override
  String get traumBildKoerperImLicht => 'Body in light';

  @override
  String get traumBildBegegnung => 'Encounter';

  @override
  String get traumBildKlarheit => 'Clarity';

  @override
  String get einschlafUeberrasch => 'Surprise me';

  @override
  String get einschlafThemaKoerper => 'My body is welcome';

  @override
  String get einschlafThemaWelle => 'Desire is a wave';

  @override
  String get einschlafThemaGaspedal => 'Gas pedal and brake';

  @override
  String get einschlafThemaSpueren => 'Feeling instead of watching';

  @override
  String get einschlafThemaBecken => 'A soft pelvis';

  @override
  String get einschlafThemaGeniessen => 'I may enjoy';

  @override
  String get einschlafOhneBezug => 'No reference';

  @override
  String get einschlafSpicyTitel => 'More explicit words';

  @override
  String get einschlafSpicyText =>
      'Calm, anatomical language for your own genitals. No dirty talk, nothing exciting.';

  @override
  String get einschlafStart => 'Begin the drift-off journey';

  @override
  String get einschlafLaeuft => 'You may fall asleep';

  @override
  String get einschlafLaeuftText =>
      'The voice grows quieter and rarer. In the end everything stops by itself.';

  @override
  String get einschlafBeenden => 'End the drift-off journey?';

  @override
  String get einschlafBeendenText => 'The guidance will then stop.';

  @override
  String get aufnahmenTitel => 'Recordings';

  @override
  String get aufnahmenText =>
      'Download the spoken recordings by Victoria and Martin here, ideally on Wi-Fi. Without them, your phone\'s voice reads aloud.';

  @override
  String get aufnahmenLektionen => 'Lessons';

  @override
  String get aufnahmenGefuehrt => 'Guided audio';

  @override
  String aufnahmenGroesse(int mb) {
    return '$mb MB';
  }

  @override
  String aufnahmenInstalliert(int mb) {
    return 'downloaded, $mb MB';
  }

  @override
  String get aufnahmenLaden => 'Download';

  @override
  String aufnahmenAlleLaden(int mb) {
    return 'Download all ($mb MB)';
  }

  @override
  String get aufnahmenFertig => 'Recordings downloaded.';

  @override
  String get aufnahmenFehler =>
      'Downloading didn\'t work. Please check your internet connection and try again.';

  @override
  String get aufnahmenNichtErreichbar =>
      'The list of recordings can\'t be reached right now. Please try again later.';

  @override
  String get aufnahmenHinweisTitel => 'Download recordings';

  @override
  String get aufnahmenHinweisText =>
      'So that Victoria and Martin voice the lessons and guided audio, download the recordings once. Until then, your phone\'s voice reads aloud.';

  @override
  String get aufnahmenSpaeter => 'Later';

  @override
  String get aufnahmenAnsehen => 'View';

  @override
  String get fotoErneutVersuchen => 'Try again now';

  @override
  String get fotoStatusWeg => 'Photo no longer available';

  @override
  String get tagebuchTitel => 'Dream journal';

  @override
  String get tagebuchTipp =>
      'Right after waking, lie still for a moment and bring the dream back before you move. A few keywords are enough. „Nothing remembered“ counts too.';

  @override
  String get tagebuchPause =>
      'Lately you have noted unpleasant dreams or poor sleep more often. That is normal and not a failure. A break might do you good, or just the journal and gentle dream images. If something weighs on you, the SOS button helps.';

  @override
  String get tagebuchWoranErinnerst => 'What do you remember?';

  @override
  String get tagebuchNichtsErinnert => 'Nothing remembered';

  @override
  String get tagebuchPrivat =>
      'Your dream journal is private. Sensual dreams are a sign that your desire is alive. Who appears in them and what happens need not mean anything. Entries are not sent to your partner and never leave your device; they are part of your encrypted backup.';

  @override
  String get tagebuchHinweisText => 'Keywords, an image, a feeling …';

  @override
  String get tagebuchLoeschen => 'Delete';

  @override
  String get tagebuchSpeichern => 'Save';

  @override
  String get tagebuchMarkeErinnert => 'remembered';

  @override
  String get tagebuchMarkeLuzide => 'lucid';

  @override
  String get tagebuchMarkeSinnlich => 'sensual';

  @override
  String get tagebuchMarkeHoehepunkt => 'climax';

  @override
  String get tagebuchMarkeUnangenehm => 'unpleasant';

  @override
  String get tagebuchMarkeSchlechtGeschlafen => 'slept badly';

  @override
  String get tagebuchKarteTitel => 'What do you remember?';

  @override
  String get tagebuchKarteTitelNeutral => 'Morning note';

  @override
  String get tagebuchKarteText =>
      'Capture your dream while it is still close. A few words are enough.';

  @override
  String get tagebuchKarteTextNeutral =>
      'A few words for yourself, first thing in the morning.';

  @override
  String get traumpraxisTitel => 'Your dream practice';

  @override
  String get praxisZeichenTitel => 'Your dream signs';

  @override
  String get praxisZeichenText =>
      'What keeps appearing in your dreams? A place, an impossible transition, an unusual light? Name a sign you would like to recognise within a dream.';

  @override
  String get praxisZeichenLeer =>
      'No dream signs yet. You can begin with a detail from your journal.';

  @override
  String get praxisZeichenFeld => 'My dream sign';

  @override
  String get praxisZeichenBeispiel =>
      'For example: a doorway in an impossible place';

  @override
  String get praxisHinzufuegen => 'Add';

  @override
  String get praxisSpeichern => 'Save';

  @override
  String get praxisAbbrechen => 'Cancel';

  @override
  String get praxisBearbeiten => 'Edit';

  @override
  String get praxisLoeschen => 'Delete';

  @override
  String get praxisLoeschenFrage => 'Delete this entry?';

  @override
  String get praxisLoeschenText =>
      'The entry will be removed. Restoring an older backup later will not automatically bring it back.';

  @override
  String get praxisFehler =>
      'Saving did not work. Your existing data is preserved. Please try again.';

  @override
  String get praxisZeichenWaehlen => 'A sign for tonight';

  @override
  String get praxisZeichenAbsicht =>
      'Imagine this sign appearing in your dream. You notice it and realise: I am dreaming. Then let your personal intention rest.';

  @override
  String get praxisAbendStart => 'Open your evening episode';

  @override
  String get praxisBeobachten => 'Reflect on today';

  @override
  String get praxisBeobachtungTitel => 'Your daily observation';

  @override
  String get praxisBeobachtungText =>
      'What do you notice today? You can leave questions unanswered. An experienced orgasm is a possibility, not a nightly goal.';

  @override
  String get praxisSchlaf => 'How rested do you feel?';

  @override
  String get praxisLust => 'How does your desire feel today?';

  @override
  String get praxisUnbeantwortet => 'Leave unanswered';

  @override
  String get praxisSchlaf0 => 'Not rested at all';

  @override
  String get praxisSchlaf1 => 'Slightly rested';

  @override
  String get praxisSchlaf2 => 'Somewhat rested';

  @override
  String get praxisSchlaf3 => 'Well rested';

  @override
  String get praxisSchlaf4 => 'Very well rested';

  @override
  String get praxisLust0 => 'No desire noticeable';

  @override
  String get praxisLust1 => 'A little desire';

  @override
  String get praxisLust2 => 'Moderate desire';

  @override
  String get praxisLust3 => 'Clear desire';

  @override
  String get praxisLust4 => 'Strong desire';

  @override
  String get praxisSinnlich => 'Was your dream sensual?';

  @override
  String get praxisKlar => 'Did you know you were dreaming?';

  @override
  String get praxisOrgasmus => 'Did you experience an orgasm in your dream?';

  @override
  String get praxisJa => 'Yes';

  @override
  String get praxisNein => 'No';

  @override
  String get praxisNotiz => 'What would you like to remember?';

  @override
  String get praxisRueckblick => 'Your private review';

  @override
  String get praxisRueckblickText =>
      'These are your own observations. Similar patterns may invite curiosity, but do not establish a cause. There are no points or target rates.';

  @override
  String get praxisRueckblickLeer =>
      'No daily observations yet. Even a single note can be a beginning.';

  @override
  String get praxisNurOffeneFelder => 'No questions answered yet';

  @override
  String get praxisPfad => 'Your path for today';

  @override
  String get praxisPfadErinnern =>
      'Begin with dream recall and bodily awareness. The first two episodes accompany you.';

  @override
  String get praxisPfadErkennen =>
      'Connect a personal dream sign with your evening preparation. Episodes three to five explore recognising dreams.';

  @override
  String get praxisPfadEntfalten =>
      'Explore pleasure within lucid dreams and notice what you might carry into the day. Episodes six to eight offer space for this.';

  @override
  String get traumpraxisNurSpicy =>
      'This dream practice is part of Spicy mode for adults.';

  @override
  String get traumpraxisEinladung => 'Pleasure may linger beyond the night.';

  @override
  String get traumpraxisZiel =>
      'Explore sensual dreams, becoming aware within a dream, and what you might carry into your day. An orgasm may be part of that experience. You choose how far you want to go.';

  @override
  String get traumpraxisErinnern => 'In the morning · Remember';

  @override
  String get traumpraxisErinnernText =>
      'Write down what you remember: a place, a sensation, an encounter. You can mark sensuality, lucidity and an experienced orgasm in your journal. A dream without an orgasm, or a night with no recall, belongs here too.';

  @override
  String get traumpraxisErkennen => 'In the evening · Practise noticing';

  @override
  String get traumpraxisMildEinleitung =>
      'This imagery exercise draws on MILD: connecting a remembered dream with the intention to recognise the next one. Keep it brief, without keeping yourself awake. You do not need an extra alarm for this exercise.';

  @override
  String get traumpraxisVorlage => 'A pleasant dream memory';

  @override
  String get traumpraxisOhneEintrag =>
      'No suitable entry yet? Recall a pleasant dream. You can also begin by picturing a familiar place and rehearsing the moment of recognition.';

  @override
  String get traumpraxisMildSchritte =>
      'Let your dream return to mind. Where was something unusual? Perhaps a place changed, or an impossible transition occurred.\n\nPicture that moment again. This time, you notice it and realise: I am dreaming. Let the image remain for a moment, without forcing anything to happen.';

  @override
  String get traumpraxisAbsicht =>
      'Next time I dream, I want to remember that I am dreaming.';

  @override
  String get traumpraxisLoslassen =>
      'Then let the intention rest. You are free to fall asleep. If the exercise makes you more alert, leave it for tonight. The eight evening episodes remain available to you.';

  @override
  String get traumpraxisRuhe => 'Rest can be enough today';

  @override
  String get traumpraxisMitnehmen =>
      'During the day · Carry something pleasant with you';

  @override
  String get traumpraxisMitnehmenText =>
      'If your dream felt pleasant, recall a sensation: warmth, lightness or closeness. What, if anything, can you still feel in your waking body? There may be a lot, a little or nothing. Skip this exercise if the dream was distressing.';

  @override
  String get traumpraxisNachspueren =>
      'Choose a small, freely chosen sensual experience for your day: warm water on your skin, a soft fabric, or a quiet moment of bodily awareness. Afterwards, notice: Has your desire changed? Your curiosity? Or mostly your sense of calm? Write down your own observation, without having to judge it.';

  @override
  String get traumpraxisNotieren => 'Reflect in your journal';

  @override
  String get traumpraxisHoehepunkt => 'If you experience an orgasm in a dream';

  @override
  String get traumpraxisHoehepunktText =>
      'You may enjoy and record the experience, including if it happens again. The app does not measure bodily responses: a remembered dream orgasm is a reported experience, not a physiological measurement. You do not have to stay in the dream or reach another orgasm.';

  @override
  String get traumpraxisHoeren => 'To listen';

  @override
  String get traumpraxisHoerenText =>
      'Three short guided pieces with Victoria or Martin. They add to the practice, replace nothing, and end on their own. For you alone, not for listening together.';

  @override
  String get traumpraxisHoerenAbend =>
      'Once before falling asleep or before an evening episode.';

  @override
  String get traumpraxisHoerenKlarheit =>
      'In the daytime or early evening, awake, sitting or lying down.';

  @override
  String get traumpraxisHoerenMorgen =>
      'After waking up or in a quiet moment during the day, then perhaps your daytime observation.';

  @override
  String get traumpraxisHoerenStarten => 'Listen';

  @override
  String get traumpraxisHoerenPaket =>
      'The content of these pieces comes with the recordings. Download them in package management and the titles will appear here.';

  @override
  String get audioFuerHeute => 'For today';

  @override
  String get audioAlleAnzeigen => 'Show all';

  @override
  String get audioGruppeFuerMich => 'For me';

  @override
  String get audioGruppeFuerMichText =>
      'Time just for you: feel your body, explore yourself, experience dreams more consciously. You choose the length and how close you go.';

  @override
  String get audioGruppeFuerUns => 'For us';

  @override
  String get audioGruppeFuerUnsText =>
      'Listen together or take turns giving and receiving. A voice guides you, you set the pace.';

  @override
  String get audioGruppeNacht => 'Night';

  @override
  String get audioGruppeNachtNeutral => 'Calm';

  @override
  String get audioGruppeNachtText =>
      'For falling asleep, the dream evening and getting back to sleep. The voice grows quieter, you may drift off.';

  @override
  String get audioGruppeGeschichten => 'Stories';

  @override
  String get audioGruppeGeschichtenNeutral => 'Audio stories';

  @override
  String get audioGruppeGeschichtenText =>
      'Connected audio stories for adults, not for falling asleep. You choose the perspective and intensity.';

  @override
  String get audioGemeinsamTitel => 'Listen together';

  @override
  String get audioGemeinsamText =>
      'Start a recording and tap \"Listen together\" in the player. You both need the same recording on your device; you listen in time and either of you can pause.';

  @override
  String get traumpraxisKarteTitel => 'Dream practice';

  @override
  String get traumpraxisKarteTitelNeutral => 'Practice';

  @override
  String get traumpraxisKarteText =>
      'Recall, recognise, notice: your practice around the night.';

  @override
  String get traumpraxisErkundung =>
      'More pleasure in dreams and daily life is the aim of this exploration. Whether these exercises increase your waking desire remains an open question for you to observe. MILD is studied as a way to encourage lucid dreams; this brief evening adaptation and the daytime practice are not proven treatments. Restful sleep matters more than any particular dream experience.';

  @override
  String get lustTitel => 'Pleasure in dreams';

  @override
  String lustFolgeN(int n) {
    return 'Episode $n';
  }

  @override
  String get lustFolge1 => 'Pleasure in the body';

  @override
  String get lustFolge2 => 'The wave';

  @override
  String get lustFolge3 => 'Inviting the dream';

  @override
  String get lustFolge4 => 'Recognising';

  @override
  String get lustFolge5 => 'Staying in the lucid dream';

  @override
  String get lustFolge6 => 'Letting pleasure unfold';

  @override
  String get lustFolge7 => 'More than once';

  @override
  String get lustFolge8 => 'Your own way';

  @override
  String get lustSerieEinleitung =>
      'Eight evenings that build on each other: from a relaxed, pleasurable body as you fall asleep, through remembering and recognising dreams, to the lucid, sensual dream. The next episode unlocks once you have listened to the previous one on two evenings. Going back and repeating is always possible.';

  @override
  String get lustEinleitung =>
      'A voice accompanies you into sleep and into tonight\'s episode. Then it quietly repeats the intention, with ever longer pauses, until only silence remains. You may fall asleep along the way.';

  @override
  String get lustEhrlich =>
      'A climax in a dream can be invited, not forced. Some experience it after a few nights, some after many, and some have sensual dreams without a climax instead. All of it is right.';

  @override
  String get lustFolgen => 'Episodes';

  @override
  String get lustTraumkoerper => 'Your body in the dream';

  @override
  String get lustTraumkoerperEigener => 'My own';

  @override
  String get lustTraumkoerperFrau => 'A woman\'s body';

  @override
  String get lustTraumkoerperMann => 'A man\'s body';

  @override
  String get lustGegenueber => 'With whom in the dream';

  @override
  String get lustGegenueberNiemand => 'Just me';

  @override
  String get lustGegenueberFrau => 'A woman';

  @override
  String get lustGegenueberMann => 'A man';

  @override
  String get lustGegenueberOffen => 'Open';

  @override
  String get lustWeiter => 'Continue to the evening';

  @override
  String get lustHinweise =>
      'Adults only. Not a substitute for treatment of sleep disorders; better not with frequent nightmares, epilepsy or severe sleep deprivation. Strong arousal often wakes you, that is normal. What happens in a dream is a dream experience; fantasies there say little about wishes in waking life.';

  @override
  String get lustHinweisHandtuch => 'A towel within reach is not a bad idea.';

  @override
  String lustAbendeGehoert(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'listened to on $n evenings',
      one: 'listened to on one evening',
      zero: 'not listened to yet',
    );
    return '$_temp0';
  }

  @override
  String lustGesperrt(int n) {
    return 'Unlocks after two evenings with episode $n';
  }

  @override
  String get lustPaketFehlt =>
      'The recordings for this series are still missing. They come as a separate package, best downloaded over Wi-Fi.';

  @override
  String get lustPaketLaden => 'Download recordings';

  @override
  String get lustLadenFehler => 'Download failed. Please try again later.';

  @override
  String get lustKarteTitel => 'Pleasure in dreams';

  @override
  String get lustKarteTitelNeutral => 'Evening series';

  @override
  String get lustKarteText =>
      'Eight evenings that build on each other, up to the lucid, sensual dream.';

  @override
  String get lustKarteTextNeutral =>
      'Eight calm evenings that build on each other.';

  @override
  String get startSchwerpunkte => 'COURSES BY FOCUS';

  @override
  String startLektionenVon(int n, int m) {
    return '$n of $m lessons';
  }

  @override
  String get schwerpunktGrundlagen => 'Foundations';

  @override
  String get schwerpunktGrundlagenText =>
      'How mind and body work together, how arousal works and why your body is good as it is.';

  @override
  String get schwerpunktAnnehmen => 'Accepting and letting go';

  @override
  String get schwerpunktAnnehmenText =>
      'Understanding pain, shame and pressure, being kind to yourself, relaxing and strengthening the pelvic floor.';

  @override
  String get schwerpunktEntdecken => 'Discovering yourself';

  @override
  String get schwerpunktEntdeckenText =>
      'Exploring your own body: female pleasure, new stimulation, prostate and perineum.';

  @override
  String get schwerpunktPaar => 'Desire as a couple';

  @override
  String get schwerpunktPaarText =>
      'Talking, different levels of desire, life phases, anticipation and everyday eroticism.';

  @override
  String get schwerpunktBeruehrung => 'Touch';

  @override
  String get schwerpunktBeruehrungText =>
      'Touch for her and for him, intimate massage, voice and relaxed positions.';

  @override
  String get schwerpunktFantasie => 'Fantasy and play';

  @override
  String get schwerpunktFantasieText =>
      'Fantasies, leading and surrendering, mind movies and toys.';

  @override
  String get rueckblickTitel => 'This week';

  @override
  String get rueckblickKeineEintraege => 'No notes in the past seven days.';

  @override
  String rueckblickEintraegeGesamt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n notes in the past seven days',
      one: '1 note in the past seven days',
    );
    return '$_temp0';
  }

  @override
  String rueckblickErinnertMorgen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Remembered on $n mornings',
      one: 'Remembered on 1 morning',
    );
    return '$_temp0';
  }

  @override
  String rueckblickNichtsErinnertMorgen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Nothing remembered $n times',
      one: 'Nothing remembered 1 time',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeLuzide(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n times lucid',
      one: '1 time lucid',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeSinnlich(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n times sensual',
      one: '1 time sensual',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeHoehepunkt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n times climax',
      one: '1 time climax',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeUnangenehm(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n times uncomfortable',
      one: '1 time uncomfortable',
    );
    return '$_temp0';
  }

  @override
  String rueckblickMarkeSchlechtGeschlafen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n times slept poorly',
      one: '1 time slept poorly',
    );
    return '$_temp0';
  }

  @override
  String get rueckblickNachAbenden => 'Following the evenings';

  @override
  String get rueckblickKeineMarken => 'without tags';

  @override
  String get realitaetTitel => 'Reality check';

  @override
  String get realitaetFrage => 'Am I dreaming right now?';

  @override
  String get realitaetEinleitung =>
      'A brief moment of mindfulness. When you question your waking state during the day, this habit carries over into your dreams.';

  @override
  String get realitaetUebungHaendeTitel => 'Look at your hands';

  @override
  String get realitaetUebungHaendeText =>
      'Look closely at your palms and fingers. In dreams, hands often change their shape or lines.';

  @override
  String get realitaetUebungFingerTitel => 'Finger through the palm';

  @override
  String get realitaetUebungFingerText =>
      'Gently press a finger against your opposite palm. Imagine slipping through. In dreams, solid matter sometimes yields.';

  @override
  String get realitaetUebungTextTitel => 'Read text twice';

  @override
  String get realitaetUebungTextText =>
      'Read a line of text or a clock, look away briefly, and read it again. In dreams, letters and numbers often shift.';

  @override
  String get realitaetBestaetigenWach => 'I am awake';

  @override
  String get realitaetBestaetigenTraum => 'I am dreaming!';

  @override
  String get realitaetErinnerungenAktiv => 'Daytime reminders';

  @override
  String realitaetZeitfenster(int von, int bis) {
    return 'Time window: $von:00 to $bis:00';
  }

  @override
  String realitaetAnzahlTag(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n reminders per day',
      one: '1 reminder per day',
    );
    return '$_temp0';
  }

  @override
  String get realitaetMotiveTitel => 'Themes from your dream journal';

  @override
  String get realitaetMotiveKeine =>
      'As you record more journal entries, the app will suggest recurring motifs as triggers here.';

  @override
  String realitaetMotivSatz(String wort) {
    return 'When I see $wort, I ask myself if I am dreaming.';
  }

  @override
  String get realitaetMitteilungTitel => 'A brief moment for you';

  @override
  String get realitaetMitteilungText => 'Take a brief moment for yourself.';

  @override
  String get realitaetHinweisXiaomi =>
      'Note for Xiaomi and MIUI devices: To receive reminders reliably, battery optimization and autostart should be granted for the app in phone settings.';

  @override
  String get realitaetKanalName => 'Mindfulness';

  @override
  String get realitaetKanalBeschreibung =>
      'Reminders for daytime reality checks';

  @override
  String get weckenTitel => 'Wake me tonight';

  @override
  String get weckenUntertitel =>
      'One-time system alarm after about five hours of sleep';

  @override
  String weckenUhrzeit(String zeit) {
    return 'Wake-up time: $zeit';
  }

  @override
  String get weckenAendern => 'Change time';

  @override
  String get weckenWeckerName => 'Brief moment';

  @override
  String get weckenGesperrt =>
      'You have already used nighttime waking twice in the past seven days. Your sleep comes first.';

  @override
  String get weckenSicherheit =>
      'At most twice a week. Do not use during shift work, pregnancy, with a baby that wakes at night, or when sleep-deprived. When falling back asleep, harmless sleep paralysis can rarely occur: breathe calmly and move a finger.';

  @override
  String weckenWeckerGesetzt(String zeit) {
    return 'System alarm opened for $zeit';
  }

  @override
  String get weckenBegleitungTitel => 'Falling back asleep';

  @override
  String get weckenBegleitungEinleitung =>
      'Briefly note your dream in a few words, then let yourself be guided calmly back to sleep.';

  @override
  String get weckenTagebuchKarteTitel => 'Back to sleep after waking';

  @override
  String get weckenTagebuchKarteText =>
      'Short, quiet guidance back into your dream (approx. 15 min)';

  @override
  String get weckenBegleitungStarten => 'Start guidance';

  @override
  String get weckenTraumNotieren => 'Note dream briefly';

  @override
  String get weckenLaeuft => 'Good night';

  @override
  String get weckenLaeuftText =>
      'Set your device aside and close your eyes. The guidance stops on its own.';

  @override
  String get testmodusAn => 'Test mode on: short pauses, everything unlocked.';

  @override
  String get testmodusAus => 'Test mode off.';

  @override
  String get testmodusSchild =>
      'Test mode: short pauses, everything unlocked. To turn off, tap the version number in the profile seven times.';

  @override
  String get reiheKarteTitel => 'Inner views';

  @override
  String get reiheKarteTitelNeutral => 'Audio story';

  @override
  String get reiheKarteText =>
      'Desire told from within, in Soft and Spicy, also from two perspectives of the same encounter.';

  @override
  String get reiheKarteTextNeutral => 'One continuous audio story.';

  @override
  String get reiheTitel => 'Inner views';

  @override
  String get reiheEinleitung =>
      'Continuous stories of about 20 to 30 minutes, not for falling asleep. They describe how desire can feel from within. Everyone experiences this differently; none of it is a benchmark or a promise.';

  @override
  String get reiheFolgen => 'Episode';

  @override
  String get reiheVariante => 'Intensity';

  @override
  String get reiheSoft => 'Soft';

  @override
  String get reiheBilderAnsehen => 'View pictures';

  @override
  String get reiheGalerieTitel => 'Pictures';

  @override
  String get reiheGalerieLeer => 'There are no pictures for this episode yet.';

  @override
  String get reiheSpicy => 'Spicy';

  @override
  String get reiheSehrSpicy => 'Very spicy';

  @override
  String get reihePerspektive => 'Perspective';

  @override
  String get reihePerspektiveFrau => 'Her';

  @override
  String get reihePerspektiveMann => 'Him';

  @override
  String reihePartnerHinweis(String name) {
    return 'The matching perspective of the same encounter: $name. Both follow the same sequence of scenes. “Listen together” synchronises the same version on two devices. Different complementary perspectives still need to be coordinated by you.';
  }

  @override
  String reihePartnerHinweisDrei(String name) {
    return 'The other two perspectives of the same encounter: $name. All three follow the same sequence of scenes. You listen to threesome episodes on your own; “Listen together” is not offered for them.';
  }

  @override
  String reiheDauer(int minuten) {
    return 'About $minuten minutes';
  }

  @override
  String get reiheStart => 'Start';

  @override
  String reiheSzene(int n, int m) {
    return 'Scene $n of $m';
  }

  @override
  String get reiheSzeneVor => 'Next scene';

  @override
  String get reiheSzeneZurueck => 'Scene from the start';

  @override
  String get reiheBeenden => 'End';

  @override
  String get reiheBeendenFrage => 'Stop the story?';

  @override
  String get reiheBeendenText => 'You can start again later.';

  @override
  String get reiheFertig => 'Done. Take a moment before you continue.';

  @override
  String get reiheHinweise =>
      'Adults only. All characters are adults, and everything happens by mutual consent. None of it is a measure of performance: arousal, climax, and satisfaction are not the same, and every body responds differently.';

  @override
  String get reiheLeer => 'The package does not contain any episodes yet.';

  @override
  String get reihePaketFehlt =>
      'The recordings for this series are not available yet. They come as a separate package; download it over Wi-Fi if possible. After that, everything works offline.';

  @override
  String get reihePaketLaden => 'Download recordings';

  @override
  String get kursBildAllein => 'Alone';

  @override
  String get kursBildZuZweit => 'Together';

  @override
  String get reihePaketNeu =>
      'There are new episodes and pictures for this series. Best to update on Wi-Fi. Afterwards everything works offline again.';

  @override
  String get reiheLadenFehler => 'Download failed. Please try again later.';

  @override
  String get reiheOffline => 'Available offline';

  @override
  String get reiheKeineAufnahme =>
      'There is no recording for this version yet; the device voice reads it aloud.';

  @override
  String get lautsprecherFrageTitel => 'Speaker';

  @override
  String get lautsprecherFrageNachricht =>
      'Playback will play through the speaker. Play anyway?';

  @override
  String get lautsprecherAbspielen => 'Play';

  @override
  String get lautsprecherAbbrechen => 'Cancel';

  @override
  String get lautsprecherNichtMehrFragen => 'Do not ask again';

  @override
  String get lautsprecherEinstellungFrageTitel => 'Ask before speaker playback';

  @override
  String get lautsprecherEinstellungFrageText =>
      'Asks before playing if no headphones are connected.';

  @override
  String get lautsprecherEinstellungPauseTitel =>
      'Pause when headphones are disconnected';

  @override
  String get lautsprecherEinstellungPauseText =>
      'Pauses playback as soon as wired or Bluetooth headphones are disconnected.';

  @override
  String get realitaetStatusEin => 'On';

  @override
  String get realitaetStatusAus => 'Off';

  @override
  String get halloTitel => 'Say an anonymous hello once';

  @override
  String get halloErklaerung =>
      'Voluntary: If you like, you can say hello to us once. Only the app version and language are transmitted – encrypted and without a sender.';

  @override
  String get halloKnopf => 'Say hello';

  @override
  String halloDankeGesendet(String datum) {
    return 'Thank you, sent on $datum.';
  }

  @override
  String get halloGesendet => 'Thank you for saying hello!';

  @override
  String get schlafTitel => 'Compare sleep data';

  @override
  String get schlafEinladung => 'A look back at your night';

  @override
  String get schlafErklaerung =>
      'Optional: View sleep data already synced to Health Connect alongside your own observations. No live detection or signals during the night. Dream Practice works without a device.';

  @override
  String get schlafDatenschutz =>
      'VelvetPulse reads only sleep sessions from the last 30 days when you explicitly start a comparison. It writes nothing to Health Connect. Imported copies stay local and are included in your backup; nothing is shared with your partner or the couple room.';

  @override
  String get schlafHinweis =>
      'Enable sharing of sleep data from Fitbit or Google Health to Health Connect. Only data actually available there can be shown. Sleep stages are estimates, not a diagnosis.';

  @override
  String get schlafVerbinden => 'Connect Health Connect';

  @override
  String get schlafImportieren => 'Compare last 30 days';

  @override
  String get schlafUebernehmen => 'Import selected source';

  @override
  String get schlafQuelle => 'Data source';

  @override
  String get schlafQuelleWaehlen =>
      'Choose a source. Records from different devices are not added together.';

  @override
  String get schlafTrennen => 'Turn off comparison';

  @override
  String get schlafGetrennt =>
      'Comparison is off. Imported data is retained. You can revoke the Android permission in Health Connect.';

  @override
  String get schlafVerbunden =>
      'Comparison is enabled. Data is read only when you request it.';

  @override
  String get schlafBerechtigungFehlt =>
      'Access to sleep data is missing. You can allow it in Health Connect; the rest of Dream Practice stays available.';

  @override
  String get schlafNichtVerfuegbar =>
      'This optional import needs Android 14 or later and available Health Connect. All other exercises remain available.';

  @override
  String get schlafLeer => 'No sleep records imported yet.';

  @override
  String get schlafKeineDaten =>
      'No completed sleep sessions are available. Check syncing and sharing in your source app.';

  @override
  String get schlafFehler =>
      'The comparison could not be completed. Your existing data is retained.';

  @override
  String get schlafGespeichert => 'The selected sleep data has been imported.';

  @override
  String get schlafEinstellungen => 'Android permissions';

  @override
  String get schlafLoeschen => 'Delete imported sleep data';

  @override
  String get schlafLoeschenFrage =>
      'Delete all imported sleep data from VelvetPulse? Your own journal and Dream Practice entries are retained. Data in Health Connect is not deleted.';

  @override
  String get schlafAbbrechen => 'Cancel';

  @override
  String get schlafZeitfenster => 'Recorded time window';

  @override
  String get schlafSchlafzeit => 'Sleep time from stages';

  @override
  String get schlafUnbekannt => 'Cannot be fully determined';

  @override
  String get schlafPhasen => 'Recorded stages';

  @override
  String get schlafWach => 'Awake';

  @override
  String get schlafLeicht => 'Light sleep';

  @override
  String get schlafTief => 'Deep sleep';

  @override
  String get schlafRem => 'REM';

  @override
  String get schlafOhnePhase => 'Sleep without a stage label';

  @override
  String get schlafUnbekanntePhase => 'Unknown';

  @override
  String get schlafEigeneAngaben => 'Your observations for this wake-up date';

  @override
  String get schlafKeineAngaben => 'No personal daily observation yet.';

  @override
  String get schlafBeobachtung => 'Open daily observation';

  @override
  String get schlafLetzterAbgleich => 'Last comparison';

  @override
  String get schlafImportierteKopie =>
      'Saved copy. Changes or deletions in the source app do not automatically remove this copy. Observed patterns do not establish an effect on desire or dreams.';

  @override
  String schlafDauer(int stunden, int minuten) {
    return '$stunden hr $minuten min';
  }

  @override
  String get schlafBlickTitel => 'What your nights reveal';

  @override
  String get schlafBlickEinladung =>
      'Noticed a dream sign? Carried a feeling into your day? Explore your past seven days through your memories and, if you wish, your sleep records.';

  @override
  String get schlafBlickGrenze =>
      'Your own entries describe your experience. A watch provides sleep estimates. These do not identify lucid dreams or orgasms. Journal entries are matched by their entry date.';

  @override
  String get schlafBlickWoche => 'Your past seven days';

  @override
  String get schlafBlickKlar => 'Lucidity recorded';

  @override
  String get schlafBlickErinnert => 'Dream memory recorded';

  @override
  String get schlafBlickSinnlich => 'Sensual dream recorded';

  @override
  String get schlafBlickHoehepunkt => 'Dream orgasm recorded';

  @override
  String get schlafBlickOhneErinnerung =>
      'Nothing recalled – that belongs here too';

  @override
  String get schlafBlickUnbekannt => 'No dream observation yet';

  @override
  String get schlafBlickOhneMessung => 'No sleep measurement';

  @override
  String get schlafBlickMehrere =>
      'Multiple sleep records – view them individually under measurements';

  @override
  String get schlafBlickNacht => 'Record this night';

  @override
  String get schlafBlickNaechster => 'Your next discovery';

  @override
  String get schlafBlickStart =>
      'Start with a small fragment of memory: an image, a mood, a place. It may become your personal dream sign.';

  @override
  String get schlafBlickUeben =>
      'You have already recorded something. Look for an unusual detail and carry it as a gentle intention into your next evening practice.';

  @override
  String get schlafBlickVertiefen =>
      'You have recorded lucidity in a dream. What would you like to notice consciously next time? Dream Practice makes room for sensuality and noticing how it feels during the day.';

  @override
  String get schlafBlickRuhe =>
      'Your recent entries suggest taking a break. Rest can be enough today. You do not need another exercise or overnight interruption.';

  @override
  String get schlafBlickPraxis => 'Explore Dream Practice';

  @override
  String get schlafBlickHeute => 'Today';

  @override
  String get schlafBlickGestern => 'Yesterday';

  @override
  String schlafBlickGeschlafen(String dauer) {
    return 'Slept: $dauer';
  }

  @override
  String schlafBlickImBett(String dauer) {
    return 'In bed: $dauer';
  }

  @override
  String get schlafBlickKeineBesonderheiten => 'Nothing special noted';

  @override
  String get schlafBlickAendern => 'View or change entries';

  @override
  String get schlafBlickNochNichts => 'Nothing noted yet';

  @override
  String get schlafMesswerte => 'Connect sleep data and view measurements';

  @override
  String schlafBlickBilanz(int klar, int tage) {
    return '$klar of $tage days with personal entries include a reported lucid dream. This is a reflection, not a performance goal.';
  }

  @override
  String get ersteWocheEyebrow => 'Your first week';

  @override
  String get ersteWocheEinstieg =>
      'Seven small steps, each no longer than a quarter of an hour. You don\'t have to do any of them, and none is a test. Every one has a “Not today”.';

  @override
  String ersteWocheSchrittMin(int n, int min) {
    return 'Step $n · about $min min.';
  }

  @override
  String ersteWocheSchrittNr(int n) {
    return 'Step $n';
  }

  @override
  String get ersteWocheAnsehen => 'Take a look';

  @override
  String get ersteWocheHeuteNicht => 'Not today';

  @override
  String get ersteWocheHeuteNichtAntwort =>
      'All good. The step will wait, and nothing expires.';

  @override
  String get ersteWocheZugeklappt => 'Your first week is waiting, no rush.';

  @override
  String get ersteWocheMenue => 'More';

  @override
  String get ersteWocheUeberspringen => 'Skip this step';

  @override
  String get ersteWocheAusblenden => 'Hide';

  @override
  String get ersteWocheWiederZeigen => 'Show your first week again';

  @override
  String ersteWocheLangePause(int n) {
    return 'Carry on with step $n, whenever you like';
  }

  @override
  String get ersteWocheGeschafft => 'Your first week is behind you';

  @override
  String get ersteWocheZumAbend => 'Carry on with the shared evening';

  @override
  String get ersteWocheGutSo => 'That\'s enough for now';

  @override
  String ersteWochePunktOffen(int n) {
    return 'Step $n: open';
  }

  @override
  String ersteWochePunktGetan(int n) {
    return 'Step $n: done';
  }

  @override
  String ersteWochePunktUebersprungen(int n) {
    return 'Step $n: skipped';
  }

  @override
  String get ersteWocheGemacht => 'We did this';

  @override
  String get ersteWocheLektionOeffnen => 'Open the lesson';

  @override
  String get ersteWocheLandkarteOeffnen => 'Open the fantasy map';

  @override
  String get ersteWocheAlleBereiche => 'See all areas';

  @override
  String get ersteWocheAlternative => 'Rather each on our own';

  @override
  String get ersteWocheFragen => 'Two questions are enough';

  @override
  String get ersteWocheFrage1 => 'What was lovely?';

  @override
  String get ersteWocheFrage2 => 'What shall we do again?';

  @override
  String get ersteWocheWeiterMenue => 'A menu for your wishes';

  @override
  String get ersteWocheWeiterTitel => 'If you like, carry on like this';

  @override
  String get ersteWocheNichtVerfuegbar => 'That is not available right now.';

  @override
  String get ersteWocheSagenWo => 'Tell them where I am';

  @override
  String ersteWocheNachricht(int n) {
    return 'I did step $n. If you like, have a look at the next one. No pressure.';
  }

  @override
  String get ersteWocheNachrichtTitel => 'Send this?';

  @override
  String get ersteWocheNachrichtHinweis =>
      'You can change the text. Nothing is sent until you tap “Send”.';

  @override
  String get ersteWocheAbbrechen => 'Cancel';

  @override
  String get ersteWocheSenden => 'Send';

  @override
  String get ersteWocheS1Titel => 'One word that stops everything';

  @override
  String get ersteWocheS1Text =>
      'Before anything else, a word that stops everything at once is helpful. The lesson shows a traffic light for wishes and limits. If you like, you then agree on a word for “stop”. Knowing that stop always counts makes it easier to be open to everything else.';

  @override
  String get ersteWocheS2Titel => 'Breathing together';

  @override
  String get ersteWocheS2Text =>
      'Arriving together, without a touch that wants something. If you like, you breathe in the same rhythm for a few minutes, and the pacer helps. If you\'d rather not lie close yet, each of you can do it alone with a short audio exercise.';

  @override
  String get ersteWocheS3Titel => 'Why pressure is nobody\'s fault';

  @override
  String get ersteWocheS3Text =>
      'Many couples feel pressure around closeness and take it as their own fault. The lesson explains the body\'s accelerator and brake: it is not a defect, it is how every body works. If you like, each of you reads it on your own. Nobody has to talk about it afterwards.';

  @override
  String get ersteWocheS4Titel => 'Touch without a goal';

  @override
  String get ersteWocheS4Text =>
      'If you like: touch, clothed and without a goal, for example back, shoulders, arms, hands, feet. Nothing has to come of it, and either of you can say “stop” at any time. About 10 to 15 minutes, you decide.';

  @override
  String get ersteWocheS5Titel => 'Gathering wishes quietly';

  @override
  String get ersteWocheS5Text =>
      'After touching, you may know a little better what feels good. In the fantasy map, only the calm category “Sensuality & Senses” is meant. Each of you answers for yourself, and answering alone works too. Only what you both like is shown.';

  @override
  String get ersteWocheS6Titel => 'One easy sentence';

  @override
  String get ersteWocheS6Text =>
      'A conversation is easier once there is calm and trust. Pick one of the three sentence starters from the lesson and say it, if you like. That is all it takes. This is not a talk about problems.';

  @override
  String get ersteWocheS7Titel => 'A look back without judging';

  @override
  String get ersteWocheS7Text =>
      'To finish, a look back, with no grades. Two questions are enough. Answer aloud or just for yourselves, however it feels. After that you can carry on if you like, or simply let it be.';

  @override
  String heutePaarDuUnd(Object name) {
    return 'You and $name';
  }

  @override
  String get heutePaarEyebrow => 'For you two';

  @override
  String get heutePaarTitel => 'Today, together';

  @override
  String get heutePaarAbendMeta => 'At your pace, with one voice';

  @override
  String get heutePaarAudios => 'Audios for you two';

  @override
  String get heutePaarAudiosMeta => 'Listen together';

  @override
  String heutePaarWir(Object name) {
    return 'Us: a message or a spark to $name';
  }

  @override
  String get heutePaarEinladen => 'Invite your partner';

  @override
  String get heutePaarSchonCode => 'Already have a code?';

  @override
  String get heutePaarVerbinden => 'Connect';

  @override
  String get heutePaarMehrAllein => 'More just for you';

  @override
  String get heutePaarWegMeta => 'You are in the middle of a path';

  @override
  String get ersteWocheUnterzeileVorsichtig =>
      'If you both like – a no counts fully';

  @override
  String get appSperreNeuTitel => 'Just for you';

  @override
  String get appSperreNeuText =>
      'VelvetPulse only opens with your device lock: fingerprint, face, PIN or pattern. That way, what you explore here stays with you. You can change this any time in your profile.';

  @override
  String get appSperreNeuOk => 'Sounds good';

  @override
  String get appSperreFrageTitel => 'Keep VelvetPulse just for you?';

  @override
  String get appSperreFrageText =>
      'The app will then ask for your device lock when you open it and after a short time in the background. That way nobody can look in if your phone is lying around.';

  @override
  String get appSperreFrageJa => 'Yes, lock it';

  @override
  String get appSperreFrageNein => 'Not now';

  @override
  String get appSperreKeineTitel =>
      'Your phone doesn\'t have a screen lock yet';

  @override
  String get appSperreKeineText =>
      'Set up a PIN, pattern or fingerprint in your Android settings (usually under “Security” or “Lock screen”). Then you can turn on the app lock in your profile.';

  @override
  String get appSperreKeineOk => 'Got it';

  @override
  String get fantasieHinweisTitel => 'Your fantasies are yours';

  @override
  String get fantasieHinweisText =>
      'A fantasy isn\'t a wish you have to act on, and it isn\'t a verdict on your relationship. Whatever comes to mind here is allowed to just be. Whether you share any of it, and what and when, is up to you.';

  @override
  String get fantasieHinweisDrei =>
      'A scene with three people doesn\'t mean anything is missing from your relationship either.';

  @override
  String get fantasieHinweisOk => 'Good to know';

  @override
  String get spicyAbgelaufenTitel => 'Spicy mode is off';

  @override
  String get spicyAbgelaufenText =>
      'The app was in the background for more than 5 hours. So that nobody who picks up your phone can look in, Spicy mode was switched off. Your settings and content are unchanged.';

  @override
  String get spicyAbgelaufenEntsperren => 'Unlock again';

  @override
  String get spicyAbgelaufenSpaeter => 'Later';

  @override
  String get trennungDialog1Titel => 'Disconnect?';

  @override
  String trennungDialog1(Object name) {
    return 'The history with $name, $name\'s answers and the shared reflections will be deleted on this phone. Your own answers stay.\n\nOn $name\'s phone, whatever is there stays until they delete it themselves.';
  }

  @override
  String get trennungDialog1Weiter => 'Continue';

  @override
  String get trennungDialog2Titel => 'Really disconnect?';

  @override
  String get trennungDialog2 => 'This can only be undone by pairing again.';

  @override
  String get trennungDialog2Ja => 'Yes, disconnect';

  @override
  String trennungNichtGesendet(Object name) {
    return 'Disconnected. The notice to $name didn\'t go through. On $name\'s phone everything stays until they delete it themselves.';
  }

  @override
  String trennungHinweis(Object name) {
    return '$name has ended the connection. You don\'t need to do anything, and there\'s no hurry. The chat stays readable here for as long as you like.';
  }

  @override
  String get trennungSchalter =>
      'Also disconnect on this phone and delete this connection\'s data';

  @override
  String get trennungGegenueberDialog1Titel => 'Disconnect on this phone?';

  @override
  String trennungGegenueberDialog1(Object name) {
    return 'The history with $name, $name\'s answers and the shared reflections will be deleted on this phone. Your own answers stay.\n\nYou can also wait. Nothing is deleted until you confirm.';
  }

  @override
  String get trennungGegenueberDialog2Titel => 'Really delete?';

  @override
  String get trennungGegenueberDialog2 => 'This can\'t be brought back.';

  @override
  String get trennungGegenueberLoeschenJa => 'Yes, delete';

  @override
  String get trennungGegenueberFertig => 'Disconnected on this phone.';

  @override
  String get trennungSatzAelter => 'The connection was ended.';

  @override
  String get spicyEinladungNein => 'Not right now';

  @override
  String get spicyNeinSatz => 'Not right now, thank you.';

  @override
  String get spicyEinladungNeinAntwort =>
      'Thank you for telling me. There\'s no rush.';

  @override
  String get spicyEinladungNeinGesendet =>
      'You\'ve replied. You can change your mind any time.';

  @override
  String get funkeDanke => 'Thanks for telling me';

  @override
  String get funkeTippNein =>
      'A no today isn\'t a no to you. You don\'t need to ask follow-up questions.';

  @override
  String get funkeTippReden =>
      'You don\'t have to answer right away. Say when it suits you.';

  @override
  String get funkeTippLabel => 'Just for you';

  @override
  String trennungHinweisSenden(Object name) {
    return 'Send $name a notice';
  }

  @override
  String get trennungHinweisInfoAn =>
      'If it doesn\'t arrive (app closed, no connection), nothing changes there.';

  @override
  String trennungHinweisInfoAus(Object name) {
    return '$name won\'t be told about the disconnection. On $name\'s phone everything stays until they delete it themselves.';
  }

  @override
  String get trennungHilfe => 'Do you need support?';

  @override
  String funkeDankeAntwort(Object name) {
    return '$name: Thanks for telling me.';
  }

  @override
  String get fotoHinweisTrennung =>
      'Photos you send stay on the other person\'s phone, even if you disconnect later.';

  @override
  String get yesNoMaybeInfoZeile => 'How this works';

  @override
  String lektionEyebrow(Object durationMin) {
    return 'Lesson · $durationMin min';
  }

  @override
  String lektionEyebrowAudio(Object durationMin) {
    return 'Audio exercise · $durationMin min';
  }

  @override
  String playerZeit(String vergangen, String gesamt) {
    return '$vergangen of $gesamt';
  }

  @override
  String wiedergabeTeil(int nr, int anzahl) {
    return 'Part $nr of $anzahl';
  }
}
