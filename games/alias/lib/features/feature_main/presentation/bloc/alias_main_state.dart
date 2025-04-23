part of 'alias_main_bloc.dart';

/// The base class for the states of [AliasMainBloc].
sealed class AliasMainState {
  const AliasMainState();
}

/// Represents the initial state of the [AliasMainBloc].
class AliasMainInitial extends AliasMainState {
  const AliasMainInitial();
}

/// Represents the loading state of the [AliasMainBloc].
class AliasMainLoading extends AliasMainState {
  const AliasMainLoading();
}

/// Represents the loaded state of the [AliasMainBloc].
/// This state indicates that the word packs have been successfully fetched and cached.
class AliasMainLoaded extends AliasMainState {
  const AliasMainLoaded();
}

/// Represents an error state in the [AliasMainBloc].
/// The most common error is when the word packs are not fetched and cached.
class AliasMainError extends AliasMainState {
  final String message;

  const AliasMainError({required this.message});
}
