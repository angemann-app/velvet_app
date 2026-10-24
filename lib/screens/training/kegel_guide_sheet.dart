import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/t.dart';

class KegelGuideSheet extends StatelessWidget {
  const KegelGuideSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const KegelGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: AppTheme.sageGreen, size: 24),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.kegelGuideSheetPelvicFloorGuide,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              t.kegelGuideSheetFindingTheMuscleExercisesPlan,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppTheme.border, height: 1),

              // Content Body
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    _buildSectionCard(
                      title: t.kegelGuideSheetFindingTheMuscle,
                      badge: t.kegelGuideSheetBasics,
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        Text(
                          t.kegelGuideSheetThePelvicFloorStretchesLike,
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodBox(
                          icon: Icons.vertical_align_top_rounded,
                          title: t.kegelGuideSheetTightenAndLift,
                          text: t.kegelGuideSheetImagineHoldingBackWindAnd,
                          accentColor: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 8),
                        _buildMethodBox(
                          icon: Icons.vertical_align_bottom_rounded,
                          title: t.kegelGuideSheetLetGoAndWiden,
                          text: t.kegelGuideSheetBreatheDeepIntoTheBelly,
                          accentColor: AppTheme.amber,
                        ),
                        const SizedBox(height: 10),
                        _buildTip(t.kegelGuideSheetButtocksThighsAndBellyStay),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: t.kegelGuideSheetWhichExerciseForWhat,
                      badge: t.kegelGuideSheetExercises,
                      badgeColor: AppTheme.amber,
                      children: [
                        _buildModeComparison(
                          title: t.kegelTimerViewLetGo,
                          subtitle: t.kegelGuideSheetForTensionPainOnPenetration,
                          description: t.kegelGuideSheetForEveryoneWhosePelvicFloor,
                          color: AppTheme.amber,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: t.kegelTimerViewStrengthen,
                          subtitle: t.kegelGuideSheetForSupportControlAndStability,
                          description: t.kegelGuideSheetStrengthensTheMusclesForExample,
                          color: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: t.kegelTimerViewQuickPulses,
                          subtitle: t.kegelGuideSheetForResponsiveness,
                          description: t.kegelGuideSheetAShortSqueezeAndImmediate,
                          color: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: t.kegelTimerViewWaves,
                          subtitle: t.kegelGuideSheetStayingLooseWhenItGets,
                          description: t.kegelGuideSheetALongAudibleExhaleWith,
                          color: AppTheme.rose,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: t.kegelGuideSheetCommonMistakes,
                      badge: t.kegelGuideSheetCareful,
                      badgeColor: AppTheme.rose,
                      children: [
                        _buildRuleItem(
                          isWarning: true,
                          title: t.kegelGuideSheetSqueezingTheButtocks,
                          description: t.kegelGuideSheetTheBigGlutealMuscleLikes,
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: t.kegelGuideSheetHoldingYourBreath,
                          description: t.kegelGuideSheetKeepBreathingCalmlyWhileHolding,
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: t.kegelGuideSheetPushingInsteadOfLettingGo,
                          description: t.kegelGuideSheetWhenLettingGoNothingIs,
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: t.kegelGuideSheetPractisingWhileActuallyUrinating,
                          description: t.kegelGuideSheetRegularlyStoppingTheFlowOf,
                        ),
                        _buildRuleItem(
                          isWarning: false,
                          title: t.kegelGuideSheetBetterShortAndRegular,
                          description: t.kegelGuideSheetAFewMinutesOnMost,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: t.kegelGuideSheetAPlanForSixWeeks,
                      badge: t.kegelGuideSheetPlan,
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        _buildPlanRow(t.kegelGuideSheetWeek, t.kegelGuideSheetLetGoDailyRoundsEasy),
                        _buildPlanRow(t.kegelGuideSheetWeek2, t.kegelGuideSheetLetGoRoundsThenStrengthen),
                        _buildPlanRow(t.kegelGuideSheetWeek3, t.kegelGuideSheetRoundsOfYourMainExercise),
                        const SizedBox(height: 6),
                        Text(
                          t.kegelGuideSheetAfterThatKeepTwoOr,
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.45),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: t.kegelGuideSheetWhenToSeeAPhysiotherapist,
                      badge: t.kegelGuideSheetHealth,
                      badgeColor: AppTheme.amber,
                      children: [
                        Text(
                          t.kegelGuideSheetSpecialisedPelvicFloorPhysiotherapyCan,
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sageGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(t.kegelGuideSheetBackToTraining, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanRow(String when, String what) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(when, style: const TextStyle(color: AppTheme.sageGreen, fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Text(what, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMethodBox({
    required IconData icon,
    required String title,
    required String text,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeComparison({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              subtitle,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem({
    required bool isWarning,
    required String title,
    required String description,
  }) {
    final color = isWarning ? AppTheme.rose : AppTheme.sageGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? Icons.cancel_outlined : Icons.check_circle_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
