import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'sprache.dart';

enum TtsPlaybackState { stopped, playing, paused }

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  final ValueNotifier<TtsPlaybackState> stateNotifier =
      ValueNotifier<TtsPlaybackState>(TtsPlaybackState.stopped);
  final ValueNotifier<String?> currentSpeakingIdNotifier =
      ValueNotifier<String?>(null);

  bool _initialized = false;
  String? _sprache;

  Future<void> init() async {
    // Sprache der Geräte-Stimme folgt der App-Sprache, auch nach einem Wechsel.
    if (_initialized && _sprache == Sprache.code) return;
    if (_initialized) {
      _sprache = Sprache.code;
      await _flutterTts.setLanguage(Sprache.englisch ? 'en-US' : 'de-DE').timeout(const Duration(seconds: 2)).catchError((_) => null);
      return;
    }
    _sprache = Sprache.code;

    try {
      await _flutterTts
          .setLanguage(Sprache.englisch ? 'en-US' : 'de-DE')
          .timeout(const Duration(seconds: 2));
      await _flutterTts
          .setSpeechRate(0.45)
          .timeout(const Duration(seconds: 1));
      await _flutterTts
          .setVolume(1.0)
          .timeout(const Duration(seconds: 1));
      await _flutterTts
          .setPitch(0.95)
          .timeout(const Duration(seconds: 1));

      _flutterTts.setStartHandler(() {
        stateNotifier.value = TtsPlaybackState.playing;
      });

      _flutterTts.setCompletionHandler(() {
        stateNotifier.value = TtsPlaybackState.stopped;
        currentSpeakingIdNotifier.value = null;
      });

      _flutterTts.setPauseHandler(() {
        stateNotifier.value = TtsPlaybackState.paused;
      });

      _flutterTts.setContinueHandler(() {
        stateNotifier.value = TtsPlaybackState.playing;
      });

      _flutterTts.setErrorHandler((msg) {
        stateNotifier.value = TtsPlaybackState.stopped;
        currentSpeakingIdNotifier.value = null;
      });

      _initialized = true;
    } catch (e) {
      debugPrint('TTS initialization warning: $e');
    }
  }

  Future<void> speak(String text, {required String contextId}) async {
    await init();
    try {
      if (stateNotifier.value == TtsPlaybackState.paused &&
          currentSpeakingIdNotifier.value == contextId) {
        // Resume
        await _flutterTts.speak(text);
        stateNotifier.value = TtsPlaybackState.playing;
      } else {
        await stop();
        currentSpeakingIdNotifier.value = contextId;
        stateNotifier.value = TtsPlaybackState.playing;
        await _flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint('Error speaking text: $e');
      stateNotifier.value = TtsPlaybackState.stopped;
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      stateNotifier.value = TtsPlaybackState.paused;
    } catch (e) {
      debugPrint('Error pausing TTS: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      stateNotifier.value = TtsPlaybackState.stopped;
      currentSpeakingIdNotifier.value = null;
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
