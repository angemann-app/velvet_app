import 'package:flutter/material.dart';
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
            backgroundColor: AppTheme.rose,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: t.aiCoachCheckKey,
              textColor: Colors.white,
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
            backgroundColor: AppTheme.surface,
            title: Row(
              children: [
                Icon(Icons.key_rounded, color: AppTheme.amber, size: 22),
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
                      style: const TextStyle(color: AppTheme.amberLight, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    t.aiCoachPrivateCoachingUsesGoogleGemini,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
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
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showApiKeyGuide();
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.help_outline_rounded, size: 14, color: AppTheme.amberLight),
                              SizedBox(width: 4),
                              Text(
                                t.aiCoachShowGuide,
                                style: TextStyle(
                                  color: AppTheme.amberLight,
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
                            ? AppTheme.sageGreen.withValues(alpha: 0.15)
                            : AppTheme.rose.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (testSuccess == true)
                              ? AppTheme.sageGreen.withValues(alpha: 0.5)
                              : AppTheme.rose.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (testSuccess == true)
                                ? Icons.check_circle_rounded
                                : Icons.error_outline_rounded,
                            color: (testSuccess == true) ? AppTheme.sageGreen : AppTheme.rose,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              testResult!,
                              style: TextStyle(
                                color: (testSuccess == true) ? AppTheme.sageGreen : AppTheme.rose,
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
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.amber),
                            )
                          : const Icon(Icons.wifi_tethering_rounded, size: 16),
                      label: Text(isTesting ? t.aiCoachCheckingConnection : t.aiCoachTestConnection),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.amber,
                        side: const BorderSide(color: AppTheme.amber),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.ausspracheMeldenCancel, style: TextStyle(color: AppTheme.textMuted)),
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
                        backgroundColor: newKey.isEmpty ? AppTheme.amber : AppTheme.sageGreen,
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
        backgroundColor: AppTheme.surface,
        title: Text(t.aiCoachClearChatHistory),
        content: Text(
          t.aiCoachDoYouWantToDelete,
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.ausspracheMeldenCancel, style: TextStyle(color: AppTheme.textMuted)),
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
              backgroundColor: AppTheme.rose,
              foregroundColor: Colors.white,
            ),
            child: Text(t.aiCoachClear),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-Header bar for Key Setup & Reset
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(bottom: BorderSide(color: AppTheme.border.withValues(alpha: 0.5))),
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
                          ? AppTheme.sageGreen
                          : AppTheme.amber,
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
                          ? AppTheme.textSecondary
                          : AppTheme.amberLight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.help_outline_rounded, size: 20, color: AppTheme.amberLight),
                    tooltip: t.aiCoachGuideCreateAKey,
                    onPressed: _showApiKeyGuide,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: AppTheme.textMuted),
                    tooltip: t.aiCoachClearChat,
                    onPressed: _clearChat,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded, size: 20, color: AppTheme.textSecondary),
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
              color: AppTheme.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.amber.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.amber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t.aiCoachNoApiKeyYetCreated,
                    style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: _showApiKeyGuide,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppTheme.amberLight,
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
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.sageGreen,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  t.aiCoachCoachIsThinking,
                  style: TextStyle(
                    color: AppTheme.sageGreen.withValues(alpha: 0.9),
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
                  backgroundColor: AppTheme.surfaceLight.withValues(alpha: 0.4),
                  side: const BorderSide(color: AppTheme.border),
                  labelStyle: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                  ),
                );
              },
            ),
          ),
        ],

        // Input Field Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(top: BorderSide(color: AppTheme.border)),
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
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: t.aiCoachAskAConfidentialQuestion,
                      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.sageGreen),
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
                    backgroundColor: AppTheme.sageGreen,
                    foregroundColor: Colors.black,
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
                color: AppTheme.sageGreen.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.psychology_rounded, size: 16, color: AppTheme.sageGreen),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.surfaceLight : AppTheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser
                      ? AppTheme.border
                      : AppTheme.sageGreen.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: SelectableText(
                msg.text,
                style: TextStyle(
                  color: isUser ? AppTheme.textPrimary : const Color(0xFFF1F5F9),
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
