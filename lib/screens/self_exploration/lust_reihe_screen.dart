import 'dart:async';

import 'package:flutter/material.dart';
import '../../widgets/aufnahme_status.dart';
import '../../services/wiedergabe_plaene.dart';
import '../../services/wiedergabe_dienst.dart';
import '../wiedergabe_screen.dart';
import 'reihe_galerie_screen.dart';
import '../../theme/vp_tokens.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/t.dart';
import '../../models/lust_reihe.dart';
import '../../services/paket_verzeichnis.dart';
import '../../services/pakete.dart';
import '../../services/privacy_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lautsprecher_frage.dart';

/// Audioreihe „Innenansichten“ (docs/konzepte/lust-audioreihe.md): zusammenhängende Erzählungen, Soft und
/// Spicy, Perspektiven derselben Begegnung mit gemeinsamen Szenen-IDs. Inhalte nur aus dem Paket
/// `<sprache>-reihe` (nur R2), Wiedergabe szenenweise ohne künstliche Stille.
class LustReiheScreen extends StatefulWidget {
  const LustReiheScreen({super.key});

  @override
  State<LustReiheScreen> createState() => _LustReiheScreenState();
}

class _LustReiheScreenState extends State<LustReiheScreen> {
  static const _keyFolge = 'reihe_folge';
  static const _keyVariante = 'reihe_variante';
  static const _keyPerspektive = 'reihe_perspektive';

  ReiheDaten? _daten;
  bool _geladen = false;
  String? _folgeId;
  String _variante = 'soft';
  String? _perspektive;

  // läuft gerade

  String get _paket => Pakete.name(Pakete.reihe);
  bool get _paketDa => Pakete.version(_paket) > 0;
  bool _neueVersion = false;
  bool get _spicy => StorageService.spicyMode();

  /// Folgen, von denen es in der gewählten Betriebsart etwas zu hören gibt (Dreier-Folgen z. B. nur als Sehr spicy).
  List<ReiheFolge> get _folgen => [
        for (final f in _daten?.folgen ?? const <ReiheFolge>[])
          if (f.varianten(spicyErlaubt: _spicy).isNotEmpty) f
      ];

  ReiheFolge? get _folge {
    final liste = _folgen;
    if (liste.isEmpty) return null;
    return liste.where((f) => f.id == _folgeId).firstOrNull ?? liste.first;
  }

  @override
  void initState() {
    super.initState();
    StorageService.spicyAenderung.addListener(_modusGeaendert);
    _laden();
  }

  /// Endet der Spicy-Modus, während die Reihe offen ist (z. B. erneute Abfrage nach langer Pause im Hintergrund),
  /// schließt sich die Seite, statt Folgen zu zeigen, die nicht mehr spielen.
  void _modusGeaendert() {
    if (!mounted || StorageService.spicyMode()) return;
    final route = ModalRoute.of(context);
    if (route != null) Navigator.of(context).removeRoute(route);
  }

  @override
  void dispose() {
    StorageService.spicyAenderung.removeListener(_modusGeaendert);
    super.dispose();
  }

