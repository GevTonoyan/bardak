import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReviewedWordsX.totalScore', () {
    test('guessed words add one point each', () {
      final words = <ReviewedWord>[
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.guessed),
      ];

      expect(words.totalScore, 2);
    });

    test('skipped words subtract one point', () {
      final words = <ReviewedWord>[
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.guessed),
        (word: 'c', status: WordReviewStatus.skipped),
      ];

      expect(words.totalScore, 1);
    });

    test('not guessed words leave the score unchanged', () {
      final words = <ReviewedWord>[
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.notGuessed),
      ];

      expect(words.totalScore, 1);
    });

    test('score is clamped at zero after each word in play order', () {
      // skip first (0 -> clamped 0), then guess twice.
      final words = <ReviewedWord>[
        (word: 'a', status: WordReviewStatus.skipped),
        (word: 'b', status: WordReviewStatus.guessed),
        (word: 'c', status: WordReviewStatus.guessed),
      ];

      expect(words.totalScore, 2);
    });

    test('clamping depends on order, not totals', () {
      // guess (1), skip (0), skip (clamped 0), guess (1).
      final words = <ReviewedWord>[
        (word: 'a', status: WordReviewStatus.guessed),
        (word: 'b', status: WordReviewStatus.skipped),
        (word: 'c', status: WordReviewStatus.skipped),
        (word: 'd', status: WordReviewStatus.guessed),
      ];

      expect(words.totalScore, 1);
    });

    test('empty list scores zero', () {
      expect(<ReviewedWord>[].totalScore, 0);
    });
  });

  group('WordReviewStatusX.isGuessed', () {
    test('only guessed reports true', () {
      expect(WordReviewStatus.guessed.isGuessed, isTrue);
      expect(WordReviewStatus.skipped.isGuessed, isFalse);
      expect(WordReviewStatus.notGuessed.isGuessed, isFalse);
    });
  });
}
