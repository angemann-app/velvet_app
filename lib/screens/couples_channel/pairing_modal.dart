import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/nostr_service.dart';
import '../../theme/app_theme.dart';

class PairingModal extends StatefulWidget {
  const PairingModal({super.key});

  @override
  State<PairingModal> createState() => _PairingModalState();
}

class _PairingModalState extends State<PairingModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _keyInputController = TextEditingController();
  final TextEditingController _nameInputController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isProcessingScan = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keyInputController.dispose();
    _nameInputController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleKeySubmission(String rawKey) async {
    if (_isProcessingScan) return;
    setState(() {
      _isProcessingScan = true;
      _errorMessage = null;
    });

    final nostr = NostrService();
    final name = _nameInputController.text.trim().isNotEmpty
        ? _nameInputController.text.trim()
        : 'Partner';

    final success = await nostr.setPartner(rawKey, name: name);

    if (mounted) {
      setState(() {
        _isProcessingScan = false;
      });

      if (success) {
        HapticFeedback.mediumImpact();
        // Meldet sich beim Gegenüber, damit eine offene Einladung dort sofort als Anfrage erscheint.
        nostr.sendChatMessage('👋 Hallo, ich bin jetzt verbunden.');
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verbunden mit $name 💛'),
            backgroundColor: AppTheme.sageGreen,
          ),
        );
      } else {
        HapticFeedback.heavyImpact();
        setState(() {
          _errorMessage =
              'Dieser Code passt nicht. Scanne den QR-Code deines Gegenübers oder füge den vollständigen Code (beginnt mit npub1…) ein.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nostr = NostrService();
    final myNpub = nostr.myNpub;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.link_rounded, color: AppTheme.amber, size: 24),
                SizedBox(width: 10),
                Text(
                  'Mit Partner verbinden',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.amber,
            labelColor: AppTheme.amberLight,
            unselectedLabelColor: AppTheme.textSecondary,
            tabs: const [
              Tab(icon: Icon(Icons.qr_code_rounded), text: 'Mein Code'),
              Tab(icon: Icon(Icons.qr_code_scanner_rounded), text: 'Partner scannen'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: Show My QR
                ValueListenableBuilder<String>(
                  valueListenable: nostr.myNpubNotifier,
                  builder: (context, activeNpub, _) {
                    final currentNpub = activeNpub.isNotEmpty ? activeNpub : nostr.myNpub;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            'Lass diesen Code von deinem Partner scannen, um euren privaten Kanal zu öffnen.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // QR Code Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.amber.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: currentNpub.isNotEmpty
                                ? QrImageView(
                                    data: currentNpub,
                                    version: QrVersions.auto,
                                    size: 210.0,
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                  )
                                : const SizedBox(
                                    width: 210,
                                    height: 210,
                                    child: Center(
                                      child: CircularProgressIndicator(color: AppTheme.amber),
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 20),

                          // Key text display with copy button
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    currentNpub,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, size: 18),
                                  color: AppTheme.amberLight,
                                  tooltip: 'Code kopieren',
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: currentNpub));
                                    HapticFeedback.lightImpact();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Dein Verbindungscode wurde kopiert.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_rounded, size: 14, color: AppTheme.sageGreen),
                              SizedBox(width: 6),
                              Text(
                                'Ende-zu-Ende-verschlüsselt • ohne Konto',
                                style: TextStyle(
                                  color: AppTheme.sageGreen,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // TAB 2: Scan Partner QR or Paste
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Scanner Viewport
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: AppTheme.amber.withOpacity(0.5), width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if (barcode.rawValue != null && !_isProcessingScan) {
                                      _handleKeySubmission(barcode.rawValue!);
                                      break;
                                    }
                                  }
                                },
                              ),
                              // Reticle overlay
                              Center(
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.amber, width: 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Partner-QR-Code im Rahmen halten',
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.rose.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.rose.withOpacity(0.4)),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppTheme.rose, fontSize: 12),
                          ),
                        ),
                      ],

                      // Partner Name Input
                      TextField(
                        controller: _nameInputController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Partner-Name (z.B. Mein Schatz, Anna)',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.favorite_outline_rounded, color: AppTheme.rose, size: 20),
                          filled: true,
                          fillColor: AppTheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.border),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Manual Key Input
                      TextField(
                        controller: _keyInputController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                        decoration: InputDecoration(
                          hintText: 'Oder npub1... / Hex-Schlüssel einfügen',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.key_rounded, color: AppTheme.amber, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.paste_rounded, color: AppTheme.amberLight, size: 20),
                            tooltip: 'Aus Zwischenablage einfügen',
                            onPressed: () async {
                              final data = await Clipboard.getData('text/plain');
                              if (data?.text != null) {
                                _keyInputController.text = data!.text!.trim();
                              }
                            },
                          ),
                          filled: true,
                          fillColor: AppTheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.border),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isProcessingScan
                              ? null
                              : () => _handleKeySubmission(_keyInputController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.amber,
                            foregroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isProcessingScan
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : const Text(
                                  'Verbinden & Koppeln',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
