import 'package:flutter/material.dart';
import '../../widgets/weg_begleiter.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../services/sprache.dart';
import '../../theme/vp_palette.dart';
import '../../widgets/design/vp_komponenten.dart';
import '../../theme/vp_tokens.dart';
import '../../widgets/design/vp_bild_feld.dart';
import '../../models/content_models.dart';
import '../../models/user_profile.dart';
import '../../services/data_service.dart';
import '../../services/storage_service.dart';
import '../../services/testmodus.dart';
import '../../widgets/aufnahmen_karte.dart';
import '../../widgets/gefuehrte_audios.dart';
import '../../theme/app_theme.dart';
import '../../widgets/daily_checkin_card.dart';
import '../../widgets/daily_simmering_card.dart';
import '../onboarding/onboarding_screen.dart';
import 'lesson_detail_screen.dart';
import '../../l10n/t.dart';

/// Zwei Gesichter derselben Daten: **Heute** (Kopf, nächster Schritt, Check-in/Funke, geführte Audios) und **Lernen**
/// (Filter und Kurse nach Schwerpunkten). Siehe docs/konzepte/heute-und-produktschliff.md.
class CoursesScreen extends StatefulWidget {
  final void Function(int tabIndex, {String? subTab}) onNavigateToTool;

  /// true: Tab „Lernen“ mit Filter und Kursliste; false: Tab „Heute“.
  final bool lernen;

  /// Heute: führt zum Tab „Lernen“.
  final VoidCallback? onZuLernen;

  /// Meldet, wenn der Tab gewechselt wurde, damit erledigte Lektionen aus dem anderen Tab nachgeladen werden.
  final Listenable? aktualisieren;

