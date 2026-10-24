import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/nostr_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../couples_channel/pairing_modal.dart';
import '../../l10n/t.dart';

/// Techniken aus dem Kurs „Sich selbst erkunden“ (Lektionen self_2 und self_3).
List<(String, String)> get _vulvaTechniques => [
  ('v_kreisen', t.lustProfileCircling),
  ('v_aufab', t.lustProfileUpAndDown),
  ('v_seitwaerts', t.lustProfileSideToSide),
  ('v_druecken', t.lustProfilePressAndHold),
  ('v_rahmen', t.lustProfileFramingTwoFingersLeftAnd),
  ('v_klopfen', t.lustProfileLightTapping),
  ('v_innen_aussen', t.lustProfileInsideAndOutsideAtOnce),
];

List<(String, String)> get _penisTechniques => [
  ('p_offen', t.lustProfileOpenOiledHand),
  ('p_zweihand', t.lustProfileTwoHandedGliding),
  ('p_drehen', t.lustProfileTwisting),
  ('p_ring', t.lustProfileRingAtTheBase),
  ('p_baendchen', t.lustProfileCirclingTheFrenulum),
  ('p_hoden_damm', t.lustProfileIncludingTesticlesAndPerineum),
  ('p_wellen', t.lustProfileWavesPausingJustBeforeClimax),
];

List<(String, String)> get _general => [
  ('g_langsam', t.lustProfileStartSlowlyAroundRatherThan),
  ('g_gleich', t.lustProfileWhenItSGoodKeep),
  ('g_gleitmittel', t.lustProfileWithPlentyOfLubricant),
  ('g_zeit', t.lustProfileLotsOfTimeNoGoal),
];

/// „Mein Lust-Profil“: angekreuzte Vorlieben plus Notiz, teilbar über den Paar-Kanal.
class LustProfileScreen extends StatefulWidget {
  const LustProfileScreen({super.key});

  @override
  State<LustProfileScreen> createState() => _LustProfileScreenState();
}

class _LustProfileScreenState extends State<LustProfileScreen> {
  static const String _key = 'lust_profile';

  final Set<String> _selected = {};
  final TextEditingController _note = TextEditingController();
  final NostrService _nostr = NostrService();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || !mounted) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        _selected.addAll((data['selected'] as List).cast<String>());
        _note.text = data['note'] as String? ?? '';
      });
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({'selected': _selected.toList(), 'note': _note.text}));
  }

  String _composeMessage() {
    final all = [..._general, ..._vulvaTechniques, ..._penisTechniques];
    final liked = all.where((t) => _selected.contains(t.$1)).map((t) => '• ${t.$2}').toList();
    final buffer = StringBuffer(t.lustProfileMyDesireProfileThisIs);
    if (liked.isNotEmpty) buffer.writeln(liked.join('\n'));
    final note = _note.text.trim();
    if (note.isNotEmpty) buffer.writeln('\n$note');
    buffer.write(t.lustProfileWouldYouLikeToTry);
    return buffer.toString();
  }

  bool get _hasContent => _selected.isNotEmpty || _note.text.trim().isNotEmpty;

  Future<void> _send() async {
    await _save();
    if (!_nostr.isPaired) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const PairingModal(),
      );
      return;
    }
    setState(() => _sending = true);
    final ok = await _nostr.sendChatMessage(_composeMessage());
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? t.lustProfileYourDesireProfileIsOn : t.lustProfileSendingDidnTWorkPlease),
        backgroundColor: ok ? AppTheme.sageGreen : AppTheme.rose,
      ),
    );
  }

  Future<void> _copy() async {
    await _save();
    await Clipboard.setData(ClipboardData(text: _composeMessage()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.lustProfileTextCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = StorageService.getUserProfile()?.isFemale == true;
    final first = isFemale ? (t.lustProfileWithVulva, _vulvaTechniques) : (t.lustProfileWithPenis, _penisTechniques);
    final second = isFemale ? (t.lustProfileWithPenis, _penisTechniques) : (t.lustProfileWithVulva, _vulvaTechniques);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(t.lessonDetailMyDesireProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            t.lustProfileTickWhatYouEnjoyedWhile,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 16),
          _buildSection(t.lustProfileGeneral, _general),
          _buildSection(first.$1, first.$2),
          _buildSection(second.$1, second.$2, initiallyExpanded: false),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: t.lustProfilePersonalNote,
              hintText: t.lustProfileForExampleAtTheBeginning,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _hasContent && !_sending ? _send : null,
              icon: const Icon(Icons.favorite_rounded),
              label: Text(_nostr.isPaired ? t.lustProfileSendToMyPartner : t.lustProfileConnectCoupleChannelAndSend),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.rose,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _hasContent ? _copy : null,
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(t.lustProfileJustCopyAsText),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.lustProfileTipEvenNicerThanAny,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<(String, String)> items, {bool initiallyExpanded = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          children: items
              .map((t) => CheckboxListTile(
                    value: _selected.contains(t.$1),
                    activeColor: AppTheme.rose,
                    dense: true,
                    title: Text(t.$2, style: const TextStyle(fontSize: 14)),
                    onChanged: (v) {
                      setState(() => v == true ? _selected.add(t.$1) : _selected.remove(t.$1));
                      _save();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
