import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/content_models.dart';
import '../../models/user_profile.dart';
import '../../services/data_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/daily_checkin_card.dart';
import '../../widgets/daily_simmering_card.dart';
import '../onboarding/onboarding_screen.dart';
import 'lesson_detail_screen.dart';
import '../../l10n/t.dart';

class CoursesScreen extends StatefulWidget {
  final void Function(int tabIndex, {String? subTab}) onNavigateToTool;

  const CoursesScreen({
    super.key,
    required this.onNavigateToTool,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  Set<String> _completedLessonIds = {};
  int _streak = 1;
  bool _isLoading = true;
  String _selectedCategory = 'all';
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = await DataService.loadDatabase();
    final completed = StorageService.getCompletedLessons();
    final streak = StorageService.getStreakCount();
    final profile = StorageService.getUserProfile();

    if (mounted) {
      setState(() {
        _courses = db.courses;
        _completedLessonIds = completed;
        _streak = streak;
        _profile = profile;
        _isLoading = false;

        // Auto-set category based on user profile on initial load
        if (_selectedCategory == 'all' && profile != null) {
          if (profile.isFemale) {
            _selectedCategory = 'women';
          } else if (profile.isMale) {
            _selectedCategory = 'men';
          }
        }
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
      _streak = StorageService.getStreakCount();
    });
  }

  /// "#RRGGBB" aus velvet_content.json (Feld title_color) in eine Farbe umwandeln.
  Color? _parseColor(String? hex) {
    if (hex == null || !RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(hex)) return null;
    return Color(int.parse('FF${hex.substring(1)}', radix: 16));
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
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.sageGreen),
      );
    }

    // Calculate total stats
    int totalLessons = 0;
    int completedCount = 0;
    for (final c in _courses) {
      totalLessons += c.lessons.length;
      for (final l in c.lessons) {
        if (_completedLessonIds.contains(l.id)) {
          completedCount++;
        }
      }
    }
    final double overallProgress = totalLessons > 0 ? (completedCount / totalLessons) : 0.0;

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
      if (_selectedCategory == 'touch') return c.id.contains('touch') || c.id == 'course_self_exploration';
      return true;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.sageGreen,
      backgroundColor: AppTheme.surface,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Welcome & Daily Streak Banner
          _buildHeroHeader(completedCount, totalLessons, overallProgress),

          const SizedBox(height: 18),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('all', t.coursesAllCourses, Icons.apps_rounded),
                const SizedBox(width: 8),
                _buildCategoryChip('touch', t.coursesTouch, Icons.touch_app_rounded),
                const SizedBox(width: 8),
                _buildCategoryChip('women', t.coursesForHer, Icons.spa_rounded),
                const SizedBox(width: 8),
                _buildCategoryChip('men', t.coursesForHim, Icons.male_rounded),
                const SizedBox(width: 8),
                _buildCategoryChip('couples', t.coursesForCouples, Icons.favorite_rounded),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Daily 30-Second Micro-Journaling Check-in
          DailyCheckInCard(
            onCheckInSaved: () {
              setState(() {
                _streak = StorageService.getStreakCount();
              });
            },
          ),

          const SizedBox(height: 12),

          // Daily Simmering / Erotik-Funke Card
          const DailySimmeringCard(),

