# Bardak — Flutter Project Context for Claude

## What this project is

Bardak is a multi-player party word game (Alias-style) for iOS and Android.
Flutter + Dart, targeting SDK 3.12.1 / Flutter 3.44.1.
Package name: `bardak`. App version: `1.0.1+12`.

## Architecture — Clean Architecture + BLoC

Three strict layers per feature: `domain/` → `data/` → `presentation/`.

| Layer | Rule |
|-------|------|
| `domain/` | Pure Dart. Zero Flutter or `dart:ui` imports. |
| `data/` | Hive / Firestore / SharedPrefs impls. Maps exceptions → domain failures. |
| `presentation/` | BLoC/Cubit + screens + widgets. Depends on use cases only, never repositories directly. |

### Feature folder template

```
lib/feature_x/
  domain/
    entities/
    repositories/        # abstract interface class
    usecases/
  data/
    data_sources/
    repositories/        # impl
  presentation/
    bloc/
    ui/                  # screens + widgets
  feature_x_scope.dart   # GetIt registrations
```

Presentation-only features (home, splash, rules) omit domain/data.
Game-loop features (game_session, card_round, single_word_round) use domain entities directly — no persistence layer.

## Features inventory

| Feature | Type | Storage |
|---------|------|---------|
| `word_packs` | Full | Firestore (remote) + Hive (cache) |
| `settings` | Full | SharedPreferences |
| `themes` | Full | SharedPreferences |
| `rewards` | Full | SharedPreferences |
| `app_review` | Full | SharedPreferences |
| `pre_game` | Full | SharedPreferences |
| `game_session` | Game-loop | In-memory |
| `card_round` | Game-loop | In-memory |
| `single_word_round` | Game-loop | In-memory |
| `home` / `rules` / `splash` | Presentation-only | — |

## State management — BLoC rules

- Events MUST be `sealed` classes; events and states both extend `Equatable`. State shape (single class vs `sealed` base) follows the Naming conventions below.
- Every async `on<Event>` MUST declare an explicit concurrency transformer:
  - `restartable()` — search/refresh
  - `droppable()` — single tap actions
  - `sequential()` — order-sensitive saves
- BLoCs receive use cases via constructor. **Never** call `sl()` inside a BLoC.
- Use `Bloc` for discrete event-driven logic; `Cubit` only for simple method-call state machines.

## Naming conventions

Consistency across features outweighs any individual preference. New code MUST follow these; existing violations are fixed incrementally.

### Use cases
- One use case = one class with a single `call()` method (callable class).
- Class `<Verb><Noun>UseCase`; file `<verb>_<noun>_usecase.dart` (`usecase`, one word).
- Dependency field is **private and named for the repository**: `final SettingsRepository _settingsRepository;` — not a generic `_repository`. A use case with **more than two repositories** takes **named constructor parameters**.
- Verb vocabulary — one canonical verb per intent, **regardless of data source** (local DB, cache, memory, and remote/network all use the same verb); never mix synonyms:
  - `Get<Noun>` — read data. Always `Get`, never `Fetch`/`Load`, whether the source is local or remote. Sync return when the repo is sync; `Future` when async.
  - `Update<Noun>` — persist a change. Always `Update`, never `Save`/`Change`.
  - Boolean query — `Is…` / `Are…` / `Has…` (e.g. `AreWordPacksCachedUseCase`).
  - Other commands — imperative verb for the effect (`RecordAppOpenedUseCase`, `OpenStoreListingUseCase`). Avoid `On…` (event-handler phrasing, not a command).
- Params: a use case with arguments declares `<UseCaseName without "UseCase">Params` in the **same file**. Noun must match the use case (`AreWordPacksCachedUseCase` → `AreWordPacksCachedParams`).
- The same domain noun is spelled identically across use case, params, repository method, and entity (`WordPacks`, never `Packs` in some places).

