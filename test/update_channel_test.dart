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

  test('Nur eine echte SHA-256-Prüfsumme wird angenommen', () {
    final sha = 'a' * 64;
    expect(UpdateService.parseSha256('$sha  velvetpulse-arm64-v8a.apk\n'), sha);
    expect(UpdateService.parseSha256(sha.toUpperCase()), sha);
    for (final kaputt in ['', '<!DOCTYPE html><html>', 'a' * 63, 'g' * 64, '${'a' * 64}0']) {
      expect(UpdateService.parseSha256(kaputt), isNull, reason: kaputt);
    }
  });

  test('Downloads nur aus den Releases dieses Repositorys', () {
    expect(UpdateService.isReleaseDownloadUrl(
        'https://github.com/angemann-app/velvet_app/releases/download/v4.4.0+29/velvetpulse-arm64-v8a.apk'), isTrue);
    for (final fremd in [
      'http://github.com/angemann-app/velvet_app/releases/download/x.apk',
      'https://github.com/jemand/velvet_app/releases/download/x.apk',
      'https://github.com.example.org/angemann-app/velvet_app/releases/download/x.apk',
      'https://example.org/x.apk',
    ]) {
      expect(UpdateService.isReleaseDownloadUrl(fremd), isFalse, reason: fremd);
    }
  });

  test('Build-Nummer aus Tags', () {
    expect(UpdateService.buildFromTag('v4.2.0-beta.1+17'), 17);
    expect(UpdateService.buildFromTag('v4.1.0'), 0);
  });
}
