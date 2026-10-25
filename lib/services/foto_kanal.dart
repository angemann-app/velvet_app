import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'foto_verbindung.dart';
import 'nostr_service.dart';

enum FotoErgebnis { fehler, wartet, unterwegs }

/// Was der Foto-Kanal vom Paar-Kanal braucht. Im Betrieb NostrService, in Tests ein Ersatz.
abstract class FotoBote {
  Stream<Map<String, dynamic>> get signale;
  Future<bool> sendSignal(Map<String, Object?> daten);
  Future<bool> sendFotoAngebot(Map<String, Object> angaben, {bool verschwindet});
  Future<Map<String, dynamic>?> fotoAngebot(String id);
  Future<void> fotoVergessen(String id);

  /// ids der Fotos, die das Gegenüber geschickt hat (aus dem Nachrichtenverlauf).
  List<String> get empfangeneFotoIds;
}

class _NostrBote implements FotoBote {
  _NostrBote(this._n);
  final NostrService _n;

  @override
  Stream<Map<String, dynamic>> get signale => _n.signale;
  @override
  Future<bool> sendSignal(Map<String, Object?> daten) => _n.sendSignal(daten);
  @override
  Future<bool> sendFotoAngebot(Map<String, Object> angaben, {bool verschwindet = false}) =>
      _n.sendFotoAngebot(angaben, verschwindet: verschwindet);
  @override
  Future<Map<String, dynamic>?> fotoAngebot(String id) => _n.fotoAngebot(id);
  @override
  Future<void> fotoVergessen(String id) => _n.fotoVergessen(id);
  @override
  List<String> get empfangeneFotoIds =>
      [for (final m in _n.messagesNotifier.value) if (!m.isMe && m.fotoId != null) m.fotoId!];
}

/// Fotos im Paar-Kanal: verschlüsselt direkt von Handy zu Handy, ohne Server dazwischen.
///
/// 1. Absender verschlüsselt das Foto (AES-256-GCM) und schickt den Schlüssel in einer normalen,
///    Ende-zu-Ende-verschlüsselten Nostr-Nachricht. Das verschlüsselte Foto bleibt bei ihm liegen.
/// 2. Ist das Gegenüber erreichbar (unsichtbares „bist du da?“ über flüchtige Signale), bauen
///    beide über Signale eine WebRTC-Verbindung auf und das Foto geht direkt hinüber.
/// 3. Sonst wartet es verschlüsselt beim Absender, bis beide den Paar-Kanal gleichzeitig offen
///    haben (höchstens [aufbewahrung]).
/// 4. Beim Gegenüber lässt es sich einmal ansehen; danach sind Datei und Schlüssel weg.
class FotoKanal {
  FotoKanal._(this._nostr, this._fabrik, this._ordner, [String praefix = ''])
      : _keyAusgang = '${praefix}velvet_fotos_ausgang',
        _keyStatus = '${praefix}velvet_fotos_status';

  static final FotoKanal instanz = FotoKanal._(_NostrBote(NostrService()), webRtcVerbindung, _standardOrdner);

  /// Für Tests: zwei Kanäle in einem Prozess brauchen eigene Schlüssel in den Einstellungen.
  @visibleForTesting
  factory FotoKanal.fuerTest(FotoBote bote, FotoVerbindungFabrik fabrik, Future<String> Function() ordner,
          String praefix) =>
      FotoKanal._(bote, fabrik, ordner, praefix);

  final FotoBote _nostr;
  final FotoVerbindungFabrik _fabrik;
  final Future<String> Function() _ordner;

  static const aufbewahrung = Duration(days: 7);
  final String _keyAusgang; // id -> Zeitpunkt (ms)
  final String _keyStatus; // id -> zugestellt | angesehen | fehler
  static const _blockGroesse = 16 * 1024;

  /// Zustand je Foto für die Anzeige: wartet, laedt, bereit, zugestellt, angesehen, fehler.
  final ValueNotifier<Map<String, String>> status = ValueNotifier({});

  StreamSubscription<Map<String, dynamic>>? _abo;
  final Map<String, FotoVerbindung> _verbindungen = {};
  final Map<String, Completer<void>> _pong = {};

