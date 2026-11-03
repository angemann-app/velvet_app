import 'package:flutter/material.dart';
import '../l10n/t.dart';
import '../services/aufnahme_stand.dart';
import '../services/pakete.dart';
import '../theme/vp_tokens.dart';
import 'aufnahmen_karte.dart';
import '../services/paket_verzeichnis.dart';
import '../services/storage_service.dart';

/// Direkter Dateistatus am Angebot. Keine automatische Netzverbindung und kein
/// Download beim bloßen Anzeigen; Paketverwaltung erst nach bewusstem Antippen.
class AufnahmeStatus extends StatelessWidget {
  final List<String> pfade;
  final String? sprache;
  final List<String>? paketNamen;
  final bool geraeteStimmeMoeglich;
  final bool erneutLaden;
  const AufnahmeStatus(
      {super.key,
      required this.pfade,
      this.sprache,
      this.paketNamen,
      this.geraeteStimmeMoeglich = true,
      this.erneutLaden = false});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: Pakete.stand,
      builder: (context, _, child) {
        final stand = AufnahmeStand.pruefen(pfade, sprache: sprache);
        return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: VpAbstand.s,
            children: [
              Icon(stand.vollstaendig
                  ? Icons.offline_pin_outlined
                  : Icons.voice_chat_outlined),
              Text(
                  stand.vollstaendig
                      ? t.aufnahmeOffline
                      : geraeteStimmeMoeglich
                          ? t.aufnahmeGeraetestimme
                          : t.aufnahmePaketFehlt,
                  style: context.vp.typo.beschriftung),
              if (!stand.vollstaendig || erneutLaden)
                TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => SafeArea(
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.all(VpAbstand.rand),
                                child: paketNamen == null
                                    ? const AufnahmenKarte()
                                    : _PlanPakete(namen: paketNamen!)))),
                    child: Text(t.aufnahmeVerwalten)),
            ]);
      });
}

/// Verzeichnisabruf erst beim bewusst geöffneten Downloadfenster. Auch eigene
/// Pakete und die ursprüngliche Sprache eines gemerkten Ablaufs berücksichtigen.
class _PlanPakete extends StatefulWidget {
  final List<String> namen;
  const _PlanPakete({required this.namen});
  @override
  State<_PlanPakete> createState() => _PlanPaketeState();
}

class _PlanPaketeState extends State<_PlanPakete> {
  late final _verzeichnis = PaketVerzeichnis.laden();
  String? _laedt;
  Future<void> _laden(String name, PaketVerzeichnis v) async {
    if (_laedt != null) return;
    if ((name.endsWith('-lust') || name.endsWith('-reihe')) &&
        !StorageService.spicyMode()) return;
    setState(() => _laedt = name);
    try {
      await Pakete.laden(name, verzeichnis: v);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.aufnahmenFertig)));
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.aufnahmenFehler)));
    } finally {
      if (mounted) setState(() => _laedt = null);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<PaketVerzeichnis?>(
      future: _verzeichnis,
      builder: (context, snap) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.aufnahmenTitel, style: context.vp.typo.ueberschrift),
                for (final name in widget.namen) ...[
                  const SizedBox(height: VpAbstand.l),
                  Text(
                      '${_titel(name)} · ${name.startsWith('en-') ? t.spracheEnglisch : t.spracheDeutsch}',
                      style: context.vp.typo.titel),
                  if (snap.connectionState != ConnectionState.done)
                    const LinearProgressIndicator()
                  else if (snap.data?.paket(name) == null)
                    Text(t.aufnahmenNichtErreichbar)
                  else ...[
                    Text(
                        t.aufnahmenGroesse(
                            (snap.data!.paket(name)!.groesse / 1000000).ceil()),
                        style: context.vp.typo.beschriftung),
                    TextButton(
                        onPressed: _laedt == null
                            ? () => _laden(name, snap.data!)
                            : null,
                        child: Text(t.aufnahmenLaden)),
                    if (_laedt == name)
                      ValueListenableBuilder<Map<String, double>>(
                          valueListenable: Pakete.fortschritt,
                          builder: (_, stand, child) => LinearProgressIndicator(
                              value: stand[name] == 0 ? null : stand[name])),
                  ],
                ],
              ]));
  String _titel(String name) => name.endsWith('-lektionen')
      ? t.aufnahmenLektionen
      : name.endsWith('-lust')
          ? t.lustTitel
          : name.endsWith('-reihe')
              ? t.reiheTitel
              : t.aufnahmenGefuehrt;
}
