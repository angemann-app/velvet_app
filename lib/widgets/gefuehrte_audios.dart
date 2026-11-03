import 'package:flutter/material.dart';
import '../theme/vp_tokens.dart';
import 'design/vp_bild_feld.dart';
import 'package:flutter/services.dart';

import '../l10n/t.dart';
import '../screens/couples_channel/paar_abend_screen.dart';
import '../screens/self_exploration/einschlaf_reise_screen.dart';
import '../screens/self_exploration/lust_im_traum_screen.dart';
import '../screens/self_exploration/lust_reihe_screen.dart';
import '../screens/self_exploration/selbst_reise_screen.dart';
import '../screens/self_exploration/traum_tagebuch_screen.dart';
import '../screens/self_exploration/traumpraxis_screen.dart';
import '../screens/self_exploration/wecken_screen.dart';
import '../screens/gemeinsam_screen.dart';
import '../services/audio_gruppen.dart';
import '../services/gemeinsam_dienst.dart';
import '../services/nostr_service.dart';
import '../services/privacy_service.dart';
import '../services/storage_service.dart';
import '../services/testmodus.dart';
import '../theme/app_theme.dart';

/// Die geführten Audios gut sichtbar: Körperreise für dich, Gemeinsamer Abend für Paare.
/// Startseite (Kurse) und Paar-Kanal nutzen dieselben Karten.
class GefuehrteAudios extends StatelessWidget {
  /// Ohne Paar-Karte, z. B. bei Singles.
  final bool mitPaar;

  /// Ohne Körperreise, z. B. im Paar-Kanal.
  final bool mitSelbst;

  /// Startseite: kleine Kacheln in einer Reihe zum Wischen (docs/konzepte/startseite.md).
  final bool kompakt;

  const GefuehrteAudios({super.key, this.mitPaar = true, this.mitSelbst = true, this.kompakt = false});

  @override
  Widget build(BuildContext context) {
    final karten = _karten(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mitSelbst && mitPaar && !kompakt)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(t.gefuehrtTitel,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.tinte)),
          ),
        if (mitSelbst) const _TagebuchKarte(),
        if (kompakt)
          _Einklappbar(
            titel: t.gefuehrtTitel,
            child: _Kompakt(
              child: SizedBox(
                height: 150,
                child: ListView(scrollDirection: Axis.horizontal, children: karten),
              ),
            ),
          )
        else
          ...karten,
      ],
    );
  }

  List<Widget> _karten(BuildContext context) {
    return [
        if (mitSelbst)
          GefuehrtKarte(
            bild: 'assets/images/guided_selbst.svg',
            titel: t.gefuehrtSelbstTitel,
            text: t.gefuehrtSelbstText,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SelbstReiseScreen())),
          ),
        if (mitSelbst) const _EinschlafKarte(),
        if (mitSelbst) const _TraumKarte(),
        if (mitSelbst)
          ValueListenableBuilder<bool>(
            valueListenable: StorageService.spicyAenderung,
            builder: (context, spicy, _) => spicy ? const _LustKarte() : const SizedBox.shrink(),
          ),
        if (mitSelbst) const _ReiheKarte(),
        if (mitPaar)
          GefuehrtKarte(
            bild: 'assets/images/guided_paar.svg',
            titel: t.couplesChannelSharedEvening,
            text: t.couplesChannelGuidedTouchForTheTwo,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen())),
          ),
    ];
  }
}

String _gruppeTitel(AudioGruppe g, bool neutral) => switch (g) {
      AudioGruppe.fuerMich => t.audioGruppeFuerMich,
      AudioGruppe.fuerUns => t.audioGruppeFuerUns,
      AudioGruppe.nacht => neutral ? t.audioGruppeNachtNeutral : t.audioGruppeNacht,
      AudioGruppe.geschichten => neutral ? t.audioGruppeGeschichtenNeutral : t.audioGruppeGeschichten,
    };

String _gruppeText(AudioGruppe g) => switch (g) {
      AudioGruppe.fuerMich => t.audioGruppeFuerMichText,
      AudioGruppe.fuerUns => t.audioGruppeFuerUnsText,
      AudioGruppe.nacht => t.audioGruppeNachtText,
      AudioGruppe.geschichten => t.audioGruppeGeschichtenText,
    };

String _gruppeBild(AudioGruppe g) => switch (g) {
      AudioGruppe.fuerMich => 'assets/images/guided_selbst.svg',
      AudioGruppe.fuerUns => 'assets/images/guided_paar.svg',
      _ => 'assets/images/guided_einschlaf.svg',
    };

/// Heute: eine Empfehlung „Für heute“ und die übrigen Gruppen als Kacheln, dazu „Alle anzeigen“ als Rückfallebene
/// (docs/konzepte/audio-gruppen.md). Im Diskretions-Modus bleiben Titel neutral und ohne Erklärtext.
class AudioGruppenBereich extends StatefulWidget {
  final bool mitPaar;
  const AudioGruppenBereich({super.key, this.mitPaar = true});

  @override
  State<AudioGruppenBereich> createState() => _AudioGruppenBereichState();
}

