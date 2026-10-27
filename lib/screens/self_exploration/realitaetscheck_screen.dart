import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/t.dart';
import '../../models/traum_eintrag.dart';
import '../../services/realitaetscheck.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

/// Bildschirm für den Realitätscheck (docs/konzepte/traum-reise.md, „Realitätschecks“).
///
/// Bietet die kleine Achtsamkeitsübung („Träume ich gerade?“), Auswertung wiederkehrender
/// Motive aus dem Traumtagebuch sowie die Einstellungen für diskrete Erinnerungen am Tag.
class RealitaetscheckScreen extends StatefulWidget {
  const RealitaetscheckScreen({super.key});

  @override
  State<RealitaetscheckScreen> createState() => _RealitaetscheckScreenState();
}

class _RealitaetscheckScreenState extends State<RealitaetscheckScreen> {
  late RealitaetscheckEinstellungen _einstellungen;
  List<TraumEintrag> _eintraege = [];
  List<String> _motive = [];
  String? _rueckmeldung;

  @override
  void initState() {
    super.initState();
    _einstellungen = StorageService.getRealitaetschecks();
    _eintraege = StorageService.getTraumEintraege();
    _motive = RealitaetscheckService.findeMotive(_eintraege);
  }

  Future<void> _einstellungenSpeichern(RealitaetscheckEinstellungen neu) async {
    setState(() => _einstellungen = neu);
    await StorageService.saveRealitaetschecks(neu);
    await RealitaetscheckService.planen(neu);
  }

  void _antwortWach() {
    HapticFeedback.lightImpact();
    setState(() => _rueckmeldung = 'Wach und präsent im Hier und Jetzt.');
  }

  void _antwortTraum() {
    HapticFeedback.heavyImpact();
    setState(() => _rueckmeldung = 'Du träumst! Bleib ruhig, atme sanft und genieße deinen Traum.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(t.realitaetTitel),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            Text(
              t.realitaetFrage,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              t.realitaetEinleitung,
              style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 18),

            // 1. Übungskarte: Hände
            _UebungsKarte(
              icon: Icons.pan_tool_outlined,
              titel: t.realitaetUebungHaendeTitel,
              text: t.realitaetUebungHaendeText,
            ),
            const SizedBox(height: 10),

            // 2. Übungskarte: Finger durch Handfläche
            _UebungsKarte(
              icon: Icons.touch_app_outlined,
              titel: t.realitaetUebungFingerTitel,
              text: t.realitaetUebungFingerText,
            ),
            const SizedBox(height: 10),

            // 3. Übungskarte: Text zweimal lesen
            _UebungsKarte(
              icon: Icons.menu_book_outlined,
              titel: t.realitaetUebungTextTitel,
              text: t.realitaetUebungTextText,
            ),
            const SizedBox(height: 18),

            if (_rueckmeldung != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.rose.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.rose.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _rueckmeldung!,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Antwort-Knöpfe
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _antwortWach,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.rose,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(t.realitaetBestaetigenWach, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _antwortTraum,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: BorderSide(color: AppTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(t.realitaetBestaetigenTraum, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Motive aus dem Tagebuch
            Text(
              t.realitaetMotiveTitel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            if (_motive.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  t.realitaetMotiveKeine,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final m in _motive.take(5))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '• ${t.realitaetMotivSatz(m)}',
                          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.35),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 28),

            // Einstellungen
            Text(
              t.realitaetErinnerungenAktiv,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(t.realitaetErinnerungenAktiv,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    subtitle: Text(
                      t.realitaetMitteilungTitel,
                      style: const TextStyle(fontSize: 12.5, color: AppTheme.textMuted),
                    ),
                    value: _einstellungen.aktiv,
                    activeThumbColor: AppTheme.rose,
                    onChanged: (an) => _einstellungenSpeichern(_einstellungen.mit(aktiv: an)),
                  ),
                  if (_einstellungen.aktiv) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.realitaetZeitfenster(_einstellungen.vonStunde, _einstellungen.bisStunde),
                            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.realitaetAnzahlTag(_einstellungen.anzahlProTag),
                            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                          Row(
                            children: [
                              for (final n in [2, 3, 4])
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: ChoiceChip(
                                    label: Text('$n'),
                                    selected: _einstellungen.anzahlProTag == n,
                                    onSelected: (sel) {
                                      if (sel) _einstellungenSpeichern(_einstellungen.mit(anzahlProTag: n));
                                    },
                                    selectedColor: AppTheme.rose.withValues(alpha: 0.22),
                                    backgroundColor: AppTheme.background,
                                    side: BorderSide(
                                      color: _einstellungen.anzahlProTag == n ? AppTheme.rose : AppTheme.border,
                                    ),
                                    labelStyle: TextStyle(
                                      color: _einstellungen.anzahlProTag == n ? AppTheme.textPrimary : AppTheme.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Xiaomi-Hinweis
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                t.realitaetHinweisXiaomi,
                style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UebungsKarte extends StatelessWidget {
  final IconData icon;
  final String titel;
  final String text;

  const _UebungsKarte({required this.icon, required this.titel, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.rose, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titel,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
