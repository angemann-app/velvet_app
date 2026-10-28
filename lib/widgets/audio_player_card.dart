import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'aussprache_melden.dart';
import 'lautsprecher_frage.dart';
import '../l10n/t.dart';

class AudioPlayerCard extends StatefulWidget {
  final String textToRead;
  final String contextId;
  final int durationMin;
  final bool isAudioExercise;

  /// Wenn gesetzt, steht unter dem Player ein Link „Wort falsch ausgesprochen?“ mit diesem Ort.
  final String? meldeOrt;

  const AudioPlayerCard({
    super.key,
    required this.textToRead,
    required this.contextId,
    required this.durationMin,
    required this.isAudioExercise,
    this.meldeOrt,
  });

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  final AudioService _audioService = AudioService();
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _audioService.stateNotifier.addListener(_onAudioUpdate);
    _audioService.currentLessonIdNotifier.addListener(_onAudioUpdate);
    _audioService.positionNotifier.addListener(_onAudioUpdate);
    _audioService.durationNotifier.addListener(_onAudioUpdate);
    _audioService.isUsingTtsFallbackNotifier.addListener(_onAudioUpdate);
  }

  @override
  void dispose() {
    _audioService.stateNotifier.removeListener(_onAudioUpdate);
    _audioService.currentLessonIdNotifier.removeListener(_onAudioUpdate);
    _audioService.positionNotifier.removeListener(_onAudioUpdate);
    _audioService.durationNotifier.removeListener(_onAudioUpdate);
    _audioService.isUsingTtsFallbackNotifier.removeListener(_onAudioUpdate);
    super.dispose();
  }

  void _onAudioUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = _audioService.isCurrentLesson(widget.contextId);
    final isPlaying = isCurrent && _audioService.stateNotifier.value == PlayerState.playing;
    final isPaused = isCurrent && _audioService.stateNotifier.value == PlayerState.paused;
    final isUsingFallback = isCurrent && _audioService.isUsingTtsFallbackNotifier.value;

    final Duration totalDur = (isCurrent && _audioService.durationNotifier.value > Duration.zero)
        ? _audioService.durationNotifier.value
        : Duration(minutes: widget.durationMin > 0 ? widget.durationMin : 3);

    final Duration currentPos = isCurrent
        ? _audioService.positionNotifier.value
        : Duration.zero;

    final double totalMs = totalDur.inMilliseconds > 0 ? totalDur.inMilliseconds.toDouble() : 1.0;
    final double posMs = (_dragValue ?? currentPos.inMilliseconds.toDouble()).clamp(0.0, totalMs);

    final accentColor = widget.isAudioExercise ? AppTheme.amber : AppTheme.sageGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying
              ? accentColor.withValues(alpha: 0.7)
              : (isPaused ? accentColor.withValues(alpha: 0.3) : AppTheme.border),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Studio Neural Audio Badge & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? accentColor.withValues(alpha: 0.2)
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPlaying
                        ? accentColor.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPlaying ? Icons.graphic_eq_rounded : Icons.headphones_rounded,
                      color: isPlaying ? accentColor : AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isUsingFallback
                          ? t.audioPlayerCardDeviceVoice
                          : (widget.isAudioExercise ? t.audioPlayerCardGuidedExercise : t.audioPlayerCardListen),
                      style: TextStyle(
                        color: isPlaying ? accentColor : AppTheme.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              // Time Display (01:24 / 04:15)
              Text(
                '${_formatDuration(currentPos)} / ${_formatDuration(totalDur)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Subtitle description
          Text(
            isPlaying
                ? (widget.isAudioExercise
                    ? t.audioPlayerCardJustFollowTheVoice
                    : t.audioPlayerCardReadingAloud)
                : (isPaused
                    ? t.audioPlayerCardPausedTapToResume
                    : (widget.isAudioExercise
                        ? t.audioPlayerCardCloseYourEyesAndListen
                        : t.audioPlayerCardListenToTheLessonApprox(widget.durationMin))),
            style: TextStyle(
              color: isPlaying ? AppTheme.textPrimary : AppTheme.textMuted,
              fontSize: 13,
              fontWeight: isPlaying ? FontWeight.w500 : FontWeight.w400,
            ),
          ),

          const SizedBox(height: 10),

          // Slider / Progress bar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: accentColor,
              inactiveTrackColor: AppTheme.surfaceLight,
              thumbColor: accentColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.5),
              overlayColor: accentColor.withValues(alpha: 0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              min: 0.0,
              max: totalMs,
              value: posMs,
              onChanged: isCurrent
                  ? (val) {
                      setState(() {
                        _dragValue = val;
                      });
                    }
                  : null,
              onChangeEnd: isCurrent
                  ? (val) {
                      _audioService.seek(Duration(milliseconds: val.toInt()));
                      setState(() {
                        _dragValue = null;
                      });
                    }
                  : null,
            ),
          ),

          // Controls Row: -10s, Play/Pause, +10s, Stop
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10 Seconds
              IconButton(
                onPressed: isCurrent
                    ? () => _audioService.seekRelative(-10)
                    : null,
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 30,
                color: isCurrent ? AppTheme.textPrimary : AppTheme.textMuted.withValues(alpha: 0.4),
                tooltip: t.audioPlayerCardBackS,
              ),

              const SizedBox(width: 20),

              // Central Play / Pause Button
              GestureDetector(
                onTap: () async {
                  if (isPlaying) {
                    _audioService.pause();
                  } else if (isPaused) {
                    final darf = await frageVorLautsprecher(context);
                    if (!darf) return;
                    _audioService.resume();
                  } else {
                    final darf = await frageVorLautsprecher(context);
                    if (!darf) return;
                    _audioService.playLesson(
                      widget.contextId,
                      fallbackText: widget.textToRead,
                    );
                  }
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accentColor,
                        accentColor.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 34,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Forward 10 Seconds
              IconButton(
                onPressed: isCurrent
                    ? () => _audioService.seekRelative(10)
                    : null,
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 30,
                color: isCurrent ? AppTheme.textPrimary : AppTheme.textMuted.withValues(alpha: 0.4),
                tooltip: t.audioPlayerCardForwardS,
              ),

              if (isCurrent) ...[
                const SizedBox(width: 14),
                // Stop / Reset Button
                IconButton(
                  onPressed: () => _audioService.stop(),
                  icon: const Icon(Icons.stop_rounded),
                  iconSize: 22,
                  color: AppTheme.textSecondary,
                  tooltip: t.audioPlayerCardStopReset,
                ),
              ],
            ],
          ),
          // Bei der Geräte-Stimme (Fallback) hilft eine Meldung nichts.
          if (widget.meldeOrt != null && !isUsingFallback)
            AusspracheMeldenButton(
              wo: widget.meldeOrt!,
              position: () => _audioService.isCurrentLesson(widget.contextId)
                  ? _audioService.positionNotifier.value
                  : null,
            ),
        ],
      ),
    );
  }
}
