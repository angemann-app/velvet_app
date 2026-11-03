import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../models/wiedergabe_plan.dart';
import 'wiedergabe_lauf.dart';

enum GemeinsamPhase {
  ruhe,
  einladung,
  wartet,
  countdown,
  hoert,
  pause,
  ende,
  fehler
}

/// Baut auf bereits authentifizierten/entschlüsselten Partnersignalen auf.
/// Keine Schlüssel, Inhalte oder Sitzungen werden hier dauerhaft gespeichert.
class GemeinsamHoeren extends ChangeNotifier {
  final WiedergabeLauf lauf;
  final Future<bool> Function(Map<String, Object?>) sende;
  final Future<WiedergabePlan> Function(WiedergabePlan) ergaenzen;
  final Future<String?> Function(WiedergabePlan) pruefsumme;
  final bool Function() gekoppelt, spicy;
  final DateTime Function() jetzt;
  late final StreamSubscription _abo;
  GemeinsamHoeren(
      {required this.lauf,
      required Stream<Map<String, dynamic>> signale,
      required this.sende,
      required this.ergaenzen,
      required this.pruefsumme,
      required this.gekoppelt,
      required this.spicy,
      DateTime Function()? jetzt})
      : jetzt = jetzt ?? DateTime.now {
    _abo = signale.listen((m) {
      _eingang = _eingang.then((_) => _empfangen(m)).catchError((Object _) {});
    });
    lauf.addListener(_player);
  }
  GemeinsamPhase phase = GemeinsamPhase.ruhe;
  WiedergabePlan? plan;
  String? sitzung;
  bool gastgeber = false, ichBereit = false, partnerBereit = false;
  bool angenommen = false, verbindungFehlt = false;
  String? problem;
  DateTime? startzeit;
  int? _uhrVersatz;
  int _sequenz = 0, _hoechsteSequenz = 0;
  final _gesehen = <int>{};
  final _beendet = <String>{};
  final _pausen = <String>{};
  int _index = 0;
  Duration _position = Duration.zero;
  String? _digest;
  String? _partnerRunde;
  int? _pingZeit;
  DateTime? _letztesSignal;
  Timer? _start, _takt, _ablauf;
  bool _startAck = false, _bereitetVor = false, _endet = false;
  bool _suche = false;
  bool _startWirdGesendet = false;
  bool _geschlossen = false;
  String? _probeId;
  Completer<bool>? _probeAntwort;
  Future<void> _eingang = Future.value();
  bool get aktiv =>
      !_geschlossen &&
      sitzung != null &&
      phase != GemeinsamPhase.ruhe &&
      phase != GemeinsamPhase.ende;
  @override
  void notifyListeners() {
    if (!_geschlossen) super.notifyListeners();
  }

  String get rueckblickId => 'ge_${plan?.spicy == true ? 's' : 'n'}_$sitzung';
  String get _runde {
    final ids = _pausen.toList()..sort();
    return sha256.convert(utf8.encode(ids.join(':'))).toString();
  }

