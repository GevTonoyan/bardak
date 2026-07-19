import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/are_spy_packs_cached_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/download_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/draw_spy_secret_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_fallback_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpyPacksBloc extends Bloc<SpyPacksEvent, SpyPacksState> {
  SpyPacksBloc({
    required this._getSpyPacksUseCase,
    required this._getFallbackSpyPacksUseCase,
    required this._areSpyPacksCachedUseCase,
    required this._downloadSpyPacksUseCase,
    required this._drawSpySecretUseCase,
    required this._getSpySettingsUseCase,
  }) : super(const SpyPacksInitial()) {
    on<SyncSpyPacks>(_onSyncSpyPacks, transformer: droppable());
    on<LoadSpyPacks>(_onLoadSpyPacks, transformer: restartable());
    on<DownloadSpyPacks>(_onDownloadSpyPacks, transformer: droppable());
    on<StartSpyGame>(_onStartSpyGame, transformer: droppable());
  }

  final GetSpyPacksUseCase _getSpyPacksUseCase;
  final GetFallbackSpyPacksUseCase _getFallbackSpyPacksUseCase;
  final AreSpyPacksCachedUseCase _areSpyPacksCachedUseCase;
  final DownloadSpyPacksUseCase _downloadSpyPacksUseCase;
  final DrawSpySecretUseCase _drawSpySecretUseCase;
  final GetSpySettingsUseCase _getSpySettingsUseCase;

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

      if (areCached) {
        emit(SpyPacksLoaded(packs: await _getSpyPacksUseCase(event.locale)));
      } else {
        emit(
          SpyPacksNotCached(
            fallbackPacks: _getFallbackSpyPacksUseCase(event.locale),
          ),
        );
      }
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to load spy packs',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        SpyPacksNotCached(
          fallbackPacks: _getFallbackSpyPacksUseCase(event.locale),
        ),
      );
    }
  }

  Future<void> _onDownloadSpyPacks(
    DownloadSpyPacks event,
    Emitter<SpyPacksState> emit,
  ) async {
    try {
      await _downloadSpyPacksUseCase(event.locale);
      add(LoadSpyPacks(event.locale));
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to download spy packs',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        SpyPacksNotCached(
          fallbackPacks: _getFallbackSpyPacksUseCase(event.locale),
        ),
      );
    }
  }

  Future<void> _onStartSpyGame(
    StartSpyGame event,
    Emitter<SpyPacksState> emit,
  ) async {
    try {
      final settings = _getSpySettingsUseCase();
      final secretWord = await _drawSpySecretUseCase(
        DrawSpySecretParams(localeCode: event.locale, pack: event.pack),
      );

      final session = SpySessionEntity.create(
        pack: event.pack,
        secretWord: secretWord,
        playerCount: settings.playerCount,
        spyCount: settings.spyCount,
        roundDuration: settings.roundDuration,
      );

      final packs = switch (state) {
        SpyPacksLoaded(:final packs) => packs,
        SpyGameReady(:final packs) => packs,
        _ => <SpyPackEntity>[],
      };

      emit(SpyGameReady(packs: packs, session: session));
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to start spy game',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
