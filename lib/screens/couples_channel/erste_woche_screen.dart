import 'package:flutter/material.dart';

import '../../l10n/t.dart';
import '../../models/bedien_daten.dart';
import '../../models/erste_woche.dart';
import '../../models/content_models.dart';
import '../../services/data_service.dart';
import '../../services/erste_woche_dienst.dart';
import '../../services/nostr_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import '../../widgets/design/vp_komponenten.dart';
import '../courses/lesson_detail_screen.dart';
import '../yes_no_maybe/yes_no_maybe_screen.dart';
import 'paar_abend_screen.dart';

/// Eine Seite zu einem Schritt von „Eure erste Woche“. „Haben wir gemacht“, „Heute nicht“ und
/// „Diesen Schritt überspringen“ sind gleich ruhig; „Heute nicht“ speichert nichts.
class ErsteWocheScreen extends StatelessWidget {
  final int nr;

  /// Nur für Tests ausschaltbar: Auto-Backup nach dem Markieren.
  final bool backup;
  const ErsteWocheScreen({super.key, required this.nr, this.backup = true});

  ErsteWocheSchritt get _schritt => ErsteWoche.schritt(nr);

  void _lektion(BuildContext context, String id) {
    Lesson? lektion;
    Course? kurs;
    for (final c in DataService.getCourses()) {
      for (final l in c.lessons) {
        if (l.id == id) {
          lektion = l;
          kurs = c;
        }
      }
    }
    if (lektion == null || kurs == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.ersteWocheNichtVerfuegbar)));
      return;
    }
    final l = lektion;
    final k = kurs;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonDetailScreen(lesson: l, courseTitle: k.title)));
  }

  void _haupt(BuildContext context) {
    switch (_schritt.ziel) {
      case ErsteWocheZiel.lektion:
        _lektion(context, _schritt.lektion!);
      case ErsteWocheZiel.landkarte:
        // Nur die ruhige Kategorie „Sinnlichkeit & Sinne“; „Alle Bereiche ansehen“ hebt den Filter auf.
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const YesNoMaybeScreen(nurKategorie: ersteWocheKategorie)));
      case ErsteWocheZiel.rueckblick:
        break;
    }
  }

  Future<void> _markieren(BuildContext context, String wert) async {
    final nav = Navigator.of(context);
    await ErsteWocheDienst.markieren(nr, wert, backup: backup);
    nav.pop();
  }

  void _heuteNicht(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(t.ersteWocheHeuteNichtAntwort)));
  }

  /// Freiwillig: Text vorbereiten, bearbeiten lassen, erst nach „Senden“ schicken.
  Future<void> _sagenWo(BuildContext context) async {
    final controller = TextEditingController(text: t.ersteWocheNachricht(nr));
    final messenger = ScaffoldMessenger.of(context);
    final senden = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.ersteWocheNachrichtTitel),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: controller, minLines: 2, maxLines: 5, autofocus: false),
          const SizedBox(height: VpAbstand.s),
          Text(t.ersteWocheNachrichtHinweis, style: ctx.vp.typo.beschriftung),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.ersteWocheAbbrechen)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.ersteWocheSenden)),
        ],
      ),
    );
    final text = controller.text.trim();
    controller.dispose();
    final ok = await ErsteWoche.nachrichtSenden(senden, text, NostrService().sendChatMessage);
    if (ok == false) {
      messenger.showSnackBar(SnackBar(content: Text(t.lessonDetailSendingDidnTWorkPlease)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final typo = context.vp.typo;
    final s = _schritt;
    final hauptText = switch (s.ziel) {
      ErsteWocheZiel.lektion => t.ersteWocheLektionOeffnen,
      ErsteWocheZiel.landkarte => t.ersteWocheLandkarteOeffnen,
      ErsteWocheZiel.rueckblick => null,
    };
    return Scaffold(
      backgroundColor: AppTheme.papier,
      appBar: AppBar(title: Text(t.ersteWocheSchrittNr(nr))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            VpEyebrow(t.ersteWocheSchrittMin(nr, s.minuten)),
            const SizedBox(height: VpAbstand.s),
            Text(s.titel, style: typo.ueberschrift),
            const SizedBox(height: VpAbstand.m),
            Text(s.text, style: typo.fliesstext),
            const SizedBox(height: VpAbstand.l),
            if (s.ziel == ErsteWocheZiel.rueckblick) ...[
              VpKarte(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.ersteWocheFragen, style: typo.titel),
                  const SizedBox(height: VpAbstand.s),
                  Text(t.ersteWocheFrage1, style: typo.fliesstext),
                  const SizedBox(height: VpAbstand.xs),
                  Text(t.ersteWocheFrage2, style: typo.fliesstext),
                ]),
              ),
              const SizedBox(height: VpAbstand.m),
              Text(t.ersteWocheWeiterTitel, style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm)),
              Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.xs, children: [
                TextButton(
                    onPressed: () => _lektion(context, ErsteWoche.menueLektion),
                    child: Text(t.ersteWocheWeiterMenue)),
                TextButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const PaarAbendScreen())),
                    child: Text(t.couplesChannelSharedEvening)),
              ]),
            ] else
              Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.s, children: [
                if (hauptText != null)
                  FilledButton(onPressed: () => _haupt(context), child: Text(hauptText)),
                if (s.alternative != null)
                  TextButton(
                      onPressed: () => _lektion(context, s.alternative!),
                      child: Text(t.ersteWocheAlternative)),
              ]),
            const SizedBox(height: VpAbstand.xl),
            // Alle drei gleich ruhig: keine Antwort ist die richtige.
            Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.s, children: [
              OutlinedButton(
                  onPressed: () => _markieren(context, ErsteWocheStand.getan),
                  child: Text(t.ersteWocheGemacht)),
              OutlinedButton(
                  onPressed: () => _heuteNicht(context), child: Text(t.ersteWocheHeuteNicht)),
              OutlinedButton(
                  onPressed: () => _markieren(context, ErsteWocheStand.uebersprungen),
                  child: Text(t.ersteWocheUeberspringen)),
            ]),
            if (NostrService().isPaired) ...[
              const SizedBox(height: VpAbstand.l),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () => _sagenWo(context),
                    child: Text(t.ersteWocheSagenWo, style: TextStyle(color: AppTheme.tinteStumm))),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
