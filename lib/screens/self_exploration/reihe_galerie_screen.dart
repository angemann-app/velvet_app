import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../l10n/t.dart';
import '../../models/lust_reihe.dart';
import '../../services/pakete.dart';
import '../../services/privacy_service.dart';
import '../../services/storage_service.dart';
import '../../theme/vp_tokens.dart';

/// Die Szenenbilder einer Folge im Vollbild: Wischen zwischen den Szenen, Zoomen mit zwei Fingern, Stufen wählen
/// (docs/konzepte/szenenbilder-galerie-beta.md). Nur im Spicy-Modus (die Reihe ist es ohnehin), ohne diskretes
/// App-Symbol, ohne Screenshots und Vorschau im App-Wechsler.
class ReiheGalerieScreen extends StatefulWidget {
  final ReiheFolge folge;
  final String variante;
  final String? perspektive;

  /// Löst einen Paketpfad in eine Datei auf; in Tests ersetzbar.
  final String? Function(String pfad)? dateiVon;

  const ReiheGalerieScreen({
    super.key,
    required this.folge,
    required this.variante,
    this.perspektive,
    this.dateiVon,
  });

  /// Bilder der Folge in einer Stufe, in der Reihenfolge des Szenenbuchs; nur die, die es im Paket gibt.
  static List<GalerieBild> bilder(
    ReiheFolge folge,
    String variante,
    String? perspektive, {
    required bool spicyErlaubt,
    String? Function(String pfad)? dateiVon,
  }) {
    final fassung = _fassung(folge, variante, perspektive, spicyErlaubt);
    if (fassung == null) return const [];
    final suche = dateiVon ?? Pakete.datei;
    return [
      for (final szene in folge.szenen)
        if (fassung.segmente.where((s) => s.szene == szene.id).firstOrNull case final segment?)
          if (suche(ReiheDaten.bildPfad(folge, fassung, segment)) case final datei?)
            GalerieBild(szene.id, szene.beschreibung, datei)
    ];
  }

  static ReiheFassung? _fassung(ReiheFolge folge, String variante, String? perspektive, bool spicyErlaubt) {
    if (!folge.varianten(spicyErlaubt: spicyErlaubt).contains(variante)) return null;
    return folge.gewaehlt(variante, perspektive, spicyErlaubt: spicyErlaubt);
  }

  /// Gibt es in irgendeiner erlaubten Stufe mindestens ein Bild? Dann lohnt sich der Einstieg.
  static bool hatBilder(ReiheFolge folge, String? perspektive,
          {required bool spicyErlaubt, String? Function(String pfad)? dateiVon}) =>
      folge
          .varianten(spicyErlaubt: spicyErlaubt)
          .any((v) => bilder(folge, v, perspektive, spicyErlaubt: spicyErlaubt, dateiVon: dateiVon).isNotEmpty);

  @override
  State<ReiheGalerieScreen> createState() => _ReiheGalerieScreenState();
}

class GalerieBild {
  final String szene;
  final String beschreibung;
  final String datei;
  const GalerieBild(this.szene, this.beschreibung, this.datei);
}

class _ReiheGalerieScreenState extends State<ReiheGalerieScreen> {
  late String _variante;
  final _seiten = PageController();
  int _seite = 0;

  @override
  void initState() {
    super.initState();
    _variante = widget.variante;
    unawaited(PrivacyService.applySecureFlag(true));
    unawaited(_diskretPruefen());
  }

  /// Das diskrete App-Symbol zeigt nie Bilder, auch nicht, wenn jemand die Seite anders erreicht.
  Future<void> _diskretPruefen() async {
    if (await PrivacyService.isDiscreetIcon() && mounted) Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    _seiten.dispose();
    PaintingBinding.instance.imageCache.clear();
    unawaited(PrivacyService.isLockEnabled().then(PrivacyService.applySecureFlag));
    super.dispose();
  }

  String _name(String v) => switch (v) {
        'spicy' => t.reiheSpicy,
        'sehrspicy' => t.reiheSehrSpicy,
        _ => t.reiheSoft,
      };

  @override
  Widget build(BuildContext context) {
    final spicy = StorageService.spicyMode();
    final stufen = widget.folge
        .varianten(spicyErlaubt: spicy)
        .where((v) => ReiheGalerieScreen.bilder(widget.folge, v, widget.perspektive,
                spicyErlaubt: spicy, dateiVon: widget.dateiVon)
            .isNotEmpty)
        .toList();
    final aktiv = stufen.contains(_variante) ? _variante : (stufen.isEmpty ? null : stufen.first);
    final bilder = aktiv == null
        ? const <GalerieBild>[]
        : ReiheGalerieScreen.bilder(widget.folge, aktiv, widget.perspektive,
            spicyErlaubt: spicy, dateiVon: widget.dateiVon);
    final seite = _seite.clamp(0, bilder.isEmpty ? 0 : bilder.length - 1);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(t.reiheGalerieTitel),
      ),
      body: SafeArea(
        child: bilder.isEmpty
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.all(VpAbstand.rand),
                    child: Text(t.reiheGalerieLeer,
                        textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70))))
            : Column(children: [
                if (stufen.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: VpAbstand.s),
                    child: Wrap(spacing: VpAbstand.s, children: [
                      for (final v in stufen)
                        ChoiceChip(
                          label: Text(_name(v)),
                          selected: v == aktiv,
                          onSelected: (_) => setState(() {
                            _variante = v;
                            _seite = 0;
                            if (_seiten.hasClients) _seiten.jumpToPage(0);
                          }),
                        ),
                    ]),
                  ),
                Expanded(
                  child: PageView.builder(
                    key: ValueKey('galerie_$aktiv'),
                    controller: _seiten,
                    itemCount: bilder.length,
                    onPageChanged: (i) => setState(() => _seite = i),
                    itemBuilder: (context, i) => InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Center(
                        child: Image.file(File(bilder[i].datei),
                            key: ValueKey('galerie_bild_${bilder[i].szene}'),
                            fit: BoxFit.contain,
                            errorBuilder: (_, error, stack) => const SizedBox.shrink()),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(VpAbstand.rand, VpAbstand.s, VpAbstand.rand, VpAbstand.l),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(bilder[seite].beschreibung,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, height: 1.4)),
                    const SizedBox(height: VpAbstand.s),
                    Text('${seite + 1} / ${bilder.length}',
                        style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                  ]),
                ),
              ]),
      ),
    );
  }
}
