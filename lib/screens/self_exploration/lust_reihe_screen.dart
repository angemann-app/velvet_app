import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/lust_reihe.dart';
import '../../services/audio_ausgabe.dart';
import '../../services/pakete.dart';
import '../../services/sprachausgabe.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lautsprecher_frage.dart';

/// Audioreihe „Innenansichten“ (docs/konzepte/lust-audioreihe.md): zusammenhängende Erzählungen, Soft und
/// Spicy, Perspektiven derselben Begegnung mit gemeinsamen Szenen-IDs. Inhalte nur aus dem Paket
/// `<sprache>-reihe` (nur R2), Wiedergabe szenenweise ohne künstliche Stille.
class LustReiheScreen extends StatefulWidget {
  const LustReiheScreen({super.key});

  @override
  State<LustReiheScreen> createState() => _LustReiheScreenState();
}

class _LustReiheScreenState extends State<LustReiheScreen> {
  static const _keyFolge = 'reihe_folge';
  static const _keyVariante = 'reihe_variante';
  static const _keyPerspektive = 'reihe_perspektive';

  final _player = AudioPlayer();
  ReiheDaten? _daten;
  bool _geladen = false;
  String? _folgeId;
  String _variante = 'soft';
  String? _perspektive;

  ReiheFolge? _spiel; // läuft gerade
  ReiheFassung? _fassung;
  int _index = 0;
  Duration _imSegment = Duration.zero;
  bool _pausiert = false;
  bool _fertig = false;
  int _lauf = 0;
  StreamSubscription<void>? _kopfhoererSub;

  String get _paket => Pakete.name(Pakete.reihe);
  bool get _paketDa => Pakete.version(_paket) > 0;
  bool get _spicy => StorageService.spicyMode();

  ReiheFolge? get _folge {
    final d = _daten;
    if (d == null || d.folgen.isEmpty) return null;
    return d.folgen.where((f) => f.id == _folgeId).firstOrNull ?? d.folgen.first;
  }

  @override
  void initState() {
    super.initState();
    AudioAusgabe.instanz.initialisieren();
    _kopfhoererSub = AudioAusgabe.instanz.onKopfhoererGetrennt.listen((_) {
      if (!mounted) return;
      if (StorageService.getPausiereBeiKopfhoererGetrennt() && _spiel != null && !_fertig && !_pausiert) {
        _pauseUmschalten();
      }
    });
    _laden();
  }

