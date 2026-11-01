"""Erzeugt die 'Sehr spicy'-Fassungen fuer 'Der andere Koerper' (Innenansichten).

Ziel:
- sehrspicy_mann (Hoerer Mann, Stimme Martin, Thema: Der Orgasmus der Frau von innen)
- sehrspicy_frau (Hoererin Frau, Stimme Victoria, Thema: Die Erektion, Ejakulation und Refraktärzeit des Mannes von innen)
In deutscher und englischer Sprache, aufgeteilt in die sechs Szenen:
  opening, own_body, other_door, other_body, return, afterglow.
Ablage unter build/redaktion/sehrspicy/.
"""
import json
import html
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / 'build' / 'redaktion' / 'sehrspicy'

# --- TEXTE: DEUTSCH ---

SEHRSPICY_MANN_DE = {
    "id": "sehrspicy_mann",
    "variante": "sehrspicy",
    "perspektive": "mann",
    "name": "Mann",
    "stimme": "martin",
    "titel": "Wenn ich eine Frau werde: Der Orgasmus der Frau von innen",
    "segmente": [
        {
            "szene": "opening",
            "titel": "Ankommen im Abend",
            "text": """Ich liege auf dem Rücken.

Das Schlafzimmer ist ruhig. Nur das gedämpfte, warme Licht einer kleinen Nachttischlampe fällt weich über die Bettdecke. Ich bin nackt und spüre die kühle Luft auf meiner Haut, bevor die Decke sie wieder wärmt. Meine Arme liegen locker neben meinem Körper, meine Beine sind leicht geöffnet.

Nichts wird von mir erwartet. Es gibt kein Ziel, das ich erreichen müsste, keine Leistung und keine Rolle, die ich ausfüllen soll.

Ich nehme wahr, wie sich mein Brustkorb beim Atmen hebt und wieder senkt. Ein langer Atemzug ein, und ein langes, lösendes Ausatmen. Ich möchte einfach nur da sein, die Schwere des Tages abstreifen und mich auf eine Reise einlassen, die ich so vielleicht noch nie gewagt habe: die Reise in das innerste Erleben eines anderen Körpers."""
        },
        {
            "szene": "own_body",
            "titel": "Der vertraute Körper",
            "text": """Bevor ich mich auf das Fremde einlasse, komme ich ganz in meinem eigenen, vertrauten Körper an.

Ich kenne dieses Gewicht auf der Matratze. Ich spüre meine Fersen, die feste Auflage meiner Schultern und die Form meines Beckens. Ich kenne meine Haut, meine Muskeln und die Art, wie mein Körper auf Berührung reagiert. Ich weiß, wo meine Grenzen verlaufen und wie es sich anfühlt, wenn meine eigene Hand über meine Brust und meinen Bauch streicht.

Ich schließe die Augen.

Hier bin ich sicher. Dieser Körper ist meine Heimat. Und genau aus dieser Sicherheit und Ruhe heraus erlaube ich mir nun, neugierig zu werden. Ich lasse die Muskeln in meinem Kiefer locker, lasse meine Schultern noch ein Stück tiefer in die Kissen sinken und öffne einen inneren Raum."""
        },
        {
            "szene": "other_door",
            "titel": "Die Verwandlung",
            "text": """Dann verändert sich etwas.

Zunächst ist es kaum mehr als ein Kribbeln. Es beginnt tief in meinem Becken und breitet sich langsam wie ein warmer Strom durch meinen Rumpf aus. Die Matratze unter mir scheint weicher nachzugeben. Mein Schwerpunkt verschiebt sich nach unten, näher an die Mitte meines Körpers.

Ich spüre, wie sich meine Konturen neu finden. Meine Schultern werden schmaler. Meine Arme fühlen sich zarter an. Meine Taille zeichnet sich deutlicher ab, während meine Hüften eine neue, ausladendere Form annehmen und tiefer in die Matratze sinken.

Dann bemerke ich meine Brust.

Zunächst ist es ein sanftes Ziehen, ein neues, warmes Gewicht. Meine Brust hebt sich mit jedem Atemzug anders. Als ich vorsichtig meine Hände hebe und sie darauflege, spüre ich zwei weiche Rundungen unter meinen Handflächen. Die Haut ist zart, warm und empfindsam. Ich bewege die Finger fast ungläubig über die Wölbung. Ich habe Brüste.

Und zwischen meinen Beinen verändert sich alles. Das gewohnte Gefühl von Gewicht und Anhängen schwindet vollständig. Stattdessen entsteht eine neue, weiche Fülle. Als meine Hand nach unten wandert, ertaste ich die äußeren und inneren Schamlippen, die zarte Feuchtigkeit am Scheideneingang und die kleine, geschützte Kappe der Klitoris.

Ich schlage die Augen auf und blicke an mir hinab. Ich muss nichts hinterfragen. Es ist vollkommen selbstverständlich:

Ich bin eine Frau. Ich bewohne diesen Körper von innen."""
        },
        {
            "szene": "other_body",
            "titel": "Das Erleben der Lust und der Höhepunkte",
            "text": """Ich liege still da und lausche in diese neue Anatomie hinein.

Erregung beginnt hier nicht wie ein Schalter, der umgelegt wird. Es ist ein allmähliches, tiefes Aufglühen. Als meine Hand sanft über meinen Oberschenkel streicht und die zarte Haut an den Innenseiten meiner Schenkel berührt, fährt ein Schauer durch mein Becken.

Tief im Inneren beginnt sich etwas zu verändern. Die Klitoris ist so viel mehr als das kleine, von außen sichtbare Organ: Ihre beiden Schwellkörperschenkel schmiegen sich wie Flügel an meine Schambeinäste, und die Schwellkörper des Vorhofs umgeben meinen Scheideneingang. Jetzt füllen sich all diese verborgenen Gewebe langsam mit warmem Blut. Mein ganzes Becken fühlt sich dichter an, geschwollen, pulsierend und lebendig. An den Wänden meiner Scheide tritt eine feine, warme Feuchtigkeit hervor – mein Körper bereitet sich von selbst vor, ohne jeden bewussten Befehl.

Meine Finger wandern hinauf zu meiner Brust. Als ich mit den Kuppen behutsam um die Brustwarzen kreise, zieht ein feiner Nervenstrang von der Brust direkt hinab in meinen Schoß. Meine Brustwarzen richten sich auf, fest und dunkel vor Empfindung.

Nun gleitet meine Hand wieder nach unten zu meiner Vulva. Meine Finger sind feucht. Ich streiche über die Schamlippen und berühre zum ersten Mal ganz sanft die Spitze meiner Klitoris. Es ist wie ein elektrisierender Funke. Tausende hochsensible Nervenenden antworten auf den leisesten Druck. Ich beginne, mit der Fingerkuppe in kleinen, wiegenden Kreisen um die Spitze herumzustreichen, mit sanftem, gleichmäßigem Rhythmus.

Die Lust wächst. Doch sie steigt nicht geradlinig an; sie kommt in Wellen, wie eine warme Brandung. Ein kurzes Anfluten, dann ein Innehalten, ein tiefer Atemzug. Ich begreife, dass dieser Körper keinen Druck verträgt. Wenn ich zu hastig werde, zieht sich das Empfinden zurück. Doch wenn ich mich dem Rhythmus überlasse und mein Becken sanft gegen meine Finger wiege, öffnet sich ein Raum nach dem anderen.

Meine Beckenbodenmuskulatur spannt sich unwillkürlich an, hält die innere Fülle und entspannt sich wieder. Die Erregung strahlt in meinen Unterbauch, in mein Kreuzbein und bis tief in meine Oberschenkel. Mein Herz schlägt kräftig. Mein Atem wird schneller, unregelmäßiger. Eine Hitze staut sich auf, die sich nicht mehr verhandeln lässt. Ich nähere mich einer Schwelle.

Und dann bricht die Welle.

Ein winziger Moment des Innehaltens – und die Kontraktionen brechen los. Meine Beckenbodenmuskeln, der Musculus pubococcygeus und die Muskulatur rund um meinen Scheideneingang ziehen sich in einem rhythmischen, unerbittlichen Takt zusammen: alle Bruchteile einer Sekunde, ein schneller Schlag von etwa 0,8 Sekunden. Zusammenziehen. Lösen. Zusammenziehen. Lösen. Sechs, acht, zehn Mal hintereinander. Jedes Zusammenziehen ist ein Auspressen von purem, brennendem Licht. Mein Uterus zieht sich vom Grund bis zum Muttermund krampfartig zusammen, ein tiefes, viszerales Greifen, das mir den Atem raubt. Es ist keine örtliche Entladung – es ist ein Beben, das durch mein ganzes Nervensystem rollt, bis sich meine Zehen krallen und mein Rücken sich von der Matratze wölbt.

Langsam ebbt dieser erste Sturm ab. Ich sinke keuchend zurück in die Kissen.

Doch als meine Finger noch an meiner Klitoris liegen, zucke ich unwillkürlich zusammen: Die kleine Eichel ist schlagartig überempfindlich geworden, beinahe schmerzhaft intensiv. Jede direkte Berührung wäre jetzt zu viel. Instinktiv passe ich meine Berührung an. Ich nehme die Hand nicht weg, aber ich wechsle die Stelle: Ich streiche mit dem weichen Handballen flächig über den Schamhügel, gleite sanft über die äußeren Lippen und gebe nur noch sanften, wiegenden Druck ab.

Und genau hier geschieht das Wunder dieses Körpers: Meine Erregung stürzt nicht ab. Sie bleibt auf einem hohen, warmen Plateau schweben. Die Schwellkörper bleiben gefüllt. Das Blut pulsiert weiter. Und während ich einfach nur atme und den Handballen kreisen lasse, spüre ich, wie tief aus meinem Becken eine zweite, völlig neue Welle heraufzieht.

Sie kündigt sich nicht mit spitzer Schärfe an, sondern als ein mächtiges, dunkles Rollen. Diesmal beginnt sie tief in der Scheide und im Uterus. Mein Beckenboden zieht sich erneut zusammen – weniger punktuell, dafür unendlich weit, weich und tief. Es sind Kontraktionswellen, die nahtlos ineinander übergehen, wie warmes Wasser, das über ein Wehr schwappt. Mein ganzes Bewusstsein löst sich für Momente auf in diesem rhythmischen, strömenden Nachgeben.

So erleben es viele Frauen – nicht alle, und nicht jedes Mal gleich, denn jeder Körper trägt seine eigene Weisheit in sich. Aber die Weite und die Möglichkeit dieser Wellen liegen in jeder Faser dieses Fleisches."""
        },
        {
            "szene": "return",
            "titel": "Das Nachlassen und die Rückverwandlung",
            "text": """Ganz langsam verebbt das Beben.

Eine tiefe, goldene Schwere breitet sich in meinen Gliedern aus. Mein Atem wird wieder lang, ruhig und gleichmäßig. Das Blut beginnt behutsam aus den inneren Schwellkörpern zurückzufließen, und die Muskeln meines Beckenbodens entspannen sich vollständig. Ich liege da, warm, geborgen, erschöpft und erfüllt von einem tiefen inneren Frieden.

Nun ist der Augenblick gekommen, diesen geliehenen Körper wieder loszulassen. Ich atme tief ein und bedanke mich innerlich bei dieser Gestalt für ihr Vertrauen.

Mit meinem Ausatmen setzt die Rückverwandlung ein.

Ganz sanft und organisch: Das Gewicht auf meiner Brust löst sich auf, mein Brustkorb weitet sich wieder, wird kräftig und flach. Meine Taille wird gerader, meine Hüften straffen sich und liegen wieder vertraut auf der Unterlage. Zwischen meinen Beinen schwindet die weiche Hülle der Vulva; die gewohnte Gestalt und das Gewicht meines Penis und meines Hodensacks kehren an ihren angestammten Platz zurück.

Ich spüre wieder meine eigenen Muskeln, meine eigene Haut, meine vertrauten Konturen. Ich bin wieder ganz und gar ich selbst – sicher, ganz und geborgen in meinem männlichen Körper."""
        },
        {
            "szene": "afterglow",
            "titel": "Nachklang und Integration",
            "text": """Ich schlage langsam die Augen auf.

Das Zimmer ist dasselbe wie zuvor. Das gedämpfte Licht der Lampe, die Decke, die Stille der Nacht. Und doch hat sich etwas Grundlegendes verändert.

Ich habe hinter den Schleier geblickt. Ich habe gespürt, dass die Lust einer Frau kein Rätsel ist, das man knacken muss, und kein Automat, der auf Knopfdruck anspringt. Sie ist ein Ozean aus Wellen. Aus feinen Schwellkörpern, die Zeit brauchen, um sich zu füllen; aus Kontraktionen, die den ganzen Leib erfassen; und aus einer Zartheit, die nach einem ersten Höhepunkt nicht erlischt, sondern behutsam weiterbegleitet werden will.

Ich nehme dieses Wissen mit in mein Leben und in meine nächsten Berührungen: Nicht als Anforderung oder Leistungsziel, sondern als Geschenk der Geduld und des tiefen Respekts.

Ich atme noch einmal tief ein, ziehe die Decke bis an mein Kinn und lasse die Nacht in Ruhe beginnen."""
        }
    ]
}

