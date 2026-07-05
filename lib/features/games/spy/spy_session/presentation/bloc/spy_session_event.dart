import 'package:equatable/equatable.dart';

sealed class SpySessionEvent extends Equatable {
  const SpySessionEvent();

  @override
  List<Object?> get props => [];
}

/// Finishes the current player's role reveal and moves to the next player.
class FinishPlayerReveal extends SpySessionEvent {
  const FinishPlayerReveal();
}
