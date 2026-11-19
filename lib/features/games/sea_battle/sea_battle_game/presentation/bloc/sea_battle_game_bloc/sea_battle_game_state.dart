import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_entity.dart';
import 'package:equatable/equatable.dart';

class SeaBattleGameState extends Equatable {
  const SeaBattleGameState({required this.battle, this.lastShot});

  final SeaBattleEntity battle;

  /// The most recent shot by either side, to highlight it on the board.
  final ShotEntity? lastShot;

  @override
  List<Object?> get props => [battle, lastShot];
}
