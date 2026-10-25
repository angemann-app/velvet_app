import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/t.dart';
import '../services/sprache.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Ein Abschnitt der Anleitung (assets/data/anleitung.json, Englisch in translations/en/).
class AnleitungAbschnitt {
  final String id;
  final String icon;
  final String titel;
  final String text;

  const AnleitungAbschnitt(this.id, this.icon, this.titel, this.text);

  static Future<List<AnleitungAbschnitt>> laden() async {
    final daten = jsonDecode(await rootBundle.loadString(Sprache.inhalt('anleitung.json')));
    return [
      for (final a in daten['abschnitte'] as List)
        AnleitungAbschnitt(a['id'] as String, a['icon'] as String, a['titel'] as String, a['text'] as String),
    ];
  }
}

const _icons = {
  'flag': Icons.flag_rounded,
  'school': Icons.school_rounded,
  'spa': Icons.spa_rounded,
  'fitness': Icons.fitness_center_rounded,
  'psychology': Icons.psychology_rounded,
  'favorite': Icons.favorite_rounded,
  'flame': Icons.local_fire_department_rounded,
  'chat': Icons.chat_bubble_rounded,
  'lock': Icons.lock_rounded,
  'update': Icons.system_update_rounded,
  'language': Icons.translate_rounded,
  'help': Icons.help_rounded,
};

/// „So funktioniert VelvetPulse“: aufklappbare Abschnitte zu allen Bereichen der App.
class AnleitungScreen extends StatelessWidget {
  const AnleitungScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, title: Text(t.anleitungTitel)),
      body: FutureBuilder<List<AnleitungAbschnitt>>(
        future: AnleitungAbschnitt.laden(),
        builder: (context, snap) {
          final abschnitte = snap.data;
          if (abschnitte == null) return const Center(child: CircularProgressIndicator(color: AppTheme.sageGreen));
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            children: [
              Text(t.anleitungEinleitung,
                  style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.45)),
              const SizedBox(height: 14),
              for (final a in abschnitte)
                // Den Spicy-Abschnitt sieht nur, wer den Modus an hat; alle anderen sehen nur, dass es ihn gibt.
                if (a.id != 'spicy' || StorageService.spicyMode()) _karte(a) else _spicyHinweis(),
            ],
          );
        },
      ),
    );
  }

  Widget _karte(AnleitungAbschnitt a) => Card(
        color: AppTheme.surface,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          leading: Icon(_icons[a.icon] ?? Icons.info_rounded,
              color: a.id == 'spicy' ? AppTheme.rose : AppTheme.sageGreen),
          title: Text(a.titel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          iconColor: AppTheme.textSecondary,
          collapsedIconColor: AppTheme.textMuted,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final absatz in a.text.split('\n'))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(absatz,
                    style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.5)),
              ),
          ],
        ),
      );

  Widget _spicyHinweis() => Card(
        color: AppTheme.surface,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: ListTile(
          leading: const Icon(Icons.local_fire_department_rounded, color: AppTheme.textMuted),
          title: Text(t.spicyModus,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          subtitle: Text(t.spicyModusText, style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary)),
        ),
      );
}
