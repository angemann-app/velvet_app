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

  const UpdateInfo({
    required this.version,
    required this.build,
    required this.notes,
    required this.apkUrl,
    required this.sha256,
  });
}

/// Prüft GitHub-Releases auf neue Versionen und installiert sie.
///
/// Konvention für Releases (siehe tools/release.ps1):
///   Tag `v<version>+<build>`, z. B. `v4.1.0+13`
///   Assets `velvetpulse-<abi>.apk` und je `velvetpulse-<abi>.apk.sha256`
class UpdateService {
  static const String repo = 'angemann-app/velvet_app';
  static const String _keyLastCheck = 'update_last_check';
  static const Duration checkInterval = Duration(hours: 24);

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
      final response = await http
          .get(Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
              headers: {'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final release = jsonDecode(response.body) as Map<String, dynamic>;

      final tag = (release['tag_name'] as String? ?? '').replaceFirst('v', '');
      final parts = tag.split('+');
      final build = parts.length == 2 ? int.tryParse(parts[1]) ?? 0 : 0;
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
