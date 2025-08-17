import 'dart:async';

import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
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


final sl = GetIt.instance;

Future<void> injectAliasPreGameScope() async {
  if (sl.isRegistered<SettingsRepository>()) {
    return;
  }
}