# --- TEXTE: ENGLISCH (sehrspicy_mann) ---

SEHRSPICY_MANN_EN = {
    "id": "sehrspicy_mann",
    "variante": "sehrspicy",
    "perspektive": "mann",
    "name": "Man",
    "stimme": "martin",
    "titel": "When I Become a Woman: The Female Orgasm from Within",
    "segmente": [
        {
            "szene": "opening",
            "titel": "Arriving into the Evening",
            "text": """I am lying on my back.

The bedroom is still. Only the warm, muted glow of a small lamp falls across the duvet. I am naked, feeling the cool evening air brush across my skin before the blanket gathers my warmth again. My arms rest loosely at my sides, my legs gently apart.

Nothing is expected of me. There is no destination to reach, no performance to give, and no role I have to fulfill.

I notice my chest rising and falling with each breath. A long, slow breath in, and an unhurried, releasing breath out. I simply want to be here, let go of the day's weight, and embark on a journey I may never have dared before: the journey into the intimate, internal experience of another body."""
        },
        {
            "szene": "own_body",
            "titel": "The Familiar Body",
            "text": """Before opening myself to the unfamiliar, I arrive fully in my own known body.

I know this weight upon the mattress. I feel my heels, the solid grounding of my shoulders, and the contour of my pelvis. I know my skin, my muscles, and how my body responds to touch. I know where my boundaries lie and how it feels when my hand travels over my chest and belly.

I close my eyes.

Here, I am safe. This body is my home. And it is precisely from this place of safety that I allow myself to become curious. I soften the muscles in my jaw, let my shoulders sink a fraction deeper into the pillows, and open an inner doorway."""
        },
        {
            "szene": "other_door",
            "titel": "The Transformation",
            "text": """Then, something shifts.

At first, it is little more than a tingling. It begins deep in my pelvis and flows upward through my torso like a slow, warm current. The mattress beneath me seems to soften. My center of gravity shifts downward, settling lower toward the core of my pelvis.

I feel my contours finding a new shape. My shoulders narrow. My arms feel softer, more delicate. My waist curves in more sharply, while my hips widen, finding a fuller arc that sinks deeper into the bed.

Then I notice my chest.

A gentle pulling sensation, a new and tender weight. My chest rises differently with each breath. When I lift my hands and rest them there, I feel two soft, warm curves beneath my palms. The skin is delicate, warm, and acutely sensitive. Almost in disbelief, I move my hands over their swell. I have breasts.

And between my legs, everything transforms. The familiar feeling of weight and external suspension dissolves entirely. In its place rests a soft, protected fullness. As my hand slides down, I discover the outer and inner labia, the tender moisture at the entrance, and the small, hooded pearl of the clitoris.

I open my eyes and look down along my body. There is no question, no hesitation:

I am a woman. I inhabit this body from within."""
        },
        {
            "szene": "other_body",
            "titel": "Experiencing Arousal and Orgasm",
            "text": """I lie motionless, listening into this new anatomy.

Arousal here does not flick on like a switch. It is a gradual, deep kindling. As my hand glides down my thigh, grazing the soft skin of my inner legs, a shiver ripples through my pelvis. My breathing deepens.

Deep inside, blood begins to gather. I realize the clitoris is so much more than the small visible bud: its two cavernous arms curve along the pubic bone like wings, and the vestibular bulbs embrace the vaginal opening. Now, all these hidden erectile tissues fill with warm blood. My entire pelvis feels denser, swollen, humming with life. Along the walls of my vagina, a delicate, warm lubrication appears—a natural softening that my body produces effortlessly, responding purely to the unfolding of desire.

My fingers trace upward to my breast. As I circle my fingertips lightly around the nipples, a sharp, electric thread seems to pull straight from my chest down into my womb. My nipples erect, firm and heightened with sensation.

My hand glides down once more to my vulva. My fingers are wet. I part the outer labia, which have grown full and warm, and touch the clitoral glans with the gentlest brush. It is a spark of pure sensation. Thousands of sensitive nerve endings answer the slightest pressure. I begin to trace small, swaying circles around the tip, unhurried, patient, keeping a steady rhythm.

Desire builds. Yet it does not climb like a rigid ladder; it rolls in waves like the tide. A swell, a brief plateau, a deep breath. I understand that this body cannot be rushed. If I press too hard or hurry, the sensation retreats. But when I yield to the rhythm, rocking my pelvis gently against my fingers, chamber after chamber unlocks.

My pelvic floor muscles engage involuntarily, holding the fullness and letting go. Arousal radiates into my lower belly, my sacrum, and down through my thighs. My heart thumps against my ribs. My breath becomes ragged, shallow, and fast. A heat gathers that will no longer be reasoned with. I am approaching a threshold.

And then, the crest breaks.

A suspended heartbeat—and the contractions take hold. My pelvic floor muscles, the pubococcygeus and the tissues cradling the vaginal entrance, spasm in an exquisite, rhythmic pulse: every fraction of a second, an unmistakable beat of roughly 0.8 seconds. Squeeze. Release. Squeeze. Release. Six, eight, ten times in succession. Each contraction feels like an inner wringing of pure light and heat. My uterus contracts from its fundus down to the cervix—a deep, visceral grip that pulls a low gasp from my throat. It is no localized release; it is an earthquake rolling through my sacrum, my abdomen, and my entire nervous system, until my toes curl and my back arches from the mattress.

Slowly, the initial storm recedes. I sink back into the pillows, breathless.

Yet when my fingers brush the clitoris, I flinch: the small glans has turned acutely hypersensitive, almost painfully sharp to the touch. Any direct friction right now would be overwhelming. Instinctively, I adapt my touch. I do not pull away, but I shift: I place the soft heel of my hand over my pubic mound, brushing broadly across the outer labia, offering only a gentle, warming, rocking pressure.

And right here, the wonder of this body reveals itself: my arousal does not plummet. It lingers on a high, luminous plateau. The erectile tissues remain engorged. The blood continues to throb. And as I simply breathe and let the palm of my hand circle gently, I feel a second, entirely different wave gathering from deep within my womb.

It does not announce itself with sharp peaks, but as a vast, dark, oceanic roll. This time, it rises from deep inside the vagina and uterus. My pelvic floor grips again—broader, softer, and immeasurably deep. These are rolling waves of contractions that melt into one another, like water cresting over a weir. My entire conscious self dissolves for moments into this rolling, rhythmic surrender.

This is how many women experience it—not all, and not the same every time, for every body carries its own distinct rhythm. But the capacity and the vastness of these waves reside within every fiber of this flesh."""
        },
        {
            "szene": "return",
            "titel": "Settling and Returning",
            "text": """Gradually, the tremors subside into stillness.

A profound, golden warmth settles through my limbs. My breath turns long, even, and calm. Blood gently retreats from the inner erectile structures, and the muscles of my pelvic floor soften into complete ease. I lie there, sheltered, exhausted, and held by a quiet, untroubled peace.

Now, the moment has arrived to release this borrowed body. I take a deep breath in, inwardly offering my gratitude for the trust it granted me.

With my breath out, the reverse transformation begins.

Gently, organically: the fullness upon my chest melts away, my ribcage broadening again into a firm, flat expanse. My waist straightens, my hips narrow and ground themselves with familiar solidity on the mattress. Between my legs, the soft cradle of the vulva recedes; the familiar form and weight of my penis and scrotum return to their place.

I feel my own muscles once more, my own skin, my familiar lines. I have returned entirely to myself—safe, whole, and at home in my male body."""
        },
        {
            "szene": "afterglow",
            "titel": "Integration and Afterglow",
            "text": """I slowly open my eyes.

The room is the same as before. The soft lamp glow, the blanket, the hush of the night. And yet, something fundamental has shifted within me.

I have looked behind the veil. I have felt that a woman's desire is not an obstacle to be solved, nor a machine that starts on demand. It is an ocean of swells. Made of hidden erectile tissues that require unhurried time to awaken; of contractions that resonate through the whole core; and of a tender sensitivity that does not simply end after a climax, but asks to be held and cherished further.

I carry this understanding forward into my life and into my next touches: not as an expectation or a checklist, but as a quiet gift of patience and reverence.

I breathe in deeply one more time, draw the blanket up to my chin, and let the night gently take over."""
        }
    ]
}

