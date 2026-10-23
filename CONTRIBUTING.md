# Contributing to VelvetPulse

Thank you for wanting to help! The most welcome contribution right now is a **translation into your language**.

## Translating the content

All of VelvetPulse's content – 21 courses, 75 lessons, guided couple sessions and lists – exists in German
(the original) and in English ([translations/en](translations/en/)). We'd love to add more languages:
French, Spanish, Dutch, Italian, Polish, Portuguese … whatever you speak well.

You don't need to be a developer. If you can edit a text file, you can help.

### How to start

1. **Open an issue** with the [translation template](../../issues/new?template=translation.md) so others know
   which language is being worked on and nobody duplicates work.
2. **Fork the repository** and copy the English folder as a starting point:
   `translations/en/` → `translations/<code>/` (e.g. `translations/fr/`).
3. **Translate the text values** in the JSON files. Translate from the English version, or from the German
   original if you speak German – the German text is the reference when in doubt.
4. **Open a pull request.** Partial translations are welcome too – for example the first few courses.

### What to translate – and what not

| Translate | Keep unchanged |
|---|---|
| `title`, `subtitle`, `summary`, `content`, `reflection_question` | `id` and every other key name |
| texts in `paar_abend.json`, `yes_no_maybe.json`, `fantasy_options.json` | `image`, `icon`, `type`, `linked_tool`, `voice`, `category`, `target` |
| SOS cards, belief library, match cards | the `_source` block (it's filled in automatically) |

- **IDs must never change.** Saved answers and partner matching depend on them.
- **Keep the section headings** inside lessons on their own line (in English: “Why it works”, “The exercise”,
  “Consent and safety”, “When to see a doctor”) – translated into your language.
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

## Other contributions

Bug reports and ideas are welcome as issues. For larger changes to the app itself, please open an issue first so
we can discuss it.

By contributing, you agree that your contributions are licensed under the project's licenses:
code under [MIT](LICENSE), content and translations under [CC BY-NC-SA 4.0](LICENSE-CONTENT.md).
