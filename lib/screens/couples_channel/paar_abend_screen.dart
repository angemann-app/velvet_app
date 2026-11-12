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
import '../../services/nostr_service.dart';
import '../../services/testmodus.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lautsprecher_frage.dart';
import '../../l10n/t.dart';

/// Körper aus dem Geschlecht ('female' Vulva, 'male' Penis); unbekannt, divers oder keine Angabe: null,
/// es wird nichts angenommen.
String? paarAbendKoerper(String? geschlecht) => switch (geschlecht) {
      'female' => 'vulva',
      'male' => 'penis',
      _ => null
    };

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

  // erhöht sich bei jedem Start/Stopp, damit alte Abläufe sich beenden

  String get _ichName {
    final name = StorageService.getUserProfile()?.name.trim() ?? '';
    return name.isEmpty ? t.paarAbendYou : name;
  }

  String get _partnerName {
    final nostr = NostrService();
    final name = nostr.isPaired ? nostr.partnerName.trim() : '';
    return name.isEmpty ? t.paarAbendYourPartner : name;
  }

  @override
  void initState() {
    super.initState();
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await PaarAbendDaten.laden();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _minuten = prefs.getInt(_keyMinuten) ?? 30;
      _tiefe = tiefeAusName(prefs.getString(_keyTiefe),
          spicyErlaubt: StorageService.spicyMode());
      _stimme = prefs.getString(_keyStimme) ??
          (StorageService.getUserProfile()?.isFemale == true
              ? 'martin'
              : 'victoria');
    });
  }

  // ---------------------------------------------------------------------------
  // Ablauf

  Future<void> _starten() async {
    final daten = _daten;
    if (daten == null) return;
    final darf = await frageVorLautsprecher(context);
    if (!darf) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinuten, _minuten);
    await prefs.setString(_keyTiefe, _tiefe.name);
    await prefs.setString(_keyStimme, _stimme);

    final zuletzt = prefs.getStringList(_keyZuletzt) ?? [];
    final ablauf = daten.planen(
        minuten: _minuten,
        tiefe: _tiefe,
        stimme: _stimme,
        zuletzt: zuletzt.toSet(),
        empfaenger: _empfaenger());
    final neu = [
      for (final s in ablauf)
        if (s.baustein != null) s.baustein!.id
    ];
    // Die letzten zwei Abende merken, damit der nächste möglichst andere Varianten bekommt.
    await prefs.setStringList(
        _keyZuletzt, [...neu, ...zuletzt].take(60).toList());

    if (!mounted) return;
    final plan = WiedergabePlaene.schritte(
        art: WiedergabeArt.paar,
        titel: t.couplesChannelSharedEvening,
        schritte: Testmodus.kuerzen(ablauf),
        stimme: _stimme,
        familie: (_) => 'paar',
        spicy: _tiefe.istSpicy,
        parameter: {
          'teppich': _teppich,
          'teppichLaut': 0.35,
          'ichZuerst': _ichZuerst,
          'tiefe': _tiefe.name
        });
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  /// Körper der Person, die in Runde 1 und 2 empfängt. Eigener Körper: die gespeicherte Wahl, sonst
  /// aus dem Geschlecht (Frau, Mann; sonst offen). Das Gegenüber kommt aus dem Paar-Kanal; ist es
  /// unbekannt oder divers, bleibt der Körper offen (null), es wird nichts angenommen.
  List<String?> _empfaenger() {
    final koerper = paarAbendKoerper;
    final gewaehlt = StorageService.getKoerperVoreinstellung();
    final ich = (gewaehlt == 'vulva' || gewaehlt == 'penis')
        ? gewaehlt
        : koerper(StorageService.getUserProfile()?.gender);
    final nostr = NostrService();
    final du = koerper(nostr.isPaired ? nostr.partnerGenderNotifier.value : null);
    final (erste, zweite) = _ichZuerst ? (du, ich) : (ich, du);
    return [erste, zweite];
  }

  // ---------------------------------------------------------------------------
  // Oberfläche

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(title: Text(t.couplesChannelSharedEvening)),
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
            'audio/paar/${_stimme}_${b.id}.opus'
        ], paketNamen: [
          Pakete.name(Pakete.gefuehrt)
        ]),
        const SizedBox(height: VpAbstand.l),
        Text(
          t.paarAbendPutThePhoneNextTo,
          style:
              TextStyle(fontSize: 14, color: AppTheme.tinteLeise, height: 1.5),
        ),
        const SizedBox(height: 22),
        _titel(t.paarAbendDuration),
        Wrap(
          spacing: 8,
          children: [
            for (final m in _minutenOptionen)
              _chip(t.paarAbendMMin(m), _minuten == m,
                  () => setState(() => _minuten = m)),
          ],
        ),
        const SizedBox(height: 20),
        _titel(t.paarAbendHowFarMayItGo),
        for (final tiefe
            in waehlbareTiefen(spicyErlaubt: StorageService.spicyMode()))
          switch (tiefe) {
            PaarTiefe.bekleidet => _tiefeOption(tiefe, t.paarAbendClothed,
                t.paarAbendBackShouldersHandsHeadLegs),
            PaarTiefe.haut => _tiefeOption(tiefe, t.paarAbendSkinToSkin,
                t.paarAbendPlusMassageWithOilBelly),
            PaarTiefe.intim => _tiefeOption(
                tiefe, t.paarAbendIntimate, t.paarAbendPlusChestInnerThighsAnd),
            PaarTiefe.spicy =>
              _tiefeOption(tiefe, t.spicyStufe, t.paarAbendSpicyText),
            PaarTiefe.sehrSpicy =>
              _tiefeOption(tiefe, t.sehrSpicyStufe, t.paarAbendSehrSpicyText),
          },
        const SizedBox(height: 20),
        _titel(t.paarAbendWhoGivesFirst),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip(_ichName == t.paarAbendYou ? t.paarAbendMe : _ichName,
                _ichZuerst, () => setState(() => _ichZuerst = true)),
            _chip(NostrService().isPaired ? _partnerName : t.paarAbendMyPartner,
                !_ichZuerst, () => setState(() => _ichZuerst = false)),
          ],
        ),
        const SizedBox(height: 20),
        _titel(t.paarAbendVoice),
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
          subtitle: Text(t.paarAbendCalmBackgroundDuringTheSilences,
              style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.akzentTief.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border:
                Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.35)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.handshake_outlined,
                  color: AppTheme.akzentTief, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  _tiefe.istSpicy
                      ? t.paarAbendSpicyHinweis
                      : t.paarAbendAgreeOnAStopWord,
                  style: TextStyle(
                      fontSize: 13, color: AppTheme.tinte, height: 1.45),
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
            label: Text(t.paarAbendBeginTheEvening,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.akzentTief,
              foregroundColor: AppTheme.papier,
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
        selectedColor: AppTheme.akzentTief.withValues(alpha: 0.25),
        backgroundColor: AppTheme.papierErhoben,
        side: BorderSide(color: aktiv ? AppTheme.akzentTief : AppTheme.linie),
        labelStyle: TextStyle(
          color: aktiv ? AppTheme.akzentTief : AppTheme.tinteLeise,
          fontWeight: FontWeight.w600,
        ),
        showCheckmark: false,
      );

  Widget _tiefeOption(PaarTiefe tiefe, String titel, String text) {
    final aktiv = _tiefe == tiefe;
    final farbe = tiefe.index >= PaarTiefe.intim.index
        ? AppTheme.akzentTief
        : AppTheme.akzentTief;
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
            color:
                aktiv ? farbe.withValues(alpha: 0.12) : AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: aktiv ? farbe : AppTheme.linie),
          ),
          child: Row(
            children: [
              Icon(
                  aktiv
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: aktiv ? farbe : AppTheme.tinteStumm,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
