import 'dart:async';

import 'package:alias_pro/game_session/domain/entities/game_session_entity.dart';
import 'package:alias_pro/game_session/domain/entities/round_result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_session_event.dart';

part 'game_session_state.dart';

class GameSessionBloc extends Bloc<GameSessionEvent, GameSessionState> {
  GameSessionBloc({required GameSessionEntity initialGameState})
    : super(GameSessionState(gameState: initialGameState)) {
    on<RoundFinished>(_onRoundEnded);
    on<RoundReviewFinished>(_onRoundReviewFinished);
  }

  FutureOr<void> _onRoundEnded(
    RoundFinished event,
    Emitter<GameSessionState> emit,
  ) {
    final gameState = state.gameState;

    final wordsShown = event.reviewedWords.length;
    final guessedCount = event.reviewedWords.where((e) => e.isGuessed).length;

    final newRemainingWords = state.gameState.words.skip(wordsShown).toList();

    final currentTeamIndex = gameState.currentTeamIndex;
    gameState.teamStates[currentTeamIndex].addRoundScore(guessedCount);

    final allTeamsPlayedRound =
        currentTeamIndex + 1 >= gameState.teamStates.length;

    final (nextTeamIndex, nextRoundIndex) = switch (allTeamsPlayedRound) {
      true => (0, gameState.currentRoundIndex + 1),
      false => (currentTeamIndex + 1, gameState.currentRoundIndex),
    };

    final winnerTeamIndex = allTeamsPlayedRound
        ? gameState.getWinningTeamIndex()
        : null;

    emit(
      state.copyWith(
        gameState: state.gameState.copyWith(
          words: newRemainingWords,
          currentRoundIndex: nextRoundIndex,
          currentTeamIndex: nextTeamIndex,
          previousTeamIndex: currentTeamIndex,
          isGameFinished: winnerTeamIndex != null,
          winningTeamIndex: winnerTeamIndex,
          pendingReviewWords: event.reviewedWords,
        ),
      ),
    );
  }

  FutureOr<void> _onRoundReviewFinished(
    RoundReviewFinished event,
    Emitter<GameSessionState> emit,
  ) {
    final gameState = state.gameState;
    final lastPlayedTeamIndex = gameState.previousTeamIndex;

    gameState.teamStates[lastPlayedTeamIndex].changeLastScore(
      event.guessedCount,
    );

    emit(state);
  }
}
