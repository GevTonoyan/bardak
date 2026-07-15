import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/team_entity.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_event.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';

GameSessionEntity _threeTeamSession({
  int pointsToWin = 60,
  List<String> words = const ['w1', 'w2', 'w3', 'w4', 'w5', 'w6'],
}) {
  return GameSessionEntity(
    gameMode: GameMode.card,
    teams: const [
      TeamEntity(name: 'T1'),
      TeamEntity(name: 'T2'),
      TeamEntity(name: 'T3'),
    ],
    roundDuration: 60,
    pointsToWin: pointsToWin,
    soundEnabled: false,
    wordsPerCard: 6,
    allowSkipping: true,
    remainingWords: words,
  );
}

List<ReviewedWord> _guessed(List<String> words) => [
  for (final word in words) (word: word, status: WordReviewStatus.guessed),
];

void main() {
  group('FinishRound team rotation', () {
    test(
      'advances through all three teams then wraps to a new round',
      () async {
        final bloc = GameSessionBloc(initialSession: _threeTeamSession());
        addTearDown(bloc.close);

        bloc.add(FinishRound(reviewedWords: _guessed(['w1'])));
        await pumpEventQueue();
        var session = bloc.state.session;
        expect(session.currentTeamIndex, 1);
        expect(session.previousTeamIndex, 0);
        expect(session.currentRoundIndex, 0);

        bloc.add(FinishRound(reviewedWords: _guessed(['w2'])));
        await pumpEventQueue();
        session = bloc.state.session;
        expect(session.currentTeamIndex, 2);
        expect(session.previousTeamIndex, 1);
        expect(session.currentRoundIndex, 0);

        bloc.add(FinishRound(reviewedWords: _guessed(['w3'])));
        await pumpEventQueue();
        session = bloc.state.session;
        expect(session.currentTeamIndex, 0);
        expect(session.previousTeamIndex, 2);
        expect(session.currentRoundIndex, 1);
      },
    );

    test('records the round score for the team that played', () async {
      final bloc = GameSessionBloc(initialSession: _threeTeamSession());
      addTearDown(bloc.close);

      bloc.add(
        const FinishRound(
          reviewedWords: [
            (word: 'w1', status: WordReviewStatus.guessed),
            (word: 'w2', status: WordReviewStatus.guessed),
            (word: 'w3', status: WordReviewStatus.skipped),
          ],
        ),
      );
      await pumpEventQueue();

      final teams = bloc.state.session.teams;
      expect(teams[0].roundScores, [1]);
      expect(teams[1].roundScores, isEmpty);
      expect(teams[2].roundScores, isEmpty);
    });

    test('consumes exactly the played words from remainingWords', () async {
      final bloc = GameSessionBloc(initialSession: _threeTeamSession());
      addTearDown(bloc.close);

      bloc.add(FinishRound(reviewedWords: _guessed(['w1', 'w2'])));
      await pumpEventQueue();

      expect(bloc.state.session.remainingWords, ['w3', 'w4', 'w5', 'w6']);
      expect(bloc.state.session.pendingReviewWords, hasLength(2));
    });
  });

  group('winner detection', () {
    test('never declares a winner mid-round', () async {
      final bloc = GameSessionBloc(
        initialSession: _threeTeamSession(pointsToWin: 1),
      );
      addTearDown(bloc.close);

      // Team 1 reaches the target, but teams 2 and 3 have not played yet.
      bloc.add(FinishRound(reviewedWords: _guessed(['w1'])));
      await pumpEventQueue();

      expect(bloc.state.session.isGameFinished, isFalse);
      expect(bloc.state.session.winningTeamIndex, isNull);
    });

    test('declares the leader once the full round is complete', () async {
      final bloc = GameSessionBloc(
        initialSession: _threeTeamSession(pointsToWin: 1),
      );
      addTearDown(bloc.close);

      bloc
        ..add(FinishRound(reviewedWords: _guessed(['w1', 'w2'])))
        ..add(FinishRound(reviewedWords: _guessed(['w3'])))
        ..add(const FinishRound(reviewedWords: []));
      await pumpEventQueue();

      expect(bloc.state.session.isGameFinished, isTrue);
      expect(bloc.state.session.winningTeamIndex, 0);
    });

    test('a tie at the top keeps the game going', () async {
      final bloc = GameSessionBloc(
        initialSession: _threeTeamSession(pointsToWin: 1),
      );
      addTearDown(bloc.close);

      bloc
        ..add(FinishRound(reviewedWords: _guessed(['w1'])))
        ..add(FinishRound(reviewedWords: _guessed(['w2'])))
        ..add(const FinishRound(reviewedWords: []));
      await pumpEventQueue();

      expect(bloc.state.session.isGameFinished, isFalse);
      expect(bloc.state.session.winningTeamIndex, isNull);
    });
  });

  group('FinishRoundReview', () {
    test(
      'replaces the last played team score with the corrected one',
      () async {
        final bloc = GameSessionBloc(initialSession: _threeTeamSession());
        addTearDown(bloc.close);

        bloc.add(FinishRound(reviewedWords: _guessed(['w1', 'w2'])));
        await pumpEventQueue();
        expect(bloc.state.session.teams[0].roundScores, [2]);

        // Review flips one word to not guessed: corrected score is 1.
        bloc.add(
          const FinishRoundReview(
            reviewedWords: [
              (word: 'w1', status: WordReviewStatus.guessed),
              (word: 'w2', status: WordReviewStatus.notGuessed),
            ],
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.session.teams[0].roundScores, [1]);
        // Rotation state is untouched by a review.
        expect(bloc.state.session.currentTeamIndex, 1);
      },
    );
  });
}
