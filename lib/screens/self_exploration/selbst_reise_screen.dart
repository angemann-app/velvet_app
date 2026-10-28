import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/paar_abend.dart';
import '../../models/selbst_reise.dart';
import '../../services/audio_ausgabe.dart';
import '../../services/sprachausgabe.dart';
import '../../services/testmodus.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aussprache_melden.dart';
import '../../widgets/lautsprecher_frage.dart';
import '../../widgets/player_steuerung.dart';
import '../../l10n/t.dart';

/// Geführte Selbsterkundung: eine Stimme begleitet durch Ankommen, Atem, eine Körperreise
/// und – wenn gewählt – intime Berührung mit Wellen. Jede Reise wird neu zusammengestellt
/// (lib/models/selbst_reise.dart, Texte in assets/data/selbst_reise.json).
class SelbstReiseScreen extends StatefulWidget {
  const SelbstReiseScreen({super.key});

  @override
  State<SelbstReiseScreen> createState() => _SelbstReiseScreenState();
}

class _SelbstReiseScreenState extends State<SelbstReiseScreen> {
  static const _keyMinuten = 'selbst_reise_minuten';
  static const _keyTiefe = 'selbst_reise_tiefe';
  static const _keyKoerper = 'selbst_reise_koerper';
  static const _keyStimme = 'selbst_reise_stimme';
  static const _keyZuletzt = 'selbst_reise_zuletzt';
  static const _minutenOptionen = [10, 20, 30];

  SelbstReiseDaten? _daten;
  int _minuten = 20;
  PaarTiefe _tiefe = PaarTiefe.bekleidet;
  String _koerper = 'vulva';
  String _stimme = 'victoria';
  bool _teppich = true;

  List<PaarSchritt>? _ablauf;
  int _index = 0;
  Duration _imSchritt = Duration.zero;
  bool _pausiert = false;
  bool _fertig = false;
  int _lauf = 0;

  final AudioPlayer _stimmePlayer = AudioPlayer();
  final AudioPlayer _klangPlayer = AudioPlayer();
  final AudioPlayer _teppichPlayer = AudioPlayer();
  StreamSubscription<void>? _kopfhoererSub;

