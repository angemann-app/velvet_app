import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../models/bedien_daten.dart';
import '../models/erste_woche.dart';
import '../screens/couples_channel/erste_woche_screen.dart';
import '../screens/couples_channel/paar_abend_screen.dart';
import '../services/erste_woche_dienst.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../theme/vp_tokens.dart';
import 'design/vp_komponenten.dart';

/// „Eure erste Woche“: sieben freiwillige Schritte als ruhige Karte
/// (docs/konzepte/eine-tonlage.md, Teil 4). Keine Prozente, kein Zähler, keine Serie, keine Erinnerung.
/// „Heute nicht“ klappt die Karte nur bis zum nächsten Tag zusammen und speichert nichts.
class ErsteWocheKarte extends StatefulWidget {
  /// Im Tab „Wir“ bleibt bei ausgeblendeter Karte ein leiser Weg zurück; auf anderen Seiten verschwindet sie ganz.
  final bool imTabWir;

  /// Für Tests: aktuelle Zeit.
  final DateTime Function()? jetzt;

  const ErsteWocheKarte({super.key, this.imTabWir = false, this.jetzt});

  @override
  State<ErsteWocheKarte> createState() => _ErsteWocheKarteState();
}

class _ErsteWocheKarteState extends State<ErsteWocheKarte> {
  /// Tag (JJJJMMTT), an dem „Heute nicht“ gewählt wurde; gilt nur für diesen Start der App.
  static int? _heuteNichtAm;

  DateTime get _jetzt => (widget.jetzt ?? DateTime.now)();
  int get _heute => _jetzt.year * 10000 + _jetzt.month * 100 + _jetzt.day;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: StorageService.bedienAenderung,
      builder: (context, _, __) {
        final stand = ErsteWocheDienst.stand();
        final inhalt = _inhalt(context, stand);
        if (inhalt == null) return const SizedBox.shrink();
        return Padding(padding: const EdgeInsets.only(bottom: VpAbstand.l), child: inhalt);
      },
    );
  }

  Widget? _inhalt(BuildContext context, ErsteWocheStand? stand) {
    final ausgeblendet = stand?.ausgeblendet ?? false;
    if (ausgeblendet) {
      if (!widget.imTabWir) return null;
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => ErsteWocheDienst.ausgeblendet(false),
          child: Text(t.ersteWocheWiederZeigen, style: TextStyle(color: AppTheme.tinteStumm)),
        ),
      );
    }
    final nr = stand == null ? 1 : stand.aktuellerSchritt;
    if (nr == null) return _schluss(context);
    if (_heuteNichtAm == _heute) return _zugeklappt();
    return _karte(context, stand, nr);
  }

  Widget _zugeklappt() {
    return VpKarte(
      padding: const EdgeInsets.symmetric(horizontal: VpAbstand.l, vertical: VpAbstand.m),
      onTap: () => setState(() => _heuteNichtAm = null),
      child: Text(t.ersteWocheZugeklappt,
          style: context.vp.typo.fliesstextKlein.copyWith(color: AppTheme.tinteStumm)),
    );
  }

  Widget _schluss(BuildContext context) {
    return VpKarte(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.ersteWocheGeschafft, style: context.vp.typo.titel),
        const SizedBox(height: VpAbstand.s),
        Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.xs, children: [
          TextButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const PaarAbendScreen())),
            child: Text(t.ersteWocheZumAbend),
          ),
          TextButton(
            onPressed: () => ErsteWocheDienst.ausgeblendet(true),
            child: Text(t.ersteWocheGutSo, style: TextStyle(color: AppTheme.tinteStumm)),
          ),
        ]),
      ]),
    );
  }

  Widget _karte(BuildContext context, ErsteWocheStand? stand, int nr) {
    final schritt = ErsteWoche.schritt(nr);
    final typo = context.vp.typo;
    final pause = ErsteWoche.istLangePause(stand, _jetzt);
    final zeile = pause
        ? t.ersteWocheLangePause(nr)
        : t.ersteWocheSchrittMin(nr, schritt.minuten);
    return VpKarte(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: VpEyebrow(t.ersteWocheEyebrow)),
          SizedBox(
            height: 24,
            width: 32,
            child: PopupMenuButton<String>(
              tooltip: t.ersteWocheMenue,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_horiz_rounded, size: 20, color: AppTheme.tinteStumm),
              onSelected: (v) {
                if (v == 'ueberspringen') {
                  ErsteWocheDienst.markieren(nr, ErsteWocheStand.uebersprungen);
                } else {
                  ErsteWocheDienst.ausgeblendet(true);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'ueberspringen', child: Text(t.ersteWocheUeberspringen)),
                PopupMenuItem(value: 'ausblenden', child: Text(t.ersteWocheAusblenden)),
              ],
            ),
          ),
        ]),
        const SizedBox(height: VpAbstand.s),
        Text(schritt.titel, style: typo.titel),
        const SizedBox(height: VpAbstand.xs),
        Text(zeile, style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm)),
        if (stand == null || stand.beginn == null) ...[
          const SizedBox(height: VpAbstand.s),
          Text(t.ersteWocheEinstieg, style: typo.fliesstextKlein),
        ],
        const SizedBox(height: VpAbstand.m),
        ErsteWochePunkte(stand: stand),
        const SizedBox(height: VpAbstand.m),
        Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.xs, children: [
          FilledButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ErsteWocheScreen(nr: nr))),
            child: Text(t.ersteWocheAnsehen),
          ),
          TextButton(
            onPressed: () => setState(() => _heuteNichtAm = _heute),
            child: Text(t.ersteWocheHeuteNicht, style: TextStyle(color: AppTheme.tinteStumm)),
          ),
        ]),
      ]),
    );
  }
}

/// Sieben gleich ruhige Punkte: offen (Haarlinienkreis), gemacht (gefüllt), übersprungen (kleiner Strich).
class ErsteWochePunkte extends StatelessWidget {
  final ErsteWocheStand? stand;
  const ErsteWochePunkte({super.key, required this.stand});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var n = 1; n <= ErsteWocheStand.anzahl; n++) ...[
        if (n > 1) const SizedBox(width: VpAbstand.m),
        _punkt(n, stand?.schritte[n]),
      ],
    ]);
  }

  Widget _punkt(int n, String? wert) {
    final label = switch (wert) {
      ErsteWocheStand.getan => t.ersteWochePunktGetan(n),
      ErsteWocheStand.uebersprungen => t.ersteWochePunktUebersprungen(n),
      _ => t.ersteWochePunktOffen(n),
    };
    final Widget form = switch (wert) {
      ErsteWocheStand.getan => Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.akzentTief)),
      ErsteWocheStand.uebersprungen => Container(
          width: 8, height: 2, decoration: BoxDecoration(color: AppTheme.linieStark)),
      _ => Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.linieStark, width: VpLinie.haar))),
    };
    return Semantics(
      label: label,
      child: ExcludeSemantics(child: SizedBox(width: 12, height: 12, child: Center(child: form))),
    );
  }
}
