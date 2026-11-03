import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/t.dart';
import '../../models/traumpraxis_daten.dart';
import '../../services/sprache.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';

enum PraxisAnsicht { zeichen, beobachtung, rueckblick }

String praxisSchlafName(int wert) => [
      t.praxisSchlaf0,
      t.praxisSchlaf1,
      t.praxisSchlaf2,
      t.praxisSchlaf3,
      t.praxisSchlaf4
    ][wert];
String praxisLustName(int wert) => [
      t.praxisLust0,
      t.praxisLust1,
      t.praxisLust2,
      t.praxisLust3,
      t.praxisLust4
    ][wert];

/// Persönliche Daten bleiben in StorageService, nicht im Paket oder KI-Coach.
class PraxisVerwaltung extends StatefulWidget {
  final PraxisAnsicht ansicht;
  final String? tag;
  const PraxisVerwaltung({super.key, required this.ansicht, this.tag});

  @override
  State<PraxisVerwaltung> createState() => _PraxisVerwaltungState();
}

class _PraxisVerwaltungState extends State<PraxisVerwaltung> {
  final _text = TextEditingController();
  PraxisEintrag? _bearbeitet;
  late final String _tag;
  int? _schlaf, _lust;
  bool? _sinnlich, _klar, _orgasmus;
  bool _speichert = false;

  @override
  void initState() {
    super.initState();
    _tag = widget.tag ?? PraxisEintrag.datum(DateTime.now());
    if (widget.ansicht == PraxisAnsicht.beobachtung) {
      _bearbeitet = StorageService.getTraumpraxis()
          .tage
          .where((e) => e.id == _tag)
          .firstOrNull;
      _text.text = _bearbeitet?.text ?? '';
      _schlaf = _bearbeitet?.schlaf;
      _lust = _bearbeitet?.lust;
      _sinnlich = _bearbeitet?.sinnlich;
      _klar = _bearbeitet?.klar;
      _orgasmus = _bearbeitet?.hoehepunkt;
    }
    StorageService.spicyAenderung.addListener(_modus);
  }

