// Foto-Idee des Tages: gleich für beide, „Heute nicht“ und „Andere Idee“ wirken nur heute.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/foto_ideen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final montag = DateTime(2026, 10, 26, 9);
  final dienstag = DateTime(2026, 10, 27, 9);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FotoIdeen.vergessen();
  });

  test('Jeden Tag eine Idee, an verschiedenen Tagen verschiedene', () async {
    final heute = await FotoIdeen.heute(jetzt: montag);
    expect(heute, isNotNull);
    expect(await FotoIdeen.heute(jetzt: montag), heute, reason: 'gleiche Idee den ganzen Tag');
    expect(await FotoIdeen.heute(jetzt: dienstag), isNot(heute));
  });

  test('„Andere Idee“ blättert nur heute weiter', () async {
    final erste = await FotoIdeen.heute(jetzt: montag);
    await FotoIdeen.andereIdee(jetzt: montag);
    expect(await FotoIdeen.heute(jetzt: montag), isNot(erste));
    // Morgen wieder die gemeinsame Idee des Tages, wie beim Gegenüber.
    SharedPreferences.setMockInitialValues({});
    final morgenOhne = await FotoIdeen.heute(jetzt: dienstag);
    SharedPreferences.setMockInitialValues({'foto_ideen_versatz': '2026-10-26|1'});
    expect(await FotoIdeen.heute(jetzt: dienstag), morgenOhne);
  });

  test('Heiße und sanfte Ideen wechseln sich ab', () async {
    final woche = [
      for (var i = 0; i < 14; i++) (await FotoIdeen.heute(jetzt: montag.add(Duration(days: i))))!.heiss,
    ];
    expect(woche, contains(true));
    expect(woche, contains(false));
  });

  test('„Heute nicht“ gilt bis morgen, Ausschalten für immer', () async {
    await FotoIdeen.heuteNicht(jetzt: montag);
    expect(await FotoIdeen.heute(jetzt: montag), isNull);
    expect(await FotoIdeen.heute(jetzt: dienstag), isNotNull);
    await FotoIdeen.setzen(false);
    expect(await FotoIdeen.heute(jetzt: dienstag), isNull);
  });
}
