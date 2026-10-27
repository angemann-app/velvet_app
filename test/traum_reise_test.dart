import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/einschlaf_reise.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/models/traum_reise.dart';

EinschlafDaten einschlaf() {
  final json = jsonDecode(File('assets/data/einschlaf_reise.json').readAsStringSync());
  return EinschlafDaten((json['bausteine'] as List).map((b) => EinschlafBaustein.fromJson(b)).toList(), {});
}

TraumDaten traum() {
  final json = jsonDecode(File('assets/data/traum_reise.json').readAsStringSync());
  return TraumDaten((json['bausteine'] as List).map((b) => TraumBaustein.fromJson(b)).toList(), {});
}

Duration summe(List<PaarSchritt> s) => s.fold(Duration.zero, (a, x) => a + x.dauer);

void main() {
  final e = einschlaf();
  final d = traum();
  final ids = {for (final b in d.bausteine) b.id};

  test('Jedes Traumbild hat alle Fassungen, Absicht und Spicy für beide Körper; Hinweise vorhanden', () {
    for (final b in TraumDaten.bilder) {
      for (final teil in ['v1', 'v2', 'v3', 'f', 's_vulva', 's_penis']) {
        expect(ids, contains('${b}_$teil'));
      }
    }
    for (final h in ['hinweis_einstieg', 'hinweis_schlafparalyse']) {
      expect(d.hinweis(h), isNotNull, reason: h);
    }
    expect(d.bausteine.where((b) => b.phase == 'sinken'), isNotEmpty);
    expect(d.bausteine.where((b) => b.phase == 'absicht'), isNotEmpty);
  });

  test('Plan: Länge stimmt, Ende ist Stille, Spicy nur wenn gewählt', () {
    for (final minuten in TraumDaten.laengen) {
      for (final bild in [null, ...TraumDaten.bilder]) {
        for (final spicy in [false, true]) {
          final plan = d.planen(
              einschlaf: e,
              minuten: minuten,
              bild: bild,
              koerper: 'vulva',
              spicy: spicy,
              stimme: 'victoria',
              zufall: Random(minuten));
          final gesamt = summe(plan);
          final grund = '$minuten $bild $spicy';
          expect((gesamt - Duration(minutes: minuten)).inSeconds.abs(), lessThan(60 * 6), reason: grund);
          expect(plan.last.baustein, isNull, reason: grund);
          expect(plan.last.dauer, greaterThanOrEqualTo(const Duration(minutes: 4)), reason: grund);
          final gesprochen = [for (final s in plan) if (s.baustein != null) s.baustein!.id];
          expect(gesprochen.any((id) => id.contains('_s_')), spicy, reason: grund);
          expect(gesprochen.any((id) => id.startsWith('hinweis')), isFalse, reason: grund);
          if (bild != null) {
            expect(gesprochen, containsAllInOrder(['${bild}_v1', '${bild}_v2', '${bild}_v3', '${bild}_f']));
          }
          // Jede Aufnahme liegt entweder in audio/traum/ oder audio/einschlaf/.
          final einschlafIds = {for (final b in e.bausteine) b.id};
          for (final id in gesprochen) {
            expect(d.istTraum(id) || einschlafIds.contains(id), isTrue, reason: id);
          }
        }
      }
    }
  });

  test('Ohne Spicy kein Körper-Baustein, auch bei Körper Penis', () {
    final plan = d.planen(einschlaf: e, minuten: 45, bild: 'begegnung', koerper: 'penis', stimme: 'martin');
    expect(plan.where((s) => s.baustein?.id.contains('_s_') ?? false), isEmpty);
  });
}
