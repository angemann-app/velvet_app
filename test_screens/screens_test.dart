// Läuft als Test (eigener Ordner, damit er nicht bei jedem flutter test mitläuft).
// ignore_for_file: invalid_use_of_visible_for_testing_member
// Rendert alle Hauptscreens in Handygröße als PNG nach build/screens/ und
// meldet Layout-Fehler (z. B. Überläufe). Nicht Teil der normalen Tests.
//
// Aufruf: flutter test test_screens/screens_test.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/models/user_profile.dart';
import 'package:velvetpulse/screens/couples_channel/erste_woche_screen.dart';
import 'package:velvetpulse/screens/couples_channel/paar_abend_screen.dart';
import 'package:velvetpulse/services/erste_woche_dienst.dart';
import 'package:velvetpulse/models/bedien_daten.dart';
import 'package:velvetpulse/screens/couples_channel/pairing_modal.dart';
import 'package:velvetpulse/screens/courses/lesson_detail_screen.dart';
import 'package:velvetpulse/screens/main_navigation_screen.dart';
import 'package:velvetpulse/screens/suche_screen.dart';
import 'package:velvetpulse/widgets/weg_begleiter.dart';
import 'package:velvetpulse/screens/wiedergabe_screen.dart';
import 'package:velvetpulse/screens/gemeinsam_screen.dart';
import 'package:velvetpulse/services/wiedergabe_dienst.dart';
import 'package:velvetpulse/services/wiedergabe_lauf.dart';
import 'package:velvetpulse/services/gemeinsam_hoeren.dart';
import 'package:velvetpulse/services/gemeinsam_dienst.dart';
import 'package:velvetpulse/models/wiedergabe_plan.dart';
import 'package:velvetpulse/models/gemeinsam_antwort.dart';
import 'package:velvetpulse/screens/onboarding/onboarding_screen.dart';
import 'package:velvetpulse/screens/self_exploration/lust_profile_screen.dart';
import 'package:velvetpulse/screens/self_exploration/lust_im_traum_screen.dart';
import 'package:velvetpulse/screens/self_exploration/traumpraxis_screen.dart';
import 'package:velvetpulse/screens/self_exploration/traumpraxis_verwalten.dart';
import 'package:velvetpulse/models/traumpraxis_daten.dart';
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
import 'package:velvetpulse/services/bild_register.dart';
import 'package:velvetpulse/services/pakete.dart';
import 'package:velvetpulse/theme/app_theme.dart';

const _fontDir = 'C:/TOOLS/flutter/bin/cache/artifacts/material_fonts';

/// Sprache der Screenshots: flutter test test_screens/screens_test.dart --dart-define=LANG=en
const _sprache = String.fromEnvironment('LANG', defaultValue: 'de');

/// Spicy-Palette rendern: flutter test test_screens/screens_test.dart --dart-define=SPICY=true
const _spicy = bool.fromEnvironment('SPICY');
const _nurTraumpraxis = bool.fromEnvironment('TRAUMPRAXIS');
const _nurBedienung = bool.fromEnvironment('BEDIENUNG');
const _nurPlayer = bool.fromEnvironment('PLAYER');
// Optionales lokales Prüf-Paket; keine privaten Bilddateien im Testbestand.
const _bilderpaket = String.fromEnvironment('BILDERPAKET');

/// Darstellung des Normalmodus: --dart-define=PALETTE=papier|nacht|klassisch (Standard: papier). Spicy geht vor.
const _palette = String.fromEnvironment('PALETTE', defaultValue: 'papier');

/// Qualitätssicherung: Schriftskala und Displaygröße, z. B. --dart-define=TEXTSCALE=1.6 --dart-define=SIZE=360x640.
final _textscale = double.parse(
    const String.fromEnvironment('TEXTSCALE', defaultValue: '1.0'));
const _size = String.fromEnvironment('SIZE', defaultValue: '390x844');

/// Mit --dart-define=STRICT=true schlägt der Test bei jedem Layout-Überlauf fehl.
const _strict = bool.fromEnvironment('STRICT');

String get _suffix =>
    (_textscale != 1.0 ? '_s$_textscale' : '') +
    (_size != '390x844' ? '_$_size' : '');

