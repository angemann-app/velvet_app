import '../l10n/t.dart';

/// Beispielfragen im KI-Coach, passend zu Profil und Gegenüber.
///
/// [geschlecht] und [partnerGeschlecht]: 'male', 'female' oder anderes. Ist das Gegenüber nicht bekannt
/// (kein Paar-Kanal), nehmen wir bei Mann und Frau das andere Geschlecht an; sonst bleibt es neutral.
List<String> coachVorschlaege({String? geschlecht, String? beziehung, String? partnerGeschlecht}) {
  final ich = geschlecht;
  if (beziehung == 'single') {
    return switch (ich) {
      'male' => [t.coachQKnowBody, t.coachQFemaleDesire, t.coachQMyPressure, t.aiCoachWhatToDoAboutRacing,
          t.aiCoachWhyDoesTheReverseKegel],
      'female' => [t.coachQKnowBody, t.coachQMaleDesire, t.aiCoachAsAWomanHowDo, t.aiCoachWhatToDoAboutRacing,
          t.aiCoachWhyDoesTheReverseKegel],
      _ => [t.coachQKnowBody, t.coachQShowTouch, t.aiCoachWhatToDoAboutRacing, t.coachQWishesLimits,
          t.aiCoachWhyDoesTheReverseKegel],
    };
  }
  final du = partnerGeschlecht ?? switch (ich) { 'male' => 'female', 'female' => 'male', _ => null };
  return switch ((ich, du)) {
    ('male', 'female') => [t.coachQHerOrgasm, t.coachQWomenRelax, t.coachQHerDesire, t.coachQAskHer,
        t.coachQMyPressure],
    ('female', 'male') => [t.aiCoachAsAWomanHowDo, t.coachQShowHim, t.aiCoachHowDoIExplainResponsive,
        t.coachQMenPressure, t.aiCoachWhatToDoAboutRacing],
    ('male', 'male') => [t.coachQMyPressure, t.coachQPleaseHim, t.coachQWishesLimits, t.aiCoachWhatToDoAboutRacing,
        t.coachQDesireGap],
    ('female', 'female') => [t.aiCoachAsAWomanHowDo, t.coachQHerTouch, t.coachQWishesLimits, t.coachQDesireGap,
        t.aiCoachWhatToDoAboutRacing],
    _ => [t.aiCoachHowCanWeStopPerformance, t.aiCoachWhatToDoAboutRacing, t.aiCoachHowDoIExplainResponsive,
        t.coachQShowTouch, t.aiCoachWhyDoesTheReverseKegel],
  };
}
