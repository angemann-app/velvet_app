# VelvetPulse – English content

English translations of all VelvetPulse content, for anyone who wants to build an English version of the app.
They are **not** part of the app release; the app itself is German.

| File | German source | Contents |
|---|---|---|
| `velvet_content.json` | `assets/data/velvet_content.json` | 21 courses, 75 lessons, SOS cards, belief library, match cards |
| `paar_abend.json` | `assets/data/paar_abend.json` | 54 spoken building blocks of the guided couple evening |
| `yes_no_maybe.json` | `lib/models/yes_no_maybe_models.dart` | yes/no/maybe list: 10 categories, 63 items with explanations |
| `fantasy_options.json` | `lib/models/couple_channel_models.dart` | fantasy options of the couple channel |

The structure matches the German files, so they can be swapped in directly. IDs are identical and must never change
(saved answers and partner matching depend on them).

## What is not translated

- **User interface:** buttons, menus and hints are written directly in the Dart code in German. An English app
  also needs these strings translated (e.g. with Flutter's `intl`/ARB files).
- **Audio:** the lesson recordings are German. `tools/generate_audio.py` can record English versions with
  an English Kokoro voice.
- **Country-specific details:** crisis lines and legal remarks refer to Germany and are phrased neutrally here
  where possible. Please adapt them to your country.

## Keeping it up to date

Every new or changed German text must be translated at the same time. `test/translation_test.dart` stores a
checksum of each German source text in `_source` and fails if a translation is missing or outdated – so a
release can't be published with stale English content.

After translating, record the checksums of the translated entries:

```bash
flutter test test/translation_test.dart --dart-define=STAMP=lesson:desire_1,block:ankommen_1
```

## Other languages

Want to translate VelvetPulse into your language? Copy this folder to `translations/<code>/` and see
[CONTRIBUTING.md](../../CONTRIBUTING.md) – contributions are very welcome.

Content license: [CC BY-NC-SA 4.0](../../LICENSE-CONTENT.md), like the German original.
