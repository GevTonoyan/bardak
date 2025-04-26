import 'package:alias/features/feature_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:alias/features/feature_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:alias/features/feature_settings/domain/repositories/alias_settings_repository.dart';
import 'package:alias/features/feature_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> injectAliasPreGameScope() async {
  if (sl.isRegistered<AliasSettingsRepository>()) {
    return;
  }
}
