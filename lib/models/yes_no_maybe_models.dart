import 'package:flutter/material.dart';
import '../l10n/t.dart';

enum YesNoMaybeVote {
  yes,
  maybe,
  no;

  static YesNoMaybeVote? fromString(String? val) {
    if (val == 'yes') return YesNoMaybeVote.yes;
    if (val == 'maybe') return YesNoMaybeVote.maybe;
    if (val == 'no') return YesNoMaybeVote.no;
    return null;
  }

  String get key => name;

  String get label {
    switch (this) {
      case YesNoMaybeVote.yes:
        return t.yesNoMaybeYes;
      case YesNoMaybeVote.maybe:
        return t.yesNoMaybeMaybe;
      case YesNoMaybeVote.no:
        return t.yesNoMaybeNo;
    }
  }

  String get description {
    switch (this) {
      case YesNoMaybeVote.yes:
        return t.yesNoMaybeModelsExcitesMeIDLike;
      case YesNoMaybeVote.maybe:
        return t.yesNoMaybeModelsCuriousButUnsureDependsOn;
      case YesNoMaybeVote.no:
        return t.yesNoMaybeModelsNotForMe;
    }
  }

  Color get color {
    switch (this) {
      case YesNoMaybeVote.yes:
        return const Color(0xFF10B981);
      case YesNoMaybeVote.maybe:
        return const Color(0xFFF59E0B);
      case YesNoMaybeVote.no:
        return const Color(0xFFF43F5E);
    }
  }

  IconData get icon {
    switch (this) {
      case YesNoMaybeVote.yes:
        return Icons.check_circle_rounded;
      case YesNoMaybeVote.maybe:
        return Icons.help_outline_rounded;
      case YesNoMaybeVote.no:
        return Icons.cancel_outlined;
    }
  }
}

class YesNoMaybeItem {
  /// Stabile Kennung: wird gespeichert und mit dem Partner abgeglichen – nie ändern.
  final String id;
  final String text;

  /// Erklärung für „Mehr erfahren“: was gemeint ist, wie man anfängt, worauf man achtet.
  final String explanation;

  /// Passende Lektion zum Weiterlesen (Lektions-ID aus velvet_content.json).
  final String? lessonId;

  /// Optionale Anleitungsgrafik.
  final String? image;
  final String categoryId;

  const YesNoMaybeItem({
    required this.id,
    required this.text,
    required this.explanation,
    required this.categoryId,
    this.lessonId,
    this.image,
  });
}

class YesNoMaybeCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String image;
  final List<YesNoMaybeItem> items;

  const YesNoMaybeCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
    required this.items,
  });
}

const String _imgUmkreisen = 'assets/images/diagram_umkreisen.svg';
const String _imgWellen = 'assets/images/diagram_wellen.svg';
const String _imgYoni = 'assets/images/diagram_yoni_clock.svg';
const String _imgLingam = 'assets/images/diagram_lingam_zones.svg';
const String _imgCat = 'assets/images/diagram_cat_position.svg';

