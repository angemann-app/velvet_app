import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sprache.dart';

/// Eine Foto-Idee; [heiss] = deutlicher, dazu zeigt die Karte einen stärkeren Sicherheitshinweis.
typedef FotoIdee = ({String text, bool heiss});

/// Foto-Idee des Tages im Paar-Chat: nur im Spicy-Modus, ganz freiwillig. Keine Erinnerungen,
/// keine Serien, keine Zähler. Beide bekommen am selben Tag dieselbe Idee (Tag des Jahres);
/// „Andere Idee“ blättert nur auf dem eigenen Handy weiter.
class FotoIdeen {
  static const _keyAn = 'foto_ideen_an';
  static const _keyHeuteNicht = 'foto_ideen_heute_nicht';
  static const _keyVersatz = 'foto_ideen_versatz';

  /// Ändert sich beim Ein-/Ausschalten und bei „Heute nicht“, damit die Karte sofort folgt.
  static final ValueNotifier<int> stand = ValueNotifier(0);

  static List<FotoIdee>? _ideen;

  static Future<List<FotoIdee>> _laden() async {
    final daten = jsonDecode(await rootBundle.loadString(Sprache.inhalt('foto_ideen.json')));
    return [for (final i in daten['ideen'] as List) (text: i['text'] as String, heiss: i['heiss'] == true)];
  }

  /// Nach einem Sprachwechsel neu laden.
  static void vergessen() => _ideen = null;

  static String _tag(DateTime jetzt) => '${jetzt.year}-${jetzt.month}-${jetzt.day}';

  static int _tagDesJahres(DateTime d) => d.difference(DateTime(d.year)).inDays;

  static Future<bool> an() async => (await SharedPreferences.getInstance()).getBool(_keyAn) ?? true;

  static Future<void> setzen(bool an) async {
    await (await SharedPreferences.getInstance()).setBool(_keyAn, an);
    stand.value++;
  }

  /// Die Idee für heute, oder null, wenn ausgeschaltet oder für heute weggeklickt.
  static Future<FotoIdee?> heute({DateTime? jetzt}) async {
    final d = jetzt ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_keyAn) ?? true)) return null;
    if (prefs.getString(_keyHeuteNicht) == _tag(d)) return null;
    final ideen = _ideen ??= await _laden();
    final versatz = prefs.getString(_keyVersatz)?.split('|');
    final weiter = versatz != null && versatz.first == _tag(d) ? int.parse(versatz.last) : 0;
    return ideen[(_tagDesJahres(d) + weiter) % ideen.length];
  }

  static Future<void> heuteNicht({DateTime? jetzt}) async {
    await (await SharedPreferences.getInstance()).setString(_keyHeuteNicht, _tag(jetzt ?? DateTime.now()));
    stand.value++;
  }

  static Future<void> andereIdee({DateTime? jetzt}) async {
    final d = jetzt ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final versatz = prefs.getString(_keyVersatz)?.split('|');
    final weiter = versatz != null && versatz.first == _tag(d) ? int.parse(versatz.last) : 0;
    await prefs.setString(_keyVersatz, '${_tag(d)}|${weiter + 1}');
    stand.value++;
  }
}
