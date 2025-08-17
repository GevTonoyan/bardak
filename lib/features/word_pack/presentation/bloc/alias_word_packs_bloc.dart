import 'dart:async';

import 'package:boardify/features/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/features/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/features/word_pack/domain/usecases/set_selected_word_pack_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'alias_word_packs_event.dart';

part 'alias_word_packs_state.dart';

class AliasWordPacksBloc extends Bloc<AliasWordPacksEvent, AliasWordPacksState> {
  final GetWordPacksUseCase getWordPacks;
  final SetSelectedWordPackUseCase setSelectedWordPack;

  AliasWordPacksBloc({required this.getWordPacks, required this.setSelectedWordPack})
    : super(AliasWordPacksInitial()) {
    on<LoadWordPacks>(_onLoadWordPacks);
    on<SelectWordPack>(_onSelectWordPack);
  }

  Future<void> _onLoadWordPacks(LoadWordPacks event, Emitter<AliasWordPacksState> emit) async {
    try {
      final result = await getWordPacks(GetWordPacksParams(localeCode: event.localeCode));
      emit(AliasWordPacksLoaded(packs: result.packs, selectedPackId: result.selectedPackId));
    } on Exception catch (e) {
      emit(AliasWordPacksError(e.toString()));
    }
  }

  void _onSelectWordPack(SelectWordPack event, Emitter<AliasWordPacksState> emit) {
    if (state is AliasWordPacksLoaded) {
      final currentState = state as AliasWordPacksLoaded;
      emit(currentState.copyWith(selectedPackId: event.packId));
    }

    setSelectedWordPack(
      SetSelectedWordPackParams(packId: event.packId, localeCode: event.localeCode),
    );
  }
}
