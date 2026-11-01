import 'package:flutter/material.dart';
import '../../theme/vp_tokens.dart';
import 'package:intl/intl.dart';
import '../../models/journal_entry.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../l10n/t.dart';
import '../../services/sprache.dart';
import 'cbt_new_entry_screen.dart';
import 'belief_library_view.dart';
import '../../widgets/design/vp_tabs.dart';
import '../../widgets/design/vp_komponenten.dart';

class CbtJournalScreen extends StatefulWidget {
  const CbtJournalScreen({super.key});

  @override
  State<CbtJournalScreen> createState() => _CbtJournalScreenState();
}

class _CbtJournalScreenState extends State<CbtJournalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CbtJournalEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEntries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadEntries() {
    setState(() {
      _entries = StorageService.getCbtEntries();
      _isLoading = false;
    });
  }

  void _openNewEntry({CbtJournalEntry? existing}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CbtNewEntryScreen(existingEntry: existing),
      ),
    );
    if (result == true) {
      _loadEntries();
      if (_tabController.index != 0) {
        _tabController.animateTo(0);
      }
    }
  }

  void _confirmDelete(CbtJournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.cbtJournalDeleteEntry),
        content: Text(
          t.cbtJournalDoYouReallyWantTo,
          style: TextStyle(color: AppTheme.tinteLeise),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.ausspracheMeldenCancel, style: TextStyle(color: AppTheme.tinteStumm)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await StorageService.deleteCbtEntry(entry.id);
              _loadEntries();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.akzent,
              foregroundColor: AppTheme.aufAkzent,
            ),
            child: Text(t.cbtJournalDelete),
          ),
        ],
      ),
    );
  }

  /// Datum im Format der App-Sprache (24.10.2026 bzw. 10/24/2026).
  String _formatDate(DateTime dt) {
    try {
      return DateFormat.yMd(Sprache.code).format(dt);
    } catch (_) {
      // Ohne geladene Datumsformate (z. B. in Tests): deutsche Schreibweise.
    }
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.akzentTief),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.papier,
      // Leerer Zustand hat eigene Buttons; die FAB erst zeigen, wenn es Einträge gibt.
      floatingActionButton: _tabController.index == 0 && _entries.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _openNewEntry(),
              backgroundColor: AppTheme.akzent,
              foregroundColor: AppTheme.aufAkzent,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                t.cbtJournalNewEntry,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: Column(
        children: [
          // Segmented Bar
          VpTabs.leiste(
            controller: _tabController,
            onTap: (_) => setState(() {}),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_note_rounded, size: 16),
                    const SizedBox(width: 8),
                    Flexible(child: Text(t.cbtJournalMyRecordsEntrieslength(_entries.length), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books_rounded, size: 16),
                    SizedBox(width: 8),
                    Flexible(child: Text(t.cbtJournalBeliefs, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _entries.isEmpty ? _buildEmptyState() : _buildList(),
                BeliefLibraryView(
                  onEntryAdded: () {
                    _loadEntries();
                    _tabController.animateTo(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VpLeerzustand(
              icon: Icons.psychology_outlined,
              titel: t.cbtJournalNoThoughtRecordsYet,
              text: t.cbtJournalWhenYourHeadBlocksBefore,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openNewEntry(),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(t.cbtJournalNewRecord),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.akzent,
                  foregroundColor: AppTheme.aufAkzent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _tabController.animateTo(1),
                icon: const Icon(Icons.library_books_rounded, size: 18),
                label: Text(t.cbtJournalStartWithABelief),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
      itemCount: _entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeaderBanner();
        }
        final entry = _entries[index - 1];
        return _buildEntryCard(entry);
      },
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.akzentTief.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_note_rounded, color: AppTheme.akzentTief, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.cbtJournalCognitiveRestructuring,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.tinte,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t.cbtJournalProtocolsSaved(_entries.length),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.tinteLeise,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(CbtJournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 13, color: AppTheme.tinteStumm),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(entry.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.tinteStumm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: AppTheme.tinteStumm, size: 20),
                  color: AppTheme.papierVertieft,
                  onSelected: (val) {
                    if (val == 'edit') {
                      _openNewEntry(existing: entry);
                    } else if (val == 'delete') {
                      _confirmDelete(entry);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, size: 16, color: AppTheme.tinteLeise),
                          SizedBox(width: 8),
                          Text(t.cbtJournalEdit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.akzentTief),
                          SizedBox(width: 8),
                          Text(t.cbtJournalDelete, style: TextStyle(color: AppTheme.akzentTief)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Situation
            Text(
              entry.triggerSituation,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.tinte,
              ),
            ),

            const SizedBox(height: 10),

            // Automatic Thought Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.papierVertieft.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(VpRadius.karte),
                border: Border(
                  left: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.8), width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.cbtJournalAutomaticThoughtAlarm,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.akzentTief,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.cbtJournalAutomaticthought(entry.automaticThought),
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.tinteLeise,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Cognitive Distortions Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: entry.cognitiveDistortions.map((d) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.akzentTief.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(VpRadius.chip),
                    border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    CbtJournalEntry.anzeige(d),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.akzentTief,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Reframe / Reality Check Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.akzentTief.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(VpRadius.karte),
                border: Border(
                  left: BorderSide(color: AppTheme.akzentTief, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.cbtJournalReappraisalRealityCheck,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.akzentTief,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.realityCheckReframe,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.tinte,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
