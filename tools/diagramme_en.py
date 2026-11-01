"""Englische Diagramme entstehen zusammen mit Deutsch aus derselben Magazin-Quelle.

  python tools/diagramme_en.py          baut DE und EN gemeinsam
  python tools/diagramme_en.py --texte  prüft die zweisprachigen Einträge ohne Schreiben
"""
import sys
from diagramme_magazin import main
from diagramme_magazin_daten import BILDER

if __name__ == '__main__':
    if '--texte' in sys.argv:
        for kennung, daten in BILDER.items():
            for feld in ('titel', 'unter', 'hinweis'):
                assert all(daten[feld].get(lang, '').strip() for lang in ('de', 'en')), (kennung, feld)
            for punkt in daten['punkte']:
                assert all(punkt['titel'].get(lang, '').strip() for lang in ('de', 'en')), kennung
                assert bool(punkt['detail']['de']) == bool(punkt['detail']['en']), kennung
        print(f'{len(BILDER)} Diagramme vollständig zweisprachig.')
    else:
        main()
