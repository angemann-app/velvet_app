import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/lust_im_traum.dart';
import '../../services/pakete.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'einschlaf_reise_screen.dart';
import 'traum_tagebuch_screen.dart';

String lustFolgeTitel(int folge) => switch (folge) {
      1 => t.lustFolge1,
      2 => t.lustFolge2,
      3 => t.lustFolge3,
      4 => t.lustFolge4,
      5 => t.lustFolge5,
      6 => t.lustFolge6,
      7 => t.lustFolge7,
      _ => t.lustFolge8,
    };

/// Serie „Lust im Traum“ (docs/konzepte/lust-im-traum.md): acht aufeinander aufbauende Abende, nur im
/// Spicy-Modus. Inhalte kommen als eigenes Paket; Fortschritt nur lokal (StorageService).
class LustImTraumScreen extends StatefulWidget {
  const LustImTraumScreen({super.key});

  @override
  State<LustImTraumScreen> createState() => _LustImTraumScreenState();
}

class _LustImTraumScreenState extends State<LustImTraumScreen> {
  static const _keyBett = 'lust_bett';
  static const _keyTraumkoerper = 'lust_traumkoerper';
  static const _keyGegenueber = 'lust_gegenueber';

  LustDaten? _daten;
  bool _geladen = false;
  Map<int, int> _fortschritt = {};
  int _folge = 1;
  String _bett = 'vulva';
  String? _traumKoerper; // null = wie im Bett
  String _gegenueber = 'niemand';

  String get _paket => Pakete.name(Pakete.lust);
  bool get _paketDa => Pakete.version(_paket) > 0;

