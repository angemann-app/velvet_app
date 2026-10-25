import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/einschlaf_reise.dart';
import 'package:velvetpulse/models/paar_abend.dart';

EinschlafDaten daten() {
  final json = jsonDecode(File('assets/data/einschlaf_reise.json').readAsStringSync());
  return EinschlafDaten((json['bausteine'] as List).map((b) => EinschlafBaustein.fromJson(b)).toList(), {});
}

Duration summe(List<PaarSchritt> s) => s.fold(Duration.zero, (a, x) => a + x.dauer);

void main() {
  final d = daten();
  final ids = {for (final b in d.bausteine) b.id};

  test('Jeder Schwerpunkt hat drei Bögen mit allen Fassungen und Formel, Spicy für beide Körper', () {
    for (final t in EinschlafDaten.themen) {
      for (var b = 1; b <= 3; b++) {
        for (final v in ['v1', 'v2', 'v3', 'f']) {
          expect(ids, contains('${t}_${b}_$v'));
        }
      }
      for (final k in ['vulva', 'penis']) {
        for (final s in [1, 2]) {
          expect(ids, contains('${t}_s_${k}_$s'));
        }
      }
    }
    for (final phase in ['ankommen', 'sinken', 'sinken_kurz', 'atem', 'atem_kurz', 'nachklang_stuetze', 'ausklang']) {
      expect(d.bausteine.where((b) => b.phase == phase), isNotEmpty, reason: phase);
    }
  });

  test('Lange Reisen haben mehr Runden, die Fassungen werden kürzer', () {
    expect([for (final m in EinschlafDaten.laengen) EinschlafDaten.runden(m)], [3, 4, 5]);
    expect([for (var r = 1; r <= 5; r++) EinschlafDaten.fassung(r)], ['v1', 'v2', 'v3', 'v2', 'v3']);
  });

  test('Plan: Länge stimmt, Sprechdichte nimmt ab, Ende ist Stille', () {
    for (final minuten in EinschlafDaten.laengen) {
      for (final thema in [null, ...EinschlafDaten.themen]) {
        final plan = d.planen(minuten: minuten, thema: thema, stimme: 'victoria', zufall: Random(minuten));
        final gesamt = summe(plan);
        expect((gesamt - Duration(minutes: minuten)).inSeconds.abs(), lessThan(60 * 6), reason: '$minuten $thema');
        expect(plan.last.baustein, isNull, reason: 'endet mit Stille');
        expect(plan.last.dauer, greaterThanOrEqualTo(const Duration(minutes: 4)));
        expect(plan.where((s) => s.klang), isEmpty, reason: 'kein Gong');
        // Sprechzeit im ersten Drittel größer als im letzten.
        var t0 = Duration.zero;
        var sprech = [Duration.zero, Duration.zero, Duration.zero];
        for (final s in plan) {
          final dritte = (t0.inSeconds / gesamt.inSeconds * 3).floor().clamp(0, 2);
          if (s.baustein != null) sprech[dritte] += s.dauer;
          t0 += s.dauer;
        }
        expect(sprech[0], greaterThan(sprech[2]), reason: '$minuten $thema');
        for (final s in plan) {
          if (s.baustein != null) expect(ids, contains(s.baustein!.id));
          expect(s.dauer, greaterThan(Duration.zero));
        }
      }
    }
  });

  test('Plan zu einem Schwerpunkt enthält dessen Formeln, Überrasch mich mischt drei Schwerpunkte', () {
    final plan = d.planen(minuten: 90, thema: 'welle', stimme: 'martin', zufall: Random(1));
    final gesprochen = [for (final s in plan) if (s.baustein != null) s.baustein!.id];
    expect(gesprochen, containsAll(['welle_1_f', 'welle_2_f', 'welle_3_f', 'welle_1_v1']));
    expect(gesprochen.where((i) => i.startsWith('welle_1_v')).length, 4, reason: 'je Runde einmal');
    final mix = d.planen(minuten: 60, stimme: 'martin', zufall: Random(2));
    final themen = {
      for (final s in mix)
        if (s.baustein != null && s.baustein!.id.endsWith('_f')) s.baustein!.id.split('_').first,
    };
    expect(themen.length, 3);
  });

  test('Spicy-Bausteine nur bei Spicy und passendem Körper', () {
    bool hatSpicy(List<PaarSchritt> p, [String? k]) =>
        p.any((s) => s.baustein != null && s.baustein!.id.contains('_s_${k ?? ''}'));
    final aus = d.planen(minuten: 60, thema: 'becken', koerper: 'vulva', stimme: 'victoria', zufall: Random(3));
    expect(hatSpicy(aus), isFalse);
    final neutral = d.planen(minuten: 60, thema: 'becken', koerper: 'neutral', spicy: true, stimme: 'victoria', zufall: Random(3));
    expect(hatSpicy(neutral), isFalse);
    final vulva = d.planen(minuten: 60, thema: 'becken', koerper: 'vulva', spicy: true, stimme: 'victoria', zufall: Random(3));
    expect(hatSpicy(vulva, 'vulva'), isTrue);
    expect(hatSpicy(vulva, 'penis'), isFalse);
    final penis = d.planen(minuten: 120, thema: 'welle', koerper: 'penis', spicy: true, stimme: 'martin', zufall: Random(4));
    expect(hatSpicy(penis, 'penis'), isTrue);
  });
}
