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
