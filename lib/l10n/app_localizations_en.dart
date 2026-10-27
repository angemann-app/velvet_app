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
    Object completedCount,
    Object totalLessons,
  ) {
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
    Object checkedLength,
    Object immediateStepsLength,
  ) {
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
  String get couplesChannelSecretlyMatchWishes => 'Secretly match wishes';

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
      'You can also fill it in alone – and match it with your partner later.';

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
  String get couplesChannelWishes => 'Wishes';

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
      'Vote separately. A wish only shows up as a match when you both say “Yes, please” – a “Rather not” is never shown.';

  @override
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche) {
    return '$fragen questions in $bereiche areas – with matching course recommendations.';
  }

  @override
  String get couplesChannelYouHaveAMatch => 'You have a match';

  @override
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength) {
    return 'You have $matchesLength matches';
  }

  @override
  String get couplesChannelAMatchIsAnInvitation =>
      'A match is an invitation, not a promise. Talk briefly beforehand about how you imagine it.';

  @override
  String get couplesChannelYesPlease => 'Yes, please';

  @override
  String get couplesChannelRatherNot => 'Rather not';

  @override
  String get couplesChannelDisconnect2 => 'Disconnect?';

  @override
  String couplesChannelTheHistoryWithNameName(
    Object name,
    Object name2,
    Object name3,
  ) {
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
    Object partnerName,
    Object partnerName2,
  ) {
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
    return '\nI\'d like to try VelvetPulse with you 💛 A private app just for the two of us.\n\n1. Get the app (Android):\n$stableApkUrl\nIf Android asks, allow the installation.\n\n2. I\'ll send you my connection code as a separate message. Copy it and paste it into the app: Couple channel › Connect with partner › Scan partner › paste code › “Connect & pair”.\n\n3. Then send me a spark, and we\'re connected.\n\nDetailed guide (German): $testerGuideUrl';
  }

  @override
  String get invitePartnerYouSendALinkTo =>
      'You send a link to the app and your connection code, e.g. via a messenger. As soon as your partner replies, you confirm the connection here.';

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
    return 'As soon as $name installs the app, enters your code and sends you a spark, you can confirm the connection here.';
  }

  @override
  String get invitePartnerDecline => 'Decline';

  @override
  String invitePartnerConnectedWithName(Object name) {
    return 'Connected with $name 💛';
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
    Object old,
    Object old2,
    Object old3,
  ) {
    return 'You\'re currently connected with $old. This connection will be replaced, and the history with $old2, $old3\'s answers and the shared reflections will be deleted on this phone.';
  }

  @override
  String get pairingModalReplace => 'Replace';

  @override
  String get pairingModalHiIMConnectedNow => '👋 Hi, I\'m connected now.';

  @override
  String pairingModalConnectedWithName(Object name) {
    return 'Connected with $name 💛';
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
      'Your desire profile is on its way, encrypted 💛';

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
      'Matching answers, encrypted …';

  @override
  String yesNoMaybeCountAnswersMatched(Object count) {
    return '$count answers matched! ✨';
  }

  @override
  String get yesNoMaybeReadMore => 'READ MORE';

  @override
  String get yesNoMaybeYesMaybeNo => 'Yes / Maybe / No';

  @override
  String get yesNoMaybeSyncWithPartner => 'Sync with partner';

  @override
  String get yesNoMaybePairingRequired => 'Pairing required';

  @override
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
    Object answeredCount,
    Object totalItems,
  ) {
    return 'Questions ($answeredCount/$totalItems)';
  }

  @override
  String yesNoMaybeMatchesMatchcount(Object matchCount) {
    return 'Matches ($matchCount)';
  }

  @override
  String get yesNoMaybeDigitalSafeSpace => 'DIGITAL SAFE SPACE';

  @override
  String get yesNoMaybeFindOutWhatExcitesYou =>
      'Find out what excites you and where your limits are. Not sure what is meant? Tap “Learn more”. If you\'re connected in the couple channel, you only see what you both want – a no stays invisible.';

  @override
  String get yesNoMaybeYes => 'Yes';

  @override
  String get yesNoMaybeMaybe => 'Maybe';

  @override
  String get yesNoMaybeNo => 'No';

  @override
  String yesNoMaybeAllEintraegelength(Object eintraegeLength) {
    return 'All ($eintraegeLength)';
  }

  @override
  String get yesNoMaybeOpen => 'Open';

  @override
  String yesNoMaybeYesYescount(Object yesCount) {
    return 'Yes ($yesCount)';
  }

  @override
  String yesNoMaybeMaybeMaybecount(Object maybeCount) {
    return 'Maybe ($maybeCount)';
  }

  @override
  String yesNoMaybeNoNocount(Object noCount) {
    return 'No ($noCount)';
  }

  @override
  String get yesNoMaybePairingRequired2 => 'Pairing required';

  @override
  String get yesNoMaybeConnectWithYourPartnerIn =>
      'Connect with your partner in the couple channel via QR code. Your answers are then matched end-to-end encrypted.';

  @override
  String get yesNoMaybePairViaQrCodeNow => 'Pair via QR code now';

  @override
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName) {
    return 'PERFECT MATCH WITH $partnerName';
  }

  @override
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
    Object yesMatchesLength,
    Object curiosityMatchesLength,
  ) {
    return '$yesMatchesLength shared yeses & $curiosityMatchesLength points of curiosity discovered!';
  }

  @override
  String get yesNoMaybeNoRejectionAllLimitsWere =>
      'No rejection: all limits were kept discreetly. Only real shared desire is revealed.';

  @override
  String get yesNoMaybePerfectMatchBothSaidYes =>
      'Perfect match (both said YES)';

  @override
  String get yesNoMaybeSharedCuriosityOpenToExploring =>
      'Shared curiosity (open to exploring)';

  @override
  String get yesNoMaybeNoMatchesYet => 'No matches yet';

  @override
  String get yesNoMaybeBothKeepVotingInThe =>
      'Both keep voting in the questions. As soon as you\'ve both rated the same item yes or maybe, it lights up here.';

  @override
  String get yesNoMaybeYouBothYes => 'You both: yes';

  @override
  String get yesNoMaybeCuriousTogether => 'Curious together';

  @override
  String get yesNoMaybeCourse => 'Course ▶';

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
    Object realityCheck,
    Object practicalShift,
  ) {
    return '$realityCheck\n\nPractical shift: $practicalShift';
  }

  @override
  String get beliefLibraryViewBeliefToolkit => 'Belief toolkit';

  @override
  String get beliefLibraryViewTheMostCommonMentalTraps =>
      'The most common mental traps in performance anxiety – and the reality behind them. Tap a card to take it straight into your own journal.';

  @override
  String get beliefLibraryViewForHer => 'FOR HER 🌸';

  @override
  String get beliefLibraryViewForHim => 'FOR HIM 🌿';

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
    Object currentRound,
    Object totalRounds,
  ) {
    return 'Round $currentRound of $totalRounds';
  }

  @override
  String kegelTimerViewPhaseCurrentphaseindexPhaseslength(
    Object currentPhaseIndex,
    Object phasesLength,
  ) {
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
  String get aiCoachAsAWomanHowDo =>
      'As a woman, how do I relax my pelvic floor during sex?';

  @override
  String get aiCoachHowCanWeStopPerformance =>
      'How can we stop performance pressure in bed together?';

  @override
  String get aiCoachWhatToDoAboutRacing =>
      'What to do about racing thoughts & spectatoring?';

  @override
  String get aiCoachHowDoIExplainResponsive =>
      'How do I explain responsive desire to my partner?';

  @override
  String get aiCoachWhyDoesTheReverseKegel =>
      'Why does the reverse Kegel help with nervousness?';

  @override
  String get aiCoachWelcomeToConfidentialSomaticRelationship =>
      'Welcome to confidential somatic & relationship coaching. I\'m here for you – as a woman, a man or a couple – with all questions about relaxing the pelvic floor, overcoming racing thoughts and performance pressure, shame and fulfilling intimacy without a goal.\n\nWhat would you like to talk about, or what\'s on your mind most right now?';

  @override
  String get aiCoachPleaseAddYourGeminiApi =>
      'Please add your Gemini API key first to chat with the coach.';

  @override
  String get aiCoachNoApiKeyAddedPlease =>
      'No API key added. Please tap the gear icon at the top.';

  @override
  String get aiCoachGoogleRejectedTheApiKey =>
      'Google rejected the API key as invalid. Please check the key in Google AI Studio.';

  @override
  String aiCoachConnectionErrorCleanerr(Object cleanErr) {
    return 'Connection error: $cleanErr';
  }

  @override
  String get aiCoachCheckKey => 'Check key';

  @override
  String get aiCoachGeminiApiKey => 'Gemini API key';

  @override
  String get aiCoachPrivateCoachingUsesGoogleGemini =>
      'Private coaching uses Google Gemini. The key is stored encrypted on your phone only; your messages and profile details go to Google to be answered. In the EU, Switzerland and the UK, Google\'s terms say it doesn\'t use them to improve its products; elsewhere Google may analyse requests from the free tier.';

  @override
  String get aiCoachFreeViaAistudioGoogleCom => 'Free via aistudio.google.com';

  @override
  String get aiCoachShowGuide => 'Show guide';

  @override
  String get aiCoachPleaseEnterAKeyFirst => 'Please enter a key first.';

  @override
  String get aiCoachCheckingConnection => 'Checking connection...';

  @override
  String get aiCoachTestConnection => 'Test connection';

  @override
  String get aiCoachApiKeyRemoved => 'API key removed.';

  @override
  String get aiCoachApiKeySaved => 'API key saved.';

  @override
  String get aiCoachClearChatHistory => 'Clear chat history?';

  @override
  String get aiCoachDoYouWantToDelete =>
      'Do you want to delete all previous messages in this conversation?';

  @override
  String get aiCoachChatHistoryClearedWhatWould =>
      'Chat history cleared. What would you like to talk about?';

  @override
  String get aiCoachClear => 'Clear';

  @override
  String get aiCoachGeminiAiConnected => 'Gemini AI connected';

  @override
  String get aiCoachNoApiKeyAdded => 'No API key added';

  @override
  String get aiCoachGuideCreateAKey => 'Guide: create a key';

  @override
  String get aiCoachClearChat => 'Clear chat';

  @override
  String get aiCoachApiKeySettings => 'API key settings';

  @override
  String get aiCoachNoApiKeyYetCreated =>
      'No API key yet? Created for free in 2 minutes.';

  @override
  String get aiCoachGuide => 'Guide';

  @override
  String get aiCoachCoachIsThinking => 'Coach is thinking...';

  @override
  String get aiCoachAskAConfidentialQuestion =>
      'Ask a confidential question...';

  @override
  String get apiKeyGuideSheetFreeGeminiApiKey => 'Free Gemini API key';

  @override
  String get apiKeyGuideSheetCreatedStepByStepIn =>
      'Created step by step in 2 minutes';

  @override
  String get apiKeyGuideSheetFreeAndWhatHappensTo =>
      'Free – and what happens to your data: ';

  @override
  String get apiKeyGuideSheetGoogleAiStudioHasA =>
      'Google AI Studio has a free tier. Your key stays encrypted on your phone. Your messages, name, age, gender, relationship status and focus go to Google to be answered. In the EU, Switzerland and the UK, Google\'s terms say it doesn\'t use them to improve its products. Elsewhere Google may analyse requests from the free tier for that and have humans read them.';

  @override
  String get apiKeyGuideSheetOpenGoogleAiStudio => 'Open Google AI Studio';

  @override
  String get apiKeyGuideSheetOpenGoogleSOfficialDeveloper =>
      'Open Google\'s official developer platform in your browser (Chrome, Safari, Firefox):\n';

  @override
  String get apiKeyGuideSheetLinkCopiedToClipboard =>
      'Link copied to clipboard!';

  @override
  String get apiKeyGuideSheetCopy => 'Copy';

  @override
  String get apiKeyGuideSheetSignInWithAGoogle =>
      'Sign in with a Google account';

  @override
  String get apiKeyGuideSheetSignInWithYourExisting =>
      'Sign in with your existing Google account (Gmail). No credit card or payment method is required.';

  @override
  String get apiKeyGuideSheetClickGetApiKey => 'Click \"Get API key\"';

  @override
  String get apiKeyGuideSheetInTheMenuAtThe =>
      'In the menu at the top left, click the blue \"Get API key\" button.';

  @override
  String get apiKeyGuideSheetChooseCreateApiKeyIn =>
      'Choose \"Create API key in new project\"';

  @override
  String get apiKeyGuideSheetChooseTheOptionCreateApi =>
      'Choose the option \"Create API key in new project\". Google automatically sets up a free project in the background.';

  @override
  String get apiKeyGuideSheetCopyTheKeyPasteIt =>
      'Copy the key & paste it into VelvetPulse';

  @override
  String get apiKeyGuideSheetCopyTheGeneratedStringIt =>
      'Copy the generated string. It usually starts with \"AIzaSy...\" – then paste it into the app here.';

  @override
  String get apiKeyGuideSheetFrequentlyAskedQuestions =>
      'Frequently asked questions:';

  @override
  String get apiKeyGuideSheetDoesItCostAnything => 'Does it cost anything?';

  @override
  String get apiKeyGuideSheetNotWithinTheFreeTier =>
      'Not within the free tier of Google AI Studio. Google sets the scope and terms and can change them.';

  @override
  String get apiKeyGuideSheetWhichModelIsUsed => 'Which model is used?';

  @override
  String get apiKeyGuideSheetVelvetpulseAutomaticallyFindsTheLatest =>
      'VelvetPulse automatically finds the latest active Gemini models (preferring the fast Flash models) via your key.';

  @override
  String get apiKeyGuideSheetEnterApiKeyConnectNow =>
      'Enter API key & connect now';

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
    Object stressLevel,
    Object pressureLevel,
  ) {
    return 'Stress: $stressLevel • Pressure: $pressureLevel';
  }

  @override
  String get dailyCheckinCardHowDoStressPerformancePressure =>
      'How do stress & performance pressure relate today?';

  @override
  String get dailyCheckinCardEverydayStressTodayJobAppointments =>
      '1. Everyday stress today (job, appointments, sleep)';

  @override
  String get dailyCheckinCardInnerPerformancePressureRacingThoughts =>
      '2. Inner performance pressure & racing thoughts';

  @override
  String get dailyCheckinCardWhatDidYouGoodToday =>
      '3. What did you some good today?';

  @override
  String get dailyCheckinCardSaveDailyCheckIn => 'Save daily check-in';

  @override
  String get dailyCheckinCardUpdateValues => 'Update values';

  @override
  String get dailyCheckinCardCoachingInsightYourEverydayStress =>
      '💡 Coaching insight: your everyday stress is high today. Remember: stress and exhaustion often slow desire down by themselves. That\'s a normal reaction, not a defect.';

  @override
  String get dailyCheckinCardCoachingInsightWhenEverydayStress =>
      '💡 Coaching insight: when everyday stress drops, it\'s often easier to relax. Use today\'s calm to feel into your body without pressure to perform.';

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
    return 'Backup for \"$name\" restored! ✨';
  }

  @override
  String get onboardingProfilePersonalisation => 'Profile & personalisation';

  @override
  String get onboardingWelcomeToVelvetpulse => 'Welcome to VelvetPulse';

  @override
  String get onboardingYourPrivateCoachingProgrammeFor =>
      'Your private coaching programme for calm, pelvic floor & intimacy.';

  @override
  String get onboardingPrivateProfileJournalProgressStay =>
      'Private: profile, journal & progress stay on your phone. Only the AI coach (Google Gemini), the encrypted couple channel and the update check (GitHub) go online.';

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
  String get onboardingYourGender => '2. Your gender';

  @override
  String get onboardingAdjustsCourseRecommendationsPelvicFloor =>
      'Adjusts course recommendations, pelvic floor content and AI answers.';

  @override
  String get onboardingMale => 'Male';

  @override
  String get onboardingFemale => 'Female';

  @override
  String onboardingYourAgeSelectedageYears(Object selectedAge) {
    return '3. Your age: $selectedAge years';
  }

  @override
  String get onboardingYourRelationshipStatus => '4. Your relationship status';

  @override
  String get onboardingInARelationshipMarried =>
      'In a relationship / married 💍';

  @override
  String get onboardingDatingGettingToKnowSomeone =>
      'Dating / getting to know someone 💫';

  @override
  String get onboardingSingle => 'Single 🌱';

  @override
  String get onboardingItSComplicated => 'It\'s complicated 🌀';

  @override
  String get onboardingWhatSYourBiggestPriority =>
      '5. What\'s your biggest priority right now?';

  @override
  String get onboardingStopPerformancePressureRacingThoughts =>
      'Stop performance pressure & racing thoughts';

  @override
  String get onboardingBreakThoughtLoopsStopSpectatoring =>
      'Break thought loops, stop spectatoring.';

  @override
  String get onboardingPelvicFloorRelaxationBodyAwareness =>
      'Pelvic floor relaxation & body awareness';

  @override
  String get onboardingReleaseTensionPractiseReverseKegels =>
      'Release tension, practise reverse Kegels, calm down.';

  @override
  String get onboardingCoupleIntimacyPressureFreeSex =>
      'Couple intimacy & pressure-free sex';

  @override
  String get onboardingSensateFocusTogetherCalmingEach =>
      'Sensate focus together, calming each other & vulnerable closeness.';

  @override
  String get onboardingDesireSelfAcceptanceBodyAwareness =>
      'Desire, self-acceptance & body awareness';

  @override
  String get onboardingUnderstandResponsiveDesireEaseOrgasm =>
      'Understand responsive desire, ease orgasm pressure.';

  @override
  String get onboardingSaveChanges => 'Save changes';

  @override
  String get onboardingPersonaliseProgrammeNow => 'Personalise programme now';

  @override
  String get onboardingSkipGoStraightToThe => 'Skip & go straight to the app ➔';

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
      'Everything stays local on your device and survives updates. API key and couple connection are stored encrypted in the Android keystore and only go into a backup with a password.';

  @override
  String get onboardingExportBackup => 'Export backup';

  @override
  String get backupDialogsWhatShouldGoIntoThe =>
      'What should go into the backup?';

  @override
  String get backupDialogsOnlyYourDataProfileProgress =>
      'Only your data: profile, progress, reflections, journal, wishes. Enough for this phone.\n\nWith password: additionally the couple channel connection and your API key, encrypted. You need this for moving to another phone.';

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
      'This backup comes from an older version and contains your API key and your connection key unencrypted. It will be restored anyway.\n\nAfterwards, delete the old backup wherever you kept it, and create a new one with a password if needed.';

  @override
  String get backupDialogsRestore => 'Restore';

  @override
  String get backupDialogsBackupPassword => 'Backup password';

  @override
  String get backupDialogsThisAlsoBringsBackThe =>
      'This also brings back the couple channel connection and your API key.';

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
      '\n\nWithout your password, the connection and API key can\'t be restored. We can\'t reset it either.';

  @override
  String get checkinActionBreathed =>
      'Breathed deeply on purpose (physiological sigh)';

  @override
  String get checkinActionPelvicFloor =>
      'Relaxed the pelvic floor (reverse Kegel)';

  @override
  String get checkinActionPhoneAway => 'Put the phone away in the evening';

  @override
  String get checkinActionWalk => 'Went for a walk in fresh air';

  @override
  String get checkinActionSkinContact => 'Focused on skin contact';

  @override
  String get checkinActionOpenWord => 'Dared an open word with my partner';

  @override
  String get dailySimmeringCardTheSecondWallTease => 'The 45-second wall tease';

  @override
  String get dailySimmeringCardCourseTeasing => 'COURSE 15 • TEASING';

  @override
  String get dailySimmeringCardTodayBrieflyPressYourPartner =>
      'Today, briefly press your partner against the wall with intent, or hold them gently. Slowly kiss their neck, murmur a promise into their ear – and after exactly 45 seconds smile and walk on: \"We\'ll save the rest for later.\"';

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
      'This afternoon, send your partner an unannounced message: \"Tonight from 9 pm your body is mine. You don\'t have to do anything but be there.\"';

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
      'The strict no-penetration rule';

  @override
  String get dailySimmeringCardCourseSensateFocus =>
      'COURSE 17 • SENSATE FOCUS';

  @override
  String get dailySimmeringCardAgreeTodayYouMayHug =>
      'Agree today: you may hug, kiss and caress each other naked – but penetration is strictly off-limits. Everything may happen, nothing has to.';

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
  String get dailySimmeringCardCoursesBody => 'COURSES 3 & 9 • BODY';

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
  String get dailySimmeringCardCourseBodyLab => 'COURSE 19 • BODY LAB';

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
      'Plateau surfing at level 7';

  @override
  String get dailySimmeringCardCourseStayingPower =>
      'COURSE 19 • STAYING POWER';

  @override
  String get dailySimmeringCardBringYourArousalToLevel =>
      'Bring your arousal to level 7. As soon as it climbs to 8: stop all movement (stillness), breathe out deeply 3 times and let your pelvic floor sink down.';

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
      'COURSE 19 • MULTIPLE ORGASMS';

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
  String get dailySimmeringCardPhysiologicalSighQuickCalming =>
      'Physiological sigh (quick calming)';

  @override
  String get dailySimmeringCardToolCalmDown => 'TOOL • CALM DOWN';

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
  String get userProfileNonBinaryOpen => 'Non-binary / open';

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
  String get userProfilePelvicFloorBody => 'Pelvic floor & body';

  @override
  String get userProfileCoupleIntimacyCloseness =>
      'Couple intimacy & closeness';

  @override
  String get userProfileDesireRelaxation => 'Desire & relaxation';

  @override
  String get userProfileEasingPerformancePressure =>
      'Easing performance pressure';

  @override
  String get contentModelsTheArtOfTouchFor => 'THE ART OF TOUCH • FOR HER';

  @override
  String get contentModelsTouchLabForHim => 'TOUCH LAB • FOR HIM';

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
  String get contentModelsForHer => 'FOR HER';

  @override
  String get contentModelsForCouples => 'FOR COUPLES';

  @override
  String get contentModelsForHim => 'FOR HIM';

  @override
  String get yesNoMaybeModelsExcitesMeIDLike =>
      'Excites me, I\'d like to try it';

  @override
  String get yesNoMaybeModelsCuriousButUnsureDependsOn =>
      'Curious but unsure – depends on the moment';

  @override
  String get yesNoMaybeModelsNotForMe => 'Not for me';

  @override
  String get aiServiceYouAreTheConfidentialSomatic =>
      'You are the confidential somatic, CBT and erotic coach in the app VelvetPulse.\n\nYour attitude & tone:\n1. Character: you are a fascinating mix of a brilliant neuroscientist/sex therapist and a worldly, charmingly flirtatious seducer who meets people as equals.\n2. Language: you write natural, fluent English. You talk about desire, skin, wetness, erections, relaxing the perineum, surrender and racing thoughts completely without shame, sensually, warmly and with a light, knowing wink. Avoid any sterile hospital language and any lecturing tone!\n3. Method: always connect cognitive behavioural therapy (taking the magic out of stuffy performance and test-like thoughts) directly with pleasurable body work (letting the pelvic floor melt like warm honey, actively opening the pelvic floor, deep throaty sighs, calming the nervous system, the art of slow motion, sensual circling, pure sensing).\n4. Core message: show the user in every line that their body is completely fine and that slowness, pauses and \'not having to perform\' are not a defect but the key to much deeper, indecently good ecstasy.\n5. Format: always answer compactly (2-3 concise, atmospheric paragraphs) and end EVERY answer with exactly ONE open, gently challenging or sensation-oriented reflection question.\n6. Safety: you don\'t make diagnoses. With pain, bleeding or persistent problems, you kindly recommend seeing a doctor.';

  @override
  String aiServiceConnectionSuccessfulModelslengthModelsAvailable(
    Object modelsLength,
    Object join,
  ) {
    return 'Connection successful! $modelsLength models available (e.g. $join).';
  }

  @override
  String get aiServiceNoAvailableTextModelsFound =>
      'No available text models found for this key. Please check the API permissions.';

  @override
  String get aiServiceTheApiKeyIsInvalid =>
      'The API key is invalid. Please check it in Google AI Studio.';

  @override
  String aiServiceUserContextNameProfilenameGender(
    Object profileName,
    Object genderLabel,
    Object age,
    Object relationshipLabel,
    Object goalLabel,
  ) {
    return '\n\nUSER CONTEXT:\n- Name: $profileName\n- Gender: $genderLabel\n- Age: $age years\n- Relationship status: $relationshipLabel\n- Main focus: $goalLabel\nAddress the person confidentially by their name, and tailor your psychological and somatic explanations to their gender, age and relationship status.';
  }

  @override
  String get aiServiceReceivedAnEmptyAnswerFrom =>
      'Received an empty answer from the AI model.';

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
    Object count,
    Object fallbackRelaysLength,
  ) {
    return '$count of $fallbackRelaysLength servers';
  }

  @override
  String get nostrServiceVotedOnTheFantasySelection =>
      'Voted on the fantasy selection';

  @override
  String nostrServiceHaveAReadLessontitleCoursetitle(
    Object lessonTitle,
    Object courseTitle,
  ) {
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
  String get spicyEinschaltenTitel => 'Turn on spicy mode?';

  @override
  String get spicyEinschaltenText =>
      'Adults only. The body journey and the shared evening will then offer two extra levels:\n\n“Spicy”: hot and direct, playing with arousal to just before climax, for couples also kisses, teasing and the mouth.\n\n“Extra spicy”: the same with dirty talk and crude words.\n\nEverything stays an invitation, and a stop word always applies. You can turn the mode off here at any time, and the levels disappear straight away.';

  @override
  String get spicyEinschalten => 'I\'m 18+, turn on';

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
  String get coachQHerOrgasm =>
      'How do I help her climax without adding pressure?';

  @override
  String get coachQWomenRelax => 'What helps women truly let go during sex?';

  @override
  String get coachQHerDesire =>
      'Why does it often take her longer to feel desire?';

  @override
  String get coachQAskHer =>
      'How do I ask her what she likes without it getting awkward?';

  @override
  String get coachQMyPressure =>
      'How do I get rid of performance pressure in bed?';

  @override
  String get coachQShowHim => 'How do I show him how I want to be touched?';

  @override
  String get coachQMenPressure =>
      'What helps men with performance pressure in bed?';

  @override
  String get coachQPleaseHim =>
      'How can I pleasure him even better with hands and mouth?';

  @override
  String get coachQWishesLimits =>
      'How do we talk openly about wishes and limits?';

  @override
  String get coachQHerTouch =>
      'How do we find out which touch she enjoys most?';

  @override
  String get coachQDesireGap =>
      'How do we handle one of us wanting sex more often?';

  @override
  String get coachQKnowBody => 'How do I get to know my own body better?';

  @override
  String get coachQFemaleDesire => 'What should I know about female desire?';

  @override
  String get coachQMaleDesire => 'What should I know about male desire?';

  @override
  String get coachQShowTouch => 'How do I show how I want to be touched?';

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
      '🔥 I\'ve turned on spicy mode. Would you like to try it too? (Profile › Spicy mode)';

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
      'Your dream journal is private. Sensual dreams are a sign that your desire is alive. Who appears in them and what happens need not mean anything. Entries are not shared with the AI coach or your partner; they are part of your encrypted backup.';

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
<<<<<<< HEAD
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
=======
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
>>>>>>> origin/ag/7-naechtliches-wecken
}
