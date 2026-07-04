import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/are_spy_packs_cached_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/download_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpyPacksBloc extends Bloc<SpyPacksEvent, SpyPacksState> {
  SpyPacksBloc({
    required this._getSpyPacksUseCase,
    required this._areSpyPacksCachedUseCase,
    required this._downloadSpyPacksUseCase,
  }) : super(const SpyPacksInitial()) {
    on<SyncSpyPacks>(_onSyncSpyPacks, transformer: droppable());
    on<LoadSpyPacks>(_onLoadSpyPacks, transformer: restartable());
  }

  final GetSpyPacksUseCase _getSpyPacksUseCase;
  final AreSpyPacksCachedUseCase _areSpyPacksCachedUseCase;
  final DownloadSpyPacksUseCase _downloadSpyPacksUseCase;

  Future<void> _onSyncSpyPacks(
    SyncSpyPacks event,
    Emitter<SpyPacksState> emit,
  ) async {
    for (final appLocale in AppLocale.values) {
      final locale = appLocale.locale.languageCode;

      try {
        final areCached = await _areSpyPacksCachedUseCase(locale);
        if (!areCached) await _downloadSpyPacksUseCase(locale);
      } on Exception catch (error, stackTrace) {
        logger.error(
          'Failed to sync spy packs for $locale',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _onLoadSpyPacks(
    LoadSpyPacks event,
    Emitter<SpyPacksState> emit,
  ) async {
    try {
      final areCached = await _areSpyPacksCachedUseCase(event.locale);
      if (!areCached) {
        try {
          await _downloadSpyPacksUseCase(event.locale);
        } on Exception catch (error, stackTrace) {
          // The repository serves bundled fallback packs when the cache
          // is empty, so a failed download is not fatal.
          logger.error(
            'Failed to download spy packs, serving fallbacks',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      emit(SpyPacksLoaded(packs: await _getSpyPacksUseCase(event.locale)));
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to load spy packs',
        error: error,
        stackTrace: stackTrace,
      );
      emit(const SpyPacksFailure());
    }
  }
}
