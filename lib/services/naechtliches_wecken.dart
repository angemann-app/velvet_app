import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/t.dart';
import 'testmodus.dart';
import '../models/paar_abend.dart';
import '../models/traum_reise.dart';
import 'storage_service.dart';

/// Dienst für das optionale nächtliche Wecken (docs/konzepte/traum-reise.md, „Wecken und Wiedereinschlafen“).
///
/// Sicherheitsregeln:
/// - Höchstens zweimal innerhalb von sieben Tagen (Schlaf geht vor).
/// - Wecken über den System-Wecker (Intent an die Uhr-App) mit neutralem Namen „Kurzer Moment“.
/// - Kein Ton-Signal im REM-Schlaf.
class NaechtlichesWecken {
  static const int maxProWoche = 2;
  static const Duration wochenFenster = Duration(days: 7);
  static const Duration standardAbstand = Duration(hours: 5);

  /// Zählt, wie oft in den letzten sieben Tagen vor [jetzt] ein nächtliches Wecken genutzt wurde.
  static int anzahlInLetzterWoche(List<DateTime> verlauf, {DateTime? jetzt}) {
    final stichtag = jetzt ?? DateTime.now();
    final grenze = stichtag.subtract(wochenFenster);
    final obergrenze = stichtag.add(const Duration(days: 1));
    return verlauf.where((z) => !z.isBefore(grenze) && !z.isAfter(obergrenze)).length;
  }

  /// Prüft die Wochenregel: Höchstens [maxProWoche] (2) Mal innerhalb von sieben Tagen.
  static bool darfHeuteWecken(List<DateTime> verlauf, {DateTime? jetzt}) {
    if (Testmodus.an) return true;
    return anzahlInLetzterWoche(verlauf, jetzt: jetzt) < maxProWoche;
  }

  /// Schlägt eine Weckzeit etwa fünf Stunden nach [start] vor.
  static DateTime schlageWeckzeitVor({DateTime? start}) {
    final basis = (start ?? DateTime.now()).add(standardAbstand);
    return DateTime(basis.year, basis.month, basis.day, basis.hour, basis.minute);
  }

  /// Berechnet das nächste Datum für die gewählte [uhrzeit] ab [jetzt].
  static DateTime berechneZielZeit(TimeOfDay uhrzeit, {DateTime? jetzt}) {
    final nun = jetzt ?? DateTime.now();
    var ziel = DateTime(nun.year, nun.month, nun.day, uhrzeit.hour, uhrzeit.minute);
    if (!ziel.isAfter(nun)) {
      ziel = ziel.add(const Duration(days: 1));
    }
    return ziel;
  }

  /// Formatiert eine Uhrzeit als HH:mm.
  static String formatUhrzeit(DateTime zeit) =>
      '${zeit.hour.toString().padLeft(2, '0')}:${zeit.minute.toString().padLeft(2, '0')}';

  /// Speichert das nächtliche Wecken für heute Nacht und übergibt den Termin an die System-Uhr-App.
  static Future<bool> planen(
    DateTime zielZeit, {
    String? titel,
    DateTime? jetzt,
    Future<void> Function(DateTime, String)? intentLauncher,
  }) async {
    final verlauf = StorageService.getNaechtlichesWecken();
    if (!darfHeuteWecken(verlauf, jetzt: jetzt)) {
      return false;
    }
    await StorageService.saveNaechtlichesWecken(zielZeit);
    await stelleSystemWecker(
      zielZeit,
      titel: titel ?? t.weckenWeckerName,
      intentLauncher: intentLauncher,
    );
    return true;
  }

  /// Öffnet den System-Wecker über `android.intent.action.SET_ALARM` mit dem neutralen Namen „Kurzer Moment“.
  static Future<bool> stelleSystemWecker(
    DateTime zielZeit, {
    String? titel,
    Future<void> Function(DateTime, String)? intentLauncher,
  }) async {
    final name = titel ?? t.weckenWeckerName;
    if (intentLauncher != null) {
      await intentLauncher(zielZeit, name);
      return true;
    }
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SET_ALARM',
        arguments: <String, dynamic>{
          'android.intent.extra.alarm.HOUR': zielZeit.hour,
          'android.intent.extra.alarm.MINUTES': zielZeit.minute,
          'android.intent.extra.alarm.MESSAGE': name,
          'android.intent.extra.alarm.SKIP_UI': false,
        },
      );
      await intent.launch();
      return true;
    } catch (e) {
      debugPrint('System-Wecker konnte nicht geöffnet werden: $e');
      return false;
    }
  }

  /// Ist für diese Nacht ein Wecken eingerichtet, das noch nicht abgeschlossen wurde?
  static bool istWeckenAktiv({DateTime? jetzt}) {
    return StorageService.aktivesWecken(jetzt: jetzt) != null;
  }

  /// Markiert die Wiedereinschlaf-Begleitung dieser Nacht als abgeschlossen.
  static Future<void> begleitungAbschliessen() async {
    await StorageService.clearAktivesWecken();
  }

  /// Baut den kurzen, leisen Ablauf zum Wiedereinschlafen (ca. 5–8 Min. Sprache, dann 10 Min. Klangteppich).
  /// Ohne Ankommen-Phase, direkt sanftes Notieren, Sinken und Absicht.
  static List<PaarSchritt> planeBegleitung(
    TraumDaten traum, {
    required String stimme,
    String? abend,
  }) {
    final nachId = {for (final b in traum.bausteine) b.id: b};
    final schritte = <PaarSchritt>[];

    void bausteinMitPause(String id, Duration pause) {
      final b = nachId[id];
      if (b == null) return;
      final d = traum.dauerVon(b, stimme);
      schritte.add(PaarSchritt.ansage(b.alsPaar, d, 0));
      schritte.add(PaarSchritt.stille(pause, 0));
    }

    // 1. Kurz ankommen in der Ruhe nach dem Notieren
    bausteinMitPause('wecken_notieren', const Duration(seconds: 35));

    // 2. Erstes wieder Sinken
    bausteinMitPause('wecken_sinken_1', const Duration(seconds: 45));

    // 3. Falls am Abend ein Traumbild gewählt war, dessen Absicht kurz aufgreifen
    if (abend != null && abend.startsWith('traum:')) {
      final bild = abend.substring('traum:'.length);
      if (bild.isNotEmpty && nachId.containsKey('${bild}_f')) {
        bausteinMitPause('${bild}_f', const Duration(seconds: 30));
      }
    }

    // 4. Wecken-Absicht in Ich-Form
    bausteinMitPause('wecken_absicht', const Duration(seconds: 45));

    // 5. Übergang an der Schwelle zum Traum
    if (nachId.containsKey('wach_1')) {
      bausteinMitPause('wach_1', const Duration(seconds: 50));
    }

    // 6. Tiefer gleiten in die zweite Nachthälfte
    bausteinMitPause('wecken_sinken_2', const Duration(seconds: 60));

    // 7. Noch einmal die kurze Absicht im Nachklang
    if (nachId.containsKey('wach_absicht_1')) {
      bausteinMitPause('wach_absicht_1', const Duration(seconds: 60));
    }

    // 8. Zehn Minuten Schlussstille (Klangteppich blendet darüber sanft aus)
    schritte.add(PaarSchritt.stille(const Duration(minutes: 10), 0));
    return schritte;
  }
}
