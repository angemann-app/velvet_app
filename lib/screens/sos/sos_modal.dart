import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/sos_anlaufstellen.dart';
import '../../l10n/t.dart';
import '../../models/content_models.dart';
import '../../services/data_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';

/// Hilfe-Blatt (früher „SOS Akut-Hilfe“): erst „Was ist gerade los?“, dann ein kurzer Weg mit einem Schritt pro Seite
/// oder der feste Hilfe-Teil. Nichts wird gespeichert. Konzept: docs/konzepte/sos-neu.md.
class SosModal extends StatefulWidget {
  /// Für Tests: direkt im Hilfe-Teil starten.
  final bool startHilfe;

  const SosModal({super.key, this.startHilfe = false});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SosModal(),
    );
  }

  @override
  State<SosModal> createState() => _SosModalState();
}

enum _Ansicht { auswahl, weg, hilfe }

class _SosModalState extends State<SosModal> {
  List<SosCard> _karten = [];
  _Ansicht _ansicht = _Ansicht.auswahl;
  SosCard? _karte;
  late SosLand _land;
  String? _anrufHinweis;
  PageController _seiten = PageController();
  int _seite = 0;

  @override
  void initState() {
    super.initState();
    _karten = DataService.getSosCards();
    _land = _startLand();
    if (widget.startHilfe) _ansicht = _Ansicht.hilfe;
  }

  @override
  void dispose() {
    _seiten.dispose();
    super.dispose();
  }

  SosLand _startLand() {
    final geraet = ui.PlatformDispatcher.instance.locale;
    switch ((geraet.countryCode ?? '').toUpperCase()) {
      case 'AT':
        return SosLand.at;
      case 'CH':
        return SosLand.ch;
      case 'GB':
        return SosLand.uk;
      case 'US':
        return SosLand.us;
      case 'DE':
        return SosLand.de;
    }
    return geraet.languageCode == 'de' ? SosLand.de : SosLand.uk;
  }

  void _neuerSeitenregler() {
    // Der alte Regler hängt noch am PageView dieses Frames: erst danach entsorgen.
    final alt = _seiten;
    WidgetsBinding.instance.addPostFrameCallback((_) => alt.dispose());
    _seiten = PageController();
    _seite = 0;
  }

  void _zurAuswahl() => setState(() {
        _ansicht = _Ansicht.auswahl;
        _karte = null;
        _neuerSeitenregler();
      });

  void _oeffneKarte(SosCard k) {
    setState(() {
      _karte = k;
      _ansicht = _Ansicht.weg;
      _neuerSeitenregler();
    });
  }

  void _oeffneHilfe() => setState(() => _ansicht = _Ansicht.hilfe);