  /// Wegbeschreibungen, die vor der Verbindung ankommen (Signale überholen sich manchmal).
  final Map<String, List<Map<String, dynamic>>> _fruehe = {};

  void _verbindungMerken(String id, FotoVerbindung v) {
    _verbindungen[id] = v;
    for (final k in _fruehe.remove(id) ?? const <Map<String, dynamic>>[]) {
      v.kandidatSetzen(k);
    }
  }

  static Future<String> _standardOrdner() async => '${(await getApplicationSupportDirectory()).path}/fotos';

  Future<File> _datei(String art, String id) async {
    final ordner = Directory(await _ordner());
    if (!ordner.existsSync()) ordner.createSync(recursive: true);
    return File('${ordner.path}/${art}_$id.bin');
  }

  // ---------------------------------------------------------------------------
  // Start und Signale

  /// Beim Start der App: auf Signale hören, Wartendes ausliefern bzw. abholen. Auch erneut
  /// aufrufbar, z. B. wenn eine neue Foto-Nachricht angekommen ist.
  Future<void> start() async {
    _abo ??= _nostr.signale.listen(_signal);
    try {
      await _starten();
    } catch (e) {
      debugPrint('FotoKanal: Start nicht möglich (${e.runtimeType})');
    }
  }

  Future<void> _starten() async {
    await _statusLaden();
    await _aufraeumen();
    // Als Empfänger: dem Gegenüber sagen, welche Fotos hier noch fehlen.
    final fehlend = await _fehlendeFotos();
    if (fehlend.isNotEmpty) await _nostr.sendSignal({'t': 'hallo', 'ids': fehlend});
    // Als Absender: Wartendes ausliefern, falls das Gegenüber gerade da ist.
    final ausgang = await _ausgang();
    if (ausgang.isNotEmpty && await gegenueberDa()) {
      for (final id in ausgang.keys) {
        unawaited(_senden(id));
      }
    }
  }

  void stop() {
    _abo?.cancel();
    _abo = null;
  }

  /// Unsichtbare Anfrage: Ist die App beim Gegenüber gerade offen?
  Future<bool> gegenueberDa({Duration warten = const Duration(seconds: 4)}) async {
    final n = _zufall(8);
    final antwort = Completer<void>();
    _pong[n] = antwort;
    if (!await _nostr.sendSignal({'t': 'da?', 'n': n})) {
      _pong.remove(n);
      return false;
    }
    try {
      await antwort.future.timeout(warten);
      return true;
    } on TimeoutException {
      return false;
    } finally {
      _pong.remove(n);
    }
  }

