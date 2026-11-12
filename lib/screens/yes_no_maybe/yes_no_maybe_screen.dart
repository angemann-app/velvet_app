import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/design/vp_bild_feld.dart';
import '../../widgets/design/vp_komponenten.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/content_models.dart';
import '../../models/yes_no_maybe_models.dart';
import '../../services/auto_backup_service.dart';
import '../../services/data_service.dart';
import '../../services/listen_uebersetzung.dart';
import '../../services/nostr_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import '../courses/lesson_detail_screen.dart';
import '../couples_channel/pairing_modal.dart';
import '../../l10n/t.dart';

class YesNoMaybeScreen extends StatefulWidget {
  const YesNoMaybeScreen({super.key});

  @override
  State<YesNoMaybeScreen> createState() => _YesNoMaybeScreenState();
}

class _YesNoMaybeScreenState extends State<YesNoMaybeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NostrService _nostr = NostrService();

  static const String _storageKey = StorageService.keyYesNoMaybe;
  Map<String, String> _myAnswers = {};
  String _selectedFilter = 'all'; // 'all', 'open', 'yes', 'maybe', 'no'

  VelvetDatabase? _db;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString(_storageKey);
      final db = await DataService.loadDatabase();

      Map<String, String> loaded = {};
      if (storedJson != null && storedJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(storedJson) as Map<String, dynamic>;
          loaded = decoded.map((k, v) => MapEntry(k, v.toString()));
        } catch (e) {
          debugPrint('Error reading stored YesNoMaybe answers: $e');
        }
      }

      // Merge with any votes already present in NostrService
      final nostrVotes = _nostr.myFantasyVotesNotifier.value;
      for (var entry in nostrVotes.entries) {
        if (!loaded.containsKey(entry.key)) {
          loaded[entry.key] = entry.value;
        }
      }

      if (mounted) {
        setState(() {
          _myAnswers = loaded;
          _db = db;
        });
      }
    } catch (e) {
      debugPrint('Error loading initial YesNoMaybe data: $e');
    }
  }

  Future<void> _handleVote(String itemId, YesNoMaybeVote vote) async {
    HapticFeedback.lightImpact();
    final updated = Map<String, String>.from(_myAnswers);
    // If user taps the already active vote, keep it or toggle
    updated[itemId] = vote.key;

    setState(() {
      _myAnswers = updated;
    });

    // 1. Save to local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(updated));
      unawaited(AutoBackupService.saveAutoBackup());
    } catch (e) {
      debugPrint('Error saving YesNoMaybe answers: $e');
    }

    // 2. Synchronize via Nostr if paired
    await _nostr.sendFantasyVote(itemId, vote.key);
  }

  Future<void> _syncWithPartner() async {
    HapticFeedback.mediumImpact();
    if (!_nostr.isPaired) {
      _showPairingPrompt();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.yesNoMaybeMatchingAnswersEncrypted),
        backgroundColor: AppTheme.akzentTief,
        duration: Duration(seconds: 1),
      ),
    );

    final count = await _nostr.syncAllYesNoMaybeVotes(_myAnswers);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.yesNoMaybeCountAnswersMatched(count)),
          backgroundColor: AppTheme.akzent,
        ),
      );
    }
  }

  void _showPairingPrompt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PairingModal(),
    );
  }

  /// Lektion und zugehöriger Kurs für „Mehr erfahren“.
  (Lesson, Course)? _resolveLesson(String? lessonId) {
    if (_db == null || lessonId == null) return null;
    for (final course in _db!.courses) {
      for (final lesson in course.lessons) {
        if (lesson.id == lessonId) return (lesson, course);
      }
    }
    return null;
  }

  void _openDetails(YesNoMaybeItem item) {
    HapticFeedback.selectionClick();
    final linked = _resolveLesson(item.lessonId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: item.image != null ? 0.85 : 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppTheme.linie, width: 1.5)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppTheme.linie,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                item.text,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.tinte,
                    height: 1.3),
              ),
              if (item.image != null) ...[
                const SizedBox(height: 16),
                VpTafel(
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: VpBildFeld.pfad(item.image!,
                        format: VpBildFormat.diagramm),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                item.explanation,
                style: TextStyle(
                    fontSize: 14.5, color: AppTheme.tinteLeise, height: 1.55),
              ),
              if (linked != null) ...[
                const SizedBox(height: 22),
                InkWell(
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(
                            lesson: linked.$1, courseTitle: linked.$2.title),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.akzentTief.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(VpRadius.karte),
                      border: Border.all(
                          color: AppTheme.akzentTief.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book_rounded,
                            color: AppTheme.akzentTief),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.yesNoMaybeReadMore,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.akzentTief,
                                      letterSpacing: 0.6)),
                              const SizedBox(height: 2),
                              Text(linked.$1.title,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.tinte)),
                              Text(linked.$2.title,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.tinteStumm)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: AppTheme.tinteStumm),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.papier,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.couplesChannelFantasyMap,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              t.yesNoMaybeYesMaybeNo,
              style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.akzentTief,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: Listenable.merge([
              _nostr.partnerPubKeyNotifier,
              _nostr.statusNotifier,
            ]),
            builder: (context, _) {
              final isPaired = _nostr.isPaired;
              return IconButton(
                onPressed: _syncWithPartner,
                icon: Icon(
                  Icons.sync_rounded,
                  color: isPaired ? AppTheme.akzentTief : AppTheme.tinteStumm,
                ),
                tooltip: isPaired
                    ? t.yesNoMaybeSyncWithPartner
                    : t.yesNoMaybePairingRequired,
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.papierErhoben,
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border: Border.all(color: AppTheme.linie),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.akzentTief.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(VpRadius.karte),
                border: Border.all(
                    color: AppTheme.akzentTief.withValues(alpha: 0.6)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppTheme.akzentTief,
              unselectedLabelColor: AppTheme.tinteLeise,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: [
                Tab(
                  icon: const Icon(Icons.list_alt_rounded, size: 18),
                  text: t.yesNoMaybeMeineAntworten,
                ),
                Tab(
                  icon: const Icon(Icons.favorite_rounded, size: 18),
                  text: t.yesNoMaybeGemeinsam,
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Structured Questionnaire
          _buildQuestionnaireTab(),

          // Tab 2: Mutual Matches
          _buildMatchesTab(),
        ],
      ),
    );
  }

  Widget _buildQuestionnaireTab() {
    final yesCount = _myAnswers.values.where((v) => v == 'yes').length;
    final maybeCount = _myAnswers.values.where((v) => v == 'maybe').length;
    final noCount = _myAnswers.values.where((v) => v == 'no').length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        // Intro Card with Stats
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.linie),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: AppTheme.akzentTief, size: 20),
                  SizedBox(width: 8),
                  Text(
                    t.yesNoMaybeDigitalSafeSpace,
                    style: TextStyle(
                      color: AppTheme.akzentTief,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                t.yesNoMaybeFindOutWhatExcitesYou,
                style: TextStyle(
                  color: AppTheme.tinteLeise,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatPill(
                      t.yesNoMaybeYes, '$yesCount', AppTheme.statusJa),
                  _buildStatPill(
                      t.yesNoMaybeMaybe, '$maybeCount', AppTheme.akzentTief),
                  _buildStatPill(
                      t.yesNoMaybeNo, '$noCount', AppTheme.akzentTief),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Filter Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                  'all',
                  t.yesNoMaybeAllEintraegelength(
                      ListenUebersetzung.eintraege.length)),
              const SizedBox(width: 8),
              _buildFilterChip('open', t.yesNoMaybeOpen),
              const SizedBox(width: 8),
              _buildFilterChip('yes', t.yesNoMaybeYesYescount(yesCount)),
              const SizedBox(width: 8),
              _buildFilterChip(
                  'maybe', t.yesNoMaybeMaybeMaybecount(maybeCount)),
              const SizedBox(width: 8),
              _buildFilterChip('no', t.yesNoMaybeNoNocount(noCount)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Categories & Items
        ...ListenUebersetzung.kategorien.map((category) {
          final filteredItems = category.items.where((item) {
            final vote = _myAnswers[item.id];
            if (_selectedFilter == 'open') return vote == null || vote.isEmpty;
            if (_selectedFilter == 'yes') return vote == 'yes';
            if (_selectedFilter == 'maybe') return vote == 'maybe';
            if (_selectedFilter == 'no') return vote == 'no';
            return true;
          }).toList();

          if (filteredItems.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  child: SizedBox(
                    height: 96,
                    width: double.infinity,
                    child: VpBildFeld.pfad(category.image,
                        format: VpBildFormat.kopf),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
                child: Row(
                  children: [
                    Icon(category.icon, size: 20, color: AppTheme.akzentTief),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.tinte,
                            ),
                          ),
                          Text(
                            category.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.tinteStumm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Items
              ...filteredItems.map((item) => _buildItemCard(item)),
              const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(VpRadius.feld),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTheme.tinte,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedFilter = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.akzentTief.withValues(alpha: 0.2)
              : AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(
            color: isSelected ? AppTheme.akzentTief : AppTheme.linie,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppTheme.akzentTief : AppTheme.tinteLeise,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(YesNoMaybeItem item) {
    final currentVote = YesNoMaybeVote.fromString(_myAnswers[item.id]);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(
          color: currentVote != null
              ? currentVote.color.withValues(alpha: 0.35)
              : AppTheme.linie,
          width: currentVote != null ? 1.2 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.tinte,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Info Button for linked training
              InkWell(
                onTap: () => _openDetails(item),
                borderRadius: BorderRadius.circular(VpRadius.feld),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.papierVertieft,
                    borderRadius: BorderRadius.circular(VpRadius.feld),
                    border: Border.all(color: AppTheme.linie),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppTheme.akzentTief,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Choice Buttons: Yes / Maybe / No
          Row(
            children: [
              _buildChoiceButton(
                item: item,
                vote: YesNoMaybeVote.yes,
                isActive: currentVote == YesNoMaybeVote.yes,
              ),
              const SizedBox(width: 8),
              _buildChoiceButton(
                item: item,
                vote: YesNoMaybeVote.maybe,
                isActive: currentVote == YesNoMaybeVote.maybe,
              ),
              const SizedBox(width: 8),
              _buildChoiceButton(
                item: item,
                vote: YesNoMaybeVote.no,
                isActive: currentVote == YesNoMaybeVote.no,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton({
    required YesNoMaybeItem item,
    required YesNoMaybeVote vote,
    required bool isActive,
  }) {
    final color = vote.color;

    return Expanded(
      child: InkWell(
        onTap: () => _handleVote(item.id, vote),
        borderRadius: BorderRadius.circular(VpRadius.karte),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.2) : AppTheme.papier,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(
              color: isActive ? color : AppTheme.linie,
              width: isActive ? 1.6 : 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? vote.icon : Icons.circle_outlined,
                size: 14,
                color: isActive ? color : AppTheme.tinteStumm,
              ),
              const SizedBox(width: 6),
              Flexible(
                  child: Text(
                vote.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? color : AppTheme.tinteLeise,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchesTab() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _nostr.partnerPubKeyNotifier,
        _nostr.partnerNameNotifier,
        _nostr.myFantasyVotesNotifier,
        _nostr.partnerFantasyVotesNotifier,
        _nostr.statusNotifier,
      ]),
      builder: (context, _) {
        final isPaired = _nostr.isPaired;
        final partnerName = _nostr.partnerName;
        final partnerVotes = _nostr.partnerFantasyVotesNotifier.value;

        if (!isPaired) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.akzentTief.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppTheme.akzentTief.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Icon(Icons.favorite_border_rounded,
                          size: 36, color: AppTheme.akzentTief),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.yesNoMaybePairingRequired2,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.tinte),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.yesNoMaybeConnectWithYourPartnerIn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: AppTheme.tinteLeise, height: 1.45),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showPairingPrompt,
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                    label: Text(t.yesNoMaybePairViaQrCodeNow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.akzentTief,
                      foregroundColor: AppTheme.papier,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Calculate direct Yes-Yes matches and Yes-Maybe / Maybe-Maybe curiosity matches
        final yesMatches = <YesNoMaybeItem>[];
        final curiosityMatches = <YesNoMaybeItem>[];

        for (var item in ListenUebersetzung.eintraege) {
          final myV = _myAnswers[item.id] ??
              _nostr.myFantasyVotesNotifier.value[item.id];
          final pV = partnerVotes[item.id];

          if (myV == 'yes' && pV == 'yes') {
            yesMatches.add(item);
          } else if ((myV == 'yes' && pV == 'maybe') ||
              (myV == 'maybe' && pV == 'yes') ||
              (myV == 'maybe' && pV == 'maybe')) {
            curiosityMatches.add(item);
          }
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Banner nur bei gemeinsamen Antworten; sonst nur der leise Leer-Zustand unten
            if (yesMatches.isNotEmpty || curiosityMatches.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.statusJa.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  border: Border.all(
                      color: AppTheme.statusJa.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_border_rounded,
                            color: AppTheme.statusJa, size: 22),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            t.yesNoMaybePerfectMatchWithPartnername(
                                partnerName),
                            style: TextStyle(
                              color: AppTheme.statusJa,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.yesNoMaybeYesmatcheslengthSharedYesesCuriositymatcheslengthPoints(
                          yesMatches.length, curiosityMatches.length),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.tinte,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.yesNoMaybeNoRejectionAllLimitsWere,
                      style: TextStyle(
                          color: AppTheme.tinteLeise,
                          fontSize: 12.5,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 1. Direct YES-Matches
            if (yesMatches.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppTheme.statusJa, size: 18),
                  SizedBox(width: 8),
                  Text(
                    t.yesNoMaybePerfectMatchBothSaidYes,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.tinte,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...yesMatches
                  .map((item) => _buildMatchCard(item, isDirectYes: true)),
              const SizedBox(height: 20),
            ],

            // 2. CURIOSITY Matches (Yes/Maybe or Maybe/Maybe)
            if (curiosityMatches.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.help_outline_rounded,
                      color: AppTheme.akzentTief, size: 18),
                  SizedBox(width: 8),
                  Text(
                    t.yesNoMaybeSharedCuriosityOpenToExploring,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.tinte,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...curiosityMatches
                  .map((item) => _buildMatchCard(item, isDirectYes: false)),
              const SizedBox(height: 20),
            ],

            if (yesMatches.isEmpty && curiosityMatches.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.papierErhoben,
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  border: Border.all(color: AppTheme.linie),
                ),
                child: Column(
                  children: [
                    Icon(Icons.spa_outlined,
                        color: AppTheme.akzentTief, size: 36),
                    SizedBox(height: 12),
                    Text(
                      t.yesNoMaybeNoMatchesYet,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      t.yesNoMaybeBothKeepVotingInThe,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.tinteLeise,
                          fontSize: 13,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMatchCard(YesNoMaybeItem item, {required bool isDirectYes}) {
    final color = isDirectYes ? AppTheme.statusJa : AppTheme.akzentTief;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDirectYes ? Icons.favorite_rounded : Icons.explore_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.tinte,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDirectYes
                      ? t.yesNoMaybeYouBothYes
                      : t.yesNoMaybeCuriousTogether,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _openDetails(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withValues(alpha: 0.2),
              foregroundColor: color,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(VpRadius.feld),
                side: BorderSide(color: color.withValues(alpha: 0.5)),
              ),
            ),
            child: Text(t.yesNoMaybeCourse,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