  Future<void> _laden() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = await ReiheDaten.laden();
    if (!mounted) return;
    setState(() {
      _daten = daten;
      _geladen = true;
      _folgeId = prefs.getString(_keyFolge);
      _variante = prefs.getString(_keyVariante) ?? 'soft';
      _perspektive = prefs.getString(_keyPerspektive);
    });
    // Wer die Aufnahmen schon hat, bekommt die Bilder beim Öffnen nach, ohne dass etwas sichtbar wartet.
    if (_paketDa && Pakete.version(Pakete.reiheBilder) == 0)
      unawaited(_bilderLaden());
    unawaited(_aktualisierungPruefen());
  }

  /// Gibt es im Verzeichnis eine neuere Fassung des Reihen-Pakets (neue Folgen), zeigt die Karte „Aktualisieren“.
  /// Neuere Bilder holt die App still nach. Offline oder ohne Verzeichnis bleibt alles, wie es ist.
  Future<void> _aktualisierungPruefen() async {
    if (!_paketDa) return;
    final verzeichnis = await PaketVerzeichnis.laden();
    if (verzeichnis == null || !mounted) return;
    final neu = verzeichnis.paket(_paket);
    final bilder = verzeichnis.paket(Pakete.reiheBilder);
    // Führt das Verzeichnis keine Szenenbilder mehr (die alten Ölbilder wurden zurückgezogen), räumt die App sie auf.
    if (bilder == null && Pakete.version(Pakete.reiheBilder) > 0)
      await Pakete.loeschen(Pakete.reiheBilder);
    if (!mounted) return;
    setState(() =>
        _neueVersion = neu != null && neu.version > Pakete.version(_paket));
    if (bilder != null && bilder.version > Pakete.version(Pakete.reiheBilder)) {
      try {
        await Pakete.laden(Pakete.reiheBilder, verzeichnis: verzeichnis);
      } catch (_) {}
    }
  }

  Future<void> _paketLaden() async {
    try {
      await Pakete.laden(_paket);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.reiheLadenFehler)));
    }
    await _bilderLaden();
    _neueVersion = false;
    await _laden();
  }

  /// Die Szenenbilder sind ein eigenes, sprachunabhängiges Paket. Ohne sie läuft der Player wie bisher; ein Fehler
  /// beim Laden bleibt deshalb still.
  Future<void> _bilderLaden() async {
    if (Pakete.version(Pakete.reiheBilder) > 0) return;
    try {
      await Pakete.laden(Pakete.reiheBilder);
    } catch (_) {}
  }

  /// Die gewählte Fassung; fällt auf die erste der Variante zurück, wenn die Perspektive dort fehlt.
  ReiheFassung? _gewaehlt(ReiheFolge folge) =>
      folge.gewaehlt(_variante, _perspektive, spicyErlaubt: _spicy);
  Future<void> _starten() async {
    final folge = _folge;
    final fassung = folge == null ? null : _gewaehlt(folge);
    if (folge == null || fassung == null) return;
    final darf = await frageVorLautsprecher(context);
    if (!darf || !mounted) return;
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFolge, folge.id);
    await prefs.setString(_keyVariante, fassung.variante);
    await prefs.setString(_keyPerspektive, fassung.perspektive);
    if (!mounted) return;
    final plan = WiedergabePlaene.reihe(_daten!, folge, fassung);
    await hoerplanOeffnen(
        context, () => WiedergabeDienst.instanz.starten(plan));
  }

  /// Anzeigename der Intensität; Sehr spicy erscheint, sobald das Paket Fassungen dafür enthält.
  String _varianteName(String v) => switch (v) {
        'spicy' => t.reiheSpicy,
        'sehrspicy' => t.reiheSehrSpicy,
        _ => t.reiheSoft,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.papier,
        appBar: AppBar(title: Text(t.reiheTitel)),
        body: SafeArea(
            child: (_geladen ? true : null) == null
                ? const Center(child: CircularProgressIndicator())
                : _einrichtung()));
  }

  String _perspektiveName(ReiheFassung f) =>
      f.name ??
      switch (f.perspektive) {
        'frau' => t.reihePerspektiveFrau,
        'mann' => t.reihePerspektiveMann,
        final p => p,
      };

  Widget _einrichtung() {
    final folge = _folge;
    final fassung = folge == null ? null : _gewaehlt(folge);
    final partner = folge == null || fassung == null || folge.solo
        ? <ReiheFassung>[]
        : folge.partnerVon(fassung);
    final perspektiven = folge == null || fassung == null
        ? <ReiheFassung>[]
        : folge.fassungenVon(fassung.variante);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(t.reiheEinleitung,
            style: TextStyle(
                fontSize: 14, color: AppTheme.tinteLeise, height: 1.5)),
        const SizedBox(height: 14),
        if (!_paketDa || _daten == null || _neueVersion) ...[
          _paketKarte(),
          const SizedBox(height: 18)
        ],
        if (_daten != null && folge == null)
          Text(t.reiheLeer, style: TextStyle(color: AppTheme.tinteStumm)),
        if (folge != null && fassung != null) ...[
          AufnahmeStatus(pfade: [
            for (final segment in fassung.segmente)
              ReiheDaten.audioPfad(folge, fassung, segment)
          ], paketNamen: [
            _paket
          ]),
          _titel(t.reiheFolgen),
          for (final f in _folgen) _folgeKachel(f, f.id == folge.id),
          const SizedBox(height: 16),
          if (folge.varianten(spicyErlaubt: _spicy).length > 1) ...[
            _titel(t.reiheVariante),
            Wrap(spacing: 8, children: [
              for (final v in folge.varianten(spicyErlaubt: _spicy))
                _chip(_varianteName(v), fassung.variante == v,
                    () => setState(() => _variante = v)),
            ]),
            const SizedBox(height: 16),
          ],
          if (perspektiven.length > 1) ...[
            _titel(t.reihePerspektive),
            Wrap(spacing: 8, children: [
              for (final p in perspektiven)
                _chip(_perspektiveName(p), fassung.perspektive == p.perspektive,
                    () => setState(() => _perspektive = p.perspektive)),
            ]),
            const SizedBox(height: 12),
          ],
          if (partner.isNotEmpty)
            Text(
                folge.typ == 'trio'
                    ? t.reihePartnerHinweisDrei(
                        partner.map(_perspektiveName).join(', '))
                    : t.reihePartnerHinweis(
                        partner.map(_perspektiveName).join(', ')),
                style: TextStyle(
                    fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5)),
          const SizedBox(height: 8),
          Text(
            '${t.reiheDauer(_daten!.gesamt(folge, fassung).inMinutes.clamp(1, 999))} · ${t.reiheOffline}',
            style: TextStyle(fontSize: 12.5, color: AppTheme.tinteStumm),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _starten,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(t.reiheStart,
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.akzent,
                foregroundColor: AppTheme.aufAkzent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(VpRadius.karte)),
              ),
            ),
          ),
          FutureBuilder<bool>(
              future: PrivacyService.isDiscreetIcon(),
              builder: (context, diskret) => diskret.data == false &&
                      ReiheGalerieScreen.hatBilder(folge, fassung.perspektive,
                          spicyErlaubt: _spicy)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton.icon(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ReiheGalerieScreen(
                                      folge: folge,
                                      variante: fassung.variante,
                                      perspektive: fassung.perspektive))),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(t.reiheBilderAnsehen)))
                  : const SizedBox.shrink()),
          if (Pakete.datei(ReiheDaten.audioPfad(
                  folge, fassung, fassung.segmente.first)) ==
              null) ...[
            const SizedBox(height: 10),
            Text(t.reiheKeineAufnahme,
                style: TextStyle(
                    fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5)),
          ],
        ],
        const SizedBox(height: 16),
        Text(t.reiheHinweise,
            style: TextStyle(
                fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.5)),
      ],
    );
  }

  Widget _paketKarte() => ValueListenableBuilder<Map<String, double>>(
        valueListenable: Pakete.fortschritt,
        builder: (context, f, _) {
          final laeuft = f[_paket];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.papierErhoben,
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border:
                  Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.5)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_paketDa ? t.reihePaketNeu : t.reihePaketFehlt,
                      style: TextStyle(
                          fontSize: 13.5, color: AppTheme.tinte, height: 1.5)),
                  const SizedBox(height: 10),
                  if (laeuft != null)
                    LinearProgressIndicator(
                        value: laeuft,
                        color: AppTheme.akzentTief,
                        backgroundColor: AppTheme.papierVertieft)
                  else
                    OutlinedButton(
                      onPressed: _paketLaden,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.akzentTief,
                          side: BorderSide(color: AppTheme.akzentTief)),
                      child: Text(_paketDa
                          ? t.audioPaketAktualisieren
                          : t.reihePaketLaden),
                    ),
                ]),
          );
        },
      );

  Widget _folgeKachel(ReiheFolge f, bool aktiv) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(VpRadius.karte),
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _folgeId = f.id);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: aktiv
                  ? AppTheme.akzentTief.withValues(alpha: 0.14)
                  : AppTheme.papierErhoben,
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border: Border.all(
                  color: aktiv ? AppTheme.akzentTief : AppTheme.linie),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.titel,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.tinte)),
              if (f.beschreibung.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(f.beschreibung,
                    style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm)),
              ],
            ]),
          ),
        ),
      );

  Widget _titel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.tinte)),
      );

  Widget _chip(String label, bool aktiv, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: aktiv,
        onSelected: (_) {
          HapticFeedback.selectionClick();
          onTap();
        },
        selectedColor: AppTheme.akzentTief.withValues(alpha: 0.22),
        backgroundColor: AppTheme.papierErhoben,
        side: BorderSide(color: aktiv ? AppTheme.akzentTief : AppTheme.linie),
        labelStyle: TextStyle(
            color: aktiv ? AppTheme.tinte : AppTheme.tinteLeise,
            fontWeight: FontWeight.w600),
        showCheckmark: false,
      );
}
