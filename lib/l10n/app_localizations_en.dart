// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get mainNavigationProgrammeCourses => 'Programme & courses';

  @override
  String get mainNavigationSomaticsTraining => 'Somatics & training';

  @override
  String get mainNavigationCbtReframing => 'CBT reframing';

  @override
  String get mainNavigationCoupleChannel => 'Couple channel';

  @override
  String get mainNavigationAiCoach => 'AI coach';

  @override
  String get mainNavigationCourses => 'Courses';

  @override
  String get mainNavigationTraining => 'Training';

  @override
  String get mainNavigationReframing => 'Reframing';

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
  String get coursesForHer => 'For her 🌸';

  @override
  String get coursesForHim => 'For him 🌿';

  @override
  String get coursesForCouples => 'For couples 💫';

  @override
  String get coursesCoupleChannel => 'COUPLE CHANNEL';

  @override
  String get coursesYourPrivateSpace => 'Your private space';

  @override
  String get coursesSendSparksSecretlyMatchWishes =>
      'Send sparks & secretly match wishes';

  @override
  String get coursesYourCurriculum => 'YOUR CURRICULUM';

  @override
  String coursesHelloProfilename(Object profileName) {
    return 'Hello, $profileName';
  }

  @override
  String get coursesWelcome => 'Welcome';

  @override
  String coursesYourFocusGoallabel(Object goalLabel) {
    return 'Your focus: $goalLabel';
  }

  @override
  String get coursesUnderstandTheBiologyQuietThe =>
      'Understand the biology. Quiet the head. Feel the body.';

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
  String get coursesPracticeCbt => 'Practice: CBT';

  @override
  String get lessonDetailLessonMarkedAsCompleted =>
      'Lesson marked as completed! 🎉';

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
      'Start breath pacer (down-regulation)';

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
  String get sosModalSosQuickHelp => 'SOS quick help';

  @override
  String get sosModalCalmDownRightNowEmergency =>
      'Calm down right now & emergency steps';

  @override
  String get sosModalBefore => 'Before';

  @override
  String get sosModalInTheMoment => 'In the moment';

  @override
  String get sosModalAfterwards => 'Afterwards';

  @override
  String get sosModalYourMantraForThisMoment => 'YOUR MANTRA FOR THIS MOMENT';

  @override
  String sosModalMantra(Object mantra) {
    return '“$mantra”';
  }

  @override
  String get sosModalImmediateStepsTickOff => 'IMMEDIATE STEPS (TICK OFF)';

  @override
  String sosModalCheckedlengthImmediatestepslengthDone(
      Object checkedLength, Object immediateStepsLength) {
    return '$checkedLength/$immediateStepsLength done';
  }

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
}
