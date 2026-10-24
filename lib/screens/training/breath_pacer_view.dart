import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

enum BreathMode { fourSevenEight, physiologicalSigh }

class BreathPhase {
  final String title;
  final String action;
  final int seconds;
  final bool isInhale;
  final bool isHold;
  final bool isExhale;

  const BreathPhase({
    required this.title,
    required this.action,
    required this.seconds,
    this.isInhale = false,
    this.isHold = false,
    this.isExhale = false,
  });
}

class BreathPacerView extends StatefulWidget {
  const BreathPacerView({super.key});

  @override
  State<BreathPacerView> createState() => _BreathPacerViewState();
}

class _BreathPacerViewState extends State<BreathPacerView> with TickerProviderStateMixin {
  BreathMode _mode = BreathMode.fourSevenEight;
  bool _isRunning = false;
  int _currentPhaseIndex = 0;
  int _secondsLeft = 0;
  int _completedCycles = 0;

  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  List<BreathPhase> get _phases {
    if (_mode == BreathMode.fourSevenEight) {
      return const [
        BreathPhase(
          title: 'EINATMEN',
          action: 'Ruhig und tief durch die Nase einatmen...',
          seconds: 4,
          isInhale: true,
        ),
        BreathPhase(
          title: 'HALTEN',
          action: 'Atem anhalten, Brustkorb entspannt lassen...',
          seconds: 7,
          isHold: true,
        ),
        BreathPhase(
          title: 'LANGSAM AUSATMEN',
          action: 'Vollständig und mit sanftem Zischen durch den Mund ausatmen...',
          seconds: 8,
          isExhale: true,
        ),
      ];
    } else {
      return const [
        BreathPhase(
          title: 'TIEF EINATMEN',
          action: 'Tief durch die Nase in den Bauch einatmen...',
          seconds: 3,
          isInhale: true,
        ),
        BreathPhase(
          title: 'ZWEITER ATEMZUG',
          action: 'Noch einen kurzen Luftzug oben drauf ziehen (Alveolen weiten)...',
          seconds: 1,
          isInhale: true,
        ),
        BreathPhase(
          title: 'SEUFZEND AUSATMEN',
          action: 'Sehr lang und hörbar durch den Mund ausatmen, Schultern fallen lassen...',
          seconds: 6,
          isExhale: true,
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
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _secondsLeft = _phases[0].seconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _switchMode(BreathMode mode) {
    if (_isRunning) _stop();
    setState(() {
      _mode = mode;
      _currentPhaseIndex = 0;
      _completedCycles = 0;
      _secondsLeft = _phases[0].seconds;
    });
  }

  void _start() {
    setState(() {
      _isRunning = true;
    });
    HapticFeedback.mediumImpact();
    _applyPhaseAnimation();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
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
      _secondsLeft = phases[_currentPhaseIndex].seconds;
    } else {
      _completedCycles++;
      _currentPhaseIndex = 0;
      _secondsLeft = phases[0].seconds;
      if (_completedCycles % 3 == 0) {
        StorageService.recordActivityToday();
      }
    }
    _applyPhaseAnimation();
  }

  void _applyPhaseAnimation() {
    final current = _phases[_currentPhaseIndex];
    _animController.duration = Duration(seconds: current.seconds);
    if (current.isInhale) {
      _animController.forward(from: _animController.value);
    } else if (current.isExhale) {
      _animController.reverse(from: _animController.value);
    } else if (current.isHold) {
      _animController.stop();
    }
  }

  void _pause() {
    _timer?.cancel();
    _animController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _stop() {
    _timer?.cancel();
    _animController.stop();
    _animController.reset();
    setState(() {
      _isRunning = false;
      _currentPhaseIndex = 0;
      _secondsLeft = _phases[0].seconds;
      _completedCycles = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phases = _phases;
    final current = phases[_currentPhaseIndex];

    Color phaseColor = AppTheme.sageGreen;
    if (current.isHold) {
      phaseColor = AppTheme.amber;
    } else if (current.isExhale) {
      phaseColor = const Color(0xFF38BDF8); // Calming Sky Blue
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Mode Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildModeTab(
                    title: '4-7-8 Atmung',
                    subtitle: 'Tiefe Parasympathikus-Aktivierung',
                    mode: BreathMode.fourSevenEight,
                  ),
                ),
                Expanded(
                  child: _buildModeTab(
                    title: 'Physiol. Seufzer',
                    subtitle: 'Sofortige Adrenalin-Bremse',
                    mode: BreathMode.physiologicalSigh,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Cycle Counter Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  '$_completedCycles Zyklen abgeschlossen',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Pulsing Visual Breathing Ring
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                final scale = _isRunning ? _scaleAnimation.value : 1.0;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          phaseColor.withValues(alpha: 0.28),
                          phaseColor.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: phaseColor,
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: phaseColor.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_secondsLeft',
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: phaseColor,
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

          const SizedBox(height: 32),

          // Instruction Text Box
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
                  current.action,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _mode == BreathMode.fourSevenEight
                      ? 'Längeres Ausatmen verlangsamt messbar den Herzschlag.'
                      : 'Der doppelte Atemzug entfaltet kollabierte Lungenbläschen.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
              OutlinedButton(
                onPressed: _stop,
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: 150,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? _pause : _start,
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

          // Neuro-Bio Info Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.science_outlined, color: AppTheme.sageGreen, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Biologischer Hintergrund: Wenn das Ausatmen länger dauert als das Einatmen, dehnt sich das Zwerchfell nach oben, das Herz bekommt etwas mehr Raum und der Vagusnerv schickt ein Signal ans Gehirn, die Herzfrequenz sofort zu drosseln.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required String title,
    required String subtitle,
    required BreathMode mode,
  }) {
    final isSelected = _mode == mode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _switchMode(mode),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.5))
                : null,
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontSize: 13,
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