  const CoursesScreen({
    super.key,
    required this.onNavigateToTool,
    this.lernen = false,
    this.onZuLernen,
    this.aktualisieren,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  Set<String> _completedLessonIds = {};
  bool _isLoading = true;
  String _selectedCategory = StorageService.getKursFilter() ?? 'all';
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Spicy-Kurse erscheinen und verschwinden sofort, wenn der Modus umgeschaltet wird.
    StorageService.spicyAenderung.addListener(_loadData);
    widget.aktualisieren?.addListener(_loadData);
  }

  @override
  void dispose() {
    StorageService.spicyAenderung.removeListener(_loadData);
    widget.aktualisieren?.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = await DataService.loadDatabase();
    final completed = StorageService.getCompletedLessons();
    final profile = StorageService.getUserProfile();

    if (mounted) {
      setState(() {
        _courses = db.courses;
        _completedLessonIds = completed;
        _profile = profile;
        _isLoading = false;
        // Keine Vorbelegung des Filters nach Geschlecht: Standard ist „Alle Kurse“ (Konzept eine-tonlage.md).
      });
    }
  }

  void _openProfileEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(isEditing: true),
      ),
    );
    // Immer neu laden: auch ohne Speichern kann sich z. B. der Spicy-Modus geändert haben.
    _loadData();
  }

  void _onLessonTap(Course course, Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(
          lesson: lesson,
          courseTitle: course.title,
          onNavigateToTool: widget.onNavigateToTool,
        ),
      ),
    );
    // Refresh completed state on return
    setState(() {
      _completedLessonIds = StorageService.getCompletedLessons();
    });
  }

  IconData _getIconForCourse(String iconName) {
    switch (iconName) {
      case 'psychology':
        return Icons.psychology_rounded;
      case 'visibility_off':
        return Icons.visibility_off_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'forum':
        return Icons.forum_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'touch_app':
        return Icons.touch_app_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'healing':
        return Icons.healing_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.akzentTief),
      );
    }

    // Calculate total stats
    int completedCount = 0;
    for (final c in _courses) {
      for (final l in c.lessons) {
        if (_completedLessonIds.contains(l.id)) {
          completedCount++;
        }
      }
    }

    // Filter courses based on selected category.
    // "Für Sie"/"Für Ihn" zeigen auch Paar-Kurse, außer bei Singles.
    final showCouples = _profile?.relationshipStatus != 'single';
    final filteredCourses = _courses.where((c) {
      if (_selectedCategory == 'all') return true;
      if (_selectedCategory == 'women') {
        return c.isForWomen || c.category == 'all' || (showCouples && c.isForCouples);
      }
      if (_selectedCategory == 'men') {
        return c.isForMen || c.category == 'all' || (showCouples && c.isForCouples);
      }
      if (_selectedCategory == 'couples') return c.isForCouples || c.category == 'all';
      return true;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.akzentTief,
      backgroundColor: AppTheme.papierErhoben,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: Testmodus.aktiv,
            builder: (context, an, _) => an
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.akzentTief.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
                      ),
                      child: Text(t.testmodusSchild,
                          style: TextStyle(color: AppTheme.akzentTief, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          if (!widget.lernen) ...[
            // Kopf: Begrüßung ohne Prozentbalken und Serie (docs/konzepte/heute-und-produktschliff.md)
            _buildKopf(),
            WegFortsetzen(oeffnen: _onLessonTap),

            const SizedBox(height: VpAbstand.xl),

            // Die Einladung: ein großes Bildfeld und ein klarer nächster Schritt. Alles Weitere ist leiser.
            _buildNaechsterSchritt(completedCount),

            const SizedBox(height: VpAbstand.xxl),

            // Für heute: Check-in und Funke als zwei leise Reiter.
            VpAbschnitt(titel: t.heuteFuerHeute),
            const SizedBox(height: VpAbstand.m),
            const _HeuteReiter(),

            const SizedBox(height: VpAbstand.xl),

            const AufnahmenHinweis(),

            // Geführte Audios nach Anlass: Empfehlung für heute, Gruppen, „Alle anzeigen“.
            AudioGruppenBereich(mitPaar: showCouples),

            const SizedBox(height: VpAbstand.l),

            _buildKurseKarte(filteredCourses.length),
          ] else ...[
            // Filter nach Zielgruppe
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', t.coursesAllCourses, Icons.apps_rounded),
                  const SizedBox(width: VpAbstand.s),
                  _buildCategoryChip('women', t.coursesForHer, Icons.spa_outlined),
                  const SizedBox(width: VpAbstand.s),
                  _buildCategoryChip('men', t.coursesForHim, Icons.male_rounded),
                  const SizedBox(width: VpAbstand.s),
                  _buildCategoryChip('couples', t.coursesForCouples, Icons.favorite_border_rounded),
                ],
              ),
            ),

            const SizedBox(height: VpAbstand.xl),

            // Kurse nach Schwerpunkten (docs/konzepte/startseite.md): Magazin-Inhaltsverzeichnis
            VpAbschnitt(
              eyebrow: t.startSchwerpunkte,
              titel: t.coursesCourseCount(filteredCourses.length),
              massLinie: true,
            ),

            for (final s in Course.schwerpunkte)
              if (filteredCourses.any((c) => c.schwerpunkt == s))
                _buildSchwerpunkt(s, [for (final c in filteredCourses) if (c.schwerpunkt == s) c]),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Heute: leiser Verweis in den Tab „Lernen“ (eine Zeile, kein Rahmen).
  Widget _buildKurseKarte(int anzahl) {
    return VpListenzeile(
      titel: t.heuteAlleKurse,
      meta: t.coursesCourseCount(anzahl),
      onTap: widget.onZuLernen,
      trailing: Icon(Icons.arrow_forward_rounded, color: AppTheme.akzentTief, size: 20),
    );
  }

  Widget _buildCategoryChip(String cat, String label, IconData icon) {
    return VpChip(
      label: label,
      icon: icon,
      gewaehlt: _selectedCategory == cat,
      onTap: () {
        setState(() => _selectedCategory = cat);
        StorageService.setKursFilter(cat);
      },
    );
  }

  /// Datum für die Kopfzeile („Sonntag, 1. November“), in der Sprache der App. Ohne Datumsdaten leer.
  String _datum() {
    try {
      return DateFormat.MMMMEEEEd(Sprache.code).format(DateTime.now());
    } catch (_) {
      return '';
    }
  }

  Widget _buildKopf() {
    final typo = context.vp.typo;
    final spicy = AppTheme.paletteId == VpPaletteId.spicy;
    final datum = _datum();
    // Spicy: die Begrüßung in kursiver Serif, sonst ruhige Regular.
    final anzeige = spicy ? typo.anzeige.copyWith(fontStyle: FontStyle.italic) : typo.anzeige;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (datum.isNotEmpty) ...[VpEyebrow(datum), const SizedBox(height: VpAbstand.s)],
              Text(_profile != null ? t.coursesHelloProfilename(_profile!.name) : t.coursesWelcome, style: anzeige),
              const SizedBox(height: VpAbstand.s),
              Text(
                // Beim neutralen Fokus 'open' (Erstmal umsehen) steht keine Fokus-Zeile, sondern der freundliche Text.
                _profile != null && _profile!.primaryGoal != 'open'
                    ? t.coursesYourFocusGoallabel(_profile!.goalLabel)
                    : t.coursesUnderstandTheBiologyQuietThe,
                style: typo.fliesstextKlein,
              ),
              const SizedBox(height: VpAbstand.s),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.lock_outline_rounded, size: 13, color: AppTheme.tinteStumm),
                const SizedBox(width: 5),
                Text(t.heuteBleibtLokal, style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm)),
              ]),
            ],
          ),
        ),
        IconButton(
          onPressed: _openProfileEditor,
          tooltip: t.coursesProfileSettings,
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.account_circle_outlined, color: AppTheme.akzentTief, size: 30),
        ),
      ],
    );
  }

  /// Die nächste offene Lektion: erst im Schwerpunkt zum Fokus im Profil, sonst die erste offene überhaupt.
  (Course, Lesson)? _naechsteLektion() {
    final fokus = _schwerpunktZumFokus[_profile?.primaryGoal];
    final reihenfolge = [
      if (fokus != null) ..._courses.where((c) => c.schwerpunkt == fokus),
      ..._courses,
    ];
    for (final c in reihenfolge) {
      for (final l in c.lessons) {
        if (!_completedLessonIds.contains(l.id)) return (c, l);
      }
    }
    return null;
  }

  Widget _buildNaechsterSchritt(int erledigt) {
    final n = _naechsteLektion();
    final typo = context.vp.typo;
    final spicy = AppTheme.paletteId == VpPaletteId.spicy;
    if (n == null) {
      return VpKarte(
        rahmen: VpRahmen.gerahmt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          VpEyebrow(t.heuteNaechsterSchritt),
          const SizedBox(height: VpAbstand.s),
          Text(t.heuteAllesErledigt, style: typo.fliesstext),
        ]),
      );
    }
    final eyebrow = VpEyebrow(t.heuteNaechsterSchritt, farbe: spicy ? AppTheme.aufBild.withValues(alpha: 0.8) : null);
    final titel = Text(
      n.$2.title,
      style: spicy ? typo.ueberschrift.copyWith(fontSize: 26, fontStyle: FontStyle.italic, color: AppTheme.aufBild) : typo.ueberschrift,
    );
    final bildHoehe = spicy ? 300.0 : 190.0;
    return VpKarte(
      rahmen: VpRahmen.gerahmt,
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Das Bildfeld bestimmt die Seite: in Spicy höher, mit dem Titel über einer ruhigen Abdunklung am Bildrand
        // (die Abdunklung ist funktional, sie trägt die Lesbarkeit des Titels).
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(VpRadius.karte)),
          child: SizedBox(
            height: bildHoehe,
            child: Stack(fit: StackFit.expand, children: [
              if (n.$1.image case final bild?)
                VpBildFeld.pfad(bild, format: VpBildFormat.kopf)
              else
                const VpBildFeld('bereich.heute.einladung'),
              if (spicy) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppTheme.tiefe.withValues(alpha: 0.92)],
                      stops: const [0.35, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: VpAbstand.l,
                  right: VpAbstand.l,
                  bottom: VpAbstand.l,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [eyebrow, const SizedBox(height: VpAbstand.xs), titel]),
                ),
              ],
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(VpAbstand.l),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!spicy) ...[eyebrow, const SizedBox(height: VpAbstand.xs), titel, const SizedBox(height: VpAbstand.xs)],
            Text(t.heuteKursUndDauer(n.$1.title, n.$2.durationMin), style: typo.fliesstextKlein),
            const SizedBox(height: VpAbstand.l),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onLessonTap(n.$1, n.$2),
                child: Text(erledigt > 0 ? t.heuteWeitermachen : t.heuteStarten),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
  /// Welche Schwerpunkte aufgeklappt sind; anfangs der zum Fokus im Profil passende, oder der erste mit
  /// offenen Lektionen, wenn der schon fertig ist.
  Set<String>? _offen;

  static const _schwerpunktZumFokus = {
    'performance_anxiety': 'grundlagen',
    'pelvic_somatics': 'annehmen',
    'body_pleasure': 'entdecken',
    'couple_intimacy': 'paar',
  };

  bool _fertig(String schwerpunkt) => _courses
      .where((c) => c.schwerpunkt == schwerpunkt)
      .every((c) => c.lessons.every((l) => _completedLessonIds.contains(l.id)));

  Set<String> _startOffen() {
    final fokus = _schwerpunktZumFokus[_profile?.primaryGoal];
    if (fokus != null && !_fertig(fokus)) return {fokus};
    final offen = Course.schwerpunkte.where((s) => !_fertig(s));
    return offen.isEmpty ? {} : {offen.first};
  }

  String _schwerpunktName(String s) => switch (s) {
        'grundlagen' => t.schwerpunktGrundlagen,
        'annehmen' => t.schwerpunktAnnehmen,
        'entdecken' => t.schwerpunktEntdecken,
        'paar' => t.schwerpunktPaar,
        'beruehrung' => t.schwerpunktBeruehrung,
        _ => t.schwerpunktFantasie,
      };

  String _schwerpunktText(String s) => switch (s) {
        'grundlagen' => t.schwerpunktGrundlagenText,
        'annehmen' => t.schwerpunktAnnehmenText,
        'entdecken' => t.schwerpunktEntdeckenText,
        'paar' => t.schwerpunktPaarText,
        'beruehrung' => t.schwerpunktBeruehrungText,
        _ => t.schwerpunktFantasieText,
      };

  Widget _buildSchwerpunkt(String s, List<Course> kurse) {
    final offen = (_offen ??= _startOffen()).contains(s);
    final lektionen = [for (final c in kurse) ...c.lessons];
    final erledigt = lektionen.where((l) => _completedLessonIds.contains(l.id)).length;
    final fortschritt = lektionen.isEmpty ? 0.0 : erledigt / lektionen.length;
    final nr = (Course.schwerpunkte.indexOf(s) + 1).toString().padLeft(2, '0');
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Semantics(
        button: true,
        expanded: offen,
        child: InkWell(
          onTap: () => setState(() => _offen = offen ? ({..._offen!}..remove(s)) : {..._offen!, s}),
          child: Padding(
            padding: const EdgeInsets.only(top: VpAbstand.l),
            child: VpAbschnitt(
              eyebrow: '$nr · ${t.startLektionenVon(erledigt, lektionen.length)}',
              titel: _schwerpunktName(s),
              text: _schwerpunktText(s),
              linie: false,
              trailing: Padding(
                padding: const EdgeInsets.only(left: VpAbstand.m),
                child: Icon(offen ? Icons.remove_rounded : Icons.add_rounded, color: AppTheme.tinteStumm, size: 22),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: VpAbstand.m),
      VpFortschritt(wert: fortschritt, schritte: lektionen.length),
      if (offen) Column(children: [for (final c in kurse) _buildCourseCard(c)]),
      const SizedBox(height: VpAbstand.xl),
    ]);
  }

  /// Welche Kurse aufgeklappt sind; anfangs der mit der nächsten offenen Lektion.
  Set<String>? _kurseOffen;

  /// Kleines Titelbild in der Kurszeile (Bleistift-Skizze, im Spicy-Modus die Spicy-Fassung, sonst der Platzhalter).
  /// Ein Haken in der Ecke zeigt einen abgeschlossenen Kurs.
  Widget _kursBild(Course course, bool fertig) {
    final bild = course.image;
    return Stack(fit: StackFit.expand, children: [
      if (bild != null)
        VpBildFeld.pfad(bild, format: VpBildFormat.marke)
      else
        ColoredBox(
          color: AppTheme.papierVertieft,
          child: Icon(_getIconForCourse(course.icon), color: AppTheme.tinteLeise, size: 24),
        ),
      if (fertig)
        Positioned(
          right: 3,
          bottom: 3,
          child: Container(
            decoration: BoxDecoration(color: AppTheme.papierErhoben, shape: BoxShape.circle),
            child: Icon(Icons.check_circle_rounded, color: AppTheme.akzentTief, size: 18),
          ),
        ),
    ]);
  }

  /// Eine Kurszeile: Nummer, Titel, Teaser, Fortschrittslinie, Bild. Antippen klappt die Lektionen auf (Kursdetail).
  Widget _buildCourseCard(Course course) {
    final fertigAnzahl = course.lessons.where((l) => _completedLessonIds.contains(l.id)).length;
    final gesamt = course.lessons.length;
    final isAllDone = gesamt > 0 && fertigAnzahl == gesamt;
    final naechste = _naechsteLektion();
    final offen = (_kurseOffen ??= {if (naechste != null) naechste.$1.id}).contains(course.id);
    // Titel tragen ihre Nummer („1. Kopf und Körper …“): sie wird zur Serif-Zahl links, der Titel bleibt sauber.
    final m = RegExp(r'^(\d+)\.\s*(.*)$').firstMatch(course.title);
    final nummer = m?.group(1);
    final titel = m?.group(2) ?? course.title;
    final typo = context.vp.typo;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      VpListenzeile(
        nummer: nummer,
        titel: titel,
        teaser: course.subtitle,
        bild: _kursBild(course, isAllDone),
        fortschritt: gesamt > 0 ? fertigAnzahl / gesamt : 0,
        fortschrittSchritte: gesamt,
        fortschrittText: '$fertigAnzahl/$gesamt',
        erledigt: isAllDone,
        offen: offen,
        trennlinie: !offen,
        onTap: () => setState(() => _kurseOffen = offen ? ({..._kurseOffen!}..remove(course.id)) : {..._kurseOffen!, course.id}),
      ),
      if (offen)
        Container(
          margin: const EdgeInsets.only(bottom: VpAbstand.s),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.linie, width: VpLinie.haar))),
          child: Column(children: [
            for (final lesson in course.lessons) _buildLektionsZeile(course, lesson, typo),
          ]),
        ),
    ]);
  }

  Widget _buildLektionsZeile(Course course, Lesson lesson, VpTypo typo) {
    final isDone = _completedLessonIds.contains(lesson.id);
    final praxis = switch (lesson.linkedTool) {
      'none' => null,
      'kegel_timer' => t.coursesPracticePelvicFloor,
      'breath_pacer' => t.coursesPracticeBreath,
      'selbst_reise' => t.coursesPracticeSelfExploration,
      'lust_profil' => t.coursesPracticeDesireProfile,
      _ => t.coursesPracticeCbt,
    };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onLessonTap(course, lesson),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(34, VpAbstand.m, 0, VpAbstand.m),
          child: Row(children: [
            Icon(
              isDone ? Icons.check_circle_outline_rounded : (lesson.isAudioExercise ? Icons.headphones_outlined : Icons.circle_outlined),
              color: isDone ? AppTheme.akzentTief : AppTheme.tinteStumm,
              size: 18,
            ),
            const SizedBox(width: VpAbstand.m),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(lesson.title,
                    style: typo.fliesstext.copyWith(fontWeight: FontWeight.w600, color: isDone ? AppTheme.tinteLeise : AppTheme.tinte)),
                const SizedBox(height: 2),
                Text(
                  [t.coursesDurationminMin(lesson.durationMin), if (praxis != null) praxis].join(' · '),
                  style: typo.beschriftung.copyWith(color: AppTheme.tinteStumm),
                ),
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.tinteStumm, size: 20),
          ]),
        ),
      ),
    );
  }
}

/// Check-in und Funke als zwei leise Reiter, damit „für heute“ nur einen Block belegt. Die Wahl bleibt bis zum Neustart.
class _HeuteReiter extends StatefulWidget {
  const _HeuteReiter();

  @override
  State<_HeuteReiter> createState() => _HeuteReiterState();
}

class _HeuteReiterState extends State<_HeuteReiter> {
  static int _gewaehlt = 0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        VpChip(label: t.heuteReiterCheckin, icon: Icons.speed_rounded, gewaehlt: _gewaehlt == 0, onTap: () => setState(() => _gewaehlt = 0)),
        const SizedBox(width: VpAbstand.s),
        VpChip(label: t.heuteReiterFunke, icon: Icons.bolt_outlined, gewaehlt: _gewaehlt == 1, onTap: () => setState(() => _gewaehlt = 1)),
      ]),
      const SizedBox(height: VpAbstand.m),
      if (_gewaehlt == 0) const DailyCheckInCard() else const DailySimmeringCard(),
    ]);
  }
}
