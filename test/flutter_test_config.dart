import 'dart:async';

import 'package:velvetpulse/services/sprache.dart';

/// Gilt für alle Tests in test/: Die Testumgebung meldet ein englisches Gerät; die meisten Tests
/// prüfen aber die deutsche App. Tests für Englisch setzen Sprache.geraetFuerTest selbst.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Sprache.geraetFuerTest = 'de';
  await testMain();
}
