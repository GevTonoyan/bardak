part of 'game_session_bloc.dart';

sealed class GameSessionEvent extends Equatable {
  const GameSessionEvent();
}

class RoundEnded extends GameSessionEvent {
  const RoundEnded({required this.wordsShown, required this.guessedCount});

  final int wordsShown;
  final int guessedCount;

  @override
  List<Object?> get props => [wordsShown, guessedCount];
}
