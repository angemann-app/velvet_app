import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/couple_channel_models.dart';
import '../../services/data_service.dart';
import '../../services/listen_uebersetzung.dart';
import '../../services/message_notifier.dart';
import '../../services/nostr_service.dart';
import '../courses/lesson_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../yes_no_maybe/yes_no_maybe_screen.dart';
import 'invite_partner.dart';
import 'paar_abend_screen.dart';
import '../../widgets/gefuehrte_audios.dart';
import '../../widgets/spicy_modus_dialog.dart';
import '../../services/foto_kanal.dart';
import '../../services/foto_ideen.dart';
import 'package:image_picker/image_picker.dart';
import 'foto_ansicht.dart';
import '../../services/storage_service.dart';
import 'partner_profile_dialog.dart';
import 'pairing_modal.dart';
import '../../l10n/t.dart';

/// Schnelle Funken: ein Tippen sagt, worauf man heute Lust hat – oder eben nicht.
List<(String, String)> get _sparks => [
  ('🔥', t.couplesChannelIWantYou),
  ('🌿', t.couplesChannelJustCuddlesToday),
  ('🥂', t.couplesChannelLookingForwardToLater),
  ('🐢', t.couplesChannelVerySlowlyToday),
  ('💬', t.couplesChannelLetSTalk),
  ('🌙', t.couplesChannelNotToday),
];

/// Heiße Funken, nur im Spicy-Modus (Spicy und Sehr spicy gemischt, der Schalter ist die Entscheidung).
List<(String, String)> get _spicySparks => [
  ('💋', t.spicyFunkeLippen),
  ('😏', t.spicyFunkeHeuteAbend),
  ('🔥', t.spicyFunkeScharf),
  ('👅', t.spicyFunkeSchmecken),
  ('😈', t.spicyFunkeNichtsDrunter),
  ('🍑', t.spicyFunkeNackt),
  ('💦', t.spicyFunkeFicken),
  ('🏠', t.spicyFunkeNachHause),
];

class CouplesChannelScreen extends StatefulWidget {
  const CouplesChannelScreen({super.key});

  @override
  State<CouplesChannelScreen> createState() => _CouplesChannelScreenState();
}

