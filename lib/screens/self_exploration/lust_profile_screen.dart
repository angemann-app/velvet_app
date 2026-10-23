import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/nostr_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../couples_channel/pairing_modal.dart';

/// Techniken aus dem Kurs „Sich selbst erkunden“ (Lektionen self_2 und self_3).
const List<(String, String)> _vulvaTechniques = [
  ('v_kreisen', 'Kreisen'),
  ('v_aufab', 'Auf und ab'),
  ('v_seitwaerts', 'Seitwärts'),
  ('v_druecken', 'Drücken und halten'),
  ('v_rahmen', 'Rahmen – zwei Finger links und rechts'),
  ('v_klopfen', 'Leichtes Klopfen'),
  ('v_innen_aussen', 'Innen und außen zugleich'),
];

const List<(String, String)> _penisTechniques = [
  ('p_offen', 'Offene, eingeölte Hand'),
  ('p_zweihand', 'Zweihand-Gleiten'),
  ('p_drehen', 'Drehen'),
  ('p_ring', 'Ring an der Wurzel'),
  ('p_baendchen', 'Das Bändchen umkreisen'),
  ('p_hoden_damm', 'Hoden und Damm einbeziehen'),
  ('p_wellen', 'Wellen – kurz vor dem Höhepunkt innehalten'),
];

const List<(String, String)> _general = [
  ('g_langsam', 'Langsam beginnen, rundherum statt direkt'),
  ('g_gleich', 'Wenn es gut ist: genau so weitermachen'),
  ('g_gleitmittel', 'Mit viel Gleitmittel'),
  ('g_zeit', 'Viel Zeit, ohne Ziel'),
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
    final buffer = StringBuffer('💛 Mein Lust-Profil – das habe ich über mich entdeckt:\n');
    if (liked.isNotEmpty) buffer.writeln(liked.join('\n'));
    final note = _note.text.trim();
    if (note.isNotEmpty) buffer.writeln('\n$note');
    buffer.write('\nMagst du es mit mir ausprobieren?');
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
        content: Text(ok ? 'Dein Lust-Profil ist verschlüsselt unterwegs 💛' : 'Senden hat nicht geklappt. Bitte gleich noch einmal.'),
        backgroundColor: ok ? AppTheme.sageGreen : AppTheme.rose,
      ),
    );
  }

  Future<void> _copy() async {
    await _save();
    await Clipboard.setData(ClipboardData(text: _composeMessage()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Text kopiert.')));
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = StorageService.getUserProfile()?.isFemale == true;
    final first = isFemale ? ('Mit Vulva', _vulvaTechniques) : ('Mit Penis', _penisTechniques);
    final second = isFemale ? ('Mit Penis', _penisTechniques) : ('Mit Vulva', _vulvaTechniques);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Mein Lust-Profil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Text(
            'Hake an, was dir beim Erkunden gefallen hat. Nur du entscheidest, ob und wann du es teilst – '
            'gesendet wird ausschließlich, was du hier auswählst.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 16),
          _buildSection('Allgemein', _general),
          _buildSection(first.$1, first.$2),
          _buildSection(second.$1, second.$2, initiallyExpanded: false),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Eigene Notiz',
              hintText: 'Zum Beispiel: Am Anfang mag ich große, langsame Kreise …',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _hasContent && !_sending ? _send : null,
              icon: const Icon(Icons.favorite_rounded),
              label: Text(_nostr.isPaired ? 'An mein Gegenüber senden' : 'Paar-Kanal verbinden und senden'),
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
              label: const Text('Nur als Text kopieren'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tipp: Noch schöner als jede Nachricht ist es, die Hand deines Gegenübers zu führen oder es dir zeigen zu lassen. '
            'Die Nachricht kann der Anstoß dafür sein.',
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
