import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_event.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_state.dart';
import 'package:flutter_test/flutter_test.dart';

SingleWordRoundBloc _bloc({List<String> words = const ['a', 'b', 'c']}) {
  return SingleWordRoundBloc(
    words: words,
    roundDuration: 60,
    allowSkipping: true,
    soundEnabled: false,
  );
}

void main() {
  group('ResolveCurrentWord', () {
    test('a guess adds a point and advances', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc.add(const ResolveCurrentWord(WordResolution.guessed));
      await pumpEventQueue();

      expect(bloc.state.score, 1);
      expect(bloc.state.index, 1);
      expect(bloc.state.guessedIndexes, {0});
      expect(bloc.state.completed, isFalse);
    });

    test('a skip subtracts a point, clamped at zero', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc.add(const ResolveCurrentWord(WordResolution.skipped));
      await pumpEventQueue();

      expect(bloc.state.score, 0);
      expect(bloc.state.index, 1);
      expect(bloc.state.skippedIndexes, {0});
    });

    test('resolving the last word completes the round', () async {
      final bloc = _bloc(words: const ['a']);
      addTearDown(bloc.close);

      bloc.add(const ResolveCurrentWord(WordResolution.guessed));
      await pumpEventQueue();

      expect(bloc.state.completed, isTrue);
      expect(bloc.state.index, 0);
    });

    test('is ignored once the round is completed', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc.add(const CompleteRound());
      await pumpEventQueue();

      final emissions = <SingleWordRoundState>[];
      final subscription = bloc.stream.listen(emissions.add);
      addTearDown(subscription.cancel);

      bloc.add(const ResolveCurrentWord(WordResolution.guessed));
      await pumpEventQueue();

      expect(emissions, isEmpty);
    });
  });

  group('CompleteRound', () {
    test('completes once and is idempotent', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      final completedEmissions = <SingleWordRoundState>[];
      final subscription = bloc.stream
          .where((s) => s.completed)
          .listen(completedEmissions.add);
      addTearDown(subscription.cancel);

      bloc
        ..add(const CompleteRound())
        ..add(const CompleteRound());
      await pumpEventQueue();

      expect(completedEmissions, hasLength(1));
    });
  });

  group('SingleWordRoundState.wordsToReview', () {
    test('reports every seen word with its resolution', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc
        ..add(const ResolveCurrentWord(WordResolution.guessed))
        ..add(const ResolveCurrentWord(WordResolution.skipped));
      await pumpEventQueue();

      expect(bloc.state.wordsToReview(), [
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.skipped),
        (word: 'c', status: WordReviewStatus.notGuessed),
      ]);
    });
  });
}
