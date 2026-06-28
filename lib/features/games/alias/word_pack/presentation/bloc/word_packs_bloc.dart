import 'dart:async';

import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:bardak/features/games/alias/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:bardak/features/games/alias/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_packs_event.dart';

part 'word_packs_state.dart';

class WordPacksBloc extends Bloc<WordPacksEvent, WordPacksState> {
  WordPacksBloc({
    required this.areWordPacksCached,
    required this.fetchAndCacheWordPacks,
    required this.getWordPacks,
  }) : super(const WordPacksInitial()) {
    on<CacheWordPacksIfNeeded>(_cacheWordPacksIfNeeded);
    on<LoadWordPacks>(_onLoadWordPacks);
    on<FetchAndCachePacks>(_fetchAndCachePacks);
  }

  final GetWordPacksUseCase getWordPacks;
  final ArePacksCachedUseCase areWordPacksCached;
  final FetchAndCacheWordPacksUseCase fetchAndCacheWordPacks;

  Future<void> _cacheWordPacksIfNeeded(
    CacheWordPacksIfNeeded event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      for (final appLocale in AppLocale.values) {
        final locale = appLocale.locale.languageCode;

        final areCached = await areWordPacksCached(
          AreWordPacksCachedParams(localeCode: locale),
        );
        if (!areCached) {
          await fetchAndCacheWordPacks(
            FetchAndCacheWordPacksParams(localeCode: locale),
          );
        }
      }
    } on Exception catch (_) {}
  }

  Future<void> _onLoadWordPacks(
    LoadWordPacks event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      final areCached = await areWordPacksCached(
        AreWordPacksCachedParams(localeCode: event.locale),
      );

      if (areCached) {
        final result = await getWordPacks(
          GetWordPacksParams(localeCode: event.locale),
        );
        emit(
          WordPacksLoaded(packs: result.packs, locale: event.locale),
        );
      } else {
        emit(
          WordPacksNotCached(
            fallbackPacks: WordPackInfoResultEntity.fallback(
              event.locale,
            ).packs,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        WordPacksNotCached(
          fallbackPacks: WordPackInfoResultEntity.fallback(
            event.locale,
          ).packs,
        ),
      );
    }
  }

  FutureOr<void> _fetchAndCachePacks(
    FetchAndCachePacks event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      await fetchAndCacheWordPacks(
        FetchAndCacheWordPacksParams(localeCode: event.locale),
      );
      add(LoadWordPacks(event.locale));
    } on Exception catch (e) {
      emit(
        WordPacksNotCached(
          fallbackPacks: WordPackInfoResultEntity.fallback(
            event.locale,
          ).packs,
          error: e.toString(),
        ),
      );
    }
  }
}
