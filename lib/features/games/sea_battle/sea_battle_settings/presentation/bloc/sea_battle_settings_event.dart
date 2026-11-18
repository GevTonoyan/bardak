import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleSettingsEvent extends Equatable {
  const SeaBattleSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Changes and persists the game mode.
class ChangeSeaBattleMode extends SeaBattleSettingsEvent {
  const ChangeSeaBattleMode(this.mode);

  final SeaBattleMode mode;

  @override
  List<Object?> get props => [mode];
}

/// Changes and persists the bot difficulty.
class ChangeBotDifficulty extends SeaBattleSettingsEvent {
  const ChangeBotDifficulty(this.botDifficulty);

  final SeaBattleBotDifficulty botDifficulty;

  @override
  List<Object?> get props => [botDifficulty];
}
