import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/paar_abend.dart';
import '../../services/nostr_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aussprache_melden.dart';
import '../../widgets/player_steuerung.dart';

/// Gemeinsamer, geführter Abend: Ein Handy liegt neben euch, die Stimme führt durch
/// Ankommen, zwei Berührungsrunden mit Rollenwechsel und Ausklang.
/// Jeder Abend wird aus den Bausteinen in assets/data/paar_abend.json neu zusammengestellt.
class PaarAbendScreen extends StatefulWidget {
  const PaarAbendScreen({super.key});

  @override
  State<PaarAbendScreen> createState() => _PaarAbendScreenState();
}

class _PaarAbendScreenState extends State<PaarAbendScreen> {
  static const _keyMinuten = 'paar_abend_minuten';
  static const _keyTiefe = 'paar_abend_tiefe';
  static const _keyStimme = 'paar_abend_stimme';
  static const _keyZuletzt = 'paar_abend_zuletzt';
  static const _minutenOptionen = [20, 30, 45];

  PaarAbendDaten? _daten;
  int _minuten = 30;
  PaarTiefe _tiefe = PaarTiefe.bekleidet;
  String _stimme = 'victoria';
  bool _ichZuerst = true;
  bool _teppich = true;

  List<PaarSchritt>? _ablauf;
  int _index = 0;
  Duration _imSchritt = Duration.zero;
  bool _pausiert = false;
  bool _fertig = false;
  int _lauf = 0; // erhöht sich bei jedem Start/Stopp, damit alte Abläufe sich beenden

  final AudioPlayer _stimmePlayer = AudioPlayer();
  final AudioPlayer _klangPlayer = AudioPlayer();
  final AudioPlayer _teppichPlayer = AudioPlayer();

  String get _ichName {
    final name = StorageService.getUserProfile()?.name.trim() ?? '';
    return name.isEmpty ? 'Du' : name;
  }

  String get _partnerName {
    final nostr = NostrService();
    final name = nostr.isPaired ? nostr.partnerName.trim() : '';
    return name.isEmpty ? 'dein Gegenüber' : name;
  }

