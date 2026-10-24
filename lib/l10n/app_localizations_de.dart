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
  String get aiCoachAsAWomanHowDo =>
      'Wie entspanne ich als Frau meinen Beckenboden beim Sex?';

  @override
  String get aiCoachHowCanWeStopPerformance =>
      'Wie stoppen wir zu zweit den Leistungsdruck im Bett?';

  @override
  String get aiCoachWhatToDoAboutRacing =>
      'Was tun bei akutem Kopfkino & Spectatoring?';

  @override
  String get aiCoachHowDoIExplainResponsive =>
      'Wie erkläre ich meinem Partner die responsive Lust?';

  @override
  String get aiCoachWhyDoesTheReverseKegel =>
      'Warum hilft der Reverse Kegel bei Nervosität?';

  @override
  String get aiCoachWelcomeToConfidentialSomaticRelationship =>
      'Willkommen im vertraulichen Somatik- & Beziehungs-Coaching. Ich begleite euch – ob als Frau, Mann oder als Paar – bei allen Fragen zu Beckenboden-Entspannung, Überwindung von Kopfkino und Leistungsdruck, Scham und erfüllender, absichtsloser Intimität.\n\nWorüber möchtet ihr sprechen oder was beschäftigt dein Nervensystem gerade am meisten?';

  @override
  String get aiCoachPleaseAddYourGeminiApi =>
      'Bitte hinterlege zuerst deinen Gemini API-Key, um mit dem Coach zu schreiben.';

  @override
  String get aiCoachNoApiKeyAddedPlease =>
      'Kein API-Key hinterlegt. Bitte klicke oben auf das Zahnrad-Symbol.';

  @override
  String get aiCoachGoogleRejectedTheApiKey =>
      'Der API-Key wurde von Google als ungültig abgelehnt. Bitte überprüfe den Key im Google AI Studio.';

  @override
  String aiCoachConnectionErrorCleanerr(Object cleanErr) {
    return 'Verbindungsfehler: $cleanErr';
  }

  @override
  String get aiCoachCheckKey => 'Key prüfen';

  @override
  String get aiCoachGeminiApiKey => 'Gemini API-Key';

  @override
  String get aiCoachPrivateCoachingUsesGoogleGemini =>
      'Für das private Coaching wird Google Gemini verwendet. Der Key liegt verschlüsselt nur auf deinem Smartphone; deine Nachrichten und Profilangaben gehen zur Beantwortung an Google. In der EU, der Schweiz und Großbritannien nutzt Google sie laut seinen Bedingungen nicht zur Verbesserung seiner Produkte; anderswo kann Google Anfragen aus dem kostenlosen Kontingent auswerten.';

  @override
  String get aiCoachFreeViaAistudioGoogleCom =>
      'Kostenlos via aistudio.google.com';

  @override
  String get aiCoachShowGuide => 'Anleitung anzeigen';

  @override
  String get aiCoachPleaseEnterAKeyFirst => 'Bitte gib zuerst einen Key ein.';

  @override
  String get aiCoachCheckingConnection => 'Prüfe Verbindung...';

  @override
  String get aiCoachTestConnection => 'Verbindung testen';

  @override
  String get aiCoachApiKeyRemoved => 'API-Key entfernt.';

  @override
  String get aiCoachApiKeySaved => 'API-Key erfolgreich gespeichert.';

  @override
  String get aiCoachClearChatHistory => 'Chatverlauf leeren?';

  @override
  String get aiCoachDoYouWantToDelete =>
      'Möchtest du alle bisherigen Nachrichten dieses Dialogs löschen?';

  @override
  String get aiCoachChatHistoryClearedWhatWould =>
      'Chatverlauf zurückgesetzt. Worüber möchtest du sprechen?';

  @override
  String get aiCoachClear => 'Leeren';

  @override
  String get aiCoachGeminiAiConnected => 'Gemini KI verbunden';

  @override
  String get aiCoachNoApiKeyAdded => 'Kein API-Key hinterlegt';

  @override
  String get aiCoachGuideCreateAKey => 'Anleitung: Key erstellen';

  @override
  String get aiCoachClearChat => 'Chat leeren';

  @override
  String get aiCoachApiKeySettings => 'API-Key Einstellungen';

  @override
  String get aiCoachNoApiKeyYetCreated =>
      'Noch kein API-Key? In 2 Min. kostenlos erstellt.';

  @override
  String get aiCoachGuide => 'Anleitung';

  @override
  String get aiCoachCoachIsThinking => 'Coach reflektiert...';

  @override
  String get aiCoachAskAConfidentialQuestion => 'Vertrauliche Frage stellen...';

  @override
  String get apiKeyGuideSheetFreeGeminiApiKey => 'Kostenlosen Gemini API-Key';

  @override
  String get apiKeyGuideSheetCreatedStepByStepIn =>
      'Schritt-für-Schritt in 2 Minuten erstellt';

  @override
  String get apiKeyGuideSheetFreeAndWhatHappensTo =>
      'Kostenlos – und was mit deinen Daten passiert: ';

  @override
  String get apiKeyGuideSheetGoogleAiStudioHasA =>
      'Google AI Studio hat ein kostenloses Kontingent. Dein Key bleibt verschlüsselt auf deinem Smartphone. Deine Nachrichten, dein Name, Alter, Geschlecht, Beziehungsstatus und Fokus gehen zur Beantwortung an Google. In der EU, der Schweiz und Großbritannien nutzt Google sie laut seinen Bedingungen nicht, um seine Produkte zu verbessern. Anderswo darf Google Anfragen aus dem kostenlosen Kontingent dafür auswerten und von Menschen lesen lassen.';

  @override
  String get apiKeyGuideSheetOpenGoogleAiStudio => 'Google AI Studio aufrufen';

  @override
  String get apiKeyGuideSheetOpenGoogleSOfficialDeveloper =>
      'Öffne im Browser (Chrome, Safari, Firefox) die offizielle Entwickler-Plattform von Google:\n';

  @override
  String get apiKeyGuideSheetLinkCopiedToClipboard =>
      'Link in Zwischenablage kopiert!';

  @override
  String get apiKeyGuideSheetCopy => 'Kopieren';

  @override
  String get apiKeyGuideSheetSignInWithAGoogle => 'Mit Google-Konto anmelden';

  @override
  String get apiKeyGuideSheetSignInWithYourExisting =>
      'Melde dich mit deinem bestehenden Google-Konto (Gmail) an. Es ist keine Kreditkarte oder Zahlungsmethode erforderlich.';

  @override
  String get apiKeyGuideSheetClickGetApiKey => '\"Get API key\" anklicken';

  @override
  String get apiKeyGuideSheetInTheMenuAtThe =>
      'Klicke im Menü links oben auf den blauen Button \"Get API key\" (oder \"API-Schlüssel anfordern\").';

  @override
  String get apiKeyGuideSheetChooseCreateApiKeyIn =>
      '\"Create API key in new project\" wählen';

  @override
  String get apiKeyGuideSheetChooseTheOptionCreateApi =>
      'Wähle die Option \"Create API key in new project\". Google richtet sofort automatisch im Hintergrund ein kostenloses Projekt ein.';

  @override
  String get apiKeyGuideSheetCopyTheKeyPasteIt =>
      'Key kopieren & in VelvetPulse einfügen';

  @override
  String get apiKeyGuideSheetCopyTheGeneratedStringIt =>
      'Kopiere die erzeugte Zeichenkette. Sie beginnt typischerweise mit \"AIzaSy...\" – füge sie anschließend hier in die App ein.';

  @override
  String get apiKeyGuideSheetFrequentlyAskedQuestions => 'Häufige Fragen:';

  @override
  String get apiKeyGuideSheetDoesItCostAnything => 'Kostet die Nutzung etwas?';

  @override
  String get apiKeyGuideSheetNotWithinTheFreeTier =>
      'Im kostenlosen Kontingent (Free Tier) von Google AI Studio nicht. Umfang und Bedingungen legt Google fest und kann sie ändern.';

  @override
  String get apiKeyGuideSheetWhichModelIsUsed => 'Welches Modell wird genutzt?';

  @override
  String get apiKeyGuideSheetVelvetpulseAutomaticallyFindsTheLatest =>
      'VelvetPulse ermittelt automatisch die aktuellsten aktiven Gemini-Modelle (bevorzugt die schnellen Flash-Modelle) über deinen Key.';

  @override
  String get apiKeyGuideSheetEnterApiKeyConnectNow =>
      'API-Key jetzt eintragen & verbinden';

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
      'Wie stehen Stress & Leistungsdruck heute zueinander?';

  @override
  String get dailyCheckinCardEverydayStressTodayJobAppointments =>
      '1. Alltagsstress heute (Job, Termine, Schlaf)';

  @override
  String get dailyCheckinCardInnerPerformancePressureRacingThoughts =>
      '2. Innerer Leistungsdruck & Kopfkino';

  @override
  String get dailyCheckinCardWhatDidYouGoodToday =>
      '3. Was hat deinem Nervensystem heute gut getan?';

  @override
  String get dailyCheckinCardSaveDailyCheckIn => 'Tages-Check-in speichern';

  @override
  String get dailyCheckinCardUpdateValues => 'Werte aktualisieren';

  @override
  String get dailyCheckinCardCoachingInsightYourEverydayStress =>
      '💡 Coaching-Insight: Dein Alltagsstress ist heute hoch. Erinnere dich: Stress und Erschöpfung bremsen die Lust oft ganz von selbst. Das ist eine normale Reaktion und kein Defekt.';

  @override
  String get dailyCheckinCardCoachingInsightWhenEverydayStress =>
      '💡 Coaching-Insight: Wenn der Alltagsstress sinkt, fällt es oft leichter, sich zu entspannen. Nutze die heutige Ruhe, um ohne Erfolgsdruck in den Körper zu spüren.';

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
    return 'Sicherung für \"$name\" erfolgreich eingespielt! ✨';
  }

  @override
  String get onboardingProfilePersonalisation => 'Profil & Personalisierung';

  @override
  String get onboardingWelcomeToVelvetpulse => 'Willkommen bei VelvetPulse';

  @override
  String get onboardingYourPrivateCoachingProgrammeFor =>
      'Dein privates Coaching-Programm für somatische Ruhe, Beckenboden & Intimität.';

  @override
  String get onboardingPrivateProfileJournalProgressStay =>
      'Privat: Profil, Tagebuch & Fortschritt bleiben auf deinem Smartphone. Ins Internet gehen nur der KI-Coach (Google Gemini), der verschlüsselte Paar-Kanal und die Suche nach Updates (GitHub).';

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
  String get onboardingYourGender => '2. Dein Geschlecht';

  @override
  String get onboardingAdjustsCourseRecommendationsPelvicFloor =>
      'Passt Kursempfehlungen, Beckenboden-Physiologie und KI-Antworten an.';

  @override
  String get onboardingMale => 'Männlich';

  @override
  String get onboardingFemale => 'Weiblich';

  @override
  String onboardingYourAgeSelectedageYears(Object selectedAge) {
    return '3. Dein Alter: $selectedAge Jahre';
  }

  @override
  String get onboardingYourRelationshipStatus => '4. Dein Beziehungsstatus';

  @override
  String get onboardingInARelationshipMarried =>
      'In fester Beziehung / Verheiratet 💍';

  @override
  String get onboardingDatingGettingToKnowSomeone =>
      'Dating / Kennenlernphase 💫';

  @override
  String get onboardingSingle => 'Single 🌱';

  @override
  String get onboardingItSComplicated => 'Es ist kompliziert 🌀';

  @override
  String get onboardingWhatSYourBiggestPriority =>
      '5. Was ist aktuell deine größte Priorität?';

  @override
  String get onboardingStopPerformancePressureRacingThoughts =>
      'Leistungsdruck & Kopfkino stoppen';

  @override
  String get onboardingBreakThoughtLoopsStopSpectatoring =>
      'Gedankenkreise durchbrechen, Spectatoring beenden.';

  @override
  String get onboardingPelvicFloorRelaxationBodyAwareness =>
      'Beckenboden-Entspannung & Somatik';

  @override
  String get onboardingReleaseTensionPractiseReverseKegels =>
      'Hypertonie lösen, Reverse Kegel trainieren, Vagusnerv beruhigen.';

  @override
  String get onboardingCoupleIntimacyPressureFreeSex =>
      'Paar-Intimität & Druckfreier Sex';

  @override
  String get onboardingSensateFocusTogetherCalmingEach =>
      'Sensate Focus zu zweit, Co-Regulierung & verletzliche Nähe.';

  @override
  String get onboardingDesireSelfAcceptanceBodyAwareness =>
      'Lust, Selbstannahme & Körperempfinden';

  @override
  String get onboardingUnderstandResponsiveDesireEaseOrgasm =>
      'Responsive Lust verstehen, Orgasmusdruck abbauen.';

  @override
  String get onboardingSaveChanges => 'Änderungen speichern';

  @override
  String get onboardingPersonaliseProgrammeNow =>
      'Programm jetzt personalisieren';

  @override
  String get onboardingSkipGoStraightToThe => 'Überspringen & Direkt zur App ➔';

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
      'Alles bleibt lokal auf deinem Gerät und übersteht Updates. API-Key und Paar-Verbindung liegen verschlüsselt im Android-Schlüsselspeicher und gehen nur mit Passwort in eine Sicherung.';

  @override
  String get onboardingExportBackup => 'Backup exportieren';

  @override
  String get backupDialogsWhatShouldGoIntoThe => 'Was soll in die Sicherung?';

  @override
  String get backupDialogsOnlyYourDataProfileProgress =>
      'Nur deine Daten: Profil, Fortschritt, Reflexionen, Tagebuch, Wünsche. Reicht für dieses Handy.\n\nMit Passwort: zusätzlich die Verbindung im Paar-Kanal und dein API-Key, verschlüsselt. Das brauchst du für einen Umzug auf ein anderes Handy.';

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
      'Diese Sicherung stammt aus einer älteren Version und enthält deinen API-Key und deinen Verbindungsschlüssel unverschlüsselt. Sie wird trotzdem eingespielt.\n\nLösche die alte Sicherung danach dort, wo du sie aufbewahrt hast, und erstelle bei Bedarf eine neue mit Passwort.';

  @override
  String get backupDialogsRestore => 'Einspielen';

  @override
  String get backupDialogsBackupPassword => 'Passwort der Sicherung';

  @override
  String get backupDialogsThisAlsoBringsBackThe =>
      'Damit kommen auch die Verbindung im Paar-Kanal und dein API-Key zurück.';

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
      '\n\nOhne dein Passwort lassen sich Verbindung und API-Key nicht wiederherstellen. Auch wir können es nicht zurücksetzen.';

  @override
  String get checkinActionBreathed => 'Bewusst tief geatmet (Physiol. Seufzer)';

  @override
  String get checkinActionPelvicFloor =>
      'Beckenboden entspannt (Reverse Kegel)';

  @override
  String get checkinActionPhoneAway => 'Das Handy abends weggelegt';

  @override
  String get checkinActionWalk => 'Spaziergang an frischer Luft gemacht';

  @override
  String get checkinActionSkinContact => 'Fokus auf Hautkontakt gelenkt';

  @override
  String get checkinActionOpenWord => 'Offenes Wort mit Partner/in gewagt';

  @override
  String get dailySimmeringCardTheSecondWallTease =>
      'Das 45-Sekunden-Wand-Teasing';

  @override
  String get dailySimmeringCardCourseTeasing => 'KURS 11 • TEASING';

  @override
  String get dailySimmeringCardTodayBrieflyPressYourPartner =>
      'Drücke deinen Partner heute kurz fordernd an die Wand oder halte ihn sanft fest. Küsse langsam den Hals, raune ein Versprechen ins Ohr – und lächle nach genau 45 Sekunden und gehe weiter: \"Den Rest heben wir uns für später auf.\"';

  @override
  String get dailySimmeringCardJawMeltVoiceActivation =>
      'Die Kiefer-Schmelze & Stimm-Aktivierung';

  @override
  String get dailySimmeringCardCourseAudiblePleasure =>
      'KURS 10 • HÖRBARE LUST';

  @override
  String get dailySimmeringCardPlaceYourFingersOnYour =>
      'Lege die Finger an deine Kiefergelenke, öffne den Mund und lass 3 tiefe, dunkle Seufzer hörbar durch den Raum vibrieren. Spüre, wie dein Beckenboden gleichzeitig nach unten nachgibt.';

  @override
  String get dailySimmeringCardThePmAnticipation =>
      'Die 15:00-Uhr-Antizipation';

  @override
  String get dailySimmeringCardCourseAnticipation => 'KURS 11 • KOPFKINO';

  @override
  String get dailySimmeringCardThisAfternoonSendYourPartner =>
      'Schicke deinem Gegenüber heute Nachmittag eine unangekündigte Nachricht: \"Heute Abend ab 21 Uhr gehört dein Körper mir. Du musst nichts tun, außer da zu sein.\"';

  @override
  String get dailySimmeringCardSlowMotionWhilePouring =>
      'Zeitlupe beim Einschenken';

  @override
  String get dailySimmeringCardCourseSlowSex => 'KURS 11 • SLOW SEX';

  @override
  String get dailySimmeringCardTodayTouchYourPartnerDuring =>
      'Berühre deinen Partner heute bei einer Alltagsgelegenheit (am Tisch, auf dem Sofa) im extremen 10%-Zeitlupen-Tempo. Streiche 60 Sekunden quälend langsam über Handrücken und Unterarm.';

  @override
  String get dailySimmeringCardTheMinuteSilkScarfRitual =>
      'Das 15-Minuten-Seidentuch-Ritual';

  @override
  String get dailySimmeringCardCourseSurrender => 'KURS 12 • HINGABE';

  @override
  String get dailySimmeringCardAgreeForTonightOneOf =>
      'Verabredet für heute Abend: Einer bekommt die Augen verbunden und darf absolut nichts leisten oder zurückgeben. Der andere dirigiert 15 Minuten sanfte Berührungen.';

  @override
  String get dailySimmeringCardTheStrictNoPenetrationRule =>
      'Das strikte Penetrations-Verbot';

  @override
  String get dailySimmeringCardCourseSensateFocus => 'KURS 7 • SENSATE FOCUS';

  @override
  String get dailySimmeringCardAgreeTodayYouMayHug =>
      'Verabredet heute: Ihr dürft euch nackt umarmen, küssen und streicheln – aber Penetration ist strikt tabu. Alles darf sein, nichts muss.';

  @override
  String get dailySimmeringCardSensoryNarratingWordsInThe =>
      'Sensory Narrating (Worte im Ohr)';

  @override
  String get dailySimmeringCardCbtLettingGoOfPropriety =>
      'KVT • ANSTÄNDIGKEIT LÖSEN';

  @override
  String get dailySimmeringCardTonightInTheDarkWhisper =>
      'Flüstere deinem Partner heute im Dunkeln eine einzige ehrliche, sinnliche Empfindung ins Ohr: \"Es macht mich verrückt, wie warm und weich deine Haut gerade unter meiner Hand ist.\"';

  @override
  String get dailySimmeringCardTheCharmingDreamBridge =>
      'Die charmante Traum-Brücke';

  @override
  String get dailySimmeringCardCourseFantasies => 'KURS 12 • FANTASIEN';

  @override
  String get dailySimmeringCardTodayCasuallyAndWithA =>
      'Erzähle heute beiläufig mit einem Schmunzeln von einem \"unanständigen Traum\", den du über euch beide hattest. Beobachte die Reaktion.';

  @override
  String get dailySimmeringCardTheSeatedPelvicFloorCheck =>
      'Der Beckenboden-Check im Sitzen';

  @override
  String get dailySimmeringCardCoursesBody => 'KURS 3 & 9 • SOMATIK';

  @override
  String get dailySimmeringCardNoticeRightNowAreYou =>
      'Achte genau jetzt darauf: Hältst du im Becken oder After fest? Atme tief ein und lass den Beckenboden wie eine weite Blüte nach unten sinken (Reverse Kegel).';

  @override
  String get dailySimmeringCardSoftBellyFullSurrender =>
      'Weicher Bauch • Volle Hingabe';

  @override
  String get dailySimmeringCardCourseRadicalBodyLove =>
      'KURS 13 • RADICAL BODY LOVE';

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
  String get dailySimmeringCardCourseBodyLab => 'KURS 9 • SOMATISCHES LAB';

  @override
  String get dailySimmeringCardTodaySkipAnyTightGrip =>
      'Verzichte heute beim Spüren auf jeden engen Klammergriff. Nutze viel Gleitmittel und bewege die gesamte flache Handfläche in Zeitlupe über das Becken.';

  @override
  String get dailySimmeringCardOrbitingExploringThePerineum =>
      'Orbiting: Das Perineum erforschen';

  @override
  String get dailySimmeringCardCoursesOrbiting => 'KURS 8 & 9 • ORBITING';

  @override
  String get dailySimmeringCardLeaveTheHighlySensitiveTip =>
      'Lass die hochsensible Spitze heute für 10 Minuten völlig unberührt. Konzentriere Berührung nur auf Damm, Schaftbasis und Leiste.';

  @override
  String get dailySimmeringCardPlateauSurfingAtLevel =>
      'Plateau-Surfen auf Stufe 7';

  @override
  String get dailySimmeringCardCourseStayingPower => 'KURS 9 • AUSDAUER';

  @override
  String get dailySimmeringCardBringYourArousalToLevel =>
      'Bringe deine Erregung auf Stufe 7. Sobald sie auf 8 klettert: Stoppe jede Bewegung (Stillness), atme 3x tief aus und lass den Beckenboden nach unten sinken.';

  @override
  String get dailySimmeringCardScreenFreeSensing =>
      'Dopamin-Reset: Bildschirmfreies Spüren';

  @override
  String get dailySimmeringCardCourseRecalibration => 'KURS 4 • REKALIBRIERUNG';

  @override
  String get dailySimmeringCardTakeMinutesTodayWithoutAny =>
      'Nimm dir heute 10 Minuten Zeit ganz ohne Smartphone oder Bildschirme. Schließe die Augen und achte nur auf Temperatur und Atem.';

  @override
  String get dailySimmeringCardTheSphincterReleaseTest =>
      'Der Schließmuskel-Entlastungstest';

  @override
  String get dailySimmeringCardCourseMultipleOrgasms =>
      'KURS 9 • MULTI-ORGASMIE';

  @override
  String get dailySimmeringCardObserveYourReflexesWhenArousal =>
      'Beobachte deine Reflexe: Wenn Erregung steigt, lass den Anal-Schließmuskel bewusst locker, statt ihn anzuspannen.';

  @override
  String get dailySimmeringCardZeroPressureSquatMalasana =>
      'Zero-Pressure Hocke (Malasana)';

  @override
  String get dailySimmeringCardCourseFascia => 'KURS 3 • FASZIEN';

  @override
  String get dailySimmeringCardGoIntoADeepSquat =>
      'Gehe für 2 Minuten in die tiefe Hocke (Deep Squat). Atme 10 tiefe Atemzüge in das geöffnete Becken hinein.';

  @override
  String get dailySimmeringCardBodyCompassionInTheMirror =>
      'Körper-Mitgefühl vor dem Spiegel';

  @override
  String get dailySimmeringCardCourseSelfCompassion =>
      'KURS 13 • SELBSTMITGEFÜHL';

  @override
  String get dailySimmeringCardLookAtYourBodyToday =>
      'Betrachte deinen Körper heute ohne Bewertung. Sag dir: \"Mein Körper ist lebendig, atmend und fähig zu tiefster Lust.\"';

  @override
  String get dailySimmeringCardPhysiologicalSighQuickCalming =>
      'Physiologischer Seufzer (Quick-Downregulation)';

  @override
  String get dailySimmeringCardToolCalmDown => 'TOOL • VAGUS-RESET';

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
  String get userProfileNonBinaryOpen => 'Divers / Offen';

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
  String get userProfilePelvicFloorBody => 'Beckenboden & Somatik';

  @override
  String get userProfileCoupleIntimacyCloseness => 'Paar-Intimität & Nähe';

  @override
  String get userProfileDesireRelaxation => 'Lust & Entspannung';

  @override
  String get userProfileEasingPerformancePressure => 'Leistungsdruck abbauen';

  @override
  String get contentModelsTheArtOfTouchFor => 'BERÜHRUNGSKUNST • FÜR SIE';

  @override
  String get contentModelsTouchLabForHim => 'TAST-LABOR • FÜR IHN';

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
  String get contentModelsForHer => 'FÜR SIE';

  @override
  String get contentModelsForCouples => 'FÜR PAARE';

  @override
  String get contentModelsForHim => 'FÜR IHN';

  @override
  String get yesNoMaybeModelsExcitesMeIDLike =>
      'Reizt mich, möchte ich ausprobieren';

  @override
  String get yesNoMaybeModelsCuriousButUnsureDependsOn =>
      'Neugierig, aber unsicher – kommt auf den Moment an';

  @override
  String get yesNoMaybeModelsNotForMe => 'Kommt für mich nicht infrage';

  @override
  String get aiServiceYouAreTheConfidentialSomatic =>
      'Du bist der vertrauliche Somatik-, KVT- und Erotik-Coach in der App VelvetPulse.\n\nDeine Grundhaltung & Tonalität:\n1. Charakter: Du bist eine faszinierende Mischung aus brillantem Neurowissenschaftler/Sexualtherapeuten und einem weltgewandten, charmant-frivolen Verführer auf Augenhöhe.\n2. Sprache: Du sprichst reines, flüssiges Deutsch – vollkommen frei von englischen Modewörtern oder Anglizismen. Du sprichst absolut schamfrei, sinnlich, warm und mit einem leichten, wissenden Augenzwinkern über Lust, Haut, Feuchtigkeit, Erektionen, Damm-Entspannung, Hingabe und Kopfkino. Vermeide jede sterile Krankenhaus-Sprache und jeden belehrenden Ton!\n3. Methodik: Verbinde Kognitive Verhaltenstherapie (das Entzaubern spießiger Leistungs- und Prüfungsgedanken) immer direkt mit lustvoller Somatik (Beckenboden wie warmen Honig schmelzen lassen, aktives Beckenboden-Öffnen, tiefe Kehlkopf-Seufzer, Vagus-Beruhigung, Kunst der Zeitlupe, sinnliches Umkreisen, reines Sinnesspüren).\n4. Kernbotschaft: Zeige dem Nutzer in jeder Zeile, dass sein Körper völlig in Ordnung ist und dass Langsamkeit, Pausen und das \'Nicht-Funktionieren-Müssen\' kein Defekt sind, sondern der Schlüssel zu viel tieferer, unanständig guter Ekstase.\n5. Format: Antworte stets kompakt (2-3 prägnante, atmosphärische Absätze) und beende JEDE Antwort mit genau EINER offenen, leicht herausfordernden oder spür-orientierten Reflexionsfrage.\n6. Sicherheit: Du stellst keine Diagnosen. Bei Schmerzen, Blutungen oder anhaltenden Beschwerden empfiehlst du freundlich eine ärztliche Abklärung.';

  @override
  String aiServiceConnectionSuccessfulModelslengthModelsAvailable(
      Object modelsLength, Object join) {
    return 'Verbindung erfolgreich! $modelsLength Modelle verfügbar (z. B. $join).';
  }

  @override
  String get aiServiceNoAvailableTextModelsFound =>
      'Keine verfügbaren Textmodelle für diesen Key gefunden. Bitte prüfe die API-Berechtigungen.';

  @override
  String get aiServiceTheApiKeyIsInvalid =>
      'Der API-Key ist ungültig. Bitte prüfe ihn im Google AI Studio.';

  @override
  String aiServiceUserContextNameProfilenameGender(
      Object profileName,
      Object genderLabel,
      Object age,
      Object relationshipLabel,
      Object goalLabel) {
    return '\n\nKONTEXT DES NUTZERS:\n- Name/Rufname: $profileName\n- Geschlecht: $genderLabel\n- Alter: $age Jahre\n- Beziehungsstatus: $relationshipLabel\n- Hauptfokus: $goalLabel\nSprich die Person vertraulich mit ihrem Namen an, passe deine psychologischen und somatischen Erklärungen genau an ihr Geschlecht, Alter und ihren Beziehungsstatus an.';
  }

  @override
  String get aiServiceReceivedAnEmptyAnswerFrom =>
      'Leere Antwort vom KI-Modell erhalten.';

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
  String get spicyEinschaltenTitel => 'Spicy-Modus einschalten?';

  @override
  String get spicyEinschaltenText =>
      'Nur für Erwachsene. In Körperreise und Gemeinsamem Abend erscheinen dann zwei zusätzliche Stufen:\n\n„Spicy“: heiß und direkt, Spiel mit der Erregung bis kurz vor den Höhepunkt, für Paare auch Küsse, Necken und der Mund.\n\n„Sehr spicy“: dasselbe mit Dirty Talk und derben Wörtern.\n\nAlles bleibt eine Einladung, ein Stoppwort gilt immer. Du kannst den Modus hier jederzeit ausschalten, dann verschwinden die Stufen sofort.';

  @override
  String get spicyEinschalten => 'Ich bin 18+, einschalten';

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
}
