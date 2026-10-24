import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/data_service.dart';
import 'services/storage_service.dart';
import 'services/auto_backup_service.dart';
import 'services/message_notifier.dart';
import 'services/nostr_service.dart';
import 'services/privacy_service.dart';
import 'services/whats_new.dart';
import 'widgets/app_lock.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  } catch (e) {
    debugPrint('System UI overlay error: $e');
  }

  runApp(const VelvetPulseApp());
}

class VelvetPulseApp extends StatefulWidget {
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
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      _lockEnabled = await PrivacyService.isLockEnabled();
    } catch (e) {
      debugPrint('Privacy init error: $e');
    }

    try {
      await StorageService.init();
      await AutoBackupService.checkAndAutoRestore();
      await NostrService().init();
    } catch (e) {
      debugPrint('Init error: $e');
    }

    try {
      await MessageNotifier.init();
    } catch (e) {
      debugPrint('Notification init error: $e');
    }

    try {
      await DataService.loadDatabase();
    } catch (e) {
      debugPrint('DataService loadDatabase error: $e');
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VelvetPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Erlaubt Scrollen per Mausziehen (Web-/Desktop-Vorschau); auf dem Handy ohne Wirkung.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      builder: (context, child) => _isInitialized
          ? AppLock(initiallyLocked: _lockEnabled, child: child!)
          : child!,
      home: !_isInitialized
          ? const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VelvetPulse',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'KVT & SOMATIK COACHING',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.sageGreen,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppTheme.sageGreen,
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
