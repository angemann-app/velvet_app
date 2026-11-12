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

  /// No description provided for @gemeinsamWiedergabeFehler.
  ///
  /// In de, this message translates to:
  /// **'Eine Wiedergabe konnte nicht starten. Prüft die Aufnahmen und die Audioausgabe und versucht es erneut.'**
  String get gemeinsamWiedergabeFehler;

  /// No description provided for @gemeinsamZurueckziehen.
  ///
  /// In de, this message translates to:
  /// **'Einladung zurückziehen'**
  String get gemeinsamZurueckziehen;

  /// No description provided for @aufnahmePaketFehlt.
  ///
  /// In de, this message translates to:
  /// **'Das passende Inhaltspaket muss geladen werden.'**
  String get aufnahmePaketFehlt;

  /// No description provided for @wiedergabeStimmenStand.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen für diese Stimme'**
  String get wiedergabeStimmenStand;

  /// No description provided for @gemeinsamAntwortZuLang.
  ///
  /// In de, this message translates to:
  /// **'Der Rückblick ist zu lang. Kürze ihn bitte etwas und versuche es erneut.'**
  String get gemeinsamAntwortZuLang;

  /// No description provided for @gemeinsamGefuehlRuhig.
  ///
  /// In de, this message translates to:
  /// **'Ruhig'**
  String get gemeinsamGefuehlRuhig;

  /// No description provided for @gemeinsamGefuehlNah.
  ///
  /// In de, this message translates to:
  /// **'Verbunden'**
  String get gemeinsamGefuehlNah;

  /// No description provided for @gemeinsamGefuehlOffen.
  ///
  /// In de, this message translates to:
  /// **'Noch offen'**
  String get gemeinsamGefuehlOffen;

  /// No description provided for @gemeinsamGefuehlBewegt.
  ///
  /// In de, this message translates to:
  /// **'Bewegt'**
  String get gemeinsamGefuehlBewegt;

  /// No description provided for @gemeinsamTitel.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsame Übung'**
  String get gemeinsamTitel;

  /// No description provided for @gemeinsamHinweis.
  ///
  /// In de, this message translates to:
  /// **'Ihr hört denselben Ablauf auf euren eigenen Geräten. Beide brauchen passende Aufnahmen und bestätigen ihre Bereitschaft. Kopfhörer können angenehm sein. Jede Person kann pausieren; weiter geht es erst, wenn beide bereit sind. Eine Einladung beginnt den Ablauf von vorn.'**
  String get gemeinsamHinweis;

  /// No description provided for @gemeinsamAnnehmen.
  ///
  /// In de, this message translates to:
  /// **'Annehmen'**
  String get gemeinsamAnnehmen;

  /// No description provided for @gemeinsamSpaeter.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get gemeinsamSpaeter;

  /// No description provided for @gemeinsamWarten.
  ///
  /// In de, this message translates to:
  /// **'Du bist bereit. Warte auf dein Gegenüber.'**
  String get gemeinsamWarten;

  /// No description provided for @gemeinsamBereitHinweis.
  ///
  /// In de, this message translates to:
  /// **'Richte dich in Ruhe ein und bestätige dann deine Bereitschaft.'**
  String get gemeinsamBereitHinweis;

  /// No description provided for @gemeinsamBereit.
  ///
  /// In de, this message translates to:
  /// **'Bereit'**
  String get gemeinsamBereit;

  /// No description provided for @gemeinsamPlayer.
  ///
  /// In de, this message translates to:
  /// **'Wiedergabe öffnen'**
  String get gemeinsamPlayer;

  /// No description provided for @gemeinsamRueckblick.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsamer Rückblick'**
  String get gemeinsamRueckblick;

  /// No description provided for @gemeinsamBeenden.
  ///
  /// In de, this message translates to:
  /// **'Für beide beenden'**
  String get gemeinsamBeenden;

  /// No description provided for @gemeinsamSchliessen.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get gemeinsamSchliessen;

  /// No description provided for @gemeinsamEinladung.
  ///
  /// In de, this message translates to:
  /// **'Eine Einladung wartet auf dich.'**
  String get gemeinsamEinladung;

  /// No description provided for @gemeinsamVorbereiten.
  ///
  /// In de, this message translates to:
  /// **'In Ruhe bereit werden'**
  String get gemeinsamVorbereiten;

  /// No description provided for @gemeinsamWartenAnnahme.
  ///
  /// In de, this message translates to:
  /// **'Warte auf dein Gegenüber.'**
  String get gemeinsamWartenAnnahme;

  /// No description provided for @gemeinsamLaeuft.
  ///
  /// In de, this message translates to:
  /// **'Ihr hört gemeinsam.'**
  String get gemeinsamLaeuft;

  /// No description provided for @gemeinsamPause.
  ///
  /// In de, this message translates to:
  /// **'Pause. Weiter erst, wenn beide bereit sind.'**
  String get gemeinsamPause;

  /// No description provided for @gemeinsamAbgeschlossen.
  ///
  /// In de, this message translates to:
  /// **'Euer gemeinsamer Moment ist beendet.'**
  String get gemeinsamAbgeschlossen;

  /// No description provided for @gemeinsamAufnahmenFehlen.
  ///
  /// In de, this message translates to:
  /// **'Passende Aufnahmen fehlen oder unterscheiden sich. Ladet beide die aktuellen Aufnahmen und ladet euch erneut ein. Gemeinsames Hören verwendet keine Geräte-Stimme.'**
  String get gemeinsamAufnahmenFehlen;

  /// No description provided for @gemeinsamPartnerFehlt.
  ///
  /// In de, this message translates to:
  /// **'Dein Gegenüber ist gerade nicht erreichbar, bereits beschäftigt oder braucht eine aktuelle App. Öffnet beide den Paar-Kanal und versucht es erneut.'**
  String get gemeinsamPartnerFehlt;

  /// No description provided for @gemeinsamFehler.
  ///
  /// In de, this message translates to:
  /// **'Die Verbindung hat nicht geklappt. Bitte versucht es erneut.'**
  String get gemeinsamFehler;

  /// No description provided for @gemeinsamLeer.
  ///
  /// In de, this message translates to:
  /// **'Wähle bei einer Wiedergabe „Gemeinsam hören“.'**
  String get gemeinsamLeer;

  /// No description provided for @gemeinsamStatusOeffnen.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsamen Ablauf öffnen'**
  String get gemeinsamStatusOeffnen;

  /// No description provided for @gemeinsamStarten.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam hören'**
  String get gemeinsamStarten;

  /// No description provided for @gemeinsamDuEmpfaengst.
  ///
  /// In de, this message translates to:
  /// **'Du empfängst, dein Gegenüber gibt.'**
  String get gemeinsamDuEmpfaengst;

  /// No description provided for @gemeinsamVerbindungFehlt.
  ///
  /// In de, this message translates to:
  /// **'Die Verbindung zum Gegenüber ist unterbrochen. Deine Wiedergabe läuft lokal weiter. Du kannst jederzeit pausieren; ein Wiederverbinden startet nichts automatisch.'**
  String get gemeinsamVerbindungFehlt;

  /// No description provided for @gemeinsamRueckblickFrage.
  ///
  /// In de, this message translates to:
  /// **'Wie war dieser Moment für dich?'**
  String get gemeinsamRueckblickFrage;

  /// No description provided for @gemeinsamRueckblickHinweis.
  ///
  /// In de, this message translates to:
  /// **'Dein Rückblick ist freiwillig. Die Antwort deines Gegenübers wird erst sichtbar, wenn ihr beide eine eigene Antwort geteilt habt.'**
  String get gemeinsamRueckblickHinweis;

  /// No description provided for @gemeinsamAntwort.
  ///
  /// In de, this message translates to:
  /// **'Dein Rückblick'**
  String get gemeinsamAntwort;

  /// No description provided for @gemeinsamTeilen.
  ///
  /// In de, this message translates to:
  /// **'Antwort speichern und teilen'**
  String get gemeinsamTeilen;

  /// No description provided for @gemeinsamGeteilt.
  ///
  /// In de, this message translates to:
  /// **'Dein Rückblick wurde geteilt.'**
  String get gemeinsamGeteilt;

  /// No description provided for @gemeinsamNochVerdeckt.
  ///
  /// In de, this message translates to:
  /// **'Der gemeinsame Rückblick ist noch verdeckt.'**
  String get gemeinsamNochVerdeckt;

  /// No description provided for @gemeinsamCountdown.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsamer Start in {sekunden}'**
  String gemeinsamCountdown(int sekunden);

  /// No description provided for @wiedergabeNeutral.
  ///
  /// In de, this message translates to:
  /// **'Wiedergabe'**
  String get wiedergabeNeutral;

  /// No description provided for @wiedergabeLeer.
  ///
  /// In de, this message translates to:
  /// **'Keine zugängliche Wiedergabe ausgewählt.'**
  String get wiedergabeLeer;

  /// No description provided for @wiedergabeBehalten.
  ///
  /// In de, this message translates to:
  /// **'Du kannst diese Seite schließen und während des Hörens weiter entdecken.'**
  String get wiedergabeBehalten;

  /// No description provided for @wiedergabeTts.
  ///
  /// In de, this message translates to:
  /// **'Geräte-Stimme: Beim Wiederaufnehmen beginnt dieser Abschnitt von vorn.'**
  String get wiedergabeTts;

  /// No description provided for @wiedergabeFehler.
  ///
  /// In de, this message translates to:
  /// **'Die Wiedergabe konnte nicht fortgesetzt werden. Prüfe die Aufnahmen und versuche es erneut.'**
  String get wiedergabeFehler;

  /// No description provided for @wiedergabeFertig.
  ///
  /// In de, this message translates to:
  /// **'Für diesen Moment abgeschlossen.'**
  String get wiedergabeFertig;

  /// No description provided for @wiedergabeTeilweise.
  ///
  /// In de, this message translates to:
  /// **'Nicht alle Aufnahmen sind offline vorhanden. Fehlende Texte liest die Geräte-Stimme.'**
  String get wiedergabeTeilweise;

  /// No description provided for @wiedergabeAbschnitte.
  ///
  /// In de, this message translates to:
  /// **'Abschnitte'**
  String get wiedergabeAbschnitte;

  /// No description provided for @wiedergabeRuhe.
  ///
  /// In de, this message translates to:
  /// **'Ruhe & Nachspüren'**
  String get wiedergabeRuhe;

  /// No description provided for @wiedergabeEntfernen.
  ///
  /// In de, this message translates to:
  /// **'Aus Weiterhören entfernen'**
  String get wiedergabeEntfernen;

  /// No description provided for @wiedergabeLaeuft.
  ///
  /// In de, this message translates to:
  /// **'Läuft weiter'**
  String get wiedergabeLaeuft;

  /// No description provided for @wiedergabeFortsetzen.
  ///
  /// In de, this message translates to:
  /// **'Weiterhören'**
  String get wiedergabeFortsetzen;

  /// No description provided for @wiedergabeRunde.
  ///
  /// In de, this message translates to:
  /// **'Runde {runde}'**
  String wiedergabeRunde(int runde);

  /// No description provided for @sucheTitel.
  ///
  /// In de, this message translates to:
  /// **'Entdecken & finden'**
  String get sucheTitel;

  /// No description provided for @aufnahmeOffline.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme offline verfügbar'**
  String get aufnahmeOffline;

  /// No description provided for @wegTitel.
  ///
  /// In de, this message translates to:
  /// **'Dein persönlicher Weg'**
  String get wegTitel;

  /// No description provided for @wegEinladung.
  ///
  /// In de, this message translates to:
  /// **'Wissen, Ausprobieren, Nachspüren. Drei freiwillige Schritte in deinem Tempo – ohne Zeitvorgabe oder Pflichtantwort.'**
  String get wegEinladung;

  /// No description provided for @wegWissen.
  ///
  /// In de, this message translates to:
  /// **'Wissen entdecken'**
  String get wegWissen;

  /// No description provided for @wegUeben.
  ///
  /// In de, this message translates to:
  /// **'Übung ausprobieren'**
  String get wegUeben;

  /// No description provided for @wegNachspueren.
  ///
  /// In de, this message translates to:
  /// **'Nachspüren'**
  String get wegNachspueren;

  /// No description provided for @wegBeginnen.
  ///
  /// In de, this message translates to:
  /// **'Diesen Weg beginnen'**
  String get wegBeginnen;

  /// No description provided for @wegNochEinmal.
  ///
  /// In de, this message translates to:
  /// **'Noch einmal entdecken'**
  String get wegNochEinmal;

  /// No description provided for @wegOeffnen.
  ///
  /// In de, this message translates to:
  /// **'Schritt öffnen'**
  String get wegOeffnen;

  /// No description provided for @wegWeiter.
  ///
  /// In de, this message translates to:
  /// **'Zum nächsten Schritt'**
  String get wegWeiter;

  /// No description provided for @wegAbschliessen.
  ///
  /// In de, this message translates to:
  /// **'Für mich abschließen'**
  String get wegAbschliessen;

  /// No description provided for @wegFehler.
  ///
  /// In de, this message translates to:
  /// **'Der Stand konnte nicht gespeichert werden. Bitte versuche es noch einmal.'**
  String get wegFehler;

  /// No description provided for @aufnahmeGeraetestimme.
  ///
  /// In de, this message translates to:
  /// **'Ohne Aufnahme: Geräte-Stimme'**
  String get aufnahmeGeraetestimme;

  /// No description provided for @aufnahmeVerwalten.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen laden'**
  String get aufnahmeVerwalten;

  /// No description provided for @sucheFeld.
  ///
  /// In de, this message translates to:
  /// **'Kurse, Lektionen und Übungen suchen'**
  String get sucheFeld;

  /// No description provided for @sucheLeeren.
  ///
  /// In de, this message translates to:
  /// **'Suche leeren'**
  String get sucheLeeren;

  /// No description provided for @sucheHinweis.
  ///
  /// In de, this message translates to:
  /// **'Was möchtest du entdecken? Suche nach einem Thema oder einem Angebot. Deine Suche bleibt auf diesem Gerät und wird nicht gespeichert.'**
  String get sucheHinweis;

  /// No description provided for @sucheLeer.
  ///
  /// In de, this message translates to:
  /// **'Dazu wurde nichts gefunden. Versuche ein anderes Wort.'**
  String get sucheLeer;

  /// No description provided for @sucheFehler.
  ///
  /// In de, this message translates to:
  /// **'Die Inhalte konnten nicht geladen werden. Öffne die Suche bitte erneut.'**
  String get sucheFehler;

  /// No description provided for @sucheKurs.
  ///
  /// In de, this message translates to:
  /// **'Kurs'**
  String get sucheKurs;

  /// No description provided for @sucheLektion.
  ///
  /// In de, this message translates to:
  /// **'Lektion'**
  String get sucheLektion;

  /// No description provided for @sucheAngebot.
  ///
  /// In de, this message translates to:
  /// **'Audio & Praxis'**
  String get sucheAngebot;

  /// No description provided for @suchePaarAbend.
  ///
  /// In de, this message translates to:
  /// **'Geführter Paar-Abend'**
  String get suchePaarAbend;

  /// No description provided for @sucheInnenansichten.
  ///
  /// In de, this message translates to:
  /// **'Innenansichten'**
  String get sucheInnenansichten;

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
  /// **'Heute'**
  String get mainNavigationProgrammeCourses;

  /// No description provided for @mainNavigationSomaticsTraining.
  ///
  /// In de, this message translates to:
  /// **'Körper & Üben'**
  String get mainNavigationSomaticsTraining;

  /// No description provided for @mainNavigationCbtReframing.
  ///
  /// In de, this message translates to:
  /// **'Gedanken'**
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
  /// **'Heute'**
  String get mainNavigationCourses;

  /// No description provided for @mainNavigationTraining.
  ///
  /// In de, this message translates to:
  /// **'Körper'**
  String get mainNavigationTraining;

  /// No description provided for @mainNavigationReframing.
  ///
  /// In de, this message translates to:
  /// **'Gedanken'**
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
  /// **'Für Sie'**
  String get coursesForHer;

  /// No description provided for @coursesForHim.
  ///
  /// In de, this message translates to:
  /// **'Für Ihn'**
  String get coursesForHim;

  /// No description provided for @coursesForCouples.
  ///
  /// In de, this message translates to:
  /// **'Für Paare'**
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
  /// **'Funken schicken & Wünsche vergleichen, sichtbar wird nur, was ihr beide wollt'**
  String get coursesSendSparksSecretlyMatchWishes;

  /// No description provided for @coursesYourCurriculum.
  ///
  /// In de, this message translates to:
  /// **'DEINE KURSE'**
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

  /// No description provided for @heuteNaechsterSchritt.
  ///
  /// In de, this message translates to:
  /// **'Dein nächster Schritt'**
  String get heuteNaechsterSchritt;

  /// No description provided for @heuteStarten.
  ///
  /// In de, this message translates to:
  /// **'Starten'**
  String get heuteStarten;

  /// No description provided for @heuteWeitermachen.
  ///
  /// In de, this message translates to:
  /// **'Weitermachen'**
  String get heuteWeitermachen;

  /// No description provided for @heuteKursUndDauer.
  ///
  /// In de, this message translates to:
  /// **'{kurs} · {min} Min.'**
  String heuteKursUndDauer(String kurs, int min);

  /// No description provided for @heuteAllesErledigt.
  ///
  /// In de, this message translates to:
  /// **'Du hast alle Lektionen durch. Stöbere in den Kursen oder hör ein Audio.'**
  String get heuteAllesErledigt;

  /// No description provided for @heuteBleibtLokal.
  ///
  /// In de, this message translates to:
  /// **'Bleibt auf deinem Handy'**
  String get heuteBleibtLokal;

  /// No description provided for @heuteReiterCheckin.
  ///
  /// In de, this message translates to:
  /// **'Check-in'**
  String get heuteReiterCheckin;

  /// No description provided for @heuteReiterFunke.
  ///
  /// In de, this message translates to:
  /// **'Funke'**
  String get heuteReiterFunke;

  /// No description provided for @heuteKurse.
  ///
  /// In de, this message translates to:
  /// **'Kurse'**
  String get heuteKurse;

  /// No description provided for @wuenscheSzenenTitel.
  ///
  /// In de, this message translates to:
  /// **'Szenen zum Ausprobieren'**
  String get wuenscheSzenenTitel;

  /// No description provided for @wuenscheSzenenText.
  ///
  /// In de, this message translates to:
  /// **'Ganze Abende statt einzelner Fragen. Beantwortet sie getrennt, wie in der Landkarte. Nur im Spicy-Modus.'**
  String get wuenscheSzenenText;

  /// No description provided for @wuenscheBesprechenTitel.
  ///
  /// In de, this message translates to:
  /// **'Zum Besprechen'**
  String get wuenscheBesprechenTitel;

  /// No description provided for @wuenscheBesprechenText.
  ///
  /// In de, this message translates to:
  /// **'Hier ist mindestens ein „Vielleicht“ dabei. Sprecht kurz darüber, was ihr euch vorstellen könnt.'**
  String get wuenscheBesprechenText;

  /// No description provided for @aiCoachEinrichtungTitel.
  ///
  /// In de, this message translates to:
  /// **'Dein KI-Coach'**
  String get aiCoachEinrichtungTitel;

  /// No description provided for @aiCoachEinrichtungText.
  ///
  /// In de, this message translates to:
  /// **'Stell Fragen zu Körper, Lust und Beziehung, vertraulich und ohne Urteil. Er ersetzt keine ärztliche oder therapeutische Hilfe.'**
  String get aiCoachEinrichtungText;

  /// No description provided for @aiCoachEinrichtungSchritt1.
  ///
  /// In de, this message translates to:
  /// **'Einen kostenlosen Schlüssel bei Google erstellen'**
  String get aiCoachEinrichtungSchritt1;

  /// No description provided for @aiCoachEinrichtungKnopf1.
  ///
  /// In de, this message translates to:
  /// **'Anleitung'**
  String get aiCoachEinrichtungKnopf1;

  /// No description provided for @aiCoachEinrichtungSchritt2.
  ///
  /// In de, this message translates to:
  /// **'Den Schlüssel hier einfügen'**
  String get aiCoachEinrichtungSchritt2;

  /// No description provided for @aiCoachEinrichtungKnopf2.
  ///
  /// In de, this message translates to:
  /// **'Einfügen'**
  String get aiCoachEinrichtungKnopf2;

  /// No description provided for @aiCoachEinrichtungDatenschutz.
  ///
  /// In de, this message translates to:
  /// **'Nur deine Fragen gehen an Googles Gemini. Alles andere bleibt auf deinem Handy.'**
  String get aiCoachEinrichtungDatenschutz;

  /// No description provided for @onboardingLosGehts.
  ///
  /// In de, this message translates to:
  /// **'Loslegen'**
  String get onboardingLosGehts;

  /// No description provided for @onboardingWeiter.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get onboardingWeiter;

  /// No description provided for @onboardingZurueck.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get onboardingZurueck;

  /// No description provided for @onboardingOk.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get onboardingOk;

  /// No description provided for @onboardingMehrDatenschutz.
  ///
  /// In de, this message translates to:
  /// **'Mehr zum Datenschutz'**
  String get onboardingMehrDatenschutz;

  /// No description provided for @onboardingVersprechenLokal.
  ///
  /// In de, this message translates to:
  /// **'Alles bleibt auf deinem Handy: Profil, Tagebuch und Fortschritt.'**
  String get onboardingVersprechenLokal;

  /// No description provided for @onboardingVersprechenKeinKonto.
  ///
  /// In de, this message translates to:
  /// **'Kein Konto, keine Werbung, keine Auswertung.'**
  String get onboardingVersprechenKeinKonto;

  /// No description provided for @onboardingVersprechenNetz.
  ///
  /// In de, this message translates to:
  /// **'Ins Netz geht nur, was du selbst einschaltest: KI-Coach, Paar-Kanal und die Suche nach Updates.'**
  String get onboardingVersprechenNetz;

  /// No description provided for @onboardingSchritt.
  ///
  /// In de, this message translates to:
  /// **'Frage {n} von {gesamt}'**
  String onboardingSchritt(int n, int gesamt);

  /// No description provided for @heuteAlleKurse.
  ///
  /// In de, this message translates to:
  /// **'Alle Kurse ansehen'**
  String get heuteAlleKurse;

  /// No description provided for @navLernen.
  ///
  /// In de, this message translates to:
  /// **'Lernen'**
  String get navLernen;

  /// No description provided for @navUeben.
  ///
  /// In de, this message translates to:
  /// **'Üben'**
  String get navUeben;

  /// No description provided for @navWir.
  ///
  /// In de, this message translates to:
  /// **'Wir'**
  String get navWir;

  /// No description provided for @uebenKoerper.
  ///
  /// In de, this message translates to:
  /// **'Körper'**
  String get uebenKoerper;

  /// No description provided for @uebenGedanken.
  ///
  /// In de, this message translates to:
  /// **'Gedanken'**
  String get uebenGedanken;

  /// No description provided for @uebenCoach.
  ///
  /// In de, this message translates to:
  /// **'KI-Coach'**
  String get uebenCoach;

  /// No description provided for @coursesYourFocusGoallabel.
  ///
  /// In de, this message translates to:
  /// **'Dein Fokus: {goalLabel}'**
  String coursesYourFocusGoallabel(Object goalLabel);

  /// No description provided for @coursesUnderstandTheBiologyQuietThe.
  ///
  /// In de, this message translates to:
  /// **'Verstehen, was in dir passiert. Zur Ruhe kommen. Den Körper spüren.'**
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
  /// **'Praxis: Gedanken'**
  String get coursesPracticeCbt;

  /// No description provided for @lessonDetailLessonMarkedAsCompleted.
  ///
  /// In de, this message translates to:
  /// **'Lektion als abgeschlossen markiert!'**
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
  /// **'Atem-Begleiter starten (langes Ausatmen)'**
  String get lessonDetailStartBreathPacerDownRegulation;

  /// No description provided for @lessonDetailCalmDownWithBreathingOr.
  ///
  /// In de, this message translates to:
  /// **'Mit 4-7-8-Atmung oder dem langen Seufzer zur Ruhe kommen'**
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
  /// **'Wünsche leise vergleichen'**
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
  /// **'Kannst du auch allein ausfüllen und später mit deinem Gegenüber vergleichen.'**
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
  /// **'Gemeinsam entdecken'**
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
  /// **'Antwortet getrennt. Ein Wunsch wird erst sichtbar, wenn ihr beide „Ja, gern“ gesagt habt. Ein „Vielleicht“ kommt zu „Zum Besprechen“. Ein „Lieber nicht“ sieht dein Gegenüber nie.'**
  String get couplesChannelVoteSeparatelyAWishOnly;

  /// No description provided for @couplesChannelQuestionsInSeveralAreasWith.
  ///
  /// In de, this message translates to:
  /// **'{fragen} Fragen in {bereiche} Bereichen – mit passenden Kurs-Empfehlungen.'**
  String couplesChannelQuestionsInSeveralAreasWith(int fragen, int bereiche);

  /// No description provided for @couplesChannelYouHaveAMatch.
  ///
  /// In de, this message translates to:
  /// **'Bei einer Sache sagt ihr beide Ja'**
  String get couplesChannelYouHaveAMatch;

  /// No description provided for @couplesChannelYouHaveMatcheslengthMatches.
  ///
  /// In de, this message translates to:
  /// **'Bei {matchesLength} Dingen sagt ihr beide Ja'**
  String couplesChannelYouHaveMatcheslengthMatches(Object matchesLength);

  /// No description provided for @couplesChannelAMatchIsAnInvitation.
  ///
  /// In de, this message translates to:
  /// **'Ein gemeinsames Ja ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt. Und ein „Heute nicht“ gilt immer.'**
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

  /// No description provided for @couplesChannelEncryptionSealed.
  ///
  /// In de, this message translates to:
  /// **'Nostr NIP-17 (versiegelt)'**
  String get couplesChannelEncryptionSealed;

  /// No description provided for @couplesChannelSealedNote.
  ///
  /// In de, this message translates to:
  /// **'Schreibt ihr beide mit einer neuen Version, gehen die Nachrichten versiegelt raus: Die Server sehen nicht, wer sie schickt, und nur einen ungenauen Zeitpunkt. Sichtbar bleiben für sie, dass jemand an einen von euch schreibt, deine IP-Adresse und die ungefähre Größe.'**
  String get couplesChannelSealedNote;

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
  /// **'Verbunden mit {name}'**
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
  /// **'Verbunden mit {name}'**
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
  /// **'Dein Lust-Profil ist verschlüsselt unterwegs'**
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
  /// **'Antworten werden verschlüsselt verglichen …'**
  String get yesNoMaybeMatchingAnswersEncrypted;

  /// No description provided for @yesNoMaybeCountAnswersMatched.
  ///
  /// In de, this message translates to:
  /// **'Fertig: {count} Antworten verglichen.'**
  String yesNoMaybeCountAnswersMatched(Object count);

  /// No description provided for @yesNoMaybeReadMore.
  ///
  /// In de, this message translates to:
  /// **'WEITERLESEN'**
  String get yesNoMaybeReadMore;

  /// No description provided for @yesNoMaybeYesMaybeNo.
  ///
  /// In de, this message translates to:
  /// **'Ja, gern / Vielleicht / Lieber nicht'**
  String get yesNoMaybeYesMaybeNo;

  /// No description provided for @yesNoMaybeSyncWithPartner.
  ///
  /// In de, this message translates to:
  /// **'Mit deinem Gegenüber vergleichen'**
  String get yesNoMaybeSyncWithPartner;

  /// No description provided for @yesNoMaybePairingRequired.
  ///
  /// In de, this message translates to:
  /// **'Erst verbinden'**
  String get yesNoMaybePairingRequired;

  /// No description provided for @yesNoMaybeQuestionsAnsweredcountTotalitems.
  ///
  /// In de, this message translates to:
  /// **'Fragenkatalog ({answeredCount} von {totalItems})'**
  String yesNoMaybeQuestionsAnsweredcountTotalitems(
      Object answeredCount, Object totalItems);

  /// No description provided for @yesNoMaybeMatchesMatchcount.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam ({matchCount})'**
  String yesNoMaybeMatchesMatchcount(Object matchCount);

  /// No description provided for @yesNoMaybeMeineAntworten.
  ///
  /// In de, this message translates to:
  /// **'Meine Antworten'**
  String get yesNoMaybeMeineAntworten;

  /// No description provided for @yesNoMaybeGemeinsam.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam'**
  String get yesNoMaybeGemeinsam;

  /// No description provided for @yesNoMaybeDigitalSafeSpace.
  ///
  /// In de, this message translates to:
  /// **'Deine Antworten, dein Tempo'**
  String get yesNoMaybeDigitalSafeSpace;

  /// No description provided for @yesNoMaybeFindOutWhatExcitesYou.
  ///
  /// In de, this message translates to:
  /// **'Hier darfst du in Ruhe spüren, was dir gefällt, was vielleicht und was lieber nicht. Du musst nichts beantworten. Unklar, was gemeint ist? Tippe auf das i. Wenn ihr verbunden seid, wird nur sichtbar, wo ihr beide mindestens „Vielleicht“ gesagt habt. Ein „Lieber nicht“ sieht dein Gegenüber nie.'**
  String get yesNoMaybeFindOutWhatExcitesYou;

  /// No description provided for @yesNoMaybeYes.
  ///
  /// In de, this message translates to:
  /// **'Ja, gern'**
  String get yesNoMaybeYes;

  /// No description provided for @yesNoMaybeMaybe.
  ///
  /// In de, this message translates to:
  /// **'Vielleicht'**
  String get yesNoMaybeMaybe;

  /// No description provided for @yesNoMaybeNo.
  ///
  /// In de, this message translates to:
  /// **'Lieber nicht'**
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
  /// **'Ja, gern ({yesCount})'**
  String yesNoMaybeYesYescount(Object yesCount);

  /// No description provided for @yesNoMaybeMaybeMaybecount.
  ///
  /// In de, this message translates to:
  /// **'Vielleicht ({maybeCount})'**
  String yesNoMaybeMaybeMaybecount(Object maybeCount);

  /// No description provided for @yesNoMaybeNoNocount.
  ///
  /// In de, this message translates to:
  /// **'Lieber nicht ({noCount})'**
  String yesNoMaybeNoNocount(Object noCount);

  /// No description provided for @yesNoMaybePairingRequired2.
  ///
  /// In de, this message translates to:
  /// **'Erst verbinden'**
  String get yesNoMaybePairingRequired2;

  /// No description provided for @yesNoMaybeConnectWithYourPartnerIn.
  ///
  /// In de, this message translates to:
  /// **'Wenn ihr im Paar-Kanal verbunden seid, könnt ihr eure Antworten verschlüsselt vergleichen. Sichtbar wird nur das Gemeinsame. Allein ausfüllen geht auch.'**
  String get yesNoMaybeConnectWithYourPartnerIn;

  /// No description provided for @yesNoMaybePairViaQrCodeNow.
  ///
  /// In de, this message translates to:
  /// **'Per QR-Code verbinden'**
  String get yesNoMaybePairViaQrCodeNow;

  /// No description provided for @yesNoMaybePerfectMatchWithPartnername.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam mit {partnerName}'**
  String yesNoMaybePerfectMatchWithPartnername(Object partnerName);

  /// No description provided for @yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints.
  ///
  /// In de, this message translates to:
  /// **'Ja bei euch beiden: {yesMatchesLength} · Gemeinsam neugierig: {curiosityMatchesLength}'**
  String yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
      Object yesMatchesLength, Object curiosityMatchesLength);

  /// No description provided for @yesNoMaybeNoRejectionAllLimitsWere.
  ///
  /// In de, this message translates to:
  /// **'Hier steht nur, was ihr beide gesagt habt. Alles andere bleibt bei jedem für sich. Ein „Lieber nicht“ ist eine vollwertige Antwort.'**
  String get yesNoMaybeNoRejectionAllLimitsWere;

  /// No description provided for @yesNoMaybePerfectMatchBothSaidYes.
  ///
  /// In de, this message translates to:
  /// **'Ihr beide: Ja'**
  String get yesNoMaybePerfectMatchBothSaidYes;

  /// No description provided for @yesNoMaybeSharedCuriosityOpenToExploring.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsame Neugier, ein Vielleicht reicht'**
  String get yesNoMaybeSharedCuriosityOpenToExploring;

  /// No description provided for @yesNoMaybeNoMatchesYet.
  ///
  /// In de, this message translates to:
  /// **'Hier ist es noch still'**
  String get yesNoMaybeNoMatchesYet;

  /// No description provided for @yesNoMaybeBothKeepVotingInThe.
  ///
  /// In de, this message translates to:
  /// **'Das heißt nicht, dass etwas fehlt. Vielleicht habt ihr noch nicht alles beantwortet, oder eure Antworten liegen einfach an verschiedenen Stellen. Beides ist normal. Ihr müsst nichts tun.'**
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
  /// **'Mehr dazu'**
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
  /// **'FÜR SIE'**
  String get beliefLibraryViewForHer;

  /// No description provided for @beliefLibraryViewForHim.
  ///
  /// In de, this message translates to:
  /// **'FÜR IHN'**
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

  /// No description provided for @kegelTimerViewBreatheInWiden.
  ///
  /// In de, this message translates to:
  /// **'EINATMEN & WEIT WERDEN'**
  String get kegelTimerViewBreatheInWiden;

  /// No description provided for @kegelTimerViewBreatheDeepIntoTheBelly.
  ///
  /// In de, this message translates to:
  /// **'Tief in den Bauch atmen. Den Beckenboden sanft nach unten nachgeben lassen – kein Pressen.'**
  String get kegelTimerViewBreatheDeepIntoTheBelly;

  /// No description provided for @kegelTimerViewStaySoft.
  ///
  /// In de, this message translates to:
  /// **'WEICH BLEIBEN'**
  String get kegelTimerViewStaySoft;

  /// No description provided for @kegelTimerViewBreatheOutSlowlyAndStay.
  ///
  /// In de, this message translates to:
  /// **'Langsam ausatmen und weit bleiben, wie eine Hängematte, die locker durchhängt.'**
  String get kegelTimerViewBreatheOutSlowlyAndStay;

  /// No description provided for @kegelTimerViewNotice.
  ///
  /// In de, this message translates to:
  /// **'NACHSPÜREN'**
  String get kegelTimerViewNotice;

  /// No description provided for @kegelTimerViewKeepBreathingNormallyAndFeel.
  ///
  /// In de, this message translates to:
  /// **'Normal weiteratmen und spüren, wie warm und ruhig das Becken ist.'**
  String get kegelTimerViewKeepBreathingNormallyAndFeel;

  /// No description provided for @kegelTimerViewTighten.
  ///
  /// In de, this message translates to:
  /// **'ANSPANNEN'**
  String get kegelTimerViewTighten;

  /// No description provided for @kegelTimerViewGentlyDrawTheAreaBetween.
  ///
  /// In de, this message translates to:
  /// **'Den Bereich zwischen Schambein und Steißbein sanft nach innen und oben ziehen. Po und Bauch bleiben locker.'**
  String get kegelTimerViewGentlyDrawTheAreaBetween;

  /// No description provided for @kegelTimerViewHoldTheTensionAtAbout.
  ///
  /// In de, this message translates to:
  /// **'Die Spannung halten, etwa mit halber Kraft. Weiter ruhig atmen.'**
  String get kegelTimerViewHoldTheTensionAtAbout;

  /// No description provided for @kegelTimerViewLetGoCompletely.
  ///
  /// In de, this message translates to:
  /// **'GANZ LOSLASSEN'**
  String get kegelTimerViewLetGoCompletely;

  /// No description provided for @kegelTimerViewRelaxCompletelyLettingGoLasts.
  ///
  /// In de, this message translates to:
  /// **'Vollständig entspannen. Das Loslassen dauert mindestens so lange wie das Halten.'**
  String get kegelTimerViewRelaxCompletelyLettingGoLasts;

  /// No description provided for @kegelTimerViewQuickSqueeze.
  ///
  /// In de, this message translates to:
  /// **'KURZ AN'**
  String get kegelTimerViewQuickSqueeze;

  /// No description provided for @kegelTimerViewAQuickShortSqueezeLike.
  ///
  /// In de, this message translates to:
  /// **'Ein schnelles, kurzes Anspannen – wie ein Zwinkern mit dem Beckenboden.'**
  String get kegelTimerViewAQuickShortSqueezeLike;

  /// No description provided for @kegelTimerViewRelease.
  ///
  /// In de, this message translates to:
  /// **'LOS'**
  String get kegelTimerViewRelease;

  /// No description provided for @kegelTimerViewLetGoCompletelyRightAway.
  ///
  /// In de, this message translates to:
  /// **'Sofort wieder ganz loslassen.'**
  String get kegelTimerViewLetGoCompletelyRightAway;

  /// No description provided for @kegelTimerViewBreatheInSoften.
  ///
  /// In de, this message translates to:
  /// **'EINATMEN & WEICH'**
  String get kegelTimerViewBreatheInSoften;

  /// No description provided for @kegelTimerViewBreatheDeepIntoTheBelly2.
  ///
  /// In de, this message translates to:
  /// **'Tief in den Bauch atmen. Damm und Po bewusst weich werden lassen.'**
  String get kegelTimerViewBreatheDeepIntoTheBelly2;

  /// No description provided for @kegelTimerViewLongExhale.
  ///
  /// In de, this message translates to:
  /// **'LANG AUSATMEN'**
  String get kegelTimerViewLongExhale;

  /// No description provided for @kegelTimerViewBreatheOutLongAndAudibly.
  ///
  /// In de, this message translates to:
  /// **'Lang und hörbar ausatmen, der Beckenboden bleibt weit. So übst du, bei Erregung locker zu bleiben.'**
  String get kegelTimerViewBreatheOutLongAndAudibly;

  /// No description provided for @kegelTimerViewKeepBreathingCalmlyAndFeel.
  ///
  /// In de, this message translates to:
  /// **'Ruhig weiteratmen und die Wärme im Becken spüren.'**
  String get kegelTimerViewKeepBreathingCalmlyAndFeel;

  /// No description provided for @kegelTimerViewDone.
  ///
  /// In de, this message translates to:
  /// **'Geschafft'**
  String get kegelTimerViewDone;

  /// No description provided for @kegelTimerViewYouPractisedTotalroundsRoundsA.
  ///
  /// In de, this message translates to:
  /// **'Du hast {totalRounds} Runden geübt. Regelmäßig ein paar Minuten bringen mehr als selten lange – bis morgen!'**
  String kegelTimerViewYouPractisedTotalroundsRoundsA(Object totalRounds);

  /// No description provided for @kegelTimerViewFinish.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get kegelTimerViewFinish;

  /// No description provided for @kegelTimerViewLetGo.
  ///
  /// In de, this message translates to:
  /// **'Loslassen'**
  String get kegelTimerViewLetGo;

  /// No description provided for @kegelTimerViewWiden.
  ///
  /// In de, this message translates to:
  /// **'weit werden'**
  String get kegelTimerViewWiden;

  /// No description provided for @kegelTimerViewStrengthen.
  ///
  /// In de, this message translates to:
  /// **'Kräftigen'**
  String get kegelTimerViewStrengthen;

  /// No description provided for @kegelTimerViewHoldRelease.
  ///
  /// In de, this message translates to:
  /// **'halten & lösen'**
  String get kegelTimerViewHoldRelease;

  /// No description provided for @kegelTimerViewQuickPulses.
  ///
  /// In de, this message translates to:
  /// **'Schnelle Impulse'**
  String get kegelTimerViewQuickPulses;

  /// No description provided for @kegelTimerViewQuickOnQuickOff.
  ///
  /// In de, this message translates to:
  /// **'kurz an, kurz los'**
  String get kegelTimerViewQuickOnQuickOff;

  /// No description provided for @kegelTimerViewWaves.
  ///
  /// In de, this message translates to:
  /// **'Wellen'**
  String get kegelTimerViewWaves;

  /// No description provided for @kegelTimerViewSoftWhenAroused.
  ///
  /// In de, this message translates to:
  /// **'weich bei Erregung'**
  String get kegelTimerViewSoftWhenAroused;

  /// No description provided for @kegelTimerViewRounds.
  ///
  /// In de, this message translates to:
  /// **'Runden'**
  String get kegelTimerViewRounds;

  /// No description provided for @kegelTimerViewMinutesMin.
  ///
  /// In de, this message translates to:
  /// **'≈ {minutes} Min.'**
  String kegelTimerViewMinutesMin(Object minutes);

  /// No description provided for @kegelTimerViewLevel.
  ///
  /// In de, this message translates to:
  /// **'Stufe'**
  String get kegelTimerViewLevel;

  /// No description provided for @kegelTimerViewVoiceCues.
  ///
  /// In de, this message translates to:
  /// **'Ansage'**
  String get kegelTimerViewVoiceCues;

  /// No description provided for @kegelTimerViewAVoiceGuidesYou.
  ///
  /// In de, this message translates to:
  /// **'Stimme führt dich durch'**
  String get kegelTimerViewAVoiceGuidesYou;

  /// No description provided for @kegelTimerViewVibrationOnly.
  ///
  /// In de, this message translates to:
  /// **'nur Vibration'**
  String get kegelTimerViewVibrationOnly;

  /// No description provided for @kegelTimerViewRoundCurrentroundOfTotalrounds.
  ///
  /// In de, this message translates to:
  /// **'Runde {currentRound} von {totalRounds}'**
  String kegelTimerViewRoundCurrentroundOfTotalrounds(
      Object currentRound, Object totalRounds);

  /// No description provided for @kegelTimerViewPhaseCurrentphaseindexPhaseslength.
  ///
  /// In de, this message translates to:
  /// **'Phase {currentPhaseIndex}/{phasesLength}'**
  String kegelTimerViewPhaseCurrentphaseindexPhaseslength(
      Object currentPhaseIndex, Object phasesLength);

  /// No description provided for @kegelTimerViewGuidePracticePlan.
  ///
  /// In de, this message translates to:
  /// **'Anleitung & Übungsplan'**
  String get kegelTimerViewGuidePracticePlan;

  /// No description provided for @kegelTimerViewFindingTheMuscleWhichExercise.
  ///
  /// In de, this message translates to:
  /// **'Muskel finden, welche Übung wofür, typische Fehler, Plan für 6 Wochen'**
  String get kegelTimerViewFindingTheMuscleWhichExercise;

  /// No description provided for @kegelGuideSheetPelvicFloorGuide.
  ///
  /// In de, this message translates to:
  /// **'Beckenboden-Anleitung'**
  String get kegelGuideSheetPelvicFloorGuide;

  /// No description provided for @kegelGuideSheetFindingTheMuscleExercisesPlan.
  ///
  /// In de, this message translates to:
  /// **'Muskel finden, Übungen, Plan'**
  String get kegelGuideSheetFindingTheMuscleExercisesPlan;

  /// No description provided for @kegelGuideSheetFindingTheMuscle.
  ///
  /// In de, this message translates to:
  /// **'1. Den Muskel finden'**
  String get kegelGuideSheetFindingTheMuscle;

  /// No description provided for @kegelGuideSheetBasics.
  ///
  /// In de, this message translates to:
  /// **'GRUNDLAGEN'**
  String get kegelGuideSheetBasics;

  /// No description provided for @kegelGuideSheetThePelvicFloorStretchesLike.
  ///
  /// In de, this message translates to:
  /// **'Der Beckenboden spannt sich wie eine Hängematte zwischen Schambein und Steißbein – bei allen Menschen. Er kann zwei Dinge: heben und halten, und weit werden und loslassen. Beides gehört zum Training.'**
  String get kegelGuideSheetThePelvicFloorStretchesLike;

  /// No description provided for @kegelGuideSheetTightenAndLift.
  ///
  /// In de, this message translates to:
  /// **'Anspannen und heben'**
  String get kegelGuideSheetTightenAndLift;

  /// No description provided for @kegelGuideSheetImagineHoldingBackWindAnd.
  ///
  /// In de, this message translates to:
  /// **'Stell dir vor, du hältst einen Wind zurück und stoppst gleichzeitig den Urinstrahl – nur in der Vorstellung.\n• Mit Vulva: Scheideneingang und Damm ziehen sich sanft nach innen und oben.\n• Mit Penis: Die Peniswurzel hebt sich ein kleines Stück, die Hoden ziehen leicht nach oben.'**
  String get kegelGuideSheetImagineHoldingBackWindAnd;

  /// No description provided for @kegelGuideSheetLetGoAndWiden.
  ///
  /// In de, this message translates to:
  /// **'Loslassen und weit werden'**
  String get kegelGuideSheetLetGoAndWiden;

  /// No description provided for @kegelGuideSheetBreatheDeepIntoTheBelly.
  ///
  /// In de, this message translates to:
  /// **'Atme tief in den Bauch. Während sich der Bauch wölbt, lass den Beckenboden sanft nach unten nachgeben – wie beim Beginn des Wasserlassens, aber ohne zu pressen. Der Bereich zwischen Schambein und Steißbein wird weich und warm.'**
  String get kegelGuideSheetBreatheDeepIntoTheBelly;

  /// No description provided for @kegelGuideSheetButtocksThighsAndBellyStay.
  ///
  /// In de, this message translates to:
  /// **'Po, Oberschenkel und Bauch bleiben locker. Eine Hand auf dem Po verrät, ob er mitarbeitet.'**
  String get kegelGuideSheetButtocksThighsAndBellyStay;

  /// No description provided for @kegelGuideSheetWhichExerciseForWhat.
  ///
  /// In de, this message translates to:
  /// **'2. Welche Übung wofür?'**
  String get kegelGuideSheetWhichExerciseForWhat;

  /// No description provided for @kegelGuideSheetExercises.
  ///
  /// In de, this message translates to:
  /// **'ÜBUNGEN'**
  String get kegelGuideSheetExercises;

  /// No description provided for @kegelGuideSheetForTensionPainOnPenetration.
  ///
  /// In de, this message translates to:
  /// **'bei Anspannung, Schmerzen beim Eindringen, frühem Samenerguss'**
  String get kegelGuideSheetForTensionPainOnPenetration;

  /// No description provided for @kegelGuideSheetForEveryoneWhosePelvicFloor.
  ///
  /// In de, this message translates to:
  /// **'Für alle, deren Beckenboden eher zu viel festhält. Das ist bei Stress, viel Sitzen und Leistungsdruck häufig. Fang hier an, wenn du unsicher bist.'**
  String get kegelGuideSheetForEveryoneWhosePelvicFloor;

  /// No description provided for @kegelGuideSheetForSupportControlAndStability.
  ///
  /// In de, this message translates to:
  /// **'für Halt, Kontrolle und Stabilität'**
  String get kegelGuideSheetForSupportControlAndStability;

  /// No description provided for @kegelGuideSheetStrengthensTheMusclesForExample.
  ///
  /// In de, this message translates to:
  /// **'Stärkt die Muskulatur, etwa nach einer Geburt, bei leichter Blasenschwäche oder für mehr Kontrolle. Mit halber Kraft üben, das Loslassen danach ist genauso wichtig wie das Halten.'**
  String get kegelGuideSheetStrengthensTheMusclesForExample;

  /// No description provided for @kegelGuideSheetForResponsiveness.
  ///
  /// In de, this message translates to:
  /// **'für Reaktionsfähigkeit'**
  String get kegelGuideSheetForResponsiveness;

  /// No description provided for @kegelGuideSheetAShortSqueezeAndImmediate.
  ///
  /// In de, this message translates to:
  /// **'Kurzes An und sofortiges Los trainiert die schnellen Muskelfasern – zum Beispiel für den Moment beim Husten oder Niesen.'**
  String get kegelGuideSheetAShortSqueezeAndImmediate;

  /// No description provided for @kegelGuideSheetStayingLooseWhenItGets.
  ///
  /// In de, this message translates to:
  /// **'locker bleiben, wenn es spannend wird'**
  String get kegelGuideSheetStayingLooseWhenItGets;

  /// No description provided for @kegelGuideSheetALongAudibleExhaleWith.
  ///
  /// In de, this message translates to:
  /// **'Langes, hörbares Ausatmen mit weichem Damm und Po. Genau das hilft beim Wellen-Surfen aus den Kursen 8 und 9, die Erregung hoch zu halten, ohne dass sie überläuft.'**
  String get kegelGuideSheetALongAudibleExhaleWith;

  /// No description provided for @kegelGuideSheetCommonMistakes.
  ///
  /// In de, this message translates to:
  /// **'3. Typische Fehler'**
  String get kegelGuideSheetCommonMistakes;

  /// No description provided for @kegelGuideSheetCareful.
  ///
  /// In de, this message translates to:
  /// **'ACHTUNG'**
  String get kegelGuideSheetCareful;

  /// No description provided for @kegelGuideSheetSqueezingTheButtocks.
  ///
  /// In de, this message translates to:
  /// **'Den Po zusammenkneifen'**
  String get kegelGuideSheetSqueezingTheButtocks;

  /// No description provided for @kegelGuideSheetTheBigGlutealMuscleLikes.
  ///
  /// In de, this message translates to:
  /// **'Der große Gesäßmuskel mogelt sich gern hinein. Der Po bleibt weich.'**
  String get kegelGuideSheetTheBigGlutealMuscleLikes;

  /// No description provided for @kegelGuideSheetHoldingYourBreath.
  ///
  /// In de, this message translates to:
  /// **'Die Luft anhalten'**
  String get kegelGuideSheetHoldingYourBreath;

  /// No description provided for @kegelGuideSheetKeepBreathingCalmlyWhileHolding.
  ///
  /// In de, this message translates to:
  /// **'Atme beim Halten ruhig weiter. Angehaltener Atem erhöht den Druck im Bauch.'**
  String get kegelGuideSheetKeepBreathingCalmlyWhileHolding;

  /// No description provided for @kegelGuideSheetPushingInsteadOfLettingGo.
  ///
  /// In de, this message translates to:
  /// **'Pressen statt loslassen'**
  String get kegelGuideSheetPushingInsteadOfLettingGo;

  /// No description provided for @kegelGuideSheetWhenLettingGoNothingIs.
  ///
  /// In de, this message translates to:
  /// **'Beim Loslassen wird nichts nach unten gedrückt. Es ist ein Nachgeben, kein Schieben.'**
  String get kegelGuideSheetWhenLettingGoNothingIs;

  /// No description provided for @kegelGuideSheetPractisingWhileActuallyUrinating.
  ///
  /// In de, this message translates to:
  /// **'Beim echten Wasserlassen üben'**
  String get kegelGuideSheetPractisingWhileActuallyUrinating;

  /// No description provided for @kegelGuideSheetRegularlyStoppingTheFlowOf.
  ///
  /// In de, this message translates to:
  /// **'Den Urinstrahl regelmäßig zu stoppen kann die Blasenentleerung stören. Nur in der Vorstellung üben.'**
  String get kegelGuideSheetRegularlyStoppingTheFlowOf;

  /// No description provided for @kegelGuideSheetBetterShortAndRegular.
  ///
  /// In de, this message translates to:
  /// **'Lieber kurz und regelmäßig'**
  String get kegelGuideSheetBetterShortAndRegular;

  /// No description provided for @kegelGuideSheetAFewMinutesOnMost.
  ///
  /// In de, this message translates to:
  /// **'Ein paar Minuten an den meisten Tagen bringen mehr als selten eine lange Einheit.'**
  String get kegelGuideSheetAFewMinutesOnMost;

  /// No description provided for @kegelGuideSheetAPlanForSixWeeks.
  ///
  /// In de, this message translates to:
  /// **'4. Ein Plan für sechs Wochen'**
  String get kegelGuideSheetAPlanForSixWeeks;

  /// No description provided for @kegelGuideSheetPlan.
  ///
  /// In de, this message translates to:
  /// **'PLAN'**
  String get kegelGuideSheetPlan;

  /// No description provided for @kegelGuideSheetWeek.
  ///
  /// In de, this message translates to:
  /// **'Woche 1–2'**
  String get kegelGuideSheetWeek;

  /// No description provided for @kegelGuideSheetLetGoDailyRoundsEasy.
  ///
  /// In de, this message translates to:
  /// **'Täglich Loslassen, 5 Runden, Stufe leicht. Ziel: das Weitwerden sicher spüren.'**
  String get kegelGuideSheetLetGoDailyRoundsEasy;

  /// No description provided for @kegelGuideSheetWeek2.
  ///
  /// In de, this message translates to:
  /// **'Woche 3–4'**
  String get kegelGuideSheetWeek2;

  /// No description provided for @kegelGuideSheetLetGoRoundsThenStrengthen.
  ///
  /// In de, this message translates to:
  /// **'Loslassen 5 Runden, danach Kräftigen 5 Runden, Stufe leicht. An zwei Tagen Wellen.'**
  String get kegelGuideSheetLetGoRoundsThenStrengthen;

  /// No description provided for @kegelGuideSheetWeek3.
  ///
  /// In de, this message translates to:
  /// **'Woche 5–6'**
  String get kegelGuideSheetWeek3;

  /// No description provided for @kegelGuideSheetRoundsOfYourMainExercise.
  ///
  /// In de, this message translates to:
  /// **'10 Runden in deiner Hauptübung, Stufe mittel. Dazu ein paar Schnelle Impulse.'**
  String get kegelGuideSheetRoundsOfYourMainExercise;

  /// No description provided for @kegelGuideSheetAfterThatKeepTwoOr.
  ///
  /// In de, this message translates to:
  /// **'Danach: Behalte zwei, drei kurze Einheiten pro Woche bei. Und nutze das Loslassen bewusst in intimen Momenten – tief in den Bauch atmen, den Beckenboden sinken lassen.'**
  String get kegelGuideSheetAfterThatKeepTwoOr;

  /// No description provided for @kegelGuideSheetWhenToSeeAPhysiotherapist.
  ///
  /// In de, this message translates to:
  /// **'5. Wann zur Physiotherapie?'**
  String get kegelGuideSheetWhenToSeeAPhysiotherapist;

  /// No description provided for @kegelGuideSheetHealth.
  ///
  /// In de, this message translates to:
  /// **'GESUNDHEIT'**
  String get kegelGuideSheetHealth;

  /// No description provided for @kegelGuideSheetSpecialisedPelvicFloorPhysiotherapyCan.
  ///
  /// In de, this message translates to:
  /// **'Eine spezialisierte Beckenboden-Physiotherapie kann genau untersuchen, ob dein Beckenboden eher zu schwach oder zu fest ist, und dich gezielt anleiten. Lass dich beraten bei:\n• Schmerzen im Becken, beim Sex oder beim Training\n• Blasen- oder Darmschwäche\n• Beschwerden nach einer Geburt oder einer Operation im Becken\n• dem Gefühl, den Muskel gar nicht ansteuern zu können'**
  String get kegelGuideSheetSpecialisedPelvicFloorPhysiotherapyCan;

  /// No description provided for @kegelGuideSheetBackToTraining.
  ///
  /// In de, this message translates to:
  /// **'Zurück zum Training'**
  String get kegelGuideSheetBackToTraining;

  /// No description provided for @aiCoachAsAWomanHowDo.
  ///
  /// In de, this message translates to:
  /// **'Wie entspanne ich als Frau meinen Beckenboden beim Sex?'**
  String get aiCoachAsAWomanHowDo;

  /// No description provided for @aiCoachHowCanWeStopPerformance.
  ///
  /// In de, this message translates to:
  /// **'Wie stoppen wir zu zweit den Leistungsdruck im Bett?'**
  String get aiCoachHowCanWeStopPerformance;

  /// No description provided for @aiCoachWhatToDoAboutRacing.
  ///
  /// In de, this message translates to:
  /// **'Was tun bei akutem Kopfkino & Spectatoring?'**
  String get aiCoachWhatToDoAboutRacing;

  /// No description provided for @aiCoachHowDoIExplainResponsive.
  ///
  /// In de, this message translates to:
  /// **'Wie erkläre ich meinem Partner die responsive Lust?'**
  String get aiCoachHowDoIExplainResponsive;

  /// No description provided for @aiCoachWhyDoesTheReverseKegel.
  ///
  /// In de, this message translates to:
  /// **'Warum hilft der Reverse Kegel bei Nervosität?'**
  String get aiCoachWhyDoesTheReverseKegel;

  /// No description provided for @aiCoachWelcomeToConfidentialSomaticRelationship.
  ///
  /// In de, this message translates to:
  /// **'Willkommen im vertraulichen Somatik- & Beziehungs-Coaching. Ich begleite euch – ob als Frau, Mann oder als Paar – bei allen Fragen zu Beckenboden-Entspannung, Überwindung von Kopfkino und Leistungsdruck, Scham und erfüllender, absichtsloser Intimität.\n\nWorüber möchtet ihr sprechen oder was beschäftigt dein Nervensystem gerade am meisten?'**
  String get aiCoachWelcomeToConfidentialSomaticRelationship;

  /// No description provided for @aiCoachPleaseAddYourGeminiApi.
  ///
  /// In de, this message translates to:
  /// **'Bitte hinterlege zuerst deinen Gemini API-Key, um mit dem Coach zu schreiben.'**
  String get aiCoachPleaseAddYourGeminiApi;

  /// No description provided for @aiCoachNoApiKeyAddedPlease.
  ///
  /// In de, this message translates to:
  /// **'Kein API-Key hinterlegt. Bitte klicke oben auf das Zahnrad-Symbol.'**
  String get aiCoachNoApiKeyAddedPlease;

  /// No description provided for @aiCoachGoogleRejectedTheApiKey.
  ///
  /// In de, this message translates to:
  /// **'Der API-Key wurde von Google als ungültig abgelehnt. Bitte überprüfe den Key im Google AI Studio.'**
  String get aiCoachGoogleRejectedTheApiKey;

  /// No description provided for @aiCoachConnectionErrorCleanerr.
  ///
  /// In de, this message translates to:
  /// **'Verbindungsfehler: {cleanErr}'**
  String aiCoachConnectionErrorCleanerr(Object cleanErr);

  /// No description provided for @aiCoachCheckKey.
  ///
  /// In de, this message translates to:
  /// **'Key prüfen'**
  String get aiCoachCheckKey;

  /// No description provided for @aiCoachGeminiApiKey.
  ///
  /// In de, this message translates to:
  /// **'Gemini API-Key'**
  String get aiCoachGeminiApiKey;

  /// No description provided for @aiCoachPrivateCoachingUsesGoogleGemini.
  ///
  /// In de, this message translates to:
  /// **'Für das private Coaching wird Google Gemini verwendet. Der Key liegt verschlüsselt nur auf deinem Smartphone; deine Nachrichten und Profilangaben gehen zur Beantwortung an Google. In der EU, der Schweiz und Großbritannien nutzt Google sie laut seinen Bedingungen nicht zur Verbesserung seiner Produkte; anderswo kann Google Anfragen aus dem kostenlosen Kontingent auswerten.'**
  String get aiCoachPrivateCoachingUsesGoogleGemini;

  /// No description provided for @aiCoachFreeViaAistudioGoogleCom.
  ///
  /// In de, this message translates to:
  /// **'Kostenlos via aistudio.google.com'**
  String get aiCoachFreeViaAistudioGoogleCom;

  /// No description provided for @aiCoachShowGuide.
  ///
  /// In de, this message translates to:
  /// **'Anleitung anzeigen'**
  String get aiCoachShowGuide;

  /// No description provided for @aiCoachPleaseEnterAKeyFirst.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib zuerst einen Key ein.'**
  String get aiCoachPleaseEnterAKeyFirst;

  /// No description provided for @aiCoachCheckingConnection.
  ///
  /// In de, this message translates to:
  /// **'Prüfe Verbindung...'**
  String get aiCoachCheckingConnection;

  /// No description provided for @aiCoachTestConnection.
  ///
  /// In de, this message translates to:
  /// **'Verbindung testen'**
  String get aiCoachTestConnection;

  /// No description provided for @aiCoachApiKeyRemoved.
  ///
  /// In de, this message translates to:
  /// **'API-Key entfernt.'**
  String get aiCoachApiKeyRemoved;

  /// No description provided for @aiCoachApiKeySaved.
  ///
  /// In de, this message translates to:
  /// **'API-Key erfolgreich gespeichert.'**
  String get aiCoachApiKeySaved;

  /// No description provided for @aiCoachClearChatHistory.
  ///
  /// In de, this message translates to:
  /// **'Chatverlauf leeren?'**
  String get aiCoachClearChatHistory;

  /// No description provided for @aiCoachDoYouWantToDelete.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du alle bisherigen Nachrichten dieses Dialogs löschen?'**
  String get aiCoachDoYouWantToDelete;

  /// No description provided for @aiCoachChatHistoryClearedWhatWould.
  ///
  /// In de, this message translates to:
  /// **'Chatverlauf zurückgesetzt. Worüber möchtest du sprechen?'**
  String get aiCoachChatHistoryClearedWhatWould;

  /// No description provided for @aiCoachClear.
  ///
  /// In de, this message translates to:
  /// **'Leeren'**
  String get aiCoachClear;

  /// No description provided for @aiCoachGeminiAiConnected.
  ///
  /// In de, this message translates to:
  /// **'Gemini KI verbunden'**
  String get aiCoachGeminiAiConnected;

  /// No description provided for @aiCoachNoApiKeyAdded.
  ///
  /// In de, this message translates to:
  /// **'Kein API-Key hinterlegt'**
  String get aiCoachNoApiKeyAdded;

  /// No description provided for @aiCoachGuideCreateAKey.
  ///
  /// In de, this message translates to:
  /// **'Anleitung: Key erstellen'**
  String get aiCoachGuideCreateAKey;

  /// No description provided for @aiCoachClearChat.
  ///
  /// In de, this message translates to:
  /// **'Chat leeren'**
  String get aiCoachClearChat;

  /// No description provided for @aiCoachApiKeySettings.
  ///
  /// In de, this message translates to:
  /// **'API-Key Einstellungen'**
  String get aiCoachApiKeySettings;

  /// No description provided for @aiCoachNoApiKeyYetCreated.
  ///
  /// In de, this message translates to:
  /// **'Noch kein API-Key? In 2 Min. kostenlos erstellt.'**
  String get aiCoachNoApiKeyYetCreated;

  /// No description provided for @aiCoachGuide.
  ///
  /// In de, this message translates to:
  /// **'Anleitung'**
  String get aiCoachGuide;

  /// No description provided for @aiCoachCoachIsThinking.
  ///
  /// In de, this message translates to:
  /// **'Coach reflektiert...'**
  String get aiCoachCoachIsThinking;

  /// No description provided for @aiCoachAskAConfidentialQuestion.
  ///
  /// In de, this message translates to:
  /// **'Vertrauliche Frage stellen...'**
  String get aiCoachAskAConfidentialQuestion;

  /// No description provided for @apiKeyGuideSheetFreeGeminiApiKey.
  ///
  /// In de, this message translates to:
  /// **'Kostenlosen Gemini API-Key'**
  String get apiKeyGuideSheetFreeGeminiApiKey;

  /// No description provided for @apiKeyGuideSheetCreatedStepByStepIn.
  ///
  /// In de, this message translates to:
  /// **'Schritt-für-Schritt in 2 Minuten erstellt'**
  String get apiKeyGuideSheetCreatedStepByStepIn;

  /// No description provided for @apiKeyGuideSheetFreeAndWhatHappensTo.
  ///
  /// In de, this message translates to:
  /// **'Kostenlos – und was mit deinen Daten passiert: '**
  String get apiKeyGuideSheetFreeAndWhatHappensTo;

  /// No description provided for @apiKeyGuideSheetGoogleAiStudioHasA.
  ///
  /// In de, this message translates to:
  /// **'Google AI Studio hat ein kostenloses Kontingent. Dein Key bleibt verschlüsselt auf deinem Smartphone. Deine Nachrichten, dein Name, Alter, Geschlecht, Beziehungsstatus und Fokus gehen zur Beantwortung an Google. In der EU, der Schweiz und Großbritannien nutzt Google sie laut seinen Bedingungen nicht, um seine Produkte zu verbessern. Anderswo darf Google Anfragen aus dem kostenlosen Kontingent dafür auswerten und von Menschen lesen lassen.'**
  String get apiKeyGuideSheetGoogleAiStudioHasA;

  /// No description provided for @apiKeyGuideSheetOpenGoogleAiStudio.
  ///
  /// In de, this message translates to:
  /// **'Google AI Studio aufrufen'**
  String get apiKeyGuideSheetOpenGoogleAiStudio;

  /// No description provided for @apiKeyGuideSheetOpenGoogleSOfficialDeveloper.
  ///
  /// In de, this message translates to:
  /// **'Öffne im Browser (Chrome, Safari, Firefox) die offizielle Entwickler-Plattform von Google:\n'**
  String get apiKeyGuideSheetOpenGoogleSOfficialDeveloper;

  /// No description provided for @apiKeyGuideSheetLinkCopiedToClipboard.
  ///
  /// In de, this message translates to:
  /// **'Link in Zwischenablage kopiert!'**
  String get apiKeyGuideSheetLinkCopiedToClipboard;

  /// No description provided for @apiKeyGuideSheetCopy.
  ///
  /// In de, this message translates to:
  /// **'Kopieren'**
  String get apiKeyGuideSheetCopy;

  /// No description provided for @apiKeyGuideSheetSignInWithAGoogle.
  ///
  /// In de, this message translates to:
  /// **'Mit Google-Konto anmelden'**
  String get apiKeyGuideSheetSignInWithAGoogle;

  /// No description provided for @apiKeyGuideSheetSignInWithYourExisting.
  ///
  /// In de, this message translates to:
  /// **'Melde dich mit deinem bestehenden Google-Konto (Gmail) an. Es ist keine Kreditkarte oder Zahlungsmethode erforderlich.'**
  String get apiKeyGuideSheetSignInWithYourExisting;

  /// No description provided for @apiKeyGuideSheetClickGetApiKey.
  ///
  /// In de, this message translates to:
  /// **'\"Get API key\" anklicken'**
  String get apiKeyGuideSheetClickGetApiKey;

  /// No description provided for @apiKeyGuideSheetInTheMenuAtThe.
  ///
  /// In de, this message translates to:
  /// **'Klicke im Menü links oben auf den blauen Button \"Get API key\" (oder \"API-Schlüssel anfordern\").'**
  String get apiKeyGuideSheetInTheMenuAtThe;

  /// No description provided for @apiKeyGuideSheetChooseCreateApiKeyIn.
  ///
  /// In de, this message translates to:
  /// **'\"Create API key in new project\" wählen'**
  String get apiKeyGuideSheetChooseCreateApiKeyIn;

  /// No description provided for @apiKeyGuideSheetChooseTheOptionCreateApi.
  ///
  /// In de, this message translates to:
  /// **'Wähle die Option \"Create API key in new project\". Google richtet sofort automatisch im Hintergrund ein kostenloses Projekt ein.'**
  String get apiKeyGuideSheetChooseTheOptionCreateApi;

  /// No description provided for @apiKeyGuideSheetCopyTheKeyPasteIt.
  ///
  /// In de, this message translates to:
  /// **'Key kopieren & in VelvetPulse einfügen'**
  String get apiKeyGuideSheetCopyTheKeyPasteIt;

  /// No description provided for @apiKeyGuideSheetCopyTheGeneratedStringIt.
  ///
  /// In de, this message translates to:
  /// **'Kopiere die erzeugte Zeichenkette. Sie beginnt typischerweise mit \"AIzaSy...\" – füge sie anschließend hier in die App ein.'**
  String get apiKeyGuideSheetCopyTheGeneratedStringIt;

  /// No description provided for @apiKeyGuideSheetFrequentlyAskedQuestions.
  ///
  /// In de, this message translates to:
  /// **'Häufige Fragen:'**
  String get apiKeyGuideSheetFrequentlyAskedQuestions;

  /// No description provided for @apiKeyGuideSheetDoesItCostAnything.
  ///
  /// In de, this message translates to:
  /// **'Kostet die Nutzung etwas?'**
  String get apiKeyGuideSheetDoesItCostAnything;

  /// No description provided for @apiKeyGuideSheetNotWithinTheFreeTier.
  ///
  /// In de, this message translates to:
  /// **'Im kostenlosen Kontingent (Free Tier) von Google AI Studio nicht. Umfang und Bedingungen legt Google fest und kann sie ändern.'**
  String get apiKeyGuideSheetNotWithinTheFreeTier;

  /// No description provided for @apiKeyGuideSheetWhichModelIsUsed.
  ///
  /// In de, this message translates to:
  /// **'Welches Modell wird genutzt?'**
  String get apiKeyGuideSheetWhichModelIsUsed;

  /// No description provided for @apiKeyGuideSheetVelvetpulseAutomaticallyFindsTheLatest.
  ///
  /// In de, this message translates to:
  /// **'VelvetPulse ermittelt automatisch die aktuellsten aktiven Gemini-Modelle (bevorzugt die schnellen Flash-Modelle) über deinen Key.'**
  String get apiKeyGuideSheetVelvetpulseAutomaticallyFindsTheLatest;

  /// No description provided for @apiKeyGuideSheetEnterApiKeyConnectNow.
  ///
  /// In de, this message translates to:
  /// **'API-Key jetzt eintragen & verbinden'**
  String get apiKeyGuideSheetEnterApiKeyConnectNow;

  /// No description provided for @dailyCheckinCardVeryCalm.
  ///
  /// In de, this message translates to:
  /// **'Sehr ruhig'**
  String get dailyCheckinCardVeryCalm;

  /// No description provided for @dailyCheckinCardMild.
  ///
  /// In de, this message translates to:
  /// **'Leicht'**
  String get dailyCheckinCardMild;

  /// No description provided for @dailyCheckinCardModerate.
  ///
  /// In de, this message translates to:
  /// **'Mäßig'**
  String get dailyCheckinCardModerate;

  /// No description provided for @dailyCheckinCardHigh.
  ///
  /// In de, this message translates to:
  /// **'Hoch'**
  String get dailyCheckinCardHigh;

  /// No description provided for @dailyCheckinCardExtremeStress.
  ///
  /// In de, this message translates to:
  /// **'Extremer Stress'**
  String get dailyCheckinCardExtremeStress;

  /// No description provided for @dailyCheckinCardClearHead.
  ///
  /// In de, this message translates to:
  /// **'Frei im Kopf'**
  String get dailyCheckinCardClearHead;

  /// No description provided for @dailyCheckinCardHardlyAnyPressure.
  ///
  /// In de, this message translates to:
  /// **'Kaum Druck'**
  String get dailyCheckinCardHardlyAnyPressure;

  /// No description provided for @dailyCheckinCardSomeRestlessness.
  ///
  /// In de, this message translates to:
  /// **'Unruhe da'**
  String get dailyCheckinCardSomeRestlessness;

  /// No description provided for @dailyCheckinCardNoticeablyHigh.
  ///
  /// In de, this message translates to:
  /// **'Spürbar hoch'**
  String get dailyCheckinCardNoticeablyHigh;

  /// No description provided for @dailyCheckinCardStrongPressure.
  ///
  /// In de, this message translates to:
  /// **'Starker Druck'**
  String get dailyCheckinCardStrongPressure;

  /// No description provided for @dailyCheckinCardSecondDailyCheckIn.
  ///
  /// In de, this message translates to:
  /// **'30-Sekunden Tages-Check-in'**
  String get dailyCheckinCardSecondDailyCheckIn;

  /// No description provided for @dailyCheckinCardDone.
  ///
  /// In de, this message translates to:
  /// **'Erledigt'**
  String get dailyCheckinCardDone;

  /// No description provided for @dailyCheckinCardStressStresslevelPressurePressurelevel.
  ///
  /// In de, this message translates to:
  /// **'Stress: {stressLevel} • Druck: {pressureLevel}'**
  String dailyCheckinCardStressStresslevelPressurePressurelevel(
      Object stressLevel, Object pressureLevel);

  /// No description provided for @dailyCheckinCardHowDoStressPerformancePressure.
  ///
  /// In de, this message translates to:
  /// **'Wie geht es dir heute?'**
  String get dailyCheckinCardHowDoStressPerformancePressure;

  /// No description provided for @dailyCheckinCardEverydayStressTodayJobAppointments.
  ///
  /// In de, this message translates to:
  /// **'1. Alltagsstress heute (Job, Termine, Schlaf)'**
  String get dailyCheckinCardEverydayStressTodayJobAppointments;

  /// No description provided for @dailyCheckinCardInnerPerformancePressureRacingThoughts.
  ///
  /// In de, this message translates to:
  /// **'2. Wie viel Druck spürst du innerlich?'**
  String get dailyCheckinCardInnerPerformancePressureRacingThoughts;

  /// No description provided for @dailyCheckinCardWhatDidYouGoodToday.
  ///
  /// In de, this message translates to:
  /// **'3. Was hat dir heute gut getan?'**
  String get dailyCheckinCardWhatDidYouGoodToday;

  /// No description provided for @dailyCheckinCardSaveDailyCheckIn.
  ///
  /// In de, this message translates to:
  /// **'Tages-Check-in speichern'**
  String get dailyCheckinCardSaveDailyCheckIn;

  /// No description provided for @dailyCheckinCardUpdateValues.
  ///
  /// In de, this message translates to:
  /// **'Werte aktualisieren'**
  String get dailyCheckinCardUpdateValues;

  /// No description provided for @dailyCheckinCardCoachingInsightYourEverydayStress.
  ///
  /// In de, this message translates to:
  /// **'Dein Alltagsstress ist heute hoch. Das ist okay: Stress und Erschöpfung bremsen die Lust oft ganz von selbst. Das ist normal und kein Fehler von dir.'**
  String get dailyCheckinCardCoachingInsightYourEverydayStress;

  /// No description provided for @dailyCheckinCardCoachingInsightWhenEverydayStress.
  ///
  /// In de, this message translates to:
  /// **'Wenn der Alltag ruhiger ist, fällt Entspannen oft leichter. Wenn du magst, spür heute einfach in deinen Körper, ganz ohne Ziel.'**
  String get dailyCheckinCardCoachingInsightWhenEverydayStress;

  /// No description provided for @onboardingGuest.
  ///
  /// In de, this message translates to:
  /// **'Gast'**
  String get onboardingGuest;

  /// No description provided for @onboardingProfileUpdated.
  ///
  /// In de, this message translates to:
  /// **'Profil erfolgreich aktualisiert.'**
  String get onboardingProfileUpdated;

  /// No description provided for @onboardingRestoreBackup.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wiederherstellen'**
  String get onboardingRestoreBackup;

  /// No description provided for @onboardingRestoreYourProfileLessonsCouple.
  ///
  /// In de, this message translates to:
  /// **'Stelle dein Profil, Lektionen & Nostr-Kanal wieder her'**
  String get onboardingRestoreYourProfileLessonsCouple;

  /// No description provided for @onboardingBackupFoundOnThisDevice.
  ///
  /// In de, this message translates to:
  /// **'Sicherung auf dem Gerät gefunden!'**
  String get onboardingBackupFoundOnThisDevice;

  /// No description provided for @onboardingProfileProfilename.
  ///
  /// In de, this message translates to:
  /// **'Profil: {profileName}'**
  String onboardingProfileProfilename(Object profileName);

  /// No description provided for @onboardingRestoreAutomaticBackupNow.
  ///
  /// In de, this message translates to:
  /// **'Automatische Sicherung jetzt einspielen'**
  String get onboardingRestoreAutomaticBackupNow;

  /// No description provided for @onboardingReadyInClipboard.
  ///
  /// In de, this message translates to:
  /// **'IN ZWISCHENABLAGE BEREIT'**
  String get onboardingReadyInClipboard;

  /// No description provided for @onboardingBackupForProfilename.
  ///
  /// In de, this message translates to:
  /// **'Sicherung für: „{profileName}“'**
  String onboardingBackupForProfilename(Object profileName);

  /// No description provided for @onboardingRestoreFromClipboard.
  ///
  /// In de, this message translates to:
  /// **'Aus Zwischenablage einspielen'**
  String get onboardingRestoreFromClipboard;

  /// No description provided for @onboardingPasteBackupCodeJsonManually.
  ///
  /// In de, this message translates to:
  /// **'Backup-Code / JSON manuell einfügen:'**
  String get onboardingPasteBackupCodeJsonManually;

  /// No description provided for @onboardingPasteJsonTextHereE.
  ///
  /// In de, this message translates to:
  /// **'Hier den Text der Sicherung einfügen (beginnt mit \"app\": \"VelvetPulse\")'**
  String get onboardingPasteJsonTextHereE;

  /// No description provided for @onboardingPleasePasteTheBackupJson.
  ///
  /// In de, this message translates to:
  /// **'Bitte füge zuerst den Backup-JSON-Text ein.'**
  String get onboardingPleasePasteTheBackupJson;

  /// No description provided for @onboardingApplyBackupNow.
  ///
  /// In de, this message translates to:
  /// **'Sicherung jetzt anwenden'**
  String get onboardingApplyBackupNow;

  /// No description provided for @onboardingTheBackupCouldNotBe.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung konnte nicht eingespielt werden.'**
  String get onboardingTheBackupCouldNotBe;

  /// No description provided for @onboardingUser.
  ///
  /// In de, this message translates to:
  /// **'Nutzer'**
  String get onboardingUser;

  /// No description provided for @onboardingBackupForNameRestored.
  ///
  /// In de, this message translates to:
  /// **'Sicherung für \"{name}\" erfolgreich eingespielt!'**
  String onboardingBackupForNameRestored(Object name);

  /// No description provided for @onboardingProfilePersonalisation.
  ///
  /// In de, this message translates to:
  /// **'Profil & Personalisierung'**
  String get onboardingProfilePersonalisation;

  /// No description provided for @onboardingWelcomeToVelvetpulse.
  ///
  /// In de, this message translates to:
  /// **'Willkommen bei VelvetPulse'**
  String get onboardingWelcomeToVelvetpulse;

  /// No description provided for @onboardingYourPrivateCoachingProgrammeFor.
  ///
  /// In de, this message translates to:
  /// **'Ein privater Begleiter für Ruhe im Körper, Beckenboden und Nähe.'**
  String get onboardingYourPrivateCoachingProgrammeFor;

  /// No description provided for @onboardingPrivateProfileJournalProgressStay.
  ///
  /// In de, this message translates to:
  /// **'Privat: Profil, Tagebuch & Fortschritt bleiben auf deinem Smartphone. Ins Internet gehen nur der KI-Coach (Google Gemini), der verschlüsselte Paar-Kanal und die Suche nach Updates (GitHub).'**
  String get onboardingPrivateProfileJournalProgressStay;

  /// No description provided for @onboardingAlreadyUsingVelvetpulse.
  ///
  /// In de, this message translates to:
  /// **'Bereits VelvetPulse-Nutzer?'**
  String get onboardingAlreadyUsingVelvetpulse;

  /// No description provided for @onboardingLoadABackupFromFile.
  ///
  /// In de, this message translates to:
  /// **'Sicherung aus Datei oder Zwischenablage laden'**
  String get onboardingLoadABackupFromFile;

  /// No description provided for @onboardingRestore.
  ///
  /// In de, this message translates to:
  /// **'Wiederherstellen'**
  String get onboardingRestore;

  /// No description provided for @onboardingWhatShouldWeCallYou.
  ///
  /// In de, this message translates to:
  /// **'1. Wie dürfen wir dich ansprechen?'**
  String get onboardingWhatShouldWeCallYou;

  /// No description provided for @onboardingYourFirstNameOrA.
  ///
  /// In de, this message translates to:
  /// **'Dein Vorname oder Pseudonym'**
  String get onboardingYourFirstNameOrA;

  /// No description provided for @onboardingYourGender.
  ///
  /// In de, this message translates to:
  /// **'2. Dein Geschlecht'**
  String get onboardingYourGender;

  /// No description provided for @onboardingAdjustsCourseRecommendationsPelvicFloor.
  ///
  /// In de, this message translates to:
  /// **'Passt Kursempfehlungen, Beckenboden-Physiologie und KI-Antworten an.'**
  String get onboardingAdjustsCourseRecommendationsPelvicFloor;

  /// No description provided for @onboardingMale.
  ///
  /// In de, this message translates to:
  /// **'Männlich'**
  String get onboardingMale;

  /// No description provided for @onboardingFemale.
  ///
  /// In de, this message translates to:
  /// **'Weiblich'**
  String get onboardingFemale;

  /// No description provided for @onboardingYourAgeSelectedageYears.
  ///
  /// In de, this message translates to:
  /// **'3. Dein Alter: {selectedAge} Jahre'**
  String onboardingYourAgeSelectedageYears(Object selectedAge);

  /// No description provided for @onboardingYourRelationshipStatus.
  ///
  /// In de, this message translates to:
  /// **'4. Dein Beziehungsstatus'**
  String get onboardingYourRelationshipStatus;

  /// No description provided for @onboardingInARelationshipMarried.
  ///
  /// In de, this message translates to:
  /// **'In fester Beziehung / Verheiratet'**
  String get onboardingInARelationshipMarried;

  /// No description provided for @onboardingDatingGettingToKnowSomeone.
  ///
  /// In de, this message translates to:
  /// **'Dating / Kennenlernphase'**
  String get onboardingDatingGettingToKnowSomeone;

  /// No description provided for @onboardingSingle.
  ///
  /// In de, this message translates to:
  /// **'Single'**
  String get onboardingSingle;

  /// No description provided for @onboardingItSComplicated.
  ///
  /// In de, this message translates to:
  /// **'Es ist kompliziert'**
  String get onboardingItSComplicated;

  /// No description provided for @onboardingWhatSYourBiggestPriority.
  ///
  /// In de, this message translates to:
  /// **'5. Was wünschst du dir im Moment am meisten?'**
  String get onboardingWhatSYourBiggestPriority;

  /// No description provided for @onboardingStopPerformancePressureRacingThoughts.
  ///
  /// In de, this message translates to:
  /// **'Weniger Druck, ein ruhigerer Kopf'**
  String get onboardingStopPerformancePressureRacingThoughts;

  /// No description provided for @onboardingBreakThoughtLoopsStopSpectatoring.
  ///
  /// In de, this message translates to:
  /// **'Aus dem Kopf zurück ins Spüren, ohne dich selbst zu beobachten.'**
  String get onboardingBreakThoughtLoopsStopSpectatoring;

  /// No description provided for @onboardingPelvicFloorRelaxationBodyAwareness.
  ///
  /// In de, this message translates to:
  /// **'Beckenboden entspannen & den Körper spüren'**
  String get onboardingPelvicFloorRelaxationBodyAwareness;

  /// No description provided for @onboardingReleaseTensionPractiseReverseKegels.
  ///
  /// In de, this message translates to:
  /// **'Anspannung loslassen, den Beckenboden weich werden lassen, zur Ruhe kommen.'**
  String get onboardingReleaseTensionPractiseReverseKegels;

  /// No description provided for @onboardingCoupleIntimacyPressureFreeSex.
  ///
  /// In de, this message translates to:
  /// **'Nähe zu zweit, ohne Druck'**
  String get onboardingCoupleIntimacyPressureFreeSex;

  /// No description provided for @onboardingSensateFocusTogetherCalmingEach.
  ///
  /// In de, this message translates to:
  /// **'Berührung ohne Ziel, gemeinsam zur Ruhe kommen, sich nahe sein dürfen.'**
  String get onboardingSensateFocusTogetherCalmingEach;

  /// No description provided for @onboardingDesireSelfAcceptanceBodyAwareness.
  ///
  /// In de, this message translates to:
  /// **'Lust, dich annehmen & deinen Körper spüren'**
  String get onboardingDesireSelfAcceptanceBodyAwareness;

  /// No description provided for @onboardingUnderstandResponsiveDesireEaseOrgasm.
  ///
  /// In de, this message translates to:
  /// **'Verstehen, wie Lust bei dir entsteht, und den Druck herausnehmen.'**
  String get onboardingUnderstandResponsiveDesireEaseOrgasm;

  /// No description provided for @onboardingSaveChanges.
  ///
  /// In de, this message translates to:
  /// **'Änderungen speichern'**
  String get onboardingSaveChanges;

  /// No description provided for @onboardingPersonaliseProgrammeNow.
  ///
  /// In de, this message translates to:
  /// **'Fertig, los geht\'s'**
  String get onboardingPersonaliseProgrammeNow;

  /// No description provided for @onboardingSkipGoStraightToThe.
  ///
  /// In de, this message translates to:
  /// **'Später, direkt zur App'**
  String get onboardingSkipGoStraightToThe;

  /// No description provided for @onboardingVersionData.
  ///
  /// In de, this message translates to:
  /// **'Version {data}'**
  String onboardingVersionData(Object data);

  /// No description provided for @onboardingCheckForUpdates.
  ///
  /// In de, this message translates to:
  /// **'Nach Updates suchen'**
  String get onboardingCheckForUpdates;

  /// No description provided for @onboardingReceiveBetaVersions.
  ///
  /// In de, this message translates to:
  /// **'Beta-Versionen erhalten'**
  String get onboardingReceiveBetaVersions;

  /// No description provided for @onboardingYouGetNewFeaturesEarlier.
  ///
  /// In de, this message translates to:
  /// **'Du bekommst neue Funktionen früher, dafür vielleicht mit kleinen Fehlern.'**
  String get onboardingYouGetNewFeaturesEarlier;

  /// No description provided for @onboardingOnlyTestedVersionsWhenSwitching.
  ///
  /// In de, this message translates to:
  /// **'Nur geprüfte Versionen. Beim Zurückwechseln von Beta bleibt deine Version, bis eine neuere stabile erscheint.'**
  String get onboardingOnlyTestedVersionsWhenSwitching;

  /// No description provided for @onboardingDiscretion.
  ///
  /// In de, this message translates to:
  /// **'Diskretion'**
  String get onboardingDiscretion;

  /// No description provided for @onboardingLockWithFingerprint.
  ///
  /// In de, this message translates to:
  /// **'Mit Fingerabdruck sperren'**
  String get onboardingLockWithFingerprint;

  /// No description provided for @onboardingOnOpeningAndAfterOne.
  ///
  /// In de, this message translates to:
  /// **'Beim Öffnen und nach einer Minute im Hintergrund. Inhalte sind in der App-Übersicht verborgen, Screenshots gesperrt.'**
  String get onboardingOnOpeningAndAfterOne;

  /// No description provided for @onboardingNoScreenLockIsSet.
  ///
  /// In de, this message translates to:
  /// **'Auf diesem Gerät ist keine Displaysperre eingerichtet.'**
  String get onboardingNoScreenLockIsSet;

  /// No description provided for @onboardingTheAppIsNowCalled.
  ///
  /// In de, this message translates to:
  /// **'Die App heißt jetzt „Pulse“. Der Startbildschirm braucht dafür ein paar Sekunden.'**
  String get onboardingTheAppIsNowCalled;

  /// No description provided for @onboardingTheAppIsCalledVelvetpulse.
  ///
  /// In de, this message translates to:
  /// **'Die App heißt wieder „VelvetPulse“.'**
  String get onboardingTheAppIsCalledVelvetpulse;

  /// No description provided for @onboardingDiscreetAppIcon.
  ///
  /// In de, this message translates to:
  /// **'Unauffälliges App-Symbol'**
  String get onboardingDiscreetAppIcon;

  /// No description provided for @onboardingShowsPulseWithANeutral.
  ///
  /// In de, this message translates to:
  /// **'Zeigt „Pulse“ mit neutralem Symbol auf dem Startbildschirm.'**
  String get onboardingShowsPulseWithANeutral;

  /// No description provided for @onboardingCallYourPartnerByName.
  ///
  /// In de, this message translates to:
  /// **'Gegenüber in Lektionen beim Namen nennen'**
  String get onboardingCallYourPartnerByName;

  /// No description provided for @onboardingForExampleAnnaLiesOn.
  ///
  /// In de, this message translates to:
  /// **'Zum Beispiel „Anna liegt auf dem Rücken“ statt „sie liegt“. Aus, wenn öfter jemand mitliest.'**
  String get onboardingForExampleAnnaLiesOn;

  /// No description provided for @onboardingAndroidHasnTAllowedNotifications.
  ///
  /// In de, this message translates to:
  /// **'Android hat Mitteilungen für die App nicht erlaubt. Das lässt sich in den Android-Einstellungen ändern.'**
  String get onboardingAndroidHasnTAllowedNotifications;

  /// No description provided for @onboardingNotifyAboutNewMessages.
  ///
  /// In de, this message translates to:
  /// **'Hinweis bei neuen Nachrichten'**
  String get onboardingNotifyAboutNewMessages;

  /// No description provided for @onboardingEvenWhenTheAppIs.
  ///
  /// In de, this message translates to:
  /// **'Auch wenn die App geschlossen ist: nur „Neue Nachricht“, ohne Inhalt und Namen. Bei geschlossener App kann es bis zu 15 Minuten dauern.'**
  String get onboardingEvenWhenTheAppIs;

  /// No description provided for @onboardingPrivacyUpdateSafety.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz & Update-Sicherheit'**
  String get onboardingPrivacyUpdateSafety;

  /// No description provided for @onboardingEverythingStaysLocalOnYour.
  ///
  /// In de, this message translates to:
  /// **'Alles bleibt lokal auf deinem Gerät und übersteht Updates. API-Key und Paar-Verbindung liegen verschlüsselt im Android-Schlüsselspeicher und gehen nur mit Passwort in eine Sicherung.'**
  String get onboardingEverythingStaysLocalOnYour;

  /// No description provided for @onboardingExportBackup.
  ///
  /// In de, this message translates to:
  /// **'Backup exportieren'**
  String get onboardingExportBackup;

  /// No description provided for @backupDialogsWhatShouldGoIntoThe.
  ///
  /// In de, this message translates to:
  /// **'Was soll in die Sicherung?'**
  String get backupDialogsWhatShouldGoIntoThe;

  /// No description provided for @backupDialogsOnlyYourDataProfileProgress.
  ///
  /// In de, this message translates to:
  /// **'Nur deine Daten: Profil, Fortschritt, Reflexionen, Tagebuch, Wünsche. Reicht für dieses Handy.\n\nMit Passwort: zusätzlich die Verbindung im Paar-Kanal und dein API-Key, verschlüsselt. Das brauchst du für einen Umzug auf ein anderes Handy.'**
  String get backupDialogsOnlyYourDataProfileProgress;

  /// No description provided for @backupDialogsDataOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur Daten'**
  String get backupDialogsDataOnly;

  /// No description provided for @backupDialogsWithPassword.
  ///
  /// In de, this message translates to:
  /// **'Mit Passwort'**
  String get backupDialogsWithPassword;

  /// No description provided for @backupDialogsBackupCopied.
  ///
  /// In de, this message translates to:
  /// **'Sicherung kopiert'**
  String get backupDialogsBackupCopied;

  /// No description provided for @backupDialogsOk.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get backupDialogsOk;

  /// No description provided for @backupDialogsOlderBackup.
  ///
  /// In de, this message translates to:
  /// **'Ältere Sicherung'**
  String get backupDialogsOlderBackup;

  /// No description provided for @backupDialogsThisBackupComesFromAn.
  ///
  /// In de, this message translates to:
  /// **'Diese Sicherung stammt aus einer älteren Version und enthält deinen API-Key und deinen Verbindungsschlüssel unverschlüsselt. Sie wird trotzdem eingespielt.\n\nLösche die alte Sicherung danach dort, wo du sie aufbewahrt hast, und erstelle bei Bedarf eine neue mit Passwort.'**
  String get backupDialogsThisBackupComesFromAn;

  /// No description provided for @backupDialogsRestore.
  ///
  /// In de, this message translates to:
  /// **'Einspielen'**
  String get backupDialogsRestore;

  /// No description provided for @backupDialogsBackupPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort der Sicherung'**
  String get backupDialogsBackupPassword;

  /// No description provided for @backupDialogsThisAlsoBringsBackThe.
  ///
  /// In de, this message translates to:
  /// **'Damit kommen auch die Verbindung im Paar-Kanal und dein API-Key zurück.'**
  String get backupDialogsThisAlsoBringsBackThe;

  /// No description provided for @backupDialogsPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get backupDialogsPassword;

  /// No description provided for @backupDialogsWithoutKeys.
  ///
  /// In de, this message translates to:
  /// **'Ohne Schlüssel'**
  String get backupDialogsWithoutKeys;

  /// No description provided for @backupDialogsPasswordForTheBackup.
  ///
  /// In de, this message translates to:
  /// **'Passwort für die Sicherung'**
  String get backupDialogsPasswordForTheBackup;

  /// No description provided for @backupDialogsPasswordAtLeastCharacters.
  ///
  /// In de, this message translates to:
  /// **'Passwort (mindestens 8 Zeichen)'**
  String get backupDialogsPasswordAtLeastCharacters;

  /// No description provided for @backupDialogsRepeatPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort wiederholen'**
  String get backupDialogsRepeatPassword;

  /// No description provided for @backupDialogsPleaseUseAtLeastCharacters.
  ///
  /// In de, this message translates to:
  /// **'Bitte mindestens 8 Zeichen.'**
  String get backupDialogsPleaseUseAtLeastCharacters;

  /// No description provided for @backupDialogsThePasswordsDonTMatch.
  ///
  /// In de, this message translates to:
  /// **'Die Passwörter sind verschieden.'**
  String get backupDialogsThePasswordsDonTMatch;

  /// No description provided for @backupDialogsEncrypt.
  ///
  /// In de, this message translates to:
  /// **'Verschlüsseln'**
  String get backupDialogsEncrypt;

  /// No description provided for @backupDialogsOneMoment.
  ///
  /// In de, this message translates to:
  /// **'Einen Moment …'**
  String get backupDialogsOneMoment;

  /// No description provided for @backupDialogsBackupCopiedText.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung liegt in der Zwischenablage. Füge sie in eine Notiz oder ein privates Dokument ein.'**
  String get backupDialogsBackupCopiedText;

  /// No description provided for @backupDialogsPasswordCannotBeReset.
  ///
  /// In de, this message translates to:
  /// **'\n\nOhne dein Passwort lassen sich Verbindung und API-Key nicht wiederherstellen. Auch wir können es nicht zurücksetzen.'**
  String get backupDialogsPasswordCannotBeReset;

  /// No description provided for @checkinActionBreathed.
  ///
  /// In de, this message translates to:
  /// **'Ein paar Mal tief durchgeatmet'**
  String get checkinActionBreathed;

  /// No description provided for @checkinActionPelvicFloor.
  ///
  /// In de, this message translates to:
  /// **'Den Beckenboden bewusst weich gelassen'**
  String get checkinActionPelvicFloor;

  /// No description provided for @checkinActionPhoneAway.
  ///
  /// In de, this message translates to:
  /// **'Das Handy abends weggelegt'**
  String get checkinActionPhoneAway;

  /// No description provided for @checkinActionWalk.
  ///
  /// In de, this message translates to:
  /// **'Spaziergang an frischer Luft gemacht'**
  String get checkinActionWalk;

  /// No description provided for @checkinActionSkinContact.
  ///
  /// In de, this message translates to:
  /// **'Hautkontakt bewusst gespürt'**
  String get checkinActionSkinContact;

  /// No description provided for @checkinActionOpenWord.
  ///
  /// In de, this message translates to:
  /// **'Ein offenes Wort mit meinem Gegenüber gesprochen'**
  String get checkinActionOpenWord;

  /// No description provided for @dailySimmeringCardTheSecondWallTease.
  ///
  /// In de, this message translates to:
  /// **'Das 45-Sekunden-Wand-Teasing'**
  String get dailySimmeringCardTheSecondWallTease;

  /// No description provided for @dailySimmeringCardCourseTeasing.
  ///
  /// In de, this message translates to:
  /// **'KURS 15 • TEASING'**
  String get dailySimmeringCardCourseTeasing;

  /// No description provided for @dailySimmeringCardTodayBrieflyPressYourPartner.
  ///
  /// In de, this message translates to:
  /// **'Wenn ihr beide so etwas mögt: Zieh dein Gegenüber heute kurz an dich, küss langsam den Hals, flüstere ein Versprechen ins Ohr. Nach 45 Sekunden lächelst du und gehst weiter: \"Den Rest heben wir uns für später auf.\"'**
  String get dailySimmeringCardTodayBrieflyPressYourPartner;

  /// No description provided for @dailySimmeringCardJawMeltVoiceActivation.
  ///
  /// In de, this message translates to:
  /// **'Die Kiefer-Schmelze & Stimm-Aktivierung'**
  String get dailySimmeringCardJawMeltVoiceActivation;

  /// No description provided for @dailySimmeringCardCourseAudiblePleasure.
  ///
  /// In de, this message translates to:
  /// **'KURS 21 • HÖRBARE LUST'**
  String get dailySimmeringCardCourseAudiblePleasure;

  /// No description provided for @dailySimmeringCardPlaceYourFingersOnYour.
  ///
  /// In de, this message translates to:
  /// **'Lege die Finger an deine Kiefergelenke, öffne den Mund und lass 3 tiefe, dunkle Seufzer hörbar durch den Raum vibrieren. Spüre, wie dein Beckenboden gleichzeitig nach unten nachgibt.'**
  String get dailySimmeringCardPlaceYourFingersOnYour;

  /// No description provided for @dailySimmeringCardThePmAnticipation.
  ///
  /// In de, this message translates to:
  /// **'Die 15:00-Uhr-Antizipation'**
  String get dailySimmeringCardThePmAnticipation;

  /// No description provided for @dailySimmeringCardCourseAnticipation.
  ///
  /// In de, this message translates to:
  /// **'KURS 15 • KOPFKINO'**
  String get dailySimmeringCardCourseAnticipation;

  /// No description provided for @dailySimmeringCardThisAfternoonSendYourPartner.
  ///
  /// In de, this message translates to:
  /// **'Nur wenn ihr das mögt: Schick deinem Gegenüber heute Nachmittag eine Nachricht, die Vorfreude macht, ohne etwas zu erwarten.'**
  String get dailySimmeringCardThisAfternoonSendYourPartner;

  /// No description provided for @dailySimmeringCardSlowMotionWhilePouring.
  ///
  /// In de, this message translates to:
  /// **'Zeitlupe beim Einschenken'**
  String get dailySimmeringCardSlowMotionWhilePouring;

  /// No description provided for @dailySimmeringCardCourseSlowSex.
  ///
  /// In de, this message translates to:
  /// **'KURS 15 • SLOW SEX'**
  String get dailySimmeringCardCourseSlowSex;

  /// No description provided for @dailySimmeringCardTodayTouchYourPartnerDuring.
  ///
  /// In de, this message translates to:
  /// **'Berühre dein Gegenüber heute bei einer Alltagsgelegenheit (am Tisch, auf dem Sofa) im extremen 10%-Zeitlupen-Tempo. Streiche 60 Sekunden ganz langsam über Handrücken und Unterarm.'**
  String get dailySimmeringCardTodayTouchYourPartnerDuring;

  /// No description provided for @dailySimmeringCardTheMinuteSilkScarfRitual.
  ///
  /// In de, this message translates to:
  /// **'Das 15-Minuten-Seidentuch-Ritual'**
  String get dailySimmeringCardTheMinuteSilkScarfRitual;

  /// No description provided for @dailySimmeringCardCourseSurrender.
  ///
  /// In de, this message translates to:
  /// **'KURS 23 • HINGABE'**
  String get dailySimmeringCardCourseSurrender;

  /// No description provided for @dailySimmeringCardAgreeForTonightOneOf.
  ///
  /// In de, this message translates to:
  /// **'Verabredet für heute Abend: Einer bekommt die Augen verbunden und darf absolut nichts leisten oder zurückgeben. Der andere dirigiert 15 Minuten sanfte Berührungen.'**
  String get dailySimmeringCardAgreeForTonightOneOf;

  /// No description provided for @dailySimmeringCardTheStrictNoPenetrationRule.
  ///
  /// In de, this message translates to:
  /// **'Heute ohne Eindringen'**
  String get dailySimmeringCardTheStrictNoPenetrationRule;

  /// No description provided for @dailySimmeringCardCourseSensateFocus.
  ///
  /// In de, this message translates to:
  /// **'KURS 17 • BERÜHRUNG OHNE ZIEL'**
  String get dailySimmeringCardCourseSensateFocus;

  /// No description provided for @dailySimmeringCardAgreeTodayYouMayHug.
  ///
  /// In de, this message translates to:
  /// **'Verabredet heute: Ihr dürft euch nackt umarmen, küssen und streicheln – Eindringen bleibt heute außen vor. Alles darf sein, nichts muss.'**
  String get dailySimmeringCardAgreeTodayYouMayHug;

  /// No description provided for @dailySimmeringCardSensoryNarratingWordsInThe.
  ///
  /// In de, this message translates to:
  /// **'Sensory Narrating (Worte im Ohr)'**
  String get dailySimmeringCardSensoryNarratingWordsInThe;

  /// No description provided for @dailySimmeringCardCbtLettingGoOfPropriety.
  ///
  /// In de, this message translates to:
  /// **'KVT • ANSTÄNDIGKEIT LÖSEN'**
  String get dailySimmeringCardCbtLettingGoOfPropriety;

  /// No description provided for @dailySimmeringCardTonightInTheDarkWhisper.
  ///
  /// In de, this message translates to:
  /// **'Flüstere deinem Gegenüber heute im Dunkeln eine einzige ehrliche, sinnliche Empfindung ins Ohr: \"Es macht mich verrückt, wie warm und weich deine Haut gerade unter meiner Hand ist.\"'**
  String get dailySimmeringCardTonightInTheDarkWhisper;

  /// No description provided for @dailySimmeringCardTheCharmingDreamBridge.
  ///
  /// In de, this message translates to:
  /// **'Die charmante Traum-Brücke'**
  String get dailySimmeringCardTheCharmingDreamBridge;

  /// No description provided for @dailySimmeringCardCourseFantasies.
  ///
  /// In de, this message translates to:
  /// **'KURS 23 • FANTASIEN'**
  String get dailySimmeringCardCourseFantasies;

  /// No description provided for @dailySimmeringCardTodayCasuallyAndWithA.
  ///
  /// In de, this message translates to:
  /// **'Erzähle heute beiläufig mit einem Schmunzeln von einem \"unanständigen Traum\", den du über euch beide hattest. Beobachte die Reaktion.'**
  String get dailySimmeringCardTodayCasuallyAndWithA;

  /// No description provided for @dailySimmeringCardTheSeatedPelvicFloorCheck.
  ///
  /// In de, this message translates to:
  /// **'Der Beckenboden-Check im Sitzen'**
  String get dailySimmeringCardTheSeatedPelvicFloorCheck;

  /// No description provided for @dailySimmeringCardCoursesBody.
  ///
  /// In de, this message translates to:
  /// **'KURS 7 & 9 • KÖRPER'**
  String get dailySimmeringCardCoursesBody;

  /// No description provided for @dailySimmeringCardNoticeRightNowAreYou.
  ///
  /// In de, this message translates to:
  /// **'Achte genau jetzt darauf: Hältst du im Becken oder After fest? Atme tief ein und lass den Beckenboden wie eine weite Blüte nach unten sinken (Reverse Kegel).'**
  String get dailySimmeringCardNoticeRightNowAreYou;

  /// No description provided for @dailySimmeringCardSoftBellyFullSurrender.
  ///
  /// In de, this message translates to:
  /// **'Weicher Bauch • Volle Hingabe'**
  String get dailySimmeringCardSoftBellyFullSurrender;

  /// No description provided for @dailySimmeringCardCourseRadicalBodyLove.
  ///
  /// In de, this message translates to:
  /// **'KURS 6 • RADICAL BODY LOVE'**
  String get dailySimmeringCardCourseRadicalBodyLove;

  /// No description provided for @dailySimmeringCardTodayConsciouslyLetYourBelly.
  ///
  /// In de, this message translates to:
  /// **'Lass deinen Bauch heute ganz bewusst locker nach außen sinken. Perfektion ist kalt – Hingabe und Wärme sind unwiderstehlich.'**
  String get dailySimmeringCardTodayConsciouslyLetYourBelly;

  /// No description provided for @dailySimmeringCardJawMeltPelvicVibration.
  ///
  /// In de, this message translates to:
  /// **'Die Kiefer-Schmelze & Becken-Vibration'**
  String get dailySimmeringCardJawMeltPelvicVibration;

  /// No description provided for @dailySimmeringCardOpenYourMouthSmoothOut.
  ///
  /// In de, this message translates to:
  /// **'Öffne den Mund, streiche deine Wangen aus und seufze 3x tief und dunkel nach unten aus. Spüre, wie die Schwingung bis in dein Schambein hinabwandert.'**
  String get dailySimmeringCardOpenYourMouthSmoothOut;

  /// No description provided for @dailySimmeringCardBroadPalmTouchWithWarm.
  ///
  /// In de, this message translates to:
  /// **'Broad Palm Touch mit warmem Öl'**
  String get dailySimmeringCardBroadPalmTouchWithWarm;

  /// No description provided for @dailySimmeringCardCourseBodyLab.
  ///
  /// In de, this message translates to:
  /// **'KURS 19 • BERÜHRUNG NEU LERNEN'**
  String get dailySimmeringCardCourseBodyLab;

  /// No description provided for @dailySimmeringCardTodaySkipAnyTightGrip.
  ///
  /// In de, this message translates to:
  /// **'Verzichte heute beim Spüren auf jeden engen Klammergriff. Nutze viel Gleitmittel und bewege die gesamte flache Handfläche in Zeitlupe über das Becken.'**
  String get dailySimmeringCardTodaySkipAnyTightGrip;

  /// No description provided for @dailySimmeringCardOrbitingExploringThePerineum.
  ///
  /// In de, this message translates to:
  /// **'Orbiting: Das Perineum erforschen'**
  String get dailySimmeringCardOrbitingExploringThePerineum;

  /// No description provided for @dailySimmeringCardCoursesOrbiting.
  ///
  /// In de, this message translates to:
  /// **'KURS 18 & 9 • ORBITING'**
  String get dailySimmeringCardCoursesOrbiting;

  /// No description provided for @dailySimmeringCardLeaveTheHighlySensitiveTip.
  ///
  /// In de, this message translates to:
  /// **'Lass die hochsensible Spitze heute für 10 Minuten völlig unberührt. Konzentriere Berührung nur auf Damm, Schaftbasis und Leiste.'**
  String get dailySimmeringCardLeaveTheHighlySensitiveTip;

  /// No description provided for @dailySimmeringCardPlateauSurfingAtLevel.
  ///
  /// In de, this message translates to:
  /// **'Erregung ohne Ziel spüren'**
  String get dailySimmeringCardPlateauSurfingAtLevel;

  /// No description provided for @dailySimmeringCardCourseStayingPower.
  ///
  /// In de, this message translates to:
  /// **'KURS 19 • AUSDAUER'**
  String get dailySimmeringCardCourseStayingPower;

  /// No description provided for @dailySimmeringCardBringYourArousalToLevel.
  ///
  /// In de, this message translates to:
  /// **'Spür heute, wie sich deine Erregung anfühlt, und lass sie ohne Ziel kommen und gehen. Wird es zu viel, halte inne, atme 3x tief aus und lass den Beckenboden weich werden.'**
  String get dailySimmeringCardBringYourArousalToLevel;

  /// No description provided for @dailySimmeringCardScreenFreeSensing.
  ///
  /// In de, this message translates to:
  /// **'Bildschirmfreies Spüren'**
  String get dailySimmeringCardScreenFreeSensing;

  /// No description provided for @dailySimmeringCardCourseRecalibration.
  ///
  /// In de, this message translates to:
  /// **'KURS 10 • REKALIBRIERUNG'**
  String get dailySimmeringCardCourseRecalibration;

  /// No description provided for @dailySimmeringCardTakeMinutesTodayWithoutAny.
  ///
  /// In de, this message translates to:
  /// **'Nimm dir heute 10 Minuten Zeit ganz ohne Smartphone oder Bildschirme. Schließe die Augen und achte nur auf Temperatur und Atem.'**
  String get dailySimmeringCardTakeMinutesTodayWithoutAny;

  /// No description provided for @dailySimmeringCardTheSphincterReleaseTest.
  ///
  /// In de, this message translates to:
  /// **'Der Schließmuskel-Entlastungstest'**
  String get dailySimmeringCardTheSphincterReleaseTest;

  /// No description provided for @dailySimmeringCardCourseMultipleOrgasms.
  ///
  /// In de, this message translates to:
  /// **'KURS 19 • LOSLASSEN'**
  String get dailySimmeringCardCourseMultipleOrgasms;

  /// No description provided for @dailySimmeringCardObserveYourReflexesWhenArousal.
  ///
  /// In de, this message translates to:
  /// **'Beobachte deine Reflexe: Wenn Erregung steigt, lass den Anal-Schließmuskel bewusst locker, statt ihn anzuspannen.'**
  String get dailySimmeringCardObserveYourReflexesWhenArousal;

  /// No description provided for @dailySimmeringCardZeroPressureSquatMalasana.
  ///
  /// In de, this message translates to:
  /// **'Zero-Pressure Hocke (Malasana)'**
  String get dailySimmeringCardZeroPressureSquatMalasana;

  /// No description provided for @dailySimmeringCardCourseFascia.
  ///
  /// In de, this message translates to:
  /// **'KURS 7 • FASZIEN'**
  String get dailySimmeringCardCourseFascia;

  /// No description provided for @dailySimmeringCardGoIntoADeepSquat.
  ///
  /// In de, this message translates to:
  /// **'Gehe für 2 Minuten in die tiefe Hocke (Deep Squat). Atme 10 tiefe Atemzüge in das geöffnete Becken hinein.'**
  String get dailySimmeringCardGoIntoADeepSquat;

  /// No description provided for @dailySimmeringCardBodyCompassionInTheMirror.
  ///
  /// In de, this message translates to:
  /// **'Körper-Mitgefühl vor dem Spiegel'**
  String get dailySimmeringCardBodyCompassionInTheMirror;

  /// No description provided for @dailySimmeringCardCourseSelfCompassion.
  ///
  /// In de, this message translates to:
  /// **'KURS 6 • SELBSTMITGEFÜHL'**
  String get dailySimmeringCardCourseSelfCompassion;

  /// No description provided for @dailySimmeringCardLookAtYourBodyToday.
  ///
  /// In de, this message translates to:
  /// **'Betrachte deinen Körper heute ohne Bewertung. Sag dir: \"Mein Körper ist lebendig, atmend und fähig zu tiefster Lust.\"'**
  String get dailySimmeringCardLookAtYourBodyToday;

  /// No description provided for @dailySimmeringCardPhysiologicalSighQuickCalming.
  ///
  /// In de, this message translates to:
  /// **'Der lange Seufzer'**
  String get dailySimmeringCardPhysiologicalSighQuickCalming;

  /// No description provided for @dailySimmeringCardToolCalmDown.
  ///
  /// In de, this message translates to:
  /// **'ÜBUNG • RUHE'**
  String get dailySimmeringCardToolCalmDown;

  /// No description provided for @dailySimmeringCardBreatheInTwiceDeeplyThrough.
  ///
  /// In de, this message translates to:
  /// **'Doppelt durch die Nase tief einatmen, dann sehr lang und hörbar durch den offenen Mund seufzen. 3 Wiederholungen.'**
  String get dailySimmeringCardBreatheInTwiceDeeplyThrough;

  /// No description provided for @dailySimmeringCardThePercentPactWithYourself.
  ///
  /// In de, this message translates to:
  /// **'Der 90-Prozent-Pakt mit dir selbst'**
  String get dailySimmeringCardThePercentPactWithYourself;

  /// No description provided for @dailySimmeringCardGiveYourselfMinutesOfPleasure.
  ///
  /// In de, this message translates to:
  /// **'Schenke dir heute 10 Minuten Genuss – aber nimm dir vor, bei 90% bewusst aufzuhören, ohne zum Abschluss zu eilen.'**
  String get dailySimmeringCardGiveYourselfMinutesOfPleasure;

  /// No description provided for @dailySimmeringCardTodaySEroticSpark.
  ///
  /// In de, this message translates to:
  /// **'HEUTIGER EROTIK-FUNKE'**
  String get dailySimmeringCardTodaySEroticSpark;

  /// No description provided for @dailySimmeringCardSimmeringEverydayTeasing.
  ///
  /// In de, this message translates to:
  /// **'Simmering & Alltags-Teasing'**
  String get dailySimmeringCardSimmeringEverydayTeasing;

  /// No description provided for @dailySimmeringCardTapHereToRevealToday.
  ///
  /// In de, this message translates to:
  /// **'Tippe hier, um deinen heutigen 45-Sekunden-Funken aufzudecken...'**
  String get dailySimmeringCardTapHereToRevealToday;

  /// No description provided for @dailySimmeringCardOpen.
  ///
  /// In de, this message translates to:
  /// **'ÖFFNEN'**
  String get dailySimmeringCardOpen;

  /// No description provided for @userProfileNonBinaryOpen.
  ///
  /// In de, this message translates to:
  /// **'Divers / nicht-binär'**
  String get userProfileNonBinaryOpen;

  /// No description provided for @userProfileInARelationshipMarried.
  ///
  /// In de, this message translates to:
  /// **'In Beziehung / Verheiratet'**
  String get userProfileInARelationshipMarried;

  /// No description provided for @userProfileDatingGettingToKnowSomeone.
  ///
  /// In de, this message translates to:
  /// **'Dating / Kennenlernphase'**
  String get userProfileDatingGettingToKnowSomeone;

  /// No description provided for @userProfileSingle.
  ///
  /// In de, this message translates to:
  /// **'Single'**
  String get userProfileSingle;

  /// No description provided for @userProfileComplicated.
  ///
  /// In de, this message translates to:
  /// **'Kompliziert'**
  String get userProfileComplicated;

  /// No description provided for @userProfilePelvicFloorBody.
  ///
  /// In de, this message translates to:
  /// **'Beckenboden & Körper spüren'**
  String get userProfilePelvicFloorBody;

  /// No description provided for @userProfileCoupleIntimacyCloseness.
  ///
  /// In de, this message translates to:
  /// **'Paar-Intimität & Nähe'**
  String get userProfileCoupleIntimacyCloseness;

  /// No description provided for @userProfileDesireRelaxation.
  ///
  /// In de, this message translates to:
  /// **'Lust & Entspannung'**
  String get userProfileDesireRelaxation;

  /// No description provided for @userProfileEasingPerformancePressure.
  ///
  /// In de, this message translates to:
  /// **'Weniger Druck'**
  String get userProfileEasingPerformancePressure;

  /// No description provided for @contentModelsTheArtOfTouchFor.
  ///
  /// In de, this message translates to:
  /// **'BERÜHRUNGSKUNST • FÜR SIE'**
  String get contentModelsTheArtOfTouchFor;

  /// No description provided for @contentModelsTouchLabForHim.
  ///
  /// In de, this message translates to:
  /// **'TAST-LABOR • FÜR IHN'**
  String get contentModelsTouchLabForHim;

  /// No description provided for @contentModelsSelfExploration.
  ///
  /// In de, this message translates to:
  /// **'SELBST ERKUNDEN'**
  String get contentModelsSelfExploration;

  /// No description provided for @contentModelsVoiceBody.
  ///
  /// In de, this message translates to:
  /// **'STIMME & SOMATIK'**
  String get contentModelsVoiceBody;

  /// No description provided for @contentModelsAnticipationDesire.
  ///
  /// In de, this message translates to:
  /// **'HINHALTEN & VERLANGEN'**
  String get contentModelsAnticipationDesire;

  /// No description provided for @contentModelsPolarityRoles.
  ///
  /// In de, this message translates to:
  /// **'POLARITÄT & ROLLEN'**
  String get contentModelsPolarityRoles;

  /// No description provided for @contentModelsBodyPresence.
  ///
  /// In de, this message translates to:
  /// **'KÖRPER-PRÄSENZ'**
  String get contentModelsBodyPresence;

  /// No description provided for @contentModelsForHer.
  ///
  /// In de, this message translates to:
  /// **'FÜR SIE'**
  String get contentModelsForHer;

  /// No description provided for @contentModelsForCouples.
  ///
  /// In de, this message translates to:
  /// **'FÜR PAARE'**
  String get contentModelsForCouples;

  /// No description provided for @contentModelsForHim.
  ///
  /// In de, this message translates to:
  /// **'FÜR IHN'**
  String get contentModelsForHim;

  /// No description provided for @yesNoMaybeModelsExcitesMeIDLike.
  ///
  /// In de, this message translates to:
  /// **'Reizt mich, möchte ich ausprobieren'**
  String get yesNoMaybeModelsExcitesMeIDLike;

  /// No description provided for @yesNoMaybeModelsCuriousButUnsureDependsOn.
  ///
  /// In de, this message translates to:
  /// **'Neugierig, aber unsicher – kommt auf den Moment an'**
  String get yesNoMaybeModelsCuriousButUnsureDependsOn;

  /// No description provided for @yesNoMaybeModelsNotForMe.
  ///
  /// In de, this message translates to:
  /// **'Kommt für mich nicht infrage'**
  String get yesNoMaybeModelsNotForMe;

  /// No description provided for @aiServiceYouAreTheConfidentialSomatic.
  ///
  /// In de, this message translates to:
  /// **'Du bist der vertrauliche Somatik-, KVT- und Erotik-Coach in der App VelvetPulse.\n\nDeine Grundhaltung & Tonalität:\n1. Charakter: Du bist eine faszinierende Mischung aus brillantem Neurowissenschaftler/Sexualtherapeuten und einem weltgewandten, charmant-frivolen Verführer auf Augenhöhe.\n2. Sprache: Du sprichst reines, flüssiges Deutsch – vollkommen frei von englischen Modewörtern oder Anglizismen. Du sprichst absolut schamfrei, sinnlich, warm und mit einem leichten, wissenden Augenzwinkern über Lust, Haut, Feuchtigkeit, Erektionen, Damm-Entspannung, Hingabe und Kopfkino. Vermeide jede sterile Krankenhaus-Sprache und jeden belehrenden Ton!\n3. Methodik: Verbinde Kognitive Verhaltenstherapie (das Entzaubern spießiger Leistungs- und Prüfungsgedanken) immer direkt mit lustvoller Somatik (Beckenboden wie warmen Honig schmelzen lassen, aktives Beckenboden-Öffnen, tiefe Kehlkopf-Seufzer, Vagus-Beruhigung, Kunst der Zeitlupe, sinnliches Umkreisen, reines Sinnesspüren).\n4. Kernbotschaft: Zeige dem Nutzer in jeder Zeile, dass sein Körper völlig in Ordnung ist und dass Langsamkeit, Pausen und das \'Nicht-Funktionieren-Müssen\' kein Defekt sind, sondern der Schlüssel zu viel tieferer, unanständig guter Ekstase.\n5. Format: Antworte stets kompakt (2-3 prägnante, atmosphärische Absätze) und beende JEDE Antwort mit genau EINER offenen, leicht herausfordernden oder spür-orientierten Reflexionsfrage.\n6. Sicherheit: Du stellst keine Diagnosen. Bei Schmerzen, Blutungen oder anhaltenden Beschwerden empfiehlst du freundlich eine ärztliche Abklärung.'**
  String get aiServiceYouAreTheConfidentialSomatic;

  /// No description provided for @aiServiceConnectionSuccessfulModelslengthModelsAvailable.
  ///
  /// In de, this message translates to:
  /// **'Verbindung erfolgreich! {modelsLength} Modelle verfügbar (z. B. {join}).'**
  String aiServiceConnectionSuccessfulModelslengthModelsAvailable(
      Object modelsLength, Object join);

  /// No description provided for @aiServiceNoAvailableTextModelsFound.
  ///
  /// In de, this message translates to:
  /// **'Keine verfügbaren Textmodelle für diesen Key gefunden. Bitte prüfe die API-Berechtigungen.'**
  String get aiServiceNoAvailableTextModelsFound;

  /// No description provided for @aiServiceTheApiKeyIsInvalid.
  ///
  /// In de, this message translates to:
  /// **'Der API-Key ist ungültig. Bitte prüfe ihn im Google AI Studio.'**
  String get aiServiceTheApiKeyIsInvalid;

  /// No description provided for @aiServiceUserContextNameProfilenameGender.
  ///
  /// In de, this message translates to:
  /// **'\n\nKONTEXT DES NUTZERS:\n- Name/Rufname: {profileName}\n- Geschlecht: {genderLabel}\n- Alter: {age} Jahre\n- Beziehungsstatus: {relationshipLabel}\n- Hauptfokus: {goalLabel}\nSprich die Person vertraulich mit ihrem Namen an, passe deine psychologischen und somatischen Erklärungen genau an ihr Geschlecht, Alter und ihren Beziehungsstatus an.'**
  String aiServiceUserContextNameProfilenameGender(
      Object profileName,
      Object genderLabel,
      Object age,
      Object relationshipLabel,
      Object goalLabel);

  /// No description provided for @aiServiceReceivedAnEmptyAnswerFrom.
  ///
  /// In de, this message translates to:
  /// **'Leere Antwort vom KI-Modell erhalten.'**
  String get aiServiceReceivedAnEmptyAnswerFrom;

  /// No description provided for @backupCodecTheBackupIsTooLarge.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist zu groß.'**
  String get backupCodecTheBackupIsTooLarge;

  /// No description provided for @backupCodecThisIsNotAValid.
  ///
  /// In de, this message translates to:
  /// **'Das ist keine gültige Sicherung (kein JSON).'**
  String get backupCodecThisIsNotAValid;

  /// No description provided for @backupCodecThisIsNotAValid2.
  ///
  /// In de, this message translates to:
  /// **'Das ist keine gültige Sicherung.'**
  String get backupCodecThisIsNotAValid2;

  /// No description provided for @backupCodecThisIsNotAVelvetpulse.
  ///
  /// In de, this message translates to:
  /// **'Das ist keine VelvetPulse-Sicherung.'**
  String get backupCodecThisIsNotAVelvetpulse;

  /// No description provided for @backupCodecThisBackupComesFromA.
  ///
  /// In de, this message translates to:
  /// **'Diese Sicherung stammt aus einer neueren App-Version. Bitte erst aktualisieren.'**
  String get backupCodecThisBackupComesFromA;

  /// No description provided for @backupCodecTheBackupIsDamagedField.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt (Feld „{key}“).'**
  String backupCodecTheBackupIsDamagedField(Object key);

  /// No description provided for @backupCodecTheBackupContainsAnInvalid.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung enthält einen ungültigen Verbindungsschlüssel.'**
  String get backupCodecTheBackupContainsAnInvalid;

  /// No description provided for @backupCodecTheBackupIsDamagedField2.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt (Feld „secrets“).'**
  String get backupCodecTheBackupIsDamagedField2;

  /// No description provided for @backupCodecTheBackupIsDamagedField3.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt (Feld „{field}“ zu lang).'**
  String backupCodecTheBackupIsDamagedField3(Object field);

  /// No description provided for @backupCodecTheBackupIsDamagedField4.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt (Feld „{field}“ zu lang).'**
  String backupCodecTheBackupIsDamagedField4(Object field);

  /// No description provided for @backupCodecThePasswordIsWrongOr.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort stimmt nicht, oder die Sicherung wurde beschädigt.'**
  String get backupCodecThePasswordIsWrongOr;

  /// No description provided for @backupCodecTheBackupIsDamaged.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt.'**
  String get backupCodecTheBackupIsDamaged;

  /// No description provided for @messageNotifierNewMessages.
  ///
  /// In de, this message translates to:
  /// **'Neue Nachrichten'**
  String get messageNotifierNewMessages;

  /// No description provided for @messageNotifierNewMessage.
  ///
  /// In de, this message translates to:
  /// **'Neue Nachricht'**
  String get messageNotifierNewMessage;

  /// No description provided for @messageNotifierNoticeOfNewMessagesIn.
  ///
  /// In de, this message translates to:
  /// **'Hinweis auf neue Nachrichten im Paar-Kanal, ohne Inhalt'**
  String get messageNotifierNoticeOfNewMessagesIn;

  /// No description provided for @nostrServiceWeReConnected.
  ///
  /// In de, this message translates to:
  /// **'💛 Wir sind verbunden!'**
  String get nostrServiceWeReConnected;

  /// No description provided for @nostrServiceCountOfFallbackrelayslengthServers.
  ///
  /// In de, this message translates to:
  /// **'{count} von {fallbackRelaysLength} Servern'**
  String nostrServiceCountOfFallbackrelayslengthServers(
      Object count, Object fallbackRelaysLength);

  /// No description provided for @nostrServiceVotedOnTheFantasySelection.
  ///
  /// In de, this message translates to:
  /// **'Fantasie-Auswahl abgestimmt'**
  String get nostrServiceVotedOnTheFantasySelection;

  /// No description provided for @nostrServiceHaveAReadLessontitleCoursetitle.
  ///
  /// In de, this message translates to:
  /// **'📖 Lies mal: „{lessonTitle}“ ({courseTitle})'**
  String nostrServiceHaveAReadLessontitleCoursetitle(
      Object lessonTitle, Object courseTitle);

  /// No description provided for @nostrServiceIVeSharedMyThoughts.
  ///
  /// In de, this message translates to:
  /// **'💭 Ich habe meine Gedanken zu „{lessonTitle}“ geteilt. Du siehst sie, sobald du selbst geantwortet hast.'**
  String nostrServiceIVeSharedMyThoughts(Object lessonTitle);

  /// No description provided for @nostrServiceIVeSharedMyAnswers.
  ///
  /// In de, this message translates to:
  /// **'🗳️ Ich habe meine Antworten der Ja/Nein-Liste geteilt.'**
  String get nostrServiceIVeSharedMyAnswers;

  /// No description provided for @privacyServiceUnlockTheApp.
  ///
  /// In de, this message translates to:
  /// **'Entsperre die App'**
  String get privacyServiceUnlockTheApp;

  /// No description provided for @privacyServiceConfirmToTurnOnThe.
  ///
  /// In de, this message translates to:
  /// **'Bestätige, um die App-Sperre einzuschalten'**
  String get privacyServiceConfirmToTurnOnThe;

  /// No description provided for @storageServiceTheBackupIsDamagedProfile.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt (Profil).'**
  String get storageServiceTheBackupIsDamagedProfile;

  /// No description provided for @storageServiceReflections.
  ///
  /// In de, this message translates to:
  /// **'Reflexionen'**
  String get storageServiceReflections;

  /// No description provided for @storageServiceYesNoList.
  ///
  /// In de, this message translates to:
  /// **'Ja/Nein-Liste'**
  String get storageServiceYesNoList;

  /// No description provided for @storageServiceTheKeysInTheBackup.
  ///
  /// In de, this message translates to:
  /// **'Die Schlüssel in der Sicherung passen nicht zusammen.'**
  String get storageServiceTheKeysInTheBackup;

  /// No description provided for @storageServiceTheBackupCouldNotBe.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung konnte nicht eingespielt werden. Es wurde nichts verändert.'**
  String get storageServiceTheBackupCouldNotBe;

  /// No description provided for @storageServiceTheBackupIsDamagedFeld.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung ist beschädigt ({feld}).'**
  String storageServiceTheBackupIsDamagedFeld(Object feld);

  /// No description provided for @spracheHinweis.
  ///
  /// In de, this message translates to:
  /// **'Oberfläche, Kurse und Übungen. Die Aufnahmen gibt es auf Deutsch in der App; englische Aufnahmen lassen sich nachladen.'**
  String get spracheHinweis;

  /// No description provided for @cueEinatmenWeit.
  ///
  /// In de, this message translates to:
  /// **'Einatmen. Und weit werden.'**
  String get cueEinatmenWeit;

  /// No description provided for @cueWeichBleiben.
  ///
  /// In de, this message translates to:
  /// **'Weich bleiben.'**
  String get cueWeichBleiben;

  /// No description provided for @cueAnspannen.
  ///
  /// In de, this message translates to:
  /// **'Anspannen. Und sanft heben.'**
  String get cueAnspannen;

  /// No description provided for @cueHalten.
  ///
  /// In de, this message translates to:
  /// **'Halten. Weiter atmen.'**
  String get cueHalten;

  /// No description provided for @cueLoslassen.
  ///
  /// In de, this message translates to:
  /// **'Und ganz loslassen.'**
  String get cueLoslassen;

  /// No description provided for @cueNachspueren.
  ///
  /// In de, this message translates to:
  /// **'Nachspüren.'**
  String get cueNachspueren;

  /// No description provided for @cueAn.
  ///
  /// In de, this message translates to:
  /// **'An.'**
  String get cueAn;

  /// No description provided for @cueLos.
  ///
  /// In de, this message translates to:
  /// **'Los.'**
  String get cueLos;

  /// No description provided for @cueWelle.
  ///
  /// In de, this message translates to:
  /// **'Einatmen. Damm und Po weich.'**
  String get cueWelle;

  /// No description provided for @cueSeufzen.
  ///
  /// In de, this message translates to:
  /// **'Ausatmen. Lang und hörbar.'**
  String get cueSeufzen;

  /// No description provided for @cueStart.
  ///
  /// In de, this message translates to:
  /// **'Wir beginnen.'**
  String get cueStart;

  /// No description provided for @cueFertig.
  ///
  /// In de, this message translates to:
  /// **'Geschafft. Spür noch einen Moment nach.'**
  String get cueFertig;

  /// No description provided for @audioPaketTitel.
  ///
  /// In de, this message translates to:
  /// **'Englische Stimmen'**
  String get audioPaketTitel;

  /// No description provided for @audioPaketText.
  ///
  /// In de, this message translates to:
  /// **'Englische Aufnahmen für Lektionen, Gemeinsamen Abend, Selbsterkundung und Beckenboden-Training (ca. {mb} MB). Ohne sie liest die Geräte-Stimme vor.'**
  String audioPaketText(int mb);

  /// No description provided for @audioPaketInstalliert.
  ///
  /// In de, this message translates to:
  /// **'Installiert ({mb} MB). Die Aufnahmen liegen nur auf diesem Gerät.'**
  String audioPaketInstalliert(int mb);

  /// No description provided for @audioPaketLaden.
  ///
  /// In de, this message translates to:
  /// **'Herunterladen'**
  String get audioPaketLaden;

  /// No description provided for @audioPaketLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get audioPaketLoeschen;

  /// No description provided for @audioPaketFertig.
  ///
  /// In de, this message translates to:
  /// **'Englische Stimmen sind bereit.'**
  String get audioPaketFertig;

  /// No description provided for @audioPaketFehler.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. Bitte Internetverbindung prüfen und später noch einmal versuchen.'**
  String get audioPaketFehler;

  /// No description provided for @navPaarKanalKurz.
  ///
  /// In de, this message translates to:
  /// **'Paar-Kanal'**
  String get navPaarKanalKurz;

  /// No description provided for @spicyModus.
  ///
  /// In de, this message translates to:
  /// **'Spicy-Modus'**
  String get spicyModus;

  /// No description provided for @spicyModusText.
  ///
  /// In de, this message translates to:
  /// **'Ab 18. Schaltet in Körperreise und Gemeinsamem Abend die Stufen „Spicy“ und „Sehr spicy“ frei.'**
  String get spicyModusText;

  /// No description provided for @heuteFuerHeute.
  ///
  /// In de, this message translates to:
  /// **'Für heute'**
  String get heuteFuerHeute;

  /// No description provided for @designTitel.
  ///
  /// In de, this message translates to:
  /// **'Darstellung'**
  String get designTitel;

  /// No description provided for @designText.
  ///
  /// In de, this message translates to:
  /// **'Papier ist hell, Nachtpapier dunkel. Im Spicy-Modus gelten eigene Farben.'**
  String get designText;

  /// No description provided for @designPapier.
  ///
  /// In de, this message translates to:
  /// **'Papier'**
  String get designPapier;

  /// No description provided for @designNacht.
  ///
  /// In de, this message translates to:
  /// **'Nachtpapier'**
  String get designNacht;

  /// No description provided for @designKlassisch.
  ///
  /// In de, this message translates to:
  /// **'Klassisch'**
  String get designKlassisch;

  /// No description provided for @spicyEinschaltenTitel.
  ///
  /// In de, this message translates to:
  /// **'Spicy-Modus einschalten?'**
  String get spicyEinschaltenTitel;

  /// No description provided for @spicyEinschaltenText.
  ///
  /// In de, this message translates to:
  /// **'Nur für Erwachsene. In Körperreise und Gemeinsamem Abend erscheinen dann zwei zusätzliche Stufen:\n\n„Spicy“: heiß und direkt, Spiel mit der Erregung bis kurz vor den Höhepunkt, für Paare auch Küsse, Necken und der Mund.\n\n„Sehr spicy“: dasselbe mit Dirty Talk und derben Wörtern.\n\nAlles bleibt eine Einladung, ein Stoppwort gilt immer. Du kannst den Modus hier jederzeit ausschalten, dann verschwinden die Stufen sofort.'**
  String get spicyEinschaltenText;

  /// No description provided for @spicyEinschalten.
  ///
  /// In de, this message translates to:
  /// **'Ich bin 18+, einschalten'**
  String get spicyEinschalten;

  /// No description provided for @alterTitel.
  ///
  /// In de, this message translates to:
  /// **'Bist du volljährig?'**
  String get alterTitel;

  /// No description provided for @alterText.
  ///
  /// In de, this message translates to:
  /// **'Dieser Bereich ist nur für Erwachsene. Gib Monat und Jahr deiner Geburt an. Die App rechnet nur nach und speichert das Datum nicht. Alles bleibt auf diesem Gerät. Das ersetzt keinen Ausweis.'**
  String get alterText;

  /// No description provided for @alterMonat.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get alterMonat;

  /// No description provided for @alterJahr.
  ///
  /// In de, this message translates to:
  /// **'Jahr'**
  String get alterJahr;

  /// No description provided for @alterWeiter.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get alterWeiter;

  /// No description provided for @alterGesperrtTitel.
  ///
  /// In de, this message translates to:
  /// **'Gerade nicht möglich'**
  String get alterGesperrtTitel;

  /// No description provided for @alterGesperrtText.
  ///
  /// In de, this message translates to:
  /// **'Dieser Bereich ist erst ab 18 verfügbar. Du kannst es später noch einmal versuchen.'**
  String get alterGesperrtText;

  /// No description provided for @alterSperreFehltTitel.
  ///
  /// In de, this message translates to:
  /// **'Gerätesperre nötig'**
  String get alterSperreFehltTitel;

  /// No description provided for @alterSperreFehltText.
  ///
  /// In de, this message translates to:
  /// **'Richte zuerst eine Bildschirmsperre (PIN, Muster oder Fingerabdruck) auf deinem Gerät ein. Sie schützt diesen Bereich vor fremdem Zugriff.'**
  String get alterSperreFehltText;

  /// No description provided for @alterSperreGrund.
  ///
  /// In de, this message translates to:
  /// **'Bitte bestätige, dass du diesen Bereich öffnen willst.'**
  String get alterSperreGrund;

  /// No description provided for @alterAbsichern.
  ///
  /// In de, this message translates to:
  /// **'Immer erneut absichern'**
  String get alterAbsichern;

  /// No description provided for @alterAbsichernText.
  ///
  /// In de, this message translates to:
  /// **'Nach einem App-Neustart oder 30 Minuten im Hintergrund fragt die App wieder nach deiner Gerätesperre.'**
  String get alterAbsichernText;

  /// No description provided for @alterGesperrtKurz.
  ///
  /// In de, this message translates to:
  /// **'Gesperrt. Zum Entsperren einschalten.'**
  String get alterGesperrtKurz;

  /// No description provided for @spicyStufe.
  ///
  /// In de, this message translates to:
  /// **'Spicy'**
  String get spicyStufe;

  /// No description provided for @selbstReiseSpicyText.
  ///
  /// In de, this message translates to:
  /// **'Direkt auf der Haut beginnen, dann Erregungswellen bis kurz vor die Kante, und am Ende deine Wahl: kommen oder genießen.'**
  String get selbstReiseSpicyText;

  /// No description provided for @paarAbendSpicyText.
  ///
  /// In de, this message translates to:
  /// **'Necken, Küsse über den ganzen Körper, Hand und Mund am Geschlecht, Spiel mit der Kante. Nur wenn ihr beide es wollt.'**
  String get paarAbendSpicyText;

  /// No description provided for @paarAbendSpicyHinweis.
  ///
  /// In de, this message translates to:
  /// **'Sprecht vorher kurz über Wünsche und Grenzen und vereinbart ein Stoppwort. Wer es sagt, bekommt sofort Ruhe, ohne Diskussion. Grün, gelb, rot hilft zwischendurch.'**
  String get paarAbendSpicyHinweis;

  /// No description provided for @sehrSpicyStufe.
  ///
  /// In de, this message translates to:
  /// **'Sehr spicy'**
  String get sehrSpicyStufe;

  /// No description provided for @selbstReiseSehrSpicyText.
  ///
  /// In de, this message translates to:
  /// **'Wie Spicy, aber mit Dirty Talk: derbe Wörter, gierig und schamlos.'**
  String get selbstReiseSehrSpicyText;

  /// No description provided for @paarAbendSehrSpicyText.
  ///
  /// In de, this message translates to:
  /// **'Wie Spicy, aber mit Dirty Talk: derbe Wörter, gierig und schamlos. Nur wenn ihr beide es wollt.'**
  String get paarAbendSehrSpicyText;

  /// No description provided for @audioPaketUpdate.
  ///
  /// In de, this message translates to:
  /// **'Neue englische Aufnahmen sind verfügbar (ca. {mb} MB). Bis dahin liest die Geräte-Stimme die neuen Texte vor.'**
  String audioPaketUpdate(int mb);

  /// No description provided for @audioPaketAktualisieren.
  ///
  /// In de, this message translates to:
  /// **'Aktualisieren'**
  String get audioPaketAktualisieren;

  /// No description provided for @coachQHerOrgasm.
  ///
  /// In de, this message translates to:
  /// **'Wie bringe ich meine Partnerin zum Höhepunkt, ohne Druck zu machen?'**
  String get coachQHerOrgasm;

  /// No description provided for @coachQWomenRelax.
  ///
  /// In de, this message translates to:
  /// **'Was hilft Frauen, beim Sex wirklich loszulassen?'**
  String get coachQWomenRelax;

  /// No description provided for @coachQHerDesire.
  ///
  /// In de, this message translates to:
  /// **'Warum braucht sie oft länger, bis sie Lust bekommt?'**
  String get coachQHerDesire;

  /// No description provided for @coachQAskHer.
  ///
  /// In de, this message translates to:
  /// **'Wie frage ich sie, was ihr gefällt, ohne dass es peinlich wird?'**
  String get coachQAskHer;

  /// No description provided for @coachQMyPressure.
  ///
  /// In de, this message translates to:
  /// **'Wie werde ich den Leistungsdruck im Bett los?'**
  String get coachQMyPressure;

  /// No description provided for @coachQShowHim.
  ///
  /// In de, this message translates to:
  /// **'Wie zeige ich ihm, wie ich berührt werden möchte?'**
  String get coachQShowHim;

  /// No description provided for @coachQMenPressure.
  ///
  /// In de, this message translates to:
  /// **'Was hilft Männern gegen Leistungsdruck im Bett?'**
  String get coachQMenPressure;

  /// No description provided for @coachQPleaseHim.
  ///
  /// In de, this message translates to:
  /// **'Wie verwöhne ich ihn mit Händen und Mund noch besser?'**
  String get coachQPleaseHim;

  /// No description provided for @coachQWishesLimits.
  ///
  /// In de, this message translates to:
  /// **'Wie sprechen wir offen über Wünsche und Grenzen?'**
  String get coachQWishesLimits;

  /// No description provided for @coachQHerTouch.
  ///
  /// In de, this message translates to:
  /// **'Wie finden wir heraus, welche Berührung ihr am meisten gefällt?'**
  String get coachQHerTouch;

  /// No description provided for @coachQDesireGap.
  ///
  /// In de, this message translates to:
  /// **'Wie gehen wir damit um, dass einer öfter Lust hat?'**
  String get coachQDesireGap;

  /// No description provided for @coachQKnowBody.
  ///
  /// In de, this message translates to:
  /// **'Wie lerne ich meinen eigenen Körper besser kennen?'**
  String get coachQKnowBody;

  /// No description provided for @coachQFemaleDesire.
  ///
  /// In de, this message translates to:
  /// **'Was sollte ich über weibliche Lust wissen?'**
  String get coachQFemaleDesire;

  /// No description provided for @coachQMaleDesire.
  ///
  /// In de, this message translates to:
  /// **'Was sollte ich über männliche Lust wissen?'**
  String get coachQMaleDesire;

  /// No description provided for @coachQShowTouch.
  ///
  /// In de, this message translates to:
  /// **'Wie zeige ich, wie ich berührt werden möchte?'**
  String get coachQShowTouch;

  /// No description provided for @gefuehrtTitel.
  ///
  /// In de, this message translates to:
  /// **'Geführte Audios'**
  String get gefuehrtTitel;

  /// No description provided for @gefuehrtSelbstTitel.
  ///
  /// In de, this message translates to:
  /// **'Körperreise'**
  String get gefuehrtSelbstTitel;

  /// No description provided for @gefuehrtSelbstText.
  ///
  /// In de, this message translates to:
  /// **'10 bis 30 Minuten nur für dich: eine Stimme führt dich über deinen Körper, so nah, wie du möchtest.'**
  String get gefuehrtSelbstText;

  /// No description provided for @lessonDetailTryGuidedEvening.
  ///
  /// In de, this message translates to:
  /// **'Jetzt geführt ausprobieren: Gemeinsamer Abend'**
  String get lessonDetailTryGuidedEvening;

  /// No description provided for @spicyEinladen.
  ///
  /// In de, this message translates to:
  /// **'Zum Spicy-Modus einladen'**
  String get spicyEinladen;

  /// No description provided for @spicyEinladungText.
  ///
  /// In de, this message translates to:
  /// **'Ich habe den Spicy-Modus eingeschaltet. Magst du ihn auch ausprobieren? (Profil › Spicy-Modus)'**
  String get spicyEinladungText;

  /// No description provided for @spicyEinladungAnnehmen.
  ///
  /// In de, this message translates to:
  /// **'Spicy-Modus ansehen'**
  String get spicyEinladungAnnehmen;

  /// No description provided for @spicyEinladungSchonAn.
  ///
  /// In de, this message translates to:
  /// **'Bei dir ist der Spicy-Modus schon an.'**
  String get spicyEinladungSchonAn;

  /// No description provided for @spicyEinladungGesendet.
  ///
  /// In de, this message translates to:
  /// **'Einladung gesendet.'**
  String get spicyEinladungGesendet;

  /// No description provided for @spicyEinladungFehler.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. Bitte später noch einmal versuchen.'**
  String get spicyEinladungFehler;

  /// No description provided for @spicyFunkeLippen.
  ///
  /// In de, this message translates to:
  /// **'Ich denk gerade an deine Lippen'**
  String get spicyFunkeLippen;

  /// No description provided for @spicyFunkeHeuteAbend.
  ///
  /// In de, this message translates to:
  /// **'Heute Abend gehörst du mir'**
  String get spicyFunkeHeuteAbend;

  /// No description provided for @spicyFunkeScharf.
  ///
  /// In de, this message translates to:
  /// **'Ich bin den ganzen Tag scharf auf dich'**
  String get spicyFunkeScharf;

  /// No description provided for @spicyFunkeSchmecken.
  ///
  /// In de, this message translates to:
  /// **'Ich will dich heute Abend schmecken'**
  String get spicyFunkeSchmecken;

  /// No description provided for @spicyFunkeNichtsDrunter.
  ///
  /// In de, this message translates to:
  /// **'Zieh heute nichts drunter an'**
  String get spicyFunkeNichtsDrunter;

  /// No description provided for @spicyFunkeNackt.
  ///
  /// In de, this message translates to:
  /// **'Ich will dich nackt sehen'**
  String get spicyFunkeNackt;

  /// No description provided for @spicyFunkeFicken.
  ///
  /// In de, this message translates to:
  /// **'Ich will dich ficken. Heute.'**
  String get spicyFunkeFicken;

  /// No description provided for @spicyFunkeNachHause.
  ///
  /// In de, this message translates to:
  /// **'Komm sofort nach Hause'**
  String get spicyFunkeNachHause;

  /// No description provided for @verschwindenSchalter.
  ///
  /// In de, this message translates to:
  /// **'Verschwindende Nachricht'**
  String get verschwindenSchalter;

  /// No description provided for @verschwindenHinweis.
  ///
  /// In de, this message translates to:
  /// **'Verschwindet 10 Min. nach dem Lesen …'**
  String get verschwindenHinweis;

  /// No description provided for @verschwindetLabel.
  ///
  /// In de, this message translates to:
  /// **'Verschwindet nach dem Lesen'**
  String get verschwindetLabel;

  /// No description provided for @fotoNachricht.
  ///
  /// In de, this message translates to:
  /// **'📷 Ein Foto für dich, nur einmal ansehbar. Öffne VelvetPulse, dann kommt es direkt zu dir.'**
  String get fotoNachricht;

  /// No description provided for @fotoSenden.
  ///
  /// In de, this message translates to:
  /// **'Foto senden'**
  String get fotoSenden;

  /// No description provided for @fotoKamera.
  ///
  /// In de, this message translates to:
  /// **'Kamera'**
  String get fotoKamera;

  /// No description provided for @fotoGalerie.
  ///
  /// In de, this message translates to:
  /// **'Galerie'**
  String get fotoGalerie;

  /// No description provided for @fotoSicherheitHinweis.
  ///
  /// In de, this message translates to:
  /// **'Das Foto geht verschlüsselt direkt von Handy zu Handy und lässt sich nur einmal ansehen. Am sichersten ohne Gesicht und ohne erkennbare Umgebung. Ein zweites Handy kann den Bildschirm trotzdem abfotografieren.'**
  String get fotoSicherheitHinweis;

  /// No description provided for @fotoNichtDa.
  ///
  /// In de, this message translates to:
  /// **'Dein Gegenüber hat VelvetPulse gerade nicht offen. Das Foto bleibt verschlüsselt bei dir und geht raus, sobald ihr beide die App offen habt.'**
  String get fotoNichtDa;

  /// No description provided for @fotoFehler.
  ///
  /// In de, this message translates to:
  /// **'Das Foto konnte nicht angekündigt werden. Bitte später noch einmal versuchen.'**
  String get fotoFehler;

  /// No description provided for @fotoStatusWartet.
  ///
  /// In de, this message translates to:
  /// **'Foto kommt, sobald ihr beide die App offen habt'**
  String get fotoStatusWartet;

  /// No description provided for @fotoStatusLaedt.
  ///
  /// In de, this message translates to:
  /// **'Foto wird übertragen …'**
  String get fotoStatusLaedt;

  /// No description provided for @fotoAnsehen.
  ///
  /// In de, this message translates to:
  /// **'Foto ansehen (nur einmal)'**
  String get fotoAnsehen;

  /// No description provided for @fotoStatusAngesehen.
  ///
  /// In de, this message translates to:
  /// **'Foto angesehen'**
  String get fotoStatusAngesehen;

  /// No description provided for @fotoStatusWartetRaus.
  ///
  /// In de, this message translates to:
  /// **'Wartet auf dein Gegenüber'**
  String get fotoStatusWartetRaus;

  /// No description provided for @fotoStatusZugestellt.
  ///
  /// In de, this message translates to:
  /// **'Zugestellt'**
  String get fotoStatusZugestellt;

  /// No description provided for @fotoStatusFehler.
  ///
  /// In de, this message translates to:
  /// **'Nicht zugestellt'**
  String get fotoStatusFehler;

  /// No description provided for @fotoAnsichtHinweis.
  ///
  /// In de, this message translates to:
  /// **'Nur jetzt sichtbar. Beim Schließen ist das Foto gelöscht.'**
  String get fotoAnsichtHinweis;

  /// No description provided for @fotoWeg.
  ///
  /// In de, this message translates to:
  /// **'Dieses Foto ist nicht mehr da.'**
  String get fotoWeg;

  /// No description provided for @anleitungTitel.
  ///
  /// In de, this message translates to:
  /// **'So funktioniert VelvetPulse'**
  String get anleitungTitel;

  /// No description provided for @anleitungEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Hier findest du alle Bereiche der App kurz erklärt. Tippe auf einen Abschnitt, um ihn aufzuklappen.'**
  String get anleitungEinleitung;

  /// No description provided for @fotoIdeeTitel.
  ///
  /// In de, this message translates to:
  /// **'FOTO-IDEE FÜR HEUTE'**
  String get fotoIdeeTitel;

  /// No description provided for @fotoIdeeHinweis.
  ///
  /// In de, this message translates to:
  /// **'Ganz freiwillig. Ohne Gesicht ist am sichersten.'**
  String get fotoIdeeHinweis;

  /// No description provided for @fotoIdeeAndere.
  ///
  /// In de, this message translates to:
  /// **'Andere Idee'**
  String get fotoIdeeAndere;

  /// No description provided for @fotoIdeeHeuteNicht.
  ///
  /// In de, this message translates to:
  /// **'Heute nicht'**
  String get fotoIdeeHeuteNicht;

  /// No description provided for @fotoIdeenAnzeigen.
  ///
  /// In de, this message translates to:
  /// **'Foto-Ideen anzeigen'**
  String get fotoIdeenAnzeigen;

  /// No description provided for @fotoIdeeHinweisHeiss.
  ///
  /// In de, this message translates to:
  /// **'Ganz freiwillig. Bitte ohne Gesicht, Tattoos oder erkennbaren Raum.'**
  String get fotoIdeeHinweisHeiss;

  /// No description provided for @fotoAlleinTitel.
  ///
  /// In de, this message translates to:
  /// **'Bist du allein?'**
  String get fotoAlleinTitel;

  /// No description provided for @fotoAlleinText.
  ///
  /// In de, this message translates to:
  /// **'Das Foto lässt sich nur einmal ansehen. Schau es dir am besten an, wenn du allein bist und dir niemand über die Schulter schaut.'**
  String get fotoAlleinText;

  /// No description provided for @fotoJetztAnsehen.
  ///
  /// In de, this message translates to:
  /// **'Jetzt ansehen'**
  String get fotoJetztAnsehen;

  /// No description provided for @fotoSpaeter.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get fotoSpaeter;

  /// No description provided for @fotoExperimentell.
  ///
  /// In de, this message translates to:
  /// **'Experimentell'**
  String get fotoExperimentell;

  /// No description provided for @fotoExperimentellHinweis.
  ///
  /// In de, this message translates to:
  /// **'Fotos sind neu: In manchen Mobilfunknetzen kommt die direkte Verbindung noch nicht zustande.'**
  String get fotoExperimentellHinweis;

  /// No description provided for @pairingAnfrageTitel.
  ///
  /// In de, this message translates to:
  /// **'Dein Code wurde gescannt'**
  String get pairingAnfrageTitel;

  /// No description provided for @pairingAnfrageText.
  ///
  /// In de, this message translates to:
  /// **'Ein Handy hat gerade deinen Code gescannt und möchte sich mit dir verbinden. Bestätige nur, wenn es das Handy deines Gegenübers ist.'**
  String get pairingAnfrageText;

  /// No description provided for @pairingAnfrageVerbinden.
  ///
  /// In de, this message translates to:
  /// **'Verbinden'**
  String get pairingAnfrageVerbinden;

  /// No description provided for @rueckmeldungTitel.
  ///
  /// In de, this message translates to:
  /// **'Rückmeldung senden'**
  String get rueckmeldungTitel;

  /// No description provided for @rueckmeldungEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Ein Wunsch für eine neue Funktion, ein Fehler oder ein Wort, das falsch klingt? Schreib es uns, anonym und verschlüsselt.'**
  String get rueckmeldungEinleitung;

  /// No description provided for @rueckmeldungWunsch.
  ///
  /// In de, this message translates to:
  /// **'Wunsch'**
  String get rueckmeldungWunsch;

  /// No description provided for @rueckmeldungFehlerArt.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get rueckmeldungFehlerArt;

  /// No description provided for @rueckmeldungAussprache.
  ///
  /// In de, this message translates to:
  /// **'Aussprache'**
  String get rueckmeldungAussprache;

  /// No description provided for @rueckmeldungNachricht.
  ///
  /// In de, this message translates to:
  /// **'Deine Nachricht'**
  String get rueckmeldungNachricht;

  /// No description provided for @rueckmeldungFehlerHinweis.
  ///
  /// In de, this message translates to:
  /// **'Was ist passiert, und wo in der App?'**
  String get rueckmeldungFehlerHinweis;

  /// No description provided for @rueckmeldungWort.
  ///
  /// In de, this message translates to:
  /// **'Welches Wort klingt falsch?'**
  String get rueckmeldungWort;

  /// No description provided for @rueckmeldungSoll.
  ///
  /// In de, this message translates to:
  /// **'So sollte es klingen (freiwillig)'**
  String get rueckmeldungSoll;

  /// No description provided for @rueckmeldungSollHinweis.
  ///
  /// In de, this message translates to:
  /// **'z. B. Betonung auf der zweiten Silbe'**
  String get rueckmeldungSollHinweis;

  /// No description provided for @rueckmeldungAnmerkung.
  ///
  /// In de, this message translates to:
  /// **'Anmerkung (freiwillig)'**
  String get rueckmeldungAnmerkung;

  /// No description provided for @rueckmeldungKontakt.
  ///
  /// In de, this message translates to:
  /// **'Kontakt für Rückfragen (freiwillig)'**
  String get rueckmeldungKontakt;

  /// No description provided for @rueckmeldungKontaktHinweis.
  ///
  /// In de, this message translates to:
  /// **'z. B. E-Mail oder Nostr-npub'**
  String get rueckmeldungKontaktHinweis;

  /// No description provided for @rueckmeldungDatenschutz.
  ///
  /// In de, this message translates to:
  /// **'Die Nachricht geht verschlüsselt über Nostr an das Rückmelde-Postfach von VelvetPulse, mit einem Einmal-Schlüssel, ohne Bezug zu deinem Paar-Kanal. Übertragen wird nur, was hier steht, dazu App-Version und Sprache. Die Server sehen deine IP-Adresse, nicht den Inhalt.'**
  String get rueckmeldungDatenschutz;

  /// No description provided for @rueckmeldungSenden.
  ///
  /// In de, this message translates to:
  /// **'Anonym senden'**
  String get rueckmeldungSenden;

  /// No description provided for @rueckmeldungDanke.
  ///
  /// In de, this message translates to:
  /// **'Danke! Deine Rückmeldung ist angekommen.'**
  String get rueckmeldungDanke;

  /// No description provided for @rueckmeldungFehler.
  ///
  /// In de, this message translates to:
  /// **'Senden hat nicht geklappt. Bitte prüfe die Internetverbindung und versuch es noch einmal.'**
  String get rueckmeldungFehler;

  /// No description provided for @rueckmeldungGithub.
  ///
  /// In de, this message translates to:
  /// **'Lieber öffentlich auf GitHub melden'**
  String get rueckmeldungGithub;

  /// No description provided for @einschlafKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Einschlafen'**
  String get einschlafKarteTitel;

  /// No description provided for @einschlafKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Entspannung'**
  String get einschlafKarteTitelNeutral;

  /// No description provided for @einschlafKarteText.
  ///
  /// In de, this message translates to:
  /// **'Eine lange, ruhige Reise in den Schlaf: 60 bis 120 Minuten mit Sätzen, die du im Halbschlaf mitnimmst.'**
  String get einschlafKarteText;

  /// No description provided for @einschlafTitel.
  ///
  /// In de, this message translates to:
  /// **'Einschlaf-Reise'**
  String get einschlafTitel;

  /// No description provided for @einschlafEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Eine Stimme begleitet dich im Bett in den Schlaf. Sie spricht immer weniger, die Pausen werden länger, und zum Schluss bleibt nur ein leiser Klang. Du darfst und sollst dabei einschlafen.'**
  String get einschlafEinleitung;

  /// No description provided for @einschlafWirkung.
  ///
  /// In de, this message translates to:
  /// **'Die Sätze wirken vor allem in der ruhigen Zeit, bevor du einschläfst, und durch die Wiederholung an vielen Abenden. Gelernt wird nicht im Tiefschlaf.'**
  String get einschlafWirkung;

  /// No description provided for @einschlafHinweise.
  ///
  /// In de, this message translates to:
  /// **'Nicht beim Autofahren oder wenn du wach bleiben musst. Stell es leise ein; Kopfhörer nur, wenn sie bequem sind, sonst den Lautsprecher. Am besten mit Ladekabel. Die Einschlaf-Reise ersetzt keine Behandlung von Schlafstörungen.'**
  String get einschlafHinweise;

  /// No description provided for @einschlafLaenge.
  ///
  /// In de, this message translates to:
  /// **'Länge'**
  String get einschlafLaenge;

  /// No description provided for @einschlafSchwerpunkt.
  ///
  /// In de, this message translates to:
  /// **'Schwerpunkt'**
  String get einschlafSchwerpunkt;

  /// No description provided for @traumKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Traum-Abend'**
  String get traumKarteTitel;

  /// No description provided for @traumKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Ruhe'**
  String get traumKarteTitelNeutral;

  /// No description provided for @traumKarteText.
  ///
  /// In de, this message translates to:
  /// **'Sanft in den Schlaf und in einen sinnlichen Traum: 30 bis 60 Minuten mit einem Traumbild deiner Wahl.'**
  String get traumKarteText;

  /// No description provided for @traumTitel.
  ///
  /// In de, this message translates to:
  /// **'Traum-Abend'**
  String get traumTitel;

  /// No description provided for @traumEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Eine Stimme begleitet dich in den Schlaf und legt dir ein Traumbild nahe. Danach wiederholt sie leise deine Traum-Absicht, mit immer längeren Pausen, bis nur Stille bleibt. Du darfst dabei einschlafen.'**
  String get traumEinleitung;

  /// No description provided for @traumBild.
  ///
  /// In de, this message translates to:
  /// **'Traumbild'**
  String get traumBild;

  /// No description provided for @traumBildWarmesWasser.
  ///
  /// In de, this message translates to:
  /// **'Warmes Wasser'**
  String get traumBildWarmesWasser;

  /// No description provided for @traumBildOrtFuerMich.
  ///
  /// In de, this message translates to:
  /// **'Ein Ort für mich'**
  String get traumBildOrtFuerMich;

  /// No description provided for @traumBildKoerperImLicht.
  ///
  /// In de, this message translates to:
  /// **'Körper im Licht'**
  String get traumBildKoerperImLicht;

  /// No description provided for @traumBildBegegnung.
  ///
  /// In de, this message translates to:
  /// **'Begegnung'**
  String get traumBildBegegnung;

  /// No description provided for @traumBildKlarheit.
  ///
  /// In de, this message translates to:
  /// **'Klarheit'**
  String get traumBildKlarheit;

  /// No description provided for @einschlafUeberrasch.
  ///
  /// In de, this message translates to:
  /// **'Überrasch mich'**
  String get einschlafUeberrasch;

  /// No description provided for @einschlafThemaKoerper.
  ///
  /// In de, this message translates to:
  /// **'Mein Körper ist willkommen'**
  String get einschlafThemaKoerper;

  /// No description provided for @einschlafThemaWelle.
  ///
  /// In de, this message translates to:
  /// **'Lust ist eine Welle'**
  String get einschlafThemaWelle;

  /// No description provided for @einschlafThemaGaspedal.
  ///
  /// In de, this message translates to:
  /// **'Gaspedal und Bremse'**
  String get einschlafThemaGaspedal;

  /// No description provided for @einschlafThemaSpueren.
  ///
  /// In de, this message translates to:
  /// **'Spüren statt beobachten'**
  String get einschlafThemaSpueren;

  /// No description provided for @einschlafThemaBecken.
  ///
  /// In de, this message translates to:
  /// **'Ein weiches Becken'**
  String get einschlafThemaBecken;

  /// No description provided for @einschlafThemaGeniessen.
  ///
  /// In de, this message translates to:
  /// **'Ich darf genießen'**
  String get einschlafThemaGeniessen;

  /// No description provided for @einschlafOhneBezug.
  ///
  /// In de, this message translates to:
  /// **'Ohne Bezug'**
  String get einschlafOhneBezug;

  /// No description provided for @einschlafSpicyTitel.
  ///
  /// In de, this message translates to:
  /// **'Deutlichere Worte'**
  String get einschlafSpicyTitel;

  /// No description provided for @einschlafSpicyText.
  ///
  /// In de, this message translates to:
  /// **'Ruhige, anatomische Sprache für dein eigenes Geschlecht. Kein Dirty Talk, nichts Aufregendes.'**
  String get einschlafSpicyText;

  /// No description provided for @einschlafStart.
  ///
  /// In de, this message translates to:
  /// **'Einschlaf-Reise beginnen'**
  String get einschlafStart;

  /// No description provided for @einschlafLaeuft.
  ///
  /// In de, this message translates to:
  /// **'Du darfst einschlafen'**
  String get einschlafLaeuft;

  /// No description provided for @einschlafLaeuftText.
  ///
  /// In de, this message translates to:
  /// **'Die Stimme wird leiser und seltener. Am Ende stoppt alles von selbst.'**
  String get einschlafLaeuftText;

  /// No description provided for @einschlafBeenden.
  ///
  /// In de, this message translates to:
  /// **'Einschlaf-Reise beenden?'**
  String get einschlafBeenden;

  /// No description provided for @einschlafBeendenText.
  ///
  /// In de, this message translates to:
  /// **'Die Begleitung hört dann auf.'**
  String get einschlafBeendenText;

  /// No description provided for @aufnahmenTitel.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen'**
  String get aufnahmenTitel;

  /// No description provided for @aufnahmenText.
  ///
  /// In de, this message translates to:
  /// **'Die gesprochenen Aufnahmen von Victoria und Martin lädst du hier nach, am besten im WLAN. Ohne sie liest die Stimme deines Handys vor.'**
  String get aufnahmenText;

  /// No description provided for @aufnahmenLektionen.
  ///
  /// In de, this message translates to:
  /// **'Lektionen'**
  String get aufnahmenLektionen;

  /// No description provided for @aufnahmenGefuehrt.
  ///
  /// In de, this message translates to:
  /// **'Geführte Audios'**
  String get aufnahmenGefuehrt;

  /// No description provided for @aufnahmenGroesse.
  ///
  /// In de, this message translates to:
  /// **'{mb} MB'**
  String aufnahmenGroesse(int mb);

  /// No description provided for @aufnahmenInstalliert.
  ///
  /// In de, this message translates to:
  /// **'geladen, {mb} MB'**
  String aufnahmenInstalliert(int mb);

  /// No description provided for @aufnahmenLaden.
  ///
  /// In de, this message translates to:
  /// **'Laden'**
  String get aufnahmenLaden;

  /// No description provided for @aufnahmenAlleLaden.
  ///
  /// In de, this message translates to:
  /// **'Alle laden ({mb} MB)'**
  String aufnahmenAlleLaden(int mb);

  /// No description provided for @aufnahmenFertig.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen geladen.'**
  String get aufnahmenFertig;

  /// No description provided for @aufnahmenFehler.
  ///
  /// In de, this message translates to:
  /// **'Laden hat nicht geklappt. Bitte prüfe die Internetverbindung und versuch es noch einmal.'**
  String get aufnahmenFehler;

  /// No description provided for @aufnahmenNichtErreichbar.
  ///
  /// In de, this message translates to:
  /// **'Das Verzeichnis der Aufnahmen ist gerade nicht erreichbar. Bitte später noch einmal versuchen.'**
  String get aufnahmenNichtErreichbar;

  /// No description provided for @aufnahmenHinweisTitel.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen laden'**
  String get aufnahmenHinweisTitel;

  /// No description provided for @aufnahmenHinweisText.
  ///
  /// In de, this message translates to:
  /// **'Damit Victoria und Martin die Lektionen und geführten Audios sprechen, lade einmal die Aufnahmen. Bis dahin liest die Stimme deines Handys vor.'**
  String get aufnahmenHinweisText;

  /// No description provided for @aufnahmenSpaeter.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get aufnahmenSpaeter;

  /// No description provided for @aufnahmenAnsehen.
  ///
  /// In de, this message translates to:
  /// **'Ansehen'**
  String get aufnahmenAnsehen;

  /// No description provided for @fotoErneutVersuchen.
  ///
  /// In de, this message translates to:
  /// **'Jetzt erneut versuchen'**
  String get fotoErneutVersuchen;

  /// No description provided for @fotoStatusWeg.
  ///
  /// In de, this message translates to:
  /// **'Foto nicht mehr verfügbar'**
  String get fotoStatusWeg;

  /// No description provided for @tagebuchTitel.
  ///
  /// In de, this message translates to:
  /// **'Traumtagebuch'**
  String get tagebuchTitel;

  /// No description provided for @tagebuchTipp.
  ///
  /// In de, this message translates to:
  /// **'Gleich nach dem Aufwachen kurz still liegen bleiben und den Traum zurückholen, bevor du dich bewegst. Ein paar Stichworte reichen. Auch „nichts erinnert“ zählt.'**
  String get tagebuchTipp;

  /// No description provided for @tagebuchPause.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt hast du öfter unangenehme Träume oder schlechten Schlaf notiert. Das ist normal und kein Fehler. Vielleicht tut dir eine Pause gut oder nur Tagebuch und sanfte Traumbilder. Wenn dich etwas belastet, hilft der SOS-Knopf.'**
  String get tagebuchPause;

  /// No description provided for @tagebuchWoranErinnerst.
  ///
  /// In de, this message translates to:
  /// **'Woran erinnerst du dich?'**
  String get tagebuchWoranErinnerst;

  /// No description provided for @tagebuchNichtsErinnert.
  ///
  /// In de, this message translates to:
  /// **'Nichts erinnert'**
  String get tagebuchNichtsErinnert;

  /// No description provided for @tagebuchPrivat.
  ///
  /// In de, this message translates to:
  /// **'Dein Traumtagebuch ist privat. Sinnliche Träume sind ein Zeichen, dass deine Lust lebendig ist. Wer darin vorkommt und was geschieht, muss nichts bedeuten. Die Einträge gehen nicht an den KI-Coach und nicht an dein Gegenüber; sie sind Teil deiner verschlüsselten Sicherung.'**
  String get tagebuchPrivat;

  /// No description provided for @tagebuchHinweisText.
  ///
  /// In de, this message translates to:
  /// **'Stichworte, ein Bild, ein Gefühl …'**
  String get tagebuchHinweisText;

  /// No description provided for @tagebuchLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get tagebuchLoeschen;

  /// No description provided for @tagebuchSpeichern.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get tagebuchSpeichern;

  /// No description provided for @tagebuchMarkeErinnert.
  ///
  /// In de, this message translates to:
  /// **'erinnert'**
  String get tagebuchMarkeErinnert;

  /// No description provided for @tagebuchMarkeLuzide.
  ///
  /// In de, this message translates to:
  /// **'luzide'**
  String get tagebuchMarkeLuzide;

  /// No description provided for @tagebuchMarkeSinnlich.
  ///
  /// In de, this message translates to:
  /// **'sinnlich'**
  String get tagebuchMarkeSinnlich;

  /// No description provided for @tagebuchMarkeHoehepunkt.
  ///
  /// In de, this message translates to:
  /// **'Höhepunkt'**
  String get tagebuchMarkeHoehepunkt;

  /// No description provided for @tagebuchMarkeUnangenehm.
  ///
  /// In de, this message translates to:
  /// **'unangenehm'**
  String get tagebuchMarkeUnangenehm;

  /// No description provided for @tagebuchMarkeSchlechtGeschlafen.
  ///
  /// In de, this message translates to:
  /// **'schlecht geschlafen'**
  String get tagebuchMarkeSchlechtGeschlafen;

  /// No description provided for @tagebuchKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Woran erinnerst du dich?'**
  String get tagebuchKarteTitel;

  /// No description provided for @tagebuchKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Morgennotiz'**
  String get tagebuchKarteTitelNeutral;

  /// No description provided for @tagebuchKarteText.
  ///
  /// In de, this message translates to:
  /// **'Halte deinen Traum fest, solange er noch nah ist. Ein paar Worte genügen.'**
  String get tagebuchKarteText;

  /// No description provided for @tagebuchKarteTextNeutral.
  ///
  /// In de, this message translates to:
  /// **'Ein paar Worte für dich, gleich am Morgen.'**
  String get tagebuchKarteTextNeutral;

  /// No description provided for @traumpraxisTitel.
  ///
  /// In de, this message translates to:
  /// **'Deine Traumpraxis'**
  String get traumpraxisTitel;

  /// No description provided for @praxisZeichenTitel.
  ///
  /// In de, this message translates to:
  /// **'Deine Traumzeichen'**
  String get praxisZeichenTitel;

  /// No description provided for @praxisZeichenText.
  ///
  /// In de, this message translates to:
  /// **'Was taucht in deinen Träumen wieder auf? Ein Ort, ein unmöglicher Übergang, ein besonderes Licht? Benenne ein Zeichen, an dem du einen Traum erkennen möchtest.'**
  String get praxisZeichenText;

  /// No description provided for @praxisZeichenLeer.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Traumzeichen. Du kannst mit einem Detail aus deinem Tagebuch beginnen.'**
  String get praxisZeichenLeer;

  /// No description provided for @praxisZeichenFeld.
  ///
  /// In de, this message translates to:
  /// **'Mein Traumzeichen'**
  String get praxisZeichenFeld;

  /// No description provided for @praxisZeichenBeispiel.
  ///
  /// In de, this message translates to:
  /// **'Zum Beispiel: eine Tür an einem unmöglichen Ort'**
  String get praxisZeichenBeispiel;

  /// No description provided for @praxisHinzufuegen.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get praxisHinzufuegen;

  /// No description provided for @praxisSpeichern.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get praxisSpeichern;

  /// No description provided for @praxisAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get praxisAbbrechen;

  /// No description provided for @praxisBearbeiten.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get praxisBearbeiten;

  /// No description provided for @praxisLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get praxisLoeschen;

  /// No description provided for @praxisLoeschenFrage.
  ///
  /// In de, this message translates to:
  /// **'Diesen Eintrag löschen?'**
  String get praxisLoeschenFrage;

  /// No description provided for @praxisLoeschenText.
  ///
  /// In de, this message translates to:
  /// **'Der Eintrag wird entfernt. Eine spätere Wiederherstellung einer älteren Sicherung holt ihn nicht automatisch zurück.'**
  String get praxisLoeschenText;

  /// No description provided for @praxisFehler.
  ///
  /// In de, this message translates to:
  /// **'Das Speichern hat nicht geklappt. Deine bisherigen Daten bleiben erhalten. Bitte versuche es erneut.'**
  String get praxisFehler;

  /// No description provided for @praxisZeichenWaehlen.
  ///
  /// In de, this message translates to:
  /// **'Ein Zeichen für heute Abend'**
  String get praxisZeichenWaehlen;

  /// No description provided for @praxisZeichenAbsicht.
  ///
  /// In de, this message translates to:
  /// **'Stell dir vor, dieses Zeichen erscheint in deinem Traum. Du bemerkst es und erkennst: Ich träume. Danach darf deine persönliche Absicht ruhen.'**
  String get praxisZeichenAbsicht;

  /// No description provided for @praxisAbendStart.
  ///
  /// In de, this message translates to:
  /// **'Zu deiner Abendfolge'**
  String get praxisAbendStart;

  /// No description provided for @praxisBeobachten.
  ///
  /// In de, this message translates to:
  /// **'Heute nachspüren'**
  String get praxisBeobachten;

  /// No description provided for @praxisBeobachtungTitel.
  ///
  /// In de, this message translates to:
  /// **'Deine Tagesbeobachtung'**
  String get praxisBeobachtungTitel;

  /// No description provided for @praxisBeobachtungText.
  ///
  /// In de, this message translates to:
  /// **'Was beobachtest du heute? Du kannst einzelne Fragen offenlassen. Ein erlebter Höhepunkt ist eine Möglichkeit, kein Ziel für jeden Abend.'**
  String get praxisBeobachtungText;

  /// No description provided for @praxisSchlaf.
  ///
  /// In de, this message translates to:
  /// **'Wie erholt bist du?'**
  String get praxisSchlaf;

  /// No description provided for @praxisLust.
  ///
  /// In de, this message translates to:
  /// **'Wie fühlt sich deine Lust heute an?'**
  String get praxisLust;

  /// No description provided for @praxisUnbeantwortet.
  ///
  /// In de, this message translates to:
  /// **'Offenlassen'**
  String get praxisUnbeantwortet;

  /// No description provided for @praxisSchlaf0.
  ///
  /// In de, this message translates to:
  /// **'Gar nicht erholt'**
  String get praxisSchlaf0;

  /// No description provided for @praxisSchlaf1.
  ///
  /// In de, this message translates to:
  /// **'Wenig erholt'**
  String get praxisSchlaf1;

  /// No description provided for @praxisSchlaf2.
  ///
  /// In de, this message translates to:
  /// **'Teils erholt'**
  String get praxisSchlaf2;

  /// No description provided for @praxisSchlaf3.
  ///
  /// In de, this message translates to:
  /// **'Gut erholt'**
  String get praxisSchlaf3;

  /// No description provided for @praxisSchlaf4.
  ///
  /// In de, this message translates to:
  /// **'Sehr erholt'**
  String get praxisSchlaf4;

  /// No description provided for @praxisLust0.
  ///
  /// In de, this message translates to:
  /// **'Keine Lust spürbar'**
  String get praxisLust0;

  /// No description provided for @praxisLust1.
  ///
  /// In de, this message translates to:
  /// **'Wenig Lust'**
  String get praxisLust1;

  /// No description provided for @praxisLust2.
  ///
  /// In de, this message translates to:
  /// **'Mittlere Lust'**
  String get praxisLust2;

  /// No description provided for @praxisLust3.
  ///
  /// In de, this message translates to:
  /// **'Deutliche Lust'**
  String get praxisLust3;

  /// No description provided for @praxisLust4.
  ///
  /// In de, this message translates to:
  /// **'Viel Lust'**
  String get praxisLust4;

  /// No description provided for @praxisSinnlich.
  ///
  /// In de, this message translates to:
  /// **'War dein Traum sinnlich?'**
  String get praxisSinnlich;

  /// No description provided for @praxisKlar.
  ///
  /// In de, this message translates to:
  /// **'Wusstest du im Traum, dass du träumst?'**
  String get praxisKlar;

  /// No description provided for @praxisOrgasmus.
  ///
  /// In de, this message translates to:
  /// **'Hast du im Traum einen Orgasmus erlebt?'**
  String get praxisOrgasmus;

  /// No description provided for @praxisJa.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get praxisJa;

  /// No description provided for @praxisNein.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get praxisNein;

  /// No description provided for @praxisNotiz.
  ///
  /// In de, this message translates to:
  /// **'Was möchtest du festhalten?'**
  String get praxisNotiz;

  /// No description provided for @praxisRueckblick.
  ///
  /// In de, this message translates to:
  /// **'Dein privater Rückblick'**
  String get praxisRueckblick;

  /// No description provided for @praxisRueckblickText.
  ///
  /// In de, this message translates to:
  /// **'Hier stehen deine eigenen Beobachtungen. Ähnliche Verläufe können neugierig machen, belegen aber keine Ursache. Es gibt keine Punkte und keine Zielquote.'**
  String get praxisRueckblickText;

  /// No description provided for @praxisRueckblickLeer.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Tagesbeobachtung. Schon eine einzelne Notiz kann ein Anfang sein.'**
  String get praxisRueckblickLeer;

  /// No description provided for @praxisNurOffeneFelder.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Fragen beantwortet'**
  String get praxisNurOffeneFelder;

  /// No description provided for @praxisPfad.
  ///
  /// In de, this message translates to:
  /// **'Dein Weg für heute'**
  String get praxisPfad;

  /// No description provided for @praxisPfadErinnern.
  ///
  /// In de, this message translates to:
  /// **'Beginne mit Erinnern und Körperwahrnehmung. Die ersten beiden Folgen begleiten dich dabei.'**
  String get praxisPfadErinnern;

  /// No description provided for @praxisPfadErkennen.
  ///
  /// In de, this message translates to:
  /// **'Verbinde ein persönliches Traumzeichen mit deiner Abendvorbereitung. Die Folgen drei bis fünf vertiefen das Erkennen.'**
  String get praxisPfadErkennen;

  /// No description provided for @praxisPfadEntfalten.
  ///
  /// In de, this message translates to:
  /// **'Du kannst Lust im Klartraum erkunden und nachspüren, was du in den Tag mitnehmen möchtest. Die Folgen sechs bis acht geben dir dafür Raum.'**
  String get praxisPfadEntfalten;

  /// No description provided for @traumpraxisNurSpicy.
  ///
  /// In de, this message translates to:
  /// **'Diese Traumpraxis gehört zum Spicy-Modus für Erwachsene.'**
  String get traumpraxisNurSpicy;

  /// No description provided for @traumpraxisEinladung.
  ///
  /// In de, this message translates to:
  /// **'Lust darf über die Nacht hinausreichen.'**
  String get traumpraxisEinladung;

  /// No description provided for @traumpraxisZiel.
  ///
  /// In de, this message translates to:
  /// **'Erkunde sinnliche Träume, das bewusste Erkennen im Traum und das, was davon am Tag nachklingen darf. Ein Höhepunkt kann dazugehören. Du bestimmst, wie weit du gehen möchtest.'**
  String get traumpraxisZiel;

  /// No description provided for @traumpraxisErinnern.
  ///
  /// In de, this message translates to:
  /// **'Am Morgen · Erinnern'**
  String get traumpraxisErinnern;

  /// No description provided for @traumpraxisErinnernText.
  ///
  /// In de, this message translates to:
  /// **'Halte fest, woran du dich erinnerst: einen Ort, eine Empfindung, eine Begegnung. Sinnlichkeit, Klarheit und ein erlebter Höhepunkt dürfen im Tagebuch markiert werden. Auch ein Traum ohne Höhepunkt oder eine Nacht ohne Erinnerung gehört dazu.'**
  String get traumpraxisErinnernText;

  /// No description provided for @traumpraxisErkennen.
  ///
  /// In de, this message translates to:
  /// **'Am Abend · Erkennen üben'**
  String get traumpraxisErkennen;

  /// No description provided for @traumpraxisMildEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Diese Vorstellungsübung orientiert sich an MILD: Du verbindest die Erinnerung an einen Traum mit der Absicht, den nächsten Traum zu erkennen. Übe kurz und ohne dich wachzuhalten. Einen zusätzlichen Wecker brauchst du dafür nicht.'**
  String get traumpraxisMildEinleitung;

  /// No description provided for @traumpraxisVorlage.
  ///
  /// In de, this message translates to:
  /// **'Eine angenehme Traumerinnerung'**
  String get traumpraxisVorlage;

  /// No description provided for @traumpraxisOhneEintrag.
  ///
  /// In de, this message translates to:
  /// **'Noch kein passender Eintrag? Erinnere dich an einen angenehmen Traum. Du kannst zunächst auch nur einen vertrauten Ort vor Augen haben und das bewusste Erkennen üben.'**
  String get traumpraxisOhneEintrag;

  /// No description provided for @traumpraxisMildSchritte.
  ///
  /// In de, this message translates to:
  /// **'Rufe deinen Traum ruhig in Erinnerung. Wo war etwas ungewöhnlich? Vielleicht ein Ort, der sich verändert hat, oder ein unmöglicher Übergang.\n\nStell dir dieselbe Stelle noch einmal vor. Diesmal bemerkst du sie und erkennst: Ich träume. Lass die Vorstellung für einen Moment bestehen, ohne eine Handlung erzwingen zu müssen.'**
  String get traumpraxisMildSchritte;

  /// No description provided for @traumpraxisAbsicht.
  ///
  /// In de, this message translates to:
  /// **'Wenn ich wieder träume, möchte ich mich daran erinnern, dass ich träume.'**
  String get traumpraxisAbsicht;

  /// No description provided for @traumpraxisLoslassen.
  ///
  /// In de, this message translates to:
  /// **'Danach darf die Absicht ruhen. Du darfst einschlafen. Wenn die Übung dich wacher macht, lässt du sie für heute los. Die acht Abendfolgen stehen dir weiterhin zur Verfügung.'**
  String get traumpraxisLoslassen;

  /// No description provided for @traumpraxisRuhe.
  ///
  /// In de, this message translates to:
  /// **'Heute darf Ruhe genügen'**
  String get traumpraxisRuhe;

  /// No description provided for @traumpraxisMitnehmen.
  ///
  /// In de, this message translates to:
  /// **'Am Tag · Das Angenehme mitnehmen'**
  String get traumpraxisMitnehmen;

  /// No description provided for @traumpraxisMitnehmenText.
  ///
  /// In de, this message translates to:
  /// **'Wenn dein Traum angenehm war, erinnere dich an eine Empfindung: Wärme, Leichtigkeit oder Nähe. Was davon ist jetzt, im wachen Körper, noch spürbar? Es darf viel sein, wenig oder gar nichts. Bei einem belastenden Traum lässt du diese Übung aus.'**
  String get traumpraxisMitnehmenText;

  /// No description provided for @traumpraxisNachspueren.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine kleine, freiwillige sinnliche Erfahrung für deinen Tag: warmes Wasser auf der Haut, einen weichen Stoff oder einen Moment ungestörter Körperwahrnehmung. Spüre danach nach: Hat sich deine Lust verändert? Deine Neugier? Oder vor allem deine Ruhe? Notiere deine eigene Beobachtung, ohne sie bewerten zu müssen.'**
  String get traumpraxisNachspueren;

  /// No description provided for @traumpraxisNotieren.
  ///
  /// In de, this message translates to:
  /// **'Im Tagebuch nachspüren'**
  String get traumpraxisNotieren;

  /// No description provided for @traumpraxisHoehepunkt.
  ///
  /// In de, this message translates to:
  /// **'Wenn du im Traum einen Orgasmus erlebst'**
  String get traumpraxisHoehepunkt;

  /// No description provided for @traumpraxisHoehepunktText.
  ///
  /// In de, this message translates to:
  /// **'Du darfst das Erlebnis genießen und festhalten, auch wenn es sich wiederholt. Die App misst keine körperlichen Reaktionen: Ein erinnerter Orgasmus im Traum ist ein berichtetes Erlebnis, kein körperlicher Messbefund. Du musst weder im Traum bleiben noch einen weiteren Höhepunkt erreichen.'**
  String get traumpraxisHoehepunktText;

  /// No description provided for @traumpraxisHoeren.
  ///
  /// In de, this message translates to:
  /// **'Zum Hören'**
  String get traumpraxisHoeren;

  /// No description provided for @traumpraxisHoerenText.
  ///
  /// In de, this message translates to:
  /// **'Drei kurze Begleitungen mit Victoria oder Martin. Sie ergänzen die Praxis, ersetzen nichts davon und enden von selbst. Nur für dich allein, nicht für das gemeinsame Hören.'**
  String get traumpraxisHoerenText;

  /// No description provided for @traumpraxisHoerenAbend.
  ///
  /// In de, this message translates to:
  /// **'Einmal vor dem Einschlafen oder vor einer Abendfolge.'**
  String get traumpraxisHoerenAbend;

  /// No description provided for @traumpraxisHoerenKlarheit.
  ///
  /// In de, this message translates to:
  /// **'Tagsüber oder am frühen Abend, wach und im Sitzen oder Liegen.'**
  String get traumpraxisHoerenKlarheit;

  /// No description provided for @traumpraxisHoerenMorgen.
  ///
  /// In de, this message translates to:
  /// **'Nach dem Aufwachen oder in einem ruhigen Moment am Tag, danach gern die Tagesbeobachtung.'**
  String get traumpraxisHoerenMorgen;

  /// No description provided for @traumpraxisHoerenStarten.
  ///
  /// In de, this message translates to:
  /// **'Anhören'**
  String get traumpraxisHoerenStarten;

  /// No description provided for @traumpraxisHoerenPaket.
  ///
  /// In de, this message translates to:
  /// **'Der Inhalt dieser Begleitungen kommt mit den Aufnahmen. Lade sie in der Paketverwaltung nach, dann erscheinen die Titel hier.'**
  String get traumpraxisHoerenPaket;

  /// No description provided for @audioFuerHeute.
  ///
  /// In de, this message translates to:
  /// **'Für heute'**
  String get audioFuerHeute;

  /// No description provided for @audioAlleAnzeigen.
  ///
  /// In de, this message translates to:
  /// **'Alle anzeigen'**
  String get audioAlleAnzeigen;

  /// No description provided for @audioGruppeFuerMich.
  ///
  /// In de, this message translates to:
  /// **'Für mich'**
  String get audioGruppeFuerMich;

  /// No description provided for @audioGruppeFuerMichText.
  ///
  /// In de, this message translates to:
  /// **'Zeit nur für dich: deinen Körper spüren, dich erkunden, Träume bewusster erleben. Du bestimmst Länge und Nähe.'**
  String get audioGruppeFuerMichText;

  /// No description provided for @audioGruppeFuerUns.
  ///
  /// In de, this message translates to:
  /// **'Für uns'**
  String get audioGruppeFuerUns;

  /// No description provided for @audioGruppeFuerUnsText.
  ///
  /// In de, this message translates to:
  /// **'Zu zweit hören oder abwechselnd geben und empfangen. Eine Stimme führt, ihr bestimmt das Tempo.'**
  String get audioGruppeFuerUnsText;

  /// No description provided for @audioGruppeNacht.
  ///
  /// In de, this message translates to:
  /// **'Nacht'**
  String get audioGruppeNacht;

  /// No description provided for @audioGruppeNachtNeutral.
  ///
  /// In de, this message translates to:
  /// **'Ruhe'**
  String get audioGruppeNachtNeutral;

  /// No description provided for @audioGruppeNachtText.
  ///
  /// In de, this message translates to:
  /// **'Zum Einschlafen, für den Traum-Abend und zum Wiedereinschlafen. Die Stimme wird leiser, du darfst einschlafen.'**
  String get audioGruppeNachtText;

  /// No description provided for @audioGruppeGeschichten.
  ///
  /// In de, this message translates to:
  /// **'Geschichten'**
  String get audioGruppeGeschichten;

  /// No description provided for @audioGruppeGeschichtenNeutral.
  ///
  /// In de, this message translates to:
  /// **'Hörgeschichten'**
  String get audioGruppeGeschichtenNeutral;

  /// No description provided for @audioGruppeGeschichtenText.
  ///
  /// In de, this message translates to:
  /// **'Zusammenhängende Hörgeschichten für Erwachsene, nicht zum Einschlafen. Du wählst Perspektive und Intensität.'**
  String get audioGruppeGeschichtenText;

  /// No description provided for @audioGemeinsamTitel.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam hören'**
  String get audioGemeinsamTitel;

  /// No description provided for @audioGemeinsamText.
  ///
  /// In de, this message translates to:
  /// **'Startet eine Aufnahme und tippt im Player auf „Gemeinsam hören“. Beide brauchen dieselbe Aufnahme auf dem Gerät; ihr hört im selben Takt und beide können pausieren.'**
  String get audioGemeinsamText;

  /// No description provided for @traumpraxisKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Traumpraxis'**
  String get traumpraxisKarteTitel;

  /// No description provided for @traumpraxisKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Praxis'**
  String get traumpraxisKarteTitelNeutral;

  /// No description provided for @traumpraxisKarteText.
  ///
  /// In de, this message translates to:
  /// **'Erinnern, erkennen, nachspüren: deine Praxis rund um die Nacht.'**
  String get traumpraxisKarteText;

  /// No description provided for @traumpraxisErkundung.
  ///
  /// In de, this message translates to:
  /// **'Mehr Lust im Traum und im Alltag ist das Ziel dieser Erkundung. Ob diese Übungen deine Tageslust erhöhen, ist offen und individuell zu beobachten. MILD wird zur Klartraumförderung untersucht; diese kurze Abendfassung und der Transfer in den Tag sind keine nachgewiesene Behandlung. Erholsamer Schlaf bleibt wichtiger als ein bestimmtes Traumerlebnis.'**
  String get traumpraxisErkundung;

  /// No description provided for @lustTitel.
  ///
  /// In de, this message translates to:
  /// **'Lust im Traum'**
  String get lustTitel;

  /// No description provided for @lustFolgeN.
  ///
  /// In de, this message translates to:
  /// **'Folge {n}'**
  String lustFolgeN(int n);

  /// No description provided for @lustFolge1.
  ///
  /// In de, this message translates to:
  /// **'Lust im Körper'**
  String get lustFolge1;

  /// No description provided for @lustFolge2.
  ///
  /// In de, this message translates to:
  /// **'Die Welle'**
  String get lustFolge2;

  /// No description provided for @lustFolge3.
  ///
  /// In de, this message translates to:
  /// **'Den Traum einladen'**
  String get lustFolge3;

  /// No description provided for @lustFolge4.
  ///
  /// In de, this message translates to:
  /// **'Erkennen'**
  String get lustFolge4;

  /// No description provided for @lustFolge5.
  ///
  /// In de, this message translates to:
  /// **'Im Klartraum bleiben'**
  String get lustFolge5;

  /// No description provided for @lustFolge6.
  ///
  /// In de, this message translates to:
  /// **'Lust im Traum entfalten'**
  String get lustFolge6;

  /// No description provided for @lustFolge7.
  ///
  /// In de, this message translates to:
  /// **'Mehr als einmal'**
  String get lustFolge7;

  /// No description provided for @lustFolge8.
  ///
  /// In de, this message translates to:
  /// **'Eigene Wege'**
  String get lustFolge8;

  /// No description provided for @lustSerieEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Acht Abende, die aufeinander aufbauen: vom entspannten, lustvollen Körper beim Einschlafen über das Erinnern und Erkennen von Träumen bis zum luziden, sinnlichen Traum. Die nächste Folge wird frei, wenn du die vorige an zwei Abenden gehört hast. Zurückgehen und Wiederholen geht jederzeit.'**
  String get lustSerieEinleitung;

  /// No description provided for @lustEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Eine Stimme begleitet dich in den Schlaf und in die Folge dieses Abends. Danach wiederholt sie leise die Absicht, mit immer längeren Pausen, bis nur Stille bleibt. Du darfst dabei einschlafen.'**
  String get lustEinleitung;

  /// No description provided for @lustEhrlich.
  ///
  /// In de, this message translates to:
  /// **'Ein Höhepunkt im Traum lässt sich einladen, nicht erzwingen. Manche erleben ihn nach wenigen Nächten, manche nach vielen, manche erleben dafür sinnliche Träume ohne Höhepunkt. Alles davon ist richtig.'**
  String get lustEhrlich;

  /// No description provided for @lustFolgen.
  ///
  /// In de, this message translates to:
  /// **'Folgen'**
  String get lustFolgen;

  /// No description provided for @lustTraumkoerper.
  ///
  /// In de, this message translates to:
  /// **'Dein Körper im Traum'**
  String get lustTraumkoerper;

  /// No description provided for @lustTraumkoerperEigener.
  ///
  /// In de, this message translates to:
  /// **'Mein eigener'**
  String get lustTraumkoerperEigener;

  /// No description provided for @lustTraumkoerperFrau.
  ///
  /// In de, this message translates to:
  /// **'Frauenkörper'**
  String get lustTraumkoerperFrau;

  /// No description provided for @lustTraumkoerperMann.
  ///
  /// In de, this message translates to:
  /// **'Männerkörper'**
  String get lustTraumkoerperMann;

  /// No description provided for @lustGegenueber.
  ///
  /// In de, this message translates to:
  /// **'Mit wem im Traum'**
  String get lustGegenueber;

  /// No description provided for @lustGegenueberNiemand.
  ///
  /// In de, this message translates to:
  /// **'Nur ich'**
  String get lustGegenueberNiemand;

  /// No description provided for @lustGegenueberFrau.
  ///
  /// In de, this message translates to:
  /// **'Eine Frau'**
  String get lustGegenueberFrau;

  /// No description provided for @lustGegenueberMann.
  ///
  /// In de, this message translates to:
  /// **'Ein Mann'**
  String get lustGegenueberMann;

  /// No description provided for @lustGegenueberOffen.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get lustGegenueberOffen;

  /// No description provided for @lustWeiter.
  ///
  /// In de, this message translates to:
  /// **'Weiter zum Abend'**
  String get lustWeiter;

  /// No description provided for @lustHinweise.
  ///
  /// In de, this message translates to:
  /// **'Nur ab achtzehn. Kein Ersatz für eine Behandlung bei Schlafstörungen; bei häufigen Albträumen, Epilepsie oder schwerem Schlafmangel lieber nicht. Starke Erregung weckt oft auf, das ist normal. Was im Traum geschieht, ist ein Traumerlebnis; Fantasien darin sagen wenig über Wünsche im Wachleben.'**
  String get lustHinweise;

  /// No description provided for @lustHinweisHandtuch.
  ///
  /// In de, this message translates to:
  /// **'Ein Handtuch in Reichweite ist kein schlechter Gedanke.'**
  String get lustHinweisHandtuch;

  /// No description provided for @lustAbendeGehoert.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =0{noch nicht gehört} =1{an einem Abend gehört} other{an {n} Abenden gehört}}'**
  String lustAbendeGehoert(int n);

  /// No description provided for @lustGesperrt.
  ///
  /// In de, this message translates to:
  /// **'Frei nach zwei Abenden mit Folge {n}'**
  String lustGesperrt(int n);

  /// No description provided for @lustPaketFehlt.
  ///
  /// In de, this message translates to:
  /// **'Für diese Serie fehlen noch die Aufnahmen. Sie kommen als eigenes Paket, am besten im WLAN laden.'**
  String get lustPaketFehlt;

  /// No description provided for @lustPaketLaden.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen laden'**
  String get lustPaketLaden;

  /// No description provided for @lustLadenFehler.
  ///
  /// In de, this message translates to:
  /// **'Laden hat nicht geklappt. Bitte später noch einmal versuchen.'**
  String get lustLadenFehler;

  /// No description provided for @lustKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Lust im Traum'**
  String get lustKarteTitel;

  /// No description provided for @lustKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Abendserie'**
  String get lustKarteTitelNeutral;

  /// No description provided for @lustKarteText.
  ///
  /// In de, this message translates to:
  /// **'Acht Abende, die aufeinander aufbauen, bis zum luziden, sinnlichen Traum.'**
  String get lustKarteText;

  /// No description provided for @lustKarteTextNeutral.
  ///
  /// In de, this message translates to:
  /// **'Acht ruhige Abende, die aufeinander aufbauen.'**
  String get lustKarteTextNeutral;

  /// No description provided for @startSchwerpunkte.
  ///
  /// In de, this message translates to:
  /// **'KURSE NACH SCHWERPUNKTEN'**
  String get startSchwerpunkte;

  /// No description provided for @startLektionenVon.
  ///
  /// In de, this message translates to:
  /// **'{n} von {m} Lektionen'**
  String startLektionenVon(int n, int m);

  /// No description provided for @schwerpunktGrundlagen.
  ///
  /// In de, this message translates to:
  /// **'Grundlagen'**
  String get schwerpunktGrundlagen;

  /// No description provided for @schwerpunktGrundlagenText.
  ///
  /// In de, this message translates to:
  /// **'Wie Kopf und Körper zusammenspielen, wie Erregung funktioniert und warum dein Körper gut ist, wie er ist.'**
  String get schwerpunktGrundlagenText;

  /// No description provided for @schwerpunktAnnehmen.
  ///
  /// In de, this message translates to:
  /// **'Annehmen und Lösen'**
  String get schwerpunktAnnehmen;

  /// No description provided for @schwerpunktAnnehmenText.
  ///
  /// In de, this message translates to:
  /// **'Schmerz, Scham und Druck verstehen, freundlich mit dir sein, den Beckenboden lösen und stärken.'**
  String get schwerpunktAnnehmenText;

  /// No description provided for @schwerpunktEntdecken.
  ///
  /// In de, this message translates to:
  /// **'Sich selbst entdecken'**
  String get schwerpunktEntdecken;

  /// No description provided for @schwerpunktEntdeckenText.
  ///
  /// In de, this message translates to:
  /// **'Den eigenen Körper erkunden: weibliche Lust, neue Reize, Prostata und Damm.'**
  String get schwerpunktEntdeckenText;

  /// No description provided for @schwerpunktPaar.
  ///
  /// In de, this message translates to:
  /// **'Lust als Paar'**
  String get schwerpunktPaar;

  /// No description provided for @schwerpunktPaarText.
  ///
  /// In de, this message translates to:
  /// **'Reden, unterschiedliche Lust, Lebensphasen, Vorfreude und Erotik im Alltag.'**
  String get schwerpunktPaarText;

  /// No description provided for @schwerpunktBeruehrung.
  ///
  /// In de, this message translates to:
  /// **'Berührung'**
  String get schwerpunktBeruehrung;

  /// No description provided for @schwerpunktBeruehrungText.
  ///
  /// In de, this message translates to:
  /// **'Berührung für sie und für ihn, Intim-Massage, Stimme und entspannte Stellungen.'**
  String get schwerpunktBeruehrungText;

  /// No description provided for @schwerpunktFantasie.
  ///
  /// In de, this message translates to:
  /// **'Fantasie und Spiel'**
  String get schwerpunktFantasie;

  /// No description provided for @schwerpunktFantasieText.
  ///
  /// In de, this message translates to:
  /// **'Fantasien, Führung und Hingabe, Kopfkino und Spielzeug.'**
  String get schwerpunktFantasieText;

  /// No description provided for @rueckblickTitel.
  ///
  /// In de, this message translates to:
  /// **'Diese Woche'**
  String get rueckblickTitel;

  /// No description provided for @rueckblickKeineEintraege.
  ///
  /// In de, this message translates to:
  /// **'Keine Notizen in den letzten sieben Tagen.'**
  String get rueckblickKeineEintraege;

  /// No description provided for @rueckblickEintraegeGesamt.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Notiz in den letzten sieben Tagen} other{{n} Notizen in den letzten sieben Tagen}}'**
  String rueckblickEintraegeGesamt(int n);

  /// No description provided for @rueckblickErinnertMorgen.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{An 1 Morgen erinnert} other{An {n} Morgen erinnert}}'**
  String rueckblickErinnertMorgen(int n);

  /// No description provided for @rueckblickNichtsErinnertMorgen.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal nichts erinnert} other{{n} Mal nichts erinnert}}'**
  String rueckblickNichtsErinnertMorgen(int n);

  /// No description provided for @rueckblickMarkeLuzide.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal luzide} other{{n} Mal luzide}}'**
  String rueckblickMarkeLuzide(int n);

  /// No description provided for @rueckblickMarkeSinnlich.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal sinnlich} other{{n} Mal sinnlich}}'**
  String rueckblickMarkeSinnlich(int n);

  /// No description provided for @rueckblickMarkeHoehepunkt.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal Höhepunkt} other{{n} Mal Höhepunkt}}'**
  String rueckblickMarkeHoehepunkt(int n);

  /// No description provided for @rueckblickMarkeUnangenehm.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal unangenehm} other{{n} Mal unangenehm}}'**
  String rueckblickMarkeUnangenehm(int n);

  /// No description provided for @rueckblickMarkeSchlechtGeschlafen.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Mal schlecht geschlafen} other{{n} Mal schlecht geschlafen}}'**
  String rueckblickMarkeSchlechtGeschlafen(int n);

  /// No description provided for @rueckblickNachAbenden.
  ///
  /// In de, this message translates to:
  /// **'Nach den Abenden'**
  String get rueckblickNachAbenden;

  /// No description provided for @rueckblickKeineMarken.
  ///
  /// In de, this message translates to:
  /// **'ohne Markierung'**
  String get rueckblickKeineMarken;

  /// No description provided for @realitaetTitel.
  ///
  /// In de, this message translates to:
  /// **'Realitätscheck'**
  String get realitaetTitel;

  /// No description provided for @realitaetFrage.
  ///
  /// In de, this message translates to:
  /// **'Träume ich gerade?'**
  String get realitaetFrage;

  /// No description provided for @realitaetEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Ein kurzer Moment der Achtsamkeit. Wenn du dich tagsüber fragst, ob du wach bist, taucht diese Gewohnheit auch im Traum auf.'**
  String get realitaetEinleitung;

  /// No description provided for @realitaetUebungHaendeTitel.
  ///
  /// In de, this message translates to:
  /// **'Auf die Hände schauen'**
  String get realitaetUebungHaendeTitel;

  /// No description provided for @realitaetUebungHaendeText.
  ///
  /// In de, this message translates to:
  /// **'Sieh dir deine Handflächen und Finger aufmerksam an. Im Traum verändern Hände oft ihre Form oder Linien.'**
  String get realitaetUebungHaendeText;

  /// No description provided for @realitaetUebungFingerTitel.
  ///
  /// In de, this message translates to:
  /// **'Finger durch die Handfläche'**
  String get realitaetUebungFingerTitel;

  /// No description provided for @realitaetUebungFingerText.
  ///
  /// In de, this message translates to:
  /// **'Drücke sanft mit einem Finger gegen deine andere Handfläche. Stell dir vor, hindurchzugleiten. Im Traum gibt feste Materie manchmal nach.'**
  String get realitaetUebungFingerText;

  /// No description provided for @realitaetUebungTextTitel.
  ///
  /// In de, this message translates to:
  /// **'Text zweimal lesen'**
  String get realitaetUebungTextTitel;

  /// No description provided for @realitaetUebungTextText.
  ///
  /// In de, this message translates to:
  /// **'Lies eine Zeile oder eine Uhrzeit, schau kurz weg und lies noch einmal. Im Traum wechseln Buchstaben und Ziffern oft ihr Aussehen.'**
  String get realitaetUebungTextText;

  /// No description provided for @realitaetBestaetigenWach.
  ///
  /// In de, this message translates to:
  /// **'Ich bin wach'**
  String get realitaetBestaetigenWach;

  /// No description provided for @realitaetBestaetigenTraum.
  ///
  /// In de, this message translates to:
  /// **'Ich träume!'**
  String get realitaetBestaetigenTraum;

  /// No description provided for @realitaetErinnerungenAktiv.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen am Tag'**
  String get realitaetErinnerungenAktiv;

  /// No description provided for @realitaetZeitfenster.
  ///
  /// In de, this message translates to:
  /// **'Zeitfenster: {von} bis {bis} Uhr'**
  String realitaetZeitfenster(int von, int bis);

  /// No description provided for @realitaetAnzahlTag.
  ///
  /// In de, this message translates to:
  /// **'{n, plural, =1{1 Erinnerung pro Tag} other{{n} Erinnerungen pro Tag}}'**
  String realitaetAnzahlTag(int n);

  /// No description provided for @realitaetMotiveTitel.
  ///
  /// In de, this message translates to:
  /// **'Motive aus deinem Tagebuch'**
  String get realitaetMotiveTitel;

  /// No description provided for @realitaetMotiveKeine.
  ///
  /// In de, this message translates to:
  /// **'Sobald du mehr Notizen im Tagebuch hast, schlägt die App hier wiederkehrende Bilder als Auslöser vor.'**
  String get realitaetMotiveKeine;

  /// No description provided for @realitaetMotivSatz.
  ///
  /// In de, this message translates to:
  /// **'Wenn ich {wort} sehe, frage ich mich, ob ich träume.'**
  String realitaetMotivSatz(String wort);

  /// No description provided for @realitaetMitteilungTitel.
  ///
  /// In de, this message translates to:
  /// **'Kurzer Moment für dich'**
  String get realitaetMitteilungTitel;

  /// No description provided for @realitaetMitteilungText.
  ///
  /// In de, this message translates to:
  /// **'Nimm dir einen kurzen Augenblick Zeit.'**
  String get realitaetMitteilungText;

  /// No description provided for @realitaetHinweisXiaomi.
  ///
  /// In de, this message translates to:
  /// **'Hinweis für Xiaomi- und MIUI-Geräte: Damit Erinnerungen verlässlich eintreffen, sollten Akku-Optimierung und Autostart in den Telefoneinstellungen für die App freigegeben sein.'**
  String get realitaetHinweisXiaomi;

  /// No description provided for @realitaetKanalName.
  ///
  /// In de, this message translates to:
  /// **'Achtsamkeit'**
  String get realitaetKanalName;

  /// No description provided for @realitaetKanalBeschreibung.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen für den Realitätscheck am Tag'**
  String get realitaetKanalBeschreibung;

  /// No description provided for @weckenTitel.
  ///
  /// In de, this message translates to:
  /// **'Heute Nacht wecken'**
  String get weckenTitel;

  /// No description provided for @weckenUntertitel.
  ///
  /// In de, this message translates to:
  /// **'Einmaliger System-Wecker nach etwa fünf Stunden Schlaf'**
  String get weckenUntertitel;

  /// No description provided for @weckenUhrzeit.
  ///
  /// In de, this message translates to:
  /// **'Weckzeit: {zeit} Uhr'**
  String weckenUhrzeit(String zeit);

  /// No description provided for @weckenAendern.
  ///
  /// In de, this message translates to:
  /// **'Zeit ändern'**
  String get weckenAendern;

  /// No description provided for @weckenWeckerName.
  ///
  /// In de, this message translates to:
  /// **'Kurzer Moment'**
  String get weckenWeckerName;

  /// No description provided for @weckenGesperrt.
  ///
  /// In de, this message translates to:
  /// **'Du hast das nächtliche Wecken in den letzten sieben Tagen bereits zweimal genutzt. Dein Schlaf geht vor.'**
  String get weckenGesperrt;

  /// No description provided for @weckenSicherheit.
  ///
  /// In de, this message translates to:
  /// **'Höchstens zweimal pro Woche. Nicht nutzen bei Schichtarbeit, in der Schwangerschaft, mit einem Baby, das nachts weckt, oder bei Schlafmangel. Beim Wiedereinschlafen kann selten eine harmlose Schlafparalyse auftreten: ruhig atmen und einen Finger bewegen.'**
  String get weckenSicherheit;

  /// No description provided for @weckenWeckerGesetzt.
  ///
  /// In de, this message translates to:
  /// **'System-Wecker für {zeit} Uhr geöffnet'**
  String weckenWeckerGesetzt(String zeit);

  /// No description provided for @weckenBegleitungTitel.
  ///
  /// In de, this message translates to:
  /// **'Wiedereinschlafen'**
  String get weckenBegleitungTitel;

  /// No description provided for @weckenBegleitungEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Halte deinen Traum kurz in Stichworten fest und lass dich danach ruhig zurück in den Schlaf begleiten.'**
  String get weckenBegleitungEinleitung;

  /// No description provided for @weckenTagebuchKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Nach dem Wecken weiterschlafen'**
  String get weckenTagebuchKarteTitel;

  /// No description provided for @weckenTagebuchKarteText.
  ///
  /// In de, this message translates to:
  /// **'Kurze, leise Begleitung zurück in den Traum (ca. 15 Min.)'**
  String get weckenTagebuchKarteText;

  /// No description provided for @weckenBegleitungStarten.
  ///
  /// In de, this message translates to:
  /// **'Begleitung starten'**
  String get weckenBegleitungStarten;

  /// No description provided for @weckenTraumNotieren.
  ///
  /// In de, this message translates to:
  /// **'Traum kurz festhalten'**
  String get weckenTraumNotieren;

  /// No description provided for @weckenLaeuft.
  ///
  /// In de, this message translates to:
  /// **'Gute Nacht'**
  String get weckenLaeuft;

  /// No description provided for @weckenLaeuftText.
  ///
  /// In de, this message translates to:
  /// **'Leg das Gerät weg und schließ die Augen. Die Begleitung endet von selbst.'**
  String get weckenLaeuftText;

  /// No description provided for @testmodusAn.
  ///
  /// In de, this message translates to:
  /// **'Testmodus an: kurze Pausen, alles frei.'**
  String get testmodusAn;

  /// No description provided for @testmodusAus.
  ///
  /// In de, this message translates to:
  /// **'Testmodus aus.'**
  String get testmodusAus;

  /// No description provided for @testmodusSchild.
  ///
  /// In de, this message translates to:
  /// **'Testmodus: kurze Pausen, alles frei. Ausschalten: siebenmal auf die Versionsnummer im Profil tippen.'**
  String get testmodusSchild;

  /// No description provided for @reiheKarteTitel.
  ///
  /// In de, this message translates to:
  /// **'Innenansichten'**
  String get reiheKarteTitel;

  /// No description provided for @reiheKarteTitelNeutral.
  ///
  /// In de, this message translates to:
  /// **'Hörgeschichte'**
  String get reiheKarteTitelNeutral;

  /// No description provided for @reiheKarteText.
  ///
  /// In de, this message translates to:
  /// **'Lust von innen erzählt, in Soft und Spicy, auch aus zwei Perspektiven derselben Begegnung.'**
  String get reiheKarteText;

  /// No description provided for @reiheKarteTextNeutral.
  ///
  /// In de, this message translates to:
  /// **'Eine zusammenhängende Hörgeschichte.'**
  String get reiheKarteTextNeutral;

  /// No description provided for @reiheTitel.
  ///
  /// In de, this message translates to:
  /// **'Innenansichten'**
  String get reiheTitel;

  /// No description provided for @reiheEinleitung.
  ///
  /// In de, this message translates to:
  /// **'Zusammenhängende Erzählungen von etwa 20 bis 30 Minuten, nicht zum Einschlafen. Sie beschreiben, wie sich Lust von innen anfühlen kann. Jeder Mensch erlebt das anders; nichts davon ist ein Maßstab oder ein Versprechen.'**
  String get reiheEinleitung;

  /// No description provided for @reiheFolgen.
  ///
  /// In de, this message translates to:
  /// **'Folge'**
  String get reiheFolgen;

  /// No description provided for @reiheVariante.
  ///
  /// In de, this message translates to:
  /// **'Intensität'**
  String get reiheVariante;

  /// No description provided for @reiheSoft.
  ///
  /// In de, this message translates to:
  /// **'Soft'**
  String get reiheSoft;

  /// No description provided for @reiheBilderAnsehen.
  ///
  /// In de, this message translates to:
  /// **'Bilder ansehen'**
  String get reiheBilderAnsehen;

  /// No description provided for @reiheGalerieTitel.
  ///
  /// In de, this message translates to:
  /// **'Bilder'**
  String get reiheGalerieTitel;

  /// No description provided for @reiheGalerieLeer.
  ///
  /// In de, this message translates to:
  /// **'Zu dieser Folge gibt es noch keine Bilder.'**
  String get reiheGalerieLeer;

  /// No description provided for @reiheSpicy.
  ///
  /// In de, this message translates to:
  /// **'Spicy'**
  String get reiheSpicy;

  /// No description provided for @reiheSehrSpicy.
  ///
  /// In de, this message translates to:
  /// **'Sehr spicy'**
  String get reiheSehrSpicy;

  /// No description provided for @reihePerspektive.
  ///
  /// In de, this message translates to:
  /// **'Perspektive'**
  String get reihePerspektive;

  /// No description provided for @reihePerspektiveFrau.
  ///
  /// In de, this message translates to:
  /// **'Sie'**
  String get reihePerspektiveFrau;

  /// No description provided for @reihePerspektiveMann.
  ///
  /// In de, this message translates to:
  /// **'Er'**
  String get reihePerspektiveMann;

  /// No description provided for @reihePartnerHinweis.
  ///
  /// In de, this message translates to:
  /// **'Die passende Gegenperspektive derselben Begegnung: {name}. Beide folgen derselben Szenenfolge. „Gemeinsam hören“ gleicht dieselbe Fassung auf zwei Geräten ab. Unterschiedliche Gegenperspektiven stimmt ihr weiterhin selbst aufeinander ab.'**
  String reihePartnerHinweis(String name);

  /// No description provided for @reihePartnerHinweisDrei.
  ///
  /// In de, this message translates to:
  /// **'Die beiden anderen Perspektiven derselben Begegnung: {name}. Alle drei folgen derselben Szenenfolge. Dreier-Folgen hörst du allein, „Gemeinsam hören“ gibt es dafür nicht.'**
  String reihePartnerHinweisDrei(String name);

  /// No description provided for @reiheDauer.
  ///
  /// In de, this message translates to:
  /// **'Etwa {minuten} Minuten'**
  String reiheDauer(int minuten);

  /// No description provided for @reiheStart.
  ///
  /// In de, this message translates to:
  /// **'Starten'**
  String get reiheStart;

  /// No description provided for @reiheSzene.
  ///
  /// In de, this message translates to:
  /// **'Szene {n} von {m}'**
  String reiheSzene(int n, int m);

  /// No description provided for @reiheSzeneVor.
  ///
  /// In de, this message translates to:
  /// **'Nächste Szene'**
  String get reiheSzeneVor;

  /// No description provided for @reiheSzeneZurueck.
  ///
  /// In de, this message translates to:
  /// **'Szene von vorn'**
  String get reiheSzeneZurueck;

  /// No description provided for @reiheBeenden.
  ///
  /// In de, this message translates to:
  /// **'Beenden'**
  String get reiheBeenden;

  /// No description provided for @reiheBeendenFrage.
  ///
  /// In de, this message translates to:
  /// **'Die Erzählung stoppen?'**
  String get reiheBeendenFrage;

  /// No description provided for @reiheBeendenText.
  ///
  /// In de, this message translates to:
  /// **'Du kannst später neu beginnen.'**
  String get reiheBeendenText;

  /// No description provided for @reiheFertig.
  ///
  /// In de, this message translates to:
  /// **'Fertig. Nimm dir einen Moment, bevor du weitermachst.'**
  String get reiheFertig;

  /// No description provided for @reiheHinweise.
  ///
  /// In de, this message translates to:
  /// **'Nur ab achtzehn. Alle Figuren sind erwachsen, alles geschieht einvernehmlich. Nichts davon ist ein Leistungsmaßstab: Erregung, Höhepunkt und Zufriedenheit sind nicht dasselbe, und jeder Körper reagiert anders.'**
  String get reiheHinweise;

  /// No description provided for @reiheLeer.
  ///
  /// In de, this message translates to:
  /// **'Im Paket sind noch keine Folgen.'**
  String get reiheLeer;

  /// No description provided for @reihePaketFehlt.
  ///
  /// In de, this message translates to:
  /// **'Für diese Reihe fehlen noch die Aufnahmen. Sie kommen als eigenes Paket, am besten im WLAN laden. Danach läuft alles ohne Netz.'**
  String get reihePaketFehlt;

  /// No description provided for @reihePaketLaden.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen laden'**
  String get reihePaketLaden;

  /// No description provided for @kursBildAllein.
  ///
  /// In de, this message translates to:
  /// **'Allein'**
  String get kursBildAllein;

  /// No description provided for @kursBildZuZweit.
  ///
  /// In de, this message translates to:
  /// **'Zu zweit'**
  String get kursBildZuZweit;

  /// No description provided for @reihePaketNeu.
  ///
  /// In de, this message translates to:
  /// **'Es gibt neue Folgen und Bilder für diese Reihe. Am besten im WLAN aktualisieren. Danach läuft alles wieder ohne Netz.'**
  String get reihePaketNeu;

  /// No description provided for @reiheLadenFehler.
  ///
  /// In de, this message translates to:
  /// **'Laden hat nicht geklappt. Bitte später noch einmal versuchen.'**
  String get reiheLadenFehler;

  /// No description provided for @reiheOffline.
  ///
  /// In de, this message translates to:
  /// **'Offline verfügbar'**
  String get reiheOffline;

  /// No description provided for @reiheKeineAufnahme.
  ///
  /// In de, this message translates to:
  /// **'Zu dieser Fassung gibt es noch keine Aufnahme; die Geräte-Stimme liest vor.'**
  String get reiheKeineAufnahme;

  /// No description provided for @lautsprecherFrageTitel.
  ///
  /// In de, this message translates to:
  /// **'Lautsprecher'**
  String get lautsprecherFrageTitel;

  /// No description provided for @lautsprecherFrageNachricht.
  ///
  /// In de, this message translates to:
  /// **'Die Wiedergabe läuft über den Lautsprecher. Trotzdem abspielen?'**
  String get lautsprecherFrageNachricht;

  /// No description provided for @lautsprecherAbspielen.
  ///
  /// In de, this message translates to:
  /// **'Abspielen'**
  String get lautsprecherAbspielen;

  /// No description provided for @lautsprecherAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get lautsprecherAbbrechen;

  /// No description provided for @lautsprecherNichtMehrFragen.
  ///
  /// In de, this message translates to:
  /// **'Nicht mehr fragen'**
  String get lautsprecherNichtMehrFragen;

  /// No description provided for @lautsprecherEinstellungFrageTitel.
  ///
  /// In de, this message translates to:
  /// **'Vor Lautsprecher-Wiedergabe fragen'**
  String get lautsprecherEinstellungFrageTitel;

  /// No description provided for @lautsprecherEinstellungFrageText.
  ///
  /// In de, this message translates to:
  /// **'Fragt vor dem Abspielen, wenn keine Kopfhörer angeschlossen sind.'**
  String get lautsprecherEinstellungFrageText;

  /// No description provided for @lautsprecherEinstellungPauseTitel.
  ///
  /// In de, this message translates to:
  /// **'Pausieren, wenn Kopfhörer getrennt werden'**
  String get lautsprecherEinstellungPauseTitel;

  /// No description provided for @lautsprecherEinstellungPauseText.
  ///
  /// In de, this message translates to:
  /// **'Hält die Wiedergabe an, sobald Kabel- oder Bluetooth-Kopfhörer getrennt werden.'**
  String get lautsprecherEinstellungPauseText;

  /// No description provided for @realitaetStatusEin.
  ///
  /// In de, this message translates to:
  /// **'Ein'**
  String get realitaetStatusEin;

  /// No description provided for @realitaetStatusAus.
  ///
  /// In de, this message translates to:
  /// **'Aus'**
  String get realitaetStatusAus;

  /// No description provided for @halloTitel.
  ///
  /// In de, this message translates to:
  /// **'Einmal anonym Hallo sagen'**
  String get halloTitel;

  /// No description provided for @halloErklaerung.
  ///
  /// In de, this message translates to:
  /// **'Freiwillig: Wenn du magst, sagst du uns einmal Hallo. Übertragen werden ausschließlich Version und Sprache der App – verschlüsselt und ohne Absender.'**
  String get halloErklaerung;

  /// No description provided for @halloKnopf.
  ///
  /// In de, this message translates to:
  /// **'Hallo sagen'**
  String get halloKnopf;

  /// No description provided for @halloDankeGesendet.
  ///
  /// In de, this message translates to:
  /// **'Danke, gesendet am {datum}.'**
  String halloDankeGesendet(String datum);

  /// No description provided for @halloGesendet.
  ///
  /// In de, this message translates to:
  /// **'Danke für dein Hallo!'**
  String get halloGesendet;

  /// No description provided for @schlafTitel.
  ///
  /// In de, this message translates to:
  /// **'Schlafdaten abgleichen'**
  String get schlafTitel;

  /// No description provided for @schlafEinladung.
  ///
  /// In de, this message translates to:
  /// **'Deine Nacht im Rückblick'**
  String get schlafEinladung;

  /// No description provided for @schlafErklaerung.
  ///
  /// In de, this message translates to:
  /// **'Optional: Bereits synchronisierte Schlafdaten aus Health Connect neben deinen eigenen Beobachtungen ansehen. Keine Live-Erkennung, keine Signale während der Nacht. Die Traumpraxis funktioniert auch ohne Gerät.'**
  String get schlafErklaerung;

  /// No description provided for @schlafDatenschutz.
  ///
  /// In de, this message translates to:
  /// **'VelvetPulse liest nur Schlafsitzungen der letzten 30 Tage, wenn du den Abgleich ausdrücklich startest. Es schreibt nichts nach Health Connect. Importierte Kopien bleiben lokal und werden in deine Sicherung aufgenommen; keine Weitergabe an Coach oder Paarraum.'**
  String get schlafDatenschutz;

  /// No description provided for @schlafHinweis.
  ///
  /// In de, this message translates to:
  /// **'Aktiviere die Freigabe deiner Schlafdaten in Fitbit bzw. Google Health für Health Connect. Es werden nur Daten angezeigt, die dort tatsächlich verfügbar sind. Schlafphasen sind Schätzungen, keine Diagnose.'**
  String get schlafHinweis;

  /// No description provided for @schlafVerbinden.
  ///
  /// In de, this message translates to:
  /// **'Health Connect verbinden'**
  String get schlafVerbinden;

  /// No description provided for @schlafImportieren.
  ///
  /// In de, this message translates to:
  /// **'Letzte 30 Tage abgleichen'**
  String get schlafImportieren;

  /// No description provided for @schlafUebernehmen.
  ///
  /// In de, this message translates to:
  /// **'Ausgewählte Quelle übernehmen'**
  String get schlafUebernehmen;

  /// No description provided for @schlafQuelle.
  ///
  /// In de, this message translates to:
  /// **'Datenquelle'**
  String get schlafQuelle;

  /// No description provided for @schlafQuelleWaehlen.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle eine Quelle. Aufzeichnungen verschiedener Geräte werden nicht addiert.'**
  String get schlafQuelleWaehlen;

  /// No description provided for @schlafTrennen.
  ///
  /// In de, this message translates to:
  /// **'Abgleich ausschalten'**
  String get schlafTrennen;

  /// No description provided for @schlafGetrennt.
  ///
  /// In de, this message translates to:
  /// **'Abgleich ausgeschaltet. Importierte Daten bleiben erhalten. Die Android-Berechtigung kannst du in Health Connect widerrufen.'**
  String get schlafGetrennt;

  /// No description provided for @schlafVerbunden.
  ///
  /// In de, this message translates to:
  /// **'Abgleich aktiviert. Daten werden nur auf deinen Wunsch gelesen.'**
  String get schlafVerbunden;

  /// No description provided for @schlafBerechtigungFehlt.
  ///
  /// In de, this message translates to:
  /// **'Zugriff auf Schlafdaten fehlt. Du kannst ihn in Health Connect erlauben; die übrige Traumpraxis bleibt nutzbar.'**
  String get schlafBerechtigungFehlt;

  /// No description provided for @schlafNichtVerfuegbar.
  ///
  /// In de, this message translates to:
  /// **'Dieser optionale Import benötigt Android 14 oder neuer und verfügbares Health Connect. Alle übrigen Übungen bleiben nutzbar.'**
  String get schlafNichtVerfuegbar;

  /// No description provided for @schlafLeer.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Schlafaufzeichnungen importiert.'**
  String get schlafLeer;

  /// No description provided for @schlafKeineDaten.
  ///
  /// In de, this message translates to:
  /// **'Keine abgeschlossenen Schlafsitzungen verfügbar. Prüfe die Synchronisierung und die Freigabe in deiner Quell-App.'**
  String get schlafKeineDaten;

  /// No description provided for @schlafFehler.
  ///
  /// In de, this message translates to:
  /// **'Der Abgleich konnte nicht abgeschlossen werden. Deine bisherigen Daten bleiben erhalten.'**
  String get schlafFehler;

  /// No description provided for @schlafGespeichert.
  ///
  /// In de, this message translates to:
  /// **'Die ausgewählten Schlafdaten wurden übernommen.'**
  String get schlafGespeichert;

  /// No description provided for @schlafEinstellungen.
  ///
  /// In de, this message translates to:
  /// **'Android-Berechtigungen'**
  String get schlafEinstellungen;

  /// No description provided for @schlafLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Importierte Schlafdaten löschen'**
  String get schlafLoeschen;

  /// No description provided for @schlafLoeschenFrage.
  ///
  /// In de, this message translates to:
  /// **'Alle importierten Schlafdaten aus VelvetPulse löschen? Deine eigenen Tagebuch- und Traumpraxis-Einträge bleiben erhalten. Daten in Health Connect werden nicht gelöscht.'**
  String get schlafLoeschenFrage;

  /// No description provided for @schlafAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get schlafAbbrechen;

  /// No description provided for @schlafZeitfenster.
  ///
  /// In de, this message translates to:
  /// **'Erfasstes Zeitfenster'**
  String get schlafZeitfenster;

  /// No description provided for @schlafSchlafzeit.
  ///
  /// In de, this message translates to:
  /// **'Schlafzeit laut Phasen'**
  String get schlafSchlafzeit;

  /// No description provided for @schlafUnbekannt.
  ///
  /// In de, this message translates to:
  /// **'Nicht vollständig bestimmbar'**
  String get schlafUnbekannt;

  /// No description provided for @schlafPhasen.
  ///
  /// In de, this message translates to:
  /// **'Erfasste Phasen'**
  String get schlafPhasen;

  /// No description provided for @schlafWach.
  ///
  /// In de, this message translates to:
  /// **'Wach'**
  String get schlafWach;

  /// No description provided for @schlafLeicht.
  ///
  /// In de, this message translates to:
  /// **'Leichtschlaf'**
  String get schlafLeicht;

  /// No description provided for @schlafTief.
  ///
  /// In de, this message translates to:
  /// **'Tiefschlaf'**
  String get schlafTief;

  /// No description provided for @schlafRem.
  ///
  /// In de, this message translates to:
  /// **'REM'**
  String get schlafRem;

  /// No description provided for @schlafOhnePhase.
  ///
  /// In de, this message translates to:
  /// **'Schlaf ohne Phasenangabe'**
  String get schlafOhnePhase;

  /// No description provided for @schlafUnbekanntePhase.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get schlafUnbekanntePhase;

  /// No description provided for @schlafEigeneAngaben.
  ///
  /// In de, this message translates to:
  /// **'Deine Angaben zu diesem Aufwachdatum'**
  String get schlafEigeneAngaben;

  /// No description provided for @schlafKeineAngaben.
  ///
  /// In de, this message translates to:
  /// **'Noch keine eigene Tagesbeobachtung vorhanden.'**
  String get schlafKeineAngaben;

  /// No description provided for @schlafBeobachtung.
  ///
  /// In de, this message translates to:
  /// **'Tagesbeobachtung öffnen'**
  String get schlafBeobachtung;

  /// No description provided for @schlafLetzterAbgleich.
  ///
  /// In de, this message translates to:
  /// **'Letzter Abgleich'**
  String get schlafLetzterAbgleich;

  /// No description provided for @schlafImportierteKopie.
  ///
  /// In de, this message translates to:
  /// **'Gespeicherte Kopie. Änderungen oder Löschungen in der Quell-App entfernen diese Kopie nicht automatisch. Hinweise auf einen Zusammenhang sind kein Nachweis einer Wirkung auf Lust oder Träume.'**
  String get schlafImportierteKopie;

  /// No description provided for @schlafDauer.
  ///
  /// In de, this message translates to:
  /// **'{stunden} Std. {minuten} Min.'**
  String schlafDauer(int stunden, int minuten);

  /// No description provided for @schlafBlickTitel.
  ///
  /// In de, this message translates to:
  /// **'Was deine Nächte erzählen'**
  String get schlafBlickTitel;

  /// No description provided for @schlafBlickEinladung.
  ///
  /// In de, this message translates to:
  /// **'Ein Traumzeichen bemerkt? Ein Gefühl mit in den Tag genommen? Entdecke deine letzten sieben Tage – mit deinen Erinnerungen und, wenn du möchtest, deinen Schlafdaten.'**
  String get schlafBlickEinladung;

  /// No description provided for @schlafBlickGrenze.
  ///
  /// In de, this message translates to:
  /// **'Deine Angaben erzählen vom Erleben. Die Uhr liefert Schlafschätzungen. Daraus wird kein Klartraum oder Orgasmus erkannt. Tagebucheinträge werden nach ihrem Eintragsdatum zugeordnet.'**
  String get schlafBlickGrenze;

  /// No description provided for @schlafBlickWoche.
  ///
  /// In de, this message translates to:
  /// **'Deine letzten sieben Tage'**
  String get schlafBlickWoche;

  /// No description provided for @schlafBlickKlar.
  ///
  /// In de, this message translates to:
  /// **'Klarheit im Traum notiert'**
  String get schlafBlickKlar;

  /// No description provided for @schlafBlickErinnert.
  ///
  /// In de, this message translates to:
  /// **'Traumerinnerung notiert'**
  String get schlafBlickErinnert;

  /// No description provided for @schlafBlickSinnlich.
  ///
  /// In de, this message translates to:
  /// **'Sinnlicher Traum notiert'**
  String get schlafBlickSinnlich;

  /// No description provided for @schlafBlickHoehepunkt.
  ///
  /// In de, this message translates to:
  /// **'Höhepunkt im Traum notiert'**
  String get schlafBlickHoehepunkt;

  /// No description provided for @schlafBlickOhneErinnerung.
  ///
  /// In de, this message translates to:
  /// **'Nichts erinnert – auch das gehört dazu'**
  String get schlafBlickOhneErinnerung;

  /// No description provided for @schlafBlickUnbekannt.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Traumangabe'**
  String get schlafBlickUnbekannt;

  /// No description provided for @schlafBlickOhneMessung.
  ///
  /// In de, this message translates to:
  /// **'Ohne Schlafmessung'**
  String get schlafBlickOhneMessung;

  /// No description provided for @schlafBlickMehrere.
  ///
  /// In de, this message translates to:
  /// **'Mehrere Schlafaufzeichnungen – einzeln unter Messwerten ansehen'**
  String get schlafBlickMehrere;

  /// No description provided for @schlafBlickNacht.
  ///
  /// In de, this message translates to:
  /// **'Diese Nacht festhalten'**
  String get schlafBlickNacht;

  /// No description provided for @schlafBlickNaechster.
  ///
  /// In de, this message translates to:
  /// **'Deine nächste Entdeckung'**
  String get schlafBlickNaechster;

  /// No description provided for @schlafBlickStart.
  ///
  /// In de, this message translates to:
  /// **'Beginne mit einem kleinen Rest Erinnerung: ein Bild, eine Stimmung, ein Ort. Daraus kann dein persönliches Traumzeichen entstehen.'**
  String get schlafBlickStart;

  /// No description provided for @schlafBlickUeben.
  ///
  /// In de, this message translates to:
  /// **'Du hast bereits etwas festgehalten. Schau nach einem ungewöhnlichen Detail und nimm es als ruhige Absicht in deine nächste Abendpraxis mit.'**
  String get schlafBlickUeben;

  /// No description provided for @schlafBlickVertiefen.
  ///
  /// In de, this message translates to:
  /// **'Du hast Klarheit im Traum notiert. Was möchtest du beim nächsten Mal bewusst wahrnehmen? Deine Traumpraxis lässt Raum für Sinnlichkeit und das Nachspüren am Tag.'**
  String get schlafBlickVertiefen;

  /// No description provided for @schlafBlickRuhe.
  ///
  /// In de, this message translates to:
  /// **'Deine letzten Einträge sprechen für eine Pause. Heute darf Erholung genügen. Du musst keine neue Übung oder nächtliche Unterbrechung hinzufügen.'**
  String get schlafBlickRuhe;

  /// No description provided for @schlafBlickPraxis.
  ///
  /// In de, this message translates to:
  /// **'Traumpraxis entdecken'**
  String get schlafBlickPraxis;

  /// No description provided for @schlafBlickHeute.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get schlafBlickHeute;

  /// No description provided for @schlafBlickGestern.
  ///
  /// In de, this message translates to:
  /// **'Gestern'**
  String get schlafBlickGestern;

  /// No description provided for @schlafBlickGeschlafen.
  ///
  /// In de, this message translates to:
  /// **'Geschlafen: {dauer}'**
  String schlafBlickGeschlafen(String dauer);

  /// No description provided for @schlafBlickImBett.
  ///
  /// In de, this message translates to:
  /// **'Im Bett: {dauer}'**
  String schlafBlickImBett(String dauer);

  /// No description provided for @schlafBlickKeineBesonderheiten.
  ///
  /// In de, this message translates to:
  /// **'Nichts Besonderes notiert'**
  String get schlafBlickKeineBesonderheiten;

  /// No description provided for @schlafBlickAendern.
  ///
  /// In de, this message translates to:
  /// **'Angaben ansehen oder ändern'**
  String get schlafBlickAendern;

  /// No description provided for @schlafBlickNochNichts.
  ///
  /// In de, this message translates to:
  /// **'Noch nichts festgehalten'**
  String get schlafBlickNochNichts;

  /// No description provided for @schlafMesswerte.
  ///
  /// In de, this message translates to:
  /// **'Schlafdaten verbinden und Messwerte ansehen'**
  String get schlafMesswerte;

  /// No description provided for @schlafBlickBilanz.
  ///
  /// In de, this message translates to:
  /// **'{klar} von {tage} Tagen mit eigenen Angaben enthalten einen berichteten Klartraum. Das ist ein Rückblick, kein Leistungsziel.'**
  String schlafBlickBilanz(int klar, int tage);
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
