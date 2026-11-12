import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/privacy_service.dart';
import 'package:velvetpulse/widgets/app_lock.dart';

void main() {
  var abfragen = 0;

  setUp(() {
    SharedPreferences.setMockInitialValues({'privacy_lock_enabled': true});
    AppLock.zuruecksetzenFuerTest();
    abfragen = 0;
    PrivacyService.unterstuetztFuerTest = true;
    PrivacyService.authenticateFuerTest = () async {
      abfragen++;
      return true;
    };
  });
  tearDown(() {
    PrivacyService.authenticateFuerTest = null;
    PrivacyService.unterstuetztFuerTest = null;
  });

  /// Die Sperre ruft Plattform-Kanäle auf; die brauchen echte Zeit statt der simulierten.
  Future<void> zeige(WidgetTester tester, Widget w) async {
    await tester.pumpWidget(w);
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
  }

  Widget app(Key key) => MaterialApp(
        key: key,
        home: AppLock(initiallyLocked: true, child: const Scaffold(body: Text('Inhalt'))),
      );

  testWidgets('Beim Start wird einmal entsperrt', (tester) async {
    await zeige(tester, app(const ValueKey('de')));
    expect(abfragen, 1);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
  });

  testWidgets('Sprachwechsel (App wird neu aufgebaut) fragt nicht erneut nach dem Fingerabdruck', (tester) async {
    await zeige(tester, app(const ValueKey('de')));
    await zeige(tester, app(const ValueKey('en')));
    expect(abfragen, 1);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
    expect(find.text('Inhalt'), findsOneWidget);
  });

  testWidgets('Gerade eingeschaltet (Onboarding, Bestandsfrage): Sprachwechsel sperrt nicht sofort', (tester) async {
    AppLock.alsEntsperrtMerken();
    await zeige(tester, app(const ValueKey('en')));
    expect(abfragen, 0);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
    expect(find.text('Inhalt'), findsOneWidget);
  });

  testWidgets('Bildschirmsperre weggefallen: nie aussperren, Sperre aus, einmal der Hinweis', (tester) async {
    PrivacyService.unterstuetztFuerTest = false;
    final navigator = GlobalKey<NavigatorState>();
    await zeige(
      tester,
      MaterialApp(
        navigatorKey: navigator,
        builder: (context, child) => AppLock(initiallyLocked: true, navigatorKey: navigator, child: child!),
        home: const Scaffold(body: Text('Inhalt')),
      ),
    );
    await tester.pumpAndSettle();
    expect(abfragen, 0);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
    expect(find.text('Inhalt'), findsOneWidget);
    expect(await tester.runAsync(PrivacyService.isLockEnabled), isFalse);
    expect(find.text(t.appSperreKeineTitel), findsOneWidget);
    await tester.tap(find.text(t.appSperreKeineOk));
    await tester.pumpAndSettle();
    expect(find.text(t.appSperreKeineTitel), findsNothing);
  });
}
