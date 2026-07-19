import 'package:bardak/features/games/alias/game_session/domain/entities/team_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamEntity', () {
    test('totalScore sums all round scores', () {
      const team = TeamEntity(name: 'Reds', roundScores: [3, 5, 0, 2]);

      expect(team.totalScore, 10);
    });

    test('totalScore is 0 with no rounds played', () {
      const team = TeamEntity(name: 'Reds');

      expect(team.totalScore, 0);
    });

    test('withRoundScore appends to the history', () {
      const team = TeamEntity(name: 'Reds', roundScores: [3]);

      final updated = team.withRoundScore(7);

      expect(updated.roundScores, [3, 7]);
      expect(updated.name, 'Reds');
      // Original is untouched.
      expect(team.roundScores, [3]);
    });

    test('withLastRoundScore replaces only the most recent score', () {
      const team = TeamEntity(name: 'Reds', roundScores: [3, 5]);

      final updated = team.withLastRoundScore(9);

      expect(updated.roundScores, [3, 9]);
    });

    test('value equality', () {
      expect(
        const TeamEntity(name: 'A', roundScores: [1]),
        const TeamEntity(name: 'A', roundScores: [1]),
      );
      expect(
        const TeamEntity(name: 'A', roundScores: [1]),
        isNot(const TeamEntity(name: 'A', roundScores: [2])),
      );
    });
  });
}
