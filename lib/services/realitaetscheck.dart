import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/t.dart';
import '../main.dart';
import '../models/traum_eintrag.dart';
import '../screens/self_exploration/realitaetscheck_screen.dart';
import 'message_notifier.dart';
import 'storage_service.dart';

/// Einstellungen für die täglichen Realitätschecks (docs/konzepte/traum-reise.md, „Realitätschecks“).
class RealitaetscheckEinstellungen {
  final bool aktiv;
  final int vonStunde;
  final int bisStunde;
  final int anzahlProTag;

  const RealitaetscheckEinstellungen({
    this.aktiv = false,
    this.vonStunde = 9,
    this.bisStunde = 21,
    this.anzahlProTag = 3,
  });

  RealitaetscheckEinstellungen mit({
    bool? aktiv,
    int? vonStunde,
    int? bisStunde,
    int? anzahlProTag,
  }) =>
      RealitaetscheckEinstellungen(
        aktiv: aktiv ?? this.aktiv,
        vonStunde: vonStunde ?? this.vonStunde,
        bisStunde: bisStunde ?? this.bisStunde,
        anzahlProTag: anzahlProTag ?? this.anzahlProTag,
      );

  factory RealitaetscheckEinstellungen.fromJson(Map<String, dynamic> json) => RealitaetscheckEinstellungen(
        aktiv: json['aktiv'] as bool? ?? false,
        vonStunde: (json['vonStunde'] as num?)?.toInt() ?? 9,
        bisStunde: (json['bisStunde'] as num?)?.toInt() ?? 21,
        anzahlProTag: (json['anzahlProTag'] as num?)?.toInt() ?? 3,
      );

  Map<String, dynamic> toJson() => {
        'aktiv': aktiv,
        'vonStunde': vonStunde,
        'bisStunde': bisStunde,
        'anzahlProTag': anzahlProTag,
      };
}

/// Dienst für die Planung und Ausführung von Realitätscheck-Erinnerungen.
class RealitaetscheckService {
  static const int basisNotificationId = 8000;
  static const int maxNotifications = 20;

  static bool _timezonesInitialisiert = false;

