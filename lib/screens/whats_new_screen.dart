import 'package:flutter/material.dart';

import '../services/whats_new.dart';
import '../theme/app_theme.dart';

/// Zeigt nach einem Update einmal, was neu ist, und merkt sich das danach.
Future<void> showWhatsNewIfUpdated(BuildContext context) async {
  List<WhatsNewEntry> entries;
  try {
    entries = await WhatsNew.pending();
  } catch (e) {
    debugPrint('WhatsNew error: $e');
    return;
  }
  if (entries.isEmpty || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => WhatsNewScreen(entries: entries)),
  );
  await WhatsNew.markSeen();
}

const _icons = <String, IconData>{
  'favorite': Icons.favorite_rounded,
  'school': Icons.school_rounded,
  'notifications': Icons.notifications_rounded,
  'person': Icons.person_rounded,
  'spa': Icons.spa_rounded,
  'edit': Icons.edit_rounded,
  'record_voice_over': Icons.record_voice_over_rounded,
  'new_releases': Icons.new_releases_rounded,
};

class WhatsNewScreen extends StatelessWidget {
  final List<WhatsNewEntry> entries;

  const WhatsNewScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final version = entries.first.version.split('-').first;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 16),
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppTheme.rose, size: 40),
                  const SizedBox(height: 16),
                  const Text(
                    'Willkommen zurück',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Das ist neu in Version $version.',
                    style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 26),
                  for (final entry in entries)
                    for (final item in entry.items) _item(item),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.rose,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Los geht\'s', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(WhatsNewItem item) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.rose.withOpacity(0.14), shape: BoxShape.circle),
              child: Icon(_icons[item.icon] ?? Icons.star_rounded, color: AppTheme.rose, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 3),
                  Text(item.text, style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      );
}
