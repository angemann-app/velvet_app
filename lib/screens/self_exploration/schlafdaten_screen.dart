import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/t.dart';
import '../../models/schlafdaten.dart';
import '../../services/schlafdaten_dienst.dart';
import '../../services/sprache.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import 'traumpraxis_verwalten.dart';
import '../../widgets/schlaf_traum_blick.dart';

/// Öffentliche Berechtigungsbegründung ohne private Werte oder Verbindung.
class SchlafInfoScreen extends StatelessWidget {
  const SchlafInfoScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(t.schlafTitel)),
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.all(VpAbstand.rand),
              children: [
            Text(t.schlafDatenschutz),
            const SizedBox(height: VpAbstand.xl),
            Text(t.schlafHinweis),
            const SizedBox(height: VpAbstand.xl),
            Text(t.schlafGetrennt),
          ])));
}

class SchlafdatenScreen extends StatefulWidget {
  final SchlafdatenDienst? dienst;
  const SchlafdatenScreen({super.key, this.dienst});
  @override
  State<SchlafdatenScreen> createState() => _SchlafdatenScreenState();
}

class _SchlafdatenScreenState extends State<SchlafdatenScreen>
    with WidgetsBindingObserver {
  late final SchlafdatenDienst _dienst;
  SchlafZugang? _zugang;
  bool _busy = false;
  String? _meldung, _quelle;
  List<SchlafAufzeichnung> _vorschau = [];

  @override
  void initState() {
    super.initState();
    _dienst = widget.dienst ?? SchlafdatenDienst();
    WidgetsBinding.instance.addObserver(this);
    StorageService.spicyAenderung.addListener(_modus);
    StorageService.schlafAenderung.addListener(_neu);
    _status();
  }

  void _neu() {
    if (mounted) setState(() {});
  }

  void _modus() {
    if (!StorageService.spicyMode()) {
      _dienst.abbrechen();
      _vorschau = [];
      _meldung = null;
    }
    _neu();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _status();
  }

  @override
  void dispose() {
    _dienst.abbrechen();
    WidgetsBinding.instance.removeObserver(this);
    StorageService.spicyAenderung.removeListener(_modus);
    StorageService.schlafAenderung.removeListener(_neu);
    super.dispose();
  }

  Future<void> _status() async {
    try {
      final s = await _dienst.status();
      if (mounted) setState(() => _zugang = s);
    } catch (_) {
      if (mounted) setState(() => _meldung = t.schlafFehler);
    }
  }

  Future<void> _aktion(Future<void> Function() action) async {
    if (_busy || !StorageService.spicyMode()) return;
    setState(() {
      _busy = true;
      _meldung = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted && StorageService.spicyMode())
        setState(() => _meldung = t.schlafFehler);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verbinden() => _aktion(() async {
        final ja = await _dienst.berechtigen();
        if (!mounted || !StorageService.spicyMode()) return;
        if (ja)
          await _dienst.verbinden();
        else
          setState(() => _meldung = t.schlafBerechtigungFehlt);
        await _status();
      });
  Future<void> _lesen() => _aktion(() async {
        final rows = await _dienst.lesen();
        if (!mounted || !StorageService.spicyMode()) return;
        final sources = rows.map((r) => r.quelle).toSet();
        setState(() {
          _vorschau = rows;
          _quelle = sources.length == 1 ? sources.single : null;
          if (rows.isEmpty) _meldung = t.schlafKeineDaten;
        });
      });
  Future<void> _uebernehmen() => _aktion(() async {
        if (_quelle == null) return;
        await _dienst.uebernehmen(_vorschau, _quelle!);
        if (mounted)
          setState(() {
            _vorschau = [];
            _meldung = t.schlafGespeichert;
          });
      });
  Future<void> _trennen() async {
    try {
      await _dienst.trennen();
      if (mounted)
        setState(() {
          _vorschau = [];
          _meldung = t.schlafGetrennt;
        });
    } catch (_) {
      if (mounted) setState(() => _meldung = t.schlafFehler);
    }
  }

  Future<void> _loeschen() async {
    final ja = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(t.schlafLoeschen),
                content: Text(t.schlafLoeschenFrage),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(t.schlafAbbrechen)),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(t.schlafLoeschen)),
                ]));
    if (ja == true && mounted && StorageService.spicyMode())
      await _aktion(() async {
        await _dienst.loeschen();
        if (mounted) setState(() => _vorschau = []);
      });
  }

  String _dauer(Duration d) =>
      t.schlafDauer(d.inHours, d.inMinutes.remainder(60));
  String _uhr(DateTime utc, int? offset) =>
      DateFormat.Hm(Sprache.code).format(offset == null
          ? utc.toLocal()
          : utc.toUtc().add(Duration(minutes: offset)));

  Widget _aufzeichnung(SchlafAufzeichnung r) {
    final typo = VpTypo.fuer(AppTheme.palette);
    final tag = StorageService.getTraumpraxis()
        .tage
        .where((e) => e.id == r.tag)
        .firstOrNull;
    final labels = {
      0: t.schlafUnbekanntePhase,
      1: t.schlafWach,
      2: t.schlafOhnePhase,
      3: t.schlafWach,
      4: t.schlafLeicht,
      5: t.schlafTief,
      6: t.schlafRem,
      7: t.schlafWach
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Divider(),
      Text(DateFormat.yMMMd(Sprache.code).format(DateTime.parse(r.tag)),
          style: typo.titel),
      Text(r.quelle, style: typo.fliesstextKlein),
      Text(
          '${_uhr(r.beginn, r.beginnOffsetMinuten)} – ${_uhr(r.ende, r.endeOffsetMinuten)}',
          style: typo.fliesstext),
      Text('${t.schlafZeitfenster}: ${_dauer(r.zeitfenster)}'),
      Text(
          '${t.schlafSchlafzeit}: ${r.schlafzeit == null ? t.schlafUnbekannt : _dauer(r.schlafzeit!)}'),
      if (r.phasenMs.isNotEmpty) ...[
        const SizedBox(height: VpAbstand.m),
        Text(t.schlafPhasen, style: typo.titel),
        for (final k in (r.phasenMs.keys.toList()..sort()))
          Text(
              '${labels[k]}: ${_dauer(Duration(milliseconds: r.phasenMs[k]!))}'),
      ],
      const SizedBox(height: VpAbstand.l),
      Text(t.schlafEigeneAngaben, style: typo.titel),
      if (tag == null)
        Text(t.schlafKeineAngaben)
      else ...[
        if (tag.schlaf != null) Text(praxisSchlafName(tag.schlaf!)),
        if (tag.lust != null) Text(praxisLustName(tag.lust!)),
        if (tag.sinnlich != null)
          Text(
              '${t.praxisSinnlich}: ${tag.sinnlich! ? t.praxisJa : t.praxisNein}'),
        if (tag.klar != null)
          Text('${t.praxisKlar}: ${tag.klar! ? t.praxisJa : t.praxisNein}'),
        if (tag.hoehepunkt != null)
          Text(
              '${t.praxisOrgasmus}: ${tag.hoehepunkt! ? t.praxisJa : t.praxisNein}'),
      ],
      TextButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PraxisVerwaltung(
                    ansicht: PraxisAnsicht.beobachtung, tag: r.tag)));
            _neu();
          },
          child: Text(t.schlafBeobachtung)),
      const SizedBox(height: VpAbstand.l),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final typo = VpTypo.fuer(AppTheme.palette),
        daten = StorageService.getSchlafdaten();
    final sources = _vorschau.map((r) => r.quelle).toSet().toList()..sort();
    return Scaffold(
        appBar: AppBar(title: Text(t.schlafTitel)),
        body: SafeArea(
            child: !StorageService.spicyMode()
                ? Center(child: Text(t.traumpraxisNurSpicy))
                : ListView(
                    padding: const EdgeInsets.all(VpAbstand.rand),
                    children: [
                        SchlafTraumBlick(neu: _neu),
                        ExpansionTile(
                            title: Text(t.schlafMesswerte),
                            children: [
                              Text(t.schlafEinladung, style: typo.ueberschrift),
                              const SizedBox(height: VpAbstand.l),
                              Text(t.schlafErklaerung),
                              const SizedBox(height: VpAbstand.l),
                              Text(t.schlafDatenschutz),
                              const SizedBox(height: VpAbstand.l),
                              Text(t.schlafHinweis),
                              const SizedBox(height: VpAbstand.xl),
                              if (_zugang == null)
                                const LinearProgressIndicator()
                              else if (!_zugang!.verfuegbar)
                                Text(t.schlafNichtVerfuegbar)
                              else ...[
                                Text(!daten.verbunden
                                    ? t.schlafGetrennt
                                    : !_zugang!.berechtigt
                                        ? t.schlafBerechtigungFehlt
                                        : t.schlafVerbunden),
                                const SizedBox(height: VpAbstand.m),
                                Wrap(
                                    spacing: VpAbstand.s,
                                    runSpacing: VpAbstand.s,
                                    children: [
                                      if (!daten.verbunden ||
                                          !_zugang!.berechtigt)
                                        FilledButton(
                                            onPressed:
                                                _busy ? null : _verbinden,
                                            child: Text(t.schlafVerbinden))
                                      else
                                        FilledButton(
                                            onPressed: _busy ? null : _lesen,
                                            child: Text(t.schlafImportieren)),
                                      if (daten.verbunden)
                                        TextButton(
                                            onPressed: _trennen,
                                            child: Text(t.schlafTrennen)),
                                      TextButton(
                                          onPressed: _busy
                                              ? null
                                              : () => _aktion(
                                                  _dienst.einstellungen),
                                          child: Text(t.schlafEinstellungen)),
                                    ]),
                              ],
                              if (_busy)
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: VpAbstand.l),
                                    child: LinearProgressIndicator()),
                              if (_meldung != null)
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: VpAbstand.l),
                                    child: Semantics(
                                        liveRegion: true,
                                        child: Text(_meldung!))),
                              if (_vorschau.isNotEmpty) ...[
                                const Divider(),
                                Text(t.schlafQuelleWaehlen),
                                DropdownButtonFormField<String>(
                                    key: ValueKey(sources.join('/')),
                                    initialValue: _quelle,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                        labelText: t.schlafQuelle),
                                    items: [
                                      for (final s in sources)
                                        DropdownMenuItem(
                                            value: s,
                                            child: Text(s,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                    ],
                                    onChanged: _busy
                                        ? null
                                        : (value) =>
                                            setState(() => _quelle = value)),
                                FilledButton(
                                    onPressed: _busy || _quelle == null
                                        ? null
                                        : _uebernehmen,
                                    child: Text(t.schlafUebernehmen)),
                              ],
                              const SizedBox(height: VpAbstand.xl),
                              if (daten.letzterAbgleich != null)
                                Text(
                                    '${t.schlafLetzterAbgleich}: ${DateFormat.yMMMd(Sprache.code).add_Hm().format(daten.letzterAbgleich!.toLocal())}'),
                              if (daten.aufzeichnungen.isEmpty)
                                Text(t.schlafLeer),
                              for (final r in daten.aufzeichnungen)
                                _aufzeichnung(r),
                              Text(t.schlafImportierteKopie,
                                  style: typo.fliesstextKlein),
                              if (daten.aufzeichnungen.isNotEmpty)
                                TextButton(
                                    onPressed: _busy ? null : _loeschen,
                                    child: Text(t.schlafLoeschen)),
                            ]),
                      ])));
  }
}
