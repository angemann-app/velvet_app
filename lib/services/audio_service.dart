import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'sprachausgabe.dart';
import 'tts_service.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  final TtsService _ttsFallback = TtsService();

  final ValueNotifier<PlayerState> stateNotifier =
      ValueNotifier<PlayerState>(PlayerState.stopped);
  final ValueNotifier<String?> currentLessonIdNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<Duration> positionNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> durationNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<bool> isUsingTtsFallbackNotifier =
      ValueNotifier<bool>(false);

  bool _initialized = false;
  StreamSubscription? _stateSub;
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;

  void _init() {
    if (_initialized) return;

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      stateNotifier.value = state;
      if (state == PlayerState.completed) {
        positionNotifier.value = Duration.zero;
      }
    });

    _posSub = _player.onPositionChanged.listen((pos) {
      positionNotifier.value = pos;
    });

    _durSub = _player.onDurationChanged.listen((dur) {
      if (dur != Duration.zero) {
        durationNotifier.value = dur;
      }
    });

    // Liest die Geräte-Stimme vor (Aufnahme fehlt), spiegelt sie ihren Zustand in
    // stateNotifier, damit der Player Pause und Weiter anzeigt.
    _ttsFallback.stateNotifier.addListener(() {
      if (!isUsingTtsFallbackNotifier.value) return;
      stateNotifier.value = switch (_ttsFallback.stateNotifier.value) {
        TtsPlaybackState.playing => PlayerState.playing,
        TtsPlaybackState.paused => PlayerState.paused,
        TtsPlaybackState.stopped => PlayerState.stopped,
      };
    });

    _initialized = true;
  }

  /// Text für die Geräte-Stimme, um nach einer Pause weiterzulesen.
  String? _fallbackText;

  bool isCurrentLesson(String lessonId) {
    return currentLessonIdNotifier.value == lessonId;
  }

  bool isPlaying(String lessonId) {
    return isCurrentLesson(lessonId) &&
        stateNotifier.value == PlayerState.playing;
  }

  bool isPaused(String lessonId) {
    return isCurrentLesson(lessonId) &&
        stateNotifier.value == PlayerState.paused;
  }

  Future<void> playLesson(String lessonId, {String? fallbackText}) async {
    _init();

    // If currently paused on this lesson, resume
    if (isPaused(lessonId)) {
      if (isUsingTtsFallbackNotifier.value && fallbackText != null) {
        await _ttsFallback.speak(fallbackText, contextId: lessonId);
      } else {
        await _player.resume();
      }
      return;
    }

    // If already playing this lesson, do nothing
    if (isPlaying(lessonId)) {
      return;
    }

    // Stop current
    await stop();

    currentLessonIdNotifier.value = lessonId;
    isUsingTtsFallbackNotifier.value = false;
    positionNotifier.value = Duration.zero;
    durationNotifier.value = Duration.zero;

    try {
      // Deutsch aus den Assets, Englisch aus dem Audiopaket; fehlt die Aufnahme, liest die Geräte-Stimme.
      final source = Sprachausgabe.quelle('audio/$lessonId.opus');
      if (source == null) throw StateError('keine Aufnahme in dieser Sprache');
      await _player.play(source);
      debugPrint('AudioService: Playing neural asset audio/$lessonId.opus');
    } catch (e) {
      debugPrint('AudioService: Asset playback failed ($e), falling back to TTS');
      isUsingTtsFallbackNotifier.value = true;
      _fallbackText = fallbackText;
      if (fallbackText != null && fallbackText.isNotEmpty) {
        await _ttsFallback.speak(fallbackText, contextId: lessonId);
      }
    }
  }

  Future<void> pause() async {
    if (isUsingTtsFallbackNotifier.value) {
      await _ttsFallback.pause();
    } else {
      await _player.pause();
    }
  }

  Future<void> resume() async {
    final currentId = currentLessonIdNotifier.value;
    if (currentId != null) {
      if (isUsingTtsFallbackNotifier.value) {
        final text = _fallbackText;
        if (text != null && text.isNotEmpty) await _ttsFallback.speak(text, contextId: currentId);
      } else {
        await _player.resume();
      }
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _ttsFallback.stop();
    } catch (_) {}

    stateNotifier.value = PlayerState.stopped;
    positionNotifier.value = Duration.zero;
  }

  Future<void> seek(Duration position) async {
    if (!isUsingTtsFallbackNotifier.value) {
      await _player.seek(position);
    }
  }

  Future<void> seekRelative(int seconds) async {
    if (isUsingTtsFallbackNotifier.value) return;

    final currentPos = positionNotifier.value;
    final totalDur = durationNotifier.value;

    int newSec = currentPos.inSeconds + seconds;
    if (newSec < 0) newSec = 0;
    if (totalDur != Duration.zero && newSec > totalDur.inSeconds) {
      newSec = totalDur.inSeconds;
    }

    await seek(Duration(seconds: newSec));
  }

  void dispose() {
    _stateSub?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();
    _player.dispose();
  }
}
