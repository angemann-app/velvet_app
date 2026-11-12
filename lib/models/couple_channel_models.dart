import 'package:flutter/material.dart';

enum CoupleMessageType {
  chat,
  ping,
  fantasyVote,
}

enum NostrConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class CoupleMessage {
  final String id;
  final String senderPubkey;
  final bool isMe;
  final CoupleMessageType type;
  final String? text;
  final String? emoji;
  final String? fantasyId;
  final String? fantasyVote;

  /// Lektion, auf die sich die Nachricht bezieht (geteilte Lektion oder Reflexion).
  final String? lessonId;

  /// Einladung zum Spicy-Modus (als Chat-Nachricht mit Zusatzfeld, ältere Versionen zeigen den Text).
  final bool spicyEinladung;

  /// Verschwindende Nachricht: wird 10 Minuten nach dem Lesen gelöscht, nur nach dem Lesen
  /// (NostrService.verschwindenNachLesen).
  final bool verschwindet;

  /// Ab wann die verschwindende Nachricht gelöscht wird (gesetzt, sobald sie gelesen wurde).
  final DateTime? loeschenAb;

  /// Foto, das direkt von Handy zu Handy übertragen wird (lib/services/foto_kanal.dart).
  final String? fotoId;

  /// Antwort auf eine Einladung oder einen Funken (`spicy_nein`, `danke`); als Chat-Nachricht mit
  /// lesbarem Text, ältere Versionen zeigen den Text. Nur bekannte Werte (siehe [antwortArten]).
  final String? antwort;

  /// Art eines Funkens, auf den man antworten kann (`nein` = „Heute lieber nicht“, `reden`).
  final String? funke;

  /// Auf diese Einladung oder diesen Funken habe ich schon geantwortet (nur lokal).
  final bool beantwortet;
  final DateTime createdAt;

  /// Bekannte Werte von [antwort]; alles andere wird beim Empfang verworfen.
  static const antwortArten = {'spicy_nein', 'danke'};

  /// Bekannte Werte von [funke].
  static const funkeArten = {'nein', 'reden'};

  const CoupleMessage({
    required this.id,
    required this.senderPubkey,
    required this.isMe,
    required this.type,
    this.text,
    this.emoji,
    this.fantasyId,
    this.fantasyVote,
    this.lessonId,
    this.spicyEinladung = false,
    this.verschwindet = false,
    this.loeschenAb,
    this.fotoId,
    this.antwort,
    this.funke,
    this.beantwortet = false,
    required this.createdAt,
  });

  CoupleMessage mitLoeschzeit(DateTime zeit) => _kopie(loeschenAb: zeit);

  CoupleMessage alsBeantwortet() => _kopie(beantwortet: true);

