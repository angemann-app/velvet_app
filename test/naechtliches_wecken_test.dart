import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/traum_reise.dart';
import 'package:velvetpulse/services/naechtliches_wecken.dart';
import 'package:velvetpulse/services/storage_service.dart';

TraumDaten ladeTraumDaten() {
  final json = jsonDecode(File('assets/data/traum_reise.json').readAsStringSync());
  final dauerRaw = jsonDecode(File('assets/audio/traum/dauer.json').readAsStringSync()) as Map;
  final dauer = dauerRaw.map((k, v) => MapEntry(k as String, v as int));
  return TraumDaten((json['bausteine'] as List).map((b) => TraumBaustein.fromJson(b)).toList(), dauer);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('Wochenregel (höchstens zweimal pro Woche)', () {
    test('erlaubt Wecken bei 0 oder 1 Nutzung in den letzten 7 Tagen', () {
      final jetzt = DateTime(2026, 10, 27, 22, 0);
      expect(NaechtlichesWecken.darfHeuteWecken(const [], jetzt: jetzt), isTrue);

      final einmal = [DateTime(2026, 10, 25, 4, 0)];
      expect(NaechtlichesWecken.anzahlInLetzterWoche(einmal, jetzt: jetzt), 1);
      expect(NaechtlichesWecken.darfHeuteWecken(einmal, jetzt: jetzt), isTrue);
    });

    test('sperrt Wecken nach 2 Nutzungen innerhalb von 7 Tagen', () {
      final jetzt = DateTime(2026, 10, 27, 22, 0);
      final zweimal = [
        DateTime(2026, 10, 26, 4, 30),
        DateTime(2026, 10, 22, 3, 45),
      ];
      expect(NaechtlichesWecken.anzahlInLetzterWoche(zweimal, jetzt: jetzt), 2);
      expect(NaechtlichesWecken.darfHeuteWecken(zweimal, jetzt: jetzt), isFalse);
    });

    test('gibt Wecken wieder frei, sobald ältere Einträge mehr als 7 Tage zurückliegen', () {
      final jetzt = DateTime(2026, 10, 27, 22, 0);
      final verlauf = [
        DateTime(2026, 10, 25, 4, 0), // vor 2 Tagen
        DateTime(2026, 10, 18, 4, 0), // vor 9 Tagen (außerhalb des 7-Tage-Fensters)
        DateTime(2026, 10, 12, 4, 0), // vor 15 Tagen
      ];
      expect(NaechtlichesWecken.anzahlInLetzterWoche(verlauf, jetzt: jetzt), 1);
      expect(NaechtlichesWecken.darfHeuteWecken(verlauf, jetzt: jetzt), isTrue);
    });
  });

  group('Weckzeit-Berechnung und Planung', () {
    test('schlägt Uhrzeit 5 Stunden nach dem Start vor', () {
      final start = DateTime(2026, 10, 27, 23, 15);
      final vorschlag = NaechtlichesWecken.schlageWeckzeitVor(start: start);
      expect(vorschlag, DateTime(2026, 10, 28, 4, 15));
      expect(NaechtlichesWecken.formatUhrzeit(vorschlag), '04:15');
    });

    test('berechneZielZeit wählt den nächsten Morgen, wenn die Uhrzeit vor dem Abend liegt', () {
      final abend = DateTime(2026, 10, 27, 22, 30);
      final ziel = NaechtlichesWecken.berechneZielZeit(const TimeOfDay(hour: 4, minute: 0), jetzt: abend);
      expect(ziel, DateTime(2026, 10, 28, 4, 0));
    });

    test('planen speichert Termin, öffnet System-Wecker mit neutralem Namen und beachtet Wochenregel', () async {
      final jetzt = DateTime(2026, 10, 27, 22, 0);
      final ziel1 = DateTime(2026, 10, 28, 3, 30);
      DateTime? uebergebeneZeit;
      String? uebergebenerTitel;

      final erfolg1 = await NaechtlichesWecken.planen(
        ziel1,
        titel: 'Kurzer Moment',
        jetzt: jetzt,
        intentLauncher: (z, t) async {
          uebergebeneZeit = z;
          uebergebenerTitel = t;
        },
      );

      expect(erfolg1, isTrue);
      expect(uebergebeneZeit, ziel1);
      expect(uebergebenerTitel, 'Kurzer Moment');
      expect(NaechtlichesWecken.istWeckenAktiv(jetzt: ziel1), isTrue);

      await NaechtlichesWecken.begleitungAbschliessen();
      expect(NaechtlichesWecken.istWeckenAktiv(jetzt: ziel1), isFalse);

      // Zweites Wecken in derselben Woche klappt noch
      final ziel2 = DateTime(2026, 10, 30, 4, 0);
      final erfolg2 = await NaechtlichesWecken.planen(
        ziel2,
        titel: 'Kurzer Moment',
        jetzt: DateTime(2026, 10, 29, 23, 0),
        intentLauncher: (_, __) async {},
      );
      expect(erfolg2, isTrue);

      // Drittes Wecken innerhalb derselben 7 Tage wird abgelehnt
      final ziel3 = DateTime(2026, 11, 1, 4, 0);
      var drittesAufgerufen = false;
      final erfolg3 = await NaechtlichesWecken.planen(
        ziel3,
        titel: 'Kurzer Moment',
        jetzt: DateTime(2026, 10, 31, 23, 0),
        intentLauncher: (_, __) async => drittesAufgerufen = true,
      );
      expect(erfolg3, isFalse);
      expect(drittesAufgerufen, isFalse);
    });
  });

  group('Begleitung zum Wiedereinschlafen', () {
    test('enthält alle wecken-Bausteine, die Abend-Absicht und endet mit 10 Minuten Stille', () {
      final traum = ladeTraumDaten();
      final weckenBausteine = traum.bausteine.where((b) => b.phase == 'wecken').map((b) => b.id).toSet();
      expect(
        weckenBausteine,
        containsAll(['wecken_notieren', 'wecken_sinken_1', 'wecken_absicht', 'wecken_sinken_2']),
      );

      final plan = NaechtlichesWecken.planeBegleitung(
        traum,
        stimme: 'victoria',
        abend: 'traum:warmes_wasser',
      );

      final gesprochen = [for (final s in plan) if (s.baustein != null) s.baustein!.id];
      expect(
        gesprochen,
        containsAllInOrder([
          'wecken_notieren',
          'wecken_sinken_1',
          'warmes_wasser_f',
          'wecken_absicht',
          'wach_1',
          'wecken_sinken_2',
          'wach_absicht_1',
        ]),
      );

      // Letzter Schritt ist die 10-minütige Schlussstille für den ausblendenden Klangteppich
      expect(plan.last.baustein, isNull);
      expect(plan.last.dauer, const Duration(minutes: 10));
    });
  });
}
