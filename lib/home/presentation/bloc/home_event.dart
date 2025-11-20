part of 'home_bloc.dart';

/// Base class for all events in the AliasMainBloc.
sealed class HomeEvent {
  const HomeEvent();
}

/// Event to check if alias words are cached, and if not,
/// fetch them from the server and cache them.
/// Also retrieves the selected word pack name.
final class InitializeAliasHomeEvent extends HomeEvent {
  const InitializeAliasHomeEvent({required this.locale});

  final String locale;
}

/// Event to get the selected word pack name.
final class GetSelectedWordPackNameEvent extends HomeEvent {
  const GetSelectedWordPackNameEvent({required this.locale});

  final String locale;
}
