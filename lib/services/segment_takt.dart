import 'dart:async';

/// Wartet auf das Ende eines Abschnitts einer Reise (Szene der Audioreihe) und zählt dabei den Fortschritt.
///
/// Das Ende kommt von der Aufnahme selbst ([ende], z. B. `AudioPlayer.onPlayerComplete`), nicht von einem Zähler:
/// Bei ausgeschaltetem Bildschirm kann Android die App bremsen, ein gezählter Takt bleibt dann stehen, und die
/// nächste Szene begänne zu spät oder gar nicht. Der Takt zählt deshalb die **tatsächlich vergangene** Zeit und dient
/// nur der Anzeige und als Sicherung. Ohne Aufnahme ([ende] ist null, die Geräte-Stimme liest vor) bestimmt allein
/// [dauer], wann es weitergeht.
///
/// Liefert `true`, wenn der Abschnitt zu Ende ist, `false`, wenn [abgebrochen] wahr wurde.
Future<bool> segmentAbwarten({
  required Duration dauer,
  Stream<void>? ende,
  required bool Function() pausiert,
  required bool Function() abgebrochen,
  required void Function(Duration vergangen) fortschritt,
  Duration takt = const Duration(milliseconds: 250),
  Duration reserve = const Duration(seconds: 8),
  DateTime Function() jetzt = DateTime.now,
}) async {
  var aufnahmeFertig = false;
  final weckt = Completer<void>();
  final abo = ende?.listen((_) {
    aufnahmeFertig = true;
    if (!weckt.isCompleted) weckt.complete();
  });
  try {
    var letzte = jetzt();
    var summe = Duration.zero;
    // Ohne Aufnahme endet der Abschnitt nach [dauer], mit Aufnahme mit ihr, spätestens [reserve] danach.
    final grenze = ende == null ? dauer : dauer + reserve;
    while (true) {
      // Ist das Ende schon da (und wir nur in der Pause), nicht mehr auf das Ereignis warten: sonst dreht die Schleife leer.
      await Future.any([Future.delayed(takt), if (!aufnahmeFertig) weckt.future]);
      if (abgebrochen()) return false;
      final t = jetzt();
      final schritt = t.difference(letzte);
      letzte = t;
      if (pausiert()) continue;
      summe += schritt;
      fortschritt(schritt);
      if (aufnahmeFertig || summe >= grenze) return true;
    }
  } finally {
    await abo?.cancel();
  }
}
