import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/report_opponent_shot_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSeaBattleOpponentRepository extends Mock
    implements SeaBattleOpponentRepository {}

void main() {
  late _MockSeaBattleOpponentRepository repository;

  const cell = BoardCoordinate(2, 7);
  const shot = ShotEntity(shooter: .player, cell: cell, result: .hit);

  setUpAll(() => registerFallbackValue(const SeaBattleBoardEntity()));

  setUp(() => repository = _MockSeaBattleOpponentRepository());

  test('FireAtOpponentUseCase returns the opponent answer', () async {
    when(() => repository.answerPlayerShot(cell)).thenAnswer(
      (_) async => shot,
    );

    expect(await FireAtOpponentUseCase(repository)(cell), shot);
  });

  test('GetOpponentShotUseCase never shows the opponent the fleet', () async {
    final playerBoard = SeaBattleBoardEntity(
      fleet: FleetEntity.random(Random(1)),
    ).record(const BoardCoordinate(0, 0), .miss);
    when(() => repository.getOpponentShot(any())).thenAnswer(
      (_) async => cell,
    );

    expect(await GetOpponentShotUseCase(repository)(playerBoard), cell);
    verify(
      () => repository.getOpponentShot(playerBoard.withoutFleet),
    ).called(1);
  });

  test('ReportOpponentShotUseCase reports the shot', () async {
    when(() => repository.reportOpponentShot(shot)).thenAnswer((_) async {});

    await ReportOpponentShotUseCase(repository)(shot);

    verify(() => repository.reportOpponentShot(shot)).called(1);
  });

  test('GetOpponentFleetUseCase returns the revealed fleet', () async {
    final fleet = FleetEntity.random(Random(2));
    when(repository.getOpponentFleet).thenAnswer((_) async => fleet);

    expect(await GetOpponentFleetUseCase(repository)(), fleet);
  });
}
