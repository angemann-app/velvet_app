"""Ergänzt die abgestimmte Traumpraxis-Anleitung idempotent in DE und EN."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEXT = {
    'assets/data/anleitung.json': 'Deine Traumpraxis: In Lust im Traum verbindest du Erinnern, bewusstes Erkennen und Nachspüren am Tag. Unter „Deine Traumzeichen“ legst du persönliche Zeichen an, bearbeitest oder löschst sie. Für deine Abendvorbereitung wählst du ein Zeichen und eine angenehme Erinnerung aus dem Tagebuch. Unter „Heute nachspüren“ hältst du freiwillig Erholung, Tageslust, sinnliche oder klare Träume, mögliche Höhepunkte und eine Notiz fest. Fragen dürfen offenbleiben. Im privaten Rückblick kannst du deine Tagesbeobachtungen ansehen, bearbeiten und löschen. Traumzeichen und Beobachtungen bleiben lokal, sind Teil deiner Sicherung und gehen nicht an dein Gegenüber und nicht ins Netz. Mehr Tageslust ist ein Erkundungsziel, kein versprochener Effekt.',
    'translations/en/anleitung.json': 'Your dream practice: In Pleasure in dreams, connect recall, recognising dreams and noticing what lingers during the day. Under “Your dream signs”, add, edit or delete personal signs. For your evening preparation, choose a sign and a pleasant memory from your journal. Under “Reflect on today”, optionally record rest, waking desire, sensual or lucid dreams, any experienced orgasms and a note. Questions can remain unanswered. Your private review lets you view, edit and delete daily observations. Signs and observations stay local, are included in your backup and are not sent to your partner and never leave your device. More waking desire is an aim to explore, not a promised effect.',
}
for name, text in TEXT.items():
    path = ROOT / name
    data = json.loads(path.read_text(encoding='utf-8'))
    section = next(a for a in data['abschnitte'] if a['id'] == 'gefuehrt')
    paragraphs = [p for p in section['text'].split('\n') if not p.startswith(('Deine Traumpraxis:', 'Your dream practice:'))]
    section['text'] = '\n'.join(paragraphs + [text])
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
