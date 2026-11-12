import 'package:flutter/material.dart';
import '../../theme/vp_tokens.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../services/rueckmeldung.dart';
import '../../models/user_profile.dart';
import '../../services/alter_dienst.dart';
import '../../services/storage_service.dart';
import '../../services/testmodus.dart';
import '../../services/auto_backup_service.dart';
import '../../services/backup_codec.dart';
import '../../services/message_notifier.dart';
import '../../services/privacy_service.dart';
import '../../services/update_service.dart';
import '../../widgets/backup_dialogs.dart';
import '../../widgets/update_dialog.dart';
import '../../theme/app_theme.dart';
import '../main_navigation_screen.dart';
import '../../l10n/t.dart';
import '../../services/sprache.dart';
import '../../widgets/aufnahmen_karte.dart';
import '../../widgets/spicy_modus_dialog.dart';
import '../anleitung_screen.dart';
import '../couples_channel/pairing_modal.dart';
import '../rueckmeldung_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEditing;
  final VoidCallback? onComplete;

  const OnboardingScreen({
    super.key,
    this.isEditing = false,
    this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  // Keine Vorauswahl: wer nichts wählt, wird als "Keine Angabe" ('unspecified') gespeichert.
  String? _selectedGender;
  // Körper-Voreinstellung (nur im Profil): 'vulva', 'penis', 'beides' oder null (später fragen).
  String? _koerper = StorageService.getKoerperVoreinstellung();
  int _selectedAge = 32;
  String _selectedRelationship = 'relationship';
  // Keine Vorauswahl: wer nichts wählt, wird mit dem neutralen Fokus 'open' gespeichert.
  String? _selectedGoal;
  bool _isSubmitting = false;
  // Ersteinrichtung in Schritten: 0 Willkommen (Versprechen), 1 bis 5 je eine Frage. Beim Bearbeiten des Profils gilt alles auf einer Seite.
  int _schritt = 0;
  static const _fragen = 5;
  // Sanfter Start für eingeladene Personen: drei ruhige Bildschirme vor den Fragen. Gilt nur, solange das Onboarding offen ist.
  bool _eingeladen = false;
  int _einladungsSchritt = 1;
  bool _lockEnabled = false;
  bool _discreetIcon = false;
  UpdateChannel _updateChannel = UpdateChannel.stable;
  bool _notifyMessages = false;
  bool _personalizeNames = StorageService.personalizeNames();
  bool _lockSupported = false;
  bool _frageVorLautsprecher = StorageService.getFrageVorLautsprecher();
  bool _pausiereBeiKopfhoererGetrennt = StorageService.getPausiereBeiKopfhoererGetrennt();
  String? _halloGesendetAm = StorageService.getHalloGesendetAm();
  bool _halloSendet = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) _loadPrivacySettings();
    final existing = StorageService.getUserProfile();
    if (existing != null) {
      _nameController.text = existing.name;
      _selectedGender = existing.gender;
      _selectedAge = existing.age;
      _selectedRelationship = existing.relationshipStatus;
      _selectedGoal = existing.primaryGoal == 'open' ? null : existing.primaryGoal;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final name = _nameController.text.trim().isEmpty ? t.onboardingGuest : _nameController.text.trim();
      final profile = UserProfile(
        name: name,
        gender: _selectedGender ?? 'unspecified',
        age: _selectedAge,
        relationshipStatus: _selectedRelationship,
        primaryGoal: _selectedGoal ?? 'open',
      );

      await StorageService.saveUserProfile(profile);

      if (widget.isEditing) {
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.onboardingProfileUpdated),
              backgroundColor: AppTheme.akzent,
            ),
          );
        }
      } else {
        if (widget.onComplete != null) {
          widget.onComplete!();
        } else if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        }
      }
    } catch (e) {
      debugPrint('Onboarding submit error: $e');
      try {
        await StorageService.setCompletedOnboarding(true);
      } catch (e) {
        debugPrint('setCompletedOnboarding error: $e');
      }
      if (widget.isEditing) {
        if (mounted) Navigator.of(context).pop(true);
      } else {
        if (widget.onComplete != null) {
          widget.onComplete!();
        } else if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// Speichert ein Standardprofil (ohne Angaben: „Keine Angabe“, Fokus „offen“), damit die App starten kann.
  Future<void> _standardprofilSpeichern() async {
    final defaultProfile = UserProfile(
      name: t.paarAbendYou,
      gender: _selectedGender ?? 'unspecified',
      age: _selectedAge,
      relationshipStatus: _selectedRelationship,
      primaryGoal: _selectedGoal ?? 'open',
    );
    try {
      await StorageService.saveUserProfile(defaultProfile);
    } catch (e) {
      debugPrint('Onboarding skip error: $e');
    }
  }

  void _weiterZurApp() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  /// „Überspringen“ und „Ich schau erst mal nur“: Standardprofil speichern und direkt in die App.
  Future<void> _ueberspringen() async {
    if (_isSubmitting) return; // gegen Doppeltippen
    setState(() => _isSubmitting = true);
    try {
      await _standardprofilSpeichern();
      _weiterZurApp();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// Verbinden mit der einladenden Person: derselbe Dialog wie im Tab „Wir“. Gelingt es, geht es in die App.
  Future<void> _mitPersonVerbinden() async {
    if (_isSubmitting) return; // gegen Doppeltippen
    HapticFeedback.lightImpact();
    setState(() => _isSubmitting = true);
    bool? verbunden;
    try {
      verbunden = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const PairingModal(),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
    if (verbunden == true && mounted) await _ueberspringen();
  }

  Future<void> _promptRestoreBackup() async {
    HapticFeedback.lightImpact();

    // 1. Sicherung im privaten App-Speicher
    final fileText = await AutoBackupService.readBackupText();
    ValidatedBackup? fileData;
    try {
      if (fileText != null) fileData = BackupCodec.validate(fileText);
    } catch (_) {}

    // 2. Sicherung in der Zwischenablage
    ValidatedBackup? clipData;
    try {
      final clip = await Clipboard.getData('text/plain');
      if (clip?.text != null && clip!.text!.trim().startsWith('{')) {
        clipData = BackupCodec.validate(clip.text!);
      }
    } catch (_) {}

    if (!mounted) return;

    final TextEditingController inputController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            decoration: BoxDecoration(
              color: AppTheme.papierErhoben,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: AppTheme.linie, width: 1.5)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.linie,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.restore_page_rounded, color: AppTheme.akzentTief, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.onboardingRestoreBackup,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.tinte,
                              ),
                            ),
                            Text(
                              t.onboardingRestoreYourProfileLessonsCouple,
                              style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Option 1: File detected on device
                  if (fileData != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.statusJa.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        border: Border.all(color: AppTheme.statusJa.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: AppTheme.statusJa, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                t.onboardingBackupFoundOnThisDevice.toUpperCase(),
                                style: TextStyle(
                                  color: AppTheme.statusJa,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t.onboardingProfileProfilename(fileData.profileName),
                            style: TextStyle(color: AppTheme.tinte, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                await _applyRestore(fileData!);
                              },
                              icon: const Icon(Icons.flash_on_rounded, size: 16),
                              label: Text(t.onboardingRestoreAutomaticBackupNow, style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.statusJa,
                                foregroundColor: AppTheme.papier,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Option 2: Clipboard detected
                  if (clipData != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.akzentTief.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.content_paste_rounded, color: AppTheme.akzentTief, size: 18),
                              SizedBox(width: 8),
                              Text(
                                t.onboardingReadyInClipboard,
                                style: TextStyle(
                                  color: AppTheme.akzentTief,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t.onboardingBackupForProfilename(clipData.profileName),
                            style: TextStyle(color: AppTheme.tinte, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                await _applyRestore(clipData!);
                              },
                              icon: const Icon(Icons.done_all_rounded, size: 16),
                              label: Text(t.onboardingRestoreFromClipboard, style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.akzentTief,
                                foregroundColor: AppTheme.papier,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Option 3: Manual JSON Input field
                  Text(
                    t.onboardingPasteBackupCodeJsonManually,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.tinteLeise,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: inputController,
                    maxLines: 4,
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: AppTheme.tinte),
                    decoration: InputDecoration(
                      hintText: t.onboardingPasteJsonTextHereE,
                      hintStyle: TextStyle(color: AppTheme.tinteStumm, fontSize: 11),
                      filled: true,
                      fillColor: AppTheme.papier,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(VpRadius.karte), borderSide: BorderSide(color: AppTheme.linie)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.paste_rounded, color: AppTheme.akzentTief, size: 20),
                        tooltip: t.pairingModalPasteFromClipboard,
                        onPressed: () async {
                          final c = await Clipboard.getData('text/plain');
                          if (c?.text != null) {
                            setModalState(() {
                              inputController.text = c!.text!;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final raw = inputController.text.trim();
                        if (raw.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.onboardingPleasePasteTheBackupJson), backgroundColor: AppTheme.akzentTief),
                          );
                          return;
                        }
                        try {
                          final backup = BackupCodec.validate(raw);
                          Navigator.of(ctx).pop();
                          await _applyRestore(backup);
                        } on BackupException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message), backgroundColor: AppTheme.signal),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: Text(t.onboardingApplyBackupNow, style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.akzent,
                        foregroundColor: AppTheme.aufAkzent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _applyRestore(ValidatedBackup backup) async {
    final secrets = await resolveBackupSecrets(context, backup);
    if (secrets == null || !mounted) return;
    String? error;
    try {
      await StorageService.importBackup(backup, secrets: secrets);
    } on BackupException catch (e) {
      error = e.message;
    } catch (_) {
      error = t.onboardingTheBackupCouldNotBe;
    }
    if (!mounted) return;

    if (error == null) {
      HapticFeedback.mediumImpact();
      final profile = StorageService.getUserProfile();
      final name = profile?.name ?? t.onboardingUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.onboardingBackupForNameRestored(name)),
          backgroundColor: AppTheme.akzent,
        ),
      );

      if (widget.isEditing) {
        setState(() {
          if (profile != null) {
            _nameController.text = profile.name;
            _selectedGender = profile.gender;
            _selectedAge = profile.age;
            _selectedRelationship = profile.relationshipStatus;
            _selectedGoal = profile.primaryGoal == 'open' ? null : profile.primaryGoal;
          }
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.signal),
      );
    }
  }

  /// Sanfter Start: drei ruhige Bildschirme, ohne Fortschrittsbalken und ohne Druck.
  Widget _buildEingeladen() {
    final n = _einladungsSchritt;
    final icon = switch (n) {
      1 => Icons.favorite_border_rounded,
      2 => Icons.front_hand_outlined,
      _ => Icons.lock_outline_rounded,
    };
    final titel = switch (n) {
      1 => t.onboardingEingeladenTitel1,
      2 => t.onboardingEingeladenTitel2,
      _ => t.onboardingEingeladenTitel3,
    };
    final text = switch (n) {
      1 => t.onboardingEingeladenText1,
      2 => t.onboardingEingeladenText2,
      _ => t.onboardingEingeladenText3,
    };

    Widget weg(String label, VoidCallback? onPressed, {bool betont = false}) => SizedBox(
          width: double.infinity,
          child: betont
              ? ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.akzent,
                    foregroundColor: AppTheme.aufAkzent,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                  ),
                  child: Text(label,
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              : OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.akzentTief,
                    minimumSize: const Size.fromHeight(54),
                    side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                  ),
                  child: Text(label,
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
        );

    return Scaffold(
      backgroundColor: AppTheme.papier,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() {
                    if (n == 1) {
                      _eingeladen = false;
                    } else {
                      _einladungsSchritt--;
                    }
                  }),
                  icon: Icon(Icons.arrow_back_rounded, size: 18, color: AppTheme.tinteLeise),
                  label: Text(t.onboardingZurueck, style: TextStyle(color: AppTheme.tinteLeise)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.papierErhoben,
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    border: Border.all(color: AppTheme.linie),
                  ),
                  child: Icon(icon, color: AppTheme.akzentTief, size: 32),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                titel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: VpTypo.serif,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.tinte,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppTheme.tinteLeise, height: 1.5),
              ),
              const SizedBox(height: 28),
              if (n < 3) ...[
                weg(t.onboardingWeiter, () => setState(() => _einladungsSchritt++), betont: true),
                const SizedBox(height: 10),
                weg(t.onboardingEingeladenNurSchauen, _isSubmitting ? null : _ueberspringen),
              ] else ...[
                weg(t.onboardingEingeladenEinrichten, () => setState(() {
                      _eingeladen = false;
                      _schritt = 1;
                    })),
                const SizedBox(height: 10),
                weg(t.onboardingEingeladenVerbinden, _isSubmitting ? null : _mitPersonVerbinden),
                const SizedBox(height: 10),
                weg(t.onboardingEingeladenNurSchauen, _isSubmitting ? null : _ueberspringen),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditing && _eingeladen) {
      // Systemzurück geht im Einladungsmodus einen Schritt zurück, statt die App zu schließen.
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          setState(() {
            if (_einladungsSchritt == 1) {
              _eingeladen = false;
            } else {
              _einladungsSchritt--;
            }
          });
        },
        child: _buildEingeladen(),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.papier,
      appBar: widget.isEditing
          ? AppBar(
              title: Text(t.onboardingProfilePersonalisation),
              backgroundColor: AppTheme.papier,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isEditing && _schritt == 0) ...[
                // Welcome Logo & Header
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.papierErhoben,
                      borderRadius: BorderRadius.circular(VpRadius.karte),
                      border: Border.all(color: AppTheme.linie),
                      
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      color: AppTheme.akzentTief,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    t.onboardingWelcomeToVelvetpulse,
                    style: TextStyle(
                      fontFamily: VpTypo.serif, fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.tinte,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    t.onboardingYourPrivateCoachingProgrammeFor,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.tinteLeise,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildVersprechen(),
                const SizedBox(height: 16),

                // Fast Restore Option
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.papierErhoben,
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_download_rounded, color: AppTheme.akzentTief, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.onboardingAlreadyUsingVelvetpulse,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.tinte,
                              ),
                            ),
                            Text(
                              t.onboardingLoadABackupFromFile,
                              style: TextStyle(fontSize: 11, color: AppTheme.tinteStumm),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _promptRestoreBackup,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.akzentTief),
                          foregroundColor: AppTheme.akzentTief,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        child: Text(t.onboardingRestore, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _schritt = 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.akzent,
                      foregroundColor: AppTheme.aufAkzent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                    ),
                    child: Text(t.onboardingLosGehts, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 4),
                // Ruhiger dritter Weg für Menschen, die eingeladen wurden.
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => setState(() {
                      _eingeladen = true;
                      _einladungsSchritt = 1;
                    }),
                    icon: Icon(Icons.favorite_border_rounded, size: 18, color: AppTheme.akzentTief),
                    label: Text(
                      t.onboardingEingeladenLink,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.akzentTief, fontSize: 14.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],

              if (!widget.isEditing && _schritt >= 1) ...[
                Text(t.onboardingSchritt(_schritt, _fragen),
                    style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _schritt / _fragen,
                    minHeight: 4,
                    backgroundColor: AppTheme.papierVertieft,
                    valueColor: AlwaysStoppedAnimation(AppTheme.akzentTief),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 1. Name
              if (widget.isEditing || _schritt == 1) ...[
              _buildSectionTitle(t.onboardingWhatShouldWeCallYou, Icons.person_rounded),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: TextStyle(color: AppTheme.tinte, fontSize: 15),
                decoration: InputDecoration(
                  hintText: t.onboardingYourFirstNameOrA,
                  prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.tinteStumm, size: 20),
                  filled: true,
                  fillColor: AppTheme.papierErhoben,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    borderSide: BorderSide(color: AppTheme.linie),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    borderSide: BorderSide(color: AppTheme.linie),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    borderSide: BorderSide(color: AppTheme.akzentTief),
                  ),
                ),
              ),

              ],

              // 2. Gender
              if (widget.isEditing || _schritt == 2) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(t.onboardingYourGender, Icons.wc_rounded),
              Text(
                t.onboardingAdjustsCourseRecommendationsPelvicFloor,
                style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm),
              ),
              const SizedBox(height: 10),
              // 2×2-Raster: Frau, Mann, Divers, Keine Angabe (keine Vorauswahl)
              Row(
                children: [
                  Expanded(child: _geschlechtKarte('female', t.onboardingFemale, Icons.female_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _geschlechtKarte('male', t.onboardingMale, Icons.male_rounded)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _geschlechtKarte('other', t.partnerProfileDialogNonBinary, Icons.all_inclusive_rounded)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _geschlechtKarte(
                          'unspecified', t.partnerProfileDialogNotSpecified, Icons.radio_button_unchecked_rounded)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                t.onboardingGenderWeitergehen,
                style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm),
              ),
              if (widget.isEditing) ...[
                const SizedBox(height: 20),
                _buildKoerperKarte(),
              ],
              ],

              // 3. Age
              if (widget.isEditing || _schritt == 3) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(t.onboardingYourAgeSelectedageYears(_selectedAge), Icons.cake_rounded),
              const SizedBox(height: 4),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.akzentTief,
                  inactiveTrackColor: AppTheme.papierVertieft,
                  thumbColor: AppTheme.akzent,
                  overlayColor: AppTheme.akzentTief.withValues(alpha: 0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _selectedAge.toDouble(),
                  min: 18,
                  max: 75,
                  divisions: 57,
                  label: '$_selectedAge',
                  onChanged: (val) => setState(() => _selectedAge = val.toInt()),
                ),
              ),

              ],

              // 4. Relationship Status
              if (widget.isEditing || _schritt == 4) ...[
              const SizedBox(height: 20),
              _buildSectionTitle(t.onboardingYourRelationshipStatus, Icons.favorite_rounded),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChoiceChip(
                    id: 'relationship',
                    current: _selectedRelationship,
                    label: t.onboardingInARelationshipMarried,
                    onTap: () => setState(() => _selectedRelationship = 'relationship'),
                  ),
                  _buildChoiceChip(
                    id: 'dating',
                    current: _selectedRelationship,
                    label: t.onboardingDatingGettingToKnowSomeone,
                    onTap: () => setState(() => _selectedRelationship = 'dating'),
                  ),
                  _buildChoiceChip(
                    id: 'single',
                    current: _selectedRelationship,
                    label: t.onboardingSingle,
                    onTap: () => setState(() => _selectedRelationship = 'single'),
                  ),
                  _buildChoiceChip(
                    id: 'complicated',
                    current: _selectedRelationship,
                    label: t.onboardingItSComplicated,
                    onTap: () => setState(() => _selectedRelationship = 'complicated'),
                  ),
                ],
              ),

              ],

              // 5. Primary Goal
              if (widget.isEditing || _schritt == 5) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(t.onboardingWhatSYourBiggestPriority, Icons.track_changes_rounded),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'performance_anxiety',
                title: t.onboardingStopPerformancePressureRacingThoughts,
                subtitle: t.onboardingBreakThoughtLoopsStopSpectatoring,
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'pelvic_somatics',
                title: t.onboardingPelvicFloorRelaxationBodyAwareness,
                subtitle: t.onboardingReleaseTensionPractiseReverseKegels,
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'couple_intimacy',
                title: t.onboardingCoupleIntimacyPressureFreeSex,
                subtitle: t.onboardingSensateFocusTogetherCalmingEach,
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'body_pleasure',
                title: t.onboardingDesireSelfAcceptanceBodyAwareness,
                subtitle: t.onboardingUnderstandResponsiveDesireEaseOrgasm,
              ),
              const SizedBox(height: 8),
              Text(
                t.onboardingGenderWeitergehen,
                style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm),
              ),

              ],

              const SizedBox(height: 32),

              // Submit Button (bei der Ersteinrichtung: Weiter, am Ende Personalisieren)
              if (widget.isEditing || _schritt >= 1)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : (!widget.isEditing && _schritt < _fragen ? () => setState(() => _schritt++) : _submit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.akzent,
                    foregroundColor: AppTheme.aufAkzent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppTheme.aufAkzent,
                          ),
                        )
                      : Text(
                          widget.isEditing
                              ? t.onboardingSaveChanges
                              : (_schritt < _fragen ? t.onboardingWeiter : t.onboardingPersonaliseProgrammeNow),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              if (!widget.isEditing && _schritt > 1)
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _schritt--),
                    child: Text(t.onboardingZurueck, style: TextStyle(color: AppTheme.tinteLeise)),
                  ),
                ),

              if (!widget.isEditing) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: _isSubmitting ? null : _ueberspringen,
                    icon: Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.tinteStumm),
                    label: Text(
                      t.onboardingSkipGoStraightToThe,
                      style: TextStyle(color: AppTheme.tinteStumm, fontSize: 13),
                    ),
                  ),
                ),
              ],

              if (widget.isEditing) ...[
                const SizedBox(height: 24),
                Divider(color: AppTheme.linie),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnleitungScreen())),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(t.anleitungTitel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.akzentTief,
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RueckmeldungScreen())),
                  icon: const Icon(Icons.campaign_outlined),
                  label: Text(t.rueckmeldungTitel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.tinteLeise,
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(color: AppTheme.linie),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLanguageSection(),
                const SizedBox(height: 16),
                _buildPrivacySection(),
                const SizedBox(height: 16),
                _buildDesignSection(),
                const SizedBox(height: 16),
                _buildSpicySection(),
                const SizedBox(height: 16),
                _buildBackupSection(),
                const SizedBox(height: 16),
                _buildHalloSection(),
                const SizedBox(height: 16),
                _buildVersionSection(),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Willkommensseite: drei Versprechen statt eines langen Datenschutztextes; die Einzelheiten stehen dahinter.
  Widget _buildVersprechen() {
    Widget zeile(IconData icon, String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: AppTheme.akzentTief, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 14, color: AppTheme.tinte, height: 1.4)),
            ),
          ]),
        );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        zeile(Icons.lock_outline_rounded, t.onboardingVersprechenLokal),
        zeile(Icons.person_off_outlined, t.onboardingVersprechenKeinKonto),
        zeile(Icons.wifi_off_rounded, t.onboardingVersprechenNetz),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppTheme.papierErhoben,
                title: Text(t.onboardingMehrDatenschutz),
                content: Text(t.onboardingPrivateProfileJournalProgressStay),
                actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(t.onboardingOk))],
              ),
            ),
            child: Text(t.onboardingMehrDatenschutz, style: TextStyle(color: AppTheme.akzentTief)),
          ),
        ),
      ]),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.akzentTief, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.tinte,
            ),
          ),
        ),
      ],
    );
  }

  Widget _geschlechtKarte(String id, String label, IconData icon) => _buildSelectCard(
        id: id,
        current: _selectedGender,
        label: label,
        icon: icon,
        activeColor: AppTheme.akzentTief,
        onTap: () => setState(() => _selectedGender = id),
      );

  /// Körper-Voreinstellung (nur im Profil, freiwillig, unabhängig vom Geschlecht). Wird sofort gespeichert.
  Widget _buildKoerperKarte() {
    Future<void> waehlen(String? wert) async {
      setState(() => _koerper = wert);
      await StorageService.setKoerperVoreinstellung(wert);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.onboardingKoerperTitel, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
          const SizedBox(height: 4),
          Text(t.onboardingKoerperText, style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, height: 1.35)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip(
                  id: 'vulva', current: _koerper ?? '', label: t.onboardingKoerperVulva, onTap: () => waehlen('vulva')),
              _buildChoiceChip(
                  id: 'penis', current: _koerper ?? '', label: t.onboardingKoerperPenis, onTap: () => waehlen('penis')),
              _buildChoiceChip(
                  id: 'beides', current: _koerper ?? '', label: t.onboardingKoerperBeides, onTap: () => waehlen('beides')),
              _buildChoiceChip(
                  id: '', current: _koerper ?? '', label: t.onboardingKoerperSpaeter, onTap: () => waehlen(null)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCard({
    required String id,
    required String? current,
    required String label,
    required IconData icon,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final isSelected = current == id;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VpRadius.karte),
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.18) : AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.linie,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? activeColor : AppTheme.tinteLeise, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.tinte : AppTheme.tinteLeise,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String id,
    required String current,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = current == id;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VpRadius.karte),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.akzentTief.withValues(alpha: 0.18) : AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(
            color: isSelected ? AppTheme.akzentTief : AppTheme.linie,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.tinte : AppTheme.tinteLeise,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTile({
    required String id,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedGoal == id;
    return InkWell(
      onTap: () => setState(() => _selectedGoal = id),
      borderRadius: BorderRadius.circular(VpRadius.karte),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.papierVertieft.withValues(alpha: 0.5) : AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(
            color: isSelected ? AppTheme.akzentTief : AppTheme.linie,
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? AppTheme.akzentTief : AppTheme.tinteStumm,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.tinte,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.tinteLeise,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadPrivacySettings() async {
    final lock = await PrivacyService.isLockEnabled();
    final discreet = await PrivacyService.isDiscreetIcon();
    final supported = await PrivacyService.isSupported();
    final channel = await UpdateService.channel();
    final notify = await MessageNotifier.isEnabled();
    if (mounted) {
      setState(() {
        _updateChannel = channel;
        _notifyMessages = notify;
        _lockEnabled = lock;
        _discreetIcon = discreet;
        _lockSupported = supported;
        _frageVorLautsprecher = StorageService.getFrageVorLautsprecher();
        _pausiereBeiKopfhoererGetrennt = StorageService.getPausiereBeiKopfhoererGetrennt();
        _halloGesendetAm = StorageService.getHalloGesendetAm();
      });
    }
  }

  Widget _buildVersionSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.system_update_rounded, color: AppTheme.akzentTief, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  // Siebenmal tippen: Testmodus an/aus (lib/services/testmodus.dart).
                  onTap: () {
                    final neu = Testmodus.tippen();
                    if (neu == null) return;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(neu ? t.testmodusAn : t.testmodusAus)));
                  },
                  child: FutureBuilder<String>(
                    future: UpdateService.installedVersion(),
                    builder: (context, snap) => Text(
                      t.onboardingVersionData(snap.data ?? '…'),
                      style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => checkForUpdateAndPrompt(context, force: true),
                child: Text(t.onboardingCheckForUpdates, style: TextStyle(color: AppTheme.akzentTief)),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(left: 30, right: 4),
            value: _updateChannel == UpdateChannel.beta,
            activeThumbColor: AppTheme.akzentTief,
            title: Text(t.onboardingReceiveBetaVersions,
                style: TextStyle(color: AppTheme.tinte, fontSize: 14)),
            subtitle: Text(
              _updateChannel == UpdateChannel.beta
                  ? t.onboardingYouGetNewFeaturesEarlier
                  : t.onboardingOnlyTestedVersionsWhenSwitching,
              style: TextStyle(color: AppTheme.tinteStumm, fontSize: 12, height: 1.35),
            ),
            onChanged: (beta) async {
              final channel = beta ? UpdateChannel.beta : UpdateChannel.stable;
              await UpdateService.setChannel(channel);
              if (mounted) setState(() => _updateChannel = channel);
            },
          ),
        ],
      ),
    );
  }

  /// Sprache der App. Ein Wechsel baut die ganze App neu auf (main.dart) und lädt die Inhalte neu.
  Widget _buildLanguageSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate_rounded, color: AppTheme.akzentTief, size: 20),
              const SizedBox(width: 8),
              Text(t.spracheTitel,
                  style: TextStyle(color: AppTheme.tinte, fontSize: 14.5, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.spracheHinweis, style: TextStyle(color: AppTheme.tinteStumm, fontSize: 12.5, height: 1.4)),
          const SizedBox(height: 6),
          RadioGroup<String>(
            groupValue: Sprache.wahl.value,
            onChanged: (wert) {
              if (wert != null) Sprache.setzen(wert);
            },
            child: Column(children: [
              for (final (wert, text) in [
                ('auto', t.spracheAutomatisch),
                ('de', t.spracheDeutsch),
                ('en', t.spracheEnglisch),
              ])
                RadioListTile<String>(
                  value: wert,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppTheme.akzent,
                  title: Text(text, style: TextStyle(color: AppTheme.tinte, fontSize: 14)),
                ),
            ]),
          ),
          const AufnahmenKarte(),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility_off_rounded, color: AppTheme.akzentTief, size: 20),
              SizedBox(width: 8),
              Text(
                t.onboardingDiscretion,
                style: TextStyle(color: AppTheme.tinte, fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _lockEnabled,
            activeThumbColor: AppTheme.akzent,
            onChanged: _lockSupported
                ? (value) async {
                    final ok = await PrivacyService.setLockEnabled(value);
                    if (ok && mounted) setState(() => _lockEnabled = value);
                  }
                : null,
            title: Text(t.onboardingLockWithFingerprint, style: TextStyle(fontSize: 14)),
            subtitle: Text(
              _lockSupported
                  ? t.onboardingOnOpeningAndAfterOne
                  : t.onboardingNoScreenLockIsSet,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _discreetIcon,
            activeThumbColor: AppTheme.akzent,
            onChanged: (value) async {
              await PrivacyService.setDiscreetIcon(value);
              if (!mounted) return;
              setState(() => _discreetIcon = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? t.onboardingTheAppIsNowCalled
                      : t.onboardingTheAppIsCalledVelvetpulse),
                ),
              );
            },
            title: Text(t.onboardingDiscreetAppIcon, style: TextStyle(fontSize: 14)),
            subtitle: Text(
              t.onboardingShowsPulseWithANeutral,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _personalizeNames,
            activeThumbColor: AppTheme.akzent,
            onChanged: (value) async {
              await StorageService.setPersonalizeNames(value);
              if (mounted) setState(() => _personalizeNames = value);
            },
            title: Text(t.onboardingCallYourPartnerByName, style: TextStyle(fontSize: 14)),
            subtitle: Text(
              t.onboardingForExampleAnnaLiesOn,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _notifyMessages,
            activeThumbColor: AppTheme.akzent,
            onChanged: (value) async {
              final ok = await MessageNotifier.setEnabled(value);
              if (!mounted) return;
              if (ok) {
                setState(() => _notifyMessages = value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(t.onboardingAndroidHasnTAllowedNotifications),
                ));
              }
            },
            title: Text(t.onboardingNotifyAboutNewMessages, style: TextStyle(fontSize: 14)),
            subtitle: Text(
              t.onboardingEvenWhenTheAppIs,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _frageVorLautsprecher,
            activeThumbColor: AppTheme.akzent,
            onChanged: (value) async {
              await StorageService.setFrageVorLautsprecher(value);
              if (mounted) setState(() => _frageVorLautsprecher = value);
            },
            title: Text(t.lautsprecherEinstellungFrageTitel, style: const TextStyle(fontSize: 14)),
            subtitle: Text(
              t.lautsprecherEinstellungFrageText,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _pausiereBeiKopfhoererGetrennt,
            activeThumbColor: AppTheme.akzent,
            onChanged: (value) async {
              await StorageService.setPausiereBeiKopfhoererGetrennt(value);
              if (mounted) setState(() => _pausiereBeiKopfhoererGetrennt = value);
            },
            title: Text(t.lautsprecherEinstellungPauseTitel, style: const TextStyle(fontSize: 14)),
            subtitle: Text(
              t.lautsprecherEinstellungPauseText,
              style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  /// Darstellung des Normalmodus: Papier (hell), Nachtpapier (dunkel) oder Klassisch (Farben bis Build 55, Übergang).
  Widget _buildDesignSection() {
    final namen = {'papier': t.designPapier, 'nacht': t.designNacht, 'klassisch': t.designKlassisch};
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.designTitel, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(t.designText, style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35)),
        const SizedBox(height: 12),
        ValueListenableBuilder<String>(
          valueListenable: StorageService.designAenderung,
          builder: (context, gewaehlt, _) => Wrap(spacing: 8, runSpacing: 8, children: [
            for (final e in namen.entries)
              ChoiceChip(
                label: Text(e.value),
                selected: gewaehlt == e.key,
                onSelected: (_) => StorageService.setDesignPalette(e.key),
              ),
          ]),
        ),
      ]),
    );
  }

  /// Spicy-Modus: aus, bis man ihn bewusst mit Altersangabe und Gerätesperre einschaltet; Ausschalten geht sofort.
  Widget _buildSpicySection() {
    return ListenableBuilder(
      listenable: Listenable.merge([AlterDienst.aenderung, StorageService.spicyAenderung]),
      builder: (context, _) {
        final an = StorageService.spicyMode();
        final gesperrt = !an && StorageService.spicyGewaehlt() && AlterDienst.bestaetigt;
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.linie),
          ),
          child: Column(children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.only(right: 8),
              value: an,
              activeThumbColor: AppTheme.akzentTief,
              secondary: Icon(Icons.spa_outlined, color: an ? AppTheme.akzentTief : AppTheme.tinteStumm),
              title: Text(t.spicyModus, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
              subtitle: Text(
                gesperrt ? t.alterGesperrtKurz : t.spicyModusText,
                style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
              ),
              onChanged: (value) async {
                if (value) {
                  await spicyModusEinschalten(context);
                } else {
                  await StorageService.setSpicyMode(false);
                }
                if (mounted) setState(() {});
              },
            ),
            if (an)
              SwitchListTile(
                contentPadding: const EdgeInsets.only(right: 8),
                value: AlterDienst.absichern,
                activeThumbColor: AppTheme.akzentTief,
                title: Text(t.alterAbsichern, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  t.alterAbsichernText,
                  style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.35),
                ),
                onChanged: (value) async {
                  await AlterDienst.setAbsichern(value);
                  if (mounted) setState(() {});
                },
              ),
          ]),
        );
      },
    );
  }
  Widget _buildBackupSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_rounded, color: AppTheme.akzentTief, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.onboardingPrivacyUpdateSafety,
                  style: TextStyle(
                    color: AppTheme.tinte,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t.onboardingEverythingStaysLocalOnYour,
            style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showExportBackupDialog(context),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(t.onboardingExportBackup, style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.5)),
                    foregroundColor: AppTheme.akzentTief,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _promptRestoreBackup,
                  icon: const Icon(Icons.restore_page_rounded, size: 16),
                  label: Text(t.onboardingRestore, style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.5)),
                    foregroundColor: AppTheme.akzentTief,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sendeHallo() async {
    if (_halloSendet || _halloGesendetAm != null) return;
    setState(() => _halloSendet = true);
    final info = await PackageInfo.fromPlatform();
    final version = info.version;
    final sprache = Sprache.code;
    final ok = await Rueckmeldung.halloSenden(version: version, sprache: sprache);
    if (!mounted) return;
    setState(() => _halloSendet = false);
    if (ok) {
      final jetzt = DateTime.now();
      final datumStr =
          '${jetzt.day.toString().padLeft(2, '0')}.${jetzt.month.toString().padLeft(2, '0')}.${jetzt.year}';
      await StorageService.setHalloGesendetAm(datumStr);
      if (mounted) {
        setState(() => _halloGesendetAm = datumStr);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.halloGesendet), backgroundColor: AppTheme.akzent),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.rueckmeldungFehler), backgroundColor: AppTheme.signal),
      );
    }
  }

  Widget _buildHalloSection() {
    final gesendet = _halloGesendetAm;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.waving_hand_rounded, color: AppTheme.akzentTief, size: 20),
              const SizedBox(width: 8),
              Text(
                t.halloTitel,
                style: TextStyle(
                  color: AppTheme.tinte,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            t.halloErklaerung,
            style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: 12),
          if (gesendet != null)
            Text(
              t.halloDankeGesendet(gesendet),
              style: TextStyle(color: AppTheme.akzentTief, fontSize: 13, fontWeight: FontWeight.w600),
            )
          else
            OutlinedButton.icon(
              onPressed: _halloSendet ? null : _sendeHallo,
              icon: _halloSendet
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_rounded, size: 16),
              label: Text(t.halloKnopf, style: const TextStyle(fontSize: 12.5)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.5)),
                foregroundColor: AppTheme.akzentTief,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
        ],
      ),
    );
  }
}