  @override
  void initState() {
    super.initState();
    final ohneFokus = AudioContext(android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none));
    _stimmePlayer.setAudioContext(ohneFokus).catchError((_) {});
    _klangPlayer.setAudioContext(ohneFokus).catchError((_) {});
    _teppichPlayer.setReleaseMode(ReleaseMode.loop).catchError((_) {});
    AudioAusgabe.instanz.initialisieren();
    _kopfhoererSub = AudioAusgabe.instanz.onKopfhoererGetrennt.listen((_) {
      if (!mounted) return;
      if (StorageService.getPausiereBeiKopfhoererGetrennt() && _ablauf != null && !_fertig && !_pausiert) {
        _pauseUmschalten();
      }
    });
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await SelbstReiseDaten.laden();
    final profil = StorageService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _minuten = prefs.getInt(_keyMinuten) ?? 20;
      _tiefe = tiefeAusName(prefs.getString(_keyTiefe), spicyErlaubt: StorageService.spicyMode());
      _koerper = prefs.getString(_keyKoerper) ?? (profil?.isMale == true ? 'penis' : 'vulva');
      _stimme = prefs.getString(_keyStimme) ?? (profil?.isMale == true ? 'martin' : 'victoria');
    });
  }

  @override
  void dispose() {
    _lauf++;
    _kopfhoererSub?.cancel();
    Sprachausgabe.vorlesenBeenden();
    _stimmePlayer.dispose();
    _klangPlayer.dispose();
    _teppichPlayer.dispose();
    super.dispose();
  }

  Future<void> _starten() async {
    final daten = _daten;
    if (daten == null) return;
    final darf = await frageVorLautsprecher(context);
    if (!darf) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinuten, _minuten);
    await prefs.setString(_keyTiefe, _tiefe.name);
    await prefs.setString(_keyKoerper, _koerper);
    await prefs.setString(_keyStimme, _stimme);
    final zuletzt = prefs.getStringList(_keyZuletzt) ?? [];
    final ablauf = daten.planen(
        minuten: _minuten, tiefe: _tiefe, koerper: _koerper, stimme: _stimme, zuletzt: zuletzt.toSet());
    final neu = [for (final s in ablauf) if (s.baustein != null) s.baustein!.id];
    await prefs.setStringList(_keyZuletzt, [...neu, ...zuletzt].take(30).toList());

    setState(() {
      _ablauf = Testmodus.kuerzen(ablauf);
      _index = 0;
      _imSchritt = Duration.zero;
      _pausiert = false;
      _fertig = false;
    });
    if (_teppich) {
      _teppichPlayer.setVolume(0.3).catchError((_) {});
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
        Sprachausgabe.sprich(_stimmePlayer, 'audio/selbst/${_stimme}_${schritt.baustein!.id}.opus',
            schritt.baustein!.text);
      }
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
    for (var v = 0.3; v > 0; v -= 0.05) {
      await _teppichPlayer.setVolume(v).catchError((_) {});
      await Future.delayed(const Duration(milliseconds: 400));
    }
    await _teppichPlayer.stop().catchError((_) {});
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
        appBar: AppBar(backgroundColor: AppTheme.background, title: Text(t.lessonDetailGuidedSelfExploration)),
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
        title: Text(t.selbstReiseEndTheJourney),
        content: Text(t.selbstReiseTheGuidanceStopsThenYou),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.paarAbendContinue)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.playerSteuerungStop)),
        ],
      ),
    );
    if (ja == true && mounted) _beenden();
  }

  Widget _buildEinrichtung() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(
          t.selbstReiseAVoiceGuidesYouThrough,
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(
            t.selbstReiseYouDecideYouCanPause,
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
          ),
        ),
        const SizedBox(height: 22),
        _titel(t.paarAbendDuration),
        Wrap(spacing: 8, children: [
          for (final m in _minutenOptionen) _chip(t.selbstReiseMMin(m), _minuten == m, () => setState(() => _minuten = m)),
        ]),
        const SizedBox(height: 20),
        _titel(t.selbstReiseHowCloseWouldYouLike),
        for (final tiefe in waehlbareTiefen(spicyErlaubt: StorageService.spicyMode()))
          switch (tiefe) {
            PaarTiefe.bekleidet => _tiefeOption(tiefe, t.selbstReiseGentle, t.selbstReiseFaceScalpEarsNeckArms),
            PaarTiefe.haut => _tiefeOption(tiefe, t.selbstReiseSkin, t.selbstReisePlusBareSkinWithOil),
            PaarTiefe.intim => _tiefeOption(tiefe, t.paarAbendIntimate, t.selbstReisePlusPerineumAndGenitalsWith),
            PaarTiefe.spicy => _tiefeOption(tiefe, t.spicyStufe, t.selbstReiseSpicyText),
            PaarTiefe.sehrSpicy => _tiefeOption(tiefe, t.sehrSpicyStufe, t.selbstReiseSehrSpicyText),
          },
        if (_tiefe.index >= PaarTiefe.intim.index) ...[
          const SizedBox(height: 12),
          _titel(t.selbstReiseYourBody),
          Wrap(spacing: 8, children: [
            _chip(t.selbstReiseVulva, _koerper == 'vulva', () => setState(() => _koerper = 'vulva')),
            _chip(t.selbstReisePenis, _koerper == 'penis', () => setState(() => _koerper = 'penis')),
          ]),
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
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(t.selbstReiseBeginTheJourney, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
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

  Widget _tiefeOption(PaarTiefe tiefe, String titel, String text) {
    final aktiv = _tiefe == tiefe;
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
            color: aktiv ? AppTheme.rose.withValues(alpha: 0.10) : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: aktiv ? AppTheme.rose : AppTheme.border),
          ),
          child: Row(children: [
            Icon(aktiv ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: aktiv ? AppTheme.rose : AppTheme.textMuted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titel, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final ablauf = _ablauf!;
    final schritt = _index < ablauf.length ? ablauf[_index] : null;
    final ersteReise = ablauf.indexWhere((s) => s.runde == 1);
    final letzteReise = ablauf.lastIndexWhere((s) => s.runde == 1);
    final phase = _fertig || schritt == null
        ? t.selbstReiseThankYou
        : (schritt.runde == 1 ? t.selbstReiseBodyJourney : (_index < ersteReise ? t.paarAbendArriving : (_index > letzteReise ? t.paarAbendEnding : t.selbstReiseBodyJourney)));
    final spricht = schritt?.baustein != null;
    final gesamt = _gesamt;
    final fortschritt = gesamt.inMilliseconds == 0 ? 0.0 : _vergangen.inMilliseconds / gesamt.inMilliseconds;
    final stilleRest = schritt == null ? Duration.zero : schritt.dauer - _imSchritt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fortschritt.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: AppTheme.surfaceLight,
            color: AppTheme.rose,
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
          width: spricht ? 190 : 160,
          height: spricht ? 190 : 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppTheme.rose.withValues(alpha: _pausiert ? 0.15 : 0.42),
              AppTheme.background,
            ]),
          ),
          child: Center(
            child: Icon(_fertig ? Icons.favorite_rounded : (spricht ? Icons.graphic_eq_rounded : Icons.spa_rounded),
                color: AppTheme.textPrimary.withValues(alpha: 0.85), size: 44),
          ),
        ),
        const SizedBox(height: 28),
        Text(phase, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        if (!_fertig && schritt != null)
          Text(
            _pausiert ? t.paarAbendPaused : (spricht ? t.paarAbendTheVoiceIsSpeaking : t.selbstReiseSilenceStillerestLeft(_fmt(stilleRest))),
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
          )
        else
          Text(t.selbstReiseStayLyingDownAsLong,
              style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
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
        if (_letzteAnsage() case final b?) ...[
          const SizedBox(height: 6),
          AusspracheMeldenButton(wo: 'Geführte Selbsterkundung, Baustein ${b.id}', stimme: _stimme),
        ],
      ]),
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
