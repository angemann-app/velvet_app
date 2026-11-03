import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/t.dart';
import '../services/gemeinsam_dienst.dart';
import '../services/gemeinsam_hoeren.dart';
import '../services/nostr_service.dart';
import '../services/storage_service.dart';
import '../theme/vp_tokens.dart';
import '../widgets/lautsprecher_frage.dart';
import 'wiedergabe_screen.dart';
import '../models/gemeinsam_antwort.dart';
import '../widgets/aufnahme_status.dart';
import '../services/wiedergabe_plaene.dart';

class GemeinsamScreen extends StatefulWidget {
  final GemeinsamHoeren? vorschau;
  const GemeinsamScreen({super.key, this.vorschau});
  @override
  State<GemeinsamScreen> createState() => _GemeinsamScreenState();
}

class _GemeinsamScreenState extends State<GemeinsamScreen> {
  Timer? _takt;
  @override
  void initState() {
    super.initState();
    _takt = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _takt?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.vorschau ?? GemeinsamDienst.instanz.hoeren;
    return AnimatedBuilder(
        animation: h,
        builder: (context, _) => Scaffold(
            appBar: AppBar(title: Text(t.gemeinsamTitel)),
            body: SafeArea(
                child: ListView(
                    padding: const EdgeInsets.all(VpAbstand.rand),
                    children: [
                  Text(t.gemeinsamTitel, style: context.vp.typo.anzeige),
                  const SizedBox(height: VpAbstand.l),
                  Text(t.gemeinsamHinweis, style: context.vp.typo.fliesstext),
                  const SizedBox(height: VpAbstand.xl),
                  Text(_zustand(h), style: context.vp.typo.ueberschrift),
                  const SizedBox(height: VpAbstand.m),
                  if (h.phase == GemeinsamPhase.fehler && h.plan != null)
                    AufnahmeStatus(
                        pfade: [
                          for (final s in h.plan!.abschnitte)
                            if (s.pfad != null) s.pfad!
                        ],
                        sprache: h.plan!.sprache,
                        paketNamen: WiedergabePlaene.paketNamen(h.plan!),
                        geraeteStimmeMoeglich: false,
                        erneutLaden: true),
                  if (h.verbindungFehlt)
                    Text(t.gemeinsamVerbindungFehlt,
                        style: context.vp.typo.fliesstext),
                  if (h.phase == GemeinsamPhase.einladung) ...[
                    FilledButton(
                        onPressed: h.annehmen,
                        child: Text(t.gemeinsamAnnehmen)),
                    TextButton(
                        onPressed: () async {
                          await h.beenden();
                          h.verwerfen();
                        },
                        child: Text(t.gemeinsamSpaeter)),
                  ],
                  if (h.aktiv &&
                      h.angenommen &&
                      h.phase != GemeinsamPhase.hoert &&
                      h.phase != GemeinsamPhase.countdown &&
                      h.phase != GemeinsamPhase.fehler) ...[
                    Text(
                        h.ichBereit
                            ? t.gemeinsamWarten
                            : t.gemeinsamBereitHinweis,
                        style: context.vp.typo.fliesstextKlein),
                    const SizedBox(height: VpAbstand.l),
                    FilledButton(
                        onPressed: h.ichBereit
                            ? null
                            : () async {
                                if (await frageVorLautsprecher(context))
                                  await h.bereit();
                              },
                        child: Text(t.gemeinsamBereit)),
                  ],
                  if (h.phase == GemeinsamPhase.countdown ||
                      h.phase == GemeinsamPhase.hoert)
                    FilledButton.tonal(
                        onPressed: h.pause,
                        child: Text(t.playerSteuerungPause)),
                  if (h.angenommen)
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WiedergabeScreen())),
                        child: Text(t.gemeinsamPlayer)),
                  if (h.phase == GemeinsamPhase.ende && h.angenommen)
                    FilledButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GemeinsamRueckblickScreen(
                                    id: h.rueckblickId))),
                        child: Text(t.gemeinsamRueckblick)),
                  if (h.aktiv && h.phase != GemeinsamPhase.einladung)
                    TextButton(
                        onPressed: h.beenden,
                        child: Text(h.angenommen
                            ? t.gemeinsamBeenden
                            : t.gemeinsamZurueckziehen))
                  else if (!h.aktiv && h.phase != GemeinsamPhase.ruhe)
                    TextButton(
                        onPressed: () {
                          h.verwerfen();
                          Navigator.pop(context);
                        },
                        child: Text(t.gemeinsamSchliessen)),
                ]))));
  }

  String _zustand(GemeinsamHoeren h) => switch (h.phase) {
        GemeinsamPhase.einladung => t.gemeinsamEinladung,
        GemeinsamPhase.wartet =>
          h.angenommen ? t.gemeinsamVorbereiten : t.gemeinsamWartenAnnahme,
        GemeinsamPhase.countdown => t.gemeinsamCountdown(h.countdown),
        GemeinsamPhase.hoert => t.gemeinsamLaeuft,
        GemeinsamPhase.pause => t.gemeinsamPause,
        GemeinsamPhase.ende => t.gemeinsamAbgeschlossen,
        GemeinsamPhase.fehler => h.problem == 'aufnahmen'
            ? t.gemeinsamAufnahmenFehlen
            : h.problem == 'wiedergabe'
                ? t.gemeinsamWiedergabeFehler
                : h.problem == 'partner'
                    ? t.gemeinsamPartnerFehlt
                    : t.gemeinsamFehler,
        GemeinsamPhase.ruhe => t.gemeinsamLeer,
      };
}

