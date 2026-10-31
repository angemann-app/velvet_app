import 'package:flutter/material.dart';
import '../services/nostr_service.dart';
import '../services/storage_service.dart';
import '../widgets/spicy_atmosphaere.dart';
import '../theme/app_theme.dart';
import '../widgets/sos_button.dart';
import '../widgets/update_dialog.dart';
import 'courses/courses_screen.dart';
import 'training/training_screen.dart';
import 'couples_channel/couples_channel_screen.dart';
import 'ueben/ueben_screen.dart';
import 'whats_new_screen.dart';
import 'anleitung_screen.dart';
import '../l10n/t.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Tabs: 0 Heute, 1 Lernen, 2 Üben, 3 Wir (Paar-Kanal).
  static const _heute = 0, _lernen = 1, _ueben = 2, _wir = 3;

  int _currentIndex = 0;
  final GlobalKey<TrainingScreenState> _trainingKey = GlobalKey<TrainingScreenState>();
  final GlobalKey<UebenScreenState> _uebenKey = GlobalKey<UebenScreenState>();
  // Zählt bei jedem Tabwechsel hoch, damit Heute und Lernen erledigte Lektionen des anderen Tabs nachladen.
  final ValueNotifier<int> _tabWechsel = ValueNotifier(0);

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
    NostrService().paarKanalSichtbar.value = index == _wir;
    _tabWechsel.value++;
  }

  /// Sprung aus Lektionen und Karten. Die Nummern sind die der alten fünf Tabs und bleiben dem Aufrufer so erhalten:
  /// 0 Kurse, 1 Training (mit `subTab` kegel/breath), 2 Reframing, 3 Paar-Kanal, 4 KI-Coach.
  void _navigateToTab(int index, {String? subTab}) {
    switch (index) {
      case 0:
        _showTab(_heute);
      case 3:
        _showTab(_wir);
      default:
        _showTab(_ueben);
        final bereich = switch (index) {
          1 => UebenScreenState.koerper,
          2 => UebenScreenState.gedanken,
          _ => UebenScreenState.coach,
        };
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _uebenKey.currentState?.waehle(bereich);
          if (index == 1 && subTab != null) _trainingKey.currentState?.selectSubTab(subTab);
        });
    }
  }
  String _getAppBarTitle(int index) {
    switch (index) {
      case _heute:
        return t.mainNavigationProgrammeCourses;
      case _lernen:
        return t.navLernen;
      case _ueben:
        return t.navUeben;
      case _wir:
        return t.mainNavigationCoupleChannel;
      default:
        return 'VelvetPulse';
    }
  }
  @override
  Widget build(BuildContext context) {
    // Im Spicy-Modus wird die ganze Oberfläche wärmer und röter (lib/widgets/spicy_atmosphaere.dart).
    return ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, spicy, _) => _buildScaffold(spicy),
    );
  }

  Widget _buildScaffold(bool spicy) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        flexibleSpace: spicy
            ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SpicyAtmosphaere.glut.withValues(alpha: 0.28), AppTheme.background],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              )
            : null,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          if (spicy) ...[
            Icon(Icons.local_fire_department_rounded, color: AppTheme.rose, size: 20, semanticLabel: t.spicyModus),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              _getAppBarTitle(_currentIndex),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnleitungScreen())),
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: t.anleitungTitel,
          ),
          // Global SOS Button permanently in the AppBar
          const SosButton(),
        ],
      ),
      body: SpicyAtmosphaere(
        an: spicy,
        child: IndexedStack(
        index: _currentIndex,
        children: [
          CoursesScreen(
            onNavigateToTool: _navigateToTab,
            onZuLernen: () => _showTab(_lernen),
            aktualisieren: _tabWechsel,
          ),
          CoursesScreen(
            key: const ValueKey('lernen'),
            lernen: true,
            onNavigateToTool: _navigateToTab,
            aktualisieren: _tabWechsel,
          ),
          UebenScreen(key: _uebenKey, trainingKey: _trainingKey),
          const CouplesChannelScreen(),
        ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: spicy ? SpicyAtmosphaere.glut.withValues(alpha: 0.6) : AppTheme.border, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: spicy ? Color.alphaBlend(SpicyAtmosphaere.glut.withValues(alpha: 0.08), AppTheme.surface) : AppTheme.surface,
          selectedItemColor: spicy ? AppTheme.rose : AppTheme.amber,
          unselectedItemColor: AppTheme.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: _showTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny_outlined),
              activeIcon: Icon(Icons.wb_sunny_rounded),
              label: t.mainNavigationCourses,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: t.navLernen,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_outlined),
              activeIcon: Icon(Icons.self_improvement_rounded),
              label: t.navUeben,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: t.navWir,
            ),          ],
        ),
      ),
    );
  }
}
