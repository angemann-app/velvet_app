import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../models/chat_message.dart';
import '../models/daily_checkin.dart';
import '../models/user_profile.dart';
import 'auto_backup_service.dart';
import 'nostr_service.dart';

class StorageService {
  static const String _keyCompletedLessons = 'completed_lessons';
  static const String _keyReflectionAnswers = 'reflection_answers';
  static const String _keyCbtEntries = 'cbt_journal_entries';
  static const String _keyApiKey = 'gemini_api_key';
  static const String _keyChatHistory = 'ai_chat_history';
  static const String _keyStreakCount = 'streak_count';
  static const String _keyLastActiveDate = 'last_active_date';
  static const String _keyDailyCheckIns = 'daily_check_ins';
  static const String _keyUserProfile = 'user_profile';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyYesNoMaybe = 'yes_no_maybe_answers';

  static SharedPreferences? _prefs;
  static String? _inMemoryApiKey;
  static UserProfile? _inMemoryProfile;

  static Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final key = _prefs?.getString(_keyApiKey);
      if (key != null && key.trim().isNotEmpty) {
        _inMemoryApiKey = key.trim();
      }
      final profStr = _prefs?.getString(_keyUserProfile);
      if (profStr != null && profStr.isNotEmpty) {
        _inMemoryProfile = UserProfile.fromJson(
          jsonDecode(profStr) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('StorageService init error: $e');
    }
  }

  static Future<SharedPreferences> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Completed Lessons
  static Set<String> getCompletedLessons() {
    final list = _prefs?.getStringList(_keyCompletedLessons) ?? [];
    return list.toSet();
  }

  static Future<bool> toggleLessonCompleted(String lessonId) async {
    final prefs = await _ensurePrefs();
    final current = getCompletedLessons();
    final isCompleted = current.contains(lessonId);
    if (isCompleted) {
      current.remove(lessonId);
    } else {
      current.add(lessonId);
      await recordActivityToday();
    }
    await prefs.setStringList(_keyCompletedLessons, current.toList());
    await AutoBackupService.saveAutoBackup();
    return !isCompleted;
  }

  static bool isLessonCompleted(String lessonId) {
    return getCompletedLessons().contains(lessonId);
  }

  // Reflection Answers
  static String? getReflectionAnswer(String lessonId) {
    final jsonStr = _prefs?.getString(_keyReflectionAnswers);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map[lessonId] as String?;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveReflectionAnswer(String lessonId, String answer) async {
    final prefs = await _ensurePrefs();
    final jsonStr = prefs.getString(_keyReflectionAnswers);
    Map<String, dynamic> map = {};
    if (jsonStr != null) {
      try {
        map = jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (_) {}
    }
    map[lessonId] = answer.trim();
    await prefs.setString(_keyReflectionAnswers, jsonEncode(map));
    await recordActivityToday();
    await AutoBackupService.saveAutoBackup();
  }

  // CBT Journal Entries
  static List<CbtJournalEntry> getCbtEntries() {
    final list = _prefs?.getStringList(_keyCbtEntries) ?? [];
    final entries = <CbtJournalEntry>[];
    for (final item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        entries.add(CbtJournalEntry.fromJson(map));
      } catch (_) {}
    }
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  static Future<void> saveCbtEntry(
    CbtJournalEntry entry, {
    bool triggerBackup = true,
  }) async {
    final prefs = await _ensurePrefs();
    final entries = getCbtEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.insert(0, entry);
    }
    final rawList = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_keyCbtEntries, rawList);
    await recordActivityToday();
    if (triggerBackup) {
      await AutoBackupService.saveAutoBackup();
    }
  }

