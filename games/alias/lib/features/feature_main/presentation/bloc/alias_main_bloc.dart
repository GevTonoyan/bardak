import 'dart:async';

import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alias_main_event.dart';

part 'alias_main_state.dart';

class AliasMainBloc extends Bloc<AliasMainEvent, AliasMainState> {
  final AreWordPacksCachedUseCase areWordPacksCached;
  final FetchAndCacheWordPacksUseCase fetchAndCacheWordPacks;
  final GetSelectedWordPackNameUseCase getSelectedWordPackName;

  AliasMainBloc({
    required this.fetchAndCacheWordPacks,
    required this.areWordPacksCached,
    required this.getSelectedWordPackName,
  }) : super(AliasMainInitial()) {
    on<InitializeAliasMainEvent>(_onInitializeAliasMainEvent);
    on<GetSelectedWordPackNameEvent>(_onGetSelectedWordPackName);
  }

  Future<void> _onInitializeAliasMainEvent(
    InitializeAliasMainEvent event,
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
      final selectedWordPackName = await getSelectedWordPackName(
        params: GetSelectedWordPackNameParams(localeCode: event.locale),
      );
      emit(AliasMainLoaded(selectedWordPackName: selectedWordPackName));
    } on Exception catch (error) {
      emit(AliasMainError(message: error.toString()));
    }
  }

  Future<void> _onGetSelectedWordPackName(
    GetSelectedWordPackNameEvent event,
    Emitter<AliasMainState> emit,
  ) async {
    final selectedWordPackName = await getSelectedWordPackName(
      params: GetSelectedWordPackNameParams(localeCode: event.locale),
    );
    emit(AliasMainLoaded(selectedWordPackName: selectedWordPackName));
  }
}