# --- TEXTE: DEUTSCH (sehrspicy_frau) ---

SEHRSPICY_FRAU_DE = {
    "id": "sehrspicy_frau",
    "variante": "sehrspicy",
    "perspektive": "frau",
    "name": "Frau",
    "stimme": "victoria",
    "titel": "Wenn ich ein Mann werde: Erektion, Ejakulation und Refraktärzeit von innen",
    "segmente": [
        {
            "szene": "opening",
            "titel": "Ankommen im Abend",
            "text": """Ich liege auf dem Rücken.

Das Zimmer um mich her ist still. Nur das sanfte, bernsteinfarbene Licht einer kleinen Lampe wirft weiche Schatten an die Wand. Ich bin nackt und spüre die kühle Zimmerluft auf meinen Schultern, bevor die Bettdecke mich sanft umhüllt. Meine Arme liegen entspannt neben mir, meine Hände ruhen locker, die Handflächen nach oben geöffnet.

Nichts drängt mich. Ich muss niemandem gefallen, nichts beweisen und keine Erwartung erfüllen.

Ich höre meinen eigenen Atem. Ein langer, ruhiger Atemzug ein, und ein tiefes, lösendes Ausatmen. Ich darf einfach nur hier sein und mich mit offener, unvoreingenommener Neugier auf eine Erfahrung einlassen, die Frauen meist verborgen bleibt: wie es sich anfühlt, im Körper eines Mannes zu sein und das Geheimnis seiner intimsten Entladung von innen zu erleben."""
        },
        {
            "szene": "own_body",
            "titel": "Der vertraute Körper",
            "text": """Bevor ich diese Schwelle überschreite, spüre ich meinen eigenen, vertrauten Körper.

Ich nehme wahr, wie sich meine Brüste mit jedem Atemzug sanft heben und senken. Ich spüre die weiche Rundung meiner Hüften, das vertraute Einsinken meines Beckens in die Matratze, die glatte Haut an meinen Oberschenkeln. Das ist meine Heimat. Ich weiß, wie sich Berührungen auf dieser Haut anfühlen, wo meine Lust wohnt und wie mein Körper auf Zärtlichkeit antwortet.

Ich schließe die Augen.

Hier bin ich geborgen. Und genau aus dieser Gewissheit heraus erlaube ich mir nun, mich zu verwandeln. Ich lasse die Stirn glatt werden, lasse meinen Atem bis tief in den Bauch hinabfließen und öffne die Tür zu einer neuen Erfahrung."""
        },
        {
            "szene": "other_door",
            "titel": "Die Verwandlung",
            "text": """Dann geschieht es.

Ein leises Kribbeln breitet sich von meinem Brustbein aus, zieht über meinen Rücken und durch meine Arme und Beine. Mein Körper beginnt sich umzuformen – ruhig, kraftvoll und beinahe selbstverständlich.

Meine Schultern werden breiter, die Muskeln meines Nackens und meiner Arme gewinnen spürbar an Dichte und Spannkraft. Meine Brüste weichen zurück; mein Brustkorb dehnt sich zu einer flachen, festen Ebene aus. Meine Taille verliert ihre weiche Kurve, wird gerader, kompakter, und mein Körperschwerpunkt wandert ein Stück nach oben in den Rumpf.

Und dann bemerke ich die Veränderung zwischen meinen Beinen.

Da ist plötzlich ein neues, ungewohntes Gewicht – etwas Freies, Bewegliches, das zwischen meinen Oberschenkeln ruht. Meine Hand gleitet vorsichtig nach unten. Meine Finger berühren den weichen Schaft eines Penis und darunter die feine, bewegliche Haut des Hodensacks mit den beiden tastbaren Hoden darin.

Ich schlage die Augen auf und blicke an mir hinunter. Der Gedanke überrascht mich nicht mehr:

Ich bin ein Mann. Ich betrachte diesen Körper nicht von außen – ich bewohne ihn in jeder Faser."""
        },
        {
            "szene": "other_body",
            "titel": "Erektion, Emission und Ejakulation",
            "text": """Ich bleibe liegen und spüre dieser neuen Anatomie nach.

Sie ist erstaunlich lebendig und reagiert unmittelbar auf jeden Impuls. Als die kühle Luft über meinen Unterbauch streicht, bemerke ich, wie sich die feine Muskulatur des Hodensacks zusammenzieht und die Hoden schützend dichter an meinen Körper heranzieht. Ein eigenständiger, unwillkürlicher Reflex.

Dann setzt ein Gedanke ein, eine kleine Berührung meiner Finger an der Innenseite meines Oberschenkels – und eine körperliche Kettenreaktion beginnt.

Tief in meinem Becken entspannt sich die glatte Muskulatur der Gefäßwände. Ein starker, pulsierender Blutstrom flutet in die beiden Schwellkörper meines Penis, die Corpora cavernosa. Ich spüre von innen heraus, wie das Gewebe sich füllt, wie es fester, schwerer und heißer wird. Der Penis richtet sich auf, wächst in die Länge und spannt sich steil gegen meinen Unterbauch. Auch die Eichel an der Spitze füllt sich mit Blut, wird prall, glänzt feucht an der Mündung und entfaltet eine ungeheure Empfindsamkeit.

Meine Hand schließt sich um den Schaft. Das Gefühl ist atemberaubend neu: Die Haut ist samtig und gleitet über das feste, pulsierende Gewebe darunter. Als ich beginne, meine Hand langsam auf und ab zu bewegen, über den Schaft bis hinauf über den empfindlichen Kranz der Eichel, jagt ein elektrisierender Impuls durch mein Becken. Am feinen Bändchen an der Unterseite brennt eine intensive, süße Lust.

Die Erregung nimmt rasch an Dichte zu. Sie ist fokussiert, drängend und geradlinig. Mein Herz pocht mir bis in den Hals, mein Atem geht stoßweise. Meine Beckenbodenmuskeln spannen sich an; meine Hoden ziehen sich fest an die Wurzel meines Gliedes heran. Es ist eine unerbittliche Dringlichkeit, die sich wie in einem Brennglas sammelt. Meine Hand bewegt sich schneller, die Reibung wird rhythmischer, die Hitze im Becken unerträglich schön.

Und dann erreiche ich die erste Schwelle: die Emission.

Tief in meinem Becken, hinter dem Schambein und um meine Prostata herum, zieht sich die innere Muskulatur zusammen. Die Samenleiter ziehen sich zusammen, die Samenblasen und die Prostata entleeren ihre Sekrete in den hinteren Abschnitt der Harnröhre. Im selben Bruchteil einer Sekunde schließt sich der innere Blasenschließmuskel fest ab. Ich spüre ein tiefes, dumpfes Füllegefühl im Dammbereich – und das überwältigende Bewusstsein: Das ist der Punkt ohne Wiederkehr. Mein Körper übernimmt die absolute Kontrolle. Jetzt gibt es kein Halten mehr. Es geschieht.

Im nächsten Herzschlag folgt die Expulsion – die Entladung.

Meine Beckenbodenmuskeln, vor allem der Musculus bulbospongiosus an der Basis meines Gliedes, beginnen kraftvoll und unerbittlich zu pumpen. Alle 0,8 Sekunden zieht sich der Muskel mit berauschender Wucht zusammen: Eins. Zwei. Drei. Mit jedem Stoß spüre ich, wie die Samenflüssigkeit in kräftigen Schüben durch die Harnröhre nach vorne getrieben wird und meinen Körper verlässt.

Und gleichzeitig explodiert mein Kopf: Eine gewaltige Flutwelle aus Dopamin und Endorphinen überrollt mein Bewusstsein. Mein Atem stockt, meine Augen schließen sich krampfhaft, mein Becken bäumt sich gegen meine Hand auf. Jeder einzelne Nerv der Eichel entlädt sich in reiner, schwindelerregender Erlösung. Eine ungeheuer dichte, existenzielle Entladung, die mich für einige Sekunden vollkommen aus Zeit und Raum reißt.

Vier, fünf kräftige Kontraktionen, gefolgt von einigen sanfteren Nachzuckungen. Dann fällt die Spannung ab.

Ich sinke zurück in die Kissen. Mein Brustkorb hebt und senkt sich heftig. Mein Glied pocht noch, feucht und heiß, in meiner Hand.

So erleben es viele Männer: zielgerichtet, mächtig, unausweichlich im Scheitelpunkt. Orgasmus und Ejakulation fallen hier meist zusammen, auch wenn das eine der seelische Rausch und das andere der körperliche Reflex ist."""
        },
        {
            "szene": "return",
            "titel": "Refraktärzeit und Rückkehr",
            "text": """Und nun erlebe ich den zweiten, vielleicht tiefsten Teil dieser Reise: die Refraktärphase.

Fast augenblicklich verändert sich mein Körper. Eine Welle von Prolaktin flutet mein Blut, und mit ihr eine schwere, bleierne Müdigkeit und Ruhe. Das Blut weicht aus den Schwellkörpern; mein Glied verliert seine Festigkeit, wird weich und zieht sich zusammen.

Doch vor allem: Die Eichel wird mit einem Schlag überempfindlich. Jede Berührung, die eben noch pure Ekstase war, fühlt sich jetzt überreizt, elektrisch und fast unangenehm an. Ich muss meine Hand wegnehmen.

In meinem Kopf kehrt eine vollkommene, fast nüchterne Stille ein. Jede sexuelle Erregbarkeit ist für diesen Moment wie ausgelöscht. Und ich begreife mit dem Herzen: Das ist keine Kälte. Kein emotionaler Rückzug von mir, kein Mangel an Liebe. Es ist die Biologie des Mannes, die seinem Nervensystem und seinem Herzen eine zwingende, heilsame Erholungspause schenkt. Er kann jetzt nicht mehr wollen – aber er sehnt sich nach Nähe, nach Wärme und nach einem ruhigen Ankuscheln.

Mit dieser tiefen Einsicht lasse ich den männlichen Körper nun dankbar los. Ich atme lange aus, und die Rückverwandlung setzt ein.

Die breiten Schultern weichen zurück, mein Brustkorb sinkt, und das vertraute, warme Gewicht meiner eigenen Brüste kehrt auf meine Brust zurück. Meine Taille findet ihre weiche Rundung wieder, mein Becken schmiegt sich wieder sanft in die Kissen. Zwischen meinen Beinen verschwindet das Gewicht; meine eigene, wohlige Vulva nimmt ihren angestammten Platz wieder ein.

Ich spüre wieder meine Haut, mein eigenes Becken, meinen vertrauten Atem. Ich bin wieder ganz und heil bei mir selbst angekommen."""
        },
        {
            "szene": "afterglow",
            "titel": "Nachklang und Integration",
            "text": """Ich schlage die Augen auf.

Das Zimmer liegt friedlich da. Das warme Licht, die Decke, die Stille.

Doch ich sehe Männer und ihre Sexualität nun mit ganz anderen Augen. Ich habe gespürt, wie verwundbar eine Erektion ist – kein Werkzeug, sondern eine sensible Antwort des Kreislaufs. Ich habe die Wucht des Punktes ohne Wiederkehr erlebt, die Schübe der Entladung – und ich habe verstanden, warum der Mann danach diese Stille braucht, um wieder zu Atem zu kommen.

Ich nehme dieses Mitgefühl mit. Die Gewissheit, dass unter der sichtbaren Kraft eine zarte Natur liegt, die wie meine eigene nach Verstehen und Geborgenheit sucht.

Ich kuschele mich tiefer in meine Kissen, atme ruhig durch und lasse mich in einen tiefen, friedlichen Schlaf gleiten."""
        }
    ]
}

