import 'package:flutter/material.dart';
import 'kegel_timer_view.dart';
import 'breath_pacer_view.dart';
import '../../l10n/t.dart';
import '../../widgets/design/vp_tabs.dart';

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
        VpTabs.leiste(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center_rounded, size: 16),
                  SizedBox(width: 8),
                  Text(t.trainingPelvicFloor),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.air_rounded, size: 16),
                  SizedBox(width: 8),
                  Text(t.trainingBreathPacer),
                ],
              ),
            ),
          ],
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