final _outDir = Directory(_spicy
    ? 'build/screens_spicy${_sprache == 'de' ? '' : '_$_sprache'}$_suffix'
    : (_palette != 'papier'
        ? 'build/screens_$_palette${_sprache == 'de' ? '' : '_$_sprache'}$_suffix'
        : (_sprache == 'de'
            ? 'build/screens$_suffix'
            : 'build/screens_$_sprache$_suffix')));
final _boundary = GlobalKey();

Future<void> _loadFonts() async {
  Future<ByteData> load(String f) async => ByteData.view(
      Uint8List.fromList(await File('$_fontDir/$f').readAsBytes()).buffer);
  final roboto = FontLoader('Roboto')
    ..addFont(load('roboto-regular.ttf'))
    ..addFont(load('roboto-medium.ttf'))
    ..addFont(load('roboto-bold.ttf'))
    ..addFont(load('roboto-black.ttf'))
    ..addFont(load('roboto-italic.ttf'));
  await roboto.load();
  // SVG-Beschriftungen verwenden den Android-Systemnamen sans-serif.
  await (FontLoader('sans-serif')..addFont(load('roboto-regular.ttf'))).load();
  // Emojis (Funken im Paar-Kanal): unter Windows liegt eine Farb-Emoji-Schrift bei.
  const emojiFont = 'C:/Windows/Fonts/seguiemj.ttf';
  if (File(emojiFont).existsSync()) {
    await (FontLoader('Emoji')
          ..addFont(Future.value(ByteData.view(
              Uint8List.fromList(await File(emojiFont).readAsBytes()).buffer))))
        .load();
  }
  await (FontLoader('MaterialIcons')
        ..addFont(load('materialicons-regular.otf')))
      .load();
  // Redaktionelle Serif der App (assets/fonts), damit die Screenshots die echte Typografie zeigen.
  Future<ByteData> serif(String f) async => ByteData.view(
      Uint8List.fromList(await File('assets/fonts/$f').readAsBytes()).buffer);
  await (FontLoader('SourceSerif4')
        ..addFont(serif('SourceSerif4-Regular.ttf'))
        ..addFont(serif('SourceSerif4-SemiBold.ttf'))
        ..addFont(serif('SourceSerif4-Italic.ttf')))
      .load();
}

/// Serif-Stile der App behalten, alle anderen auf Roboto setzen.
TextStyle? _mitRoboto(TextStyle? s) => s == null
    ? null
    : (s.fontFamily == 'SourceSerif4'
        ? s
        : s.copyWith(fontFamily: 'Roboto', fontFamilyFallback: ['Emoji']));

/// Im Test gibt es keine Systemschrift: Stile ohne Schriftfamilie (AppBar, Knöpfe)
/// würden als Kästchen gezeichnet. Darum überall Roboto eintragen.
ThemeData _testTheme() {
  final base = AppTheme.darkTheme;
  ButtonStyle withRoboto(ButtonStyle? style) =>
      (style ?? const ButtonStyle()).copyWith(
        textStyle: WidgetStatePropertyAll(
            (style?.textStyle?.resolve({}) ?? const TextStyle())
                .copyWith(fontFamily: 'Roboto')),
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
      titleTextStyle:
          _mitRoboto(base.appBarTheme.titleTextStyle ?? const TextStyle()),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: withRoboto(base.elevatedButtonTheme.style)),
    filledButtonTheme:
        FilledButtonThemeData(style: withRoboto(base.filledButtonTheme.style)),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: _mitRoboto(base.chipTheme.labelStyle ?? const TextStyle()),
      secondaryLabelStyle:
          _mitRoboto(base.chipTheme.secondaryLabelStyle ?? const TextStyle()),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: withRoboto(base.outlinedButtonTheme.style)),
    textButtonTheme:
        TextButtonThemeData(style: withRoboto(base.textButtonTheme.style)),
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

/// Tippt robust: scrollt das Ziel ins Bild (kleine Displays, große Schrift) und ignoriert Fehltreffer, statt zu hängen.
Future<void> _tippe(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) return;
  try {
    await tester.ensureVisible(f.first);
    await tester.pump();
  } catch (_) {}
  await tester.tap(f.first, warnIfMissed: false);
}

