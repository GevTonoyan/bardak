part of 'home_bloc.dart';

/// The base class for the states of [HomeBloc].
sealed class HomeState {
  const HomeState();
}

/// Represents the initial state of the [HomeBloc].
class HomeStateInitial extends HomeState {
  const HomeStateInitial();
}

/// Represents the loading state of the [HomeBloc].
class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

/// Represents the loaded state of the [HomeBloc].
/// This state indicates that the word packs
/// have been successfully fetched and cached.
class HomeStateLoaded extends HomeState {
  const HomeStateLoaded({this.selectedWordPackName});

  final String? selectedWordPackName;
}

/// Represents an error state in the [HomeBloc].
/// The most common error is when the word packs are not fetched and cached.
class HomeStateError extends HomeState {
  const HomeStateError({required this.message});

  final String message;
}
