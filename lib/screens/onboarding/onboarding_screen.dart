import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user_profile.dart';
import '../../services/storage_service.dart';
import '../../services/auto_backup_service.dart';
import '../../services/backup_codec.dart';
import '../../services/privacy_service.dart';
import '../../services/update_service.dart';
import '../../widgets/backup_dialogs.dart';
import '../../widgets/update_dialog.dart';
import '../../theme/app_theme.dart';
import '../main_navigation_screen.dart';

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
  String _selectedGender = 'male';
  int _selectedAge = 32;
  String _selectedRelationship = 'relationship';
  String _selectedGoal = 'performance_anxiety';
  bool _isSubmitting = false;
  bool _lockEnabled = false;
  bool _discreetIcon = false;
  UpdateChannel _updateChannel = UpdateChannel.stable;
  bool _lockSupported = false;

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
      _selectedGoal = existing.primaryGoal;
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
      final name = _nameController.text.trim().isEmpty ? 'Gast' : _nameController.text.trim();
      final profile = UserProfile(
        name: name,
        gender: _selectedGender,
        age: _selectedAge,
        relationshipStatus: _selectedRelationship,
        primaryGoal: _selectedGoal,
      );

      await StorageService.saveUserProfile(profile);

      if (widget.isEditing) {
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil erfolgreich aktualisiert.'),
              backgroundColor: AppTheme.sageGreen,
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
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: AppTheme.border, width: 1.5)),
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
                        color: AppTheme.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.restore_page_rounded, color: AppTheme.sageGreen, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sicherung wiederherstellen',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Stelle dein Profil, Lektionen & Nostr-Kanal wieder her',
                              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
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
                        color: const Color(0xFF064E3B).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Sicherung auf dem Gerät gefunden!'.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF34D399),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Profil: ${fileData.profileName}',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
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
                              label: const Text('Automatische Sicherung jetzt einspielen', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: const Color(0xFF0F172A),
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
                        color: AppTheme.amber.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.amber.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.content_paste_rounded, color: AppTheme.amber, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'IN ZWISCHENABLAGE BEREIT',
                                style: TextStyle(
                                  color: AppTheme.amber,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sicherung für: „${clipData.profileName}“',
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
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
                              label: const Text('Aus Zwischenablage einspielen', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.amber,
                                foregroundColor: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Option 3: Manual JSON Input field
                  const Text(
                    'Backup-Code / JSON manuell einfügen:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: inputController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Hier JSON-Text einfügen (z. B. {"app": "VelvetPulse", ...})',
                      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      filled: true,
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.paste_rounded, color: AppTheme.amber, size: 20),
                        tooltip: 'Aus Zwischenablage einfügen',
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
                            const SnackBar(content: Text('Bitte füge zuerst den Backup-JSON-Text ein.'), backgroundColor: AppTheme.amber),
                          );
                          return;
                        }
                        try {
                          final backup = BackupCodec.validate(raw);
                          Navigator.of(ctx).pop();
                          await _applyRestore(backup);
                        } on BackupException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message), backgroundColor: AppTheme.rose),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Sicherung jetzt anwenden', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.sageGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      error = 'Die Sicherung konnte nicht eingespielt werden.';
    }
    if (!mounted) return;

    if (error == null) {
      HapticFeedback.mediumImpact();
      final profile = StorageService.getUserProfile();
      final name = profile?.name ?? 'Nutzer';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sicherung für "$name" erfolgreich eingespielt! ✨'),
          backgroundColor: AppTheme.sageGreen,
        ),
      );

      if (widget.isEditing) {
        setState(() {
          if (profile != null) {
            _nameController.text = profile.name;
            _selectedGender = profile.gender;
            _selectedAge = profile.age;
            _selectedRelationship = profile.relationshipStatus;
            _selectedGoal = profile.primaryGoal;
          }
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.rose),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: widget.isEditing
          ? AppBar(
              title: const Text('Profil & Personalisierung'),
              backgroundColor: AppTheme.background,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isEditing) ...[
                // Welcome Logo & Header
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.amber.withOpacity(0.15),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: AppTheme.amber,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Willkommen bei VelvetPulse',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Dein privates Coaching-Programm für somatische Ruhe, Beckenboden & Intimität.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, color: AppTheme.sageGreen, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Privat: Profil, Tagebuch & Fortschritt bleiben auf deinem Smartphone. '
                          'Nur der KI-Coach (Google Gemini) und der verschlüsselte Paar-Kanal nutzen das Internet.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fast Restore Option
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.sageGreen.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_download_rounded, color: AppTheme.sageGreen, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bereits VelvetPulse-Nutzer?',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Sicherung aus Datei oder Zwischenablage laden',
                              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _promptRestoreBackup,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.sageGreen),
                          foregroundColor: AppTheme.sageGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        child: const Text('Wiederherstellen', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 1. Name
              _buildSectionTitle('1. Wie dürfen wir dich ansprechen?', Icons.person_rounded),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Dein Vorname oder Pseudonym',
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.textMuted, size: 20),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.sageGreen),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Gender
              _buildSectionTitle('2. Dein Geschlecht', Icons.wc_rounded),
              const Text(
                'Passt Kursempfehlungen, Beckenboden-Physiologie und KI-Antworten an.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectCard(
                      id: 'male',
                      current: _selectedGender,
                      label: 'Männlich',
                      icon: Icons.male_rounded,
                      activeColor: AppTheme.sageGreen,
                      onTap: () => setState(() => _selectedGender = 'male'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSelectCard(
                      id: 'female',
                      current: _selectedGender,
                      label: 'Weiblich',
                      icon: Icons.female_rounded,
                      activeColor: const Color(0xFFFB7185),
                      onTap: () => setState(() => _selectedGender = 'female'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSelectCard(
                      id: 'other',
                      current: _selectedGender,
                      label: 'Divers',
                      icon: Icons.all_inclusive_rounded,
                      activeColor: AppTheme.amber,
                      onTap: () => setState(() => _selectedGender = 'other'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 3. Age
              _buildSectionTitle('3. Dein Alter: $_selectedAge Jahre', Icons.cake_rounded),
              const SizedBox(height: 4),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.sageGreen,
                  inactiveTrackColor: AppTheme.surfaceLight,
                  thumbColor: AppTheme.sageGreen,
                  overlayColor: AppTheme.sageGreen.withOpacity(0.2),
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

              const SizedBox(height: 20),

              // 4. Relationship Status
              _buildSectionTitle('4. Dein Beziehungsstatus', Icons.favorite_rounded),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChoiceChip(
                    id: 'relationship',
                    current: _selectedRelationship,
                    label: 'In fester Beziehung / Verheiratet 💍',
                    onTap: () => setState(() => _selectedRelationship = 'relationship'),
                  ),
                  _buildChoiceChip(
                    id: 'dating',
                    current: _selectedRelationship,
                    label: 'Dating / Kennenlernphase 💫',
                    onTap: () => setState(() => _selectedRelationship = 'dating'),
                  ),
                  _buildChoiceChip(
                    id: 'single',
                    current: _selectedRelationship,
                    label: 'Single 🌱',
                    onTap: () => setState(() => _selectedRelationship = 'single'),
                  ),
                  _buildChoiceChip(
                    id: 'complicated',
                    current: _selectedRelationship,
                    label: 'Es ist kompliziert 🌀',
                    onTap: () => setState(() => _selectedRelationship = 'complicated'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 5. Primary Goal
              _buildSectionTitle('5. Was ist aktuell deine größte Priorität?', Icons.track_changes_rounded),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'performance_anxiety',
                title: 'Leistungsdruck & Kopfkino stoppen',
                subtitle: 'Gedankenkreise durchbrechen, Spectatoring beenden.',
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'pelvic_somatics',
                title: 'Beckenboden-Entspannung & Somatik',
                subtitle: 'Hypertonie lösen, Reverse Kegel trainieren, Vagusnerv beruhigen.',
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'couple_intimacy',
                title: 'Paar-Intimität & Druckfreier Sex',
                subtitle: 'Sensate Focus zu zweit, Co-Regulierung & verletzliche Nähe.',
              ),
              const SizedBox(height: 8),
              _buildGoalTile(
                id: 'body_pleasure',
                title: 'Lust, Selbstannahme & Körperempfinden',
                subtitle: 'Responsive Lust verstehen, Orgasmusdruck abbauen.',
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sageGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          widget.isEditing ? 'Änderungen speichern' : 'Programm jetzt personalisieren',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              if (!widget.isEditing) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            final defaultProfile = UserProfile(
                              name: 'Du',
                              gender: _selectedGender,
                              age: _selectedAge,
                              relationshipStatus: _selectedRelationship,
                              primaryGoal: _selectedGoal,
                            );
                            try {
                              await StorageService.saveUserProfile(defaultProfile);
                            } catch (e) {
                              debugPrint('Onboarding skip error: $e');
                            }
                            if (widget.onComplete != null) {
                              widget.onComplete!();
                            } else if (mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                              );
                            }
                          },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.textMuted),
                    label: const Text(
                      'Überspringen & Direkt zur App ➔',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ),
                ),
              ],

              if (widget.isEditing) ...[
                const SizedBox(height: 24),
                const Divider(color: AppTheme.border),
                const SizedBox(height: 16),
                _buildPrivacySection(),
                const SizedBox(height: 16),
                _buildBackupSection(),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.amber, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectCard({
    required String id,
    required String current,
    required String label,
    required IconData icon,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final isSelected = current == id;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.border,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? activeColor : AppTheme.textSecondary, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.sageGreen.withOpacity(0.18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.sageGreen : AppTheme.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceLight.withOpacity(0.5) : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.sageGreen : AppTheme.border,
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? AppTheme.sageGreen : AppTheme.textMuted,
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
                      color: AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
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
    if (mounted) {
      setState(() {
        _updateChannel = channel;
        _lockEnabled = lock;
        _discreetIcon = discreet;
        _lockSupported = supported;
      });
    }
  }

  Widget _buildVersionSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.system_update_rounded, color: AppTheme.sageGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: FutureBuilder<String>(
                  future: UpdateService.installedVersion(),
                  builder: (context, snap) => Text(
                    'Version ${snap.data ?? '…'}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => checkForUpdateAndPrompt(context, force: true),
                child: const Text('Nach Updates suchen', style: TextStyle(color: AppTheme.sageGreen)),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(left: 30, right: 4),
            value: _updateChannel == UpdateChannel.beta,
            activeColor: AppTheme.amber,
            title: const Text('Beta-Versionen erhalten',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
            subtitle: Text(
              _updateChannel == UpdateChannel.beta
                  ? 'Du bekommst neue Funktionen früher, dafür vielleicht mit kleinen Fehlern.'
                  : 'Nur geprüfte Versionen. Beim Zurückwechseln von Beta bleibt deine Version, '
                      'bis eine neuere stabile erscheint.',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.35),
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

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.visibility_off_rounded, color: AppTheme.sageGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Diskretion',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _lockEnabled,
            activeColor: AppTheme.sageGreen,
            onChanged: _lockSupported
                ? (value) async {
                    final ok = await PrivacyService.setLockEnabled(value);
                    if (ok && mounted) setState(() => _lockEnabled = value);
                  }
                : null,
            title: const Text('Mit Fingerabdruck sperren', style: TextStyle(fontSize: 14)),
            subtitle: Text(
              _lockSupported
                  ? 'Beim Öffnen und nach einer Minute im Hintergrund. Inhalte sind in der App-Übersicht verborgen, Screenshots gesperrt.'
                  : 'Auf diesem Gerät ist keine Displaysperre eingerichtet.',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
            ),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.only(right: 8),
            value: _discreetIcon,
            activeColor: AppTheme.sageGreen,
            onChanged: (value) async {
              await PrivacyService.setDiscreetIcon(value);
              if (!mounted) return;
              setState(() => _discreetIcon = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Die App heißt jetzt „Pulse“. Der Startbildschirm braucht dafür ein paar Sekunden.'
                      : 'Die App heißt wieder „VelvetPulse“.'),
                ),
              );
            },
            title: const Text('Unauffälliges App-Symbol', style: TextStyle(fontSize: 14)),
            subtitle: const Text(
              'Zeigt „Pulse“ mit neutralem Symbol auf dem Startbildschirm.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_rounded, color: AppTheme.sageGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Datenschutz & Update-Sicherheit',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Alles bleibt lokal auf deinem Gerät und übersteht Updates. API-Key und Paar-Verbindung liegen verschlüsselt im Android-Schlüsselspeicher und gehen nur mit Passwort in eine Sicherung.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showExportBackupDialog(context),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Backup exportieren', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.sageGreen.withOpacity(0.5)),
                    foregroundColor: AppTheme.sageGreen,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _promptRestoreBackup,
                  icon: const Icon(Icons.restore_page_rounded, size: 16),
                  label: const Text('Wiederherstellen', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.amber.withOpacity(0.5)),
                    foregroundColor: AppTheme.amber,
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
}
