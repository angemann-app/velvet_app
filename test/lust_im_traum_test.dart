import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/einschlaf_reise.dart';
import 'package:velvetpulse/models/lust_im_traum.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/models/traum_reise.dart';

// Die echten Texte liegen nie im Repository (nur im Paket); der Test baut Platzhalter mit derselben Struktur.
LustDaten platzhalter() {
  final b = <LustBaustein>[];
  for (var f = 1; f <= LustDaten.folgen; f++) {
    for (final k in ['vulva', 'penis']) {
      for (final teil in ['v1', 'v2', 'v3', 'f', 'tag']) {
        b.add(LustBaustein(id: 'f${f}_${k}_$teil', phase: 'folge', text: 'Platzhalter. ' * 20, folge: f, koerper: k, teil: teil));
      }
      if (f >= LustDaten.abFolgeTraumkoerper) {
        for (final g in ['frau', 'mann', 'offen']) {
          b.add(LustBaustein(
              id: 'f${f}_${k}_${g}_v1', phase: 'folge', text: 'Platzhalter. ' * 20, folge: f, koerper: k, teil: 'v1', gegenueber: g));
        }
      }
    }
  }
  for (final k in ['vulva', 'penis']) {
    for (final n in [1, 2]) {
      b.add(LustBaustein(id: 'uebergang_${k}_$n', phase: 'uebergang', text: 'Platzhalter. ' * 15, koerper: k));
    }
  }
  return LustDaten(b, {});
}

EinschlafDaten einschlaf() {
  final json = jsonDecode(File('assets/data/einschlaf_reise.json').readAsStringSync());
  return EinschlafDaten((json['bausteine'] as List).map((b) => EinschlafBaustein.fromJson(b)).toList(), {});
}

TraumDaten traum() {
  final json = jsonDecode(File('assets/data/traum_reise.json').readAsStringSync());
  return TraumDaten((json['bausteine'] as List).map((b) => TraumBaustein.fromJson(b)).toList(), {});
}

List<String> ids(List<PaarSchritt> plan) => [for (final s in plan) if (s.baustein != null) s.baustein!.id];
Duration summe(List<PaarSchritt> s) => s.fold(Duration.zero, (a, x) => a + x.dauer);

void main() {
  final d = platzhalter();
  final e = einschlaf();
  final tr = traum();

  test('Freischaltung: Folge 1 immer, die nächste nach zwei Abenden, spätere bleiben nach Wiederholen frei', () {
    expect(LustDaten.frei(1, {}), isTrue);
    expect(LustDaten.frei(2, {}), isFalse);
    expect(LustDaten.frei(2, {1: 1}), isFalse);
    expect(LustDaten.frei(2, {1: 2}), isTrue);
    expect(LustDaten.frei(3, {1: 2}), isFalse);
    // Wer Folge 4 schon gehört hat, verliert sie nicht wieder.
    expect(LustDaten.frei(4, {1: 2, 2: 2, 3: 1, 4: 1}), isTrue);
  });

  test('Folge 1 und 2 richten sich nach dem Körper im Bett, ohne Übergang und ohne Gegenüber', () {
    final plan = d.planen(
        einschlaf: e, traum: tr, minuten: 45, folge: 2, bettKoerper: 'penis', traumKoerper: 'vulva', gegenueber: 'frau',
        stimme: 'martin', zufall: Random(1));
    final gesprochen = ids(plan);
    expect(gesprochen, containsAllInOrder(['f2_penis_v1', 'f2_penis_v2', 'f2_penis_v3', 'f2_penis_f']));
    expect(gesprochen.any((id) => id.startsWith('uebergang') || id.contains('vulva') || id.contains('frau')), isFalse);
    expect(gesprochen.any((id) => id.startsWith('f2_penis_tag')), isFalse, reason: 'Die Tagesübung steht nur als Text da');
  });

  test('Ab Folge 3: Übergang in den Traumkörper und Fassung mit Gegenüber', () {
    final plan = d.planen(
        einschlaf: e, traum: tr, minuten: 45, folge: 4, bettKoerper: 'vulva', traumKoerper: 'penis', gegenueber: 'mann',
        stimme: 'victoria', zufall: Random(2));
    final gesprochen = ids(plan);
    final uebergang = gesprochen.indexWhere((id) => id.startsWith('uebergang_penis_'));
    expect(uebergang, isNonNegative);
    expect(gesprochen.indexOf('f4_penis_mann_v1'), greaterThan(uebergang));
    expect(gesprochen, containsAllInOrder(['f4_penis_mann_v1', 'f4_penis_v2', 'f4_penis_v3', 'f4_penis_f']));
    expect(gesprochen.contains('f4_penis_v1'), isFalse);
  });

  test('Länge stimmt, Ende ist Stille, die Absicht kehrt im Nachklang wieder', () {
    for (final minuten in LustDaten.laengen) {
      for (var folge = 1; folge <= LustDaten.folgen; folge++) {
        final plan = d.planen(
            einschlaf: e, traum: tr, minuten: minuten, folge: folge, bettKoerper: 'vulva', stimme: 'victoria',
            zufall: Random(folge));
        final grund = '$minuten Min, Folge $folge';
        expect((summe(plan) - Duration(minutes: minuten)).inSeconds.abs(), lessThan(60 * 6), reason: grund);
        expect(plan.last.baustein, isNull, reason: grund);
        expect(plan.last.dauer, greaterThanOrEqualTo(const Duration(minutes: 4)), reason: grund);
        expect(ids(plan).where((id) => id == 'f${folge}_vulva_f').length, greaterThanOrEqualTo(3), reason: grund);
      }
    }
  });
}
