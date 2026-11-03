import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/services/gemeinsam_hoeren.dart';
import 'package:velvetpulse/services/wiedergabe_lauf.dart';

class TestAufnahme implements AbschnittAusgabe {
  @override
  final bool aufnahme;
  TestAufnahme({this.aufnahme = true});
  int starts = 0;
  bool pausiert = false;
  Duration position = Duration.zero;
  final fertig = StreamController<void>.broadcast();
  @override
  Stream<void> get ende => fertig.stream;
  @override
  Stream<Duration> get positionen => const Stream.empty();
  @override
  Stream<Duration> get laengen => const Stream.empty();
  @override
  Future<void> starten(Duration p, {bool pausiert = false}) async {
    position = p;
    this.pausiert = pausiert;
    if (!pausiert) starts++;
  }

  @override
  Future<void> weiter() async {
    starts++;
    pausiert = false;
  }

  @override
  Future<void> pause() async {
    pausiert = true;
  }

  @override
  Future<void> suchen(Duration p) async {
    position = p;
  }

  @override
  Future<void> laut(double v) async {}
  @override
  Future<void> schliessen() async {
    await fertig.close();
  }
}

WiedergabePlan angebot({bool spicy = false}) => WiedergabePlan(
        art: WiedergabeArt.lektion,
        id: 'probe',
        sprache: 'de',
        spicy: spicy,
        abschnitte: const [
          WiedergabeAbschnitt(
              id: 'probe',
              art: AbschnittArt.sprache,
              dauer: Duration(minutes: 1),
              pfad: 'audio/probe.opus',
              aufnahmeEnde: true)
        ]);

class ZweiGeraete {
  final empfangA = StreamController<Map<String, dynamic>>.broadcast();
  final empfangB = StreamController<Map<String, dynamic>>.broadcast();
  final vonA = <Map<String, dynamic>>[], vonB = <Map<String, dynamic>>[];
  final quellenA = <TestAufnahme>[], quellenB = <TestAufnahme>[];
  bool netzA = true,
      netzB = true,
      spicyA = true,
      spicyB = true,
      gekoppelt = true;
  bool aufnahmeB = true;
  String? hashA = 'gleich', hashB = 'gleich';
  String? sperreA, sperreB;
  late final WiedergabeLauf laufA = WiedergabeLauf(
      ausgabe: (_, code) async {
        final q = TestAufnahme();
        quellenA.add(q);
        return q;
      },
      wach: (_) async {},
      sichern: (_, backup) async {});
  late final WiedergabeLauf laufB = WiedergabeLauf(
      ausgabe: (_, code) async {
        final q = TestAufnahme(aufnahme: aufnahmeB);
        quellenB.add(q);
        return q;
      },
      wach: (_) async {},
      sichern: (_, backup) async {});
  late final GemeinsamHoeren a = GemeinsamHoeren(
      lauf: laufA,
      signale: empfangA.stream,
      sende: (m) async {
        final raw = Map<String, dynamic>.from(m);
        vonA.add(raw);
        if (netzA && (sperreA == null || raw['a'] != sperreA))
          empfangB.add(raw);
        return netzA;
      },
      ergaenzen: (p) async => p,
      pruefsumme: (_) async => hashA,
      gekoppelt: () => gekoppelt,
      spicy: () => spicyA);
  late final GemeinsamHoeren b = GemeinsamHoeren(
      lauf: laufB,
      signale: empfangB.stream,
      sende: (m) async {
        final raw = Map<String, dynamic>.from(m);
        vonB.add(raw);
        if (netzB && (sperreB == null || raw['a'] != sperreB))
          empfangA.add(raw);
        return netzB;
      },
      ergaenzen: (p) async => p,
      pruefsumme: (_) async => hashB,
      gekoppelt: () => gekoppelt,
      spicy: () => spicyB,
      jetzt: () => DateTime.now().add(const Duration(seconds: 90)));
  ZweiGeraete() {
    a;
    b;
  }
  Future<void> annehmen() async {
    await a.einladen(angebot());
    await warten(() => b.phase == GemeinsamPhase.einladung);
    await b.annehmen();
    await warten(() => a.angenommen);
  }

  Future<void> beideBereit() async {
    await a.bereit();
    await b.bereit();
    await warten(() =>
        a.phase == GemeinsamPhase.countdown &&
        b.phase == GemeinsamPhase.countdown);
  }

  Future<void> schliessen() async {
    await a.schliessen();
    await b.schliessen();
    await laufA.schliessen();
    await laufB.schliessen();
    await empfangA.close();
    await empfangB.close();
  }
}

Future<void> warten(bool Function() fertig,
    {Duration timeout = const Duration(seconds: 2)}) async {
  final ende = DateTime.now().add(timeout);
  while (!fertig()) {
    if (DateTime.now().isAfter(ende))
      fail('Erwarteter Signalzustand blieb aus');
    await Future<void>.delayed(const Duration(milliseconds: 2));
  }
}

