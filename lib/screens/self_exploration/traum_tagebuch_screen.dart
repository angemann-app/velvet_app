import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/t.dart';
import '../../models/traum_eintrag.dart';
import '../../models/traum_rueckblick.dart';
import '../../services/storage_service.dart';
import '../../services/naechtliches_wecken.dart';
import '../../theme/app_theme.dart';
import 'realitaetscheck_screen.dart';
import 'wecken_screen.dart';

/// Traumtagebuch (docs/konzepte/traum-reise.md, „Traumtagebuch“): morgens kurz festhalten, woran man sich
/// erinnert, mit Markierungen. Ruhig und dunkel; „Nichts erinnert“ zählt auch.
class TraumTagebuchScreen extends StatefulWidget {
  /// Öffnet gleich das Eingabefeld (Karte am Morgen).
  final bool neuOeffnen;

  const TraumTagebuchScreen({super.key, this.neuOeffnen = false});

  @override
  State<TraumTagebuchScreen> createState() => _TraumTagebuchScreenState();
}

/// Name des Abends für die Anzeige, z. B. „Traum-Abend · Warmes Wasser“.
String traumAbendName(String? abend) {
  if (abend == null) return '';
  final teile = abend.split(':');
  if (teile.length != 2) return '';
  if (teile[0] == 'lust') return '${t.lustTitel} · ${t.lustFolgeN(int.tryParse(teile[1]) ?? 0)}';
  final bild = switch (teile[1]) {
    'warmes_wasser' => t.traumBildWarmesWasser,
    'ort_fuer_mich' => t.traumBildOrtFuerMich,
    'koerper_im_licht' => t.traumBildKoerperImLicht,
    'begegnung' => t.traumBildBegegnung,
    'klarheit' => t.traumBildKlarheit,
    _ => '',
  };
  return bild.isEmpty ? t.traumTitel : '${t.traumTitel} · $bild';
}

String traumMarkeName(String marke) => switch (marke) {
      'erinnert' => t.tagebuchMarkeErinnert,
      'luzide' => t.tagebuchMarkeLuzide,
      'sinnlich' => t.tagebuchMarkeSinnlich,
      'hoehepunkt' => t.tagebuchMarkeHoehepunkt,
      'unangenehm' => t.tagebuchMarkeUnangenehm,
      'schlecht_geschlafen' => t.tagebuchMarkeSchlechtGeschlafen,
      _ => t.tagebuchNichtsErinnert,
    };

class _TraumTagebuchScreenState extends State<TraumTagebuchScreen> {
  List<TraumEintrag> _eintraege = [];

  @override
  void initState() {
    super.initState();
    _eintraege = StorageService.getTraumEintraege();
    if (widget.neuOeffnen) WidgetsBinding.instance.addPostFrameCallback((_) => _bearbeiten(null));
  }

  void _neuLaden() => setState(() => _eintraege = StorageService.getTraumEintraege());

  Future<void> _nichtsErinnert() async {
    HapticFeedback.lightImpact();
    await StorageService.saveTraumEintrag(TraumEintrag(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      zeit: DateTime.now(),
      marken: const {TraumEintrag.nichts},
      abend: StorageService.letzterAbend(),
    ));
    _neuLaden();
    _pruefeWeckenBegleitung();
  }

