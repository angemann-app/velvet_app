import 'package:flutter/material.dart';
import '../models/daily_checkin.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../l10n/t.dart';

class DailyCheckInCard extends StatefulWidget {
  final VoidCallback? onCheckInSaved;

  const DailyCheckInCard({super.key, this.onCheckInSaved});

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard> {
  DailyCheckIn? _todayCheckIn;
  bool _isExpanded = false;
  double _stressLevel = 3.0;
  double _pressureLevel = 3.0;
  final Set<String> _selectedActions = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    final existing = StorageService.getTodayCheckIn();
    setState(() {
      _todayCheckIn = existing;
      if (existing != null) {
        _stressLevel = existing.stressLevel.toDouble();
        _pressureLevel = existing.performancePressure.toDouble();
        _selectedActions.clear();
        _selectedActions.addAll(existing.positiveActions);
      }
    });
  }

  void _toggleAction(String action) {
    setState(() {
      if (_selectedActions.contains(action)) {
        _selectedActions.remove(action);
      } else {
        _selectedActions.add(action);
      }
    });
  }

  Future<void> _saveCheckIn() async {
    setState(() {
      _isSaving = true;
    });

    final checkIn = DailyCheckIn(
      date: StorageService.getTodayKey(),
      stressLevel: _stressLevel.round(),
      performancePressure: _pressureLevel.round(),
      positiveActions: _selectedActions.toList(),
      timestamp: DateTime.now(),
    );

    await StorageService.saveDailyCheckIn(checkIn);

    setState(() {
      _todayCheckIn = checkIn;
      _isExpanded = false;
      _isSaving = false;
    });

    if (widget.onCheckInSaved != null) {
      widget.onCheckInSaved!();
    }
  }

  String _getStressLabel(double val) {
    switch (val.round()) {
      case 1:
        return t.dailyCheckinCardVeryCalm;
      case 2:
        return t.dailyCheckinCardMild;
      case 3:
        return t.dailyCheckinCardModerate;
      case 4:
        return t.dailyCheckinCardHigh;
      case 5:
        return t.dailyCheckinCardExtremeStress;
      default:
        return '';
    }
  }

  String _getPressureLabel(double val) {
    switch (val.round()) {
      case 1:
        return t.dailyCheckinCardClearHead;
      case 2:
        return t.dailyCheckinCardHardlyAnyPressure;
      case 3:
        return t.dailyCheckinCardSomeRestlessness;
      case 4:
        return t.dailyCheckinCardNoticeablyHigh;
      case 5:
        return t.dailyCheckinCardStrongPressure;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _todayCheckIn != null
              ? AppTheme.sageGreen.withValues(alpha: 0.4)
              : AppTheme.amber.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Header Bar
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _todayCheckIn != null
                            ? AppTheme.sageGreen.withValues(alpha: 0.18)
                            : AppTheme.amber.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _todayCheckIn != null
                            ? Icons.check_circle_rounded
                            : Icons.speed_rounded,
                        color: _todayCheckIn != null
                            ? AppTheme.sageGreen
                            : AppTheme.amber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                t.dailyCheckinCardSecondDailyCheckIn,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              if (_todayCheckIn != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.sageGreen.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    t.dailyCheckinCardDone,
                                    style: TextStyle(
                                      color: AppTheme.sageGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _todayCheckIn != null
                                ? t.dailyCheckinCardStressStresslevelPressurePressurelevel(_getStressLabel(_stressLevel), _getPressureLabel(_pressureLevel))
                                : t.dailyCheckinCardHowDoStressPerformancePressure,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppTheme.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded) ...[
            const Divider(color: AppTheme.border, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider 1: Alltagsstress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.dailyCheckinCardEverydayStressTodayJobAppointments,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getStressLabel(_stressLevel),
                        style: const TextStyle(
                          color: AppTheme.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.amber,
                      inactiveTrackColor: AppTheme.surfaceLight,
                      thumbColor: AppTheme.amber,
                      overlayColor: AppTheme.amber.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _stressLevel,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      onChanged: (val) {
                        setState(() {
                          _stressLevel = val;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Slider 2: Innerer Leistungsdruck
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.dailyCheckinCardInnerPerformancePressureRacingThoughts,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getPressureLabel(_pressureLevel),
                        style: const TextStyle(
                          color: AppTheme.sageGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.sageGreen,
                      inactiveTrackColor: AppTheme.surfaceLight,
                      thumbColor: AppTheme.sageGreen,
                      overlayColor: AppTheme.sageGreen.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _pressureLevel,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      onChanged: (val) {
                        setState(() {
                          _pressureLevel = val;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Positive Actions Chips
                  Text(
                    t.dailyCheckinCardWhatDidYouGoodToday,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: DailyCheckIn.availableActions.map((action) {
                      final isSelected = _selectedActions.contains(action);

                      return FilterChip(
                        label: Text(DailyCheckIn.anzeige(action)),
                        selected: isSelected,
                        onSelected: (_) => _toggleAction(action),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        selectedColor: AppTheme.sageGreen.withValues(alpha: 0.25),
                        checkmarkColor: AppTheme.sageGreen,
                        backgroundColor: AppTheme.surfaceLight.withValues(alpha: 0.3),
                        side: BorderSide(
                          color: isSelected ? AppTheme.sageGreen : AppTheme.border,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.sageGreen,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: Text(
                        _todayCheckIn == null
                            ? t.dailyCheckinCardSaveDailyCheckIn
                            : t.dailyCheckinCardUpdateValues,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Correlation Insight Box (if completed)
          if (_todayCheckIn != null && !_isExpanded) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.insights_rounded, color: AppTheme.amberLight, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _stressLevel >= 4
                            ? t.dailyCheckinCardCoachingInsightYourEverydayStress
                            : t.dailyCheckinCardCoachingInsightWhenEverydayStress,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
