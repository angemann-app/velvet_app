import 'dart:convert';
import 'dart:io';

import '../services/pakete.dart';

/// Die drei Hörbegleitungen der Traumpraxis (Abend, Klarheit, Morgen). Inhalt und Aufnahmen liegen im
/// signierten Geführt-Paket unter `audio/traum/traumpraxis.json`, nicht im App-Code. Nur Spicy, 18+.
class PraxisBegleitung {
  static const ids = ['praxis_abend', 'praxis_klarheit', 'praxis_morgen'];
  static const stimmen = ['victoria', 'martin'];
  static const katalogPfad = 'audio/traum/traumpraxis.json';

  final String id;
  final String titel;
  final String phase;
  final String text;
  final Map<String, ({String pfad, int dauerMs})> aufnahmen;

  const PraxisBegleitung(
      {required this.id,
      required this.titel,
      required this.phase,
      required this.text,
      required this.aufnahmen});

  static String pfadFuer(String stimme, String id) =>
      'audio/traum/${stimme}_$id.opus';

  /// Streng: nur bekannte IDs und Stimmen, Pfade genau nach Schema, Dauer in sinnvollem Bereich.
  /// Wirft [FormatException], sonst entsteht nie ein halber Katalog.
  static List<PraxisBegleitung> ausJson(Map<String, dynamic> j) {
    if (j['version'] != 1 || j['spicy'] != true || j['mindestalter'] != 18) {
      throw const FormatException('Katalog nicht als Spicy 18+ gekennzeichnet');
    }
    final roh = j['eintraege'];
    if (roh is! List || roh.length != ids.length) {
      throw const FormatException('Katalog unvollständig');
    }
    final liste = <PraxisBegleitung>[];
    for (final e in roh) {
      if (e is! Map) throw const FormatException('Eintrag ungültig');
      final id = e['id'];
      if (id is! String || !ids.contains(id) || liste.any((b) => b.id == id)) {
        throw const FormatException('Unbekannte Begleitung');
      }
      if (e['spicy'] != true) {
        throw const FormatException('Begleitung nicht als Spicy gekennzeichnet');
      }
      final titel = e['titel'], phase = e['phase'], text = e['text'];
      if (titel is! String || titel.isEmpty || titel.length > 120 ||
          phase is! String || text is! String) {
        throw const FormatException('Eintrag ungültig');
      }
      final a = e['aufnahmen'];
      if (a is! Map || a.length != stimmen.length) {
        throw const FormatException('Aufnahmen ungültig');
      }
      final aufnahmen = <String, ({String pfad, int dauerMs})>{};
      for (final s in stimmen) {
        final x = a[s];
        if (x is! Map ||
            x['pfad'] != pfadFuer(s, id) ||
            x['dauerMs'] is! int ||
            x['dauerMs'] < 1000 ||
            x['dauerMs'] > 3600000) {
          throw const FormatException('Aufnahme ungültig');
        }
        aufnahmen[s] = (pfad: x['pfad'] as String, dauerMs: x['dauerMs'] as int);
      }
      liste.add(PraxisBegleitung(
          id: id, titel: titel, phase: phase, text: text, aufnahmen: aufnahmen));
    }
    return List.unmodifiable(liste);
  }

  /// Katalog aus dem installierten Geführt-Paket der Sprache; null, solange das Paket fehlt oder der
  /// Katalog nicht gültig ist.
  static Future<List<PraxisBegleitung>?> laden({String? sprache}) async {
    final datei = Pakete.datei(katalogPfad, sprache: sprache);
    if (datei == null) return null;
    try {
      return ausJson(
          jsonDecode(await File(datei).readAsString()) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
