---
name: add-feature
description: Scaffold a new Clean Architecture feature for the Bardak Flutter app. Generates domain entities, repository interfaces, use cases, data sources, repository implementations, BLoC events/states/bloc, GetIt scope, GoRouter route, and optional screen. Use when the user asks to add a feature, create a new module, implement a new screen with backend, or extend the app with new functionality.
---

# Add Feature — Bardak

## Step 0 — Classify the feature

Before generating any files, determine the feature type:

| Type | Use when | Layers needed |
|------|----------|---------------|
| **Full** | Reads/writes persistent data | domain + data + presentation |
| **Game-loop** | Pure in-memory game state, no storage | domain entities + presentation |
| **Presentation-only** | Static screen, no state beyond UI | presentation only |

Ask the user if it is unclear. Then follow the matching track below.

---

## Track A — Full Clean Architecture Feature

### 1 — Create folder structure

```
lib/<feature_name>/
  domain/
    entities/
    repositories/
    usecases/
  data/
    data_sources/
      local/
      remote/         # omit if no remote source
    repositories/
  presentation/
    bloc/
    pages/
    widgets/          # omit if no shared sub-widgets
  <feature_name>_scope.dart
```

### 2 — Domain layer

**a) Entity** — pure Dart, no Flutter imports. Add `Equatable` when used in BLoC state.
See [templates.md](templates.md#entity) for the full template.

Key rules:
- `copyWith` for immutable updates
- `fromJson`/`toJson` (or `fromFirestore`) on the entity class until a models/ layer exists
- `factory FeatureEntity.initial()` for default/empty state

**b) Repository interface**

```dart
abstract interface class FeatureRepository {
  Future<FeatureEntity> getFeature(GetFeatureParams params);
  Future<void> saveFeature(SaveFeatureParams params);
}
```

**c) Use cases** — one class per operation, `call()` method, `Params` class in same file.
See [templates.md](templates.md#usecase).

### 3 — Data layer

**a) Local data source** — hide Hive/SharedPrefs behind an interface.
**b) Remote data source** — hide Firestore behind an interface.
**c) Repository implementation** — delegates to data sources, maps exceptions to domain failures when the `Result<T>` pattern is adopted.

See [templates.md](templates.md#data-layer) for stubs.

### 4 — Presentation layer (BLoC)

Create three files in `presentation/bloc/`:
- `feature_event.dart` — `sealed class` events
- `feature_state.dart` — `sealed class` states (or single state with `copyWith`)
- `feature_bloc.dart` — constructor-injected use cases, explicit concurrency transformer per handler

Rules:
- `sealed + Equatable` for events and states
- Choose transformer: `restartable()` for refresh/search, `droppable()` for taps, `sequential()` when order matters
- Never call `sl()` inside the BLoC

See [templates.md](templates.md#bloc) for the full pattern.

### 5 — Feature scope (DI)

Create `lib/<feature_name>/<feature_name>_scope.dart`:

```dart
void injectFeatureNameScope() {
  if (sl.isRegistered<FeatureRepository>()) return;
  sl
    ..registerLazySingleton<GetFeatureUseCase>(() => GetFeatureUseCase(sl()))
    ..registerLazySingleton<FeatureRepository>(
      () => FeatureRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<FeatureLocalDataSource>(
      () => FeatureLocalDataSourceImpl(sl()),
    );
}
```

Registration order: use cases → repository → data sources.
Then call `injectFeatureNameScope()` from `lib/utils/dependency_injection/di.dart`.

### 6 — Route

Add a `GoRoute` to `lib/router/app_router.dart`. Route path and name are
`static const` on the screen class:

```dart
GoRoute(
  path: FeatureScreen.routePath,
  name: FeatureScreen.routePath,
  pageBuilder: (context, state) => _buildPlatformPage(
    child: BlocProvider(
      create: (_) => FeatureBloc(getFeature: sl(), saveFeature: sl()),
      child: const FeatureScreen(),
    ),
  ),
),
```

### 7 — Global BLoC (if app-wide)

If the BLoC must live for the app lifetime (like `SettingsBloc`), add it to
`MultiBlocProvider` in `main.dart`. Otherwise, scope it to the route (step 6).

---

## Track B — Game-Loop Feature

Use for in-memory game state (no persistence).

1. Create `lib/<feature>/domain/entities/<feature>_entity.dart` — pure Dart entity
2. Create `lib/<feature>/presentation/bloc/` — BLoC receives constructor params (words, duration, etc.) from the router, no use cases needed
3. Add route in `app_router.dart` — create BLoC in `pageBuilder`, read params from `GameSessionBloc` state via `context.read<GameSessionBloc>().state.gameState`
4. No scope file needed

---

## Track C — Presentation-Only Feature

1. Create `lib/<feature>/presentation/pages/<feature>_screen.dart`
2. Add `static const routePath` on the screen class
3. Add `GoRoute` to `app_router.dart`
4. No domain, data, or DI changes needed

---

## Checklist

After generating all files, verify:

- [ ] Domain layer has zero Flutter imports
- [ ] BLoC receives use cases via constructor (no `sl()` inside)
- [ ] Every async `on<Event>` has an explicit concurrency transformer
- [ ] Scope function has idempotency guard (`isRegistered` check)
- [ ] Scope is called from `injectDependencies()` in `di.dart`
- [ ] Route path/name are `static const` on the screen class
- [ ] Route is added to `app_router.dart`
- [ ] All colors/styles use `context.colors` / `context.typography`
- [ ] All assets use `Assets.*` generated accessors
- [ ] Dart format passes (`dart format lib/<feature>/`)

---

## Reference

- Full code templates: [templates.md](templates.md)
- Architecture overview: [docs/architecture.md](../../docs/architecture.md)
- Feature inventory: [docs/features.md](../../docs/features.md)
- Layer rules: `.cursor/rules/clean-architecture.mdc`
- BLoC rules: `.cursor/rules/bloc-patterns.mdc`
- DI rules: `.cursor/rules/dependency-injection.mdc`
