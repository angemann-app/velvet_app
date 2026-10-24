import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'update_service.dart';

/// Ein Punkt auf dem „Was ist neu“-Bildschirm.
class WhatsNewItem {
  final String icon;
  final String title;
  final String text;

  const WhatsNewItem(this.icon, this.title, this.text);
}

class WhatsNewEntry {
  final int build;
  final String version;
  final List<WhatsNewItem> items;

  const WhatsNewEntry(this.build, this.version, this.items);

  factory WhatsNewEntry.fromJson(Map<String, dynamic> json) => WhatsNewEntry(
        json['build'] as int,
        json['version'] as String,
        [
          for (final p in json['punkte'] as List)
            WhatsNewItem(p['icon'] as String, p['titel'] as String, p['text'] as String),
        ],
      );
}

/// Merkt sich, welche Version zuletzt begrüßt wurde, und liefert nach einem Update
/// die Neuigkeiten aus assets/data/neuigkeiten.json.
class WhatsNew {
  static const _keySeen = 'whats_new_seen_build';

  /// Neuinstallation: nichts zeigen, nur die aktuelle Version als gesehen merken.
  static Future<void> markInstalled() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(_keySeen) == null) await prefs.setInt(_keySeen, await UpdateService.installedBuild());
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySeen, await UpdateService.installedBuild());
  }

  /// Einträge seit der zuletzt begrüßten Version, neueste zuerst. Leer, wenn es nichts Neues gibt.
  static Future<List<WhatsNewEntry>> pending() async {
    final prefs = await SharedPreferences.getInstance();
    final current = await UpdateService.installedBuild();
    // Wer von einer Version ohne diesen Bildschirm kommt, hat noch keinen Wert: dann nur den neuesten Eintrag.
    final seen = prefs.getInt(_keySeen);
    if (seen != null && seen >= current) return [];
    final entries = await load();
    final relevant = entries.where((e) => e.build <= current && (seen == null || e.build > seen)).toList()
      ..sort((a, b) => b.build.compareTo(a.build));
    return seen == null ? relevant.take(1).toList() : relevant;
  }

  static Future<List<WhatsNewEntry>> load() async {
    final data = jsonDecode(await rootBundle.loadString('assets/data/neuigkeiten.json'));
    return [for (final e in data['eintraege'] as List) WhatsNewEntry.fromJson(e)];
  }
}
