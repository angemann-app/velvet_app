import '../models/content_models.dart';
import 'such_index.dart';

/// Nur öffentliche, bereits gefilterte Inhalte. Kein Zugriff auf gespeicherte
/// Antworten, Tagebücher, Paar-Nachrichten.
class InhaltSuche {
  final List<Course> kurse;
  final List<SuchEintrag> angebote;
  late final SuchIndex index = SuchIndex([
    ...angebote,
    for (final kurs in kurse) ...[
      SuchEintrag(
          id: 'kurs:${kurs.id}',
          titel: kurs.title,
          beschreibung: kurs.subtitle),
      for (final lektion in kurs.lessons)
        SuchEintrag(
            id: 'lektion:${lektion.id}',
            titel: lektion.title,
            beschreibung: lektion.summary,
            text: lektion.content,
            tags: [kurs.title]),
    ],
  ]);

  InhaltSuche({required List<Course> kurse, this.angebote = const []})
      : kurse = List.unmodifiable(kurse);
}
