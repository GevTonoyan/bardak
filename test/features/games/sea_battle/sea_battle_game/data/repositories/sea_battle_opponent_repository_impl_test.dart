import 'package:bardak/features/games/sea_battle/sea_battle_game/data/data_sources/sea_battle_opponent_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/data/repositories/sea_battle_opponent_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock
    implements SeaBattleOpponentLocalDataSource {}

void main() {
  late _MockLocalDataSource localDataSource;
  late SeaBattleOpponentRepositoryImpl repository;

  const cell = BoardCoordinate(3, 4);
  const shot = ShotEntity(shooter: .player, cell: cell, result: .miss);

  setUp(() {
    localDataSource = _MockLocalDataSource();
    repository = SeaBattleOpponentRepositoryImpl(
      localDataSource: localDataSource,
    );
  });

  test('answerPlayerShot asks the bot', () async {
    when(() => localDataSource.answerPlayerShot(cell)).thenAnswer(
      (_) async => shot,
    );

    expect(await repository.answerPlayerShot(cell), shot);
  });

  test('getOpponentShot asks the bot', () async {
    const board = SeaBattleBoardEntity();
    when(() => localDataSource.getOpponentShot(board)).thenAnswer(
      (_) async => cell,
    );

    expect(await repository.getOpponentShot(board), cell);
  });

  test('getOpponentFleet asks the bot', () async {
    const fleet = FleetEntity();
    when(localDataSource.getOpponentFleet).thenAnswer((_) async => fleet);

    expect(await repository.getOpponentFleet(), fleet);
  });

  test('reportOpponentShot needs nothing from the bot', () async {
    await repository.reportOpponentShot(shot);

    verifyZeroInteractions(localDataSource);
  });
}
