import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'kegel_guide_sheet.dart';

enum KegelPreset { loslassen, kraeftigen, impulse, wellen }

enum KegelLevel { leicht, mittel, fortgeschritten }

class KegelPhase {
  final String label;
  final String instruction;
  final int durationSeconds;
  final Color color;
  final double circleScaleTarget; // 1.0 normal, > 1 weit, < 1 angespannt

  /// Name der Ansage in assets/audio/cues/<stimme>_<cue>.opus (siehe tools/generate_audio.py).
  final String? cue;

  const KegelPhase({
    required this.label,
    required this.instruction,
    required this.durationSeconds,
    required this.color,
    required this.circleScaleTarget,
    this.cue,
  });
}

class KegelTimerView extends StatefulWidget {
  const KegelTimerView({super.key});

  @override
  State<KegelTimerView> createState() => _KegelTimerViewState();
}

class _KegelTimerViewState extends State<KegelTimerView> with SingleTickerProviderStateMixin {
  static const String _keyVoice = 'kegel_voice_cues';
  static const String _keyRounds = 'kegel_rounds';
  static const String _keyLevel = 'kegel_level';
  static const List<int> _roundOptions = [5, 10, 15];

  KegelPreset _selectedPreset = KegelPreset.loslassen;
  KegelLevel _level = KegelLevel.leicht;
  int _totalRounds = 10;
  bool _voiceCues = true;

  bool _isRunning = false;
  int _currentRound = 1;
  int _currentPhaseIndex = 0;
  int _secondsLeftInPhase = 0;

  Timer? _ticker;
  late AnimationController _animController;
  final AudioPlayer _cuePlayer = AudioPlayer();

  /// Haltezeit wächst mit der Stufe.
  int _hold(int base) => base + (_level.index * 2);

