import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_side.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:equatable/equatable.dart';

/// A shot fired by [shooter] at [cell] on the other side's board.
class ShotEntity extends Equatable {
  const ShotEntity({
    required this.shooter,
    required this.cell,
    required this.result,
  });

  final SeaBattleSide shooter;
  final BoardCoordinate cell;
  final ShotResult result;

  @override
  List<Object?> get props => [shooter, cell, result];
}