  /// Füllwörter und Hilfsverben, die bei der Motivsuche ignoriert werden.
  static const Set<String> stopWoerter = {
    'aber', 'alle', 'allem', 'allen', 'aller', 'alles', 'als', 'also', 'am', 'an',
    'ander', 'andere', 'anderem', 'anderen', 'anderer', 'anderes', 'anderm', 'andern',
    'auch', 'auf', 'aus', 'bei', 'beide', 'beiden', 'beides', 'beim', 'bereits',
    'bin', 'bis', 'bist', 'da', 'dabei', 'dadurch', 'daher', 'damit', 'dann', 'daran',
    'darauf', 'daraus', 'darin', 'darüber', 'darum', 'darunter', 'das', 'dass', 'daß',
    'dein', 'deine', 'deinem', 'deinen', 'deiner', 'deines', 'dem', 'demselben',
    'den', 'denn', 'denselben', 'der', 'dereinst', 'derselbe', 'derselben', 'des',
    'desselben', 'dessen', 'dich', 'die', 'dies', 'diese', 'dieselbe', 'dieselben',
    'diesem', 'diesen', 'dieser', 'dieses', 'dir', 'doch', 'dort', 'du', 'durch',
    'ein', 'eine', 'einem', 'einen', 'einer', 'eines', 'einige', 'einigen', 'einiges',
    'einmal', 'er', 'erst', 'es', 'etwas', 'euch', 'euer', 'eure', 'eurem', 'euren',
    'eurer', 'eures', 'für', 'gab', 'ganz', 'gar', 'geben', 'gehabt', 'gemacht',
    'gesehen', 'gewesen', 'gibt', 'ging', 'hab', 'habe', 'haben', 'hat', 'hatte',
    'hatten', 'hier', 'hin', 'hinter', 'ich', 'ihm', 'ihn', 'ihr', 'ihre', 'ihrem',
    'ihren', 'ihrer', 'ihres', 'im', 'immer', 'in', 'indem', 'ins', 'ist', 'ja',
    'jede', 'jedem', 'jeden', 'jeder', 'jedes', 'jedoch', 'jetzt', 'kann', 'kannst',
    'kein', 'keine', 'keinem', 'keinen', 'keiner', 'keines', 'konnte', 'können',
    'könnte', 'lassen', 'liegt', 'machen', 'man', 'manche', 'manchem', 'manchen',
    'mancher', 'manches', 'mein', 'meine', 'meinem', 'meinen', 'meiner', 'meines',
    'mich', 'mir', 'mit', 'muss', 'musste', 'nach', 'nachdem', 'nein', 'nicht',
    'nichts', 'noch', 'nun', 'nur', 'oder', 'ohne', 'sehr', 'sein', 'seine',
    'seinem', 'seinen', 'seiner', 'seines', 'selbst', 'sich', 'sie', 'sind', 'so',
    'solche', 'solchem', 'solchen', 'solcher', 'solches', 'soll', 'sollte', 'somit',
    'sondern', 'sonst', 'über', 'um', 'und', 'uns', 'unser', 'unsere', 'unserem',
    'unseren', 'unserer', 'unseres', 'unter', 'viel', 'viele', 'vom', 'von', 'vor',
    'war', 'waren', 'warst', 'was', 'weder', 'weil', 'weiter', 'weitere', 'welche',
    'welchem', 'welchen', 'welcher', 'welches', 'wenn', 'wer', 'werde', 'werden',
    'wie', 'wieder', 'will', 'wir', 'wird', 'wirst', 'wo', 'wollen', 'wollte',
    'wollten', 'worden', 'wurde', 'wurden', 'zu', 'zum', 'zur', 'zwar', 'zwischen',
    'traum', 'träumen', 'geträumt', 'traumes', 'nacht', 'morgen', 'aufgewacht', 'erinnert'
  };

  /// Initialisiert Zeitzonen und plant aktive Erinnerungen neu.
  static Future<void> init() async {
    if (!_timezonesInitialisiert) {
      try {
        tz.initializeTimeZones();
        _timezonesInitialisiert = true;
      } catch (_) {}
    }
    final einstellungen = StorageService.getRealitaetschecks();
    if (einstellungen.aktiv) {
      await planen(einstellungen);
    }
  }

  /// Berechnet die zufälligen Zeitpunkte innerhalb des Zeitfensters für [tageVoraus] Tage.
  /// Reine Funktion, deterministisch testbar über [jetzt] und [zufall].
  static List<DateTime> planeZeiten(
    RealitaetscheckEinstellungen einstellungen, {
    DateTime? jetzt,
    Random? zufall,
    int tageVoraus = 3,
  }) {
    if (!einstellungen.aktiv) return const [];
    final stichtag = jetzt ?? DateTime.now();
    final rand = zufall ?? Random();
    final zeiten = <DateTime>[];

    final von = einstellungen.vonStunde.clamp(0, 23);
    final bis = einstellungen.bisStunde.clamp(von + 1, 24);
    final minutenFenster = (bis - von) * 60;
    if (minutenFenster <= 0) return const [];

    final anzahl = einstellungen.anzahlProTag.clamp(2, 4);

    for (var d = 0; d < tageVoraus; d++) {
      final tagesDatum = stichtag.add(Duration(days: d));
      final basisZeit = DateTime(tagesDatum.year, tagesDatum.month, tagesDatum.day, von);

      final tagesMinuten = <int>{};
      var versuche = 0;
      while (tagesMinuten.length < anzahl && versuche < 100) {
        versuche++;
        final min = rand.nextInt(minutenFenster);
        final nah = tagesMinuten.any((m) => (m - min).abs() < 30);
        if (!nah || versuche > 50) {
          tagesMinuten.add(min);
        }
      }

      final sortierteMinuten = tagesMinuten.toList()..sort();
      for (final min in sortierteMinuten) {
        final geplanteZeit = basisZeit.add(Duration(minutes: min));
        if (geplanteZeit.isAfter(stichtag)) {
          zeiten.add(geplanteZeit);
        }
      }
    }

    return zeiten;
  }

