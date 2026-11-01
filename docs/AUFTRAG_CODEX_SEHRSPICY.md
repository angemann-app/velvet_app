# Auftrag für Codex: „Sehr spicy“ in „Der andere Körper“ (Innenansichten)

Stand: 01.11.2026, von Claude Code. Der Nutzer übergibt diese Aufgabe an Codex (Ausnahme „ChatGPT/Codex für Texte und Audios der Spicy-Folgen“, `CLAUDE.md`). Vor dem Start lesen: `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md` (Haupt-Checkout), und das Konzept im Worktree `C:\TOOLS\workspace\mojo\.claude\worktrees\design-magazin\docs\konzepte\lust-audioreihe.md`, Abschnitt „Nachtrag 01.11.2026: Sehr spicy in ‚Der andere Körper‘“ (ab Zeile 490, dort alle Entscheidungen und Leitplanken). Diese Datei dort nicht verändern.

## Ziel

Zwei neue, sehr spicy Fassungen der Übung „Der andere Körper“, Deutsch und Englisch, danach lokale Vertonung nach Textabnahme:

| Fassung | Hörer·in | Thema | Stimme | Beispieltext des Nutzers (Basis) |
|---|---|---|---|---|
| `sehrspicy_mann` | Mann | wie sich der Orgasmus der Frau anfühlt, gern mehrfach | Martin | `C:\TOOLS\workspace\mojo_innenansichten\sehr_spicy_frau.txt` („Wenn ich eine Frau werde“) |
| `sehrspicy_frau` | Frau | wie sich der Samenerguss des Mannes anfühlt | Victoria | `C:\TOOLS\workspace\mojo_innenansichten\sehr_spicy_mann.txt` („Wenn ich ein Mann werde“) |

Die App kennt die Variante `sehrspicy` bereits (Beta 57) und zeigt sie automatisch an, sobald das Paket `de-reihe` bzw. `en-reihe` Fassungen mit `"variante": "sehrspicy"` enthält. Es ist also **kein App-Code** zu ändern.

## Leitplanken (Nutzerentscheidungen, verbindlich)

1. Höhepunkte wirklich **erzählen**, nicht Abläufe aufzählen: Spannungsaufbau, Empfindungen, Wellen, Nachlassen unmittelbar miterleben.
2. Wissenschaft in die Erzählung integrieren; Anatomie und Physiologie stimmen, Fachbegriffe nur mit echtem Erkenntnisgewinn.
3. Beide Geschichten bekommen eine **vollständige Rückverwandlung** und sind dramaturgisch gleichwertig abgeschlossen (die Mann-wird-Frau-Geschichte hat sie noch nicht).
4. Ich-Form bleibt. Sechs Szenen: `opening`, `own_body`, `other_door`, `other_body`, `return`, `afterglow`; `other_body` darf deutlich länger sein.
5. **Sinnlich und exakt, kein Dirty Talk.** Der knappe Zusatz „so erleben es viele, nicht alle“ bleibt (keine Leistungsnorm). Kein Hinweistext vor der Folge.
6. Englisch **literarisch** übertragen, nicht wörtlich.
7. Keine künstliche Kürzung (Richtwert um 10.000 Zeichen, auch 20 Minuten Laufzeit sind in Ordnung).
8. Alle Figuren erwachsen, alles einvernehmlich. Orgasmus und Ejakulation unterscheiden (vgl. Diagramm-Konzept), Spannbreite des Erlebens zeigen.

## Schritte

1. **Recherche** mit Quellenangabe, im neuen Konzept `docs/konzepte/sehr-spicy-andere-koerper.md` festhalten: Phasen und Kontraktionstakt bei Frau und Mann, Rolle von Klitoris, Vagina, Beckenboden, Uterus; mehrfache Orgasmen (Sensibilität, Pausen, Unterschiede); Mann: Emission und Expulsion, Refraktärzeit.
2. **Textentwürfe** DE und EN je Fassung in der Szenenfolge, getrennt unter `build/redaktion/sehrspicy/` (wie beim Spicy-Lektorat). Produktionsquellen (`C:\TOOLS\velvet-inhalte\reihe\`, `reihe.json`) bis zur Abnahme nicht ändern. Struktur und Feldnamen der bestehenden Spicy-Fassungen in `reihe.json` übernehmen.
3. **Textabnahme durch den Nutzer** (Vergleich als HTML wie beim Lektorat). Erst danach weiter.
4. **Vertonung lokal** (Kokoro, `tools/generate_audio.py`, Ausdrucksweg `tools/reihe_ausdruck.py`, Hörprobe vor der ganzen Folge). Neue Folgen in `reihe_ausdruck.AUSDRUCK_LEKTIONEN` eintragen, Aussprache in `tools/aussprache.json`.
5. Nach Abnahme der Aufnahmen: Texte in `reihe.json`, Aufnahmen und `dauer.json` ins Paket, `de-reihe` und `en-reihe` in `tools/pakete/versionen.json` hochzählen, **lokal bauen**, nicht hochladen.

## Nicht tun

- Keine Bilder oder Motive erzeugen oder an Cloud-Modelle geben (Szenenbilder teilt die Variante mit Spicy: `bilder/<folge>_spicy_<szene>.webp`).
- Nichts hochladen, veröffentlichen oder releasen; das macht Claude Code nach Freigabe des Nutzers.
- Keine Schlüssel oder Zugangsdaten anfassen; die Beispieltexte nicht überschreiben, Änderungen als Entwürfe ablegen.
- Dateien in `C:\TOOLS\velvet-inhalte` und `mojo_innenansichten` nur nach dem Signal des Nutzers an Claude zum Lesen übergeben (Regel in `CLAUDE.md`).
- Nicht im Haupt-Checkout Branch wechseln, wenn dort gerade ein Release läuft; eigenen Branch `codex/sehrspicy` anlegen.

## Übergabe

Eintrag in `docs/ZUSAMMENARBEIT_CODEX_CLAUDE.md` mit Ausgangsstand, Dateien, Quellen, Prüfungen, offenen Fragen und Abnahmestatus. Rückfragen zu offenen Punkten an den Nutzer, nicht raten. Zeitplan des Nutzers: Texte am Dienstag, 03.11.2026.