  @override
  void dispose() {
    _lauf++;
    _kopfhoererSub?.cancel();
    Sprachausgabe.vorlesenBeenden();
    _player.dispose();
    super.dispose();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await ReiheDaten.laden();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _geladen = true;
      _folgeId = prefs.getString(_keyFolge);
      _variante = prefs.getString(_keyVariante) ?? 'soft';
      _perspektive = prefs.getString(_keyPerspektive);
    });
  }

  Future<void> _paketLaden() async {
    try {
      await Pakete.laden(_paket);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.reiheLadenFehler)));
    }
    await _laden();
  }

  /// Die gewählte Fassung; fällt auf die erste der Variante zurück, wenn die Perspektive dort fehlt.
  ReiheFassung? _gewaehlt(ReiheFolge folge) {
    final variante = folge.varianten(spicyErlaubt: _spicy).contains(_variante) ? _variante : 'soft';
    final liste = folge.fassungenVon(variante);
    if (liste.isEmpty) return null;
    return liste.where((f) => f.perspektive == _perspektive).firstOrNull ?? liste.first;
  }

  Future<void> _starten() async {
    final folge = _folge;
    final fassung = folge == null ? null : _gewaehlt(folge);
    if (folge == null || fassung == null) return;
    final darf = await frageVorLautsprecher(context);
    if (!darf || !mounted) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFolge, folge.id);
    await prefs.setString(_keyVariante, fassung.variante);
    await prefs.setString(_keyPerspektive, fassung.perspektive);
    setState(() {
      _spiel = folge;
      _fassung = fassung;
      _index = 0;
      _imSegment = Duration.zero;
      _pausiert = false;
      _fertig = false;
    });
    _abspielen(++_lauf);
  }

  bool _abgebrochen(int lauf) => lauf != _lauf || !mounted;

  /// Segment für Segment, ohne Stille dazwischen; die Szenen bleiben so für beide Perspektiven gleich.
  Future<void> _abspielen(int lauf) async {
    final folge = _spiel!, fassung = _fassung!, daten = _daten!;
    while (_index < fassung.segmente.length) {
      final s = fassung.segmente[_index];
      final dauer = daten.dauerVon(folge, fassung, s);
      Sprachausgabe.sprich(_player, ReiheDaten.audioPfad(folge, fassung, s), s.text);
      while (_imSegment < dauer) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (_abgebrochen(lauf)) return;
        if (!_pausiert) setState(() => _imSegment += const Duration(milliseconds: 250));
      }
      if (_abgebrochen(lauf)) return;
      setState(() {
        _index++;
        _imSegment = Duration.zero;
      });
    }
    setState(() => _fertig = true);
  }

  void _pauseUmschalten() {
    HapticFeedback.lightImpact();
    setState(() => _pausiert = !_pausiert);
    if (_pausiert) {
      Sprachausgabe.pause(_player);
    } else {
      _player.resume().catchError((_) {});
    }
  }

  /// Springt zu einer Szene (Anfang des Segments) und spielt von dort weiter.
  void _springe(int index) {
    final fassung = _fassung;
    if (fassung == null) return;
    HapticFeedback.selectionClick();
    Sprachausgabe.stopp(_player);
    setState(() {
      _index = index.clamp(0, fassung.segmente.length - 1);
      _imSegment = Duration.zero;
      _pausiert = false;
      _fertig = false;
    });
    _abspielen(++_lauf);
  }

  void _beenden() {
    _lauf++;
    Sprachausgabe.stopp(_player);
    setState(() {
      _spiel = null;
      _fassung = null;
      _fertig = false;
      _pausiert = false;
    });
  }

  Future<void> _fragBeenden() async {
    final ja = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(t.reiheBeendenFrage),
        content: Text(t.reiheBeendenText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.paarAbendContinue)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.reiheBeenden)),
        ],
      ),
    );
    if (ja == true && mounted) _beenden();
  }

  @override
  Widget build(BuildContext context) {
    final laeuft = _spiel != null;
    return PopScope(
      canPop: !laeuft || _fertig,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _fragBeenden();
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(backgroundColor: AppTheme.background, title: Text(t.reiheTitel)),
        body: SafeArea(
          child: !_geladen
              ? const Center(child: CircularProgressIndicator(color: AppTheme.rose))
              : (laeuft ? _spieler() : _einrichtung()),
        ),
      ),
    );
  }

  String _perspektiveName(String p) => switch (p) {
        'frau' => t.reihePerspektiveFrau,
        'mann' => t.reihePerspektiveMann,
        _ => p,
      };

  Widget _einrichtung() {
    final folge = _folge;
    final fassung = folge == null ? null : _gewaehlt(folge);
    final partner = folge == null || fassung == null ? <ReiheFassung>[] : folge.partnerVon(fassung);
    final perspektiven = folge == null || fassung == null
        ? <String>[]
        : [for (final f in folge.fassungenVon(fassung.variante)) f.perspektive];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(t.reiheEinleitung, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5)),
        const SizedBox(height: 14),
        if (!_paketDa || _daten == null) ...[_paketKarte(), const SizedBox(height: 18)],
        if (_daten != null && folge == null) Text(t.reiheLeer, style: TextStyle(color: AppTheme.textMuted)),
        if (folge != null && fassung != null) ...[
          _titel(t.reiheFolgen),
          for (final f in _daten!.folgen) _folgeKachel(f, f.id == folge.id),
          const SizedBox(height: 16),
          if (folge.varianten(spicyErlaubt: _spicy).length > 1) ...[
            _titel(t.reiheVariante),
            Wrap(spacing: 8, children: [
              for (final v in folge.varianten(spicyErlaubt: _spicy))
                _chip(v == 'spicy' ? t.reiheSpicy : t.reiheSoft, fassung.variante == v, () => setState(() => _variante = v)),
            ]),
            const SizedBox(height: 16),
          ],
          if (perspektiven.length > 1) ...[
            _titel(t.reihePerspektive),
            Wrap(spacing: 8, children: [
              for (final p in perspektiven)
                _chip(_perspektiveName(p), fassung.perspektive == p, () => setState(() => _perspektive = p)),
            ]),
            const SizedBox(height: 12),
          ],
          if (partner.isNotEmpty)
            Text(t.reihePartnerHinweis(partner.map((p) => _perspektiveName(p.perspektive)).join(', ')),
                style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
          const SizedBox(height: 8),
          Text(
            '${t.reiheDauer(_daten!.gesamt(folge, fassung).inMinutes.clamp(1, 999))} · ${t.reiheOffline}',
            style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _starten,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(t.reiheStart, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.rose,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          if (Pakete.datei(ReiheDaten.audioPfad(folge, fassung, fassung.segmente.first)) == null) ...[
            const SizedBox(height: 10),
            Text(t.reiheKeineAufnahme, style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
          ],
        ],
        const SizedBox(height: 16),
        Text(t.reiheHinweise, style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
      ],
    );
  }

  Widget _spieler() {
    final folge = _spiel!, fassung = _fassung!;
    final szenen = fassung.segmente.length;
    final i = _index.clamp(0, szenen - 1);
    final szene = folge.szenen.where((s) => s.id == fassung.segmente[i].szene).firstOrNull;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 12),
        Text(folge.titel,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        Text('${fassung.spicy ? t.reiheSpicy : t.reiheSoft} · ${_perspektiveName(fassung.perspektive)}',
            style: TextStyle(color: AppTheme.textMuted)),
        const Spacer(),
        Text(_fertig ? t.reiheFertig : t.reiheSzene(i + 1, szenen),
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
        if (szene != null && !_fertig) ...[
          const SizedBox(height: 8),
          Text(szene.beschreibung, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        ],
        const SizedBox(height: 18),
        LinearProgressIndicator(
          value: _fertig ? 1 : (i + 0.0) / szenen,
          color: AppTheme.rose,
          backgroundColor: AppTheme.surfaceLight,
        ),
        const Spacer(),
        if (_fertig)
          ElevatedButton(onPressed: _beenden, child: Text(t.reiheBeenden))
        else
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              tooltip: t.reiheSzeneZurueck,
              iconSize: 32,
              onPressed: () => _springe(_imSegment > const Duration(seconds: 4) ? i : i - 1),
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              iconSize: 40,
              style: IconButton.styleFrom(backgroundColor: AppTheme.rose),
              onPressed: _pauseUmschalten,
              icon: Icon(_pausiert ? Icons.play_arrow_rounded : Icons.pause_rounded),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: t.reiheSzeneVor,
              iconSize: 32,
              onPressed: i < szenen - 1 ? () => _springe(i + 1) : null,
              icon: const Icon(Icons.skip_next_rounded),
            ),
          ]),
        TextButton(onPressed: _fertig ? _beenden : _fragBeenden, child: Text(t.reiheBeenden)),
      ]),
    );
  }

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
              Text(t.reihePaketFehlt, style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary, height: 1.5)),
              const SizedBox(height: 10),
              if (laeuft != null)
                LinearProgressIndicator(value: laeuft, color: AppTheme.rose, backgroundColor: AppTheme.surfaceLight)
              else
                OutlinedButton(
                  onPressed: _paketLaden,
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.rose, side: const BorderSide(color: AppTheme.rose)),
                  child: Text(t.reihePaketLaden),
                ),
            ]),
          );
        },
      );

  Widget _folgeKachel(ReiheFolge f, bool aktiv) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _folgeId = f.id);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: aktiv ? AppTheme.rose.withValues(alpha: 0.14) : AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: aktiv ? AppTheme.rose : AppTheme.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.titel, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              if (f.beschreibung.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(f.beschreibung, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              ],
            ]),
          ),
        ),
      );

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
