"""Gezielte Regression: Ausdruck darf Paarlektionen nicht auf eine Stimme reduzieren.

Mit C:\\TOOLS\\kikiri-venv\\Scripts\\python.exe -m unittest discover -s tools -p test_audio_ausdruck.py
Kein Modell, kein Netzwerk, keine Aufnahmeproduktion.
"""
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

import numpy as np
import generate_audio as de
import generate_audio_en as en

TEXT = ('Erster Abschnitt mit ausreichend vielen Zeichen für den bestehenden Absatzwechsel.\n\n'
        'Zweiter Abschnitt mit ausreichend vielen Zeichen für den bestehenden Absatzwechsel.')


class AusdruckTest(unittest.TestCase):
    def test_de_beide_stimmen_und_reihenfolge(self):
        engine = de.Kokoro.__new__(de.Kokoro)
        called = []
        def sprechen(szene, text, name):
            called.append((name, text))
            return [np.zeros(24, dtype=np.float32)]
        engine._speak_ausdruck = sprechen
        with patch('soundfile.write'):
            engine.synthesize_ausdruck('wissen', TEXT, de.BOTH, 'nicht-schreiben.wav')
        self.assertEqual(called, de.alternate_voices(TEXT))

    def test_en_beide_stimmen_und_reihenfolge(self):
        engine = en.Englisch.__new__(en.Englisch)
        called = []
        def pipe(text, voice, speed):
            called.append(voice)
            return [SimpleNamespace(audio=SimpleNamespace(numpy=lambda: np.zeros(24, dtype=np.float32)))]
        engine.pipe = pipe
        with patch('soundfile.write'):
            ms = engine.wav(TEXT, de.BOTH, 'nicht-schreiben.wav', pause='ausdruck:lektionsausdruck-1:wissen')
        self.assertEqual(called, ['af_heart', 'am_michael'])
        self.assertGreater(ms, 0)

    def test_de_einzelstimme_bleibt(self):
        engine = de.Kokoro.__new__(de.Kokoro)
        called=[]
        engine._speak_ausdruck=lambda szene,text,name: called.append(name) or [np.zeros(24)]
        with patch('soundfile.write'):
            engine.synthesize_ausdruck('wissen',TEXT,'martin','nicht-schreiben.wav')
        self.assertEqual(called,['martin'])

    def test_lexikon_alle_woerter_mit_hauptbetonung(self):
        import json
        lex=json.loads(de.LEXICON_JSON.read_text(encoding='utf-8'))
        for word, phon in lex.items():
            if not word.startswith('_'): self.assertIn('ˈ',phon,word)


if __name__ == '__main__': unittest.main()
