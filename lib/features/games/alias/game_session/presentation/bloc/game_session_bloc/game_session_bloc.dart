import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_event.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSessionBloc extends Bloc<GameSessionEvent, GameSessionState> {
  GameSessionBloc({required GameSessionEntity initialSession})
    : super(GameSessionState(session: initialSession)) {
    on<FinishRound>(_onFinishRound);
    on<FinishRoundReview>(_onFinishRoundReview);
  }

  void _onFinishRound(FinishRound event, Emitter<GameSessionState> emit) {
    final session = state.session;
    final currentTeamIndex = session.currentTeamIndex;

    final teams = [...session.teams];
    teams[currentTeamIndex] = teams[currentTeamIndex].withRoundScore(
      event.reviewedWords.totalScore,
    );

    final allTeamsPlayedRound = currentTeamIndex + 1 >= teams.length;

    final (nextTeamIndex, nextRoundIndex) = switch (allTeamsPlayedRound) {
      true => (0, session.currentRoundIndex + 1),
      false => (currentTeamIndex + 1, session.currentRoundIndex),
    };

    final updated = session.copyWith(
      teams: teams,
      remainingWords: session.remainingWords
          .skip(event.reviewedWords.length)
          .toList(),
      currentRoundIndex: nextRoundIndex,
      currentTeamIndex: nextTeamIndex,
      previousTeamIndex: currentTeamIndex,
      pendingReviewWords: event.reviewedWords,
    );

    final winningTeamIndex = allTeamsPlayedRound
        ? updated.findWinningTeamIndex()
        : null;

    emit(
      GameSessionState(
        session: updated.copyWith(
          isGameFinished: winningTeamIndex != null,
          winningTeamIndex: winningTeamIndex,
        ),
      ),
    );
  }

  void _onFinishRoundReview(
    FinishRoundReview event,
    Emitter<GameSessionState> emit,
  ) {
    final session = state.session;
    final lastPlayedTeamIndex = session.previousTeamIndex;

    final teams = [...session.teams];
    teams[lastPlayedTeamIndex] = teams[lastPlayedTeamIndex].withLastRoundScore(
      event.reviewedWords.totalScore,
    );

    emit(
      GameSessionState(
        session: session.copyWith(
          teams: teams,
          pendingReviewWords: event.reviewedWords,
        ),
      ),
    );
  }
}
