import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:equatable/equatable.dart';

class GameSettingsState extends Equatable {
  const GameSettingsState({required this.gameSettings});

  final GameSettingsEntity gameSettings;

  @override
  List<Object?> get props => [gameSettings];
}
