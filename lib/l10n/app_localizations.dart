import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'VelvetPulse'**
  String get appName;

  /// No description provided for @spracheTitel.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get spracheTitel;

  /// No description provided for @spracheAutomatisch.
  ///
  /// In de, this message translates to:
  /// **'Automatisch (wie das Gerät)'**
  String get spracheAutomatisch;

  /// No description provided for @spracheDeutsch.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get spracheDeutsch;

  /// No description provided for @spracheEnglisch.
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get spracheEnglisch;

  /// No description provided for @mainNavigationProgrammeCourses.
  ///
  /// In de, this message translates to:
  /// **'Programm & Kurse'**
  String get mainNavigationProgrammeCourses;

  /// No description provided for @mainNavigationSomaticsTraining.
  ///
  /// In de, this message translates to:
  /// **'Somatik & Training'**
  String get mainNavigationSomaticsTraining;

  /// No description provided for @mainNavigationCbtReframing.
  ///
  /// In de, this message translates to:
  /// **'KVT-Reframing'**
  String get mainNavigationCbtReframing;

  /// No description provided for @mainNavigationCoupleChannel.
  ///
  /// In de, this message translates to:
  /// **'Paar-Kanal'**
  String get mainNavigationCoupleChannel;

  /// No description provided for @mainNavigationAiCoach.
  ///
  /// In de, this message translates to:
  /// **'KI-Coach'**
  String get mainNavigationAiCoach;

  /// No description provided for @mainNavigationCourses.
  ///
  /// In de, this message translates to:
  /// **'Kurse'**
  String get mainNavigationCourses;

  /// No description provided for @mainNavigationTraining.
  ///
  /// In de, this message translates to:
  /// **'Training'**
  String get mainNavigationTraining;

  /// No description provided for @mainNavigationReframing.
  ///
  /// In de, this message translates to:
  /// **'Reframing'**
  String get mainNavigationReframing;

  /// No description provided for @whatsNewWelcomeBack.
  ///
  /// In de, this message translates to:
  /// **'Willkommen zurück'**
  String get whatsNewWelcomeBack;

  /// No description provided for @whatsNewThisIsNewInVersion.
  ///
  /// In de, this message translates to:
  /// **'Das ist neu in Version {version}.'**
  String whatsNewThisIsNewInVersion(Object version);

  /// No description provided for @whatsNewLetSGo.
  ///
  /// In de, this message translates to:
  /// **'Los geht\'s'**
  String get whatsNewLetSGo;

  /// No description provided for @playerSteuerungStop.
  ///
  /// In de, this message translates to:
  /// **'Beenden'**
  String get playerSteuerungStop;

  /// No description provided for @playerSteuerungResume.
  ///
  /// In de, this message translates to:
  /// **'Fortsetzen'**
  String get playerSteuerungResume;

  /// No description provided for @playerSteuerungPause.
  ///
  /// In de, this message translates to:
  /// **'Pausieren'**
  String get playerSteuerungPause;

  /// No description provided for @playerSteuerungPause2.
  ///
  /// In de, this message translates to:
  /// **'Pause'**
  String get playerSteuerungPause2;

  /// No description provided for @playerSteuerungSkip.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get playerSteuerungSkip;

  /// No description provided for @ausspracheMeldenWordMispronounced.
  ///
  /// In de, this message translates to:
  /// **'Wort falsch ausgesprochen?'**
  String get ausspracheMeldenWordMispronounced;

  /// No description provided for @ausspracheMeldenThanksForHelpingTheReport.
  ///
  /// In de, this message translates to:
  /// **'Danke, dass du hilfst! Die Meldung landet öffentlich auf GitHub und braucht dort ein Konto. Sie ist unter deinem Kontonamen sichtbar.\n\nÜbertragen werden nur die Stelle im Audio und die Stimme. Das Wort trägst du selbst ein.'**
  String get ausspracheMeldenThanksForHelpingTheReport;

  /// No description provided for @ausspracheMeldenCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get ausspracheMeldenCancel;

  /// No description provided for @ausspracheMeldenContinueToGithub.
  ///
  /// In de, this message translates to:
  /// **'Weiter zu GitHub'**
  String get ausspracheMeldenContinueToGithub;

  /// No description provided for @ausspracheMeldenTheBrowserCouldNotBe.
  ///
  /// In de, this message translates to:
  /// **'Der Browser ließ sich nicht öffnen.'**
  String get ausspracheMeldenTheBrowserCouldNotBe;

  /// No description provided for @updateDialogYouHaveTheLatestVersion.
  ///
  /// In de, this message translates to:
  /// **'Du hast die neueste Version.'**
  String get updateDialogYouHaveTheLatestVersion;

  /// No description provided for @updateDialogPleaseAllowTheAppTo.
  ///
  /// In de, this message translates to:
  /// **'Bitte erlaube der App im nächsten Schritt, Updates zu installieren, und tippe dann erneut.'**
  String get updateDialogPleaseAllowTheAppTo;

  /// No description provided for @updateDialogTheDownloadedFileIsDamaged.
  ///
  /// In de, this message translates to:
  /// **'Die heruntergeladene Datei ist beschädigt. Bitte später noch einmal versuchen.'**
  String get updateDialogTheDownloadedFileIsDamaged;

  /// No description provided for @updateDialogTheUpdateDidnTWork.
  ///
  /// In de, this message translates to:
  /// **'Das Update hat nicht geklappt ({statusName}). Bitte später noch einmal versuchen.'**
  String updateDialogTheUpdateDidnTWork(Object statusName);

  /// No description provided for @updateDialogDownloadFailedPleaseCheckYour.
  ///
  /// In de, this message translates to:
  /// **'Download fehlgeschlagen. Bitte Internetverbindung prüfen.'**
  String get updateDialogDownloadFailedPleaseCheckYour;

  /// No description provided for @updateDialogNewBetaVersion.
  ///
  /// In de, this message translates to:
  /// **'Neue Beta {version}'**
  String updateDialogNewBetaVersion(Object version);

  /// No description provided for @updateDialogNewVersionVersion.
  ///
  /// In de, this message translates to:
  /// **'Neue Version {version}'**
  String updateDialogNewVersionVersion(Object version);

  /// No description provided for @updateDialogImprovementsAndBugFixes.
  ///
  /// In de, this message translates to:
  /// **'Verbesserungen und Fehlerbehebungen.'**
  String get updateDialogImprovementsAndBugFixes;

  /// No description provided for @updateDialogDownloadingProgress.
  ///
  /// In de, this message translates to:
  /// **'Wird heruntergeladen … {progress} %'**
  String updateDialogDownloadingProgress(Object progress);

  /// No description provided for @updateDialogYourDataIsKeptDuring.
  ///
  /// In de, this message translates to:
  /// **'Deine Daten bleiben bei der Aktualisierung erhalten.'**
  String get updateDialogYourDataIsKeptDuring;

  /// No description provided for @updateDialogLater.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get updateDialogLater;

  /// No description provided for @updateDialogUpdateNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt aktualisieren'**
  String get updateDialogUpdateNow;

  /// No description provided for @coursesAllCourses.
  ///
  /// In de, this message translates to:
  /// **'Alle Kurse'**
  String get coursesAllCourses;

  /// No description provided for @coursesTouch.
  ///
  /// In de, this message translates to:
  /// **'Berührung'**
  String get coursesTouch;

  /// No description provided for @coursesForHer.
  ///
  /// In de, this message translates to:
  /// **'Für Sie 🌸'**
  String get coursesForHer;

  /// No description provided for @coursesForHim.
  ///
  /// In de, this message translates to:
  /// **'Für Ihn 🌿'**
  String get coursesForHim;

  /// No description provided for @coursesForCouples.
  ///
  /// In de, this message translates to:
  /// **'Für Paare 💫'**
  String get coursesForCouples;

  /// No description provided for @coursesCoupleChannel.
  ///
  /// In de, this message translates to:
  /// **'PAAR-KANAL'**
  String get coursesCoupleChannel;

  /// No description provided for @coursesYourPrivateSpace.
  ///
  /// In de, this message translates to:
  /// **'Euer privater Raum'**
  String get coursesYourPrivateSpace;

  /// No description provided for @coursesSendSparksSecretlyMatchWishes.
  ///
  /// In de, this message translates to:
  /// **'Funken senden & Wünsche heimlich abgleichen'**
  String get coursesSendSparksSecretlyMatchWishes;

  /// No description provided for @coursesYourCurriculum.
  ///
  /// In de, this message translates to:
  /// **'DEIN CURRICULUM'**
  String get coursesYourCurriculum;

  /// No description provided for @coursesHelloProfilename.
  ///
  /// In de, this message translates to:
  /// **'Hallo, {profileName}'**
  String coursesHelloProfilename(Object profileName);

  /// No description provided for @coursesWelcome.
  ///
  /// In de, this message translates to:
  /// **'Willkommen'**
  String get coursesWelcome;

  /// No description provided for @coursesYourFocusGoallabel.
  ///
  /// In de, this message translates to:
  /// **'Dein Fokus: {goalLabel}'**
  String coursesYourFocusGoallabel(Object goalLabel);

  /// No description provided for @coursesUnderstandTheBiologyQuietThe.
  ///
  /// In de, this message translates to:
  /// **'Biologie verstehen. Kopfkino stoppen. Körper spüren.'**
  String get coursesUnderstandTheBiologyQuietThe;

  /// No description provided for @coursesProfileSettings.
  ///
  /// In de, this message translates to:
  /// **'Profil & Einstellungen'**
  String get coursesProfileSettings;

  /// No description provided for @coursesOverallProgressCompletedcountOfTotallessons.
  ///
  /// In de, this message translates to:
  /// **'Gesamtfortschritt: {completedCount} von {totalLessons} Lektionen'**
  String coursesOverallProgressCompletedcountOfTotallessons(
      Object completedCount, Object totalLessons);

  /// No description provided for @coursesDurationminMin.
  ///
  /// In de, this message translates to:
  /// **'{durationMin} Min.'**
  String coursesDurationminMin(Object durationMin);

  /// No description provided for @coursesPracticePelvicFloor.
  ///
  /// In de, this message translates to:
  /// **'Praxis: Beckenboden'**
  String get coursesPracticePelvicFloor;

  /// No description provided for @coursesPracticeBreath.
  ///
  /// In de, this message translates to:
  /// **'Praxis: Atem'**
  String get coursesPracticeBreath;

  /// No description provided for @coursesPracticeCbt.
  ///
  /// In de, this message translates to:
  /// **'Praxis: KVT'**
  String get coursesPracticeCbt;

  /// No description provided for @lessonDetailLessonMarkedAsCompleted.
  ///
  /// In de, this message translates to:
  /// **'Lektion als abgeschlossen markiert! 🎉'**
  String get lessonDetailLessonMarkedAsCompleted;

  /// No description provided for @lessonDetailLessonMarkedAsOpenAgain.
  ///
  /// In de, this message translates to:
  /// **'Lektion wieder als offen markiert.'**
  String get lessonDetailLessonMarkedAsOpenAgain;

  /// No description provided for @lessonDetailLessonSentToPartnername.
  ///
  /// In de, this message translates to:
  /// **'Lektion an {partnerName} geschickt.'**
  String lessonDetailLessonSentToPartnername(Object partnerName);

  /// No description provided for @lessonDetailSendingDidnTWorkPlease.
  ///
  /// In de, this message translates to:
  /// **'Senden hat nicht geklappt. Bitte gleich noch einmal versuchen.'**
  String get lessonDetailSendingDidnTWorkPlease;

  /// No description provided for @lessonDetailYourThoughtsAreWithPartnername.
  ///
  /// In de, this message translates to:
  /// **'Deine Gedanken sind bei {partnerName}. Sichtbar werden sie, wenn auch dort eine Antwort steht.'**
  String lessonDetailYourThoughtsAreWithPartnername(Object partnerName);

  /// No description provided for @lessonDetailNameHasAlreadyAnswered.
  ///
  /// In de, this message translates to:
  /// **'{name} hat schon geantwortet'**
  String lessonDetailNameHasAlreadyAnswered(Object name);

  /// No description provided for @lessonDetailNameSThoughts.
  ///
  /// In de, this message translates to:
  /// **'Die Gedanken von {name}'**
  String lessonDetailNameSThoughts(Object name);

  /// No description provided for @lessonDetailWriteAndSaveYourOwn.
  ///
  /// In de, this message translates to:
  /// **'Schreib und speichere zuerst deine eigene Antwort, dann siehst du die von {name}.'**
  String lessonDetailWriteAndSaveYourOwn(Object name);

  /// No description provided for @lessonDetailShareWithPartnername.
  ///
  /// In de, this message translates to:
  /// **'Mit {partnerName} teilen'**
  String lessonDetailShareWithPartnername(Object partnerName);

  /// No description provided for @lessonDetailCompleted.
  ///
  /// In de, this message translates to:
  /// **'Abgeschlossen'**
  String get lessonDetailCompleted;

  /// No description provided for @lessonDetailMarkAsCompleted.
  ///
  /// In de, this message translates to:
  /// **'Als abgeschlossen markieren'**
  String get lessonDetailMarkAsCompleted;

  /// No description provided for @lessonDetailAudioExercise.
  ///
  /// In de, this message translates to:
  /// **'AUDIO-ÜBUNG'**
  String get lessonDetailAudioExercise;

  /// No description provided for @lessonDetailLesson.
  ///
  /// In de, this message translates to:
  /// **'LEKTION'**
  String get lessonDetailLesson;

  /// No description provided for @lessonDetailDurationminMinRead.
  ///
  /// In de, this message translates to:
  /// **'{durationMin} Min. Lesezeit'**
  String lessonDetailDurationminMinRead(Object durationMin);

  /// No description provided for @lessonDetailLessonCompletedDone.
  ///
  /// In de, this message translates to:
  /// **'Lektion abgeschlossen (Erledigt)'**
  String get lessonDetailLessonCompletedDone;

  /// No description provided for @lessonDetailMarkLessonAsCompleted.
  ///
  /// In de, this message translates to:
  /// **'Lektion als abgeschlossen markieren'**
  String get lessonDetailMarkLessonAsCompleted;

  /// No description provided for @lessonDetailOpenPelvicFloorTimer.
  ///
  /// In de, this message translates to:
  /// **'Beckenboden-Timer öffnen'**
  String get lessonDetailOpenPelvicFloorTimer;

  /// No description provided for @lessonDetailGoStraightIntoRelaxationStrengthening.
  ///
  /// In de, this message translates to:
  /// **'Direkt in die Entspannungs- & Kräftigungs-Praxis einsteigen'**
  String get lessonDetailGoStraightIntoRelaxationStrengthening;

  /// No description provided for @lessonDetailStartBreathPacerDownRegulation.
  ///
  /// In de, this message translates to:
  /// **'Atem-Pacer (Down-Regulation) starten'**
  String get lessonDetailStartBreathPacerDownRegulation;

  /// No description provided for @lessonDetailCalmDownWithBreathingOr.
  ///
  /// In de, this message translates to:
  /// **'Vagusnerv aktivieren & Adrenalin senken mit 4-7-8 oder Seufzer'**
  String get lessonDetailCalmDownWithBreathingOr;

  /// No description provided for @lessonDetailMyDesireProfile.
  ///
  /// In de, this message translates to:
  /// **'Mein Lust-Profil'**
  String get lessonDetailMyDesireProfile;

  /// No description provided for @lessonDetailTickWhatYouLikeAnd.
  ///
  /// In de, this message translates to:
  /// **'Ankreuzen, was dir gefällt – und auf Wunsch deinem Gegenüber schicken'**
  String get lessonDetailTickWhatYouLikeAnd;

  /// No description provided for @lessonDetailGuidedSelfExploration.
  ///
  /// In de, this message translates to:
  /// **'Geführte Selbsterkundung'**
  String get lessonDetailGuidedSelfExploration;

  /// No description provided for @lessonDetailToMinutesAVoiceGuides.
  ///
  /// In de, this message translates to:
  /// **'10 bis 30 Minuten, eine Stimme begleitet dich – so nah, wie du möchtest'**
  String get lessonDetailToMinutesAVoiceGuides;

  /// No description provided for @lessonDetailStartCbtThoughtRecord.
  ///
  /// In de, this message translates to:
  /// **'KVT-Gedankenprotokoll starten'**
  String get lessonDetailStartCbtThoughtRecord;

  /// No description provided for @lessonDetailReframeAnticipatoryAnxietyAndCatastrophic.
  ///
  /// In de, this message translates to:
  /// **'Erwartungsangst und innere Katastrophengedanken reframen'**
  String get lessonDetailReframeAnticipatoryAnxietyAndCatastrophic;

  /// No description provided for @lessonDetailMatchingPractice.
  ///
  /// In de, this message translates to:
  /// **'PASSENDE PRAXIS-ÜBUNG'**
  String get lessonDetailMatchingPractice;

  /// No description provided for @lessonDetailStartThePracticeNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt Praxis-Übung starten'**
  String get lessonDetailStartThePracticeNow;

  /// No description provided for @lessonDetailYourPersonalReflection.
  ///
  /// In de, this message translates to:
  /// **'Deine persönliche Reflexion'**
  String get lessonDetailYourPersonalReflection;

  /// No description provided for @lessonDetailWriteDownYourHonestThoughts.
  ///
  /// In de, this message translates to:
  /// **'Schreibe hier deine ehrlichen Gedanken auf. Sie bleiben auf deinem Gerät, außer du teilst sie.'**
  String get lessonDetailWriteDownYourHonestThoughts;

  /// No description provided for @lessonDetailSavedLocally.
  ///
  /// In de, this message translates to:
  /// **'Lokal gespeichert!'**
  String get lessonDetailSavedLocally;

  /// No description provided for @lessonDetailSaveAnswer.
  ///
  /// In de, this message translates to:
  /// **'Antwort speichern'**
  String get lessonDetailSaveAnswer;

  /// No description provided for @lessonDetailShareWithPartnername2.
  ///
  /// In de, this message translates to:
  /// **'Mit {partnerName} teilen'**
  String lessonDetailShareWithPartnername2(Object partnerName);

  /// No description provided for @audioPlayerCardDeviceVoice.
  ///
  /// In de, this message translates to:
  /// **'GERÄTE-STIMME'**
  String get audioPlayerCardDeviceVoice;

  /// No description provided for @audioPlayerCardGuidedExercise.
  ///
  /// In de, this message translates to:
  /// **'GEFÜHRTE ÜBUNG'**
  String get audioPlayerCardGuidedExercise;

  /// No description provided for @audioPlayerCardListen.
  ///
  /// In de, this message translates to:
  /// **'ZUM ANHÖREN'**
  String get audioPlayerCardListen;

  /// No description provided for @audioPlayerCardJustFollowTheVoice.
  ///
  /// In de, this message translates to:
  /// **'Folge einfach der Stimme …'**
  String get audioPlayerCardJustFollowTheVoice;

  /// No description provided for @audioPlayerCardReadingAloud.
  ///
  /// In de, this message translates to:
  /// **'Wird vorgelesen …'**
  String get audioPlayerCardReadingAloud;

  /// No description provided for @audioPlayerCardPausedTapToResume.
  ///
  /// In de, this message translates to:
  /// **'Pausiert • Tippe zum Fortsetzen'**
  String get audioPlayerCardPausedTapToResume;

  /// No description provided for @audioPlayerCardCloseYourEyesAndListen.
  ///
  /// In de, this message translates to:
  /// **'Schließ die Augen und lausche'**
  String get audioPlayerCardCloseYourEyesAndListen;

  /// No description provided for @audioPlayerCardListenToTheLessonApprox.
  ///
  /// In de, this message translates to:
  /// **'Lektion anhören (ca. {durationMin} Min.)'**
  String audioPlayerCardListenToTheLessonApprox(Object durationMin);

  /// No description provided for @audioPlayerCardBackS.
  ///
  /// In de, this message translates to:
  /// **'10 Sek. zurück'**
  String get audioPlayerCardBackS;

  /// No description provided for @audioPlayerCardForwardS.
  ///
  /// In de, this message translates to:
  /// **'10 Sek. vor'**
  String get audioPlayerCardForwardS;

  /// No description provided for @audioPlayerCardStopReset.
  ///
  /// In de, this message translates to:
  /// **'Stoppen & Zurücksetzen'**
  String get audioPlayerCardStopReset;

  /// No description provided for @trainingPelvicFloor.
  ///
  /// In de, this message translates to:
  /// **'Beckenboden'**
  String get trainingPelvicFloor;

  /// No description provided for @trainingBreathPacer.
  ///
  /// In de, this message translates to:
  /// **'Atem-Pacer'**
  String get trainingBreathPacer;

  /// No description provided for @breathPacerViewBreatheIn.
  ///
  /// In de, this message translates to:
  /// **'EINATMEN'**
  String get breathPacerViewBreatheIn;

  /// No description provided for @breathPacerViewBreatheInCalmlyAndDeeply.
  ///
  /// In de, this message translates to:
  /// **'Ruhig und tief durch die Nase einatmen...'**
  String get breathPacerViewBreatheInCalmlyAndDeeply;

  /// No description provided for @breathPacerViewHold.
  ///
  /// In de, this message translates to:
  /// **'HALTEN'**
  String get breathPacerViewHold;

  /// No description provided for @breathPacerViewHoldYourBreathKeepThe.
  ///
  /// In de, this message translates to:
  /// **'Atem anhalten, Brustkorb entspannt lassen...'**
  String get breathPacerViewHoldYourBreathKeepThe;

  /// No description provided for @breathPacerViewBreatheOutSlowly.
  ///
  /// In de, this message translates to:
  /// **'LANGSAM AUSATMEN'**
  String get breathPacerViewBreatheOutSlowly;

  /// No description provided for @breathPacerViewBreatheOutFullyThroughThe.
  ///
  /// In de, this message translates to:
  /// **'Vollständig und mit sanftem Zischen durch den Mund ausatmen...'**
  String get breathPacerViewBreatheOutFullyThroughThe;

  /// No description provided for @breathPacerViewBreatheInDeeply.
  ///
  /// In de, this message translates to:
  /// **'TIEF EINATMEN'**
  String get breathPacerViewBreatheInDeeply;

  /// No description provided for @breathPacerViewBreatheDeepIntoTheBelly.
  ///
  /// In de, this message translates to:
  /// **'Tief durch die Nase in den Bauch einatmen...'**
  String get breathPacerViewBreatheDeepIntoTheBelly;

  /// No description provided for @breathPacerViewSecondBreath.
  ///
  /// In de, this message translates to:
  /// **'ZWEITER ATEMZUG'**
  String get breathPacerViewSecondBreath;

  /// No description provided for @breathPacerViewTakeOneMoreShortSip.
  ///
  /// In de, this message translates to:
  /// **'Noch einen kurzen Luftzug oben drauf ziehen...'**
  String get breathPacerViewTakeOneMoreShortSip;

  /// No description provided for @breathPacerViewSighItOut.
  ///
  /// In de, this message translates to:
  /// **'SEUFZEND AUSATMEN'**
  String get breathPacerViewSighItOut;

  /// No description provided for @breathPacerViewBreatheOutVeryLongAnd.
  ///
  /// In de, this message translates to:
  /// **'Sehr lang und hörbar durch den Mund ausatmen, Schultern fallen lassen...'**
  String get breathPacerViewBreatheOutVeryLongAnd;

  /// No description provided for @breathPacerViewBreathing.
  ///
  /// In de, this message translates to:
  /// **'4-7-8 Atmung'**
  String get breathPacerViewBreathing;

  /// No description provided for @breathPacerViewDeepCalmingBreath.
  ///
  /// In de, this message translates to:
  /// **'Tiefe, beruhigende Atmung'**
  String get breathPacerViewDeepCalmingBreath;

  /// No description provided for @breathPacerViewPhysiologicalSigh.
  ///
  /// In de, this message translates to:
  /// **'Physiol. Seufzer'**
  String get breathPacerViewPhysiologicalSigh;

  /// No description provided for @breathPacerViewQuickWayToCalmDown.
  ///
  /// In de, this message translates to:
  /// **'Schnell zur Ruhe kommen'**
  String get breathPacerViewQuickWayToCalmDown;

  /// No description provided for @breathPacerViewCompletedcyclesCyclesCompleted.
  ///
  /// In de, this message translates to:
  /// **'{completedCycles} Zyklen abgeschlossen'**
  String breathPacerViewCompletedcyclesCyclesCompleted(Object completedCycles);

  /// No description provided for @breathPacerViewALongerExhaleMeasurablySlows.
  ///
  /// In de, this message translates to:
  /// **'Längeres Ausatmen verlangsamt messbar den Herzschlag.'**
  String get breathPacerViewALongerExhaleMeasurablySlows;

  /// No description provided for @breathPacerViewTheDoubleInhaleIsMeant.
  ///
  /// In de, this message translates to:
  /// **'Der doppelte Atemzug entfaltet kollabierte Lungenbläschen.'**
  String get breathPacerViewTheDoubleInhaleIsMeant;

  /// No description provided for @breathPacerViewStart.
  ///
  /// In de, this message translates to:
  /// **'Start'**
  String get breathPacerViewStart;

  /// No description provided for @breathPacerViewBackgroundWhenTheExhaleLasts.
  ///
  /// In de, this message translates to:
  /// **'Hintergrund: Wenn das Ausatmen länger dauert als das Einatmen, wird der Herzschlag mit jedem Ausatmen ein wenig langsamer. Das ist ein normaler Reflex, den viele als beruhigend erleben.'**
  String get breathPacerViewBackgroundWhenTheExhaleLasts;

  /// No description provided for @sosModalSosQuickHelp.
  ///
  /// In de, this message translates to:
  /// **'SOS Akut-Hilfe'**
  String get sosModalSosQuickHelp;

  /// No description provided for @sosModalCalmDownRightNowEmergency.
  ///
  /// In de, this message translates to:
  /// **'Sofortige Down-Regulation & Notfall-Schritte'**
  String get sosModalCalmDownRightNowEmergency;

  /// No description provided for @sosModalBefore.
  ///
  /// In de, this message translates to:
  /// **'Vorab'**
  String get sosModalBefore;

  /// No description provided for @sosModalInTheMoment.
  ///
  /// In de, this message translates to:
  /// **'Im Moment'**
  String get sosModalInTheMoment;

  /// No description provided for @sosModalAfterwards.
  ///
  /// In de, this message translates to:
  /// **'Danach'**
  String get sosModalAfterwards;

  /// No description provided for @sosModalYourMantraForThisMoment.
  ///
  /// In de, this message translates to:
  /// **'DEIN MANTRA FÜR DIESEN MOMENT'**
  String get sosModalYourMantraForThisMoment;

  /// No description provided for @sosModalMantra.
  ///
  /// In de, this message translates to:
  /// **'„{mantra}“'**
  String sosModalMantra(Object mantra);

  /// No description provided for @sosModalImmediateStepsTickOff.
  ///
  /// In de, this message translates to:
  /// **'SOFORT-SCHRITTE (ABHAKEN)'**
  String get sosModalImmediateStepsTickOff;

  /// No description provided for @sosModalCheckedlengthImmediatestepslengthDone.
  ///
  /// In de, this message translates to:
  /// **'{checkedLength}/{immediateStepsLength} erledigt'**
  String sosModalCheckedlengthImmediatestepslengthDone(
      Object checkedLength, Object immediateStepsLength);

  /// No description provided for @appLockLocked.
  ///
  /// In de, this message translates to:
  /// **'Gesperrt'**
  String get appLockLocked;

  /// No description provided for @appLockUnlock.
  ///
  /// In de, this message translates to:
  /// **'Entsperren'**
  String get appLockUnlock;

  /// No description provided for @mainCbtSomaticCoaching.
  ///
  /// In de, this message translates to:
  /// **'KVT & SOMATIK COACHING'**
  String get mainCbtSomaticCoaching;

  /// No description provided for @coursesCourseCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Kurs} other{{count} Kurse}}'**
  String coursesCourseCount(int count);

  /// No description provided for @coursesStreakDays.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Tag in Folge aktiv} other{{count} Tage in Folge aktiv}}'**
  String coursesStreakDays(int count);

  /// No description provided for @coursesPracticeSelfExploration.
  ///
  /// In de, this message translates to:
  /// **'Praxis: Selbsterkundung'**
  String get coursesPracticeSelfExploration;

  /// No description provided for @coursesPracticeDesireProfile.
  ///
  /// In de, this message translates to:
  /// **'Praxis: Lust-Profil'**
  String get coursesPracticeDesireProfile;

  /// No description provided for @couplesChannelIWantYou.
  ///
  /// In de, this message translates to:
  /// **'Lust auf dich'**
  String get couplesChannelIWantYou;

  /// No description provided for @couplesChannelJustCuddlesToday.
  ///
  /// In de, this message translates to:
  /// **'Heute nur kuscheln'**
  String get couplesChannelJustCuddlesToday;

  /// No description provided for @couplesChannelLookingForwardToLater.
  ///
  /// In de, this message translates to:
  /// **'Freu mich auf später'**
  String get couplesChannelLookingForwardToLater;

  /// No description provided for @couplesChannelVerySlowlyToday.
  ///
  /// In de, this message translates to:
  /// **'Heute ganz langsam'**
  String get couplesChannelVerySlowlyToday;

  /// No description provided for @couplesChannelLetSTalk.
  ///
  /// In de, this message translates to:
  /// **'Lass uns reden'**
  String get couplesChannelLetSTalk;

  /// No description provided for @couplesChannelNotToday.
  ///
  /// In de, this message translates to:
  /// **'Heute lieber nicht'**
  String get couplesChannelNotToday;

  /// No description provided for @couplesChannelReconnect.
  ///
  /// In de, this message translates to:
  /// **'Neu verbinden'**
  String get couplesChannelReconnect;

  /// No description provided for @couplesChannelConnectWithYourPartnerAnd.
  ///
  /// In de, this message translates to:
  /// **'Verbinde dich mit deinem Gegenüber und teilt Wünsche, die sonst schwer auszusprechen sind.'**
  String get couplesChannelConnectWithYourPartnerAnd;

  /// No description provided for @couplesChannelSendSparks.
  ///
  /// In de, this message translates to:
  /// **'Funken senden'**
  String get couplesChannelSendSparks;

  /// No description provided for @couplesChannelShowWithOneTapWhat.
  ///
  /// In de, this message translates to:
  /// **'Mit einem Tippen zeigen, worauf du heute Lust hast – oder eben nicht.'**
  String get couplesChannelShowWithOneTapWhat;

  /// No description provided for @couplesChannelSecretlyMatchWishes.
  ///
  /// In de, this message translates to:
  /// **'Wünsche heimlich abgleichen'**
  String get couplesChannelSecretlyMatchWishes;

  /// No description provided for @couplesChannelYouVoteSeparatelyOnlyWhat.
  ///
  /// In de, this message translates to:
  /// **'Ihr stimmt getrennt ab. Sichtbar wird nur, was ihr beide wollt.'**
  String get couplesChannelYouVoteSeparatelyOnlyWhat;

  /// No description provided for @couplesChannelJustForTheTwoOf.
  ///
  /// In de, this message translates to:
  /// **'Nur für euch beide'**
  String get couplesChannelJustForTheTwoOf;

  /// No description provided for @couplesChannelEndToEndEncryptedNo.
  ///
  /// In de, this message translates to:
  /// **'Ende-zu-Ende-verschlüsselt, ohne Konto und ohne Telefonnummer.'**
  String get couplesChannelEndToEndEncryptedNo;

  /// No description provided for @couplesChannelConnectWithPartner.
  ///
  /// In de, this message translates to:
  /// **'Mit Partner verbinden'**
  String get couplesChannelConnectWithPartner;

  /// No description provided for @couplesChannelInvitePartner.
  ///
  /// In de, this message translates to:
  /// **'Partner einladen'**
  String get couplesChannelInvitePartner;

  /// No description provided for @couplesChannelHowDoesItWork.
  ///
  /// In de, this message translates to:
  /// **'Wie funktioniert das?'**
  String get couplesChannelHowDoesItWork;

  /// No description provided for @couplesChannelYouCanAlsoFillIt.
  ///
  /// In de, this message translates to:
  /// **'Kannst du auch allein ausfüllen – und später mit deinem Gegenüber abgleichen.'**
  String get couplesChannelYouCanAlsoFillIt;

  /// No description provided for @couplesChannelSharedEvening.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsamer Abend'**
  String get couplesChannelSharedEvening;

  /// No description provided for @couplesChannelGuidedTouchForTheTwo.
  ///
  /// In de, this message translates to:
  /// **'Geführte Berührung für euch beide, 20 bis 45 Minuten. Jedes Mal anders.'**
  String get couplesChannelGuidedTouchForTheTwo;

  /// No description provided for @couplesChannelFantasyMap.
  ///
  /// In de, this message translates to:
  /// **'Fantasie-Landkarte'**
  String get couplesChannelFantasyMap;

  /// No description provided for @couplesChannelMessages.
  ///
  /// In de, this message translates to:
  /// **'Nachrichten'**
  String get couplesChannelMessages;

  /// No description provided for @couplesChannelWishes.
  ///
  /// In de, this message translates to:
  /// **'Wünsche'**
  String get couplesChannelWishes;

  /// No description provided for @couplesChannelConnectedEncrypted.
  ///
  /// In de, this message translates to:
  /// **'verbunden & verschlüsselt'**
  String get couplesChannelConnectedEncrypted;

  /// No description provided for @couplesChannelConnecting.
  ///
  /// In de, this message translates to:
  /// **'verbindet …'**
  String get couplesChannelConnecting;

  /// No description provided for @couplesChannelOfflineTapToConnect.
  ///
  /// In de, this message translates to:
  /// **'offline – tippe zum Verbinden'**
  String get couplesChannelOfflineTapToConnect;

  /// No description provided for @couplesChannelYouName.
  ///
  /// In de, this message translates to:
  /// **'Du & {name}'**
  String couplesChannelYouName(Object name);

  /// No description provided for @couplesChannelPartnerSNameGender.
  ///
  /// In de, this message translates to:
  /// **'Name & Geschlecht des Gegenübers'**
  String get couplesChannelPartnerSNameGender;

  /// No description provided for @couplesChannelReadReceipts.
  ///
  /// In de, this message translates to:
  /// **'Lesebestätigungen'**
  String get couplesChannelReadReceipts;

  /// No description provided for @couplesChannelEncryptionDetails.
  ///
  /// In de, this message translates to:
  /// **'Verschlüsselung & Details'**
  String get couplesChannelEncryptionDetails;

  /// No description provided for @couplesChannelManageConnection.
  ///
  /// In de, this message translates to:
  /// **'Verbindung verwalten'**
  String get couplesChannelManageConnection;

  /// No description provided for @couplesChannelDisconnect.
  ///
  /// In de, this message translates to:
  /// **'Verbindung trennen'**
  String get couplesChannelDisconnect;

  /// No description provided for @couplesChannelItSStillQuietHere.
  ///
  /// In de, this message translates to:
  /// **'Noch ist es still hier'**
  String get couplesChannelItSStillQuietHere;

  /// No description provided for @couplesChannelSendASparkFromThe.
  ///
  /// In de, this message translates to:
  /// **'Schick einen Funken aus der Leiste unten oder schreib ein paar Worte.'**
  String get couplesChannelSendASparkFromThe;

  /// No description provided for @couplesChannelRead.
  ///
  /// In de, this message translates to:
  /// **' · Gelesen'**
  String get couplesChannelRead;

  /// No description provided for @couplesChannelSent.
  ///
  /// In de, this message translates to:
  /// **' · Gesendet'**
  String get couplesChannelSent;

  /// No description provided for @couplesChannelOpenLesson.
  ///
  /// In de, this message translates to:
  /// **'Lektion öffnen'**
  String get couplesChannelOpenLesson;

  /// No description provided for @couplesChannelWriteAMessage.
  ///
  /// In de, this message translates to:
  /// **'Nachricht schreiben …'**
  String get couplesChannelWriteAMessage;

  /// No description provided for @couplesChannelSend.
  ///
  /// In de, this message translates to:
  /// **'Senden'**
  String get couplesChannelSend;

  /// No description provided for @couplesChannelVoteSeparatelyAWishOnly.
  ///
  /// In de, this message translates to:
  /// **'Stimmt getrennt ab. Ein Wunsch erscheint erst als Match, wenn ihr beide „Ja, gern“ sagt – ein „Lieber nicht“ wird nie angezeigt.'**
  String get couplesChannelVoteSeparatelyAWishOnly;

  /// No description provided for @couplesChannelQuestionsInSeveralAreasWith.
  ///
  /// In de, this message translates to:
  /// **'{fragen} Fragen in {bereiche} Bereichen – mit passenden Kurs-Empfehlungen.'**
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche);

  /// No description provided for @couplesChannelYouHaveAMatch.
  ///
  /// In de, this message translates to:
  /// **'Ihr habt ein Match'**
  String get couplesChannelYouHaveAMatch;

  /// No description provided for @couplesChannelYouHaveMatcheslengthMatches.
  ///
  /// In de, this message translates to:
  /// **'Ihr habt {matchesLength} Matches'**
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength);

  /// No description provided for @couplesChannelAMatchIsAnInvitation.
  ///
  /// In de, this message translates to:
  /// **'Ein Match ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt.'**
  String get couplesChannelAMatchIsAnInvitation;

  /// No description provided for @couplesChannelYesPlease.
  ///
  /// In de, this message translates to:
  /// **'Ja, gern'**
  String get couplesChannelYesPlease;

  /// No description provided for @couplesChannelRatherNot.
  ///
  /// In de, this message translates to:
  /// **'Lieber nicht'**
  String get couplesChannelRatherNot;

  /// No description provided for @couplesChannelDisconnect2.
  ///
  /// In de, this message translates to:
  /// **'Verbindung trennen?'**
  String get couplesChannelDisconnect2;

  /// No description provided for @couplesChannelTheHistoryWithNameName.
  ///
  /// In de, this message translates to:
  /// **'Der Verlauf mit {name}, die Antworten von {name2} auf die Ja/Nein-Liste und die geteilten Reflexionen werden auf diesem Handy gelöscht. Deine eigenen Antworten bleiben erhalten.\n\nAuf dem Handy von {name3} ändert sich nichts.'**
  String couplesChannelTheHistoryWithNameName(
      Object name, Object name2, Object name3);

  /// No description provided for @couplesChannelDisconnect3.
  ///
  /// In de, this message translates to:
  /// **'Trennen'**
  String get couplesChannelDisconnect3;

  /// No description provided for @couplesChannelDisconnected.
  ///
  /// In de, this message translates to:
  /// **'Verbindung getrennt.'**
  String get couplesChannelDisconnected;

  /// No description provided for @couplesChannelHowItStaysPrivate.
  ///
  /// In de, this message translates to:
  /// **'So bleibt es privat'**
  String get couplesChannelHowItStaysPrivate;

  /// No description provided for @couplesChannelMessagesAreEncryptedOnYour.
  ///
  /// In de, this message translates to:
  /// **'Nachrichten werden auf deinem Handy verschlüsselt und erst auf dem Handy deines Gegenübers wieder lesbar. Dazwischen laufen sie über öffentliche Nostr-Server. Die können den Inhalt nicht lesen. Sichtbar sind für sie aber die Schlüssel von Absender und Empfänger, Zeitpunkt und ungefähre Größe jeder Nachricht sowie deine IP-Adresse – also dass, wann und wie oft ihr schreibt. Die Schlüssel tragen keinen Namen. Es gibt kein Konto, keine Telefonnummer und keinen Server von uns.'**
  String get couplesChannelMessagesAreEncryptedOnYour;

  /// No description provided for @couplesChannelEncryption.
  ///
  /// In de, this message translates to:
  /// **'Verschlüsselung'**
  String get couplesChannelEncryption;

  /// No description provided for @couplesChannelServers.
  ///
  /// In de, this message translates to:
  /// **'Server'**
  String get couplesChannelServers;

  /// No description provided for @couplesChannelYourConnectionCode.
  ///
  /// In de, this message translates to:
  /// **'Dein Verbindungscode'**
  String get couplesChannelYourConnectionCode;

  /// No description provided for @couplesChannelClose.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get couplesChannelClose;

  /// No description provided for @paarAbendYou.
  ///
  /// In de, this message translates to:
  /// **'Du'**
  String get paarAbendYou;

  /// No description provided for @paarAbendYourPartner.
  ///
  /// In de, this message translates to:
  /// **'dein Gegenüber'**
  String get paarAbendYourPartner;

  /// No description provided for @paarAbendEndTheEvening.
  ///
  /// In de, this message translates to:
  /// **'Abend beenden?'**
  String get paarAbendEndTheEvening;

  /// No description provided for @paarAbendTheGuidanceStopsThenYou.
  ///
  /// In de, this message translates to:
  /// **'Die Begleitung hört dann auf. Ihr könnt jederzeit neu beginnen.'**
  String get paarAbendTheGuidanceStopsThenYou;

  /// No description provided for @paarAbendContinue.
  ///
  /// In de, this message translates to:
  /// **'Weitermachen'**
  String get paarAbendContinue;

  /// No description provided for @paarAbendPutThePhoneNextTo.
  ///
  /// In de, this message translates to:
  /// **'Legt das Handy neben euch. Eine Stimme führt euch durch Ankommen, zwei Runden Berührung mit Rollenwechsel und einen ruhigen Ausklang. Die meiste Zeit ist Stille, damit ihr ganz bei euch seid. Jeder Abend wird neu zusammengestellt.'**
  String get paarAbendPutThePhoneNextTo;

  /// No description provided for @paarAbendDuration.
  ///
  /// In de, this message translates to:
  /// **'Dauer'**
  String get paarAbendDuration;

  /// No description provided for @paarAbendMMin.
  ///
  /// In de, this message translates to:
  /// **'{m} Min.'**
  String paarAbendMMin(Object m);

  /// No description provided for @paarAbendHowFarMayItGo.
  ///
  /// In de, this message translates to:
  /// **'Wie weit darf es gehen?'**
  String get paarAbendHowFarMayItGo;

  /// No description provided for @paarAbendClothed.
  ///
  /// In de, this message translates to:
  /// **'Bekleidet'**
  String get paarAbendClothed;

  /// No description provided for @paarAbendBackShouldersHandsHeadLegs.
  ///
  /// In de, this message translates to:
  /// **'Rücken, Schultern, Hände, Kopf, Beine und Füße.'**
  String get paarAbendBackShouldersHandsHeadLegs;

  /// No description provided for @paarAbendSkinToSkin.
  ///
  /// In de, this message translates to:
  /// **'Haut an Haut'**
  String get paarAbendSkinToSkin;

  /// No description provided for @paarAbendPlusMassageWithOilBelly.
  ///
  /// In de, this message translates to:
  /// **'Dazu Massage mit Öl, Bauch, Hüften und Po.'**
  String get paarAbendPlusMassageWithOilBelly;

  /// No description provided for @paarAbendIntimate.
  ///
  /// In de, this message translates to:
  /// **'Intim'**
  String get paarAbendIntimate;

  /// No description provided for @paarAbendPlusChestInnerThighsAnd.
  ///
  /// In de, this message translates to:
  /// **'Dazu Brust, Innenschenkel und Geschlecht, ganz ohne Ziel.'**
  String get paarAbendPlusChestInnerThighsAnd;

  /// No description provided for @paarAbendWhoGivesFirst.
  ///
  /// In de, this message translates to:
  /// **'Wer gibt zuerst?'**
  String get paarAbendWhoGivesFirst;

  /// No description provided for @paarAbendMe.
  ///
  /// In de, this message translates to:
  /// **'Ich'**
  String get paarAbendMe;

  /// No description provided for @paarAbendMyPartner.
  ///
  /// In de, this message translates to:
  /// **'Mein Gegenüber'**
  String get paarAbendMyPartner;

  /// No description provided for @paarAbendVoice.
  ///
  /// In de, this message translates to:
  /// **'Stimme'**
  String get paarAbendVoice;

  /// No description provided for @paarAbendSoftSoundBed.
  ///
  /// In de, this message translates to:
  /// **'Leiser Klangteppich'**
  String get paarAbendSoftSoundBed;

  /// No description provided for @paarAbendCalmBackgroundDuringTheSilences.
  ///
  /// In de, this message translates to:
  /// **'Ruhiger Hintergrund in den Stillen'**
  String get paarAbendCalmBackgroundDuringTheSilences;

  /// No description provided for @paarAbendAgreeOnAStopWord.
  ///
  /// In de, this message translates to:
  /// **'Vereinbart vorher ein Stoppwort. Die Stimme lädt ein, sie bestimmt nichts: Was sich nicht gut anfühlt, lasst ihr einfach aus.'**
  String get paarAbendAgreeOnAStopWord;

  /// No description provided for @paarAbendBeginTheEvening.
  ///
  /// In de, this message translates to:
  /// **'Abend beginnen'**
  String get paarAbendBeginTheEvening;

  /// No description provided for @paarAbendThankYouForYourEvening.
  ///
  /// In de, this message translates to:
  /// **'Danke für euren Abend'**
  String get paarAbendThankYouForYourEvening;

  /// No description provided for @paarAbendStayLyingDownAsLong.
  ///
  /// In de, this message translates to:
  /// **'Bleibt liegen, solange es sich gut anfühlt.'**
  String get paarAbendStayLyingDownAsLong;

  /// No description provided for @paarAbendRoundRunde.
  ///
  /// In de, this message translates to:
  /// **'Runde {runde}'**
  String paarAbendRoundRunde(Object runde);

  /// No description provided for @paarAbendYouGivePartnernameReceives.
  ///
  /// In de, this message translates to:
  /// **'Du gibst · {partnerName} empfängt'**
  String paarAbendYouGivePartnernameReceives(Object partnerName);

  /// No description provided for @paarAbendPartnernamePartnernameGivesYouReceive.
  ///
  /// In de, this message translates to:
  /// **'{partnerName}{partnerName2} gibt · du empfängst'**
  String paarAbendPartnernamePartnernameGivesYouReceive(
      Object partnerName, Object partnerName2);

  /// No description provided for @paarAbendArriving.
  ///
  /// In de, this message translates to:
  /// **'Ankommen'**
  String get paarAbendArriving;

  /// No description provided for @paarAbendEnding.
  ///
  /// In de, this message translates to:
  /// **'Ausklang'**
  String get paarAbendEnding;

  /// No description provided for @paarAbendChangeOfRoles.
  ///
  /// In de, this message translates to:
  /// **'Rollenwechsel'**
  String get paarAbendChangeOfRoles;

  /// No description provided for @paarAbendBreatheTogether.
  ///
  /// In de, this message translates to:
  /// **'Atmet gemeinsam.'**
  String get paarAbendBreatheTogether;

  /// No description provided for @paarAbendPaused.
  ///
  /// In de, this message translates to:
  /// **'Pausiert'**
  String get paarAbendPaused;

  /// No description provided for @paarAbendTheVoiceIsSpeaking.
  ///
  /// In de, this message translates to:
  /// **'Die Stimme spricht …'**
  String get paarAbendTheVoiceIsSpeaking;

  /// No description provided for @paarAbendSilenceStillerestLeft.
  ///
  /// In de, this message translates to:
  /// **'Stille · noch {stilleRest}'**
  String paarAbendSilenceStillerestLeft(Object stilleRest);

  /// No description provided for @invitePartnerIDLikeToTry.
  ///
  /// In de, this message translates to:
  /// **'\nIch möchte VelvetPulse mit dir ausprobieren 💛 Eine private App nur für uns zwei.\n\n1. App laden (Android):\n{stableApkUrl}\nWenn Android fragt, die Installation erlauben.\n\n2. Meinen Verbindungscode schicke ich dir gleich als eigene Nachricht. Kopiere ihn und füge ihn in der App ein: Paar-Kanal › Mit Partner verbinden › Partner scannen › Code einfügen › „Verbinden & Koppeln“.\n\n3. Schick mir danach einen Funken, dann sind wir verbunden.\n\nAusführliche Anleitung: {testerGuideUrl}'**
  String invitePartnerIDLikeToTry(Object stableApkUrl, Object testerGuideUrl);

  /// No description provided for @invitePartnerYouSendALinkTo.
  ///
  /// In de, this message translates to:
  /// **'Du schickst einen Link zur App und deinen Verbindungscode, z. B. per Messenger. Sobald sich dein Gegenüber meldet, bestätigst du hier die Verbindung.'**
  String get invitePartnerYouSendALinkTo;

  /// No description provided for @invitePartnerNameEGAnna.
  ///
  /// In de, this message translates to:
  /// **'Name, z. B. Anna'**
  String get invitePartnerNameEGAnna;

  /// No description provided for @invitePartnerShareInvitation.
  ///
  /// In de, this message translates to:
  /// **'Einladung teilen'**
  String get invitePartnerShareInvitation;

  /// No description provided for @invitePartnerInvitationToVelvetpulse.
  ///
  /// In de, this message translates to:
  /// **'Einladung zu VelvetPulse'**
  String get invitePartnerInvitationToVelvetpulse;

  /// No description provided for @invitePartnerNowYourCode.
  ///
  /// In de, this message translates to:
  /// **'Jetzt noch deinen Code'**
  String get invitePartnerNowYourCode;

  /// No description provided for @invitePartnerSendYourConnectionCodeAfterwards.
  ///
  /// In de, this message translates to:
  /// **'Schick deinen Verbindungscode als eigene Nachricht hinterher, am besten an dieselbe Person. So lässt er sich mit einem Tippen kopieren.'**
  String get invitePartnerSendYourConnectionCodeAfterwards;

  /// No description provided for @invitePartnerShareCode.
  ///
  /// In de, this message translates to:
  /// **'Code teilen'**
  String get invitePartnerShareCode;

  /// No description provided for @invitePartnerMyVelvetpulseCode.
  ///
  /// In de, this message translates to:
  /// **'Mein VelvetPulse-Code'**
  String get invitePartnerMyVelvetpulseCode;

  /// No description provided for @invitePartnerCopiedPasteTheTextInto.
  ///
  /// In de, this message translates to:
  /// **'Kopiert. Füge den Text in einen Messenger ein.'**
  String get invitePartnerCopiedPasteTheTextInto;

  /// No description provided for @invitePartnerNameWantsToConnect.
  ///
  /// In de, this message translates to:
  /// **'{name} möchte sich verbinden'**
  String invitePartnerNameWantsToConnect(Object name);

  /// No description provided for @invitePartnerInvitationSentToName.
  ///
  /// In de, this message translates to:
  /// **'Einladung an {name} verschickt'**
  String invitePartnerInvitationSentToName(Object name);

  /// No description provided for @invitePartnerAMessageJustArrivedAt.
  ///
  /// In de, this message translates to:
  /// **'Gerade kam eine Nachricht an deinen Code. Wenn sie von {name} ist, nimm die Verbindung an.'**
  String invitePartnerAMessageJustArrivedAt(Object name);

  /// No description provided for @invitePartnerAsSoonAsNameInstalls.
  ///
  /// In de, this message translates to:
  /// **'Sobald {name} die App installiert, deinen Code eingibt und dir einen Funken schickt, kannst du die Verbindung hier bestätigen.'**
  String invitePartnerAsSoonAsNameInstalls(Object name);

  /// No description provided for @invitePartnerDecline.
  ///
  /// In de, this message translates to:
  /// **'Ablehnen'**
  String get invitePartnerDecline;

  /// No description provided for @invitePartnerConnectedWithName.
  ///
  /// In de, this message translates to:
  /// **'Verbunden mit {name} 💛'**
  String invitePartnerConnectedWithName(Object name);

  /// No description provided for @invitePartnerAccept.
  ///
  /// In de, this message translates to:
  /// **'Annehmen'**
  String get invitePartnerAccept;

  /// No description provided for @invitePartnerWithdraw.
  ///
  /// In de, this message translates to:
  /// **'Zurückziehen'**
  String get invitePartnerWithdraw;

  /// No description provided for @invitePartnerShareAgain.
  ///
  /// In de, this message translates to:
  /// **'Erneut teilen'**
  String get invitePartnerShareAgain;

  /// No description provided for @pairingModalConnectWithSomeoneElse.
  ///
  /// In de, this message translates to:
  /// **'Mit jemand anderem verbinden?'**
  String get pairingModalConnectWithSomeoneElse;

  /// No description provided for @pairingModalYouReCurrentlyConnectedWith.
  ///
  /// In de, this message translates to:
  /// **'Du bist gerade mit {old} verbunden. Diese Verbindung wird ersetzt, und der Verlauf mit {old2}, die Antworten von {old3} und die geteilten Reflexionen werden auf diesem Handy gelöscht.'**
  String pairingModalYouReCurrentlyConnectedWith(
      Object old, Object old2, Object old3);

  /// No description provided for @pairingModalReplace.
  ///
  /// In de, this message translates to:
  /// **'Ersetzen'**
  String get pairingModalReplace;

  /// No description provided for @pairingModalHiIMConnectedNow.
  ///
  /// In de, this message translates to:
  /// **'👋 Hallo, ich bin jetzt verbunden.'**
  String get pairingModalHiIMConnectedNow;

  /// No description provided for @pairingModalConnectedWithName.
  ///
  /// In de, this message translates to:
  /// **'Verbunden mit {name} 💛'**
  String pairingModalConnectedWithName(Object name);

  /// No description provided for @pairingModalThisCodeDoesnTFit.
  ///
  /// In de, this message translates to:
  /// **'Dieser Code passt nicht. Scanne den QR-Code deines Gegenübers oder füge den vollständigen Code (beginnt mit npub1…) ein.'**
  String get pairingModalThisCodeDoesnTFit;

  /// No description provided for @pairingModalMyCode.
  ///
  /// In de, this message translates to:
  /// **'Mein Code'**
  String get pairingModalMyCode;

  /// No description provided for @pairingModalScanPartner.
  ///
  /// In de, this message translates to:
  /// **'Partner scannen'**
  String get pairingModalScanPartner;

  /// No description provided for @pairingModalLetYourPartnerScanThis.
  ///
  /// In de, this message translates to:
  /// **'Lass diesen Code von deinem Partner scannen, um euren privaten Kanal zu öffnen.'**
  String get pairingModalLetYourPartnerScanThis;

  /// No description provided for @pairingModalCopyCode.
  ///
  /// In de, this message translates to:
  /// **'Code kopieren'**
  String get pairingModalCopyCode;

  /// No description provided for @pairingModalYourConnectionCodeHasBeen.
  ///
  /// In de, this message translates to:
  /// **'Dein Verbindungscode wurde kopiert.'**
  String get pairingModalYourConnectionCodeHasBeen;

  /// No description provided for @pairingModalEndToEndEncryptedNo.
  ///
  /// In de, this message translates to:
  /// **'Ende-zu-Ende-verschlüsselt • ohne Konto'**
  String get pairingModalEndToEndEncryptedNo;

  /// No description provided for @pairingModalHoldYourPartnerSQr.
  ///
  /// In de, this message translates to:
  /// **'Partner-QR-Code im Rahmen halten'**
  String get pairingModalHoldYourPartnerSQr;

  /// No description provided for @pairingModalPartnerSNameEG.
  ///
  /// In de, this message translates to:
  /// **'Partner-Name (z.B. Mein Schatz, Anna)'**
  String get pairingModalPartnerSNameEG;

  /// No description provided for @pairingModalOrPasteNpubHexKey.
  ///
  /// In de, this message translates to:
  /// **'Oder npub1... / Hex-Schlüssel einfügen'**
  String get pairingModalOrPasteNpubHexKey;

  /// No description provided for @pairingModalPasteFromClipboard.
  ///
  /// In de, this message translates to:
  /// **'Aus Zwischenablage einfügen'**
  String get pairingModalPasteFromClipboard;

  /// No description provided for @pairingModalConnectPair.
  ///
  /// In de, this message translates to:
  /// **'Verbinden & Koppeln'**
  String get pairingModalConnectPair;

  /// No description provided for @partnerProfileDialogWoman.
  ///
  /// In de, this message translates to:
  /// **'Frau'**
  String get partnerProfileDialogWoman;

  /// No description provided for @partnerProfileDialogMan.
  ///
  /// In de, this message translates to:
  /// **'Mann'**
  String get partnerProfileDialogMan;

  /// No description provided for @partnerProfileDialogNonBinary.
  ///
  /// In de, this message translates to:
  /// **'Divers'**
  String get partnerProfileDialogNonBinary;

  /// No description provided for @partnerProfileDialogNotSpecified.
  ///
  /// In de, this message translates to:
  /// **'Keine Angabe'**
  String get partnerProfileDialogNotSpecified;

  /// No description provided for @partnerProfileDialogYourPartner.
  ///
  /// In de, this message translates to:
  /// **'Dein Gegenüber'**
  String get partnerProfileDialogYourPartner;

  /// No description provided for @partnerProfileDialogThisLetsLessonsCallYour.
  ///
  /// In de, this message translates to:
  /// **'Damit können Lektionen dein Gegenüber beim Namen nennen, etwa „Anna liegt auf dem Rücken“ statt „sie liegt“. Beides bleibt nur auf deinem Handy.'**
  String get partnerProfileDialogThisLetsLessonsCallYour;

  /// No description provided for @partnerProfileDialogSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get partnerProfileDialogSave;

  /// No description provided for @partnerProfileDialogHowMayLessonsReferTo.
  ///
  /// In de, this message translates to:
  /// **'Wie dürfen Lektionen dein Gegenüber nennen?'**
  String get partnerProfileDialogHowMayLessonsReferTo;

  /// No description provided for @partnerProfileDialogWithNameAndGenderThe.
  ///
  /// In de, this message translates to:
  /// **'Mit Name und Geschlecht sprechen die Texte euch persönlich an. Das bleibt auf deinem Handy.'**
  String get partnerProfileDialogWithNameAndGenderThe;

  /// No description provided for @partnerProfileDialogAdd.
  ///
  /// In de, this message translates to:
  /// **'Ergänzen'**
  String get partnerProfileDialogAdd;

  /// No description provided for @distortionSpectatoring.
  ///
  /// In de, this message translates to:
  /// **'Spectatoring / Selbstbeobachtung'**
  String get distortionSpectatoring;

  /// No description provided for @distortionCatastrophizing.
  ///
  /// In de, this message translates to:
  /// **'Katastrophisieren'**
  String get distortionCatastrophizing;

  /// No description provided for @distortionAllOrNothing.
  ///
  /// In de, this message translates to:
  /// **'Alles-oder-Nichts-Denken'**
  String get distortionAllOrNothing;

  /// No description provided for @distortionMindReading.
  ///
  /// In de, this message translates to:
  /// **'Gedankenlesen'**
  String get distortionMindReading;

  /// No description provided for @distortionPerformancePressure.
  ///
  /// In de, this message translates to:
  /// **'Leistungsdruck'**
  String get distortionPerformancePressure;

  /// No description provided for @distortionTunnelVision.
  ///
  /// In de, this message translates to:
  /// **'Tunnelblick auf Körpersignale'**
  String get distortionTunnelVision;

  /// No description provided for @cbtJournalProtocolsSaved.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Gedankenprotokoll lokal gesichert} other{{count} Gedankenprotokolle lokal gesichert}}'**
  String cbtJournalProtocolsSaved(int count);

  /// No description provided for @selbstReiseEndTheJourney.
  ///
  /// In de, this message translates to:
  /// **'Reise beenden?'**
  String get selbstReiseEndTheJourney;

  /// No description provided for @selbstReiseTheGuidanceStopsThenYou.
  ///
  /// In de, this message translates to:
  /// **'Die Begleitung hört dann auf. Du kannst jederzeit neu beginnen.'**
  String get selbstReiseTheGuidanceStopsThenYou;

  /// No description provided for @selbstReiseAVoiceGuidesYouThrough.
  ///
  /// In de, this message translates to:
  /// **'Eine Stimme begleitet dich durch Ankommen, Atem und eine Reise über deinen Körper. Die meiste Zeit ist Stille, damit du ganz bei dir bist. Jede Reise wird neu zusammengestellt, und es gibt kein Ziel.'**
  String get selbstReiseAVoiceGuidesYouThrough;

  /// No description provided for @selbstReiseYouDecideYouCanPause.
  ///
  /// In de, this message translates to:
  /// **'Du bestimmst. Pausieren, einen Schritt überspringen oder aufhören geht jederzeit über die Knöpfe unten. Es muss nichts passieren: Bei einer angenehmen, nicht sexuellen Berührung zu bleiben ist genauso richtig. Wird etwas unangenehm oder kommen schwierige Erinnerungen hoch, darfst du jederzeit aufhören.'**
  String get selbstReiseYouDecideYouCanPause;

  /// No description provided for @selbstReiseMMin.
  ///
  /// In de, this message translates to:
  /// **'{m} Min.'**
  String selbstReiseMMin(Object m);

  /// No description provided for @selbstReiseHowCloseWouldYouLike.
  ///
  /// In de, this message translates to:
  /// **'Wie nah möchtest du dir heute kommen?'**
  String get selbstReiseHowCloseWouldYouLike;

  /// No description provided for @selbstReiseGentle.
  ///
  /// In de, this message translates to:
  /// **'Sanft'**
  String get selbstReiseGentle;

  /// No description provided for @selbstReiseFaceScalpEarsNeckArms.
  ///
  /// In de, this message translates to:
  /// **'Gesicht, Kopfhaut, Ohren, Hals, Arme, Hände, Brust, Bauch, Beine und Füße, gern bekleidet.'**
  String get selbstReiseFaceScalpEarsNeckArms;

  /// No description provided for @selbstReiseSkin.
  ///
  /// In de, this message translates to:
  /// **'Haut'**
  String get selbstReiseSkin;

  /// No description provided for @selbstReisePlusBareSkinWithOil.
  ///
  /// In de, this message translates to:
  /// **'Dazu nackte Haut mit Öl, Hüften und Innenschenkel.'**
  String get selbstReisePlusBareSkinWithOil;

  /// No description provided for @selbstReisePlusPerineumAndGenitalsWith.
  ///
  /// In de, this message translates to:
  /// **'Dazu Damm und Geschlecht, mit Wellen statt Ziel.'**
  String get selbstReisePlusPerineumAndGenitalsWith;

  /// No description provided for @selbstReiseYourBody.
  ///
  /// In de, this message translates to:
  /// **'Dein Körper'**
  String get selbstReiseYourBody;

  /// No description provided for @selbstReiseVulva.
  ///
  /// In de, this message translates to:
  /// **'Vulva'**
  String get selbstReiseVulva;

  /// No description provided for @selbstReisePenis.
  ///
  /// In de, this message translates to:
  /// **'Penis'**
  String get selbstReisePenis;

  /// No description provided for @selbstReiseBeginTheJourney.
  ///
  /// In de, this message translates to:
  /// **'Reise beginnen'**
  String get selbstReiseBeginTheJourney;

  /// No description provided for @selbstReiseThankYou.
  ///
  /// In de, this message translates to:
  /// **'Danke dir'**
  String get selbstReiseThankYou;

  /// No description provided for @selbstReiseBodyJourney.
  ///
  /// In de, this message translates to:
  /// **'Körperreise'**
  String get selbstReiseBodyJourney;

  /// No description provided for @selbstReiseSilenceStillerestLeft.
  ///
  /// In de, this message translates to:
  /// **'Stille · noch {stilleRest}'**
  String selbstReiseSilenceStillerestLeft(Object stilleRest);

  /// No description provided for @selbstReiseStayLyingDownAsLong.
  ///
  /// In de, this message translates to:
  /// **'Bleib liegen, solange es sich gut anfühlt.'**
  String get selbstReiseStayLyingDownAsLong;

  /// No description provided for @lustProfileCircling.
  ///
  /// In de, this message translates to:
  /// **'Kreisen'**
  String get lustProfileCircling;

  /// No description provided for @lustProfileUpAndDown.
  ///
  /// In de, this message translates to:
  /// **'Auf und ab'**
  String get lustProfileUpAndDown;

  /// No description provided for @lustProfileSideToSide.
  ///
  /// In de, this message translates to:
  /// **'Seitwärts'**
  String get lustProfileSideToSide;

  /// No description provided for @lustProfilePressAndHold.
  ///
  /// In de, this message translates to:
  /// **'Drücken und halten'**
  String get lustProfilePressAndHold;

  /// No description provided for @lustProfileFramingTwoFingersLeftAnd.
  ///
  /// In de, this message translates to:
  /// **'Rahmen – zwei Finger links und rechts'**
  String get lustProfileFramingTwoFingersLeftAnd;

  /// No description provided for @lustProfileLightTapping.
  ///
  /// In de, this message translates to:
  /// **'Leichtes Klopfen'**
  String get lustProfileLightTapping;

  /// No description provided for @lustProfileInsideAndOutsideAtOnce.
  ///
  /// In de, this message translates to:
  /// **'Innen und außen zugleich'**
  String get lustProfileInsideAndOutsideAtOnce;

  /// No description provided for @lustProfileOpenOiledHand.
  ///
  /// In de, this message translates to:
  /// **'Offene, eingeölte Hand'**
  String get lustProfileOpenOiledHand;

  /// No description provided for @lustProfileTwoHandedGliding.
  ///
  /// In de, this message translates to:
  /// **'Zweihand-Gleiten'**
  String get lustProfileTwoHandedGliding;

  /// No description provided for @lustProfileTwisting.
  ///
  /// In de, this message translates to:
  /// **'Drehen'**
  String get lustProfileTwisting;

  /// No description provided for @lustProfileRingAtTheBase.
  ///
  /// In de, this message translates to:
  /// **'Ring an der Wurzel'**
  String get lustProfileRingAtTheBase;

  /// No description provided for @lustProfileCirclingTheFrenulum.
  ///
  /// In de, this message translates to:
  /// **'Das Bändchen umkreisen'**
  String get lustProfileCirclingTheFrenulum;

  /// No description provided for @lustProfileIncludingTesticlesAndPerineum.
  ///
  /// In de, this message translates to:
  /// **'Hoden und Damm einbeziehen'**
  String get lustProfileIncludingTesticlesAndPerineum;

  /// No description provided for @lustProfileWavesPausingJustBeforeClimax.
  ///
  /// In de, this message translates to:
  /// **'Wellen – kurz vor dem Höhepunkt innehalten'**
  String get lustProfileWavesPausingJustBeforeClimax;

  /// No description provided for @lustProfileStartSlowlyAroundRatherThan.
  ///
  /// In de, this message translates to:
  /// **'Langsam beginnen, rundherum statt direkt'**
  String get lustProfileStartSlowlyAroundRatherThan;

  /// No description provided for @lustProfileWhenItSGoodKeep.
  ///
  /// In de, this message translates to:
  /// **'Wenn es gut ist: genau so weitermachen'**
  String get lustProfileWhenItSGoodKeep;

  /// No description provided for @lustProfileWithPlentyOfLubricant.
  ///
  /// In de, this message translates to:
  /// **'Mit viel Gleitmittel'**
  String get lustProfileWithPlentyOfLubricant;

  /// No description provided for @lustProfileLotsOfTimeNoGoal.
  ///
  /// In de, this message translates to:
  /// **'Viel Zeit, ohne Ziel'**
  String get lustProfileLotsOfTimeNoGoal;

  /// No description provided for @lustProfileMyDesireProfileThisIs.
  ///
  /// In de, this message translates to:
  /// **'💛 Mein Lust-Profil – das habe ich über mich entdeckt:\n'**
  String get lustProfileMyDesireProfileThisIs;

  /// No description provided for @lustProfileWouldYouLikeToTry.
  ///
  /// In de, this message translates to:
  /// **'\nMagst du es mit mir ausprobieren?'**
  String get lustProfileWouldYouLikeToTry;

  /// No description provided for @lustProfileYourDesireProfileIsOn.
  ///
  /// In de, this message translates to:
  /// **'Dein Lust-Profil ist verschlüsselt unterwegs 💛'**
  String get lustProfileYourDesireProfileIsOn;

  /// No description provided for @lustProfileSendingDidnTWorkPlease.
  ///
  /// In de, this message translates to:
  /// **'Senden hat nicht geklappt. Bitte gleich noch einmal.'**
  String get lustProfileSendingDidnTWorkPlease;

  /// No description provided for @lustProfileTextCopied.
  ///
  /// In de, this message translates to:
  /// **'Text kopiert.'**
  String get lustProfileTextCopied;

  /// No description provided for @lustProfileWithVulva.
  ///
  /// In de, this message translates to:
  /// **'Mit Vulva'**
  String get lustProfileWithVulva;

  /// No description provided for @lustProfileWithPenis.
  ///
  /// In de, this message translates to:
  /// **'Mit Penis'**
  String get lustProfileWithPenis;

  /// No description provided for @lustProfileTickWhatYouEnjoyedWhile.
  ///
  /// In de, this message translates to:
  /// **'Hake an, was dir beim Erkunden gefallen hat. Nur du entscheidest, ob und wann du es teilst – gesendet wird ausschließlich, was du hier auswählst.'**
  String get lustProfileTickWhatYouEnjoyedWhile;

  /// No description provided for @lustProfileGeneral.
  ///
  /// In de, this message translates to:
  /// **'Allgemein'**
  String get lustProfileGeneral;

  /// No description provided for @lustProfilePersonalNote.
  ///
  /// In de, this message translates to:
  /// **'Eigene Notiz'**
  String get lustProfilePersonalNote;

  /// No description provided for @lustProfileForExampleAtTheBeginning.
  ///
  /// In de, this message translates to:
  /// **'Zum Beispiel: Am Anfang mag ich große, langsame Kreise …'**
  String get lustProfileForExampleAtTheBeginning;

  /// No description provided for @lustProfileSendToMyPartner.
  ///
  /// In de, this message translates to:
  /// **'An mein Gegenüber senden'**
  String get lustProfileSendToMyPartner;

  /// No description provided for @lustProfileConnectCoupleChannelAndSend.
  ///
  /// In de, this message translates to:
  /// **'Paar-Kanal verbinden und senden'**
  String get lustProfileConnectCoupleChannelAndSend;

  /// No description provided for @lustProfileJustCopyAsText.
  ///
  /// In de, this message translates to:
  /// **'Nur als Text kopieren'**
  String get lustProfileJustCopyAsText;

  /// No description provided for @lustProfileTipEvenNicerThanAny.
  ///
  /// In de, this message translates to:
  /// **'Tipp: Noch schöner als jede Nachricht ist es, die Hand deines Gegenübers zu führen oder es dir zeigen zu lassen. Die Nachricht kann der Anstoß dafür sein.'**
  String get lustProfileTipEvenNicerThanAny;

  /// No description provided for @yesNoMaybeMatchingAnswersEncrypted.
  ///
  /// In de, this message translates to:
  /// **'Antworten werden verschlüsselt abgeglichen …'**
  String get yesNoMaybeMatchingAnswersEncrypted;

  /// No description provided for @yesNoMaybeCountAnswersMatched.
  ///
  /// In de, this message translates to:
  /// **'{count} Antworten erfolgreich abgeglichen! ✨'**
  String yesNoMaybeCountAnswersMatched(Object count);

  /// No description provided for @yesNoMaybeReadMore.
  ///
  /// In de, this message translates to:
  /// **'WEITERLESEN'**
  String get yesNoMaybeReadMore;

  /// No description provided for @yesNoMaybeYesMaybeNo.
  ///
  /// In de, this message translates to:
  /// **'Ja / Vielleicht / Nein'**
  String get yesNoMaybeYesMaybeNo;

  /// No description provided for @yesNoMaybeSyncWithPartner.
  ///
  /// In de, this message translates to:
  /// **'Mit Partner synchronisieren'**
  String get yesNoMaybeSyncWithPartner;

  /// No description provided for @yesNoMaybePairingRequired.
  ///
  /// In de, this message translates to:
  /// **'Koppeln erforderlich'**
  String get yesNoMaybePairingRequired;

  /// No description provided for @yesNoMaybeQuestionsAnsweredcountTotalitems.
  ///
  /// In de, this message translates to:
  /// **'Fragenkatalog ({answeredCount}/{totalItems})'**
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
      Object answeredCount, Object totalItems);

  /// No description provided for @yesNoMaybeMatchesMatchcount.
  ///
  /// In de, this message translates to:
  /// **'Matches ({matchCount})'**
  String yesNoMaybeMatchesMatchcount(Object matchCount);

  /// No description provided for @yesNoMaybeDigitalSafeSpace.
  ///
  /// In de, this message translates to:
  /// **'DIGITALER SAFE SPACE'**
  String get yesNoMaybeDigitalSafeSpace;

  /// No description provided for @yesNoMaybeFindOutWhatExcitesYou.
  ///
  /// In de, this message translates to:
  /// **'Finde heraus, was dich reizt und wo deine Grenzen liegen. Unklar, was gemeint ist? Tippe auf „Mehr erfahren“. Seid ihr im Paar-Kanal verbunden, seht ihr nur, was ihr beide wollt – ein Nein bleibt unsichtbar.'**
  String get yesNoMaybeFindOutWhatExcitesYou;

  /// No description provided for @yesNoMaybeYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yesNoMaybeYes;

  /// No description provided for @yesNoMaybeMaybe.
  ///
  /// In de, this message translates to:
  /// **'Vielleicht'**
  String get yesNoMaybeMaybe;

  /// No description provided for @yesNoMaybeNo.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get yesNoMaybeNo;

  /// No description provided for @yesNoMaybeAllEintraegelength.
  ///
  /// In de, this message translates to:
  /// **'Alle ({eintraegeLength})'**
  String yesNoMaybeAllEintraegelength(Object eintraegeLength);

  /// No description provided for @yesNoMaybeOpen.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get yesNoMaybeOpen;

  /// No description provided for @yesNoMaybeYesYescount.
  ///
  /// In de, this message translates to:
  /// **'Ja ({yesCount})'**
  String yesNoMaybeYesYescount(Object yesCount);

  /// No description provided for @yesNoMaybeMaybeMaybecount.
  ///
  /// In de, this message translates to:
  /// **'Vielleicht ({maybeCount})'**
  String yesNoMaybeMaybeMaybecount(Object maybeCount);

  /// No description provided for @yesNoMaybeNoNocount.
  ///
  /// In de, this message translates to:
  /// **'Nein ({noCount})'**
  String yesNoMaybeNoNocount(Object noCount);

  /// No description provided for @yesNoMaybePairingRequired2.
  ///
  /// In de, this message translates to:
  /// **'Kopplung erforderlich'**
  String get yesNoMaybePairingRequired2;

  /// No description provided for @yesNoMaybeConnectWithYourPartnerIn.
  ///
  /// In de, this message translates to:
  /// **'Verbinde dich im Paar-Kanal per QR-Code mit deinem Gegenüber. Eure Antworten werden dann Ende-zu-Ende-verschlüsselt abgeglichen.'**
  String get yesNoMaybeConnectWithYourPartnerIn;

  /// No description provided for @yesNoMaybePairViaQrCodeNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt per QR-Code koppeln'**
  String get yesNoMaybePairViaQrCodeNow;

  /// No description provided for @yesNoMaybePerfectMatchWithPartnername.
  ///
  /// In de, this message translates to:
  /// **'VOLLTREFFER MIT {partnerName}'**
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName);

  /// No description provided for @yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints.
  ///
  /// In de, this message translates to:
  /// **'{yesMatchesLength} gemeinsame Ja-Übereinstimmungen & {curiosityMatchesLength} Neugier-Punkte entdeckt!'**
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
      Object yesMatchesLength, Object curiosityMatchesLength);

  /// No description provided for @yesNoMaybeNoRejectionAllLimitsWere.
  ///
  /// In de, this message translates to:
  /// **'Keine Zurückweisung: Alle Grenzen wurden diskret gewahrt. Nur echte gemeinsame Lust wird enthüllt.'**
  String get yesNoMaybeNoRejectionAllLimitsWere;

  /// No description provided for @yesNoMaybePerfectMatchBothSaidYes.
  ///
  /// In de, this message translates to:
  /// **'Volltreffer (Beide haben JA gesagt)'**
  String get yesNoMaybePerfectMatchBothSaidYes;

  /// No description provided for @yesNoMaybeSharedCuriosityOpenToExploring.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsame Neugier (Offen für Erkundung)'**
  String get yesNoMaybeSharedCuriosityOpenToExploring;

  /// No description provided for @yesNoMaybeNoMatchesYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Übereinstimmungen'**
  String get yesNoMaybeNoMatchesYet;

  /// No description provided for @yesNoMaybeBothKeepVotingInThe.
  ///
  /// In de, this message translates to:
  /// **'Stimmt beide weiter im Fragenkatalog ab. Sobald ihr denselben Punkt mit Ja oder Vielleicht bewertet habt, leuchtet er hier auf.'**
  String get yesNoMaybeBothKeepVotingInThe;

  /// No description provided for @yesNoMaybeYouBothYes.
  ///
  /// In de, this message translates to:
  /// **'Ihr beide: Ja'**
  String get yesNoMaybeYouBothYes;

  /// No description provided for @yesNoMaybeCuriousTogether.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam neugierig'**
  String get yesNoMaybeCuriousTogether;

  /// No description provided for @yesNoMaybeCourse.
  ///
  /// In de, this message translates to:
  /// **'Kurs ▶'**
  String get yesNoMaybeCourse;

  /// No description provided for @cbtNewEntryPleaseChooseAtLeastOne.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle mindestens ein Denkmuster / eine Verzerrung aus.'**
  String get cbtNewEntryPleaseChooseAtLeastOne;

  /// No description provided for @cbtNewEntryNewThoughtRecord.
  ///
  /// In de, this message translates to:
  /// **'Neues Gedankenprotokoll'**
  String get cbtNewEntryNewThoughtRecord;

  /// No description provided for @cbtNewEntryEditEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag bearbeiten'**
  String get cbtNewEntryEditEntry;

  /// No description provided for @cbtNewEntryCognitiveRestructuringUnmaskIrrationalAlarm.
  ///
  /// In de, this message translates to:
  /// **'Kognitive Umstrukturierung: Enttarne irrationale Alarmgedanken und formuliere eine biologisch realistische Antwort.'**
  String get cbtNewEntryCognitiveRestructuringUnmaskIrrationalAlarm;

  /// No description provided for @cbtNewEntryTriggerSituation.
  ///
  /// In de, this message translates to:
  /// **'Auslöser / Situation'**
  String get cbtNewEntryTriggerSituation;

  /// No description provided for @cbtNewEntryWhenOrDuringWhatDid.
  ///
  /// In de, this message translates to:
  /// **'Wann oder wobei trat die Anspannung auf? (z.B. „Als wir ins Bett gingen“, „Als sie mich berührte“)'**
  String get cbtNewEntryWhenOrDuringWhatDid;

  /// No description provided for @cbtNewEntryDescribeTheSpecificSituation.
  ///
  /// In de, this message translates to:
  /// **'Konkrete Situation beschreiben...'**
  String get cbtNewEntryDescribeTheSpecificSituation;

  /// No description provided for @cbtNewEntryPleaseDescribeASituation.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib eine Situation an.'**
  String get cbtNewEntryPleaseDescribeASituation;

  /// No description provided for @cbtNewEntryAutomaticThoughtMentalMovie.
  ///
  /// In de, this message translates to:
  /// **'Automatischer Gedanke (Kopfkino)'**
  String get cbtNewEntryAutomaticThoughtMentalMovie;

  /// No description provided for @cbtNewEntryWhatShotThroughYourHead.
  ///
  /// In de, this message translates to:
  /// **'Was schoss dir sofort durch den Kopf? Was sagte der innere Kritiker? (z.B. „Ich werde gleich wieder versagen“)'**
  String get cbtNewEntryWhatShotThroughYourHead;

  /// No description provided for @cbtNewEntryNoteTheUnfilteredThought.
  ///
  /// In de, this message translates to:
  /// **'Den ungefilterten Gedanken notieren...'**
  String get cbtNewEntryNoteTheUnfilteredThought;

  /// No description provided for @cbtNewEntryPleaseNoteYourThought.
  ///
  /// In de, this message translates to:
  /// **'Bitte notiere deinen Gedanken.'**
  String get cbtNewEntryPleaseNoteYourThought;

  /// No description provided for @cbtNewEntryExposeTheCognitiveDistortion.
  ///
  /// In de, this message translates to:
  /// **'Kognitive Verzerrung entlarven'**
  String get cbtNewEntryExposeTheCognitiveDistortion;

  /// No description provided for @cbtNewEntryWhichThinkingTrapIsThis.
  ///
  /// In de, this message translates to:
  /// **'Welche Denkfalle liegt hier vor? (Wähle mindestens eine aus)'**
  String get cbtNewEntryWhichThinkingTrapIsThis;

  /// No description provided for @cbtNewEntryReappraisalRealityCheck.
  ///
  /// In de, this message translates to:
  /// **'Neubewertung / Realitätscheck'**
  String get cbtNewEntryReappraisalRealityCheck;

  /// No description provided for @cbtNewEntryWhatSTheRealisticView.
  ///
  /// In de, this message translates to:
  /// **'Was ist die biologische Wahrheit? Was würde ein empathischer Coach oder Freund dazu sagen?'**
  String get cbtNewEntryWhatSTheRealisticView;

  /// No description provided for @cbtNewEntryEGMyBodyIs.
  ///
  /// In de, this message translates to:
  /// **'z.B.: „Mein Körper reagiert nur auf Adrenalin. Ich muss heute niemanden beeindrucken. Wenn ich den Fokus auf Hautkontakt und Atmung lenke, fällt der Druck ab.“'**
  String get cbtNewEntryEGMyBodyIs;

  /// No description provided for @cbtNewEntryPleasePhraseAReappraisal.
  ///
  /// In de, this message translates to:
  /// **'Bitte formuliere eine Neubewertung.'**
  String get cbtNewEntryPleasePhraseAReappraisal;

  /// No description provided for @cbtNewEntrySaving.
  ///
  /// In de, this message translates to:
  /// **'Wird gespeichert...'**
  String get cbtNewEntrySaving;

  /// No description provided for @cbtNewEntrySaveThoughtRecord.
  ///
  /// In de, this message translates to:
  /// **'Gedankenprotokoll speichern'**
  String get cbtNewEntrySaveThoughtRecord;

  /// No description provided for @cbtJournalDeleteEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag löschen?'**
  String get cbtJournalDeleteEntry;

  /// No description provided for @cbtJournalDoYouReallyWantTo.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du dieses Gedankenprotokoll wirklich von deinem Gerät entfernen?'**
  String get cbtJournalDoYouReallyWantTo;

  /// No description provided for @cbtJournalDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get cbtJournalDelete;

  /// No description provided for @cbtJournalNewEntry.
  ///
  /// In de, this message translates to:
  /// **'Neuer Eintrag'**
  String get cbtJournalNewEntry;

  /// No description provided for @cbtJournalMyRecordsEntrieslength.
  ///
  /// In de, this message translates to:
  /// **'Meine Protokolle ({entriesLength})'**
  String cbtJournalMyRecordsEntrieslength(Object entriesLength);

  /// No description provided for @cbtJournalBeliefs.
  ///
  /// In de, this message translates to:
  /// **'Glaubenssätze'**
  String get cbtJournalBeliefs;

  /// No description provided for @cbtJournalNoThoughtRecordsYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Gedankenprotokolle'**
  String get cbtJournalNoThoughtRecordsYet;

  /// No description provided for @cbtJournalWhenYourHeadBlocksBefore.
  ///
  /// In de, this message translates to:
  /// **'Wenn der Kopf vor oder bei der Intimität blockiert, hilft es ungemein, den automatischen Gedanken aufzuschreiben und die kognitive Verzerrung schwarz auf weiß zu entlarven.'**
  String get cbtJournalWhenYourHeadBlocksBefore;

  /// No description provided for @cbtJournalNewRecord.
  ///
  /// In de, this message translates to:
  /// **'Neues Protokoll'**
  String get cbtJournalNewRecord;

  /// No description provided for @cbtJournalStartWithABelief.
  ///
  /// In de, this message translates to:
  /// **'Mit einem Glaubenssatz starten'**
  String get cbtJournalStartWithABelief;

  /// No description provided for @cbtJournalCognitiveRestructuring.
  ///
  /// In de, this message translates to:
  /// **'Kognitive Umstrukturierung'**
  String get cbtJournalCognitiveRestructuring;

  /// No description provided for @cbtJournalEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get cbtJournalEdit;

  /// No description provided for @cbtJournalAutomaticThoughtAlarm.
  ///
  /// In de, this message translates to:
  /// **'AUTOMATISCHER GEDANKE (ALARM)'**
  String get cbtJournalAutomaticThoughtAlarm;

  /// No description provided for @cbtJournalAutomaticthought.
  ///
  /// In de, this message translates to:
  /// **'„{automaticThought}“'**
  String cbtJournalAutomaticthought(Object automaticThought);

  /// No description provided for @cbtJournalReappraisalRealityCheck.
  ///
  /// In de, this message translates to:
  /// **'NEUBEWERTUNG & REALITÄTSCHECK'**
  String get cbtJournalReappraisalRealityCheck;

  /// No description provided for @beliefLibraryViewRealitycheckPracticalShiftPracticalshift.
  ///
  /// In de, this message translates to:
  /// **'{realityCheck}\n\nPraktischer Shift: {practicalShift}'**
  String beliefLibraryViewRealitycheckPracticalShiftPracticalshift(
      Object realityCheck, Object practicalShift);

  /// No description provided for @beliefLibraryViewBeliefToolkit.
  ///
  /// In de, this message translates to:
  /// **'Glaubenssätze-Baukasten'**
  String get beliefLibraryViewBeliefToolkit;

  /// No description provided for @beliefLibraryViewTheMostCommonMentalTraps.
  ///
  /// In de, this message translates to:
  /// **'Die häufigsten mentalen Fallen bei Leistungsangst – und die biologische Wahrheit dahinter. Tippe auf eine Karte, um sie direkt in dein eigenes Journal zu übernehmen.'**
  String get beliefLibraryViewTheMostCommonMentalTraps;

  /// No description provided for @beliefLibraryViewForHer.
  ///
  /// In de, this message translates to:
  /// **'FÜR SIE 🌸'**
  String get beliefLibraryViewForHer;

  /// No description provided for @beliefLibraryViewForHim.
  ///
  /// In de, this message translates to:
  /// **'FÜR IHN 🌿'**
  String get beliefLibraryViewForHim;

  /// No description provided for @beliefLibraryViewTypicalMisbeliefMentalMovie.
  ///
  /// In de, this message translates to:
  /// **'TYPISCHER IRRGLAUBE (KOPFKINO)'**
  String get beliefLibraryViewTypicalMisbeliefMentalMovie;

  /// No description provided for @beliefLibraryViewIrrationalthought.
  ///
  /// In de, this message translates to:
  /// **'„{irrationalThought}“'**
  String beliefLibraryViewIrrationalthought(Object irrationalThought);

  /// No description provided for @beliefLibraryViewRealityCheck.
  ///
  /// In de, this message translates to:
  /// **'BIOLOGISCHER REALITÄTSCHECK'**
  String get beliefLibraryViewRealityCheck;

  /// No description provided for @beliefLibraryViewTakeIntoMyJournal.
  ///
  /// In de, this message translates to:
  /// **'In eigenes Journal übernehmen'**
  String get beliefLibraryViewTakeIntoMyJournal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
