import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/paar_abend.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Abende treffen die gewählte Dauer und bleiben in der gewählten Tiefe', () async {
    final daten = await PaarAbendDaten.laden();
    for (final minuten in [20, 30, 45]) {
      for (final tiefe in PaarTiefe.values) {
        for (var seed = 0; seed < 20; seed++) {
          final ablauf = daten.planen(minuten: minuten, tiefe: tiefe, stimme: 'victoria', zufall: Random(seed));
          final gesamt = ablauf.fold<Duration>(Duration.zero, (s, x) => s + x.dauer);
          expect(gesamt.inSeconds, closeTo(minuten * 60, 90), reason: '$minuten Min., $tiefe');

          final erlaubt = erlaubteTiefen(tiefe);
          final zonen = ablauf.map((s) => s.baustein).whereType<PaarBaustein>().where((b) => b.phase == 'beruehren');
          expect(zonen.every((b) => erlaubt.contains(b.tiefe)), isTrue);
          final bausteine = ablauf.map((s) => s.baustein).whereType<PaarBaustein>().toList();
          // Bausteine einer Spicy-Stufe nur bei genau dieser Stufe.
          final fremd = {'spicy', 'sehrSpicy'}..remove(tiefe.name);
          expect(bausteine.any((b) => fremd.contains(b.tiefe)), isFalse, reason: '$tiefe');
          if (tiefe.istSpicy) {
            expect(zonen.any((b) => b.tiefe == 'bekleidet'), isFalse, reason: 'Spicy beginnt auf der Haut');
            expect(zonen.any((b) => b.tiefe == tiefe.name), isTrue);
            for (final p in ['ankommen', 'runde_start', 'check_in', 'runde_ende', 'wechsel', 'ausklang']) {
              expect(bausteine.where((b) => b.phase == p).every((b) => b.tiefe == tiefe.name), isTrue, reason: p);
            }
          }
          // Jeder Baustein höchstens einmal pro Abend.
          final ids = ablauf.map((s) => s.baustein?.id).whereType<String>().where((id) => !id.startsWith('erinnerung'));
          expect(ids.toSet().length, ids.length);
        }
      }
    }
  });

  test('Spicy: Brust-Bausteine nur in Runden, in denen eine Frau empfängt, dort aber immer', () async {
    final daten = await PaarAbendDaten.laden();
    for (final tiefe in [PaarTiefe.spicy, PaarTiefe.sehrSpicy]) {
      for (final minuten in [20, 30, 45]) {
        for (var seed = 0; seed < 10; seed++) {
          List<PaarBaustein> brueste(List<String?> empfaenger, int runde) => daten
              .planen(minuten: minuten, tiefe: tiefe, stimme: 'martin', empfaenger: empfaenger, zufall: Random(seed))
              .where((s) => s.runde == runde && s.baustein?.zone == 'brueste')
              .map((s) => s.baustein!)
              .toList();
          expect(brueste(['vulva', 'penis'], 1), hasLength(1), reason: '$tiefe $minuten');
          expect(brueste(['vulva', 'penis'], 1).single.tiefe, tiefe.name);
          expect(brueste(['vulva', 'penis'], 2), isEmpty);
          expect(brueste([null, null], 1) + brueste([null, null], 2), isEmpty, reason: 'unbekannt: neutral');
        }
      }
    }
  });

  test('Der nächste Abend bevorzugt andere Berührungen', () async {
    final daten = await PaarAbendDaten.laden();
    Set<String> beruehrungen(List<PaarSchritt> ablauf) =>
        ablauf.map((s) => s.baustein).whereType<PaarBaustein>().where((b) => b.phase == 'beruehren').map((b) => b.id).toSet();
    final erster = daten.planen(minuten: 30, tiefe: PaarTiefe.haut, stimme: 'martin', zufall: Random(1));
    final ids = erster.map((s) => s.baustein?.id).whereType<String>().toSet();
    final zweiter = daten.planen(
        minuten: 30, tiefe: PaarTiefe.haut, stimme: 'martin', zuletzt: ids, zufall: Random(2));
    final wieder = beruehrungen(zweiter).intersection(beruehrungen(erster));
    expect(wieder.length, lessThan(beruehrungen(erster).length ~/ 2));
  });
}
