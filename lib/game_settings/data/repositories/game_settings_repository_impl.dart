import 'package:bardak/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';
import 'package:bardak/game_settings/domain/usecases/update_game_settings_usecase.dart';

class GameSettingsRepositoryImpl implements GameSettingsRepository {
  const GameSettingsRepositoryImpl({required this.dataSource});

  final GameSettingsLocalDataSource dataSource;

  @override
  GameSettingsEntity getGameSettings() => dataSource.getGameSettings();

  @override
  Future<bool> updateGameSettings(UpdateGameSettingsParams params) {
    return dataSource.updateGameSettings(params);
  }
}