### BLoC / Cubit
- Default to `Bloc`. Use `Cubit` only for a trivial method-call state machine — and it still has a dedicated `<Feature>State` class (never a raw entity as the state type).
- Triad per feature in `presentation/bloc/`: `<Feature>Bloc` / `<Feature>Event` / `<Feature>State`, files `<feature>_bloc.dart` / `_event.dart` / `_state.dart`.

### Events
- Base: `sealed class <Feature>Event extends Equatable`.
- Subclasses: **imperative, verb-first, no `Event` suffix** — `LoadGameSettings`, `ChangeLocale`, `ToggleWord`, `PurchaseTheme` (not `AddTeamsEvent`, not past-tense `WordToggled`).
- The "load this feature's data" trigger is always `Load<Thing>` — the use-case verb `Get` (and `Cache`) belong to use cases, not events.

### States
- All states extend `Equatable`.
- **≤ 2 states** (data that mutates in place): a single immutable `<Feature>State` class.
- **> 2 distinct states**: a `sealed class <Feature>State` base with one subclass per state, named `<Feature><Variant>` (`<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded`, `<Feature>Failure`).
- A single-field state has no `copyWith` — construct it directly.

### Repositories & data sources
- `<Feature>Repository` (`abstract interface class`) in `domain/repositories/`; impl in `data/repositories/`.
- `<Feature>LocalDataSource` / `<Feature>RemoteDataSource` (+ `…Impl`) in `data/data_sources/`.
- Methods verb-first camelCase mirroring use-case intent (`getX`, `updateX`, `areXCached`) — same canonical verbs as use cases, source-agnostic (no `fetchX`).

### Entities
- `<Noun>Entity`, `Equatable`; `copyWith` when it has more than one field; factories `.initial()`, `.fromPreferences()` / `.fromJson()`.

### DI scope files
- File `<feature>_scope.dart`, function `inject<Feature>Scope()` (not `inject_<feature>_scope.dart`).

## Dependency injection — GetIt

Single instance: `final GetIt sl = GetIt.instance;` in `lib/utils/dependency_injection/di.dart`.

Only these locations may call `sl<T>()`:
- `lib/utils/dependency_injection/di.dart`
- `lib/*/feature_x_scope.dart`
- `lib/router/app_router.dart` (pageBuilder — composition root)
- `lib/main.dart` (MultiBlocProvider)

Feature scopes MUST be idempotent: guard with `if (sl.isRegistered<T>()) return;`.
Registration order: use cases → repository → data sources.

## Navigation — GoRouter

All routes in `lib/router/app_router.dart`. Route path and name are `static const` on each screen class.

Current route tree:
```
/splash → /home → /settings, /rules, /rewards, /themes
                → /gameSettings → /setupTeamNames → /wordPacks → /languageSelect
                → /gameSession (ShellRoute) → /countdown, /cardRound, /singleWordRound
                                            → /roundOverview → /roundReview
                → /gameSummary
```

`ShellRoute` keeps `GameSessionBloc` alive across all round screens.
Pass complex data via `state.extra` (typed arg classes). Never encode domain entities in query params.

## Design system

### Colors — `context.colors` → `AppColors`

All colors via `context.colors`. Never use raw `Color(...)` or `Colors.*` in UI.

**Scheme-specific (differ per theme):**
| Token | Main scheme value | Use for |
|-------|-------------------|---------|
| `context.colors.firstGradient` | `#FF6C3F` (orange) | Top of background gradient |
| `context.colors.secondGradient` | `#D81E1E` (red) | Bottom of background gradient |
| `context.colors.main` | `LinearGradient(firstGradient → secondGradient)` | Full-screen background |
| `context.colors.secondary` | `#7E2210` (dark red) | Bottom sheets, cards, icon buttons, overlays |

