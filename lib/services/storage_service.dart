import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nostr_tools/nostr_tools.dart' show KeyApi;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../models/chat_message.dart';
import '../models/daily_checkin.dart';
import '../models/user_profile.dart';
import 'auto_backup_service.dart';
import 'backup_codec.dart';
import 'nostr_service.dart';
import 'secret_store.dart';

class StorageService {
  static const String _keyCompletedLessons = 'completed_lessons';
  static const String _keyReflectionAnswers = 'reflection_answers';
  static const String _keyCbtEntries = 'cbt_journal_entries';
  static const String _keyChatHistory = 'ai_chat_history';
  static const String _keyStreakCount = 'streak_count';
  static const String _keyLastActiveDate = 'last_active_date';
  static const String _keyDailyCheckIns = 'daily_check_ins';
  static const String _keyUserProfile = 'user_profile';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyYesNoMaybe = 'yes_no_maybe_answers';
  static const String _keyPartnerPubKey = 'velvet_partner_pubkey';
  static const String _keyPartnerName = 'velvet_partner_name';
  static const String _keyMyVotes = 'velvet_my_fantasy_votes';
  static const String _keyPartnerVotes = 'velvet_partner_fantasy_votes';
  static const String _keyPartnerReflections = 'velvet_partner_reflections';

  static SharedPreferences? _prefs;
  static UserProfile? _inMemoryProfile;

  static Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await SecretStore.init(_prefs!);
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

