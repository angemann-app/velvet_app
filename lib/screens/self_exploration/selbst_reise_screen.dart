import 'dart:async';

import 'package:flutter/material.dart';
import '../../widgets/aufnahme_status.dart';
import '../../services/pakete.dart';
import '../../models/wiedergabe_plan.dart';
import '../../services/wiedergabe_plaene.dart';
import '../../services/wiedergabe_dienst.dart';
import '../wiedergabe_screen.dart';
import '../../theme/vp_tokens.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/paar_abend.dart';
import '../../models/selbst_reise.dart';
import '../../services/testmodus.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lautsprecher_frage.dart';
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

  @override
  void initState() {
    super.initState();
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
      _tiefe = tiefeAusName(prefs.getString(_keyTiefe),
          spicyErlaubt: StorageService.spicyMode());
      _koerper = prefs.getString(_keyKoerper) ?? StorageService.koerperVorschlag();
      _stimme = prefs.getString(_keyStimme) ??
          (profil?.isMale == true ? 'martin' : 'victoria');
    });
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
        minuten: _minuten,
        tiefe: _tiefe,
        koerper: _koerper,
        stimme: _stimme,
        zuletzt: zuletzt.toSet());
    final neu = [
      for (final s in ablauf)
        if (s.baustein != null) s.baustein!.id
    ];
    await prefs.setStringList(
        _keyZuletzt, [...neu, ...zuletzt].take(30).toList());

    if (!mounted) return;
    final plan = WiedergabePlaene.schritte(
        art: WiedergabeArt.selbst,
        titel: t.lessonDetailGuidedSelfExploration,
        schritte: Testmodus.kuerzen(ablauf),
        stimme: _stimme,
        familie: (_) => 'selbst',
        spicy: _tiefe.istSpicy,
        parameter: {
          'teppich': _teppich,
          'teppichLaut': 0.3,
          'tiefe': _tiefe.name,
          'koerper': _koerper
        });
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(title: Text(t.lessonDetailGuidedSelfExploration)),
        body: SafeArea(
            child: (_daten) == null
                ? const Center(child: CircularProgressIndicator())
                : _buildEinrichtung()));
  }

  Widget _buildEinrichtung() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(t.wiedergabeStimmenStand, style: context.vp.typo.beschriftung),
        AufnahmeStatus(pfade: [
          for (final b in _daten!.bausteine)
            'audio/selbst/${_stimme}_${b.id}.opus'
        ], paketNamen: [
          Pakete.name(Pakete.gefuehrt)
        ]),
        const SizedBox(height: VpAbstand.l),
        Text(
          t.selbstReiseAVoiceGuidesYouThrough,
          style:
              TextStyle(fontSize: 14, color: AppTheme.tinteLeise, height: 1.5),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.linie),
          ),
          child: Text(
            t.selbstReiseYouDecideYouCanPause,
            style: TextStyle(
                fontSize: 13, color: AppTheme.tinteLeise, height: 1.5),
          ),
        ),
        const SizedBox(height: 22),
        _titel(t.paarAbendDuration),
        Wrap(spacing: 8, children: [
          for (final m in _minutenOptionen)
            _chip(t.selbstReiseMMin(m), _minuten == m,
                () => setState(() => _minuten = m)),
        ]),
        const SizedBox(height: 20),
        _titel(t.selbstReiseHowCloseWouldYouLike),
        for (final tiefe
            in waehlbareTiefen(spicyErlaubt: StorageService.spicyMode()))
          switch (tiefe) {
            PaarTiefe.bekleidet => _tiefeOption(
                tiefe, t.selbstReiseGentle, t.selbstReiseFaceScalpEarsNeckArms),
            PaarTiefe.haut => _tiefeOption(
                tiefe, t.selbstReiseSkin, t.selbstReisePlusBareSkinWithOil),
            PaarTiefe.intim => _tiefeOption(tiefe, t.paarAbendIntimate,
                t.selbstReisePlusPerineumAndGenitalsWith),
            PaarTiefe.spicy =>
              _tiefeOption(tiefe, t.spicyStufe, t.selbstReiseSpicyText),
            PaarTiefe.sehrSpicy =>
              _tiefeOption(tiefe, t.sehrSpicyStufe, t.selbstReiseSehrSpicyText),
          },
        if (_tiefe.index >= PaarTiefe.intim.index) ...[
          const SizedBox(height: 12),
          _titel(t.selbstReiseYourBody),
          Wrap(spacing: 8, children: [
            _chip(t.selbstReiseVulva, _koerper == 'vulva',
                () => setState(() => _koerper = 'vulva')),
            _chip(t.selbstReisePenis, _koerper == 'penis',
                () => setState(() => _koerper = 'penis')),
          ]),
        ],
        const SizedBox(height: 20),
        _titel(t.paarAbendVoice),
        Wrap(spacing: 8, children: [
          _chip('Victoria', _stimme == 'victoria',
              () => setState(() => _stimme = 'victoria')),
          _chip('Martin', _stimme == 'martin',
              () => setState(() => _stimme = 'martin')),
        ]),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _teppich,
          activeThumbColor: AppTheme.akzentTief,
          onChanged: (v) => setState(() => _teppich = v),
          title: Text(t.paarAbendSoftSoundBed,
              style: TextStyle(color: AppTheme.tinte, fontSize: 14.5)),
          subtitle: Text(t.paarAbendCalmBackgroundDuringTheSilences,
              style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5)),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(t.selbstReiseBeginTheJourney,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.akzent,
              foregroundColor: AppTheme.aufAkzent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VpRadius.karte)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.tinte)),
      );

  Widget _chip(String label, bool aktiv, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: aktiv,
        onSelected: (_) {
          HapticFeedback.selectionClick();
          onTap();
        },
        selectedColor: AppTheme.akzentTief.withValues(alpha: 0.22),
        backgroundColor: AppTheme.papierErhoben,
        side: BorderSide(color: aktiv ? AppTheme.akzentTief : AppTheme.linie),
        labelStyle: TextStyle(
            color: aktiv ? AppTheme.tinte : AppTheme.tinteLeise,
            fontWeight: FontWeight.w600),
        showCheckmark: false,
      );

  Widget _tiefeOption(PaarTiefe tiefe, String titel, String text) {
    final aktiv = _tiefe == tiefe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(VpRadius.karte),
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _tiefe = tiefe);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: aktiv
                ? AppTheme.akzentTief.withValues(alpha: 0.10)
                : AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border:
                Border.all(color: aktiv ? AppTheme.akzentTief : AppTheme.linie),
          ),
          child: Row(children: [
            Icon(
                aktiv
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: aktiv ? AppTheme.akzentTief : AppTheme.tinteStumm,
                size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titel,
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.tinte)),
                    const SizedBox(height: 2),
                    Text(text,
                        style: TextStyle(
                            fontSize: 12.5,
                            color: AppTheme.tinteLeise,
                            height: 1.35)),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
