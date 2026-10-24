import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/whats_new.dart';

void installed(int build) => PackageInfo.setMockInitialValues(
      appName: 'VelvetPulse',
      packageName: 'app.velvetpulse',
      version: '4.4.0',
      // Wie bei --split-per-abi: 2000 + Build
      buildNumber: '${2000 + build}',
      buildSignature: '',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Neuinstallation zeigt nichts', () async {
    SharedPreferences.setMockInitialValues({});
    installed(26);
    await WhatsNew.markInstalled();
    expect(await WhatsNew.pending(), isEmpty);
  });

  test('Update von einer Version ohne diesen Bildschirm zeigt den neuesten Eintrag', () async {
    SharedPreferences.setMockInitialValues({});
    installed(26);
    final entries = await WhatsNew.pending();
    expect(entries.map((e) => e.build), [26]);
  });

  test('Wer Versionen überspringt, sieht alles seit seiner letzten, aber nur einmal', () async {
    SharedPreferences.setMockInitialValues({'whats_new_seen_build': 24});
    installed(26);
    expect((await WhatsNew.pending()).map((e) => e.build), [26, 25]);
    await WhatsNew.markSeen();
    expect(await WhatsNew.pending(), isEmpty);
  });

  test('Einträge sind gültig und Build-Nummern eindeutig', () async {
    final entries = await WhatsNew.load();
    expect(entries.map((e) => e.build).toSet().length, entries.length);
    for (final e in entries) {
      expect(e.items, isNotEmpty, reason: 'Build ${e.build}');
    }
  });
}
