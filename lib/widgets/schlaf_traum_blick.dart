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

  static String _dauer(Duration d) =>
      t.schlafDauer(d.inHours, d.inMinutes.remainder(60));

  /// Kalendertag in Worten: heute und gestern ausgeschrieben, sonst Wochentag und Datum.
  static String _tagName(String datum, DateTime jetzt) {
    final d = DateTime.parse(datum);
    final heute = DateTime(jetzt.year, jetzt.month, jetzt.day);
    final diff = DateTime(d.year, d.month, d.day).difference(heute).inDays;
    return diff == 0
        ? t.schlafBlickHeute
        : diff == -1
            ? t.schlafBlickGestern
            : DateFormat.MMMEd(Sprache.code).format(d);
  }

  /// Ein Tag in einfachen Worten: wie lange du geschlafen hast und alles, was du selbst festgehalten hast
  /// (Erholung, Lust, Träume, Notiz). Phasen und Zeitfenster stehen nur unter „Messwerte“.
  Widget _tag(BuildContext context, SchlafTraumTag tag, VpTypo typo) {
    final b = tag.beobachtung;
    final String? schlaf = tag.messungen.length > 1
        ? t.schlafBlickMehrere
        : tag.messungen.length == 1
            ? (tag.messungen.single.schlafzeit != null
                ? t.schlafBlickGeschlafen(_dauer(tag.messungen.single.schlafzeit!))
                : t.schlafBlickImBett(_dauer(tag.messungen.single.zeitfenster)))
            : null;
    final angaben = <String>[
      if (b?.schlaf != null) praxisSchlafName(b!.schlaf!),
      if (b?.lust != null) praxisLustName(b!.lust!),
      if (tag.klar) t.schlafBlickKlar,
      if (tag.sinnlich) t.schlafBlickSinnlich,
      if (tag.hoehepunkt) t.schlafBlickHoehepunkt,
      if (tag.erinnert)
        t.schlafBlickErinnert
      else if (tag.nichtsErinnert)
        t.schlafBlickOhneErinnerung,
    ];
    final notiz = b?.text.trim() ?? '';
    final nichts = !tag.hatAngaben;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: VpAbstand.m),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_tagName(tag.datum, DateTime.now()), style: typo.titel),
          if (schlaf != null)
            Padding(
                padding: const EdgeInsets.only(top: VpAbstand.s),
                child: Text(schlaf)),
          if (angaben.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(top: VpAbstand.s),
                child: Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.s, children: [
                  for (final a in angaben) Chip(label: Text(a))
                ])),
          if (notiz.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(top: VpAbstand.s),
                child: Text(notiz,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: typo.fliesstextKlein)),
          if (tag.hatAngaben && angaben.isEmpty && notiz.isEmpty)
            Padding(
                padding: const EdgeInsets.only(top: VpAbstand.s),
                child: Text(t.schlafBlickKeineBesonderheiten,
                    style: typo.fliesstextKlein)),
          if (nichts && schlaf == null)
            Padding(
                padding: const EdgeInsets.only(top: VpAbstand.s),
                child: Text(t.schlafBlickNochNichts,
                    style: typo.fliesstextKlein)),
          const SizedBox(height: VpAbstand.s),
          Builder(builder: (context) {
            final oeffnen = () => _oeffnen(
                context,
                PraxisVerwaltung(
                    ansicht: PraxisAnsicht.beobachtung, tag: tag.datum));
            return nichts
                ? FilledButton.tonal(
                    onPressed: oeffnen, child: Text(t.schlafBlickNacht))
                : TextButton(
                    onPressed: oeffnen, child: Text(t.schlafBlickAendern));
          }),
        ]));
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
        _tag(context, tag, typo),
      ],
      const SizedBox(height: VpAbstand.l),
      Text(t.schlafBlickGrenze, style: typo.fliesstextKlein),
      const SizedBox(height: VpAbstand.xl),
    ]);
  }
}
