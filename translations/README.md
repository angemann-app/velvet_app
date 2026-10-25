# Translating VelvetPulse / VelvetPulse übersetzen

[English](#english) · [Deutsch](#deutsch) · Progress / Fortschritt: [STATUS.md](STATUS.md)

> VelvetPulse contains adult content about sexuality (sex education with a therapeutic background).
> VelvetPulse enthält Inhalte über Sexualität für Erwachsene (Sexualaufklärung mit therapeutischem Hintergrund).

<a id="english"></a>
## English

Every text of the app is a separate entry in a translation file in the standard **PO format**: the German
original, a short note on where it appears, the English version as a help, and an empty field for your
translation. You work through them in order, and [STATUS.md](STATUS.md) shows how much of each language is done.

### The files

| Area | Template | Your language |
|---|---|---|
| Interface (buttons, menus, messages) | [po/oberflaeche/oberflaeche.pot](po/oberflaeche/oberflaeche.pot) | `po/oberflaeche/<code>.po` |
| Courses and lessons | [po/kurse/kurse.pot](po/kurse/kurse.pot) | `po/kurse/<code>.po` |
| Yes/no/maybe list and fantasy cards | [po/ja_nein/ja_nein.pot](po/ja_nein/ja_nein.pot) | `po/ja_nein/<code>.po` |
| Guided self-exploration (audio blocks) | [po/selbst_reise/selbst_reise.pot](po/selbst_reise/selbst_reise.pot) | `po/selbst_reise/<code>.po` |
| Drift-off journey (audio blocks) | [po/einschlaf_reise/einschlaf_reise.pot](po/einschlaf_reise/einschlaf_reise.pot) | `po/einschlaf_reise/<code>.po` |
| An evening together (audio blocks) | [po/paar_abend/paar_abend.pot](po/paar_abend/paar_abend.pot) | `po/paar_abend/<code>.po` |
| In-app guide | [po/anleitung/anleitung.pot](po/anleitung/anleitung.pot) | `po/anleitung/<code>.po` |
| What's new (after updates) | [po/neuigkeiten/neuigkeiten.pot](po/neuigkeiten/neuigkeiten.pot) | `po/neuigkeiten/<code>.po` |
| Photo ideas (spicy mode) | [po/foto_ideen/foto_ideen.pot](po/foto_ideen/foto_ideen.pot) | `po/foto_ideen/<code>.po` |

A good order: the interface first, then the guide, then the courses one by one. Partial translations are
welcome – a language can grow over time.

### Step by step

1. **Open an issue** with the [translation template](../../../issues/new?template=translation.md), so others
   know which language is being worked on.
2. **Get the files.** If your language already has `<code>.po` files (e.g. `fr.po`), use those. Otherwise
   download the `.pot` templates; when you open one in [Poedit](https://poedit.net) (free), choose
   *Create new translation* and your language, and save it as `<code>.po` next to the template.
3. **Translate.** Poedit shows the German original, the note and the English version (lines starting with
   `EN:`) for each entry. Type your translation into the empty field. You can stop at any time.
4. **Send it back:** open a pull request with your `.po` files, or attach them to your issue if you don't use
   Git. We take care of the rest.

You can also use any text editor: fill in the `msgstr ""` below each `msgid`.

### What to keep unchanged

- Everything except the translation itself: `msgctxt` (the key) and `msgid` (the German text) stay as they are.
- Placeholders such as `{name}` or `{count}`, and the structure of plural forms such as
  `{count, plural, =1{…} other{…}}` – translate only the words inside the braces.
- Name placeholders in lessons such as `{W:she}` or `{P:your partner}`: keep the letter and colon, translate
  the rest (`{W:elle}`). More guidelines: [CONTRIBUTING.md](../CONTRIBUTING.md#translation-guidelines).

### When the German text changes

The translation is then marked as **fuzzy** (outdated) and counted as *outdated* in [STATUS.md](STATUS.md).
Poedit lists fuzzy entries separately; once you've reviewed or updated one, the mark disappears.

### For maintainers

```bash
flutter test test/uebersetzung_test.dart --dart-define=PO=neu --dart-define=LANG=fr   # start a new language
flutter test test/uebersetzung_test.dart --dart-define=PO=sync                        # import .po, refresh templates and status
```

`sync` writes the translations into `translations/<code>/` (same layout as `translations/en/`, the interface as
`oberflaeche.arb`), refreshes all templates and PO files and regenerates [STATUS.md](STATUS.md). The normal
test run fails if any of them is out of date. English is maintained directly in `translations/en/` and
`lib/l10n/app_en.arb`, not via PO files. Once a language is complete enough, it is built into the app.

<a id="deutsch"></a>
## Deutsch

Jeder Text der App ist ein eigener Eintrag in einer Übersetzungsdatei im Standardformat **PO**: das deutsche
Original, ein kurzer Hinweis, wo er vorkommt, die englische Fassung als Hilfe und ein leeres Feld für die
Übersetzung. Man arbeitet sie der Reihe nach ab, und [STATUS.md](STATUS.md) zeigt, wie weit jede Sprache ist.

**So geht es:**

1. **Issue eröffnen** mit der [Vorlage für Übersetzungen](../../../issues/new?template=translation.md), damit
   andere wissen, an welcher Sprache gearbeitet wird.
2. **Dateien holen.** Gibt es für die Sprache schon `<code>.po`-Dateien (z. B. `fr.po`), diese nehmen. Sonst
   die `.pot`-Vorlagen aus der Tabelle oben herunterladen, in [Poedit](https://poedit.net) (kostenlos) öffnen,
   *Neue Übersetzung erstellen* wählen und als `<code>.po` neben der Vorlage speichern.
3. **Übersetzen.** Poedit zeigt zu jedem Eintrag das deutsche Original, den Hinweis und die englische Fassung
   (Zeilen mit `EN:`). Die Übersetzung ins leere Feld schreiben, aufhören geht jederzeit.
4. **Zurückschicken:** als Pull Request mit den `.po`-Dateien, oder ohne Git einfach ans Issue anhängen.

Unverändert bleiben `msgctxt` und `msgid`, Platzhalter wie `{name}` und die Form von Pluralangaben
(`{count, plural, …}`), bei Namens-Platzhaltern wie `{W:sie}` Buchstabe und Doppelpunkt. Ändert sich später
ein deutscher Text, wird die Übersetzung als **fuzzy** (überholt) markiert und in [STATUS.md](STATUS.md) als
überholt gezählt, bis sie durchgesehen ist.
