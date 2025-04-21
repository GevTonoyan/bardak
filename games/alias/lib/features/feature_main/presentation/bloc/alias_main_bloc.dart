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

  FutureOr<void> _onCheckAndCacheAliasWords(
    CheckAndCacheAliasWords event,
    Emitter<AliasMainState> emit,
  ) async {
    try {
      final areCached = await areWordPacksCached(AreWordPacksCachedParams(localeCode: 'en'));
      if (!areCached) {
        await fetchAndCacheWordPacks(const FetchAndCacheWordPacksParams(localeCode: 'en'));
      }
    } on Exception catch (e) {
      // Todo error handling
      print('Error fetching word packs: $e');
    }
    emit(AliasMainLoaded());
  }
}
