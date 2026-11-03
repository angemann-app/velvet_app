import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/wiedergabe_plan.dart';

/// Ein geladener Abschnitt. Eigene Instanz je Abschnitt: verspätete native
/// Ereignisse einer alten Aufnahme dürfen keine neue Szene überspringen.
abstract class AbschnittAusgabe {
  bool get aufnahme;
  Stream<void> get ende;
  Stream<Duration> get positionen;
  Stream<Duration> get laengen;
  Future<void> starten(Duration position, {bool pausiert = false});
  Future<void> pause();
  Future<void> weiter();
  Future<void> suchen(Duration position);
  Future<void> laut(double wert);
  Future<void> schliessen();
}

enum WiedergabeZustand { leer, laden, spielt, pause, fertig, fehler }

/// Die Sitzung lebt unabhängig von einer Route. Die Uhr misst tatsächliche
/// aktive Zeit; ein gedrosselter UI-Timer verlängert dadurch keine Stillen.
class WiedergabeLauf extends ChangeNotifier {
  final Future<AbschnittAusgabe> Function(WiedergabeAbschnitt, String) ausgabe;
  final Future<void> Function(bool) wach;
  final Future<void> Function(WiedergabeLauf, bool) sichern;
  final Future<void> Function(WiedergabeLauf)? abschnittBeginnt;
  final Future<void> Function(WiedergabeLauf)? begleiten;
  final Duration takt;
  WiedergabeLauf(
      {required this.ausgabe,
      required this.wach,
      required this.sichern,
      this.abschnittBeginnt,
      this.begleiten,
      this.takt = const Duration(milliseconds: 250),
      Stopwatch? uhr})
      : _uhr = uhr ?? Stopwatch();

  WiedergabePlan? plan;
  WiedergabeZustand zustand = WiedergabeZustand.leer;
  int index = 0;
  bool geraetestimme = false;
  bool nurAufnahmen = false;
  Object? fehler;
  Duration nativeLaenge = Duration.zero;
  Duration _nativePosition = Duration.zero;
  Duration _basis = Duration.zero;
  final Stopwatch _uhr;
  Timer? _timer;
  AbschnittAusgabe? _quelle;
  final List<StreamSubscription> _abos = [];
  int _generation = 0;
  int _steuerung = 0;
  bool _pauseGewollt = false, _aufnahmeFertig = false, _wechselt = false;
  Future<void> _arbeit = Future<void>.value();
  Duration _zuletztGesichert = Duration.zero;

  WiedergabeAbschnitt? get abschnitt =>
      plan == null ? null : plan!.abschnitte[index];
  bool get spielt => zustand == WiedergabeZustand.spielt;
  bool get vorbereitet => _timer?.isActive == true;
  bool get vorhanden => plan != null && zustand != WiedergabeZustand.fertig;
  Duration get position => _basis + _uhr.elapsed;
  Duration get aufnahmePosition => _quelle?.aufnahme == true && !_aufnahmeFertig
      ? _nativePosition
      : position;
  Duration get vergangen =>
      (plan?.bisAbschnitt(index) ?? Duration.zero) + position;
  Duration get dauer => plan?.dauer ?? Duration.zero;

  Future<void> _reihe(Future<void> Function() aktion) {
    final job = _arbeit.then((_) => aktion());
    _arbeit = job.then<void>((_) {}, onError: (Object e, StackTrace s) {});
    return job;
  }

  Future<void> starten(WiedergabePlan neu,
      {int bei = 0, Duration position = Duration.zero, bool pausiert = false}) {
    // Vor einer Änderung des laufenden Programms streng validieren.
    WiedergabePlan.fromJson(neu.toJson());
    if (bei < 0 || bei >= neu.abschnitte.length || position.isNegative) {
      throw const FormatException('Ungültiger Wiedergabestart');
    }
    final generation = ++_generation;
    ++_steuerung;
    _pauseGewollt = pausiert;
    _uhr.stop();
    return _reihe(() async {
      if (generation != _generation) return;
      await _quelleSchliessen();
      plan = neu;
      index = bei;
      fehler = null;
      _zuletztGesichert = Duration.zero;
      await _laden(generation, position);
    });
  }