  @override
  Widget build(BuildContext context) {
    final hoehe = MediaQuery.of(context).size.height * 0.90;
    return Container(
      height: hoehe,
      decoration: BoxDecoration(
        color: AppTheme.papier,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppTheme.signal, width: 2)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 44,
              height: 4,
              decoration: BoxDecoration(color: AppTheme.linie, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          _kopf(),
          Divider(height: 1, color: AppTheme.linie),
          Expanded(
            child: switch (_ansicht) {
              _Ansicht.auswahl => _auswahl(),
              _Ansicht.weg => _weg(_karte!),
              _Ansicht.hilfe => _hilfe(),
            },
          ),
        ],
      ),
    );
  }

  Widget _kopf() {
    final zurueck = _ansicht != _Ansicht.auswahl;
    final titel = _ansicht == _Ansicht.hilfe ? t.sosHilfeTitel : (_karte?.title ?? t.sosTitel);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        children: [
          if (zurueck)
            IconButton(
              tooltip: t.sosZurAuswahl,
              onPressed: _zurAuswahl,
              icon: Icon(Icons.arrow_back_rounded, color: AppTheme.tinteLeise),
            )
          else
            const SizedBox(width: 12),
          Expanded(
            child: Text(
              titel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppTheme.tinte, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: t.sosSchliessen,
            iconSize: 28,
            constraints: const BoxConstraints(minWidth: 52, minHeight: 52),
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: AppTheme.tinteLeise),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- Auswahl

  Widget _auswahl() {
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(VpAbstand.rand, 16, VpAbstand.rand, 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight - 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.sosAuswahlTitel,
                  style: TextStyle(color: AppTheme.tinte, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
              const SizedBox(height: 6),
              Text(t.sosAuswahlUntertitel, style: TextStyle(color: AppTheme.tinteLeise, fontSize: 14, height: 1.4)),
              const SizedBox(height: 16),
              for (final k in _karten) _wahl(k.title, () => _oeffneKarte(k)),
              const SizedBox(height: 4),
              _wahl(t.sosAuswahlHilfe, _oeffneHilfe, hervorgehoben: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wahl(String text, VoidCallback onTap, {bool hervorgehoben = false}) {
    final farbe = hervorgehoben ? AppTheme.signal : AppTheme.linie;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border: Border.all(color: farbe, width: hervorgehoben ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(text, style: TextStyle(color: AppTheme.tinte, fontSize: 16, height: 1.3, fontWeight: FontWeight.w500)),
                ),
                Icon(Icons.chevron_right_rounded, color: hervorgehoben ? AppTheme.signal : AppTheme.tinteStumm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------- Weg

  Widget _weg(SosCard k) {
    final gesamt = k.steps.length + 2; // Einstieg, Schritte, Sätze
    final letzte = _seite == gesamt - 1;

    Widget seite(String? kopf, Widget inhalt) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(VpAbstand.rand, 24, VpAbstand.rand, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kopf != null) ...[
                Text(kopf.toUpperCase(),
                    style: TextStyle(color: AppTheme.akzentTief, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                const SizedBox(height: 12),
              ],
              inhalt,
            ],
          ),
        );

    final grossText = TextStyle(color: AppTheme.tinte, fontSize: 21, height: 1.45);

    final seitenListe = <Widget>[
      seite(null, Text(k.intro, style: grossText)),
      for (var i = 0; i < k.steps.length; i++)
        seite(t.sosSchrittVon(i + 1, k.steps.length), Text(k.steps[i], style: grossText)),
      seite(
        t.sosSatzTitel,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in k.phrases)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.akzentTief.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.4)),
                ),
                child: Text(t.sosSatzZitat(s), style: TextStyle(color: AppTheme.tinte, fontSize: 19, height: 1.4, fontStyle: FontStyle.italic)),
              ),
            const SizedBox(height: 10),
            Text(k.closing, style: TextStyle(color: AppTheme.tinteLeise, fontSize: 17, height: 1.45)),
          ],
        ),
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _seiten,
            onPageChanged: (i) => setState(() => _seite = i),
            children: seitenListe,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < gesamt; i++)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _seite ? AppTheme.akzentTief : AppTheme.linie,
                ),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(VpAbstand.rand, 12, VpAbstand.rand, 20 + MediaQuery.viewPaddingOf(context).bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (letzte && k.toHelp) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: AppTheme.signal,
                    side: BorderSide(color: AppTheme.signal, width: 1.5),
                  ),
                  onPressed: _oeffneHilfe,
                  child: Text(t.sosHilfeKnopf),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  if (_seite > 0)
                    TextButton(
                      style: TextButton.styleFrom(minimumSize: const Size(88, 52)),
                      onPressed: () => _seiten.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                      child: Text(t.sosZurueck),
                    ),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: letzte
                          ? _zurAuswahl
                          : () => _seiten.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                      child: Text(letzte ? t.sosZurAuswahl : t.sosWeiter),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------ Hilfe

  String _landName(SosLand l) => switch (l) {
        SosLand.de => t.sosLandDe,
        SosLand.at => t.sosLandAt,
        SosLand.ch => t.sosLandCh,
        SosLand.uk => t.sosLandUk,
        SosLand.us => t.sosLandUs,
      };

  String _notrufText(SosLand l) => switch (l) {
        SosLand.de => t.sosNotrufDe,
        SosLand.at => t.sosNotrufAt,
        SosLand.ch => t.sosNotrufCh,
        SosLand.uk => t.sosNotrufUk,
        SosLand.us => t.sosNotrufUs,
      };

  String _stelleName(String id) => switch (id) {
        'DeFrauen' => t.sosStelleDeFrauenName,
        'DeMaenner' => t.sosStelleDeMaennerName,
        'DeWeisser' => t.sosStelleDeWeisserName,
        'DeSeelsorge' => t.sosStelleDeSeelsorgeName,
        'AtFrauen' => t.sosStelleAtFrauenName,
        'AtGewaltschutz' => t.sosStelleAtGewaltschutzName,
        'ChOpferhilfe' => t.sosStelleChOpferhilfeName,
        'UkRape' => t.sosStelleUkRapeName,
        'UsRainn' => t.sosStelleUsRainnName,
        _ => t.sosStelleUs988Name,
      };

  String _stelleHinweis(String id) => switch (id) {
        'DeFrauen' => t.sosStelleDeFrauenHinweis,
        'DeMaenner' => t.sosStelleDeMaennerHinweis,
        'DeWeisser' => t.sosStelleDeWeisserHinweis,
        'DeSeelsorge' => t.sosStelleDeSeelsorgeHinweis,
        'AtFrauen' => t.sosStelleAtFrauenHinweis,
        'AtGewaltschutz' => t.sosStelleAtGewaltschutzHinweis,
        'ChOpferhilfe' => t.sosStelleChOpferhilfeHinweis,
        'UkRape' => t.sosStelleUkRapeHinweis,
        'UsRainn' => t.sosStelleUsRainnHinweis,
        _ => t.sosStelleUs988Hinweis,
      };

  Future<void> _anrufen(String tel, String anzeige) async {
    var ok = false;
    try {
      ok = await launchUrl(Uri(scheme: 'tel', path: tel));
    } catch (_) {}
    // Kein Kopieren in die Zwischenablage (hinterlässt Spuren): Hinweis im Blatt selbst.
    if (!ok && mounted) setState(() => _anrufHinweis = t.sosHilfeNummerWaehlen(anzeige));
  }

  Future<void> _web(String url) async {
    var ok = false;
    try {
      ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!ok && mounted) setState(() => _anrufHinweis = url);
  }

  Widget _hilfe() {
    final stellen = sosStellen.where((s) => s.land == _land).toList();
    final gilt = [t.sosHilfeGilt1, t.sosHilfeGilt2, t.sosHilfeGilt3, t.sosHilfeGilt4];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(VpAbstand.rand, 20, VpAbstand.rand, 12),
            children: [
              Text(t.sosHilfeEinstieg, style: TextStyle(color: AppTheme.tinte, fontSize: 18, height: 1.5)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final l in SosLand.values)
                    ChoiceChip(
                      label: Text(_landName(l)),
                      selected: l == _land,
                      onSelected: (_) => setState(() => _land = l),
                    ),
                ],
              ),
              if (_anrufHinweis != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.papierErhoben,
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    border: Border.all(color: AppTheme.signal),
                  ),
                  child: Text(_anrufHinweis!, style: TextStyle(color: AppTheme.tinte, fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ],
              const SizedBox(height: 16),
              _notrufKarte(),
              const SizedBox(height: 16),
              Text(t.sosHilfeAnrufenTitel.toUpperCase(),
                  style: TextStyle(color: AppTheme.akzentTief, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              for (final s in stellen) _stelleKarte(s),
              const SizedBox(height: 8),
              Text(t.sosHilfeDiskretion, style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.45)),
              const SizedBox(height: 20),
              Text(t.sosHilfeGiltTitel.toUpperCase(),
                  style: TextStyle(color: AppTheme.akzentTief, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              for (final g in gilt)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3, right: 10),
                        child: Icon(Icons.check_rounded, size: 18, color: AppTheme.akzentTief),
                      ),
                      Expanded(child: Text(g, style: TextStyle(color: AppTheme.tinte, fontSize: 15, height: 1.45))),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(t.sosHilfeStand(sosAnlaufstellenStand), style: TextStyle(color: AppTheme.tinteStumm, fontSize: 12, height: 1.4)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(VpAbstand.rand, 8, VpAbstand.rand, 20 + MediaQuery.viewPaddingOf(context).bottom),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            icon: const Icon(Icons.exit_to_app_rounded),
            label: Text(t.sosHilfeSchnellVerlassen),
          ),
        ),
      ],
    );
  }

  Widget _notrufKarte() {
    final tel = sosNotrufTel[_land]!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.signal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.signal.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.sosHilfeNotrufTitel, style: TextStyle(color: AppTheme.signal, fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 4),
                Text(_notrufText(_land), style: TextStyle(color: AppTheme.tinte, fontSize: 15, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: t.sosHilfeAnrufenNummer(tel),
            excludeSemantics: true,
            button: true,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.signal, minimumSize: const Size(96, 52)),
              onPressed: () => _anrufen(tel, tel),
              child: Text(t.sosHilfeAnrufenNummer(tel)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stelleKarte(SosStelle s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_stelleName(s.id), style: TextStyle(color: AppTheme.tinte, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(s.anzeige, style: TextStyle(color: AppTheme.tinte, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_stelleHinweis(s.id), style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.45)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Semantics(
                label: '${_stelleName(s.id)}: ${t.sosHilfeAnrufenNummer(s.anzeige)}',
                excludeSemantics: true,
                button: true,
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(96, 48)),
                  onPressed: () => _anrufen(s.tel, s.anzeige),
                  child: Text(t.sosHilfeAnrufen),
                ),
              ),
              if (s.web != null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(96, 48)),
                  onPressed: () => _web(s.web!),
                  child: Text(t.sosHilfeWebseite),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
