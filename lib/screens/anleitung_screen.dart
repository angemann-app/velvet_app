import 'dart:convert';

import 'package:flutter/material.dart';
import '../theme/vp_tokens.dart';
import 'package:flutter/services.dart';

import '../l10n/t.dart';
import '../services/sprache.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'rueckmeldung_screen.dart';

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
  'flame': Icons.bolt_outlined,
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
      backgroundColor: AppTheme.papier,
      appBar: AppBar(backgroundColor: AppTheme.papier, title: Text(t.anleitungTitel)),
      body: FutureBuilder<List<AnleitungAbschnitt>>(
        future: AnleitungAbschnitt.laden(),
        builder: (context, snap) {
          final abschnitte = snap.data;
          if (abschnitte == null) return Center(child: CircularProgressIndicator(color: AppTheme.akzentTief));
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            children: [
              Text(t.anleitungEinleitung,
                  style: TextStyle(fontSize: 14, color: AppTheme.tinteLeise, height: 1.45)),
              const SizedBox(height: 14),
              for (final a in abschnitte)
                // Den Spicy-Abschnitt sieht nur, wer den Modus an hat; alle anderen sehen nur, dass es ihn gibt.
                if (a.id != 'spicy' || StorageService.spicyMode()) _karte(a) else _spicyHinweis(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RueckmeldungScreen())),
                icon: const Icon(Icons.campaign_outlined),
                label: Text(t.rueckmeldungTitel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.akzentTief,
                  minimumSize: const Size.fromHeight(48),
                  side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _karte(AnleitungAbschnitt a) => Card(
        color: AppTheme.papierErhoben,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VpRadius.karte),
          side: BorderSide(color: AppTheme.linie),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          leading: Icon(_icons[a.icon] ?? Icons.info_rounded,
              color: a.id == 'spicy' ? AppTheme.akzentTief : AppTheme.akzentTief),
          title: Text(a.titel,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
          iconColor: AppTheme.tinteLeise,
          collapsedIconColor: AppTheme.tinteStumm,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final absatz in a.text.split('\n'))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(absatz,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.tinteLeise, height: 1.5)),
              ),
          ],
        ),
      );

  Widget _spicyHinweis() => Card(
        color: AppTheme.papierErhoben,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VpRadius.karte),
          side: BorderSide(color: AppTheme.linie),
        ),
        child: ListTile(
          leading: Icon(Icons.bolt_outlined, color: AppTheme.tinteStumm),
          title: Text(t.spicyModus,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
          subtitle: Text(t.spicyModusText, style: TextStyle(fontSize: 12.5, color: AppTheme.tinteLeise)),
        ),
      );
}
