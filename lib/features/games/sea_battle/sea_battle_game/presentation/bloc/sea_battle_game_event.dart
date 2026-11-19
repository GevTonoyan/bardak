import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleGameEvent extends Equatable {
  const SeaBattleGameEvent();

  @override
  List<Object?> get props => [];
}

/// The player fires at [cell] on the opponent's board.
final class FireShot extends SeaBattleGameEvent {
  const FireShot(this.cell);

  final BoardCoordinate cell;

  @override
  List<Object?> get props => [cell];
}

/// The bot takes its shot at the player's board.
final class FireBotShot extends SeaBattleGameEvent {
  const FireBotShot();
}
