import 'package:bardak/features/games/sea_battle/sea_battle_game/data/data_sources/sea_battle_opponent_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// The opponent played by the bot on the device.
class SeaBattleOpponentRepositoryImpl implements SeaBattleOpponentRepository {
  const SeaBattleOpponentRepositoryImpl({required this._localDataSource});

  final SeaBattleOpponentLocalDataSource _localDataSource;

  @override
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell) =>
      _localDataSource.answerPlayerShot(cell);

  @override
  Future<BoardCoordinate> getOpponentShot(SeaBattleBoardEntity playerBoard) =>
      _localDataSource.getOpponentShot(playerBoard);

  /// The bot works out its own results, so it needs no report.
  @override
  Future<void> reportOpponentShot(ShotEntity shot) async {}

  @override
  Future<FleetEntity> getOpponentFleet() => _localDataSource.getOpponentFleet();

  /// The bot never leaves.
  @override
  Stream<void> watchOpponentLeft() => const Stream.empty();

  /// The bot lives only as long as the battle, so it needs no goodbye.
  @override
  Future<void> leaveBattle() async {}
}
