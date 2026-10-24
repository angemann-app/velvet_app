// Beispielfragen im KI-Coach passen zu Profil und Gegenüber.
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/coach_vorschlaege.dart';

void main() {
  test('Mann in Beziehung bekommt Fragen zu Frauen, keine Frauen-Fragen über sich selbst', () {
    final fragen = coachVorschlaege(geschlecht: 'male', beziehung: 'relationship');
    expect(fragen, contains(t.coachQHerOrgasm));
    expect(fragen, isNot(contains(t.aiCoachAsAWomanHowDo)));
  });

  test('Frau in Beziehung bekommt ihre eigenen Fragen', () {
    final fragen = coachVorschlaege(geschlecht: 'female', beziehung: 'relationship');
    expect(fragen, contains(t.aiCoachAsAWomanHowDo));
    expect(fragen, contains(t.coachQShowHim));
  });

  test('Gleichgeschlechtliche Paare nach dem Gegenüber aus dem Paar-Kanal', () {
    expect(coachVorschlaege(geschlecht: 'male', beziehung: 'relationship', partnerGeschlecht: 'male'),
        allOf(contains(t.coachQPleaseHim), isNot(contains(t.coachQHerOrgasm))));
    expect(coachVorschlaege(geschlecht: 'female', beziehung: 'relationship', partnerGeschlecht: 'female'),
        allOf(contains(t.coachQHerTouch), isNot(contains(t.coachQShowHim))));
  });

  test('Singles und ohne Profil', () {
    expect(coachVorschlaege(geschlecht: 'male', beziehung: 'single'), contains(t.coachQFemaleDesire));
    expect(coachVorschlaege(geschlecht: 'female', beziehung: 'single'), contains(t.coachQMaleDesire));
    final neutral = coachVorschlaege();
    expect(neutral, hasLength(5));
    expect(neutral, isNot(contains(t.aiCoachAsAWomanHowDo)));
  });
}