  @visibleForTesting
  static void resetForTest() {
    _prefs = null;
    _inMemoryProfile = null;
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

  // Gemini API Key – liegt im SecretStore, nie in den SharedPreferences oder im Backup.
  static String? getApiKey() => SecretStore.read(SecretStore.apiKey);

  static Future<void> saveApiKey(String key, {bool triggerBackup = true}) async {
    final trimmed = key.trim();
    await SecretStore.write(SecretStore.apiKey, trimmed);
    if (triggerBackup) {
      await AutoBackupService.saveAutoBackup();
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

  // Sicherung: Export und Import (Format siehe BackupCodec)

  /// Normale Sicherung (Auto-Backup, „Backup exportieren“): alle Nutzerdaten,
  /// aber keine Geheimnisse. Der eigene öffentliche Nostr-Schlüssel ist dabei,
  /// damit beim Import erkennbar ist, ob die Paar-Verbindung noch passt.
  static Map<String, dynamic> exportAllUserData() {
    return {
      'app': 'VelvetPulse',
      'schema': BackupCodec.schema,
      'exportedAt': DateTime.now().toIso8601String(),
      'userProfile': getUserProfile()?.toJson(),
      'completedLessons': getCompletedLessons().toList(),
      'reflectionAnswers': _prefs?.getString(_keyReflectionAnswers),
      'cbtEntries': getCbtEntries().map((e) => e.toJson()).toList(),
      'dailyCheckIns': _prefs?.getStringList(_keyDailyCheckIns),
      'yesNoMaybe': _prefs?.getString(_keyYesNoMaybe),
      'streakCount': getStreakCount(),
      'lastActiveDate': _prefs?.getString(_keyLastActiveDate),
      'nostrPubKey': NostrService().myPublicKey,
      'nostrPartnerPubKey': _prefs?.getString(_keyPartnerPubKey),
      'nostrPartnerName': _prefs?.getString(_keyPartnerName),
      'myFantasyVotes': _prefs?.getString(_keyMyVotes),
      'partnerFantasyVotes': _prefs?.getString(_keyPartnerVotes),
      'partnerReflections': _prefs?.getString(_keyPartnerReflections),
    };
  }

  /// Sicherung für den Umzug auf ein anderes Gerät: zusätzlich API-Key und
  /// privater Nostr-Schlüssel, verschlüsselt mit dem Passwort des Nutzers.
  static Future<Map<String, dynamic>> exportWithSecrets(String password) async {
    final data = exportAllUserData();
    final secrets = <String, String>{
      'nostrPrivKey': NostrService().myPrivateKey,
      if (getApiKey() != null) 'apiKey': getApiKey()!,
    };
    data['secrets'] = await BackupCodec.encryptSecrets(secrets, password);
    return data;
  }

  /// Bequemer Weg für bereits geprüfte Klartext-Sicherungen ohne Passwort.
  static Future<bool> importUserData(Map<String, dynamic> data) async {
    try {
      final backup = BackupCodec.validate(data);
      await importBackup(backup, secrets: backup.plaintextSecrets);
      return true;
    } catch (e) {
      debugPrint('importUserData abgelehnt: ${e is BackupException ? e.message : e.runtimeType}');
      return false;
    }
  }

  /// Spielt eine geprüfte Sicherung ein. Alles wird erst vorbereitet und dann
  /// geschrieben; scheitert ein Schreibvorgang, wird der vorherige Stand
  /// wiederhergestellt. [secrets] sind die entschlüsselten bzw. Klartext-Geheimnisse.
  static Future<void> importBackup(ValidatedBackup backup, {Map<String, String> secrets = const {}}) async {
    final prefs = await _ensurePrefs();
    final d = backup.data;

    // 1. Vorbereiten, ohne etwas zu schreiben.
    final writes = <String, Object>{};
    UserProfile? profile;
    if (d['userProfile'] is Map) {
      try {
        profile = UserProfile.fromJson(Map<String, dynamic>.from(d['userProfile'] as Map));
      } catch (_) {
        throw const BackupException('Die Sicherung ist beschädigt (Profil).');
      }
      writes[_keyUserProfile] = jsonEncode(profile.toJson());
    }
    if (d['completedLessons'] is List) {
      writes[_keyCompletedLessons] =
          {...getCompletedLessons(), ...(d['completedLessons'] as List).map((e) => e.toString())}.toList();
    }
    if (d['reflectionAnswers'] is String && (d['reflectionAnswers'] as String).isNotEmpty) {
      final imported = jsonDecode(d['reflectionAnswers'] as String);
      if (imported is! Map) throw const BackupException('Die Sicherung ist beschädigt (Reflexionen).');
      final currentStr = prefs.getString(_keyReflectionAnswers);
      final current = currentStr == null || currentStr.isEmpty
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(currentStr) as Map);
      writes[_keyReflectionAnswers] = jsonEncode({...current, ...imported});
    }
    if (d['cbtEntries'] is List) {
      final entries = {for (final e in getCbtEntries()) e.id: e};
      for (final item in d['cbtEntries'] as List) {
        if (item is! Map) continue;
        try {
          final entry = CbtJournalEntry.fromJson(Map<String, dynamic>.from(item));
          entries[entry.id] = entry;
        } catch (_) {}
      }
      final sorted = entries.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      writes[_keyCbtEntries] = sorted.map((e) => jsonEncode(e.toJson())).toList();
    }
    if (d['dailyCheckIns'] is List) {
      writes[_keyDailyCheckIns] = (d['dailyCheckIns'] as List).map((e) => e.toString()).toList();
    }
    if (d['yesNoMaybe'] is String && (d['yesNoMaybe'] as String).isNotEmpty) {
      writes[_keyYesNoMaybe] = d['yesNoMaybe'] as String;
    }
    if (d['streakCount'] is int && (d['streakCount'] as int) > getStreakCount()) {
      writes[_keyStreakCount] = d['streakCount'] as int;
    }

    // Paar-Kanal: Der Partner passt nur, wenn auch der eigene Schlüssel mitkommt oder
    // die Sicherung von genau diesem Schlüssel stammt. Sonst wäre die Verbindung nur scheinbar da.
    final newPriv = secrets['nostrPrivKey'];
    if (newPriv != null && d['nostrPubKey'] != null && KeyApi().getPublicKey(newPriv) != d['nostrPubKey']) {
      throw const BackupException('Die Schlüssel in der Sicherung passen nicht zusammen.');
    }
    final sameIdentity = d['nostrPubKey'] == null || d['nostrPubKey'] == NostrService().myPublicKey;
    if (newPriv != null || sameIdentity) {
      for (final (field, key) in [
        ('nostrPartnerPubKey', _keyPartnerPubKey),
        ('nostrPartnerName', _keyPartnerName),
        ('myFantasyVotes', _keyMyVotes),
        ('partnerFantasyVotes', _keyPartnerVotes),
        ('partnerReflections', _keyPartnerReflections),
      ]) {
        final value = d[field];
        if (value is String && value.isNotEmpty) writes[key] = value;
      }
    }
    writes[_keyHasCompletedOnboarding] = true;

    // 2. Schreiben, bei Fehler alles zurück.
    final before = {for (final key in writes.keys) key: prefs.get(key)};
    final secretsBefore = {
      SecretStore.apiKey: SecretStore.read(SecretStore.apiKey),
      SecretStore.nostrPrivKey: SecretStore.read(SecretStore.nostrPrivKey),
    };
    try {
      for (final entry in writes.entries) {
        await _put(prefs, entry.key, entry.value);
      }
      if (secrets['apiKey'] != null) await SecretStore.write(SecretStore.apiKey, secrets['apiKey']);
      if (newPriv != null) await SecretStore.write(SecretStore.nostrPrivKey, newPriv);
    } catch (e) {
      for (final entry in before.entries) {
        await _put(prefs, entry.key, entry.value);
      }
      for (final entry in secretsBefore.entries) {
        await SecretStore.write(entry.key, entry.value);
      }
      throw const BackupException('Die Sicherung konnte nicht eingespielt werden. Es wurde nichts verändert.');
    }

    if (profile != null) _inMemoryProfile = profile;
    await NostrService().reloadKeysFromPrefs();
    await AutoBackupService.saveAutoBackup();
  }

  static Future<void> _put(SharedPreferences prefs, String key, Object? value) async {
    switch (value) {
      case null:
        await prefs.remove(key);
      case String v:
        await prefs.setString(key, v);
      case bool v:
        await prefs.setBool(key, v);
      case int v:
        await prefs.setInt(key, v);
      case List v:
        await prefs.setStringList(key, v.map((e) => e.toString()).toList());
      default:
        throw ArgumentError('Typ ${value.runtimeType} für $key');
    }
  }
}
