import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../l10n/t.dart';

class DailySimmeringCard extends StatefulWidget {
  const DailySimmeringCard({super.key});

  @override
  State<DailySimmeringCard> createState() => _DailySimmeringCardState();
}

class _DailySimmeringCardState extends State<DailySimmeringCard>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  late AnimationController _flipController;

  static List<Map<String, String>> get _couplesImpulses => [
    {
      'title': t.dailySimmeringCardTheSecondWallTease,
      'tag': t.dailySimmeringCardCourseTeasing,
      'action':
          t.dailySimmeringCardTodayBrieflyPressYourPartner,
    },
    {
      'title': t.dailySimmeringCardJawMeltVoiceActivation,
      'tag': t.dailySimmeringCardCourseAudiblePleasure,
      'action':
          t.dailySimmeringCardPlaceYourFingersOnYour,
    },
    {
      'title': t.dailySimmeringCardThePmAnticipation,
      'tag': t.dailySimmeringCardCourseAnticipation,
      'action':
          t.dailySimmeringCardThisAfternoonSendYourPartner,
    },
    {
      'title': t.dailySimmeringCardSlowMotionWhilePouring,
      'tag': t.dailySimmeringCardCourseSlowSex,
      'action':
          t.dailySimmeringCardTodayTouchYourPartnerDuring,
    },
    {
      'title': t.dailySimmeringCardTheMinuteSilkScarfRitual,
      'tag': t.dailySimmeringCardCourseSurrender,
      'action':
          t.dailySimmeringCardAgreeForTonightOneOf,
    },
    {
      'title': t.dailySimmeringCardTheStrictNoPenetrationRule,
      'tag': t.dailySimmeringCardCourseSensateFocus,
      'action':
          t.dailySimmeringCardAgreeTodayYouMayHug,
    },
    {
      'title': t.dailySimmeringCardSensoryNarratingWordsInThe,
      'tag': t.dailySimmeringCardCbtLettingGoOfPropriety,
      'action':
          t.dailySimmeringCardTonightInTheDarkWhisper,
    },
    {
      'title': t.dailySimmeringCardTheCharmingDreamBridge,
      'tag': t.dailySimmeringCardCourseFantasies,
      'action':
          t.dailySimmeringCardTodayCasuallyAndWithA,
    },
    {
      'title': t.dailySimmeringCardTheSeatedPelvicFloorCheck,
      'tag': t.dailySimmeringCardCoursesBody,
      'action':
          t.dailySimmeringCardNoticeRightNowAreYou,
    },
    {
      'title': t.dailySimmeringCardSoftBellyFullSurrender,
      'tag': t.dailySimmeringCardCourseRadicalBodyLove,
      'action':
          t.dailySimmeringCardTodayConsciouslyLetYourBelly,
    },
  ];

  static List<Map<String, String>> get _soloImpulses => [
    {
      'title': t.dailySimmeringCardJawMeltPelvicVibration,
      'tag': t.dailySimmeringCardCourseAudiblePleasure,
      'action':
          t.dailySimmeringCardOpenYourMouthSmoothOut,
    },
    {
      'title': t.dailySimmeringCardBroadPalmTouchWithWarm,
      'tag': t.dailySimmeringCardCourseBodyLab,
      'action':
          t.dailySimmeringCardTodaySkipAnyTightGrip,
    },
    {
      'title': t.dailySimmeringCardOrbitingExploringThePerineum,
      'tag': t.dailySimmeringCardCoursesOrbiting,
      'action':
          t.dailySimmeringCardLeaveTheHighlySensitiveTip,
    },
    {
      'title': t.dailySimmeringCardPlateauSurfingAtLevel,
      'tag': t.dailySimmeringCardCourseStayingPower,
      'action':
          t.dailySimmeringCardBringYourArousalToLevel,
    },
    {
      'title': t.dailySimmeringCardScreenFreeSensing,
      'tag': t.dailySimmeringCardCourseRecalibration,
      'action':
          t.dailySimmeringCardTakeMinutesTodayWithoutAny,
    },
    {
      'title': t.dailySimmeringCardTheSphincterReleaseTest,
      'tag': t.dailySimmeringCardCourseMultipleOrgasms,
      'action':
          t.dailySimmeringCardObserveYourReflexesWhenArousal,
    },
    {
      'title': t.dailySimmeringCardZeroPressureSquatMalasana,
      'tag': t.dailySimmeringCardCourseFascia,
      'action':
          t.dailySimmeringCardGoIntoADeepSquat,
    },
    {
      'title': t.dailySimmeringCardBodyCompassionInTheMirror,
      'tag': t.dailySimmeringCardCourseSelfCompassion,
      'action':
          t.dailySimmeringCardLookAtYourBodyToday,
    },
    {
      'title': t.dailySimmeringCardPhysiologicalSighQuickCalming,
      'tag': t.dailySimmeringCardToolCalmDown,
      'action':
          t.dailySimmeringCardBreatheInTwiceDeeplyThrough,
    },
    {
      'title': t.dailySimmeringCardThePercentPactWithYourself,
      'tag': t.dailySimmeringCardCourseTeasing,
      'action':
          t.dailySimmeringCardGiveYourselfMinutesOfPleasure,
    },
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    HapticFeedback.lightImpact();
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    });
  }

  Map<String, String> _getTodayImpulse(UserProfile? profile) {
    final now = DateTime.now();
    // Daily stable index (day of year)
    final dayIndex = (now.year * 365 + now.month * 31 + now.day) % 10;
    final isSolo = (profile != null && profile.relationshipStatus == 'single');
    final list = isSolo ? _soloImpulses : _couplesImpulses;
    return list[dayIndex % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final impulse = _getTodayImpulse(profile);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRevealed
              ? const Color(0xFFE11D48).withValues(alpha: 0.6)
              : AppTheme.amber.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          if (_isRevealed)
            BoxShadow(
              color: const Color(0xFFE11D48).withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleReveal,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE11D48).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFFB7185),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.dailySimmeringCardTodaySEroticSpark,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Color(0xFFFB7185),
                              ),
                            ),
                            Text(
                              _isRevealed ? impulse['tag']! : t.dailySimmeringCardSimmeringEverydayTeasing,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      _isRevealed
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.lock_open_rounded,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Content Area (Mystery vs Revealed)
                if (!_isRevealed) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.dailySimmeringCardTapHereToRevealToday,
                          style: TextStyle(
                            color: AppTheme.textSecondary.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          t.dailySimmeringCardOpen,
                          style: TextStyle(
                            color: AppTheme.amberLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    impulse['title']!,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    impulse['action']!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