  @override
  void initState() {
    super.initState();
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await LustDaten.laden();
    final profil = StorageService.getUserProfile();
    final fortschritt = StorageService.getLustFortschritt();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _geladen = true;
      _fortschritt = fortschritt;
      _bett = prefs.getString(_keyBett) ?? (profil?.isMale == true ? 'penis' : 'vulva');
      _traumKoerper = prefs.getString(_keyTraumkoerper);
      _gegenueber = prefs.getString(_keyGegenueber) ?? 'niemand';
      // Vorauswahl: die höchste freie Folge.
      _folge = [for (var f = 1; f <= LustDaten.folgen; f++) if (LustDaten.frei(f, fortschritt)) f].last;
    });
  }

  Future<void> _paketLaden() async {
    try {
      await Pakete.laden(_paket);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.lustLadenFehler)));
    }
    await _laden();
  }

  Future<void> _weiter() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBett, _bett);
    if (_traumKoerper == null) {
      await prefs.remove(_keyTraumkoerper);
    } else {
      await prefs.setString(_keyTraumkoerper, _traumKoerper!);
    }
    await prefs.setString(_keyGegenueber, _gegenueber);
    final traumteil = _folge >= LustDaten.abFolgeTraumkoerper;
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EinschlafReiseScreen(
        lust: LustWahl(
          folge: _folge,
          bettKoerper: _bett,
          traumKoerper: traumteil ? _traumKoerper : null,
          gegenueber: traumteil ? _gegenueber : 'niemand',
        ),
      ),
    ));
    _laden();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(t.lustTitel),
        actions: [
          IconButton(
            tooltip: t.tagebuchTitel,
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TraumTagebuchScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: !_geladen
            ? const Center(child: CircularProgressIndicator(color: AppTheme.rose))
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  Text(t.lustSerieEinleitung, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5)),
                  const SizedBox(height: 14),
                  if (!_paketDa || _daten == null) ...[_paketKarte(), const SizedBox(height: 18)],
                  _titel(t.selbstReiseYourBody),
                  Wrap(spacing: 8, children: [
                    _chip(t.selbstReiseVulva, _bett == 'vulva', () => setState(() => _bett = 'vulva')),
                    _chip(t.selbstReisePenis, _bett == 'penis', () => setState(() => _bett = 'penis')),
                  ]),
                  const SizedBox(height: 20),
                  _titel(t.lustFolgen),
                  for (var f = 1; f <= LustDaten.folgen; f++) _folgeKachel(f),
                  if (_folge >= LustDaten.abFolgeTraumkoerper) ...[
                    const SizedBox(height: 16),
                    _titel(t.lustTraumkoerper),
                    Wrap(spacing: 8, runSpacing: 4, children: [
                      _chip(t.lustTraumkoerperEigener, _traumKoerper == null || _traumKoerper == _bett,
                          () => setState(() => _traumKoerper = null)),
                      if (_bett != 'vulva')
                        _chip(t.lustTraumkoerperFrau, _traumKoerper == 'vulva', () => setState(() => _traumKoerper = 'vulva')),
                      if (_bett != 'penis')
                        _chip(t.lustTraumkoerperMann, _traumKoerper == 'penis', () => setState(() => _traumKoerper = 'penis')),
                    ]),
                    const SizedBox(height: 16),
                    _titel(t.lustGegenueber),
                    Wrap(spacing: 8, runSpacing: 4, children: [
                      for (final g in LustDaten.gegenuebers)
                        _chip(_gegenueberName(g), _gegenueber == g, () => setState(() => _gegenueber = g)),
                    ]),
                  ],
                  if (_daten?.tag(_folge, _wirksamerKoerper) case final tag?) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Text(tag, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _daten == null ? null : _weiter,
                      icon: const Icon(Icons.bedtime_rounded),
                      label: Text(t.lustWeiter, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.rose,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_bett == 'penis' ? '${t.lustHinweise}\n${t.lustHinweisHandtuch}' : t.lustHinweise,
                      style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
                ],
              ),
      ),
    );
  }

  /// Körper der Traum-Teile: Folge 1 und 2 immer der eigene, ab Folge 3 der gewählte Traumkörper.
  String get _wirksamerKoerper =>
      _folge >= LustDaten.abFolgeTraumkoerper ? (_traumKoerper ?? _bett) : _bett;

  String _gegenueberName(String g) => switch (g) {
        'frau' => t.lustGegenueberFrau,
        'mann' => t.lustGegenueberMann,
        'offen' => t.lustGegenueberOffen,
        _ => t.lustGegenueberNiemand,
      };

  Widget _paketKarte() => ValueListenableBuilder<Map<String, double>>(
        valueListenable: Pakete.fortschritt,
        builder: (context, f, _) {
          final laeuft = f[_paket];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.rose.withValues(alpha: 0.5)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(t.lustPaketFehlt, style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary, height: 1.5)),
              const SizedBox(height: 10),
              if (laeuft != null)
                LinearProgressIndicator(value: laeuft, color: AppTheme.rose, backgroundColor: AppTheme.surfaceLight)
              else
                OutlinedButton(
                  onPressed: _paketLaden,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.rose,
                    side: const BorderSide(color: AppTheme.rose),
                  ),
                  child: Text(t.lustPaketLaden),
                ),
            ]),
          );
        },
      );

  Widget _folgeKachel(int f) {
    final frei = LustDaten.frei(f, _fortschritt);
    final abende = _fortschritt[f] ?? 0;
    final aktiv = _folge == f;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: frei
            ? () {
                HapticFeedback.selectionClick();
                setState(() => _folge = f);
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: aktiv ? AppTheme.rose.withValues(alpha: 0.14) : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: aktiv ? AppTheme.rose : AppTheme.border),
          ),
          child: Row(children: [
            SizedBox(
              width: 30,
              child: frei
                  ? Text('$f', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))
                  : const Icon(Icons.lock_outline_rounded, size: 18, color: AppTheme.textMuted),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(lustFolgeTitel(f),
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: frei ? AppTheme.textPrimary : AppTheme.textMuted)),
                const SizedBox(height: 2),
                Text(
                  frei ? t.lustAbendeGehoert(abende) : t.lustGesperrt(f - 1),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _titel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      );

  Widget _chip(String label, bool aktiv, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: aktiv,
        onSelected: (_) {
          HapticFeedback.selectionClick();
          onTap();
        },
        selectedColor: AppTheme.rose.withValues(alpha: 0.22),
        backgroundColor: AppTheme.surface,
        side: BorderSide(color: aktiv ? AppTheme.rose : AppTheme.border),
        labelStyle: TextStyle(color: aktiv ? AppTheme.textPrimary : AppTheme.textSecondary, fontWeight: FontWeight.w600),
        showCheckmark: false,
      );
}
