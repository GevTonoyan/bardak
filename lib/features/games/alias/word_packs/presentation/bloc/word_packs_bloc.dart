import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/download_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_fallback_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_event.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordPacksBloc extends Bloc<WordPacksEvent, WordPacksState> {
  WordPacksBloc({
    required this._getWordPacksUseCase,
    required this._getFallbackWordPacksUseCase,
    required this._areWordPacksCachedUseCase,
    required this._downloadWordPacksUseCase,
  }) : super(const WordPacksInitial()) {
    on<SyncWordPacks>(_onSyncWordPacks, transformer: droppable());
    on<LoadWordPacks>(_onLoadWordPacks, transformer: restartable());
    on<DownloadWordPacks>(_onDownloadWordPacks, transformer: droppable());
  }

  final GetWordPacksUseCase _getWordPacksUseCase;
  final GetFallbackWordPacksUseCase _getFallbackWordPacksUseCase;
  final AreWordPacksCachedUseCase _areWordPacksCachedUseCase;
  final DownloadWordPacksUseCase _downloadWordPacksUseCase;

  Future<void> _onSyncWordPacks(
    SyncWordPacks event,
    Emitter<WordPacksState> emit,
  ) async {
    for (final appLocale in AppLocale.values) {
      final locale = appLocale.locale.languageCode;

      try {
        final areCached = await _areWordPacksCachedUseCase(locale);
        if (!areCached) await _downloadWordPacksUseCase(locale);
      } on Exception catch (error, stackTrace) {
        logger.error(
          'Failed to sync word packs for $locale',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _onLoadWordPacks(
    LoadWordPacks event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      final areCached = await _areWordPacksCachedUseCase(event.locale);

      if (areCached) {
        final packs = await _getWordPacksUseCase(event.locale);
        emit(WordPacksLoaded(packs: packs));
      } else {
        emit(
          WordPacksNotCached(
            fallbackPacks: _getFallbackWordPacksUseCase(event.locale),
          ),
        );
      }
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to load word packs',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        WordPacksNotCached(
          fallbackPacks: _getFallbackWordPacksUseCase(event.locale),
        ),
      );
    }
  }

  Future<void> _onDownloadWordPacks(
    DownloadWordPacks event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      await _downloadWordPacksUseCase(event.locale);
      add(LoadWordPacks(event.locale));
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to download word packs',
        error: error,
        stackTrace: stackTrace,
      );
      // A new attempt count makes this a distinct state even when the
      // fallback packs are unchanged, so the screen re-shows the notification.
      final currentState = state;
      final attempt =
          currentState is WordPacksNotCached ? currentState.attempt + 1 : 0;
      emit(
        WordPacksNotCached(
          fallbackPacks: _getFallbackWordPacksUseCase(event.locale),
          attempt: attempt,
        ),
      );
    }
  }
}
