import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/einschlaf_reise.dart';
import '../../models/paar_abend.dart';
import '../../services/sprachausgabe.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aussprache_melden.dart';
import '../../widgets/player_steuerung.dart';

/// Einschlaf-Reise: eine lange, ruhige Begleitung in den Schlaf (lib/models/einschlaf_reise.dart,
/// Texte in assets/data/einschlaf_reise.json). Die Stimme wird über die Reise leiser, der Klangteppich
/// blendet in der Schlussstille aus; danach stoppt alles von selbst.
class EinschlafReiseScreen extends StatefulWidget {
  const EinschlafReiseScreen({super.key});

  @override
  State<EinschlafReiseScreen> createState() => _EinschlafReiseScreenState();
}

class _EinschlafReiseScreenState extends State<EinschlafReiseScreen> {
  static const _keyMinuten = 'einschlaf_minuten';
  static const _keyThema = 'einschlaf_thema';
  static const _keyKoerper = 'einschlaf_koerper';
  static const _keySpicy = 'einschlaf_spicy';
  static const _keyStimme = 'einschlaf_stimme';
  static const _keyZuletzt = 'einschlaf_zuletzt';

  /// Lautstärke des Klangteppichs, solange er nicht ausblendet.
  static const _teppichLaut = 0.3;

  /// So lange blendet der Klangteppich in der Schlussstille aus (höchstens).
  static const _ausblenden = Duration(minutes: 10);

