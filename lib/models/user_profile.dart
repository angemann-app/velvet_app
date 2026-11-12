
import '../l10n/t.dart';class UserProfile {
  final String name;
  final String gender; // 'male', 'female', 'other' (Divers), 'unspecified' (Keine Angabe; auch Standard bei Altdaten ohne Wert)
  final int age;
  final String relationshipStatus; // 'relationship', 'dating', 'single', 'complicated'
  final String primaryGoal; // 'performance_anxiety', 'pelvic_somatics', 'couple_intimacy', 'body_pleasure'; 'open' = Erstmal umsehen (nur beim Überspringen, keine Kachel)

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
        return t.onboardingFemale;
      case 'male':
        return t.onboardingMale;
      case 'other':
        return t.userProfileNonBinaryOpen;
      default:
        return t.partnerProfileDialogNotSpecified;
    }
  }

  String get relationshipLabel {
    switch (relationshipStatus) {
      case 'relationship':
        return t.userProfileInARelationshipMarried;
      case 'dating':
        return t.userProfileDatingGettingToKnowSomeone;
      case 'single':
        return t.userProfileSingle;
      default:
        return t.userProfileComplicated;
    }
  }

  String get goalLabel {
    switch (primaryGoal) {
      case 'pelvic_somatics':
        return t.userProfilePelvicFloorBody;
      case 'couple_intimacy':
        return t.userProfileCoupleIntimacyCloseness;
      case 'body_pleasure':
        return t.userProfileDesireRelaxation;
      case 'open':
        return t.userProfileJustLookingAround;
      default:
        return t.userProfileEasingPerformancePressure;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'age': age,
        'relationship_status': relationshipStatus,
        'primary_goal': primaryGoal,
      };

  /// Gespeicherte Werte bleiben; fehlende oder unbekannte werden zu 'unspecified'.
  static String _normGender(Object? roh) {
    const erlaubt = {'male', 'female', 'other', 'unspecified'};
    return roh is String && erlaubt.contains(roh) ? roh : 'unspecified';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? t.onboardingGuest,
        gender: _normGender(json['gender']),
        age: (json['age'] as num?)?.toInt() ?? 30,
        relationshipStatus: json['relationship_status'] as String? ?? 'relationship',
        primaryGoal: json['primary_goal'] as String? ?? 'performance_anxiety',
      );
}
