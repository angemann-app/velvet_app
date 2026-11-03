import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/audio_gruppen.dart';

void main() {
  final morgens = DateTime(2026, 11, 3, 9);
  final abends = DateTime(2026, 11, 3, 21);
  final nachts = DateTime(2026, 11, 4, 2);

  test('Gruppen ohne sichtbaren Inhalt verschwinden', () {
    expect(AudioGruppen.sichtbar(spicy: false, paar: false),
        [AudioGruppe.fuerMich, AudioGruppe.nacht]);
    expect(AudioGruppen.sichtbar(spicy: true, paar: true), AudioGruppe.values);
    expect(AudioGruppen.sichtbar(spicy: true, paar: false),
        isNot(contains(AudioGruppe.fuerUns)));
    expect(AudioGruppen.sichtbar(spicy: false, paar: true),
        isNot(contains(AudioGruppe.geschichten)));
  });

  test('Reihenfolge nach Tageszeit: abends und nachts steht Nacht vorn', () {
    expect(AudioGruppen.reihenfolge(morgens, spicy: true, paar: true).first,
        AudioGruppe.fuerMich);
    for (final z in [abends, nachts]) {
      final r = AudioGruppen.reihenfolge(z, spicy: true, paar: true);
      expect(r.first, AudioGruppe.nacht);
      expect(r.toSet(), AudioGruppe.values.toSet());
      expect(r.length, 4);
    }
  });

  test('Empfehlung: Tageszeit, sonst heute zuletzt geöffnete sichtbare Gruppe', () {
    expect(AudioGruppen.empfehlung(morgens, spicy: false, paar: false),
        AudioGruppe.fuerMich);
    expect(AudioGruppen.empfehlung(abends, spicy: false, paar: false),
        AudioGruppe.nacht);
    expect(
        AudioGruppen.empfehlung(abends,
            spicy: true,
            paar: true,
            zuletzt: AudioGruppe.fuerUns,
            zuletztZeit: DateTime(2026, 11, 3, 19)),
        AudioGruppe.fuerUns);
    // gestern zählt nicht
    expect(
        AudioGruppen.empfehlung(abends,
            spicy: true,
            paar: true,
            zuletzt: AudioGruppe.fuerUns,
            zuletztZeit: DateTime(2026, 11, 2, 19)),
        AudioGruppe.nacht);
    // unsichtbare Gruppe wird nie empfohlen
    expect(
        AudioGruppen.empfehlung(morgens,
            spicy: false,
            paar: false,
            zuletzt: AudioGruppe.geschichten,
            zuletztZeit: DateTime(2026, 11, 3, 8)),
        AudioGruppe.fuerMich);
    // Nacht tagsüber nie
    expect(
        AudioGruppen.empfehlung(morgens,
            spicy: false,
            paar: false,
            zuletzt: AudioGruppe.nacht,
            zuletztZeit: DateTime(2026, 11, 3, 8)),
        AudioGruppe.fuerMich);
  });

  test('Zuletzt geöffnete Gruppe wird gemerkt und fehlerhafte Werte ignoriert', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    expect(await AudioGruppen.zuletztGeoeffnet(), isNull);
    final z = DateTime(2026, 11, 3, 20, 15);
    await AudioGruppen.merken(AudioGruppe.nacht, z);
    expect(await AudioGruppen.zuletztGeoeffnet(), (AudioGruppe.nacht, z));
    SharedPreferences.setMockInitialValues({'audio_gruppe_zuletzt': 'quatsch|kein-datum'});
    expect(await AudioGruppen.zuletztGeoeffnet(), isNull);
  });
}
