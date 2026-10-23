import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'kegel_guide_sheet.dart';

enum KegelPreset { reverseKegel, plateauMelting, classicKegel }

class KegelPhase {
  final String label;
  final String instruction;
  final int durationSeconds;
  final Color color;
  final double circleScaleTarget; // 1.0 (normal) to 1.3 (expanded) or 0.8 (contracted)

  const KegelPhase({
    required this.label,
    required this.instruction,
    required this.durationSeconds,
    required this.color,
    required this.circleScaleTarget,
  });
}

class KegelTimerView extends StatefulWidget {
  const KegelTimerView({super.key});

  @override
  State<KegelTimerView> createState() => _KegelTimerViewState();
}

class _KegelTimerViewState extends State<KegelTimerView> with SingleTickerProviderStateMixin {
  KegelPreset _selectedPreset = KegelPreset.reverseKegel;
  bool _isRunning = false;
  int _currentRound = 1;
  static const int _totalRounds = 10;
  int _currentPhaseIndex = 0;
  int _secondsLeftInPhase = 0;

  Timer? _ticker;
  late AnimationController _animController;

  // Presets definition
  List<KegelPhase> get _phases {
    if (_selectedPreset == KegelPreset.reverseKegel) {
      return const [
        KegelPhase(
          label: 'EINATMEN & ABSENKEN',
          instruction: 'Tief in den Bauch atmen, Beckenboden sanft nach außen/unten nachgeben lassen',
          durationSeconds: 4,
          color: AppTheme.sageGreen,
          circleScaleTarget: 1.25,
        ),
        KegelPhase(
          label: 'WEITEN & HALTEN',
          instruction: 'Weich und offen bleiben. Den Beckenboden wie eine Hängematte hängen lassen',
          durationSeconds: 8,
          color: AppTheme.amber,
          circleScaleTarget: 1.35,
        ),
        KegelPhase(
          label: 'PAUSE & NACHSPÜREN',
          instruction: 'Ganz normal atmen, vollständige Ruhe im Becken spüren',
          durationSeconds: 6,
          color: AppTheme.surfaceLight,
          circleScaleTarget: 1.0,
        ),
      ];
    } else if (_selectedPreset == KegelPreset.plateauMelting) {
      return const [
        KegelPhase(
          label: 'EINATMEN & DAMM ÖFFNEN',
          instruction: 'Tief in den Bauch atmen, Damm und After wie eine Blüte weich öffnen',
          durationSeconds: 6,
          color: Color(0xFFE11D48),
          circleScaleTarget: 1.35,
        ),
        KegelPhase(
          label: 'WEICH SCHMELZEN & AUSATMEN',
          instruction: 'Langer, hörbarer Seufzer. Beckenboden wie warmen Honig schmelzen lassen',
          durationSeconds: 10,
          color: AppTheme.amber,
          circleScaleTarget: 1.45,
        ),
        KegelPhase(
          label: 'PLATEAU-RUHE & NACHSPÜREN',
          instruction: 'Pulsierende Wärme und absolute Stille im Beckenraum spüren',
          durationSeconds: 4,
          color: AppTheme.surfaceLight,
          circleScaleTarget: 1.0,
        ),
      ];
    } else {
      return const [
        KegelPhase(
          label: 'ANSPANNEN',
          instruction: 'Muskel nach innen-oben heben (wie Urinstrahl stoppen). Gesäß bleibt locker!',
          durationSeconds: 5,
          color: AppTheme.sageGreen,
          circleScaleTarget: 0.8,
        ),
        KegelPhase(
          label: 'KRAFT HALTEN',
          instruction: 'Spannung stabil halten, ohne den Atem anzuhalten',
          durationSeconds: 5,
          color: AppTheme.amber,
          circleScaleTarget: 0.75,
        ),
        KegelPhase(
          label: 'VOLLSTÄNDIG LOSLASSEN',
          instruction: 'Muskel komplett entspannen, Schwellkörper durchbluten lassen',
          durationSeconds: 10,
          color: AppTheme.surfaceLight,
          circleScaleTarget: 1.1,
        ),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _secondsLeftInPhase = _phases[0].durationSeconds;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _switchPreset(KegelPreset preset) {
    if (_isRunning) _stopTraining();
    setState(() {
      _selectedPreset = preset;
      _currentRound = 1;
      _currentPhaseIndex = 0;
      _secondsLeftInPhase = _phases[0].durationSeconds;
    });
  }

  void _startTraining() {
    setState(() {
      _isRunning = true;
    });
    HapticFeedback.mediumImpact();
    _animController.duration = Duration(seconds: _phases[_currentPhaseIndex].durationSeconds);
    _animController.repeat(reverse: true);

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeftInPhase > 1) {
          _secondsLeftInPhase--;
        } else {
          // Move to next phase
          _nextPhase();
        }
      });
    });
  }

  void _nextPhase() {
    HapticFeedback.mediumImpact();
    final phases = _phases;
    if (_currentPhaseIndex < phases.length - 1) {
      _currentPhaseIndex++;
      _secondsLeftInPhase = phases[_currentPhaseIndex].durationSeconds;
    } else {
      // Completed all phases in current round
      if (_currentRound < _totalRounds) {
        _currentRound++;
        _currentPhaseIndex = 0;
        _secondsLeftInPhase = phases[0].durationSeconds;
      } else {
        // Finished all 10 rounds!
        _stopTraining();
        StorageService.recordActivityToday();
        _showCompletedDialog();
        return;
      }
    }
    _animController.duration = Duration(seconds: _phases[_currentPhaseIndex].durationSeconds);
    _animController.reset();
    _animController.repeat(reverse: true);
  }

  void _pauseTraining() {
    _ticker?.cancel();
    _animController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTraining() {
    _ticker?.cancel();
    _animController.stop();
    _animController.reset();
    setState(() {
      _isRunning = false;
      _currentRound = 1;
      _currentPhaseIndex = 0;
      _secondsLeftInPhase = _phases[0].durationSeconds;
    });
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: AppTheme.amber, size: 28),
            SizedBox(width: 10),
            Text('Großartig gemacht!'),
          ],
        ),
        content: const Text(
          'Du hast alle 10 Runden erfolgreich absolviert.\nDein Beckenboden und dein Nervensystem haben heute einen wichtigen Rekalibrierungs-Reiz erhalten.',
          style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abschließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phases = _phases;
    final currentPhase = phases[_currentPhaseIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Segmented Preset Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPresetButton(
                        label: 'Reverse Kegel',
                        preset: KegelPreset.reverseKegel,
                        subtitle: 'Becken weiten (4s / 8s / 6s)',
                      ),
                    ),
                    Expanded(
                      child: _buildPresetButton(
                        label: 'Klassisch',
                        preset: KegelPreset.classicKegel,
                        subtitle: 'Kraft & Festigkeit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildPresetButton(
                  label: 'Plateau-Wellen & Schmelze ✨',
                  preset: KegelPreset.plateauMelting,
                  subtitle: 'Edging & Schließmuskel-Entlastung (6s / 10s / 4s)',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Anleitung & Info Button
          InkWell(
            onTap: () => KegelGuideSheet.show(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.sageGreen.withOpacity(0.35)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: AppTheme.sageGreen, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anleitung: Wie trainiere ich richtig?',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          'Technik, Biofeedback & Reverse-Kegel Praxis',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.sageGreen, size: 12),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Round & Phase Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  'Runde $_currentRound von $_totalRounds',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentPhase.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: currentPhase.color.withOpacity(0.4)),
                ),
                child: Text(
                  'Phase ${_currentPhaseIndex + 1}/${phases.length}',
                  style: TextStyle(
                    color: currentPhase.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Dynamic Pulsing Visual Circle
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final pulse = _isRunning
                    ? (_animController.value * 0.15)
                    : 0.0;
                final scale = currentPhase.circleScaleTarget + pulse;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          currentPhase.color.withOpacity(0.28),
                          currentPhase.color.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: currentPhase.color,
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentPhase.color.withOpacity(0.35),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_secondsLeftInPhase',
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentPhase.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: currentPhase.color,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Clear Centered Instruction Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Text(
                  currentPhase.instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '💡 Tipp: Schließe die Augen – spüre das Vibrations-Feedback bei jedem Phasenwechsel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset Button
              OutlinedButton(
                onPressed: _stopTraining,
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
              ),
              const SizedBox(width: 18),
              // Main Start / Pause Button
              SizedBox(
                width: 150,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTraining : _startTraining,
                  icon: Icon(
                    _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 26,
                  ),
                  label: Text(
                    _isRunning ? 'Pause' : 'Start',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? AppTheme.amber : AppTheme.sageGreen,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // Skip to next phase button
              OutlinedButton(
                onPressed: _isRunning ? _nextPhase : null,
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.skip_next_rounded, color: AppTheme.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Technique Tips Footer
          InkWell(
            onTap: () => KegelGuideSheet.show(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.amber.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_rounded, color: AppTheme.amber, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warum Entspannung vor Kraft kommt',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tippe hier für die vollständige Schritt-für-Schritt Anleitung & Fehleranalyse.',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPresetButton({
    required String label,
    required KegelPreset preset,
    required String subtitle,
  }) {
    final isSelected = _selectedPreset == preset;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _switchPreset(preset),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppTheme.sageGreen.withOpacity(0.5))
                : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppTheme.sageGreen : AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
