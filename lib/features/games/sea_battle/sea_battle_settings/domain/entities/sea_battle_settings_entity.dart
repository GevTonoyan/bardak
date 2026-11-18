import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Sea Battle game (mode and bot difficulty).
///
/// The board (10×10), fleet and rules (ships never touch, a hit earns
/// another shot, cells around a sunk ship are auto-marked) are fixed, so
/// they are not part of the settings.
///
/// Persisted, so choices are remembered across sessions.
class SeaBattleSettingsEntity extends Equatable {
  const SeaBattleSettingsEntity({
    this.mode = SeaBattleMode.vsBot,
    this.botDifficulty = SeaBattleBotDifficulty.medium,
  });

  final SeaBattleMode mode;
  final SeaBattleBotDifficulty botDifficulty;

  SeaBattleSettingsEntity copyWith({
    SeaBattleMode? mode,
    SeaBattleBotDifficulty? botDifficulty,
  }) {
    return SeaBattleSettingsEntity(
      mode: mode ?? this.mode,
      botDifficulty: botDifficulty ?? this.botDifficulty,
    );
  }

  @override
  List<Object?> get props => [mode, botDifficulty];
}
