import 'dart:async';

import 'package:flutter/material.dart';
import '../gemeinsam_screen.dart';
import '../../widgets/design/vp_bild_feld.dart';
import 'package:flutter/services.dart';
import '../../models/couple_channel_models.dart';
import '../../services/data_service.dart';
import '../../services/listen_uebersetzung.dart';
import '../../services/message_notifier.dart';
import '../../services/nostr_service.dart';
import '../courses/lesson_detail_screen.dart';
import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';
import '../../widgets/design/vp_tabs.dart';
import '../../widgets/design/vp_komponenten.dart';
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
import '../sos/sos_modal.dart';
import 'pairing_modal.dart';
import '../../widgets/erste_woche_karte.dart';
import '../../l10n/t.dart';

/// Schnelle Funken: ein Tippen sagt, worauf man heute Lust hat – oder eben nicht.
List<(String, String)> get _sparks => [
  ('💗', t.couplesChannelIWantYou),
  ('🌿', t.couplesChannelJustCuddlesToday),
  ('🥂', t.couplesChannelLookingForwardToLater),
  ('🐢', t.couplesChannelVerySlowlyToday),
  ('💬', t.couplesChannelLetSTalk),
];

/// „Heute lieber nicht“ steht fest vor der Leiste, ohne Wischen erreichbar.
(String, String) get _funkeNein => ('🌙', t.couplesChannelNotToday);

