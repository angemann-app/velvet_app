import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/update_service.dart';

void installed(String version, int build) => PackageInfo.setMockInitialValues(
      appName: 'VelvetPulse',
      packageName: 'app.velvetpulse',
      version: version,
      buildNumber: '${2000 + build}',
      buildSignature: '',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Eine neue stabile Version setzt Beta auf Stabil zurück – genau einmal', () async {
    SharedPreferences.setMockInitialValues({'update_channel': 'beta'});
    installed('4.4.0', 29);
    expect(await UpdateService.resetChannelAfterStableUpdate(), isTrue);
    expect(await UpdateService.channel(), UpdateChannel.stable);

    // Wer sich danach bewusst wieder anmeldet, bleibt in Beta.
    await UpdateService.setChannel(UpdateChannel.beta);
    expect(await UpdateService.resetChannelAfterStableUpdate(), isFalse);
    expect(await UpdateService.channel(), UpdateChannel.beta);
  });

  test('Beta-Versionen setzen nichts zurück', () async {
    SharedPreferences.setMockInitialValues({'update_channel': 'beta'});
    installed('4.4.0-beta.7', 28);
    expect(await UpdateService.resetChannelAfterStableUpdate(), isFalse);
    expect(await UpdateService.channel(), UpdateChannel.beta);
  });

  test('Die nächste stabile Version beendet auch die nächste Testrunde', () async {
    SharedPreferences.setMockInitialValues({'update_channel': 'beta', 'update_channel_reset_build': 29});
    installed('4.5.0', 35);
    expect(await UpdateService.resetChannelAfterStableUpdate(), isTrue);
    expect(await UpdateService.channel(), UpdateChannel.stable);
  });
}
