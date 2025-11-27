import 'dart:async';

import 'package:boardify/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/home/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/home/domain/usecases/get_words_version_usecase.dart';
import 'package:boardify/utils/remote_config/remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.fetchAndCacheWordPacks,
    required this.areWordPacksCached,
    required this.getSelectedWordPackName,
    required this.getWordsVersion,
  }) : super(const HomeStateInitial()) {
    on<InitializeAliasHomeEvent>(_onInitializeAliasHomeEvent);
    on<GetSelectedWordPackNameEvent>(_onGetSelectedWordPackName);
  }

  final AreWordPacksCachedUseCase areWordPacksCached;
  final FetchAndCacheWordPacksUseCase fetchAndCacheWordPacks;
  final GetSelectedWordPackNameUseCase getSelectedWordPackName;
  final GetWordsVersionUseCase getWordsVersion;

  Future<void> _onInitializeAliasHomeEvent(
    InitializeAliasHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeStateLoading());

    try {
      final areCached = await areWordPacksCached(
        AreWordPacksCachedParams(localeCode: event.locale),
      );
      if (!areCached) {
        await fetchAndCacheWordPacks(
          FetchAndCacheWordPacksParams(localeCode: event.locale),
        );
      }
      final selectedWordPackName = await getSelectedWordPackName(
        params: GetSelectedWordPackNameParams(localeCode: event.locale),
      );
      emit(HomeStateLoaded(selectedWordPackName: selectedWordPackName));
      //unawaited(_checkForWordsUpdate(event.locale));
    } on Exception catch (error) {
      emit(HomeStateError(message: error.toString()));
    }
  }

  Future<void> _onGetSelectedWordPackName(
    GetSelectedWordPackNameEvent event,
    Emitter<HomeState> emit,
  ) async {
    final selectedWordPackName = await getSelectedWordPackName(
      params: GetSelectedWordPackNameParams(localeCode: event.locale),
    );
    emit(HomeStateLoaded(selectedWordPackName: selectedWordPackName));
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
}
