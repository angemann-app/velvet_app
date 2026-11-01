"""Erzeugt getrennte Lektoratsmuster; verändert keine Produktionsdateien.

Aufruf: python tools/redaktion_beruehrung_muster.py
Ausgabe: build/redaktion/beruehrung/ (DE/EN, Vorher-Nachher-Diffs und Manifest).
"""
import difflib
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ZIEL = ROOT / 'build' / 'redaktion' / 'beruehrung'

# Nur bestehende Formulierungen lektorieren und pauschale Aussagen korrigieren.
# Die Dialogbeispiele, Aufgaben und Metadaten bleiben wortgleich erhalten.
KORREKTUREN = {
    'de': {
        'touch_w_s1': [
            ('Sichtbar ist nur ihre Spitze, dahinter liegen Schenkel und Schwellkörper, die sich bis tief ins Becken ziehen.',
             'Von außen ist vor allem die Klitoriseichel zu sehen, die teilweise oder vollständig von der Vorhaut bedeckt sein kann. Körper und Schenkel der Klitoris liegen überwiegend im Inneren.'),
            ('Erst wenn die Hüften sich entgegenrecken, ist die Klitoris bereit.',
             'Eine Bewegung der Hüften sagt für sich allein nicht, welche Berührung gerade erwünscht ist. Fragt nach und lasst ihre Rückmeldung entscheiden.'),
            ('Kreisen: Zwei flache Finger kreisen über der Klitorisvorhaut, nicht direkt auf der Spitze. Mal im Uhrzeigersinn, mal dagegen.',
             'Beim Kreisen bleiben zwei flache Finger über der Klitorisvorhaut, statt unmittelbar auf der Eichel. Ob die Richtung angenehm ist, entscheidet ihre Rückmeldung.'),
            ('Auf und ab: Zwei Finger links und rechts neben der Klitoris gleiten auf und ab und massieren sie von der Seite.',
             'Für die Auf-und-ab-Bewegung gleiten zwei Finger links und rechts neben der Klitoris und berühren sie von der Seite.'),
            ('Tippen: leichte, schnelle Tupfer, wie Regentropfen.\nDruck: die flache Hand auf die ganze Vulva legen und rhythmisch drücken.',
             'Eine weitere Möglichkeit sind leichte, schnelle Tupfer, wie Regentropfen. Bei der Druckvariante liegt die flache Hand auf der Vulva; beginnt mit wenig Druck und passt ihn gemeinsam an.'),
            ('Wichtig ist fast immer: Gleitmittel oder die eigene Feuchtigkeit, und dranbleiben. Wenn es gut ist, nicht wechseln.',
             'Angenehme Reibung braucht ausreichend Feuchtigkeit. Bei Bedarf ergänzt ihr ein verträgliches Gleitmittel und beachtet dessen Eignung für Kondome oder Toys. Wenn etwas gut ist, bleibt dabei; bei Unbehagen verändert ihr die Berührung oder macht eine Pause.'),
            ('Zwei Finger in der Vagina, nach vorn gekrümmt, können das verstärken.',
             'Die zusätzliche Berührung in der Vagina ist eine Möglichkeit, wenn sie gewünscht ist und angenehm bleibt; sie ist keine Voraussetzung für einen Orgasmus.'),
            ('Kurz innehalten, die Hand ruhig liegen lassen, dann wieder ganz sanft beginnen, gern indirekt. Viele Frauen können so mehrmals hintereinander kommen. Nicht jede will das, und das ist genauso in Ordnung.',
             'Haltet zunächst inne und klärt, ob eine ruhende Hand angenehm ist oder jede Berührung gerade zu viel wäre. Manche Frauen erleben mehrere Orgasmen, andere brauchen eine längere Pause oder möchten aufhören. Daraus lässt sich weder eine Pflicht noch ein Maßstab für guten Sex ableiten.'),
        ],
        'touch_m_s1': [
            ('Wer die empfindlichsten Stellen kennt und mit Tempo und Druck spielt, macht aus einem schnellen Handjob ein Erlebnis.',
             'Entscheidend ist dabei weniger die Zahl der Griffe als die Aufmerksamkeit dafür, was ihm gerade gefällt.'),
            ('Die Eichel, besonders ihr Rand. Das Bändchen an der Unterseite, wo Eichel und Schaft sich treffen. Die Hoden und der Damm zwischen Hoden und After. Der Schaft ist weniger empfindlich, verträgt mehr Druck und ist die Bühne für Rhythmus.',
             'Zu den häufig empfindlichen Bereichen gehören die Eichel, ihr Rand und das Bändchen an der Unterseite, wo Eichel und Schaft zusammentreffen. Auch Hoden und Damm können berührungsempfindlich sein. Wie sich die Empfindlichkeit verteilt, ist individuell: Mehr Druck ist am Schaft nicht automatisch angenehmer.'),
            ('Die Eichel-Massage: Die flache, nasse Handfläche kreist über der Eichel, wie über einem Türknauf.',
             'Bei der Eichel-Massage kreist die flache, befeuchtete Handfläche über der Eichel. Achtet darauf, dass die Haut dabei nicht unangenehm mitgezogen wird.'),
            ('Das Bändchen: zwei Finger reiben kurz und schnell an der Unterseite.',
             'Am Bändchen beginnt ihr besonders behutsam; direkte Reibung kann dort schnell zu intensiv werden.'),
            ('Ohne Gleitmittel geht wenig. Lieber zu viel als zu wenig.',
             'Ein verträgliches Gleitmittel kann Reibung vermindern. Verwendet so viel, wie angenehm ist, ergänzt bei Bedarf und beachtet die Eignung für Kondome. Eine vorhandene Vorhaut bewegt ihr nur so weit, wie es mühelos und schmerzfrei möglich ist.'),
            ('Wer gibt, achtet auf die Hoden: ziehen sie sich hoch, ist er nah dran. Ein ruhiger, fester Griff an der Wurzel kann den Höhepunkt kurz hinauszögern.',
             'Verlasst euch dafür auf seine Rückmeldung. Die Stellung der Hoden ist kein verlässlicher Countdown zum Orgasmus. Einen festen Griff an der Wurzel solltet ihr nicht als allgemeine Methode zum Verzögern verstehen; schmerzhaftes Drücken oder Abschnüren gehört nicht dazu.'),
            ('Während eine Hand gleitet, umfasst die andere sanft die Hoden, wiegt sie, zieht sie leicht nach unten. Oder zwei Finger drücken rhythmisch auf den Damm. Das macht die Erregung tiefer.',
             'Die Hoden könnt ihr sanft umfassen, ohne an ihnen zu ziehen oder sie zu quetschen. Eine Berührung am Damm ist eine weitere Möglichkeit, wenn sie gewünscht ist. Ob sie angenehm ist, sagt er euch; eine bestimmte Wirkung lässt sich nicht versprechen.'),
        ],
    },
    'en': {
        'touch_w_s1': [
            ('Only its tip is visible; behind it lie the legs and erectile tissue, reaching deep into the pelvis.',
             'The part most visible externally is the clitoral glans, which may be partly or fully covered by the hood. The body and crura of the clitoris lie mainly inside the body.'),
            ('Only when the hips push towards you is the clitoris ready.',
             'A movement of the hips alone does not tell you which touch is wanted. Ask, and let her feedback guide you.'),
            ('Circling: two flat fingers circle over the clitoral hood, not directly on the tip. Sometimes clockwise, sometimes anticlockwise.',
             'For circling, two flat fingers stay over the clitoral hood rather than directly on the glans. Her feedback tells you whether the direction feels comfortable.'),
            ('Up and down: two fingers either side of the clitoris glide up and down and massage it from the sides.',
             'For the up-and-down movement, two fingers glide on either side of the clitoris, touching it from the sides.'),
            ('Tapping: light, quick taps, like raindrops.\nPressure: lay the flat hand over the whole vulva and press rhythmically.',
             'Another option is light, quick tapping, like raindrops. For the pressure variation, the flat hand rests over the vulva; begin with light pressure and adjust it together.'),
            ("Almost always important: lube or her own wetness, and staying with it. When it's good, don't change.",
             'Comfortable friction needs enough moisture. Add a suitable lubricant when needed and check its compatibility with condoms or toys. Stay with what feels good; if discomfort arises, change the touch or pause.'),
            ('Two fingers in the vagina, curled forwards, can intensify it.',
             'Additional touch inside the vagina is an option if she wants it and it remains comfortable; it is not a requirement for orgasm.'),
            ("Pause briefly, let the hand rest, then begin again very gently, ideally indirectly. This way many women can come several times in a row. Not everyone wants that, and that's just as fine.",
             'Pause first and check whether a resting hand feels comfortable or any touch would be too much. Some women experience several orgasms; others need a longer break or want to stop. Neither creates an obligation or a standard for good sex.'),
        ],
        'touch_m_s1': [
            ('If you know the most sensitive spots and play with pace and pressure, a quick handjob becomes an experience.',
             'What matters is less the number of techniques than paying attention to what he enjoys at that moment.'),
            ('The head, especially its rim. The frenulum on the underside, where head and shaft meet. The testicles and the perineum between testicles and anus. The shaft is less sensitive, takes more pressure and is the stage for rhythm.',
             'Often-sensitive areas include the head, its rim and the frenulum on the underside, where head and shaft meet. The testicles and perineum can also be sensitive to touch. Sensitivity varies from person to person: more pressure on the shaft is not automatically more comfortable.'),
            ('The head massage: the flat, wet palm circles over the head, like over a doorknob.',
             'For the head massage, the flat, moistened palm circles over the head. Make sure this does not pull the skin uncomfortably.'),
            ('The frenulum: two fingers rub briefly and quickly on the underside.',
             'Be particularly gentle at the frenulum; direct friction can quickly become too intense there.'),
            ('Without lube, not much works. Better too much than too little.',
             'A suitable lubricant can reduce friction. Use as much as feels comfortable, add more when needed and check compatibility with condoms. If a foreskin is present, move it only as far as it goes easily and without pain.'),
            ("Whoever gives watches the testicles: when they draw up, he's close. A calm, firm grip at the base can briefly delay climax.",
             'Rely on his feedback instead. The position of the testicles is not a reliable countdown to orgasm. A firm grip at the base should not be treated as a general method of delaying climax; painful pressure or constriction has no place here.'),
            ('While one hand glides, the other gently cups the testicles, cradles them, draws them slightly down. Or two fingers press rhythmically on the perineum. That makes the arousal deeper.',
             'You can gently cup the testicles without pulling or squeezing them. Touching the perineum is another option if he wants it. He can tell you whether it feels comfortable; no particular effect can be promised.'),
        ],
    },
}


