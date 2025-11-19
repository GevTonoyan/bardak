import 'package:firebase_remote_config/firebase_remote_config.dart';

final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

const _amWordsKey = 'words_version_am';
const _ruWordsKey = 'words_version_ru';
const _enWordsKey = 'words_version_en';

class AliasRemoteConfig {
  AliasRemoteConfig._(this._remoteConfig);

  static AliasRemoteConfig? instance;

  final FirebaseRemoteConfig _remoteConfig;

  static Future<AliasRemoteConfig> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(days: 1),
      ),
    );

    await remoteConfig.fetchAndActivate();

    instance = AliasRemoteConfig._(remoteConfig);
    return instance!;
  }

  int get amWordsVersion => _remoteConfig.getInt(_amWordsKey);

  int get ruWordsVersion => _remoteConfig.getInt(_ruWordsKey);

  int get enWordsVersion => _remoteConfig.getInt(_enWordsKey);
}
