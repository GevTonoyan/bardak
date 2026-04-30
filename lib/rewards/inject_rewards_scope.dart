import 'package:alias_pro/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:alias_pro/rewards/data/repositories/rewards_repository_impl.dart';
import 'package:alias_pro/rewards/domain/repositories/rewards_repository.dart';
import 'package:alias_pro/rewards/domain/usecases/update_coins_usecase.dart';
import 'package:alias_pro/rewards/domain/usecases/get_coins_state_usecase.dart';
import 'package:alias_pro/utils/dependency_injection/di.dart';
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
