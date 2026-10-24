import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/nostr_service.dart';
import '../../theme/app_theme.dart';

/// Direkter Download der neuesten STABILEN Version: GitHubs „latest“ überspringt Beta-Versionen.
const String stableApkUrl =
    'https://github.com/angemann-app/velvet_app/releases/latest/download/velvetpulse-arm64-v8a.apk';
const String testerGuideUrl = 'https://github.com/angemann-app/velvet_app/blob/main/docs/TESTER.md';

const _share = MethodChannel('velvetpulse/share');

/// Erste Nachricht: Link und Anleitung. Der Code folgt als eigene Nachricht, weil ältere
/// Versionen beim Einfügen nur den reinen Code verstehen und Messenger ganze Nachrichten kopieren.
String invitationText() => '''
Ich möchte VelvetPulse mit dir ausprobieren 💛 Eine private App nur für uns zwei.

1. App laden (Android):
$stableApkUrl
Wenn Android fragt, die Installation erlauben.

2. Meinen Verbindungscode schicke ich dir gleich als eigene Nachricht. Kopiere ihn und füge ihn in der App ein: Paar-Kanal › Mit Partner verbinden › Partner scannen › Code einfügen › „Verbinden & Koppeln“.

3. Schick mir danach einen Funken, dann sind wir verbunden.

Ausführliche Anleitung: $testerGuideUrl''';

/// Fragt nach dem Namen, öffnet das Teilen-Menü mit der Einladung und merkt sich die offene Einladung.
Future<void> invitePartner(BuildContext context) async {
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('Partner einladen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Du schickst einen Link zur App und deinen Verbindungscode, z. B. per Messenger. '
            'Sobald sich dein Gegenüber meldet, bestätigst du hier die Verbindung.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Name, z. B. Anna'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Einladung teilen'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (name == null) return;

  final nostr = NostrService();
  await nostr.startInvite(name.isEmpty ? 'Partner' : name);
  if (!context.mounted) return;
  await _shareOrCopy(context, invitationText(), 'Einladung zu VelvetPulse');
  if (!context.mounted) return;

  // Schritt 2 wartet, bis man aus dem Messenger zurückkommt.
  final sendCode = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('Jetzt noch deinen Code'),
      content: const Text(
        'Schick deinen Verbindungscode als eigene Nachricht hinterher, am besten an dieselbe Person. '
        'So lässt er sich mit einem Tippen kopieren.',
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Später')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Code teilen')),
      ],
    ),
  );
  if (sendCode == true && context.mounted) {
    await _shareOrCopy(context, nostr.myNpub, 'Mein VelvetPulse-Code');
  }
}

/// Öffnet das Teilen-Menü; ohne Teilen-Menü landet der Text in der Zwischenablage.
Future<void> _shareOrCopy(BuildContext context, String text, String subject) async {
  try {
    await _share.invokeMethod('shareText', {'text': text, 'subject': subject});
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kopiert. Füge den Text in einen Messenger ein.')),
      );
    }
  }
}

/// Zeigt den Stand einer offenen Einladung und, sobald sich jemand meldet, die Anfrage zum Bestätigen.
class InviteStatusCard extends StatelessWidget {
  const InviteStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final nostr = NostrService();
    return AnimatedBuilder(
      animation: Listenable.merge([nostr.inviteNameNotifier, nostr.joinRequestNotifier]),
      builder: (context, _) {
        final name = nostr.inviteNameNotifier.value;
        if (name == null) return const SizedBox.shrink();
        final request = nostr.joinRequestNotifier.value != null;
        final color = request ? AppTheme.rose : AppTheme.amber;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(request ? Icons.favorite_rounded : Icons.mark_email_read_outlined, color: color, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      request ? '$name möchte sich verbinden' : 'Einladung an $name verschickt',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  request
                      ? 'Gerade kam eine Nachricht an deinen Code. Wenn sie von $name ist, nimm die Verbindung an.'
                      : 'Sobald $name die App installiert, deinen Code eingibt und dir einen Funken schickt, '
                          'kannst du die Verbindung hier bestätigen.',
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.4),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: request
                    ? [
                        TextButton(
                          onPressed: nostr.declineJoinRequest,
                          child: const Text('Ablehnen', style: TextStyle(color: AppTheme.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            final ok = await nostr.acceptJoinRequest();
                            if (context.mounted && ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Verbunden mit $name 💛'), backgroundColor: AppTheme.sageGreen),
                              );
                            }
                          },
                          child: const Text('Annehmen',
                              style: TextStyle(color: AppTheme.rose, fontWeight: FontWeight.w700)),
                        ),
                      ]
                    : [
                        TextButton(
                          onPressed: nostr.cancelInvite,
                          child: const Text('Zurückziehen', style: TextStyle(color: AppTheme.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () => invitePartner(context),
                          child: Text('Erneut teilen', style: TextStyle(color: color)),
                        ),
                      ],
              ),
            ],
          ),
        );
      },
    );
  }
}
