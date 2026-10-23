import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'storage_service.dart';
import '../models/chat_message.dart';

class AiService {
  static const String systemInstructionText =
      "Du bist der vertrauliche Somatik-, KVT- und Erotik-Coach in der App VelvetPulse.\n\n"
      "Deine Grundhaltung & Tonalität:\n"
      "1. Charakter: Du bist eine faszinierende Mischung aus brillantem Neurowissenschaftler/Sexualtherapeuten und einem weltgewandten, charmant-frivolen Verführer auf Augenhöhe.\n"
      "2. Sprache: Du sprichst reines, flüssiges Deutsch – vollkommen frei von englischen Modewörtern oder Anglizismen. Du sprichst absolut schamfrei, sinnlich, warm und mit einem leichten, wissenden Augenzwinkern über Lust, Haut, Feuchtigkeit, Erektionen, Damm-Entspannung, Hingabe und Kopfkino. Vermeide jede sterile Krankenhaus-Sprache und jeden belehrenden Ton!\n"
      "3. Methodik: Verbinde Kognitive Verhaltenstherapie (das Entzaubern spießiger Leistungs- und Prüfungsgedanken) immer direkt mit lustvoller Somatik (Beckenboden wie warmen Honig schmelzen lassen, aktives Beckenboden-Öffnen, tiefe Kehlkopf-Seufzer, Vagus-Beruhigung, Kunst der Zeitlupe, sinnliches Umkreisen, reines Sinnesspüren).\n"
      "4. Kernbotschaft: Zeige dem Nutzer in jeder Zeile, dass sein Körper völlig in Ordnung ist und dass Langsamkeit, Pausen und das 'Nicht-Funktionieren-Müssen' kein Defekt sind, sondern der Schlüssel zu viel tieferer, unanständig guter Ekstase.\n"
      "5. Format: Antworte stets kompakt (2-3 prägnante, atmosphärische Absätze) und beende JEDE Antwort mit genau EINER offenen, leicht herausfordernden oder spür-orientierten Reflexionsfrage.";

  static List<String>? _cachedWorkingModels;
  static String? _cachedModelsKey;

