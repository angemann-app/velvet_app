import 'dart:convert';
import 'dart:ffi' show Abi;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ein verfügbares Update aus den GitHub-Releases.
class UpdateInfo {
  final String version;
  final int build;
  final String notes;
  final String apkUrl;
  final String sha256;
  final bool prerelease;

  const UpdateInfo({
    this.prerelease = false,
    required this.version,
    required this.build,
    required this.notes,
    required this.apkUrl,
    required this.sha256,
  });
}

/// Update-Kanal. Stabil bekommt nur normale Releases, Beta zusätzlich Vorabversionen
/// (GitHub „Pre-release“). Beide Kanäle teilen Schlüssel, Paketnamen, Datenformat und
/// eine gemeinsame, stetig steigende Build-Nummer: Ein Wechsel braucht nie eine Neuinstallation.
enum UpdateChannel { stable, beta }

/// Prüft GitHub-Releases auf neue Versionen und installiert sie.
///
/// Konvention für Releases (siehe tools/release.ps1):
///   Tag `v<version>+<build>`, z. B. `v4.1.0+13` oder `v4.2.0-beta.1+17`
///   Assets `velvetpulse-<abi>.apk` und je `velvetpulse-<abi>.apk.sha256`
class UpdateService {
  static const String repo = 'angemann-app/velvet_app';
  static const String _keyLastCheck = 'update_last_check';
  static const String _keyChannel = 'update_channel';
  static const Duration checkInterval = Duration(hours: 24);

  static Future<UpdateChannel> channel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyChannel) == 'beta' ? UpdateChannel.beta : UpdateChannel.stable;
  }

  static Future<void> setChannel(UpdateChannel channel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyChannel, channel.name);
  }

  /// Build-Nummer der installierten App. Bei --split-per-abi addiert Flutter
  /// 1000 × ABI auf den Versionscode, darum nur die letzten drei Stellen.
  static Future<int> installedBuild() async {
    final info = await PackageInfo.fromPlatform();
    return (int.tryParse(info.buildNumber) ?? 0) % 1000;
  }

  static Future<String> installedVersion() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${await installedBuild()})';
  }

  /// Gibt ein Update zurück, wenn es eines gibt. Ohne [force] höchstens einmal
  /// pro [checkInterval].
  static Future<UpdateInfo?> check({bool force = false}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    if (!force) {
      final last = prefs.getInt(_keyLastCheck) ?? 0;
      if (now - last < checkInterval.inMilliseconds) return null;
    }
    await prefs.setInt(_keyLastCheck, now);

    try {
      // Nicht /releases/latest, das kennt keine Vorabversionen. Die neuesten Releases holen
      // und das mit der höchsten Build-Nummer nehmen, das zum Kanal passt.
      final response = await http
          .get(Uri.parse('https://api.github.com/repos/$repo/releases?per_page=30'),
              headers: {'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final release = pickRelease(
        (jsonDecode(response.body) as List).cast<Map<String, dynamic>>(),
        await channel(),
      );
      // Android kann nicht zurückstufen: Wer von Beta auf Stabil wechselt, bleibt auf seiner
      // Version, bis eine stabile Version mit höherer Build-Nummer erscheint.
      if (release == null) return null;
      final tag = (release['tag_name'] as String).replaceFirst('v', '');
      final parts = tag.split('+');
      final build = buildFromTag(tag);
      if (build <= await installedBuild()) return null;

      final assets = (release['assets'] as List).cast<Map<String, dynamic>>();
      final apk = _assetFor(assets, '${_abiName()}.apk');
      if (apk == null) return null;
      // Ohne Prüfsumme kein Update: so wird nie eine beschädigte oder fremde Datei installiert.
      final shaAsset = _assetFor(assets, '${_abiName()}.apk.sha256');
      if (shaAsset == null) return null;
      final shaResponse = await http.get(Uri.parse(shaAsset['browser_download_url'] as String));
      if (shaResponse.statusCode != 200) return null;
      final sha = shaResponse.body.trim().split(RegExp(r'\s+')).first.toLowerCase();

      return UpdateInfo(
        version: parts.first,
        prerelease: release['prerelease'] == true,
        build: build,
        notes: (release['body'] as String? ?? '').trim(),
        apkUrl: apk['browser_download_url'] as String,
        sha256: sha,
      );
    } catch (e) {
      debugPrint('UpdateService check error: $e');
      return null;
    }
  }

  /// Lädt die APK herunter und öffnet die Android-Installation.
  static Stream<OtaEvent> install(UpdateInfo update) {
    return OtaUpdate().execute(
      update.apkUrl,
      destinationFilename: 'velvetpulse-update.apk',
      sha256checksum: update.sha256,
    );
  }

  /// Das Release mit der höchsten Build-Nummer im Kanal; Entwürfe nie,
  /// Vorabversionen nur im Beta-Kanal.
  @visibleForTesting
  static Map<String, dynamic>? pickRelease(List<Map<String, dynamic>> releases, UpdateChannel channel) {
    Map<String, dynamic>? best;
    var bestBuild = 0;
    for (final r in releases) {
      if (r['draft'] == true) continue;
      if (r['prerelease'] == true && channel != UpdateChannel.beta) continue;
      final build = buildFromTag(r['tag_name'] as String? ?? '');
      if (build > bestBuild) {
        best = r;
        bestBuild = build;
      }
    }
    return best;
  }

  /// Build-Nummer aus einem Tag wie `v4.2.0-beta.1+17`, 0 wenn keine erkennbar ist.
  static int buildFromTag(String tag) {
    final parts = tag.split('+');
    return parts.length == 2 ? int.tryParse(parts[1]) ?? 0 : 0;
  }

  static Map<String, dynamic>? _assetFor(List<Map<String, dynamic>> assets, String suffix) {
    for (final asset in assets) {
      if ((asset['name'] as String? ?? '').endsWith(suffix)) return asset;
    }
    return null;
  }

  static String _abiName() {
    switch (Abi.current()) {
      case Abi.androidArm:
        return 'armeabi-v7a';
      case Abi.androidX64:
        return 'x86_64';
      default:
        return 'arm64-v8a';
    }
  }
}
