// ignore_for_file: invalid_use_of_visible_for_testing_member
// Echter Durchlauf gegen R2/GitHub: signiertes Verzeichnis laden und prüfen, ein Paket herunterladen und
// installieren. Läuft nicht automatisch:  flutter test test_live/pakete_live_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/paket_verzeichnis.dart';
import 'package:velvetpulse/services/pakete.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Verzeichnis ist gültig signiert, en-gefuehrt lässt sich laden und installieren', () async {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = null; // flutter_test sperrt echte Verbindungen sonst
    final tmp = Directory.systemTemp.createTempSync('pakete_live');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final v = await PaketVerzeichnis.laden(ablageFuerTest: () async => tmp.path);
    expect(v, isNotNull, reason: 'Verzeichnis nicht erreichbar oder Signatur ungültig');
    expect(v!.pakete.map((p) => p.name), containsAll(['de-lektionen', 'de-gefuehrt', 'en-lektionen', 'en-gefuehrt']));

    Pakete.basisFuerTest = '${tmp.path}/pakete';
    await Pakete.laden('en-gefuehrt', verzeichnis: v);
    expect(Pakete.version('en-gefuehrt'), v.paket('en-gefuehrt')!.version);
    expect(File('${tmp.path}/pakete/en-gefuehrt/audio/paar/dauer.json').existsSync(), isTrue);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