  Future<void> _laden(int generation, Duration bei) async {
    _timer?.cancel();
    _uhr.stop();
    _uhr.reset();
    _basis = bei;
    _nativePosition = bei;
    nativeLaenge = Duration.zero;
    _aufnahmeFertig = false;
    _wechselt = false;
    geraetestimme = false;
    zustand = WiedergabeZustand.laden;
    notifyListeners();
    try {
      final s = abschnitt!;
      if (s.art != AbschnittArt.stille) {
        final q = await ausgabe(s, plan!.sprache);
        if (generation != _generation) {
          await q.schliessen();
          return;
        }
        if (nurAufnahmen && !q.aufnahme) {
          await q.schliessen();
          throw StateError('Gemeinsames Hören braucht Aufnahmen');
        }
        _quelle = q;
        geraetestimme = !q.aufnahme;
        // Geräte-Stimmen erlauben kein verlässliches Seek: Abschnitt bewusst
        // von vorn lesen statt einen falschen sekundengenauen Stand anzuzeigen.
        if (!q.aufnahme) _basis = Duration.zero;
        _abos.add(q.ende.listen((_) {
          if (generation != _generation) return;
          _aufnahmeFertig = true;
          _pruefen();
        }, onError: (Object e) => _quellFehler(e, generation)));
        _abos.add(q.positionen.listen((p) {
          if (generation == _generation) _nativePosition = p;
        }, onError: (Object e) => _quellFehler(e, generation)));
        _abos.add(q.laengen.listen((d) {
          if (generation == _generation && d > Duration.zero) nativeLaenge = d;
        }, onError: (Object e) => _quellFehler(e, generation)));
        if (!_pauseGewollt) await wach(true);
        if (generation != _generation) return;
        await q.starten(_basis, pausiert: _pauseGewollt);
        if (generation != _generation) return;
        if (_pauseGewollt) await q.pause();
      }
      if (generation != _generation) return;
      zustand =
          _pauseGewollt ? WiedergabeZustand.pause : WiedergabeZustand.spielt;
      if (!_pauseGewollt) _uhr.start();
      await wach(!_pauseGewollt);
      await abschnittBeginnt?.call(this);
      await begleiten?.call(this);
      await sichern(this, true);
      if (generation != _generation) return;
      _zuletztGesichert = vergangen;
      _timer = Timer.periodic(takt, (_) => _pruefen());
      notifyListeners();
      _pruefen();
    } catch (e) {
      if (generation != _generation) return;
      await _fehlgeschlagen(e);
    }
  }

  void _pruefen() {
    if (!spielt || _wechselt || abschnitt == null) return;
    final s = abschnitt!;
    final grenze = nativeLaenge > s.dauer ? nativeLaenge : s.dauer;
    final fertig = s.art == AbschnittArt.stille
        ? position >= s.dauer
        : s.aufnahmeEnde
            ? _aufnahmeFertig
            : position >= s.dauer && _aufnahmeFertig;
    if (fertig) {
      _wechselt = true;
      unawaited(naechster());
      return;
    }
    // Ein verlorenes Plugin-Ende darf keine Endlosschleife erzeugen. Eine
    // längere tatsächlich gemessene Aufnahme wird dabei nicht abgeschnitten.
    final sicherung = geraetestimme
        ? grenze * 3 + const Duration(seconds: 30)
        : grenze + const Duration(seconds: 8);
    if (s.art != AbschnittArt.stille &&
        !_aufnahmeFertig &&
        position > sicherung) {
      _quellFehler(StateError('Aufnahmeende fehlt'), _generation);
      return;
    }
    if (vergangen - _zuletztGesichert >= const Duration(seconds: 5)) {
      _zuletztGesichert = vergangen;
      unawaited(sichern(this, false).catchError((Object e) {
        fehler = e;
        notifyListeners();
      }));
    }
    if (begleiten != null)
      unawaited(begleiten!(this).catchError((Object _) {}));
    notifyListeners();
  }

  Future<void> pause() {
    ++_steuerung;
    _pauseGewollt = true;
    _uhr.stop();
    if (zustand == WiedergabeZustand.spielt) zustand = WiedergabeZustand.pause;
    notifyListeners();
    return _reihe(() async {
      await _quelle?.pause();
      await wach(false);
      await begleiten?.call(this);
      await sichern(this, true);
    });
  }

  Future<void> weiter() {
    final steuerung = ++_steuerung;
    return _reihe(() async {
      if (steuerung != _steuerung) return;
      if (plan == null || zustand != WiedergabeZustand.pause) return;
      _pauseGewollt = false;
      try {
        await wach(true);
        if (steuerung != _steuerung) {
          await wach(false);
          return;
        }
        if (!_aufnahmeFertig) await _quelle?.weiter();
      } catch (e) {
        await _fehlgeschlagen(e);
        return;
      }
      if (steuerung != _steuerung) {
        await _quelle?.pause();
        await wach(false);
        return;
      }
      if (geraetestimme) {
        _basis = Duration.zero;
        _uhr.reset();
        _zuletztGesichert = vergangen;
      }
      zustand = WiedergabeZustand.spielt;
      _uhr.start();
      await wach(true);
      await abschnittBeginnt?.call(this);
      await begleiten?.call(this);
      notifyListeners();
      _pruefen();
    });
  }

