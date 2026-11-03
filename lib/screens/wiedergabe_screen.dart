import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/t.dart';
import '../services/pakete.dart';
import '../services/storage_service.dart';
import '../services/wiedergabe_dienst.dart';
import '../services/wiedergabe_lauf.dart';
import '../theme/app_theme.dart';
import '../theme/vp_tokens.dart';
import '../widgets/lautsprecher_frage.dart';
import '../widgets/player_steuerung.dart';
import '../services/gemeinsam_dienst.dart';
import '../services/nostr_service.dart';
import '../models/wiedergabe_plan.dart';
import '../widgets/aussprache_melden.dart';
import 'gemeinsam_screen.dart';
import '../widgets/aufnahme_status.dart';
import '../services/wiedergabe_plaene.dart';

String hoerzeit(Duration d) =>
    '${d.inMinutes.toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

class WiedergabeScreen extends StatelessWidget {
  final WiedergabeLauf? vorschau;
  const WiedergabeScreen({super.key, this.vorschau});
  @override
  Widget build(BuildContext context) {
    final dienst = WiedergabeDienst.instanz;
    final l = vorschau ?? dienst.lauf;
    final gemeinsam = GemeinsamDienst.instanz.hoeren;
    return AnimatedBuilder(
        animation: Listenable.merge(
            [l, gemeinsam, StorageService.spicyAenderung, Pakete.stand]),
        builder: (context, _) {
          final p = l.plan;
          final zugang = p != null && (!p.spicy || StorageService.spicyMode());
          final s = zugang ? l.abschnitt : null;
          final datei = s?.bild == null
              ? null
              : Pakete.datei(s!.bild!, sprache: p!.sprache);
          return Scaffold(
              appBar: AppBar(title: Text(t.wiedergabeNeutral)),
              body: !zugang
                  ? Center(child: Text(t.wiedergabeLeer))
                  : SafeArea(
                      child: ListView(
                          padding: const EdgeInsets.all(VpAbstand.rand),
                          children: [
                          if (datei != null)
                            Padding(
                                padding:
                                    const EdgeInsets.only(bottom: VpAbstand.xl),
                                child: AspectRatio(
                                    aspectRatio: VpBildFormat.kopf.verhaeltnis,
                                    child: Image.file(File(datei),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, error, stack) =>
                                            const SizedBox.shrink()))),
                          Text(p.titel.isEmpty ? t.wiedergabeNeutral : p.titel,
                              style: context.vp.typo.anzeige),
                          const SizedBox(height: VpAbstand.m),
                          Text(t.wiedergabeBehalten,
                              style: context.vp.typo.fliesstextKlein),
                          const SizedBox(height: VpAbstand.l),
                          Text(
                              '${l.index + 1} / ${p.abschnitte.length} · ${hoerzeit(l.vergangen)} / ${hoerzeit(l.dauer)}',
                              style: context.vp.typo.zahl),
                          const SizedBox(height: VpAbstand.s),
                          if (s!.runde > 0)
                            Text(t.wiedergabeRunde(s.runde),
                                style: context.vp.typo.titel),
                          if (p.art == WiedergabeArt.paar && s.runde > 0)
                            Text(
                                (s.runde == 1) ==
                                        (p.parameter['ichZuerst'] == true)
                                    ? t.paarAbendYouGivePartnernameReceives(
                                        NostrService().partnerName.isEmpty
                                            ? t.paarAbendYourPartner
                                            : NostrService().partnerName)
                                    : t.gemeinsamDuEmpfaengst,
                                style: context.vp.typo.fliesstext),
                          if (l.zustand == WiedergabeZustand.laden)
                            const LinearProgressIndicator(),
                          if (l.zustand == WiedergabeZustand.fehler)
                            Text(t.wiedergabeFehler,
                                style: context.vp.typo.fliesstext),
                          if (l.geraetestimme)
                            Text(t.wiedergabeTts,
                                style: context.vp.typo.beschriftung),
                          const SizedBox(height: VpAbstand.l),
                          if (l.zustand == WiedergabeZustand.fertig)
                            Text(t.wiedergabeFertig,
                                style: context.vp.typo.ueberschrift)
                          else
                            PlayerSteuerung(
                                pausiert: !l.spielt,
                                farbe: AppTheme.akzentTief,
                                symbolFarbe: AppTheme.aufAkzentTief,
                                onBeenden: () async {
                                  await dienst.beenden();
                                  if (context.mounted) Navigator.pop(context);
                                },
                                onPause: () async {
                                  if (l.spielt) {
                                    await dienst.pause();
                                  } else if (await frageVorLautsprecher(
                                      context)) {
                                    await dienst.weiter();
                                  }
                                },
                                ueberspringenErlaubt: !gemeinsam.aktiv,
                                onUeberspringen: () => l.naechster()),
                          const SizedBox(height: VpAbstand.l),
                          _AbschnittRegler(lauf: l, gemeinsam: gemeinsam.aktiv),
                          const SizedBox(height: VpAbstand.l),
                          AufnahmeStatus(
                              pfade: p.abschnitte
                                  .where((s) => s.pfad != null)
                                  .map((s) => s.pfad!)
                                  .toList(),
                              sprache: p.sprache,
                              paketNamen: WiedergabePlaene.paketNamen(p),
                              erneutLaden:
                                  l.zustand == WiedergabeZustand.fehler,
                              geraeteStimmeMoeglich: p.abschnitte
                                  .where((s) => s.art == AbschnittArt.sprache)
                                  .every((s) => s.text.isNotEmpty)),
                          const SizedBox(height: VpAbstand.xl),
                          ExpansionTile(
                              title: Text(t.wiedergabeAbschnitte),
                              children: [
                                for (var i = 0; i < p.abschnitte.length; i++)
                                  ListTile(
                                      leading: Text('${i + 1}',
                                          style: context.vp.typo.zahl),
                                      title: Text(
                                          p.abschnitte[i].text.isEmpty
                                              ? t.wiedergabeRuhe
                                              : p.abschnitte[i].text,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      selected: l.index == i,
                                      onTap: gemeinsam.aktiv
                                          ? null
                                          : () => l.springen(i)),
                              ]),
                          if (!l.geraetestimme)
                            AusspracheMeldenButton(
                                wo: '${p.art.name}/${p.id}/${s.id}',
                                stimme: p.parameter['stimme'] as String?,
                                position: () => l.aufnahmePosition),
                          if (gemeinsam.aktiv)
                            TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const GemeinsamScreen())),
                                child: Text(t.gemeinsamStatusOeffnen))
                          else if (NostrService().isPaired &&
                              p.art != WiedergabeArt.praxis &&
                              l.zustand != WiedergabeZustand.fertig)
                            OutlinedButton.icon(
                                icon: const Icon(Icons.people_outline_rounded),
                                label: Text(t.gemeinsamStarten),
                                onPressed: () async {
                                  await gemeinsam.einladen(p);
                                  if (context.mounted)
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const GemeinsamScreen()));
                                }),
                          TextButton(
                              onPressed: () async {
                                await dienst.beenden(entfernen: true);
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Text(t.wiedergabeEntfernen)),
                        ])));
        });
  }
}

