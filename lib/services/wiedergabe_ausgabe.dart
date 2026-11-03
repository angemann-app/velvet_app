import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/wiedergabe_plan.dart';
import 'sprachausgabe.dart';
import 'tts_service.dart';
import 'wiedergabe_lauf.dart';

Future<AbschnittAusgabe> nativeAbschnittAusgabe(
    WiedergabeAbschnitt s, String sprache) async {
  final Source? quelle = s.art == AbschnittArt.klang
      ? AssetSource('audio/paar/klangschale.opus')
      : Sprachausgabe.quelle(s.pfad!, sprache: sprache);
  if (quelle != null) return _Aufnahme(quelle);
  if (s.text.trim().isEmpty) throw StateError('Aufnahme und Lesetext fehlen');
  return _Vorlesen(s.text, s.pfad!, sprache);
}

class _Aufnahme implements AbschnittAusgabe {
  final AudioPlayer _player = AudioPlayer();
  final Source quelle;
  _Aufnahme(this.quelle);
  @override
  bool get aufnahme => true;
  @override
  Stream<void> get ende => _player.onPlayerComplete;
  @override
  Stream<Duration> get positionen => _player.onPositionChanged;
  @override
  Stream<Duration> get laengen => _player.onDurationChanged;
  @override
  Future<void> starten(Duration position, {bool pausiert = false}) async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setAudioContext(AudioContext(
        android:
            const AudioContextAndroid(audioFocus: AndroidAudioFocus.none)));
    await _player.setSource(quelle);
    if (position > Duration.zero) await _player.seek(position);
    if (!pausiert) await _player.resume();
  }

  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> weiter() => _player.resume();
  @override
  Future<void> suchen(Duration position) => _player.seek(position);
  @override
  Future<void> laut(double wert) => _player.setVolume(wert);
  @override
  Future<void> schliessen() async {
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _player.dispose();
    } catch (_) {}
  }
}

class _Vorlesen implements AbschnittAusgabe {
  final String text, id, sprache;
  final TtsService _tts = TtsService();
  final _ende = StreamController<void>.broadcast();
  bool _begonnen = false;
  _Vorlesen(this.text, this.id, this.sprache) {
    _tts.stateNotifier.addListener(_zustand);
  }
  void _zustand() {
    if (_begonnen && _tts.stateNotifier.value == TtsPlaybackState.stopped)
      _ende.add(null);
  }

  @override
  bool get aufnahme => false;
  @override
  Stream<void> get ende => _ende.stream;
  @override
  Stream<Duration> get positionen => const Stream.empty();
  @override
  Stream<Duration> get laengen => const Stream.empty();
  @override
  Future<void> starten(Duration position, {bool pausiert = false}) async {
    if (!pausiert) await weiter();
  }

  @override
  Future<void> pause() async {
    _begonnen = false;
    await _tts.pause();
  }

  @override
  Future<void> weiter() async {
    _begonnen = false;
    await _tts.stop();
    await _tts.speak(text, contextId: id, sprache: sprache);
    if (_tts.stateNotifier.value != TtsPlaybackState.playing)
      throw StateError('Geräte-Stimme nicht gestartet');
    _begonnen = true;
  }

  @override
  Future<void> suchen(Duration position) async {}
  @override
  Future<void> laut(double wert) async {}
  @override
  Future<void> schliessen() async {
    _begonnen = false;
    _tts.stateNotifier.removeListener(_zustand);
    await _tts.stop();
    await _ende.close();
  }
}