  Future<void> suchen(Duration ziel) => _reihe(() async {
        if (abschnitt == null ||
            (geraetestimme && abschnitt!.art != AbschnittArt.stille)) return;
        final grenze =
            nativeLaenge > Duration.zero ? nativeLaenge : abschnitt!.dauer;
        final p = Duration(
            milliseconds: ziel.inMilliseconds.clamp(0, grenze.inMilliseconds));
        final lief = spielt;
        _uhr.stop();
        await _quelle?.suchen(p);
        _basis = p;
        _nativePosition = p;
        _uhr.reset();
        _zuletztGesichert = vergangen;
        _aufnahmeFertig = false;
        if (lief) _uhr.start();
        await sichern(this, true);
        notifyListeners();
      });

  Future<void> springen(int ziel) {
    if (plan == null || ziel < 0 || ziel >= plan!.abschnitte.length)
      return Future.value();
    final generation = ++_generation;
    _uhr.stop();
    return _reihe(() async {
      if (generation != _generation) return;
      await _quelleSchliessen();
      index = ziel;
      await _laden(generation, Duration.zero);
    });
  }

  Future<void> naechster() {
    if (plan == null) return Future.value();
    if (index + 1 < plan!.abschnitte.length) return springen(index + 1);
    ++_generation;
    _uhr.stop();
    return _reihe(() async {
      _timer?.cancel();
      await _quelleSchliessen();
      zustand = WiedergabeZustand.fertig;
      await begleiten?.call(this);
      await wach(false);
      await sichern(this, true);
      notifyListeners();
    });
  }

  /// Beenden hält den aktuellen Stand. Entfernen löscht zusätzlich den Merker.
  Future<void> beenden({bool entfernen = false}) {
    ++_generation;
    ++_steuerung;
    _uhr.stop();
    _pauseGewollt = true;
    return _reihe(() async {
      _timer?.cancel();
      // Vor Schließen die native Position sichern, der Transport verwirft sie.
      _basis = aufnahmePosition;
      _uhr.reset();
      await _quelleSchliessen();
      zustand = entfernen ? WiedergabeZustand.fertig : WiedergabeZustand.pause;
      await begleiten?.call(this);
      await wach(false);
      await sichern(this, true);
      if (entfernen) {
        plan = null;
        zustand = WiedergabeZustand.leer;
      }
      notifyListeners();
    });
  }

  Future<void> wiederaufnehmen() async {
    if (plan == null) return;
    if (_timer == null ||
        !_timer!.isActive ||
        zustand == WiedergabeZustand.fehler) {
      return starten(plan!, bei: index, position: _basis);
    }
    return weiter();
  }

  Future<void> laut(double wert) async => _quelle?.laut(wert);
  Future<void> meldeFehler(Object e) => _reihe(() => _fehlgeschlagen(e));
  void _quellFehler(Object e, int generation) {
    if (generation != _generation ||
        _wechselt ||
        zustand == WiedergabeZustand.fehler) return;
    _wechselt = true;
    _uhr.stop();
    unawaited(_reihe(() async {
      if (generation == _generation) await _fehlgeschlagen(e);
    }));
  }

  /// Passives Wiederfinden nach App-Start oder einer Einladung: kein Laden,
  /// kein Ton und keine Wachhaltesperre vor einer bewussten Wiedergabe.
  Future<void> vormerken(WiedergabePlan neu, int bei, Duration pos) async {
    WiedergabePlan.fromJson(neu.toJson());
    if (bei < 0 || bei >= neu.abschnitte.length || pos.isNegative) {
      throw const FormatException('Ungültiger Wiedergabemerker');
    }
    ++_generation;
    ++_steuerung;
    _timer?.cancel();
    _uhr.stop();
    await _reihe(() async {
      await _quelleSchliessen();
      await wach(false);
      plan = neu;
      index = bei;
      _basis = pos;
      _uhr.reset();
      _pauseGewollt = true;
      geraetestimme = false;
      fehler = null;
      zustand = WiedergabeZustand.pause;
      notifyListeners();
    });
  }

  Future<void> _quelleSchliessen() async {
    for (final a in _abos) {
      await a.cancel();
    }
    _abos.clear();
    final alt = _quelle;
    _quelle = null;
    await alt?.schliessen();
  }

  Future<void> _fehlgeschlagen(Object e) async {
    if (zustand == WiedergabeZustand.fehler) return;
    _uhr.stop();
    _timer?.cancel();
    fehler = e;
    _basis = aufnahmePosition;
    _uhr.reset();
    zustand = WiedergabeZustand.fehler;
    await _quelleSchliessen();
    await wach(false);
    await begleiten?.call(this);
    try {
      await sichern(this, true);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> schliessen() async {
    ++_generation;
    _timer?.cancel();
    _uhr.stop();
    await _reihe(_quelleSchliessen);
    await wach(false);
    super.dispose();
  }
}
