import 'package:flutter/material.dart';
import '../../models/journal_entry.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../l10n/t.dart';

class CbtNewEntryScreen extends StatefulWidget {
  final CbtJournalEntry? existingEntry;
  final String? presetThought;
  final String? presetDistortion;
  final String? presetReframe;

  const CbtNewEntryScreen({
    super.key,
    this.existingEntry,
    this.presetThought,
    this.presetDistortion,
    this.presetReframe,
  });

  @override
  State<CbtNewEntryScreen> createState() => _CbtNewEntryScreenState();
}

class _CbtNewEntryScreenState extends State<CbtNewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _situationController;
  late TextEditingController _thoughtController;
  late TextEditingController _reframeController;
  final Set<String> _selectedDistortions = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.existingEntry;
    _situationController = TextEditingController(text: entry?.triggerSituation ?? '');
    _thoughtController = TextEditingController(text: entry?.automaticThought ?? (widget.presetThought ?? ''));
    _reframeController = TextEditingController(text: entry?.realityCheckReframe ?? (widget.presetReframe ?? ''));

    if (entry != null) {
      _selectedDistortions.addAll(entry.cognitiveDistortions);
    } else if (widget.presetDistortion != null) {
      _selectedDistortions.add(widget.presetDistortion!);
    }
  }

  @override
  void dispose() {
    _situationController.dispose();
    _thoughtController.dispose();
    _reframeController.dispose();
    super.dispose();
  }

  void _toggleDistortion(String name) {
    setState(() {
      if (_selectedDistortions.contains(name)) {
        _selectedDistortions.remove(name);
      } else {
        _selectedDistortions.add(name);
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDistortions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.cbtNewEntryPleaseChooseAtLeastOne),
          backgroundColor: AppTheme.amber,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final entry = CbtJournalEntry(
      id: widget.existingEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: widget.existingEntry?.timestamp ?? DateTime.now(),
      triggerSituation: _situationController.text.trim(),
      automaticThought: _thoughtController.text.trim(),
      cognitiveDistortions: _selectedDistortions.toList(),
      realityCheckReframe: _reframeController.text.trim(),
    );

    await StorageService.saveCbtEntry(entry);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          widget.existingEntry == null ? t.cbtNewEntryNewThoughtRecord : t.cbtNewEntryEditEntry,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: const Icon(Icons.check, color: AppTheme.sageGreen),
            label: Text(
              t.partnerProfileDialogSave,
              style: TextStyle(
                color: AppTheme.sageGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Intro Callout
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_outlined, color: AppTheme.amber, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.cbtNewEntryCognitiveRestructuringUnmaskIrrationalAlarm,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step 1: Situation
            _buildStepHeader(
              stepNumber: 1,
              title: t.cbtNewEntryTriggerSituation,
              hint: t.cbtNewEntryWhenOrDuringWhatDid,
            ),
            TextFormField(
              controller: _situationController,
              maxLines: 2,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.cbtNewEntryDescribeTheSpecificSituation,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return t.cbtNewEntryPleaseDescribeASituation;
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Step 2: Automatic Thought
            _buildStepHeader(
              stepNumber: 2,
              title: t.cbtNewEntryAutomaticThoughtMentalMovie,
              hint: t.cbtNewEntryWhatShotThroughYourHead,
            ),
            TextFormField(
              controller: _thoughtController,
              maxLines: 2,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.cbtNewEntryNoteTheUnfilteredThought,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return t.cbtNewEntryPleaseNoteYourThought;
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Step 3: Distortions Chips
            _buildStepHeader(
              stepNumber: 3,
              title: t.cbtNewEntryExposeTheCognitiveDistortion,
              hint: t.cbtNewEntryWhichThinkingTrapIsThis,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CbtJournalEntry.availableDistortions.map((distortion) {
                final isSelected = _selectedDistortions.contains(distortion);

                return FilterChip(
                  label: Text(CbtJournalEntry.anzeige(distortion)),
                  selected: isSelected,
                  onSelected: (_) => _toggleDistortion(distortion),
                  selectedColor: AppTheme.amber.withValues(alpha: 0.25),
                  checkmarkColor: AppTheme.amber,
                  backgroundColor: AppTheme.surface,
                  side: BorderSide(
                    color: isSelected ? AppTheme.amber : AppTheme.border,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Step 4: Reframe / Reality Check
            _buildStepHeader(
              stepNumber: 4,
              title: t.cbtNewEntryReappraisalRealityCheck,
              hint: t.cbtNewEntryWhatSTheRealisticView,
            ),
            TextFormField(
              controller: _reframeController,
              maxLines: 4,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.cbtNewEntryEGMyBodyIs,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return t.cbtNewEntryPleasePhraseAReappraisal;
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  _isSaving ? t.cbtNewEntrySaving : t.cbtNewEntrySaveThoughtRecord,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sageGreen,
                  foregroundColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader({
    required int stepNumber,
    required String title,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppTheme.sageGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