class _AbschnittRegler extends StatefulWidget {
  final WiedergabeLauf lauf;
  final bool gemeinsam;
  const _AbschnittRegler({required this.lauf, this.gemeinsam = false});
  @override
  State<_AbschnittRegler> createState() => _AbschnittReglerState();
}

class _AbschnittReglerState extends State<_AbschnittRegler> {
  double? _wahl;
  @override
  Widget build(BuildContext context) {
    final l = widget.lauf;
    final dauer =
        l.nativeLaenge > Duration.zero ? l.nativeLaenge : l.abschnitt!.dauer;
    final max = dauer.inMilliseconds.toDouble().clamp(1.0, double.infinity);
    return Slider(
        value: (_wahl ?? l.aufnahmePosition.inMilliseconds.toDouble())
            .clamp(0.0, max),
        max: max,
        label: hoerzeit(Duration(milliseconds: (_wahl ?? 0).round())),
        onChanged: l.geraetestimme || widget.gemeinsam
            ? null
            : (v) => setState(() => _wahl = v),
        onChangeEnd: l.geraetestimme || widget.gemeinsam
            ? null
            : (v) async {
                await l.suchen(Duration(milliseconds: v.round()));
                if (mounted) setState(() => _wahl = null);
              });
  }
}

/// Absichtlich neutraler Titel auch außerhalb des Diskretionsmodus; ein kleiner
/// Player neben anderen Bereichen verrät keine Namen oder Inhaltstitel.
class WiedergabeMini extends StatelessWidget {
  const WiedergabeMini({super.key});
  @override
  Widget build(BuildContext context) {
    final d = WiedergabeDienst.instanz;
    return AnimatedBuilder(
        animation: Listenable.merge([d.lauf, StorageService.spicyAenderung]),
        builder: (context, _) {
          final l = d.lauf;
          if (!l.vorhanden || (l.plan!.spicy && !StorageService.spicyMode()))
            return const SizedBox.shrink();
          return Material(
              color: AppTheme.papierErhoben,
              child: ListTile(
                  title:
                      Text(t.wiedergabeNeutral, style: context.vp.typo.titel),
                  subtitle: Text(
                      '${hoerzeit(l.vergangen)} · ${l.spielt ? t.wiedergabeLaeuft : t.wiedergabeFortsetzen}'),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WiedergabeScreen())),
                  trailing: IconButton(
                      tooltip: l.spielt
                          ? t.playerSteuerungPause
                          : t.playerSteuerungResume,
                      icon: Icon(l.spielt
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                      onPressed: () async {
                        if (l.spielt) {
                          await d.pause();
                        } else if (await frageVorLautsprecher(context)) {
                          await d.weiter();
                        }
                      })));
        });
  }
}

Future<void> hoerplanOeffnen(
    BuildContext context, Future<void> Function() starten) async {
  try {
    await starten();
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wiedergabeFehler)));
    return;
  }
  if (context.mounted)
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const WiedergabeScreen()));
}
