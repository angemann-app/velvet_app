import 'package:flutter/material.dart';
import '../../theme/vp_tokens.dart';
import '../../models/chat_message.dart';
import '../../services/ai_service.dart';
import '../../services/coach_vorschlaege.dart';
import '../../services/nostr_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'api_key_guide_sheet.dart';
import '../../l10n/t.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _apiKey;

  /// Beispielfragen passend zum eigenen Profil und, wenn bekannt, zum Gegenüber aus dem Paar-Kanal.
  List<String> get _suggestedPrompts {
    final profil = StorageService.getUserProfile();
    final nostr = NostrService();
    return coachVorschlaege(
      geschlecht: profil?.gender,
      beziehung: profil?.relationshipStatus,
      partnerGeschlecht: nostr.isPaired ? nostr.partnerGenderNotifier.value : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _apiKey = StorageService.getApiKey();
    _messages = StorageService.getChatHistory();

    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(
          id: 'welcome',
          text:
              t.aiCoachWelcomeToConfidentialSomaticRelationship,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _sendMessage([String? presetText]) async {
    final text = presetText ?? _textController.text.trim();
    if (text.isEmpty) return;

    final effectiveKey = (_apiKey != null && _apiKey!.trim().isNotEmpty)
        ? _apiKey!.trim()
        : StorageService.getApiKey()?.trim();

    if (effectiveKey == null || effectiveKey.isEmpty) {
      _showApiKeyDialog(reasonMessage: t.aiCoachPleaseAddYourGeminiApi);
      return;
    }

    if (presetText == null) {
      _textController.clear();
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _scrollToBottom();
    await StorageService.saveChatHistory(_messages);

    try {
      final replyText = await AiService.sendMessage(
        apiKey: effectiveKey,
        userMessage: text,
        history: _messages,
      );

      final botMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: replyText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _messages.add(botMessage);
          _isLoading = false;
        });
        _scrollToBottom();
        await StorageService.saveChatHistory(_messages);
        await StorageService.recordActivityToday();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorText;
        final errString = e.toString();
        if (errString.contains('NO_API_KEY')) {
          errorText = t.aiCoachNoApiKeyAddedPlease;
        } else if (errString.contains('INVALID_API_KEY')) {
          errorText = t.aiCoachGoogleRejectedTheApiKey;
        } else {
          final cleanErr = errString.replaceAll('Exception: ', '').trim();
          errorText = t.aiCoachConnectionErrorCleanerr(cleanErr);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: AppTheme.akzentTief,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: t.aiCoachCheckKey,
              textColor: AppTheme.aufSignal,
              onPressed: () => _showApiKeyDialog(),
            ),
          ),
        );
      }
    }
  }

  void _showApiKeyGuide() {
    ApiKeyGuideSheet.show(
      context,
      onOpenKeyDialog: () => _showApiKeyDialog(),
    );
  }

  void _showApiKeyDialog({String? reasonMessage}) {
    final currentKey = _apiKey ?? StorageService.getApiKey() ?? '';
    final controller = TextEditingController(text: currentKey);
    bool isTesting = false;
    String? testResult;
    bool? testSuccess;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppTheme.papierErhoben,
            title: Row(
              children: [
                Icon(Icons.key_rounded, color: AppTheme.akzentTief, size: 22),
                SizedBox(width: 10),
                Text(t.aiCoachGeminiApiKey, style: TextStyle(fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reasonMessage != null) ...[
                    Text(
                      reasonMessage,
                      style: TextStyle(color: AppTheme.akzentTief, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    t.aiCoachPrivateCoachingUsesGoogleGemini,
                    style: TextStyle(color: AppTheme.tinteLeise, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    style: TextStyle(color: AppTheme.tinte, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'AIzaSy...',
                      labelText: 'Google AI Studio API Key',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.aiCoachFreeViaAistudioGoogleCom,
                        style: TextStyle(color: AppTheme.tinteStumm, fontSize: 11),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showApiKeyGuide();
                        },
                        borderRadius: BorderRadius.circular(VpRadius.chip),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.help_outline_rounded, size: 14, color: AppTheme.akzentTief),
                              SizedBox(width: 4),
                              Text(
                                t.aiCoachShowGuide,
                                style: TextStyle(
                                  color: AppTheme.akzentTief,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Connection Test Result Display
                  if (testResult != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (testSuccess == true)
                            ? AppTheme.akzentTief.withValues(alpha: 0.15)
                            : AppTheme.akzentTief.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        border: Border.all(
                          color: (testSuccess == true)
                              ? AppTheme.akzentTief.withValues(alpha: 0.5)
                              : AppTheme.akzentTief.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (testSuccess == true)
                                ? Icons.check_circle_rounded
                                : Icons.error_outline_rounded,
                            color: (testSuccess == true) ? AppTheme.akzentTief : AppTheme.akzentTief,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              testResult!,
                              style: TextStyle(
                                color: (testSuccess == true) ? AppTheme.akzentTief : AppTheme.akzentTief,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Test Connection Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isTesting
                          ? null
                          : () async {
                              final keyToTest = controller.text.trim();
                              if (keyToTest.isEmpty) {
                                setDialogState(() {
                                  testSuccess = false;
                                  testResult = t.aiCoachPleaseEnterAKeyFirst;
                                });
                                return;
                              }
                              setDialogState(() {
                                isTesting = true;
                                testResult = null;
                              });

                              final res = await AiService.testConnection(keyToTest);
                              setDialogState(() {
                                isTesting = false;
                                testSuccess = res['success'] as bool? ?? false;
                                testResult = res['message'] as String? ?? '';
                              });
                            },
                      icon: isTesting
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.akzentTief),
                            )
                          : const Icon(Icons.wifi_tethering_rounded, size: 16),
                      label: Text(isTesting ? t.aiCoachCheckingConnection : t.aiCoachTestConnection),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.akzentTief,
                        side: BorderSide(color: AppTheme.akzentTief),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VpRadius.karte)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.ausspracheMeldenCancel, style: TextStyle(color: AppTheme.tinteStumm)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newKey = controller.text.trim();
                  await StorageService.saveApiKey(newKey);
                  setState(() {
                    _apiKey = newKey;
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          newKey.isEmpty
                              ? t.aiCoachApiKeyRemoved
                              : t.aiCoachApiKeySaved,
                        ),
                        backgroundColor: newKey.isEmpty ? AppTheme.akzentTief : AppTheme.akzentTief,
                      ),
                    );
                  }
                },
                child: Text(t.partnerProfileDialogSave),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.papierErhoben,
        title: Text(t.aiCoachClearChatHistory),
        content: Text(
          t.aiCoachDoYouWantToDelete,
          style: TextStyle(color: AppTheme.tinteLeise),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.ausspracheMeldenCancel, style: TextStyle(color: AppTheme.tinteStumm)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await StorageService.clearChatHistory();
              setState(() {
                _messages = [
                  ChatMessage(
                    id: 'welcome',
                    text: t.aiCoachChatHistoryClearedWhatWould,
                    isUser: false,
                    timestamp: DateTime.now(),
                  )
                ];
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.akzent,
              foregroundColor: AppTheme.aufAkzent,
            ),
            child: Text(t.aiCoachClear),
          ),
        ],
      ),
    );
  }

  /// Ohne Schlüssel: ein freundlicher Einstieg in zwei Schritten statt einer Fehlermeldung
  /// (docs/konzepte/heute-und-produktschliff.md, Punkt 6).
  Widget _buildEinrichtung() {
    Widget schritt(int n, String text, String knopf, VoidCallback onTap) => Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            borderRadius: BorderRadius.circular(VpRadius.karte),
            border: Border.all(color: AppTheme.linie),
          ),
          child: Row(children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.akzentTief.withValues(alpha: 0.18)),
              child: Text('$n', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.akzentTief)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: AppTheme.tinte, height: 1.35))),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.akzentTief,
                side: BorderSide(color: AppTheme.akzentTief.withValues(alpha: 0.7)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text(knopf, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ]),
        );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        Center(child: Icon(Icons.chat_bubble_outline_rounded, size: 38, color: AppTheme.akzentTief)),
        const SizedBox(height: 14),
        Text(t.aiCoachEinrichtungTitel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.tinte)),
        const SizedBox(height: 10),
        Text(t.aiCoachEinrichtungText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.5, color: AppTheme.tinteLeise, height: 1.45)),
        const SizedBox(height: 8),
        schritt(1, t.aiCoachEinrichtungSchritt1, t.aiCoachEinrichtungKnopf1, _showApiKeyGuide),
        schritt(2, t.aiCoachEinrichtungSchritt2, t.aiCoachEinrichtungKnopf2, () => _showApiKeyDialog()),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.lock_outline_rounded, size: 15, color: AppTheme.tinteStumm),
          const SizedBox(width: 8),
          Expanded(
            child: Text(t.aiCoachEinrichtungDatenschutz,
                style: TextStyle(fontSize: 12.5, color: AppTheme.tinteStumm, height: 1.4)),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_apiKey == null || _apiKey!.isEmpty) return _buildEinrichtung();
    return Column(
      children: [
        // Sub-Header bar for Key Setup & Reset
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            border: Border(bottom: BorderSide(color: AppTheme.linie.withValues(alpha: 0.5))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_apiKey != null && _apiKey!.isNotEmpty)
                          ? AppTheme.akzentTief
                          : AppTheme.akzentTief,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (_apiKey != null && _apiKey!.isNotEmpty)
                        ? t.aiCoachGeminiAiConnected
                        : t.aiCoachNoApiKeyAdded,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (_apiKey != null && _apiKey!.isNotEmpty)
                          ? AppTheme.tinteLeise
                          : AppTheme.akzentTief,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.help_outline_rounded, size: 20, color: AppTheme.akzentTief),
                    tooltip: t.aiCoachGuideCreateAKey,
                    onPressed: _showApiKeyGuide,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_sweep_rounded, size: 20, color: AppTheme.tinteStumm),
                    tooltip: t.aiCoachClearChat,
                    onPressed: _clearChat,
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_rounded, size: 20, color: AppTheme.tinteLeise),
                    tooltip: t.aiCoachApiKeySettings,
                    onPressed: () => _showApiKeyDialog(),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Hint Banner if no Key is set
        if (_apiKey == null || _apiKey!.isEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.akzentTief.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(VpRadius.karte),
              border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: AppTheme.akzentTief, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t.aiCoachNoApiKeyYetCreated,
                    style: TextStyle(fontSize: 12, color: AppTheme.tinte),
                  ),
                ),
                TextButton(
                  onPressed: _showApiKeyGuide,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppTheme.akzentTief,
                  ),
                  child: Text(t.aiCoachGuide, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ),

        // Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _buildMessageBubble(msg);
            },
          ),
        ),

        // Typing indicator
        if (_isLoading) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.akzentTief,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  t.aiCoachCoachIsThinking,
                  style: TextStyle(
                    color: AppTheme.akzentTief.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Suggested Prompts Chips (if few messages)
        if (_messages.length <= 2) ...[
          Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 6),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return ActionChip(
                  label: Text(prompt),
                  onPressed: () => _sendMessage(prompt),
                  backgroundColor: AppTheme.papierVertieft.withValues(alpha: 0.4),
                  side: BorderSide(color: AppTheme.linie),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: AppTheme.tinte,
                  ),
                );
              },
            ),
          ),
        ],

        // Input Field Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          decoration: BoxDecoration(
            color: AppTheme.papierErhoben,
            border: Border(top: BorderSide(color: AppTheme.linie)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(color: AppTheme.tinte, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: t.aiCoachAskAConfidentialQuestion,
                      hintStyle: TextStyle(color: AppTheme.tinteStumm, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      fillColor: AppTheme.papier,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        borderSide: BorderSide(color: AppTheme.linie),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        borderSide: BorderSide(color: AppTheme.linie),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VpRadius.karte),
                        borderSide: BorderSide(color: AppTheme.akzentTief),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading ? null : () => _sendMessage(),
                  icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.akzent,
                    foregroundColor: AppTheme.aufAkzent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 10, top: 2),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.akzentTief.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.akzentTief.withValues(alpha: 0.4)),
              ),
              child: Icon(Icons.psychology_rounded, size: 16, color: AppTheme.akzentTief),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.papierVertieft : AppTheme.papierErhoben,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser
                      ? AppTheme.linie
                      : AppTheme.akzentTief.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: SelectableText(
                msg.text,
                style: TextStyle(
                  color: AppTheme.tinte,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
