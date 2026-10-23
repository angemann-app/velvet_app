class UserProfile {
  final String name;
  final String gender; // 'male', 'female', 'other'
  final int age;
  final String relationshipStatus; // 'relationship', 'dating', 'single', 'complicated'
  final String primaryGoal; // 'performance_anxiety', 'pelvic_somatics', 'couple_intimacy', 'body_pleasure'

  UserProfile({
    required this.name,
    required this.gender,
    required this.age,
    required this.relationshipStatus,
    this.primaryGoal = 'performance_anxiety',
  });

  bool get isFemale => gender == 'female';
  bool get isMale => gender == 'male';
  bool get inRelationship => relationshipStatus == 'relationship';

  String get genderLabel {
    switch (gender) {
      case 'female':
        return 'Weiblich';
      case 'male':
        return 'Männlich';
      default:
        return 'Divers / Offen';
    }
  }

  String get relationshipLabel {
    switch (relationshipStatus) {
      case 'relationship':
        return 'In Beziehung / Verheiratet';
      case 'dating':
        return 'Dating / Kennenlernphase';
      case 'single':
        return 'Single';
      default:
        return 'Kompliziert';
    }
  }

  String get goalLabel {
    switch (primaryGoal) {
      case 'pelvic_somatics':
        return 'Beckenboden & Somatik';
      case 'couple_intimacy':
        return 'Paar-Intimität & Nähe';
      case 'body_pleasure':
        return 'Lust & Entspannung';
      default:
        return 'Leistungsdruck abbauen';
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'age': age,
        'relationship_status': relationshipStatus,
        'primary_goal': primaryGoal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'Gast',
        gender: json['gender'] as String? ?? 'male',
        age: (json['age'] as num?)?.toInt() ?? 30,
        relationshipStatus: json['relationship_status'] as String? ?? 'relationship',
        primaryGoal: json['primary_goal'] as String? ?? 'performance_anxiety',
      );
}