  Future<void> _bearbeiten(TraumEintrag? eintrag) async {
    final geaendert = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _Editor(eintrag: eintrag),
    );
    if (geaendert == true) {
      _neuLaden();
      _pruefeWeckenBegleitung();
    }
  }

  void _pruefeWeckenBegleitung() {
    if (!mounted || !NaechtlichesWecken.istWeckenAktiv()) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const WeckenScreen()))
        .then((_) => _neuLaden());
  }

  String _datum(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}. ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(t.tagebuchTitel),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondary),
            color: AppTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'realitaetscheck') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RealitaetscheckScreen()),
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'realitaetscheck',
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 18, color: AppTheme.textSecondary),
                    const SizedBox(width: 10),
                    Text(t.realitaetTitel, style: const TextStyle(color: AppTheme.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            Text(t.tagebuchTipp, style: TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.5)),
            if (NaechtlichesWecken.istWeckenAktiv()) ...[
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pruefeWeckenBegleitung,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.rose.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.nights_stay_rounded, color: AppTheme.rose, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.weckenTagebuchKarteTitel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t.weckenTagebuchKarteText,
                              style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_eintraege.isNotEmpty) ...[
              _WochenrueckblickKarte(eintraege: _eintraege),
              const SizedBox(height: 16),
            ],
            if (TraumEintrag.pauseRaten(_eintraege)) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.rose.withValues(alpha: 0.5)),
                ),
                child: Text(t.tagebuchPause, style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.5)),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _bearbeiten(null),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(t.tagebuchWoranErinnerst, style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.rose,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _nichtsErinnert,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  side: BorderSide(color: AppTheme.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(t.tagebuchNichtsErinnert),
              ),
            ),
            const SizedBox(height: 22),
            for (final e in _eintraege)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _bearbeiten(e),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        [_datum(e.zeit), if (traumAbendName(e.abend).isNotEmpty) traumAbendName(e.abend)].join(' · '),
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      if (e.text.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(e.text,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.4)),
                      ],
                      if (e.marken.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          for (final m in e.marken)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(traumMarkeName(m),
                                  style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary)),
                            ),
                        ]),
                      ],
                    ]),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(t.tagebuchPrivat, style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _Editor extends StatefulWidget {
  final TraumEintrag? eintrag;

  const _Editor({this.eintrag});

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  late final TextEditingController _text = TextEditingController(text: widget.eintrag?.text ?? '');
  late Set<String> _marken = {...?widget.eintrag?.marken}..remove(TraumEintrag.nichts);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _speichern() async {
    final alt = widget.eintrag;
    final marken = {..._marken};
    if (_text.text.trim().isNotEmpty) marken.add('erinnert');
    final eintrag = alt?.mit(text: _text.text.trim(), marken: marken) ??
        TraumEintrag(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          zeit: DateTime.now(),
          text: _text.text.trim(),
          marken: marken,
          abend: StorageService.letzterAbend(),
        );
    await StorageService.saveTraumEintrag(eintrag);
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _loeschen() async {
    await StorageService.deleteTraumEintrag(widget.eintrag!.id);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(t.tagebuchWoranErinnerst,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            autofocus: widget.eintrag == null,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: t.tagebuchHinweisText,
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              filled: true,
              fillColor: AppTheme.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 6, children: [
            for (final m in TraumEintrag.markierungen)
              FilterChip(
                label: Text(traumMarkeName(m)),
                selected: _marken.contains(m),
                onSelected: (an) => setState(() => _marken = an ? {..._marken, m} : ({..._marken}..remove(m))),
                selectedColor: AppTheme.rose.withValues(alpha: 0.22),
                backgroundColor: AppTheme.background,
                side: BorderSide(color: _marken.contains(m) ? AppTheme.rose : AppTheme.border),
                labelStyle: TextStyle(color: _marken.contains(m) ? AppTheme.textPrimary : AppTheme.textSecondary),
                showCheckmark: false,
              ),
          ]),
          const SizedBox(height: 18),
          Row(children: [
            if (widget.eintrag != null)
              TextButton(onPressed: _loeschen, child: Text(t.tagebuchLoeschen, style: const TextStyle(color: AppTheme.textMuted))),
            const Spacer(),
            ElevatedButton(
              onPressed: _speichern,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose, foregroundColor: Colors.white),
              child: Text(t.tagebuchSpeichern),
            ),
          ]),
        ]),
      ),
    );
  }
}


class _WochenrueckblickKarte extends StatelessWidget {
  final List<TraumEintrag> eintraege;

  const _WochenrueckblickKarte({required this.eintraege});

  String _formatMarken(Map<String, int> marken) {
    if (marken.isEmpty) return t.rueckblickKeineMarken;
    final teile = <String>[];
    for (final m in TraumEintrag.markierungen) {
      if (marken.containsKey(m)) {
        teile.add('${marken[m]}× ${traumMarkeName(m)}');
      }
    }
    if (marken.containsKey(TraumEintrag.nichts)) {
      teile.add('${marken[TraumEintrag.nichts]}× ${traumMarkeName(TraumEintrag.nichts)}');
    }
    return teile.isEmpty ? t.rueckblickKeineMarken : teile.join(', ');
  }

  String _kurztext(TraumRueckblick r) {
    if (r.eintraegeGesamt == 0) return t.rueckblickKeineEintraege;
    final teile = <String>[];
    if (r.erinnert > 0) {
      teile.add(t.rueckblickErinnertMorgen(r.erinnert));
    } else if (r.nichtsErinnert > 0) {
      teile.add(t.rueckblickNichtsErinnertMorgen(r.nichtsErinnert));
    }
    for (final m in ['luzide', 'sinnlich', 'hoehepunkt']) {
      final anzahl = r.markenZaehlung[m];
      if (anzahl != null && anzahl > 0) {
        final markeText = switch (m) {
          'luzide' => t.rueckblickMarkeLuzide(anzahl),
          'sinnlich' => t.rueckblickMarkeSinnlich(anzahl),
          'hoehepunkt' => t.rueckblickMarkeHoehepunkt(anzahl),
          _ => '${anzahl}× ${traumMarkeName(m)}',
        };
        teile.add(markeText);
        break;
      }
    }
    if (teile.isEmpty) {
      return t.rueckblickEintraegeGesamt(r.eintraegeGesamt);
    }
    return teile.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final r = TraumRueckblick.berechnen(eintraege);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: AppTheme.rose,
          collapsedIconColor: AppTheme.textMuted,
          title: Text(
            t.rueckblickTitel,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          subtitle: Text(
            _kurztext(r),
            style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.3),
          ),
          children: [
            if (r.eintraegeGesamt == 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.rueckblickKeineEintraege,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              )
            else ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  [
                    t.rueckblickEintraegeGesamt(r.eintraegeGesamt),
                    if (r.erinnert > 0) t.rueckblickErinnertMorgen(r.erinnert),
                    if (r.nichtsErinnert > 0) t.rueckblickNichtsErinnertMorgen(r.nichtsErinnert),
                  ].join('. ') + '.',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                ),
              ),
              if (r.markenZaehlung.isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final m in TraumEintrag.markierungen)
                        if (r.markenZaehlung.containsKey(m))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${r.markenZaehlung[m]}× ${traumMarkeName(m)}',
                              style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
              if (r.abendMarken.isNotEmpty) ...[
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.rueckblickNachAbenden,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
                  ),
                ),
                const SizedBox(height: 6),
                for (final entry in r.abendMarken.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '• ${traumAbendName(entry.key)}: ${_formatMarken(entry.value)}',
                        style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35),
                      ),
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
