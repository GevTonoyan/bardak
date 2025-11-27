import 'package:boardify/settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/settings/domain/entities/game_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.appSettings, required this.gameSettings});

  final AppSettingsEntity appSettings;
  final GameSettingsEntity gameSettings;

  SettingsState copyWith({
    AppSettingsEntity? appSettings,
    GameSettingsEntity? gameSettings,
  }) {
    return SettingsState(
      appSettings: appSettings ?? this.appSettings,
      gameSettings: gameSettings ?? this.gameSettings,
    );
  }

  @override
  List<Object?> get props => [appSettings, gameSettings];
}