# --- TEXTE: ENGLISCH (sehrspicy_frau) ---

SEHRSPICY_FRAU_EN = {
    "id": "sehrspicy_frau",
    "variante": "sehrspicy",
    "perspektive": "frau",
    "name": "Woman",
    "stimme": "victoria",
    "titel": "When I Become a Man: Erection, Ejaculation, and the Refractory Phase from Within",
    "segmente": [
        {
            "szene": "opening",
            "titel": "Arriving into the Evening",
            "text": """I am lying on my back.

The room around me is quiet. Only the gentle, amber glow of a small lamp casts soft shadows on the wall. I am naked, feeling the cool air against my shoulders before the blanket wraps me in warmth. My arms rest easily beside me, my hands open, palms facing upward.

Nothing presses upon me. I have nothing to prove, no expectations to meet, and no one to please.

I listen to my breath. A slow, steady breath in, and a deep, releasing breath out. I am allowed simply to be here, opening myself with quiet, unhurried curiosity to an experience that remains largely mysterious to women: what it feels like to inhabit a man's body and experience the secret of his most intimate release from within."""
        },
        {
            "szene": "own_body",
            "titel": "The Familiar Body",
            "text": """Before I cross this threshold, I tune into my own, familiar body.

I notice my breasts gently rising and falling with each breath. I feel the soft curve of my hips, the familiar cradle of my pelvis against the mattress, the smooth warmth of my thighs. This is my home. I know how touch registers on this skin, where my pleasure resides, and how my body responds to tenderness.

I close my eyes.

Here, I am safe and complete. And from this very assurance, I grant myself permission to transform. I smooth the tension from my brow, breathe deeply into my belly, and open the door to a new reality."""
        },
        {
            "szene": "other_door",
            "titel": "The Transformation",
            "text": """Then, it happens.

A subtle tingling radiates from my breastbone, traveling down my spine and through my limbs. My body begins to reshape itself—quietly, powerfully, with an organic certainty.

My shoulders broaden; the musculature of my neck and arms gains noticeable density and firmness. My breasts draw back; my chest flattens and expands into a solid, muscular plane. My waist sheds its soft curve, becoming straighter, more compact, and my center of gravity rises slightly into my torso.

And then I register the change between my legs.

Suddenly, there is a new, unfamiliar weight—something free, suspended, and resting between my thighs. My hand slides down tentatively. My fingers encounter the soft shaft of a penis and, cradled beneath it, the delicate skin of the scrotum holding two distinct testes.

I open my eyes and look down along my form. The realization carries no doubt:

I am a man. I am not observing him from without—I inhabit this body down to every fiber."""
        },
        {
            "szene": "other_body",
            "titel": "Erection, Emission, and Ejaculation",
            "text": """I lie still, discovering this new anatomy.

It is remarkably alive, responding instantly to subtle shifts. As the cooler air brushes over my lower abdomen, I feel the fine dartos muscle of the scrotum tighten, drawing the testes closer to my body in a protective reflex. An involuntary, self-regulating reaction to temperature.

Then, a thought stirs, accompanied by the graze of my fingers along the inside of my thigh—and a physical cascade ignites.

Deep in my pelvis, the smooth muscles of the arterial walls relax. A rich, pulsing surge of blood floods into the twin erectile chambers of my penis, the corpora cavernosa. From within, I feel the tissue engorging, growing heavier, firmer, and hot. The penis rises, extending in length and lifting tautly against my lower belly. The glans at the crown expands, glistening moistly at the slit, awakening into intense, electrifying sensitivity.

My hand wraps around the shaft. The sensation is startlingly new: the skin is velvet-soft, gliding effortlessly over the firm, throbbing core beneath. As I begin to stroke slowly along the length and over the sensitive ridge of the corona, a sharp electric pulse shoots through my pelvis. Along the frenulum on the underside, a sweet, piercing pleasure flares.

Arousal gathers momentum rapidly. It is focused, urgent, linear. My heart pounds in my ears, my breathing turns shallow and breathless. My pelvic floor muscles tense; my testes pull up tight against the base of my shaft. It is an unyielding urgency, focusing like light through a prism. My hand moves faster, the rhythm tightens, and the heat in my pelvis turns into an overwhelming demand.

And then I reach the first threshold: emission.

Deep inside my pelvis, behind the pubic bone and around my prostate, the internal musculature contracts. The vas deferens squeeze rhythmically; the seminal vesicles and prostate gland discharge their fluids into the posterior urethra. In that identical fraction of a second, the internal bladder neck clamps shut. I feel a deep, heavy fullness in the perineum—and the absolute awareness: this is the point of no return. Ejaculatory inevitability. My body has seized complete command. There is no stopping it now. It is happening.

On the very next heartbeat follows expulsion—the release itself.

My pelvic floor muscles, especially the bulbospongiosus at the base of my penis, begin pumping with relentless power. Every 0.8 seconds, the muscle clenches with breathtaking force: One. Two. Three. With every contraction, I feel the seminal fluid driven forward through the urethra in forceful, pulsing surges, escaping my body.

And simultaneously, my mind explodes: a colossal surge of dopamine and endorphins engulfs my awareness. My breath catches, my eyes shut tight, my pelvis arches up against my hand. Every nerve along the glans discharges in pure, dizzying relief. It is an exquisitely concentrated, existential unraveling that tears me clean out of time and space for several suspended seconds.

Four, five powerful contractions, followed by gentler, lingering twitches. Then, the tension breaks.

I collapse back into the pillows, my chest heaving. My shaft still throbs, damp and hot, within my slackening hand.

This is how many men experience it: singular, powerful, unavoidable at its peak. Climax and ejaculation uniting in a single instant, even though one is the psychological rapture and the other the somatic reflex."""
        },
        {
            "szene": "return",
            "titel": "The Refractory Phase and Return",
            "text": """And now I encounter the second, perhaps most revealing chapter of this journey: the refractory phase.

Almost instantly, my body shifts. A wave of prolactin saturates my bloodstream, bringing with it a heavy, leaden peace and quietude. Blood ebbs from the erectile tissues; my shaft loses its firmness, shrinking back into soft vulnerability.

Above all: the glans becomes acutely hypersensitive in a single beat. Any touch that moments ago felt like ecstasy now registers as overstimulated, sharp, and uncomfortable. I have to pull my hand away.

A calm, sober stillness falls over my thoughts. All sexual drive is momentarily extinguished, as if snuffed out by biology. And with my heart, I understand: this is not emotional withdrawal. It is not coldness or a loss of love. It is the male physiology granting his nervous system and cardiovascular core a necessary, restorative grace period. He can no longer desire right now—yet he craves warmth, comfort, and the quiet shelter of simply lying close.

Holding this profound revelation, I release the male body with gratitude. I breathe out deeply, and the return begins.

The broad shoulders ease away, my ribcage settles, and the familiar, warm weight of my own breasts returns to my chest. My waist softens into its familiar curve; my hips cradle into the mattress. Between my legs, the external presence dissolves; my own comforting vulva resumes its cherished place.

I feel my own skin again, my own pelvis, my steady breath. I have arrived back home—safe, whole, and at peace within myself."""
        },
        {
            "szene": "afterglow",
            "titel": "Afterglow and Integration",
            "text": """I open my eyes.

The room lies in peaceful silence. The warm lamp, the duvet, the tranquil night.

Yet I perceive men and their sexuality with completely transformed eyes. I have felt the vulnerability of an erection—not a mechanical tool, but a delicate vascular balance. I have experienced the visceral surge of the point of no return, the pulsing power of the release—and I understand why a man needs that subsequent stillness to find himself again.

I carry this compassion with me. The certainty that beneath the visible strength lies a tender nature that, just like mine, longs for understanding, patience, and warmth.

I nestle deeper into my pillows, breathe softly, and let myself drift into a deep, peaceful sleep."""
        }
    ]
}


