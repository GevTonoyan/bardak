import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_remote_opponent_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';

/// The opponent played by a friend on another phone, through the room
/// with [_code]. One per battle: it counts the shots, which both phones
/// number the same way since only one shot is ever in flight.
class SeaBattleRemoteOpponentRepositoryImpl
    implements SeaBattleOpponentRepository {
  SeaBattleRemoteOpponentRepositoryImpl({
    required this._code,
    required this._playerFleet,
    required this._remoteDataSource,
  });

  final String _code;

  /// This player's fleet, shown to the opponent once the battle is over.
  final FleetEntity _playerFleet;

  final SeaBattleRemoteOpponentDataSource _remoteDataSource;

  /// Shots fired so far by both players: the number of the next one.
  int _shotCount = 0;

  /// This player's ships sunk so far; the last one ends the battle.
  int _playerShipsSunk = 0;

  @override
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell) => _guard(() async {
    final index = _shotCount++;
    await _remoteDataSource.fireShot(_code, index, cell);
    final (result, sunkShip) = await _remoteDataSource.getShotAnswer(
      _code,
      index,
    );
    return ShotEntity(
      shooter: .player,
      cell: cell,
      result: result,
      sunkShip: sunkShip,
    );
  });

  /// The opponent aims on their own phone, so [playerBoard] is not needed.
  @override
  Future<BoardCoordinate> getOpponentShot(SeaBattleBoardEntity playerBoard) =>
      _guard(() => _remoteDataSource.getOpponentShot(_code, _shotCount));

  @override
  Future<void> reportOpponentShot(ShotEntity shot) => _guard(() {
    if (shot.result == .sunk) _playerShipsSunk++;
    return _remoteDataSource.answerShot(
      _code,
      _shotCount++,
      result: shot.result,
      sunkShip: shot.sunkShip,
      isFleetSunk: _playerShipsSunk == FleetEntity.shipCount,
    );
  });

  @override
  Future<FleetEntity> getOpponentFleet() => _guard(() async {
    await _remoteDataSource.revealFleet(_code, _playerFleet);
    return _remoteDataSource.getOpponentFleet(_code);
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SeaBattleRoomException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SeaBattleRoomException(.connection, cause: error),
        stackTrace,
      );
    }
  }
}
