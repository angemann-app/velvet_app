import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/t.dart';
import '../services/alter_dienst.dart';
import '../services/privacy_service.dart';
import '../services/sprache.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Schaltet den Spicy-Modus ein, nach Altersnachweis und Gerätesperre (docs/konzepte/altersnachweis.md).
/// Gibt zurück, ob er danach an ist. Genutzt im Profil und bei einer Einladung des Gegenübers im Paar-Chat.
Future<bool> spicyModusEinschalten(BuildContext context) async {
  if (StorageService.spicyMode()) return true;
  if (AlterDienst.gesperrtBis() != null) {
    await _hinweis(context, t.alterGesperrtTitel, t.alterGesperrtText);
    return false;
  }
  if (!await PrivacyService.isSupported()) {
    if (!context.mounted) return false;
    await _hinweis(context, t.alterSperreFehltTitel, t.alterSperreFehltText);
    return false;
  }
  if (!AlterDienst.bestaetigt) {
    if (!context.mounted) return false;
    final volljaehrig = await _geburtsangabe(context);
    if (volljaehrig == null) return false;
    if (!volljaehrig) {
      if (!context.mounted) return false;
      await _hinweis(context, t.alterGesperrtTitel, t.alterGesperrtText);
      return false;
    }
  }
  if (!StorageService.spicyGewaehlt()) {
    if (!context.mounted) return false;
    final ja = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.spicyEinschaltenTitel),
        content: SingleChildScrollView(child: Text(t.spicyEinschaltenText, style: const TextStyle(height: 1.45))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.ausspracheMeldenCancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.spicyEinschalten, style: TextStyle(color: AppTheme.akzentTief)),
          ),
        ],
      ),
    );
    if (ja != true) return false;
  }
  if (!await AlterDienst.entsperren()) return false;
  await StorageService.setSpicyMode(true);
  return true;
}

Future<void> _hinweis(BuildContext context, String titel, String text) => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(titel),
        content: Text(text, style: const TextStyle(height: 1.45)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.alterWeiter)),
        ],
      ),
    );

/// Fragt Geburtsmonat und -jahr. null = abgebrochen, sonst ob volljährig.
Future<bool?> _geburtsangabe(BuildContext context) {
  final jetzt = DateTime.now();
  int? monat, jahr;
  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.alterTitel),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.alterText, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              key: const ValueKey('alter_monat'),
              decoration: InputDecoration(labelText: t.alterMonat),
              initialValue: monat,
              items: [
                for (var m = 1; m <= 12; m++)
                  DropdownMenuItem(value: m, child: Text(DateFormat.MMMM(Sprache.code).format(DateTime(2000, m)))),
              ],
              onChanged: (v) => setState(() => monat = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: const ValueKey('alter_jahr'),
              decoration: InputDecoration(labelText: t.alterJahr),
              initialValue: jahr,
              items: [
                for (var j = jetzt.year; j >= jetzt.year - 100; j--) DropdownMenuItem(value: j, child: Text('$j')),
              ],
              onChanged: (v) => setState(() => jahr = v),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.ausspracheMeldenCancel)),
          TextButton(
            onPressed: monat == null || jahr == null
                ? null
                : () async {
                    final ok = await AlterDienst.angabePruefen(jahr!, monat!);
                    if (context.mounted) Navigator.pop(context, ok);
                  },
            child: Text(t.alterWeiter, style: TextStyle(color: AppTheme.akzentTief)),
          ),
        ],
      ),
    ),
  );
}
