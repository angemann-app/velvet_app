import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/models/selbst_reise.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Reisen treffen die Dauer, bleiben in der Tiefe und beim gewählten Körper', () async {
    final daten = await SelbstReiseDaten.laden();
    for (final minuten in [10, 20, 30]) {
      for (final tiefe in PaarTiefe.values) {
        for (final koerper in ['vulva', 'penis']) {
          for (var seed = 0; seed < 15; seed++) {
            final ablauf = daten.planen(
                minuten: minuten, tiefe: tiefe, koerper: koerper, stimme: 'victoria', zufall: Random(seed));
            final gesamt = ablauf.fold<Duration>(Duration.zero, (s, x) => s + x.dauer);
            expect(gesamt.inSeconds, closeTo(minuten * 60, 90), reason: '$minuten Min., $tiefe, $koerper');

            final erlaubt = erlaubteTiefen(tiefe);
            final bausteine = ablauf.map((s) => s.baustein).whereType<PaarBaustein>().toList();
            final beruehren = bausteine.where((b) => b.phase == 'beruehren');
            expect(beruehren.every((b) => erlaubt.contains(b.tiefe)), isTrue);
            expect(beruehren.every((b) => b.koerper == null || b.koerper == koerper), isTrue);

            final genital = beruehren.where((b) => b.zone == 'genital').toList();
            if (tiefe.index >= PaarTiefe.intim.index) {
              expect(genital.first.id, endsWith('_1'), reason: 'Beginnt mit dem ruhigen Auflegen der Hand');
              expect(bausteine.any((b) => b.phase == 'welle'), isTrue);
            } else {
              expect(genital, isEmpty);
            }

            // Bausteine einer Spicy-Stufe nur bei genau dieser Stufe.
            final fremd = {'spicy', 'sehrSpicy'}..remove(tiefe.name);
            expect(bausteine.any((b) => fremd.contains(b.tiefe)), isFalse, reason: '$tiefe');
            if (tiefe.istSpicy) {
              expect(bausteine.where((b) => b.phase == 'hoehepunkt'), hasLength(1));
              expect(beruehren.any((b) => b.tiefe == 'bekleidet'), isFalse, reason: 'Spicy beginnt auf der Haut');
              expect(beruehren.any((b) => b.tiefe == tiefe.name), isTrue);
              for (final p in ['ankommen', 'welle', 'hoehepunkt', 'ausklang']) {
                expect(bausteine.where((b) => b.phase == p).every((b) => b.tiefe == tiefe.name), isTrue, reason: p);
              }
            } else {
              expect(bausteine.any((b) => b.phase == 'hoehepunkt'), isFalse);
            }

            final ids = bausteine.map((b) => b.id).where((id) => !id.startsWith('erinnerung'));
            expect(ids.toSet().length, ids.length);
          }
        }
      }
    }
  });
}