def main():
    ZIEL.mkdir(parents=True, exist_ok=True)
    manifest = {'status': 'Entwurf zur Abnahme, keine Produktionsänderung', 'quellen': {}, 'lektionen': []}
    for sprache, datei in [('de', 'assets/data/velvet_content.json'), ('en', 'translations/en/velvet_content.json')]:
        quelle = ROOT / datei
        manifest['quellen'][datei] = hashlib.sha256(quelle.read_bytes()).hexdigest()
        daten = json.loads(quelle.read_text(encoding='utf-8'))
        for kurs in daten['courses']:
            for original in kurs['lessons']:
                kennung = original['id']
                if kennung not in KORREKTUREN[sprache]:
                    continue
                entwurf = dict(original)
                inhalt = original['content']
                for alt, neu in KORREKTUREN[sprache][kennung]:
                    if inhalt.count(alt) != 1:
                        raise ValueError(f'{sprache}/{kennung}: Ausgangsstelle fehlt oder ist mehrdeutig: {alt[:70]}')
                    inhalt = inhalt.replace(alt, neu)
                entwurf['content'] = inhalt
                assert {k: v for k, v in original.items() if k != 'content'} == {k: v for k, v in entwurf.items() if k != 'content'}
                for marker in (('Sehr spicy:', 'Die Aufgabe') if sprache == 'de' else ('Extra spicy:', 'The task')):
                    assert original['content'].split(marker, 1)[1] == inhalt.split(marker, 1)[1]
                name = f'{kennung}.{sprache}'
                (ZIEL / f'{name}.json').write_text(json.dumps({'course': kurs['id'], 'lesson': entwurf}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
                (ZIEL / f'{name}.md').write_text(f"# {entwurf['title']}\n\nEntwurf zur Abnahme · {kennung} · {kurs['id']} · {original['voice']}\n\n{original['summary']}\n\n{inhalt}\n\n## Reflexionsfrage\n\n{original['reflection_question']}\n", encoding='utf-8')
                diff = difflib.unified_diff(original['content'].splitlines(True), inhalt.splitlines(True), fromfile=f'{kennung}/{sprache}/vorher', tofile=f'{kennung}/{sprache}/entwurf')
                (ZIEL / f'{name}.diff').write_text(''.join(diff), encoding='utf-8')
                manifest['lektionen'].append({'sprache': sprache, 'id': kennung, 'course': kurs['id'], 'aenderungen': len(KORREKTUREN[sprache][kennung]), 'zeichen_vorher': len(original['content']), 'zeichen_entwurf': len(inhalt)})
    if len(manifest['lektionen']) != 4:
        raise ValueError('Es müssen genau zwei Lektionen in zwei Sprachen sein.')
    (ZIEL / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('Vier Musterfassungen mit Diffs und Manifest erzeugt:', ZIEL)


if __name__ == '__main__':
    main()
