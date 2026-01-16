import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pre_game_event.dart';

part 'pre_game_state.dart';

class PreGameBloc extends Bloc<PreGameEvent, PreGameState> {
  PreGameBloc({required this.getWordPacks, required this.getWordsByPack})
    : super(PreGameState.initial()) {
    on<ChangeGameModeEvent>(_changeGameMode);
    on<AddTeamsEvent>(_addTeams);
  }

  final GetWordPacksUseCase getWordPacks;
  final GetWordsByPackUseCase getWordsByPack;

  void _changeGameMode(ChangeGameModeEvent event, Emitter<PreGameState> emit) {
    if (state.gameMode == event.gameMode) return;
    emit(state.copyWith(gameMode: event.gameMode));
  }

  void _addTeams(AddTeamsEvent event, Emitter<PreGameState> emit) =>
      emit(state.copyWith(teamNames: event.teamNames));
}
