import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/personalize.dart';

void main() {
  const anna = PersonalizeContext(partnerName: 'Anna', partnerGender: 'female', myGender: 'male');
  const lukas = PersonalizeContext(partnerName: 'Lukas', partnerGender: 'male', myGender: 'female');

  test('Name beim ersten Vorkommen je Absatz, danach das Pronomen', () {
    const text = '{W:Sie} liegt auf dem Rücken. Erst wenn {W2:ihr} Atem tief wird, geht es weiter.\n'
        'Phase drei – nur wenn {W:sie} es möchte.';
    expect(personalize(text, anna),
        'Anna liegt auf dem Rücken. Erst wenn ihr Atem tief wird, geht es weiter.\nPhase drei – nur wenn Anna es möchte.');
  });

  test('Ohne passendes Geschlecht oder ohne Namen bleibt der neutrale Text', () {
    const text = '{W:Sie} liegt, {M2:sein} Atem, {P:dein Gegenüber}.';
    const neutral = 'Sie liegt, sein Atem, dein Gegenüber.';
    expect(personalize(text, PersonalizeContext.none), neutral);
    expect(personalize(text, const PersonalizeContext(partnerName: 'Partner', partnerGender: 'female')), neutral);
    // Zwei Frauen: Wer „sie“ in der Lektion ist, bleibt offen.
    expect(personalize(text, const PersonalizeContext(partnerName: 'Mia', partnerGender: 'female', myGender: 'female')),
        'Sie liegt, sein Atem, Mia.');
    expect(stripPersonalization(text), neutral);
  });

  test('Gleichgeschlechtliche Paare: aus Sicht der gebenden Person ist „sie“ das Gegenüber', () {
    const mia = PersonalizeContext(partnerName: 'Mia', partnerGender: 'female', myGender: 'female');
    const tom = PersonalizeContext(partnerName: 'Tom', partnerGender: 'male', myGender: 'male');
    // Yoni-Massage (giver): die Partnerin wird genannt.
    expect(personalize('{W:Sie} liegt auf dem Rücken.', mia.forPerspective('giver')), 'Mia liegt auf dem Rücken.');
    // Lingam-Massage (giver) bei zwei Männern.
    expect(personalize('Wenn {M2:sein} Atem schneller wird', tom.forPerspective('giver')), 'Wenn Toms Atem schneller wird');
    // „Wenn Sex wehtut“ spricht die Frau selbst an: bei zwei Frauen bleibt es offen.
    expect(personalize('bestimmt {W:die Frau} alles', mia.forPerspective(null)), 'bestimmt die Frau alles');
    // Das Gegenüber ist ein Mann: in der Yoni-Massage gibt es keine Frau, die er sein könnte.
    expect(personalize('{W:Sie} liegt', tom.forPerspective('giver')), 'Sie liegt');
  });

  test('Lektionen aus Sicht der gebenden Person sind in DE und EN gleich gekennzeichnet', () {
    Map<String, String?> perspectives(String path) {
      final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      return {
        for (final c in data['courses'] as List)
          for (final l in c['lessons'] as List) l['id'] as String: l['perspective'] as String?,
      };
    }

    final de = perspectives('assets/data/velvet_content.json');
    expect(de['mass_2'], 'giver');
    expect(perspectives('translations/en/velvet_content.json'), de);
  });

  test('Besitzform', () {
    expect(personalize('{M2:Sein} Atem', lukas), "Lukas' Atem");
    expect(personalize('{W2:ihr} Atem', anna), 'Annas Atem');
    expect(personalize('{W2:her} breath',
        const PersonalizeContext(partnerName: 'Anna', partnerGender: 'female', myGender: 'male', english: true)),
        "Anna's breath");
  });

  test('Alle Platzhalter in den Inhalten sind wohlgeformt und gleich in DE und EN', () {
    final bad = RegExp(r'\{(?!(W2|M2|W|M|P):[^{}]*\})');
    Map<String, String> tokens(String path) {
      final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      return {
        for (final c in data['courses'] as List)
          for (final l in c['lessons'] as List)
            l['id'] as String: RegExp(r'\{(W2|M2|W|M|P):').allMatches(l['content'] as String).map((m) => m.group(1)).join(','),
      };
    }

    for (final path in ['assets/data/velvet_content.json', 'translations/en/velvet_content.json']) {
      final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      for (final c in data['courses'] as List) {
        for (final l in c['lessons'] as List) {
          final text = l['content'] as String;
          expect(bad.hasMatch(text) || text.contains('}') != text.contains('{'), isFalse,
              reason: 'Unvollständiger Platzhalter in ${l['id']} ($path)');
        }
      }
    }
    final de = tokens('assets/data/velvet_content.json');
    final en = tokens('translations/en/velvet_content.json');
    for (final id in de.keys) {
      // Gleiche Arten von Platzhaltern, damit die englische Fassung genauso personalisiert wird.
      expect((en[id] ?? '').split(',').toSet(), de[id]!.split(',').toSet(), reason: id);
    }
  });
}
