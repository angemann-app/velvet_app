import 'package:flutter/material.dart';
import '../services/nostr_service.dart';
import '../theme/app_theme.dart';
import '../widgets/sos_button.dart';
import '../widgets/update_dialog.dart';
import 'courses/courses_screen.dart';
import 'training/training_screen.dart';
import 'cbt/cbt_journal_screen.dart';
import 'couples_channel/couples_channel_screen.dart';
import 'ai_coach/ai_coach_screen.dart';
import 'whats_new_screen.dart';
import '../l10n/t.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final GlobalKey<TrainingScreenState> _trainingKey = GlobalKey<TrainingScreenState>();

  @override
  void initState() {
    super.initState();
    // Nach einem Update einmal zeigen, was neu ist; danach höchstens einmal täglich
    // nach einer neuen Version auf GitHub schauen.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) await showWhatsNewIfUpdated(context);
      if (mounted) checkForUpdateAndPrompt(context);
    });
  }

  void _showTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Für Lesebestätigungen: Nur wer den Paar-Kanal wirklich sieht, hat gelesen.
    NostrService().paarKanalSichtbar.value = index == 3;
  }

  void _navigateToTab(int index, {String? subTab}) {
    _showTab(index);
    if (index == 1 && subTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _trainingKey.currentState?.selectSubTab(subTab);
      });
    }
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return t.mainNavigationProgrammeCourses;
      case 1:
        return t.mainNavigationSomaticsTraining;
      case 2:
        return t.mainNavigationCbtReframing;
      case 3:
        return t.mainNavigationCoupleChannel;
      case 4:
        return t.mainNavigationAiCoach;
      default:
        return 'VelvetPulse';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_currentIndex),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: const [
          // Global SOS Button permanently in the AppBar
          SosButton(),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CoursesScreen(
            onNavigateToTool: _navigateToTab,
          ),
          TrainingScreen(
            key: _trainingKey,
          ),
          const CbtJournalScreen(),
          const CouplesChannelScreen(),
          const AiCoachScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.amber,
          unselectedItemColor: AppTheme.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: _showTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: t.mainNavigationCourses,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              activeIcon: Icon(Icons.fitness_center_rounded),
              label: t.mainNavigationTraining,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_rounded),
              activeIcon: Icon(Icons.psychology_rounded),
              label: t.mainNavigationReframing,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: t.navPaarKanalKurz,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: t.mainNavigationAiCoach,
            ),
          ],
        ),
      ),
    );
  }
}
