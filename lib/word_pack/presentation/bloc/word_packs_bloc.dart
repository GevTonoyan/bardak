import 'dart:async';

import 'package:boardify/utils/constants/constants.dart';
import 'package:boardify/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/word_pack/domain/usecases/get_word_packs_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_packs_event.dart';

part 'word_packs_state.dart';

class WordPacksBloc extends Bloc<WordPacksEvent, WordPacksState> {
  WordPacksBloc({required this.getWordPacks}) : super(WordPacksInitial()) {
    on<LoadWordPacks>(_onLoadWordPacks);
    on<SelectWordPack>(_onSelectWordPack);
  }

  final GetWordPacksUseCase getWordPacks;

  Future<void> _onLoadWordPacks(
    LoadWordPacks event,
    Emitter<WordPacksState> emit,
  ) async {
    try {
      final result = await getWordPacks(
        GetWordPacksParams(localeCode: event.localeCode),
      );
      emit(
        WordPacksLoaded(
          packs: result.packs,
          selectedPackId: AppConstants.defaultPackId,
        ),
      );
    } on Exception catch (e) {
      emit(WordPacksError(e.toString()));
    }
  }

  void _onSelectWordPack(SelectWordPack event, Emitter<WordPacksState> emit) {
    if (state is WordPacksLoaded) {
      final currentState = state as WordPacksLoaded;
      emit(currentState.copyWith(selectedPackId: event.packId));
    }
  }
}