def erzeuge_dateien():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    
    fassungen = [
        ("sehrspicy_mann", "de", SEHRSPICY_MANN_DE),
        ("sehrspicy_mann", "en", SEHRSPICY_MANN_EN),
        ("sehrspicy_frau", "de", SEHRSPICY_FRAU_DE),
        ("sehrspicy_frau", "en", SEHRSPICY_FRAU_EN)
    ]
    
    statistik = []
    
    for fassungs_id, lang, daten in fassungen:
        # JSON schreiben
        json_pfad = OUT_DIR / f"{fassungs_id}.{lang}.json"
        json_pfad.write_text(json.dumps(daten, indent=2, ensure_ascii=False), encoding='utf-8')
        
        # Markdown schreiben
        md_pfad = OUT_DIR / f"{fassungs_id}.{lang}.md"
        gesamt_text = []
        gesamt_text.append(f"# {daten['titel']}\n")
        gesamt_text.append(f"**ID:** `{daten['id']}` | **Variante:** `{daten['variante']}` | **Perspektive:** `{daten['perspektive']}` | **Stimme:** `{daten['stimme']}`\n")
        
        zeichen_summe = 0
        worte_summe = 0
        
        for seg in daten['segmente']:
            szene = seg['szene']
            titel = seg.get('titel', szene)
            text = seg['text']
            z_len = len(text)
            w_len = len(text.split())
            zeichen_summe += z_len
            worte_summe += w_len
            gesamt_text.append(f"## Szene: `{szene}` – {titel}\n*({z_len} Zeichen, ca. {w_len} Wörter)*\n\n{text}\n")
            
        md_pfad.write_text("\n".join(gesamt_text), encoding='utf-8')
        
        # Vorlesezeit (ca. 130 Wörter pro Minute im ruhigen, meditativen Audiostil)
        minuten = worte_summe / 130.0
        statistik.append({
            "id": fassungs_id,
            "lang": lang,
            "titel": daten['titel'],
            "stimme": daten['stimme'],
            "zeichen": zeichen_summe,
            "woerter": worte_summe,
            "dauer_min": round(minuten, 1),
            "daten": daten
        })
        
    erzeuge_index_md(statistik)
    erzeuge_vergleich_html(statistik)
    print("Alle Entwürfe, Index und Vergleichsansicht erfolgreich generiert.")


