import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'theme/vp_tokens.dart';
import 'package:flutter/foundation.dart' show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/services.dart';
import 'services/bild_register.dart';
import 'services/data_service.dart';
import 'services/storage_service.dart';
import 'services/auto_backup_service.dart';
import 'services/message_notifier.dart';
import 'services/realitaetscheck.dart';
import 'services/nostr_service.dart';
import 'services/pakete.dart';
import 'services/privacy_service.dart';
import 'services/sprachausgabe.dart';
import 'services/sprache.dart';
import 'services/update_service.dart';
import 'services/whats_new.dart';
import 'widgets/app_lock.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'l10n/t.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  systemLeistenAnpassen();
  // Lizenz der mitgelieferten Schrift (SIL OFL), sie verlangt, dass der Text mitgeliefert wird.
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Source Serif 4'], await rootBundle.loadString('assets/fonts/SourceSerif4-OFL.txt'));
  });

  runApp(const VelvetPulseApp());
}

/// Status- und Navigationsleiste zur aktuellen Atmosphäre: helle Symbole auf dunklem Grund, dunkle auf Papier.
void systemLeistenAnpassen() {
  try {
    final dunkel = AppTheme.palette.istDunkel;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dunkel ? Brightness.light : Brightness.dark,
        statusBarBrightness: dunkel ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: AppTheme.papier,
        systemNavigationBarIconBrightness: dunkel ? Brightness.light : Brightness.dark,
      ),
    );
  } catch (e) {
    debugPrint('System UI overlay error: $e');
  }
}

class VelvetPulseApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const VelvetPulseApp({super.key});

  @override
  State<VelvetPulseApp> createState() => _VelvetPulseAppState();
}

class _VelvetPulseAppState extends State<VelvetPulseApp> {
  bool _isInitialized = false;
  bool _hasOnboarded = false;
  bool _lockEnabled = false;

  @override
  void initState() {
    super.initState();
    Sprache.wahl.addListener(_spracheGewechselt);
    StorageService.spicyAenderung.addListener(_spicyGewechselt);
    StorageService.designAenderung.addListener(_spicyGewechselt);
    _initApp();
  }

  /// Spicy an oder aus, oder neue Darstellung: Die Farben hängen daran (AppTheme), also alles neu aufbauen.
  /// Der Zustand der Seiten bleibt.
  void _spicyGewechselt() {
    if (!mounted) return;
    systemLeistenAnpassen();
    setState(() {});
    WidgetsBinding.instance.reassembleApplication();
  }

  Future<void> _initApp() async {
    try {
      _lockEnabled = await PrivacyService.isLockEnabled();
    } catch (e) {
      debugPrint('Privacy init error: $e');
    }

    try {
      await Sprache.laden();
      await BildRegister.laden();
      await AudioPaket.init();
      await Pakete.init();
    } catch (e) {
      debugPrint('Sprache init error: $e');
    }

    try {
      await StorageService.init();
      systemLeistenAnpassen();
      await AutoBackupService.checkAndAutoRestore();
      await NostrService().init();
    } catch (e) {
      debugPrint('Init error: $e');
    }

    try {
      await MessageNotifier.init();
      await RealitaetscheckService.init();
    } catch (e) {
      debugPrint('Notification init error: $e');
    }

    try {
      await DataService.loadDatabase();
    } catch (e) {
      debugPrint('DataService loadDatabase error: $e');
    }

    try {
      await UpdateService.resetChannelAfterStableUpdate();
    } catch (e) {
      debugPrint('Update channel reset error: $e');
    }

    final hasOnboarded = StorageService.hasCompletedOnboarding();
    // Bei einer Neuinstallation gibt es nichts „Neues“ zu zeigen.
    if (!hasOnboarded) {
      try {
        await WhatsNew.markInstalled();
      } catch (e) {
        debugPrint('WhatsNew init error: $e');
      }
    }

    if (mounted) {
      setState(() {
        _hasOnboarded = hasOnboarded;
        _isInitialized = true;
      });
    }
  }

  void _onOnboardingComplete() {
    setState(() {
      _hasOnboarded = true;
    });
  }

  /// Neue Sprache: Inhalte in dieser Sprache laden und die ganze App neu aufbauen.
  Future<void> _spracheGewechselt() async {
    await DataService.neuLaden();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: VelvetPulseApp.navigatorKey,
      // Neuer Schlüssel je Sprache: Die ganze App wird neu aufgebaut, kein Text bleibt in der alten Sprache.
      key: ValueKey(Sprache.code),
      title: 'VelvetPulse',
      debugShowCheckedModeBanner: false,
      locale: Sprache.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.darkTheme,
      // Erlaubt Scrollen per Mausziehen (Web-/Desktop-Vorschau); auf dem Handy ohne Wirkung.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      builder: (context, child) => _isInitialized
          ? AppLock(initiallyLocked: _lockEnabled, child: child!)
          : child!,
      home: !_isInitialized
          ? Scaffold(
              backgroundColor: AppTheme.papier,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VelvetPulse',
                      style: TextStyle(
                        fontFamily: VpTypo.serif, fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.tinte,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      t.mainCbtSomaticCoaching,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.akzentTief,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppTheme.akzentTief,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _hasOnboarded
              ? const MainNavigationScreen()
              : OnboardingScreen(onComplete: _onOnboardingComplete),
    );
  }
}
