import 'package:boardify/features/home/feature_home_scope.dart';
import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/word_pack/word_packs_scope.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> injectDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<SharedPreferences>(() => prefs)
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
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(preferences: sl()),
    );

  await injectWordPacksScope();
  injectHomeScope();
}
