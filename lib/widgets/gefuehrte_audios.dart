import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/t.dart';
import '../screens/couples_channel/paar_abend_screen.dart';
import '../screens/self_exploration/einschlaf_reise_screen.dart';
import '../screens/self_exploration/lust_im_traum_screen.dart';
import '../screens/self_exploration/selbst_reise_screen.dart';
import '../screens/self_exploration/traum_tagebuch_screen.dart';
import '../services/privacy_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Die geführten Audios gut sichtbar: Körperreise für dich, Gemeinsamer Abend für Paare.
/// Startseite (Kurse) und Paar-Kanal nutzen dieselben Karten.
class GefuehrteAudios extends StatelessWidget {
  /// Ohne Paar-Karte, z. B. bei Singles.
  final bool mitPaar;

  /// Ohne Körperreise, z. B. im Paar-Kanal.
  final bool mitSelbst;

  const GefuehrteAudios({super.key, this.mitPaar = true, this.mitSelbst = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mitSelbst && mitPaar)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(t.gefuehrtTitel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ),
        if (mitSelbst)
          GefuehrtKarte(
            bild: 'assets/images/guided_selbst.svg',
            titel: t.gefuehrtSelbstTitel,
            text: t.gefuehrtSelbstText,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SelbstReiseScreen())),
          ),
        if (mitSelbst) const _TagebuchKarte(),
        if (mitSelbst) const _EinschlafKarte(),
        if (mitSelbst) const _TraumKarte(),
        if (mitSelbst)
          ValueListenableBuilder<bool>(
            valueListenable: StorageService.spicyAenderung,
            builder: (context, spicy, _) => spicy ? const _LustKarte() : const SizedBox.shrink(),
          ),
        if (mitPaar)
          GefuehrtKarte(
            bild: 'assets/images/guided_paar.svg',
            titel: t.couplesChannelSharedEvening,
            text: t.couplesChannelGuidedTouchForTheTwo,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen())),
          ),
      ],
    );
  }
}

/// Die Einschlaf-Reise; im Diskretions-Modus steht auf der Karte nur „Entspannung“.
class _EinschlafKarte extends StatelessWidget {
  const _EinschlafKarte();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PrivacyService.isDiscreetIcon(),
      builder: (context, snapshot) => GefuehrtKarte(
        bild: 'assets/images/guided_einschlaf.svg',
        titel: snapshot.data == true ? t.einschlafKarteTitelNeutral : t.einschlafKarteTitel,
        text: t.einschlafKarteText,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EinschlafReiseScreen())),
      ),
    );
  }
}

/// Morgens nach einem Traum-Abend bzw. einem Abend „Lust im Traum“: ein Tipp zum Traumtagebuch.
/// Verschwindet mittags oder sobald seit dem Abend etwas eingetragen ist.
class _TagebuchKarte extends StatelessWidget {
  const _TagebuchKarte();

  @override
  Widget build(BuildContext context) {
    final jetzt = DateTime.now();
    if (jetzt.hour >= 12 || jetzt.hour < 4 || StorageService.letzterAbend() == null) return const SizedBox.shrink();
    final heute = DateTime(jetzt.year, jetzt.month, jetzt.day);
    if (StorageService.getTraumEintraege().any((e) => e.zeit.isAfter(heute))) return const SizedBox.shrink();
    return FutureBuilder<bool>(
      future: PrivacyService.isDiscreetIcon(),
      builder: (context, snapshot) => GefuehrtKarte(
        bild: 'assets/images/guided_einschlaf.svg',
        titel: snapshot.data == true ? t.tagebuchKarteTitelNeutral : t.tagebuchKarteTitel,
        text: snapshot.data == true ? t.tagebuchKarteTextNeutral : t.tagebuchKarteText,
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const TraumTagebuchScreen(neuOeffnen: true))),
      ),
    );
  }
}

/// Serie „Lust im Traum“, nur im Spicy-Modus. Im Diskretions-Modus neutral.
class _LustKarte extends StatelessWidget {
  const _LustKarte();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PrivacyService.isDiscreetIcon(),
      builder: (context, snapshot) => GefuehrtKarte(
        bild: 'assets/images/guided_einschlaf.svg',
        titel: snapshot.data == true ? t.lustKarteTitelNeutral : t.lustKarteTitel,
        text: snapshot.data == true ? t.lustKarteTextNeutral : t.lustKarteText,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LustImTraumScreen())),
      ),
    );
  }
}

/// Traum-Abend (Traum-Reise, erster Teil). Im Diskretions-Modus mit neutralem Titel.
class _TraumKarte extends StatelessWidget {
  const _TraumKarte();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PrivacyService.isDiscreetIcon(),
      builder: (context, snapshot) => GefuehrtKarte(
        bild: 'assets/images/guided_einschlaf.svg',
        titel: snapshot.data == true ? t.traumKarteTitelNeutral : t.traumKarteTitel,
        text: t.traumKarteText,
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EinschlafReiseScreen(traum: true))),
      ),
    );
  }
}

class GefuehrtKarte extends StatelessWidget {
  final String bild;
  final String titel;
  final String text;
  final VoidCallback onTap;

  const GefuehrtKarte({super.key, required this.bild, required this.titel, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: true,
        label: titel,
        child: Material(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: SizedBox(
              height: 128,
              child: Stack(fit: StackFit.expand, children: [
                SvgPicture.asset(bild, fit: BoxFit.cover),
                // Verlauf nach unten, damit der Text auf dem Bild lesbar bleibt.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.78)],
                      stops: const [0.25, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(titel,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        const SizedBox(height: 2),
                        Text(text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.3)),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppTheme.rose, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
