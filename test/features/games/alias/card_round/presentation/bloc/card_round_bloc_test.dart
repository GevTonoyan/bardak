import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_event.dart';
import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_state.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:flutter_test/flutter_test.dart';

CardRoundBloc _bloc({
  List<String> words = const ['a', 'b', 'c', 'd'],
  int wordsPerCard = 2,
}) {
  return CardRoundBloc(
    words: words,
    wordsPerCard: wordsPerCard,
    soundEnabled: false,
  );
}

void main() {
  group('ToggleWord', () {
    test('marks and unmarks a word as guessed', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc.add(const ToggleWord(word: 'a', isSelected: true));
      await pumpEventQueue();
      expect(bloc.state.guessed, {'a'});

      bloc.add(const ToggleWord(word: 'a', isSelected: false));
      await pumpEventQueue();
      expect(bloc.state.guessed, isEmpty);
    });

    test('completing the visible card advances to the next page', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc
        ..add(const ToggleWord(word: 'a', isSelected: true))
        ..add(const ToggleWord(word: 'b', isSelected: true));
      await pumpEventQueue();

      expect(bloc.state.page, 1);
      expect(bloc.state.visible, ['c', 'd']);
      expect(bloc.state.completed, isFalse);
    });

    test('completing the last card completes the round', () async {
      final bloc = _bloc(words: const ['a', 'b']);
      addTearDown(bloc.close);

      bloc
        ..add(const ToggleWord(word: 'a', isSelected: true))
        ..add(const ToggleWord(word: 'b', isSelected: true));
      await pumpEventQueue();

      expect(bloc.state.completed, isTrue);
    });

    test('is ignored once the round is completed', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      bloc.add(const CompleteRound());
      await pumpEventQueue();

      final emissions = <CardRoundState>[];
      final subscription = bloc.stream.listen(emissions.add);
      addTearDown(subscription.cancel);

      bloc
        ..add(const ToggleWord(word: 'a', isSelected: true))
        ..add(const ToggleWord(word: 'a', isSelected: false));
      await pumpEventQueue();

      expect(emissions, isEmpty);
    });
  });

  group('CompleteRound', () {
    test('completes the round once and is idempotent', () async {
      final bloc = _bloc();
      addTearDown(bloc.close);

      final completedEmissions = <CardRoundState>[];
      final subscription = bloc.stream
          .where((s) => s.completed)
          .listen(completedEmissions.add);
      addTearDown(subscription.cancel);

      bloc
        ..add(const CompleteRound())
        ..add(const CompleteRound());
      await pumpEventQueue();

      expect(bloc.state.completed, isTrue);
      expect(completedEmissions, hasLength(1));
    });
  });

  group('CardRoundState', () {
    test('visible returns the current page of words', () {
      const state = CardRoundState(
        words: ['a', 'b', 'c'],
        wordsPerCard: 2,
        soundEnabled: false,
        page: 1,
      );

      expect(state.visible, ['c']);
      expect(state.isLastPage, isTrue);
      expect(state.seenWordsCount, 3);
    });

    test('wordsToReview reports guessed and not guessed seen words', () {
      const state = CardRoundState(
        words: ['a', 'b', 'c', 'd'],
        wordsPerCard: 2,
        soundEnabled: false,
        guessed: {'a'},
      );

      expect(state.wordsToReview(), [
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.notGuessed),
      ]);
    });
  });
}