class _CouplesChannelScreenState extends State<CouplesChannelScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _subTabController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final NostrService _nostr = NostrService();

  /// Nächste Nachricht oder nächster Funke verschwindet nach dem Lesen (nur im Spicy-Modus).
  bool _verschwinden = false;
  Timer? _aufraeumTimer;

  /// Für den Haken im Menü; die Karte selbst fragt FotoIdeen direkt.
  bool _ideenAn = true;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this);
    _nostr.init().then((_) => FotoKanal.instanz.start());
    _aufraeumTimer = Timer.periodic(const Duration(seconds: 20), (_) => _nostr.aufraeumen());
    FotoIdeen.an().then((an) {
      if (mounted) setState(() => _ideenAn = an);
    });
    FotoIdeen.stand.addListener(_ideenStand);
    MessageNotifier.clear();
    WidgetsBinding.instance.addObserver(this);
    _subTabController.addListener(_pruefeGelesen);
    _nostr.paarKanalSichtbar.addListener(_pruefeGelesen);
    _nostr.messagesNotifier.addListener(_pruefeGelesen);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _pruefeGelesen();
  }

  /// Gelesen ist, was im Nachrichten-Bereich bei geöffneter App auf dem Bildschirm steht.
  void _pruefeGelesen() {
    final sichtbar = _nostr.paarKanalSichtbar.value &&
        _subTabController.index == 0 &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    if (!sichtbar) return;
    MessageNotifier.clear();
    _nostr.markMessagesRead();
  }

  @override
  void dispose() {
    _aufraeumTimer?.cancel();
    FotoIdeen.stand.removeListener(_ideenStand);
    FotoKanal.instanz.stop();
    WidgetsBinding.instance.removeObserver(this);
    _nostr.paarKanalSichtbar.removeListener(_pruefeGelesen);
    _nostr.messagesNotifier.removeListener(_pruefeGelesen);
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

  bool get _verschwindenAktiv => _verschwinden && StorageService.spicyMode();

  void _ideenStand() => FotoIdeen.an().then((an) {
        if (mounted) setState(() => _ideenAn = an);
      });

  /// Foto auswählen, verschlüsseln und direkt ans Gegenüber schicken (oder warten lassen).
  Future<void> _fotoSenden() async {
    final quelle = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.surface,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(t.fotoKamera),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(t.fotoGalerie),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text(t.fotoSicherheitHinweis,
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.4)),
          ),
        ]),
      ),
    );
    if (quelle == null) return;
    final gewaehlt = await ImagePicker().pickImage(source: quelle, maxWidth: 1600, maxHeight: 1600, imageQuality: 82);
    if (gewaehlt == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final ergebnis = await FotoKanal.instanz.senden(await gewaehlt.readAsBytes(), verschwindet: _verschwindenAktiv);
    switch (ergebnis) {
      case FotoErgebnis.fehler:
        messenger.showSnackBar(SnackBar(content: Text(t.fotoFehler), backgroundColor: AppTheme.rose));
      case FotoErgebnis.wartet:
        messenger.showSnackBar(SnackBar(content: Text(t.fotoNichtDa), duration: const Duration(seconds: 6)));
        _scrollToBottom();
      case FotoErgebnis.unterwegs:
        _scrollToBottom();
    }
  }

  /// Zustand und Knopf für ein Foto in der Sprechblase.
  Widget _fotoZeile(CoupleMessage msg, Color farbe) {
    final id = msg.fotoId!;
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: FotoKanal.instanz.status,
      builder: (context, _, __) => FutureBuilder<String>(
        future: FotoKanal.instanz.zustand(id, vonMir: msg.isMe),
        builder: (context, snap) {
          final z = snap.data ?? 'wartet';
          if (!msg.isMe && z == 'bereit') {
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: FilledButton.icon(
                onPressed: () async {
                  // Erst fragen: Das Foto lässt sich nur einmal ansehen, also besser allein.
                  final jetzt = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.surface,
                      title: Text(t.fotoAlleinTitel),
                      content: Text(t.fotoAlleinText, style: const TextStyle(height: 1.45)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.fotoSpaeter)),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(t.fotoJetztAnsehen, style: const TextStyle(color: AppTheme.rose)),
                        ),
                      ],
                    ),
                  );
                  if (jetzt != true) return;
                  final bild = await FotoKanal.instanz.einmalOeffnen(id);
                  if (!context.mounted) return;
                  if (bild == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.fotoWeg)));
                    return;
                  }
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => FotoAnsicht(bild: bild)));
                },
                style: FilledButton.styleFrom(backgroundColor: AppTheme.rose),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(t.fotoAnsehen),
              ),
            );
          }
          final text = switch ((msg.isMe, z)) {
            (_, 'laedt') => t.fotoStatusLaedt,
            (_, 'angesehen') => t.fotoStatusAngesehen,
            (true, 'zugestellt') => t.fotoStatusZugestellt,
            (true, 'fehler') => t.fotoStatusFehler,
            (true, _) => t.fotoStatusWartetRaus,
            (false, _) => t.fotoStatusWartet,
          };
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text, style: TextStyle(fontSize: 11.5, color: farbe, fontStyle: FontStyle.italic)),
          );
        },
      ),
    );
  }

  void _sendSpark(String emoji, String text) async {
    HapticFeedback.mediumImpact();
    final success = await _nostr.sendQuickPing(emoji, text, verschwindet: _verschwindenAktiv);
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

    final success = await _nostr.sendChatMessage(text, verschwindet: _verschwindenAktiv);
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
        content: Text(t.lessonDetailSendingDidnTWorkPlease),
        backgroundColor: AppTheme.rose,
        action: SnackBarAction(
          label: t.couplesChannelReconnect,
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
        Text(
          t.coursesYourPrivateSpace,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          t.couplesChannelConnectWithYourPartnerAnd,
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.45),
        ),
        const SizedBox(height: 16),
        // Geht auch ohne Verbindung: ein Handy neben euch reicht.
        const GefuehrteAudios(mitSelbst: false),
        const SizedBox(height: 8),
        _buildFeature(
          Icons.bolt_rounded,
          AppTheme.amber,
          t.couplesChannelSendSparks,
          t.couplesChannelShowWithOneTapWhat,
        ),
        _buildFeature(
          Icons.favorite_rounded,
          AppTheme.rose,
          t.couplesChannelSecretlyMatchWishes,
          t.couplesChannelYouVoteSeparatelyOnlyWhat,
        ),
        _buildFeature(
          Icons.lock_rounded,
          AppTheme.sageGreen,
          t.couplesChannelJustForTheTwoOf,
          t.couplesChannelEndToEndEncryptedNo,
        ),
        const SizedBox(height: 12),
        const InviteStatusCard(),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _openPairingModal,
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
            label: Text(t.couplesChannelConnectWithPartner,
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
            label: Text(t.couplesChannelInvitePartner, style: TextStyle(fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.amberLight,
              side: BorderSide(color: AppTheme.amber.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: _showInfoDialog,
            child: Text(t.couplesChannelHowDoesItWork, style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ),
        const SizedBox(height: 12),
        _buildFantasyMapCard(subtitle: t.couplesChannelYouCanAlsoFillIt),
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
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
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

  Future<void> _spicyEinladen() async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await _nostr.sendSpicyEinladung();
    messenger.showSnackBar(SnackBar(content: Text(ok ? t.spicyEinladungGesendet : t.spicyEinladungFehler)));
  }

  /// Knopf unter einer Einladung des Gegenübers: einschalten (mit Altersabfrage) oder Hinweis, dass er schon an ist.
  Widget _spicyAnnehmen() {
    return ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, an, _) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: an
            ? Text(t.spicyEinladungSchonAn, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted))
            : InkWell(
                onTap: () => spicyModusEinschalten(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.rose.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.local_fire_department_rounded, size: 15, color: AppTheme.rose),
                    const SizedBox(width: 6),
                    Text(t.spicyEinladungAnnehmen,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.rose)),
                  ]),
                ),
              ),
      ),
    );
  }

  void _openAbend() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen()));
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
          border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.explore_rounded, color: AppTheme.sageGreen, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.couplesChannelFantasyMap,
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
        const PartnerProfilePrompt(),
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
              color: AppTheme.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.amber.withValues(alpha: 0.5)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppTheme.amberLight,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            tabs: [
              Tab(height: 42, text: t.couplesChannelMessages),
              ValueListenableBuilder<List<String>>(
                valueListenable: _nostr.matchesNotifier,
                builder: (context, matches, _) => Tab(
                  height: 42,
                  child: Badge(
                    isLabelVisible: matches.isNotEmpty,
                    label: Text('${matches.length}'),
                    backgroundColor: AppTheme.rose,
                    offset: const Offset(14, -6),
                    child: Text(t.couplesChannelWishes),
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
          NostrConnectionStatus.connected => (AppTheme.sageGreen, t.couplesChannelConnectedEncrypted),
          NostrConnectionStatus.connecting => (AppTheme.amber, t.couplesChannelConnecting),
          _ => (AppTheme.rose, t.couplesChannelOfflineTapToConnect),
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
                backgroundColor: AppTheme.rose.withValues(alpha: 0.2),
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
                        t.couplesChannelYouName(name),
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
                tooltip: t.couplesChannelSharedEvening,
              ),
              IconButton(
                onPressed: _openFantasyMap,
                icon: const Icon(Icons.explore_outlined, color: AppTheme.amber, size: 22),
                tooltip: t.couplesChannelFantasyMap,
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
                    case 'profile':
                      editPartnerProfile(context);
                    case 'reconnect':
                      _nostr.reconnectNextRelay();
                    case 'unpair':
                      _confirmUnpair();
                    case 'read':
                      _nostr.setReadReceiptsEnabled(!_nostr.readReceiptsEnabled.value);
                    case 'spicy':
                      _spicyEinladen();
                    case 'ideen':
                      FotoIdeen.setzen(!_ideenAn);
                  }
                },
                itemBuilder: (_) => [
                  // Einladen kann nur, wer den Spicy-Modus selbst eingeschaltet hat.
                  if (StorageService.spicyMode()) ...[
                    PopupMenuItem(value: 'spicy', child: Text(t.spicyEinladen)),
                    CheckedPopupMenuItem(value: 'ideen', checked: _ideenAn, child: Text(t.fotoIdeenAnzeigen)),
                  ],
                  PopupMenuItem(value: 'profile', child: Text(t.couplesChannelPartnerSNameGender)),
                  CheckedPopupMenuItem(
                    value: 'read',
                    checked: _nostr.readReceiptsEnabled.value,
                    child: Text(t.couplesChannelReadReceipts),
                  ),
                  PopupMenuItem(value: 'info', child: Text(t.couplesChannelEncryptionDetails)),
                  PopupMenuItem(value: 'pair', child: Text(t.couplesChannelManageConnection)),
                  PopupMenuItem(value: 'reconnect', child: Text(t.couplesChannelReconnect)),
                  PopupMenuItem(value: 'unpair', child: Text(t.couplesChannelDisconnect)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Foto-Idee des Tages: nur im Spicy-Modus, mit „Heute nicht“ sofort weg, ganz abschaltbar im Menü.
  Widget _fotoIdee() {
    if (!StorageService.spicyMode()) return const SizedBox.shrink();
    return ValueListenableBuilder<int>(
      valueListenable: FotoIdeen.stand,
      builder: (context, _, __) => FutureBuilder<FotoIdee?>(
        future: FotoIdeen.heute(),
        builder: (context, snap) {
          final idee = snap.data;
          if (idee == null) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 6),
            decoration: BoxDecoration(
              color: AppTheme.rose.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.rose.withValues(alpha: 0.4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.photo_camera_outlined, size: 16, color: AppTheme.rose),
                const SizedBox(width: 6),
                Text(t.fotoIdeeTitel,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.rose)),
              ]),
              const SizedBox(height: 4),
              Text(idee.text,
                  style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
              Text(idee.heiss ? t.fotoIdeeHinweisHeiss : t.fotoIdeeHinweis,
                  style: TextStyle(
                      fontSize: 11,
                      color: idee.heiss ? AppTheme.rose : AppTheme.textMuted,
                      fontWeight: idee.heiss ? FontWeight.w600 : FontWeight.w400)),
              Wrap(spacing: 0, children: [
                TextButton(onPressed: _fotoSenden, child: Text(t.fotoSenden)),
                TextButton(onPressed: () => FotoIdeen.andereIdee(), child: Text(t.fotoIdeeAndere)),
                TextButton(
                  onPressed: () => FotoIdeen.heuteNicht(),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
                  child: Text(t.fotoIdeeHeuteNicht),
                ),
              ]),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildMessagesTab() {
    return Column(
      children: [
        _fotoIdee(),
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
        itemCount: _alleFunken.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (emoji, text) = _alleFunken[i];
          final heiss = i >= _sparks.length;
          return InkWell(
            onTap: () => _sendSpark(emoji, text),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: heiss ? AppTheme.rose.withValues(alpha: 0.14) : AppTheme.surfaceLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: heiss ? AppTheme.rose.withValues(alpha: 0.6) : AppTheme.border),
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

  /// Normale Funken, im Spicy-Modus gefolgt von den heißen.
  List<(String, String)> get _alleFunken => [..._sparks, if (StorageService.spicyMode()) ..._spicySparks];

  Widget _buildChatStream() {
    return ValueListenableBuilder<List<CoupleMessage>>(
      valueListenable: _nostr.messagesNotifier,
      builder: (context, allMessages, _) {
        final messages = allMessages.where((m) => m.type != CoupleMessageType.fantasyVote).toList();

        if (messages.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.forum_outlined, size: 44, color: AppTheme.textMuted),
                  SizedBox(height: 12),
                  Text(
                    t.couplesChannelItSStillQuietHere,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    t.couplesChannelSendASparkFromThe,
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
          itemBuilder: (context, index) => _buildBubble(
            messages[index],
            istLetzteEigene: messages[index].isMe && messages.skip(index + 1).every((m) => !m.isMe),
          ),
        );
      },
    );
  }

  /// „Gelesen“ / „Gesendet“ – nur wenn beide Lesebestätigungen nutzen. Sendet das Gegenüber
  /// keine (ältere Version oder ausgeschaltet), steht dort nichts statt eines falschen „Gesendet“.
  Widget _lesestatus(CoupleMessage msg, Color farbe) => ValueListenableBuilder<bool>(
        valueListenable: _nostr.readReceiptsEnabled,
        builder: (context, an, _) => ValueListenableBuilder<int?>(
          valueListenable: _nostr.partnerReadUntil,
          builder: (context, bis, _) {
            if (!an || bis == null) return const SizedBox.shrink();
            // Kleiner Spielraum: Die Zeit in der Nachricht und im verschickten Event können eine Sekunde auseinanderliegen.
            final gelesen = bis + 2 >= msg.createdAt.millisecondsSinceEpoch ~/ 1000;
            return Text(
              gelesen ? t.couplesChannelRead : t.couplesChannelSent,
              style: TextStyle(fontSize: 10, color: farbe, fontWeight: gelesen ? FontWeight.w700 : FontWeight.w400),
            );
          },
        ),
      );

  Widget _buildBubble(CoupleMessage msg, {bool istLetzteEigene = false}) {
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
          color: isMe ? null : (isSpark ? AppTheme.rose.withValues(alpha: 0.16) : AppTheme.surface),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: isSpark ? AppTheme.rose.withValues(alpha: 0.45) : AppTheme.border),
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
            if (msg.spicyEinladung && !isMe) _spicyAnnehmen(),
            if (msg.fotoId != null) _fotoZeile(msg, isMe ? textColor.withValues(alpha: 0.8) : AppTheme.textSecondary),
            if (msg.lessonId != null && DataService.getLessonById(msg.lessonId!) != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: InkWell(
                  onTap: () => _openLesson(msg.lessonId!),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isMe ? Colors.black : AppTheme.amber).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 15, color: isMe ? textColor : AppTheme.amberLight),
                        const SizedBox(width: 6),
                        Text(t.couplesChannelOpenLesson,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.verschwindet) ...[
                  Icon(Icons.timer_outlined,
                      size: 11,
                      color: isMe ? textColor.withValues(alpha: 0.75) : AppTheme.rose,
                      semanticLabel: t.verschwindetLabel),
                  const SizedBox(width: 4),
                ],
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(fontSize: 10, color: isMe ? textColor.withValues(alpha: 0.65) : AppTheme.textMuted),
                ),
                if (istLetzteEigene) _lesestatus(msg, textColor.withValues(alpha: 0.75)),
              ],
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
          if (StorageService.spicyMode()) ...[
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _verschwinden = !_verschwinden);
              },
              isSelected: _verschwinden,
              icon: const Icon(Icons.timer_outlined, color: AppTheme.textMuted),
              selectedIcon: const Icon(Icons.timer_rounded, color: AppTheme.rose),
              tooltip: t.verschwindenSchalter,
            ),
            IconButton(
              onPressed: _fotoSenden,
              icon: const Icon(Icons.add_a_photo_outlined, color: AppTheme.textMuted),
              tooltip: t.fotoSenden,
            ),
          ],
          Expanded(
            child: TextField(
              controller: _chatController,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: _verschwindenAktiv ? t.verschwindenHinweis : t.couplesChannelWriteAMessage,
                hintStyle: TextStyle(color: _verschwindenAktiv ? AppTheme.rose : AppTheme.textMuted, fontSize: 13.5),
                filled: true,
                fillColor: _verschwindenAktiv
                    ? AppTheme.rose.withValues(alpha: 0.10)
                    : AppTheme.surfaceLight.withValues(alpha: 0.5),
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
            tooltip: t.couplesChannelSend,
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
            Padding(
              padding: EdgeInsets.fromLTRB(2, 4, 2, 14),
              child: Text(
                t.couplesChannelVoteSeparatelyAWishOnly,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
              ),
            ),
            const GefuehrteAudios(mitSelbst: false),
            _buildFantasyMapCard(subtitle: t.couplesChannelQuestionsInSeveralAreasWith(ListenUebersetzung.eintraege.length, ListenUebersetzung.kategorien.length)),
            const SizedBox(height: 16),
            if (matches.isNotEmpty) ...[
              _buildMatchBanner(matches),
              const SizedBox(height: 16),
            ],
            ...ListenUebersetzung.fantasien.map((opt) => _buildWishCard(opt, myVotes[opt.id], matches.contains(opt.id))),
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
            matches.length == 1 ? t.couplesChannelYouHaveAMatch : t.couplesChannelYouHaveMatcheslengthMatches(matches.length),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...matches.map((id) {
            final opt = ListenUebersetzung.fantasien.firstWhere((o) => o.id == id, orElse: () => ListenUebersetzung.fantasien.first);
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('✨ ${opt.title}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5)),
            );
          }),
          const SizedBox(height: 10),
          Text(
            t.couplesChannelAMatchIsAnInvitation,
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
        color: isMatch ? AppTheme.rose.withValues(alpha: 0.1) : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isMatch ? AppTheme.rose.withValues(alpha: 0.7) : AppTheme.border),
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
              voteButton('yes', t.couplesChannelYesPlease, Icons.local_fire_department_rounded),
              const SizedBox(width: 10),
              voteButton('no', t.couplesChannelRatherNot, Icons.do_not_disturb_on_outlined),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------

  Future<void> _confirmUnpair() async {
    final name = _nostr.partnerName;
    final ja = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(t.couplesChannelDisconnect2, style: TextStyle(fontSize: 18)),
        content: Text(
          t.couplesChannelTheHistoryWithNameName(name, name, name),
          style: const TextStyle(color: AppTheme.textSecondary, height: 1.45),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.ausspracheMeldenCancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.couplesChannelDisconnect3, style: TextStyle(color: AppTheme.rose)),
          ),
        ],
      ),
    );
    if (ja != true) return;
    await _nostr.unpairPartner();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couplesChannelDisconnected)));
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(t.couplesChannelHowItStaysPrivate, style: TextStyle(fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.couplesChannelMessagesAreEncryptedOnYour,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(t.couplesChannelEncryption, 'Nostr NIP-04'),
              _buildInfoRow(t.couplesChannelServers, _nostr.connectedRelaysLabel),
              for (final relay in _nostr.connectedRelays) _buildInfoRow('', relay),
              const SizedBox(height: 10),
              Text(t.couplesChannelYourConnectionCode, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
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
            child: Text(t.couplesChannelClose, style: TextStyle(color: AppTheme.textSecondary)),
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