  /// Dynamically queries Google Generative Language API to discover which models
  /// are active, authorized, and support generateContent for this exact API key.
  static Future<List<String>> fetchAvailableModels(String apiKey) async {
    final cleanKey = apiKey.trim();
    if (cleanKey.isEmpty) return [];

    final client = HttpClient();
    try {
      // Key im Header statt in der URL, damit er nicht in Logs oder Fehlermeldungen landet.
      final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models');
      final req = await client.getUrl(uri);
      req.headers.set('x-goog-api-key', cleanKey);
      final resp = await req.close().timeout(const Duration(seconds: 6));
      final body = await resp.transform(utf8.decoder).join();

      if (resp.statusCode == 200) {
        final data = jsonDecode(body) as Map<String, dynamic>;
        final list = data['models'] as List<dynamic>? ?? [];
        final found = <String>[];

        for (final m in list) {
          final methods = (m['supportedGenerationMethods'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
          if (methods.contains('generateContent')) {
            final name = m['name'] as String? ?? '';
            final clean = name.replaceFirst('models/', '').trim();
            if (clean.isNotEmpty) {
              found.add(clean);
            }
          }
        }

        // Prioritize Flash models, then newer versions
        found.sort((a, b) {
          final aFlash = a.contains('flash');
          final bFlash = b.contains('flash');
          if (aFlash && !bFlash) return -1;
          if (!aFlash && bFlash) return 1;
          return b.compareTo(a);
        });

        _cachedWorkingModels = found;
        _cachedModelsKey = cleanKey;
        debugPrint('AiService: ${found.length} Modelle verfügbar');
        return found;
      } else {
        // If Google returned a non-200 error, inspect error message
        try {
          final errJson = jsonDecode(body) as Map<String, dynamic>;
          final msg = errJson['error']?['message'] as String?;
          if (msg != null && msg.isNotEmpty) {
            final lower = msg.toLowerCase();
            if (lower.contains('api key not valid') || lower.contains('api_key_invalid')) {
              throw Exception('INVALID_API_KEY');
            }
            throw Exception(msg);
          }
        } catch (e) {
          if (e.toString().contains('INVALID_API_KEY')) rethrow;
        }
      }
    } catch (e) {
      debugPrint('AiService: fetchAvailableModels warning: $e');
      if (e.toString().contains('INVALID_API_KEY')) rethrow;
    } finally {
      client.close();
    }

    // Die Liste gilt nur für den Key, mit dem sie abgefragt wurde.
    return _cachedModelsKey == cleanKey ? (_cachedWorkingModels ?? []) : [];
  }

  /// Public test helper for UI to verify API key immediately
  static Future<Map<String, dynamic>> testConnection(String apiKey) async {
    try {
      final models = await fetchAvailableModels(apiKey);
      if (models.isNotEmpty) {
        return {
          'success': true,
          'models': models,
          'message': 'Verbindung erfolgreich! ${models.length} Modelle verfügbar (z. B. ${models.take(3).join(', ')}).',
        };
      }
      return {
        'success': false,
        'message': 'Keine verfügbaren Textmodelle für diesen Key gefunden. Bitte prüfe die API-Berechtigungen.',
      };
    } catch (e) {
      final str = e.toString().replaceAll('Exception: ', '').trim();
      return {
        'success': false,
        'message': str.contains('INVALID_API_KEY')
            ? 'Der API-Key ist ungültig. Bitte prüfe ihn im Google AI Studio.'
            : str,
      };
    }
  }

  static Future<String> sendMessage({
    required String userMessage,
    required List<ChatMessage> history,
    String? apiKey,
  }) async {
    final effectiveKey = (apiKey != null && apiKey.trim().isNotEmpty)
        ? apiKey.trim()
        : StorageService.getApiKey()?.trim();

    if (effectiveKey == null || effectiveKey.isEmpty) {
      throw Exception('NO_API_KEY');
    }

    // Build recent conversation history (last 10 messages)
    final recentHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    final contents = <Content>[];
    for (final msg in recentHistory) {
      if (msg.text.trim() == userMessage.trim()) continue;

      if (msg.isUser) {
        contents.add(Content.text(msg.text));
      } else {
        contents.add(Content.model([TextPart(msg.text)]));
      }
    }

    contents.add(Content.text(userMessage));

    // Discover real models or use robust candidate list
    List<String> candidateModels =
        _cachedModelsKey == effectiveKey ? (_cachedWorkingModels ?? []) : [];
    if (candidateModels.isEmpty) {
      try {
        candidateModels = await fetchAvailableModels(effectiveKey);
      } catch (e) {
        if (e.toString().contains('INVALID_API_KEY')) {
          throw Exception('INVALID_API_KEY');
        }
      }
    }

    // If dynamic discovery returned empty, use prioritized active model aliases
    if (candidateModels.isEmpty) {
      candidateModels = [
        'gemini-2.0-flash',
        'gemini-2.0-flash-001',
        'gemini-flash-latest',
        'gemini-1.5-flash-latest',
        'gemini-1.5-flash-002',
        'gemini-1.5-flash-001',
        'gemini-2.5-flash',
        'gemini-1.5-pro-latest',
        'gemini-1.5-pro',
        'gemini-pro',
      ];
    }

    // Build personalized system instructions using UserProfile if available
    final profile = StorageService.getUserProfile();
    String effectiveInstruction = systemInstructionText;
    if (profile != null) {
      effectiveInstruction +=
          "\n\nKONTEXT DES NUTZERS:\n"
          "- Name/Rufname: ${profile.name}\n"
          "- Geschlecht: ${profile.genderLabel}\n"
          "- Alter: ${profile.age} Jahre\n"
          "- Beziehungsstatus: ${profile.relationshipLabel}\n"
          "- Hauptfokus: ${profile.goalLabel}\n"
          "Sprich die Person vertraulich mit ihrem Namen an, passe deine psychologischen und somatischen Erklärungen genau an ihr Geschlecht, Alter und ihren Beziehungsstatus an.";
    }

    Object? lastError;
    for (final modelName in candidateModels) {
      try {
        debugPrint('AiService: Attempting request with model $modelName...');
        final model = GenerativeModel(
          model: modelName,
          apiKey: effectiveKey,
          systemInstruction: Content.system(effectiveInstruction),
          generationConfig: GenerationConfig(
            temperature: 0.7,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 600,
          ),
        );

        final response = await model.generateContent(contents);
        final text = response.text?.trim();
        if (text != null && text.isNotEmpty) {
          debugPrint('AiService: Success using model $modelName');
          return text;
        }
      } catch (e) {
        lastError = e;
        debugPrint('AiService: Error with $modelName: $e');
        final errLower = e.toString().toLowerCase();

        if (errLower.contains('api_key_invalid') ||
            errLower.contains('api key not valid') ||
            errLower.contains('invalid api key')) {
          throw Exception('INVALID_API_KEY');
        }

        // Try next candidate model
      }
    }

    debugPrint('AiService: All models exhausted. Final error: $lastError');
    if (lastError != null) {
      throw lastError;
    }
    throw Exception('Leere Antwort vom KI-Modell erhalten.');
  }
}
