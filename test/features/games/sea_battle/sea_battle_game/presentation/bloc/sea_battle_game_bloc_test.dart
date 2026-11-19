import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/report_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStartSeaBattleUseCase extends Mock
    implements StartSeaBattleUseCase {}

/// An opponent with a known fleet that fires at the given shots in order.
class _FakeOpponent implements SeaBattleOpponentRepository {
  _FakeOpponent({required this.fleet, List<BoardCoordinate> shots = const []})
    : _shots = [...shots],
      _board = SeaBattleBoardEntity(fleet: fleet);

  final FleetEntity fleet;
  final List<BoardCoordinate> _shots;
  SeaBattleBoardEntity _board;

  final reported = <ShotEntity>[];
  final seenBoards = <SeaBattleBoardEntity>[];
  int fleetRequests = 0;

  @override
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell) async {
    final (result, sunkShip) = _board.answer(cell);
    _board = _board.record(cell, result, sunkShip: sunkShip);
    return ShotEntity(
      shooter: .player,
      cell: cell,
      result: result,
      sunkShip: sunkShip,
    );
  }

  @override
  Future<BoardCoordinate> getOpponentShot(
    SeaBattleBoardEntity playerBoard,
  ) async {
    seenBoards.add(playerBoard);
    return _shots.removeAt(0);
  }

  @override
  Future<void> reportOpponentShot(ShotEntity shot) async => reported.add(shot);

  @override
  Future<FleetEntity> getOpponentFleet() async {
    fleetRequests++;
    return fleet;
  }
}

/// The player's two-cell ship at the top-left.
const _playerShip = ShipEntity(
  id: 0,
  length: 2,
  origin: BoardCoordinate(0, 0),
);
final FleetEntity _playerFleet = const FleetEntity().withShip(_playerShip);

/// A full random fleet for the opponent, so sinking all of it wins.
final FleetEntity _opponentFleet = FleetEntity.random(Random(4));

/// A cell with no ship on [fleet].
BoardCoordinate _water(FleetEntity fleet, {int skip = 0}) => [
  for (var row = 0; row < BoardCoordinate.boardSize; row++)
    for (var column = 0; column < BoardCoordinate.boardSize; column++)
      BoardCoordinate(row, column),
].where((cell) => fleet.shipAt(cell) == null).elementAt(skip);

void main() {
  late _MockStartSeaBattleUseCase startSeaBattle;

  setUpAll(() => registerFallbackValue(const FleetEntity()));

  setUp(() => startSeaBattle = _MockStartSeaBattleUseCase());

  SeaBattleGameBloc buildBloc(
    _FakeOpponent opponent, {
    SeaBattleSide firstShooter = .player,
    FleetEntity? playerFleet,
  }) {
    when(() => startSeaBattle(any())).thenReturn(
      SeaBattleEntity(
        playerBoard: SeaBattleBoardEntity(fleet: playerFleet ?? _playerFleet),
        opponentBoard: const SeaBattleBoardEntity(),
        turn: firstShooter,
      ),
    );
    final bloc = SeaBattleGameBloc(
      playerFleet: _playerFleet,
      startSeaBattleUseCase: startSeaBattle,
      fireAtOpponentUseCase: FireAtOpponentUseCase(opponent),
      getOpponentShotUseCase: GetOpponentShotUseCase(opponent),
      reportOpponentShotUseCase: ReportOpponentShotUseCase(opponent),
      getOpponentFleetUseCase: GetOpponentFleetUseCase(opponent),
    );
    addTearDown(bloc.close);
    return bloc;
  }

  test('a player miss hands the turn over, and the opponent fires back '
      'and is told the result', () async {
    final opponent = _FakeOpponent(
      fleet: _opponentFleet,
      shots: [const BoardCoordinate(5, 5)],
    );
    final missCell = _water(_opponentFleet);
    final bloc = buildBloc(opponent)..add(FireShot(missCell));
    await pumpEventQueue();

    final battle = bloc.state.battle;
    expect(battle.opponentBoard.missCells, {missCell});
    expect(battle.playerBoard.missCells, {const BoardCoordinate(5, 5)});
    expect(battle.turn, SeaBattleSide.player);
    const expected = ShotEntity(
      shooter: .opponent,
      cell: BoardCoordinate(5, 5),
      result: .miss,
    );
    expect(battle.lastShot, expected);
    expect(opponent.reported, [expected]);
  });

  test('the opponent never sees where the player ships are', () async {
    final opponent = _FakeOpponent(
      fleet: _opponentFleet,
      shots: [const BoardCoordinate(5, 5)],
    );
    buildBloc(opponent, firstShooter: .opponent);
    await pumpEventQueue();

    expect(opponent.seenBoards.single.fleet, isNull);
  });

  test('a player hit keeps the turn', () async {
    final opponent = _FakeOpponent(fleet: _opponentFleet);
    final bloc = buildBloc(opponent)
      ..add(FireShot(_opponentFleet.ships.first.origin));
    await pumpEventQueue();

    expect(bloc.state.battle.turn, SeaBattleSide.player);
    expect(bloc.state.battle.lastShot?.result, ShotResult.hit);
    expect(opponent.seenBoards, isEmpty);
  });

  test('the opponent keeps firing while it hits', () async {
    final opponent = _FakeOpponent(
      fleet: _opponentFleet,
      shots: [_playerShip.cells.first, const BoardCoordinate(5, 5)],
    );
    final bloc = buildBloc(opponent)..add(FireShot(_water(_opponentFleet)));
    await pumpEventQueue();

    expect(bloc.state.battle.playerBoard.hitCells, {
      _playerShip.cells.first,
    });
    expect(bloc.state.battle.turn, SeaBattleSide.player);
    expect(opponent.reported, hasLength(2));
  });

  test('the opponent fires first when the battle starts on its turn', () async {
    final opponent = _FakeOpponent(
      fleet: _opponentFleet,
      shots: [const BoardCoordinate(5, 5)],
    );
    final bloc = buildBloc(opponent, firstShooter: .opponent);
    await pumpEventQueue();

    expect(bloc.state.battle.playerBoard.missCells, {
      const BoardCoordinate(5, 5),
    });
    expect(bloc.state.battle.turn, SeaBattleSide.player);
  });

  test(
    'player shots at marked cells or on the opponent turn are ignored',
    () async {
      final missCell = _water(_opponentFleet);
      final opponent = _FakeOpponent(
        fleet: _opponentFleet,
        shots: [const BoardCoordinate(5, 5)],
      );
      final bloc = buildBloc(opponent)..add(FireShot(missCell));
      await pumpEventQueue();
      bloc.add(FireShot(missCell));
      await pumpEventQueue();

      expect(bloc.state.battle.opponentBoard.marked, {missCell});
    },
  );

  test(
    'losing the whole fleet ends the battle and reveals the opponent',
    () async {
      final playerFleet = FleetEntity.random(Random(9));
      final opponent = _FakeOpponent(
        fleet: _opponentFleet,
        shots: [for (final ship in playerFleet.ships) ...ship.cells],
      );
      final bloc = buildBloc(
        opponent,
        firstShooter: .opponent,
        playerFleet: playerFleet,
      );
      await pumpEventQueue(times: 200);

      expect(bloc.state.battle.winner, SeaBattleSide.opponent);
      expect(bloc.state.battle.opponentBoard.fleet, _opponentFleet);
      expect(opponent.reported, hasLength(20));
    },
  );
}
