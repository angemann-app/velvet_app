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
      Object old, Object old2, Object old3) {
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
      Object answeredCount, Object totalItems) {
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
      Object yesMatchesLength, Object curiosityMatchesLength) {
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
      Object realityCheck, Object practicalShift) {
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
}
