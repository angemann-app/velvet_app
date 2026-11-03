import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/such_index.dart';

SuchEintrag _eintrag(
  String id, {
  String titel = '',
  String beschreibung = '',
  String text = '',
  List<String> tags = const [],
}) {
  return SuchEintrag(
    id: id,
    titel: titel,
    beschreibung: beschreibung,
    text: text,
    tags: tags,
  );
}

List<String> _ids(List<SuchTreffer> treffer) {
  return [for (final eintrag in treffer) eintrag.eintrag.id];
}

void main() {
  group('Normalisierung', () {
    test('findet Umlaute unabhängig von der Schreibweise', () {
      final index = SuchIndex([
        _eintrag('umlaut', titel: 'Grüne Übung'),
        _eintrag('ohne', titel: 'Blauer Ablauf'),
      ]);

      expect(_ids(index.suche('GRUNE UBUNG')), ['umlaut']);
      expect(_ids(index.suche('grüne übung')), ['umlaut']);
      expect(_ids(index.suche('GRÜNE')), ['umlaut']);
    });

    test('behandelt ß wie ss', () {
      final index = SuchIndex([
        _eintrag('strasse', titel: 'Straße am See'),
        _eintrag('anderes', titel: 'Weg am Fluss'),
      ]);

      expect(_ids(index.suche('STRASSE SEE')), ['strasse']);
      expect(_ids(index.suche('straße')), ['strasse']);
    });

    test('entfernt häufige lateinische Akzente', () {
      final index = SuchIndex([
        _eintrag('cafe', titel: 'Café Naïve'),
        _eintrag('anderes', titel: 'Tee am Fenster'),
      ]);

      expect(_ids(index.suche('cafe naive')), ['cafe']);
      expect(_ids(index.suche('CAFÉ NAÏVE')), ['cafe']);
    });
  });

  group('Mehrwort-Anfragen', () {
    test('verlangt jedes Wort in mindestens einem Feld', () {
      final index = SuchIndex([
        _eintrag('a', titel: 'Apfel', text: 'Der Baum steht im Garten.'),
        _eintrag('b', titel: 'Apfel', text: 'Die Birne liegt in der Schale.'),
        _eintrag('c', titel: 'Pflaume', text: 'Der Baum trägt Früchte.'),
      ]);

      expect(_ids(index.suche('apfel baum')), ['a']);
      expect(_ids(index.suche('apfel')), ['a', 'b']);
      expect(_ids(index.suche('baum birne')), isEmpty);
    });

    test('zählt doppelte Wörter nur einmal', () {
      final index = SuchIndex([
        _eintrag('a', titel: 'Apfel'),
        _eintrag('b', titel: 'Apfel'),
      ]);

      expect(_ids(index.suche('apfel apfel')), ['a', 'b']);
    });
  });

  group('Rangfolge', () {
    test('Titel vor Beschreibung und Tags vor Fließtext', () {
      final index = SuchIndex([
        _eintrag('text', text: 'Licht'),
        _eintrag('tag', tags: const ['Licht']),
        _eintrag('beschreibung', beschreibung: 'Licht'),
        _eintrag('titel', titel: 'Licht'),
      ]);

      final treffer = index.suche('licht');

      expect(_ids(treffer), ['titel', 'tag', 'beschreibung', 'text']);
      expect(treffer[0].gewicht, greaterThan(treffer[1].gewicht));
      expect(treffer[1].gewicht, greaterThan(treffer[3].gewicht));
    });

    test('behält bei Gleichstand die Reihenfolge der Eingabe', () {
      final index = SuchIndex([
        _eintrag('zuerst', titel: 'Licht'),
        _eintrag('danach', titel: 'Licht'),
      ]);

      expect(_ids(index.suche('licht')), ['zuerst', 'danach']);
    });

    test('behält Gleichstand auch bei Beschreibung und Tags', () {
      final index = SuchIndex([
        _eintrag('tag', tags: const ['Licht']),
        _eintrag('beschreibung', beschreibung: 'Licht'),
      ]);

      expect(_ids(index.suche('licht')), ['tag', 'beschreibung']);
    });
  });

  group('Grenze', () {
    final index = SuchIndex([
      for (var i = 0; i < 35; i++) _eintrag('e$i', titel: 'Licht'),
    ]);

    test('liefert standardmäßig höchstens 30 Treffer', () {
      expect(index.suche('licht'), hasLength(30));
    });

    test('schneidet auf die angegebene Grenze ab', () {
      expect(_ids(index.suche('licht', grenze: 2)), ['e0', 'e1']);
    });

    test('liefert bei einer Grenze von null oder weniger nichts', () {
      expect(index.suche('licht', grenze: 0), isEmpty);
      expect(index.suche('licht', grenze: -5), isEmpty);
    });
  });

  group('Sonderzeichen', () {
    final index = SuchIndex([
      _eintrag('apfel', titel: 'Apfel'),
      _eintrag('birne', titel: 'Birne'),
    ]);

    test('leere und wortlose Anfragen ergeben nichts', () {
      expect(index.suche(''), isEmpty);
      expect(index.suche('   '), isEmpty);
      expect(index.suche('!!! ??? ... ---'), isEmpty);
      expect(SuchIndex(const []).suche('apfel'), isEmpty);
    });

    test('trennt Satzzeichen ab', () {
      expect(_ids(index.suche('(apfel)')), ['apfel']);
      expect(_ids(index.suche('"apfel"')), ['apfel']);
    });

    test('führt keine regulären Ausdrücke aus der Anfrage aus', () {
      expect(index.suche('apfel|birne'), isEmpty);
      expect(index.suche('apfel.*birne'), isEmpty);
      expect(_ids(index.suche('Apfel, Birne!')), isEmpty);
      expect(index.suche('.*'), isEmpty);
    });
  });
}
