import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'nostr_event_check.dart';
import 'nostr_service.dart';

/// Hinweis auf neue Nachrichten im Paar-Kanal, auch wenn die App gesperrt oder geschlossen ist.
///
/// - Läuft die App im Hintergrund, kommt der Hinweis sofort (NostrService ruft [notifyIfInBackground]).
/// - Ist sie beendet, prüft Androids WorkManager etwa alle 15 Minuten (kürzer erlaubt Android nicht)
///   bei den Relays, ob der Partner geschrieben hat. Dafür braucht es nur die öffentlichen Schlüssel:
///   Es wird nichts entschlüsselt, und die Mitteilung enthält weder Inhalt noch Namen.
class MessageNotifier {
  static const String keyEnabled = 'notify_messages';
  static const String keyNotifiedUntil = 'velvet_notified_until';
  static const String _task = 'velvet_message_check';
  static const int _notificationId = 4711;

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _pluginReady = false;

  static bool get _supported => !kIsWeb && Platform.isAndroid;

  static Future<void> init() async {
    if (!_supported) return;
    await _initPlugin();
    await Workmanager().initialize(callbackDispatcher);
    if (await isEnabled()) await _schedule();
  }

  static Future<void> _initPlugin() async {
    if (_pluginReady) return;
    await _plugin.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('ic_notification')),
    );
    _pluginReady = true;
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyEnabled) ?? false;
  }

  /// Schaltet die Hinweise ein oder aus. Gibt false zurück, wenn Android die Erlaubnis verweigert.
  static Future<bool> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_supported) {
      await prefs.setBool(keyEnabled, enabled);
      return true;
    }
    if (enabled) {
      await _initPlugin();
      final granted = await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          true;
      if (!granted) return false;
      await prefs.setBool(keyEnabled, true);
      await _schedule();
    } else {
      await prefs.setBool(keyEnabled, false);
      await Workmanager().cancelByUniqueName(_task);
    }
    return true;
  }

  static Future<void> _schedule() => Workmanager().registerPeriodicTask(
        _task,
        _task,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );

  /// Merkt sich, bis wohin Nachrichten bekannt sind, damit nichts doppelt gemeldet wird.
  static Future<void> markSeen(int createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    if (createdAt > (prefs.getInt(keyNotifiedUntil) ?? 0)) {
      await prefs.setInt(keyNotifiedUntil, createdAt);
    }
  }

  /// Vom NostrService bei jeder Nachricht des Partners: Hinweis nur, wenn die App nicht im Vordergrund ist.
  static Future<void> notifyIfInBackground(int createdAt) async {
    await markSeen(createdAt);
    if (!_supported || !await isEnabled()) return;
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) return;
    await show();
  }

  static Future<void> clear() async {
    if (!_supported || !_pluginReady) return;
    await _plugin.cancel(id: _notificationId);
  }

  static Future<void> show({int count = 1}) async {
    await _initPlugin();
    final prefs = await SharedPreferences.getInstance();
    // Im Diskretions-Modus heißt die App „Pulse“ – dann auch in der Mitteilung.
    final discreet = prefs.getBool('privacy_discreet_icon') ?? false;
    await _plugin.show(
      id: _notificationId,
      title: discreet ? 'Pulse' : 'VelvetPulse',
      body: count > 1 ? '$count neue Nachrichten' : 'Neue Nachricht',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'messages',
          'Nachrichten',
          channelDescription: 'Hinweis auf neue Nachrichten im Paar-Kanal, ohne Inhalt',
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.secret,
        ),
      ),
    );
  }

  /// Läuft im Hintergrund-Isolate von WorkManager.
  @visibleForTesting
  static Future<int> checkRelays({Duration timeout = const Duration(seconds: 10)}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (!(prefs.getBool(keyEnabled) ?? false)) return 0;
    final me = prefs.getString('velvet_nostr_pubkey');
    final partner = prefs.getString('velvet_partner_pubkey');
    if (me == null || partner == null || partner.isEmpty) return 0;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final since = prefs.getInt(keyNotifiedUntil) ?? now - 3600;

    final found = <String, int>{};
    await Future.wait(NostrService.fallbackRelays.map((url) async {
      try {
        final ws = await WebSocket.connect(url).timeout(timeout);
        final done = Completer<void>();
        ws.listen((data) {
          try {
            final msg = jsonDecode(data as String);
            if (msg is List && msg.length >= 3 && msg[0] == 'EVENT' && msg[2] is Map<String, dynamic>) {
              final ev = msg[2] as Map<String, dynamic>;
              if (ev['pubkey'] == partner &&
                  (ev['created_at'] as int) > since &&
                  NostrEventCheck.isValidDirectMessage(ev, recipient: me)) {
                found[ev['id'] as String] = ev['created_at'] as int;
              }
            } else if (msg is List && (msg[0] == 'EOSE' || msg[0] == 'CLOSED') && !done.isCompleted) {
              done.complete();
            }
          } catch (_) {}
        }, onDone: () {
          if (!done.isCompleted) done.complete();
        });
        ws.add(jsonEncode([
          'REQ',
          'notify',
          {
            'kinds': [4],
            'authors': [partner],
            '#p': [me],
            'since': since + 1,
            'limit': 20,
          }
        ]));
        await done.future.timeout(timeout, onTimeout: () {});
        await ws.close();
      } catch (_) {}
    }));

    if (found.isEmpty) return 0;
    await prefs.setInt(keyNotifiedUntil, found.values.reduce((a, b) => a > b ? a : b));
    return found.length;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final count = await MessageNotifier.checkRelays();
      if (count > 0) await MessageNotifier.show(count: count);
    } catch (_) {}
    return true;
  });
}
