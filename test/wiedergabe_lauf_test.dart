import 'dart:async';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/services/wiedergabe_lauf.dart';

class Uhr implements Stopwatch {
  Duration jetzt = Duration.zero,
      _summe = Duration.zero,
      _anfang = Duration.zero;
  @override
  bool isRunning = false;
  @override
  void start() {
    if (!isRunning) {
      _anfang = jetzt;
      isRunning = true;
    }
  }

  @override
  void stop() {
    if (isRunning) {
      _summe += jetzt - _anfang;
      isRunning = false;
    }
  }

  @override
  void reset() {
    _summe = Duration.zero;
    _anfang = jetzt;
  }

  @override
  Duration get elapsed =>
      _summe + (isRunning ? jetzt - _anfang : Duration.zero);
  @override
  int get elapsedMicroseconds => elapsed.inMicroseconds;
  @override
  int get elapsedMilliseconds => elapsed.inMilliseconds;
  @override
  int get elapsedTicks => elapsedMicroseconds;
  @override
  int get frequency => 1000000;
}

class Ausgabe implements AbschnittAusgabe {
  final fertig = StreamController<void>.broadcast(sync: true);
  final position = StreamController<Duration>.broadcast(sync: true);
  final laenge = StreamController<Duration>.broadcast(sync: true);
  Duration? gestartet;
  bool pausiert = false, geschlossen = false;
  @override
  bool get aufnahme => true;
  @override
  Stream<void> get ende => fertig.stream;
  @override
  Stream<Duration> get positionen => position.stream;
  @override
  Stream<Duration> get laengen => laenge.stream;
  @override
  Future<void> starten(Duration p, {bool pausiert = false}) async {
    gestartet = p;
    this.pausiert = pausiert;
  }

  @override
  Future<void> pause() async {
    pausiert = true;
  }

  @override
  Future<void> weiter() async {
    pausiert = false;
  }

  @override
  Future<void> suchen(Duration p) async {
    position.add(p);
  }

  @override
  Future<void> laut(double v) async {}
  @override
  Future<void> schliessen() async {
    geschlossen = true;
  }
}

class VerzoegerteAusgabe extends Ausgabe {
  final freigabe = Completer<void>();
  @override
  Future<void> weiter() async {
    await freigabe.future;
    await super.weiter();
  }
}

WiedergabePlan plan({bool stille = false}) => WiedergabePlan(
        art: WiedergabeArt.selbst,
        id: 'selbst',
        sprache: 'de',
        spicy: false,
        parameter: const {
          'stimme': 'martin'
        },
        abschnitte: [
          WiedergabeAbschnitt(
              id: 'a',
              art: stille ? AbschnittArt.stille : AbschnittArt.sprache,
              pfad: stille ? null : 'audio/selbst/martin_a.opus',
              dauer: const Duration(seconds: 10),
              aufnahmeEnde: !stille),
          const WiedergabeAbschnitt(
              id: 'b', art: AbschnittArt.stille, dauer: Duration(seconds: 20))
        ]);

