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

import '../../l10n/t.dart';
import '../../models/einschlaf_reise.dart';
import '../../models/lust_im_traum.dart';
import '../../models/traum_reise.dart';
import '../../services/naechtliches_wecken.dart';
import '../../services/storage_service.dart';
import '../../services/testmodus.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lautsprecher_frage.dart';
import 'lust_im_traum_screen.dart' show lustFolgeTitel;
import 'realitaetscheck_screen.dart';
import 'traum_tagebuch_screen.dart';

/// Einschlaf-Reise: eine lange, ruhige Begleitung in den Schlaf (lib/models/einschlaf_reise.dart,
/// Texte in assets/data/einschlaf_reise.json). Die Stimme wird über die Reise leiser, der Klangteppich
/// blendet in der Schlussstille aus; danach stoppt alles von selbst.
class EinschlafReiseScreen extends StatefulWidget {
  /// Traum-Abend statt Einschlaf-Reise: Traumbild statt Schwerpunkt (lib/models/traum_reise.dart).
  final bool traum;

  /// Ein Abend der Serie „Lust im Traum“ (lib/models/lust_im_traum.dart); Auswahl im LustImTraumScreen.
  final LustWahl? lust;

  const EinschlafReiseScreen({super.key, this.traum = false, this.lust});

  @override
  State<EinschlafReiseScreen> createState() => _EinschlafReiseScreenState();
}

/// Auswahl für einen Abend „Lust im Traum“.
class LustWahl {
  final int folge;
  final String bettKoerper;
  final String traumKoerper;
  final String gegenueber;

  const LustWahl(
      {required this.folge,
      required this.bettKoerper,
      String? traumKoerper,
      this.gegenueber = 'niemand'})
      : traumKoerper = traumKoerper ?? bettKoerper;
}

class _EinschlafReiseScreenState extends State<EinschlafReiseScreen> {
  String get _modus =>
      widget.lust != null ? 'lust' : (widget.traum ? 'traum' : 'einschlaf');
  String get _keyMinuten => '${_modus}_minuten';
  String get _keyThema => '${_modus}_thema';
  String get _keyKoerper => '${_modus}_koerper';
  String get _keySpicy => '${_modus}_spicy';
  String get _keyStimme => '${_modus}_stimme';
  String get _keyZuletzt => '${_modus}_zuletzt';

  /// Lautstärke des Klangteppichs, solange er nicht ausblendet.
  static const _teppichLaut = 0.3;

  /// So lange blendet der Klangteppich in der Schlussstille aus (höchstens).
  static const _ausblenden = Duration(minutes: 10);

  EinschlafDaten? _daten;
  TraumDaten? _traumDaten;
  LustDaten? _lustDaten;

  int _minuten = 90;
  String? _thema; // null = Überrasch mich
  String _koerper = 'neutral';
  bool _spicy = false;
  String _stimme = 'victoria';
  bool _teppich = true;
  bool _heuteWecken = false;
  late DateTime _weckenZeit = NaechtlichesWecken.schlageWeckzeitVor();

