import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/content_models.dart';
import '../../services/nostr_service.dart';
import '../../services/pakete.dart';
import '../../services/personalize.dart';
import '../../services/storage_service.dart';
import '../../services/audio_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import '../../widgets/design/vp_bild_feld.dart';
import '../../widgets/design/vp_komponenten.dart';
import '../../widgets/design/vp_grafik.dart';
import '../../widgets/audio_player_card.dart';
import '../self_exploration/lust_profile_screen.dart';
import '../self_exploration/selbst_reise_screen.dart';
import '../couples_channel/paar_abend_screen.dart';
import '../../l10n/t.dart';

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
    _spicyBilderLaden();
  }

  /// Spicy-Bilder kommen aus dem Nur-R2-Paket. Fehlt es, lädt die App es still nach (Fehler bleiben still, die Lektion
  /// funktioniert ohne Bild).
  Future<void> _spicyBilderLaden() async {
    final l = widget.lesson;
    if (l.bilder.isEmpty || !StorageService.spicyMode()) return;
    if (Pakete.version(Pakete.kurseBilderSpicy) > 0) return;
    try {
      await Pakete.laden(Pakete.kurseBilderSpicy);
    } catch (_) {
      return;
    }
    if (mounted) setState(() {});
  }

  /// Stimmungsbilder der Spicy-Lektionen und der Lektionen mit zweiter Spicy-Bildfassung: 240 hoch, nebeneinander, den Text
  /// begleitend (Antippen vergrößert). Nur im Spicy-Modus und nur, wenn das Paket da ist.
  Widget _spicyBilder(Lesson l) {
    if (l.bilder.isEmpty || !StorageService.spicyMode()) return const SizedBox.shrink();
    final dateien = [
      for (final b in l.bilder)
        if (Pakete.datei(b) case final pfad?)
          (pfad: pfad, beschriftung: b.contains('_allein') ? t.kursBildAllein : (b.contains('_zweit') ? t.kursBildZuZweit : null)),
    ];
    if (dateien.isEmpty) return const SizedBox.shrink();
    // Bleistift-Studien (`…_spicy.webp`) sind Querformat 16:9, die Praxis-Bilder Hochformat.
    bool quer(String pfad) => pfad.endsWith('_spicy.webp');
    final hoehe = dateien.every((d) => quer(d.pfad)) ? 200.0 : 240.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        height: hoehe,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dateien.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => _spicyBildGross(dateien[i].pfad),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(VpRadius.karte),
              child: SizedBox(
                width: quer(dateien[i].pfad) ? hoehe * 16 / 9 : 160,
                child: Stack(fit: StackFit.expand, children: [
                  VpBildFeld.datei(dateien[i].pfad, format: quer(dateien[i].pfad) ? VpBildFormat.studie : VpBildFormat.hoch, cacheBreite: quer(dateien[i].pfad) ? 640 : 480),
                  if (dateien[i].beschriftung != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        color: Colors.black54,
                        child: Text(dateien[i].beschriftung!, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _spicyBildGross(String pfad) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: InteractiveViewer(maxScale: 4, child: Center(child: Image.file(File(pfad), fit: BoxFit.contain))),
        ),
      ),
    );
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
                ? t.lessonDetailLessonMarkedAsCompleted
                : t.lessonDetailLessonMarkedAsOpenAgain,
          ),
          backgroundColor: newState ? AppTheme.akzentTief : AppTheme.papierVertieft,
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
      _reflectionSavedMessage = true; // macht auch eine geteilte Antwort des Gegenübers sichtbar
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _reflectionSavedMessage = false;
        });
      }
    });
  }

  final NostrService _nostr = NostrService();

  /// Name und Geschlecht des Gegenübers für die persönliche Ansprache, sofern gekoppelt und eingeschaltet.
  PersonalizeContext get _personalizeContext {
    if (!_nostr.isPaired || !StorageService.personalizeNames()) return PersonalizeContext.none;
    return PersonalizeContext(
      partnerName: _nostr.partnerName,
      partnerGender: _nostr.partnerGenderNotifier.value,
      myGender: StorageService.getUserProfile()?.gender,
    );
  }

  Future<void> _shareLesson() async {
    final ok = await _nostr.sendLessonShare(widget.lesson.id, widget.lesson.title, widget.courseTitle);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? t.lessonDetailLessonSentToPartnername(_nostr.partnerName)
          : t.lessonDetailSendingDidnTWorkPlease),
      backgroundColor: ok ? AppTheme.akzentTief : AppTheme.akzentTief,
    ));
  }

  /// Die Antwort geht verschlüsselt an das Gegenüber. Dort wird sie erst sichtbar,
  /// wenn es die Frage selbst beantwortet hat – und umgekehrt.
  Future<void> _shareReflection() async {
    final answer = _reflectionController.text.trim();
    if (answer.isEmpty) return;
    await StorageService.saveReflectionAnswer(widget.lesson.id, answer);
    final ok = await _nostr.sendReflection(widget.lesson.id, widget.lesson.title, answer);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? t.lessonDetailYourThoughtsAreWithPartnername(_nostr.partnerName)
          : t.lessonDetailSendingDidnTWorkPlease),
      backgroundColor: ok ? AppTheme.akzentTief : AppTheme.akzentTief,
    ));
  }

  Widget _buildPartnerReflection() {
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: _nostr.partnerReflectionsNotifier,
      builder: (context, reflections, _) {
        final theirs = reflections[widget.lesson.id];
        if (theirs == null || !_nostr.isPaired) return const SizedBox.shrink();
        final mine = StorageService.getReflectionAnswer(widget.lesson.id)?.trim() ?? '';
        final name = _nostr.partnerName;
        return Container(
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.akzentTief.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(mine.isEmpty ? Icons.lock_outline_rounded : Icons.favorite_rounded,
                      color: AppTheme.akzentTief, size: 16),
                  const SizedBox(width: 6),
                  Text(mine.isEmpty ? t.lessonDetailNameHasAlreadyAnswered(name) : t.lessonDetailNameSThoughts(name),
                      style: TextStyle(color: AppTheme.tinte, fontSize: 13.5, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                mine.isEmpty ? t.lessonDetailWriteAndSaveYourOwn(name) : theirs,
                style: TextStyle(
                  color: mine.isEmpty ? AppTheme.tinteStumm : AppTheme.tinte,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _triggerSmartTool() {
    final tool = widget.lesson.linkedTool;
    if (tool == 'lust_profil') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LustProfileScreen()));
      return;
    }
    if (tool == 'selbst_reise') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SelbstReiseScreen()));
      return;
    }
    if (tool == 'paar_abend') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen()));
      return;
    }
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
            child: Center(child: VpBildFeld.pfad(asset, format: VpBildFormat.diagramm, fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: AppTheme.papier,
      appBar: AppBar(
        title: Text(
          widget.courseTitle,
          style: TextStyle(fontSize: 16, color: AppTheme.tinteLeise),
        ),
        actions: [
          if (_nostr.isPaired)
            IconButton(
              onPressed: _shareLesson,
              icon: Icon(Icons.favorite_border_rounded, color: AppTheme.akzentTief),
              tooltip: t.lessonDetailShareWithPartnername(_nostr.partnerName),
            ),
          IconButton(
            onPressed: _toggleCompleted,
            icon: Icon(
              _isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
              color: _isCompleted ? AppTheme.akzentTief : AppTheme.tinteStumm,
              size: 26,
            ),
            tooltip: _isCompleted ? t.lessonDetailCompleted : t.lessonDetailMarkAsCompleted,
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
                borderRadius: BorderRadius.circular(VpRadius.karte),
                child: Container(
                  color: AppTheme.papierVertieft,
                  child: lesson.image!.endsWith('.svg')
                      // Diagramme in voller Breite; Antippen öffnet sie zum Zoomen.
                      ? GestureDetector(
                          onTap: () => _openDiagram(lesson.image!),
                          child: Stack(
                            children: [
                              // Alle Diagramme sind 800x600.
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: VpBildFeld.pfad(lesson.image!, format: VpBildFormat.diagramm),
                              ),
                              const Positioned(
                                right: 8,
                                bottom: 8,
                                child: Icon(Icons.zoom_in_rounded, color: Colors.white70, size: 22),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: 160, width: double.infinity, child: VpBildFeld.pfad(lesson.image!, format: VpBildFormat.kopf)),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (lesson.zeichnung != null) ...[
              // Körperzeichnung (16:9) mit Beschriftung; Antippen öffnet sie zum Zoomen.
              ClipRRect(
                borderRadius: BorderRadius.circular(VpRadius.karte),
                child: GestureDetector(
                  onTap: () => _openDiagram(lesson.zeichnung!),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VpBildFeld.pfad(lesson.zeichnung!, format: VpBildFormat.studie),
                      ),
                      const Positioned(
                        right: 8,
                        bottom: 8,
                        child: Icon(Icons.zoom_in_rounded, color: Colors.black54, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _spicyBilder(lesson),

            // Kopf im Magazinstil: Eyebrow (Kurs, Art, Dauer), Serif-Titel, Einleitung, Haarlinie.
            VpEyebrow('${widget.courseTitle} · ${lesson.isAudioExercise ? t.lessonDetailAudioExercise : t.lessonDetailLesson} · ${t.lessonDetailDurationminMinRead(lesson.durationMin)}'),
            const SizedBox(height: VpAbstand.s),
            Text(lesson.title, style: context.vp.typo.anzeige.copyWith(fontSize: 30)),
            const SizedBox(height: VpAbstand.m),
            Text(lesson.summary, style: context.vp.typo.fliesstext.copyWith(color: AppTheme.tinteLeise, fontSize: 16.5, height: 1.55)),
            const SizedBox(height: VpAbstand.l),
            VpGrafik.trenner(id: 'linie.mass'),
            const SizedBox(height: VpAbstand.l),
            // Audio Player Card
            AudioPlayerCard(
              textToRead: stripPersonalization(lesson.content),
              contextId: lesson.id,
              durationMin: lesson.durationMin,
              isAudioExercise: lesson.isAudioExercise,
              meldeOrt: '${widget.courseTitle}, „${lesson.title}“ (${lesson.id})',
            ),

            // Haupttext: kein Kasten, nur Typografie und Raum.
            SelectableText(
              personalize(lesson.content, _personalizeContext.forPerspective(lesson.perspective)),
              style: context.vp.typo.fliesstext.copyWith(fontSize: 16.5, height: 1.7, letterSpacing: 0.1),
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
                      ? t.lessonDetailLessonCompletedDone
                      : t.lessonDetailMarkLessonAsCompleted,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCompleted ? AppTheme.papierVertieft : AppTheme.akzentTief,
                  foregroundColor: _isCompleted ? AppTheme.tinte : AppTheme.aufAkzent,
                  side: _isCompleted ? BorderSide(color: AppTheme.linie) : null,
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
    Color accentColor = AppTheme.akzentTief;

    if (tool == 'kegel_timer') {
      toolTitle = t.lessonDetailOpenPelvicFloorTimer;
      toolSubtitle = t.lessonDetailGoStraightIntoRelaxationStrengthening;
      toolIcon = Icons.fitness_center_rounded;
      accentColor = AppTheme.akzentTief;
    } else if (tool == 'breath_pacer') {
      toolTitle = t.lessonDetailStartBreathPacerDownRegulation;
      toolSubtitle = t.lessonDetailCalmDownWithBreathingOr;
      toolIcon = Icons.air_rounded;
      accentColor = AppTheme.akzentTief;
    } else if (tool == 'lust_profil') {
      toolTitle = t.lessonDetailMyDesireProfile;
      toolSubtitle = t.lessonDetailTickWhatYouLikeAnd;
      toolIcon = Icons.favorite_rounded;
      accentColor = AppTheme.akzentTief;
    } else if (tool == 'selbst_reise') {
      toolTitle = t.lessonDetailGuidedSelfExploration;
      toolSubtitle = t.lessonDetailToMinutesAVoiceGuides;
      toolIcon = Icons.spa_rounded;
      accentColor = AppTheme.akzentTief;
    } else if (tool == 'paar_abend') {
      toolTitle = t.lessonDetailTryGuidedEvening;
      toolSubtitle = t.couplesChannelGuidedTouchForTheTwo;
      toolIcon = Icons.favorite_rounded;
      accentColor = AppTheme.akzentTief;
    } else if (tool == 'cbt_journal') {
      toolTitle = t.lessonDetailStartCbtThoughtRecord;
      toolSubtitle = t.lessonDetailReframeAnticipatoryAnxietyAndCatastrophic;
      toolIcon = Icons.psychology_rounded;
      accentColor = AppTheme.akzentTief;
    }

    accentColor = AppTheme.akzentTief;
    return VpKarte(
      rahmen: VpRahmen.akzent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
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
                      t.lessonDetailMatchingPractice,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      toolTitle,
                      style: TextStyle(
                        color: AppTheme.tinte,
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
            style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _triggerSmartTool,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(t.lessonDetailStartThePracticeNow),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppTheme.aufAkzent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(String question) {
    return VpKarte(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppTheme.akzentTief, size: 22),
              SizedBox(width: 8),
              Text(
                t.lessonDetailYourPersonalReflection,
                style: TextStyle(
                  color: AppTheme.tinte,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question,
            style: TextStyle(
              color: AppTheme.tinteLeise,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _reflectionController,
            maxLines: 4,
            style: TextStyle(color: AppTheme.tinte, fontSize: 14),
            decoration: InputDecoration(
              hintText: t.lessonDetailWriteDownYourHonestThoughts,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_reflectionSavedMessage)
                Row(
                  children: [
                    Icon(Icons.check, color: AppTheme.akzentTief, size: 16),
                    SizedBox(width: 4),
                    Text(
                      t.lessonDetailSavedLocally,
                      style: TextStyle(color: AppTheme.akzentTief, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              else
                const SizedBox(),
              ElevatedButton(
                onPressed: _isSavingReflection ? null : _saveReflection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.papierVertieft,
                  foregroundColor: AppTheme.tinte,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  side: BorderSide(color: AppTheme.linie),
                ),
                child: _isSavingReflection
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(t.lessonDetailSaveAnswer, style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          if (_nostr.isPaired) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _shareReflection,
                icon: Icon(Icons.favorite_border_rounded, size: 16, color: AppTheme.akzentTief),
                label: Text(t.lessonDetailShareWithPartnername2(_nostr.partnerName),
                    style: TextStyle(color: AppTheme.akzentTief, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          _buildPartnerReflection(),
        ],
      ),
    );
  }
}
