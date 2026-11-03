/// Ein Eintrag, der in den lokalen Suchindex aufgenommen werden kann.
///
/// Der Index selbst kennt keine Inhalts- oder Datenschutzregeln. Der Aufrufer
/// übergibt ausschließlich Einträge, die an dieser Stelle bereits erlaubt sind.
class SuchEintrag {
  SuchEintrag({
    required this.id,
    required this.titel,
    this.beschreibung = '',
    this.text = '',
    List<String> tags = const [],
  }) : tags = List<String>.unmodifiable(tags);

  final String id;
  final String titel;
  final String beschreibung;
  final String text;
  final List<String> tags;
}

/// Ein Treffer mit seinem Ranggewicht.
///
/// Höhere Gewichte stehen weiter vorn.
class SuchTreffer {
  const SuchTreffer({required this.eintrag, required this.gewicht});

  final SuchEintrag eintrag;
  final int gewicht;
}

/// Rein lokaler Suchindex über bereits freigegebene Einträge.
///
/// Die Anfrage wird in alphanumerische Wörter zerlegt. Jedes Wort muss in
/// mindestens einem Feld eines Eintrags vorkommen. Aus der Anfrage werden
/// keine regulären Ausdrücke ausgeführt.
class SuchIndex {
  SuchIndex(List<SuchEintrag> eintraege)
      : _vorbereitet = [
          for (final eintrag in eintraege) _VorbereiteterEintrag(eintrag),
        ];

  final List<_VorbereiteterEintrag> _vorbereitet;

  /// Liefert höchstens [grenze] Treffer, absteigend nach Gewicht.
  ///
  /// Bei Gleichstand bleibt die Reihenfolge der übergebenen Einträge erhalten.
  /// Eine leere oder wortlose Anfrage sowie [grenze] <= 0 ergeben eine leere
  /// Liste.
  List<SuchTreffer> suche(String frage, {int grenze = 30}) {
    if (grenze <= 0) return const <SuchTreffer>[];

    final woerter = _zerlegeInWoerter(_normalisiere(frage));
    if (woerter.isEmpty) return const <SuchTreffer>[];

    final eindeutigeWoerter = woerter.toSet().toList(growable: false);
    final bewertet = <_BewerteterTreffer>[];
    for (var position = 0; position < _vorbereitet.length; position++) {
      final eintrag = _vorbereitet[position];
      final gewicht = _bewerte(eintrag, eindeutigeWoerter);
      if (gewicht != null) {
        bewertet.add(
          _BewerteterTreffer(
            position: position,
            treffer: SuchTreffer(eintrag: eintrag.eintrag, gewicht: gewicht),
          ),
        );
      }
    }

    bewertet.sort((a, b) {
      final nachGewicht = b.treffer.gewicht.compareTo(a.treffer.gewicht);
      if (nachGewicht != 0) return nachGewicht;
      return a.position.compareTo(b.position);
    });

    final anzahl = bewertet.length < grenze ? bewertet.length : grenze;
    return List<SuchTreffer>.unmodifiable([
      for (var i = 0; i < anzahl; i++) bewertet[i].treffer,
    ]);
  }

  int? _bewerte(_VorbereiteterEintrag eintrag, List<String> woerter) {
    var gewicht = 0;
    for (final wort in woerter) {
      if (eintrag.titel.contains(wort)) {
        gewicht += _gewichtTitel;
      } else if (eintrag.nebenfelder.contains(wort)) {
        gewicht += _gewichtNebenfelder;
      } else if (eintrag.text.contains(wort)) {
        gewicht += _gewichtText;
      } else {
        return null;
      }
    }
    return gewicht;
  }
}

const int _gewichtTitel = 100;
const int _gewichtNebenfelder = 10;
const int _gewichtText = 1;

/// Ein Eintrag mit vorberechneten, normalisierten Feldern.
class _VorbereiteterEintrag {
  _VorbereiteterEintrag(SuchEintrag eintrag)
      : eintrag = eintrag,
        titel = _normalisiere(eintrag.titel),
        nebenfelder = _normalisiere(
          '${eintrag.beschreibung} ${eintrag.tags.join(' ')}',
        ),
        text = _normalisiere(eintrag.text);

  final SuchEintrag eintrag;
  final String titel;
  final String nebenfelder;
  final String text;
}

class _BewerteterTreffer {
  const _BewerteterTreffer({required this.position, required this.treffer});

  final int position;
  final SuchTreffer treffer;
}

