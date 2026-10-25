import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../l10n/t.dart';
import '../../services/privacy_service.dart';
import '../../theme/app_theme.dart';

/// Zeigt ein empfangenes Foto genau einmal. Es liegt nur im Arbeitsspeicher; Datei und Schlüssel
/// sind beim Öffnen schon gelöscht (FotoKanal.einmalOeffnen). Screenshots sind währenddessen gesperrt.
class FotoAnsicht extends StatefulWidget {
  final Uint8List bild;

  const FotoAnsicht({super.key, required this.bild});

  @override
  State<FotoAnsicht> createState() => _FotoAnsichtState();
}

class _FotoAnsichtState extends State<FotoAnsicht> {
  @override
  void initState() {
    super.initState();
    PrivacyService.applySecureFlag(true);
  }

  @override
  void dispose() {
    // Zurück zur Einstellung der App-Sperre (die blockiert Screenshots ohnehin).
    PrivacyService.isLockEnabled().then(PrivacyService.applySecureFlag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: InteractiveViewer(child: Center(child: Image.memory(widget.bild)))),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(t.fotoAnsichtHinweis,
              textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5)),
        ),
      ]),
    );
  }
}