**Fixed across all themes:**
| Token | Value | Use for |
|-------|-------|---------|
| `context.colors.green` | `#59CA42` | Correct / confirm / active switch thumb |
| `context.colors.red` | `#D42B2B` | Wrong / destructive actions |
| `context.colors.orange` | `#E38417` | Warnings / coins / highlights |
| `context.colors.blue` | `#4068F5` | Info / links |
| `context.colors.purple` | `#A473E9` | Decorative / special |
| `context.colors.white` | `#FFFFFF` | Primary text, icons |
| `context.colors.white50` | white @ 50% | Subdued text |
| `context.colors.white30` | white @ 30% | Borders, dividers |
| `context.colors.white20` | white @ 20% | Button backgrounds (glass) |
| `context.colors.white10` | white @ 10% | Very subtle fills |
| `context.colors.black` | `#000000` | Overlays base |
| `context.colors.shadow` | `#B9B9B9` | Box shadows |

### Typography — `context.typography` → `AppTextStyles`

All text via `context.typography`. Never use raw `TextStyle(...)`.

**Brand font (NishikiTeki) — use for game UI, headings, buttons:**
| Token | Size | Use for |
|-------|------|---------|
| `regular38` | 38px | Large word cards, hero labels |
| `regular28` | 28px | Section headings |
| `regular24` | 24px | Button labels, standard headings |
| `regular20` | 20px | Medium button labels |
| `regular18` | 18px | Small buttons, notification text |
| `medium` | 18px | General medium body (no font family — system) |

**System font — use for settings, lists, body copy:**
| Token | Size | Use for |
|-------|------|---------|
| `displayLarge` | 57px | Hero numbers |
| `headlineLarge` | 32px | Screen titles |
| `headlineMedium` | 28px | Card titles |
| `titleLarge` | 22px | Section titles |
| `titleMedium` | 16px | List item titles |
| `bodyLarge` | 16px | Body text |
| `bodyMedium` | 14px | Secondary body |
| `bodySmall` | 12px | Captions, labels |
| `labelSmall` | 11px | Chips, tags |

**Number font:** append `.withNumericFont` to any style → switches to Digitalt font.
Example: `context.typography.medium.withNumericFont`

### Screen backgrounds

Two background widgets in `lib/app_ui/widgets/screen_background.dart`:

```dart
// Full gradient background (most screens)
GradientBackground(child: ...)

// Black shadow overlay with jagged top edge (game round screens)
ShadowBackground(child: ...)
```

### Color schemes

All 15 schemes share the same token names — only the values differ. The active scheme is driven by `ThemesBloc` and read via `context.colors`.

| Scheme | firstGradient | secondGradient | secondary |
|--------|--------------|----------------|-----------|
| `main` | `#FF6C3F` | `#D81E1E` | `#7E2210` |
| `purple` | `#9C59FE` | `#6F53FD` | `#723FBC` |
| `yellow` | `#B5B518` | `#706812` | `#3D3A0C` |
| `blue` | `#4068F5` | `#3B5FE2` | `#21378B` |
| `green` | `#75B435` | `#4E741F` | `#3C5D17` |
| `pink` | `#ED3B97` | `#A61C63` | `#6E1F48` |
| `red` | `#DF393C` | `#932123` | `#6C2020` |
| `dark` | `#595959` | `#171717` | `#000000` |
| `turquoise` | `#2CA5B3` | `#196770` | `#14565D` |
| `orange` | `#FF9A3E` | `#F07F1C` | `#B8570E` |
| `brown` | `#8B5A2B` | `#6B3F1D` | `#4A2A11` |
| `navy` | `#1B3A7A` | `#0F244F` | `#081833` |
| `mint` | `#4FD1B1` | `#2BAE91` | `#156E5A` |
| `plum` | `#6B2D8E` | `#4A1B66` | `#2E0F42` |
| `grey` | `#8C8C8C` | `#3D3D3D` | `#5A5A5A` |

### Component library

All in `lib/app_ui/widgets/`. Use these — never build raw equivalents.

