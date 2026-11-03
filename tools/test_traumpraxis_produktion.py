"""Prüft die Unterbrechungs-/Fortsetzungsregeln ohne TTS oder Netzwerk."""
import tempfile
from pathlib import Path
from types import SimpleNamespace
import unittest
from unittest.mock import patch

import traumpraxis_hoertexte as job


class ProduktionsTest(unittest.TestCase):
    def test_fremde_pause_bleibt_erhalten(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'pause.flag').write_text('Nutzerpause', encoding='utf-8')
            with patch.object(job, 'PRODUCTION', root), patch.object(job, 'vorbereiten', return_value=[]), \
                    patch.object(job, 'schreiben'), patch.object(job.subprocess, 'run') as resume, \
                    patch.object(job.sys, 'argv', ['job', '--einschieben']):
                with self.assertRaises(FileExistsError):
                    job.main()
                resume.assert_not_called()
            self.assertEqual((root / 'pause.flag').read_text(encoding='utf-8'), 'Nutzerpause')

    def test_fehlgeschlagener_einschub_gibt_eigene_pause_frei_und_setzt_fort(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with patch.object(job, 'PRODUCTION', root), patch.object(job, 'vorbereiten', return_value=[]), \
                    patch.object(job, 'schreiben'), patch.object(job, 'produzieren', side_effect=RuntimeError('TTS fehlt')), \
                    patch.object(job.subprocess, 'run', return_value=SimpleNamespace(returncode=0)) as resume, \
                    patch.object(job.sys, 'argv', ['job', '--einschieben']):
                with self.assertRaises(RuntimeError):
                    job.main()
                resume.assert_called_once()
                self.assertEqual(resume.call_args.args[0][-2:], ['--gruppe', 'gefuehrt'])
            self.assertFalse((root / 'pause.flag').exists())

    def test_geaendertes_pausensignal_wird_nicht_entfernt(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            def andere_pause(*args):
                (root / 'pause.flag').write_text('Nutzerpause', encoding='utf-8')
            with patch.object(job, 'PRODUCTION', root), patch.object(job, 'vorbereiten', return_value=[]), \
                    patch.object(job, 'schreiben'), patch.object(job, 'produzieren', side_effect=andere_pause), \
                    patch.object(job.subprocess, 'run') as resume, \
                    patch.object(job.sys, 'argv', ['job', '--einschieben']):
                job.main()
                resume.assert_not_called()
            self.assertEqual((root / 'pause.flag').read_text(encoding='utf-8'), 'Nutzerpause')


if __name__ == '__main__':
    unittest.main()
