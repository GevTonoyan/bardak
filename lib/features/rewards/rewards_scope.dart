import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:bardak/features/rewards/data/repositories/rewards_repository_impl.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:bardak/features/rewards/domain/usecases/get_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/update_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/watch_coin_balance_usecase.dart';

void injectRewardsScope() {
  if (sl.isRegistered<RewardsRepository>()) return;

  sl
    ..registerLazySingleton<GetCoinBalanceUseCase>(
      () => GetCoinBalanceUseCase(sl()),
    )
    ..registerLazySingleton<UpdateCoinBalanceUseCase>(
      () => UpdateCoinBalanceUseCase(sl()),
    )
    ..registerLazySingleton<WatchCoinBalanceUseCase>(
      () => WatchCoinBalanceUseCase(sl()),
    )
    ..registerLazySingleton<RewardsRepository>(
      () => RewardsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<RewardsLocalDataSource>(
      () => RewardsLocalDataSourceImpl(preferences: sl()),
    );
}
