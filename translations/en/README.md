# VelvetPulse – English content

> Want to translate into another language? See [../README.md](../README.md): every text is available as a PO file there.

English translations of all VelvetPulse content. Since version 4.5 they ship with the app: on non-German
phones (or when chosen in the profile) the app loads these files instead of the German ones.

| File | German source | Contents |
|---|---|---|
| `velvet_content.json` | `assets/data/velvet_content.json` | 26 courses (2 of them spicy mode only), 116 lessons, SOS cards, belief library, match cards |
| `paar_abend.json` | `assets/data/paar_abend.json` | 110 spoken building blocks of the guided couple evening |
| `selbst_reise.json` | `assets/data/selbst_reise.json` | 100 spoken building blocks of the guided self-exploration |
| `einschlaf_reise.json` | `assets/data/einschlaf_reise.json` | 119 spoken building blocks of the drift-off journey |
| `yes_no_maybe.json` | `lib/models/yes_no_maybe_models.dart` | yes/no/maybe list: 11 categories, 78 items with explanations (category „spicy“ only in spicy mode) |
| `fantasy_options.json` | `lib/models/couple_channel_models.dart` | fantasy options of the couple channel |
| `anleitung.json` | `assets/data/anleitung.json` | in-app guide |
| `neuigkeiten.json` | `assets/data/neuigkeiten.json` | what's new after updates |
| `foto_ideen.json` | `assets/data/foto_ideen.json` | photo ideas of the couple chat (spicy mode) |

The structure matches the German files, so they can be swapped in directly. IDs are identical and must never change
(saved answers and partner matching depend on them).

## What is not translated

- **User interface:** lives in `lib/l10n/app_en.arb` (Flutter gen-l10n), not in this folder.
- **Audio:** German recordings are built into the app. English recordings (`tools/generate_audio_en.py`,
  Kokoro voices af_heart and am_michael) are an optional download inside the app.
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
