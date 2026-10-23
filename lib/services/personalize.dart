/// Personalisiert Lektionstexte mit dem Namen des Gegenübers.
///
/// Platzhalter im Text (assets/data/velvet_content.json und translations/en/):
///   {W:sie}    die Frau der Lektion, als Pronomen   → „Anna“
///   {W2:ihr}   die Frau der Lektion, besitzanzeigend → „Annas“ / engl. „Anna's“
///   {M:er}     der Mann der Lektion, als Pronomen    → „Lukas“
///   {M2:sein}  der Mann der Lektion, besitzanzeigend → „Lukas'“
///   {P:dein Gegenüber}  das Gegenüber, unabhängig vom Geschlecht → „Anna“
/// Hinter dem Doppelpunkt steht der neutrale Text; er wird angezeigt, wenn nichts bekannt ist,
/// und er ist genau das, was eingesprochen wurde (tools/generate_audio.py).
///
/// Ersetzt wird nur, wenn klar ist, dass die Person das Gegenüber ist:
/// - Lektionen aus Sicht der gebenden Person (Lektionsfeld "perspective": "giver", z. B. die
///   Yoni-Massage): „sie“ ist immer die empfangende Person, also das Gegenüber, sobald es eine
///   Frau ist – auch wenn man selbst eine Frau ist.
/// - Alle anderen: nur wenn das Gegenüber eine Frau ist und man selbst nicht, sonst wäre offen,
///   wer gemeint ist (z. B. „Wenn Sex wehtut“ bei zwei Frauen).
/// Für {M:…} entsprechend. Damit der Text nicht holprig wird, nennt {W}/{M} den Namen nur beim
/// ersten Vorkommen je Absatz; danach bleibt das Pronomen.
class PersonalizeContext {
  final String? partnerName;

  /// 'female', 'male', 'other' oder null.
  final String? partnerGender;
  final String? myGender;
  final bool english;
  final bool giverPerspective;

  const PersonalizeContext({
    this.partnerName,
    this.partnerGender,
    this.myGender,
    this.english = false,
    this.giverPerspective = false,
  });

  static const none = PersonalizeContext();

  PersonalizeContext forPerspective(String? perspective) => PersonalizeContext(
        partnerName: partnerName,
        partnerGender: partnerGender,
        myGender: myGender,
        english: english,
        giverPerspective: perspective == 'giver',
      );

  bool get _hasName => partnerName != null && partnerName!.trim().isNotEmpty && partnerName != 'Partner';
  bool get womanIsPartner => _hasName && partnerGender == 'female' && (giverPerspective || myGender != 'female');
  bool get manIsPartner => _hasName && partnerGender == 'male' && (giverPerspective || myGender != 'male');
}

final RegExp _token = RegExp(r'\{(W2|M2|W|M|P):([^{}]*)\}');

/// Für Audio, Übersetzungs-Prüfung und neutrale Anzeige: alle Platzhalter durch ihren Text ersetzen.
String stripPersonalization(String text) => text.replaceAllMapped(_token, (m) => m.group(2)!);

String personalize(String text, PersonalizeContext ctx) {
  final name = ctx.partnerName?.trim() ?? '';
  return text.split('\n').map((paragraph) {
    var womanNamed = false;
    var manNamed = false;
    return paragraph.replaceAllMapped(_token, (m) {
      final kind = m.group(1)!;
      final fallback = m.group(2)!;
      switch (kind) {
        case 'P':
          return ctx._hasName ? name : fallback;
        case 'W':
        case 'W2':
          if (!ctx.womanIsPartner || womanNamed) return fallback;
          womanNamed = true;
          return kind == 'W' ? name : _possessive(name, ctx.english);
        case 'M':
        case 'M2':
          if (!ctx.manIsPartner || manNamed) return fallback;
          manNamed = true;
          return kind == 'M' ? name : _possessive(name, ctx.english);
      }
      return fallback;
    });
  }).join('\n');
}

/// „Annas“, „Lukas'“ – im Englischen „Anna's“, „Lukas'“.
String _possessive(String name, bool english) {
  final last = name.isEmpty ? '' : name[name.length - 1].toLowerCase();
  if ('sßxz'.contains(last)) return "$name'";
  return english ? "$name's" : '${name}s';
}
