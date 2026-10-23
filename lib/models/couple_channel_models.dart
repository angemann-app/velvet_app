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
  final DateTime createdAt;

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
    required this.createdAt,
  });

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

  const FantasyOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
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
    title: '45 Min. Yoni-Verehrung (Nur für Sie)',
    subtitle: 'Sie darf nur daliegen, die Augen schließen und empfangen – mit warmem Öl, ohne jede Gegenleistung.',
    tag: 'Intim-Massage',
    icon: Icons.spa_rounded,
  ),
  FantasyOption(
    id: 'match_lingam_ritual',
    title: '45 Min. Lingam- & Damm-Reise (Nur für Ihn)',
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
    icon: Icons.local_fire_department_rounded,
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
