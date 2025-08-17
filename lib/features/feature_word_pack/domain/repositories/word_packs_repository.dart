import 'dart:async';

import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_agame_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/presentation/ui/alias_settings_screen.dart';
import 'package:boardify/features/feature_gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:boardify/features/feature_main/data/repositories/alias_main_repository_impl.dart';
import 'package:boardify/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:boardify/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:boardify/features/feature_word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/features/feature_word_pack/domain/repositories/word_packs_repository.dart';
import 'package:boardify/features/feature_word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/features/feature_word_pack/domain/usecases/set_selected_word_pack_usecase.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract repository to handle word pack data operations.
abstract interface class WordPacksRepository {
  /// Gets cached word packs for the given locale.
  Future<AliasWordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Persists the selected word pack for the given locale.
  Future<void> setSelectedWordPack(SetSelectedWordPackParams params);
}
