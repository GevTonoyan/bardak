import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
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
import 'package:boardify/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
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

/// Handles caching and reading data locally using Hive.
abstract interface class AliasMainLocalDataSource {
  /// Saves all word packs for a given locale to Hive.
  Future<void> cacheWordPacks(String localeCode, List<AliasWordPackEntity> packs);

  /// Checks if word packs are already cached in Hive for a given locale.
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params);

  /// Returns the name of the currently selected word pack.
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params);
}

/// Implementation of [AliasMainLocalDataSource] using Hive for local storage.
class AliasMainLocalDataSourceImpl implements AliasMainLocalDataSource {
  final SharedPreferences preferences;

  const AliasMainLocalDataSourceImpl({required this.preferences});

  @override
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params) async {
    final boxName = '${AliasConstants.aliasWordPack}_${params.localeCode}';

    if (!Hive.isBoxOpen(boxName)) {
      final exists = await Hive.boxExists(boxName);
      if (!exists) return false;

      await Hive.openBox(boxName);
    }

    final box = Hive.box(boxName);
    return box.isNotEmpty;
  }

  @override
  Future<void> cacheWordPacks(String localeCode, List<AliasWordPackEntity> packs) async {
    final box = await Hive.openBox('${AliasConstants.aliasWordPack}_$localeCode');

    // We are keeping the locale code as the key for the box
    // and the word packs as the value.
    // e.g. en_movies: {name:Movies, words: [word1, word2]}
    for (final pack in packs) {
      final key = pack.id;
      await box.put(key, <String, dynamic>{
        AliasConstants.aliasWordPackName: pack.name,
        AliasConstants.aliasWordPackEmoji: pack.emoji,
        AliasConstants.aliasWordPackWords: pack.words,
      });
    }
  }

  @override
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params) async {
    var selectedPackId = preferences.getString(
      '${AliasConstants.aliasSelectedWordPackKey}_${params.localeCode}',
    );

    selectedPackId ??= 'all';

    final boxName = '${AliasConstants.aliasWordPack}_${params.localeCode}';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    final box = Hive.box(boxName);

    final packData = box.get(selectedPackId);

    if (packData is Map) {
      return packData[AliasConstants.aliasWordPackName] as String? ?? 'All';
    }

    return 'All';
  }
}