  CoupleMessage _kopie({DateTime? loeschenAb, bool? beantwortet}) => CoupleMessage(
        id: id,
        senderPubkey: senderPubkey,
        isMe: isMe,
        type: type,
        text: text,
        emoji: emoji,
        fantasyId: fantasyId,
        fantasyVote: fantasyVote,
        lessonId: lessonId,
        spicyEinladung: spicyEinladung,
        verschwindet: verschwindet,
        loeschenAb: loeschenAb ?? this.loeschenAb,
        fotoId: fotoId,
        antwort: antwort,
        funke: funke,
        beantwortet: beantwortet ?? this.beantwortet,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderPubkey': senderPubkey,
      'isMe': isMe,
      'type': type.name,
      'text': text,
      'emoji': emoji,
      'fantasyId': fantasyId,
      'fantasyVote': fantasyVote,
      'lessonId': lessonId,
      if (spicyEinladung) 'spicyEinladung': true,
      if (verschwindet) 'verschwindet': true,
      if (loeschenAb != null) 'loeschenAb': loeschenAb!.toIso8601String(),
      if (fotoId != null) 'fotoId': fotoId,
      if (antwort != null) 'antwort': antwort,
      if (funke != null) 'funke': funke,
      if (beantwortet) 'beantwortet': true,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CoupleMessage.fromJson(Map<String, dynamic> map) {
    return CoupleMessage(
      id: map['id'] as String? ?? '',
      senderPubkey: map['senderPubkey'] as String? ?? '',
      isMe: map['isMe'] as bool? ?? false,
      type: CoupleMessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CoupleMessageType.chat,
      ),
      text: map['text'] as String?,
      emoji: map['emoji'] as String?,
      fantasyId: map['fantasyId'] as String?,
      fantasyVote: map['fantasyVote'] as String?,
      lessonId: map['lessonId'] as String?,
      spicyEinladung: map['spicyEinladung'] == true,
      verschwindet: map['verschwindet'] == true,
      loeschenAb: DateTime.tryParse(map['loeschenAb'] as String? ?? ''),
      fotoId: map['fotoId'] as String?,
      antwort: antwortArten.contains(map['antwort']) ? map['antwort'] as String : null,
      funke: funkeArten.contains(map['funke']) ? map['funke'] as String : null,
      beantwortet: map['beantwortet'] == true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class FantasyOption {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;

  /// Die Szenen sind deutlich und stehen nur im Spicy-Modus (Entscheidung vom 31.10.2026).
  final bool spicy;

  const FantasyOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    this.spicy = true,
  });

  String get category => tag;
  String get description => subtitle;
}

const List<FantasyOption> defaultFantasyOptions = [
  FantasyOption(
    id: 'match_blindfold',
    title: 'Hingabe unter der Augenbinde (Eis & Wärme)',
    subtitle: 'Einer bekommt die Augen verbunden und weiß nicht, ob als Nächstes warme Lippen, Öl oder ein Eiswürfel seine Haut berühren.',
    tag: 'Rollen & Sinne',
    icon: Icons.visibility_off_rounded,
  ),
  FantasyOption(
    id: 'match_yoni_ritual',
    title: '45 Min. Yoni-Verehrung (eine Person empfängt)',
    subtitle: 'Eine Person liegt nur da, schließt die Augen und empfängt, mit warmem Öl, ohne jede Gegenleistung.',
    tag: 'Intim-Massage',
    icon: Icons.spa_rounded,
  ),
  FantasyOption(
    id: 'match_lingam_ritual',
    title: '45 Min. Lingam- & Damm-Reise (eine Person empfängt)',
    subtitle: 'Eine langsame, beidhändige Ölmassage von Bauch, Damm und Schaft – völlig ohne Leistungs- oder Erfolgsdruck.',
    tag: 'Intim-Massage',
    icon: Icons.self_improvement_rounded,
  ),
  FantasyOption(
    id: 'match_wrists',
    title: 'Fesselnde Hingabe (Handgelenke gehalten)',
    subtitle: 'Die Handgelenke werden mit einem weichen Schal oder den Händen über dem Kopf gehalten: Bewegungsverbot beim Verwöhntwerden.',
    tag: 'Macht & Hingabe',
    icon: Icons.lock_outline_rounded,
  ),
  FantasyOption(
    id: 'match_cat_grinding',
    title: 'Stoßfreie Verschmelzung (Schambein-Wiegen)',
    subtitle: 'Kein Rein-Raus: Wir bleiben tief ineinander verankert und bewegen uns nur durch langsames, schweres Becken-Wiegen.',
    tag: 'Stellungen',
    icon: Icons.sync_rounded,
  ),
  FantasyOption(
    id: 'match_prostate_explore',
    title: 'Geheime Zone: Damm- & Prostata-Erkundung',
    subtitle: 'Neugieriges, schamfreies Erforschen des männlichen Damms und des inneren Lustpunkts mit viel Gleitgel und Zeit.',
    tag: 'Tiefe Somatik',
    icon: Icons.explore_rounded,
  ),
  FantasyOption(
    id: 'match_sensory_talk',
    title: 'Flüstern im Dunkeln (Verführerische Worte)',
    subtitle: 'Wir schalten das Licht komplett aus und beschreiben uns gegenseitig mit tiefer Stimme direkt ins Ohr, was wir gerade spüren.',
    tag: 'Kommunikation',
    icon: Icons.record_voice_over_rounded,
  ),
  FantasyOption(
    id: 'match_kitchen_tease',
    title: 'Das 90-Prozent-Spiel im Alltag',
    subtitle: 'Mitten am Tag eine Minute innig küssen, die Hände wandern lassen – und dann lächelnd weitergehen. Ohne Versprechen für später.',
    tag: 'Knisterndes Hinhalten',
    icon: Icons.spa_outlined,
  ),
  FantasyOption(
    id: 'match_mirror_watch',
    title: 'Zuschauen & Genießen (Abend für die Augen)',
    subtitle: 'Einer berührt sich selbst ganz langsam nach den Entspannungs-Regeln, während der andere eng daneben liegt, zuschaut und küsst.',
    tag: 'Fantasie',
    icon: Icons.remove_red_eye_rounded,
  ),
  FantasyOption(
    id: 'match_oral_worship',
    title: 'Lippen- & Zungen-Verwöhnung in Zeitlupe',
    subtitle: 'Zwanzig Minuten reiner Fokus mit Lippen und Zunge nach dem Umlaufbahn-Prinzip – der Kopf hat Sendepause.',
    tag: 'Sinnlichkeit',
    icon: Icons.waves_rounded,
  ),
  FantasyOption(
    id: 'match_hotel_stranger',
    title: 'Fremde an der Bar (Das Rollenspiel)',
    subtitle: 'Wir treffen uns getrennt an einem Abend, tun so, als würden wir uns zum ersten Mal sehen, und nehmen uns danach mit nach Hause.',
    tag: 'Fantasie',
    icon: Icons.hotel_rounded,
  ),
  FantasyOption(
    id: 'match_morning_spoon',
    title: 'Halbschlaf-Löffelchen am Morgen',
    subtitle: 'Noch vor dem ersten Kaffee: Seitlich eng aneinandergeschmiegt im Zeitlupen-Modus ineinander gleiten.',
    tag: 'Stellungen',
    icon: Icons.bed_rounded,
  ),
];
