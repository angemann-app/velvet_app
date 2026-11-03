import 'dart:convert';

/// Im vorhandenen Reflexionsfeld gespeichert, kein zusätzlicher Datenbestand.
/// Der Freigabestand ist lokal: eine fehlgeschlagene Übertragung deckt die
/// Antwort des Gegenübers nicht vorzeitig auf.
class GemeinsamAntwort {
  final String text;
  final String? gefuehl;
  final bool geteilt;
  const GemeinsamAntwort(this.text, {this.gefuehl, this.geteilt = false});
  static const gefuehle = ['ruhig', 'nah', 'offen', 'bewegt'];
  String speichern() {
    if (text.trim().isEmpty ||
        text.length > 4000 ||
        (gefuehl != null && !gefuehle.contains(gefuehl))) {
      throw const FormatException('Ungültiger Rückblick');
    }
    final raw = jsonEncode({
      'ge': 1,
      'text': text.trim(),
      if (gefuehl != null) 'gefuehl': gefuehl,
      'geteilt': geteilt
    });
    if (raw.length > 4800) throw const FormatException('Rückblick zu lang');
    return raw;
  }

  factory GemeinsamAntwort.lesen(String? raw) {
    if (raw == null) return const GemeinsamAntwort('');
    try {
      final j = jsonDecode(raw);
      if (j is Map &&
          j['ge'] == 1 &&
          j['text'] is String &&
          (j['text'] as String).length <= 4000 &&
          j['geteilt'] is bool &&
          (j['gefuehl'] == null || gefuehle.contains(j['gefuehl']))) {
        return GemeinsamAntwort(j['text'] as String,
            gefuehl: j['gefuehl'] as String?, geteilt: j['geteilt'] as bool);
      }
    } catch (_) {}
    return GemeinsamAntwort(raw);
  }
}
