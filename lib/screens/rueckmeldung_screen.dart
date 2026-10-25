import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/t.dart';
import '../services/rueckmeldung.dart';
import '../services/sprache.dart';
import '../theme/app_theme.dart';

/// Funktionswunsch, Fehler oder falsche Aussprache anonym ans Rückmelde-Postfach schicken.
/// [angaben] sind schon bekannte Details (z. B. Lektion, Stimme, Minute bei der Aussprache).
class RueckmeldungScreen extends StatefulWidget {
  final RueckmeldungArt art;
  final Map<String, String> angaben;

  const RueckmeldungScreen({super.key, this.art = RueckmeldungArt.wunsch, this.angaben = const {}});

  @override
  State<RueckmeldungScreen> createState() => _RueckmeldungScreenState();
}

class _RueckmeldungScreenState extends State<RueckmeldungScreen> {
  late RueckmeldungArt _art = widget.art;
  final _nachricht = TextEditingController();
  final _wort = TextEditingController();
  final _soll = TextEditingController();
  final _kontakt = TextEditingController();
  bool _sendet = false;

  @override
  void dispose() {
    for (final c in [_nachricht, _wort, _soll, _kontakt]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _vollstaendig =>
      _art == RueckmeldungArt.aussprache ? _wort.text.trim().isNotEmpty : _nachricht.text.trim().isNotEmpty;

  Future<void> _senden() async {
    setState(() => _sendet = true);
    final info = await PackageInfo.fromPlatform();
    final aussprache = _art == RueckmeldungArt.aussprache;
    final text = Rueckmeldung.text(
      art: _art,
      nachricht: aussprache
          ? 'Wort: ${_wort.text.trim()}\nSo sollte es klingen: ${_soll.text.trim()}\n${_nachricht.text.trim()}'
          : _nachricht.text,
      angaben: aussprache ? widget.angaben : const {},
      kontakt: _kontakt.text,
      version: '${info.version}+${info.buildNumber}',
      sprache: Sprache.code,
    );
    final ok = await Rueckmeldung.senden(text);
    if (!mounted) return;
    setState(() => _sendet = false);
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(t.rueckmeldungDanke), backgroundColor: AppTheme.sageGreen));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(t.rueckmeldungFehler), backgroundColor: AppTheme.rose));
    }
  }

  InputDecoration _feld(String label, {String? hint}) => InputDecoration(labelText: label, hintText: hint);

  @override
  Widget build(BuildContext context) {
    final aussprache = _art == RueckmeldungArt.aussprache;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, title: Text(t.rueckmeldungTitel)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(t.rueckmeldungEinleitung, style: const TextStyle(color: AppTheme.textSecondary, height: 1.45)),
          const SizedBox(height: 16),
          SegmentedButton<RueckmeldungArt>(
            segments: [
              ButtonSegment(value: RueckmeldungArt.wunsch, label: Text(t.rueckmeldungWunsch)),
              ButtonSegment(value: RueckmeldungArt.fehler, label: Text(t.rueckmeldungFehlerArt)),
              ButtonSegment(value: RueckmeldungArt.aussprache, label: Text(t.rueckmeldungAussprache)),
            ],
            selected: {_art},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _art = s.first),
          ),
          const SizedBox(height: 16),
          if (aussprache) ...[
            if (widget.angaben.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  widget.angaben.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textMuted, height: 1.4),
                ),
              ),
            TextField(
              controller: _wort,
              onChanged: (_) => setState(() {}),
              decoration: _feld(t.rueckmeldungWort),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _soll,
              decoration: _feld(t.rueckmeldungSoll, hint: t.rueckmeldungSollHinweis),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _nachricht,
            onChanged: (_) => setState(() {}),
            minLines: aussprache ? 2 : 5,
            maxLines: 12,
            maxLength: 4000,
            decoration: _feld(aussprache ? t.rueckmeldungAnmerkung : t.rueckmeldungNachricht,
                hint: _art == RueckmeldungArt.fehler ? t.rueckmeldungFehlerHinweis : null),
          ),
          TextField(
            controller: _kontakt,
            decoration: _feld(t.rueckmeldungKontakt, hint: t.rueckmeldungKontaktHinweis),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lock_outline_rounded, size: 18, color: AppTheme.sageGreen),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t.rueckmeldungDatenschutz,
                    style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.45)),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _vollstaendig && !_sendet ? _senden : null,
            icon: _sendet
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send_rounded),
            label: Text(t.rueckmeldungSenden),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => launchUrl(Uri.parse('https://github.com/angemann-app/velvet_app/issues'),
                mode: LaunchMode.externalApplication).catchError((_) => false),
            child: Text(t.rueckmeldungGithub, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}