class GemeinsamLeiste extends StatelessWidget {
  const GemeinsamLeiste({super.key});
  @override
  Widget build(BuildContext context) {
    final h = GemeinsamDienst.instanz.hoeren;
    return AnimatedBuilder(
        animation: h,
        builder: (context, _) {
          if (h.phase == GemeinsamPhase.ruhe) return const SizedBox.shrink();
          return ListTile(
              leading: const Icon(Icons.people_outline_rounded),
              title: Text(t.gemeinsamTitel,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                  h.phase == GemeinsamPhase.einladung
                      ? t.gemeinsamEinladung
                      : h.phase == GemeinsamPhase.ende
                          ? t.gemeinsamRueckblick
                          : t.gemeinsamStatusOeffnen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GemeinsamScreen())));
        });
  }
}

class GemeinsamRueckblickScreen extends StatefulWidget {
  final String id;
  const GemeinsamRueckblickScreen({super.key, required this.id});
  static bool gueltigeId(String id) =>
      RegExp(r'^ge_[sn]_[a-f0-9]{32}$').hasMatch(id);
  @override
  State<GemeinsamRueckblickScreen> createState() =>
      _GemeinsamRueckblickScreenState();
}

class _GemeinsamRueckblickScreenState extends State<GemeinsamRueckblickScreen> {
  late final _bestand =
      GemeinsamAntwort.lesen(StorageService.getReflectionAnswer(widget.id));
  late final _text = TextEditingController(text: _bestand.text);
  late String? _gefuehl = _bestand.gefuehl;
  bool _speichert = false;
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _teilen() async {
    if (_speichert || _text.text.trim().isEmpty) return;
    setState(() => _speichert = true);
    try {
      final lokal = GemeinsamAntwort(_text.text, gefuehl: _gefuehl).speichern();
      final geteilt =
          GemeinsamAntwort(_text.text, gefuehl: _gefuehl, geteilt: true)
              .speichern();
      await StorageService.saveReflectionAnswer(widget.id, lokal);
      final ok = await NostrService()
          .sendReflection(widget.id, t.gemeinsamRueckblick, geteilt);
      if (ok) await StorageService.saveReflectionAnswer(widget.id, geteilt);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(ok ? t.gemeinsamGeteilt : t.gemeinsamFehler)));
    } on FormatException {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.gemeinsamAntwortZuLang)));
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.gemeinsamFehler)));
    } finally {
      if (mounted) setState(() => _speichert = false);
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, spicy, _) {
        final erlaubt = GemeinsamRueckblickScreen.gueltigeId(widget.id) &&
            (!widget.id.startsWith('ge_s_') || spicy);
        return Scaffold(
            appBar: AppBar(title: Text(t.gemeinsamRueckblick)),
            body: !erlaubt
                ? Center(child: Text(t.wiedergabeLeer))
                : ListView(
                    padding: const EdgeInsets.all(VpAbstand.rand),
                    children: [
                        Text(t.gemeinsamRueckblickFrage,
                            style: context.vp.typo.ueberschrift),
                        const SizedBox(height: VpAbstand.m),
                        Text(t.gemeinsamRueckblickHinweis,
                            style: context.vp.typo.fliesstextKlein),
                        const SizedBox(height: VpAbstand.m),
                        Wrap(spacing: VpAbstand.s, children: [
                          for (final g in GemeinsamAntwort.gefuehle)
                            ChoiceChip(
                                label: Text(_gefuehlText(g)),
                                selected: _gefuehl == g,
                                onSelected: (an) =>
                                    setState(() => _gefuehl = an ? g : null))
                        ]),
                        const SizedBox(height: VpAbstand.m),
                        TextField(
                            controller: _text,
                            maxLength: 4000,
                            maxLines: 5,
                            decoration:
                                InputDecoration(labelText: t.gemeinsamAntwort)),
                        FilledButton(
                            onPressed: _speichert ? null : _teilen,
                            child: Text(t.gemeinsamTeilen)),
                        ValueListenableBuilder<Map<String, String>>(
                            valueListenable:
                                NostrService().partnerReflectionsNotifier,
                            builder: (context, antworten, _) {
                              final partner = antworten[widget.id];
                              final ich = GemeinsamAntwort.lesen(
                                  StorageService.getReflectionAnswer(
                                      widget.id));
                              if (partner == null ||
                                  !ich.geteilt ||
                                  ich.text.trim().isEmpty)
                                return Text(t.gemeinsamNochVerdeckt);
                              final antwort = GemeinsamAntwort.lesen(partner);
                              return Padding(
                                  padding:
                                      const EdgeInsets.only(top: VpAbstand.xl),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (antwort.gefuehl != null)
                                          Text(_gefuehlText(antwort.gefuehl!),
                                              style: context.vp.typo.titel),
                                        Text(antwort.text,
                                            style: context.vp.typo.fliesstext),
                                      ]));
                            }),
                      ]));
      });
  String _gefuehlText(String id) => switch (id) {
        'ruhig' => t.gemeinsamGefuehlRuhig,
        'nah' => t.gemeinsamGefuehlNah,
        'offen' => t.gemeinsamGefuehlOffen,
        _ => t.gemeinsamGefuehlBewegt,
      };
}
