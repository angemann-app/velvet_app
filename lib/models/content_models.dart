
import '../l10n/t.dart';
import '../services/storage_service.dart';

class VelvetDatabase {
  final String version;

  /// Alle Kurse, auch die Spicy-Kurse. Die App zeigt [courses].
  final List<Course> alleKurse;
  final List<SosCard> sosCards;
  final List<BeliefCard> beliefLibrary;

  VelvetDatabase({
    required this.version,
    required List<Course> courses,
    required this.sosCards,
    this.beliefLibrary = const [],
  }) : alleKurse = courses;

  /// Die sichtbaren Kurse: Spicy-Kurse und Spicy-Lektionen nur bei eingeschaltetem Spicy-Modus.
  List<Course> get courses {
    if (StorageService.spicyMode()) return alleKurse;
    return [
      for (final c in alleKurse)
        if (!c.spicy) c.lessons.any((l) => l.spicy) ? c.ohneSpicyLektionen() : c,
    ];
  }

  factory VelvetDatabase.fromJson(Map<String, dynamic> json) {
    return VelvetDatabase(
      version: json['version'] as String? ?? '1.2',
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sosCards: (json['sos_cards'] as List<dynamic>?)
              ?.map((e) => SosCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      beliefLibrary: (json['belief_library'] as List<dynamic>?)
              ?.map((e) => BeliefCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'courses': alleKurse.map((e) => e.toJson()).toList(),
        'sos_cards': sosCards.map((e) => e.toJson()).toList(),
        'belief_library': beliefLibrary.map((e) => e.toJson()).toList(),
      };
}

class Course {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String category; // "all" | "men" | "women" | "couples"
  final String? image;

  /// Optionale Hervorhebungsfarbe für den Titel, z. B. "#F43F5E".
  final String? titleColor;

  /// Nur mit eingeschaltetem Spicy-Modus sichtbar (Feld "spicy" in velvet_content.json).
  final bool spicy;

  /// Schwerpunkt auf der Startseite (docs/konzepte/startseite.md), einer aus [schwerpunkte].
  final String schwerpunkt;
  final List<Lesson> lessons;

  static const schwerpunkte = ['grundlagen', 'annehmen', 'entdecken', 'paar', 'beruehrung', 'fantasie'];

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.category = 'all',
    this.image,
    this.titleColor,
    this.spicy = false,
    this.schwerpunkt = 'grundlagen',
    required this.lessons,
  });

  /// Derselbe Kurs ohne die Lektionen, die nur im Spicy-Modus sichtbar sind.
  Course ohneSpicyLektionen() => Course(
        id: id,
        title: title,
        subtitle: subtitle,
        icon: icon,
        category: category,
        image: image,
        titleColor: titleColor,
        spicy: spicy,
        schwerpunkt: schwerpunkt,
        lessons: [for (final l in lessons) if (!l.spicy) l],
      );

  bool get isForWomen => category == 'women';
  bool get isForCouples => category == 'couples';
  bool get isForMen => category == 'men';

  String get targetBadgeLabel {
    if (id.contains('touch') || id.contains('omgyes')) {
      return isForWomen ? t.contentModelsTheArtOfTouchFor : t.contentModelsTouchLabForHim;
    }
    if (id == 'course_self_exploration') {
      return t.contentModelsSelfExploration;
    }
    if (id == 'course_vocal_pelvic') {
      return t.contentModelsVoiceBody;
    }
    if (id == 'course_teasing_desire') {
      return t.contentModelsAnticipationDesire;
    }
    if (id == 'course_fantasies_shadow') {
      return t.contentModelsPolarityRoles;
    }
    if (id == 'course_body_acceptance') {
      return t.contentModelsBodyPresence;
    }
    switch (category) {
      case 'women':
        return t.contentModelsForHer;
      case 'couples':
        return t.contentModelsForCouples;
      case 'men':
        return t.contentModelsForHim;
      default:
        return t.kegelGuideSheetBasics;
    }
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      icon: json['icon'] as String? ?? 'psychology',
      category: json['category'] as String? ?? 'all',
      image: json['image'] as String?,
      titleColor: json['title_color'] as String?,
      spicy: json['spicy'] as bool? ?? false,
      schwerpunkt: json['schwerpunkt'] as String? ?? 'grundlagen',
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'icon': icon,
        'category': category,
        'image': image,
        if (titleColor != null) 'title_color': titleColor,
        if (spicy) 'spicy': true,
        'schwerpunkt': schwerpunkt,
        'lessons': lessons.map((e) => e.toJson()).toList(),
      };
}

class Lesson {
  final String id;
  final String title;
  final String type; // "article" | "audio_exercise"
  final int durationMin;
  final String linkedTool; // "none" | "kegel_timer" | "breath_pacer" | "cbt_journal"
  final String summary;
  final String content;
  final String reflectionQuestion;
  final String? image;

