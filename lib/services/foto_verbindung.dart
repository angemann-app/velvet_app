import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Eine direkte Verbindung von Handy zu Handy für ein Foto (lib/services/foto_kanal.dart).
/// Der Verbindungsaufbau (Angebot, Antwort, Wegbeschreibungen) läuft über verschlüsselte
/// Nostr-Signale; die Daten selbst gehen direkt und zusätzlich DTLS-verschlüsselt hinüber.
abstract class FotoVerbindung {
  /// Absender: Angebot (SDP) erstellen.
  Future<String> angebotErstellen();

  /// Empfänger: auf ein Angebot antworten.
  Future<String> antwortErstellen(String angebot);

  /// Absender: die Antwort des Empfängers setzen.
  Future<void> antwortSetzen(String antwort);

  /// Wegbeschreibung (ICE-Kandidat) der Gegenseite.
  Future<void> kandidatSetzen(Map<String, dynamic> kandidat);

  /// Absender: erfüllt, sobald der Datenkanal offen ist.
  Future<void> get offen;

  Future<void> senden(Uint8List teil);

  /// Absender: alle Teile sind raus.
  Future<void> ende();

  Future<void> schliessen();
}

typedef FotoVerbindungFabrik = FotoVerbindung Function({
  required void Function(Map<String, dynamic> kandidat) kandidat,
  void Function(Uint8List teil)? daten,
  void Function()? beendet,
});

/// Die echte Verbindung über WebRTC.
FotoVerbindung webRtcVerbindung({
  required void Function(Map<String, dynamic> kandidat) kandidat,
  void Function(Uint8List teil)? daten,
  void Function()? beendet,
}) =>
    _WebRtcVerbindung(kandidat, daten, beendet);

class _WebRtcVerbindung implements FotoVerbindung {
  _WebRtcVerbindung(this._kandidat, this._daten, this._beendet);

  final void Function(Map<String, dynamic>) _kandidat;
  final void Function(Uint8List)? _daten;
  final void Function()? _beendet;

  // Ein öffentlicher STUN-Server hilft nur, den Weg durch Router zu finden; er sieht keine Daten.
  static const _konfiguration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ],
  };

  RTCPeerConnection? _pc;
  RTCDataChannel? _kanal;
  final _offen = Completer<void>();
  final List<RTCIceCandidate> _wartend = [];
  bool _gegenseiteBekannt = false;

  Future<RTCPeerConnection> _verbindung() async {
    final pc = await createPeerConnection(_konfiguration);
    pc.onIceCandidate = (c) {
      if (c.candidate != null) _kandidat({'c': c.candidate, 'mid': c.sdpMid, 'i': c.sdpMLineIndex});
    };
    return pc;
  }

  void _kanalVorbereiten(RTCDataChannel kanal) {
    _kanal = kanal;
    kanal.onDataChannelState = (zustand) {
      if (zustand == RTCDataChannelState.RTCDataChannelOpen && !_offen.isCompleted) _offen.complete();
    };
    kanal.onMessage = (nachricht) {
      if (nachricht.isBinary) {
        _daten?.call(nachricht.binary);
      } else if (nachricht.text == 'ende') {
        _beendet?.call();
      }
    };
  }

  Future<void> _wartendeSetzen() async {
    _gegenseiteBekannt = true;
    for (final k in _wartend) {
      await _pc?.addCandidate(k);
    }
    _wartend.clear();
  }

  @override
  Future<String> angebotErstellen() async {
    _pc = await _verbindung();
    _kanalVorbereiten(await _pc!.createDataChannel('foto', RTCDataChannelInit()..ordered = true));
    final angebot = await _pc!.createOffer();
    await _pc!.setLocalDescription(angebot);
    return angebot.sdp!;
  }

  @override
  Future<String> antwortErstellen(String angebot) async {
    _pc = await _verbindung();
    _pc!.onDataChannel = _kanalVorbereiten;
    await _pc!.setRemoteDescription(RTCSessionDescription(angebot, 'offer'));
    await _wartendeSetzen();
    final antwort = await _pc!.createAnswer();
    await _pc!.setLocalDescription(antwort);
    return antwort.sdp!;
  }

  @override
  Future<void> antwortSetzen(String antwort) async {
    await _pc?.setRemoteDescription(RTCSessionDescription(antwort, 'answer'));
    await _wartendeSetzen();
  }

  @override
  Future<void> kandidatSetzen(Map<String, dynamic> k) async {
    final kandidat = RTCIceCandidate(k['c'] as String?, k['mid'] as String?, k['i'] as int?);
    if (_pc == null || !_gegenseiteBekannt) {
      _wartend.add(kandidat);
    } else {
      await _pc!.addCandidate(kandidat);
    }
  }

  @override
  Future<void> get offen => _offen.future;

  @override
  Future<void> senden(Uint8List teil) async {
    // Nicht mehr als etwa 1 MB im Puffer, sonst bricht der Kanal bei großen Fotos ab.
    while ((_kanal?.bufferedAmount ?? 0) > 1024 * 1024) {
      await Future.delayed(const Duration(milliseconds: 20));
    }
    await _kanal!.send(RTCDataChannelMessage.fromBinary(teil));
  }

  @override
  Future<void> ende() async => _kanal!.send(RTCDataChannelMessage('ende'));

  @override
  Future<void> schliessen() async {
    await _kanal?.close();
    await _pc?.close();
  }
}