Future<void> _shot(
    WidgetTester tester, String name, List<String> errors) async {
  // Erst asynchron aufgebaute Seiten fertig aufbauen, dann deren Bilder finden.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  // Rasterbilder werden asynchron dekodiert. Vor dem Screenshot wirklich
  // laden, damit ein leerer Zwischenframe nicht als fertige Ansicht durchgeht.
  final ausstehend = <String>{};
  await tester.runAsync(() async {
    var nr = 0;
    for (final element in find.byType(Image).evaluate()) {
      final bild = element.widget as Image;
      final quelle = '$name / ${nr++} / ${bild.image}';
      ausstehend.add(quelle);
      unawaited(precacheImage(bild.image, element,
              onError: (error, stack) => errors
                  .add('Bild konnte nicht geladen werden: $quelle / $error'))
          .whenComplete(() => ausstehend.remove(quelle)));
    }
  });
  // Datei-I/O und Test-Microtasks müssen beide laufen können.
  for (var i = 0; i < 40 && ausstehend.isNotEmpty; i++) {
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 25)));
    await tester.pump(const Duration(milliseconds: 25));
  }
  for (final quelle in ausstehend) {
    errors.add('Bild konnte nicht geladen werden: Zeitlimit / $quelle');
  }
  await tester.pump();
  await tester.runAsync(() async {
    final boundary =
        _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(
        pixelRatio:
            const int.fromEnvironment('SCALE', defaultValue: 1).toDouble());
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    _outDir.createSync(recursive: true);
    File('${_outDir.path}/$name.png')
        .writeAsBytesSync(png!.buffer.asUint8List());
  });
  final exception = tester.takeException();
  if (exception != null) errors.add('$name: $exception');
  errors.add('--- nach $name');
  debugPrint('Screen fertig: $name');
}

/// Globale Dienste verbinden Dart-Futures und native Ereignisse. Beim Aufräumen
/// beide Test-Zeitbereiche abwickeln, statt einen davon wartend anzuhalten.
Future<void> _abwickeln(WidgetTester tester, Future<void> arbeit) async {
  var fertig = false;
  Object? fehler;
  arbeit.then((_) => fertig = true, onError: (Object e, StackTrace s) {
    fehler = e; fertig = true;
  });
  for (var i = 0; i < 150 && !fertig; i++) {
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 2)));
  }
  expect(fertig, isTrue, reason: 'Globale Wiedergabe nicht vollständig aufgeräumt');
  expect(fehler, isNull);
}