**`AppButton`** — primary action button with press animation and 3D shadow effect:
```dart
AppButton(
  label: 'Play',
  color: context.colors.green,        // required: any Color
  size: ButtonSize.large,             // extraLarge | large | medium | small
  onPressed: () {},                   // null = disabled state
  icon: Assets.icons.play.svg(),      // optional leading icon
  isPressed: false,                   // external pressed state override
)
// Sizes → heights: extraLarge=157/147, large=60/50, medium=50/42, small=42/36
// Label styles: large/extraLarge=regular24, medium=regular20, small=regular18
```

**`AppStepperButton`** — number picker built on `AppButton` shell:
```dart
AppStepperButton(
  label: '60',
  onIncrement: () {},   // null = disabled
  onDecrement: () {},
)
```

**`AppSwitchButton`** — toggle row inside a button shell (glass background):
```dart
AppSwitchButton(
  label: 'Sound',
  value: true,
  onChanged: (v) {},
  onPressed: () {},              // optional tap on the whole row
  icon: Assets.icons.volume.svg(),
)
```

**`AppSwitch`** — bare toggle (green thumb, white track):
```dart
AppSwitch(value: isOn, onChanged: (v) {})
```

**`AppIconButton`** — circular 40×40 button (secondary bg, white border, shadow):
```dart
AppIconButton.back(onTap: () {})
AppIconButton.close(onTap: () {})
AppIconButton.settings(onTap: () {})
AppIconButton.pause(onTap: () {})
AppIconButton.play(onTap: () {})
AppIconButton.info(onTap: () {})
AppIconButton.edit(onTap: () {})
// Custom child:
AppIconButton(onTap: () {}, child: someWidget)
```

**`AppIconTextButton`** — pill-shaped button with white border, press feedback:
```dart
AppIconTextButton(
  onTap: () {},
  color: context.colors.secondary,   // optional fill color
  gradient: someGradient,            // optional gradient (overrides color)
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  child: Row(children: [...]),
)
```

**`AppIcon`** — tap target wrapper with 48px minimum hit area:
```dart
AppIcon(icon: someWidget, onTap: () {}, clickableArea: 48, iconSize: 20)
```

**`SvgIcon`** — SVG that inherits color and size from `IconTheme`:
```dart
SvgIcon(asset: Assets.icons.coin)
// Wrap in IconTheme to control color/size:
IconTheme(data: IconThemeData(color: colors.white, size: 20), child: SvgIcon(asset: ...))
```

**Bottom sheets** — always use these, never plain `showModalBottomSheet`:
```dart
// Partial height — scrollable content at bottom
PartialBottomSheet(titleBuilder: (ctx) => ctx.l10n.title, child: ...)

// Fixed header + scrollable expanded content
FullBottomSheet(titleBuilder: (ctx) => ctx.l10n.title, child: ...)

// Simple titled sheet (minimal)
ScaffoldBottomSheet(title: 'Title', child: ...)

// Confirm/cancel dialog sheet (two buttons)
await showConfirmSheet(
  context: context,
  title: 'Are you sure?',
  description: 'This will end the round.',
  confirmText: 'End round',
  cancelText: 'Continue',
  confirmColor: context.colors.red,
  cancelColor: context.colors.green,
  onConfirm: () {},
)
```

**Overlay notifications:**
```dart
// Top-sliding notification banner (2s auto-dismiss)
await showAppNotification(context, message: 'Copied!', icon: Assets.icons.check.svg())

// Bottom-rising points badge (e.g. after scoring)
await showPointsBadge(context, points: '+3')
await showPointsBadge(context, points: '-1')   // negative = red gradient
```

**`RoundTimer`** — colored pill showing countdown (green→orange→red at ≤10/≤5s):
```dart
RoundTimer(seconds: remainingSeconds)
```

**`FlipCard`** — 3D card flip animation:
```dart
FlipCard(isFlipped: showBack, front: frontWidget, back: backWidget)
```

**`HighlightedText`** — text in a rounded secondary-colored card:
```dart
HighlightedText(text: 'some word')
// → Container(secondary bg, radius 12, regular28 style)
```

**`TextWithBorder`** — text with stroke outline (used on game cards):
```dart
TextWithBorder('BARDAK', style: context.typography.regular38, borderWidth: 5)
```

