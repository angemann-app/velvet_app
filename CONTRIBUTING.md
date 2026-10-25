# Contributing to VelvetPulse

Thank you for wanting to help! The most welcome contribution right now is a **translation into your language**.

## Translating the content

All of VelvetPulse – 26 courses, 116 lessons, guided sessions, lists and the interface – exists in German
(the original) and in English ([translations/en](translations/en/)). We'd love to add more languages:
French, Spanish, Dutch, Italian, Polish, Portuguese … whatever you speak well.

You don't need to be a developer. Every text is a separate entry in a translation file (PO format), shown one
after another with the German original, the English version as a help and a field for your translation.
The free program [Poedit](https://poedit.net) shows them in order and tracks how far you've got.

**Step by step, what to keep unchanged and how progress is shown:** [translations/README.md](translations/README.md).
Current progress per language: [translations/STATUS.md](translations/STATUS.md).

### Translation guidelines

- **Keep the section headings** inside lessons on their own line (in English: “Why it works”, “The exercise”,
  “Consent and safety”, “When to see a doctor”) – translated into your language.
- **Keep the name placeholders.** Some lessons contain `{W:she}`, `{W2:her}`, `{M:he}`, `{M2:his}` or
  `{P:your partner}`. The app replaces them with the partner's name (e.g. “Anna lies on her back”). Translate
  only the text after the colon and keep the letter before it: `{W:elle}`, `{P:ton/ta partenaire}`. `W2`/`M2`
  mark possessives (“her”, “his”), which become “Anna's”.
- **Interface texts:** keep placeholders like `{name}` or `{count}` exactly as they are, and keep the structure
  of plural forms such as `{count, plural, =1{…} other{…}}` – translate only the words inside the braces.
- **Plain text only**, no Markdown: the app shows the text as is and reads it aloud.
- **Adapt country-specific details:** crisis lines, emergency numbers and legal remarks should fit your
  country. If unsure, phrase them neutrally (“a crisis line in your country”).
- **Tone:** warm, clear, non-judgemental and inclusive. The content is sex education for adults with a
  therapeutic background; please keep the medical and safety notes intact.

### Keeping translations current

English is maintained together with the German original and is always up to date. Other languages are
maintained by the community and may lag behind. When a German text changes, its translation is marked as
*fuzzy* (outdated) in the PO file and counted as outdated in the status page until it has been reviewed. If
you'd like to look after a language long-term, say so in your issue – you'll be named as its maintainer.

## Reporting pronunciation (German audio)

The lessons are read aloud by a local text-to-speech voice (Victoria and Martin). Sometimes it stresses a
word wrongly or sounds a little off. If you hear such a word, tap “Word mispronounced?” below the player in the app: the report is sent
anonymously and encrypted, with lesson, voice and minute already filled in. Or report it publicly with the
[pronunciation template](../../issues/new?template=aussprache.md) – a description in words is enough, e.g.
“Beckenboden: stress is on the wrong syllable”. Fixes go into `tools/aussprache.json` and the affected
recordings are regenerated.

Please **don't attach recordings of your own voice**: a voice is personal and would stay public in the
repository. For the same reason we don't collect human voice recordings for the app.

## Other contributions

Bug reports and ideas are welcome, either anonymously in the app (*Profile → Send feedback*) or as issues. For larger changes to the app itself, please open an issue first so
we can discuss it.

By contributing, you agree that your contributions are licensed under the project's licenses:
code under [MIT](LICENSE), content and translations under [CC BY-NC-SA 4.0](LICENSE-CONTENT.md).