void main() {
  test('Verweigerter Audio-Fokus startet keine Aufnahme', () async {
    final q = Ausgabe();
    final l = WiedergabeLauf(
        ausgabe: (_, code) async => q,
        wach: (an) async {
          if (an) throw StateError('Fokus fehlt');
        },
        sichern: (_, backup) async {});
    await l.starten(plan());
    expect(q.gestartet, isNull);
    expect(l.zustand, WiedergabeZustand.fehler);
    await l.schliessen();
  });
  test('Decoderfehler behält die native Position für eine Wiederaufnahme',
      () async {
    final quellen = <Ausgabe>[];
    final l = WiedergabeLauf(
        ausgabe: (_, code) async {
          final q = Ausgabe();
          quellen.add(q);
          return q;
        },
        wach: (_) async {},
        sichern: (_, backup) async {});
    await l.starten(plan());
    final fehler = Completer<void>();
    l.addListener(() {
      if (l.zustand == WiedergabeZustand.fehler && !fehler.isCompleted)
        fehler.complete();
    });
    quellen.first.position.add(const Duration(seconds: 4));
    quellen.first.fertig.addError(StateError('Decoder'));
    await fehler.future.timeout(const Duration(seconds: 2));
    await l.wiederaufnehmen();
    expect(quellen.last.gestartet, const Duration(seconds: 4));
    await l.schliessen();
  });
  test('Spätere Pause gewinnt gegen ein bereits laufendes natives Fortsetzen',
      () async {
    final q = VerzoegerteAusgabe();
    final wach = <bool>[];
    final l = WiedergabeLauf(
        ausgabe: (_, code) async => q,
        wach: (an) async {
          wach.add(an);
        },
        sichern: (_, backup) async {});
    await l.starten(plan(), pausiert: true);
    final weiter = l.weiter();
    await Future<void>.delayed(Duration.zero);
    final pause = l.pause();
    q.freigabe.complete();
    await weiter;
    await pause;
    expect(l.spielt, isFalse);
    expect(q.pausiert, isTrue);
    expect(wach.last, isFalse);
    await l.schliessen();
  });
  test(
      'Passives Wiederfinden lädt nichts; Wiederaufnahme behält Abschnitt und exakte Position',
      () {
    fakeAsync((f) {
      final uhr = Uhr();
      final quellen = <Ausgabe>[];
      final l = WiedergabeLauf(
          uhr: uhr,
          ausgabe: (s, code) async {
            final q = Ausgabe();
            quellen.add(q);
            return q;
          },
          wach: (_) async {},
          sichern: (_, backup) async {});
      l.vormerken(plan(), 0, const Duration(seconds: 4));
      f.flushMicrotasks();
      expect(quellen, isEmpty);
      expect(l.zustand, WiedergabeZustand.pause);
      l.wiederaufnehmen();
      f.flushMicrotasks();
      expect(quellen.single.gestartet, const Duration(seconds: 4));
      expect(l.spielt, isTrue);
      l.schliessen();
      f.flushMicrotasks();
    });
  });
  test(
      'Native Enden wechseln sofort; alte und doppelte Ereignisse überspringen keine neue Szene',
      () async {
    final quellen = <Ausgabe>[];
    final l = WiedergabeLauf(
        ausgabe: (s, code) async {
          final q = Ausgabe();
          quellen.add(q);
          return q;
        },
        wach: (_) async {},
        sichern: (_, backup) async {});
    await l.starten(plan());
    final gewechselt = Completer<void>();
    l.addListener(() {
      if (l.index == 1 && !gewechselt.isCompleted) gewechselt.complete();
    });
    quellen.first.fertig.add(null);
    await gewechselt.future.timeout(const Duration(seconds: 2));
    expect(l.index, 1);
    expect(quellen.first.geschlossen, isTrue);
    quellen.first.fertig.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(l.index, 1);
    expect(l.spielt, isTrue);
    await l.schliessen();
  });
  test('Gedrosselter Takt zählt wirkliche Zeit, Pausezeit wird ausgeschlossen',
      () {
    fakeAsync((f) {
      final uhr = Uhr();
      final l = WiedergabeLauf(
          uhr: uhr,
          ausgabe: (s, code) async => Ausgabe(),
          wach: (_) async {},
          sichern: (_, backup) async {});
      l.starten(plan(stille: true));
      f.flushMicrotasks();
      uhr.jetzt += const Duration(seconds: 3);
      f.elapse(const Duration(milliseconds: 250));
      l.pause();
      f.flushMicrotasks();
      uhr.jetzt += const Duration(minutes: 2);
      f.elapse(const Duration(milliseconds: 250));
      expect(l.position, const Duration(seconds: 3));
      expect(l.index, 0);
      l.weiter();
      f.flushMicrotasks();
      uhr.jetzt += const Duration(seconds: 8);
      f.elapse(const Duration(milliseconds: 250));
      f.flushMicrotasks();
      expect(l.index, 1);
      l.schliessen();
      f.flushMicrotasks();
    });
  });
  test(
      'Pause während des Ladens verhindert den Start; Abschluss löscht nur den Merker',
      () async {
    final geladen = Completer<AbschnittAusgabe>();
    final q = Ausgabe();
    final geloescht = <bool>[];
    final l = WiedergabeLauf(
        ausgabe: (_, code) => geladen.future,
        wach: (_) async {},
        sichern: (l, backup) async {
          geloescht.add(l.zustand == WiedergabeZustand.fertig);
        });
    final startet = l.starten(plan());
    await Future<void>.delayed(Duration.zero);
    final pausiert = l.pause();
    geladen.complete(q);
    await startet;
    await pausiert;
    expect(q.pausiert, isTrue);
    expect(l.spielt, isFalse);
    await l.beenden(entfernen: true);
    expect(geloescht.last, isTrue);
    expect(l.plan, isNull);
    await l.schliessen();
  });
}