  void _modus() {
    if (!StorageService.spicyMode()) {
      _text.clear();
      _bearbeitet = null;
      _schlaf = _lust = null;
      _sinnlich = _klar = _orgasmus = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    StorageService.spicyAenderung.removeListener(_modus);
    _text.dispose();
    super.dispose();
  }

  Future<bool> _speichern(PraxisEintrag e) async {
    if (_speichert || !StorageService.spicyMode()) return false;
    setState(() => _speichert = true);
    try {
      await StorageService.savePraxisEintrag(e);
      return true;
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.praxisFehler)));
      return false;
    } finally {
      if (mounted) setState(() => _speichert = false);
    }
  }

  Future<void> _zeichenSpeichern() async {
    if (_text.text.trim().isEmpty) return;
    final now = DateTime.now();
    final ok = await _speichern(PraxisEintrag(
        id: _bearbeitet?.id ?? now.microsecondsSinceEpoch.toString(),
        art: 'zeichen',
        geaendert: now,
        text: _text.text.trim()));
    if (!mounted || !ok) return;
    setState(() {
      _text.clear();
      _bearbeitet = null;
    });
  }

  Future<void> _tagSpeichern() async {
    final ok = await _speichern(PraxisEintrag(
        id: _tag,
        art: 'tag',
        geaendert: DateTime.now(),
        text: _text.text.trim(),
        schlaf: _schlaf,
        lust: _lust,
        sinnlich: _sinnlich,
        klar: _klar,
        hoehepunkt: _orgasmus));
    if (mounted && ok) Navigator.of(context).pop();
  }

  Future<void> _loeschen(PraxisEintrag e) async {
    final ja = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(t.praxisLoeschenFrage),
              content: Text(t.praxisLoeschenText),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(t.praxisAbbrechen)),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(t.praxisLoeschen))
              ],
            ));
    if (!mounted || ja != true) return;
    final ok = await _speichern(PraxisEintrag(
        id: e.id, art: e.art, geaendert: DateTime.now(), geloescht: true));
    if (mounted && ok && _bearbeitet?.id == e.id)
      setState(() {
        _bearbeitet = null;
        _text.clear();
      });
  }

  @override
  Widget build(BuildContext context) {
    final typo = VpTypo.fuer(AppTheme.palette);
    final daten = StorageService.getTraumpraxis();
    final titel = switch (widget.ansicht) {
      PraxisAnsicht.zeichen => t.praxisZeichenTitel,
      PraxisAnsicht.beobachtung => t.praxisBeobachtungTitel,
      PraxisAnsicht.rueckblick => t.praxisRueckblick,
    };
    return Scaffold(
        appBar: AppBar(title: Text(titel)),
        body: SafeArea(
            child: !StorageService.spicyMode()
                ? Center(child: Text(t.traumpraxisNurSpicy))
                : ListView(
                    padding: const EdgeInsets.all(VpAbstand.rand),
                    children: [
                        if (widget.ansicht == PraxisAnsicht.zeichen) ...[
                          Text(t.praxisZeichenText, style: typo.fliesstext),
                          const SizedBox(height: VpAbstand.xl),
                          TextField(
                              controller: _text,
                              maxLength: 120,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  labelText: t.praxisZeichenFeld,
                                  hintText: t.praxisZeichenBeispiel)),
                          const SizedBox(height: VpAbstand.m),
                          FilledButton(
                              onPressed: _speichert ? null : _zeichenSpeichern,
                              child: Text(_bearbeitet == null
                                  ? t.praxisHinzufuegen
                                  : t.praxisSpeichern)),
                          if (_bearbeitet != null)
                            TextButton(
                                onPressed: () => setState(() {
                                      _bearbeitet = null;
                                      _text.clear();
                                    }),
                                child: Text(t.praxisAbbrechen)),
                          const SizedBox(height: VpAbstand.xl),
                          if (daten.zeichen.isEmpty)
                            Text(t.praxisZeichenLeer,
                                style: typo.fliesstextKlein),
                          for (final e in daten.zeichen) ...[
                            const Divider(),
                            Text(e.text, style: typo.titel),
                            Wrap(children: [
                              TextButton.icon(
                                  onPressed: _speichert
                                      ? null
                                      : () => setState(() {
                                            _bearbeitet = e;
                                            _text.text = e.text;
                                          }),
                                  icon: const Icon(Icons.edit_outlined),
                                  label: Text(t.praxisBearbeiten)),
                              TextButton.icon(
                                  onPressed:
                                      _speichert ? null : () => _loeschen(e),
                                  icon: const Icon(Icons.delete_outline),
                                  label: Text(t.praxisLoeschen)),
                            ]),
                          ],
                        ],
                        if (widget.ansicht == PraxisAnsicht.beobachtung) ...[
                          Text(_datum(_tag), style: typo.ueberschrift),
                          const SizedBox(height: VpAbstand.l),
                          Text(t.praxisBeobachtungText, style: typo.fliesstext),
                          const SizedBox(height: VpAbstand.xl),
                          _stufe(t.praxisSchlaf, _schlaf, praxisSchlafName,
                              (v) => setState(() => _schlaf = v)),
                          _stufe(t.praxisLust, _lust, praxisLustName,
                              (v) => setState(() => _lust = v)),
                          _frage(t.praxisSinnlich, _sinnlich,
                              (v) => setState(() => _sinnlich = v)),
                          _frage(t.praxisKlar, _klar,
                              (v) => setState(() => _klar = v)),
                          _frage(t.praxisOrgasmus, _orgasmus,
                              (v) => setState(() => _orgasmus = v)),
                          TextField(
                              controller: _text,
                              maxLength: 2000,
                              minLines: 3,
                              maxLines: 6,
                              decoration:
                                  InputDecoration(labelText: t.praxisNotiz)),
                          const SizedBox(height: VpAbstand.l),
                          FilledButton(
                              onPressed: _speichert ? null : _tagSpeichern,
                              child: Text(t.praxisSpeichern)),
                        ],
                        if (widget.ansicht == PraxisAnsicht.rueckblick) ...[
                          Text(t.praxisRueckblickText, style: typo.fliesstext),
                          const SizedBox(height: VpAbstand.l),
                          OutlinedButton(
                              onPressed: () => _bearbeitenTag(null),
                              child: Text(t.praxisBeobachten)),
                          if (daten.tage.isEmpty)
                            Text(t.praxisRueckblickLeer,
                                style: typo.fliesstextKlein),
                          for (final e in daten.tage) ...[
                            const Divider(),
                            Text(_datum(e.id), style: typo.titel),
                            const SizedBox(height: VpAbstand.m),
                            Text(_zusammenfassung(e), style: typo.fliesstext),
                            if (e.text.isNotEmpty)
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: VpAbstand.m),
                                  child: Text(e.text, style: typo.fliesstext)),
                            Wrap(children: [
                              TextButton.icon(
                                  onPressed: _speichert
                                      ? null
                                      : () => _bearbeitenTag(e.id),
                                  icon: const Icon(Icons.edit_outlined),
                                  label: Text(t.praxisBearbeiten)),
                              TextButton.icon(
                                  onPressed:
                                      _speichert ? null : () => _loeschen(e),
                                  icon: const Icon(Icons.delete_outline),
                                  label: Text(t.praxisLoeschen)),
                            ]),
                          ],
                        ],
                      ])));
  }

  Future<void> _bearbeitenTag(String? tag) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            PraxisVerwaltung(ansicht: PraxisAnsicht.beobachtung, tag: tag)));
    if (mounted) setState(() {});
  }

  String _datum(String tag) =>
      DateFormat.yMMMd(Sprache.code).format(DateTime.parse(tag));

  String _zusammenfassung(PraxisEintrag e) {
    final lines = [
      if (e.schlaf != null) praxisSchlafName(e.schlaf!),
      if (e.lust != null) praxisLustName(e.lust!),
      if (e.sinnlich != null)
        '${t.praxisSinnlich} ${e.sinnlich! ? t.praxisJa : t.praxisNein}',
      if (e.klar != null)
        '${t.praxisKlar} ${e.klar! ? t.praxisJa : t.praxisNein}',
      if (e.hoehepunkt != null)
        '${t.praxisOrgasmus} ${e.hoehepunkt! ? t.praxisJa : t.praxisNein}'
    ];
    return lines.isEmpty ? t.praxisNurOffeneFelder : lines.join('\n');
  }

  Widget _stufe(String label, int? wert, String Function(int) name,
          ValueChanged<int?> changed) =>
      Padding(
        padding: const EdgeInsets.only(bottom: VpAbstand.l),
        child: DropdownButtonFormField<int>(
            initialValue: wert ?? -1,
            isExpanded: true,
            decoration: InputDecoration(labelText: label),
            items: [
              DropdownMenuItem(value: -1, child: Text(t.praxisUnbeantwortet)),
              for (var i = 0; i < 5; i++)
                DropdownMenuItem(value: i, child: Text(name(i)))
            ],
            onChanged: (v) => changed(v == -1 ? null : v)),
      );

  Widget _frage(String label, bool? wert, ValueChanged<bool?> changed) =>
      Padding(
        padding: const EdgeInsets.only(bottom: VpAbstand.l),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: VpTypo.fuer(AppTheme.palette).fliesstext),
          Wrap(spacing: VpAbstand.s, children: [
            for (final v in <bool?>[null, true, false])
              ChoiceChip(
                  label: Text(v == null
                      ? t.praxisUnbeantwortet
                      : v
                          ? t.praxisJa
                          : t.praxisNein),
                  selected: wert == v,
                  onSelected: (_) => changed(v)),
          ]),
        ]),
      );
}