/// Vereinheitlicht Groß-/Kleinschreibung, Umlaute, ß und lateinische Akzente.
String _normalisiere(String wert) {
  final puffer = StringBuffer();
  for (final zeichen in wert.toLowerCase().runes) {
    switch (zeichen) {
      // a
      case 0x00E0: // à
      case 0x00E1: // á
      case 0x00E2: // â
      case 0x00E3: // ã
      case 0x00E4: // ä
      case 0x00E5: // å
      case 0x0101: // ā
      case 0x0103: // ă
      case 0x0105: // ą
        puffer.write('a');
        break;
      // c
      case 0x00E7: // ç
      case 0x0107: // ć
      case 0x010D: // č
        puffer.write('c');
        break;
      // d
      case 0x00F0: // ð
      case 0x010F: // ď
      case 0x0111: // đ
        puffer.write('d');
        break;
      // e
      case 0x00E8: // è
      case 0x00E9: // é
      case 0x00EA: // ê
      case 0x00EB: // ë
      case 0x0113: // ē
      case 0x0115: // ĕ
      case 0x0117: // ė
      case 0x0119: // ę
      case 0x011B: // ě
        puffer.write('e');
        break;
      // g
      case 0x011D: // ĝ
      case 0x011F: // ğ
      case 0x0123: // ģ
        puffer.write('g');
        break;
      // i
      case 0x00EC: // ì
      case 0x00ED: // í
      case 0x00EE: // î
      case 0x00EF: // ï
      case 0x012B: // ī
      case 0x012D: // ĭ
      case 0x012F: // į
      case 0x0131: // ı
        puffer.write('i');
        break;
      // l
      case 0x013A: // ĺ
      case 0x013C: // ļ
      case 0x013E: // ľ
      case 0x0142: // ł
        puffer.write('l');
        break;
      // n
      case 0x00F1: // ñ
      case 0x0144: // ń
      case 0x0146: // ņ
      case 0x0148: // ň
        puffer.write('n');
        break;
      // o
      case 0x00F2: // ò
      case 0x00F3: // ó
      case 0x00F4: // ô
      case 0x00F5: // õ
      case 0x00F6: // ö
      case 0x00F8: // ø
      case 0x014D: // ō
      case 0x014F: // ŏ
      case 0x0151: // ő
        puffer.write('o');
        break;
      // r
      case 0x0155: // ŕ
      case 0x0159: // ř
        puffer.write('r');
        break;
      // s
      case 0x00DF: // ß
      case 0x1E9E: // ẞ
        puffer.write('ss');
        break;
      case 0x0161: // š
      case 0x015B: // ś
      case 0x015F: // ş
      case 0x0219: // ș
      case 0x017F: // ſ
        puffer.write('s');
        break;
      // t
      case 0x0163: // ţ
      case 0x0165: // ť
      case 0x021B: // ț
        puffer.write('t');
        break;
      // u
      case 0x00F9: // ù
      case 0x00FA: // ú
      case 0x00FB: // û
      case 0x00FC: // ü
      case 0x016B: // ū
      case 0x016D: // ŭ
      case 0x016F: // ů
      case 0x0171: // ű
      case 0x0173: // ų
        puffer.write('u');
        break;
      // y
      case 0x00FD: // ý
      case 0x00FF: // ÿ
      case 0x0177: // ŷ
        puffer.write('y');
        break;
      // z
      case 0x017A: // ź
      case 0x017C: // ż
      case 0x017E: // ž
        puffer.write('z');
        break;
      // Mehrzeichen
      case 0x00E6: // æ
        puffer.write('ae');
        break;
      case 0x0153: // œ
        puffer.write('oe');
        break;
      case 0x00FE: // þ
        puffer.write('th');
        break;
      default:
        // Zerlegte Akzente (kombinierende Zeichen) werden verworfen.
        if (zeichen < 0x0300 || zeichen > 0x036F) {
          puffer.writeCharCode(zeichen);
        }
    }
  }
  return puffer.toString();
}

/// Zerlegt Text an allen Zeichen, die nicht als Buchstabe oder Ziffer gelten.
List<String> _zerlegeInWoerter(String text) {
  final woerter = <String>[];
  final puffer = StringBuffer();
  for (final zeichen in text.runes) {
    if (_istWortzeichen(zeichen)) {
      puffer.writeCharCode(zeichen);
    } else if (puffer.length > 0) {
      woerter.add(puffer.toString());
      puffer.clear();
    }
  }
  if (puffer.length > 0) {
    woerter.add(puffer.toString());
  }
  return woerter;
}

/// Prüft ohne reguläre Ausdrücke, ob ein Zeichen zu einem Wort gehört.
bool _istWortzeichen(int zeichen) {
  if ((zeichen >= 0x30 && zeichen <= 0x39) ||
      (zeichen >= 0x41 && zeichen <= 0x5A) ||
      (zeichen >= 0x61 && zeichen <= 0x7A)) {
    return true;
  }
  if (zeichen >= 0x00C0 && zeichen <= 0x024F) {
    // Multiplikations- und Divisionszeichen sind keine Buchstaben.
    return zeichen != 0x00D7 && zeichen != 0x00F7;
  }
  if (zeichen >= 0x0370 && zeichen <= 0x03FF) return true;
  if (zeichen >= 0x0400 && zeichen <= 0x04FF) return true;
  if (zeichen >= 0x1E00 && zeichen <= 0x1EFF) return true;
  if ((zeichen >= 0x0660 && zeichen <= 0x0669) ||
      (zeichen >= 0x06F0 && zeichen <= 0x06F9) ||
      (zeichen >= 0x0966 && zeichen <= 0x096F)) {
    return true;
  }
  return false;
}
