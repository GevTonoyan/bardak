import 'dart:async';

import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alias_main_event.dart';

part 'alias_main_state.dart';

class AliasMainBloc extends Bloc<AliasMainEvent, AliasMainState> {
  final AreWordPacksCachedUseCase areWordPacksCached;
  final FetchAndCacheWordPacksUseCase fetchAndCacheWordPacks;

  AliasMainBloc({required this.fetchAndCacheWordPacks, required this.areWordPacksCached})
    : super(AliasMainLoaded()) {
    on<CheckAndCacheAliasWords>(_onCheckAndCacheAliasWords);
  }

  Future<void> _onCheckAndCacheAliasWords(
    CheckAndCacheAliasWords event,
    Emitter<AliasMainState> emit,
  ) async {
    emit(const AliasMainLoading());

    try {
      final areCached = await areWordPacksCached(
        AreWordPacksCachedParams(localeCode: event.locale),
      );
      if (!areCached) {
        await fetchAndCacheWordPacks(FetchAndCacheWordPacksParams(localeCode: event.locale));
      }
      emit(const AliasMainLoaded());
    } on Exception catch (error) {
      emit(AliasMainError(message: error.toString()));
    }
  }
}
