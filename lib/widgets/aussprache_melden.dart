import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/privacy_service.dart';
import '../theme/app_theme.dart';

/// Link zur Vorlage .github/ISSUE_TEMPLATE/aussprache.md, schon ausgefüllt mit dem Ort im Audio.
/// Übertragen wird nur, was hier steht – keine Profil- oder Nutzungsdaten.
Uri ausspracheMeldungUrl({required String wo, String? stimme, Duration? position}) {
  final minute = position == null
      ? ''
      : '${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  final body = '**Wort oder Wendung:** \n\n'
      '**Wo:** $wo\n\n'
      '**Stimme:** ${stimme == null ? '' : '${stimme[0].toUpperCase()}${stimme.substring(1)}'}\n\n'
      '**Ungefähr bei Minute:** $minute\n\n'
      '**So klingt es:** \n\n'
      '**So sollte es klingen:** \n';
  return Uri.https('github.com', '/angemann-app/velvet_app/issues/new', {
    'template': 'aussprache.md',
    'title': 'Aussprache: ',
    'body': body,
  });
}

/// Fragt nach, weil die Meldung öffentlich ist, und öffnet sie dann im Browser.
Future<void> ausspracheMelden(BuildContext context, {required String wo, String? stimme, Duration? position}) async {
  final weiter = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('Wort falsch ausgesprochen?'),
      content: const Text(
        'Danke, dass du hilfst! Die Meldung landet öffentlich auf GitHub und braucht dort ein Konto. '
        'Sie ist unter deinem Kontonamen sichtbar.\n\n'
        'Übertragen werden nur die Stelle im Audio und die Stimme. Das Wort trägst du selbst ein.',
        style: TextStyle(color: AppTheme.textSecondary, height: 1.45),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Weiter zu GitHub')),
      ],
    ),
  );
  if (weiter != true) return;
  final ok = await launchUrl(ausspracheMeldungUrl(wo: wo, stimme: stimme, position: position),
          mode: LaunchMode.externalApplication)
      .catchError((_) => false);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Der Browser ließ sich nicht öffnen.')),
    );
  }
}

/// Kleiner Link unter einem Audio-Player. Im Diskretions-Modus ausgeblendet,
/// damit nichts nach außen auf die App hindeutet.
class AusspracheMeldenButton extends StatefulWidget {
  final String wo;
  final String? stimme;
  final Duration? Function()? position;

  const AusspracheMeldenButton({super.key, required this.wo, this.stimme, this.position});

  @override
  State<AusspracheMeldenButton> createState() => _AusspracheMeldenButtonState();
}

class _AusspracheMeldenButtonState extends State<AusspracheMeldenButton> {
  // Einmal laden, nicht bei jedem Neuzeichnen des Players (sonst flackert der Link).
  late final Future<bool> _diskret = PrivacyService.isDiscreetIcon();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _diskret,
      builder: (context, snapshot) {
        if (snapshot.data != false) return const SizedBox.shrink();
        return Center(
          child: TextButton.icon(
            onPressed: () => ausspracheMelden(context,
                wo: widget.wo, stimme: widget.stimme, position: widget.position?.call()),
            icon: const Icon(Icons.record_voice_over_outlined, size: 16),
            label: const Text('Wort falsch ausgesprochen?'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textMuted,
              textStyle: const TextStyle(fontSize: 12.5),
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }
}
