// Läuft als Test (eigener Ordner, damit er nicht bei jedem flutter test mitläuft).
// ignore_for_file: invalid_use_of_visible_for_testing_member
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
import 'package:velvetpulse/screens/couples_channel/paar_abend_screen.dart';
import 'package:velvetpulse/screens/couples_channel/pairing_modal.dart';
import 'package:velvetpulse/screens/courses/lesson_detail_screen.dart';
import 'package:velvetpulse/screens/main_navigation_screen.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/screens/self_exploration/lust_profile_screen.dart';
import 'package:velvetpulse/screens/self_exploration/lust_im_traum_screen.dart';
import 'package:velvetpulse/screens/self_exploration/selbst_reise_screen.dart';
import 'package:velvetpulse/screens/self_exploration/traum_tagebuch_screen.dart';
import 'package:velvetpulse/screens/whats_new_screen.dart';
import 'package:velvetpulse/services/whats_new.dart';
import 'package:velvetpulse/screens/yes_no_maybe/yes_no_maybe_screen.dart';
import 'package:velvetpulse/services/data_service.dart';
import 'package:velvetpulse/services/nostr_service.dart';
import 'package:velvetpulse/l10n/t.dart';
import 'package:velvetpulse/services/sprache.dart';
import 'package:velvetpulse/services/storage_service.dart';
import 'package:velvetpulse/theme/app_theme.dart';

const _fontDir = 'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts';
/// Sprache der Screenshots: flutter test test_screens/screens_test.dart --dart-define=LANG=en
const _sprache = String.fromEnvironment('LANG', defaultValue: 'de');
/// Spicy-Palette rendern: flutter test test_screens/screens_test.dart --dart-define=SPICY=true
const _spicy = bool.fromEnvironment('SPICY');
/// Darstellung des Normalmodus: --dart-define=PALETTE=papier|nacht|klassisch (Standard: papier). Spicy geht vor.
const _palette = String.fromEnvironment('PALETTE', defaultValue: 'papier');
final _outDir = Directory(_spicy
    ? 'build/screens_spicy'
    : (_palette != 'papier'
        ? 'build/screens_$_palette'
        : (_sprache == 'de' ? 'build/screens' : 'build/screens_$_sprache')));
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
  // Emojis (Funken im Paar-Kanal): unter Windows liegt eine Farb-Emoji-Schrift bei.
  const emojiFont = 'C:/Windows/Fonts/seguiemj.ttf';
  if (File(emojiFont).existsSync()) {
    await (FontLoader('Emoji')
          ..addFont(Future.value(ByteData.view(Uint8List.fromList(await File(emojiFont).readAsBytes()).buffer))))
        .load();
  }
  await (FontLoader('MaterialIcons')..addFont(load('materialicons-regular.otf'))).load();
  // Redaktionelle Serif der App (assets/fonts), damit die Screenshots die echte Typografie zeigen.
  Future<ByteData> serif(String f) async =>
      ByteData.view(Uint8List.fromList(await File('assets/fonts/$f').readAsBytes()).buffer);
  await (FontLoader('SourceSerif4')
        ..addFont(serif('SourceSerif4-Regular.ttf'))
        ..addFont(serif('SourceSerif4-SemiBold.ttf'))
        ..addFont(serif('SourceSerif4-Italic.ttf')))
      .load();
}

/// Serif-Stile der App behalten, alle anderen auf Roboto setzen.
TextStyle? _mitRoboto(TextStyle? s) =>
    s == null ? null : (s.fontFamily == 'SourceSerif4' ? s : s.copyWith(fontFamily: 'Roboto', fontFamilyFallback: ['Emoji']));

/// Im Test gibt es keine Systemschrift: Stile ohne Schriftfamilie (AppBar, Knöpfe)
/// würden als Kästchen gezeichnet. Darum überall Roboto eintragen.
ThemeData _testTheme() {
  final base = AppTheme.darkTheme;
  ButtonStyle withRoboto(ButtonStyle? style) => (style ?? const ButtonStyle()).copyWith(
        textStyle: WidgetStatePropertyAll(
            (style?.textStyle?.resolve({}) ?? const TextStyle()).copyWith(fontFamily: 'Roboto')),
      );
  return base.copyWith(
    textTheme: TextTheme(
      displayLarge: _mitRoboto(base.textTheme.displayLarge),
      displayMedium: _mitRoboto(base.textTheme.displayMedium),
      displaySmall: _mitRoboto(base.textTheme.displaySmall),
      headlineLarge: _mitRoboto(base.textTheme.headlineLarge),
      headlineMedium: _mitRoboto(base.textTheme.headlineMedium),
      headlineSmall: _mitRoboto(base.textTheme.headlineSmall),
      titleLarge: _mitRoboto(base.textTheme.titleLarge),
      titleMedium: _mitRoboto(base.textTheme.titleMedium),
      titleSmall: _mitRoboto(base.textTheme.titleSmall),
      bodyLarge: _mitRoboto(base.textTheme.bodyLarge),
      bodyMedium: _mitRoboto(base.textTheme.bodyMedium),
      bodySmall: _mitRoboto(base.textTheme.bodySmall),
      labelLarge: _mitRoboto(base.textTheme.labelLarge),
      labelMedium: _mitRoboto(base.textTheme.labelMedium),
      labelSmall: _mitRoboto(base.textTheme.labelSmall),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: _mitRoboto(base.appBarTheme.titleTextStyle ?? const TextStyle()),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: withRoboto(base.elevatedButtonTheme.style)),
    outlinedButtonTheme: OutlinedButtonThemeData(style: withRoboto(base.outlinedButtonTheme.style)),
    textButtonTheme: TextButtonThemeData(style: withRoboto(base.textButtonTheme.style)),
  );
}