  /// Spicy-Stimmungsbilder aus dem Nur-R2-Paket `kurse-bilder-spicy` (Pfade im Paket, zum Beispiel
  /// `kurse/touch_w_s2_allein_a.webp`). Bei Spicy-Lektionen und bei normalen Lektionen mit zweiter Spicy-Bildfassung, nur im
  /// Spicy-Modus; fehlt das Paket, bleibt die Lektion ohne Bild.
  final List<String> bilder;

  /// "giver": Text spricht die gebende Person an; Rollen wie „sie“ meinen dann immer das Gegenüber
  /// (wichtig für gleichgeschlechtliche Paare, siehe lib/services/personalize.dart).
  final String? perspective;

  /// Nur im Spicy-Modus sichtbar (Feld "spicy"), auch in Kursen, die sonst für alle sind.
  final bool spicy;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMin,
    required this.linkedTool,
    required this.summary,
    required this.content,
    required this.reflectionQuestion,
    this.image,
    this.bilder = const [],
    this.perspective,
    this.spicy = false,
  });

  bool get isAudioExercise => type == 'audio_exercise';

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'article',
      durationMin: (json['duration_min'] as num?)?.toInt() ?? 3,
      linkedTool: json['linked_tool'] as String? ?? 'none',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      reflectionQuestion: json['reflection_question'] as String? ?? '',
      image: json['image'] as String?,
      bilder: [for (final b in (json['bilder'] as List?) ?? const []) b as String],
      perspective: json['perspective'] as String?,
      spicy: json['spicy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'duration_min': durationMin,
        'linked_tool': linkedTool,
        'summary': summary,
        'content': content,
        'reflection_question': reflectionQuestion,
        'image': image,
        'bilder': bilder,
        'perspective': perspective,
        if (spicy) 'spicy': true,
      };
}

class SosCard {
  final String id;
  final String title;
  final String situation;
  final List<String> immediateSteps;
  final String mantra;

  SosCard({
    required this.id,
    required this.title,
    required this.situation,
    required this.immediateSteps,
    required this.mantra,
  });

  factory SosCard.fromJson(Map<String, dynamic> json) {
    return SosCard(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      situation: json['situation'] as String? ?? '',
      immediateSteps: (json['immediate_steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mantra: json['mantra'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'situation': situation,
        'immediate_steps': immediateSteps,
        'mantra': mantra,
      };
}

class BeliefCard {
  final String id;
  final String category;
  final String target; // "all" | "men" | "women" | "couples"
  final String irrationalThought;
  final String realityCheck;
  final String practicalShift;

  BeliefCard({
    required this.id,
    required this.category,
    this.target = 'all',
    required this.irrationalThought,
    required this.realityCheck,
    required this.practicalShift,
  });

  factory BeliefCard.fromJson(Map<String, dynamic> json) {
    return BeliefCard(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      target: json['target'] as String? ?? 'all',
      irrationalThought: json['irrational_thought'] as String? ?? '',
      realityCheck: json['reality_check'] as String? ?? '',
      practicalShift: json['practical_shift'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'target': target,
        'irrational_thought': irrationalThought,
        'reality_check': realityCheck,
        'practical_shift': practicalShift,
      };
}
