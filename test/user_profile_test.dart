import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTest();
    await StorageService.init();
  });

  group('UserProfile.fromJson: Geschlecht', () {
    test('fehlender Schlüssel wird zu unspecified, nicht zu male', () {
      final p = UserProfile.fromJson({'name': 'A'});
      expect(p.gender, 'unspecified');
      expect(p.isMale, isFalse);
      expect(p.isFemale, isFalse);
    });

    test('unbekannte Werte und falsche Typen werden zu unspecified', () {
      expect(UserProfile.fromJson({'gender': 'xyz'}).gender, 'unspecified');
      expect(UserProfile.fromJson({'gender': 7}).gender, 'unspecified');
    });

    test('gespeicherte Werte bleiben', () {
      for (final g in ['male', 'female', 'other', 'unspecified']) {
        expect(UserProfile.fromJson({'gender': g}).gender, g);
      }
    });

    test('Hin- und Rückweg über toJson', () {
      final p = UserProfile(name: 'A', gender: 'unspecified', age: 30, relationshipStatus: 'single', primaryGoal: 'open');
      final q = UserProfile.fromJson(p.toJson());
      expect(q.gender, 'unspecified');
      expect(q.primaryGoal, 'open');
    });
  });

  group('UserProfile: Beschriftungen', () {
    UserProfile mit(String g, [String ziel = 'body_pleasure']) =>
        UserProfile(name: 'A', gender: g, age: 30, relationshipStatus: 'single', primaryGoal: ziel);

    test('genderLabel', () {
      expect(mit('female').genderLabel, t.onboardingFemale);
      expect(mit('male').genderLabel, t.onboardingMale);
      expect(mit('other').genderLabel, t.userProfileNonBinaryOpen);
      expect(mit('unspecified').genderLabel, t.partnerProfileDialogNotSpecified);
      expect(mit('irgendwas').genderLabel, t.partnerProfileDialogNotSpecified);
    });

    test('goalLabel kennt den neutralen Fokus open', () {
      expect(mit('female', 'open').goalLabel, t.userProfileJustLookingAround);
      expect(mit('female', 'couple_intimacy').goalLabel, t.userProfileCoupleIntimacyCloseness);
    });
  });
}