class _AudioGruppenBereichState extends State<AudioGruppenBereich> {
  AudioGruppe? _zuletzt;
  DateTime? _zeit;
  bool _neutral = false;

  @override
  void initState() {
    super.initState();
    _laden();
  }

  Future<void> _laden() async {
    final z = await AudioGruppen.zuletztGeoeffnet();
    final neutral = await PrivacyService.isDiscreetIcon();
    if (!mounted) return;
    setState(() {
      _zuletzt = z?.$1;
      _zeit = z?.$2;
      _neutral = neutral;
    });
  }

  Future<void> _oeffnen(AudioGruppe g) async {
    await AudioGruppen.merken(g);
    if (!mounted) return;
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AudioGruppeSeite(gruppe: g, mitPaar: widget.mitPaar)));
    if (mounted) await _laden();
  }

  Widget _karte(AudioGruppe g, {double? breite}) {
    final gross = breite == null;
    final karte = GefuehrtKarte(
      bild: _gruppeBild(g),
      titel: _gruppeTitel(g, _neutral),
      text: _neutral ? '' : _gruppeText(g),
      breite: breite,
      onTap: () => _oeffnen(g),
    );
    return gross ? karte : _Kompakt(child: karte);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, spicy, _) {
        final jetzt = DateTime.now();
        final empfehlung = AudioGruppen.empfehlung(jetzt,
            spicy: spicy, paar: widget.mitPaar, zuletzt: _zuletzt, zuletztZeit: _zeit);
        final rest = AudioGruppen.reihenfolge(jetzt, spicy: spicy, paar: widget.mitPaar)
            .where((g) => g != empfehlung)
            .toList();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _TagebuchKarte(),
          _Einklappbar(
            titel: t.gefuehrtTitel,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.audioFuerHeute, style: context.vp.typo.beschriftung),
              const SizedBox(height: VpAbstand.s),
              _karte(empfehlung),
              LayoutBuilder(
                builder: (context, c) {
                  final breite = (c.maxWidth / 2 - 10.5).floorToDouble();
                  return Wrap(runSpacing: 10, children: [for (final g in rest) _karte(g, breite: breite)]);
                },
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AlleAudiosSeite(mitPaar: widget.mitPaar))),
                child: Text(t.audioAlleAnzeigen),
              ),
            ]),
          ),
        ]);
      },
    );
  }
}

/// Eine Gruppe mit ihren Einstiegen; sortiert wie bisher in den Karten, jeweils mit Spicy- und Diskretionsregeln.
class AudioGruppeSeite extends StatelessWidget {
  final AudioGruppe gruppe;
  final bool mitPaar;
  const AudioGruppeSeite({super.key, required this.gruppe, this.mitPaar = true});

  Widget _spicy(Widget Function() karte) => ValueListenableBuilder<bool>(
        valueListenable: StorageService.spicyAenderung,
        builder: (context, spicy, _) => spicy ? karte() : const SizedBox.shrink(),
      );

  List<Widget> _eintraege(BuildContext context, bool neutral) => switch (gruppe) {
        AudioGruppe.fuerMich => [
            GefuehrtKarte(
              bild: 'assets/images/guided_selbst.svg',
              titel: t.gefuehrtSelbstTitel,
              text: t.gefuehrtSelbstText,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SelbstReiseScreen())),
            ),
            _spicy(() => GefuehrtKarte(
                  bild: 'assets/images/guided_einschlaf.svg',
                  titel: neutral ? t.traumpraxisKarteTitelNeutral : t.traumpraxisKarteTitel,
                  text: t.traumpraxisKarteText,
                  onTap: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TraumpraxisScreen())),
                )),
          ],
        AudioGruppe.fuerUns => [
            GefuehrtKarte(
              bild: 'assets/images/guided_paar.svg',
              titel: t.couplesChannelSharedEvening,
              text: t.couplesChannelGuidedTouchForTheTwo,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen())),
            ),
            if (NostrService().isPaired) const _GemeinsamHinweis(),
          ],
        AudioGruppe.nacht => [
            const _EinschlafKarte(),
            const _TraumKarte(),
            GefuehrtKarte(
              bild: 'assets/images/guided_einschlaf.svg',
              titel: t.weckenBegleitungTitel,
              text: t.weckenBegleitungEinleitung,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WeckenScreen())),
            ),
            _spicy(() => const _LustKarte()),
          ],
        AudioGruppe.geschichten => [const _ReiheKarte()],
      };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PrivacyService.isDiscreetIcon(),
      builder: (context, snapshot) {
        final neutral = snapshot.data == true;
        return Scaffold(
          backgroundColor: AppTheme.papier,
          appBar: AppBar(title: Text(_gruppeTitel(gruppe, neutral))),
          body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(VpAbstand.rand), children: [
              Text(_gruppeText(gruppe), style: context.vp.typo.fliesstext),
              const SizedBox(height: VpAbstand.l),
              ..._eintraege(context, neutral),
            ]),
          ),
        );
      },
    );
  }
}

/// „Gemeinsam hören“ startet im Player; hier steht nur, wie, und der Weg zum laufenden Abgleich.
class _GemeinsamHinweis extends StatelessWidget {
  const _GemeinsamHinweis();