def erzeuge_index_md(statistik):
    zeilen = [
        "# Entwürfe: Sehr spicy in „Der andere Körper“",
        "",
        "Stand: 01.11.2026. Entwürfe für die beiden neuen Fassungen der Folge `der_andere_koerper` in der Audioreihe *Innenansichten*.",
        "",
        "## Übersicht der Entwürfe",
        "",
        "| ID | Sprache | Stimme | Zeichen | Wörter | Richtwert Dauer | JSON | Lese-Entwurf |",
        "|---|---|---|---|---|---|---|---|"
    ]
    for s in statistik:
        fid = s['id']
        flang = s['lang']
        json_file = f"{fid}.{flang}.json"
        md_file = f"{fid}.{flang}.md"
        zeilen.append(f"| `{fid}` | **{flang.upper()}** | `{s['stimme']}` | {s['zeichen']} | {s['woerter']} | ca. {s['dauer_min']} Min | [`{json_file}`]({json_file}) | [`{md_file}`]({md_file}) |")
        
    zeilen.extend([
        "",
        "## Visuelle Textabnahme im Browser",
        "",
        "Für die komfortable Prüfung der Texte steht die interaktive HTML-Ansicht bereit:",
        "- **[VERGLEICH.html](VERGLEICH.html)** (öffnet direkt lokal im Browser: zweisprachig, Szenenvergleich, physiologische Anmerkungen).",
        "",
        "## Leitplanken-Abgleich",
        "",
        "1. **Ich-Form eingehalten:** Alle Texte sind konsequent aus der Ich-Perspektive der erlebenden Person geschrieben.",
        "2. **Sechs Szenen:** `opening`, `own_body`, `other_door`, `other_body`, `return`, `afterglow` in allen Fassungen.",
        "3. **Schwerpunkt `other_body`:** Detaillierte, sinnliche und anatomisch präzise Beschreibung der Erregung und des Höhepunkts (ca. 4.500–5.500 Zeichen).",
        "4. **Physiologie integriert:**",
        "   - *Frau:* Klitorisschwellkörper (Crura, Bulbi), Kontraktionstakt (0,8s), Uteruskontraktionen, Hypersensibilität der Glans, Wellen-Mehrfachorgasmus.",
        "   - *Mann:* Erektion von innen, Punkt ohne Wiederkehr (Emission), rhythmische Expulsion (0,8s) des M. bulbospongiosus, Dopamin-Rausch, Refraktärphase & Prolaktin.",
        "5. **Sinnlich und exakt, kein Dirty Talk:** Literarisch anspruchsvoll, keine Vulgärsprache.",
        "6. **Vollständige Rückverwandlung:** Beide Geschichten schließen mit einer sicheren, gleichwertigen Rückkehr in den eigenen Körper ab.",
        "7. **Englische Fassung:** Vollwertige literarische Übertragung."
    ])
    (OUT_DIR / "INDEX.md").write_text("\n".join(zeilen), encoding='utf-8')


