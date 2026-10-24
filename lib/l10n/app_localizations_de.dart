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
}
