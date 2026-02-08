import 'package:boardify/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:boardify/rewards/data/repositories/rewards_repository_impl.dart';
import 'package:boardify/rewards/domain/repositories/rewards_repository.dart';
import 'package:boardify/rewards/domain/usecases/update_coins_usecase.dart';
import 'package:boardify/rewards/domain/usecases/get_coins_state_usecase.dart';
import 'package:boardify/utils/dependency_injection/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> injectRewardsScope() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<UpdateCoinsUseCase>(
      () => UpdateCoinsUseCase(sl()),
    )
    ..registerLazySingleton<GetCoinsStateUseCase>(
      () => GetCoinsStateUseCase(sl()),
    )
    ..registerLazySingleton<RewardsRepository>(
      () => RewardsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<RewardsLocalDataSource>(
      () => RewardsLocalDataSourceImpl(preferences: prefs),
    );
}
