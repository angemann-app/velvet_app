"""Prüft die Weiterverwendung bestehender Tempi ohne TTS-Modell oder Netzwerk."""
import types
import unittest

import redaktion_audio_gefuehrt as guided


class SprechregelnTest(unittest.TestCase):
    def setUp(self):
        self.de = types.SimpleNamespace(SPEED=0.9, VOICE_SPEED={'martin': 0.8}, PARAGRAPH_PAUSE_S=0.6)
        self.en = types.SimpleNamespace(LANGSAM='langsam')

    def task(self, lang, slow):
        return {'sprache': lang, 'langsam': slow, 'text': 'Ruhiger Atem.', 'stimme': 'martin'}

    def test_de_langsam_und_anschliessend_unveraendert(self):
        seen = []
        def synthesize(*args, **kwargs):
            seen.append((self.de.SPEED, self.de.VOICE_SPEED, self.de.PARAGRAPH_PAUSE_S, kwargs['pause']))
        engine = types.SimpleNamespace(synthesize_wav=synthesize)
        guided.sprechen(engine, self.task('de', True), 'probe.wav', self.de, self.en)
        guided.sprechen(engine, self.task('de', False), 'probe.wav', self.de, self.en)
        self.assertEqual(seen, [(0.75, {'martin': 0.7}, 1.5, True), (0.9, {'martin': 0.8}, 0.6, False)])

    def test_de_tempo_auch_bei_fehler_zuruecksetzen(self):
        def fail(*args, **kwargs):
            raise RuntimeError('Modellfehler')
        with self.assertRaises(RuntimeError):
            guided.sprechen(types.SimpleNamespace(synthesize_wav=fail), self.task('de', True), 'probe.wav', self.de, self.en)
        self.assertEqual((self.de.SPEED, self.de.VOICE_SPEED, self.de.PARAGRAPH_PAUSE_S), (0.9, {'martin': 0.8}, 0.6))

    def test_en_bestehenden_langsam_modus_weitergeben(self):
        seen = []
        engine = types.SimpleNamespace(wav=lambda *args, **kwargs: seen.append(kwargs['pause']))
        for slow in (True, False):
            guided.sprechen(engine, self.task('en', slow), 'probe.wav', self.de, self.en)
        self.assertEqual(seen, ['langsam', False])

    def test_alle_stimmen_pfade_und_sprachen(self):
        tasks = guided.auftraege()
        self.assertEqual(len(tasks), 1488)
        self.assertEqual(len({(t['sprache'], t['id']) for t in tasks}), 1488)
        for task in tasks:
            self.assertEqual(task['langsam'], task['id'].split('/')[0] in ('einschlaf', 'traum'))
            self.assertEqual(task['id'].split('/')[1].split('_')[0], task['stimme'])


if __name__ == '__main__':
    unittest.main()
