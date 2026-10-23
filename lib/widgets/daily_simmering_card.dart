import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class DailySimmeringCard extends StatefulWidget {
  const DailySimmeringCard({super.key});

  @override
  State<DailySimmeringCard> createState() => _DailySimmeringCardState();
}

class _DailySimmeringCardState extends State<DailySimmeringCard>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  static const List<Map<String, String>> _couplesImpulses = [
    {
      'title': 'Das 45-Sekunden-Wand-Teasing',
      'tag': 'KURS 11 • TEASING',
      'action':
          'Drücke deinen Partner heute kurz fordernd an die Wand oder halte ihn sanft fest. Küsse langsam den Hals, raune ein Versprechen ins Ohr – und lächle nach genau 45 Sekunden und gehe weiter: "Den Rest heben wir uns für später auf."',
      'benefit': 'Flutet das Dopamin-System, ohne Leistungsdruck aufzubauen.',
    },
    {
      'title': 'Die Kiefer-Schmelze & Stimm-Aktivierung',
      'tag': 'KURS 10 • HÖRBARE LUST',
      'action':
          'Lege die Finger an deine Kiefergelenke, öffne den Mund und lass 3 tiefe, dunkle Seufzer hörbar durch den Raum vibrieren. Spüre, wie dein Beckenboden gleichzeitig nach unten nachgibt.',
      'benefit': 'Löst über die Kehlkopf-Becken-Achse chronische Anspannung im Damm.',
    },
    {
      'title': 'Die 15:00-Uhr-Antizipation',
      'tag': 'KURS 11 • KOPFKINO',
      'action':
          'Schicke deinem Gegenüber heute Nachmittag eine unangekündigte Nachricht: "Heute Abend ab 21 Uhr gehört dein Körper mir. Du musst nichts tun, außer da zu sein."',
      'benefit': 'Erzeugt wohlige Vorfreude statt hektischem Abrufen auf Knopfdruck.',
    },
    {
      'title': 'Zeitlupe beim Einschenken',
      'tag': 'KURS 11 • SLOW SEX',
      'action':
          'Berühre deinen Partner heute bei einer Alltagsgelegenheit (am Tisch, auf dem Sofa) im extremen 10%-Zeitlupen-Tempo. Streiche 60 Sekunden quälend langsam über Handrücken und Unterarm.',
      'benefit': 'Aktiviert feine Meissner-Tastkörperchen und signalisiert Sicherheit.',
    },
    {
      'title': 'Das 15-Minuten-Seidentuch-Ritual',
      'tag': 'KURS 12 • HINGABE',
      'action':
          'Verabredet für heute Abend: Einer bekommt die Augen verbunden und darf absolut nichts leisten oder zurückgeben. Der andere dirigiert 15 Minuten sanfte Berührungen.',
      'benefit': 'Transient Hypofrontality: Schaltet den kontrollierenden Chef im Kopf ab.',
    },
    {
      'title': 'Das strikte Penetrations-Verbot',
      'tag': 'KURS 7 • SENSATE FOCUS',
      'action':
          'Verabredet heute: Ihr dürft euch nackt umarmen, küssen und streicheln – aber Penetration ist strikt tabu. Alles darf sein, nichts muss.',
      'benefit': 'Halbiert den Adrenalinspiegel und lässt die Lust von allein kochen.',
    },
    {
      'title': 'Sensory Narrating (Worte im Ohr)',
      'tag': 'KVT • ANSTÄNDIGKEIT LÖSEN',
      'action':
          'Flüstere deinem Partner heute im Dunkeln eine einzige ehrliche, sinnliche Empfindung ins Ohr: "Es macht mich verrückt, wie warm und weich deine Haut gerade unter meiner Hand ist."',
      'benefit': 'Sprengt die Stummfilm-Starre und verbindet euch intim.',
    },
    {
      'title': 'Die charmante Traum-Brücke',
      'tag': 'KURS 12 • FANTASIEN',
      'action':
          'Erzähle heute beiläufig mit einem Schmunzeln von einem "unanständigen Traum", den du über euch beide hattest. Beobachte die Reaktion.',
      'benefit': 'Öffnet den geheimen Garten ohne Scham oder Rechtfertigungsdruck.',
    },
    {
      'title': 'Der Beckenboden-Check im Sitzen',
      'tag': 'KURS 3 & 9 • SOMATIK',
      'action':
          'Achte genau jetzt darauf: Hältst du im Becken oder After fest? Atme tief ein und lass den Beckenboden wie eine weite Blüte nach unten sinken (Reverse Kegel).',
      'benefit': 'Down-Training für Standfestigkeit und Schmerzfreiheit.',
    },
    {
      'title': 'Weicher Bauch • Volle Hingabe',
      'tag': 'KURS 13 • RADICAL BODY LOVE',
      'action':
          'Lass deinen Bauch heute ganz bewusst locker nach außen sinken. Perfektion ist kalt – Hingabe und Wärme sind unwiderstehlich.',
      'benefit': 'Ermöglicht freie Zwerchfell- und Becken-Durchblutung.',
    },
  ];

  static const List<Map<String, String>> _soloImpulses = [
    {
      'title': 'Die Kiefer-Schmelze & Becken-Vibration',
      'tag': 'KURS 10 • HÖRBARE LUST',
      'action':
          'Öffne den Mund, streiche deine Wangen aus und seufze 3x tief und dunkel nach unten aus. Spüre, wie die Schwingung bis in dein Schambein hinabwandert.',
      'benefit': 'Öffnet die Kehlkopf-Becken-Achse und entspannt den Damm.',
    },
    {
      'title': 'Broad Palm Touch mit warmem Öl',
      'tag': 'KURS 9 • SOMATISCHES LAB',
      'action':
          'Verzichte heute beim Spüren auf jeden engen Klammergriff. Nutze viel Gleitmittel und bewege die gesamte flache Handfläche in Zeitlupe über das Becken.',
      'benefit': 'Heilt den "Death Grip" und reaktiviert feine Dehnungsrezeptoren.',
    },
    {
      'title': 'Orbiting: Das Perineum erforschen',
      'tag': 'KURS 8 & 9 • ORBITING',
      'action':
          'Lass die hochsensible Spitze heute für 10 Minuten völlig unberührt. Konzentriere Berührung nur auf Damm, Schaftbasis und Leiste.',
      'benefit': 'Verhindert Reizüberflutung und dehnt Lust auf das ganze Becken aus.',
    },
    {
      'title': 'Plateau-Surfen auf Stufe 7',
      'tag': 'KURS 9 • AUSDAUER',
      'action':
          'Bringe deine Erregung auf Stufe 7. Sobald sie auf 8 klettert: Stoppe jede Bewegung (Stillness), atme 3x tief aus und lass den Beckenboden nach unten sinken.',
      'benefit': 'Entkoppelt im Gehirn Lustempfinden vom Ejakulationsreflex.',
    },
    {
      'title': 'Dopamin-Reset: Bildschirmfreies Spüren',
      'tag': 'KURS 4 • REKALIBRIERUNG',
      'action':
          'Nimm dir heute 10 Minuten Zeit ganz ohne Smartphone oder Bildschirme. Schließe die Augen und achte nur auf Temperatur und Atem.',
      'benefit': 'Resettet die Rezeptoren für natürliche, berührende Nähe.',
    },
    {
      'title': 'Der Schließmuskel-Entlastungstest',
      'tag': 'KURS 9 • MULTI-ORGASMIE',
      'action':
          'Beobachte deine Reflexe: Wenn Erregung steigt, lass den Anal-Schließmuskel bewusst locker, statt ihn anzuspannen.',
      'benefit': 'Schützt vor dem vorzeitigen Reflex und breitet Lust im Körper aus.',
    },
    {
      'title': 'Zero-Pressure Hocke (Malasana)',
      'tag': 'KURS 3 • FASZIEN',
      'action':
          'Gehe für 2 Minuten in die tiefe Hocke (Deep Squat). Atme 10 tiefe Atemzüge in das geöffnete Becken hinein.',
      'benefit': 'Dehnt Adduktoren und befreit chronisch verkrampfte Beckenfaszien.',
    },
    {
      'title': 'Körper-Mitgefühl vor dem Spiegel',
      'tag': 'KURS 13 • SELBSTMITGEFÜHL',
      'action':
          'Betrachte deinen Körper heute ohne Bewertung. Sag dir: "Mein Körper ist lebendig, atmend und fähig zu tiefster Lust."',
      'benefit': 'Sprengt den inneren Kritiker und baut Scham ab.',
    },
    {
      'title': 'Physiologischer Seufzer (Quick-Downregulation)',
      'tag': 'TOOL • VAGUS-RESET',
      'action':
          'Doppelt durch die Nase tief einatmen, dann sehr lang und hörbar durch den offenen Mund seufzen. 3 Wiederholungen.',
      'benefit': 'Schaltet den Sympathikus innerhalb von 45 Sekunden ab.',
    },
    {
      'title': 'Der 90-Prozent-Pakt mit dir selbst',
      'tag': 'KURS 11 • TEASING',
      'action':
          'Schenke dir heute 10 Minuten Genuss – aber nimm dir vor, bei 90% bewusst aufzuhören, ohne zum Abschluss zu eilen.',
      'benefit': 'Trainiert das Nervensystem darauf, dass Lust kein Zweckbetrieb ist.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    HapticFeedback.lightImpact();
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    });
  }

  Map<String, String> _getTodayImpulse(UserProfile? profile) {
    final now = DateTime.now();
    // Daily stable index (day of year)
    final dayIndex = (now.year * 365 + now.month * 31 + now.day) % 10;
    final isSolo = (profile != null && profile.relationshipStatus == 'single');
    final list = isSolo ? _soloImpulses : _couplesImpulses;
    return list[dayIndex % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final impulse = _getTodayImpulse(profile);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRevealed
              ? const Color(0xFFE11D48).withOpacity(0.6)
              : AppTheme.amber.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          if (_isRevealed)
            BoxShadow(
              color: const Color(0xFFE11D48).withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleReveal,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE11D48).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFFB7185),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HEUTIGER EROTIK-FUNKE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Color(0xFFFB7185),
                              ),
                            ),
                            Text(
                              _isRevealed ? impulse['tag']! : 'Simmering & Alltags-Teasing',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      _isRevealed
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.lock_open_rounded,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Content Area (Mystery vs Revealed)
                if (!_isRevealed) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tippe hier, um deinen heutigen 45-Sekunden-Funken aufzudecken...',
                          style: TextStyle(
                            color: AppTheme.textSecondary.withOpacity(0.9),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ÖFFNEN',
                          style: TextStyle(
                            color: AppTheme.amberLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    impulse['title']!,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    impulse['action']!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 13,
                          color: AppTheme.amber,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            impulse['benefit']!,
                            style: const TextStyle(
                              color: AppTheme.amberLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
