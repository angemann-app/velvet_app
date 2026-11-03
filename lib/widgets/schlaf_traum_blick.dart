import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/t.dart';
import '../models/schlaf_traum_blick.dart';
import '../models/traumpraxis.dart';
import '../services/sprache.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../theme/vp_tokens.dart';
import '../screens/self_exploration/traum_tagebuch_screen.dart';
import '../screens/self_exploration/traumpraxis_screen.dart';
import '../screens/self_exploration/traumpraxis_verwalten.dart';

class SchlafTraumBlick extends StatelessWidget {
  final VoidCallback neu;
  const SchlafTraumBlick({super.key, required this.neu});

  Future<void> _oeffnen(BuildContext context, Widget seite) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => seite));
    neu();
  }

  @override
  Widget build(BuildContext context) {
    final typo = VpTypo.fuer(AppTheme.palette);
    final traeume = StorageService.getTraumEintraege();
    final tage = SchlafTraumTag.woche(
        heute: DateTime.now(),
        schlaf: StorageService.getSchlafdaten(),
        traeume: traeume,
        praxis: StorageService.getTraumpraxis());
    final angaben = tage.where((t) => t.hatAngaben).length;
    final klar = tage.where((t) => t.klar).length;
    final pause = Traumpraxis.pauseRaten(traeume);
    final erinnert = tage.any((t) => t.erinnert || t.klar);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.schlafBlickTitel, style: typo.ueberschrift),
      const SizedBox(height: VpAbstand.l),
      Text(t.schlafBlickEinladung),
      const SizedBox(height: VpAbstand.xl),
      Text(t.schlafBlickNaechster, style: typo.titel),
      const SizedBox(height: VpAbstand.s),
      Text(pause
          ? t.schlafBlickRuhe
          : klar > 0
              ? t.schlafBlickVertiefen
              : erinnert
                  ? t.schlafBlickUeben
                  : t.schlafBlickStart),
      if (!pause)
        TextButton.icon(
            onPressed: () => _oeffnen(
                context,
                erinnert
                    ? const TraumpraxisScreen()
                    : const TraumTagebuchScreen()),
            icon: Icon(erinnert
                ? Icons.nightlight_outlined
                : Icons.edit_note_outlined),
            label:
                Text(erinnert ? t.schlafBlickPraxis : t.traumpraxisNotieren)),
      const SizedBox(height: VpAbstand.xl),
      Text(t.schlafBlickWoche, style: typo.titel),
      if (angaben > 0)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: VpAbstand.m),
            child: Text(t.schlafBlickBilanz(klar, angaben))),
      for (final tag in tage) ...[
        const Divider(),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: VpAbstand.m),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  DateFormat.MMMEd(Sprache.code)
                      .format(DateTime.parse(tag.datum)),
                  style: typo.titel),
              Text(tag.messungen.isEmpty
                  ? t.schlafBlickOhneMessung
                  : tag.messungen.length > 1
                      ? t.schlafBlickMehrere
                      : '${t.schlafSchlafzeit}: ${tag.messungen.single.schlafzeit == null ? t.schlafUnbekannt : t.schlafDauer(tag.messungen.single.schlafzeit!.inHours, tag.messungen.single.schlafzeit!.inMinutes.remainder(60))}'),
              if (tag.messungen.length == 1 &&
                  tag.messungen.single.schlafzeit == null)
                Text(
                    '${t.schlafZeitfenster}: ${t.schlafDauer(tag.messungen.single.zeitfenster.inHours, tag.messungen.single.zeitfenster.inMinutes.remainder(60))}'),
              if (tag.klar) Text(t.schlafBlickKlar),
              if (tag.sinnlich) Text(t.schlafBlickSinnlich),
              if (tag.hoehepunkt) Text(t.schlafBlickHoehepunkt),
              if (tag.erinnert)
                Text(t.schlafBlickErinnert)
              else if (tag.nichtsErinnert)
                Text(t.schlafBlickOhneErinnerung)
              else if (!tag.klar && !tag.sinnlich && !tag.hoehepunkt)
                Text(t.schlafBlickUnbekannt),
              if (tag.beobachtung?.lust != null)
                Text(praxisLustName(tag.beobachtung!.lust!)),
              TextButton(
                  onPressed: () => _oeffnen(
                      context,
                      PraxisVerwaltung(
                          ansicht: PraxisAnsicht.beobachtung, tag: tag.datum)),
                  child: Text(t.schlafBlickNacht)),
            ])),
      ],
      const SizedBox(height: VpAbstand.l),
      Text(t.schlafBlickGrenze, style: typo.fliesstextKlein),
      const SizedBox(height: VpAbstand.xl),
    ]);
  }
}