/// Heiße Funken, nur im Spicy-Modus (Spicy und Sehr spicy gemischt, der Schalter ist die Entscheidung).
List<(String, String)> get _spicySparks => [
  ('💋', t.spicyFunkeLippen),
  ('😏', t.spicyFunkeHeuteAbend),
  ('🌶️', t.spicyFunkeScharf),
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

  /// Läuft gerade das Trennen (Hinweis wird gesendet)? Verhindert einen zweiten Hinweis.
  bool _trennt = false;

  /// Für den Haken im Menü; die Karte selbst fragt FotoIdeen direkt.
  bool _ideenAn = true;

  /// Die Foto-Idee ist eingeklappt eine einzige Zeile und klappt auf Antippen auf (spart Platz im Chat).
  bool _ideeOffen = false;

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
    // Einmal je Verbindung ein ruhiger Satz dazu, dass Gesendetes beim anderen bleibt.
    final trennHinweis = await _nostr.fotoHinweisOffen();
    if (!mounted) return;
    final quelle = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.papierErhoben,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Direkte Verbindung ohne Relais-Server: klappt noch nicht in jedem Netz.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.akzentTief.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(VpRadius.feld),
                ),
                child: Text(t.fotoExperimentell,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.akzentTief)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t.fotoExperimentellHinweis,
                    style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, height: 1.4)),
              ),
            ]),
          ),
          if (trennHinweis)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(t.fotoHinweisTrennung,
                    style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, height: 1.4)),
              ),
            ),
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
                style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, height: 1.4)),
          ),
        ]),
      ),
    );
    if (quelle == null) return;
    if (trennHinweis) unawaited(_nostr.fotoHinweisGesehen());
    final gewaehlt = await ImagePicker().pickImage(source: quelle, maxWidth: 1600, maxHeight: 1600, imageQuality: 82);
    if (gewaehlt == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final ergebnis = await FotoKanal.instanz.senden(await gewaehlt.readAsBytes(), verschwindet: _verschwindenAktiv);
    switch (ergebnis) {
      case FotoErgebnis.fehler:
        messenger.showSnackBar(SnackBar(content: Text(t.fotoFehler), backgroundColor: AppTheme.signal));
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
                      backgroundColor: AppTheme.papierErhoben,
                      title: Text(t.fotoAlleinTitel),
                      content: Text(t.fotoAlleinText, style: const TextStyle(height: 1.45)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.fotoSpaeter)),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(t.fotoJetztAnsehen, style: TextStyle(color: AppTheme.akzentTief)),
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
                style: FilledButton.styleFrom(backgroundColor: AppTheme.akzentTief),
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
            (false, 'fehler') => t.fotoStatusWeg,
            (true, _) => t.fotoStatusWartetRaus,
            (false, _) => t.fotoStatusWartet,
          };
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: TextStyle(fontSize: 11.5, color: farbe, fontStyle: FontStyle.italic)),
                // Wartet es noch, kann man sofort einen neuen Versuch anstoßen (sonst alle 30 Sekunden von selbst).
                if (z == 'wartet')
                  TextButton.icon(
                    onPressed: () => FotoKanal.instanz.abgleichen(),
                    icon: Icon(Icons.refresh_rounded, size: 16, color: farbe),
                    label: Text(t.fotoErneutVersuchen, style: TextStyle(fontSize: 12, color: farbe)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendSpark(String emoji, String text) async {
    HapticFeedback.mediumImpact();
    // Auf diese beiden Funken kann das Gegenüber antworten (Zusatzfeld, ältere Versionen ignorieren es).
    final funke = text == _funkeNein.$2 ? 'nein' : (text == t.couplesChannelLetSTalk ? 'reden' : null);
    final success = await _nostr.sendQuickPing(emoji, text, verschwindet: _verschwindenAktiv, funke: funke);
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
        backgroundColor: AppTheme.akzentTief,
        action: SnackBarAction(
          label: t.couplesChannelReconnect,
          textColor: AppTheme.aufSignal,
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
      backgroundColor: AppTheme.papier,
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
        const ErsteWocheKarte(imTabWir: true),
        ClipRRect(
          borderRadius: BorderRadius.circular(VpRadius.karte),
          child: SizedBox(height: 150, width: double.infinity, child: VpBildFeld('kurs.11.titel')),
        ),
        const SizedBox(height: 20),
        Text(
          t.coursesYourPrivateSpace,
          style: TextStyle(fontFamily: VpTypo.serif, fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.tinte),
        ),
        const SizedBox(height: 8),
        Text(
          t.couplesChannelConnectWithYourPartnerAnd,
          style: TextStyle(fontSize: 14, color: AppTheme.tinteLeise, height: 1.45),
        ),
        const SizedBox(height: 16),
        // Geht auch ohne Verbindung: ein Handy neben euch reicht.
        const GefuehrteAudios(mitSelbst: false),
        const SizedBox(height: 8),
        _buildFeature(
          Icons.bolt_rounded,
          AppTheme.akzentTief,
          t.couplesChannelSendSparks,
          t.couplesChannelShowWithOneTapWhat,
        ),
        _buildFeature(
          Icons.favorite_rounded,
          AppTheme.akzentTief,
          t.couplesChannelSecretlyMatchWishes,
          t.couplesChannelYouVoteSeparatelyOnlyWhat,
        ),
        _buildFeature(
          Icons.lock_rounded,
          AppTheme.akzentTief,
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
              backgroundColor: AppTheme.akzentTief,
              foregroundColor: AppTheme.papier,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
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
              foregroundColor: AppTheme.akzentTief,
              side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: _showInfoDialog,
            child: Text(t.couplesChannelHowDoesItWork, style: TextStyle(color: AppTheme.tinteLeise)),
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
                const SizedBox(height: 2),
                Text(text, style: TextStyle(fontSize: 13, color: AppTheme.tinteLeise, height: 1.4)),
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
  Widget _spicyAnnehmen(CoupleMessage msg) {
    return ValueListenableBuilder<bool>(
      valueListenable: StorageService.spicyAenderung,
      builder: (context, an, _) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                // „Gerade nicht“ gibt es auch, wenn der Spicy-Modus schon an ist.
                if (an) Text(t.spicyEinladungSchonAn, style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm)),
                // Hat das Gegenüber getrennt, hört niemand mehr zu: dann keine Antwort-Knöpfe.
                if (!_nostr.partnerGetrenntNotifier.value)
                Wrap(spacing: 8, runSpacing: 6, children: [
                  if (!an)
                  InkWell(
                    onTap: () => spicyModusEinschalten(context),
                    borderRadius: BorderRadius.circular(VpRadius.karte),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.akzentTief.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.spa_outlined, size: 15, color: AppTheme.akzentTief),
                        const SizedBox(width: 6),
                        Text(t.spicyEinladungAnnehmen,
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.akzentTief)),
                      ]),
                    ),
                  ),
                  if (!msg.beantwortet)
                    InkWell(
                      onTap: () => _spicyAbsagen(msg),
                      borderRadius: BorderRadius.circular(VpRadius.karte),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(VpRadius.karte),
                          border: Border.all(color: AppTheme.linieStark),
                        ),
                        child: Text(t.spicyEinladungNein,
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
                      ),
                    ),
                ]),
                if (msg.beantwortet && !_nostr.partnerGetrenntNotifier.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(t.spicyEinladungNeinGesendet,
                        style: TextStyle(fontSize: 12, color: AppTheme.tinteStumm, height: 1.4)),
                  ),
              ]),
      ),
    );
  }

  /// „Gerade nicht“: ohne Erklärung, kommt beim Einladenden als warmer Satz an.
  Future<void> _spicyAbsagen(CoupleMessage msg) async {
    HapticFeedback.lightImpact();
    final ok = await _nostr.sendAntwort('spicy_nein', t.spicyNeinSatz, aufId: msg.id);
    if (!mounted || ok) return;
    _showSendError();
  }

  /// Der angezeigte Satz einer Nachricht. Antworten des Gegenübers setzt die App in der eigenen Sprache
  /// zusammen; für ältere Versionen steht im Klartext der Satz des Absenders.
  String _bubbleText(CoupleMessage msg) {
    // „Gerade nicht“ steht in der Blase der antwortenden Person (ihre Worte); der warme Satz kommt
    // als Zeile darunter (_antwortZeile), nicht als ihr Text.
    if (!msg.isMe && msg.antwort == 'spicy_nein') return t.spicyNeinSatz;
    if (!msg.isMe && msg.antwort == 'danke') {
      final name = _nostr.partnerName.trim();
      return name.isEmpty || name == 'Partner' ? t.funkeDanke : t.funkeDankeAntwort(name);
    }
    return msg.text ?? '';
  }

  Widget _antwortZeile(CoupleMessage msg) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(t.spicyEinladungNeinAntwort,
            style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.4)),
      );

  /// Unter „Heute lieber nicht“ und „Lass uns reden“ des Gegenübers: ein kurzer Tipp und ein Knopf,
  /// den die Person selbst antippt. Das Gerät antwortet nie von allein.
  Widget _funkeAntwort(CoupleMessage msg) {
    // Nur für Neues und noch Unbeantwortetes: alte Funken im Verlauf bleiben ruhig.
    if (msg.beantwortet ||
        _nostr.partnerGetrenntNotifier.value ||
        DateTime.now().difference(msg.createdAt) > const Duration(days: 2)) {
      return const SizedBox.shrink();
    }
    final tipp = msg.funke == 'nein' ? t.funkeTippNein : t.funkeTippReden;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        // Als Tipp nur für diese Person gekennzeichnet, damit er nicht wie ein Satz des Absenders wirkt.
        Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lightbulb_outline, size: 13, color: AppTheme.tinteStumm),
          const SizedBox(width: 4),
          Text(t.funkeTippLabel,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.tinteStumm)),
        ]),
        const SizedBox(height: 2),
        Text(tipp, style: TextStyle(fontSize: 12, color: AppTheme.tinteLeise, height: 1.4)),
        Padding(
            padding: const EdgeInsets.only(top: 6),
            child: InkWell(
              onTap: () async {
                HapticFeedback.lightImpact();
                final ok = await _nostr.sendAntwort('danke', t.funkeDanke, aufId: msg.id);
                if (mounted && !ok) _showSendError();
              },
              borderRadius: BorderRadius.circular(VpRadius.karte),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.akzentTief.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                ),
                child: Text(t.funkeDanke,
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.akzentTief)),
              ),
            ),
          ),
      ]),
    );
  }

  void _openAbend() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaarAbendScreen()));
  }

  Widget _buildFantasyMapCard({required String subtitle}) {
    return InkWell(
      onTap: _openFantasyMap,
      borderRadius: BorderRadius.circular(VpRadius.karte),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.papierErhoben,
          borderRadius: BorderRadius.circular(VpRadius.karte),
          border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.explore_rounded, color: AppTheme.akzentTief, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.couplesChannelFantasyMap,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.tinte)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: AppTheme.tinteLeise, height: 1.35)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.tinteStumm),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Verbunden

  /// Die Karte über den Tabs verdrängt den Chat (sie ist fast 300 pt hoch, dazu Kopf, Chips und die Profil-Nachfrage).
  /// Nur auf wirklich hohen Displays steht sie dort, sonst oben im Tab „Gemeinsam entdecken“.
  bool get _karteOben {
    final mq = MediaQuery.of(context);
    return mq.size.height / mq.textScaler.scale(1) >= 900;
  }
  Widget _buildPaired() {
    return Column(
      children: [
        _buildHeader(),
        _buildAngebote(),
        const PartnerProfilePrompt(),
        // Bei geöffneter Tastatur verschwindet die Karte, damit der Chat Platz hat.
        if (_karteOben && MediaQuery.of(context).viewInsets.bottom == 0)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ErsteWocheKarte(imTabWir: true),
          ),
        VpTabs.leiste(
          controller: _subTabController,
          tabs: [
            Tab(height: 42, text: t.couplesChannelMessages),
            ListenableBuilder(
              listenable: Listenable.merge([_nostr.matchesNotifier, StorageService.spicyAenderung]),
              builder: (context, _) {
                // Nur Treffer zählen, die hier auch sichtbar sind (Spicy-Szenen nur im Spicy-Modus).
                final sichtbar = [
                  for (final id in _nostr.matchesNotifier.value)
                    if (ListenUebersetzung.titelFuer(id) != null) id
                ];
                return Tab(
                  height: 42,
                  child: Badge(
                    isLabelVisible: sichtbar.isNotEmpty,
                    label: Text('${sichtbar.length}'),
                    backgroundColor: AppTheme.akzentTief,
                    textColor: AppTheme.aufAkzentTief,
                    offset: const Offset(14, -6),
                    child: Text(t.couplesChannelWishes),
                  ),
                );
              },
            ),
          ],
        ),        Expanded(
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

  /// Zwei Wege in den gemeinsamen Teil, beschriftet statt nur als Symbol. Beides ist ein Angebot, keine Aufgabe.
  Widget _buildAngebote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(spacing: VpAbstand.s, runSpacing: VpAbstand.xs, children: [
          VpChip(label: t.couplesChannelSharedEvening, icon: Icons.spa_outlined, onTap: _openAbend),
          VpChip(label: t.couplesChannelFantasyMap, icon: Icons.explore_outlined, onTap: _openFantasyMap),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_nostr.partnerNameNotifier, _nostr.statusNotifier]),
      builder: (context, _) {
        final name = _nostr.partnerName;
        final status = _nostr.statusNotifier.value;
        final (Color dot, String label) = switch (status) {
          NostrConnectionStatus.connected => (AppTheme.statusJa, t.couplesChannelConnectedEncrypted),
          NostrConnectionStatus.connecting => (AppTheme.statusVielleicht, t.couplesChannelConnecting),
          _ => (AppTheme.statusNein, t.couplesChannelOfflineTapToConnect),
        };

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
          decoration: BoxDecoration(
            color: AppTheme.papier,
            border: Border(bottom: BorderSide(color: AppTheme.linie, width: VpLinie.haar)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.akzentLeise,
                child: Text(
                  name.isNotEmpty ? name.characters.first.toUpperCase() : '♥',
                  style: context.vp.typo.titel.copyWith(color: AppTheme.akzentTief),
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
                        style: context.vp.typo.titel,
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
                              style: TextStyle(fontSize: 11.5, color: AppTheme.tinteLeise),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Gemeinsamer Abend und Fantasie-Landkarte stehen als beschriftete Chips unter der Kopfzeile (_buildAngebote).
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: AppTheme.tinteLeise),
                color: AppTheme.papierErhoben,
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
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            padding: _ideeOffen ? const EdgeInsets.fromLTRB(14, 8, 6, 4) : const EdgeInsets.fromLTRB(12, 0, 4, 0),
            decoration: BoxDecoration(
              color: AppTheme.akzentTief.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Eingeklappt nur eine Zeile mit der Idee, Antippen klappt auf.
              InkWell(
                onTap: () => setState(() => _ideeOffen = !_ideeOffen),
                borderRadius: BorderRadius.circular(VpRadius.karte),
                child: SizedBox(
                  height: _ideeOffen ? 28 : 40,
                  child: Row(children: [
                    Icon(Icons.photo_camera_outlined, size: 16, color: AppTheme.akzentTief),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ideeOffen
                          ? Text(t.fotoIdeeTitel,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.akzentTief))
                          : Text(idee.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13.5, color: AppTheme.tinte, fontWeight: FontWeight.w600)),
                    ),
                    Icon(_ideeOffen ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 20, color: AppTheme.akzentTief),
                  ]),
                ),
              ),
              if (_ideeOffen) ...[
                Text(idee.text,
                    style: TextStyle(fontSize: 14, color: AppTheme.tinte, fontWeight: FontWeight.w600)),
                Text(idee.heiss ? t.fotoIdeeHinweisHeiss : t.fotoIdeeHinweis,
                    style: TextStyle(
                        fontSize: 11,
                        color: idee.heiss ? AppTheme.akzentTief : AppTheme.tinteStumm,
                        fontWeight: idee.heiss ? FontWeight.w600 : FontWeight.w400)),
                Wrap(spacing: 0, children: [
                  TextButton(onPressed: _fotoSenden, child: Text(t.fotoSenden)),
                  TextButton(onPressed: () => FotoIdeen.andereIdee(), child: Text(t.fotoIdeeAndere)),
                  TextButton(
                    onPressed: () => FotoIdeen.heuteNicht(),
                    style: TextButton.styleFrom(foregroundColor: AppTheme.tinteStumm),
                    child: Text(t.fotoIdeeHeuteNicht),
                  ),
                ]),
              ],
            ]),
          );
        },
      ),
    );
  }

  Widget _buildMessagesTab() {
    return ValueListenableBuilder<bool>(
      valueListenable: _nostr.partnerGetrenntNotifier,
      builder: (context, getrennt, _) {
        // Hat das Gegenüber getrennt, ist der Chat nur noch zum Lesen da: Senden ginge ins Leere.
        if (getrennt) {
          return Column(children: [
            _getrenntKarte(),
            Expanded(child: _buildChatStream()),
          ]);
        }
        return Column(
          children: [
            _fotoIdee(),
            Expanded(child: _buildChatStream()),
            _buildSparkBar(),
            _buildChatInputBar(),
          ],
        );
      },
    );
  }

  /// Ruhiger Hinweis, wenn das Gegenüber die Verbindung getrennt hat. Nichts eilt: Wer nichts tut, behält alles.
  Widget _getrenntKarte() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.linie),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.trennungHinweis(_nostr.partnerName),
            style: TextStyle(color: AppTheme.tinte, fontSize: 14, height: 1.45)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: Text(t.trennungSchalter,
                style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.4)),
          ),
          Switch(value: false, onChanged: (_) => _trennenGegenueber()),
        ]),
        TextButton(
          onPressed: () => SosModal.show(context),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Text(t.trennungHilfe, style: TextStyle(color: AppTheme.akzentTief)),
        ),
      ]),
    );
  }

  /// Zweistufig bestätigt: erst sagen, was gelöscht wird, dann noch einmal fragen.
  Future<bool> _zweimalBestaetigen({
    required String titel1,
    required String text1,
    required String weiter,
    required String titel2,
    required String text2,
    required String ja,
    Widget? inhalt1,
  }) async {
    Future<bool> dialog(String titel, String text, String knopf, {Widget? inhalt}) async =>
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.papierErhoben,
            title: Text(titel, style: TextStyle(fontSize: 18)),
            content: inhalt ??
                Text(text, style: TextStyle(color: AppTheme.tinteLeise, height: 1.45)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.ausspracheMeldenCancel)),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(knopf, style: TextStyle(color: AppTheme.akzentTief)),
              ),
            ],
          ),
        ) ??
        false;
    if (!await dialog(titel1, text1, weiter, inhalt: inhalt1) || !mounted) return false;
    return await dialog(titel2, text2, ja) && mounted;
  }

  /// Das Gegenüber hat getrennt; diese Person entscheidet selbst, ob auch hier gelöscht wird.
  Future<void> _trennenGegenueber() async {
    final name = _nostr.partnerName;
    final ja = await _zweimalBestaetigen(
      titel1: t.trennungGegenueberDialog1Titel,
      text1: t.trennungGegenueberDialog1(name),
      weiter: t.trennungDialog1Weiter,
      titel2: t.trennungGegenueberDialog2Titel,
      text2: t.trennungGegenueberDialog2,
      ja: t.trennungGegenueberLoeschenJa,
    );
    if (!ja) return;
    await _nostr.unpairPartner();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.trennungGegenueberFertig)));
  }

  Widget _buildSparkBar() {
    final (neinEmoji, neinText) = _funkeNein;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.papier,
        border: Border(top: BorderSide(color: AppTheme.linie, width: VpLinie.haar)),
      ),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: InkWell(
            onTap: () => _sendSpark(neinEmoji, neinText),
            borderRadius: BorderRadius.circular(VpRadius.chip),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(VpRadius.chip),
                border: Border.all(color: AppTheme.linieStark),
              ),
              child: Text('$neinEmoji  $neinText',
                  style: TextStyle(fontSize: 12.5, color: AppTheme.tinte, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        Expanded(child: _sparkListe()),
      ]),
    );
  }

  Widget _sparkListe() {
    return ClipRect(
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
            borderRadius: BorderRadius.circular(VpRadius.chip),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: heiss ? AppTheme.akzentLeise : Colors.transparent,
                borderRadius: BorderRadius.circular(VpRadius.chip),
                border: Border.all(color: heiss ? AppTheme.akzent : AppTheme.linieStark),
              ),
              child: Text(
                '$emoji  $text',
                style: TextStyle(fontSize: 12.5, color: AppTheme.tinte, fontWeight: FontWeight.w600),
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
              child: VpLeerzustand(
                icon: Icons.forum_outlined,
                titel: t.couplesChannelItSStillQuietHere,
                text: t.couplesChannelSendASparkFromThe,
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
    final textColor = isMe ? AppTheme.aufAkzent : AppTheme.tinte;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.akzentHell : (isSpark ? AppTheme.akzentLeise : AppTheme.papierErhoben),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(VpRadius.karte),
            topRight: const Radius.circular(VpRadius.karte),
            bottomLeft: Radius.circular(isMe ? VpRadius.karte : 2),
            bottomRight: Radius.circular(isMe ? 2 : VpRadius.karte),
          ),
          border: isMe ? null : Border.all(color: isSpark ? AppTheme.akzent : AppTheme.linie),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isSpark ? '${msg.emoji ?? '💗'}  ${msg.text ?? ''}' : _bubbleText(msg),
              style: TextStyle(
                color: textColor,
                fontSize: isSpark ? 15 : 14,
                fontWeight: isSpark ? FontWeight.w700 : FontWeight.w500,
                height: 1.4,
              ),
            ),
            if (msg.spicyEinladung && !isMe) _spicyAnnehmen(msg),
            if (!isMe && msg.antwort == 'spicy_nein') _antwortZeile(msg),
            if (isSpark && !isMe && msg.funke != null) _funkeAntwort(msg),
            if (msg.fotoId != null) _fotoZeile(msg, isMe ? textColor.withValues(alpha: 0.8) : AppTheme.tinteLeise),
            if (msg.lessonId != null && GemeinsamRueckblickScreen.gueltigeId(msg.lessonId!))
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => GemeinsamRueckblickScreen(id: msg.lessonId!))),
                child: Text(t.gemeinsamRueckblick)),
            if (msg.lessonId != null && DataService.getLessonById(msg.lessonId!) != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: InkWell(
                  onTap: () => _openLesson(msg.lessonId!),
                  borderRadius: BorderRadius.circular(VpRadius.karte),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isMe ? AppTheme.aufAkzent : AppTheme.akzentTief).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(VpRadius.karte),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 15, color: isMe ? textColor : AppTheme.akzentTief),
                        const SizedBox(width: 6),
                        Text(t.couplesChannelOpenLesson,
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isMe ? textColor : AppTheme.akzentTief)),
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
                      color: isMe ? textColor.withValues(alpha: 0.75) : AppTheme.akzentTief,
                      semanticLabel: t.verschwindetLabel),
                  const SizedBox(width: 4),
                ],
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(fontSize: 10, color: isMe ? textColor.withValues(alpha: 0.65) : AppTheme.tinteStumm),
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
      decoration: BoxDecoration(color: AppTheme.papier, border: Border(top: BorderSide(color: AppTheme.linie, width: VpLinie.haar))),
      child: Row(
        children: [
          if (StorageService.spicyMode()) ...[
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _verschwinden = !_verschwinden);
              },
              isSelected: _verschwinden,
              icon: Icon(Icons.timer_outlined, color: AppTheme.tinteStumm),
              selectedIcon: Icon(Icons.timer_rounded, color: AppTheme.akzentTief),
              tooltip: t.verschwindenSchalter,
            ),
            IconButton(
              onPressed: _fotoSenden,
              icon: Icon(Icons.add_a_photo_outlined, color: AppTheme.tinteStumm),
              tooltip: t.fotoSenden,
            ),
          ],
          Expanded(
            child: TextField(
              controller: _chatController,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: AppTheme.tinte, fontSize: 14),
              decoration: InputDecoration(
                hintText: _verschwindenAktiv ? t.verschwindenHinweis : t.couplesChannelWriteAMessage,
                hintStyle: TextStyle(color: _verschwindenAktiv ? AppTheme.akzentTief : AppTheme.tinteStumm, fontSize: 13.5),
                filled: true,
                fillColor: _verschwindenAktiv
                    ? AppTheme.akzentLeise
                    : AppTheme.papierErhoben,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(VpRadius.feld),
                  borderSide: BorderSide(color: AppTheme.linieStark, width: VpLinie.haar),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            onPressed: _sendMessage,
            style: IconButton.styleFrom(backgroundColor: AppTheme.akzentTief, fixedSize: const Size(46, 46), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.feld))),
            icon: Icon(Icons.send_rounded, color: AppTheme.aufAkzentTief, size: 20),
            tooltip: t.couplesChannelSend,
          ),
        ],
      ),
    );
  }

  Widget _buildWishesTab() {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_nostr.myFantasyVotesNotifier, _nostr.matchesNotifier, _nostr.besprechenNotifier, StorageService.spicyAenderung]),
      builder: (context, _) {
        // Nur Treffer und Besprech-Punkte, die hier auch sichtbar sind (Spicy-Szenen nur im Spicy-Modus).
        final matches = [for (final id in _nostr.matchesNotifier.value) if (ListenUebersetzung.titelFuer(id) != null) id];
        final besprechen = [for (final id in _nostr.besprechenNotifier.value) if (ListenUebersetzung.titelFuer(id) != null) id];
        final myVotes = _nostr.myFantasyVotesNotifier.value;
        final szenen = ListenUebersetzung.fantasien;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            if (!_karteOben) const ErsteWocheKarte(imTabWir: true),
            Padding(
              padding: EdgeInsets.fromLTRB(2, 4, 2, 14),
              child: Text(
                t.couplesChannelVoteSeparatelyAWishOnly,
                style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13.5, height: 1.45),
              ),
            ),
            if (matches.isNotEmpty) ...[
              _buildMatchBanner(matches),
              const SizedBox(height: 12),
            ],
            if (besprechen.isNotEmpty) ...[
              _buildBesprechenKarte(besprechen),
              const SizedBox(height: 12),
            ],
            _buildFantasyMapCard(subtitle: t.couplesChannelQuestionsInSeveralAreasWith(ListenUebersetzung.eintraege.length, ListenUebersetzung.kategorien.length)),
            const SizedBox(height: 12),
            const GefuehrteAudios(mitSelbst: false),
            if (szenen.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 6, 2, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.wuenscheSzenenTitel,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.tinte)),
                  const SizedBox(height: 3),
                  Text(t.wuenscheSzenenText,
                      style: TextStyle(fontSize: 13, color: AppTheme.tinteLeise, height: 1.4)),
                ]),
              ),
              ...szenen.map((opt) => _buildWishCard(opt, myVotes[opt.id], matches.contains(opt.id), besprechen.contains(opt.id))),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMatchBanner(List<String> matches) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.akzentTief,
        borderRadius: BorderRadius.circular(VpRadius.karte),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            matches.length == 1 ? t.couplesChannelYouHaveAMatch : t.couplesChannelYouHaveMatcheslengthMatches(matches.length),
            style: TextStyle(color: AppTheme.aufAkzentTief, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...matches.map((id) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${ListenUebersetzung.titelFuer(id) ?? ''}',
                    style: TextStyle(color: AppTheme.aufAkzentTief, fontWeight: FontWeight.w600, fontSize: 13.5)),
              )),
          const SizedBox(height: 10),
          Text(
            t.couplesChannelAMatchIsAnInvitation,
            style: TextStyle(color: AppTheme.aufAkzentTief.withValues(alpha: 0.85), fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Zum Besprechen: Ja und Vielleicht oder zweimal Vielleicht. Leiser als ein Treffer.
  Widget _buildBesprechenKarte(List<String> ids) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.wuenscheBesprechenTitel,
              style: TextStyle(color: AppTheme.tinte, fontWeight: FontWeight.w800, fontSize: 15.5)),
          const SizedBox(height: 4),
          Text(t.wuenscheBesprechenText,
              style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.4)),
          const SizedBox(height: 8),
          ...ids.map((id) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• ${ListenUebersetzung.titelFuer(id) ?? ''}',
                    style: TextStyle(color: AppTheme.tinte, fontWeight: FontWeight.w600, fontSize: 13.5)),
              )),
        ],
      ),
    );
  }

  Widget _buildWishCard(FantasyOption opt, String? myVote, bool isMatch, bool besprechen) {
    final accent = isMatch ? AppTheme.akzentTief : AppTheme.akzentTief;

    Widget voteButton(String value, String label, IconData icon) {
      final selected = myVote == value;
      final color = value == 'yes' ? AppTheme.statusJa : AppTheme.tinteLeise;
      final fuellung = value == 'yes' ? AppTheme.statusJa : (value == 'maybe' ? AppTheme.statusVielleicht : AppTheme.papierVertieft);
      return Expanded(
        child: OutlinedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _nostr.sendFantasyVote(opt.id, value);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? fuellung : null,
            side: BorderSide(color: selected ? Colors.transparent : AppTheme.linie),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: selected ? (value == 'no' ? AppTheme.tinte : AppTheme.aufStatus) : color),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selected ? (value == 'no' ? AppTheme.tinte : AppTheme.aufStatus) : color,
                    fontSize: 12.5)),
          ]),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMatch ? AppTheme.akzentTief.withValues(alpha: 0.1) : AppTheme.papierErhoben,
        borderRadius: BorderRadius.circular(VpRadius.karte),
        border: Border.all(color: isMatch ? AppTheme.akzentTief.withValues(alpha: 0.7) : AppTheme.linie),
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
                        style: TextStyle(color: AppTheme.tinte, fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
              if (isMatch) Icon(Icons.favorite_rounded, color: AppTheme.akzentTief, size: 20),
              if (besprechen && !isMatch) Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.akzentTief, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(opt.subtitle, style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              voteButton('yes', t.couplesChannelYesPlease, Icons.favorite_rounded),
              const SizedBox(width: 8),
              voteButton('maybe', t.yesNoMaybeMaybe, Icons.help_outline_rounded),
              const SizedBox(width: 8),
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
    // Der Hinweis ist wählbar: Wer sich vor einer kontrollierenden Person schützen will, trennt still.
    // Hat das Gegenüber schon getrennt, gibt es nichts zu senden.
    final hinweis = ValueNotifier<bool>(true);
    final getrennt = _nostr.partnerGetrenntNotifier.value;
    final ja = await _zweimalBestaetigen(
      titel1: t.trennungDialog1Titel,
      text1: t.trennungDialog1(name),
      weiter: t.trennungDialog1Weiter,
      titel2: t.trennungDialog2Titel,
      text2: t.trennungDialog2,
      ja: t.trennungDialog2Ja,
      inhalt1: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(t.trennungDialog1(name), style: TextStyle(color: AppTheme.tinteLeise, height: 1.45)),
          if (!getrennt)
            ValueListenableBuilder<bool>(
              valueListenable: hinweis,
              builder: (context, an, _) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: an,
                onChanged: (v) => hinweis.value = v,
                title: Text(t.trennungHinweisSenden(name), style: TextStyle(fontSize: 14, color: AppTheme.tinte)),
                subtitle: Text(an ? t.trennungHinweisInfoAn : t.trennungHinweisInfoAus(name),
                    style: TextStyle(fontSize: 12.5, color: AppTheme.tinteLeise, height: 1.4)),
              ),
            ),
          TextButton(
            onPressed: () => SosModal.show(context),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            child: Text(t.trennungHilfe, style: TextStyle(color: AppTheme.akzentTief)),
          ),
        ]),
      ),
    );
    final mitHinweis = hinweis.value;
    hinweis.dispose();
    if (!ja || _trennt) return;
    // Erst der Hinweis ans Gegenüber, dann wird hier aufgeräumt; das Trennen scheitert nie am Hinweis.
    final messenger = ScaffoldMessenger.of(context);
    _trennt = true;
    final bool hinweisGesendet;
    try {
      hinweisGesendet = await _nostr.trennenMitHinweis(hinweis: mitHinweis);
    } finally {
      _trennt = false;
    }
    messenger.showSnackBar(SnackBar(
      content: Text(hinweisGesendet ? t.couplesChannelDisconnected : t.trennungNichtGesendet(name)),
    ));
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.couplesChannelHowItStaysPrivate, style: TextStyle(fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.couplesChannelMessagesAreEncryptedOnYour,
                style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(t.couplesChannelEncryption,
                  _nostr.partnerNip17 ? t.couplesChannelEncryptionSealed : 'Nostr NIP-04'),
              if (_nostr.partnerNip17) ...[
                const SizedBox(height: 8),
                Text(
                  t.couplesChannelSealedNote,
                  style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.4),
                ),
              ],
              _buildInfoRow(t.couplesChannelServers, _nostr.connectedRelaysLabel),
              for (final relay in _nostr.connectedRelays) _buildInfoRow('', relay),
              const SizedBox(height: 10),
              Text(t.couplesChannelYourConnectionCode, style: TextStyle(color: AppTheme.tinteStumm, fontSize: 12)),
              const SizedBox(height: 4),
              SelectableText(
                _nostr.myNpub,
                style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppTheme.akzentTief),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.couplesChannelClose, style: TextStyle(color: AppTheme.tinteLeise)),
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
            child: Text(label, style: TextStyle(color: AppTheme.tinteStumm, fontSize: 12.5)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: AppTheme.tinte, fontSize: 12.5, fontWeight: FontWeight.w600)),
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
