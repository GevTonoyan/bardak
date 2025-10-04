import 'dart:async';

import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_session_event.dart';

part 'game_session_state.dart';

class GameSessionBloc extends Bloc<GameSessionEvent, GameSessionState> {
  GameSessionBloc({required GameSessionEntity initialGameState})
    : super(GameSessionState(initialGameState)) {
    on<RoundEnded>(_onWordsConsumed);
  }

  FutureOr<void> _onWordsConsumed(
    RoundEnded event,
    Emitter<GameSessionState> emit,
  ) {
    final gameState = state.gameState;

    final newRemainingWords =
        state.gameState.words.skip(event.wordsShown).toList();

    final currentTeamIndex = gameState.currentTeamIndex;
    gameState.teamStates[currentTeamIndex].addRoundScore(event.guessedCount);

    final allTeamsPlayedRound =
        currentTeamIndex + 1 >= gameState.teamStates.length;

    final (nextTeamIndex, nextRoundIndex) = switch (allTeamsPlayedRound) {
      true => (0, gameState.currentRoundIndex + 1),
      false => (currentTeamIndex + 1, gameState.currentRoundIndex),
    };

    emit(
      GameSessionState(
        state.gameState.copyWith(
          words: newRemainingWords,
          currentRoundIndex: nextRoundIndex,
          currentTeamIndex: nextTeamIndex,
        ),
      ),
    );
  }
}
