"""Ausdrucksprofil für die Audioreihe „Innenansichten“ (docs/konzepte/lust-audioreihe.md).

Kokoro kennt keine Gefühlsregler. Was sich steuern lässt, ist Tempo und Pause je Satz. Das Profil nimmt
das Tempo in ruhigen Szenen zurück, lässt den Atem im Höhepunkt zuerst schneller werden und danach ausklingen,
spricht kurze Sätze und wörtliche Rede etwas langsamer und gibt ihnen mehr Raum. Die Erzählung bleibt
zusammenhängend: zwischen Sätzen liegen nur kurze, natürliche Lücken, keine künstlichen Pausen.

Gilt nur für die Reihe; alle anderen Aufnahmen behalten ihr Tempo.
"""
import re

# Ändert sich das Profil, ändert sich die Prüfsumme der Aufnahmen und sie werden neu gesprochen.
PROFIL = "ausdruck-1"

# Tempo relativ zum Grundtempo der Stimme.
SZENE = {
    "opening": 1.05,
    "attraction": 1.02,
    "first_contact": 1.02,
    "building_desire": 0.97,
    "climax": 1.0,
    "afterglow": 0.92,
}

SATZ_LUECKE_S = 0.18
ABSATZ_LUECKE_S = 0.6
KURZ_LUECKE_S = 0.42
REDE_LUECKE_S = 0.5

_REDE = re.compile(
    r"\b(sagt|sagst|fragt|fragst|flüstert|flüsterst|bittet|bittest|ruft|sagte|"
    r"says|asks|whispers|you say|you ask|she says|he says|she asks|he asks|she whispers|you whisper|you ask)\b",
    re.IGNORECASE,
)


def _saetze(absatz):
    return [s.strip() for s in re.split(r"(?<=[.!?])\s+", absatz.strip()) if s.strip()]


def _kurve(szene, p):
    """Tempofaktor über den Verlauf einer Szene (p von 0 bis 1)."""
    if szene == "climax":
        if p < 0.55:
            return 1.0 + 0.07 * (p / 0.55)  # der Atem wird schneller
        if p < 0.75:
            return 0.9  # der Moment selbst
        return 0.9 - 0.06 * ((p - 0.75) / 0.25)  # ausklingen
    if szene == "building_desire":
        return 1.0 - 0.05 * p
    if szene == "afterglow":
        return 1.0 - 0.04 * p
    return 1.0


def plan(szene, text, grundtempo):
    """Liste von (Satz, Tempo, Lücke danach in Sekunden) für eine Szene."""
    absaetze = [a for a in text.split("\n") if a.strip()]
    saetze = [(s, i == len(_saetze(a)) - 1) for a in absaetze for i, s in enumerate(_saetze(a))]
    n = max(len(saetze) - 1, 1)
    ergebnis = []
    for k, (satz, absatzende) in enumerate(saetze):
        faktor = SZENE.get(szene, 1.0) * _kurve(szene, k / n)
        luecke = SATZ_LUECKE_S
        wortzahl = len(satz.split())
        if _REDE.search(satz) or wortzahl <= 4:
            faktor *= 0.93
            luecke = REDE_LUECKE_S if _REDE.search(satz) else KURZ_LUECKE_S
        elif wortzahl <= 7:
            faktor *= 0.96
        if absatzende:
            luecke = max(luecke, ABSATZ_LUECKE_S)
        ergebnis.append((satz, round(grundtempo * faktor, 3), luecke))
    return ergebnis