  int get countdown => startzeit == null
      ? 0
      : (startzeit!.difference(jetzt()).inMilliseconds / 1000)
          .ceil()
          .clamp(0, 10);
  static String _nonce() => List.generate(16,
          (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'))
      .join();

  Future<bool> _senden(String art,
      [Map<String, Object?> daten = const {}]) async {
    if (sitzung == null || !gekoppelt()) return false;
    return sende({
      't': 'ge_v1',
      'v': 1,
      's': sitzung,
      'n': ++_sequenz,
      'a': art,
      ...daten
    });
  }

  void _neueSitzung(String id, bool host) {
    _start?.cancel();
    _takt?.cancel();
    _ablauf?.cancel();
    sitzung = id;
    gastgeber = host;
    ichBereit = false;
    partnerBereit = false;
    angenommen = false;
    problem = null;
    verbindungFehlt = false;
    startzeit = null;
    _uhrVersatz = null;
    _sequenz = 0;
    _hoechsteSequenz = 0;
    _gesehen.clear();
    _pausen.clear();
    _partnerRunde = null;
    _index = 0;
    _position = Duration.zero;
    _letztesSignal = jetzt();
    _takt = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!aktiv) return;
      if (!gekoppelt()) {
        unawaited(beenden());
        return;
      }
      verbindungFehlt = jetzt().difference(_letztesSignal!).inSeconds > 15;
      unawaited(_senden('takt'));
      notifyListeners();
    });
    _ablauf = Timer(const Duration(minutes: 2), () {
      if (phase == GemeinsamPhase.einladung ||
          (phase == GemeinsamPhase.wartet && !angenommen)) {
        unawaited(beenden());
      }
    });
  }

  Future<void> einladen(WiedergabePlan angebot) async {
    if (aktiv || _suche || !gekoppelt()) return;
    _suche = true;
    try {
      await _einladen(angebot);
    } catch (_) {
      problem = 'aufnahmen';
      phase = GemeinsamPhase.fehler;
    } finally {
      _suche = false;
      notifyListeners();
    }
  }

  Future<void> _einladen(WiedergabePlan angebot) async {
    final lokal = await ergaenzen(angebot);
    if (lokal.spicy && !spicy()) return;
    final digest = await pruefsumme(lokal);
    if (digest == null ||
        jsonEncode(lokal.toJson()).length > 38000 ||
        lokal.abschnitte.length > 128) {
      problem = 'aufnahmen';
      phase = GemeinsamPhase.fehler;
      notifyListeners();
      return;
    }
    _probeId = _nonce();
    _probeAntwort = Completer<bool>();
    phase = GemeinsamPhase.wartet;
    notifyListeners();
    final gesendet = await sende({'t': 'ge_probe', 'v': 1, 's': _probeId});
    final da = gesendet &&
        await _probeAntwort!.future
            .timeout(const Duration(seconds: 4), onTimeout: () => false);
    _probeId = null;
    _probeAntwort = null;
    if (!da) {
      problem = 'partner';
      phase = GemeinsamPhase.fehler;
      return;
    }
    await lauf.pause();
    _neueSitzung(_nonce(), true);
    plan = lokal;
    _digest = digest;
    phase = GemeinsamPhase.wartet;
    _pingZeit = jetzt().millisecondsSinceEpoch;
    final ok = await _senden('einladung',
        {'plan': lokal.toJson(), 'hash': digest, 'ping': _pingZeit});
    if (!ok) {
      problem = 'verbindung';
      phase = GemeinsamPhase.fehler;
    }
    notifyListeners();
  }

  Future<void> annehmen() async {
    if (phase != GemeinsamPhase.einladung ||
        plan == null ||
        (plan!.spicy && !spicy())) return;
    // Eine neue Einladung darf eine vorhandene lokale Wiedergabe erst nach
    // bewusster Annahme unterbrechen.
    await lauf.pause();
    angenommen = true;
    phase = GemeinsamPhase.wartet;
    if (!await _senden('angenommen')) {
      problem = 'verbindung';
      phase = GemeinsamPhase.fehler;
    }
    notifyListeners();
  }

  Future<void> bereit() async {
    if (!aktiv ||
        !angenommen ||
        _bereitetVor ||
        plan == null ||
        (plan!.spicy && !spicy()) ||
        phase == GemeinsamPhase.countdown ||
        phase == GemeinsamPhase.hoert) return;
    _bereitetVor = true;
    final id = sitzung, runde = _runde;
    try {
      final digest = await pruefsumme(plan!);
      if (digest == null || digest != _digest) throw StateError('aufnahmen');
      lauf.nurAufnahmen = true;
      await lauf.starten(plan!,
          bei: _index, position: _position, pausiert: true);
      if (sitzung != id || _runde != runde || !aktiv) return;
      if (lauf.zustand != WiedergabeZustand.pause || lauf.geraetestimme)
        throw StateError('aufnahmen');
      ichBereit = true;
      if (!await _senden('bereit', {'r': runde}))
        throw StateError('verbindung');
      await _vielleichtStarten();
    } catch (_) {
      ichBereit = false;
      problem = 'aufnahmen';
      phase = GemeinsamPhase.fehler;
      await _senden('pause', {
        'p': _nonce(),
        'index': _index,
        'position': _position.inMilliseconds
      });
    } finally {
      _bereitetVor = false;
      notifyListeners();
    }
  }

  Future<void> _vielleichtStarten() async {
    if (!gastgeber ||
        !angenommen ||
        !ichBereit ||
        !partnerBereit ||
        _partnerRunde != _runde ||
        _uhrVersatz == null ||
        _startWirdGesendet ||
        phase == GemeinsamPhase.countdown ||
        phase == GemeinsamPhase.hoert) return;
    _startWirdGesendet = true;
    final runde = _runde;
    try {
      startzeit = jetzt().add(const Duration(seconds: 5));
      _startAck = false;
      final ok = await _senden('start', {
        'r': _runde,
        'start': startzeit!.millisecondsSinceEpoch,
        'versatz': _uhrVersatz,
        'index': _index,
        'position': _position.inMilliseconds
      });
      if (!aktiv || _runde != runde || !ichBereit || !partnerBereit) return;
      if (!ok) {
        await pause();
        return;
      }
      _countdownStarten();
    } finally {
      _startWirdGesendet = false;
    }
  }

  void _countdownStarten() {
    _start?.cancel();
    phase = GemeinsamPhase.countdown;
    final id = sitzung, runde = _runde;
    final rest = startzeit!.difference(jetzt());
    if (rest <= Duration.zero || rest > const Duration(seconds: 10)) {
      unawaited(pause());
      return;
    }
    _start = Timer(rest, () async {
      if (sitzung != id ||
          _runde != runde ||
          !ichBereit ||
          !partnerBereit ||
          (plan!.spicy && !spicy()) ||
          (gastgeber && !_startAck)) {
        await pause();
        return;
      }
      await lauf.weiter();
      if (sitzung != id || _runde != runde || !ichBereit || !partnerBereit) {
        await lauf.pause();
        return;
      }
      if (!lauf.spielt) {
        await pause();
        problem = 'wiedergabe';
        phase = GemeinsamPhase.fehler;
        notifyListeners();
        return;
      }
      if (sitzung == id && _runde == runde && lauf.spielt) {
        phase = GemeinsamPhase.hoert;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> pause() async {
    if (!aktiv) return;
    _punktMerken();
    _start?.cancel();
    startzeit = null;
    final nonce = _nonce();
    _pausen.add(nonce);
    ichBereit = false;
    partnerBereit = false;
    _partnerRunde = null;
    phase = GemeinsamPhase.pause;
    // Lokale Pause niemals vom Erfolg einer Netzoperation abhängig machen.
    final halten = lauf.pause();
    notifyListeners();
    unawaited(_senden('pause',
        {'p': nonce, 'index': _index, 'position': _position.inMilliseconds}));
    await halten;
  }

  void _punktMerken() {
    if (lauf.plan?.id != plan?.id) return;
    _index = lauf.index;
    _position = lauf.aufnahmePosition;
    // Lokalen Hörfortschritt (z. B. bereits gezählte Folge) nicht zurücksetzen.
    plan = lauf.plan;
  }

  Future<void> beenden({bool senden = true}) async {
    if (sitzung == null) {
      phase = GemeinsamPhase.ruhe;
      notifyListeners();
      return;
    }
    _start?.cancel();
    _takt?.cancel();
    _ablauf?.cancel();
    ichBereit = false;
    partnerBereit = false;
    startzeit = null;
    if (senden) unawaited(_senden('ende'));
    _beendet.add(sitzung!);
    if (_beendet.length > 128) _beendet.remove(_beendet.first);
    phase = GemeinsamPhase.ende;
    if (angenommen || gastgeber) await lauf.pause();
    lauf.nurAufnahmen = false;
    notifyListeners();
  }

  Future<void> _empfangen(Map<String, dynamic> m) async {
    if (_geschlossen) return;
    if (m['v'] == 1 &&
        gekoppelt() &&
        m['s'] is String &&
        RegExp(r'^[a-f0-9]{32}$').hasMatch(m['s'] as String)) {
      if (m['t'] == 'ge_probe') {
        await sende({
          't': 'ge_probe_ack',
          'v': 1,
          's': m['s'],
          'frei': !aktiv && !_suche
        });
        return;
      }
      if (m['t'] == 'ge_probe_ack' &&
          m['s'] == _probeId &&
          _probeAntwort?.isCompleted == false) {
        _probeAntwort!.complete(m['frei'] == true);
        return;
      }
    }
    if (m['t'] != 'ge_v1' || m['v'] != 1 || !gekoppelt()) return;
    final id = m['s'], n = m['n'], art = m['a'];
    if (id is! String ||
        !RegExp(r'^[a-f0-9]{32}$').hasMatch(id) ||
        n is! int ||
        n < 1 ||
        n > 1000000 ||
        art is! String ||
        _beendet.contains(id)) return;
    if (art == 'einladung') {
      if (aktiv ||
          _suche ||
          m['plan'] is! Map ||
          m['hash'] is! String ||
          m['ping'] is! int) return;
      try {
        final raw = Map<String, dynamic>.from(m['plan']);
        if (jsonEncode(raw).length > 38000) return;
        final eingang = WiedergabePlan.fromJson(raw);
        // Traumpraxis-Begleitungen werden nur allein gehört, nie über eine Einladung.
        if (eingang.art == WiedergabeArt.praxis ||
            eingang.parameter['trio'] == true) return;
        final privat = eingang.art == WiedergabeArt.reihe ||
            eingang.art == WiedergabeArt.lust;
        if ((eingang.spicy || privat) && !spicy()) return;
        WiedergabePlan p;
        try {
          p = await ergaenzen(eingang);
        } catch (_) {
          if (privat && spicy()) {
            _neueSitzung(id, false);
            plan = WiedergabePlan(
                art: eingang.art,
                id: eingang.id,
                sprache: eingang.sprache,
                spicy: true,
                abschnitte: eingang.abschnitte,
                parameter: eingang.parameter);
            problem = 'aufnahmen';
            phase = GemeinsamPhase.fehler;
            await _senden('fehlt');
            notifyListeners();
          } else {
            await sende({'t': 'ge_v1', 'v': 1, 's': id, 'n': 1, 'a': 'fehlt'});
          }
          return;
        }
        if (p.abschnitte.length > 128 || (p.spicy && !spicy())) return;
        final digest = await pruefsumme(p);
        _neueSitzung(id, false);
        plan = p;
        _digest = digest;
        if (digest == null || digest != m['hash']) {
          // Sachlicher Befund am empfangenden Gerät, niemals TTS verwenden.
          problem = 'aufnahmen';
          phase = GemeinsamPhase.fehler;
          await _senden('fehlt');
          notifyListeners();
          return;
        }
        if (p.art == WiedergabeArt.paar && p.parameter['ichZuerst'] is bool) {
          plan = WiedergabePlan(
              art: p.art,
              id: p.id,
              sprache: p.sprache,
              spicy: p.spicy,
              titel: p.titel,
              abschnitte: p.abschnitte,
              parameter: {
                ...p.parameter,
                'ichZuerst': !(p.parameter['ichZuerst'] as bool)
              });
        }
        phase = GemeinsamPhase.einladung;
        _gesehen.add(n);
        _hoechsteSequenz = n;
        await _senden('pong',
            {'ping': m['ping'], 'zeit': jetzt().millisecondsSinceEpoch});
        notifyListeners();
      } catch (_) {}
      return;
    }
    if (id != sitzung ||
        !aktiv ||
        _gesehen.contains(n) ||
        n < _hoechsteSequenz - 128) return;
    // Alte Bereitschaft darf nie eine spätere Pause aufheben. Ein noch nicht
    // gesehenes Pause-Signal wird dagegen auch bei Relay-Umordnung umgesetzt.
    // Auch Pong/Annahme dürfen hinter einem neueren Takt eintreffen. Die
    // Sitzungs-ID, gesehenen Sequenzen und Pausenrunde begrenzen alte Aktionen.
    _gesehen.add(n);
    if (n > _hoechsteSequenz) _hoechsteSequenz = n;
    _gesehen.removeWhere((v) => v < _hoechsteSequenz - 128);
    _letztesSignal = jetzt();
    verbindungFehlt = false;
    switch (art) {
      case 'pong':
        if (!gastgeber || m['ping'] != _pingZeit || m['zeit'] is! int) return;
        final ende = jetzt().millisecondsSinceEpoch;
        if (ende - _pingZeit! > 10000 || ende < _pingZeit!) return;
        _uhrVersatz = (m['zeit'] as int) - ((_pingZeit! + ende) ~/ 2);
        await _vielleichtStarten();
      case 'angenommen':
        if (!gastgeber) return;
        angenommen = true;
        await _vielleichtStarten();
      case 'bereit':
        if (!angenommen || m['r'] != _runde) return;
        partnerBereit = true;
        _partnerRunde = m['r'] as String;
        await _vielleichtStarten();
      case 'start':
        if (gastgeber ||
            phase == GemeinsamPhase.hoert ||
            phase == GemeinsamPhase.countdown ||
            !ichBereit ||
            m['r'] != _runde ||
            m['start'] is! int ||
            m['versatz'] is! int ||
            !_punktGueltig(m)) return;
        final lokal = DateTime.fromMillisecondsSinceEpoch(
            (m['start'] as int) + (m['versatz'] as int));
        final rest = lokal.difference(jetzt());
        if (rest <= const Duration(seconds: 1) ||
            rest > const Duration(seconds: 10)) {
          await pause();
          return;
        }
        final runde = _runde;
        _index = m['index'] as int;
        _position = Duration(milliseconds: m['position'] as int);
        await lauf.starten(plan!,
            bei: _index, position: _position, pausiert: true);
        if (!aktiv ||
            _runde != runde ||
            !ichBereit ||
            lauf.geraetestimme ||
            lauf.zustand != WiedergabeZustand.pause) return;
        partnerBereit = true;
        startzeit = lokal;
        await _senden('start_ack', {'r': runde});
        _countdownStarten();
      case 'start_ack':
        if (gastgeber && m['r'] == _runde) _startAck = true;
      case 'pause':
        final nonce = m['p'];
        if (nonce is! String ||
            !RegExp(r'^[a-f0-9]{32}$').hasMatch(nonce) ||
            !_punktGueltig(m)) return;
        _punktMerken();
        final pi = m['index'] as int, pp = m['position'] as int;
        if (pi < _index || (pi == _index && pp < _position.inMilliseconds)) {
          _index = pi;
          _position = Duration(milliseconds: pp);
        }
        _pausen.add(nonce);
        _start?.cancel();
        startzeit = null;
        ichBereit = false;
        partnerBereit = false;
        _partnerRunde = null;
        phase = GemeinsamPhase.pause;
        await lauf.pause();
      case 'ende':
        await beenden(senden: false);
      case 'fehlt':
        _start?.cancel();
        ichBereit = false;
        partnerBereit = false;
        problem = 'aufnahmen';
        phase = GemeinsamPhase.fehler;
        await lauf.pause();
      case 'takt':
        break;
    }
    notifyListeners();
  }

  bool _punktGueltig(Map<String, dynamic> m) =>
      m['index'] is int &&
      m['position'] is int &&
      (m['index'] as int) >= 0 &&
      (m['index'] as int) < plan!.abschnitte.length &&
      (m['position'] as int) >= 0 &&
      (m['position'] as int) <= 43200000;
  void _player() {
    if (aktiv &&
        angenommen &&
        phase == GemeinsamPhase.hoert &&
        lauf.zustand == WiedergabeZustand.fehler) {
      unawaited(pause());
      return;
    }
    if (aktiv &&
        phase == GemeinsamPhase.hoert &&
        lauf.zustand == WiedergabeZustand.fertig &&
        !_endet) {
      _endet = true;
      // Ein natürliches Ende darf nicht die letzten Worte auf dem anderen
      // Gerät abschneiden. Beide beenden ihre identische Aufnahme selbst.
      unawaited(beenden(senden: false).whenComplete(() => _endet = false));
    }
  }

  Future<void> schliessen() async {
    _geschlossen = true;
    if (_probeAntwort?.isCompleted == false) _probeAntwort!.complete(false);
    _start?.cancel();
    _takt?.cancel();
    _ablauf?.cancel();
    lauf.removeListener(_player);
    await _abo.cancel();
    await _eingang;
    super.dispose();
  }

  void verwerfen() {
    if (aktiv) return;
    sitzung = null;
    plan = null;
    phase = GemeinsamPhase.ruhe;
    problem = null;
    notifyListeners();
  }
}
