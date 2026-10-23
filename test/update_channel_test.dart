import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/update_service.dart';

void main() {
  Map<String, dynamic> release(String tag, {bool prerelease = false, bool draft = false}) =>
      {'tag_name': tag, 'prerelease': prerelease, 'draft': draft};

  final releases = [
    release('v4.2.0-beta.2+19', prerelease: true),
    release('v4.3.0+20', draft: true),
    release('v4.2.0-beta.1+17', prerelease: true),
    release('v4.1.1+16'),
    release('v4.1.0+15'),
  ];

  test('Stabil sieht nur normale Releases', () {
    expect(UpdateService.pickRelease(releases, UpdateChannel.stable)?['tag_name'], 'v4.1.1+16');
  });

  test('Beta nimmt die höchste Build-Nummer aus beiden Kanälen', () {
    expect(UpdateService.pickRelease(releases, UpdateChannel.beta)?['tag_name'], 'v4.2.0-beta.2+19');
    final stabilNeuer = [release('v4.2.0+21'), ...releases];
    expect(UpdateService.pickRelease(stabilNeuer, UpdateChannel.beta)?['tag_name'], 'v4.2.0+21');
  });

  test('Build-Nummer aus Tags', () {
    expect(UpdateService.buildFromTag('v4.2.0-beta.1+17'), 17);
    expect(UpdateService.buildFromTag('v4.1.0'), 0);
  });
}
