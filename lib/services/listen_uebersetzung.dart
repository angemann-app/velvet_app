import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/couple_channel_models.dart';
import '../models/yes_no_maybe_models.dart';
import 'sprache.dart';
import 'storage_service.dart';

/// Die Ja/Nein/Vielleicht-Liste und die Fantasie-Optionen stehen auf Deutsch im Code
/// (yes_no_maybe_models.dart, couple_channel_models.dart) – das ist die Quelle für die Übersetzung.
/// Auf Englisch werden die Texte aus translations/en/ per id darübergelegt; Fehlendes bleibt deutsch.
class ListenUebersetzung {
  static Map<String, Map<String, dynamic>> _kategorien = {};
  static Map<String, Map<String, dynamic>> _eintraege = {};
  static Map<String, Map<String, dynamic>> _fantasien = {};

  static Future<void> laden() async {
    _kategorien = {};
    _eintraege = {};
    _fantasien = {};
    if (!Sprache.englisch) return;
    try {
      final ynm = jsonDecode(await rootBundle.loadString('translations/en/yes_no_maybe.json'));
      for (final c in ynm['categories'] as List) {
        _kategorien[c['id'] as String] = Map<String, dynamic>.from(c as Map);
        for (final i in c['items'] as List) {
          _eintraege[i['id'] as String] = Map<String, dynamic>.from(i as Map);
        }
      }
      final fantasy = jsonDecode(await rootBundle.loadString('translations/en/fantasy_options.json'));
      for (final o in fantasy['options'] as List) {
        _fantasien[o['id'] as String] = Map<String, dynamic>.from(o as Map);
      }
    } catch (_) {
      // Ohne Übersetzung bleibt es eben deutsch.
    }
  }

  static String _text(Map<String, Map<String, dynamic>> quelle, String id, String feld, String deutsch) =>
      (quelle[id]?[feld] as String?) ?? deutsch;

  /// Die sichtbaren Kategorien: Spicy-Kategorien nur bei eingeschaltetem Spicy-Modus.
  static List<YesNoMaybeCategory> get kategorien {
    final sichtbar = [
      for (final c in velvetYesNoMaybeCategories)
        if (!c.spicy || StorageService.spicyMode()) c,
    ];
    if (_kategorien.isEmpty) return sichtbar;
    return [
      for (final c in sichtbar)
        YesNoMaybeCategory(
          spicy: c.spicy,
          id: c.id,
          title: _text(_kategorien, c.id, 'title', c.title),
          description: _text(_kategorien, c.id, 'description', c.description),
          icon: c.icon,
          image: c.image,
          items: [
            for (final i in c.items)
              YesNoMaybeItem(
                id: i.id,
                categoryId: i.categoryId,
                lessonId: i.lessonId,
                image: i.image,
                text: _text(_eintraege, i.id, 'text', i.text),
                explanation: _text(_eintraege, i.id, 'explanation', i.explanation),
              ),
          ],
        ),
    ];
  }

  static List<YesNoMaybeItem> get eintraege => [for (final c in kategorien) ...c.items];

  static List<FantasyOption> get fantasien {
    if (_fantasien.isEmpty) return defaultFantasyOptions;
    return [
      for (final o in defaultFantasyOptions)
        FantasyOption(
          id: o.id,
          icon: o.icon,
          title: _text(_fantasien, o.id, 'title', o.title),
          subtitle: _text(_fantasien, o.id, 'subtitle', o.subtitle),
          tag: _text(_fantasien, o.id, 'tag', o.tag),
        ),
    ];
  }
}
