import 'package:flutter/material.dart';
import '../../models/content_models.dart';
import '../../services/data_service.dart';
import '../../theme/app_theme.dart';
import 'cbt_new_entry_screen.dart';

class BeliefLibraryView extends StatelessWidget {
  final VoidCallback? onEntryAdded;

  const BeliefLibraryView({super.key, this.onEntryAdded});

  void _transferToJournal(BuildContext context, BeliefCard card) async {
    // Map category to nearest available distortion
    String distortion = 'Alles-oder-Nichts-Denken';
    if (card.category.contains('Spectatoring')) {
      distortion = 'Spectatoring / Selbstbeobachtung';
    } else if (card.category.contains('Vergleich')) {
      distortion = 'Katastrophisieren';
    } else if (card.category.contains('Verantwortung') || card.category.contains('Identität')) {
      distortion = 'Leistungsdruck';
    }

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CbtNewEntryScreen(
          presetThought: card.irrationalThought,
          presetDistortion: distortion,
          presetReframe: '${card.realityCheck}\n\nPraktischer Shift: ${card.practicalShift}',
        ),
      ),
    );

    if (result == true && onEntryAdded != null) {
      onEntryAdded!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final beliefs = DataService.getBeliefLibrary();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Intro Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.library_books_rounded, color: AppTheme.amber, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Glaubenssätze-Baukasten',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Die häufigsten mentalen Fallen bei Leistungsangst – und die biologische Wahrheit dahinter. Tippe auf eine Karte, um sie direkt in dein eigenes Journal zu übernehmen.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        ...beliefs.map((belief) => _buildBeliefCard(context, belief)),
      ],
    );
  }

  Widget _buildBeliefCard(BuildContext context, BeliefCard belief) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.amber.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.amber.withOpacity(0.4)),
                  ),
                  child: Text(
                    belief.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.amberLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (belief.target != 'all') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: belief.target == 'women'
                          ? const Color(0xFFFB7185).withOpacity(0.18)
                          : AppTheme.sageGreen.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: belief.target == 'women'
                            ? const Color(0xFFFB7185).withOpacity(0.5)
                            : AppTheme.sageGreen.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      belief.target == 'women' ? 'FÜR SIE 🌸' : 'FÜR IHN 🌿',
                      style: TextStyle(
                        color: belief.target == 'women'
                            ? const Color(0xFFFB7185)
                            : AppTheme.sageGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Irrational Thought (Innere Falle)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.rose.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: AppTheme.rose.withOpacity(0.8), width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TYPISCHER IRRGLAUBE (KOPFKINO)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.rose,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '„${belief.irrationalThought}“',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFFECDD3),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Reality Check (Biologischer Realitätscheck)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.sageGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: const BorderSide(color: AppTheme.sageGreen, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BIOLOGISCHER REALITÄTSCHECK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.sageGreen,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    belief.realityCheck,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Practical Shift
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.swap_horiz_rounded, color: AppTheme.sageLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    belief.practicalShift,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Button: In Journal übernehmen
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _transferToJournal(context, belief),
                icon: const Icon(Icons.edit_note_rounded, size: 18, color: AppTheme.amberLight),
                label: const Text(
                  'In eigenes Journal übernehmen',
                  style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.border),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
