import 'package:alias/features/feature_play/domain/entities/alias_game_state_entity.dart';
import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alias_play_event.dart';

part 'alias_play_state.dart';

class AliasPlayBloc extends Bloc<AliasPlayEvent, AliasPlayState> {
  AliasPlayBloc({
    required AliasGameMode gameMode,
    required List<String> teamNames,
    required int roundDuration,
    required int pointsToWin,
    required int wordsPerCard,
    required bool soundEnabled,
    required bool allowSkipping,
    required bool penaltyForSkipping,
  }) : super(
         AliasPlayLoaded(
           AliasGameStateEntity(
             teamStates:
                 teamNames
                     .map((name) => AliasTeamStateEntity(name: name, roundScores: []))
                     .toList(),
             gameMode: gameMode,
             soundEnabled: soundEnabled,
             roundDuration: roundDuration,
             pointsToWin: pointsToWin,
             wordsPerCard: wordsPerCard,
             allowSkipping: allowSkipping,
             penaltyForSkipping: penaltyForSkipping,
             currentTeamIndex: 0,
             currentRoundIndex: 0,
           ),
         ),
       );
}
