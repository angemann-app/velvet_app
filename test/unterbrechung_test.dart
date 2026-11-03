import 'package:audio_session/audio_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/services/wiedergabe_dienst.dart';

void main() {
  UnterbrechungsReaktion r(bool begin, AudioInterruptionType t) =>
      WiedergabeDienst.reaktionAuf(AudioInterruptionEvent(begin, t));

  test('Benachrichtigung (duck): leiser, danach wieder normal, nie pausieren', () {
    expect(r(true, AudioInterruptionType.duck), UnterbrechungsReaktion.leiser);
    expect(r(false, AudioInterruptionType.duck), UnterbrechungsReaktion.normal);
  });

  test('Anruf oder andere Wiedergabe pausiert, startet aber nie von selbst', () {
    for (final t in [AudioInterruptionType.pause, AudioInterruptionType.unknown]) {
      expect(r(true, t), UnterbrechungsReaktion.pausieren);
      expect(r(false, t), UnterbrechungsReaktion.keine);
    }
  });

  test('Sitzung pausiert nicht von selbst, wenn Android nur „leiser“ verlangt', () {
    final k = WiedergabeDienst.sitzungsKonfiguration();
    expect(k.androidWillPauseWhenDucked, isFalse);
    expect(k.androidAudioAttributes?.contentType, AndroidAudioContentType.speech);
  });

  test('Leiser ist hörbar leiser, aber nicht stumm', () {
    expect(WiedergabeDienst.duckFaktor, inInclusiveRange(0.2, 0.6));
  });
}
