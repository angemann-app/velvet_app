import 'package:flutter/material.dart';

import '../../l10n/t.dart';
import '../../theme/app_theme.dart';
import '../ai_coach/ai_coach_screen.dart';
import '../cbt/cbt_journal_screen.dart';
import '../training/training_screen.dart';

/// Tab „Üben“: Körper (Beckenboden und Atem), Gedanken (Reframing) und der KI-Coach unter einem Dach
/// (docs/konzepte/heute-und-produktschliff.md, Punkt 5). Die drei Bereiche behalten ihren Zustand.
class UebenScreen extends StatefulWidget {
  final GlobalKey<TrainingScreenState>? trainingKey;

  const UebenScreen({super.key, this.trainingKey});

  @override
  State<UebenScreen> createState() => UebenScreenState();
}

class UebenScreenState extends State<UebenScreen> {
  static const koerper = 0, gedanken = 1, coach = 2;

  int _bereich = koerper;

  /// Wechselt den Bereich, z. B. wenn eine Lektion zur Übung verlinkt.
  void waehle(int bereich) {
    if (bereich == _bereich) return;
    setState(() => _bereich = bereich);
  }

  Widget _reiter(int i, String text, IconData icon) {
    final an = _bereich == i;
    return InkWell(
      onTap: () => waehle(i),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: an ? AppTheme.amber.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: an ? AppTheme.amber : AppTheme.border, width: an ? 1.5 : 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: an ? AppTheme.amber : AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: an ? FontWeight.w700 : FontWeight.w500,
                  color: an ? AppTheme.textPrimary : AppTheme.textSecondary)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _reiter(koerper, t.uebenKoerper, Icons.fitness_center_rounded),
            const SizedBox(width: 8),
            _reiter(gedanken, t.uebenGedanken, Icons.psychology_rounded),
            const SizedBox(width: 8),
            _reiter(coach, t.uebenCoach, Icons.chat_bubble_outline_rounded),
          ]),
        ),
      ),
      Expanded(
        child: IndexedStack(index: _bereich, children: [
          TrainingScreen(key: widget.trainingKey),
          const CbtJournalScreen(),
          const AiCoachScreen(),
        ]),
      ),
    ]);
  }
}