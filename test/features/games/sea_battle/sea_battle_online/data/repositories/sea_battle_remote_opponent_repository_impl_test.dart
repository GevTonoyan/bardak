import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_remote_opponent_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/repositories/sea_battle_remote_opponent_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock
    implements SeaBattleRemoteOpponentDataSource {}

void main() {
  late _MockDataSource dataSource;
  late SeaBattleRemoteOpponentRepositoryImpl repository;

  const code = 'ABC234';
  const cell = BoardCoordinate(3, 4);
  const ship = ShipEntity(id: 9, length: 1, origin: cell);
  final playerFleet = const FleetEntity().withShip(ship);
  final opponentFleet = const FleetEntity().withShip(
    const ShipEntity(id: 9, length: 1, origin: BoardCoordinate(0, 0)),
  );

  setUpAll(() {
    registerFallbackValue(cell);
    registerFallbackValue(ShotResult.miss);
    registerFallbackValue(const FleetEntity());
  });

  setUp(() {
    dataSource = _MockDataSource();
    repository = SeaBattleRemoteOpponentRepositoryImpl(
      code: code,
      playerFleet: playerFleet,
      remoteDataSource: dataSource,
    );
    when(() => dataSource.fireShot(code, any(), any()))
        .thenAnswer((_) async {});
    when(
      () => dataSource.answerShot(
        code,
        any(),
        result: any(named: 'result'),
        sunkShip: any(named: 'sunkShip'),
        isFleetSunk: any(named: 'isFleetSunk'),
      ),
    ).thenAnswer((_) async {});
  });

  ShotEntity opponentShot(ShotResult result, {ShipEntity? sunkShip}) =>
      ShotEntity(
        shooter: .opponent,
        cell: cell,
        result: result,
        sunkShip: sunkShip,
      );

  test('the player shot is numbered and answered by the opponent', () async {
    when(
      () => dataSource.getShotAnswer(code, 0),
    ).thenAnswer((_) async => (ShotResult.sunk, ship));

    final shot = await repository.answerPlayerShot(cell);

    verify(() => dataSource.fireShot(code, 0, cell)).called(1);
    expect(
      shot,
      const ShotEntity(
        shooter: .player,
        cell: cell,
        result: .sunk,
        sunkShip: ship,
      ),
    );
  });

  test('both players shots share one count', () async {
    when(
      () => dataSource.getShotAnswer(code, 0),
    ).thenAnswer((_) async => (ShotResult.miss, null));
    when(
      () => dataSource.getOpponentShot(code, 1),
    ).thenAnswer((_) async => const BoardCoordinate(1, 1));

    await repository.answerPlayerShot(cell);
    final shot = await repository.getOpponentShot(
      const SeaBattleBoardEntity(),
    );
    await repository.reportOpponentShot(opponentShot(.miss));

    expect(shot, const BoardCoordinate(1, 1));
    verify(
      () => dataSource.answerShot(
        code,
        1,
        result: ShotResult.miss,
        sunkShip: null,
        isFleetSunk: false,
      ),
    ).called(1);
  });

  test('losing the last ship ends the battle', () async {
    for (var i = 0; i < FleetEntity.shipCount; i++) {
      await repository.reportOpponentShot(
        opponentShot(.sunk, sunkShip: ship),
      );
    }

    verify(
      () => dataSource.answerShot(
        code,
        FleetEntity.shipCount - 1,
        result: ShotResult.sunk,
        sunkShip: ship,
        isFleetSunk: true,
      ),
    ).called(1);
    verify(
      () => dataSource.answerShot(
        code,
        any(),
        result: any(named: 'result'),
        sunkShip: any(named: 'sunkShip'),
        isFleetSunk: false,
      ),
    ).called(FleetEntity.shipCount - 1);
  });

  test('the opponent fleet is shown after the player reveals theirs', () async {
    when(
      () => dataSource.revealFleet(code, playerFleet),
    ).thenAnswer((_) async {});
    when(
      () => dataSource.getOpponentFleet(code),
    ).thenAnswer((_) async => opponentFleet);

    expect(await repository.getOpponentFleet(), opponentFleet);
    verifyInOrder([
      () => dataSource.revealFleet(code, playerFleet),
      () => dataSource.getOpponentFleet(code),
    ]);
  });

  test('errors become connection failures', () async {
    when(
      () => dataSource.getOpponentShot(code, any()),
    ).thenThrow(Exception('offline'));

    await expectLater(
      repository.getOpponentShot(const SeaBattleBoardEntity()),
      throwsA(
        isA<SeaBattleRoomException>().having(
          (error) => error.reason,
          'reason',
          SeaBattleRoomFailure.connection,
        ),
      ),
    );
  });
}
