import 'package:shared_preferences/shared_preferences.dart';

/// Geführte Audios nach Anlass statt nach Technik (docs/konzepte/audio-gruppen.md).
enum AudioGruppe { fuerMich, fuerUns, nacht, geschichten }

class AudioGruppen {
  static const _schluessel = 'audio_gruppe_zuletzt';

  static bool abends(DateTime jetzt) => jetzt.hour >= 18 || jetzt.hour < 5;

  /// Gruppen ohne sichtbaren Inhalt verschwinden: „Für uns“ nur mit Paar-Bezug, „Geschichten“ nur im Spicy-Modus.
  static List<AudioGruppe> sichtbar({required bool spicy, required bool paar}) => [
        AudioGruppe.fuerMich,
        if (paar) AudioGruppe.fuerUns,
        AudioGruppe.nacht,
        if (spicy) AudioGruppe.geschichten,
      ];

  /// Abends und nachts steht „Nacht“ vorn, sonst „Für mich“; die übrigen folgen in fester Reihenfolge.
  static List<AudioGruppe> reihenfolge(DateTime jetzt, {required bool spicy, required bool paar}) {
    final liste = sichtbar(spicy: spicy, paar: paar);
    if (abends(jetzt)) {
      return [AudioGruppe.nacht, ...liste.where((g) => g != AudioGruppe.nacht)];
    }
    return liste;
  }

  /// Tageszeit plus zuletzt geöffnete Gruppe (nur wenn sie heute war, sichtbar ist und zur Tageszeit passt;
  /// „Nacht“ tagsüber nie). Ohne Treffer gilt die Gruppe der Tageszeit.
  static AudioGruppe empfehlung(DateTime jetzt,
      {required bool spicy, required bool paar, AudioGruppe? zuletzt, DateTime? zuletztZeit}) {
    final sicht = sichtbar(spicy: spicy, paar: paar);
    final heute = zuletztZeit != null && jetzt.difference(zuletztZeit).inHours < 24 && jetzt.day == zuletztZeit.day;
    if (zuletzt != null &&
        heute &&
        sicht.contains(zuletzt) &&
        (zuletzt != AudioGruppe.nacht || abends(jetzt))) {
      return zuletzt;
    }
    return abends(jetzt) ? AudioGruppe.nacht : AudioGruppe.fuerMich;
  }

  /// Nur eine Annehmlichkeit dieses Geräts, kein Inhalt: bewusst nicht in der Sicherung.
  static Future<(AudioGruppe, DateTime)?> zuletztGeoeffnet() async {
    try {
      final w = (await SharedPreferences.getInstance()).getString(_schluessel);
      if (w == null) return null;
      final teile = w.split('|');
      final g = AudioGruppe.values.asNameMap()[teile[0]];
      final z = DateTime.tryParse(teile[1]);
      return g == null || z == null ? null : (g, z);
    } catch (_) {
      return null;
    }
  }

  static Future<void> merken(AudioGruppe g, [DateTime? zeit]) async {
    try {
      await (await SharedPreferences.getInstance())
          .setString(_schluessel, '${g.name}|${(zeit ?? DateTime.now()).toIso8601String()}');
    } catch (_) {}
  }
}