  EinschlafDaten? _daten;
  int _minuten = 90;
  String? _thema; // null = Überrasch mich
  String _koerper = 'neutral';
  bool _spicy = false;
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
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await EinschlafDaten.laden();
    final profil = StorageService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      final m = prefs.getInt(_keyMinuten);
      _minuten = EinschlafDaten.laengen.contains(m) ? m! : 90;
      final th = prefs.getString(_keyThema);
      _thema = EinschlafDaten.themen.contains(th) ? th : null;
      _koerper = prefs.getString(_keyKoerper) ?? 'neutral';
      _spicy = StorageService.spicyMode() && (prefs.getBool(_keySpicy) ?? false);
      _stimme = prefs.getString(_keyStimme) ?? (profil?.isMale == true ? 'martin' : 'victoria');
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
    final daten = _daten;
    if (daten == null) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinuten, _minuten);
    if (_thema == null) {
      await prefs.remove(_keyThema);
    } else {
      await prefs.setString(_keyThema, _thema!);
    }
    await prefs.setString(_keyKoerper, _koerper);
    await prefs.setBool(_keySpicy, _spicy);
    await prefs.setString(_keyStimme, _stimme);
    final zuletzt = prefs.getStringList(_keyZuletzt) ?? [];
    final ablauf = daten.planen(
      minuten: _minuten,
      thema: _thema,
      koerper: _koerper,
      spicy: _spicy && StorageService.spicyMode(),
      stimme: _stimme,
      zuletzt: zuletzt.toSet(),
    );
    final neu = [for (final s in ablauf) if (s.baustein != null) s.baustein!.id];
    await prefs.setStringList(_keyZuletzt, [...neu, ...zuletzt].take(60).toList());

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

  /// Die Stimme wird über die Reise hinweg leiser: von 100 % auf 70 %.
  double _stimmeLautstaerke() {
    final g = _gesamt.inMilliseconds;
    if (g == 0) return 1;
    return 1 - 0.3 * (_vergangen.inMilliseconds / g).clamp(0.0, 1.0);
  }

  Future<void> _abspielen(int lauf) async {
    final ablauf = _ablauf!;
    while (_index < ablauf.length) {
      final schritt = ablauf[_index];
      final letzter = _index == ablauf.length - 1;
      if (schritt.baustein != null) {
        _stimmePlayer.setVolume(_stimmeLautstaerke()).catchError((_) {});
        Sprachausgabe.sprich(_stimmePlayer, 'audio/einschlaf/${_stimme}_${schritt.baustein!.id}.opus',
            schritt.baustein!.text);
      }
      // Ausblenden: In der Schlussstille wird der Klangteppich leiser, bis er verschwindet.
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
            // Nur in kleinen Stufen nachstellen, nicht alle 250 ms.
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
    // Ende: alles stoppt von selbst und gibt den Audio-Fokus frei, ohne Ton und ohne Benachrichtigung.
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
      '${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  String _themaName(String id) => switch (id) {
        'koerper' => t.einschlafThemaKoerper,
        'welle' => t.einschlafThemaWelle,
        'gaspedal' => t.einschlafThemaGaspedal,
        'spueren' => t.einschlafThemaSpueren,
        'becken' => t.einschlafThemaBecken,
        _ => t.einschlafThemaGeniessen,
      };

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
        appBar: AppBar(backgroundColor: AppTheme.background, title: Text(t.einschlafTitel)),
        body: SafeArea(
          child: _daten == null
              ? const Center(child: CircularProgressIndicator(color: AppTheme.rose))
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
        title: Text(t.einschlafBeenden),
        content: Text(t.einschlafBeendenText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.paarAbendContinue)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.playerSteuerungStop)),
        ],
      ),
    );
    if (ja == true && mounted) _beenden();
  }

  Widget _buildEinrichtung() {
    final spicyModus = StorageService.spicyMode();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(t.einschlafEinleitung, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(t.einschlafWirkung, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
        ),
        const SizedBox(height: 22),
        _titel(t.einschlafLaenge),
        Wrap(spacing: 8, children: [
          for (final m in EinschlafDaten.laengen) _chip(t.selbstReiseMMin(m), _minuten == m, () => setState(() => _minuten = m)),
        ]),
        const SizedBox(height: 20),
        _titel(t.einschlafSchwerpunkt),
        Wrap(spacing: 8, runSpacing: 4, children: [
          _chip(t.einschlafUeberrasch, _thema == null, () => setState(() => _thema = null)),
          for (final th in EinschlafDaten.themen) _chip(_themaName(th), _thema == th, () => setState(() => _thema = th)),
        ]),
        if (spicyModus) ...[
          const SizedBox(height: 20),
          _titel(t.selbstReiseYourBody),
          Wrap(spacing: 8, children: [
            _chip(t.selbstReiseVulva, _koerper == 'vulva', () => setState(() => _koerper = 'vulva')),
            _chip(t.selbstReisePenis, _koerper == 'penis', () => setState(() => _koerper = 'penis')),
            _chip(t.einschlafOhneBezug, _koerper == 'neutral', () => setState(() => _koerper = 'neutral')),
          ]),
          if (_koerper != 'neutral')
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _spicy,
              activeThumbColor: AppTheme.rose,
              onChanged: (v) => setState(() => _spicy = v),
              title: Text(t.einschlafSpicyTitel, style: TextStyle(color: AppTheme.textPrimary, fontSize: 14.5)),
              subtitle: Text(t.einschlafSpicyText, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
            ),
        ],
        const SizedBox(height: 20),
        _titel(t.paarAbendVoice),
        Wrap(spacing: 8, children: [
          _chip('Victoria', _stimme == 'victoria', () => setState(() => _stimme = 'victoria')),
          _chip('Martin', _stimme == 'martin', () => setState(() => _stimme = 'martin')),
        ]),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _teppich,
          activeThumbColor: AppTheme.rose,
          onChanged: (v) => setState(() => _teppich = v),
          title: Text(t.paarAbendSoftSoundBed, style: TextStyle(color: AppTheme.textPrimary, fontSize: 14.5)),
          subtitle: Text(t.paarAbendCalmBackgroundDuringTheSilences,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
        ),
        const SizedBox(height: 14),
        Text(t.einschlafHinweise, style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.bedtime_rounded),
            label: Text(t.einschlafStart, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
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

  Widget _buildPlayer() {
    final ablauf = _ablauf!;
    final gesamt = _gesamt;
    final fortschritt = gesamt.inMilliseconds == 0 ? 0.0 : _vergangen.inMilliseconds / gesamt.inMilliseconds;

    // Ruhige, dunkle Ansicht: wenig Licht, kein Zählen herunter, nur ein leiser Fortschritt.
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(children: [
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_fmt(_vergangen), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          Text(_fmt(gesamt), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
        ]),
        const Spacer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppTheme.rose.withValues(alpha: _pausiert ? 0.08 : 0.28),
              AppTheme.background,
            ]),
          ),
          child: Center(
            child: Icon(Icons.bedtime_rounded, color: AppTheme.textPrimary.withValues(alpha: 0.6), size: 44),
          ),
        ),
        const SizedBox(height: 28),
        Text(_fertig ? t.einschlafLaeuft : t.einschlafLaeuft,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
        const SizedBox(height: 10),
        Text(_pausiert ? t.paarAbendPaused : t.einschlafLaeuftText,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4)),
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
              child: Text(t.couplesChannelClose, style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          )
        else
          PlayerSteuerung(
            pausiert: _pausiert,
            farbe: AppTheme.rose,
            symbolFarbe: Colors.white,
            onBeenden: _fragBeenden,
            onPause: _pauseUmschalten,
            onUeberspringen: _weiter,
          ),
        if (_letzteAnsage(ablauf) case final b?) ...[
          const SizedBox(height: 6),
          AusspracheMeldenButton(wo: 'Einschlaf-Reise, Baustein ${b.id}', stimme: _stimme),
        ],
      ]),
    );
  }

  /// Die zuletzt gesprochene Ansage – darauf bezieht sich eine Aussprache-Meldung.
  PaarBaustein? _letzteAnsage(List<PaarSchritt> ablauf) {
    for (var i = (_index < ablauf.length ? _index : ablauf.length - 1); i >= 0; i--) {
      if (ablauf[i].baustein != null) return ablauf[i].baustein;
    }
    return null;
  }
}
