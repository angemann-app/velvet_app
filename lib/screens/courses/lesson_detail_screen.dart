import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/content_models.dart';
import '../../services/storage_service.dart';
import '../../services/audio_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/audio_player_card.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final String courseTitle;
  final void Function(int tabIndex, {String? subTab})? onNavigateToTool;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.courseTitle,
    this.onNavigateToTool,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late TextEditingController _reflectionController;
  bool _isCompleted = false;
  bool _isSavingReflection = false;
  bool _reflectionSavedMessage = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = StorageService.isLessonCompleted(widget.lesson.id);
    final savedAnswer = StorageService.getReflectionAnswer(widget.lesson.id) ?? '';
    _reflectionController = TextEditingController(text: savedAnswer);
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    AudioService().stop();
    TtsService().stop();
    super.dispose();
  }

  Future<void> _toggleCompleted() async {
    final newState = await StorageService.toggleLessonCompleted(widget.lesson.id);
    setState(() {
      _isCompleted = newState;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState
                ? 'Lektion als abgeschlossen markiert! 🎉'
                : 'Lektion wieder als offen markiert.',
          ),
          backgroundColor: newState ? AppTheme.sageGreen : AppTheme.surfaceLight,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveReflection() async {
    setState(() {
      _isSavingReflection = true;
    });
    await StorageService.saveReflectionAnswer(
      widget.lesson.id,
      _reflectionController.text,
    );
    setState(() {
      _isSavingReflection = false;
      _reflectionSavedMessage = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _reflectionSavedMessage = false;
        });
      }
    });
  }

  void _triggerSmartTool() {
    final tool = widget.lesson.linkedTool;
    if (widget.onNavigateToTool != null) {
      if (tool == 'kegel_timer') {
        Navigator.of(context).pop();
        widget.onNavigateToTool!(1, subTab: 'kegel');
      } else if (tool == 'breath_pacer') {
        Navigator.of(context).pop();
        widget.onNavigateToTool!(1, subTab: 'breath');
      } else if (tool == 'cbt_journal') {
        Navigator.of(context).pop();
        widget.onNavigateToTool!(2);
      }
    }
  }

  void _openDiagram(String asset) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: InteractiveViewer(
            maxScale: 5,
            child: Center(child: SvgPicture.asset(asset, fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          widget.courseTitle,
          style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
        ),
        actions: [
          IconButton(
            onPressed: _toggleCompleted,
            icon: Icon(
              _isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
              color: _isCompleted ? AppTheme.sageGreen : AppTheme.textMuted,
              size: 26,
            ),
            tooltip: _isCompleted ? 'Abgeschlossen' : 'Als abgeschlossen markieren',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lesson.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: AppTheme.surfaceLight,
                  child: lesson.image!.endsWith('.svg')
                      // Diagramme in voller Breite; Antippen öffnet sie zum Zoomen.
                      ? GestureDetector(
                          onTap: () => _openDiagram(lesson.image!),
                          child: Stack(
                            children: [
                              // Alle Diagramme sind 800x600.
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: SvgPicture.asset(lesson.image!, fit: BoxFit.contain),
                              ),
                              const Positioned(
                                right: 8,
                                bottom: 8,
                                child: Icon(Icons.zoom_in_rounded, color: Colors.white70, size: 22),
                              ),
                            ],
                          ),
                        )
                      : Image.asset(
                          lesson.image!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Lesson Type & Duration
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: lesson.isAudioExercise
                        ? AppTheme.amber.withOpacity(0.18)
                        : AppTheme.sageGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: lesson.isAudioExercise
                          ? AppTheme.amber.withOpacity(0.4)
                          : AppTheme.sageGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        lesson.isAudioExercise ? Icons.headphones_rounded : Icons.menu_book_rounded,
                        size: 14,
                        color: lesson.isAudioExercise ? AppTheme.amber : AppTheme.sageGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        lesson.isAudioExercise ? 'AUDIO-ÜBUNG' : 'LEKTION',
                        style: TextStyle(
                          color: lesson.isAudioExercise ? AppTheme.amber : AppTheme.sageGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${lesson.durationMin} Min. Lesezeit',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                height: 1.25,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 8),

            // Summary
            Text(
              lesson.summary,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // Audio Player Card
            AudioPlayerCard(
              textToRead: lesson.content,
              contextId: lesson.id,
              durationMin: lesson.durationMin,
              isAudioExercise: lesson.isAudioExercise,
            ),

            // Main Text Content
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: SelectableText(
                lesson.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.65,
                  color: Color(0xFFE2E8F0),
                  letterSpacing: 0.1,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Smart-Action-Button (linked_tool)
            if (lesson.linkedTool != 'none') ...[
              _buildSmartToolCard(lesson.linkedTool),
              const SizedBox(height: 28),
            ],

            // Interactive Reflection Question
            if (lesson.reflectionQuestion.isNotEmpty) ...[
              _buildReflectionCard(lesson.reflectionQuestion),
              const SizedBox(height: 24),
            ],

            // Bottom Complete Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _toggleCompleted,
                icon: Icon(
                  _isCompleted ? Icons.check_circle_rounded : Icons.check_rounded,
                  size: 22,
                ),
                label: Text(
                  _isCompleted
                      ? 'Lektion abgeschlossen (Erledigt)'
                      : 'Lektion als abgeschlossen markieren',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCompleted ? AppTheme.surfaceLight : AppTheme.sageGreen,
                  foregroundColor: _isCompleted ? AppTheme.textPrimary : const Color(0xFF022C22),
                  side: _isCompleted ? const BorderSide(color: AppTheme.border) : null,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartToolCard(String tool) {
    String toolTitle = '';
    String toolSubtitle = '';
    IconData toolIcon = Icons.fitness_center_rounded;
    Color accentColor = AppTheme.sageGreen;

    if (tool == 'kegel_timer') {
      toolTitle = 'Beckenboden-Timer öffnen';
      toolSubtitle = 'Direkt in die Entspannungs- & Kräftigungs-Praxis einsteigen';
      toolIcon = Icons.fitness_center_rounded;
      accentColor = AppTheme.amber;
    } else if (tool == 'breath_pacer') {
      toolTitle = 'Atem-Pacer (Down-Regulation) starten';
      toolSubtitle = 'Vagusnerv aktivieren & Adrenalin senken mit 4-7-8 oder Seufzer';
      toolIcon = Icons.air_rounded;
      accentColor = AppTheme.sageGreen;
    } else if (tool == 'cbt_journal') {
      toolTitle = 'KVT-Gedankenprotokoll starten';
      toolSubtitle = 'Erwartungsangst und innere Katastrophengedanken reframen';
      toolIcon = Icons.psychology_rounded;
      accentColor = AppTheme.sageLight;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(toolIcon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSENDE PRAXIS-ÜBUNG',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      toolTitle,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            toolSubtitle,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _triggerSmartTool,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Jetzt Praxis-Übung starten'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(String question) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppTheme.amber, size: 22),
              const SizedBox(width: 8),
              Text(
                'Deine persönliche Reflexion',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question,
            style: const TextStyle(
              color: AppTheme.amberLight,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _reflectionController,
            maxLines: 4,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Schreibe hier deine ehrlichen Gedanken auf (wird nur lokal auf deinem Gerät gespeichert)...',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_reflectionSavedMessage)
                const Row(
                  children: [
                    Icon(Icons.check, color: AppTheme.sageGreen, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Lokal gespeichert!',
                      style: TextStyle(color: AppTheme.sageGreen, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              else
                const SizedBox(),
              ElevatedButton(
                onPressed: _isSavingReflection ? null : _saveReflection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceLight,
                  foregroundColor: AppTheme.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  side: const BorderSide(color: AppTheme.border),
                ),
                child: _isSavingReflection
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Antwort speichern', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
