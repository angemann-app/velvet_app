import '../l10n/t.dart';

/// Hörzeit für Menschen: „1:24“ (ohne führende Null bei den Minuten), ab einer Stunde „1:02:10“.
String hoerzeitKurz(Duration d) {
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (d.inHours > 0) {
    return '${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:$s';
  }
  return '${d.inMinutes}:$s';
}

/// „1:24 von 6:00“ bzw. „1:24 of 6:00“.
String hoerzeitVon(Duration vergangen, Duration gesamt) =>
    t.playerZeit(hoerzeitKurz(vergangen), hoerzeitKurz(gesamt));
