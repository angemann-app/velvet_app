import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/screens/couples_channel/invite_partner.dart';
import 'package:velvetpulse/services/nostr_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Die ganze Einladungsnachricht einfügen verbindet mit dem enthaltenen Code', () async {
    SharedPreferences.setMockInitialValues({});
    final nostr = NostrService();
    final einladender = nostr.myNpub;
    final ok = await nostr.setPartner('Mein Code:\n$einladender\nBis gleich!', name: 'Holger');
    expect(ok, isTrue);
    expect(nostr.partnerNpub, einladender);
  });

  test('Die Einladung verlinkt immer die stabile Version', () {
    expect(stableApkUrl, contains('/releases/latest/download/'));
    expect(invitationText(), contains(stableApkUrl));
  });
}