void main() {
  Sprache.geraetFuerTest = _sprache;
  testWidgets('Screens rendern', (tester) async {
    final wh = _size.split('x').map(double.parse).toList();
    tester.view.physicalSize = Size(wh[0], wh[1]);
    tester.platformDispatcher.textScaleFactorTestValue = _textscale;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Ohne Audio-Plugin wirft AudioPlayer.dispose asynchron; das übergeht unseren Fehler-Sammler und bricht den
    // Test ab. Die Kanäle antworten deshalb hier einfach leer.
    for (final kanal in [
      'xyz.luan/audioplayers',
      'xyz.luan/audioplayers.global'
    ]) {
      tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(kanal), (_) async => null);
    }

    final errors = <String>[];
    final oldHandler = FlutterError.onError;
    addTearDown(() => FlutterError.onError = oldHandler);
    FlutterError.onError = (d) {
      final text = d.exceptionAsString();
      debugPrint('Render-Prüfung: $text');
      if (text.contains('Bad state')) debugPrint('${d.stack}');
      if (_nurTraumpraxis) oldHandler?.call(d);
      // Bei Überläufen die Fundstelle (Datei:Zeile) des betroffenen Widgets mit aufnehmen.
      final ort =
          RegExp(r'/lib/(\S+?\.dart:\d+)').firstMatch(d.toString())?.group(1);
      errors.add(text.split('\n').first + (ort != null ? '  @ $ort' : ''));
    };

    SharedPreferences.setMockInitialValues(
        {if (_spicy) 'spicy_mode': true, 'design_palette': _palette});
    await tester.runAsync(() async {
      await _loadFonts();
      await StorageService.init();
      await StorageService.saveUserProfile(
        UserProfile(
            name: 'Alex',
            gender: 'other',
            age: 35,
            relationshipStatus: 'relationship',
            primaryGoal: 'performance_anxiety'),
        triggerBackup: false,
      );
      await BildRegister.laden();
      if (_bilderpaket.isNotEmpty) {
        Pakete.basisFuerTest = _bilderpaket;
        addTearDown(() => Pakete.basisFuerTest = null);
        // Dateibilder vor dem ersten Widget im echten Async-Kontext dekodieren.
        // Sonst beginnt FileImage seine Datei-I/O in der angehaltenen Testzone.
        final pfade = BildRegister.alle
            .map(BildRegister.loese)
            .whereType<BildQuelle>()
            .where((q) => q.istDatei && !q.istSvg)
            .map((q) => q.pfad)
            .toSet();
        for (final pfad in pfade) {
          final stream =
              FileImage(File(pfad)).resolve(ImageConfiguration.empty);
          final fertig = Completer<void>();
          final listener = ImageStreamListener((image, synchron) {
            if (!fertig.isCompleted) fertig.complete();
          }, onError: (Object error, StackTrace? stack) {
            if (!fertig.isCompleted) fertig.completeError(error, stack);
          });
          stream.addListener(listener);
          try {
            await fertig.future.timeout(const Duration(seconds: 10));
          } finally {
            stream.removeListener(listener);
          }
        }
      }
      await initializeDateFormatting(_sprache);
      await DataService.loadDatabase();
    });

    if (_nurBedienung) {
      await tester.pumpWidget(_app(SucheScreen(anfang: _sprache == 'en' ? 'breath' : 'Atem')));
      await _shot(tester, '00_suche', errors);
      final kurs = DataService.getCourses().firstWhere((c) => c.lessons.any(
          (l) => l.linkedTool != 'none' && l.reflectionQuestion.isNotEmpty));
      final lektion = kurs.lessons.firstWhere(
          (l) => l.linkedTool != 'none' && l.reflectionQuestion.isNotEmpty);
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: lektion, courseTitle: kurs.title)));
      await _shot(tester, '00_weg_lektion', errors);
      await tester.ensureVisible(find.byType(WegBegleiter));
      await _shot(tester, '00_weg_beginnen', errors);
      await _tippe(tester, find.text(t.wegBeginnen));
      await tester.ensureVisible(find.byType(WegBegleiter));
      await _shot(tester, '00_weg_aktiv', errors);
    }
    if (_nurPlayer) {
      final lektion = DataService.getCourses().first.lessons.first;
      final plan = WiedergabePlan(art: WiedergabeArt.lektion, id: lektion.id,
        sprache: _sprache, spicy: false, titel: lektion.title, abschnitte: [
          WiedergabeAbschnitt(id: lektion.id, art: AbschnittArt.sprache,
            dauer: const Duration(minutes: 5), pfad: 'audio/${lektion.id}.opus',
            text: lektion.content, aufnahmeEnde: true),
        ]);
      final lauf = WiedergabeLauf(ausgabe: (_, code) async => throw StateError('Nur Vorschau'),
        wach: (_) async {}, sichern: (_, backup) async {});
      await tester.runAsync(() => lauf.vormerken(plan, 0, const Duration(seconds: 47)));
      await tester.pumpWidget(_app(WiedergabeScreen(vorschau: lauf)));
      await _shot(tester, '20_wiedergabe', errors);
      final h = GemeinsamHoeren(lauf: lauf, signale: const Stream.empty(),
        sende: (_) async => true, ergaenzen: (p) async => p, pruefsumme: (_) async => 'vorschau',
        gekoppelt: () => true, spicy: () => _spicy);
      h.plan = plan; h.sitzung = 'a' * 32; h.phase = GemeinsamPhase.einladung;
      await tester.pumpWidget(_app(GemeinsamScreen(vorschau: h)));
      await _shot(tester, '21_gemeinsam_einladung', errors);
      h.phase = GemeinsamPhase.countdown; h.angenommen = true;
      h.ichBereit = true; h.partnerBereit = true;
      h.startzeit = DateTime.now().add(const Duration(seconds: 5));
      await tester.pumpWidget(_app(GemeinsamScreen(vorschau: h)));
      await _shot(tester, '22_gemeinsam_countdown', errors);
      await tester.pumpWidget(const SizedBox());
      final id = 'ge_n_${'a' * 32}';
      await tester.runAsync(() => StorageService.saveReflectionAnswer(id,
        GemeinsamAntwort(_sprache == 'en' ? 'A calm moment, without pressure.' : 'Ein ruhiger Moment, ohne Druck.',
          gefuehl: 'ruhig', geteilt: true).speichern()));
      NostrService().partnerReflectionsNotifier.value = {id: GemeinsamAntwort(
        _sprache == 'en' ? 'I enjoyed being close.' : 'Die Nähe hat mir gutgetan.',
        gefuehl: 'nah', geteilt: true).speichern()};
      await tester.pumpWidget(_app(GemeinsamRueckblickScreen(id: id)));
      await _shot(tester, '23_gemeinsam_rueckblick', errors);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() => WiedergabeDienst.instanz.lauf.vormerken(plan, 0, const Duration(seconds: 47)));
      await tester.pumpWidget(_app(const MainNavigationScreen()));
      await _shot(tester, '24_mini_player', errors);
      final global = GemeinsamDienst.instanz.hoeren;
      global.plan = plan; global.sitzung = 'b' * 32; global.phase = GemeinsamPhase.einladung;
      global.notifyListeners();
      await _shot(tester, '25_mini_mit_einladung', errors);
      await tester.pumpWidget(const SizedBox());
      await _abwickeln(tester, global.beenden(senden: false)); global.verwerfen();
      await _abwickeln(tester, h.schliessen());
      await _abwickeln(tester, lauf.schliessen());
      await _abwickeln(tester, WiedergabeDienst.instanz.beenden(entfernen: true));
    }
    if (!_nurTraumpraxis && !_nurBedienung && !_nurPlayer) {
      await tester.pumpWidget(_app(SucheScreen(anfang: _sprache == 'en' ? 'breath' : 'Atem')));
      await _shot(tester, '00_suche', errors);
      await tester.pumpWidget(_app(const OnboardingScreen()));
      await _shot(tester, '00_onboarding', errors);
      // Sanfter Start für eingeladene Personen: drei Bildschirme.
      await _tippe(tester, find.text(t.onboardingEingeladenLink));
      await tester.pump();
      await _shot(tester, '00_onboarding_eingeladen_1', errors);
      await _tippe(tester, find.text(t.onboardingWeiter));
      await tester.pump();
      await _shot(tester, '00_onboarding_eingeladen_2', errors);
      await _tippe(tester, find.text(t.onboardingWeiter));
      await tester.pump();
      await _shot(tester, '00_onboarding_eingeladen_3', errors);
      await tester.pumpWidget(_app(OnboardingScreen(key: UniqueKey())));
      // Frage 2 (Geschlecht, 2×2 ohne Vorauswahl) und das Profil-Bearbeiten mit der Körperkarte.
      await _tippe(tester, find.text(t.onboardingLosGehts));
      await tester.pump();
      await _tippe(tester, find.text(t.onboardingWeiter));
      await tester.pump();
      await _shot(tester, '00_onboarding_geschlecht', errors);
      await tester.pumpWidget(_app(const OnboardingScreen(isEditing: true)));
      await _shot(tester, '00_profil_bearbeiten', errors);

      await tester.pumpWidget(_app(const MainNavigationScreen()));
      await _shot(tester, '01_kurse', errors);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
      await _shot(tester, '01_kurse_unten', errors);

      await _tippe(tester, find.text(t.navLernen).last);
      await _shot(tester, '01_lernen', errors);
      await _tippe(tester, find.text(t.navUeben).last);
      await _shot(tester, '02_training', errors);
      await _tippe(tester, find.text(t.uebenGedanken));
      await _shot(tester, '03_reframing', errors);
      await _tippe(tester, find.text(t.uebenCoach));
      await _shot(tester, '05_kicoach', errors);
      await _tippe(tester, find.text(t.navWir).last);
      await _shot(tester, '04_paarkanal', errors);
      // Offene Einladung, auf die sich jemand gemeldet hat.
      await tester.runAsync(() => NostrService().startInvite('Anna'));
      NostrService().joinRequestNotifier.value = 'b' * 64;
      await tester.pumpWidget(_app(const MainNavigationScreen()));
      await _tippe(tester, find.text(t.navWir).last);
      await _shot(tester, '04_paarkanal_anfrage', errors);
      await tester.runAsync(() => NostrService().cancelInvite());

      // Paar-Kanal im verbundenen Zustand, mit Beispielnachrichten und einem Match.
      await tester.runAsync(() async {
        final prefs = await SharedPreferences.getInstance();
        final now = DateTime(2026, 10, 23, 20, 15);
        await prefs.setString('velvet_partner_pubkey', 'a' * 64);
        await prefs.setString('velvet_partner_name', 'Anna');
        // Erfundene Beispielnachrichten eines Beispielpaars (Alex und Anna); keine echten Chats.
        await prefs.setString(
            'velvet_couple_messages_cache',
            jsonEncode([
              {
                'id': '1',
                'isMe': false,
                'type': 'ping',
                'emoji': '🔥',
                'text': 'Lust auf dich',
                'createdAt': '$now'
              },
              {
                'id': '2',
                'isMe': true,
                'type': 'chat',
                'text':
                    'Du machst mich verrückt. Ich weiß schon, wo ich dich später anfassen werde 😈',
                'createdAt': '$now'
              },
              {
                'id': '3',
                'isMe': false,
                'type': 'chat',
                'text': 'Dann zieh dir vorher besser nichts Unnötiges an 😘',
                'createdAt': '$now'
              },
            ]));
        await prefs.setString(
            'velvet_my_fantasy_votes', jsonEncode({'match_blindfold': 'yes'}));
        await prefs.setString('velvet_partner_fantasy_votes',
            jsonEncode({'match_blindfold': 'yes'}));
        await NostrService().reloadKeysFromPrefs();
      });
      NostrService().partnerReadUntil.value =
          DateTime(2026, 10, 23, 21).millisecondsSinceEpoch ~/ 1000;
      await tester.pumpWidget(_app(const MainNavigationScreen()));
      await _tippe(tester, find.text(t.navWir).last);
      await _shot(tester, '04_paarkanal_verbunden', errors);
      await _tippe(tester, find.text(t.couplesChannelWishes));
      await _shot(tester, '04_paarkanal_wuensche', errors);
      // Eure erste Woche: Schritt 2 gemacht, Schritt 3 ausgeblendet, dann Karte weg und wieder zeigen.
      await tester.runAsync(() async {
        await ErsteWocheDienst.markieren(1, ErsteWocheStand.getan, backup: false);
        await ErsteWocheDienst.markieren(2, ErsteWocheStand.uebersprungen, backup: false);
      });
      await tester.pump();
      await _shot(tester, '04_erste_woche_verbunden', errors);
      await tester.runAsync(() => ErsteWocheDienst.ausgeblendet(true, backup: false));
      await tester.pump();
      await _shot(tester, '04_erste_woche_ausgeblendet', errors);
      await tester.runAsync(() => ErsteWocheDienst.ausgeblendet(false, backup: false));
      await tester.pump();
      for (final nr in [1, 5, 7]) {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(_app(ErsteWocheScreen(nr: nr)));
        await _shot(tester, '04_erste_woche_schritt$nr', errors);
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const PaarAbendScreen()));
      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
      await _shot(tester, '09_paar_abend', errors);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
      await _shot(tester, '09_paar_abend_unten', errors);
      await _tippe(tester, find.text(t.paarAbendBeginTheEvening));
      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
      await _shot(tester, '09_paar_abend_laeuft', errors);
      await _tippe(tester, find.byIcon(Icons.skip_next_rounded));
      await _tippe(tester, find.byIcon(Icons.skip_next_rounded));
      await _tippe(tester, find.byIcon(Icons.skip_next_rounded));
      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 1500)));
      await _shot(tester, '09_paar_abend_runde', errors);
      await tester.pumpWidget(const SizedBox());
      await _abwickeln(tester, WiedergabeDienst.instanz.beenden(entfernen: true));

      await tester.pumpWidget(_app(const Scaffold(body: PairingModal())));
      await _shot(tester, '04_paarkanal_koppeln', errors);

      await tester.pumpWidget(_app(const YesNoMaybeScreen()));
      await _shot(tester, '07_ja_nein_vielleicht', errors);
      await _tippe(tester, find.byIcon(Icons.info_outline_rounded).first);
      await _shot(tester, '07_mehr_erfahren', errors);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const YesNoMaybeScreen()));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -2600));
      await _shot(tester, '07_ja_nein_vielleicht_unten', errors);
      await _tippe(
          tester, find.byIcon(Icons.info_outline_rounded).hitTestable().first);
      await _shot(tester, '07_mehr_erfahren_grafik', errors);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const LustProfileScreen()));
      await _shot(tester, '08_lust_profil', errors);

      final self = DataService.getCourses()
          .firstWhere((c) => c.id == 'course_self_exploration');
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: self.lessons[1], courseTitle: self.title)));
      await _shot(tester, '08_selbst_vulva', errors);

      // Gemeinsam lernen: Anna hat ihre Reflexion geteilt, die eigene Antwort steht noch aus.
      final neuro = DataService.getCourses().first;
      NostrService().partnerReflectionsNotifier.value = {
        neuro.lessons.first.id:
            'Mir hilft es, wenn wir abends zuerst zehn Minuten nur reden.'
      };
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: neuro.lessons.first, courseTitle: neuro.title)));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
      await _shot(tester, '10_gemeinsam_reflexion', errors);
      await tester.pumpWidget(const SizedBox());

      // Persönliche Ansprache: Anna ist als Frau angegeben, die Lektion nennt sie beim Namen.
      await tester.runAsync(() =>
          NostrService().setPartnerProfile(name: 'Anna', gender: 'female'));
      final massage = DataService.getCourses()
          .firstWhere((c) => c.id == 'course_sacred_massage');
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: massage.lessons[1], courseTitle: massage.title)));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
      await _shot(tester, '11_personalisiert', errors);
      await tester.pumpWidget(const SizedBox());

      final course = DataService.getCourses()
          .firstWhere((c) => c.id == 'course_sacred_massage');
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: course.lessons[1], courseTitle: course.title)));
      await _shot(tester, '06_lektion', errors);
      await tester.pumpWidget(const SizedBox());

      // Pilot: Kurs 1, erste Lektion (Kopf, Einleitung, Text).
      final kurs1 = DataService.getCourses().first;
      await tester.pumpWidget(_app(LessonDetailScreen(
          lesson: kurs1.lessons.first, courseTitle: kurs1.title)));
      await _shot(tester, '06_lektion_kurs1', errors);
      await tester.pumpWidget(const SizedBox());

      final news = await tester.runAsync(WhatsNew.load);
      await tester.pumpWidget(
          _app(WhatsNewScreen(entries: news!.reversed.take(1).toList())));
      await _shot(tester, '12_was_ist_neu', errors);
      await tester.pumpWidget(const SizedBox());

      await tester.pumpWidget(_app(const SelbstReiseScreen()));
      for (var i = 0;
          i < 10 && find.text(t.paarAbendIntimate).evaluate().isEmpty;
          i++) {
        await tester
            .runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
        await tester.pump();
      }
      await _tippe(tester, find.text(t.paarAbendIntimate));
      await _shot(tester, '13_selbst_reise', errors);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
      await _shot(tester, '13_selbst_reise_unten', errors);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const TraumTagebuchScreen()));
      await _shot(tester, '14_traumtagebuch', errors);
      await tester.pumpWidget(const SizedBox());
    }
    if (_spicy && !_nurBedienung && !_nurPlayer) {
      // Ausschließlich erfundene Vorschauwerte, keine privaten Nutzereinträge.
      final praxisPrefs = await SharedPreferences.getInstance();
      await praxisPrefs.setString(
          'traumpraxis',
          jsonEncode(TraumpraxisDaten([
            PraxisEintrag(
                id: 'vorschau-1',
                art: 'zeichen',
                geaendert: DateTime(2026, 11, 1),
                text: _sprache == 'de'
                    ? 'Eine zweite Tür im vertrauten Zimmer'
                    : 'A second doorway in a familiar room'),
            PraxisEintrag(
                id: 'vorschau-2',
                art: 'zeichen',
                geaendert: DateTime(2026, 10, 31),
                text: _sprache == 'de'
                    ? 'Licht, das von unten scheint'
                    : 'Light shining from below'),
            PraxisEintrag(
                id: '2026-11-01',
                art: 'tag',
                geaendert: DateTime(2026, 11, 1),
                schlaf: 3,
                lust: 2,
                sinnlich: true,
                klar: true,
                hoehepunkt: true,
                text: _sprache == 'de'
                    ? 'Die Wärme aus dem Traum war morgens noch spürbar. Tagsüber habe ich mir Zeit für mich genommen.'
                    : 'The warmth of the dream lingered into the morning. During the day I made some time for myself.'),
            PraxisEintrag(
                id: '2026-10-31',
                art: 'tag',
                geaendert: DateTime(2026, 10, 31),
                schlaf: 4,
                lust: 1,
                sinnlich: false,
                klar: false,
                hoehepunkt: false,
                text: _sprache == 'de'
                    ? 'Gut geschlafen. Heute war vor allem Ruhe angenehm.'
                    : 'Slept well. Today, rest felt especially welcome.'),
          ]).toJson()));
      await tester.pumpWidget(_app(const TraumpraxisScreen()));
      await _shot(tester, '15_traumpraxis', errors);
      await tester.scrollUntilVisible(find.text(t.praxisZeichenTitel), 200);
      // Die Auswahl selbst prüft der Widgettest. Hier den sichtbaren
      // Seitenabschnitt rendern, ohne von Menü-Animationen abhängig zu sein.
      await _shot(tester, '15_traumpraxis_abend', errors);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
          _app(const PraxisVerwaltung(ansicht: PraxisAnsicht.zeichen)));
      await _shot(tester, '16_traumzeichen', errors);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const PraxisVerwaltung(
          ansicht: PraxisAnsicht.beobachtung, tag: '2026-11-01')));
      await _shot(tester, '17_tagesbeobachtung', errors);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await _shot(tester, '17_tagesbeobachtung_unten', errors);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
          _app(const PraxisVerwaltung(ansicht: PraxisAnsicht.rueckblick)));
      await _shot(tester, '18_traumpraxis_rueckblick', errors);
      await tester.pumpWidget(const SizedBox());
    }
    if (!_nurTraumpraxis && !_nurBedienung && !_nurPlayer) {
      await tester.pumpWidget(_app(const LustImTraumScreen()));
      for (var i = 0;
          i < 10 && find.text(t.lustFolgen).evaluate().isEmpty;
          i++) {
        await tester
            .runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
        await tester.pump();
      }
      await _shot(tester, '15_lust_im_traum', errors);
    }

    await tester.pumpWidget(const SizedBox());
    NostrService().dispose();
    await tester.pump(const Duration(seconds: 9));
    FlutterError.onError = oldHandler;

    final protokoll = errors
        .where((e) => !e.startsWith('RenderBox was not laid out'))
        .toList();
    // ignore: avoid_print
    print('LAYOUT-PROTOKOLL:\n${protokoll.join('\n')}');
    if (_nurTraumpraxis) {
      expect(protokoll.where((e) => !e.startsWith('--- nach ')), isEmpty,
          reason: 'Neue Traumpraxis muss ohne Renderfehler laufen');
    }
    if (_strict) {
      expect(protokoll.where((e) => e.contains('overflowed')), isEmpty,
          reason: 'Layout-Überläufe, siehe LAYOUT-PROTOKOLL');
      expect(
          protokoll
              .where((e) => e.startsWith('Bild konnte nicht geladen werden:')),
          isEmpty,
          reason: 'Rasterbilder vor der Aufnahme nicht vollständig geladen');
    }
  });
}
