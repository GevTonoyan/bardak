import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_agame_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/feature_main/feature_main_scope.dart';
import 'package:boardify/features/feature_word_pack/alias_word_packs_scope.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  /// Register the usecases
  sl
    ..registerLazySingleton<GetAppSettingsUseCase>(
      () => GetAppSettingsUseCase(sl()),
    )
    ..registerLazySingleton<GetGameSettingsUseCase>(
      () => GetGameSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateGameSettingSUseCase>(
      () => UpdateGameSettingSUseCase(sl()),
    )
    ..registerLazySingleton<UpdateAppSettingsUseCase>(
      () => UpdateAppSettingsUseCase(sl()),
    );

  /// Register the repositories
  sl.registerLazySingleton<AliasSettingsRepository>(
    () => AliasSettingsRepositoryImpl(dataSource: sl()),
  );

  /// Register the data sources
  sl.registerLazySingleton<AliasSettingsLocalDataSource>(
    () => AliasSettingsLocalDataSourceImpl(preferences: sl()),
  );

  await injectWordPacksScope();
   injectAliasMainScope();
}
