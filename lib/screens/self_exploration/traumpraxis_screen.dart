import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/traum_eintrag.dart';
import '../../models/traumpraxis.dart';
import '../../models/traumpraxis_hoeren.dart';
import '../../models/lust_im_traum.dart';
import '../../services/pakete.dart';
import '../../services/storage_service.dart';
import '../../services/wiedergabe_dienst.dart';
import '../../services/wiedergabe_plaene.dart';
import '../../widgets/aufnahme_status.dart';
import '../../widgets/lautsprecher_frage.dart';
import '../wiedergabe_screen.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import 'traum_tagebuch_screen.dart';
import 'traumpraxis_verwalten.dart';
import 'schlafdaten_screen.dart';

/// Ergänzende Anleitung, keine neue Audiofolge. Auswahl bleibt in dieser Sitzung.
class TraumpraxisScreen extends StatefulWidget {
  const TraumpraxisScreen({super.key});

  @override
  State<TraumpraxisScreen> createState() => _TraumpraxisScreenState();
}

class _TraumpraxisScreenState extends State<TraumpraxisScreen> {
  List<TraumEintrag> _eintraege = [];
  String? _auswahl;
  String? _zeichen;
  List<PraxisBegleitung>? _begleitungen;
  String _stimme = 'victoria';

  @override
  void initState() {
    super.initState();
    _eintraege = StorageService.getTraumEintraege();
    StorageService.spicyAenderung.addListener(_modusGeaendert);
    Pakete.stand.addListener(_begleitungenLaden);
    _begleitungenLaden();
  }

  Future<void> _begleitungenLaden() async {
    final prefs = await SharedPreferences.getInstance();
    final katalog = await PraxisBegleitung.laden();
    if (!mounted) return;
    setState(() {
      _begleitungen = katalog;
      _stimme = prefs.getString('traum_stimme') == 'martin'
          ? 'martin'
          : prefs.getString('traum_stimme') == 'victoria'
              ? 'victoria'
              : StorageService.stimmenVorschlag();
    });
  }

