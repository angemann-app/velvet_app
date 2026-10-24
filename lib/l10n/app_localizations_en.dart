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
}
