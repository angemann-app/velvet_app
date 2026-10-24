import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class KegelGuideSheet extends StatelessWidget {
  const KegelGuideSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const KegelGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: AppTheme.sageGreen, size: 24),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Beckenboden-Anleitung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Muskel finden, Übungen, Plan',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppTheme.border, height: 1),

              // Content Body
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    _buildSectionCard(
                      title: '1. Den Muskel finden',
                      badge: 'GRUNDLAGEN',
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        const Text(
                          'Der Beckenboden spannt sich wie eine Hängematte zwischen Schambein und Steißbein – bei allen Menschen. '
                          'Er kann zwei Dinge: heben und halten, und weit werden und loslassen. Beides gehört zum Training.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodBox(
                          icon: Icons.vertical_align_top_rounded,
                          title: 'Anspannen und heben',
                          text: 'Stell dir vor, du hältst einen Wind zurück und stoppst gleichzeitig den Urinstrahl – nur in der Vorstellung.\n'
                              '• Mit Vulva: Scheideneingang und Damm ziehen sich sanft nach innen und oben.\n'
                              '• Mit Penis: Die Peniswurzel hebt sich ein kleines Stück, die Hoden ziehen leicht nach oben.',
                          accentColor: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 8),
                        _buildMethodBox(
                          icon: Icons.vertical_align_bottom_rounded,
                          title: 'Loslassen und weit werden',
                          text: 'Atme tief in den Bauch. Während sich der Bauch wölbt, lass den Beckenboden sanft nach unten nachgeben – '
                              'wie beim Beginn des Wasserlassens, aber ohne zu pressen. Der Bereich zwischen Schambein und Steißbein wird weich und warm.',
                          accentColor: AppTheme.amber,
                        ),
                        const SizedBox(height: 10),
                        _buildTip('Po, Oberschenkel und Bauch bleiben locker. Eine Hand auf dem Po verrät, ob er mitarbeitet.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '2. Welche Übung wofür?',
                      badge: 'ÜBUNGEN',
                      badgeColor: AppTheme.amber,
                      children: [
                        _buildModeComparison(
                          title: 'Loslassen',
                          subtitle: 'bei Anspannung, Schmerzen beim Eindringen, frühem Samenerguss',
                          description: 'Für alle, deren Beckenboden eher zu viel festhält. Das ist bei Stress, viel Sitzen und Leistungsdruck häufig. '
                              'Fang hier an, wenn du unsicher bist.',
                          color: AppTheme.amber,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: 'Kräftigen',
                          subtitle: 'für Halt, Kontrolle und Stabilität',
                          description: 'Stärkt die Muskulatur, etwa nach einer Geburt, bei leichter Blasenschwäche oder für mehr Kontrolle. '
                              'Mit halber Kraft üben, das Loslassen danach ist genauso wichtig wie das Halten.',
                          color: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: 'Schnelle Impulse',
                          subtitle: 'für Reaktionsfähigkeit',
                          description: 'Kurzes An und sofortiges Los trainiert die schnellen Muskelfasern – zum Beispiel für den Moment beim Husten oder Niesen.',
                          color: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 10),
                        _buildModeComparison(
                          title: 'Wellen',
                          subtitle: 'locker bleiben, wenn es spannend wird',
                          description: 'Langes, hörbares Ausatmen mit weichem Damm und Po. Genau das hilft beim Wellen-Surfen aus den Kursen 8 und 9, '
                              'die Erregung hoch zu halten, ohne dass sie überläuft.',
                          color: AppTheme.rose,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '3. Typische Fehler',
                      badge: 'ACHTUNG',
                      badgeColor: AppTheme.rose,
                      children: [
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Den Po zusammenkneifen',
                          description: 'Der große Gesäßmuskel mogelt sich gern hinein. Der Po bleibt weich.',
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Die Luft anhalten',
                          description: 'Atme beim Halten ruhig weiter. Angehaltener Atem erhöht den Druck im Bauch.',
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Pressen statt loslassen',
                          description: 'Beim Loslassen wird nichts nach unten gedrückt. Es ist ein Nachgeben, kein Schieben.',
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Beim echten Wasserlassen üben',
                          description: 'Den Urinstrahl regelmäßig zu stoppen kann die Blasenentleerung stören. Nur in der Vorstellung üben.',
                        ),
                        _buildRuleItem(
                          isWarning: false,
                          title: 'Lieber kurz und regelmäßig',
                          description: 'Ein paar Minuten an den meisten Tagen bringen mehr als selten eine lange Einheit.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '4. Ein Plan für sechs Wochen',
                      badge: 'PLAN',
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        _buildPlanRow('Woche 1–2', 'Täglich Loslassen, 5 Runden, Stufe leicht. Ziel: das Weitwerden sicher spüren.'),
                        _buildPlanRow('Woche 3–4', 'Loslassen 5 Runden, danach Kräftigen 5 Runden, Stufe leicht. An zwei Tagen Wellen.'),
                        _buildPlanRow('Woche 5–6', '10 Runden in deiner Hauptübung, Stufe mittel. Dazu ein paar Schnelle Impulse.'),
                        const SizedBox(height: 6),
                        const Text(
                          'Danach: Behalte zwei, drei kurze Einheiten pro Woche bei. Und nutze das Loslassen bewusst in intimen Momenten – '
                          'tief in den Bauch atmen, den Beckenboden sinken lassen.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.45),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '5. Wann zur Physiotherapie?',
                      badge: 'GESUNDHEIT',
                      badgeColor: AppTheme.amber,
                      children: [
                        const Text(
                          'Eine spezialisierte Beckenboden-Physiotherapie kann genau untersuchen, ob dein Beckenboden eher zu schwach oder zu fest ist, '
                          'und dich gezielt anleiten. Lass dich beraten bei:\n'
                          '• Schmerzen im Becken, beim Sex oder beim Training\n'
                          '• Blasen- oder Darmschwäche\n'
                          '• Beschwerden nach einer Geburt oder einer Operation im Becken\n'
                          '• dem Gefühl, den Muskel gar nicht ansteuern zu können',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sageGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Zurück zum Training', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanRow(String when, String what) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(when, style: const TextStyle(color: AppTheme.sageGreen, fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Text(what, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMethodBox({
    required IconData icon,
    required String title,
    required String text,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeComparison({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              subtitle,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem({
    required bool isWarning,
    required String title,
    required String description,
  }) {
    final color = isWarning ? AppTheme.rose : AppTheme.sageGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? Icons.cancel_outlined : Icons.check_circle_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
