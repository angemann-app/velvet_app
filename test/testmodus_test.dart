import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/lust_im_traum.dart';
import 'package:velvetpulse/models/paar_abend.dart';
import 'package:velvetpulse/services/testmodus.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Testmodus.zuruecksetzen();
    Testmodus.init(await SharedPreferences.getInstance());
  });

  test('Siebenmal schnell tippen schaltet um, langsames Tippen zählt neu', () {
    final t0 = DateTime(2026, 10, 27, 20);
    for (var i = 0; i < 6; i++) {
      expect(Testmodus.tippen(jetzt: t0.add(Duration(milliseconds: 300 * i))), isNull);
    }
    expect(Testmodus.tippen(jetzt: t0.add(const Duration(milliseconds: 1800))), isTrue);
    expect(Testmodus.an, isTrue);
    // Mit langen Abständen schaltet es nicht wieder aus.
    for (var i = 1; i <= 7; i++) {
      expect(Testmodus.tippen(jetzt: t0.add(Duration(seconds: 10 * i))), isNull);
    }
    expect(Testmodus.an, isTrue);
  });

  test('Kürzt nur Stillen, Ansagen und Klangschale bleiben; Folgen alle frei', () {
    const b = PaarBaustein(id: 'x', phase: 'p', text: 't');
    final ablauf = [
      const PaarSchritt.ansage(b, Duration(seconds: 30), 0),
      const PaarSchritt.stille(Duration(minutes: 5), 1),
      const PaarSchritt.klangschale(1),
    ];
    expect(Testmodus.kuerzen(ablauf), same(ablauf), reason: 'aus: unverändert');
    expect(LustDaten.frei(5, {}), isFalse);
    Testmodus.aktiv.value = true;
    final kurz = Testmodus.kuerzen(ablauf);
    expect(kurz[0].dauer, const Duration(seconds: 30));
    expect(kurz[1].dauer, Testmodus.stille);
    expect(kurz[1].runde, 1);
    expect(kurz[2].klang, isTrue);
    expect(LustDaten.frei(5, {}), isTrue);
  });
}
