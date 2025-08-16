part of 'alias_main_bloc.dart';

/// Base class for all events in the AliasMainBloc.
sealed class AliasMainEvent {
  const AliasMainEvent();
}

/// Event to check if alias words are cached, and if not, fetch them from the server and cache them.
/// Also retrieves the selected word pack name.
final class InitializeAliasMainEvent extends AliasMainEvent {
  final String locale;

  const InitializeAliasMainEvent({required this.locale});
}

/// Event to get the selected word pack name.
final class GetSelectedWordPackNameEvent extends AliasMainEvent {
  final String locale;

  const GetSelectedWordPackNameEvent({required this.locale});
}
