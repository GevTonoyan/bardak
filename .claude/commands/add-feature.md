# Add Feature

Scaffold a new Clean Architecture feature for the Bardak Flutter app.

## Usage

`/add-feature <feature_name> [full|game-loop|presentation]`

If the type is not specified, determine it from context:
- **full** — reads/writes persistent data (Hive / SharedPrefs / Firestore)
- **game-loop** — in-memory game state only, no persistence
- **presentation** — static screen, no state beyond UI

---

## Step 0 — Classify

Ask the user if the type is unclear.

---

## Track A — Full Clean Architecture Feature

Create the folder tree:
```
lib/$ARGUMENTS/
  domain/
    entities/
    repositories/
    usecases/
  data/
    data_sources/
    repositories/
  presentation/
    bloc/
    ui/
  ${ARGUMENTS}_scope.dart
```

### Domain layer
- Entity: pure Dart, `Equatable`, `copyWith`, `fromJson`/`toJson`, `factory *.initial()`.
- Repository: `abstract interface class *Repository`.
- UseCases: one class per operation, `call()` method, `*Params` class in same file.

### Data layer
- Local data source: interface + impl (Hive or SharedPrefs).
- Remote data source: interface + impl (Firestore) — omit if no remote.
- Repository impl: delegates to data sources.

### Presentation layer (BLoC)
Three files in `presentation/bloc/`:
- `*_event.dart` — `sealed class` events
- `*_state.dart` — `sealed class` states (or single state with `copyWith`)
- `*_bloc.dart` — constructor-injected use cases, explicit transformer per `on<>` handler

### Feature scope
`lib/$ARGUMENTS/${ARGUMENTS}_scope.dart`:
```dart
void inject${FeatureName}Scope() {
  if (sl.isRegistered<${FeatureName}Repository>()) return;
  sl
    ..registerLazySingleton<Get${FeatureName}UseCase>(() => Get${FeatureName}UseCase(sl()))
    ..registerLazySingleton<${FeatureName}Repository>(
      () => ${FeatureName}RepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<${FeatureName}LocalDataSource>(
      () => ${FeatureName}LocalDataSourceImpl(sl()),
    );
}
```
Then add `inject${FeatureName}Scope();` to `lib/utils/dependency_injection/di.dart`.

### Route
Add `GoRoute` to `lib/router/app_router.dart`. Path and name are `static const` on the screen class.

---

## Track B — Game-Loop Feature

1. `lib/$ARGUMENTS/domain/entities/${ARGUMENTS}_entity.dart` — pure Dart entity
2. `lib/$ARGUMENTS/presentation/bloc/` — BLoC with constructor params (words, duration, etc.), no use cases
3. Route in `app_router.dart` — read params from `GameSessionBloc` state
4. No scope file needed

---

## Track C — Presentation-Only Feature

1. `lib/$ARGUMENTS/presentation/ui/${ARGUMENTS}_screen.dart`
2. `static const routePath` on the screen class
3. `GoRoute` in `app_router.dart`
4. No domain, data, or DI changes

---

## Checklist (verify before finishing)

- [ ] Domain has zero Flutter imports
- [ ] BLoC uses constructor injection — no `sl()` inside
- [ ] Every async `on<Event>` has an explicit concurrency transformer
- [ ] Scope has idempotency guard (`isRegistered` check)
- [ ] Scope called from `injectDependencies()` in `di.dart`
- [ ] Route path/name are `static const` on the screen class
- [ ] Route added to `app_router.dart`
- [ ] All colors via `context.colors`, text via `context.typography`
- [ ] All assets via `Assets.*` generated accessors
- [ ] `dart format lib/$ARGUMENTS/` passes
