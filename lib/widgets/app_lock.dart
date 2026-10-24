import 'package:flutter/material.dart';
import '../services/privacy_service.dart';
import '../theme/app_theme.dart';
import '../l10n/t.dart';

/// Legt sich über die ganze App, solange die Fingerabdruck-Sperre aktiv und noch nicht entsperrt ist.
class AppLock extends StatefulWidget {
  final Widget child;

  /// Vor dem ersten Bild ermittelt, damit beim Start nichts kurz durchblitzt.
  final bool initiallyLocked;

  const AppLock({super.key, required this.child, this.initiallyLocked = false});

  @override
  State<AppLock> createState() => _AppLockState();
}

class _AppLockState extends State<AppLock> with WidgetsBindingObserver {
  bool _enabled = false;
  bool _locked = false;
  DateTime? _backgroundSince;

  @override
  void initState() {
    super.initState();
    _locked = widget.initiallyLocked;
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _init() async {
    _enabled = await PrivacyService.isLockEnabled();
    if (!_enabled || !mounted) return;
    await PrivacyService.applySecureFlag(true);
    setState(() => _locked = true);
    _unlock();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Der Fingerabdruck-Dialog selbst schickt die App kurz in den Hintergrund.
    if (PrivacyService.isAuthenticating) return;

    if (state == AppLifecycleState.paused) {
      _backgroundSince = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _enabled = await PrivacyService.isLockEnabled();
      final since = _backgroundSince;
      _backgroundSince = null;
      if (_enabled && !_locked && since != null && DateTime.now().difference(since) > PrivacyService.relockAfter) {
        setState(() => _locked = true);
        _unlock();
      }
    }
  }

  Future<void> _unlock() async {
    final ok = await PrivacyService.authenticate();
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Positioned.fill(
            child: Material(
              color: AppTheme.background,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_rounded, color: AppTheme.textSecondary, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        t.appLockLocked,
                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _unlock,
                        icon: const Icon(Icons.fingerprint_rounded),
                        label: Text(t.appLockUnlock),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
