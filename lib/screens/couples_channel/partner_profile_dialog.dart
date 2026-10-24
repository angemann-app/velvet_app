import 'package:flutter/material.dart';

import '../../services/nostr_service.dart';
import '../../theme/app_theme.dart';

const Map<String?, String> partnerGenderLabels = {
  'female': 'Frau',
  'male': 'Mann',
  'other': 'Divers',
  null: 'Keine Angabe',
};

/// Name und Geschlecht des Gegenübers angeben oder ändern. Beides bleibt auf diesem Gerät
/// und dient nur dazu, Lektionen mit dem Namen des Gegenübers zu personalisieren.
Future<bool> editPartnerProfile(BuildContext context) async {
  final nostr = NostrService();
  final name = TextEditingController(text: nostr.partnerName == 'Partner' ? '' : nostr.partnerName);
  String? gender = nostr.partnerGenderNotifier.value;
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Dein Gegenüber'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Damit können Lektionen dein Gegenüber beim Namen nennen, etwa „Anna liegt auf dem Rücken“ '
              'statt „sie liegt“. Beides bleibt nur auf deinem Handy.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Name, z. B. Anna'),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in partnerGenderLabels.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: gender == entry.key,
                    onSelected: (_) => setState(() => gender = entry.key),
                    selectedColor: AppTheme.rose.withValues(alpha: 0.25),
                    showCheckmark: false,
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Speichern')),
        ],
      ),
    ),
  );
  if (saved == true) {
    await nostr.setPartnerProfile(name: name.text, gender: gender);
  }
  name.dispose();
  return saved == true;
}

/// Einmalige Nachfrage im Paar-Kanal, wenn Name oder Geschlecht fehlen. „Später“ blendet sie aus;
/// ändern lässt sich beides jederzeit über das Menü.
class PartnerProfilePrompt extends StatelessWidget {
  const PartnerProfilePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final nostr = NostrService();
    return AnimatedBuilder(
      animation: Listenable.merge([nostr.partnerNameNotifier, nostr.partnerGenderNotifier]),
      builder: (context, _) => FutureBuilder<bool>(
        future: nostr.partnerProfilePromptDismissed(),
        builder: (context, snap) {
          if (!nostr.partnerProfileIncomplete || snap.data != false) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 6),
            decoration: BoxDecoration(
              color: AppTheme.rose.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.rose.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wie dürfen Lektionen dein Gegenüber nennen?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                const Text(
                  'Mit Name und Geschlecht sprechen die Texte euch persönlich an. Das bleibt auf deinem Handy.',
                  style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: nostr.dismissPartnerProfilePrompt,
                      child: const Text('Später', style: TextStyle(color: AppTheme.textSecondary)),
                    ),
                    TextButton(
                      onPressed: () => editPartnerProfile(context),
                      child: const Text('Ergänzen',
                          style: TextStyle(color: AppTheme.rose, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