  Future<void> _signal(Map<String, dynamic> s) async {
    final id = s['id'] is String ? s['id'] as String : null;
    switch (s['t']) {
      case 'da?':
        await _nostr.sendSignal({'t': 'da', 'n': s['n']});
      case 'da':
        _pong[s['n']]?.complete();
      case 'hallo':
        final ausgang = await _ausgang();
        for (final x in (s['ids'] as List? ?? const [])) {
          if (x is String && ausgang.containsKey(x)) unawaited(_senden(x));
        }
      case 'angebot' when id != null:
        await _empfangen(id, s['sdp'] as String? ?? '');
      case 'antwort' when id != null:
        await _verbindungen[id]?.antwortSetzen(s['sdp'] as String? ?? '');
      case 'ice' when id != null:
        final k = Map<String, dynamic>.from(s['c'] as Map? ?? {});
        final v = _verbindungen[id];
        if (v != null) {
          await v.kandidatSetzen(k);
        } else {
          (_fruehe[id] ??= []).add(k);
        }
      case 'erhalten' when id != null:
        await _ausgangEntfernen(id);
        _setzen(id, 'zugestellt', merken: true);
      case 'angesehen' when id != null:
        await _ausgangEntfernen(id);
        _setzen(id, 'angesehen', merken: true);
      case 'fehlt' when id != null:
        await _ausgangEntfernen(id);
        _setzen(id, 'fehler', merken: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Absender

  /// Verschlüsselt [bild], kündigt es an und liefert es aus, sobald das Gegenüber da ist.
  Future<FotoErgebnis> senden(Uint8List bild, {bool verschwindet = false}) async {
    final id = _zufall(16);
    final algo = AesGcm.with256bits();
    final schluessel = await algo.newSecretKey();
    final box = await algo.encrypt(bild, secretKey: schluessel);
    final daten = box.concatenation();
    await (await _datei('raus', id)).writeAsBytes(daten, flush: true);
    final ok = await _nostr.sendFotoAngebot({
      'id': id,
      'key': base64Encode(await schluessel.extractBytes()),
      'size': daten.length,
      'sha': hash.sha256.convert(daten).toString(),
    }, verschwindet: verschwindet);
    if (!ok) {
      await (await _datei('raus', id)).delete();
      return FotoErgebnis.fehler;
    }
    final ausgang = await _ausgang();
    ausgang[id] = DateTime.now().millisecondsSinceEpoch;
    await _ausgangSpeichern(ausgang);
    _setzen(id, 'wartet');
    if (!await gegenueberDa()) return FotoErgebnis.wartet;
    unawaited(_senden(id));
    return FotoErgebnis.unterwegs;
  }

  Future<void> _senden(String id) async {
    if (_verbindungen.containsKey(id)) return;
    final datei = await _datei('raus', id);
    if (!datei.existsSync()) return;
    final daten = await datei.readAsBytes();
    final v = _fabrik(
      kandidat: (c) => _nostr.sendSignal({'t': 'ice', 'id': id, 'c': c}),
    );
    _verbindungMerken(id, v);
    _setzen(id, 'laedt');
    try {
      final angebot = await v.angebotErstellen();
      await _nostr.sendSignal({'t': 'angebot', 'id': id, 'sdp': angebot});
      await v.offen.timeout(const Duration(seconds: 30));
      for (var i = 0; i < daten.length; i += _blockGroesse) {
        await v.senden(Uint8List.sublistView(daten, i, min(i + _blockGroesse, daten.length)));
      }
      await v.ende();
      // Bestätigung („erhalten“) kommt als Signal; bis dahin bleibt die Datei liegen.
      await Future.delayed(const Duration(seconds: 5));
      if (status.value[id] == 'laedt') _setzen(id, 'wartet');
    } catch (e) {
      debugPrint('Foto $id: Übertragung nicht möglich (${e.runtimeType})');
      if (status.value[id] == 'laedt') _setzen(id, 'wartet');
    } finally {
      _verbindungen.remove(id);
      await v.schliessen();
    }
  }

  // ---------------------------------------------------------------------------
  // Empfänger

  Future<void> _empfangen(String id, String angebot) async {
    final angaben = await _nostr.fotoAngebot(id);
    if (angaben == null) {
      await _nostr.sendSignal({'t': 'fehlt', 'id': id});
      return;
    }
    if ((await _datei('rein', id)).existsSync() || _verbindungen.containsKey(id)) return;
    final teile = BytesBuilder(copy: false);
    final fertig = Completer<void>();
    final v = _fabrik(
      kandidat: (c) => _nostr.sendSignal({'t': 'ice', 'id': id, 'c': c}),
      daten: teile.add,
      beendet: () {
        if (!fertig.isCompleted) fertig.complete();
      },
    );
    _verbindungMerken(id, v);
    _setzen(id, 'laedt');
    try {
      final antwort = await v.antwortErstellen(angebot);
      await _nostr.sendSignal({'t': 'antwort', 'id': id, 'sdp': antwort});
      await fertig.future.timeout(const Duration(seconds: 60));
      final daten = teile.takeBytes();
      if (daten.length != angaben['size'] || hash.sha256.convert(daten).toString() != angaben['sha']) {
        throw StateError('Foto unvollständig');
      }
      await (await _datei('rein', id)).writeAsBytes(daten, flush: true);
      _setzen(id, 'bereit');
      await _nostr.sendSignal({'t': 'erhalten', 'id': id});
    } catch (e) {
      debugPrint('Foto $id: Empfang nicht möglich (${e.runtimeType})');
      _setzen(id, 'wartet');
    } finally {
      _verbindungen.remove(id);
      await v.schliessen();
    }
  }

  /// Entschlüsselt ein empfangenes Foto zum einmaligen Ansehen. Danach sind Datei und Schlüssel
  /// gelöscht; das Bild existiert nur noch im Arbeitsspeicher der Ansicht.
  Future<Uint8List?> einmalOeffnen(String id) async {
    final angaben = await _nostr.fotoAngebot(id);
    final datei = await _datei('rein', id);
    if (angaben == null || !datei.existsSync()) return null;
    try {
      final box = SecretBox.fromConcatenation(await datei.readAsBytes(), nonceLength: 12, macLength: 16);
      final bild = await AesGcm.with256bits()
          .decrypt(box, secretKey: SecretKey(base64Decode(angaben['key'] as String)));
      return Uint8List.fromList(bild);
    } finally {
      await datei.delete();
      await _nostr.fotoVergessen(id);
      _setzen(id, 'angesehen', merken: true);
      unawaited(_nostr.sendSignal({'t': 'angesehen', 'id': id}));
    }
  }

  /// Zustand eines Fotos für die Anzeige (Empfänger leitet ihn aus Datei und Schlüssel ab).
  Future<String> zustand(String id, {required bool vonMir}) async {
    final bekannt = status.value[id];
    if (vonMir || bekannt == 'laedt' || bekannt == 'angesehen') return bekannt ?? 'wartet';
    if (await _nostr.fotoAngebot(id) == null) return 'angesehen';
    return (await _datei('rein', id)).existsSync() ? 'bereit' : 'wartet';
  }

  Future<List<String>> _fehlendeFotos() async {
    return [
      for (final id in _nostr.empfangeneFotoIds)
        if (await _nostr.fotoAngebot(id) != null && !(await _datei('rein', id)).existsSync()) id,
    ];
  }

  // ---------------------------------------------------------------------------
  // Ablage

  Future<Map<String, int>> _ausgang() async {
    final prefs = await SharedPreferences.getInstance();
    return Map<String, int>.from(jsonDecode(prefs.getString(_keyAusgang) ?? '{}') as Map);
  }

  Future<void> _ausgangSpeichern(Map<String, int> a) async =>
      (await SharedPreferences.getInstance()).setString(_keyAusgang, jsonEncode(a));

  Future<void> _ausgangEntfernen(String id) async {
    final a = await _ausgang()..remove(id);
    await _ausgangSpeichern(a);
    final datei = await _datei('raus', id);
    if (datei.existsSync()) await datei.delete();
  }

  /// Nicht ausgelieferte Fotos nach [aufbewahrung] löschen.
  Future<void> _aufraeumen({DateTime? jetzt}) async {
    final grenze = (jetzt ?? DateTime.now()).subtract(aufbewahrung).millisecondsSinceEpoch;
    for (final e in (await _ausgang()).entries) {
      if (e.value < grenze) {
        await _ausgangEntfernen(e.key);
        _setzen(e.key, 'fehler', merken: true);
      }
    }
  }

  @visibleForTesting
  Future<void> aufraeumenFuerTest(DateTime jetzt) => _aufraeumen(jetzt: jetzt);

  Future<void> _statusLaden() async {
    final prefs = await SharedPreferences.getInstance();
    final gespeichert = Map<String, String>.from(jsonDecode(prefs.getString(_keyStatus) ?? '{}') as Map);
    status.value = {...gespeichert, ...status.value};
  }

  void _setzen(String id, String zustand, {bool merken = false}) {
    status.value = {...status.value, id: zustand};
    if (merken) {
      SharedPreferences.getInstance().then((prefs) {
        final alle = Map<String, String>.from(jsonDecode(prefs.getString(_keyStatus) ?? '{}') as Map);
        alle[id] = zustand;
        prefs.setString(_keyStatus, jsonEncode(alle));
      });
    }
  }

  static String _zufall(int bytes) {
    final r = Random.secure();
    return [for (var i = 0; i < bytes; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')].join();
  }
}
