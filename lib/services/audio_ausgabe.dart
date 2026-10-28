// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

/// Erkennt das aktuelle Audio-Ausgabegerät (eingebauter Lautsprecher ja/nein)
/// und meldet, wenn Kopfhörer getrennt werden (Kabel abgezogen, Bluetooth beendet).
///
/// docs/konzepte/lautsprecher.md:
/// - Kabel-, USB- und Bluetooth-Geräte gelten als "nicht der Lautsprecher".
/// - Pause beim Abziehen: Android-Signal "Audio becoming noisy" bzw. Gerätewechsel.
class AudioAusgabe {
  static AudioAusgabe? _instanz;
  static AudioAusgabe get instanz => _instanz ??= AudioAusgabe();

  @visibleForTesting
  static set instanz(AudioAusgabe? wert) => _instanz = wert;

  AudioSession? _session;
  StreamSubscription<void>? _noisySub;
  StreamSubscription<AudioDevicesChangedEvent>? _devicesSub;
  final StreamController<void> _kopfhoererGetrenntController =
      StreamController<void>.broadcast();

  /// Strom, der feuert, wenn während der Wiedergabe Kopfhörer getrennt werden.
  Stream<void> get onKopfhoererGetrennt => _kopfhoererGetrenntController.stream;

  /// Test-Hook: Überschreibt das Ergebnis von [istLautsprecher].
  @visibleForTesting
  bool? testIstLautsprecher;

  /// Ausgabetypen, die als "nicht der Lautsprecher" gelten (Kopfhörer, Headsets, Bluetooth, USB).
  static const Set<AudioDeviceType> _nichtLautsprecherTypen = {
    AudioDeviceType.wiredHeadset,
    AudioDeviceType.wiredHeadphones,
    AudioDeviceType.bluetoothA2dp,
    AudioDeviceType.bluetoothSco,
    AudioDeviceType.bluetoothLe,
    AudioDeviceType.usbAudio,
    AudioDeviceType.lineAnalog,
    AudioDeviceType.lineDigital,
    AudioDeviceType.hearingAid,
    AudioDeviceType.airPlay,
    AudioDeviceType.carAudio,
    AudioDeviceType.hdmi,
    AudioDeviceType.hdmiArc,
  };

  /// Initialisiert das Lauschen auf getrennte Kopfhörer.
  Future<void> initialisieren() async {
    if (_session != null) return;
    try {
      final session = await AudioSession.instance;
      _session = session;
      _noisySub = session.becomingNoisyEventStream.listen((_) {
        _kopfhoererGetrenntController.add(null);
      });
      _devicesSub = session.devicesChangedEventStream.listen((event) {
        final entferntNichtLautsprecher = event.devicesRemoved.any(
          (d) => d.isOutput && _nichtLautsprecherTypen.contains(d.type),
        );
        if (entferntNichtLautsprecher) {
          _kopfhoererGetrenntController.add(null);
        }
      });
    } catch (e) {
      debugPrint('AudioAusgabe.initialisieren: $e');
    }
  }

  /// Prüft, ob die Audio-Wiedergabe aktuell über den eingebauten Lautsprecher liefe.
  /// Gibt false zurück, wenn Kopfhörer, Headset, USB- oder Bluetooth-Geräte aktiv sind.
  Future<bool> istLautsprecher() async {
    if (testIstLautsprecher != null) return testIstLautsprecher!;
    if (kIsWeb) return false;
    if (Platform.environment.containsKey('FLUTTER_TEST')) return false;
    try {
      final session = _session ?? await AudioSession.instance;
      _session = session;
      final devices = await session.getDevices();

      // Wenn ein Kopfhörer-, Bluetooth- oder USB-Ausgabegerät verbunden ist: kein Lautsprecher
      final hatNichtLautsprecher = devices.any(
        (d) => d.isOutput && _nichtLautsprecherTypen.contains(d.type),
      );
      if (hatNichtLautsprecher) return false;

      // Eingebauter Lautsprecher aktiv
      final hatLautsprecher = devices.any(
        (d) =>
            d.isOutput &&
            (d.type == AudioDeviceType.builtInSpeaker ||
                d.type == AudioDeviceType.builtInSpeakerSafe),
      );
      if (hatLautsprecher) return true;

      // Standardannahme auf Mobilgeräten ohne Kopfhörer
      return true;
    } catch (e) {
      debugPrint('AudioAusgabe.istLautsprecher: $e');
      return false;
    }
  }

  /// Test-Hook: Simuliert das Trennen eines Kopfhörers.
  @visibleForTesting
  void kopfhoererGetrenntMelden() {
    _kopfhoererGetrenntController.add(null);
  }

  void dispose() {
    _noisySub?.cancel();
    _devicesSub?.cancel();
    _kopfhoererGetrenntController.close();
  }
}