          // Couples Channel Teaser Banner
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF4C0519).withValues(alpha: 0.35),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFB7185).withValues(alpha: 0.35),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onNavigateToTool(3),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48).withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFFB7185),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  t.coursesCoupleChannel,
                                  style: TextStyle(
                                    color: Color(0xFFFB7185),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.lock_rounded, size: 12, color: AppTheme.sageGreen),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t.coursesYourPrivateSpace,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t.coursesSendSparksSecretlyMatchWishes,
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppTheme.textMuted,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Courses List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.coursesYourCurriculum,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  t.coursesCourseCount(filteredCourses.length),
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Course Cards
          ...filteredCourses.map((course) => _buildCourseCard(course)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String cat, String label, IconData icon) {
    final isSelected = _selectedCategory == cat;
    Color activeColor = AppTheme.sageGreen;
    if (cat == 'women') activeColor = const Color(0xFFFB7185);
    if (cat == 'couples') activeColor = AppTheme.amber;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = cat;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? activeColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(int completedCount, int totalLessons, double overallProgress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profile != null ? t.coursesHelloProfilename(_profile!.name) : t.coursesWelcome,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profile != null
                          ? t.coursesYourFocusGoallabel(_profile!.goalLabel)
                          : t.coursesUnderstandTheBiologyQuietThe,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Tagesserie
              Tooltip(
                message: t.coursesStreakDays(_streak),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.amber.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppTheme.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_streak',
                        style: const TextStyle(color: AppTheme.amberLight, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: _openProfileEditor,
                tooltip: t.coursesProfileSettings,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: _profile?.isFemale == true ? const Color(0xFFFB7185) : AppTheme.sageGreen,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.coursesOverallProgressCompletedcountOfTotallessons(completedCount, totalLessons),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(overallProgress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppTheme.sageGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: overallProgress,
              backgroundColor: AppTheme.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.sageGreen),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final completedInCourse = course.lessons.where((l) => _completedLessonIds.contains(l.id)).length;
    final totalInCourse = course.lessons.length;
    final progress = totalInCourse > 0 ? (completedInCourse / totalInCourse) : 0.0;
    final isAllDone = totalInCourse > 0 && completedInCourse == totalInCourse;

    Color badgeColor = AppTheme.sageGreen;
    if (course.isForWomen) {
      badgeColor = const Color(0xFFFB7185);
    } else if (course.isForCouples) {
      badgeColor = AppTheme.amber;
    } else if (course.isForMen) {
      badgeColor = AppTheme.sageGreen;
    } else {
      badgeColor = const Color(0xFF38BDF8);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAllDone ? AppTheme.sageGreen.withValues(alpha: 0.5) : AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thematic Image Banner
          if (course.image != null)
            Stack(
              children: [
                SizedBox(
                  height: 125,
                  width: double.infinity,
                  child: course.image!.endsWith('.svg')
                      ? SvgPicture.asset(
                          course.image!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          course.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppTheme.surfaceLight,
                            child: const Center(
                              child: Icon(Icons.spa_rounded, color: AppTheme.textMuted, size: 32),
                            ),
                          ),
                        ),
                ),
                // Gradient Overlay for smooth transition into card content
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.surface.withValues(alpha: 0.7),
                          AppTheme.surface,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Target Category Tag Pill
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.7)),
                    ),
                    child: Text(
                      course.targetBadgeLabel,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            // Eigene Material-Ebene, damit der Tipp-Effekt über dem farbigen Container sichtbar ist.
            child: Material(
              type: MaterialType.transparency,
              child: ExpansionTile(
                initiallyExpanded: false,
                tilePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isAllDone ? AppTheme.sageGreen.withValues(alpha: 0.18) : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAllDone ? AppTheme.sageGreen.withValues(alpha: 0.4) : AppTheme.border,
                    ),
                  ),
                  child: Icon(
                    isAllDone ? Icons.check_circle_rounded : _getIconForCourse(course.icon),
                    color: isAllDone ? AppTheme.sageGreen : AppTheme.textPrimary,
                    size: 22,
                  ),
                ),
                title: Text(
                  course.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _parseColor(course.titleColor) ?? AppTheme.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      course.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppTheme.surfaceLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isAllDone ? AppTheme.sageGreen : AppTheme.amber,
                              ),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$completedInCourse/$totalInCourse',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isAllDone ? AppTheme.sageGreen : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  const Divider(color: AppTheme.border, height: 1),
                  ...course.lessons.map((lesson) {
                    final isDone = _completedLessonIds.contains(lesson.id);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onLessonTap(course, lesson),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppTheme.border.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Done or Icon indicator
                              Icon(
                                isDone
                                    ? Icons.check_circle_rounded
                                    : (lesson.isAudioExercise ? Icons.headphones_rounded : Icons.circle_outlined),
                                color: isDone
                                    ? AppTheme.sageGreen
                                    : (lesson.isAudioExercise ? AppTheme.amber : AppTheme.textMuted),
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              // Titles
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          t.coursesDurationminMin(lesson.durationMin),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textMuted,
                                          ),
                                        ),
                                        if (lesson.linkedTool != 'none') ...[
                                          const Text(' • ', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                          Text(
                                            switch (lesson.linkedTool) {
                                              'kegel_timer' => t.coursesPracticePelvicFloor,
                                              'breath_pacer' => t.coursesPracticeBreath,
                                              'selbst_reise' => t.coursesPracticeSelfExploration,
                                              'lust_profil' => t.coursesPracticeDesireProfile,
                                              _ => t.coursesPracticeCbt,
                                            },
                                            style: const TextStyle(
                                              color: AppTheme.sageGreen,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppTheme.textMuted,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
