import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/alias_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/presentation/ui/alias_settings_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AliasGameStateEntity {
  AliasGameStateEntity({
    required this.gameMode,
    required this.teamStates,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.currentTeamIndex,
    required this.currentRoundIndex,
    this.isGameFinished = false,
    this.winningTeamIndex,
  });

  final AliasGameMode gameMode;

  /// Ordered list of team states including score history
  final List<AliasTeamStateEntity> teamStates;

  /// Round settings
  final int roundDuration;
  final int pointsToWin;
  final int wordsPerCard;

  /// Rules
  final bool allowSkipping;
  final bool penaltyForSkipping;

  final bool soundEnabled;

  /// Runtime flow
  final int currentTeamIndex;
  final int currentRoundIndex;

  /// Game end state
  final bool isGameFinished;
  final int? winningTeamIndex;
}

class AliasTeamStateEntity {
  AliasTeamStateEntity({required this.name, required this.roundScores});

  final String name;

  /// Score for each round (index matches round number)
  final List<int> roundScores;

  int get totalScore => roundScores.fold(0, (sum, score) => sum + score);
}