  /// Sucht wiederkehrende Wörter (mindestens [mindestHaeufigkeit] Einträge in den letzten [tage] Tagen).
  static List<String> findeMotive(
    List<TraumEintrag> eintraege, {
    DateTime? jetzt,
    int mindestHaeufigkeit = 3,
    int tage = 30,
  }) {
    final stichtag = jetzt ?? DateTime.now();
    final cutoff = stichtag.subtract(Duration(days: tage));
    final relevant = eintraege.where((e) => !e.zeit.isBefore(cutoff) && !e.zeit.isAfter(stichtag));

    final Map<String, int> zaehlung = {};
    final splitter = RegExp(r'[\s.,;:!?()[\]{}\-\u2014\u2013"„“/]+');

    for (final e in relevant) {
      if (e.text.trim().isEmpty) continue;
      final woerter = e.text.split(splitter);
      final gesehenInEintrag = <String>{};
      for (var w in woerter) {
        w = w.trim().toLowerCase();
        if (w.length < 4) continue;
        if (stopWoerter.contains(w)) continue;
        if (gesehenInEintrag.add(w)) {
          zaehlung[w] = (zaehlung[w] ?? 0) + 1;
        }
      }
    }

    final ergebnis = zaehlung.entries
        .where((entry) => entry.value >= mindestHaeufigkeit)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ergebnis.map((e) => e.key[0].toUpperCase() + e.key.substring(1)).toList();
  }

  /// Plant die Benachrichtigungen mit flutter_local_notifications.
  static Future<void> planen(RealitaetscheckEinstellungen einstellungen, {Random? zufall, DateTime? jetzt}) async {
    await abbrechen();
    if (!einstellungen.aktiv || kIsWeb) return;

    if (!_timezonesInitialisiert) {
      try {
        tz.initializeTimeZones();
        _timezonesInitialisiert = true;
      } catch (_) {}
    }

    final zeiten = planeZeiten(einstellungen, jetzt: jetzt, zufall: zufall);
    final plugin = MessageNotifier.plugin;

    int id = basisNotificationId;
    for (final zeit in zeiten) {
      if (id >= basisNotificationId + maxNotifications) break;
      try {
        final tzZeit = tz.TZDateTime.from(zeit, tz.local);
        await plugin.zonedSchedule(
          id: id,
          title: t.realitaetMitteilungTitel,
          body: t.realitaetMitteilungText,
          scheduledDate: tzZeit,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'realitaetscheck',
              t.realitaetKanalName,
              channelDescription: t.realitaetKanalBeschreibung,
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              visibility: NotificationVisibility.secret,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: 'realitaetscheck',
        );
      } catch (e) {
        debugPrint('Fehler beim Planen von Realitaetscheck $id: $e');
      }
      id++;
    }
  }

  /// Bricht alle geplanten Erinnerungen ab.
  static Future<void> abbrechen() async {
    if (kIsWeb) return;
    final plugin = MessageNotifier.plugin;
    for (var id = basisNotificationId; id < basisNotificationId + maxNotifications; id++) {
      try {
        await plugin.cancel(id: id);
      } catch (_) {}
    }
  }

  /// Öffnet den Realitätscheck-Bildschirm bei Tipp auf eine Benachrichtigung.
  static void oeffneScreen() {
    final nav = VelvetPulseApp.navigatorKey.currentState;
    nav?.push(MaterialPageRoute(builder: (_) => const RealitaetscheckScreen()));
  }
}
