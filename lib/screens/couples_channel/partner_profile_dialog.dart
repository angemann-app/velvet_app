import 'package:flutter/material.dart';

import '../../services/nostr_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import '../../widgets/design/vp_komponenten.dart';
import '../../l10n/t.dart';

Map<String?, String> get partnerGenderLabels => {
  'female': t.partnerProfileDialogWoman,
  'male': t.partnerProfileDialogMan,
  'other': t.partnerProfileDialogNonBinary,
  null: t.partnerProfileDialogNotSpecified,
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
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.partnerProfileDialogYourPartner),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.partnerProfileDialogThisLetsLessonsCallYour,
              style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: t.invitePartnerNameEGAnna),
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
                    selectedColor: AppTheme.akzentTief.withValues(alpha: 0.25),
                    showCheckmark: false,
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.ausspracheMeldenCancel)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.partnerProfileDialogSave)),
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
          // VpKarte statt Container mit gemischten Randfarben und Radius: Letzteres zeichnet in der Debug-Version nichts
          // (Assertion), die Karte stand dann leer über dem Verlauf.
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: VpKarte(
            rahmen: VpRahmen.akzent,
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.partnerProfileDialogHowMayLessonsReferTo,
                    style: context.vp.typo.titel.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  t.partnerProfileDialogWithNameAndGenderThe,
                  style: TextStyle(fontSize: 12.5, color: AppTheme.tinteLeise, height: 1.4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: nostr.dismissPartnerProfilePrompt,
                      child: Text(t.updateDialogLater, style: TextStyle(color: AppTheme.tinteLeise)),
                    ),
                    TextButton(
                      onPressed: () => editPartnerProfile(context),
                      child: Text(t.partnerProfileDialogAdd,
                          style: TextStyle(color: AppTheme.akzentTief, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}
