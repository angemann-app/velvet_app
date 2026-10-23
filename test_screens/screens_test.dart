// Rendert alle Hauptscreens in Handygröße als PNG nach build/screens/ und
// meldet Layout-Fehler (z. B. Überläufe). Nicht Teil der normalen Tests.
//
// Aufruf: flutter test test_screens/screens_test.dart
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/screens/couples_channel/pairing_modal.dart';
import 'package:velvetpulse/screens/courses/lesson_detail_screen.dart';
import 'package:velvetpulse/screens/main_navigation_screen.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

const _fontDir = 'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts';
final _outDir = Directory('build/screens');
final _boundary = GlobalKey();

Future<void> _loadFonts() async {
  Future<ByteData> load(String f) async =>
      ByteData.view(Uint8List.fromList(await File('$_fontDir/$f').readAsBytes()).buffer);
  final roboto = FontLoader('Roboto')
    ..addFont(load('roboto-regular.ttf'))
    ..addFont(load('roboto-medium.ttf'))
    ..addFont(load('roboto-bold.ttf'))
    ..addFont(load('roboto-black.ttf'))
    ..addFont(load('roboto-italic.ttf'));
  await roboto.load();
  await (FontLoader('MaterialIcons')..addFont(load('materialicons-regular.otf'))).load();
}

Widget _app(Widget home) => RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme.copyWith(
          textTheme: AppTheme.darkTheme.textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: home,
      ),
    );

Future<void> _shot(WidgetTester tester, String name, List<String> errors) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  await tester.runAsync(() async {
    final boundary = _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    _outDir.createSync(recursive: true);
    File('${_outDir.path}/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
  });
  final exception = tester.takeException();
  if (exception != null) errors.add('$name: $exception');
  errors.add('--- nach $name');
}

void main() {
  testWidgets('Screens rendern', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final errors = <String>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (d) => errors.add(d.exceptionAsString().split('\n').first);

    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(() async {
      await _loadFonts();
      await StorageService.init();
      await StorageService.saveUserProfile(
        UserProfile(name: 'Holger', gender: 'male', age: 45, relationshipStatus: 'relationship',
            primaryGoal: 'performance_anxiety'),
        triggerBackup: false,
      );
      await DataService.loadDatabase();
    });

    await tester.pumpWidget(_app(const OnboardingScreen()));
    await _shot(tester, '00_onboarding', errors);

    await tester.pumpWidget(_app(const MainNavigationScreen()));
    await _shot(tester, '01_kurse', errors);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
    await _shot(tester, '01_kurse_unten', errors);

    final tabs = {'Training': '02_training', 'Reframing': '03_reframing', 'Paar-Kanal': '04_paarkanal', 'KI-Coach': '05_kicoach'};
    for (final entry in tabs.entries) {
      await tester.tap(find.text(entry.key).last);
      await _shot(tester, entry.value, errors);
    }

    // Paar-Kanal im verbundenen Zustand, mit Beispielnachrichten und einem Match.
    await tester.runAsync(() async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime(2026, 10, 23, 20, 15);
      await prefs.setString('velvet_partner_pubkey', 'a' * 64);
      await prefs.setString('velvet_partner_name', 'Anna');
      await prefs.setString('velvet_couple_messages_cache', jsonEncode([
        {'id': '1', 'isMe': false, 'type': 'ping', 'emoji': '🥂', 'text': 'Freu mich auf später', 'createdAt': '$now'},
        {'id': '2', 'isMe': true, 'type': 'chat', 'text': 'Ich mich auch. Lass uns heute ganz langsam machen.', 'createdAt': '$now'},
        {'id': '3', 'isMe': false, 'type': 'chat', 'text': 'Klingt perfekt 💛', 'createdAt': '$now'},
      ]));
      await prefs.setString('velvet_my_fantasy_votes', jsonEncode({'match_blindfold': 'yes'}));
      await prefs.setString('velvet_partner_fantasy_votes', jsonEncode({'match_blindfold': 'yes'}));
      await NostrService().reloadKeysFromPrefs();
    });
    await tester.pumpWidget(_app(const MainNavigationScreen()));
    await tester.tap(find.text('Paar-Kanal').last);
    await _shot(tester, '04_paarkanal_verbunden', errors);
    await tester.tap(find.text('Wünsche'));
    await _shot(tester, '04_paarkanal_wuensche', errors);

    await tester.pumpWidget(_app(const Scaffold(body: PairingModal())));
    await _shot(tester, '04_paarkanal_koppeln', errors);

    final course = DataService.getCourses().firstWhere((c) => c.id == 'course_sacred_massage');
    await tester.pumpWidget(_app(LessonDetailScreen(lesson: course.lessons[1], courseTitle: course.title)));
    await _shot(tester, '06_lektion', errors);

    await tester.pumpWidget(const SizedBox());
    NostrService().dispose();
    await tester.pump(const Duration(seconds: 6));
    FlutterError.onError = oldHandler;

    // ignore: avoid_print
    print('LAYOUT-PROTOKOLL:\n${errors.where((e) => !e.startsWith('RenderBox was not laid out')).join('\n')}');
  });
}
