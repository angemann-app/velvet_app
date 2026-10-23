import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import '../services/update_service.dart';
import '../theme/app_theme.dart';

/// Prüft im Hintergrund auf Updates und zeigt bei Bedarf den Dialog.
Future<void> checkForUpdateAndPrompt(BuildContext context, {bool force = false}) async {
  final update = await UpdateService.check(force: force);
  if (!context.mounted) return;
  if (update == null) {
    if (force) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Du hast die neueste Version.')),
      );
    }
    return;
  }
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => UpdateDialog(update: update),
  );
}

class UpdateDialog extends StatefulWidget {
  final UpdateInfo update;

  const UpdateDialog({super.key, required this.update});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double? _progress;
  String? _error;

  void _install() {
    setState(() {
      _progress = 0;
      _error = null;
    });
    UpdateService.install(widget.update).listen(
      (event) {
        if (!mounted) return;
        switch (event.status) {
          case OtaStatus.DOWNLOADING:
            setState(() => _progress = (double.tryParse(event.value ?? '') ?? 0) / 100);
          case OtaStatus.INSTALLING:
          case OtaStatus.INSTALLATION_DONE:
            Navigator.of(context).pop();
          case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
            setState(() {
              _progress = null;
              _error = 'Bitte erlaube der App im nächsten Schritt, Updates zu installieren, und tippe dann erneut.';
            });
          case OtaStatus.CHECKSUM_ERROR:
            setState(() {
              _progress = null;
              _error = 'Die heruntergeladene Datei ist beschädigt. Bitte später noch einmal versuchen.';
            });
          default:
            setState(() {
              _progress = null;
              _error = 'Das Update hat nicht geklappt (${event.status.name}). Bitte später noch einmal versuchen.';
            });
        }
      },
      onError: (e) {
        if (mounted) {
          setState(() {
            _progress = null;
            _error = 'Download fehlgeschlagen. Bitte Internetverbindung prüfen.';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final update = widget.update;
    final downloading = _progress != null;

    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text('Neue Version ${update.version}', style: const TextStyle(fontSize: 18)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              update.notes.isNotEmpty ? update.notes : 'Verbesserungen und Fehlerbehebungen.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.45),
            ),
            if (downloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: _progress == 0 ? null : _progress, color: AppTheme.sageGreen),
              const SizedBox(height: 6),
              Text('Wird heruntergeladen … ${((_progress ?? 0) * 100).round()} %',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppTheme.rose, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            const Text(
              'Deine Daten bleiben bei der Aktualisierung erhalten.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        if (!downloading)
          TextButton(
            // Erinnert nach UpdateService.checkInterval erneut.
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Später', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ElevatedButton(
          onPressed: downloading ? null : _install,
          child: const Text('Jetzt aktualisieren'),
        ),
      ],
    );
  }
}