  List<KegelPhase> get _phases {
    switch (_selectedPreset) {
      case KegelPreset.loslassen:
        return [
          const KegelPhase(
            label: 'EINATMEN & WEIT WERDEN',
            instruction: 'Tief in den Bauch atmen. Den Beckenboden sanft nach unten nachgeben lassen – kein Pressen.',
            durationSeconds: 4,
            color: AppTheme.sageGreen,
            circleScaleTarget: 1.25,
            cue: 'einatmen_weit',
          ),
          KegelPhase(
            label: 'WEICH BLEIBEN',
            instruction: 'Langsam ausatmen und weit bleiben, wie eine Hängematte, die locker durchhängt.',
            durationSeconds: _hold(6),
            color: AppTheme.amber,
            circleScaleTarget: 1.35,
            cue: 'weich_bleiben',
          ),
          const KegelPhase(
            label: 'NACHSPÜREN',
            instruction: 'Normal weiteratmen und spüren, wie warm und ruhig das Becken ist.',
            durationSeconds: 5,
            color: AppTheme.surfaceLight,
            circleScaleTarget: 1.0,
            cue: 'nachspueren',
          ),
        ];
      case KegelPreset.kraeftigen:
        return [
          const KegelPhase(
            label: 'ANSPANNEN',
            instruction: 'Den Bereich zwischen Schambein und Steißbein sanft nach innen und oben ziehen. Po und Bauch bleiben locker.',
            durationSeconds: 2,
            color: AppTheme.sageGreen,
            circleScaleTarget: 0.8,
            cue: 'anspannen',
          ),
          KegelPhase(
            label: 'HALTEN',
            instruction: 'Die Spannung halten, etwa mit halber Kraft. Weiter ruhig atmen.',
            durationSeconds: _hold(3),
            color: AppTheme.amber,
            circleScaleTarget: 0.75,
            cue: 'halten',
          ),
          KegelPhase(
            label: 'GANZ LOSLASSEN',
            instruction: 'Vollständig entspannen. Das Loslassen dauert mindestens so lange wie das Halten.',
            durationSeconds: _hold(3) + 3,
            color: AppTheme.surfaceLight,
            circleScaleTarget: 1.1,
            cue: 'loslassen',
          ),
        ];
      case KegelPreset.impulse:
        return const [
          KegelPhase(
            label: 'KURZ AN',
            instruction: 'Ein schnelles, kurzes Anspannen – wie ein Zwinkern mit dem Beckenboden.',
            durationSeconds: 1,
            color: AppTheme.sageGreen,
            circleScaleTarget: 0.8,
            cue: 'an',
          ),
          KegelPhase(
            label: 'LOS',
            instruction: 'Sofort wieder ganz loslassen.',
            durationSeconds: 2,
            color: AppTheme.surfaceLight,
            circleScaleTarget: 1.05,
            cue: 'los',
          ),
        ];
      case KegelPreset.wellen:
        return [
          const KegelPhase(
            label: 'EINATMEN & WEICH',
            instruction: 'Tief in den Bauch atmen. Damm und Po bewusst weich werden lassen.',
            durationSeconds: 5,
            color: AppTheme.rose,
            circleScaleTarget: 1.35,
            cue: 'welle',
          ),
          KegelPhase(
            label: 'LANG AUSATMEN',
            instruction: 'Lang und hörbar ausatmen, der Beckenboden bleibt weit. So übst du, bei Erregung locker zu bleiben.',
            durationSeconds: _hold(7),
            color: AppTheme.amber,
            circleScaleTarget: 1.45,
            cue: 'seufzen',
          ),
          const KegelPhase(
            label: 'NACHSPÜREN',
            instruction: 'Ruhig weiteratmen und die Wärme im Becken spüren.',
            durationSeconds: 4,
            color: AppTheme.surfaceLight,
            circleScaleTarget: 1.0,
            cue: 'nachspueren',
          ),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _secondsLeftInPhase = _phases[0].durationSeconds;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _voiceCues = prefs.getBool(_keyVoice) ?? true;
      _totalRounds = prefs.getInt(_keyRounds) ?? 10;
      _level = KegelLevel.values[(prefs.getInt(_keyLevel) ?? 0).clamp(0, KegelLevel.values.length - 1)];
      _secondsLeftInPhase = _phases[0].durationSeconds;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVoice, _voiceCues);
    await prefs.setInt(_keyRounds, _totalRounds);
    await prefs.setInt(_keyLevel, _level.index);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _animController.dispose();
    _cuePlayer.dispose();
    super.dispose();
  }

  /// Victoria für Frauen-Profile, sonst Martin – wie bei den Lektionen.
  String get _voiceName => StorageService.getUserProfile()?.isFemale == true ? 'victoria' : 'martin';

  void _playCue(String? cue) {
    if (!_voiceCues || cue == null) return;
    _cuePlayer.stop();
    _cuePlayer.play(AssetSource('audio/cues/${_voiceName}_$cue.opus')).catchError((_) {});
  }

  void _changeSettings(VoidCallback change) {
    if (_isRunning) _stopTraining();
    setState(() {
      change();
      _currentRound = 1;
      _currentPhaseIndex = 0;
      _secondsLeftInPhase = _phases[0].durationSeconds;
    });
    _saveSettings();
  }

  void _startTraining() {
    final freshStart = _currentRound == 1 && _currentPhaseIndex == 0 &&
        _secondsLeftInPhase == _phases[0].durationSeconds;
    setState(() => _isRunning = true);
    HapticFeedback.mediumImpact();
    if (freshStart) _playCue(_phases[0].cue);
    _animController.duration = Duration(seconds: _phases[_currentPhaseIndex].durationSeconds);
    _animController.repeat(reverse: true);

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeftInPhase > 1) {
          _secondsLeftInPhase--;
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
    } else if (_currentRound < _totalRounds) {
      _currentRound++;
      _currentPhaseIndex = 0;
    } else {
      _stopTraining();
      _playCue('fertig');
      StorageService.recordActivityToday();
      _showCompletedDialog();
      return;
    }
    _secondsLeftInPhase = phases[_currentPhaseIndex].durationSeconds;
    _playCue(phases[_currentPhaseIndex].cue);
    _animController.duration = Duration(seconds: phases[_currentPhaseIndex].durationSeconds);
    _animController.reset();
    _animController.repeat(reverse: true);
  }

