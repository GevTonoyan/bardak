part of 'alias_main_bloc.dart';

/// Base class for all events in the AliasMainBloc.
sealed class AliasMainEvent {
  const AliasMainEvent();
}

/// Event to check if alias words are cached, and if not, fetch them from the server and cache them.
final class CheckAndCacheAliasWords extends AliasMainEvent {
  final String locale;

  const CheckAndCacheAliasWords({required this.locale});
}
