import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import 'sprache.dart';
import 'tts_service.dart';

/// Gesprochene Texte in der aktuellen Sprache.
///
/// Deutsch: die Aufnahmen aus der App (assets/audio/…).
/// Englisch: die Aufnahmen aus dem nachgeladenen englischen Audiopaket ([AudioPaket]); solange es
/// fehlt oder eine Datei darin fehlt, liest die Geräte-Stimme den Text vor.
class Sprachausgabe {
  static final TtsService _tts = TtsService();

  /// Aufnahme für [pfad] (z. B. 'audio/paar/victoria_ankommen_1.opus') oder null, wenn es keine gibt.
  static Source? quelle(String pfad) {
    if (!Sprache.englisch) return AssetSource(pfad);
    final datei = AudioPaket.datei(pfad);
    return datei == null ? null : DeviceFileSource(datei);
  }

  /// Spielt die Aufnahme über [player] oder liest [text] mit der Geräte-Stimme vor.
  static Future<void> sprich(AudioPlayer player, String pfad, String text) async {
    final q = quelle(pfad);
    if (q != null) {
      await player.play(q).catchError((_) {});
    } else {
      await _tts.speak(text, contextId: pfad);
    }
  }

  static Future<void> pause(AudioPlayer player) async {
    await player.pause().catchError((_) {});
    await _tts.stop();
  }

  static Future<void> stopp(AudioPlayer player) async {
    await player.stop().catchError((_) {});
    await _tts.stop();
  }

  /// Nur das Vorlesen beenden (z. B. beim Schließen eines Bildschirms).
  static Future<void> vorlesenBeenden() => _tts.stop();
}

/// Das englische Audiopaket: nachgeladen in den privaten App-Speicher (audio_en/…), gleiche Struktur
/// wie assets/ (audio/<lektion>.opus, audio/paar/…, audio/selbst/…, audio/cues/…).
class AudioPaket {
  static String? _ordner;

  /// Ordner bestimmen (einmal beim Start); ohne ihn gilt das Paket als nicht vorhanden.
  static Future<void> init() async {
    try {
      _ordner = '${(await getApplicationSupportDirectory()).path}/audio_en';
    } catch (_) {
      _ordner = null;
    }
  }

  static String? get ordner => _ordner;

  static bool get vorhanden => _ordner != null && File('$_ordner/audio/version.txt').existsSync();

  /// Vollständiger Pfad einer Datei aus dem Paket, oder null.
  static String? datei(String pfad) {
    final o = _ordner;
    if (o == null) return null;
    final f = File('$o/$pfad');
    return f.existsSync() ? f.path : null;
  }
}