  void _pauseTraining() {
    _ticker?.cancel();
    _animController.stop();
    setState(() => _isRunning = false);
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
        title: const Text('Geschafft'),
        content: Text(
          'Du hast $_totalRounds Runden geübt. Regelmäßig ein paar Minuten bringen mehr als selten lange – '
          'bis morgen!',
          style: const TextStyle(color: AppTheme.textSecondary, height: 1.4),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fertig')),
        ],
      ),
    );
  }

  int get _totalSeconds => _phases.fold(0, (sum, p) => sum + p.durationSeconds) * _totalRounds;

  @override
  Widget build(BuildContext context) {
    final phases = _phases;
    final currentPhase = phases[_currentPhaseIndex];
    final minutes = (_totalSeconds / 60).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Übungsart
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
                    Expanded(child: _buildPresetButton('Loslassen', 'weit werden', KegelPreset.loslassen)),
                    Expanded(child: _buildPresetButton('Kräftigen', 'halten & lösen', KegelPreset.kraeftigen)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildPresetButton('Schnelle Impulse', 'kurz an, kurz los', KegelPreset.impulse)),
                    Expanded(child: _buildPresetButton('Wellen', 'weich bei Erregung', KegelPreset.wellen)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Einstellungen
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 64, child: Text('Runden', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5))),
                    ..._roundOptions.map((r) => _buildOptionChip('$r', _totalRounds == r, () => _changeSettings(() => _totalRounds = r))),
                    const Spacer(),
                    Text('≈ $minutes Min.', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
                if (_selectedPreset != KegelPreset.impulse) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 64, child: Text('Stufe', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5))),
                      _buildOptionChip('leicht', _level == KegelLevel.leicht, () => _changeSettings(() => _level = KegelLevel.leicht)),
                      _buildOptionChip('mittel', _level == KegelLevel.mittel, () => _changeSettings(() => _level = KegelLevel.mittel)),
                      _buildOptionChip('stark', _level == KegelLevel.fortgeschritten,
                          () => _changeSettings(() => _level = KegelLevel.fortgeschritten)),
                    ],
                  ),
                ],
                Row(
                  children: [
                    const SizedBox(width: 64, child: Text('Ansage', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5))),
                    Expanded(
                      child: Text(
                        _voiceCues ? 'Stimme führt dich durch' : 'nur Vibration',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ),
                    Switch(
                      value: _voiceCues,
                      activeThumbColor: AppTheme.sageGreen,
                      onChanged: (v) {
                        setState(() => _voiceCues = v);
                        _saveSettings();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Runde und Phase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge('Runde $_currentRound von $_totalRounds', AppTheme.textPrimary, AppTheme.border),
              _buildBadge('Phase ${_currentPhaseIndex + 1}/${phases.length}', currentPhase.color,
                  currentPhase.color.withValues(alpha: 0.4)),
            ],
          ),

          const SizedBox(height: 28),

          // Atmender Kreis
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final pulse = _isRunning ? (_animController.value * 0.15) : 0.0;
                return Transform.scale(
                  scale: currentPhase.circleScaleTarget + pulse,
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        currentPhase.color.withValues(alpha: 0.28),
                        currentPhase.color.withValues(alpha: 0.08),
                        Colors.transparent,
                      ]),
                      border: Border.all(color: currentPhase.color, width: 3.5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_secondsLeftInPhase',
                            style: const TextStyle(
                                fontSize: 54, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, height: 1.0),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              currentPhase.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w800, color: currentPhase.color, letterSpacing: 1.0),
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

          // Anweisung
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              currentPhase.instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.45, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 24),

          // Steuerung
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _stopTraining,
                style: OutlinedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(16)),
                child: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: 150,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTraining : _startTraining,
                  icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 26),
                  label: Text(_isRunning ? 'Pause' : 'Start',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? AppTheme.amber : AppTheme.sageGreen,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              OutlinedButton(
                onPressed: _isRunning ? () => setState(_nextPhase) : null,
                style: OutlinedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(16)),
                child: const Icon(Icons.skip_next_rounded, color: AppTheme.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Anleitung
          InkWell(
            onTap: () => KegelGuideSheet.show(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.35)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: AppTheme.sageGreen, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anleitung & Übungsplan',
                            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 13.5)),
                        SizedBox(height: 2),
                        Text('Muskel finden, welche Übung wofür, typische Fehler, Plan für 6 Wochen',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 11.5, height: 1.3)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  Widget _buildOptionChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppTheme.sageGreen.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? AppTheme.sageGreen : AppTheme.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, String subtitle, KegelPreset preset) {
    final isSelected = _selectedPreset == preset;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _changeSettings(() => _selectedPreset = preset),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.5)) : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: isSelected ? AppTheme.sageGreen : AppTheme.textMuted, fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
