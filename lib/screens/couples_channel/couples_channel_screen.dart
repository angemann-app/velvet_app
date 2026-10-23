import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/couple_channel_models.dart';
import '../../services/data_service.dart';
import '../../services/nostr_service.dart';
import '../courses/lesson_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../yes_no_maybe/yes_no_maybe_screen.dart';
import 'invite_partner.dart';
import 'paar_abend_screen.dart';
import 'pairing_modal.dart';

/// Schnelle Funken: ein Tippen sagt, worauf man heute Lust hat – oder eben nicht.
const List<(String, String)> _sparks = [
  ('🔥', 'Lust auf dich'),
  ('🌿', 'Heute nur kuscheln'),
  ('🥂', 'Freu mich auf später'),
  ('🐢', 'Heute ganz langsam'),
  ('💬', 'Lass uns reden'),
  ('🌙', 'Heute lieber nicht'),
];

class CouplesChannelScreen extends StatefulWidget {
  const CouplesChannelScreen({super.key});

  @override
  State<CouplesChannelScreen> createState() => _CouplesChannelScreenState();
}

class _CouplesChannelScreenState extends State<CouplesChannelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _subTabController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final NostrService _nostr = NostrService();

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this);
    _nostr.init();
  }

  @override
  void dispose() {
    _subTabController.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openPairingModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PairingModal(),
    );
  }

  void _openFantasyMap() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const YesNoMaybeScreen()),
    );
  }

  void _sendSpark(String emoji, String text) async {
    HapticFeedback.mediumImpact();
    final success = await _nostr.sendQuickPing(emoji, text);
    if (!mounted) return;
    if (success) {
      _scrollToBottom();
    } else {
      _showSendError();
    }
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear();
    HapticFeedback.lightImpact();

    final success = await _nostr.sendChatMessage(text);
    if (!mounted) return;
    if (success) {
      _scrollToBottom();
    } else {
      _chatController.text = text;
      _showSendError();
    }
  }

  void _showSendError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Senden hat nicht geklappt. Bitte gleich noch einmal versuchen.'),
        backgroundColor: AppTheme.rose,
        action: SnackBarAction(
          label: 'Neu verbinden',
          textColor: Colors.white,
          onPressed: _nostr.reconnectNextRelay,
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ValueListenableBuilder<String?>(
          valueListenable: _nostr.partnerPubKeyNotifier,
          builder: (context, _, __) => _nostr.isPaired ? _buildPaired() : _buildWelcome(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Noch nicht verbunden

  Widget _buildWelcome() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SvgPicture.asset(
            'assets/images/cover_11.svg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Euer privater Raum',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verbinde dich mit deinem Gegenüber und teilt Wünsche, die sonst schwer auszusprechen sind.',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.45),
        ),
        const SizedBox(height: 20),
        _buildFeature(
          Icons.bolt_rounded,
          AppTheme.amber,
          'Funken senden',
          'Mit einem Tippen zeigen, worauf du heute Lust hast – oder eben nicht.',
        ),
        _buildFeature(
          Icons.favorite_rounded,
          AppTheme.rose,
          'Wünsche heimlich abgleichen',
          'Ihr stimmt getrennt ab. Sichtbar wird nur, was ihr beide wollt.',
        ),
        _buildFeature(
          Icons.lock_rounded,
          AppTheme.sageGreen,
          'Nur für euch beide',
          'Ende-zu-Ende-verschlüsselt, ohne Konto und ohne Telefonnummer.',
        ),
        const SizedBox(height: 12),
        const InviteStatusCard(),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _openPairingModal,
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
            label: const Text('Mit Partner verbinden',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.amber,
              foregroundColor: AppTheme.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => invitePartner(context),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Partner einladen', style: TextStyle(fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.amberLight,
              side: BorderSide(color: AppTheme.amber.withOpacity(0.6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: _showInfoDialog,
            child: const Text('Wie funktioniert das?', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ),
        const SizedBox(height: 12),
        _buildAbendCard(),
        const SizedBox(height: 10),
        _buildFantasyMapCard(subtitle: 'Kannst du auch allein ausfüllen – und später mit deinem Gegenüber abgleichen.'),
      ],
    );
  }

  Widget _buildFeature(IconData icon, Color color, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openLesson(String lessonId) {
    final course = DataService.getCourses().firstWhere((c) => c.lessons.any((l) => l.id == lessonId));
    final lesson = course.lessons.firstWhere((l) => l.id == lessonId);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonDetailScreen(lesson: lesson, courseTitle: course.title),
    ));
  }

  void _openAbend() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen()));
  }

  Widget _buildAbendCard() {
    return InkWell(
      onTap: _openAbend,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.rose.withOpacity(0.16), AppTheme.amber.withOpacity(0.10)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.rose.withOpacity(0.45)),
        ),
        child: const Row(
          children: [
            Icon(Icons.spa_rounded, color: AppTheme.rose, size: 26),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gemeinsamer Abend',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  SizedBox(height: 2),
                  Text('Geführte Berührung für euch beide, 20 bis 45 Minuten. Jedes Mal anders.',
                      style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildFantasyMapCard({required String subtitle}) {
    return InkWell(
      onTap: _openFantasyMap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.sageGreen.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.explore_rounded, color: AppTheme.sageGreen, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fantasie-Landkarte',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Verbunden

  Widget _buildPaired() {
    return Column(
      children: [
        _buildHeader(),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: TabBar(
            controller: _subTabController,
            indicator: BoxDecoration(
              color: AppTheme.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.amber.withOpacity(0.5)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppTheme.amberLight,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            tabs: [
              const Tab(height: 42, text: 'Nachrichten'),
              ValueListenableBuilder<List<String>>(
                valueListenable: _nostr.matchesNotifier,
                builder: (context, matches, _) => Tab(
                  height: 42,
                  child: Badge(
                    isLabelVisible: matches.isNotEmpty,
                    label: Text('${matches.length}'),
                    backgroundColor: AppTheme.rose,
                    offset: const Offset(14, -6),
                    child: const Text('Wünsche'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              _buildMessagesTab(),
              _buildWishesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_nostr.partnerNameNotifier, _nostr.statusNotifier]),
      builder: (context, _) {
        final name = _nostr.partnerName;
        final status = _nostr.statusNotifier.value;
        final (Color dot, String label) = switch (status) {
          NostrConnectionStatus.connected => (AppTheme.sageGreen, 'verbunden & verschlüsselt'),
          NostrConnectionStatus.connecting => (AppTheme.amber, 'verbindet …'),
          _ => (AppTheme.rose, 'offline – tippe zum Verbinden'),
        };

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.8)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.rose.withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name.characters.first.toUpperCase() : '♥',
                  style: const TextStyle(color: AppTheme.rose, fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: status == NostrConnectionStatus.connected ? _showInfoDialog : _nostr.retryConnection,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Du & $name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.5, color: dot),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: _openAbend,
                icon: const Icon(Icons.spa_outlined, color: AppTheme.rose, size: 22),
                tooltip: 'Gemeinsamer Abend',
              ),
              IconButton(
                onPressed: _openFantasyMap,
                icon: const Icon(Icons.explore_outlined, color: AppTheme.amber, size: 22),
                tooltip: 'Fantasie-Landkarte',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondary),
                color: AppTheme.surface,
                onSelected: (value) {
                  switch (value) {
                    case 'info':
                      _showInfoDialog();
                    case 'pair':
                      _openPairingModal();
                    case 'reconnect':
                      _nostr.reconnectNextRelay();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'info', child: Text('Verschlüsselung & Details')),
                  PopupMenuItem(value: 'pair', child: Text('Verbindung verwalten')),
                  PopupMenuItem(value: 'reconnect', child: Text('Neu verbinden')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesTab() {
    return Column(
      children: [
        Expanded(child: _buildChatStream()),
        _buildSparkBar(),
        _buildChatInputBar(),
      ],
    );
  }

  Widget _buildSparkBar() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border, width: 0.8)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _sparks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (emoji, text) = _sparks[i];
          return InkWell(
            onTap: () => _sendSpark(emoji, text),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                '$emoji  $text',
                style: const TextStyle(fontSize: 12.5, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatStream() {
    return ValueListenableBuilder<List<CoupleMessage>>(
      valueListenable: _nostr.messagesNotifier,
      builder: (context, allMessages, _) {
        final messages = allMessages.where((m) => m.type != CoupleMessageType.fantasyVote).toList();

        if (messages.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.forum_outlined, size: 44, color: AppTheme.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'Noch ist es still hier',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Schick einen Funken aus der Leiste unten oder schreib ein paar Worte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: messages.length,
          itemBuilder: (context, index) => _buildBubble(messages[index]),
        );
      },
    );
  }

  Widget _buildBubble(CoupleMessage msg) {
    final isMe = msg.isMe;
    final isSpark = msg.type == CoupleMessageType.ping;
    final textColor = isMe ? AppTheme.background : AppTheme.textPrimary;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : (isSpark ? AppTheme.rose.withOpacity(0.16) : AppTheme.surface),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: isSpark ? AppTheme.rose.withOpacity(0.45) : AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isSpark ? '${msg.emoji ?? '🔥'}  ${msg.text ?? ''}' : (msg.text ?? ''),
              style: TextStyle(
                color: textColor,
                fontSize: isSpark ? 15 : 14,
                fontWeight: isSpark ? FontWeight.w700 : FontWeight.w500,
                height: 1.35,
              ),
            ),
            if (msg.lessonId != null && DataService.getLessonById(msg.lessonId!) != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: InkWell(
                  onTap: () => _openLesson(msg.lessonId!),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isMe ? Colors.black : AppTheme.amber).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 15, color: isMe ? textColor : AppTheme.amberLight),
                        const SizedBox(width: 6),
                        Text('Lektion öffnen',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isMe ? textColor : AppTheme.amberLight)),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.createdAt),
              style: TextStyle(fontSize: 10, color: isMe ? textColor.withOpacity(0.65) : AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      color: AppTheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Nachricht schreiben …',
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13.5),
                filled: true,
                fillColor: AppTheme.surfaceLight.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            onPressed: _sendMessage,
            style: IconButton.styleFrom(backgroundColor: AppTheme.amber, fixedSize: const Size(46, 46)),
            icon: const Icon(Icons.send_rounded, color: AppTheme.background, size: 20),
            tooltip: 'Senden',
          ),
        ],
      ),
    );
  }

  Widget _buildWishesTab() {
    return AnimatedBuilder(
      animation: Listenable.merge([_nostr.myFantasyVotesNotifier, _nostr.matchesNotifier]),
      builder: (context, _) {
        final matches = _nostr.matchesNotifier.value;
        final myVotes = _nostr.myFantasyVotesNotifier.value;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(2, 4, 2, 14),
              child: Text(
                'Stimmt getrennt ab. Ein Wunsch erscheint erst als Match, wenn ihr beide „Ja, gern“ sagt – '
                'ein „Lieber nicht“ wird nie angezeigt.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
              ),
            ),
            _buildFantasyMapCard(subtitle: '22 Fragen in 5 Bereichen – mit passenden Kurs-Empfehlungen.'),
            const SizedBox(height: 16),
            if (matches.isNotEmpty) ...[
              _buildMatchBanner(matches),
              const SizedBox(height: 16),
            ],
            ...defaultFantasyOptions.map((opt) => _buildWishCard(opt, myVotes[opt.id], matches.contains(opt.id))),
          ],
        );
      },
    );
  }

  Widget _buildMatchBanner(List<String> matches) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBE123C), Color(0xFF881337)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            matches.length == 1 ? 'Ihr habt ein Match' : 'Ihr habt ${matches.length} Matches',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...matches.map((id) {
            final opt = defaultFantasyOptions.firstWhere((o) => o.id == id, orElse: () => defaultFantasyOptions.first);
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('✨ ${opt.title}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5)),
            );
          }),
          const SizedBox(height: 10),
          const Text(
            'Ein Match ist eine Einladung, kein Versprechen. Sprecht vorher kurz darüber, wie ihr es euch vorstellt.',
            style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildWishCard(FantasyOption opt, String? myVote, bool isMatch) {
    final accent = isMatch ? AppTheme.rose : AppTheme.amber;

    Widget voteButton(String value, String label, IconData icon) {
      final selected = myVote == value;
      final color = value == 'yes' ? AppTheme.rose : AppTheme.textSecondary;
      return Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            _nostr.sendFantasyVote(opt.id, value);
          },
          icon: Icon(icon, size: 16, color: selected ? Colors.white : color),
          label: Text(label, style: TextStyle(color: selected ? Colors.white : color, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? (value == 'yes' ? const Color(0xFFE11D48) : AppTheme.surfaceLight) : null,
            side: BorderSide(color: selected ? Colors.transparent : AppTheme.border),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMatch ? AppTheme.rose.withOpacity(0.1) : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isMatch ? AppTheme.rose.withOpacity(0.7) : AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(opt.icon, color: accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(opt.tag.toUpperCase(),
                        style: TextStyle(color: accent, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                    const SizedBox(height: 2),
                    Text(opt.title,
                        style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
              if (isMatch) const Icon(Icons.favorite_rounded, color: AppTheme.rose, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(opt.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              voteButton('yes', 'Ja, gern', Icons.local_fire_department_rounded),
              const SizedBox(width: 10),
              voteButton('no', 'Lieber nicht', Icons.do_not_disturb_on_outlined),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('So bleibt es privat', style: TextStyle(fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nachrichten werden auf deinem Handy verschlüsselt und erst auf dem Handy deines Gegenübers wieder lesbar. '
                'Dazwischen laufen sie über öffentliche Nostr-Server. Die sehen nur, dass zwei anonyme Schlüssel '
                'miteinander schreiben – nicht, was. Es gibt kein Konto, keine Telefonnummer und keinen Server von uns.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Verschlüsselung', 'Nostr NIP-04'),
              _buildInfoRow('Server', _nostr.connectedRelaysLabel),
              for (final relay in _nostr.connectedRelays) _buildInfoRow('', relay),
              const SizedBox(height: 10),
              const Text('Dein Verbindungscode', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              const SizedBox(height: 4),
              SelectableText(
                _nostr.myNpub,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppTheme.amberLight),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Schließen', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
