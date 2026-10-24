# Contributing to VelvetPulse

Thank you for wanting to help! The most welcome contribution right now is a **translation into your language**.

## Translating the content

All of VelvetPulse's content – 25 courses, 96 lessons, guided sessions and lists – exists in German
(the original) and in English ([translations/en](translations/en/)). We'd love to add more languages:
French, Spanish, Dutch, Italian, Polish, Portuguese … whatever you speak well.

You don't need to be a developer. If you can edit a text file, you can help.

### How to start

1. **Open an issue** with the [translation template](../../issues/new?template=translation.md) so others know
   which language is being worked on and nobody duplicates work.
2. **Fork the repository** and copy the English folder as a starting point:
   `translations/en/` → `translations/<code>/` (e.g. `translations/fr/`).
3. **Translate the text values** in the JSON files, and the interface in `lib/l10n/app_en.arb` (copy it to
   `app_<code>.arb`). Translate from the English version, or from the German
   original if you speak German – the German text is the reference when in doubt.
4. **Open a pull request.** Partial translations are welcome too – for example the first few courses.

### What to translate – and what not

| Translate | Keep unchanged |
|---|---|
| `title`, `subtitle`, `summary`, `content`, `reflection_question` | `id` and every other key name |
| texts in `paar_abend.json`, `selbst_reise.json`, `yes_no_maybe.json`, `fantasy_options.json` | `image`, `icon`, `type`, `linked_tool`, `voice`, `category`, `target` |
| SOS cards, belief library, match cards | the `_source` block (it's filled in automatically) |

- **IDs must never change.** Saved answers and partner matching depend on them.
- **Keep the section headings** inside lessons on their own line (in English: “Why it works”, “The exercise”,
  “Consent and safety”, “When to see a doctor”) – translated into your language.
- **Keep the name placeholders.** Some lessons contain `{W:she}`, `{W2:her}`, `{M:he}`, `{M2:his}` or
  `{P:your partner}`. The app replaces them with the partner's name (e.g. “Anna lies on her back”). Translate
  only the text after the colon and keep the letter before it: `{W:elle}`, `{P:ton/ta partenaire}`. `W2`/`M2`
  mark possessives (“her”, “his”), which become “Anna's”.
- **Plain text only**, no Markdown: the app shows the text as is and reads it aloud.
- **Adapt country-specific details:** crisis lines, emergency numbers and legal remarks should fit your
  country. If unsure, phrase them neutrally (“a crisis line in your country”).
- **Tone:** warm, clear, non-judgemental and inclusive. The content is sex education for adults with a
  therapeutic background; please keep the medical and safety notes intact.

### Checking your work (optional)

If you have [Flutter](https://flutter.dev) installed, you can check completeness and record the checksums:

```bash
flutter test test/translation_test.dart --dart-define=LANG=fr
flutter test test/translation_test.dart --dart-define=LANG=fr --dart-define=STAMP=ALL
```

The checksums link each translated entry to the German text it was translated from. When the German text
changes later, the test shows which entries need updating. If you don't use Flutter, just leave `_source`
as it is – we'll take care of it when merging.

### Keeping translations current

English is maintained together with the German original and is always up to date. Other languages are
maintained by the community and may lag behind; the checksums make visible what needs updating. If you'd like
to look after a language long-term, say so in your issue – you'll be named as its maintainer.

## Reporting pronunciation (German audio)

The lessons are read aloud by a local text-to-speech voice (Victoria and Martin). Sometimes it stresses a
word wrongly or sounds a little off. If you hear such a word, please report it with the
[pronunciation template](../../issues/new?template=aussprache.md) – a description in words is enough, e.g.
“Beckenboden: stress is on the wrong syllable”. Fixes go into `tools/aussprache.json` and the affected
recordings are regenerated.

Please **don't attach recordings of your own voice**: a voice is personal and would stay public in the
repository. For the same reason we don't collect human voice recordings for the app.

## Other contributions

Bug reports and ideas are welcome as issues. For larger changes to the app itself, please open an issue first so
we can discuss it.

By contributing, you agree that your contributions are licensed under the project's licenses:
code under [MIT](LICENSE), content and translations under [CC BY-NC-SA 4.0](LICENSE-CONTENT.md).