const List<YesNoMaybeCategory> velvetYesNoMaybeCategories = [
  YesNoMaybeCategory(
    id: 'sensory_basics',
    title: 'Sinnlichkeit & Sinne',
    description: 'Wärme, Kälte, Haut, Duft und Klang – Genuss ohne Ziel.',
    icon: Icons.spa_rounded,
    image: 'assets/images/ynm_sensory_basics.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_1',
        categoryId: 'sensory_basics',
        text: 'Langsame Ganzkörper-Massage mit warmem Öl',
        explanation:
            'Eine Person liegt, die andere massiert – ganz langsam, mit angewärmtem Öl und ohne Ziel. '
            'Rücken, Beine, Bauch, Hände. Es geht ums Spüren, nicht ums Vorspiel. '
            'Ob die Massage intim wird, bestimmt die empfangende Person.',
        lessonId: 'mass_1',
      ),
      YesNoMaybeItem(
        id: 'item_2',
        categoryId: 'sensory_basics',
        text: 'Spiel mit Wärme und Kälte',
        explanation:
            'Abwechselnd ein gekühlter Löffel, warmes Öl, ein warmer Atemhauch. Der Kontrast macht die Haut wach. '
            'Eis nie direkt auf Schleimhäute und nie lange auf einer Stelle.',
        lessonId: 'scen_1',
      ),
      YesNoMaybeItem(
        id: 'item_3',
        categoryId: 'sensory_basics',
        text: 'Mit verbundenen Augen berührt werden',
        explanation:
            'Ohne Sehen werden Tasten und Hören intensiver, und der Kopf hat weniger zu bewerten. '
            'Die Augenbinde muss sich jederzeit selbst abnehmen lassen.',
        lessonId: 'scen_1',
      ),
      YesNoMaybeItem(
        id: 'item_4',
        categoryId: 'sensory_basics',
        text: 'Gemeinsam summen oder tönen, um zur Ruhe zu kommen',
        explanation:
            'Ein tiefer gemeinsamer Ton löst Kiefer, Atem und Beckenboden. Klingt ungewohnt, verbindet aber stark – '
            'und ein Lachen dabei ist ausdrücklich erlaubt.',
        lessonId: 'vocal_2',
      ),
      YesNoMaybeItem(
        id: 'item_5',
        categoryId: 'sensory_basics',
        text: 'Mit Feder oder weichem Pinsel gestreichelt werden',
        explanation:
            'Federleichte Berührung an Hals, Armen, Rücken oder Innenschenkeln. Kitzelig oder elektrisierend – '
            'das findet man nur heraus, indem man es probiert.',
      ),
      YesNoMaybeItem(
        id: 'item_23',
        categoryId: 'sensory_basics',
        text: 'Zusammen baden oder duschen',
        explanation:
            'Warmes Wasser entspannt, Haut auf Haut wird selbstverständlich. Ein guter Einstieg für alle, '
            'denen Nacktheit im Bett noch schwerfällt.',
      ),
      YesNoMaybeItem(
        id: 'item_24',
        categoryId: 'sensory_basics',
        text: 'Einen Abend bewusst gestalten: Licht, Musik, Duft',
        explanation:
            'Kerzen statt Deckenlicht, eine gemeinsame Playlist, ein angenehmer Duft. Ein vorbereiteter Raum sagt dem '
            'Nervensystem: Jetzt ist Zeit für uns.',
      ),
      YesNoMaybeItem(
        id: 'item_25',
        categoryId: 'sensory_basics',
        text: 'Streicheln am ganzen Körper – ohne Genitalien',
        explanation:
            'Die Grundübung des Sensate Focus: Ihr berührt euch überall, nur Brüste und Genitalien bleiben ausgespart. '
            'Das nimmt jeden Druck heraus und schärft die Wahrnehmung.',
        lessonId: 'couples_1',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'communication_mind',
    title: 'Worte & Kommunikation',
    description: 'Sprechen, flüstern, schreiben – Worte als Berührung.',
    icon: Icons.record_voice_over_rounded,
    image: 'assets/images/ynm_communication_mind.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_6',
        categoryId: 'communication_mind',
        text: 'Beim Berühren laut sagen, was man spürt',
        explanation:
            'Nichts erfinden, nur beschreiben: „Ich mag, wie warm du hier bist.“ Wer ausspricht, was gerade passiert, '
            'ist ganz im Moment und nicht im Kopf.',
        lessonId: 'scen_3',
      ),
      YesNoMaybeItem(
        id: 'item_7',
        categoryId: 'communication_mind',
        text: 'Kleine erotische Nachrichten oder Funken im Alltag',
        explanation:
            'Ein Satz am Vormittag, ein Funke über den Paar-Kanal. Vorfreude über den Tag verteilt – ohne Versprechen, '
            'dass daraus abends etwas werden muss.',
        lessonId: 'tease_1',
      ),
      YesNoMaybeItem(
        id: 'item_8',
        categoryId: 'communication_mind',
        text: 'Einander erotische Szenen vorlesen oder schreiben',
        explanation:
            'Eine kurze Szene schreiben und dem anderen vorlesen – oder gemeinsam eine erotische Geschichte lesen. '
            'Worte wirken direkt aufs Kopfkino.',
        lessonId: 'fant_2',
      ),
      YesNoMaybeItem(
        id: 'item_9',
        categoryId: 'communication_mind',
        text: '„Sag mir, was du willst“ – Wünsche laut aussprechen',
        explanation:
            'Mitten im Moment innehalten und den anderen bitten, seinen Wunsch auszusprechen. Eine Einladung, '
            'keine Prüfung: „Ich weiß es gerade nicht“ ist auch eine gute Antwort.',
        lessonId: 'scen_3',
      ),
      YesNoMaybeItem(
        id: 'item_26',
        categoryId: 'communication_mind',
        text: 'Ampel-Wörter: Grün, Gelb, Rot',
        explanation:
            'Drei einfache Wörter für zwischendurch: Grün heißt „weiter so“, Gelb „langsamer oder anders“, '
            'Rot „stopp“. Macht Rückmeldung leicht, ohne die Stimmung zu brechen.',
        lessonId: 'couples_3',
      ),
      YesNoMaybeItem(
        id: 'item_27',
        categoryId: 'communication_mind',
        text: 'Komplimente und Lob im Bett',
        explanation:
            'Sagen, was einem am anderen gefällt – am Körper, an der Art, an einer Berührung. '
            'Für viele ist das erregender als jedes Spielzeug.',
      ),
      YesNoMaybeItem(
        id: 'item_28',
        categoryId: 'communication_mind',
        text: 'Fantasien erzählen, ohne sie umzusetzen',
        explanation:
            'Eine Fantasie ist ein Bild im Kopf, kein Auftrag. Sie zu teilen kann sehr verbindend sein – '
            'ob je etwas davon Wirklichkeit wird, ist eine ganz andere Frage.',
        lessonId: 'fant_2',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'touch_techniques',
    title: 'Berührung & Hände',
    description: 'Techniken für Vulva und Penis – langsam, bewusst, zum Genießen.',
    icon: Icons.back_hand_rounded,
    image: 'assets/images/ynm_touch_techniques.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_29',
        categoryId: 'touch_techniques',
        text: 'Umkreisen: erst die Umgebung, dann das Zentrum',
        explanation:
            'Statt direkt auf die empfindlichste Stelle zu gehen, wandert die Hand in weiten Kreisen um sie herum. '
            'Bei der Vulva über Venushügel und Schamlippen, beim Penis über Wurzel, Leisten und Damm. '
            'Die Spitze wird so von selbst empfänglicher.',
        lessonId: 'touch_w_2',
        image: _imgUmkreisen,
      ),
      YesNoMaybeItem(
        id: 'item_30',
        categoryId: 'touch_techniques',
        text: 'Flache Finger statt Fingerspitze',
        explanation:
            'Zwei Finger liegen flach und weich auf, statt punktuell zu reiben. Das fühlt sich für viele satt und sicher an '
            'statt spitz und grell – gilt für Klitoris wie für das Bändchen am Penis.',
        lessonId: 'touch_w_2',
        image: _imgUmkreisen,
      ),
      YesNoMaybeItem(
        id: 'item_31',
        categoryId: 'touch_techniques',
        text: 'Wenn es gut ist: genau so weitermachen',
        explanation:
            'Wenn eine Berührung wirkt, bleiben Tempo, Druck und Stelle gleich – nicht schneller, nicht fester. '
            'Ein häufiger Wunsch, der selten erfüllt wird.',
        lessonId: 'touch_w_1',
      ),
      YesNoMaybeItem(
        id: 'item_32',
        categoryId: 'touch_techniques',
        text: 'Wellen: Erregung steigen und wieder sinken lassen',
        explanation:
            'Kurz vor dem Höhepunkt Tempo herausnehmen, ruhig atmen, die Erregung etwas sinken lassen und wieder aufbauen. '
            'Oft wird der Höhepunkt danach tiefer – und er muss gar nicht kommen.',
        lessonId: 'touch_w_3',
        image: _imgWellen,
      ),
      YesNoMaybeItem(
        id: 'item_33',
        categoryId: 'touch_techniques',
        text: 'Offene, eingeölte Hand am Penis statt fester Faust',
        explanation:
            'Mit viel Gleitmittel und der flachen Hand oder beiden Händen links und rechts am Schaft. '
            'Feiner als der gewohnte Griff – und genau das schärft die Empfindung wieder.',
        lessonId: 'touch_m_1',
      ),
      YesNoMaybeItem(
        id: 'item_34',
        categoryId: 'touch_techniques',
        text: 'Wurzel, Hoden und Damm mit einbeziehen',
        explanation:
            'Ein großer Teil der Schwellkörper liegt verborgen unter Schambein und Damm. Berührung dort macht Erregung '
            'breiter und ruhiger, statt sie an der Spitze zu bündeln.',
        lessonId: 'touch_m_2',
        image: _imgLingam,
      ),
      YesNoMaybeItem(
        id: 'item_35',
        categoryId: 'touch_techniques',
        text: 'Einander zeigen, wie man sich selbst berührt',
        explanation:
            'Die schnellste Art zu lernen, was der andere mag: zuschauen, wie er oder sie es selbst macht – '
            'oder die eigene Hand auf die Hand des anderen legen und führen.',
        lessonId: 'self_4',
      ),
      YesNoMaybeItem(
        id: 'item_63',
        categoryId: 'touch_techniques',
        text: 'Mehrere ruhige Reize gleichzeitig',
        explanation:
            'Eine gleichmäßige Bewegung außen, ruhiger Halt von innen oder eine schwere Hand auf Bauch oder Brust, '
            'dazu ein hörbarer Atem. Viel Fülle lässt dem grübelnden Kopf keinen Platz.',
        lessonId: 'touch_w_4',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'mouth_kissing',
    title: 'Mund & Küssen',
    description: 'Lippen, Zunge und Atem – vom Kuss bis zur oralen Verwöhnung.',
    icon: Icons.favorite_rounded,
    image: 'assets/images/ynm_mouth_kissing.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_36',
        categoryId: 'mouth_kissing',
        text: 'Lange, langsame Küsse – ohne dass mehr daraus werden muss',
        explanation:
            'Küssen als eigenes Ereignis, nicht als Auftakt. Wer sich Zeit nimmt, merkt oft erst, wie viel Erregung allein '
            'im Mund und im Atem steckt.',
        lessonId: 'tease_1',
      ),
      YesNoMaybeItem(
        id: 'item_37',
        categoryId: 'mouth_kissing',
        text: 'Mit Lippen und Zunge verwöhnt werden (Vulva)',
        explanation:
            'Langsam, mit flacher, weicher Zunge, erst rund um die Klitoris statt direkt darauf. '
            'Gleichmäßigkeit schlägt Tempo. Die empfangende Person führt.',
        lessonId: 'touch_w_2',
        image: _imgUmkreisen,
      ),
      YesNoMaybeItem(
        id: 'item_38',
        categoryId: 'mouth_kissing',
        text: 'Mit Lippen und Zunge verwöhnt werden (Penis)',
        explanation:
            'Mit Zeit und ohne Ziel: Lippen, Zunge und Hand im Wechsel, Wurzel und Hoden einbezogen. '
            'Ein Samenerguss ist kein Muss – sprecht vorher ab, was okay ist.',
        lessonId: 'mass_3',
      ),
      YesNoMaybeItem(
        id: 'item_39',
        categoryId: 'mouth_kissing',
        text: 'Küsse am ganzen Körper: Hals, Rücken, Innenschenkel',
        explanation:
            'Langsam über den Körper wandern und Stellen entdecken, die sonst vergessen werden – Nacken, Kniekehlen, '
            'die Haut über dem Becken.',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'positions_movement',
    title: 'Stellungen & Bewegung',
    description: 'Wiegen statt Stoßen – Positionen für Nähe und Entspannung.',
    icon: Icons.sync_rounded,
    image: 'assets/images/ynm_positions_movement.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_22',
        categoryId: 'positions_movement',
        text: 'Hohe Verschmelzung: wiegen statt stoßen',
        explanation:
            'In der Missionarsstellung rutscht er etwas höher, sodass sein Schambein flächig auf der Klitoris liegt. '
            'Statt Rein und Raus ein gleichmäßiges Wiegen – mehr Kontakt, weniger Druck.',
        lessonId: 'pos_1',
        image: _imgCat,
      ),
      YesNoMaybeItem(
        id: 'item_40',
        categoryId: 'positions_movement',
        text: 'Löffelchen: seitlich und eng aneinander',
        explanation:
            'Beide liegen auf der Seite, niemand muss Gewicht halten. Die vordere Hand ist frei für Brust oder Klitoris. '
            'Ideal für langsame, entspannte Momente.',
        lessonId: 'pos_2',
      ),
      YesNoMaybeItem(
        id: 'item_41',
        categoryId: 'positions_movement',
        text: 'Oben sitzen und das Becken kreisen lassen',
        explanation:
            'Wer oben ist, bestimmt Tempo, Tiefe und Winkel. Kreisen und Reiben statt Auf und Ab fühlt sich für viele '
            'intensiver an und ist für beide entspannter.',
        lessonId: 'pos_2',
      ),
      YesNoMaybeItem(
        id: 'item_42',
        categoryId: 'positions_movement',
        text: 'Sex in Zeitlupe',
        explanation:
            'Das gewohnte Tempo auf ein Zehntel drosseln. Jede Bewegung wird einzeln spürbar, und der Druck, '
            'zu früh zu kommen, wird leiser.',
        lessonId: 'tease_2',
      ),
      YesNoMaybeItem(
        id: 'item_43',
        categoryId: 'positions_movement',
        text: 'Ineinander ruhen, ohne sich zu bewegen',
        explanation:
            'Verbunden bleiben und einfach atmen, küssen, spüren. Klingt unspektakulär – ist für viele einer der '
            'intimsten Momente überhaupt.',
        lessonId: 'pos_1',
      ),
      YesNoMaybeItem(
        id: 'item_44',
        categoryId: 'positions_movement',
        text: 'Sie bestimmt beim Eindringen jeden Millimeter',
        explanation:
            'Er bewegt sich nicht, sie führt und sinkt in ihrem Tempo. Besonders hilfreich bei einem angespannten '
            'Beckenboden oder wenn Eindringen schon einmal wehgetan hat.',
        lessonId: 'pos_3',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'power_dynamics',
    title: 'Führung & Hingabe',
    description: 'Wer führt, wer empfängt – Spiel mit Kontrolle, immer einvernehmlich.',
    icon: Icons.lock_rounded,
    image: 'assets/images/ynm_power_dynamics.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_10',
        categoryId: 'power_dynamics',
        text: 'Handgelenke sanft festhalten lassen',
        explanation:
            'Die Hände liegen über dem Kopf und dürfen sich nicht bewegen – das nimmt vielen den Leistungsdruck. '
            'Anfangs nur mit den Händen des anderen; Tücher nur locker und nie am Hals.',
        lessonId: 'scen_2',
      ),
      YesNoMaybeItem(
        id: 'item_11',
        categoryId: 'power_dynamics',
        text: 'Klare Anweisungen bekommen',
        explanation:
            '„Leg dich hin.“ „Nicht bewegen.“ Ruhige, bestimmte Ansagen geben Halt und nehmen Entscheidungen ab. '
            'Vorher besprechen, welcher Ton angenehm ist.',
        lessonId: 'fant_1',
      ),
      YesNoMaybeItem(
        id: 'item_12',
        categoryId: 'power_dynamics',
        text: 'Die Kontrolle ganz abgeben',
        explanation:
            'Für eine vereinbarte Zeit nichts entscheiden müssen, nur empfangen. Mit Stoppwort und einem Zeichen ohne Worte, '
            'das sofort gilt.',
        lessonId: 'fant_1',
      ),
      YesNoMaybeItem(
        id: 'item_13',
        categoryId: 'power_dynamics',
        text: 'Die Führung übernehmen',
        explanation:
            'Du bestimmst Tempo und Ablauf und liest genau, wie dein Gegenüber reagiert. Wer führt, trägt Verantwortung: '
            'zwischendurch nachfragen, Stoppwort achten.',
        lessonId: 'fant_1',
      ),
      YesNoMaybeItem(
        id: 'item_45',
        categoryId: 'power_dynamics',
        text: 'Leichte Klapse auf den Po',
        explanation:
            'Spielerisch, mit flacher Hand und nur auf die fleischigen Stellen des Pos – nie auf Wirbelsäule oder Nieren. '
            'Langsam steigern und auf Rückmeldung achten.',
      ),
      YesNoMaybeItem(
        id: 'item_46',
        categoryId: 'power_dynamics',
        text: 'Der andere bestimmt, wann der Höhepunkt kommen darf',
        explanation:
            'Ein Spiel mit Hinhalten: Die führende Person lässt die Erregung mehrmals steigen und wieder sinken, '
            'bevor sie „jetzt“ sagt. Verbindet Wellen-Technik mit Hingabe.',
        lessonId: 'touch_m_3',
        image: _imgWellen,
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'deep_somatics',
    title: 'Intim-Massage, Prostata & Damm',
    description: 'Behutsame Erkundung mit viel Zeit und ohne Ziel.',
    icon: Icons.self_improvement_rounded,
    image: 'assets/images/ynm_deep_somatics.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_14',
        categoryId: 'deep_somatics',
        text: 'Yoni-Massage: lange, absichtslose Massage der Vulva',
        explanation:
            'Eine Person empfängt, die andere massiert – erst Bauch und Innenschenkel, dann die Vulva, '
            'innen nur nach ausdrücklichem Ja. Ein Höhepunkt ist kein Ziel.',
        lessonId: 'mass_2',
        image: _imgYoni,
      ),
      YesNoMaybeItem(
        id: 'item_15',
        categoryId: 'deep_somatics',
        text: 'Lingam-Massage: lange, absichtslose Massage des Penis',
        explanation:
            'Von der Basis bis zur Spitze, auch im weichen Zustand. Ohne Erwartung an Erektion oder Samenerguss – '
            'genau das lässt viele Männer zum ersten Mal ganz loslassen.',
        lessonId: 'mass_3',
        image: _imgLingam,
      ),
      YesNoMaybeItem(
        id: 'item_16',
        categoryId: 'deep_somatics',
        text: 'Damm-Massage von außen',
        explanation:
            'Sanfter, kreisender Druck auf die Haut zwischen Hoden und After. Erreicht Schwellkörperwurzel und '
            'Prostata von außen – ein schamarmer Einstieg.',
        lessonId: 'prost_2',
        image: _imgLingam,
      ),
      YesNoMaybeItem(
        id: 'item_17',
        categoryId: 'deep_somatics',
        text: 'Prostata von innen erkunden',
        explanation:
            'Mit viel Gleitmittel, kurzen Nägeln und Geduld: Der Finger gleitet beim Ausatmen hinein, ruht, '
            'und streicht dann sanft über die Prostata. Schmerz heißt immer stopp.',
        lessonId: 'prost_3',
      ),
      YesNoMaybeItem(
        id: 'item_18',
        categoryId: 'deep_somatics',
        text: 'Ausdauer-Training: rechtzeitig innehalten',
        explanation:
            'Die eigene Erregung früh lesen und bei etwa sieben von zehn pausieren, statt erst kurz vor dem Punkt ohne Rückkehr. '
            'Gut untersucht und auch zu zweit spielbar.',
        lessonId: 'touch_m_3',
        image: _imgWellen,
      ),
      YesNoMaybeItem(
        id: 'item_47',
        categoryId: 'deep_somatics',
        text: 'Die vordere Vaginalwand (G-Zone) erkunden',
        explanation:
            'Ein oder zwei Finger, Kuppe Richtung Bauchnabel, eine langsame Komm-her-Bewegung. Manche empfinden das als sehr '
            'tief, andere als neutral – beides ist normal.',
        lessonId: 'mass_2',
        image: _imgYoni,
      ),
      YesNoMaybeItem(
        id: 'item_48',
        categoryId: 'deep_somatics',
        text: 'Höhepunkt ohne Samenerguss ausprobieren',
        explanation:
            'Mit Übung lassen sich orgastische Wellen erleben, ohne zu ejakulieren. Kein Muss und kein neuer '
            'Leistungsmaßstab – ein Experiment.',
        lessonId: 'touch_m_5',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'toys_aids',
    title: 'Spielzeug & Hilfsmittel',
    description: 'Gleitmittel, Vibratoren und Co. – als Bereicherung, nicht als Ersatz.',
    icon: Icons.toys_rounded,
    image: 'assets/images/ynm_toys_aids.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_49',
        categoryId: 'toys_aids',
        text: 'Gleitmittel als selbstverständlicher Teil',
        explanation:
            'Kein Zeichen von „zu wenig Lust“, sondern ein Genussmittel. Wasserbasiert passt zu allem; '
            'Silikon hält länger, aber nicht mit Silikonspielzeug. Öl verträgt sich nicht mit Latexkondomen.',
        lessonId: 'body_2',
      ),
      YesNoMaybeItem(
        id: 'item_50',
        categoryId: 'toys_aids',
        text: 'Ein Auflegevibrator beim gemeinsamen Sex',
        explanation:
            'Viele Frauen kommen beim Sex leichter, wenn die Klitoris zusätzlich gleichmäßig stimuliert wird. '
            'Ein kleiner Vibrator ist dabei Mitspieler, keine Konkurrenz.',
      ),
      YesNoMaybeItem(
        id: 'item_51',
        categoryId: 'toys_aids',
        text: 'Ein Penisring',
        explanation:
            'Ein dehnbarer Ring an der Peniswurzel hält das Blut etwas länger im Schwellkörper. '
            'Nur weiche, dehnbare Ringe und höchstens etwa 20 Minuten – bei Taubheit oder Schmerz sofort ab.',
      ),
      YesNoMaybeItem(
        id: 'item_52',
        categoryId: 'toys_aids',
        text: 'Massagekerze oder angewärmtes Massageöl',
        explanation:
            'Eine Massagekerze schmilzt zu warmem Öl – nur Kerzen nehmen, die dafür gemacht sind, '
            'und das Öl vorher am Handgelenk testen.',
        lessonId: 'mass_4',
      ),
      YesNoMaybeItem(
        id: 'item_53',
        categoryId: 'toys_aids',
        text: 'Analspielzeug',
        explanation:
            'Nur Spielzeug mit breitem Fuß und speziell für anale Nutzung, aus Silikon, mit viel Gleitmittel. '
            'Langsam, beim Ausatmen, und Schmerz heißt stopp.',
        lessonId: 'prost_3',
      ),
      YesNoMaybeItem(
        id: 'item_54',
        categoryId: 'toys_aids',
        text: 'Gemeinsam ein Spielzeug aussuchen',
        explanation:
            'Zusammen stöbern ist schon Vorfreude – und ihr findet nebenbei heraus, was den anderen reizt.',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'roles_settings',
    title: 'Rollen, Orte & Kulissen',
    description: 'Raus aus der Routine – mit neuen Rollen, Zeiten und Räumen.',
    icon: Icons.theater_comedy_rounded,
    image: 'assets/images/ynm_roles_settings.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_19',
        categoryId: 'roles_settings',
        text: 'Rollenspiel: zwei Fremde, die sich in einer Bar kennenlernen',
        explanation:
            'Getrennt hingehen, so tun, als sähe man sich zum ersten Mal, flirten – und sich gemeinsam nach Hause nehmen. '
            'Der Reiz liegt im neuen Blick auf den vertrauten Menschen.',
        lessonId: 'fant_2',
      ),
      YesNoMaybeItem(
        id: 'item_20',
        categoryId: 'roles_settings',
        text: 'Intimität an ungewöhnlichen Orten',
        explanation:
            'Wohnzimmerboden, Küche, Garten im Dunkeln – Hauptsache neu. Wichtig: nur dort, wo euch niemand '
            'unfreiwillig sehen kann. Sex in der Öffentlichkeit ist strafbar.',
      ),
      YesNoMaybeItem(
        id: 'item_21',
        categoryId: 'roles_settings',
        text: 'Dessous, Verkleidung oder eine besondere Garderobe',
        explanation:
            'Etwas tragen, das man sonst nie trägt – für den anderen oder für sich selbst. Oft wirkt es vor allem auf '
            'die Person, die es trägt.',
      ),
      YesNoMaybeItem(
        id: 'item_55',
        categoryId: 'roles_settings',
        text: 'Eine Nacht im Hotel nur für euch',
        explanation:
            'Kein Alltag, keine Wäsche, kein Handy auf dem Nachttisch. Ein fremder Raum macht vieles leichter.',
      ),
      YesNoMaybeItem(
        id: 'item_56',
        categoryId: 'roles_settings',
        text: 'Morgens im Halbschlaf',
        explanation:
            'Noch warm und weich, langsam aneinandergeschmiegt. Vorher absprechen, ob man so geweckt werden möchte.',
        lessonId: 'pos_2',
      ),
      YesNoMaybeItem(
        id: 'item_57',
        categoryId: 'roles_settings',
        text: 'Ein Abend mit Regel, zum Beispiel: nur küssen',
        explanation:
            'Eine klare Grenze für den Abend – nur küssen, nur Hände, kein Sex. Gerade das Verbot macht ihn oft '
            'besonders aufregend.',
        lessonId: 'tease_1',
      ),
    ],
  ),
  YesNoMaybeCategory(
    id: 'fantasy_watching',
    title: 'Fantasie & Zuschauen',
    description: 'Mit den Augen genießen, Kopfkino teilen.',
    icon: Icons.visibility_rounded,
    image: 'assets/images/ynm_fantasy_watching.svg',
    items: [
      YesNoMaybeItem(
        id: 'item_58',
        categoryId: 'fantasy_watching',
        text: 'Zusehen, wie der andere sich selbst berührt',
        explanation:
            'Eine Person berührt sich langsam, die andere liegt daneben, schaut zu und darf küssen. Sehr intim – '
            'und eine Lehrstunde darin, was dem anderen gefällt.',
      ),
      YesNoMaybeItem(
        id: 'item_59',
        categoryId: 'fantasy_watching',
        text: 'Einander langsam ausziehen oder ein kleiner Striptease',
        explanation:
            'Keine Show, nur Zeit lassen und gesehen werden. Musik hilft, ein Lachen auch.',
      ),
      YesNoMaybeItem(
        id: 'item_60',
        categoryId: 'fantasy_watching',
        text: 'Ein Spiegel im Blick',
        explanation:
            'Sich selbst und den anderen beim Sex sehen. Für manche sehr erregend, für andere lenkt es ab – '
            'genau das ist die Frage.',
        lessonId: 'body_1',
      ),
      YesNoMaybeItem(
        id: 'item_61',
        categoryId: 'fantasy_watching',
        text: 'Gemeinsam eine erotische Geschichte hören oder lesen',
        explanation:
            'Ein Hörbuch oder eine Kurzgeschichte als Auftakt. Fremde Bilder im Kopf, eigene Hände auf der Haut.',
        lessonId: 'scen_4',
      ),
      YesNoMaybeItem(
        id: 'item_62',
        categoryId: 'fantasy_watching',
        text: 'Private Fotos füreinander',
        explanation:
            'Nur mit ausdrücklichem Einverständnis, nur für euch. Vorher klären, wo die Bilder liegen und wann sie '
            'gelöscht werden. Gesichter weglassen schützt zusätzlich.',
      ),
    ],
  ),
];

List<YesNoMaybeItem> get allYesNoMaybeItems {
  final list = <YesNoMaybeItem>[];
  for (var cat in velvetYesNoMaybeCategories) {
    list.addAll(cat.items);
  }
  return list;
}
