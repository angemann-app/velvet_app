import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/paar_abend.dart';
import '../../models/traum_reise.dart';
import '../../services/naechtliches_wecken.dart';
import '../../services/sprachausgabe.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aussprache_melden.dart';
import '../../widgets/player_steuerung.dart';
import 'traum_tagebuch_screen.dart';

/// Kurze, leise Begleitung zum Wiedereinschlafen nach dem nächtlichen Wecken
/// (docs/konzepte/traum-reise.md, „Wecken und Wiedereinschlafen“).
class WeckenScreen extends StatefulWidget {
  const WeckenScreen({super.key});

  @override
  State<WeckenScreen> createState() => _WeckenScreenState();
}

class _WeckenScreenState extends State<WeckenScreen> {
  static const _teppichLaut = 0.22;
  static const _ausblenden = Duration(minutes: 10);

  TraumDaten? _traumDaten;
  String _stimme = 'victoria';
  bool _teppich = true;

  List<PaarSchritt>? _ablauf;
  int _index = 0;
  Duration _imSchritt = Duration.zero;
  bool _pausiert = false;
  bool _fertig = false;
  int _lauf = 0;

  final AudioPlayer _stimmePlayer = AudioPlayer();
  final AudioPlayer _teppichPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    final ohneFokus = AudioContext(android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none));
    _stimmePlayer.setAudioContext(ohneFokus).catchError((_) {});
    _teppichPlayer.setAudioContext(ohneFokus).catchError((_) {});
    _teppichPlayer.setReleaseMode(ReleaseMode.loop).catchError((_) {});
    NaechtlichesWecken.begleitungAbschliessen();
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final traumDaten = await TraumDaten.laden();
    final profil = StorageService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _traumDaten = traumDaten;
      _stimme = prefs.getString('traum_stimme') ?? (profil?.isMale == true ? 'martin' : 'victoria');
    });
  }

  @override
  void dispose() {
    _lauf++;
    Sprachausgabe.vorlesenBeenden();
    _stimmePlayer.dispose();
    _teppichPlayer.dispose();
    super.dispose();
  }

  Future<void> _starten() async {
    final traum = _traumDaten;
    if (traum == null) return;
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('traum_stimme', _stimme);

    final ablauf = NaechtlichesWecken.planeBegleitung(
      traum,
      stimme: _stimme,
      abend: StorageService.letzterAbend(),
    );

    setState(() {
      _ablauf = ablauf;
      _index = 0;
      _imSchritt = Duration.zero;
      _pausiert = false;
      _fertig = false;
    });
    if (_teppich) {
      _teppichPlayer.setVolume(_teppichLaut).catchError((_) {});
      _teppichPlayer.play(AssetSource('audio/paar/klangteppich.opus')).catchError((_) {});
    }
    _abspielen(++_lauf);
  }

  bool _abgebrochen(int lauf) => lauf != _lauf || !mounted;

  /// Noch leiser als am Abend: von 85 % sanft auf 55 %.
  double _stimmeLautstaerke() {
    final g = _gesamt.inMilliseconds;
    if (g == 0) return 0.85;
    return 0.85 - 0.30 * (_vergangen.inMilliseconds / g).clamp(0.0, 1.0);
  }

  Future<void> _abspielen(int lauf) async {
    final ablauf = _ablauf!;
    while (_index < ablauf.length) {
      final schritt = ablauf[_index];
      final letzter = _index == ablauf.length - 1;
      if (schritt.baustein != null) {
        _stimmePlayer.setVolume(_stimmeLautstaerke()).catchError((_) {});
        Sprachausgabe.sprich(
          _stimmePlayer,
          'audio/traum/${_stimme}_${schritt.baustein!.id}.opus',
          schritt.baustein!.text,
        );
      }
      final blende = letzter ? (schritt.dauer < _ausblenden ? schritt.dauer : _ausblenden) : Duration.zero;
      final blendeStart = schritt.dauer - blende;
      var letzteLautstaerke = -1.0;
      while (_imSchritt < schritt.dauer) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (_abgebrochen(lauf)) return;
        if (!_pausiert) {
          setState(() => _imSchritt += const Duration(milliseconds: 250));
          if (letzter && _teppich && _imSchritt > blendeStart && blende > Duration.zero) {
            final rest = 1 - (_imSchritt - blendeStart).inMilliseconds / blende.inMilliseconds;
            final v = (_teppichLaut * rest).clamp(0.0, _teppichLaut);
            if ((v - letzteLautstaerke).abs() > 0.005) {
              letzteLautstaerke = v;
              _teppichPlayer.setVolume(v).catchError((_) {});
            }
          }
        }
      }
      if (_abgebrochen(lauf)) return;
      setState(() {
        _index++;
        _imSchritt = Duration.zero;
      });
    }
    await _teppichPlayer.stop().catchError((_) {});
    await _stimmePlayer.stop().catchError((_) {});
    if (_abgebrochen(lauf)) return;
    setState(() => _fertig = true);
  }

  void _pauseUmschalten() {
    HapticFeedback.lightImpact();
    setState(() => _pausiert = !_pausiert);
    if (_pausiert) {
      Sprachausgabe.pause(_stimmePlayer);
      _teppichPlayer.pause().catchError((_) {});
    } else {
      _stimmePlayer.resume().catchError((_) {});
      if (_teppich) _teppichPlayer.resume().catchError((_) {});
    }
  }

  void _weiter() {
    final ablauf = _ablauf;
    if (ablauf == null || _index >= ablauf.length) return;
    HapticFeedback.selectionClick();
    Sprachausgabe.stopp(_stimmePlayer);
    setState(() => _imSchritt = ablauf[_index].dauer);
  }

  void _beenden() {
    _lauf++;
    Sprachausgabe.stopp(_stimmePlayer);
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
      '${d.inMinutes}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final laeuft = _ablauf != null;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(t.weckenBegleitungTitel),
      ),
      body: SafeArea(
        child: _traumDaten == null
            ? const Center(child: CircularProgressIndicator(color: AppTheme.rose))
            : (laeuft ? _buildPlayer() : _buildEinrichtung()),
      ),
    );
  }

  Widget _buildEinrichtung() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          t.weckenBegleitungEinleitung,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TraumTagebuchScreen(neuOeffnen: true)),
            ),
            icon: const Icon(Icons.edit_note_rounded),
            label: Text(t.weckenTraumNotieren, style: const TextStyle(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              side: const BorderSide(color: AppTheme.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          t.paarAbendVoice,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 10),
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
          activeThumbColor: AppTheme.rose,
          onChanged: (v) => setState(() => _teppich = v),
          title: Text(t.paarAbendSoftSoundBed, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14.5)),
          subtitle: Text(
            t.paarAbendCalmBackgroundDuringTheSilences,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
          ),
        ),
        if (_traumDaten?.hinweis('hinweis_schlafparalyse') != null) ...[
          const SizedBox(height: 14),
          Text(
            _traumDaten!.hinweis('hinweis_schlafparalyse')!,
            style: const TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.nights_stay_rounded),
            label: Text(t.weckenBegleitungStarten, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.rose,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

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

  Widget _buildPlayer() {
    final ablauf = _ablauf!;
    final gesamt = _gesamt;
    final fortschritt = gesamt.inMilliseconds == 0 ? 0.0 : _vergangen.inMilliseconds / gesamt.inMilliseconds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fortschritt.clamp(0.0, 1.0),
              minHeight: 3,
              backgroundColor: AppTheme.surfaceLight,
              color: AppTheme.rose.withValues(alpha: 0.6),
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
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.rose.withValues(alpha: _pausiert ? 0.06 : 0.22),
                  AppTheme.background,
                ],
              ),
            ),
            child: Center(
              child: Icon(Icons.nights_stay_rounded, color: AppTheme.textPrimary.withValues(alpha: 0.5), size: 40),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.weckenLaeuft,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            _pausiert ? t.paarAbendPaused : t.weckenLaeuftText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
          ),
          const Spacer(),
          if (_fertig)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.rose,
                  side: const BorderSide(color: AppTheme.rose),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(t.couplesChannelClose, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            )
          else
            PlayerSteuerung(
              pausiert: _pausiert,
              farbe: AppTheme.rose,
              symbolFarbe: Colors.white,
              onBeenden: _beenden,
              onPause: _pauseUmschalten,
              onUeberspringen: _weiter,
            ),
          if (_letzteAnsage(ablauf) case final b?) ...[
            const SizedBox(height: 6),
            AusspracheMeldenButton(wo: 'Nächtliches Wecken, Baustein ${b.id}', stimme: _stimme),
          ],
        ],
      ),
    );
  }

  PaarBaustein? _letzteAnsage(List<PaarSchritt> ablauf) {
    for (var i = (_index < ablauf.length ? _index : ablauf.length - 1); i >= 0; i--) {
      if (ablauf[i].baustein != null) return ablauf[i].baustein;
    }
    return null;
  }
}
