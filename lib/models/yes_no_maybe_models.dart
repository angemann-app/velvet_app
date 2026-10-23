import 'package:flutter/material.dart';

enum YesNoMaybeVote {
  yes,
  maybe,
  no;

  static YesNoMaybeVote? fromString(String? val) {
    if (val == 'yes') return YesNoMaybeVote.yes;
    if (val == 'maybe') return YesNoMaybeVote.maybe;
    if (val == 'no') return YesNoMaybeVote.no;
    return null;
  }

  String get key => name;

  String get label {
    switch (this) {
      case YesNoMaybeVote.yes:
        return 'Yes';
      case YesNoMaybeVote.maybe:
        return 'Maybe';
      case YesNoMaybeVote.no:
        return 'No';
    }
  }

  String get description {
    switch (this) {
      case YesNoMaybeVote.yes:
        return 'Möchte ich ausprobieren / Erregt mich';
      case YesNoMaybeVote.maybe:
        return 'Unsicher / Bin neugierig / Kommt auf den Kontext an';
      case YesNoMaybeVote.no:
        return 'Kommt für mich absolut nicht in Frage / Grenze';
    }
  }

  Color get color {
    switch (this) {
      case YesNoMaybeVote.yes:
        return const Color(0xFF10B981); // Emerald green
      case YesNoMaybeVote.maybe:
        return const Color(0xFFF59E0B); // Warm amber
      case YesNoMaybeVote.no:
        return const Color(0xFFF43F5E); // Rose red
    }
  }

  IconData get icon {
    switch (this) {
      case YesNoMaybeVote.yes:
        return Icons.check_circle_rounded;
      case YesNoMaybeVote.maybe:
        return Icons.help_outline_rounded;
      case YesNoMaybeVote.no:
        return Icons.cancel_outlined;
    }
  }
}

class YesNoMaybeItem {
  final String id;
  final String text;
  final String linkedCourseId;
  final String categoryId;

  const YesNoMaybeItem({
    required this.id,
    required this.text,
    required this.linkedCourseId,
    required this.categoryId,
  });
}

class YesNoMaybeCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<YesNoMaybeItem> items;

  const YesNoMaybeCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });
}

