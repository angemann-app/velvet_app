import 'package:flutter/material.dart';
import '../../theme/vp_tokens.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../l10n/t.dart';

class ApiKeyGuideSheet extends StatelessWidget {
  final VoidCallback? onOpenKeyDialog;

  const ApiKeyGuideSheet({super.key, this.onOpenKeyDialog});

  static void show(BuildContext context, {VoidCallback? onOpenKeyDialog}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApiKeyGuideSheet(onOpenKeyDialog: onOpenKeyDialog),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.linie,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.akzentTief.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                  ),
                  child: Icon(Icons.key_rounded, color: AppTheme.akzentTief, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.apiKeyGuideSheetFreeGeminiApiKey,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.tinte,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        t.apiKeyGuideSheetCreatedStepByStepIn,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.tinteLeise,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppTheme.tinteStumm),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.linie, height: 1),

          // Steps list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.papierVertieft,
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    border: Border.all(color: AppTheme.linie),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_outlined, color: AppTheme.akzentTief, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.4),
                            children: [
                              TextSpan(
                                text: t.apiKeyGuideSheetFreeAndWhatHappensTo,
                                style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.tinte),
                              ),
                              TextSpan(
                                text:
                                    t.apiKeyGuideSheetGoogleAiStudioHasA,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Step 1
                _buildStep(
                  context,
                  stepNumber: '1',
                  title: t.apiKeyGuideSheetOpenGoogleAiStudio,
                  description:
                      t.apiKeyGuideSheetOpenGoogleSOfficialDeveloper,
                  actionWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.papier,
                      borderRadius: BorderRadius.circular(VpRadius.karte),
                      border: Border.all(color: AppTheme.linie),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.link_rounded, color: AppTheme.akzentTief, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'https://aistudio.google.com',
                            style: TextStyle(
                              color: AppTheme.akzentTief,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'https://aistudio.google.com'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t.apiKeyGuideSheetLinkCopiedToClipboard),
                                duration: Duration(seconds: 2),
                                backgroundColor: AppTheme.akzent,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(VpRadius.chip),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.papierVertieft,
                              borderRadius: BorderRadius.circular(VpRadius.chip),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.copy_rounded, color: AppTheme.tinte, size: 14),
                                SizedBox(width: 4),
                                Text(t.apiKeyGuideSheetCopy, style: TextStyle(color: AppTheme.tinte, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Step 2
                _buildStep(
                  context,
                  stepNumber: '2',
                  title: t.apiKeyGuideSheetSignInWithAGoogle,
                  description:
                      t.apiKeyGuideSheetSignInWithYourExisting,
                ),

                const SizedBox(height: 16),

                // Step 3
                _buildStep(
                  context,
                  stepNumber: '3',
                  title: t.apiKeyGuideSheetClickGetApiKey,
                  description:
                      t.apiKeyGuideSheetInTheMenuAtThe,
                ),

                const SizedBox(height: 16),

                // Step 4
                _buildStep(
                  context,
                  stepNumber: '4',
                  title: t.apiKeyGuideSheetChooseCreateApiKeyIn,
                  description:
                      t.apiKeyGuideSheetChooseTheOptionCreateApi,
                ),

                const SizedBox(height: 16),

                // Step 5
                _buildStep(
                  context,
                  stepNumber: '5',
                  title: t.apiKeyGuideSheetCopyTheKeyPasteIt,
                  description:
                      t.apiKeyGuideSheetCopyTheGeneratedStringIt,
                ),

                const SizedBox(height: 24),

                // FAQ Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.papierVertieft.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    border: Border.all(color: AppTheme.linie.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.apiKeyGuideSheetFrequentlyAskedQuestions,
                        style: TextStyle(
                          color: AppTheme.tinte,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildFaqItem(
                        t.apiKeyGuideSheetDoesItCostAnything,
                        t.apiKeyGuideSheetNotWithinTheFreeTier,
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        t.apiKeyGuideSheetWhichModelIsUsed,
                        t.apiKeyGuideSheetVelvetpulseAutomaticallyFindsTheLatest,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom CTA Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: AppTheme.papierErhoben,
              border: Border(top: BorderSide(color: AppTheme.linie)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onOpenKeyDialog != null) {
                    onOpenKeyDialog!();
                  }
                },
                icon: const Icon(Icons.key_rounded, size: 20),
                label: Text(
                  t.apiKeyGuideSheetEnterApiKeyConnectNow,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.akzentTief,
                  foregroundColor: AppTheme.papier,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String description,
    Widget? actionWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierVertieft,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie.withValues(alpha: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.akzentTief.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.akzentTief, width: 1.5),
            ),
            child: Text(
              stepNumber,
              style: TextStyle(
                color: AppTheme.akzentTief,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.tinte,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.tinteLeise,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                if (actionWidget != null) ...[
                  const SizedBox(height: 8),
                  actionWidget,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $question',
          style: TextStyle(
            color: AppTheme.akzentTief,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            answer,
            style: TextStyle(
              color: AppTheme.tinteStumm,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