Widget _app(Widget home) => RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _testTheme(),
        home: home,
      ),
    );

Future<void> _shot(WidgetTester tester, String name, List<String> errors) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  await tester.runAsync(() async {
    final boundary = _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: const int.fromEnvironment('SCALE', defaultValue: 1).toDouble());
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    _outDir.createSync(recursive: true);
    File('${_outDir.path}/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
  });
  final exception = tester.takeException();
  if (exception != null) errors.add('$name: $exception');
  errors.add('--- nach $name');
  debugPrint('Screen fertig: $name');
}

void main() {
  Sprache.geraetFuerTest = _sprache;
  testWidgets('Screens rendern', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Ohne Audio-Plugin wirft AudioPlayer.dispose asynchron; das übergeht unseren Fehler-Sammler und bricht den
    // Test ab. Die Kanäle antworten deshalb hier einfach leer.
    for (final kanal in ['xyz.luan/audioplayers', 'xyz.luan/audioplayers.global']) {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(MethodChannel(kanal), (_) async => null);
    }

    final errors = <String>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (d) => errors.add(d.exceptionAsString().split('\n').first);

    SharedPreferences.setMockInitialValues({if (_spicy) 'spicy_mode': true, 'design_palette': _palette});
    await tester.runAsync(() async {
      await _loadFonts();
      await StorageService.init();
      await StorageService.saveUserProfile(
        UserProfile(name: 'Alex', gender: 'other', age: 35, relationshipStatus: 'relationship',
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

    await tester.tap(find.text(t.navLernen).last);
    await _shot(tester, '01_lernen', errors);
    await tester.tap(find.text(t.navUeben).last);
    await _shot(tester, '02_training', errors);
    await tester.tap(find.text(t.uebenGedanken));
    await _shot(tester, '03_reframing', errors);
    await tester.tap(find.text(t.uebenCoach));
    await _shot(tester, '05_kicoach', errors);
    await tester.tap(find.text(t.navWir).last);
    await _shot(tester, '04_paarkanal', errors);
    // Offene Einladung, auf die sich jemand gemeldet hat.
    await tester.runAsync(() => NostrService().startInvite('Anna'));
    NostrService().joinRequestNotifier.value = 'b' * 64;
    await tester.pumpWidget(_app(const MainNavigationScreen()));
    await tester.tap(find.text(t.navWir).last);
    await _shot(tester, '04_paarkanal_anfrage', errors);
    await tester.runAsync(() => NostrService().cancelInvite());

    // Paar-Kanal im verbundenen Zustand, mit Beispielnachrichten und einem Match.
    await tester.runAsync(() async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime(2026, 10, 23, 20, 15);
      await prefs.setString('velvet_partner_pubkey', 'a' * 64);
      await prefs.setString('velvet_partner_name', 'Anna');
      // Erfundene Beispielnachrichten eines Beispielpaars (Alex und Anna); keine echten Chats.
      await prefs.setString('velvet_couple_messages_cache', jsonEncode([
        {'id': '1', 'isMe': false, 'type': 'ping', 'emoji': '🔥', 'text': 'Lust auf dich', 'createdAt': '$now'},
        {'id': '2', 'isMe': true, 'type': 'chat', 'text': 'Du machst mich verrückt. Ich weiß schon, wo ich dich später anfassen werde 😈', 'createdAt': '$now'},
        {'id': '3', 'isMe': false, 'type': 'chat', 'text': 'Dann zieh dir vorher besser nichts Unnötiges an 😘', 'createdAt': '$now'},
      ]));
      await prefs.setString('velvet_my_fantasy_votes', jsonEncode({'match_blindfold': 'yes'}));
      await prefs.setString('velvet_partner_fantasy_votes', jsonEncode({'match_blindfold': 'yes'}));
      await NostrService().reloadKeysFromPrefs();
    });
    NostrService().partnerReadUntil.value = DateTime(2026, 10, 23, 21).millisecondsSinceEpoch ~/ 1000;
    await tester.pumpWidget(_app(const MainNavigationScreen()));
    await tester.tap(find.text(t.navWir).last);
    await _shot(tester, '04_paarkanal_verbunden', errors);
    await tester.tap(find.text(t.couplesChannelWishes));
    await _shot(tester, '04_paarkanal_wuensche', errors);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const PaarAbendScreen()));
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
    await _shot(tester, '09_paar_abend', errors);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
    await _shot(tester, '09_paar_abend_unten', errors);
    await tester.tap(find.text(t.paarAbendBeginTheEvening));
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
    await _shot(tester, '09_paar_abend_laeuft', errors);
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 1500)));
    await _shot(tester, '09_paar_abend_runde', errors);
    await tester.pumpWidget(const SizedBox());

    await tester.pumpWidget(_app(const Scaffold(body: PairingModal())));
    await _shot(tester, '04_paarkanal_koppeln', errors);

    await tester.pumpWidget(_app(const YesNoMaybeScreen()));
    await _shot(tester, '07_ja_nein_vielleicht', errors);
    await tester.tap(find.byIcon(Icons.info_outline_rounded).first);
    await _shot(tester, '07_mehr_erfahren', errors);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const YesNoMaybeScreen()));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2600));
    await _shot(tester, '07_ja_nein_vielleicht_unten', errors);
    await tester.tap(find.byIcon(Icons.info_outline_rounded).hitTestable().first);
    await _shot(tester, '07_mehr_erfahren_grafik', errors);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const LustProfileScreen()));
    await _shot(tester, '08_lust_profil', errors);

    final self = DataService.getCourses().firstWhere((c) => c.id == 'course_self_exploration');
    await tester.pumpWidget(_app(LessonDetailScreen(lesson: self.lessons[1], courseTitle: self.title)));
    await _shot(tester, '08_selbst_vulva', errors);

    // Gemeinsam lernen: Anna hat ihre Reflexion geteilt, die eigene Antwort steht noch aus.
    final neuro = DataService.getCourses().first;
    NostrService().partnerReflectionsNotifier.value = {
      neuro.lessons.first.id: 'Mir hilft es, wenn wir abends zuerst zehn Minuten nur reden.'
    };
    await tester.pumpWidget(_app(LessonDetailScreen(lesson: neuro.lessons.first, courseTitle: neuro.title)));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
    await _shot(tester, '10_gemeinsam_reflexion', errors);
    await tester.pumpWidget(const SizedBox());

    // Persönliche Ansprache: Anna ist als Frau angegeben, die Lektion nennt sie beim Namen.
    await tester.runAsync(() => NostrService().setPartnerProfile(name: 'Anna', gender: 'female'));
    final massage = DataService.getCourses().firstWhere((c) => c.id == 'course_sacred_massage');
    await tester.pumpWidget(_app(LessonDetailScreen(lesson: massage.lessons[1], courseTitle: massage.title)));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
    await _shot(tester, '11_personalisiert', errors);
    await tester.pumpWidget(const SizedBox());

    final course = DataService.getCourses().firstWhere((c) => c.id == 'course_sacred_massage');
    await tester.pumpWidget(_app(LessonDetailScreen(lesson: course.lessons[1], courseTitle: course.title)));
    await _shot(tester, '06_lektion', errors);
    await tester.pumpWidget(const SizedBox());

    final news = await tester.runAsync(WhatsNew.load);
    await tester.pumpWidget(_app(WhatsNewScreen(entries: news!.reversed.take(1).toList())));
    await _shot(tester, '12_was_ist_neu', errors);
    await tester.pumpWidget(const SizedBox());

    await tester.pumpWidget(_app(const SelbstReiseScreen()));
    for (var i = 0; i < 10 && find.text(t.paarAbendIntimate).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await tester.pump();
    }
    await tester.tap(find.text(t.paarAbendIntimate));
    await _shot(tester, '13_selbst_reise', errors);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
    await _shot(tester, '13_selbst_reise_unten', errors);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const TraumTagebuchScreen()));
    await _shot(tester, '14_traumtagebuch', errors);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const LustImTraumScreen()));
    for (var i = 0; i < 10 && find.text(t.lustFolgen).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await tester.pump();
    }
    await _shot(tester, '15_lust_im_traum', errors);

    await tester.pumpWidget(const SizedBox());
    NostrService().dispose();
    await tester.pump(const Duration(seconds: 6));
    FlutterError.onError = oldHandler;

    // ignore: avoid_print
    print('LAYOUT-PROTOKOLL:\n${errors.where((e) => !e.startsWith('RenderBox was not laid out')).join('\n')}');
  });
}