  @override
  void initState() {
    super.initState();
    // Nur der Klangteppich hält den Audio-Fokus; Stimme und Klangschale spielen darüber, ohne ihn zu unterbrechen.
    final ohneFokus = AudioContext(android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none));
    _stimmePlayer.setAudioContext(ohneFokus).catchError((_) {});
    _klangPlayer.setAudioContext(ohneFokus).catchError((_) {});
    _teppichPlayer.setReleaseMode(ReleaseMode.loop).catchError((_) {});
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await PaarAbendDaten.laden();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _minuten = prefs.getInt(_keyMinuten) ?? 30;
      _tiefe = PaarTiefe.values.asNameMap()[prefs.getString(_keyTiefe)] ?? PaarTiefe.bekleidet;
      _stimme = prefs.getString(_keyStimme) ??
          (StorageService.getUserProfile()?.isFemale == true ? 'martin' : 'victoria');
    });
  }

  @override
  void dispose() {
    _lauf++;
    _stimmePlayer.dispose();
    _klangPlayer.dispose();
    _teppichPlayer.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Ablauf

  Future<void> _starten() async {
    final daten = _daten;
    if (daten == null) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinuten, _minuten);
    await prefs.setString(_keyTiefe, _tiefe.name);
    await prefs.setString(_keyStimme, _stimme);

    final zuletzt = prefs.getStringList(_keyZuletzt) ?? [];
    final ablauf = daten.planen(minuten: _minuten, tiefe: _tiefe, stimme: _stimme, zuletzt: zuletzt.toSet());
    final neu = [for (final s in ablauf) if (s.baustein != null) s.baustein!.id];
    // Die letzten zwei Abende merken, damit der nächste möglichst andere Varianten bekommt.
    await prefs.setStringList(_keyZuletzt, [...neu, ...zuletzt].take(60).toList());

    setState(() {
      _ablauf = ablauf;
      _index = 0;
      _imSchritt = Duration.zero;
      _pausiert = false;
      _fertig = false;
    });
    if (_teppich) {
      _teppichPlayer.setVolume(0.35).catchError((_) {});
      _teppichPlayer.play(AssetSource('audio/paar/klangteppich.opus')).catchError((_) {});
    }
    _abspielen(++_lauf);
  }

  bool _abgebrochen(int lauf) => lauf != _lauf || !mounted;

  Future<void> _abspielen(int lauf) async {
    final ablauf = _ablauf!;
    while (_index < ablauf.length) {
      final schritt = ablauf[_index];
      if (schritt.klang) {
        _klangPlayer.play(AssetSource('audio/paar/klangschale.opus'), volume: 0.8).catchError((_) {});
      } else if (schritt.baustein != null) {
        _stimmePlayer
            .play(AssetSource('audio/paar/${_stimme}_${schritt.baustein!.id}.opus'))
            .catchError((_) {});
      }
      // Die Zeit läuft selbst mit, statt auf das Ende der Aufnahme zu warten:
      // So bleibt der Ablauf stabil, auch wenn eine Datei fehlt.
      while (_imSchritt < schritt.dauer) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (_abgebrochen(lauf)) return;
        if (!_pausiert) setState(() => _imSchritt += const Duration(milliseconds: 250));
      }
      if (_abgebrochen(lauf)) return;
      setState(() {
        _index++;
        _imSchritt = Duration.zero;
      });
    }
    setState(() => _fertig = true);
    await _teppichLeiser();
  }

  Future<void> _teppichLeiser() async {
    for (var v = 0.35; v > 0; v -= 0.05) {
      await _teppichPlayer.setVolume(v).catchError((_) {});
      await Future.delayed(const Duration(milliseconds: 400));
    }
    await _teppichPlayer.stop().catchError((_) {});
  }

  void _pauseUmschalten() {
    HapticFeedback.lightImpact();
    setState(() => _pausiert = !_pausiert);
    if (_pausiert) {
      _stimmePlayer.pause().catchError((_) {});
      _teppichPlayer.pause().catchError((_) {});
    } else {
      _stimmePlayer.resume().catchError((_) {});
      if (_teppich) _teppichPlayer.resume().catchError((_) {});
    }
  }

  /// Springt zum nächsten Schritt, z. B. wenn eine Stille zu lang ist.
  void _weiter() {
    final ablauf = _ablauf;
    if (ablauf == null || _index >= ablauf.length) return;
    HapticFeedback.selectionClick();
    _stimmePlayer.stop().catchError((_) {});
    setState(() => _imSchritt = ablauf[_index].dauer);
  }

  void _beenden() {
    _lauf++;
    _stimmePlayer.stop().catchError((_) {});
    _klangPlayer.stop().catchError((_) {});
    _teppichPlayer.stop().catchError((_) {});
    setState(() {
      _ablauf = null;
      _fertig = false;
      _pausiert = false;
    });
  }

  Duration get _gesamt => _ablauf?.fold<Duration>(Duration.zero, (s, x) => s + x.dauer) ?? Duration.zero;

  Duration get _vergangen {
    final ablauf = _ablauf;
    if (ablauf == null) return Duration.zero;
    var d = _imSchritt;
    for (var i = 0; i < _index && i < ablauf.length; i++) {
      d += ablauf[i].dauer;
    }
    return d;
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  // ---------------------------------------------------------------------------
  // Oberfläche

  @override
  Widget build(BuildContext context) {
    final laeuft = _ablauf != null;
    return PopScope(
      canPop: !laeuft || _fertig,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _fragBeenden();
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          title: const Text('Gemeinsamer Abend'),
        ),
        body: SafeArea(
          child: _daten == null
              ? const Center(child: CircularProgressIndicator(color: AppTheme.amber))
              : (laeuft ? _buildPlayer() : _buildEinrichtung()),
        ),
      ),
    );
  }

  Future<void> _fragBeenden() async {
    final ja = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Abend beenden?'),
        content: const Text('Die Begleitung hört dann auf. Ihr könnt jederzeit neu beginnen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Weitermachen')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Beenden')),
        ],
      ),
    );
    if (ja == true && mounted) _beenden();
  }

  Widget _buildEinrichtung() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        const Text(
          'Legt das Handy neben euch. Eine Stimme führt euch durch Ankommen, zwei Runden '
          'Berührung mit Rollenwechsel und einen ruhigen Ausklang. Die meiste Zeit ist Stille, '
          'damit ihr ganz bei euch seid. Jeder Abend wird neu zusammengestellt.',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 22),
        _titel('Dauer'),
        Wrap(
          spacing: 8,
          children: [
            for (final m in _minutenOptionen)
              _chip('$m Min.', _minuten == m, () => setState(() => _minuten = m)),
          ],
        ),
        const SizedBox(height: 20),
        _titel('Wie weit darf es gehen?'),
        _tiefeOption(PaarTiefe.bekleidet, 'Bekleidet', 'Rücken, Schultern, Hände, Kopf, Beine und Füße.'),
        _tiefeOption(PaarTiefe.haut, 'Haut an Haut', 'Dazu Massage mit Öl, Bauch, Hüften und Po.'),
        _tiefeOption(PaarTiefe.intim, 'Intim', 'Dazu Brust, Innenschenkel und Geschlecht, ganz ohne Ziel.'),
        const SizedBox(height: 20),
        _titel('Wer gibt zuerst?'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip(_ichName == 'Du' ? 'Ich' : _ichName, _ichZuerst, () => setState(() => _ichZuerst = true)),
            _chip(NostrService().isPaired ? _partnerName : 'Mein Gegenüber', !_ichZuerst, () => setState(() => _ichZuerst = false)),
          ],
        ),
        const SizedBox(height: 20),
        _titel('Stimme'),
        Wrap(
          spacing: 8,
          children: [
            _chip('Victoria', _stimme == 'victoria', () => setState(() => _stimme = 'victoria')),
            _chip('Martin', _stimme == 'martin', () => setState(() => _stimme = 'martin')),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _teppich,
          activeThumbColor: AppTheme.amber,
          onChanged: (v) => setState(() => _teppich = v),
          title: const Text('Leiser Klangteppich', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14.5)),
          subtitle: const Text('Ruhiger Hintergrund in den Stillen',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.sageGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.35)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.handshake_outlined, color: AppTheme.sageGreen, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Vereinbart vorher ein Stoppwort. Die Stimme lädt ein, sie bestimmt nichts: '
                  'Was sich nicht gut anfühlt, lasst ihr einfach aus.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.45),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Abend beginnen', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.amber,
              foregroundColor: AppTheme.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      );

  Widget _chip(String label, bool aktiv, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: aktiv,
        onSelected: (_) {
          HapticFeedback.selectionClick();
          onTap();
        },
        selectedColor: AppTheme.amber.withValues(alpha: 0.25),
        backgroundColor: AppTheme.surface,
        side: BorderSide(color: aktiv ? AppTheme.amber : AppTheme.border),
        labelStyle: TextStyle(
          color: aktiv ? AppTheme.amberLight : AppTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        showCheckmark: false,
      );

  Widget _tiefeOption(PaarTiefe tiefe, String titel, String text) {
    final aktiv = _tiefe == tiefe;
    final farbe = tiefe == PaarTiefe.intim ? AppTheme.rose : AppTheme.amber;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _tiefe = tiefe);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: aktiv ? farbe.withValues(alpha: 0.12) : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: aktiv ? farbe : AppTheme.border),
          ),
          child: Row(
            children: [
              Icon(aktiv ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: aktiv ? farbe : AppTheme.textMuted, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titel,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 2),
                    Text(text, style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final ablauf = _ablauf!;
    final schritt = _index < ablauf.length ? ablauf[_index] : null;
    final runde = schritt?.runde ?? 0;
    final ichGebe = (runde == 1) == _ichZuerst;
    final gesamt = _gesamt;
    final fortschritt = gesamt.inMilliseconds == 0 ? 0.0 : _vergangen.inMilliseconds / gesamt.inMilliseconds;

    final String phase;
    final String zeile;
    if (_fertig || schritt == null) {
      phase = 'Danke für euren Abend';
      zeile = 'Bleibt liegen, solange es sich gut anfühlt.';
    } else if (runde > 0) {
      phase = 'Runde $runde';
      zeile = ichGebe ? 'Du gibst · $_partnerName empfängt' : '${_partnerName[0].toUpperCase()}${_partnerName.substring(1)} gibt · du empfängst';
    } else {
      final ersteRunde = ablauf.indexWhere((s) => s.runde == 1);
      final letzteRunde = ablauf.lastIndexWhere((s) => s.runde == 2);
      phase = _index < ersteRunde ? 'Ankommen' : (_index > letzteRunde ? 'Ausklang' : 'Rollenwechsel');
      zeile = 'Atmet gemeinsam.';
    }
    final spricht = schritt?.baustein != null;
    final stilleRest = schritt == null ? Duration.zero : schritt.dauer - _imSchritt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fortschritt.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AppTheme.surfaceLight,
              color: AppTheme.amber,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(_vergangen), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              Text(_fmt(gesamt), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ],
          ),
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            width: spricht ? 190 : 160,
            height: spricht ? 190 : 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                (runde == 0 ? AppTheme.amber : AppTheme.rose).withValues(alpha: _pausiert ? 0.15 : 0.45),
                AppTheme.background,
              ]),
            ),
            child: Center(
              child: Icon(
                _fertig ? Icons.favorite_rounded : (spricht ? Icons.graphic_eq_rounded : Icons.spa_rounded),
                color: AppTheme.textPrimary.withValues(alpha: 0.85),
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(phase,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(zeile,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary, height: 1.4)),
          const SizedBox(height: 10),
          if (!_fertig && schritt != null)
            Text(
              _pausiert ? 'Pausiert' : (spricht ? 'Die Stimme spricht …' : 'Stille · noch ${_fmt(stilleRest)}'),
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          const Spacer(),
          if (_fertig)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.amberLight,
                  side: const BorderSide(color: AppTheme.amber),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Schließen', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            )
          else
            PlayerSteuerung(
              pausiert: _pausiert,
              farbe: AppTheme.amber,
              symbolFarbe: AppTheme.background,
              onBeenden: _fragBeenden,
              onPause: _pauseUmschalten,
              onUeberspringen: _weiter,
            ),
          if (_letzteAnsage() case final b?) ...[
            const SizedBox(height: 6),
            AusspracheMeldenButton(wo: 'Gemeinsamer Abend, Baustein ${b.id}', stimme: _stimme),
          ],
        ],
      ),
    );
  }

  /// Die zuletzt gesprochene Ansage – darauf bezieht sich eine Aussprache-Meldung.
  PaarBaustein? _letzteAnsage() {
    final ablauf = _ablauf;
    if (ablauf == null) return null;
    for (var i = (_index < ablauf.length ? _index : ablauf.length - 1); i >= 0; i--) {
      if (ablauf[i].baustein != null) return ablauf[i].baustein;
    }
    return null;
  }
}