**`SmartNumberText`** — mixed text where digit runs use Digitalt (numeric) font:
```dart
SmartNumberText('Round 3 of 10', style: context.typography.regular24)
// Numbers → Digitalt font. Non-numbers → NishikiTeki (from style).
```

**`LanguageIcon`** — circular flag icon (EN/RU/AM):
```dart
LanguageIcon(locale: AppLocales.en, size: 32, onTap: () {})
```

**`NetworkPackImage`** — remote image with BlurHash placeholder:
```dart
NetworkPackImage(imageUrl: url, imageBlurHash: hash, opacity: 0.5)
```

**`CoinBalanceWidget`** — reads `RewardsCubit`, shows coin count + icon:
```dart
CoinBalanceWidget(onTap: () {})
```

**Spacing constants** (`app_spacings.dart`):
```dart
height20  // SizedBox(height: 20)
height30  // SizedBox(height: 30)
height40  // SizedBox(height: 40)
width20   // SizedBox(width: 20)
```

### Assets — flutter_gen only

```dart
Assets.images.logo.image()
Assets.images.themeBackground.image()
Assets.icons.coin.svg()
Assets.icons.clock.svg()
Assets.icons.lock.svg()
Assets.icons.add.svg()
Assets.icons.back.svg()
Assets.icons.close.svg()
Assets.icons.play.svg()
Assets.icons.pause.svg()
Assets.icons.volume.svg()
Assets.icons.check.svg()
Assets.icons.info.svg()
Assets.icons.rewardClosed.svg()
Assets.icons.rewardOpened.svg()
Assets.sounds.tick    // used as AssetSource(Assets.sounds.tick)
Assets.sounds.check
Assets.sounds.uncheck
```

### Key UI rules

- `const` constructors on all immutable widgets.
- Prefer private widget classes (`_ScoreCard`) over `_buildScoreCard()` methods.
- Remote images: `CachedNetworkImage` with `errorBuilder` always.
- Wins/celebrations: `confetti` package.
- Selected/active highlights: `gradient_borders` package.
- `BlocSelector` for partial rebuilds — never rebuild on unrelated state changes.

## Localizations

3 languages: English (`en`), Armenian (`am`), Russian (`ru`).
`.arb` files in `lib/localizations/l10n/`. Access in widgets: `context.l10n.*`.
After editing `.arb` files, run `flutter gen-l10n` (or `flutter pub get` triggers it).

## Code style

- Max line length: 80 chars.
- Always trailing commas.
- `const` constructors on all immutable widgets.
- Prefer private widget classes (`_ScoreCard`) over `_buildScoreCard()` methods.
- Logging: `log()` from `dart:developer`. **Never** `print()` or `debugPrint()`.
- `very_good_analysis` lint rules are active — warnings are expected and will be fixed incrementally. Do not suppress them with `// ignore` unless truly necessary.

## Code generation

After adding assets or modifying Hive models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

After adding/editing `.arb` localization files:
```bash
flutter gen-l10n
```

## Common commands (safe to run without asking)

```bash
flutter analyze                                          # lint check
dart format lib/                                         # format all Dart files
flutter test                                             # run tests
dart run build_runner build --delete-conflicting-outputs # code gen
flutter pub get                                          # fetch dependencies
git status                                               # check status
git diff                                                 # check diff
git log --oneline -20                                    # recent commits
```

## Git rules

- **Ask before committing.** Never create a commit without user approval.
- **Never push to remote** without explicit user instruction.
- `lib/firebase_options.dart` is tracked in git but should not be — do not re-add or modify it. See security note below.

## Security note

`lib/firebase_options.dart` is currently tracked in git (accidentally committed).
It is in `.gitignore` but was committed before the rule was in place.
To fix: `git rm --cached lib/firebase_options.dart` (ask user before running).
Do NOT include this file in any new commits or diffs.

## Files to never commit

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- Any `.env` files
