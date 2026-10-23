class VelvetDatabase {
  final String version;
  final List<Course> courses;
  final List<SosCard> sosCards;
  final List<BeliefCard> beliefLibrary;

  VelvetDatabase({
    required this.version,
    required this.courses,
    required this.sosCards,
    this.beliefLibrary = const [],
  });

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
        'courses': courses.map((e) => e.toJson()).toList(),
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
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.category = 'all',
    this.image,
    required this.lessons,
  });

  bool get isForWomen => category == 'women';
  bool get isForCouples => category == 'couples';
  bool get isForMen => category == 'men';

  String get targetBadgeLabel {
    if (id.contains('touch') || id.contains('omgyes')) {
      return isForWomen ? 'BERÜHRUNGSKUNST • FÜR SIE' : 'TAST-LABOR • FÜR IHN';
    }
    if (id == 'course_vocal_pelvic') {
      return 'STIMME & SOMATIK';
    }
    if (id == 'course_teasing_desire') {
      return 'HINHALTEN & VERLANGEN';
    }
    if (id == 'course_fantasies_shadow') {
      return 'POLARITÄT & ROLLEN';
    }
    if (id == 'course_body_acceptance') {
      return 'KÖRPER-PRÄSENZ';
    }
    switch (category) {
      case 'women':
        return 'FÜR SIE';
      case 'couples':
        return 'FÜR PAARE';
      case 'men':
        return 'FÜR IHN';
      default:
        return 'GRUNDLAGEN';
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
