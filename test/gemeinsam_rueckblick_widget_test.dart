import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/gemeinsam_antwort.dart';
import 'package:velvetpulse/screens/gemeinsam_screen.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/secret_store.dart';
import 'package:velvetpulse/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({}); FlutterSecureStorage.setMockInitialValues({});
    SecretStore.resetForTest(); StorageService.resetForTest(); await StorageService.init();
    NostrService().partnerReflectionsNotifier.value = {};
  });
  testWidgets('Fehlgeschlagener Versand deckt die Partnerantwort nicht auf', (tester) async {
    final id = 'ge_n_${'a' * 32}';
    await StorageService.saveReflectionAnswer(id, const GemeinsamAntwort('Meine Antwort').speichern());
    NostrService().partnerReflectionsNotifier.value = {
      id: const GemeinsamAntwort('Nur nach beiderseitigem Teilen sichtbar', geteilt: true).speichern()};
    await tester.pumpWidget(MaterialApp(home: GemeinsamRueckblickScreen(id: id)));
    expect(find.text('Nur nach beiderseitigem Teilen sichtbar'), findsNothing);
    await StorageService.saveReflectionAnswer(id, const GemeinsamAntwort('Meine Antwort', geteilt: true).speichern());
    NostrService().partnerReflectionsNotifier.value = Map.of(NostrService().partnerReflectionsNotifier.value);
    await tester.pump();
    expect(find.text('Nur nach beiderseitigem Teilen sichtbar'), findsOneWidget);
  });
  testWidgets('Spicy-Rückblick wird beim Ausschalten sofort verborgen', (tester) async {
    final id = 'ge_s_${'b' * 32}';
    await StorageService.setSpicyMode(true);
    await StorageService.saveReflectionAnswer(id, const GemeinsamAntwort('Privater Rückblick', geteilt: true).speichern());
    await tester.pumpWidget(MaterialApp(home: GemeinsamRueckblickScreen(id: id)));
    expect(find.text('Privater Rückblick'), findsOneWidget);
    await StorageService.setSpicyMode(false); await tester.pump();
    expect(find.text('Privater Rückblick'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });
}
