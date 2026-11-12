import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/data/sos_anlaufstellen.dart';
import 'package:velvetpulse/models/content_models.dart';

List<SosCard> _karten(String pfad) {
  final json = jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;
  return (json['sos_cards'] as List).map((e) => SosCard.fromJson(e as Map<String, dynamic>)).toList();
}

String _alles(SosCard k) => [k.title, k.intro, ...k.steps, ...k.phrases, k.closing].join('\n');

void main() {
  final de = _karten('assets/data/velvet_content.json');
  final en = _karten('translations/en/velvet_content.json');

  test('SOS-Karten: Aufbau und Gleichlauf Deutsch/Englisch', () {
    expect(de.length, 6);
    expect(en.map((k) => k.id), de.map((k) => k.id));
    for (final listen in [de, en]) {
      for (final k in listen) {
        expect(k.title, isNotEmpty, reason: k.id);
        expect(k.intro, isNotEmpty, reason: k.id);
        expect(k.steps.length, inInclusiveRange(3, 4), reason: k.id);
        expect(k.phrases, isNotEmpty, reason: k.id);
        expect(k.closing, isNotEmpty, reason: k.id);
      }
    }
    for (var i = 0; i < de.length; i++) {
      expect(en[i].steps.length, de[i].steps.length, reason: de[i].id);
      expect(en[i].phrases.length, de[i].phrases.length, reason: de[i].id);
      expect(en[i].toHelp, de[i].toHelp, reason: de[i].id);
    }
    expect(de.where((k) => k.toHelp).map((k) => k.id), ['sos_nichtmehr', 'sos_danach']);
  });

  test('SOS-Karten: keine alten Muster (Coach, Befehlston, Fachjargon, Rollenbilder)', () {
    final verboten = RegExp(
      r'Coach|Mantra|Down-Regulation|Sympathikus|KVT|Liebhaber|Stoßen|verboten|Rückzugs|vorspiel|Penetration|coach|lover|thrust|sympathetic',
    );
    for (final k in [...de, ...en]) {
      expect(verboten.hasMatch(_alles(k)), isFalse, reason: '${k.id}: ${verboten.firstMatch(_alles(k))?.group(0)}');
    }
  });

  test('Anlaufstellen: jede hat Land, Nummer, Anzeige; jedes Land hat Notruf und Stellen', () {
    for (final s in sosStellen) {
      expect(RegExp(r'^\+?[0-9]+$').hasMatch(s.tel), isTrue, reason: s.id);
      expect(s.anzeige, isNotEmpty);
      if (s.web != null) expect(s.web, startsWith('https://'));
    }
    for (final l in SosLand.values) {
      expect(sosNotrufTel[l], isNotNull);
      expect(sosStellen.where((s) => s.land == l), isNotEmpty, reason: '$l');
    }
    expect(sosAnlaufstellenStand, matches(RegExp(r'^\d{2}/\d{4}$')));
    // Jede Stelle braucht eigene Texte in der Oberfläche (sonst greift in sos_modal.dart ein Rückfall).
    const bekannt = {'DeFrauen', 'DeMaenner', 'DeWeisser', 'DeSeelsorge', 'AtFrauen', 'AtGewaltschutz', 'ChOpferhilfe', 'UkRape', 'UsRainn', 'Us988'};
    expect(sosStellen.map((s) => s.id).toSet(), bekannt);
  });
}
