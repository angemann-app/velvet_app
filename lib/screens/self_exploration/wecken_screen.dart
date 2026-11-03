import 'dart:async';

import 'package:flutter/material.dart';
import '../../widgets/aufnahme_status.dart';
import '../../widgets/lautsprecher_frage.dart';
import '../../services/pakete.dart';
import '../../models/wiedergabe_plan.dart';
import '../../services/wiedergabe_plaene.dart';
import '../../services/wiedergabe_dienst.dart';
import '../wiedergabe_screen.dart';
import '../../theme/vp_tokens.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/traum_reise.dart';
import '../../services/naechtliches_wecken.dart';
import '../../services/testmodus.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
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
      _stimme = prefs.getString('traum_stimme') ??
          (profil?.isMale == true ? 'martin' : 'victoria');
    });
  }

  Future<void> _starten() async {
    final traum = _traumDaten;
    if (traum == null) return;
    if (!await frageVorLautsprecher(context) || !mounted) return;
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('traum_stimme', _stimme);

    final ablauf = NaechtlichesWecken.planeBegleitung(
      traum,
      stimme: _stimme,
      abend: StorageService.letzterAbend(),
    );

    if (!mounted) return;
    final plan = WiedergabePlaene.schritte(
        art: WiedergabeArt.wecken,
        titel: t.weckenBegleitungTitel,
        schritte: Testmodus.kuerzen(ablauf),
        stimme: _stimme,
        familie: (_) => 'traum',
        spicy: false,
        parameter: {
          'teppich': _teppich,
          'teppichLaut': _teppichLaut,
          'blendeMs': _ausblenden.inMilliseconds,
          'stimmeVon': 0.85,
          'stimmeBis': 0.55
        });
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(title: Text(t.weckenBegleitungTitel)),
        body: SafeArea(
            child: (_traumDaten) == null
                ? const Center(child: CircularProgressIndicator())
                : _buildEinrichtung()));
  }

  Widget _buildEinrichtung() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(t.wiedergabeStimmenStand, style: context.vp.typo.beschriftung),
        AufnahmeStatus(pfade: [
          for (final b in _traumDaten!.bausteine)
            'audio/traum/${_stimme}_${b.id}.opus'
        ], paketNamen: [
          Pakete.name(Pakete.gefuehrt)
        ]),
        const SizedBox(height: VpAbstand.l),
        Text(
          t.weckenBegleitungEinleitung,
          style:
              TextStyle(fontSize: 14, color: AppTheme.tinteLeise, height: 1.5),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const TraumTagebuchScreen(neuOeffnen: true)),
            ),
            icon: const Icon(Icons.edit_note_rounded),
            label: Text(t.weckenTraumNotieren,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.tinte,
              side: BorderSide(color: AppTheme.linie),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VpRadius.karte)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          t.paarAbendVoice,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.tinte),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            _chip('Victoria', _stimme == 'victoria',
                () => setState(() => _stimme = 'victoria')),
            _chip('Martin', _stimme == 'martin',
                () => setState(() => _stimme = 'martin')),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _teppich,
          activeThumbColor: AppTheme.akzentTief,
          onChanged: (v) => setState(() => _teppich = v),
          title: Text(t.paarAbendSoftSoundBed,
              style: TextStyle(color: AppTheme.tinte, fontSize: 14.5)),
          subtitle: Text(
            t.paarAbendCalmBackgroundDuringTheSilences,
            style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5),
          ),
        ),
        if (_traumDaten?.hinweis('hinweis_schlafparalyse') != null) ...[
          const SizedBox(height: 14),
          Text(
            _traumDaten!.hinweis('hinweis_schlafparalyse')!,
            style: TextStyle(
                fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _starten,
            icon: const Icon(Icons.nights_stay_rounded),
            label: Text(t.weckenBegleitungStarten,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15.5)),
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
}
