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
