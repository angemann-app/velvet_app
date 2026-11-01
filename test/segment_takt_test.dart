// Der Takt der Audioreihe: Das Ende einer Szene kommt von der Aufnahme, nicht von einem Zähler, damit die Folge bei
// ausgeschaltetem Bildschirm nicht zwischen den Szenen stehen bleibt.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/segment_takt.dart';

const _takt = Duration(milliseconds: 5);

void main() {
  test('Ohne Aufnahme endet der Abschnitt nach der geschätzten Dauer', () async {
    var summe = Duration.zero;
    final ok = await segmentAbwarten(
      dauer: const Duration(milliseconds: 60),
      pausiert: () => false,
      abgebrochen: () => false,
      fortschritt: (s) => summe += s,
      takt: _takt,
    );
    expect(ok, isTrue);
    expect(summe, greaterThanOrEqualTo(const Duration(milliseconds: 60)));
  });

  test('Mit Aufnahme geht es weiter, sobald sie zu Ende ist, auch lange vor der Dauer', () async {
    final ende = StreamController<void>.broadcast();
    final uhr = Stopwatch()..start();
    unawaited(Future.delayed(const Duration(milliseconds: 30), () => ende.add(null)));
    final ok = await segmentAbwarten(
      dauer: const Duration(seconds: 30),
      ende: ende.stream,
      pausiert: () => false,
      abgebrochen: () => false,
      fortschritt: (_) {},
      takt: _takt,
    );
    expect(ok, isTrue);
    expect(uhr.elapsed, lessThan(const Duration(seconds: 2)));
    await ende.close();
  });

  test('Kommt das Ende der Aufnahme nie, hilft die Sicherung nach der Reserve', () async {
    final ende = StreamController<void>.broadcast();
    final ok = await segmentAbwarten(
      dauer: const Duration(milliseconds: 40),
      reserve: const Duration(milliseconds: 60),
      ende: ende.stream,
      pausiert: () => false,
      abgebrochen: () => false,
      fortschritt: (_) {},
      takt: _takt,
    );
    expect(ok, isTrue);
    await ende.close();
  });

  test('In der Pause zählt nichts, und ein Ende während der Pause gilt erst nach dem Weiterspielen', () async {
    final ende = StreamController<void>.broadcast();
    var pause = true;
    var summe = Duration.zero;
    unawaited(Future.delayed(const Duration(milliseconds: 20), () => ende.add(null)));
    unawaited(Future.delayed(const Duration(milliseconds: 120), () => pause = false));
    final uhr = Stopwatch()..start();
    final ok = await segmentAbwarten(
      dauer: const Duration(seconds: 30),
      ende: ende.stream,
      pausiert: () => pause,
      abgebrochen: () => false,
      fortschritt: (s) => summe += s,
      takt: _takt,
    );
    expect(ok, isTrue);
    expect(uhr.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 110)));
    expect(summe, lessThan(const Duration(milliseconds: 100)), reason: 'die Pause zählt nicht mit');
    await ende.close();
  });

  test('Abbruch beendet das Warten sofort mit false', () async {
    var abbruch = false;
    unawaited(Future.delayed(const Duration(milliseconds: 20), () => abbruch = true));
    final ok = await segmentAbwarten(
      dauer: const Duration(seconds: 30),
      pausiert: () => false,
      abgebrochen: () => abbruch,
      fortschritt: (_) {},
      takt: _takt,
    );
    expect(ok, isFalse);
  });

  test('Stand die App still (Bildschirm aus), zählt die tatsächlich vergangene Zeit, nicht die Zahl der Takte', () async {
    var t = DateTime(2026, 11, 1, 22);
    var schritte = 0;
    var summe = Duration.zero;
    final ok = await segmentAbwarten(
      dauer: const Duration(seconds: 20),
      pausiert: () => false,
      abgebrochen: () => false,
      fortschritt: (s) {
        schritte++;
        summe += s;
      },
      takt: _takt,
      // Jeder Takt „dauert“ in Wirklichkeit eine Minute, so als hätte Android die App angehalten.
      jetzt: () => t = t.add(const Duration(minutes: 1)),
    );
    expect(ok, isTrue);
    expect(schritte, lessThanOrEqualTo(2), reason: 'ein einziger Takt reicht, die Zeit stimmt trotzdem');
    expect(summe, greaterThanOrEqualTo(const Duration(seconds: 20)));
  });
}
