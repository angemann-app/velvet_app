import 'package:flutter/material.dart';

import '../../l10n/t.dart';
import '../../widgets/design/vp_tabs.dart';
import '../cbt/cbt_journal_screen.dart';
import '../training/training_screen.dart';

/// Tab „Üben“: Körper (Beckenboden und Atem) und Gedanken (Reframing) unter einem Dach
/// (docs/konzepte/heute-und-produktschliff.md, Punkt 5). Die beiden Bereiche behalten ihren Zustand.
class UebenScreen extends StatefulWidget {
  final GlobalKey<TrainingScreenState>? trainingKey;

  const UebenScreen({super.key, this.trainingKey});

  @override
  State<UebenScreen> createState() => UebenScreenState();
}

class UebenScreenState extends State<UebenScreen> {
  static const koerper = 0, gedanken = 1;

  int _bereich = koerper;

  /// Wechselt den Bereich, z. B. wenn eine Lektion zur Übung verlinkt.
  void waehle(int bereich) {
    if (bereich == _bereich) return;
    setState(() => _bereich = bereich);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Zwei Kapitel auf einer Linie (je halbe Breite): Körper, Gedanken.
      VpKapitelLeiste(
        titel: [t.uebenKoerper, t.uebenGedanken],
        index: _bereich,
        onChanged: waehle,
      ),
      Expanded(
        child: IndexedStack(index: _bereich, children: [
          TrainingScreen(key: widget.trainingKey),
          const CbtJournalScreen(),
        ]),
      ),
    ]);
  }
}