const List<YesNoMaybeCategory> velvetYesNoMaybeCategories = [
  YesNoMaybeCategory(
    id: 'sensory_basics',
    title: '1. Sinnlichkeit & Sinnesreize',
    description: 'Erforschung von Temperatur, Textur, Klang und Berührung.',
    icon: Icons.spa_rounded,
    items: [
      YesNoMaybeItem(
        id: 'item_1',
        text: 'Slow-Motion-Massage mit warmem Öl im Zeitlupentempo',
        linkedCourseId: 'course_sacred_massage',
        categoryId: 'sensory_basics',
      ),
      YesNoMaybeItem(
        id: 'item_2',
        text: 'Temperaturspiele (Eiswürfel, warme Öle, sanfte Kälte/Wärme)',
        linkedCourseId: 'course_sacred_massage',
        categoryId: 'sensory_basics',
      ),
      YesNoMaybeItem(
        id: 'item_3',
        text: 'Sensorische Deprivation (Mit einer weichen Seidenbinde die Augen verbinden)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'sensory_basics',
      ),
      YesNoMaybeItem(
        id: 'item_4',
        text: 'Gemeinsames Tönen und Summen zur Entspannung des Beckenbodens',
        linkedCourseId: 'course_vocal_pelvic',
        categoryId: 'sensory_basics',
      ),
      YesNoMaybeItem(
        id: 'item_5',
        text: 'Feder- und Pinselkitzel an sensiblen Hautpartien',
        linkedCourseId: 'course_touch_women',
        categoryId: 'sensory_basics',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'communication_mind',
    title: '2. Kommunikation, Sprache & Dirty Talk',
    description: 'Worte als Zündstoff und Ausdruck von Begehren.',
    icon: Icons.record_voice_over_rounded,
    items: [
      YesNoMaybeItem(
        id: 'item_6',
        text: 'Sensory Narrating (Während der Berührung laut aussprechen, was man spürt)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'communication_mind',
      ),
      YesNoMaybeItem(
        id: 'item_7',
        text: 'Erotische Nachrichten und Teasing-Pings im Alltag (90-Prozent-Prinzip)',
        linkedCourseId: 'course_teasing_desire',
        categoryId: 'communication_mind',
      ),
      YesNoMaybeItem(
        id: 'item_8',
        text: 'Gegenseitiges Vorlesen oder Schreiben kurzer erotischer Szenarien',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'communication_mind',
      ),
      YesNoMaybeItem(
        id: 'item_9',
        text: 'Das \'Sag-es-mir\'-Spiel (Den Partner bitten, eigene Wünsche laut zu befehlen)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'communication_mind',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'power_dynamics',
    title: '3. Machtspiele, Dominanz & Hingabe (D/s)',
    description: 'Spielerischer Rollentausch, Führung und bewusste Kontrolle.',
    icon: Icons.lock_rounded,
    items: [
      YesNoMaybeItem(
        id: 'item_10',
        text: 'Sanfte Handgelenk-Fixierung (Bewegungsverbot als Entlastung)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'power_dynamics',
      ),
      YesNoMaybeItem(
        id: 'item_11',
        text: 'Verbale Dominanz (Klare Anweisungen, Lob und strenge Worte)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'power_dynamics',
      ),
      YesNoMaybeItem(
        id: 'item_12',
        text: 'Rollenwechsel: Die Zügel komplett aus der Hand geben (Submissiv sein)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'power_dynamics',
      ),
      YesNoMaybeItem(
        id: 'item_13',
        text: 'Die Zügel ergreifen und den Partner durch eine Session führen (Dominant sein)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'power_dynamics',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'deep_somatics',
    title: '4. Tiefe Somatik, Yoni, Lingam & Prostata',
    description: 'Erweiterte anatomische Erkundung und Schwellkörper-Alchemie.',
    icon: Icons.self_improvement_rounded,
    items: [
      YesNoMaybeItem(
        id: 'item_14',
        text: 'Vollständige Yoni-Verehrung (45 Minuten absichtslose Einseitigkeit)',
        linkedCourseId: 'course_sacred_massage',
        categoryId: 'deep_somatics',
      ),
      YesNoMaybeItem(
        id: 'item_15',
        text: 'Lingam- und Perineum-Massage (Entlastung des Beckenbodens)',
        linkedCourseId: 'course_sacred_massage',
        categoryId: 'deep_somatics',
      ),
      YesNoMaybeItem(
        id: 'item_16',
        text: 'Prostata-Erkundung von außen (Damm / Perineum-Druck)',
        linkedCourseId: 'course_prostate_alchemy',
        categoryId: 'deep_somatics',
      ),
      YesNoMaybeItem(
        id: 'item_17',
        text: 'Innere Prostata-Alchemie und Entdeckung des männlichen G-Punkts',
        linkedCourseId: 'course_prostate_alchemy',
        categoryId: 'deep_somatics',
      ),
      YesNoMaybeItem(
        id: 'item_18',
        text: 'Schwellen-Training (Bewusstes Innehalten an Stufe 7 zur Ausdauerkontrolle)',
        linkedCourseId: 'course_touch_men',
        categoryId: 'deep_somatics',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'roles_settings',
    title: '5. Rollenspiele, Settings & Orte',
    description: 'Ausbrechen aus der Routine durch neue Kulissen.',
    icon: Icons.theater_comedy_rounded,
    items: [
      YesNoMaybeItem(
        id: 'item_19',
        text: 'Rollenspiel: Zwei Fremde flirten in einer Bar oder im Hotel',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'roles_settings',
      ),
      YesNoMaybeItem(
        id: 'item_20',
        text: 'Intimität an ungewöhnlichen Orten (zum Beispiel im Auto, im Garten im Dunkeln)',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'roles_settings',
      ),
      YesNoMaybeItem(
        id: 'item_21',
        text: 'Verkleidungen, Uniformen oder gezielter Einsatz von aufregenden Dessous',
        linkedCourseId: 'course_erotic_scenarios',
        categoryId: 'roles_settings',
      ),
      YesNoMaybeItem(
        id: 'item_22',
        text: 'Die Verschmelzungs-Technik (CAT) für dauerhaften Flächenkontakt',
        linkedCourseId: 'course_positions_somatics',
        categoryId: 'roles_settings',
      ),
    ],
  ),
];

List<YesNoMaybeItem> get allYesNoMaybeItems {
  final list = <YesNoMaybeItem>[];
  for (var cat in velvetYesNoMaybeCategories) {
    list.addAll(cat.items);
  }
  return list;
}
