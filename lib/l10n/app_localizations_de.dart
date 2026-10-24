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
  String get couplesChannelSecretlyMatchWishes => 'Wünsche heimlich abgleichen';

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
      'Kannst du auch allein ausfüllen – und später mit deinem Gegenüber abgleichen.';

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
  String get couplesChannelWishes => 'Wünsche';

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
      'Stimmt getrennt ab. Ein Wunsch erscheint erst als Match, wenn ihr beide „Ja, gern“ sagt – ein „Lieber nicht“ wird nie angezeigt.';

  @override
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche) {
    return '$fragen Fragen in $bereiche Bereichen – mit passenden Kurs-Empfehlungen.';
  }

  @override
  String get couplesChannelYouHaveAMatch => 'Ihr habt ein Match';

  @override
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength) {
    return 'Ihr habt $matchesLength Matches';
  }

  @override
  String get couplesChannelAMatchIsAnInvitation =>
      'Ein Match ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt.';

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
    return '\nIch möchte VelvetPulse mit dir ausprobieren 💛 Eine private App nur für uns zwei.\n\n1. App laden (Android):\n$stableApkUrl\nWenn Android fragt, die Installation erlauben.\n\n2. Meinen Verbindungscode schicke ich dir gleich als eigene Nachricht. Kopiere ihn und füge ihn in der App ein: Paar-Kanal › Mit Partner verbinden › Partner scannen › Code einfügen › „Verbinden & Koppeln“.\n\n3. Schick mir danach einen Funken, dann sind wir verbunden.\n\nAusführliche Anleitung: $testerGuideUrl';
  }

  @override
  String get invitePartnerYouSendALinkTo =>
      'Du schickst einen Link zur App und deinen Verbindungscode, z. B. per Messenger. Sobald sich dein Gegenüber meldet, bestätigst du hier die Verbindung.';

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
    return 'Sobald $name die App installiert, deinen Code eingibt und dir einen Funken schickt, kannst du die Verbindung hier bestätigen.';
  }

  @override
  String get invitePartnerDecline => 'Ablehnen';

  @override
  String invitePartnerConnectedWithName(Object name) {
    return 'Verbunden mit $name 💛';
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
    return 'Verbunden mit $name 💛';
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
      'Dein Lust-Profil ist verschlüsselt unterwegs 💛';

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
      'Antworten werden verschlüsselt abgeglichen …';

  @override
  String yesNoMaybeCountAnswersMatched(Object count) {
    return '$count Antworten erfolgreich abgeglichen! ✨';
  }

  @override
  String get yesNoMaybeReadMore => 'WEITERLESEN';

  @override
  String get yesNoMaybeYesMaybeNo => 'Ja / Vielleicht / Nein';

  @override
  String get yesNoMaybeSyncWithPartner => 'Mit Partner synchronisieren';

  @override
  String get yesNoMaybePairingRequired => 'Koppeln erforderlich';

  @override
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
      Object answeredCount, Object totalItems) {
    return 'Fragenkatalog ($answeredCount/$totalItems)';
  }

  @override
  String yesNoMaybeMatchesMatchcount(Object matchCount) {
    return 'Matches ($matchCount)';
  }

  @override
  String get yesNoMaybeDigitalSafeSpace => 'DIGITALER SAFE SPACE';

  @override
  String get yesNoMaybeFindOutWhatExcitesYou =>
      'Finde heraus, was dich reizt und wo deine Grenzen liegen. Unklar, was gemeint ist? Tippe auf „Mehr erfahren“. Seid ihr im Paar-Kanal verbunden, seht ihr nur, was ihr beide wollt – ein Nein bleibt unsichtbar.';

  @override
  String get yesNoMaybeYes => 'Ja';

  @override
  String get yesNoMaybeMaybe => 'Vielleicht';

  @override
  String get yesNoMaybeNo => 'Nein';

  @override
  String yesNoMaybeAllEintraegelength(Object eintraegeLength) {
    return 'Alle ($eintraegeLength)';
  }

  @override
  String get yesNoMaybeOpen => 'Offen';

  @override
  String yesNoMaybeYesYescount(Object yesCount) {
    return 'Ja ($yesCount)';
  }

  @override
  String yesNoMaybeMaybeMaybecount(Object maybeCount) {
    return 'Vielleicht ($maybeCount)';
  }

  @override
  String yesNoMaybeNoNocount(Object noCount) {
    return 'Nein ($noCount)';
  }

  @override
  String get yesNoMaybePairingRequired2 => 'Kopplung erforderlich';

  @override
  String get yesNoMaybeConnectWithYourPartnerIn =>
      'Verbinde dich im Paar-Kanal per QR-Code mit deinem Gegenüber. Eure Antworten werden dann Ende-zu-Ende-verschlüsselt abgeglichen.';

  @override
  String get yesNoMaybePairViaQrCodeNow => 'Jetzt per QR-Code koppeln';

  @override
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName) {
    return 'VOLLTREFFER MIT $partnerName';
  }

  @override
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
      Object yesMatchesLength, Object curiosityMatchesLength) {
    return '$yesMatchesLength gemeinsame Ja-Übereinstimmungen & $curiosityMatchesLength Neugier-Punkte entdeckt!';
  }

  @override
  String get yesNoMaybeNoRejectionAllLimitsWere =>
      'Keine Zurückweisung: Alle Grenzen wurden diskret gewahrt. Nur echte gemeinsame Lust wird enthüllt.';

  @override
  String get yesNoMaybePerfectMatchBothSaidYes =>
      'Volltreffer (Beide haben JA gesagt)';

  @override
  String get yesNoMaybeSharedCuriosityOpenToExploring =>
      'Gemeinsame Neugier (Offen für Erkundung)';

  @override
  String get yesNoMaybeNoMatchesYet => 'Noch keine Übereinstimmungen';

  @override
  String get yesNoMaybeBothKeepVotingInThe =>
      'Stimmt beide weiter im Fragenkatalog ab. Sobald ihr denselben Punkt mit Ja oder Vielleicht bewertet habt, leuchtet er hier auf.';

  @override
  String get yesNoMaybeYouBothYes => 'Ihr beide: Ja';

  @override
  String get yesNoMaybeCuriousTogether => 'Gemeinsam neugierig';

  @override
  String get yesNoMaybeCourse => 'Kurs ▶';

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
  String get beliefLibraryViewForHer => 'FÜR SIE 🌸';

  @override
  String get beliefLibraryViewForHim => 'FÜR IHN 🌿';

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
}
