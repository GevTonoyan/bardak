import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_room_remote_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/repositories/sea_battle_room_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/create_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/join_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// The Realtime Database online games are played through. Not a secret:
/// the database rules decide who may read and write.
const _databaseUrl =
    'https://boardify-74b99-default-rtdb.europe-west1.firebasedatabase.app';

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
    ..registerLazySingleton<SeaBattleRoomRepository>(
      () => SeaBattleRoomRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<SeaBattleRoomRemoteDataSource>(
      () => SeaBattleRoomRemoteDataSourceImpl(
        database: FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: _databaseUrl,
        ),
        auth: FirebaseAuth.instance,
      ),
    );
}
