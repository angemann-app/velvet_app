import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/wiedergabe_plan.dart';
import 'data_service.dart';
import 'sprache.dart';
import 'wiedergabe_dienst.dart';
import 'wiedergabe_lauf.dart';

/// Kompatible Lektionsschnittstelle; auch Lektionen gehören zur einen globalen
/// Sitzung. Keine zweite native Wiedergabe neben den geführten Angeboten.
class AudioService {
  static final _instanz = AudioService._();
  factory AudioService() => _instanz;
  AudioService._() {
    _dienst.lauf.addListener(_aktualisieren);
  }
  final _dienst = WiedergabeDienst.instanz;
  final stateNotifier = ValueNotifier<PlayerState>(PlayerState.stopped);
  final currentLessonIdNotifier = ValueNotifier<String?>(null);
  final positionNotifier = ValueNotifier<Duration>(Duration.zero);
  final durationNotifier = ValueNotifier<Duration>(Duration.zero);
  final isUsingTtsFallbackNotifier = ValueNotifier<bool>(false);

  void _aktualisieren() {
    final l = _dienst.lauf;
    final istLektion = l.plan?.art == WiedergabeArt.lektion;
    currentLessonIdNotifier.value = istLektion ? l.plan!.id : null;
    stateNotifier.value = !istLektion
        ? PlayerState.stopped
        : switch (l.zustand) {
            WiedergabeZustand.spielt => PlayerState.playing,
            WiedergabeZustand.pause => PlayerState.paused,
            WiedergabeZustand.fertig => PlayerState.completed,
            _ => PlayerState.stopped,
          };
    positionNotifier.value = istLektion ? l.aufnahmePosition : Duration.zero;
    durationNotifier.value = istLektion
        ? (l.nativeLaenge > Duration.zero ? l.nativeLaenge : l.dauer)
        : Duration.zero;
    isUsingTtsFallbackNotifier.value = istLektion && l.geraetestimme;
  }

  bool isCurrentLesson(String id) => currentLessonIdNotifier.value == id;
  bool isPlaying(String id) =>
      isCurrentLesson(id) && stateNotifier.value == PlayerState.playing;
  bool isPaused(String id) =>
      isCurrentLesson(id) && stateNotifier.value == PlayerState.paused;

  Future<void> playLesson(String id, {String? fallbackText}) async {
    await _dienst.initialisieren();
    if (isPlaying(id)) return;
    if (isPaused(id)) return _dienst.weiter();
    final db = await DataService.loadDatabase();
    for (final kurs in db.courses) {
      for (final lektion in kurs.lessons) {
        if (lektion.id != id) continue;
        await _dienst.starten(WiedergabePlan(
            art: WiedergabeArt.lektion,
            id: id,
            sprache: Sprache.code,
            spicy: kurs.spicy || lektion.spicy,
            titel: lektion.title,
            abschnitte: [
              WiedergabeAbschnitt(
                  id: id,
                  art: AbschnittArt.sprache,
                  dauer: Duration(
                      minutes:
                          lektion.durationMin > 0 ? lektion.durationMin : 3),
                  pfad: 'audio/$id.opus',
                  text: fallbackText ?? lektion.content,
                  aufnahmeEnde: true)
            ]));
        return;
      }
    }
  }

  Future<void> pause() => _dienst.pause();
  Future<void> resume() => _dienst.weiter();
  Future<void> stop() => _dienst.beenden(entfernen: true);
  Future<void> seek(Duration position) => _dienst.lauf.suchen(position);
  Future<void> seekRelative(int seconds) =>
      seek(positionNotifier.value + Duration(seconds: seconds));
  // Der globale Dienst bleibt beim Verlassen einer Lektionsseite bestehen.
  void dispose() {}
}
