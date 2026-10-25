import 'package:flutter/material.dart';

import '../screens/rueckmeldung_screen.dart';
import '../services/privacy_service.dart';
import '../services/rueckmeldung.dart';
import '../services/sprache.dart';
import '../theme/app_theme.dart';
import '../l10n/t.dart';

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

/// Angaben zum Ort im Audio, die eine Aussprache-Meldung schon vorausgefüllt mitbringt.
Map<String, String> ausspracheAngaben({required String wo, String? stimme, Duration? position}) => {
      'Wo': wo,
      if (stimme != null) 'Stimme': '${stimme[0].toUpperCase()}${stimme.substring(1)}',
      if (position != null)
        'Minute': '${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
    };

/// Öffnet die Rückmeldung (anonym über Nostr) mit Ort, Stimme und Minute vorausgefüllt.
/// Wer lieber öffentlich auf GitHub meldet, findet dort einen Link.
Future<void> ausspracheMelden(BuildContext context, {required String wo, String? stimme, Duration? position}) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RueckmeldungScreen(
        art: RueckmeldungArt.aussprache,
        angaben: ausspracheAngaben(wo: wo, stimme: stimme, position: position),
      ),
    ));

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
  // Auf Englisch ausgeblendet: Die Meldung betrifft die deutschen Aufnahmen.
  late final Future<bool> _diskret =
      Sprache.englisch ? Future.value(true) : PrivacyService.isDiscreetIcon();

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
            label: Text(t.ausspracheMeldenWordMispronounced),
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