  @override
  Widget build(BuildContext context) {
    final h = GemeinsamDienst.instanz.hoeren;
    return AnimatedBuilder(
      animation: h,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.only(top: VpAbstand.s, bottom: VpAbstand.l),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.audioGemeinsamTitel, style: context.vp.typo.titel),
          const SizedBox(height: VpAbstand.s),
          Text(t.audioGemeinsamText, style: context.vp.typo.fliesstextKlein),
          if (h.aktiv)
            TextButton(
              onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GemeinsamScreen())),
              child: Text(t.gemeinsamStatusOeffnen),
            ),
        ]),
      ),
    );
  }
}

/// Rückfallebene: die bisherige vollständige Liste aller Einstiege.
class AlleAudiosSeite extends StatelessWidget {
  final bool mitPaar;
  const AlleAudiosSeite({super.key, this.mitPaar = true});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(title: Text(t.gefuehrtTitel)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(VpAbstand.rand),
            children: [GefuehrteAudios(mitPaar: mitPaar)],
          ),
        ),
      );
}

/// Dünner Balken, der die Kachelreihe der geführten Audios beim Antippen ausklappt.
/// Der Zustand bleibt dauerhaft gespeichert (auch in der Sicherung); beim ersten Start ist der Bereich offen.
class _Einklappbar extends StatefulWidget {
  final String titel;
  final Widget child;

  const _Einklappbar({required this.titel, required this.child});

  @override
  State<_Einklappbar> createState() => _EinklappbarState();
}

class _EinklappbarState extends State<_Einklappbar> {
  bool _offen = StorageService.getAudioBereichOffen();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Semantics(
        button: true,
        expanded: _offen,
        label: widget.titel,
        child: Material(
          color: AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          child: InkWell(
            borderRadius: BorderRadius.circular(VpRadius.karte),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _offen = !_offen);
              StorageService.setAudioBereichOffen(_offen);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(children: [
                Icon(Icons.headphones_rounded, size: 18, color: AppTheme.akzentTief),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.titel,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
                ),
                AnimatedRotation(
                  turns: _offen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more_rounded, size: 22, color: AppTheme.tinteLeise),
                ),
              ]),
            ),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: _offen
            ? Padding(padding: const EdgeInsets.only(top: 10), child: widget.child)
            : const SizedBox(width: double.infinity),
      ),
    ]);
  }
}

/// Markiert die kompakte Darstellung für die Karten darunter.
class _Kompakt extends InheritedWidget {
  const _Kompakt({required super.child});

  static bool von(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_Kompakt>() != null;

  @override
  bool updateShouldNotify(_Kompakt oldWidget) => false;
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
    if (!Testmodus.an && (jetzt.hour >= 12 || jetzt.hour < 4 || StorageService.letzterAbend() == null)) {
      return const SizedBox.shrink();
    }
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

/// Audioreihe „Innenansichten“ (docs/konzepte/lust-audioreihe.md). Im Diskretions-Modus neutral. Vorerst nur
/// im Spicy-Modus sichtbar, auch die Soft-Fassungen (Entscheidung des Nutzers, 28.10.2026).
class _ReiheKarte extends StatelessWidget {
  const _ReiheKarte();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, spicy, _) => !spicy
          ? const SizedBox.shrink()
          : FutureBuilder<bool>(
              future: PrivacyService.isDiscreetIcon(),
              builder: (context, snapshot) => GefuehrtKarte(
                bild: 'assets/images/guided_einschlaf.svg',
                titel: snapshot.data == true ? t.reiheKarteTitelNeutral : t.reiheKarteTitel,
                text: snapshot.data == true ? t.reiheKarteTextNeutral : t.reiheKarteText,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LustReiheScreen())),
              ),
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

  /// Feste Breite, z. B. für zwei Kacheln nebeneinander; sonst 168 (kompakt) oder volle Breite.
  final double? breite;

  const GefuehrtKarte(
      {super.key, required this.bild, required this.titel, required this.text, required this.onTap, this.breite});

  @override
  Widget build(BuildContext context) {
    final kompakt = _Kompakt.von(context);
    return Padding(
      padding: kompakt ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: true,
        label: titel,
        child: Material(
          color: AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: SizedBox(
              height: kompakt ? 150 : 128,
              width: breite ?? (kompakt ? 168 : null),
              child: Stack(fit: StackFit.expand, children: [
                VpBildFeld.pfad(bild, format: VpBildFormat.kopf),
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
                            maxLines: kompakt ? 2 : null,
                            overflow: kompakt ? TextOverflow.ellipsis : null,
                            style: TextStyle(
                                fontSize: kompakt ? 15 : 17, fontWeight: FontWeight.w800, color: AppTheme.aufBild)),
                        if (!kompakt) const SizedBox(height: 2),
                        if (!kompakt && text.isNotEmpty)
                          Text(text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.5, color: AppTheme.aufBild.withValues(alpha: 0.85), height: 1.3)),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppTheme.akzentTief, shape: BoxShape.circle),
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