  Future<void> _hoeren(PraxisBegleitung b) async {
    if (!StorageService.spicyMode()) return;
    if (!await frageVorLautsprecher(context) || !mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('traum_stimme', _stimme);
    final plan = WiedergabePlaene.praxis(b, _stimme);
    if (!mounted) return;
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  void _modusGeaendert() => setState(() {
        _auswahl = null;
        _zeichen = null;
        _eintraege = StorageService.spicyMode()
            ? StorageService.getTraumEintraege()
            : [];
      });

  @override
  void dispose() {
    StorageService.spicyAenderung.removeListener(_modusGeaendert);
    Pakete.stand.removeListener(_begleitungenLaden);
    super.dispose();
  }

  Future<void> _tagebuch() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const TraumTagebuchScreen()));
    if (!mounted) return;
    setState(() => _eintraege = StorageService.getTraumEintraege());
  }

  Future<void> _verwalten(PraxisAnsicht ansicht) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PraxisVerwaltung(ansicht: ansicht)));
    if (mounted)
      setState(() => _eintraege = StorageService.getTraumEintraege());
  }

  @override
  Widget build(BuildContext context) {
    final typo = VpTypo.fuer(AppTheme.palette);
    final pause = Traumpraxis.pauseRaten(_eintraege);
    final vorlagen = Traumpraxis.vorlagen(_eintraege);
    final ausgewaehlt = vorlagen.where((e) => e.id == _auswahl).firstOrNull;
    final zeichen = StorageService.getTraumpraxis().zeichen;
    final gewaehlt = zeichen.where((e) => e.id == _zeichen).firstOrNull;
    final fortschritt = StorageService.getLustFortschritt();
    final folge = [
      for (var f = 1; f <= LustDaten.folgen; f++)
        if (LustDaten.frei(f, fortschritt)) f
    ].last;
    return Scaffold(
      appBar: AppBar(title: Text(t.traumpraxisTitel)),
      body: !StorageService.spicyMode()
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.all(VpAbstand.rand),
                  child: Text(t.traumpraxisNurSpicy)))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(VpAbstand.rand),
                children: [
                  Text(t.traumpraxisEinladung, style: typo.ueberschrift),
                  const SizedBox(height: VpAbstand.l),
                  Text(t.traumpraxisZiel, style: typo.fliesstext),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SchlafdatenScreen())),
                    icon: const Icon(Icons.bedtime_outlined), label: Text(t.schlafTitel)),
                  const SizedBox(height: VpAbstand.xl),
                  _abschnitt(
                      t.praxisPfad,
                      folge <= 2
                          ? t.praxisPfadErinnern
                          : folge <= 5
                              ? t.praxisPfadErkennen
                              : t.praxisPfadEntfalten),
                  const SizedBox(height: VpAbstand.xl),
                  _hoerenAbschnitt(typo, pause),
                  _abschnitt(t.traumpraxisErinnern, t.traumpraxisErinnernText),
                  OutlinedButton.icon(
                      onPressed: _tagebuch,
                      icon: const Icon(Icons.edit_note_outlined),
                      label: Text(t.tagebuchTitel)),
                  const SizedBox(height: VpAbstand.xl),
                  if (pause) ...[
                    _abschnitt(t.traumpraxisRuhe, t.tagebuchPause),
                  ] else ...[
                    _abschnitt(
                        t.traumpraxisErkennen, t.traumpraxisMildEinleitung),
                    OutlinedButton.icon(
                        onPressed: () => _verwalten(PraxisAnsicht.zeichen),
                        icon: const Icon(Icons.bookmark_border),
                        label: Text(t.praxisZeichenTitel)),
                    const SizedBox(height: VpAbstand.l),
                    if (zeichen.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                          key: ValueKey('zeichen:${gewaehlt?.id}'),
                          initialValue: gewaehlt?.id,
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: t.praxisZeichenWaehlen),
                          items: [
                            for (final e in zeichen)
                              DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.text,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis))
                          ],
                          onChanged: (value) =>
                              setState(() => _zeichen = value)),
                      const SizedBox(height: VpAbstand.l),
                      if (gewaehlt != null) ...[
                        Text(gewaehlt.text, style: typo.titel),
                        const SizedBox(height: VpAbstand.m),
                        Text(t.praxisZeichenAbsicht, style: typo.fliesstext),
                        const SizedBox(height: VpAbstand.l),
                      ],
                    ],
                    if (vorlagen.isEmpty)
                      Text(t.traumpraxisOhneEintrag,
                          style: typo.fliesstextKlein)
                    else
                      DropdownButtonFormField<String>(
                        key: ValueKey(ausgewaehlt?.id),
                        initialValue: ausgewaehlt?.id,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: t.traumpraxisVorlage),
                        items: [
                          for (final e in vorlagen)
                            DropdownMenuItem(
                                value: e.id,
                                child: Text(e.text.replaceAll('\n', ' '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis))
                        ],
                        onChanged: (id) => setState(() => _auswahl = id),
                      ),
                    if (ausgewaehlt != null) ...[
                      const SizedBox(height: VpAbstand.l),
                      SelectableText(ausgewaehlt.text,
                          style: typo.fliesstextKlein),
                    ],
                    const SizedBox(height: VpAbstand.l),
                    Text(t.traumpraxisMildSchritte, style: typo.fliesstext),
                    const SizedBox(height: VpAbstand.l),
                    Text(t.traumpraxisAbsicht, style: typo.titel),
                    const SizedBox(height: VpAbstand.l),
                    Text(t.traumpraxisLoslassen, style: typo.fliesstext),
                    const SizedBox(height: VpAbstand.l),
                    if (Navigator.of(context).canPop())
                      FilledButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.bedtime_outlined),
                          label: Text(t.praxisAbendStart)),
                  ],
                  const SizedBox(height: VpAbstand.xl),
                  _abschnitt(
                      t.traumpraxisMitnehmen, t.traumpraxisMitnehmenText),
                  Text(t.traumpraxisNachspueren, style: typo.fliesstext),
                  const SizedBox(height: VpAbstand.l),
                  FilledButton(
                      onPressed: () => _verwalten(PraxisAnsicht.beobachtung),
                      child: Text(t.praxisBeobachten)),
                  const SizedBox(height: VpAbstand.m),
                  OutlinedButton(
                      onPressed: () => _verwalten(PraxisAnsicht.rueckblick),
                      child: Text(t.praxisRueckblick)),
                  const SizedBox(height: VpAbstand.l),
                  TextButton.icon(
                      onPressed: _tagebuch,
                      icon: const Icon(Icons.notes_outlined),
                      label: Text(t.traumpraxisNotieren)),
                  const SizedBox(height: VpAbstand.xl),
                  _abschnitt(
                      t.traumpraxisHoehepunkt, t.traumpraxisHoehepunktText),
                  Text(t.traumpraxisErkundung, style: typo.fliesstextKlein),
                ],
              ),
            ),
    );
  }

  /// Abend und Klarheit pausieren wie die übrigen aktiven Übungen, wenn belastende Träume gemeldet sind.
  Widget _hoerenAbschnitt(VpTypo typo, bool pause) {
    final katalog = _begleitungen;
    final eintraege = katalog == null
        ? <PraxisBegleitung>[]
        : [
            for (final b in katalog)
              if (!pause || b.id == 'praxis_morgen') b
          ];
    return Padding(
      padding: const EdgeInsets.only(bottom: VpAbstand.l),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        const SizedBox(height: VpAbstand.m),
        Text(t.traumpraxisHoeren, style: typo.titel),
        const SizedBox(height: VpAbstand.m),
        Text(t.traumpraxisHoerenText, style: typo.fliesstext),
        const SizedBox(height: VpAbstand.m),
        Wrap(spacing: VpAbstand.m, children: [
          for (final s in const [('victoria', 'Victoria'), ('martin', 'Martin')])
            ChoiceChip(
                label: Text(s.$2),
                selected: _stimme == s.$1,
                onSelected: (_) => setState(() => _stimme = s.$1))
        ]),
        const SizedBox(height: VpAbstand.m),
        if (katalog == null) ...[
          Text(t.traumpraxisHoerenPaket, style: typo.fliesstextKlein),
          AufnahmeStatus(pfade: [
            for (final id in PraxisBegleitung.ids)
              PraxisBegleitung.pfadFuer(_stimme, id),
            PraxisBegleitung.katalogPfad
          ], paketNamen: [
            Pakete.name(Pakete.gefuehrt)
          ]),
        ] else
          for (final b in eintraege) ...[
            Text(b.titel, style: typo.titel),
            const SizedBox(height: VpAbstand.s),
            Text(
                switch (b.id) {
                  'praxis_abend' => t.traumpraxisHoerenAbend,
                  'praxis_klarheit' => t.traumpraxisHoerenKlarheit,
                  _ => t.traumpraxisHoerenMorgen,
                },
                style: typo.fliesstextKlein),
            AufnahmeStatus(
                pfade: [b.aufnahmen[_stimme]!.pfad],
                paketNamen: [Pakete.name(Pakete.gefuehrt)]),
            const SizedBox(height: VpAbstand.s),
            FilledButton.icon(
                key: ValueKey('hoeren:${b.id}'),
                onPressed: () => _hoeren(b),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(t.traumpraxisHoerenStarten)),
            const SizedBox(height: VpAbstand.l),
          ],
      ]),
    );
  }

  Widget _abschnitt(String titel, String text) {
    final typo = VpTypo.fuer(AppTheme.palette);
    return Padding(
      padding: const EdgeInsets.only(bottom: VpAbstand.l),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        const SizedBox(height: VpAbstand.m),
        Text(titel, style: typo.titel),
        const SizedBox(height: VpAbstand.m),
        Text(text, style: typo.fliesstext),
      ]),
    );
  }
}