  @override
  void initState() {
    super.initState();
    _laden();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await EinschlafDaten.laden();
    final traumDaten =
        widget.traum || widget.lust != null ? await TraumDaten.laden() : null;
    final lustDaten = widget.lust != null ? await LustDaten.laden() : null;
    final profil = StorageService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _traumDaten = traumDaten;
      _lustDaten = lustDaten;
      final m = prefs.getInt(_keyMinuten);
      _minuten = _laengen.contains(m)
          ? m!
          : (widget.traum || widget.lust != null ? 45 : 90);
      final th = prefs.getString(_keyThema);
      _thema = _themen.contains(th) ? th : null;
      _koerper = prefs.getString(_keyKoerper) ?? 'neutral';
      _spicy =
          StorageService.spicyMode() && (prefs.getBool(_keySpicy) ?? false);
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
    if (_thema == null) {
      await prefs.remove(_keyThema);
    } else {
      await prefs.setString(_keyThema, _thema!);
    }
    await prefs.setString(_keyKoerper, _koerper);
    await prefs.setBool(_keySpicy, _spicy);
    await prefs.setString(_keyStimme, _stimme);
    final zuletzt = prefs.getStringList(_keyZuletzt) ?? [];
    final traumDaten = _traumDaten;
    final lust = widget.lust;
    final lustDaten = _lustDaten;
    if (lust != null && lustDaten == null) return;
    final ablauf = lust != null
        ? lustDaten!.planen(
            einschlaf: daten,
            traum: traumDaten,
            minuten: _minuten,
            folge: lust.folge,
            bettKoerper: lust.bettKoerper,
            traumKoerper: lust.traumKoerper,
            gegenueber: lust.gegenueber,
            stimme: _stimme,
            zuletzt: zuletzt.toSet(),
          )
        : traumDaten != null
            ? traumDaten.planen(
                einschlaf: daten,
                minuten: _minuten,
                bild: _thema,
                koerper: _koerper,
                spicy: _spicy && StorageService.spicyMode(),
                stimme: _stimme,
                zuletzt: zuletzt.toSet(),
              )
            : daten.planen(
                minuten: _minuten,
                thema: _thema,
                koerper: _koerper,
                spicy: _spicy && StorageService.spicyMode(),
                stimme: _stimme,
                zuletzt: zuletzt.toSet(),
              );
    final neu = [
      for (final s in ablauf)
        if (s.baustein != null) s.baustein!.id
    ];
    await prefs.setStringList(
        _keyZuletzt, [...neu, ...zuletzt].take(60).toList());
    // Für das Traumtagebuch am Morgen: was heute Abend lief.
    if (lust != null) {
      await StorageService.merkeAbend('lust:${lust.folge}');
    } else if (widget.traum) {
      final bild = TraumDaten.bilder
          .where((b) => neu.any((id) => id.startsWith('${b}_')))
          .firstOrNull;
      await StorageService.merkeAbend('traum:${bild ?? ''}');
      if (_heuteWecken) {
        await NaechtlichesWecken.planen(_weckenZeit);
      }
    }

    if (!mounted) return;
    final plan = WiedergabePlaene.schritte(
        art: widget.lust != null
            ? WiedergabeArt.lust
            : widget.traum
                ? WiedergabeArt.traum
                : WiedergabeArt.einschlaf,
        titel: widget.lust != null
            ? '${t.lustFolgeN(widget.lust!.folge)} · ${lustFolgeTitel(widget.lust!.folge)}'
            : (widget.traum ? t.traumTitel : t.einschlafTitel),
        schritte: Testmodus.kuerzen(ablauf),
        stimme: _stimme,
        familie: (id) => _lustDaten?.istLust(id) == true
            ? 'lust'
            : _traumDaten?.istTraum(id) == true
                ? 'traum'
                : 'einschlaf',
        spicy: widget.lust != null || _spicy,
        parameter: {
          'teppich': _teppich,
          'teppichLaut': _teppichLaut,
          'blendeMs': _ausblenden.inMilliseconds,
          'stimmeVon': 1.0,
          'stimmeBis': 0.7,
          if (widget.lust != null) 'lustFolge': widget.lust!.folge,
          if (widget.lust != null) 'lustZaehlen': true
        });
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  List<int> get _laengen => widget.lust != null
      ? LustDaten.laengen
      : (widget.traum ? TraumDaten.laengen : EinschlafDaten.laengen);
  List<String> get _themen =>
      widget.traum ? TraumDaten.bilder : EinschlafDaten.themen;

  String _themaName(String id) => switch (id) {
        'warmes_wasser' => t.traumBildWarmesWasser,
        'ort_fuer_mich' => t.traumBildOrtFuerMich,
        'koerper_im_licht' => t.traumBildKoerperImLicht,
        'begegnung' => t.traumBildBegegnung,
        'klarheit' => t.traumBildKlarheit,
        'koerper' => t.einschlafThemaKoerper,
        'welle' => t.einschlafThemaWelle,
        'gaspedal' => t.einschlafThemaGaspedal,
        'spueren' => t.einschlafThemaSpueren,
        'becken' => t.einschlafThemaBecken,
        _ => t.einschlafThemaGeniessen,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(
            title: Text(widget.lust != null
                ? '${t.lustFolgeN(widget.lust!.folge)} · ${lustFolgeTitel(widget.lust!.folge)}'
                : (widget.traum ? t.traumTitel : t.einschlafTitel)),
            actions: [
              if (widget.traum)
                IconButton(
                    tooltip: t.tagebuchTitel,
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TraumTagebuchScreen()))),
            ]),
        body: SafeArea(
            child: (_daten) == null
                ? const Center(child: CircularProgressIndicator())
                : _buildEinrichtung()));
  }

  Widget _buildEinrichtung() {
    final spicyModus = StorageService.spicyMode();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(t.wiedergabeStimmenStand, style: context.vp.typo.beschriftung),
        AufnahmeStatus(pfade: [
          for (final b in _daten!.bausteine)
            'audio/einschlaf/${_stimme}_${b.id}.opus',
          if (_traumDaten != null)
            for (final b in _traumDaten!.bausteine)
              'audio/traum/${_stimme}_${b.id}.opus',
          if (_lustDaten != null)
            for (final b in _lustDaten!.bausteine)
              'audio/lust/${_stimme}_${b.id}.opus'
        ], paketNamen: [
          Pakete.name(Pakete.gefuehrt),
          if (widget.lust != null) Pakete.name(Pakete.lust)
        ]),
        const SizedBox(height: VpAbstand.l),
        if (widget.lust != null && _lustDaten == null) ...[
          Text(t.lustPaketFehlt,
              style: TextStyle(
                  fontSize: 14, color: AppTheme.tinteLeise, height: 1.5)),
          const SizedBox(height: 14),
        ],
        Text(
            widget.lust != null
                ? t.lustEinleitung
                : (widget.traum ? t.traumEinleitung : t.einschlafEinleitung),
            style: TextStyle(
                fontSize: 14, color: AppTheme.tinteLeise, height: 1.5)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.linie),
          ),
          child: Text(
              widget.lust != null
                  ? t.lustEhrlich
                  : (widget.traum
                      ? (_traumDaten?.hinweis('hinweis_einstieg') ?? '')
                      : t.einschlafWirkung),
              style: TextStyle(
                  fontSize: 13, color: AppTheme.tinteLeise, height: 1.5)),
        ),
        const SizedBox(height: 22),
        _titel(t.einschlafLaenge),
        Wrap(spacing: 8, children: [
          for (final m in _laengen)
            _chip(t.selbstReiseMMin(m), _minuten == m,
                () => setState(() => _minuten = m)),
        ]),
        if (widget.lust == null) ...[
          const SizedBox(height: 20),
          _titel(widget.traum ? t.traumBild : t.einschlafSchwerpunkt),
          Wrap(spacing: 8, runSpacing: 4, children: [
            _chip(t.einschlafUeberrasch, _thema == null,
                () => setState(() => _thema = null)),
            for (final th in _themen)
              _chip(_themaName(th), _thema == th,
                  () => setState(() => _thema = th)),
          ]),
        ],
        if (spicyModus && widget.lust == null) ...[
          const SizedBox(height: 20),
          _titel(t.selbstReiseYourBody),
          Wrap(spacing: 8, children: [
            _chip(t.selbstReiseVulva, _koerper == 'vulva',
                () => setState(() => _koerper = 'vulva')),
            _chip(t.selbstReisePenis, _koerper == 'penis',
                () => setState(() => _koerper = 'penis')),
            _chip(t.einschlafOhneBezug, _koerper == 'neutral',
                () => setState(() => _koerper = 'neutral')),
          ]),
          if (_koerper != 'neutral')
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _spicy,
              activeThumbColor: AppTheme.akzentTief,
              onChanged: (v) => setState(() => _spicy = v),
              title: Text(t.einschlafSpicyTitel,
                  style: TextStyle(color: AppTheme.tinte, fontSize: 14.5)),
              subtitle: Text(t.einschlafSpicyText,
                  style: TextStyle(color: AppTheme.tinteLeise, fontSize: 12.5)),
            ),
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
        const SizedBox(height: 14),
        if (widget.traum) ...[
          _buildRealitaetscheckZeile(),
          const SizedBox(height: 14),
          _buildWeckenSchalter(),
          const SizedBox(height: 14),
        ],
        Text(t.einschlafHinweise,
            style: TextStyle(
                fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5)),
        if ((widget.traum || widget.lust != null) &&
            _traumDaten?.hinweis('hinweis_schlafparalyse') != null) ...[
          const SizedBox(height: 10),
          Text(_traumDaten!.hinweis('hinweis_schlafparalyse')!,
              style: TextStyle(
                  fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5)),
        ],
        const SizedBox(height: 22),
        SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed:
                widget.lust != null && _lustDaten == null ? null : _starten,
            icon: const Icon(Icons.bedtime_rounded),
            label: Text(t.einschlafStart,
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

  Widget _buildRealitaetscheckZeile() {
    final aktiv = StorageService.getRealitaetschecks().aktiv;
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RealitaetscheckScreen()),
        );
        if (mounted) setState(() {});
      },
      borderRadius: BorderRadius.circular(VpRadius.karte),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(color: AppTheme.linie),
        ),
        child: Row(
          children: [
            Icon(Icons.touch_app_outlined,
                color: AppTheme.akzentTief, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.realitaetTitel,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.tinte,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    aktiv ? t.realitaetStatusEin : t.realitaetStatusAus,
                    style:
                        TextStyle(fontSize: 12.5, color: AppTheme.tinteLeise),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.tinteLeise),
          ],
        ),
      ),
    );
  }

  Widget _buildWeckenSchalter() {
    final darfWecken = NaechtlichesWecken.darfHeuteWecken(
        StorageService.getNaechtlichesWecken());
    final aktiv = darfWecken && _heuteWecken;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(
            color: aktiv
                ? AppTheme.akzentTief.withValues(alpha: 0.5)
                : AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: aktiv,
            activeThumbColor: AppTheme.akzentTief,
            onChanged: darfWecken
                ? (v) => setState(() {
                      _heuteWecken = v;
                      if (v)
                        _weckenZeit = NaechtlichesWecken.schlageWeckzeitVor();
                    })
                : null,
            title: Text(t.weckenTitel,
                style: TextStyle(color: AppTheme.tinte, fontSize: 14.5)),
            subtitle: Text(
              darfWecken ? t.weckenUntertitel : t.weckenGesperrt,
              style: TextStyle(
                  color: AppTheme.tinteLeise, fontSize: 12.5, height: 1.4),
            ),
          ),
          if (aktiv) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.weckenUhrzeit(
                      NaechtlichesWecken.formatUhrzeit(_weckenZeit)),
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.tinte),
                ),
                TextButton(
                  onPressed: _weckzeitWaehlen,
                  child: Text(t.weckenAendern,
                      style: TextStyle(color: AppTheme.akzentTief)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              t.weckenSicherheit,
              style: TextStyle(
                  fontSize: 12, color: AppTheme.tinteStumm, height: 1.45),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _weckzeitWaehlen() async {
    final gewaehlt = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: _weckenZeit.hour, minute: _weckenZeit.minute),
    );
    if (gewaehlt != null && mounted) {
      setState(
          () => _weckenZeit = NaechtlichesWecken.berechneZielZeit(gewaehlt));
    }
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
}
