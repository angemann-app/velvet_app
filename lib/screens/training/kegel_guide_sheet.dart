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
                              'Technik, Neurobiologie & Praxistipps',
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
                    // Section 1: Muskel finden
                    _buildSectionCard(
                      title: '1. Wie finde ich den Muskel?',
                      badge: 'GRUNDLAGEN',
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        const Text(
                          'Der Beckenboden spannt sich bei Frau und Mann gleichermaßen wie eine elastische, tragende Hängematte zwischen Schambein und Steißbein.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodBox(
                          icon: Icons.vertical_align_top_rounded,
                          title: 'Klassisches Heben (Anspannen / Kräftigen):',
                          text: '• Für Sie: Die Vagina und das Perineum sanft nach oben-innen einziehen, wie das Schließen einer Knospe.\n• Für Ihn: Die Peniswurzel sanft nach innen-oben heben oder den Urinstrahl kurz gedanklich anhalten.',
                          accentColor: AppTheme.sageGreen,
                        ),
                        const SizedBox(height: 8),
                        _buildMethodBox(
                          icon: Icons.vertical_align_bottom_rounded,
                          title: 'Reverse Absenken (Öffnen / Entspannen):',
                          text: '• Für Sie: Den Scheideneingang und Damm wie ein Erblühen weich nach unten-außen nachgeben lassen – der Schlüssel gegen Vaginismus und Schmerzen!\n• Für Ihn: Den Beckenboden wie eine weite Hängematte nach unten sinken lassen – beendet vorzeitiges Kommen und Nervosität.',
                          accentColor: AppTheme.amber,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Wichtig: Gesäß (Po-Backen), Oberschenkel und Bauchdecke bleiben völlig entspannt!',
                                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section 2: Die beiden Trainingsmodi
                    _buildSectionCard(
                      title: '2. Wann nutze ich welchen Modus?',
                      badge: 'STRATEGIE',
                      badgeColor: AppTheme.amber,
                      children: [
                        _buildModeComparison(
                          title: 'Reverse Kegel (Entspannung & Weite)',
                          subtitle: 'Der wichtigste Modus bei Leistungsangst, PE & Vaginismus',
                          description:
                              'Über 80% der Menschen mit intimen Beschwerden haben einen chronisch verkrampften Beckenboden (Hypertonie). Bei Frauen führt dies zu Schmerzen beim Verkehr und Vaginismus, bei Männern zu vorzeitiger Ejakulation oder schwankender Erektion. Der Reverse Kegel schaltet das vegetative Nervensystem sofort in den Parasympathikus (Regeneration, Weite & maximale Durchblutung aller Schwellkörper).',
                          color: AppTheme.amber,
                        ),
                        const SizedBox(height: 12),
                        _buildModeComparison(
                          title: 'Klassischer Kegel (Kräftigung & Stabilität)',
                          subtitle: 'Für Halt, Schließkraft & Stabilität',
                          description:
                              'Stärkt die Muskulatur, verbessert den venösen Rückhalt und die Schließmuskelkontrolle. Wichtig: Die Entspannungsphase immer doppelt so lang halten wie das Anspannen!',
                          color: AppTheme.sageGreen,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section 3: Die 4 goldenen Regeln / Typische Fehler
                    _buildSectionCard(
                      title: '3. Typische Fehler vermeiden',
                      badge: 'DON\'TS',
                      badgeColor: AppTheme.rose,
                      children: [
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Po-Backen zusammenkneifen',
                          description: 'Der Gluteus-Muskel ist groß und stark – er schummelt sich gerne ein. Der Po muss weich wie Knete bleiben.',
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Luft anhalten',
                          description: 'Wenn du den Atem blockierst, steigt der Druck im Brustkorb. Atme während des Haltens ruhig durch die Nase weiter.',
                        ),
                        _buildRuleItem(
                          isWarning: true,
                          title: 'Zu viel Krafteinsatz (Pressen)',
                          description: 'Beckenbodentraining ist Neuro-Koordination, kein Powerlifting. 50 bis 70% der Maximalkraft sind ideal.',
                        ),
                        _buildRuleItem(
                          isWarning: false,
                          title: 'Regelmäßigkeit schlägt Dauer',
                          description: '5 bis 10 saubere Runden pro Tag sind 10-mal effektiver als ein langes Workout einmal im Monat.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section 4: Transfer in die Praxis
                    _buildSectionCard(
                      title: '4. Praxistipp für die Intimität',
                      badge: 'IM MOMENT',
                      badgeColor: AppTheme.sageGreen,
                      children: [
                        const Text(
                          'Wenn du im Bett merkst, dass die Erregung zu schnell steigt oder Nervosität einsetzt:\n\n'
                          '1. Verlangsame die Bewegung oder mache eine kurze Atempause.\n'
                          '2. Atme tief in den Bauch ein.\n'
                          '3. Setze einen bewussten Reverse Kegel ein: Lass den Beckenboden nach unten sinken, als wolltest du Raum im Becken schaffen.\n\n'
                          'Du wirst spüren, wie die Erregungswelle sich glättet und dein Herzschlag sich beruhigt.',
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
                        child: const Text('Verstanden, zurück zum Timer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor.withOpacity(0.4)),
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
        color: AppTheme.surfaceLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
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
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
