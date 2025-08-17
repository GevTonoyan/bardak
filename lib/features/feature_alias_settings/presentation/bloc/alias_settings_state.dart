import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/app_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final AppSettingsEntity appSettings;
  final GameSettingsEntity gameSettings;

  const SettingsState({required this.appSettings, required this.gameSettings});

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
