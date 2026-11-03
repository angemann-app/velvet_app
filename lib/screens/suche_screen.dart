import 'package:flutter/material.dart';
import '../l10n/t.dart';
import '../models/content_models.dart';
import '../services/data_service.dart';
import '../services/inhalt_suche.dart';
import '../services/storage_service.dart';
import '../services/such_index.dart';
import '../theme/vp_tokens.dart';
import 'courses/lesson_detail_screen.dart';
import 'self_exploration/einschlaf_reise_screen.dart';
import 'self_exploration/selbst_reise_screen.dart';
import 'couples_channel/paar_abend_screen.dart';
import 'self_exploration/lust_reihe_screen.dart';
import 'self_exploration/traumpraxis_screen.dart';

class SucheScreen extends StatefulWidget {
  final void Function(int tabIndex, {String? subTab})? onNavigateToTool;
  final String anfang;
  const SucheScreen({super.key, this.onNavigateToTool, this.anfang = ''});
  @override
  State<SucheScreen> createState() => _SucheScreenState();
}

class _SucheScreenState extends State<SucheScreen> {
  late final TextEditingController _frage =
      TextEditingController(text: widget.anfang);
  VelvetDatabase? _daten;
  bool _ladefehler = false;

  @override
  void initState() {
    super.initState();
    _laden();
  }

  Future<void> _laden() async {
    try {
      final daten = await DataService.loadDatabase();
      if (mounted) setState(() => _daten = daten);
    } catch (_) {
      if (mounted) setState(() => _ladefehler = true);
    }
  }

  @override
  void dispose() {
    _frage.dispose();
    super.dispose();
  }

  List<SuchEintrag> get _angebote => [
        SuchEintrag(
            id: 'angebot:selbst', titel: t.lessonDetailGuidedSelfExploration),
        SuchEintrag(id: 'angebot:paar', titel: t.suchePaarAbend),
        SuchEintrag(id: 'angebot:einschlaf', titel: t.einschlafTitel),
        SuchEintrag(id: 'angebot:traum', titel: t.traumTitel),
        SuchEintrag(id: 'angebot:praxis', titel: t.traumpraxisTitel),
        if (StorageService.spicyMode())
          SuchEintrag(id: 'angebot:reihe', titel: t.sucheInnenansichten),
        if (widget.onNavigateToTool != null) ...[
          SuchEintrag(id: 'werkzeug:atem', titel: t.trainingBreathPacer),
          SuchEintrag(id: 'werkzeug:koerper', titel: t.mainNavigationTraining),
          SuchEintrag(
              id: 'werkzeug:gedanken', titel: t.mainNavigationReframing),
        ],
      ];

  void _lektion(Course kurs, Lesson lektion) {
    if (!(_daten?.courses.any((c) =>
            c.id == kurs.id && c.lessons.any((l) => l.id == lektion.id)) ??
        false)) return;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
            lesson: lektion,
            courseTitle: kurs.title,
            onNavigateToTool: widget.onNavigateToTool == null
                ? null
                : (index, {subTab}) {
                    // Die Lektion hat sich bereits geschlossen. Auch die Suche
                    // schließen, damit das gewählte Werkzeug sichtbar wird.
                    if (mounted) Navigator.pop(context);
                    widget.onNavigateToTool!(index, subTab: subTab);
                  })));
  }

  Future<void> _oeffnen(String id) async {
    // Beim Öffnen erneut filtern: Ein Moduswechsel darf alte Treffer nicht öffnen.
    final kurse = _daten?.courses ?? const <Course>[];
    for (final kurs in kurse) {
      for (final lektion in kurs.lessons) {
        if (id == 'lektion:${lektion.id}') {
          _lektion(kurs, lektion);
          return;
        }
      }
      if (id == 'kurs:${kurs.id}') {
        await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) => SafeArea(
                    child: ListView(shrinkWrap: true, children: [
                  Padding(
                      padding: const EdgeInsets.all(VpAbstand.rand),
                      child: Text(kurs.title,
                          style: context.vp.typo.ueberschrift)),
                  for (final lektion in kurs.lessons)
                    ListTile(
                        title: Text(lektion.title),
                        subtitle: Text(lektion.summary,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _lektion(kurs, lektion);
                        }),
                ])));
        return;
      }
    }
    if (id.startsWith('werkzeug:')) {
      Navigator.pop(context);
      widget.onNavigateToTool?.call(id == 'werkzeug:gedanken' ? 2 : 1,
          subTab: id == 'werkzeug:atem' ? 'breath' : 'kegel');
      return;
    }
    final Widget? ziel = switch (id) {
      'angebot:selbst' => const SelbstReiseScreen(),
      'angebot:paar' => const PaarAbendScreen(),
      'angebot:einschlaf' => const EinschlafReiseScreen(),
      'angebot:traum' => const EinschlafReiseScreen(traum: true),
      'angebot:praxis' => const TraumpraxisScreen(),
      'angebot:reihe' when StorageService.spicyMode() =>
        const LustReiheScreen(),
      _ => null,
    };
    if (ziel != null)
      await Navigator.push(context, MaterialPageRoute(builder: (_) => ziel));
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, _, child) {
        final suche =
            InhaltSuche(kurse: _daten?.courses ?? [], angebote: _angebote);
        return Scaffold(
            appBar: AppBar(title: Text(t.sucheTitel)),
            body: SafeArea(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(VpAbstand.rand),
                  child: TextField(
                    controller: _frage,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        labelText: t.sucheFeld,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: IconButton(
                            tooltip: t.sucheLeeren,
                            onPressed: () => _frage.clear(),
                            icon: const Icon(Icons.close_rounded))),
                  )),
              Expanded(
                  child: _daten == null
                      ? Center(
                          child: _ladefehler
                              ? Text(t.sucheFehler)
                              : const CircularProgressIndicator())
                      : ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _frage,
                          builder: (context, wert, _) {
                            final treffer =
                                suche.index.suche(wert.text, grenze: 60);
                            if (wert.text.trim().isEmpty)
                              return _hinweis(t.sucheHinweis);
                            if (treffer.isEmpty) return _hinweis(t.sucheLeer);
                            return ListView.separated(
                                itemCount: treffer.length,
                                separatorBuilder: (_, index) =>
                                    const Divider(height: VpAbstand.xs),
                                itemBuilder: (context, i) {
                                  final e = treffer[i].eintrag;
                                  return ListTile(
                                      title: Text(e.titel,
                                          style: context.vp.typo.titel),
                                      subtitle: Text(
                                          e.beschreibung.isEmpty
                                              ? _art(e.id)
                                              : e.beschreibung,
                                          style: Theme.of(context).textTheme.bodySmall,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      trailing: const Icon(
                                          Icons.chevron_right_rounded),
                                      onTap: () => _oeffnen(e.id));
                                });
                          })),
            ])));
      });

  String _art(String id) => id.startsWith('kurs:')
      ? t.sucheKurs
      : id.startsWith('lektion:')
          ? t.sucheLektion
          : t.sucheAngebot;

  Widget _hinweis(String text) => Center(
      child: Padding(
          padding: const EdgeInsets.all(VpAbstand.rand),
          child: Text(text,
              style: context.vp.typo.fliesstext, textAlign: TextAlign.center)));
}