void main() {
  late ZweiGeraete g;
  setUp(() {
    g = ZweiGeraete();
  });
  tearDown(() => g.schliessen());

  test(
      'Einladung startet nichts; zwei Bereitschaften gleichen auch verschiedene Geräteuhren ab',
      () async {
    await g.annehmen();
    expect(g.quellenA, isEmpty);
    expect(g.quellenB, isEmpty);
    await g.a.bereit();
    expect(g.laufA.spielt, isFalse);
    expect(g.laufB.spielt, isFalse);
    expect(g.a.phase, GemeinsamPhase.wartet);
    await g.b.bereit();
    await warten(() => g.b.phase == GemeinsamPhase.countdown);
    expect(g.quellenA.every((q) => q.starts == 0), isTrue);
    expect(g.quellenB.every((q) => q.starts == 0), isTrue);
    await warten(() => g.laufA.spielt && g.laufB.spielt,
        timeout: const Duration(seconds: 7));
    expect(g.a.phase, GemeinsamPhase.hoert);
    expect(g.b.phase, GemeinsamPhase.hoert);
    await g.b.pause();
    await warten(() => g.a.phase == GemeinsamPhase.pause);
    expect(g.laufA.spielt, isFalse);
    expect(g.laufB.spielt, isFalse);
    await g.a.bereit();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(g.laufA.spielt, isFalse);
    expect(g.a.phase, GemeinsamPhase.pause);
    await g.b.bereit();
    await warten(() =>
        g.a.phase == GemeinsamPhase.countdown &&
        g.b.phase == GemeinsamPhase.countdown);
  });

  test('Fehlende und abweichende Aufnahmen verhindern beidseitig den Start',
      () async {
    g.hashB = 'anders';
    await g.a.einladen(angebot());
    await warten(
        () => g.a.problem == 'aufnahmen' && g.b.problem == 'aufnahmen');
    expect(g.quellenA, isEmpty);
    expect(g.quellenB, isEmpty);
    expect(g.laufA.spielt, isFalse);
    expect(g.laufB.spielt, isFalse);
  });

  test('Ohne eigene Aufnahme wird nicht einmal eine Einladung gesendet',
      () async {
    g.hashA = null;
    await g.a.einladen(angebot());
    expect(g.vonA, isEmpty);
    expect(g.a.problem, 'aufnahmen');
  });

  test('Später unterbricht keine andere lokale Wiedergabe', () async {
    await g.laufB.starten(angebot());
    await g.a.einladen(angebot());
    await warten(() => g.b.phase == GemeinsamPhase.einladung);
    expect(g.laufB.spielt, isTrue);
    await g.b.beenden();
    expect(g.laufB.spielt, isTrue);
  });

  test(
      'Verspätete Pause gilt auch nach neuerem Takt; alte Bereitschaft hebt sie nicht auf',
      () async {
    await g.annehmen();
    await g.beideBereit();
    g.sperreB = 'pause';
    await g.b.pause();
    final pause = g.vonB.lastWhere((m) => m['a'] == 'pause');
    g.empfangA.add({
      't': 'ge_v1',
      'v': 1,
      's': g.a.sitzung,
      'n': (pause['n'] as int) + 1,
      'a': 'takt'
    });
    g.empfangA.add(pause);
    await warten(() => g.a.phase == GemeinsamPhase.pause);
    final alt = g.vonB.firstWhere((m) => m['a'] == 'bereit');
    g.empfangA.add(alt);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(g.a.partnerBereit, isFalse);
    expect(g.a.startzeit, isNull);
    expect(g.laufA.spielt, isFalse);
  });

  test('Verlorene Startbestätigung lässt den Gastgeber nicht losspielen',
      () async {
    await g.annehmen();
    g.sperreB = 'start_ack';
    await g.beideBereit();
    await warten(() => g.a.phase == GemeinsamPhase.pause,
        timeout: const Duration(seconds: 7));
    await warten(() => !g.laufB.spielt);
    expect(g.quellenA.every((q) => q.starts == 0), isTrue);
    expect(g.laufA.spielt, isFalse);
  });

  test(
      'Verspäteter Uhrabgleich hinter Annahme und Bereitschaft bleibt verwendbar',
      () async {
    g.sperreB = 'pong';
    await g.annehmen();
    await g.a.bereit();
    await g.b.bereit();
    expect(g.a.phase, isNot(GemeinsamPhase.countdown));
    final pong = g.vonB.firstWhere((m) => m['a'] == 'pong');
    g.empfangA.add(pong);
    await warten(() =>
        g.a.phase == GemeinsamPhase.countdown &&
        g.b.phase == GemeinsamPhase.countdown);
    expect(g.laufA.spielt, isFalse);
    expect(g.laufB.spielt, isFalse);
  });

  test(
      'Gelöschte Datei nach Bereitschaftsprüfung aktiviert niemals die Geräte-Stimme',
      () async {
    await g.annehmen();
    g.aufnahmeB = false;
    await g.b.bereit();
    expect(g.b.ichBereit, isFalse);
    expect(g.b.phase, GemeinsamPhase.fehler);
    expect(g.quellenB.every((q) => q.starts == 0), isTrue);
  });

  test('Fremde Sitzungs-ID und erneute Einladung nach Ende lösen nichts aus',
      () async {
    await g.annehmen();
    g.empfangA.add({'t': 'ge_v1', 'v': 1, 's': '0' * 32, 'n': 99, 'a': 'ende'});
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(g.a.aktiv, isTrue);
    final einladung = g.vonA.firstWhere((m) => m['a'] == 'einladung');
    await g.b.beenden();
    g.empfangB.add(einladung);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(g.b.phase, GemeinsamPhase.ende);
  });

  test(
      'Natürliches Ende schneidet die letzten Worte auf dem anderen Gerät nicht ab',
      () async {
    await g.annehmen();
    await g.beideBereit();
    await warten(() => g.laufA.spielt && g.laufB.spielt,
        timeout: const Duration(seconds: 7));
    g.quellenA.last.fertig.add(null);
    await warten(() => g.a.phase == GemeinsamPhase.ende);
    expect(g.laufB.spielt, isTrue);
    expect(g.vonA.where((m) => m['a'] == 'ende'), isEmpty);
    g.quellenB.last.fertig.add(null);
    await warten(() => g.b.phase == GemeinsamPhase.ende);
  });
}
