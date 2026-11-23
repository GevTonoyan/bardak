import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_remote_opponent_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_room_remote_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/repositories/sea_battle_remote_opponent_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/repositories/sea_battle_room_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/create_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/join_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/mark_sea_battle_room_ready_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/start_sea_battle_room_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// The Realtime Database online games are played through. Not a secret:
/// the database rules decide who may read and write.
const _databaseUrl =
    'https://boardify-74b99-default-rtdb.europe-west1.firebasedatabase.app';

/// The same instance on every call: Firebase keeps one per database URL.
FirebaseDatabase get _database => FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: _databaseUrl,
);

/// Name the online opponent is registered under, next to the bot (the
/// unnamed [SeaBattleOpponentRepository]).
const onlineOpponentName = 'online';

void injectSeaBattleOnlineScope() {
  if (sl.isRegistered<CreateSeaBattleRoomUseCase>()) return;

  sl
    ..registerLazySingleton<CreateSeaBattleRoomUseCase>(
      () => CreateSeaBattleRoomUseCase(sl()),
    )
    ..registerLazySingleton<JoinSeaBattleRoomUseCase>(
      () => JoinSeaBattleRoomUseCase(sl()),
    )
    ..registerLazySingleton<WatchSeaBattleRoomUseCase>(
      () => WatchSeaBattleRoomUseCase(sl()),
    )
    ..registerLazySingleton<LeaveSeaBattleRoomUseCase>(
      () => LeaveSeaBattleRoomUseCase(sl()),
    )
    ..registerLazySingleton<MarkSeaBattleRoomReadyUseCase>(
      () => MarkSeaBattleRoomReadyUseCase(sl()),
    )
    ..registerLazySingleton<StartSeaBattleRoomBattleUseCase>(
      () => StartSeaBattleRoomBattleUseCase(sl()),
    )
    // A new opponent for every battle: it counts that battle's shots.
    ..registerFactoryParam<SeaBattleOpponentRepository, String, FleetEntity>(
      (code, playerFleet) => SeaBattleRemoteOpponentRepositoryImpl(
        code: code,
        playerFleet: playerFleet,
        remoteDataSource: sl(),
      ),
      instanceName: onlineOpponentName,
    )
    ..registerLazySingleton<SeaBattleRoomRepository>(
      () => SeaBattleRoomRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<SeaBattleRemoteOpponentDataSource>(
      () => SeaBattleRemoteOpponentDataSourceImpl(
        database: _database,
        auth: FirebaseAuth.instance,
      ),
    )
    ..registerLazySingleton<SeaBattleRoomRemoteDataSource>(
      () => SeaBattleRoomRemoteDataSourceImpl(
        database: _database,
        auth: FirebaseAuth.instance,
      ),
    );
}
