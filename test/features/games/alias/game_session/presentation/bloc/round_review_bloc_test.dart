import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_event.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';

RoundReviewBloc _bloc({
  required GameMode gameMode,
  List<ReviewedWord>? words,
}) {
  return RoundReviewBloc(
    words:
        words ??
        const [
          (word: 'a', status: WordReviewStatus.guessed),
          (word: 'b', status: WordReviewStatus.skipped),
          (word: 'c', status: WordReviewStatus.notGuessed),
        ],
    gameMode: gameMode,
    wordsPerCard: 2,
  );
}

void main() {
  group('ToggleWord in card mode', () {
    test('guessed toggles to not guessed and back', () async {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);

      bloc.add(const ToggleWord(index: 0));
      await pumpEventQueue();
      expect(bloc.state.reviewedWords[0].status, WordReviewStatus.notGuessed);

      bloc.add(const ToggleWord(index: 0));
      await pumpEventQueue();
      expect(bloc.state.reviewedWords[0].status, WordReviewStatus.guessed);
    });

    test('skipped and not guessed both toggle to guessed', () async {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);

      bloc
        ..add(const ToggleWord(index: 1))
        ..add(const ToggleWord(index: 2));
      await pumpEventQueue();

      expect(bloc.state.reviewedWords[1].status, WordReviewStatus.guessed);
      expect(bloc.state.reviewedWords[2].status, WordReviewStatus.guessed);
    });
  });

  group('ToggleWord in single word mode', () {
    test('a guessed non-last word becomes skipped', () async {
      final bloc = _bloc(gameMode: GameMode.singleWord);
      addTearDown(bloc.close);

      bloc.add(const ToggleWord(index: 0));
      await pumpEventQueue();

      expect(bloc.state.reviewedWords[0].status, WordReviewStatus.skipped);
    });

    test('the last word skips the skipped state', () async {
      final bloc = _bloc(
        gameMode: GameMode.singleWord,
        words: const [
          (word: 'a', status: WordReviewStatus.notGuessed),
          (word: 'b', status: WordReviewStatus.guessed),
        ],
      );
      addTearDown(bloc.close);

      bloc.add(const ToggleWord(index: 1));
      await pumpEventQueue();

      expect(bloc.state.reviewedWords[1].status, WordReviewStatus.notGuessed);
    });
  });

  group('ToggleWord bounds', () {
    test('out of range indexes are ignored', () async {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);
      final initial = bloc.state;

      bloc
        ..add(const ToggleWord(index: -1))
        ..add(const ToggleWord(index: 99));
      await pumpEventQueue();

      expect(bloc.state, initial);
    });
  });

  group('UpdateGuessedWords', () {
    test(
      'marks exactly the given words guessed, the rest not guessed',
      () async {
        final bloc = _bloc(gameMode: GameMode.card);
        addTearDown(bloc.close);

        bloc.add(const UpdateGuessedWords(guessedWords: {'b', 'c'}));
        await pumpEventQueue();

        expect(
          bloc.state.reviewedWords.map((w) => w.status).toList(),
          [
            WordReviewStatus.notGuessed,
            WordReviewStatus.guessed,
            WordReviewStatus.guessed,
          ],
        );
      },
    );
  });

  group('RoundReviewState getters', () {
    test('guessedCount counts only guessed words', () {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);

      expect(bloc.state.guessedCount, 1);
    });

    test('pagedReviewedWords chunks by wordsPerCard', () {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);

      final pages = bloc.state.pagedReviewedWords;
      expect(pages, hasLength(2));
      expect(pages[0]!.map((w) => w.word), ['a', 'b']);
      expect(pages[1]!.map((w) => w.word), ['c']);
    });

    test('guessedByPage exposes guessed words per page', () {
      final bloc = _bloc(gameMode: GameMode.card);
      addTearDown(bloc.close);

      expect(bloc.state.guessedByPage, {
        0: {'a'},
        1: <String>{},
      });
    });
  });
}
