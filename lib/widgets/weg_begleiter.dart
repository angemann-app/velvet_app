import 'package:flutter/material.dart';
import '../l10n/t.dart';
import '../models/bedien_daten.dart';
import '../models/content_models.dart';
import '../services/storage_service.dart';
import '../services/data_service.dart';
import '../theme/vp_tokens.dart';

/// Neutraler Einstieg auf Heute; nicht zugängliche Inhalte bleiben unsichtbar.
class WegFortsetzen extends StatelessWidget {
  final void Function(Course, Lesson) oeffnen;
  const WegFortsetzen({super.key, required this.oeffnen});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: StorageService.bedienAenderung,
      builder: (context, _, child) {
        final stand = StorageService.getBedienDaten().weg;
        if (stand == null || stand.fertig) return const SizedBox.shrink();
        for (final kurs in DataService.getCourses()) {
          for (final lektion in kurs.lessons) {
            if (lektion.id == stand.lektion)
              return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.route_outlined),
                  title: Text(t.wegTitel, style: context.vp.typo.titel),
                  subtitle: Text([
                    t.wegWissen,
                    t.wegUeben,
                    t.wegNachspueren
                  ][stand.schritt]),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => oeffnen(kurs, lektion));
          }
        }
        return const SizedBox.shrink();
      });
}

/// Freiwillige Orientierung zu vorhandenen Inhalten. Fortschritt ist bewusst
/// bestätigt, nie aus Hörzeit oder vermeintlicher Übungsleistung abgeleitet.
class WegBegleiter extends StatefulWidget {
  final Lesson lektion;
  final void Function(int schritt) oeffnen;
  const WegBegleiter({super.key, required this.lektion, required this.oeffnen});
  @override
  State<WegBegleiter> createState() => _WegBegleiterState();
}

class _WegBegleiterState extends State<WegBegleiter> {
  bool _speichert = false;
  Future<void> _setzen(int schritt) async {
    if (_speichert) return;
    setState(() => _speichert = true);
    try {
      await StorageService.saveBedienDaten(BedienDaten(
          weg: WegStand(
              lektion: widget.lektion.id,
              schritt: schritt,
              geaendert: DateTime.now())));
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.wegFehler)));
    } finally {
      if (mounted) setState(() => _speichert = false);
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: StorageService.bedienAenderung,
      builder: (context, _, child) {
        final stand = StorageService.getBedienDaten().weg;
        final meiner = stand?.lektion == widget.lektion.id;
        final schritt = meiner ? stand!.schritt : 0;
        final titel = [t.wegWissen, t.wegUeben, t.wegNachspueren];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: VpAbstand.l),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.wegTitel, style: context.vp.typo.titel),
              const SizedBox(height: VpAbstand.s),
              Text(t.wegEinladung, style: context.vp.typo.fliesstextKlein),
              const SizedBox(height: VpAbstand.s),
              if (!meiner || schritt == 3)
                TextButton(
                    onPressed: _speichert ? null : () => _setzen(0),
                    child: Text(schritt == 3 && meiner
                        ? t.wegNochEinmal
                        : t.wegBeginnen))
              else ...[
                Text('${schritt + 1} / 3 · ${titel[schritt]}',
                    style: context.vp.typo.beschriftung),
                Wrap(spacing: VpAbstand.s, children: [
                  TextButton(
                      onPressed: () => widget.oeffnen(schritt),
                      child: Text(t.wegOeffnen)),
                  TextButton(
                      onPressed: _speichert ? null : () => _setzen(schritt + 1),
                      child:
                          Text(schritt == 2 ? t.wegAbschliessen : t.wegWeiter)),
                ]),
              ],
            ]));
      });
}
