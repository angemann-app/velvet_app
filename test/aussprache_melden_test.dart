import 'package:flutter_test/flutter_test.dart';
import 'package:velvetpulse/widgets/aussprache_melden.dart';

void main() {
  test('Meldungs-Link füllt die Vorlage und überträgt nur Ort, Stimme und Minute', () {
    final url = ausspracheMeldungUrl(
      wo: 'Gemeinsamer Abend, Baustein ankommen_1',
      stimme: 'victoria',
      position: const Duration(minutes: 2, seconds: 5),
    );
    expect(url.host, 'github.com');
    expect(url.path, '/angemann-app/velvet_app/issues/new');
    expect(url.queryParameters.keys.toSet(), {'template', 'title', 'body'});
    expect(url.queryParameters['template'], 'aussprache.md');
    final body = url.queryParameters['body']!;
    expect(body, contains('**Wo:** Gemeinsamer Abend, Baustein ankommen_1'));
    expect(body, contains('**Stimme:** Victoria'));
    expect(body, contains('**Ungefähr bei Minute:** 2:05'));
  });

  test('Ohne Stimme und Position bleiben die Felder leer', () {
    final body = ausspracheMeldungUrl(wo: 'Kurs 3').queryParameters['body']!;
    expect(body, contains('**Stimme:** \n'));
    expect(body, contains('**Ungefähr bei Minute:** \n'));
  });
}
