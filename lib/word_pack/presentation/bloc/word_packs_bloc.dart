import 'dart:async';

import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:alias_pro/utils/remote_config/remote_config.dart';
import 'package:alias_pro/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias_pro/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_version_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_packs_event.dart';

part 'word_packs_state.dart';

class WordPacksBloc extends Bloc<WordPacksEvent, WordPacksState> {
  WordPacksBloc({
    required this.areWordPacksCached,
    required this.fetchAndCacheWordPacks,
    required this.getWordsVersion,
    required this.getWordPacks,
  }) : super(const WordPacksInitial()) {
    on<CacheWordPacksIfNeeded>(_cacheWordPacksIfNeeded);
    on<LoadWordPacks>(_onLoadWordPacks);
    on<FetchAndCachePacks>(_fetchAndCachePacks);
  }

  final GetWordPacksUseCase getWordPacks;
  final ArePacksCachedUseCase areWordPacksCached;
  final FetchAndCacheWordPacksUseCase fetchAndCacheWordPacks;
  final GetWordsVersionUseCase getWordsVersion;

  Future<void> _cacheWordPacksIfNeeded(
    CacheWordPacksIfNeeded event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      for (final appLocale in AppLocales.values) {
        final locale = appLocale.locale.languageCode;

        final areCached = await areWordPacksCached(
          AreWordPacksCachedParams(localeCode: locale),
        );
        print('------------------ $locale cached = $areCached');
        if (!areCached) {
          await fetchAndCacheWordPacks(
            FetchAndCacheWordPacksParams(localeCode: locale),
          );
        }
      }

      //unawaited(_checkForWordsUpdate(locale));
    } on Exception catch (error) {}
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
            locale: event.locale,
          ),
        );
      }
    } on Exception catch (e) {
      emit(WordPacksError(e.toString()));
    }
  }

  Future<void> _checkForWordsUpdate(String locale) async {
    final currentVersion = getWordsVersion(
      params: GetWordsVersionParams(localeCode: locale),
    );
    final remoteVersion = AppRemoteConfig.instance!.getWordsVersion(locale);
    if (currentVersion == remoteVersion) return;

    await fetchAndCacheWordPacks(
      FetchAndCacheWordPacksParams(localeCode: locale),
    );
  }

  FutureOr<void> _fetchAndCachePacks(
    FetchAndCachePacks event,
    Emitter<WordPacksState> emit,
  ) async {
    await fetchAndCacheWordPacks(
      FetchAndCacheWordPacksParams(localeCode: event.locale),
    );
    add(LoadWordPacks(event.locale));
  }
}
