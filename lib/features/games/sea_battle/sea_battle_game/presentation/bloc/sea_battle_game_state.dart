import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:equatable/equatable.dart';

class SeaBattleGameState extends Equatable {
  const SeaBattleGameState({required this.battle});

  final SeaBattleEntity battle;

  @override
  List<Object?> get props => [battle];
}
