import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/team_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';

GameSessionEntity _session({
  required List<TeamEntity> teams,
  int pointsToWin = 60,
}) {
  return GameSessionEntity(
    gameMode: GameMode.card,
    teams: teams,
    roundDuration: 60,
    pointsToWin: pointsToWin,
    soundEnabled: false,
    wordsPerCard: 6,
    allowSkipping: true,
    remainingWords: const ['w1', 'w2'],
  );
}

void main() {
  group('GameSessionEntity.findWinningTeamIndex', () {
    test('returns null while nobody reached pointsToWin', () {
      final session = _session(
        teams: const [
          TeamEntity(name: 'A', roundScores: [30]),
          TeamEntity(name: 'B', roundScores: [59]),
        ],
      );

      expect(session.findWinningTeamIndex(), isNull);
    });

    test('returns the single qualified team', () {
      final session = _session(
        teams: const [
          TeamEntity(name: 'A', roundScores: [30]),
          TeamEntity(name: 'B', roundScores: [60]),
          TeamEntity(name: 'C', roundScores: [10]),
        ],
      );

      expect(session.findWinningTeamIndex(), 1);
    });

    test('returns the leader when several teams qualified', () {
      final session = _session(
        teams: const [
          TeamEntity(name: 'A', roundScores: [61]),
          TeamEntity(name: 'B', roundScores: [70]),
          TeamEntity(name: 'C', roundScores: [59]),
        ],
      );

      expect(session.findWinningTeamIndex(), 1);
    });

    test('returns null on a tie at the top so play continues', () {
      final session = _session(
        teams: const [
          TeamEntity(name: 'A', roundScores: [65]),
          TeamEntity(name: 'B', roundScores: [65]),
        ],
      );

      expect(session.findWinningTeamIndex(), isNull);
    });

    test('reaching exactly pointsToWin qualifies', () {
      final session = _session(
        teams: const [
          TeamEntity(name: 'A', roundScores: [60]),
          TeamEntity(name: 'B', roundScores: [0]),
        ],
      );

      expect(session.findWinningTeamIndex(), 0);
    });
  });

  group('GameSessionEntity.copyWith', () {
    test('replaces only the given fields', () {
      final session = _session(
        teams: const [TeamEntity(name: 'A')],
      );

      final updated = session.copyWith(
        currentTeamIndex: 2,
        currentRoundIndex: 1,
      );

      expect(updated.currentTeamIndex, 2);
      expect(updated.currentRoundIndex, 1);
      expect(updated.previousTeamIndex, session.previousTeamIndex);
      expect(updated.teams, session.teams);
      expect(updated.pointsToWin, session.pointsToWin);
    });
  });
}
