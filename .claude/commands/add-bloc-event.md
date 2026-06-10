# Add BLoC Event

Add a new event + handler to an existing BLoC in the Bardak project.

## Usage

`/add-bloc-event <feature> <EventName>`

Example: `/add-bloc-event settings ResetToDefaults`

---

## Steps

1. **Read** the existing `*_event.dart`, `*_state.dart`, and `*_bloc.dart` files for the feature to understand the current shape.

2. **Add the event class** to `*_event.dart`:
```dart
class $EventName extends ${Feature}Event {
  const $EventName({/* required params */});

  @override
  List<Object?> get props => [/* params */];
}
```

3. **Add a new state** to `*_state.dart` if the event produces a new state (otherwise reuse existing).

4. **Register the handler** in the BLoC constructor:
```dart
on<$EventName>(_on$EventName, transformer: droppable()); // choose appropriate transformer
```

5. **Implement the handler**:
```dart
Future<void> _on$EventName(
  $EventName event,
  Emitter<${Feature}State> emit,
) async {
  // implementation
}
```

## Transformer guide

| Transformer | Use when |
|-------------|---------|
| `droppable()` | Button tap — ignore if already processing |
| `restartable()` | Search/refresh — cancel previous if new arrives |
| `sequential()` | Save operations — process in order |

## Rules

- Keep events `sealed` — the new class must extend the existing sealed base.
- Add `Equatable` props for all fields.
- Use `log()` from `dart:developer` for any logging — never `print()`.
- Run `dart format lib/<feature>/` after changes.