  static Future<void> deleteCbtEntry(String id) async {
    final prefs = await _ensurePrefs();
    final entries = getCbtEntries()..removeWhere((e) => e.id == id);
    final rawList = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_keyCbtEntries, rawList);
    await AutoBackupService.saveAutoBackup();
  }

  // Gemini API Key
  static String? getApiKey() {
    if (_inMemoryApiKey != null && _inMemoryApiKey!.trim().isNotEmpty) {
      return _inMemoryApiKey!.trim();
    }
    try {
      final fromPrefs = _prefs?.getString(_keyApiKey);
      if (fromPrefs != null && fromPrefs.trim().isNotEmpty) {
        _inMemoryApiKey = fromPrefs.trim();
        return _inMemoryApiKey;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> saveApiKey(String key, {bool triggerBackup = true}) async {
    final trimmed = key.trim();
    _inMemoryApiKey = trimmed.isEmpty ? null : trimmed;
    try {
      final prefs = await _ensurePrefs();
      if (trimmed.isEmpty) {
        await prefs.remove(_keyApiKey);
      } else {
        await prefs.setString(_keyApiKey, trimmed);
      }
      if (triggerBackup) {
        await AutoBackupService.saveAutoBackup();
      }
    } catch (e) {
      debugPrint('Error saving API key: $e');
    }
  }

  // AI Chat Messages
  static List<ChatMessage> getChatHistory() {
    final list = _prefs?.getStringList(_keyChatHistory) ?? [];
    final messages = <ChatMessage>[];
    for (final item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        messages.add(ChatMessage.fromJson(map));
      } catch (_) {}
    }
    return messages;
  }

  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final prefs = await _ensurePrefs();
    final rawList = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_keyChatHistory, rawList);
  }

  static Future<void> clearChatHistory() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_keyChatHistory);
  }

  // Streaks
  static int getStreakCount() {
    return _prefs?.getInt(_keyStreakCount) ?? 1;
  }

  static Future<void> recordActivityToday() async {
    final prefs = await _ensurePrefs();
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final lastStr = prefs.getString(_keyLastActiveDate);

    if (lastStr == null) {
      await prefs.setString(_keyLastActiveDate, todayStr);
      await prefs.setInt(_keyStreakCount, 1);
      return;
    }

    if (lastStr == todayStr) return;

    final lastDate = DateTime.tryParse(lastStr);
    if (lastDate != null) {
      final diff = today
          .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
          .inDays;
      if (diff == 1) {
        final currentStreak = getStreakCount();
        await prefs.setInt(_keyStreakCount, currentStreak + 1);
      } else if (diff > 1) {
        await prefs.setInt(_keyStreakCount, 1);
      }
    }
    await prefs.setString(_keyLastActiveDate, todayStr);
  }

  // Daily Check-in Feature
  static String getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static List<DailyCheckIn> getCheckInHistory() {
    final list = _prefs?.getStringList(_keyDailyCheckIns) ?? [];
    final checkins = <DailyCheckIn>[];
    for (final item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        checkins.add(DailyCheckIn.fromJson(map));
      } catch (_) {}
    }
    checkins.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return checkins;
  }

  static DailyCheckIn? getTodayCheckIn() {
    final todayKey = getTodayKey();
    final history = getCheckInHistory();
    try {
      return history.firstWhere((c) => c.date == todayKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveDailyCheckIn(DailyCheckIn checkIn) async {
    final prefs = await _ensurePrefs();
    final history = getCheckInHistory();
    final index = history.indexWhere((c) => c.date == checkIn.date);
    if (index >= 0) {
      history[index] = checkIn;
    } else {
      history.insert(0, checkIn);
    }
    final rawList = history.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_keyDailyCheckIns, rawList);
    await recordActivityToday();
    await AutoBackupService.saveAutoBackup();
  }

  // User Profile & Onboarding
  static bool hasCompletedOnboarding() {
    if (_inMemoryProfile != null) return true;
    final flag = _prefs?.getBool(_keyHasCompletedOnboarding);
    if (flag == true) return true;

    final profile = getUserProfile();
    if (profile != null && profile.name.trim().isNotEmpty) {
      _prefs?.setBool(_keyHasCompletedOnboarding, true);
      return true;
    }

    if (getCompletedLessons().isNotEmpty ||
        (getApiKey() != null && getApiKey()!.trim().isNotEmpty) ||
        getCbtEntries().isNotEmpty) {
      _prefs?.setBool(_keyHasCompletedOnboarding, true);
      return true;
    }
    return false;
  }

  static Future<void> setCompletedOnboarding(bool completed) async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(_keyHasCompletedOnboarding, completed);
  }

  static UserProfile? getUserProfile() {
    if (_inMemoryProfile != null) return _inMemoryProfile;
    final str = _prefs?.getString(_keyUserProfile);
    if (str == null || str.isEmpty) return null;
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      _inMemoryProfile = UserProfile.fromJson(map);
      return _inMemoryProfile;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveUserProfile(
    UserProfile profile, {
    bool triggerBackup = true,
  }) async {
    _inMemoryProfile = profile;
    final prefs = await _ensurePrefs();
    await prefs.setString(_keyUserProfile, jsonEncode(profile.toJson()));
    await prefs.setBool(_keyHasCompletedOnboarding, true);
    if (triggerBackup) {
      unawaited(AutoBackupService.saveAutoBackup());
    }
  }

  // Complete User Data Export & Import (Backup Resilience)
  static Map<String, dynamic> exportAllUserData() {
    return {
      'app': 'VelvetPulse',
      'version': '4.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'userProfile': getUserProfile()?.toJson(),
      'apiKey': getApiKey(),
      'completedLessons': getCompletedLessons().toList(),
      'reflectionAnswers': _prefs?.getString(_keyReflectionAnswers),
      'cbtEntries': getCbtEntries().map((e) => e.toJson()).toList(),
      'dailyCheckIns': _prefs?.getStringList(_keyDailyCheckIns),
      'yesNoMaybe': _prefs?.getString(_keyYesNoMaybe),
      'streakCount': getStreakCount(),
      'lastActiveDate': _prefs?.getString(_keyLastActiveDate),
      'hasCompletedOnboarding': true,
      'nostrPrivKey': _prefs?.getString('velvet_nostr_privkey') ??
          _prefs?.getString('mojo_nostr_privkey') ??
          NostrService().myPrivateKey,
      'nostrPubKey': _prefs?.getString('velvet_nostr_pubkey') ??
          _prefs?.getString('mojo_nostr_pubkey') ??
          NostrService().myPublicKey,
      'nostrPartnerPubKey': _prefs?.getString('velvet_partner_pubkey') ??
          _prefs?.getString('mojo_partner_pubkey') ??
          NostrService().partnerPublicKey,
      'nostrPartnerName': _prefs?.getString('velvet_partner_name') ??
          _prefs?.getString('mojo_partner_name') ??
          NostrService().partnerName,
      'myFantasyVotes': _prefs?.getString('velvet_my_fantasy_votes') ??
          _prefs?.getString('mojo_my_fantasy_votes'),
      'partnerFantasyVotes': _prefs?.getString('velvet_partner_fantasy_votes') ??
          _prefs?.getString('mojo_partner_fantasy_votes'),
    };
  }

  static Future<bool> importUserData(Map<String, dynamic> data) async {
    try {
      final prefs = await _ensurePrefs();

      // 1. User Profile (OHNE vorzeitiges saveAutoBackup!)
      if (data['userProfile'] != null && data['userProfile'] is Map) {
        final profMap = Map<String, dynamic>.from(data['userProfile'] as Map);
        await saveUserProfile(
          UserProfile.fromJson(profMap),
          triggerBackup: false,
        );
      }

      // 2. API Key (OHNE vorzeitiges saveAutoBackup!)
      if (data['apiKey'] != null &&
          data['apiKey'].toString().trim().isNotEmpty) {
        await saveApiKey(data['apiKey'].toString().trim(), triggerBackup: false);
      }

      // 3. Completed Lessons
      if (data['completedLessons'] is List) {
        final List<dynamic> importedLessons = data['completedLessons'];
        final current = getCompletedLessons();
        current.addAll(importedLessons.map((e) => e.toString()));
        await prefs.setStringList(_keyCompletedLessons, current.toList());
      }

      // 4. Reflection Answers
      if (data['reflectionAnswers'] != null &&
          data['reflectionAnswers'].toString().isNotEmpty) {
        try {
          final Map<String, dynamic> importedReflections =
              Map<String, dynamic>.from(
            jsonDecode(data['reflectionAnswers'].toString()) as Map,
          );
          final currentStr = prefs.getString(_keyReflectionAnswers);
          Map<String, dynamic> current = {};
          if (currentStr != null && currentStr.isNotEmpty) {
            current = Map<String, dynamic>.from(jsonDecode(currentStr) as Map);
          }
          current.addAll(importedReflections);
          await prefs.setString(_keyReflectionAnswers, jsonEncode(current));
        } catch (_) {}
      }

      // 5. CBT Entries
      if (data['cbtEntries'] is List) {
        final List<dynamic> importedCbt = data['cbtEntries'];
        for (final item in importedCbt) {
          if (item is Map) {
            try {
              final entry = CbtJournalEntry.fromJson(
                Map<String, dynamic>.from(item),
              );
              await saveCbtEntry(entry, triggerBackup: false);
            } catch (_) {}
          }
        }
      }

      // 6. Daily Check-Ins & Yes/No/Maybe
      if (data['dailyCheckIns'] is List) {
        final list =
            (data['dailyCheckIns'] as List).map((e) => e.toString()).toList();
        await prefs.setStringList(_keyDailyCheckIns, list);
      }
      if (data['yesNoMaybe'] != null &&
          data['yesNoMaybe'].toString().isNotEmpty) {
        await prefs.setString(_keyYesNoMaybe, data['yesNoMaybe'].toString());
      }

      // 7. Streaks
      if (data['streakCount'] is num) {
        final importedStreak = (data['streakCount'] as num).toInt();
        if (importedStreak > getStreakCount()) {
          await prefs.setInt(_keyStreakCount, importedStreak);
        }
      }

      // 8. Nostr Keys & Partner
      if (data['nostrPrivKey'] != null &&
          data['nostrPrivKey'].toString().length == 64) {
        final pk = data['nostrPrivKey'].toString();
        await prefs.setString('velvet_nostr_privkey', pk);
      }
      if (data['nostrPubKey'] != null &&
          data['nostrPubKey'].toString().length == 64) {
        final pub = data['nostrPubKey'].toString();
        await prefs.setString('velvet_nostr_pubkey', pub);
      }
      if (data['nostrPartnerPubKey'] != null &&
          data['nostrPartnerPubKey'].toString().isNotEmpty) {
        final ppub = data['nostrPartnerPubKey'].toString();
        await prefs.setString('velvet_partner_pubkey', ppub);
      }
      if (data['nostrPartnerName'] != null &&
          data['nostrPartnerName'].toString().isNotEmpty) {
        final pname = data['nostrPartnerName'].toString();
        await prefs.setString('velvet_partner_name', pname);
      }
      if (data['myFantasyVotes'] != null) {
        await prefs.setString(
          'velvet_my_fantasy_votes',
          data['myFantasyVotes'].toString(),
        );
      }
      if (data['partnerFantasyVotes'] != null) {
        await prefs.setString(
          'velvet_partner_fantasy_votes',
          data['partnerFantasyVotes'].toString(),
        );
      }

      await prefs.setBool(_keyHasCompletedOnboarding, true);

      // WICHTIG: NostrService zwingen, die neu importierten Keys in den RAM zu übernehmen!
      await NostrService().reloadKeysFromPrefs();

      // Jetzt am Ende einmalig das vollständige Backup auf Disk sichern
      await AutoBackupService.saveAutoBackup();
      return true;
    } catch (e) {
      debugPrint('importUserData error: $e');
      return false;
    }
  }
}
