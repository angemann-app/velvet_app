import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'kegel_timer_view.dart';
import 'breath_pacer_view.dart';

class TrainingScreen extends StatefulWidget {
  final String? initialSubTab;

  const TrainingScreen({
    super.key,
    this.initialSubTab,
  });

  @override
  State<TrainingScreen> createState() => TrainingScreenState();
}

class TrainingScreenState extends State<TrainingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialSubTab == 'breath' ? 1 : 0;
    _tabController = TabController(length: 2, vsync: this, initialIndex: initialIndex);
  }

  void selectSubTab(String subTab) {
    if (subTab == 'breath') {
      _tabController.animateTo(1);
    } else {
      _tabController.animateTo(0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Segmented Bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.sageGreen.withOpacity(0.4)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppTheme.textPrimary,
            unselectedLabelColor: AppTheme.textMuted,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Beckenboden'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.air_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Atem-Pacer'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              KegelTimerView(),
              BreathPacerView(),
            ],
          ),
        ),
      ],
    );
  }
}
