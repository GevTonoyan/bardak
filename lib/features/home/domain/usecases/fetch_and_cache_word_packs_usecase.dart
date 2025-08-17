import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:boardify/features/gameplay/presentation/bloc/blocs/gameplay_bloc/gameplay_bloc.dart';
import 'package:boardify/features/gameplay/presentation/ui/card_round_screen.dart';
import 'package:boardify/features/gameplay/presentation/ui/countdown_screen.dart';
import 'package:boardify/features/gameplay/presentation/ui/gameplay_screen.dart';
import 'package:boardify/features/gameplay/presentation/ui/round_overview_screen.dart';
import 'package:boardify/features/home/data/data_sources/home_local_data_source.dart';
import 'package:boardify/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:boardify/features/home/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/home/domain/repositories/home_repository.dart';
import 'package:boardify/features/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/home/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/features/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/features/pre_game/domain/entities/alias_pre_game_config.dart';
import 'package:boardify/features/pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/word_pack/presentation/ui/alias_word_packs_screen.dart';
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

/// Fetches all word packs from Firestore for a given locale and stores them in Hive.
class FetchAndCacheWordPacksUseCase {
  final HomeRepository repository;

  FetchAndCacheWordPacksUseCase(this.repository);

  Future<void> call(FetchAndCacheWordPacksParams params) async {
    await repository.fetchAndCacheWordPacks(params);
  }
}

/// Parameters for fetching and caching word packs.
class FetchAndCacheWordPacksParams {
  final String localeCode;

  const FetchAndCacheWordPacksParams({required this.localeCode});
}