def erzeuge_vergleich_html(statistik):
    stat_dict = {(s['id'], s['lang']): s for s in statistik}
    
    html_content = f"""<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Textabnahme: Sehr spicy in „Der andere Körper“</title>
<style>
  :root {{
    --bg: #141216;
    --card-bg: #1e1b22;
    --card-border: #2e2836;
    --text: #e6e1e8;
    --text-muted: #9e97a6;
    --accent: #d88998;
    --accent-light: #f3c2cc;
    --highlight: #2c2229;
    --font-serif: "Source Serif 4", Georgia, serif;
    --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  }}
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: var(--bg);
    color: var(--text);
    font-family: var(--font-sans);
    line-height: 1.6;
    padding: 2rem 1rem 4rem;
  }}
  .container {{
    max-width: 1200px;
    margin: 0 auto;
  }}
  header {{
    text-align: center;
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid var(--card-border);
  }}
  h1 {{
    font-family: var(--font-serif);
    font-size: 2.2rem;
    color: var(--accent-light);
    margin-bottom: 0.5rem;
  }}
  .subtitle {{
    color: var(--text-muted);
    font-size: 1.05rem;
  }}
  .tabs {{
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-bottom: 2rem;
  }}
  .tab-btn {{
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    color: var(--text);
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.2s;
  }}
  .tab-btn.active {{
    background: var(--accent);
    color: #141216;
    font-weight: 600;
    border-color: var(--accent);
  }}
  .meta-bar {{
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 8px;
    padding: 1rem 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
    margin-bottom: 2rem;
  }}
  .meta-badge {{
    background: rgba(216, 137, 152, 0.15);
    color: var(--accent-light);
    padding: 0.25rem 0.75rem;
    border-radius: 4px;
    font-size: 0.9rem;
  }}
  .content-view {{
    display: none;
  }}
  .content-view.active {{
    display: block;
  }}
  .scene-block {{
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 10px;
    margin-bottom: 2rem;
    overflow: hidden;
  }}
  .scene-header {{
    background: rgba(255, 255, 255, 0.03);
    padding: 1rem 1.5rem;
    border-bottom: 1px solid var(--card-border);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }}
  .scene-header h3 {{
    font-family: var(--font-serif);
    font-size: 1.25rem;
    color: var(--accent-light);
  }}
  .scene-cols {{
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1px;
    background: var(--card-border);
  }}
  @media (max-width: 800px) {{
    .scene-cols {{
      grid-template-columns: 1fr;
    }}
  }}
  .scene-col {{
    background: var(--card-bg);
    padding: 1.5rem;
  }}
  .lang-tag {{
    font-size: 0.8rem;
    font-weight: 700;
    text-transform: uppercase;
    color: var(--accent);
    margin-bottom: 0.75rem;
    letter-spacing: 0.05em;
  }}
  .scene-text {{
    font-family: var(--font-serif);
    font-size: 1.05rem;
    line-height: 1.75;
    white-space: pre-line;
    color: #ede8f0;
  }}
  .scene-stats {{
    font-size: 0.85rem;
    color: var(--text-muted);
  }}
  .guidelines-card {{
    background: var(--highlight);
    border: 1px solid var(--accent);
    border-radius: 8px;
    padding: 1.25rem;
    margin-bottom: 2rem;
  }}
  .guidelines-card h4 {{
    color: var(--accent-light);
    margin-bottom: 0.5rem;
  }}
  .guidelines-card ul {{
    padding-left: 1.25rem;
    color: var(--text);
    font-size: 0.95rem;
  }}
</style>
</head>
<body>
<div class="container">
  <header>
    <h1>Textabnahme: „Sehr spicy“ in „Der andere Körper“</h1>
    <p class="subtitle">Audioreihe <em>Innenansichten</em> – Entwürfe für Victoria (Frau) und Martin (Mann)</p>
  </header>

  <div class="tabs">
    <button class="tab-btn active" onclick="switchTab('mann')">Fassung für Hörer Mann: Martin (wie sich die Frau anfühlt)</button>
    <button class="tab-btn" onclick="switchTab('frau')">Fassung für Hörerin Frau: Victoria (wie sich der Mann anfühlt)</button>
  </div>

  <!-- TAB MANN -->
  <div id="tab-mann" class="content-view active">
    <div class="meta-bar">
      <div>
        <strong>Fassung:</strong> <code>sehrspicy_mann</code> | 
        <strong>Stimme:</strong> Martin | 
        <strong>Perspektive:</strong> Mann verwandelt sich in Frau
      </div>
      <div>
        <span class="meta-badge">DE: {stat_dict[('sehrspicy_mann', 'de')]['zeichen']} Zeichen (~{stat_dict[('sehrspicy_mann', 'de')]['dauer_min']} Min)</span>
        <span class="meta-badge">EN: {stat_dict[('sehrspicy_mann', 'en')]['zeichen']} Zeichen (~{stat_dict[('sehrspicy_mann', 'en')]['dauer_min']} Min)</span>
      </div>
    </div>

    <div class="guidelines-card">
      <h4>Physiologische Kernpunkte in dieser Fassung</h4>
      <ul>
        <li><strong>Schwellkörper-Netzwerk:</strong> Ausdehnung der Klitoris (Crura, Bulbi vestibuli) und Lubrikation der Scheidenwand.</li>
        <li><strong>Erster Orgasmus:</strong> Taktung der Kontraktionen von Beckenboden (M. pubococcygeus) und Uterus im ~0,8-Sekunden-Rhythmus.</li>
        <li><strong>Hypersensibilität & Anpassung:</strong> Die Glans clitoridis ist nach der Entladung extrem berührungsempfindlich; Wechsel zu flächigem, wiegendem Druck.</li>
        <li><strong>Wellen-Mehrfachorgasmus:</strong> Aufbau einer zweiten, tieferen Orgasmuswelle auf hohem Erregungsplateau.</li>
        <li><strong>Vollständige Rückverwandlung:</strong> Gleichwertiger, harmonischer Abschluss im eigenen Körper.</li>
      </ul>
    </div>
"""

    # Szenen für Mann rendern
    de_mann = stat_dict[('sehrspicy_mann', 'de')]['daten']
    en_mann = stat_dict[('sehrspicy_mann', 'en')]['daten']
    
    for i in range(len(de_mann['segmente'])):
        seg_de = de_mann['segmente'][i]
        seg_en = en_mann['segmente'][i]
        szene_id = seg_de['szene']
        titel_de = seg_de.get('titel', szene_id)
        titel_en = seg_en.get('titel', szene_id)
        
        html_content += f"""
    <div class="scene-block">
      <div class="scene-header">
        <h3>Szene {i+1}: <code>{szene_id}</code> – {html.escape(titel_de)}</h3>
        <span class="scene-stats">DE: {len(seg_de['text'])} Z. | EN: {len(seg_en['text'])} Z.</span>
      </div>
      <div class="scene-cols">
        <div class="scene-col">
          <div class="lang-tag">Deutsch (Martin)</div>
          <div class="scene-text">{html.escape(seg_de['text'])}</div>
        </div>
        <div class="scene-col">
          <div class="lang-tag">English (Martin)</div>
          <div class="scene-text">{html.escape(seg_en['text'])}</div>
        </div>
      </div>
    </div>
"""

    html_content += """
  </div>

  <!-- TAB FRAU -->
  <div id="tab-frau" class="content-view">
    <div class="meta-bar">
      <div>
        <strong>Fassung:</strong> <code>sehrspicy_frau</code> | 
        <strong>Stimme:</strong> Victoria | 
        <strong>Perspektive:</strong> Frau verwandelt sich in Mann
      </div>
      <div>
        <span class="meta-badge">DE: """ + str(stat_dict[('sehrspicy_frau', 'de')]['zeichen']) + """ Zeichen (~""" + str(stat_dict[('sehrspicy_frau', 'de')]['dauer_min']) + """ Min)</span>
        <span class="meta-badge">EN: """ + str(stat_dict[('sehrspicy_frau', 'en')]['zeichen']) + """ Zeichen (~""" + str(stat_dict[('sehrspicy_frau', 'en')]['dauer_min']) + """ Min)</span>
      </div>
    </div>

    <div class="guidelines-card">
      <h4>Physiologische Kernpunkte in dieser Fassung</h4>
      <ul>
        <li><strong>Erektion von innen:</strong> Tumeszenz der Corpora cavernosa, Aufrichten durch Gefäßentspannung und Bluteinstrom.</li>
        <li><strong>Phase 1: Emission („Punkt ohne Wiederkehr“):</strong> Glatte Muskulatur von Samenleitern, Samenblasen und Prostata entleert sich in die Harnröhre; Verschluss des inneren Blasensphinkters.</li>
        <li><strong>Phase 2: Expulsion (Ejakulation):</strong> Rhythmische Stöße des M. bulbospongiosus im 0,8s-Takt, Ausstoß der Samenflüssigkeit.</li>
        <li><strong>Zerebraler Rausch vs. Reflex:</strong> Dopamin-/Oxytocin-Flutwelle im Gehirn, die mit dem somatischen Reflex synchronisiert ist.</li>
        <li><strong>Refraktärphase & Prolaktin:</strong> Sofortige Überempfindlichkeit der Eichel, hormonelle Schutzdämpfung, heilsame Stille ohne Zurückweisung.</li>
      </ul>
    </div>
"""

    # Szenen für Frau rendern
    de_frau = stat_dict[('sehrspicy_frau', 'de')]['daten']
    en_frau = stat_dict[('sehrspicy_frau', 'en')]['daten']
    
    for i in range(len(de_frau['segmente'])):
        seg_de = de_frau['segmente'][i]
        seg_en = en_frau['segmente'][i]
        szene_id = seg_de['szene']
        titel_de = seg_de.get('titel', szene_id)
        titel_en = seg_en.get('titel', szene_id)
        
        html_content += f"""
    <div class="scene-block">
      <div class="scene-header">
        <h3>Szene {i+1}: <code>{szene_id}</code> – {html.escape(titel_de)}</h3>
        <span class="scene-stats">DE: {len(seg_de['text'])} Z. | EN: {len(seg_en['text'])} Z.</span>
      </div>
      <div class="scene-cols">
        <div class="scene-col">
          <div class="lang-tag">Deutsch (Victoria)</div>
          <div class="scene-text">{html.escape(seg_de['text'])}</div>
        </div>
        <div class="scene-col">
          <div class="lang-tag">English (Victoria)</div>
          <div class="scene-text">{html.escape(seg_en['text'])}</div>
        </div>
      </div>
    </div>
"""

    html_content += """
  </div>
</div>

<script>
function switchTab(tab) {
  document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
  document.querySelectorAll('.content-view').forEach(view => view.classList.remove('active'));
  
  if (tab === 'mann') {
    document.querySelectorAll('.tab-btn')[0].classList.add('active');
    document.getElementById('tab-mann').classList.add('active');
  } else {
    document.querySelectorAll('.tab-btn')[1].classList.add('active');
    document.getElementById('tab-frau').classList.add('active');
  }
}
</script>
</body>
</html>
"""
    (OUT_DIR / "VERGLEICH.html").write_text(html_content, encoding='utf-8')


if __name__ == '__main__':
    erzeuge_dateien()
